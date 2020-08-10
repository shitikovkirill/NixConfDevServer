{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    if config.services.xserver.enable then [
      redis
      redis-desktop-manager
    ] else
      [ redis ];
}

