{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    # ./tide.nix
    ./starship
  ];

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
        function mkdir -d "Create a directory and set CWD"
          command mkdir $argv
          if test $status = 0
            switch $argv[(count $argv)]
              case '-*'
              case '*'
        	cd $argv[(count $argv)]
        	return
            end
          end
        end

        set FZF_DEFAULT_OPTS --cycle --layout=reverse --border --height=40% --preview-window=wrap --marker="*" --color=bg+:#1d2021,gutter:-1
      '';
      shellInit = ''
        set --universal zoxide_cmd cd
      '';
      shellAliases = {
        # s = "kitten ssh";
        s = "ssh";
        cl = "clear";
        l = "ls";
        la = "ls -al";
        ll = "ls -l";
        lr = "ls -R";
      };
      plugins = [
        # {
        #   name = "z";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "jethrokuan";
        #     repo = "z";
        #     rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
        #     hash = "sha256-+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
        #   };
        # }
        {
          name = "autopair";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "autopair.fish";
            rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
            hash = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
          };
        }
      ];
    };
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
    fzf = {
      enable = true;
      defaultOptions = [
        "--cycle"
        "--layout=reverse"
        "--border"
        "--height=40%"
        "--preview-window=wrap"
        "--marker=\"*\""
        "--color=bg+:#1d2021,gutter:-1"
      ];
      fileWidgetOptions = [ "--preview 'bat {}'" ];
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      icons = "auto";
    };
  };
}
