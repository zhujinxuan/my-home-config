{
  config,
  pkgs,
  per-directory-history,
  ...
}:
let
  # RustFS lives on the NAS (192.168.110.147) and this Mac always shares its
  # LAN, so traffic goes direct — no frpc/VPS relay for the mount anymore.
  # One macOS catch: Local Network Privacy blocks unsigned nix-store binaries
  # (rclone) from dialing RFC1918 hosts, while Apple-signed binaries
  # (/usr/bin/ssh) are exempt and loopback is exempt. So ssh forwards
  # 127.0.0.1:19000 -> NAS RustFS :9000 and rclone stays on loopback.
  # NAS ssh auth is pubkey-only with ~/.ssh/id_ed25519 — authorize once with:
  #   ssh-copy-id -i ~/.ssh/id_ed25519.pub ugnasjz@192.168.110.147
  # Console over LAN: http://192.168.110.147:9001 (grant the browser Local
  # Network access if prompted). frpc's rustfs visitors are now unused.
  rustfsNasHost = "192.168.110.147";
  rustfsNasUser = "ugnasjz";
  # 19000, not 9000: frpc's rustfs visitor still binds 127.0.0.1:9000
  rustfsTunnelPort = 19000;
  rustfsEndpoint = "http://127.0.0.1:${toString rustfsTunnelPort}";
  rustfsBucket = "ugnas-shared";
  rustfsRootDir = "rclone-mount-to-disk";
  # Decrypted at activation by sops-nix (darwin/sops.nix).
  rustfsAccessKeyFile = "/Users/jinxuanzhu/.config/rustfs/access_key";
  rustfsSecretKeyFile = "/Users/jinxuanzhu/.config/rustfs/secret_key";
  rustfsMountPoint = "${config.home.homeDirectory}/rustfs-mounted";
  rcloneBin = "${pkgs.rclone}/bin/rclone";

  # The rclone remote "rustfs" is defined entirely through RCLONE_CONFIG_*
  # env vars below, so no credentials ever sit in a config file.
  # FUSE backend is FUSE-T (brew cask, kext-less; macFUSE 4.8 predates
  # macOS 26 and its kext refuses to load). rclone itself is nix-managed.
  rustfsMount = pkgs.writeShellScript "rustfs-mount" ''
    set -eu
    # wait for FUSE-T instead of thrashing until `brew install --cask fuse-t`
    # (macFUSE also ships libfuse.2.dylib, so that is not a valid marker)
    if [ ! -d "/Library/Application Support/FUSE-T" ]; then
      echo "FUSE-T not installed yet (brew install --cask fuse-t); retrying in 60s"
      sleep 60
      exit 1
    fi
    mkdir -p "${rustfsMountPoint}"
    # clear a stale mount left by a previous run before remounting
    /sbin/umount "${rustfsMountPoint}" 2>/dev/null || true

    # ssh carries the LAN hop because Apple-signed binaries are exempt from
    # Local Network Privacy while the unsigned nix rclone is not (see the
    # comment on rustfsEndpoint). Kill any tunnel left by a previous run.
    mkdir -p "$HOME/.cache"
    pidfile="$HOME/.cache/rustfs-tunnel.pid"
    if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
      kill "$(cat "$pidfile")" 2>/dev/null || true
      sleep 1
    fi
    /usr/bin/ssh -N \
      -o BatchMode=yes -o ExitOnForwardFailure=yes \
      -o ServerAliveInterval=15 -o ServerAliveCountMax=3 \
      -o IdentitiesOnly=yes -o IdentityFile="$HOME/.ssh/id_ed25519" \
      -L 127.0.0.1:${toString rustfsTunnelPort}:127.0.0.1:9000 \
      "${rustfsNasUser}@${rustfsNasHost}" &
    echo $! > "$pidfile"
    trap 'p=$(cat "$pidfile" 2>/dev/null || true); [ -n "$p" ] && kill "$p" 2>/dev/null || true' EXIT

    # wait for the forward to accept connections (NAS awake, key authorized)
    ready=0
    for _ in $(seq 1 15); do
      if (exec 3<>"/dev/tcp/127.0.0.1/${toString rustfsTunnelPort}") 2>/dev/null; then
        ready=1
        break
      fi
      sleep 1
    done
    if [ "$ready" != 1 ]; then
      echo "ssh forward to ${rustfsNasHost}:9000 never came up; NAS asleep or key not authorized?" >&2
      echo "authorize once: ssh-copy-id -i ~/.ssh/id_ed25519.pub ${rustfsNasUser}@${rustfsNasHost}" >&2
      exit 1
    fi

    export RCLONE_CONFIG_RUSTFS_TYPE=s3
    export RCLONE_CONFIG_RUSTFS_PROVIDER=Other
    export RCLONE_CONFIG_RUSTFS_ENDPOINT="${rustfsEndpoint}"
    export RCLONE_CONFIG_RUSTFS_ACCESS_KEY_ID="$(< "${rustfsAccessKeyFile}")"
    export RCLONE_CONFIG_RUSTFS_SECRET_ACCESS_KEY="$(< "${rustfsSecretKeyFile}")"
    # self-heal loop: restart rclone after eject/crash without launchd churn;
    # launchd KeepAlive remains the outer safety net for script-level deaths
    while true; do
      ${rcloneBin} mount "rustfs:${rustfsBucket}/${rustfsRootDir}" "${rustfsMountPoint}" \
        --vfs-cache-mode writes \
        -o backend=fskit \
        --log-level INFO || echo "rclone mount exited (rc=$?); remounting in 5s"
      sleep 5
      /sbin/umount "${rustfsMountPoint}" 2>/dev/null || true
    done
  '';
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    unar
    wget
    mariadb
    python3Packages.conda
    python3
    rclone
    uv
  ];

  # RUSTFS_* credentials come from sops (see darwin/sops.nix); read at
  # shell startup in .zshenv so interactive and non-interactive zsh both
  # get them.
  programs.zsh.envExtra = ''
    if [[ -r "$HOME/.config/rustfs/access_key" ]]; then
      export RUSTFS_ACCESS_KEY="$(< "$HOME/.config/rustfs/access_key")"
    fi
    if [[ -r "$HOME/.config/rustfs/secret_key" ]]; then
      export RUSTFS_SECRET_KEY="$(< "$HOME/.config/rustfs/secret_key")"
    fi
  '';

  # Auto-mount the NAS at login and self-heal: KeepAlive restarts rclone
  # after eject, crash, or network outage. Log: ~/Library/Logs/rustfs-nas.log
  launchd.agents.rustfs-nas = {
    enable = true;
    config = {
      ProgramArguments = [ "${rustfsMount}" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/rustfs-nas.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/rustfs-nas.log";
    };
  };
  programs.poetry.enable = true;

  home.username = "jinxuanzhu";
  home.homeDirectory = "/Users/jinxuanzhu";

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-macport;
  };

  programs.zsh.plugins = [
    {
      name = "darwin-zsh";
      file = "darwin.zsh";
      src = ../darwin-zsh;
    }
    {
      name = "common-zsh-config";
      file = "common-zshrc.zsh";
      src = ../zsh-common;
    }
    {
      name = "per-directory-history";
      file = "per-directory-history.zsh";
      src = per-directory-history;
    }
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    stdlib = ''
      use_nvm() {
        local node_version=$1

        nvm_sh=~/.nvm/nvm.sh
        if [[ -e $nvm_sh ]]; then
          source $nvm_sh
          nvm use $node_version
        fi
      }
    '';
  };

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
