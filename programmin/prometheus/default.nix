{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ./exporter.nix ];

  services.myMetrics = {
    enable = true;
    domain = mainDomain;
  };
}
