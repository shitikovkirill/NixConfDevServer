{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devHydra;
in {
  options = {
    services.devHydra = {
      enable = mkOption {
        default = false;
        description = ''
          Enable thinklocal web service.
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
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 80 443 ];
      };
    };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;

      upstreams = {
        "hydra_server" = { servers = { "127.0.0.1:3080" = { }; }; };
      };

      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = cfg.https;
          forceSSL = cfg.https;
          locations = { "/" = { proxyPass = "http://hydra_server"; }; };
        };
      };
    };

    services.hydra = {
      enable = true;
      port = 3080;
      hydraURL = cfg.domain;
      notificationSender = "hydra@localhost";
      buildMachinesFiles = [ ];
      useSubstitutes = true;
    };
  };
}
