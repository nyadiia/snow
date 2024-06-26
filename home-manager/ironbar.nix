{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs.ironbar = {
    enable = true;
    config = {
      anchor_to_edges = true;
      position = "top";
      height = 20;
      icon_theme = "oomox-gruvbox-dark";
      start = [
        {
          type = "workspaces";
          name_map = {
            "9" = "";
            "10" = "󰙯";
          };
        }
        {
          type = "focused";
          show_icon = false;
          show_title = true;
          icon_size = 32;
          truncate = "end";
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
          type = "sys_info";
          format = [ " {cpu_percent}% | {temp_c:coretemp-Package-id-0}°C" ];
          interval = {
            cpu = 1;
          };
        }
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
    style = "
      @define-color color_bg #282828;
      @define-color color_bg_dark #1d2021;
      /* @define-color color_border #d65d0e; */
      @define-color color_border #ebdbb2;
      @define-color color_border_active #fe8019;
      @define-color color_text #ebdbb2;
      @define-color color_urgent #fb4934;
      /* -- base styles -- */

      * {
          font-family: FiraCode Nerd Font, sans-serif;
          font-size: 12px;
          border: none;
          border-radius: 0;
          min-width: 1rem;
      }

      box, menubar, button {
          background-color: @color_bg;
          background-image: none;
          box-shadow: none;
      }

      button, label {
          color: @color_text;
          padding-left: 0.6rem;
          padding-right: 0.6rem;
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
          background-color: @color_border_active;
      }

      /* -- music -- */

      .music:hover * {
          background-color: @color_bg_dark;
      }

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
          box-shadow: inset 0 -3px @color_border_active;
          background-color: @color_bg_dark;
      }

      .workspaces .item:hover {
          box-shadow: inset 0 -3px @color_border_active;
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
