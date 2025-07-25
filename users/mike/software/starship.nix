{
  # Configure Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$nix_shell$python$hostname$directory$git_branch$git_state$git_status$kubernetes$cmd_duration$line_break$character";
      directory = {
        style = "blue";
      };
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[[( $conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed )]($style)";
        style = "cyan";
        conflicted = "‼";
        untracked = "○";
        modified = "↑";
        staged = "↔";
        renamed = "→";
        deleted = "←";
        stashed = "≡";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };
      kubernetes = {
        disabled = false;
        format = "[$symbol$context]($style) ";
      };
      hostname = {
        ssh_symbol = "";
        format = "[$hostname]($style) ";
      };
      nix_shell = {
        format = "[( \($name\))]($style) ";
      };
    };
  };
}
