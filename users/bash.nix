{ lib, config, pkgs, home-manager, ... }:

{

  # Configure bash
  home.shell.enableBashIntegration = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    shellAliases = {
      # Aliases not set by Atuin
      ll = "eza -lahg --git-repos-no-status --git";
      ls = "eza";
      cat = "bat --paging=never --style=plain";
    };
    bashrcExtra = ''
      if [[ $- != *i* ]] ; then
              # Shell is non-interactive.  Be done now!
              return
      fi

      # Enable VIM keybinds
      set -o vi

      # If a Python venv exists then activate it
      if [ -d $HOME/.venv ]; then
          source ~/.venv/bin/activate
      fi

      # Add SSH key to ssh-agent
      eval "$(ssh-agent -s)"
      ssh-add /home/mike/.ssh/id_rsa

      # Helper function for git add+commit+push
      git-sendit () {
        local branch="$(git branch --show-current)"
        git add .
        if [ ! -z "$1" ]
        then
          local msg="trivial"
        else
          git commit
        fi
        git push origin "$branch"
      }
    '';
  };

}
