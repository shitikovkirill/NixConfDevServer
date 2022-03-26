{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.devGitLab;
  registry-ssl-path = "/var/lib/docker-registry-ssl";
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

      config = mkOption {
        type = types.attrs;
        default = { };
        example = literalExample ''
          {
            omniauth = {
              enabled = true;
            };
          };
        '';
        description = ''
          Config
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
      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = cfg.https;
          forceSSL = cfg.https;
          locations."/".proxyPass =
            "http://unix:/run/gitlab/gitlab-workhorse.socket";
        };
        "registry.${cfg.domain}" = {
          enableACME = cfg.https;
          forceSSL = cfg.https;
          locations."/".proxyPass = "http://127.0.0.1:5000";
        };
        "127.0.0.1" = {
          locations."/".proxyPass =
            "http://unix:/run/gitlab/gitlab-workhorse.socket";
        };
      };
    };

    networking.hosts = ({ "127.0.0.1" = [ cfg.domain ]; });

    services.gitlab = {
      enable = true;
      databasePasswordFile = "${cfg.secretPath}/db_password";
      initialRootPasswordFile = "${cfg.secretPath}/root_password";
      https = cfg.https;
      host = cfg.domain;
      port = (if cfg.https then 443 else 80);

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
          default_projects_features = {
            issues = false;
            merge_requests = false;
            wiki = false;
            snippets = false;
            builds = false;
            container_registry = false;
          };
        };
        monitoring = { sidekiq_exporter = { enable = false; }; };
        registry = {
          enabled = true;
          host = "registry.${cfg.domain}";
          port = (if cfg.https then "443" else "80");
          api_url = "http://localhost:5000/";
          key = "${registry-ssl-path}/client.key";
          path = config.services.dockerRegistry.storagePath;
          issuer = "gitlab-issuer";
        };
      } // cfg.config;
    };

    services.dockerRegistry = {
      enable = true;
      extraConfig = {
        REGISTRY_AUTH_TOKEN_REALM =
          "http${(if cfg.https then "s" else "")}://${cfg.domain}/jwt/auth";
        REGISTRY_AUTH_TOKEN_SERVICE = "container_registry";
        REGISTRY_AUTH_TOKEN_ISSUER = "gitlab-issuer";
        REGISTRY_AUTH_TOKEN_ROOTCERTBUNDLE = registry-ssl-path;
      };
    };

    systemd.tmpfiles.rules = [
      "d '${registry-ssl-path}' 0750 ${config.services.gitlab.user} ${config.services.gitlab.group} - -"
    ];

    systemd.services.docker-registry-ssl = {
      description = "Create keys for docker registry";
      wantedBy = [ "multi-user.target" ];
      after = [
        "systemd-tmpfiles-clean.service"
        "systemd-tmpfiles-setup.service"
        "systemd-tmpfiles-setup-dev.service"
      ];
      script = ''
        FILE=client.cert
        if [[ -f "$FILE" ]]; then
            echo "$FILE exists."
        else
            echo "Criating sertificate..."
            rm -rf ./client.key
            ${pkgs.openssl}/bin/openssl genrsa -out client.key 4096
            ${pkgs.openssl}/bin/openssl req -new -x509 -text -key client.key -subj '/C=NL/ST=Zuid-Holland/L=The Hague/O=Stevige Balken en Planken B.V./OU=OpSec/CN=Certificate Authority' -out client.cert
        fi

        true
      '';
      serviceConfig = {
        WorkingDirectory = registry-ssl-path;
        User = config.services.gitlab.user;
        Group = config.services.gitlab.group;
        Type = "oneshot";
      };
    };
  };
}
