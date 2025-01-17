{ lib
, buildPythonPackage
, python
, fetchPypi
, pythonOlder
, django
, djangorestframework
, mock
, isort
, isPy3k
}:

buildPythonPackage rec {
  pname = "django-taggit";
  version = "1.5.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5bb62891f458d55332e36a32e19c08d20142c43f74bc5656c803f8af25c084a";
  };

  propagatedBuildInputs = [ isort django djangorestframework ];

  checkInputs = [ mock ];
  checkPhase = ''
    # prove we're running tests against installed package, not build dir
    rm -r taggit
    # Replace directory of locale
    substituteInPlace ./tests/test_utils.py \
      --replace 'os.path.dirname(__file__), ".."' "\"$out/lib/python${lib.versions.majorMinor python.version}/site-packages/\""
    ${python.interpreter} -m django test --settings=tests.settings
  '';

  meta = with lib; {
    description = "django-taggit is a reusable Django application for simple tagging";
    homepage = "https://github.com/alex/django-taggit/tree/master/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
