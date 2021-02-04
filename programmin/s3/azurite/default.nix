{ config, lib, pkgs, ... }: {
  imports = [ ./service.nix ];

  environment.systemPackages = with pkgs; [ docker ];

  services.azurite = { enable = true; };
}
