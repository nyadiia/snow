{ lib
, stdenv
, fetchzip
, libusb1
, glibc
, libGL
, xorg
, makeWrapper
, qtx11extras
, wrapQtAppsHook
, autoPatchelfHook
, libX11
, libXtst
, libXi
, libXrandr
, libXinerama
}:

let
  dataDir = "var/lib/xppendlw";
in
stdenv.mkDerivation rec {
  pname = "xp-pen-deco-lw-driver";
  version = "3.4.9-240131";

  src = fetchzip {
    #url = "https://www.xp-pen.com/download/file/id/1936/pid/440/ext/gz.html#.tar.gz";
    url = "https://download01.xp-pen.com/file/2024/04/XPPenLinux${version}.tar.gz";
    name = "XPPenLinux${version}.tar.gz";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    autoPatchelfHook
    makeWrapper
  ];

  dontBuild = true;

  dontWrapQtApps = true; # this is done manually

  buildInputs = [
    libusb1
    libX11
    libXtst
    libXi
    libXrandr
    libXinerama
    glibc
    libGL
    stdenv.cc.cc.lib
    qtx11extras
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{opt,bin}
    cp -r App/usr/lib/pentablet/{PenTablet,resource.rcc,conf} $out/opt
    chmod +x $out/opt/PenTablet
    cp -r App/lib $out/lib
    # sed -i 's#usr/lib/pentablet#${dataDir}#g' $out/opt/PenTablet

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/PenTablet $out/bin/xp-pen-deco-lw-driver \
      "''${qtWrapperArgs[@]}" \
      --run 'if [ "$EUID" -ne 0 ]; then echo "Please run as root."; exit 1; fi' \
      --run 'if [ ! -d /${dataDir} ]; then mkdir -p /${dataDir}; cp -r '$out'/opt/conf /${dataDir}; chmod u+w -R /${dataDir}; fi'
  '';

  meta = with lib; {
    homepage = "https://www.xp-pen.com/product/461.html";
    description = "Drivers for the XP-PEN Deco 01 v2 drawing tablet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ virchau13 ];
    license = licenses.unfree;
  };
}
