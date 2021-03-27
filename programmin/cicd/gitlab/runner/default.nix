{ config, pkgs, ... }:
let
  cicd_pkgs = with pkgs; [ git git-crypt nixops ];
  config = import ./load-config.nix;
in {
  services.gitlab-runner = {
    enable = true;
    services = config.services;
    extraPackages = cicd_pkgs;
  };

  environment.systemPackages = cicd_pkgs;

  programs.ssh.extraConfig = "StrictHostKeyChecking=no";

  systemd.services.gitlab-runner.serviceConfig = lib.mkIf config.asRoot {
    DynamicUser = pkgs.lib.mkForce false;
    User = pkgs.lib.mkForce "root";
  };
}
