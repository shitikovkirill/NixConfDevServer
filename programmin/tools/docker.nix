{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ docker ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  users.users.kirill.extraGroups = [ "docker" ];

  programs.zsh = { ohMyZsh = { plugins = [ "docker" "docker-compose" ]; }; };

  environment.shellAliases = {
    drmc = "docker rm $(docker ps -a -q)";
    drimage = "docker rmi $(docker images -q)";
    drvolume = "docker volume rm $(docker volume ls -q --filter dangling=true)";
    drnetwork = "docker network prune";
    dstopc = "docker stop $(docker ps -aq)";
    dstopc_with_restart_always =
      "docker stop $(docker ps -a -q) & docker update --restart=no $(docker ps -a -q) & systemctl restart docker";
    dnorestart = "docker update --restart=no $(docker ps -aq)";
    dhist = "docker history --no-trunc";
  };
}
