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
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets.id_rsa = {
      # %r gets replaced with a runtime directory, use %% to specify a '%'
      # sign. Runtime dir is $XDG_RUNTIME_DIR on linux and $(getconf
      # DARWIN_USER_TEMP_DIR) on darwin.
      path = "%r/test.txt";
    };
  };
}
