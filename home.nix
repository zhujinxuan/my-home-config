{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    touchegg
    fira-code
    fira-code-symbols
  ];

  home.file = {
    touchegg = {
      source = ./touchegg.conf;
      target = ".config/touchegg/touchegg.conf";
    };
  };

  programs.i3status = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    # enableAdobeFlash = true;
  };

  # xsession config
  xsession.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };

  programs.chromium = {
    enable = true;
  };

  programs.urxvt = {
    enable= true;
    fonts =  [ "xft:Droid Sans Mono Nerd Font:size=9" ];
    keybindings = {
      "M-c" = "perl:clipboard:copy";
      "M-v" = "perl:clipboard:paste";
      "M-S-v" = "perl:clipboard:paste_escaped";
    };
    extraConfig = {
      letterSpace = -7;
      foreground = "#93a1a1";
      background = "[80]#000000";
      depth = 32;
      cursorColor = "#afbfbf";
      "perl-ext-common" = with builtins; concatStringsSep "," [
        "default"
        "clipboard"
        "url-select"
        "keyboard-select"
        "tabbed"
      ];
      "perl-lib" =  with builtins; concatStringsSep "," [
        "${pkgs.urxvt_perls}/lib/urxvt/perl"
      ];
      "urlLauncher" = "firefox";
      "underLineURLs" = true;
      "underButtons" = 1;
      "copyCommand" = "xclip -i -selection clipboard";
      "pasteCommand" = "xclip -o -selection clipboard";
    };
  };


  services.picom = {
    enable = true;
    fade            = true;
    shadow          = true;
    fadeDelta       = 2;
  };

  services.screen-locker = {
    enable = true;
    lockCmd =  "${pkgs.i3lock}/bin/i3lock -n -c 000000";
  };

  systemd.user = {
    startServices = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # "application/x-desktop" = ["run-desktop.desktop"];
      "x-scheme-handler/http"=["firefox.desktop"];
      "x-scheme-handler/https"=["firefox.desktop"];
      "text/html"=["firefox.desktop"];
      "x-scheme-handler/about"=["firefox.desktop"];
      "x-scheme-handler/unknown"=["firefox.desktop"];
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.03";
}
