{ config, pkgs, ... }:

{
  networking.hostName = "dev.server";
  services.openssh = { enable = true; };
}
