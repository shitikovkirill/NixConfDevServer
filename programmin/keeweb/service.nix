{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.keeweb;
  proxyPass = "127.0.0.1:8443";
in {

  options = {
    services.keeweb = {
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
        enableACME = https;
        forceSSL = https;
        locations = { "/" = { proxyPass = "https://${proxyPass}"; }; };
      };
    };

    virtualisation.oci-containers.containers = {
      keeweb = {
        image = "antelle/keeweb";
        ports = [ "8443:443" ];
      };
    };
  };
}
