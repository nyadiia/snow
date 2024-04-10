{ inputs, pkgs, ... }:
{
  imports = [
    ./mako.nix
    ./ironbar.nix
    ./kitty.nix
    ./gtk.nix
    ./fuzzel.nix
  ];
  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    settings = {
      "$mod" = "SUPER";
      "$term" = "kitty";
      "$runner" = "fuzzel";
      "$browser" = "firefox";

      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "ironbar &"
	      "wl-paste --type text --watch cliphist store" #Stores only text data
	      "wl-paste --type image --watch cliphist store" #Stores only image data
        "swww init"
	      "mako &"
      ];
      exec = [
	      "swww img ~/Pictures/nge.jpg"
      ];

      monitor = [
        "eDP-1,preferred,auto,1.175"
        ",preferred,auto,auto"
      ];
      xwayland.force_zero_scaling = true;
      misc.vfr = true;

      input = {
        kb_layout = "us";
	      repeat_rate  = 50;
	      repeat_delay = 250;
	      touchpad.natural_scroll = true;
	      sensitivity = 0;
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = "3";
      };

      dwindle = {
        pseudotile = true;
      	preserve_split = true;
      	# no_gaps_when_only = 1;
      };

      workspace = "w[t1], bordersize:0, rounding:0, gapsout:0";

      general = {
      	layout = "dwindle";

      	gaps_in     = 3;
      	gaps_out    = 3;
      	border_size = 2;

      	"col.active_border"   = "rgb(ebdbb2)";
      	"col.inactive_border" = "rgb(1d2021)";
      };

      # bezier = "ease-out,0.165,0.84,0.44,1";
      animations = {
        enabled = false;
         #  animation = [
      	  #   "workspaces,1,3,ease-out"
      	  #   "windows,1,3,ease-out"
      	  #   "windowsOut,1,3,ease-out"
      	  # ];
      };

      decoration = {
        rounding = "3";
	      blur.enabled = false;
	      drop_shadow = false;
      };

      bind =
        [
          "$mod, W, exec, $browser"
          "$mod, N, exec, thunar"
	        "$mod, D, exec, $runner"
          ", Print, exec, grimblast copy area"
          "$mod, Print, exec, grimblast copy screen"
	        "$mod, Return, exec, $term"
	        "$mod, Q, killactive"
	        "$mod Shift, R, exec, hyprctl reload && pkill -USR2 waybar"
	        "$mod, P, pseudo" # dwindle
	        "$mod, E, togglesplit" # dwindle
	        "$mod Shift, Space, togglefloating"
	        "$mod, F, fullscreen"
	        "$mod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
	        # "$mod, L, exec, hyprlock"

	        # move focus
	        "$mod, Left, movefocus, l"
	        "$mod, Right, movefocus, r"
	        "$mod, Up, movefocus, u"
	        "$mod, Down, movefocus, d"

	        # move window
	        "$mod Shift, Left, movewindow, l"
	        "$mod Shift, Right, movewindow, r"
	        "$mod Shift, Up, movewindow, u"
	        "$mod Shift, Down, movewindow, d"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
  	      x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          ) 10)
        );
      # works while locked
      bindl = [
        # ",switch:Lid Switch, exec, hyprlock"

	      # audio
	      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];

      # works while locked and repeats when held
      bindel = [
	      # audio
	      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
	      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

	      # brightness
	      ",XF86MonBrightnessUp, exec, light -A 5"
	      ",XF86MonBrightnessDown, exec, light -U 5"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
      ];
    };
    extraConfig = ''
      bind = $mod, R, submap, resize

      submap = resize
      binde = , right, resizeactive, 20 0
      binde = , left, resizeactive, -20 0
      binde = , up, resizeactive, 0 -20
      binde = , down, resizeactive, 0 20
      bind = , escape, submap, reset
      submap = reset
    '';
  };
}
