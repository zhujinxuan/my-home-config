arg@{ config, pkgs, ... }:
let
        machine  = import ./machine.nix;
        isNix    = machine.operatingSystem == "NixOS";
        isDarwin = machine.operatingSystem == "Darwin";
        orig = if isNix then
          import ./nixos/home.nix arg
               else if isDarwin then
                 import ./darwin/home.nix arg
               else {};
in
  with orig; orig //{
    home = with home; home//{
      file = file // {
        zsh-shared = {
          target = "./zsh-config/common-zshrc.zsh";
          source = ./home-files/common-zshrc.zsh;
        };
      };
    };
  }
