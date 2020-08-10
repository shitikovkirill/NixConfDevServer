{ config, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ htop gotop nix-info ];
}
