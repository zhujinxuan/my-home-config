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
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      sops-nix,
      ...
    }:
    {

      homeConfigurations."jinxuanzhu@MacBookM1-Pro.local" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./common.nix
          ./darwin/home.nix
          ./darwin/sops.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit sops-nix;
        };
      };
      homeConfigurations."jinxuanzhu@MacBook-Pro.local" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./common.nix
          ./darwin/home.nix
          ./darwin/sops.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit sops-nix;
        };
      };
    };
}
