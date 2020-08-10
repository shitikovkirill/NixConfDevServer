{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devMetrics;
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
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      statusPage = true;
      virtualHosts."${cfg.domain}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
        locations = { "/" = { proxyPass = "http://localhost:3000"; }; };
      };
    };

    services.jupyter = {
      enable = true;
    };
  };
}
