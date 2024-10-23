{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation {
  pname = "plymough-signalis-theme";
  version = "0-unstable-2024-05-26";

  src = ./signalis;

  dontBuilt = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/signalis
    cp * $out/share/plymouth/themes/signalis
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    runHook postInstall
  '';
}
