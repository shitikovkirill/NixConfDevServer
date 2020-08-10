{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devMetrics = {
    enable = true;
    domain = "jupyter." + mainDomain;
  };
}
