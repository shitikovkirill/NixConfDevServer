{ config, pkgs, ... }:
{
  services.gitlab-runner = {
    enable = true;
    services.local.registrationConfigFile = ./registrationSecret;
  };

  networking.hosts = { "127.0.0.1" = [ "gitlab.server" ]; };
}
