{ config, lib, pkgs, ... }:

let vars = import ../../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devpi = {
    enable = true;
    domain = "devpi." + mainDomain;
  };
}
