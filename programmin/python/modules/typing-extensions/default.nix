{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "typing-extensions";
  version = "3.7.4.3";

  src = fetchPypi {
    pname = "typing_extensions";
    inherit version;
    sha256 = "0356ljrrplm917dqgpn8wjkw6j3mpp916gwxas7jhc3xc4xhgm4r";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/typing-extensions/";
    description =
      "Typing Extensions – Backported and Experimental Type Hints for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
