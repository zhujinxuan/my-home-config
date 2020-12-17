let
        machine  = import ./machine.nix;
        isNix    = machine.operatingSystem == "NixOS";
        isDarwin = machine.operatingSystem == "Darwin";
        orig = if isNix then
          import ./nixos/config.nix
               else
                 if isDarwin then
                 import ./darwin/config.nix
               else
                 {};
in
orig
