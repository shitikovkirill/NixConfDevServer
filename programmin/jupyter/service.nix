{ config, lib, pkgs, ... }:
with lib;
let cfg = config.services.devJupyter;
in {
  imports = [ ./service ];
  options = {
    services.devJupyter = {
      enable = mkOption {
        default = false;
        description = ''
          Enable service.
        '';
      };

      https = mkOption {
        default = false;
        description = ''
          Enable https.
        '';
      };

      domain = mkOption {
        type = types.str;
        description = "domain";
      };

      password = mkOption {
        type = types.str;
        default =
          "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'"; # test
        description = "domain";
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedProxySettings = true;
      virtualHosts."${cfg.domain}" = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
        locations = {
          "/" = {
            proxyPass = "http://localhost:8888";
            proxyWebsockets = true;
          };
        };
      };
    };

    services.jupyterlab = {
        enable = true;
        password = cfg.password;
        ip = "0.0.0.0";
        notebookDir = "/var/lib/jupyter";
    };

    services.jupyter = {
      enable = false;
      password = cfg.password;
      ip = "0.0.0.0";
      kernels = {
        sqlalchemy = let
          env = (pkgs.python3.withPackages (pythonPackages:
            with pythonPackages; [
              ipykernel
              ipdb
              sqlalchemy
            ]));
        in {
          displayName = "Sqlalchemy";
          argv = [
            "${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
        };
        machineLearning = let
          env = (pkgs.python3.withPackages (pythonPackages:
            with pythonPackages; [
              ipykernel
              pandas
              scikitlearn
            ]));
        in {
          displayName = "Python 3 for machine learning";
          argv = [
            "${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
        };
        asyncaio  = with pkgs; with python38Packages; let
          ipytest = callPackage ./pkgs/ipytest.nix {};
          env = (pkgs.python3.withPackages (pythonPackages:
            with pythonPackages; [
              ipykernel
              ipdb
              asynctest
              ipytest
            ]));
        in {
          displayName = "Asyncaio";
          argv = [
            "${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
        };
      };
    };
  };
}
