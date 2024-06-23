{
  programs.nixvim = {
    keymaps = [
      {
        action = ":Neotree toggle<CR>";
        key = "<Leader>n";
        mode = "n";
        options.desc = "Toggle neo-tree";
        options.silent = true;
      }
    ];

    plugins.neo-tree = {
      closeIfLastWindow = true;
      enableDiagnostics = false;
      enableGitStatus = false;

      window = {
        width = 30;
        mappings = {
          "/" = "none";
          b = "buffers";
          A = { command = "add_directory"; config.show_path = "absolute"; };
          a = { command = "add"; config.show_path = "absolute"; };
          c = { command = "copy"; config.show_path = "absolute"; };
          m = { command = "move"; config.show_path = "absolute"; };
        };
      };

      extraOptions = {
        event_handlers = [
          {
            event = "vim_buffer_enter";
            handler.__raw = ''function(_)
              if vim.bo.filetype == "neo-tree" then
                vim.opt_local.statusline = "%#Normal#"
              end
            end'';
          }
        ];
      };

      filesystem = {
        followCurrentFile.enabled = true;
        groupEmptyDirs = true;
        filteredItems = {
          visible = true;
          hideDotfiles = false;
          hideGitignored = false;
        };
      };

      buffers = {
        window.mappings = {
          d = "buffer_delete";
          b = "filesystem";
          bd = "none";
        };
      };

      # Remove default containers (allow seeing long file names)
      # https://github.com/nvim-neo-tree/neo-tree.nvim/blob/a7d6f05e57487326fd70b24195c3b7a86a88b156/lua/neo-tree/defaults.lua#L216-L257
      renderers.directory = [
        "indent"
        "icon"
        "current_filter"
        { name = "name"; zindex = 10; }
        { name = "symlink_target"; zindex = 10; highlight = "NeoTreeSymbolicLinkTarget"; }
        { name = "clipboard"; zindex = 10; }
        { name = "diagnostics"; errors_only = true; zindex = 20; align = "right"; }
      ];

      renderers.file = [
        "indent"
        "icon"
        { name = "name"; zindex = 10; }
        { name = "symlink_target"; zindex = 10; highlight = "NeoTreeSymbolicLinkTarget"; }
        { name = "bufnr"; zindex = 10; }
        { name = "modified"; zindex = 20; align = "right"; }
        { name = "diagnostics"; zindex = 20; align = "right"; }
        { name = "git_status"; zindex = 20; align = "right"; }
      ];
    };
  };
}
