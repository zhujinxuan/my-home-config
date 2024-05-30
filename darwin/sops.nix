{
  config,
  lib,
  pkgs,
  sops-nix,
  ...
}:

{
  imports = [ sops-nix.homeManagerModule ];

  sops = {
    age.keyFile = "/Users/jinxuanzhu/.config/sops/age/keys.txt";
    # defaultSopsFile = ../secrets/secrets.yaml;
    secrets.id_rsa = {
      path = "/Users/jinxuanzhu/.ssh/id_rsa";
      sopsFile = ../secrets/ssh/id_rsa.sops;
      format = "binary";
      mode = "0600";
    };
    secrets.id_rsapub = {
      path = "/Users/jinxuanzhu/.ssh/id_rsa.pub";
      sopsFile = ../secrets/ssh/id_rsa.pub.sops;
      format = "binary";
      mode = "0600";
    };
  };
}
