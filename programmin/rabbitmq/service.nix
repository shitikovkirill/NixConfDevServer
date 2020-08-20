{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.devRabbitmq;
  proxy_pass = "http://127.0.0.1:15672";
in {
  options = {
    services.devRabbitmq = {
      enable = mkOption {
        default = false;
        description = ''
          Enable thinklocal web service.
        '';
      };

      domain = mkOption {
        type = types.str;
        description = "domain";
      };

      https = mkOption {
        default = false;
        description = ''
          Enable https.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 80 443 5672 15672 ];
      };
    };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;

      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = cfg.https;
          forceSSL = cfg.https;
          locations = { "/" = { proxyPass = "${proxy_pass}"; }; };
        };
      };
    };

    services.rabbitmq = {
      enable = true;
      listenAddress = "0.0.0.0";
      plugins = [ "rabbitmq_management" "rabbitmq_prometheus" ];
      #config = "[{rabbit, [{loopback_users, []}]}].";
    };
  };
}
