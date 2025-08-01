{config, ...}: {
  # Configure bash
  sops.secrets.gh_token = {
    path = "${config.sops.defaultSymlinkPath}/gh_token";
  };
  home.shell.enableBashIntegration = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra = ''
      export GH_TOKEN="$(cat ${config.sops.secrets.gh_token.path})"
    '';
    shellAliases = {
      # Aliases not set by Atuin
      ll = "eza -lahg --git-repos-no-status --git";
      ls = "eza";
      cat = "bat --paging=never --style=plain";
      gcm = "git checkout master";
      gpm = "git pull origin master";
      grep = "ugrep";
      fps = "flatpak search";
    };
    bashrcExtra = ''
      if [[ $- != *i* ]] ; then
              # Shell is non-interactive.  Be done now!
              return
      fi

      # Enable VIM keybinds
      set -o vi

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
