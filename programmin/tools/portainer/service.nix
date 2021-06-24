{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devPortainer;
in {
  options = {
    services.devPortainer = {
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

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;

      upstreams = {
        "portainer_server" = { servers = { "127.0.0.1:9000" = { }; }; };
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
              proxyPass = "http://portainer_server";
            };
          };
        };
      };
    };

    virtualisation.oci-containers.containers = {
      portainer = {
        image = "portainer/portainer-ce";
        volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
            "portainer_data:/data"
        ];
        ports = [
            "8000:8000"
            "9000:9000"
        ];
      };
    };
  };
}
