{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ./exporter.nix ];

  services.devMetrics = {
    enable = true;
    domain = mainDomain;
  };
}
