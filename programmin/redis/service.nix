{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devRedis;
in {
  options = {
    services.devRedis = {
      enable = mkOption {
        default = false;
        description = ''
          Enable thinklocal web service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.redis = {
      enable = true;
    };
  };
}
