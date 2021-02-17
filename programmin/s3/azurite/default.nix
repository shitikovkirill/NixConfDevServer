{ config, lib, pkgs, ... }: {
  imports = [ ./service.nix ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 10000 10001 ];
    };
  };

  environment.systemPackages = with pkgs; [ docker ];

  environment.shellAliases = {
    azurite =
      "docker run --rm --name=azurite -d --log-driver=journald -p '0.0.0.0:10000:10000' -p '0.0.0.0:10001:10001' -v 'azurite_blob:/data' mcr.microsoft.com/azure-storage/azurite azurite --blobHost 0.0.0.0 --queueHost 0.0.0.0";
  };
}
