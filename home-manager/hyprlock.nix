{
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.08;
          brightness = 0.8;
          contrast = 1.4;
          vibrancy = 0.3;
          vibrancy_darkness = 0.5;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          text_align = "center"; # center/right or any value for default left. multi-line text alignment inside label container
          color = "rgb(200, 200, 200)";
          font_size = 96;
          font_family = "CozetteVector";

          position = "0, 80";
          halign = "center";
          valign = "center";
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
          font_color = "rgb(212, 190, 152)";
          inner_color = "rgb(29, 32, 33)";
          outer_color = "rgb(212, 190, 152)";
          outline_thickness = 1;
          rounding = "-1";
          placeholder_text = "pwease say the magic words";
        }
      ];
    };
  };
}
