{ config, pkgs, ... }:
let hosts = import ./load-hosts.nix;
in {
  services.openssh = { 
    enable = true;
    settings.PasswordAuthentication = false;
  };
  networking = {
    hostName = "dev";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };
  networking.hosts = hosts;
}
