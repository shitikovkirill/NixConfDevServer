{ config, pkgs, ... }:
let hosts = import ./load-hosts.nix;
in {
  services.openssh = { enable = true; };
  networking = {
    hostName = "dev";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 ];
    };
  };
  networking.hosts = hosts;
}
