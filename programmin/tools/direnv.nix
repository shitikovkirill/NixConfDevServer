{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ direnv nix-direnv ];

  programs = {
    bash.interactiveShellInit = ''
      if [ -x "$(command -v direnv)" ]; then
          eval "$(direnv hook bash)"
      fi
    '';
    zsh = lib.mkIf (config.programs.zsh.enable) {
      shellInit = ''
        if [ -x "$(command -v direnv)" ]; then
            eval "$(direnv hook zsh)"
        fi
      '';
    };
  };

  # nix options for derivations to persist garbage collection
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  environment.pathsToLink = [ "/share/nix-direnv" ];
}
