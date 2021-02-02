{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "tabulate";
  version = "0.8.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01shi7bmj09f0bcm5s0c9skys063lzp76p0n4a2xmg041ni269yv";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/tabulate/";
    description =
      "Pretty-print tabular data in Python, a library and a command-line utility.";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kirill ];
  };
}
