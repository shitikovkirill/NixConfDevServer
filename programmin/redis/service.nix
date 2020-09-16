{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.devRedis;
  redmon = pkgs.callPackage ./redmon { };
  user = "redis_admin";
  group = "redis_admin";
in {
  options = {
    services.devRedis = {
      enable = mkOption {
        default = false;
        description = ''
          Enable thinklocal web service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 80 443 4567 ];
      };
    };

    services.redis = {
      enable = true;
      openFirewall = true;
      bind = "0.0.0.0";
    };

   virtualisation.oci-containers.containers = {
      redis_admin = {
        image = "vieux/redmon";
        extraOptions = [ "--network=host" ];
      };
    };

    users = {
      groups.${group} = { };
      users.${user} = {
        group = group;
        isSystemUser = true;
      };
    };
  };
}
