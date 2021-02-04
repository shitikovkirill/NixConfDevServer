{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.azurite;
  group = "azurite";
  user = "azurite";
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
        default = "azurite_blob";
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
        ports = [ "0.0.0.0:10000:10000" "0.0.0.0:10001:10001" ];
        extraOptions = [ "--blobHost 0.0.0.0" ];
      };
    };
  };
}
