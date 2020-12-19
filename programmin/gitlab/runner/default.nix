{ config, pkgs, ... }:
{
  services.gitlab-runner = {
    enable = true;
    services.local = {
      executor = "shell";
      registrationConfigFile = ./registrationSecret;
    };
  };

  networking.hosts = { "127.0.0.1" = [ "gitlab.server" ]; };
}
