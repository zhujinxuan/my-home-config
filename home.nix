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
orig
