let
  jupyter = import (builtins.fetchGit {
    url = "https://github.com/tweag/jupyterWith";
    rev = "35eb565c6d00f3c61ef5e74e7e41870cfa3926f7";
  }) { };

  iPython = jupyter.kernels.iPythonWith {
    name = "python";
    packages = p: with p; [ numpy ];
  };

  iHaskell = jupyter.kernels.iHaskellWith {
    name = "haskell";
    packages = p: with p; [ hvega formatting ];
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith { kernels = [ iPython iHaskell ]; };
in jupyterEnvironment.env
