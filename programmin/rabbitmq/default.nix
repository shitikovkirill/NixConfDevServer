{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devRabbitmq = {
    enable = true;
    domain = "radm." + mainDomain;
  };
}
