{ config, pkgs, ... }:
let vars = import ../../variables.nix;
in with vars; {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 3000 ];
    };
  };

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [ ];
    useSubstitutes = true;
  };
}
