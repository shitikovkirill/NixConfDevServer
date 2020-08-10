{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devJupyter;
in {
  options = {
    services.devJupyter = {
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

      password = mkOption {
        type = types.str;
        default =
          "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'"; # test
        description = "domain";
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedProxySettings = true;
      virtualHosts."${cfg.domain}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
        locations = {
        "/" = { proxyPass = "http://localhost:8888"; };
        "/terminals/websocket/" = { proxyWebsockets = true; };
        };
      };
    };

    services.jupyter = {
      enable = true;
      password = cfg.password;
      ip = "0.0.0.0";
    };
  };
}
