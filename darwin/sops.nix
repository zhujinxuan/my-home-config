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
    secrets.id_rsa = {
      path = "/Users/jinxuanzhu/.ssh/id_rsa";
      sopsFile = ../secrets/ssh/id_rsa.sops;
      format = "binary";
      mode = "0600";
    };
    secrets."id_rsa.pub" = {
      path = "/Users/jinxuanzhu/.ssh/id_rsa.pub";
      sopsFile = ../secrets/ssh/id_rsa.pub.sops;
      format = "binary";
      mode = "0600";
    };
    secrets.sensitive_zsh = {
      path = "/Users/jinxuanzhu/.zsh/sensitive.zsh";
      sopsFile = ../secrets/zsh/sensitive.zsh.sops;
      format = "binary";
      mode = "0600";
    };
    secrets.webdav_password = {
      path = "/Users/jinxuanzhu/.config/webdav/password";
      sopsFile = ../secrets/webdav/password.sops;
      format = "binary";
      mode = "0600";
    };
  };
}
