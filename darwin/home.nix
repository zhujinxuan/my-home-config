{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fzf
    hledger
    hledger-ui
    hledger-web
    irony-server # C server for emacs
    # Haskell Packages
    cabal-install
    cabal2nix-unwrapped
    ghc
    haskell-language-server
    pandoc
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
    wget
    sshfs-fuse
    fasd
    jwt-cli
    qmk
    # Python
    pyright
    # Dev tools
    devenv
    oq
    pdftk
    gnused
    coreutils
    unar
    httpie
    rsync
    socat
    tcpdump
    wireshark
    imagemagick
    ghostscript
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

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
