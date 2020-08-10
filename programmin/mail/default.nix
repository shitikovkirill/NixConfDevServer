{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.myMetrics = {
    enable = true;
    domain = "mail." + mainDomain;
  };
}
