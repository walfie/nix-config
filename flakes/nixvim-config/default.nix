{ pkgs, lib, ... }:
let
  plugins = [
    {
      extraPlugins = [ pkgs.vimPlugins.camelcasemotion ];
      globals.camelcasemotion_key = ",";

      # Adding some `nmap` calls to avoid deleting trailing underscore
      # https://github.com/bkad/CamelCaseMotion/issues/10#issuecomment-8704702
      keymaps = [
        { key = "c,w"; action = "c,e"; mode = "n"; }
        { key = "ci,w"; action = "ci,e"; mode = "n"; }
      ];
    }

    {
      extraPlugins = [ pkgs.vimPlugins.vim-argwrap ];
      keymaps = [{ key = "<Leader>w"; action = ":ArgWrap<CR>"; mode = "n"; }];
    }

    {
      plugins.trouble.enable = true;
      keymaps = [{ key = "<Leader>x"; action = "<Cmd>TroubleToggle<CR>"; mode = "n"; }];
    }

    {
      extraPlugins = [ pkgs.vimExtraPlugins.vim-ctrlsf ];
      keymaps = [{ key = "<Leader>f"; action = "<Plug>CtrlSFPrompt"; mode = "n"; }];
    }

    {
      extraPlugins = [ pkgs.vimPlugins.zenburn ];

      colorscheme = "zenburn";
      globals.zenburn_high_Contrast = 1;
      match.TrailingWhitespace = ''\s\+$'';
      highlightOverride = {
        Visual.reverse = true;
        MatchParen = { bold = true; ctermbg = "none"; ctermfg = "Magenta"; };
        TrailingWhitespace.ctermfg = "DarkGreen";
        LspInlayHint.ctermfg = "DarkGray";
      };
    }

    {
      extraPlugins = [ pkgs.vimPlugins.rainbow ];
      globals.rainbow_active = 1;
      globals.rainbow_conf.ctermfgs = [ "DarkRed" "DarkGreen" "DarkMagenta" "DarkCyan" "Red" "Yellow" "Green" "DarkYellow" "Magenta" "Cyan" "DarkYellow" ];
    }
  ];
in
{
  imports = [
    ./plugins/barbar.nix
    ./plugins/cmp.nix
    ./plugins/fzf-lua.nix
    ./plugins/lsp.nix
    ./plugins/neo-tree.nix
  ] ++ plugins;

  config = {
    withNodeJs = true;

    extraPlugins = with pkgs.vimPlugins; [
      camelcasemotion
      nerdcommenter
      nvim-web-devicons
      traces-vim
      vim-abolish
      vim-eunuch
      vim-repeat
      vim-scala
      vim-visual-increment
    ];

    plugins = {
      emmet.enable = true;
      fugitive.enable = true;
      neo-tree.enable = true;
      nvim-autopairs.enable = true;
      sleuth.enable = true;
      surround.enable = true;
      which-key.enable = true;
    };

    opts = {
      mouse = ""; # Disable mouse
      expandtab = true; # Insert spaces instead of tabs
      incsearch = false; # Disable incremental search (only scroll on submitting the search)
      lazyredraw = true; # Don't redraw screen while executing macros
      linebreak = true; # Wrap long lines on word boundaries
      list = true; # Show listchars
      listchars = { tab = "> "; trail = "."; nbsp = "+"; }; # Display characters for whitespace
      modeline = false; # Ignore modelines (vim-specific comments in files)
      number = true; # Show line numbers
      sessionoptions = [ "buffers" ]; # Only store buffer info in `:mksession`
      shiftwidth = 2; # 2-space indentation by default
      synmaxcol = 2048; # Stop syntax highlighting on long lines
      undofile = true; # Keep undo history after closing nvim
      virtualedit = [ "block" ]; # Allow placing cursor anywhere in virtual select mode
      visualbell = true; # Disable error sounds

      # Always show the signcolumn, otherwise it would shift the text each time
      # diagnostics appear/become resolved.
      signcolumn = "number";

      # Searching
      ignorecase = true; # Case-insensitive search by default
      smartcase = true; # If search pattern has uppercase, use case-sensitive match

      # Highlight right margin
      colorcolumn = [ 72 80 90 100 ];

      # Status line
      statusline = lib.strings.concatStrings [
        "%F" # Full path to file
        "%=" # Add spaces to right-justify the rest of the line
        "%l/%L,%v" # Line number / Total number of lines, Virtual column
        " %p%%" # Percentage through file (lines)
      ];
    };

    # Highlight right margin
    highlightOverride.ColorColumn.ctermbg.__raw = "235";

    # Disable slow SQL dynamic completion
    globals.omni_sql_no_default_maps = 1;

    # Remove trailing whitespace with `:Clean`
    userCommands.Clean.command = ":%s/\s\+$//e";

    keymaps = [
      # Copy to clipboard
      # https://www.reddit.com/r/neovim/comments/3fricd/easiest_way_to_copy_from_neovim_to_system/ctrru3b/
      { key = "<Leader>y"; action = ''"+y''; mode = [ "n" "v" ]; }
      { key = "<Leader>Y"; action = ''"+yg_''; mode = [ "n" "v" ]; }

      # Paste from clipboard
      { key = "<Leader>p"; action = ''"+p''; mode = [ "n" "v" ]; }
      { key = "<Leader>P"; action = ''"+P''; mode = [ "n" "v" ]; }

      # Create new buffer
      { key = "<C-t>"; action = ":enew<CR>"; mode = "n"; options.silent = true; }

      # Clear highlighed search
      { key = "<CR>"; action = ":nohlsearch<CR><CR>"; mode = "n"; options.silent = true; }
    ];

    autoCmd = [
      # Stop automatically inserting comments when inserting a new line
      # https://vim.fandom.com/wiki/Disable_automatic_comment_insertion#Disabling_in_general
      {
        event = [ "FileType" ];
        pattern = "*";
        callback.__raw = ''function()
          vim.opt.formatoptions:remove('c')
          vim.opt.formatoptions:remove('r')
          vim.opt.formatoptions:remove('o')
        end'';
      }

      # When editing crontab, disable backups to avoid the 'temp file must be edited in place' error
      # https://vim.fandom.com/wiki/Editing_crontab
      {
        event = [ "FileType" ];
        pattern = "crontab";
        callback.__raw = ''function()
          vim.opt_local.backup = false
          vim.opt_local.writebackup = false
        end'';
      }
    ];
  };
}
