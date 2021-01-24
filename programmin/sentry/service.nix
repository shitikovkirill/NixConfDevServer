{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sentry;
  is_local_db = (cfg.database.host == "localhost");

  localhost_in_docker = "127.0.0.1";
  proxyPass = "127.0.0.1:9000";

  postgres_host = (if cfg.database.host == "localhost" then
    localhost_in_docker
  else
    cfg.database.host);

  sentryEnv = {
    SENTRY_URL_PREFIX = "https://${cfg.domain}";
    SENTRY_REDIS_HOST = localhost_in_docker;
    SENTRY_POSTGRES_HOST = postgres_host;
    SENTRY_DB_USER = cfg.database.user;
    SENTRY_DB_NAME = cfg.database.name;
    SENTRY_DB_PASSWORD = cfg.database.password;
    SENTRY_SECRET_KEY = cfg.secretKey;
    #SENTRY_SINGLE_ORGANIZATION=false;
  };
in {

  options = {
    services.sentry = {
      enable = mkOption {
        default = false;
        description = ''
          Enable sentry.
        '';
      };

      domain = mkOption {
        type = types.str;
        example = "example.com";
        description = ''
          Domain
        '';
      };

      email = mkOption {
        type = types.str;
        example = "admin@example.com";
        description = ''
          Admin emale
        '';
      };

      https = mkOption {
        default = false;
        description = ''
          Enable https.
        '';
      };

      secretKey = mkOption {
        type = types.str;
        example = "xxxxxxxx";
        description = ''
          Secret key
        '';
      };

      database = mkOption {
        type = types.submodule ({
          options = import ./db-options.nix { inherit lib; };
        });
        description = ''
          Database settings
        '';
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    security.acme = {
      email = cfg.email;
      acceptTerms = true;
      #server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    };

    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedGzipSettings = true;
      virtualHosts."${cfg.domain}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
        locations = { "/" = { proxyPass = "http://${proxyPass}"; }; };
      };
    };

    virtualisation.oci-containers.containers = {
      sentry_web = {
        image = "sentry";
        extraDockerOptions = [ "--network=host" ];
        environment = sentryEnv;
      };
      sentry_worker = {
        image = "sentry";
        cmd = [ "run" "worker" ];
        extraDockerOptions = [ "--network=host" ];
        environment = sentryEnv;
      };
      sentry_cron = {
        image = "sentry";
        cmd = [ "run" "cron" ];
        extraDockerOptions = [ "--network=host" ];
        environment = sentryEnv;
      };
    };

    services.postgresql = mkIf is_local_db {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 0.0.0.0/0 trust
      '';
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }];
      initialScript = pkgs.writeText "sentryDbInitScript" ''
        CREATE ROLE ${cfg.database.user} WITH LOGIN PASSWORD '${cfg.database.password}' CREATEDB;
        CREATE DATABASE ${cfg.database.name};
        GRANT ALL PRIVILEGES ON DATABASE ${cfg.database.name} TO ${cfg.database.user};
        ALTER USER ${cfg.database.user} WITH SUPERUSER;
      '';
    };

    services.redis = { enable = true; };
  };
}
