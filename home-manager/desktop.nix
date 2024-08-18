{
  pkgs,
  unstable,
  inputs,
  ...
}:

{
  imports = [
    ./common.nix
    ./firefox.nix
    ./vscode.nix
    ./hyprland.nix
  ];

  home = {

    pointerCursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
      x11 = {
        enable = true;
        defaultCursor = "Adwaita";
      };
    };

    sessionVariables = {
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";

      NIXOS_OZONE_WL = "1";
      XDG_SESSION_TYPE = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };

    packages =
      (with pkgs; [
        mpv
        obsidian
        spotify
        nixpkgs-fmt
        vesktop
        (pkgs.writeShellScriptBin "discord" ''
          exec ${pkgs.vesktop}/bin/vencorddesktop --enable-features=UseOzonePlatform --ozone-platform=wayland
        '')
        tigervnc
        prismlauncher
        swww
        playerctl
        tofi
        wl-clipboard
        libnotify
        pavucontrol
        qalculate-gtk
        gnome.file-roller
        inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        ffmpeg

        octaveFull
      ])
      ++ (with pkgs.octavePackages; [
        symbolic
        io
        ocl
        linear-algebra
        matgeom
        general
        audio
        fuzzy-logic-toolkit
        control
      ]);
  };
}
