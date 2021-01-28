{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.devRedis;
  redmon = pkgs.callPackage ./redmon { };
  user = "redis_admin";
  group = "redis_admin";
in {
  options = {
    services.devRedis = {
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
        "redis_admin_server" = { servers = { "127.0.0.1:4567" = { }; }; };
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
              proxyPass = "http://redis_admin_server";
            };
          };
        };
      };
    };

    services.redis = {
      enable = true;
      openFirewall = true;
      bind = "0.0.0.0";
    };

    virtualisation.oci-containers.containers = {
      redis_admin = {
        image = "vieux/redmon";
        extraOptions = [ "--network=host" ];
      };
    };

    users = {
      groups.${group} = { };
      users.${user} = {
        group = group;
        isSystemUser = true;
      };
    };
  };
}
