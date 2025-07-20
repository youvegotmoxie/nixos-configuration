{ lib, config, pkgs, home-manager, ...}:

{

  # Configure btop
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "/home/mike/.config/btop/themes/tokyo-night.theme";
      vim_keys = true;
      update_ms = 2000;
      proc_per_core = true;
    };
  };
}
