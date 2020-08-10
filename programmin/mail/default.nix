{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devMail = {
    enable = true;
    domain = "mail." + mainDomain;
  };
}
