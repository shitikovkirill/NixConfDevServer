{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.devMysql;
in {

  options = {
    services.devMysql = {
      enable = mkOption {
        default = false;
        description = ''
          Enable db.
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
        "mysql_admin_server" = { servers = { "127.0.0.1:8081" = { }; }; };
      };

      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = cfg.https;
          forceSSL = cfg.https;
          basicAuth = cfg.auth;
          locations = {
            "/" = {
              extraConfig = ''
                proxy_set_header "X-Real-Ip" "$remote_addr";
                proxy_set_header "Host" "$host";
              '';
              proxyPass = "http://mysql_admin_server";
            };
          };
        };
      };
    };

    services.mysql = {
      enable = true;
      package = pkgs.mysql;
      ensureDatabases = [ cfg.database.user ] + cfg.databases;
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
      }];
      initialScript = pkgs.writeText "dbInitScript" ''
        CREATE USER '${cfg.database.user}'@'%' IDENTIFIED BY '${cfg.database.password}';
        GRANT ALL PRIVILEGES ON *.* TO '${cfg.database.user}'@'%';
        CREATE DATABASE ${cfg.database.user};
      '';
    };
    virtualisation.oci-containers.containers = {
      keeweb = {
        image = "phpmyadmin";
        ports = [ "8081:80" ];
        extraDockerOptions = [ "--network=host" ];
        environment = {
          MYSQL_USER = cfg.database.user;
          MYSQL_PASSWORD = cfg.database.password;
        };
      };
    };
  };
}
