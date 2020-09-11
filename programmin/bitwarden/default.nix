{ config, lib, pkgs, ... }:

let secrets = import ../../secrets/bitwarden/secrets.nix;
in {
  imports = [ ./service.nix ];

  services.devBitwarden = {
    enable = true;
    domain = "pw." + mainDomain;
  };
}
