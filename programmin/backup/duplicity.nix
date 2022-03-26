{ pkgs, ... }:

{
  services.duplicity = {
    enable = true;
    root = "/var/lib/jupyterlab";
    targetUrl = "file:///var/backup/duplicity";
    frequency = "weeks";
  };
}
