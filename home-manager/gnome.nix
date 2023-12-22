{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome.gnome-tweaks
    papirus-icon-theme

    gnomeExtensions.user-themes
    gnomeExtensions.dash-to-dock
    gnomeExtensions.fullscreen-avoider
    gnomeExtensions.blur-my-shell
    gnomeExtensions.caffeine
    gnomeExtensions.user-themes
    gnomeExtensions.openweather
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Orchis-Pink-Dark-Compact";
      package = pkgs.orchis-theme.override {
        tweaks = [ "macos" "black" "compact" ];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-seconds = true;
      gtk-theme = "Orchis-Pink-Dark-Compact";
    };
    "org/gnome/desktop/wm/preferences" = {
      theme = "Orchis-Pink-Dark-Compact";
      button-layout = "appmenu:minimize,maximize,close";
      num-workspaces = 4;
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "fullscreen-avoider@noobsai.github.com"
        "openweather-extension@jenslody.de"
      ];
      favorite-apps = [
        "librewolf.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.Nautilus.desktop"
        "codium.desktop"
        "obsidian.desktop"
        "signal-desktop.desktop"
        "discord.desktop"
      ];
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Orchis-Pink-Dark-Compact";
    };
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = "disabled";
      toggle-message-tray = "disabled";
      close = [ "<Super>q" ];
      maximize = "disabled";
      minimize = [ "<Super>comma" ];
      move-to-monitor-down = "disabled";
      move-to-monitor-left = "disabled";
      move-to-monitor-right = "disabled";
      move-to-monitor-up = "disabled";
      move-to-workspace-down = "disabled";
      move-to-workspace-up = "disabled";
      toggle-maximized = [ "<Super>m" ];
      unmaximize = "disabled";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "terminal";
      command = "kgx";
      binding = "<Super>Return";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
    "org/gnome/desktop/background" = {
      picture-uri-dark = "https://cdn.discordapp.com/attachments/1093259252828737667/1119072489813852262/clean_up_your_room.jpg";
    };
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };
  };
}