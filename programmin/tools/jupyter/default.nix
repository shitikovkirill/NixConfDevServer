{ config, pkgs, ... }:
let vars = import ../../../variables.nix;
in with vars; {
  imports = [ ./service.nix ];

  services.devJupyter = {
    enable = true;
    domain = "jupyter." + mainDomain;
  };
}
