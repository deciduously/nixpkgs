{ lib, mkDerivation, fetchFromGitHub
, pkg-config, cmake, alsa-lib, libjack2, dbus, qtbase, qttools, qtx11extras
# Enable jack session support
, jackSession ? false
}:

mkDerivation rec {
  version = "0.9.5";
  pname = "qjackctl";

  # some dependencies such as killall have to be installed additionally

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "qjackctl";
    rev = "${pname}_${lib.replaceChars ["."] ["_"] version}";
    sha256 = "sha256-20oy3R0gbVXO3Da80cTYXu+BG8OfVNRLtAwHk8nRFJk=";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    alsa-lib
    libjack2
    dbus
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DCONFIG_JACK_VERSION=1"
    "-DCONFIG_JACK_SESSION=${toString jackSession}"
  ];

  meta = with lib; {
    description = "A Qt application to control the JACK sound server daemon";
    homepage = "https://github.com/rncbc/qjackctl";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
