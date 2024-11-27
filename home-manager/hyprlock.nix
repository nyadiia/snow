{ style, ... }:
{
  stylix.targets.hyprlock.enable = false;
  programs.hyprlock = with style.colors; {
    enable = true;
    settings = {
      background = [
        {
          path = "${style.wallpaper}";
          color = "rgb(${inverse_surface})";
          blur_passes = 3;
          blur_size = 8;
          noise = 8.0e-2;
          brightness = 0.8;
          contrast = 1.4;
          vibrancy = 0.3;
          vibrancy_darkness = 0.5;
        }
      ];

      label = [
        {
          monitor = "";
          text = ''
            cmd[update:1000] echo -e "$(date +%H)\n$(date +%M)"
          '';
          text_align = "center";
          color = "rgb(${inverse_primary})";
          font_size = 100;
          font_family = "Mononoki Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            Hai $USER! :3
          '';
          text_align = "center";
          color = "rgb(${inverse_primary})";
          font_size = 24;
          font_family = "Mononoki Nerd Font";
          position = "0, 250";
          halign = "center";
          valign = "bottom";
        }
      ];

      input-field = [
        {
          size = "400, 75";
          position = "0, 300";
          valign = "bottom";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_family = "Roboto";
          font_color = "rgb(${on_surface})";
          inner_color = "rgb(${surface})";
          outer_color = "rgb(${outline})";
          check_color = "rgb({${surface_variant}})";
          fail_color = "rgb(${error})";
          outline_thickness = 1;
          rounding = "-1";
          placeholder_text = "pwease say the magic words";
        }
      ];
    };
  };
}
