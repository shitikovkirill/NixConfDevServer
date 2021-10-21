{ pkgs, ... }:

{
  services.duplicity = {
    enable = true;
    include = [
        "/var/lib/jupyterlab"
    ];
    targetUrl = "file:///var/backup/duplicity";
    frequency = "weeks";
  };
}