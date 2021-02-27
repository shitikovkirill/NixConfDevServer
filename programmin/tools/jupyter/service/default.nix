{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.jupyterlab;

  jupyterWith = let
    jupyterWithSrc = pkgs.fetchFromGitHub {
      owner = "tweag";
      repo = "jupyterWith";
      rev = "35eb565c6d00f3c61ef5e74e7e41870cfa3926f7";
      sha256 = "15zpprs0blvlvbqapkyn92x6dpfa6va2xz25v24z67lqs96ii4jm";
    };
  in import jupyterWithSrc { };

  pythonModulePath = ../../../languages/python/modules;

  iPythonDataScience = jupyterWith.kernels.iPythonWith {
    name = "pythonDataScience";
    packages = p:
      with p; [
        numpy
        scipy
        pandas
        matplotlib
        seaborn
        umap-learn
        scikitlearn
      ];
  };

  iPythonAsync = jupyterWith.kernels.iPythonWith {
    name = "pythonAsync";
    packages = p: with p; [ ipdb asynctest ];
  };

  iPythonSql = jupyterWith.kernels.iPythonWith {
    name = "pythonSqlalchemy";
    packages = p:
      let
        tabulate = pkgs.callPackage (pythonModulePath + "/tabulate") {
          buildPythonPackage = p.buildPythonPackage;
          fetchPypi = p.fetchPypi;
        };
      in with p; [ ipdb sqlalchemy psycopg2 tabulate faker ];
  };

  iPythonPika = jupyterWith.kernels.iPythonWith {
    name = "pythonPika";
    packages = p:
      let
        pika = pkgs.callPackage (pythonModulePath + "/pika") {
          buildPythonPackage = p.buildPythonPackage;
          fetchPypi = p.fetchPypi;
        };
        aio-pika = pkgs.callPackage (pythonModulePath + "/aio-pika") {
          buildPythonPackage = p.buildPythonPackage;
          fetchPypi = p.fetchPypi;
        };
      in [ pika aio-pika ];
  };

  gophernotes = jupyterWith.kernels.gophernotes { name = "Go"; };

  iNix = jupyterWith.kernels.iNixKernel { name = "Nix"; };

  iJavascript = jupyterWith.kernels.iJavascript { name = "JavaScript"; };

  iAnsibleKernel = jupyterWith.kernels.ansibleKernel { name = "Ansible"; };

  jupyterlabPackage = lib.makeOverridable jupyterWith.jupyterlabWith {
    kernels = [
      iPythonDataScience
      iPythonAsync
      iPythonSql
      iPythonPika
      gophernotes
      iNix
      # iJavascript
      iAnsibleKernel
    ];
  };

in {
  meta.maintainers = with maintainers; [ ];

  options.services.jupyterlab = {
    enable = mkEnableOption "JupyterLab server";

    package = mkOption {
      default = jupyterlabPackage;
      type = types.package;
      defaultText = "jupyterWith.jupyterlabWith {}";
      example = "jupyterWith.jupyterlabWith { kernels = [ ipython ]; }";
    };

    ip = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        IP address Jupyterlab will be listening on.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8888;
      description = ''
        Port number Jupyterlab will be listening on.
      '';
    };

    notebookDir = mkOption {
      type = types.str;
      default = "/var/lib/jupyterlab";
      description = ''
        Root directory for notebooks.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "jupyterlab";
      description = ''
        Name of the user used to run the jupyterlab service.
        For security reason, jupyterlab should really not be run as root.
        If not set (jupyterlab), the service will create a jupyterlab user with appropriate settings.
      '';
      example = "me";
    };

    group = mkOption {
      type = types.str;
      default = "jupyterlab";
      description = ''
        Name of the group used to run the jupyterlab service.
        Use this if you want to create a group of users that are able to view the notebook directory's content.
      '';
      example = "users";
    };

    password = mkOption {
      type = types.str;
      description = ''
        Password to use with notebook.
        Can be generated using:
          In [1]: from notebook.auth import passwd
          In [2]: passwd('test')
          Out[2]: 'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'
          NOTE: you need to keep the single quote inside the nix string.
        Or you can use a python oneliner:
          "open('/path/secret_file', 'r', encoding='utf8').read().strip()"
        It will be interpreted at the end of the notebookConfig.
      '';
      example = [
        "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'"
        "open('/path/secret_file', 'r', encoding='utf8').read().strip()"
      ];
    };

    notebookConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Raw jupyterlab config.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Additional command line flags to be passed to jupyter-lab.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.jupyterlab = {
        description = "JupyterLab server";

        after = [ "network.target" ];
        before = [ "nginx.service" ];
        wantedBy = [ "multi-user.target" ];

        path = [ pkgs.bash ];

        serviceConfig = {
          Restart = "always";
          RestartSec = 10;
          ExecStart = let
            notebookConfigFile = pkgs.writeText "jupyter_notebook_config.py" ''
              ${cfg.notebookConfig}
              c.NotebookApp.password = ${cfg.password}
            '';
            args = [
              "--no-browser"
              "--ip=${cfg.ip}"
              "--port=${toString cfg.port}"
              "--port-retries=0"
              "--notebook-dir=${cfg.notebookDir}"
              "--NotebookApp.config_file=${notebookConfigFile}"
            ] ++ cfg.extraFlags;
          in "${cfg.package}/bin/jupyter-lab ${
            concatMapStringsSep " \\\n" escapeShellArg args
          }";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "~";
        };
      };
    })

    (mkIf (cfg.enable && (cfg.group == "jupyterlab")) {
      users.groups.jupyterlab = { };
    })
    (mkIf (cfg.enable && (cfg.user == "jupyterlab")) {
      users.extraUsers.jupyterlab = {
        extraGroups = [ cfg.group ];
        home = "/var/lib/jupyterlab";
        createHome = true;
        useDefaultShell = true; # needed so that the user can start a terminal.
      };
    })
  ];
}
