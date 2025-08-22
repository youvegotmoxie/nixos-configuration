{pkgs, ...}: {
  # Set EDITOR to helix
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "tokyonight";
      editor = {
        auto-format = true;
        trim-final-newlines = true;
        indent-guides = {
          render = true;
          character = "┊";
        };
        lsp = {
          display-messages = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {
          hidden = false;
        };
      };
      keys.normal = {
        C-x = [
          ":buffer-close!"
        ];
        C-g = [
          ":write-all"
          ":new"
          ":insert-output lazygit"
          ":buffer-close!"
          ":redraw"
          ":reload-all"
        ];
      };
    };
    languages = {
      language-server.nix = {
        command = "${pkgs.nil}/bin/nil";
        args = ["--stdio"];
      };
      language-server.yaml = {
        command = "${pkgs.yaml-language-server}/bin/yaml-language-server";
        args = ["--stdio"];
      };
      language-server.python = {
        command = "${pkgs.python313Packages.python-lsp-server}/bin/pylsp";
      };
      language-server.bash = {
        command = "${pkgs.bash-language-server}/bin/bash-language-server";
        args = ["start"];
      };
      language = [
        {
          name = "yaml";
          file-types = ["yaml"];
          auto-format = true;
          language-servers = ["yaml-language-server"];
          formatter = {
            command = "${pkgs.yamlfmt}/bin/yamlfmt";
            args = ["-"];
          };
        }
        {
          name = "nix";
          file-types = ["nix"];
          auto-format = true;
          formatter = {command = "${pkgs.alejandra}/bin/alejandra";};
        }
        {
          name = "bash";
          file-types = ["bash" "sh" "zsh"];
          auto-format = true;
          formatter = {
            command = "${pkgs.shfmt}/bin/shfmt";
            args = ["-"];
          };
        }
        {
          name = "python";
          file-types = ["py"];
          auto-format = true;
          formatter = {
            command = "${pkgs.python313Packages.autopep8}/bin/autopep8";
            args = ["-"];
          };
        }
      ];
    };
  };

  home.packages = with pkgs; [
    yaml-language-server
    bash-language-server
    shfmt
    nil
    alejandra
    yamlfmt
    python313Packages.autopep8
    python313Packages.python-lsp-server
  ];
}
