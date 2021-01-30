{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.devpi;

  devpiEnv = { DEVPI_PASSWORD = "changemetoyourlongsecret"; };
in {

  options = {
    services.devpi = {
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

      environment = mkOption {
        type = types.attrs;
        default = { };
        description = ''
          Add environment to systemd
        '';
      };

      volumeDir = mkOption {
        type = types.str;
        default = "/var/lib/devpi";
        example = "/data/devpi";
        description = ''
          Set default devpi volume dir
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
        addSSL = cfg.https;
        basicAuth = cfg.auth;
        locations = { "/" = { proxyPass = "http://127.0.0.1:3141"; }; };
      };
    };

    virtualisation.oci-containers.containers = {
      devpi = {
        image = "muccg/devpi";
        environment = devpiEnv // cfg.environment;
        ports = [ "3141:3141" ];
        volumes = [ "${cfg.volumeDir}:/data" ];
      };
    };

    systemd.tmpfiles.rules = [ "d '${cfg.volumeDir}' 1777 root root - -" ];

    environment.systemPackages = with pkgs; [ docker ];
  };
}
