{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.devPostgres;
in {

  options = {
    services.devPostgres = {
      enable = mkOption {
        default = false;
        description = ''
          Enable sentry.
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
    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 0.0.0.0/0 trust
      '';
      ensureDatabases = [ cfg.database.user ];
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }];
      initialScript = pkgs.writeText "sentryDbInitScript" ''
        CREATE ROLE ${cfg.database.user} WITH LOGIN PASSWORD '${cfg.database.password}' CREATEDB;
        CREATE DATABASE ${cfg.database.user};
        GRANT ALL PRIVILEGES ON DATABASE ${cfg.database.user} TO ${cfg.database.user};
        ALTER USER ${cfg.database.user} WITH SUPERUSER;
      '';
    };
    services.pgmanage = {
      enable = true;
      localOnly = false;
      connections = {
        main-server = "hostaddr=127.0.0.1 port=5432 dbname=${cfg.database.user}";
      };
    };
  };
}
