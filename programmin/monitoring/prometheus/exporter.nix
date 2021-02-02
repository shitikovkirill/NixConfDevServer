{ config, pkgs, ... }:
let
  allowed = ([ 9100 ]
    ++ (if config.services.nginx.enable then [ 9113 ] else [ ])
    ++ (if config.services.postfix.enable then [ 9154 ] else [ ]));
in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = allowed;
  };

  services.prometheus.exporters = {
    node = { enable = true; };
    nginx = {
      enable = (if config.services.nginx.enable then true else false);
    };
    postfix = {
      enable = (if config.services.postfix.enable then true else false);
      systemd.enable = true;
      showqPath = /var/lib/postfix/queue/public/showq;
      group = "postfix";
    };
  };
}
