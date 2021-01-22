{ config, pkgs, ... }: {
  services.gitlab-runner = {
    enable = true;
    services.local = {
      executor = "shell";
      debugTraceDisabled = true;
      cloneUrl = "http://127.0.0.1";
      registrationConfigFile = ./registrationSecret;
      tagList = [ "nix-shell" ];
    };
    extraPackages = with pkgs; [ git git-crypt nixops ];
  };

  programs.ssh.extraConfig = "StrictHostKeyChecking=no";

  systemd.services.gitlab-runner.serviceConfig.DynamicUser =
    pkgs.lib.mkForce false;
  systemd.services.gitlab-runner.serviceConfig.User = pkgs.lib.mkForce "root";
}
