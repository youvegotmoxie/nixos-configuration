{
  # Configure Ghostty
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    installBatSyntax = true;
    installVimSyntax = true;
    settings = {
      theme = "tokyonight";
      font-size = 10;
      cursor-style-blink = false;
      cursor-style = "";
      scrollback-limit = "100_000_000";
      shell-integration = "detect";
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-paste-protection = false;
      mouse-hide-while-typing = true;
      confirm-close-surface = false;
      quit-after-last-window-closed = true;
      keybind = ["global:alt+grave_accent=toggle_quick_terminal"];
    };
  };
}
