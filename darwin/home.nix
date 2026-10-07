{
  config,
  pkgs,
  per-directory-history,
  ...
}:
let
  webdavServer = "http://127.0.0.1:5005";
  webdavRemotePath = "/home/mount-to-remote";
  webdavUser = "ugnasjz";
  # Decrypted at activation by sops-nix (darwin/sops.nix).
  webdavPasswordFile = "/Users/jinxuanzhu/.config/webdav/password";
  webdavMountPoint = "${config.home.homeDirectory}/webdav-mounted";
  rcloneBin = "${pkgs.rclone}/bin/rclone";

  # The rclone remote "ugnasdav" is defined entirely through RCLONE_CONFIG_*
  # env vars below, so no (obscured) password ever sits in a config file.
  # FUSE backend is FUSE-T (brew cask, kext-less; macFUSE 4.8 predates
  # macOS 26 and its kext refuses to load). rclone itself is nix-managed.
  webdavMount = pkgs.writeShellScript "webdav-mount" ''
    set -eu
    # wait for FUSE-T instead of thrashing until `brew install --cask fuse-t`
    # (macFUSE also ships libfuse.2.dylib, so that is not a valid marker)
    if [ ! -d "/Library/Application Support/FUSE-T" ]; then
      echo "FUSE-T not installed yet (brew install --cask fuse-t); retrying in 60s"
      sleep 60
      exit 1
    fi
    mkdir -p "${webdavMountPoint}"
    # clear a stale mount left by a previous run before remounting
    /sbin/umount "${webdavMountPoint}" 2>/dev/null || true
    export RCLONE_CONFIG_UGNASDAV_TYPE=webdav
    export RCLONE_CONFIG_UGNASDAV_VENDOR=other
    export RCLONE_CONFIG_UGNASDAV_URL="${webdavServer}${webdavRemotePath}"
    export RCLONE_CONFIG_UGNASDAV_USER="${webdavUser}"
    export RCLONE_CONFIG_UGNASDAV_PASS="$(${rcloneBin} obscure "$(cat "${webdavPasswordFile}")")"
    exec ${rcloneBin} mount ugnasdav: "${webdavMountPoint}" \
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
  ];
  home.sessionVariables = {
    WEBDAV_URL = webdavServer;
    WEBDAV_USER = webdavUser;
  };

  # WEBDAV_PASSWORD comes from sops (see darwin/sops.nix); read at shell
  # startup in .zshenv so interactive and non-interactive zsh both get it.
  programs.zsh.envExtra = ''
    if [[ -r "$HOME/.config/webdav/password" ]]; then
      export WEBDAV_PASSWORD="$(< "$HOME/.config/webdav/password")"
    fi
  '';

  # Auto-mount the NAS at login and self-heal: KeepAlive restarts rclone
  # after eject, crash, or tunnel outage. Log: ~/Library/Logs/webdav-nas.log
  launchd.agents.webdav-nas = {
    enable = true;
    config = {
      ProgramArguments = [ "${webdavMount}" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/webdav-nas.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/webdav-nas.log";
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
