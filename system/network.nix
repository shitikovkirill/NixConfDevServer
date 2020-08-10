{ config, pkgs, ... }:

{
  services.openssh = { enable = true; };
  networking = {
    hostName = "dev";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };
}
