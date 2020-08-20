{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 3080 ];
    };
  };

  services.hydra = {
    enable = true;
    port = 3080;
    hydraURL = "http://localhost:3080";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };
}
