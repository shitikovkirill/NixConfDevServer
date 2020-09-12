{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devElk = {
    enable = true;
    domain = "elk." + mainDomain;
    systemdUnits = [ "nginx" ]
  };
}
