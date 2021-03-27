if builtins.pathExists ./config.nix then
  import ./config.nix
else {
  asRoot = false;
  services = {
    gitlab = {
      executor = "shell";
      debugTraceDisabled = true;
      registrationConfigFile = ./registrationSecretGitLab;
      tagList = [ "nix-shell" ];
    };
  };
}
