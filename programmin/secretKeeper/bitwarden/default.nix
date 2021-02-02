{ config, lib, pkgs, ... }:

let vars = import ../../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devBitwarden = {
    enable = true;
    domain = "pw." + mainDomain;
  };
}
