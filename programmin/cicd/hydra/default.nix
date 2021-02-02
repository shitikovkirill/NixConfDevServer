{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devHydra = {
    enable = true;
    domain = "hydra." + mainDomain;
  };
}
