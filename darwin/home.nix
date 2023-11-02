{ config, pkgs, ... }:

let
  emacs-osx-rc = builtins.fetchTarball
    "https://github.com/nequissimus/emacs-osx/archive/refs/tags/built.tar.gz";
  emacs-osx = import emacs-osx-rc;
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "zhujinxuan";
    userEmail = "zhujinxuan@gmail.com";
  };

  home.packages = with pkgs; [
    git
    fzf
    irony-server # C server for emacs
    # Haskell Packages
    cabal-install
    # cabal2nix
    cabal2nix-unwrapped
    ghc
    haskell-language-server
    pandoc
    hledger
    hledger-web
    hledger-ui
    # nix packages
    nix-index
    # Rust packages
    ruplacer
    fd
    ripgrep
    rustc
    rust-analyzer
    cargo
    # cargo-generate
    # cargo-edit
    # cargo-audit
    rustfmt
    # Apps
    emacs-osx.emacsOsxNativeTile
    nixfmt
    wget
    sshfs-fuse
    # Dev tools
    pdftk
    gnused
    coreutils
  ];

  programs.skim = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.password-store = {
    enable = true;
    settings = { PASSWORD_STORE_KEY = "0x98311E6463708C2B"; };
  };

  # programs.gpg = { enable = true; };
  # programs.mu = { enable = true; };
  # programs.mbsync = { enable = true; };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  programs.bat = {
    enable = true;
    config = { theme = "TwoDark"; };
    extraPackages = [ pkgs.bat-extras.batgrep pkgs.bat-extras.batman ];
  };

  programs.eza = { enable = true; };

  home.username = "jinxuanzhu";
  home.homeDirectory = "/Users/jinxuanzhu";
  home.file = {
    tridactyl = {
      source = ../home-files/tridactylrc;
      target = ".tridactylrc";
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
    enableCompletion = false;
    profileExtra =
      "\n  export  BROWSER='open'\n  # Nix\n  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then\n      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'\n  elif [ -e \"$HOME/.nix-profile/etc/profile.d/nix.sh\" ]; then\n      . $HOME/.nix-profile/etc/profile.d/nix.sh\n  fi\n  # End Nix\n";
    prezto = {
      enable = true;
      extraConfig =
        "\n  export  BROWSER='open'\n  # Nix\n  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then\n      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'\n  elif [ -e \"$HOME/.nix-profile/etc/profile.d/nix.sh\" ]; then\n      . $HOME/.nix-profile/etc/profile.d/nix.sh\n  fi\n  # End Nix\n";
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
        "ssh"
        "completion"
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
