{ config, pkgs, ... }:

let
  emacs-osx = import ../emacs-osx;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    pre-commit
    cabal-install
    cabel2nix
    ghc
    haskell-language-server
    pandoc
    languagetool
    # Rust packages
    fd
    ripgrep
    bat
    rustc
    cargo
    rustfmt
    # Apps
    emacs-osx.emacsOsxNativeTile
    # audacity
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jinxuanzhu";
  home.homeDirectory = "/Users/jinxuanzhu";
  home.file = {
    tridactyl = {
      source = ../home-files/tridactylrc;
      target = ".tridactylrc";
    };
    yabai = {
      source = ../home-files/yabairc;
      target = ".yabairc";
    };
    skhd = {
      source = ../home-files/skhdrc;
      target = ".skhdrc";
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    plugins = [
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
    profileExtra = "
  export  BROWSER='open'
  # Nix
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  elif [ -e \"$HOME/.nix-profile/etc/profile.d/nix.sh\" ]; then
      . $HOME/.nix-profile/etc/profile.d/nix.sh
  fi
  # End Nix
";
    prezto = {
      enable = true;
      extraConfig = "
  export  BROWSER='open'
  # Nix
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  elif [ -e \"$HOME/.nix-profile/etc/profile.d/nix.sh\" ]; then
      . $HOME/.nix-profile/etc/profile.d/nix.sh
  fi
  # End Nix
";
      editor = {
        keymap = "vi";
        dotExpansion = true;
        promptContext = true;
      };
      utility.safeOps = false;
      pmodules = [
        "archive"
        "autosuggestions" 
        "environment" 
        "terminal" 
        "editor" 
        "history" 
        "directory" 
        "fasd" 
        "spectrum" 
        "utility" 
        "ssh" 
        "completion" 
        "git" 
        "syntax-highlighting" 
        "history-substring-search" 
        "node" 
        "homebrew" 
        "haskell" 
        "prompt"
      ];
      prompt = {
        theme = "powerlevel10k";
        pwdLength = "long";
      };
      tmux.itermIntegration = true;
      autosuggestions.color = "fg=blue";
    };
  };
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
