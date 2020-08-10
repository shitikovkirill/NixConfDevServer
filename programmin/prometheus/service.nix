{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devMetrics;
in {
  options = {
    services.devMetrics = {
      enable = mkOption {
        default = false;
        description = ''
          Enable service.
        '';
      };

      https = mkOption {
        default = false;
        description = ''
          Enable https.
        '';
      };

      domain = mkOption {
        type = types.str;
        description = "domain";
      };

      nodeTargets = mkOption {
        default = [ ];
        description = ''
          List of targets.
        '';
      };

      nginxTargets = mkOption {
        default = [ ];
        description = ''
          List of targets.
        '';
      };

      postfixTargets = mkOption {
        default = [ ];
        description = ''
          List of targets.
        '';
      };

      rabbitmqTargets = mkOption {
        default = [ ];
        description = ''
          List of targets.
        '';
      };

      jsonTargets = mkOption {
        default = [ ];
        description = ''
          List of targets.
        '';
      };

      postgresTargets = mkOption {
        default = [ ];
        description = ''
          List of targets.
        '';
      };

      auth = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = literalExample ''
          {
            user = "password";
          };
        '';
        description = ''
          Basic Auth protection for a vhost.
          WARNING: This is implemented to store the password in plain text in the
          nix store.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."grafana.${cfg.domain}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
        locations = { "/" = { proxyPass = "http://localhost:3000"; }; };
      };
      virtualHosts."prometheus.${cfg.domain}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
        basicAuth = cfg.auth;
        locations = { "/" = { proxyPass = "http://localhost:9090"; }; };
      };
    };

    services.grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources = [{
          name = "NodeStatistic";
          type = "prometheus";
          url = "http://localhost:9090";
          isDefault = true;
          user = "admin";
        }];
      };
    };

    services.prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "prometeus";
          static_configs = [{
            targets = [ "localhost:9090" ];
            labels = { alias = "prometeus"; };
          }];
        }
        {
          job_name = "node";
          static_configs = [{
            targets = [ "localhost:9100" ] ++ cfg.nodeTargets;
            labels = { role = "node"; };
          }];
        }
        {
          job_name = "nginx";
          static_configs = [{
            targets = cfg.nginxTargets;
            labels = { role = "nginx"; };
          }];
        }
        {
          job_name = "postfix";
          static_configs = [{
            targets = cfg.postfixTargets;
            labels = { role = "postfix"; };
          }];
        }
        {
          job_name = "rabbitmq";
          static_configs = [{
            targets = cfg.rabbitmqTargets;
            labels = { role = "rabbitmq"; };
          }];
        }
        {
          job_name = "json";
          static_configs = [{
            targets = cfg.jsonTargets;
            labels = { role = "json"; };
          }];
          scrape_interval = "15m";
        }
        {
          job_name = "postgres";
          static_configs = [{
            targets = cfg.postgresTargets;
            labels = { role = "postgres"; };
          }];
        }
      ];
    };
  };
}
