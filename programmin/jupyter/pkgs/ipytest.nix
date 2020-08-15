{ stdenv, buildPythonPackage, fetchPypi, ipython, pytest, packaging }:

buildPythonPackage rec {
  pname = "ipytest";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b3sb2a80y21vbcgk3abb1x1ip2wxxmg4sx4s6bdhd7xvmbbpp3j";
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
