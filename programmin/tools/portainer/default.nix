{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devPortainer = {
    enable = true;
    domain = "portainer." + mainDomain;
  };
}
