{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    sshfs-fuse
    unar
    wget
  ];

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
      src = ../per-directory-history;
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
