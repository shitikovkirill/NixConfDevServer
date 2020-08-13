{ stdenv
, buildPythonPackage
, fetchPypi
, ipython
, isPyPy
}:

buildPythonPackage rec {
  pname = "ipytest";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y3yk5k2yszcwxsjinvf40b1wl8wi8l6kv7pl9jmx9j53hk6vx61";
  };

  propagatedBuildInputs = [ ipython pytest packaging ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/chmp/ipytest";
    description = "Unit tests in IPython notebooks";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };

}
