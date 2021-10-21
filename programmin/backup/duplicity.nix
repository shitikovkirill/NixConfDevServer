{ pkgs, ... }:

{
  services.duplicity = {
    root = "/home/kirill";
    enable = true;
    include = [
        "/var/lib/jupyterlab"
    ];
    targetUrl = "file:///var/backup/duplicity";
    frequency = "weeks";
  };
}