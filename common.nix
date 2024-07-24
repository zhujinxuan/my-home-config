{ config, pkgs, ... }:
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    fzf
    # C server for emacs
    irony-server
    # Haskell Packages
    cabal-install
    cabal2nix-unwrapped
    ghc
    haskell-language-server
    pandoc
    hledger
    hledger-ui
    hledger-web
    # nix packages
    nix-index
    # Rust packages
    ruplacer
    fd
    ripgrep
    rustfmt
    fselect
    dua
    nixfmt-rfc-style
    fasd
    jwt-cli
    qmk
    bottom
    # Python
    pyright
    # Dev tools
    devenv
    oq
    pdftk
    gnused
    coreutils
    httpie
    rsync
    socat
    imagemagick
    # Network
    tcpdump
    wireshark
    ghostscript
    findutils
    # Security
    age
    ssh-to-age
    neovim
    yazi
  ];

  programs.git = {
    enable = true;
    userName = "zhujinxuan";
    userEmail = "zhujinxuan@gmail.com";
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "6EBC7887A28C634A0CD38D8F590FE0D59AD6E8BE";
    };
  };

  programs.gpg = {
    enable = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
    extraPackages = with pkgs.bat-extras; [
      batgrep
      batman
      batdiff
      batwatch
    ];
  };

  programs.eza = {
    enable = true;
  };

  home.file.tridactyl = {
    source = ./home-files/tridactylrc;
    target = ".tridactylrc";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    prezto = {
      enable = true;
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

  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
  };

  programs.ssh = {
    enable = true;
    package = pkgs.openssh;
    controlPersist = "4h";
    matchBlocks = {
      "egenerationmarketing.com" = {
        hostname = "egenerationmarketing.com";
        user = "root";
        identityFile = [
          "~/.ssh/egm-aws.pem"
          "~/.ssh/id_rsa"
        ];
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/id_rsa" ];
      };
      "github-kakaa" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/kakaa_rsa" ];
        identitiesOnly = true;
      };
    };
  };
}
