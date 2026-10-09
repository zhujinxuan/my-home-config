{
  config,
  pkgs,
  per-directory-history,
  ...
}:
let
  # RustFS S3 API, tunneled to localhost by frpc (visitor "unas-rustfs-v",
  # see ~/.config/frpc/frpc-services.toml); console is on 127.0.0.1:9001.
  rustfsEndpoint = "http://127.0.0.1:9000";
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
    export RCLONE_CONFIG_RUSTFS_TYPE=s3
    export RCLONE_CONFIG_RUSTFS_PROVIDER=Other
    export RCLONE_CONFIG_RUSTFS_ENDPOINT="${rustfsEndpoint}"
    export RCLONE_CONFIG_RUSTFS_ACCESS_KEY_ID="$(< "${rustfsAccessKeyFile}")"
    export RCLONE_CONFIG_RUSTFS_SECRET_ACCESS_KEY="$(< "${rustfsSecretKeyFile}")"
    exec ${rcloneBin} mount "rustfs:${rustfsBucket}/${rustfsRootDir}" "${rustfsMountPoint}" \
      --vfs-cache-mode writes \
      -o backend=fskit \
      --log-level INFO
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
  # after eject, crash, or tunnel outage. Log: ~/Library/Logs/rustfs-nas.log
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
