{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.devMysql;
  phpmyadmin = import ./phpmyadmin { };
  fastcgiPass = "127.0.0.1:9000";
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
          root = phpmyadmin;
          locations = {
            "/" = {
              index = "index.php index.html index.htm";
              tryFiles = "$uri /index.php$is_args$args =404";
            };
            "~ ^/(.*.php)".extraConfig = ''
              fastcgi_pass ${fastcgiPass};
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
            '';
          };
        };
      };
    };

    services.phpfpm.pools = {
      phpmyadmin = {
        user = config.services.nginx.user;
        listen = fastcgiPass;
      };
    };

    services.mysql = {
      enable = true;
      package = pkgs.mysql;
      ensureDatabases = [ cfg.database.user ] ++ cfg.databases;
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

  };
}
