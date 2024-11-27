{ pkgs, inputs, ... }:
let
  lib = pkgs.lib;

  contrast = 0;
  wallpaper = ../wallpapers/lain_lucy.jpg;
  format = "strip";
  variant = "light";

  generatedJSON =
    with pkgs;
    runCommandLocal "palette.json" { buildInputs = [ inputs.matugen.packages.${system}.default ]; } ''
      matugen image ${wallpaper} \
      --contrast ${lib.strings.floatToString contrast} \
      -m ${variant} \
      -j ${format} \
      -q > $out
    '';
  colors = (lib.importJSON generatedJSON).colors.${variant};
in
{
  inherit colors wallpaper;
}
