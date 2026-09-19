{
  description = "Home Manager configuration of jinxuanzhu";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    per-directory-history = {
      url = "github:jimhester/per-directory-history";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      per-directory-history,
      ...
    }:
    {
      homeConfigurations."jinxuanzhu@MacBookM1-Pro.local" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";

        modules = [
          ./common.nix
          ./darwin/home.nix
          ./darwin/sops.nix
        ];

        extraSpecialArgs = {
          inherit sops-nix per-directory-history;
        };
      };
      homeConfigurations."jinxuanzhu@MacBook-Pro.local" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";

        modules = [
          ./common.nix
          ./darwin/home.nix
          ./darwin/sops.nix
        ];

        extraSpecialArgs = {
          inherit sops-nix per-directory-history;
        };
      };
    };
}
