{ lib, ... }:
let
  listToUnkeyedAttrs = lib.nixvim.listToUnkeyedAttrs;
in
{
  config = {
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
      settings = {
        close_if_last_window = true;
        enable_diagnostics = false;
        enable_git_status = false;

        window = {
          width = 30;
          mappings = {
            "/" = "none";
            A = {
              command = "add_directory";
              config.show_path = "absolute";
            };
            a = {
              command = "add";
              config.show_path = "absolute";
            };
            c = {
              command = "copy";
              config.show_path = "absolute";
            };
            m = {
              command = "move";
              config.show_path = "absolute";
            };
          };
        };

        # Remove default containers (allow seeing long file names)
        # https://github.com/nvim-neo-tree/neo-tree.nvim/blob/a7d6f05e57487326fd70b24195c3b7a86a88b156/lua/neo-tree/defaults.lua#L216-L257
        renderers.directory = [
          [ "indent" ]
          [ "icon" ]
          [ "current_filter" ]
          (listToUnkeyedAttrs [ "name" ] // { zindex = 10; })
          (
            listToUnkeyedAttrs [ "symlink_target" ]
            // {
              zindex = 10;
              highlight = "NeoTreeSymbolicLinkTarget";
            }
          )
          (listToUnkeyedAttrs [ "clipboard" ] // { zindex = 10; })
          (
            listToUnkeyedAttrs [ "diagnostics" ]
            // {
              errors_only = true;
              zindex = 20;
              align = "right";
            }
          )
        ];

        renderers.file = [
          [ "indent" ]
          [ "icon" ]
          (listToUnkeyedAttrs [ "name" ] // { zindex = 10; })
          (
            listToUnkeyedAttrs [ "symlink_target" ]
            // {
              zindex = 10;
              highlight = "NeoTreeSymbolicLinkTarget";
            }
          )
          (listToUnkeyedAttrs [ "bufnr" ] // { zindex = 10; })
          (
            listToUnkeyedAttrs [ "modified" ]
            // {
              zindex = 20;
              align = "right";
            }
          )
          (
            listToUnkeyedAttrs [ "diagnostics" ]
            // {
              zindex = 20;
              align = "right";
            }
          )
          (
            listToUnkeyedAttrs [ "git_status" ]
            // {
              zindex = 20;
              align = "right";
            }
          )
        ];

        buffers = {
          window.mappings = {
            d = "buffer_delete";
            bd = "none";
          };
        };

        event_handlers = [
          {
            event = "vim_buffer_enter";
            handler.__raw = ''
              function(_)
                if vim.bo.filetype == "neo-tree" then
                  vim.opt_local.statusline = "%#Normal#"
                end
              end'';
          }
        ];

        filesystem = {
          follow_current_file.enabled = true;
          group_empty_dirs = true;
          filtered_items = {
            visible = true;
            hide_dotfiles = false;
            hide_gitignored = false;
            hide_by_pattern = [
              "*.bak" # Used by GB Studio

              # Godot UID files
              "*.gd.uid"
              "*.gdshader.uid"
            ];
          };
        };
      };

    };
  };
}
