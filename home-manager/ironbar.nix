{
  style,
  config,
  ...
}:
{
  systemd.user.services.ironbar-restart = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Unit = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
      Description = "ironbar";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
      X-Restart-Triggers = [
        "${config.xdg.configFile."ironbar/config.json".source}"
        "${config.xdg.configFile."ironbar/style.css".source}"
      ];
    };

    Service = {
      ExecStart = "${config.programs.ironbar.package}/bin/ironbar";
      Restart = "always";
      RestartSec = "10";
    };
  };

  programs.ironbar = {
    enable = true;
    config = {
      anchor_to_edges = true;
      position = "top";
      height = 12;
      icon_theme = "oomox-gruvbox-dark";
      start = [
        {
          type = "workspaces";
          name_map = {
            "1" = "一";
            "2" = "ニ";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = " ";
          };
        }
      ];
      center = [
        {
          type = "clock";
          format = "%H:%M";
          format_popup = "%m/%d/%Y %H:%M:%S";
        }
      ];
      end = [
        { type = "volume"; }
        {
          type = "tray";
          icon_size = 32;
        }
        {
          type = "upower";
          format = "{percentage}%";
        }
      ];
    };
    style =
      with style.colors;
      "
      @define-color color_bg #${surface};
      @define-color color_bg_dark #${surface_variant};
      @define-color color_border #${outline};
      @define-color color_border_active #${primary};
      @define-color color_border_active_text #${on_primary};
      @define-color color_text #${on_surface};
      @define-color color_urgent #${tertiary};

      
      /* -- base styles -- */

      * {
        font-family: Roboto, sans-serif;
	      font-size: 10px;
        border: none;
        border-radius: 15px;
        min-width: 1rem;
      }

      box, menubar, button {
        background-color: @color_bg;
        background-image: none;
        box-shadow: none;
      }

      button, label {
        color: @color_text;
        padding-left: 0.4rem;
        padding-right: 0.4rem;
	      padding-top: 6px;
	      padding-bottom: 6px;
      }

      button:hover {
        background-color: @color_bg_dark;
      }

      .popup {
        border: 1px solid @color_border;
        padding: 1em;
      }

      /* -- clock -- */

      .clock {
        border: none;
        font-weight: bold;
        margin-left: 5px;
      }

      .popup-clock .calendar-clock {
        color: @color_text;
        font-size: 1.5em;
        padding-bottom: 0.1em;
      }

      .popup-clock .calendar {
        background-color: @color_bg;
        color: @color_text;
      }

      .popup-clock .calendar .header {
        padding-top: 1em;
        border-top: 1px solid @color_border;
        font-size: 1.5em;
      }

      .popup-clock .calendar:selected {
        color: @color_border_active_text;
        background-color: @color_border_active;
      }

      /* -- music -- */

      .music:hover * {
        background-color: @color_bg_dark;
      }
·
      .popup-music .album-art {
        margin-right: 1em;
      }

      .popup-music .icon-box {
        margin-right: 0.4em;
      }

      .popup-music .title .icon, .popup-music .title .label {
        font-size: 1.7em;
      }

      .popup-music .controls *:disabled {
        color: @color_border;
      }

      .popup-music .volume .slider slider {
        border-radius: 100%;
      }

      .popup-music .volume .icon {
        margin-left: 4px;
      }

      .popup-music .progress .slider slider {
        border-radius: 100%;
      }

      /* -- script -- */

      .script {
        padding-left: 1rem;
        padding-right: 1rem;
      }

      /* -- sys_info -- */

      .sysinfo {
        margin-left: 10px;
      }

      .sysinfo .item {
        margin-left: 5px;
      }

      /* -- workspaces -- */
      .workspaces .item.focused {
        margin-left: inherit;
        background-color: @color_bg_dark;
      }

      /* -- focused -- */
      .focused {
        margin-left: 15px;
      }

      /* -- upower -- */
      .upower {
        padding-right: 1em;
      }
    ";
  };
}
