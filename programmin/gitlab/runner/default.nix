{ config, pkgs, ... }:
let cicd_pkgs = with pkgs; [ git git-crypt nixops ];
in {
  services.gitlab-runner = {
    enable = true;
    services.local = {
      executor = "shell";
      debugTraceDisabled = true;
      cloneUrl = "http://127.0.0.1";
      registrationConfigFile = ./registrationSecret;
      tagList = [ "nix-shell" ];
    };
    extraPackages = cicd_pkgs;
  };

  environment.systemPackages = cicd_pkgs;

  programs.ssh.extraConfig = "StrictHostKeyChecking=no";

  systemd.services.gitlab-runner.serviceConfig.DynamicUser =
    pkgs.lib.mkForce false;
  systemd.services.gitlab-runner.serviceConfig.User = pkgs.lib.mkForce "root";
}
