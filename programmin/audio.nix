{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    tcp = {
        enable = true;
        anonymousClients = {
            allowAll = true;
            allowedIpRanges = [ "127.0.0.1" "192.168.1.0/24" ];
        };
    };
    zeroconf.publish.enable = true;
    daemon.logLevel = "debug";
  };

  services.avahi = {
    enable = true;
  };
}