{ config, lib, pkgs, ... }:

{
  imports = [ ./service.nix ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 5432 8080 ];
  };

  services.devPostgres = {
    enable = true;
    database = {
        user = "kirill";
    };
  };
}
