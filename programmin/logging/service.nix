{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.devElk;
  unstable = import <nixos-unstable> { config = { }; };
  fromUnit = unit: ''
    pipe {
        command => "${pkgs.systemd}/bin/journalctl -fu ${unit} -o json"
        tags => "${unit}"
        type => "syslog"
        codec => json {}
    }
  '';
in {
  options.services.devElk = {
    enable = mkOption {
      description = "Whether to enable the ELK stack";
      type = types.bool;
      default = false;
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

    systemdUnits = mkOption {
      description = "The systemd units to send to our ELK stack.";
      default = [ ];
      type = types.listOf types.str;
    };

    additionalInputConfig = mkOption {
      description = "Additional logstash input configurations.";
      default = "";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;

      upstreams = {
        "elk_server" = { servers = { "127.0.0.1:5601" = { }; }; };
      };

      virtualHosts = {
        "${cfg.domain}" = {
          enableACME = cfg.https;
          forceSSL = cfg.https;
          locations = { "/" = { proxyPass = "http://elk_server"; }; };
        };
      };
    };

    services.logstash = {
      enable = true;
      plugins = [ pkgs.logstash-contrib ];
      inputConfig = (concatMapStrings fromUnit cfg.systemdUnits)
        + cfg.additionalInputConfig;
      filterConfig = ''
        if [type] == "syslog" {
            # Keep only relevant systemd fields
            # http://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
            prune {
                whitelist_names => [
                    "type", "@timestamp", "@version",
                    "MESSAGE", "PRIORITY", "SYSLOG_FACILITY", "_SYSTEMD_UNIT"
                ]
            }
            mutate {
                rename => { "_SYSTEMD_UNIT" => "unit" }
            }
        }
      '';
      outputConfig = ''
        elasticsearch {
            hosts => [ "127.0.0.1:9200" ]
        }
      '';
    };

    services.elasticsearch = { enable = true; };

    services.kibana = {
      enable = true;
      extraConf = {
        xpack.infra.sources.default.fields.message = [ "MESSAGE" ];
      };
    };
  };
}
