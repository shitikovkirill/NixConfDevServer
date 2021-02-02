{ config, pkgs, ... }:
let vars = import ../../../variables.nix;
in with vars; {
  imports = [ ./service.nix ./exporter.nix ];

  services.devMetrics = {
    enable = true;
    domain = mainDomain;
    nodeTargets = [ "localhost:9100" "dev.server:9100" ];
    nginxTargets = [ "localhost:9113" "dev.server:9113" ];
    postfixTargets = [ "localhost:9154" "dev.server:9154" ];
    rabbitmqTargets = [ "localhost:15692" ];
    postgresTargets = [ "localhost:9187" ];
  };
}
