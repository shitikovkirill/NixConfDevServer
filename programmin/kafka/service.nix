{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devKafka;
in {
  options = {
    services.devKafka = {
      enable = mkOption {
        default = false;
        description = ''
          Enable kafka.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [ 9092 2181 ];
      };
    };

    services.apache-kafka = {
        enable = true;
    };
    services.zookeeper.enable = true;
  };
}
