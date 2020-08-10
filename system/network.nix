{ config, pkgs, ... }:

{
  services.openssh = { enable = true; };
  networking = {
    hostName = "dev";
    firewall = {
      enable = false;
    };
  };
}
