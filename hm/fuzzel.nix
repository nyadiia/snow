{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "alacritty";
        layer = "overlay";
        width = 45;
        lines = 15;
      };
      #      colors = {
      #        background = "282828ff";
      #        text = "ebdbb2ff";
      #        match = "d65d0eff";
      #        selection-match = "1d2021ff";
      #        selection = "d65d0eff";
      #        selection-text = "ebdbb2ff";
      #        border = "ebdbb2ff";
      #      };
      border = {
        width = 1;
        radius = 3;
      };
    };
  };
}
