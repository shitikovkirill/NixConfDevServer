{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.devPostgres;
in {

  options = {
    services.devPostgres = {
      enable = mkOption {
        default = false;
        description = ''
          Enable postgres db.
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

      database = mkOption {
        type = types.submodule ({
          options = import ./db-options.nix { inherit lib; };
        });
        description = ''
          Database settings
        '';
        default = { };
      };

      databases = mkOption {
        default = [ ];
        description = ''
          List of databases.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ cfg.database.port 80 443 ];
    };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;

      upstreams = {
        "db_admin_server" = { servers = { "127.0.0.1:8081" = { }; }; };
      };

      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = cfg.https;
          forceSSL = cfg.https;
          basicAuth = cfg.auth;
          locations = {
            "/" = {
              extraConfig = ''
                proxy_redirect off;
              '';
              proxyPass = "http://db_admin_server";
            };
          };
        };
      };
    };

    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all ::1/128 trust
        host all all 0.0.0.0/0 trust
      '';
      ensureDatabases = [ cfg.database.user ] ++ cfg.databases;
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }];
      initialScript = pkgs.writeText "dbInitScript" ''
        CREATE ROLE ${cfg.database.user} WITH LOGIN PASSWORD '${cfg.database.password}' CREATEDB;
        CREATE DATABASE ${cfg.database.user};
        GRANT ALL PRIVILEGES ON DATABASE ${cfg.database.user} TO ${cfg.database.user};
        ALTER USER ${cfg.database.user} WITH SUPERUSER;
      '';
    };

    #services.pgmanage = {
    #  enable = true;
    #  localOnly = false;
    #  logLevel = "info";
    #  sqlRoot="/tmp/pgmanage";
    #  connections = {
    #    main-db = "hostaddr=127.0.0.1 port=5432 dbname=${cfg.database.user}";
    #  };
    #};

    virtualisation.oci-containers.containers = {
      pg_admin = {
        image = "dpage/pgadmin4";
        extraOptions = [ "--network=host" ];
        environment = {
          PGADMIN_DEFAULT_EMAIL = "postgres@gmail.com";
          PGADMIN_DEFAULT_PASSWORD = "test";
          PGADMIN_LISTEN_ADDRESS = "0.0.0.0";
          PGADMIN_LISTEN_PORT = "8081";
        };
      };
    };
  };
}
