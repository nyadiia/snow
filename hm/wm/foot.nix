# { style, ... }:
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # term = "xterm-256color";
      };
      colors = {
        # background = style.colors.surface;
        # text = style.colors.on_surface;
        
        alpha = 0.8;
      };
    };
  };
}
