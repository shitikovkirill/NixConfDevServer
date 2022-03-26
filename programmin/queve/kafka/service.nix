{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.devKafka;
  kafka_domain = "localhost";
in {
  options = {
    services.devKafka = {
      enable = mkOption {
        default = false;
        description = ''
          Enable kafka.
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
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 9092 ];
      };
    };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;

      upstreams = {
        "kafka_admin_server" = { servers = { "127.0.0.1:8082" = { }; }; };
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
              proxyPass = "http://kafka_admin_server";
            };
          };
        };
      };
    };

    services.apache-kafka = {
      enable = true;
      hostname = kafka_domain;
    };
    services.zookeeper.enable = true;

    virtualisation.oci-containers.containers = {
      kafka_admin = {
        image = "provectuslabs/kafka-ui";
        extraOptions = [ "--network=host" ];
        environment = {
          KAFKA_CLUSTERS_0_NAME = kafka_domain;
          KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS = "${kafka_domain}:9092";
          SERVER_PORT = "8082";
        };
      };
    };

  };
}
