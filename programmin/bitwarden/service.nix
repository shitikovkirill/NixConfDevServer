{ config, lib, pkgs, ... }:

with lib;

let
  email = "bitwarden@example.com";

  cfg = config.services.devBitwarden;
in {

  options = {
    services.devBitwarden = {
      enable = mkOption {
        default = false;
        description = ''
          Enable pwServ.
        '';
      };

      environment = mkOption {
        default = {
          ADMIN_TOKEN = "admin_token";
          #YUBICO_CLIENT_ID =
          #  (import /etc/nixos/secret/bitwarden.nix).YUBICO_CLIENT_ID;
          #YUBICO_SECRET_KEY =
          #  (import /etc/nixos/secret/bitwarden.nix).YUBICO_SECRET_KEY;
          #YUBICO_SERVER = "https://api.yubico.com/wsapi/2.0/verify";
          SMTP_HOST = "127.0.0.1";
          SMTP_FROM = email;
          SMTP_PORT = 1025;
          SMTP_SSL = false;
          #SMTP_USERNAME = (import /etc/nixos/secret/bitwarden.nix).SMTP_USERNAME;
          #SMTP_PASSWORD = (import /etc/nixos/secret/bitwarden.nix).SMTP_PASSWORD;
          SMTP_TIMEOUT = 15;
        };
        description = ''
          Add environment to systemd
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

      email = mkOption {
        type = types.str;
        default = email;
        description = ''
          Admin emale
        '';
      };

      location = mkOption {
        default = "/var/backup/bitwarden_rs";
        description = ''
          Backup location.
        '';
      };
    };
  };
  config = mkIf cfg.enable {

    security.acme.acceptTerms = true;
    security.acme.email = cfg.email;
    security.acme.certs = mkIf cfg.https {
      "${cfg.domain}" = {
        group = "bitwarden_rs";
        keyType = "rsa2048";
        allowKeysForGroup = true;
      };
    };

    services.nginx = {
      enable = true;

      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = mkIf cfg.https true;

      virtualHosts = {
        "${cfg.domain}" = {
          forceSSL = cfg.https;
          enableACME = cfg.https;
          locations."/" = {
            proxyPass = "http://localhost:8000";
            proxyWebsockets = true;
          };
          locations."/notifications/hub" = {
            proxyPass = "http://localhost:3012";
            proxyWebsockets = true;
          };
          locations."/notifications/hub/negotiate" = {
            proxyPass = "http://localhost:8000";
            proxyWebsockets = true;
          };
        };
      };
    };

    services.bitwarden_rs = {
      enable = true;
      backupDir = cfg.location;

      config = {
        WEB_VAULT_FOLDER =
          "${pkgs.bitwarden_rs-vault}/share/bitwarden_rs/vault";
        WEB_VAULT_ENABLED = true;
        WEBSOCKET_ENABLED = true;
        WEBSOCKET_ADDRESS = "127.0.0.1";
        WEBSOCKET_PORT = 3012;
        SIGNUPS_VERIFY = true;
        DOMAIN = "${if cfg.https then "https" else "http"}://${cfg.domain}";
        SMTP_FROM_NAME = "Bitwarden_RS";
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8000;
      } // cfg.environment;
    };

    systemd.tmpfiles.rules = [ "d '${cfg.location}' 0700 bitwarden_rs - - -" ];

    environment.systemPackages = with pkgs; [ bitwarden_rs-vault ];
  };
}
