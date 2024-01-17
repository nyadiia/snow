{ inputs, pkgs, ... }:
{
  imports = [
    ./swaylock.nix
    ./mako.nix
    ./waybar.nix
    ./kitty.nix
    ./gtk.nix
    ./fuzzel.nix
  ];
  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland; 
    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
	"wl-paste --type text --watch cliphist store" #Stores only text data
	"wl-paste --type image --watch cliphist store" #Stores only image data
        "swww init"
	"mako"
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
      };

      general = {
	layout = "dwindle";

	gaps_in     = 3;
	gaps_out    = 3;
	border_size = 2;

	"col.active_border"   = "rgb(f5c2e7)";
	"col.inactive_border" = "rgba(585b70aa)";
      };
      bezier = "ease-out,0.165,0.84,0.44,1";
      animations = {
        animation = [
	  "workspaces,1,3,ease-out"
	  "windows,1,3,ease-out"
	  "windowsOut,1,3,ease-out"
	];
      };
      decoration = {
        rounding = "10";
	blur = {
	  enabled = true;
	  passes = "3";
	};
	drop_shadow = false;
        shadow_range = "10";
        shadow_render_power = "3";
        "col.shadow" = "rgba(1a1a1aee)";
      };

      "$mod" = "SUPER";
      "$term" = "kitty";
      bind =
        [
          "$mod, W, exec, firefox"
          "$mod, N, exec, thunar"
	  "$mod, D, exec, fuzzel"
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
        ]
        ++ (
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
	  )
       10)
       );
      # works even when locked
      bindl = [
        # doesn't work with fingerprint enabled
        # ",switch:Lid Switch, exec, swaylock"

	# audio
	",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
      
      # works while locked and repeats when held
      bindel = [
	# audio
	",XFAudioRaiseVolume, exec, wpctl set-vol @DEFAULT_AUDIO_SINK@ 5%+"
	",XFAudioLowerVolume, exec, wpctl set-vol @DEFAULT_AUDIO_SINK@ 5%-"

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
