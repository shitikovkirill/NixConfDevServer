{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devGitLab;
in {
  options = {
    services.devGitLab = {
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

      secretPath = mkOption {
        type = types.path;
        default = ./secrets-example;
        description = ''
          Secrets example files
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
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."${cfg.domain}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
        # listen.port = 8080;
        locations."/".proxyPass =
          "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
      virtualHosts."127.0.0.1" = {
        locations."/".proxyPass =
          "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
    };

    networking.hosts = ({ "127.0.0.1" = [ cfg.domain ]; });

    services.gitlab = {
      enable = true;
      databasePasswordFile = "${cfg.secretPath}/db_password";
      initialRootPasswordFile = "${cfg.secretPath}/root_password";
      https = cfg.https;
      host = cfg.domain;
      port = 80;

      secrets = {
        dbFile = "${cfg.secretPath}/db";
        secretFile = "${cfg.secretPath}/secret";
        otpFile = "${cfg.secretPath}/otp";
        jwsFile = "${cfg.secretPath}/jws";
      };

      smtp = {
        enable = true;
        address = "localhost";
        port = 1025;
      };

      extraConfig = {
        gitlab = {
          email_from = "gitlab-no-reply@${cfg.domain}";
          email_display_name = "Example GitLab";
          email_reply_to = "gitlab-no-reply@${cfg.domain}";
          default_projects_features = { builds = false; };
        };
      };
      extraGitlabRb = ''
        sidekiq['concurrency'] = 1
        unicorn['worker_processes'] = 1
        prometheus_monitoring['enable'] = false
        postgresql['shared_buffers'] = "256MB"
      '';
    };
  };
}
