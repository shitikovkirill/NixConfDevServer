{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.clearLogs;
in {
  options = {
    services.clearLogs = {
      enable = mkOption {
        default = false;
        description = ''
          Enable ClearLogs.
        '';
      };

      startAt = mkOption {
        default = "*-*-* 01:15:00";
        description = ''
          This option defines (see <literal>systemd.time</literal> for format) when the
          databases should be dumped.
          The default is to update at 01:15 (at night) every day.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.clearLogs = {
      enable = true;
      description = "Clear old logs service.";
      wantedBy = [ "multi-user.target" ];

      script = ''
        journalctl --vacuum-time=30d
      '';

      serviceConfig = { Type = "oneshot"; };

      startAt = cfg.startAt;
    };
  };
}
