{ pkgs, unstable, ... }:

{
  programs = {
    kitty.enable = true;
    waybar.enable = true;
  };

  home.packages =
    with pkgs;
    lib.mkAfter [
      autotiling
      swayosd
    ];

  wayland.windowManager.sway = {
    enable = true;
    package = unstable.swayfx;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;

    extraSessionCommands = ''
      _JAVA_AWT_WM_NONREPARENTING=1
      XDG_SESSION_TYPE=wayland
      XDG_SESSION_DESKTOP=sway
      XDG_CURRENT_DESKTOP=sway
      QT_QPA_PLATFORM=wayland
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      CLUTTER_BACKEND=wayland
      SDL_VIDEODRIVER=wayland
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
    '';
    config = {
      # super key
      modifier = "Mod4";

      bars = [ { command = "waybar"; } ];

      #      output = {
      #        "*".background = "~/Pictures/wallpaper.png fill";
      #      };

      startup = [ { command = "autotiling"; } ];

      keybindings =
        let
          mod = "Mod4";
          term = "kitty";
          app-menu = "nwggrid";
          power-menu = "nwgbar";
        in
        {
          "${mod}+Return" = "exec ${term}";
          "${mod}+d" = "exec ${app-menu}";
          "${mod}+Escape" = "exec ${power-menu}";
          "${mod}+Shift+q" = "kill";
          # Reload the configuration file
          "${mod}+Shift+c" = "reload";
          # Screenshot
          "${mod}+g" = "exec wayshot";
          # Exit sway (logs you out of your Wayland session)
          "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
          # Move your focus around
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          # Or use $mod+[up|down|left|right]
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";
          # Move the focused window with the same, but add Shift
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          # Ditto, with arrow keys
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";
          # Switch to workspace
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";
          # Move focused container to workspace
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";
          # Layout
          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          # Switch the current container between different layout styles
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";
          # Make the current focus fullscreen
          "${mod}+f" = "fullscreen";
          # Toggle the current focus between tiling and floating mode
          "${mod}+Shift+space" = "floating toggle";
          # Swap focus between the tiling area and the floating area
          "${mod}+space" = "focus mode_toggle";
          # Move focus to the parent container
          "${mod}+a" = "focus parent";
          # Scratchpad:
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";
          "${mod}+r" = "mode \"resize\"";
          # Audio
          "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          # Sink volume raise optionally with --device
          "XF86AudioRaiseVolume" = "exec ${pkgs.swayosd} --output-volume raise";
          # Sink volume lower optionally with --device
          "XF86AudioLowerVolume" = "exec ${pkgs.swayosd} --output-volume lower";
          # Sink volume toggle mute
          "XF86AudioMute" = "exec ${pkgs.swayosd} --output-volume mute-toggle";
          # Source volume toggle mute
          "XF86AudioMicMute" = "exec ${pkgs.swayosd} --input-volume mute-toggle";
          # Brightness raise
          "XF86MonBrightnessUp" = "exec ${pkgs.swayosd} --brightness raise";
          # Brightness lower
          "XF86MonBrightnessDown" = "exec ${pkgs.swayosd} --brightness lower";
        };
    };

    # SwayFX settings
    extraConfig = ''
      shadows enable
      blur_radius 7
      blur_passes 4
    '';
  };
}
