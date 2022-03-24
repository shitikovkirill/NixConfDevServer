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
    services.apache-kafka.enable = true;
  };
}
