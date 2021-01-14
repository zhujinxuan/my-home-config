{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    pre-commit
  ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jinxuanzhu";
  home.homeDirectory = "/Users/jinxuanzhu";
  home.file = {};

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
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
    ];
    profileExtra = "
  export BROWSER='open'
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
      editor = {
        keymap = "vi";
        dotExpansion = true;
      };
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
    };
  };
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
