{ config, lib, pkgs, ... }:

{
  imports = [ ./service.nix ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 5432 ];
  };

  services.devPostgres = {
    enable = true;
    database = {
        user = "kirill";
    };
  };
}
