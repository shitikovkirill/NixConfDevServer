{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nodejs yarn rsync ];

  ### Need for install global pacages to custom dir
  home-manager.users.root = {
    home.file.".npmrc".source = ./dotfiles/npm/npmrc;
  };
}
