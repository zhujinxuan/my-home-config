{pkgs, ...}: {
  allowUnfree = true;
  nix.package = pkgs.nixUnstable;
}
