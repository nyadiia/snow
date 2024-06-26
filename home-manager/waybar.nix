{ pkgs, lib, ... }:
{
  home.packages = with pkgs; lib.mkAfter [ wttrbar ];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
            * {
              border: none;
              border-radius: 0;
              font-family: 'FiraCode Nerd Font';
              font-size: 12px;
            }
            
            window#waybar {
              background: transparent;
            }
            
            window#waybar.hidden {
              opacity: 0.2;
            }

            tooltip {
              border: 2px solid #f5c2e7;
              border-radius: 15px;
              background-color: rgba(17, 17, 27, 0.8);
              padding: 10px;
      	margin: 10px;
            }
            
            #workspaces {
              border-style: solid;
              border-width: 2px 0px 2px 2px;
      	border-color: #f5c2e7;
              border-radius: 20px 0px 0px 20px;
              padding-left: 5px;
              transition: none;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #workspaces button {
              transition: ease-out;
              transition-duration: 0.1s;
              color: #6c7086;
              background: transparent;
              padding-left: 5px;
              padding-right: 5px;
            }
            #workspaces button.persistent {
              color: #6c7086;
            }
            /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
            #workspaces button:hover {
              box-shadow: inherit;
              text-shadow: inherit;
              transition: ease-in;
              transition-duration: 0.1s;
              color: #f5c2e7;
            }
            
            #workspaces button.active {
              color: #ea76cb;
            }
            
            #workspaces button.urgent {
              color: #d20f39;
            }
            
            #window {
              border-style: solid;
              border-width: 2px 2px 2px 0px;
      	border-color: #f5c2e7;
              border-radius: 0px 20px 20px 0px;
              margin-right: 3px;
              padding-left: 5px;
              padding-right: 10px;
              transition: none;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #submap {
              padding-left: 5px;
              padding-right: 5px;
              margin-right: 3px;
              border-radius: 20px;
              transition: none;
              background: #f38ba8;
              color: #313244;
            }
            
            #clock {
              border-style: solid;
              border-width: 2px;
      	border-color: #f5c2e7;
              border-radius: 20px;
              padding-left: 10px;
              padding-right: 10px;
              transition: none;
              color: #ffffff;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #custom-weather {
              border-style: solid;
              border-width: 2px 2px 2px 0px;
      	border-color: #f5c2e7;
              border-radius: 0px 20px 20px 0px;
              padding-right: 10px;
              padding-left: 5px;
              transition: none;
              color: #ffffff;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #pulseaudio {
              border-style: solid;
              border-width: 2px 0px 2px 2px;
      	border-color: #f5c2e7;
              border-radius: 20px 0px 0px 20px;
              padding-left: 10px;
              padding-right: 5px;
              transition: ease-in;
              transition-duration: 0.2s;
              color: white;
              background: #ff4879;
            }
            
            #pulseaudio.muted {
              background-color: rgba(17, 17, 27, 0.8);
              color: #ffffff;
            }
            
            #idle_inhibitor {
              border-radius: 15px 0px 0px 15px;
              padding-left: 10px;
              padding-right: 5px;
              transition: ease-in;
              transition-duration: 0.1s;
              color: white;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #idle_inhibitor.activated {
              background-color: #ff4879;
            }
            
            #bluetooth {
              padding-left: 5px;
              transition: none;
              color: #ffffff;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #network {
              padding-left: 5px;
              padding-right: 5px;
              transition: none;
              color: #ffffff;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #battery {
              border-style: solid;
              border-width: 2px 2px 2px 0px;
      	border-color: #f5c2e7;
              border-radius: 0px 20px 20px 0px;
              padding-left: 5px;
              padding-right: 10px;
              transition: none;
              color: white;
              background: rgba(17, 17, 27, 0.8);
            }
            
            #battery.charging {
              color: #313244;
              background-color: #f38ba8;
            }
            
            #battery.warning:not(.charging) {
              background-color: #cba6f7;
              color: #313244;
            }
            
            @keyframes blink {
              to {
                background-color: #11111b;
                color: #f38ba8;
              }
            }
            
            #battery.critical:not(.charging) {
              background-color: #f38ba8;
              color: #313244;
              animation-name: blink;
              animation-duration: 0.2s;
              animation-timing-function: linear;
              animation-iteration-count: infinite;
              animation-direction: alternate;
            }
    '';
    settings = [
      {
        height = 36;
        layer = "top";
        position = "top";
        margin = "3 3 0 3";
        modules-center = [
          "clock"
          "custom/weather"
        ];
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
          "hyprland/submap"
        ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
        ];
        "hyprland/window" = {
          seperate-outputs = true;
        };
        #      "custom/weather" = {
        #        format = "{}°";
        #        tooltip = true;
        #        interval = 3600;
        #        exec = "wttrbar --location Minneapolis";
        #        return-type = "json";
        #      };
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% ";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-plugged = "{capacity}% ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'>{}</span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        network = {
          interval = 1;
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ifname}: {ipaddr}/{cidr}   up: {bandwidthUpBits} down: {bandwidthDownBits}";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%) ";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [
              ""
              ""
              ""
            ];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
      }
    ];
  };
}
