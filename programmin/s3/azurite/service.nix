{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.azurite;

in {

  options = {
    services.azurite = {
      enable = mkOption {
        default = false;
        description = ''
          Enable sentry.
        '';
      };
      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/azurite";
        example = "/data/azurite";
        description = ''
          Set default value for storage
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 10000 10001 ];
      };
    };

    virtualisation.oci-containers.containers = {
      azurite = {
        image = "mcr.microsoft.com/azure-storage/azurite";
        volumes = [ "${cfg.stateDir}:/data" ];
        ports = [ "10000:10000" "10001:10001" ];
      };
    };

    systemd.tmpfiles.rules = [ "d '${cfg.stateDir}' 0750 docker docker - -" ];
  };
}
