{ config, pkgs, lib, ... }:
let
  sources = import ../../nix/sources.nix;

  # These plugins aren't in nixpkgs, so load them from niv-managed sources
  mkPlugin = name: pkgs.vimUtils.buildVimPlugin {
    inherit name;
    src = sources.${name};
    dontBuild = true;
  };

  mkOptionalPlugin = plugin: {
    inherit plugin;
    optional = true;
  };

  plugins = with pkgs.vimPlugins; [
    emmet-vim
    nerdcommenter
    traces-vim
    vim-abolish
    vim-bbye
    vim-eunuch
    vim-fugitive
    vim-repeat
    vim-scala
    vim-sleuth
    vim-surround
    vim-visual-increment

    (mkPlugin "vim-ctrlsf")
    (mkPlugin "vim-minibufexpl")

    # Used by nvim-cmp
    luasnip
    cmp-buffer
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path

    {
      plugin = which-key-nvim;
      type = "lua";
      config = ''
        require("which-key").setup({})
      '';
    }

    # LSP config initially based on: https://sharksforarms.dev/posts/neovim-rust/
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = ''
        local nvim_lsp = require("lspconfig")

        nvim_lsp.tsserver.setup({
          cmd = {
            "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server",
            "--stdio",
            "--tsserver-path",
            "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/",
          },
        })

        nvim_lsp.rnix.setup({
          cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
        })
      '';
    }

    # https://github.com/simrat39/rust-tools.nvim/tree/b696e6dee1e79a53159f1c0472289f5486ac31bc#configuration
    {
      plugin = rust-tools-nvim;
      type = "lua";
      config = ''
        require("rust-tools").setup({
          tools = {
            hover_with_actions = true,
            inlay_hints = {
              parameter_hints_prefix = "« ",
              other_hints_prefix = "» ",
            },
          },
          -- Override default rust-tools settings
          -- https://github.com/neovim/nvim-lspconfig/blob/bdfcca4af7ac8171e6d4ae4b375aad61ff747429/doc/server_configurations.md#rust_analyzer
          server = {
            cmd = { "${pkgs.rust-analyzer}/bin/rust-analyzer" },
            settings = {
              -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
              ["rust-analyzer"] = {
                cargo = {
                  -- Compile with all features to prevent "code is inactive due to #[cfg] directives" messages
                  -- https://users.rust-lang.org/t/can-i-stop-vscode-rust-analyzer-from-shading-out-cfgs/58773/4
                  features = "all",
                },
              },
            }
          },
        })
      '';
    }

    # https://github.com/hrsh7th/nvim-cmp/tree/058100d81316239f3874064064f0f0c5d43c2103#recommended-configuration
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          preselect = cmp.PreselectMode.None,
          mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<CR>"] = cmp.mapping.confirm(),
          },
          -- Installed sources
          sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          },
        })
      '';
    }

    {
      plugin = nvim-tree-lua;
      type = "lua";
      config = ''
        vim.keymap.set("n", "<Leader>n", ":NvimTreeToggle<CR>", {
          desc = "Toggle nvim-tree",
        })

        require("nvim-tree").setup({
          view = {
            number = true,
            signcolumn = "no",
          },
          git = {
            enable = false,
          },
        })

        -- Close neovim if the tree is the last remaining pane
        -- https://github.com/kyazdani42/nvim-tree.lua/discussions/1115#discussioncomment-2454398
        vim.api.nvim_create_autocmd("BufEnter", {
          nested = true,
          callback = function()
            if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
              vim.cmd "quit"
            end
          end,
        })
      '';
    }

    {
      plugin = camelcasemotion;
      config = ''
        " Adding some `nmap` calls to avoid deleting trailing underscore
        " https://github.com/bkad/CamelCaseMotion/issues/10#issuecomment-8704702
        let g:camelcasemotion_key = ','
        nmap c,w c,e
        nmap ci,w ci,e
      '';
    }

    {
      plugin = delimitMate;
      config = ''
        let delimitMate_quotes = '" `'
      '';
    }

    {
      plugin = fzf-vim;
      config = ''
        " Ctrl+P for fuzzy finder
        let g:fzf_command_prefix = 'Fzf'

        " Disable preview window
        let g:fzf_preview_window = ""
        map <silent> <C-p> <Esc>:FzfFiles<CR>
        map <silent> <Leader>b <Esc>:FzfBuffers<CR>
        map <silent> <Leader>l <Esc>:FzfLines<CR>
        " \a used to be for `ag`, but now it's `rg`
        map <silent> <Leader>a <Esc>:FzfRg<CR>
        " \d for definition
        map <silent> <Leader>d <Esc>:FzfRg (class\|trait\|object\|struct\|enum\|type)<CR>

        " Ctrl+l to autocomplete from Rg search
        imap <C-x><C-l> <Plug>(fzf-complete-line)

        " Skip files in gitignore
        let $FZF_DEFAULT_COMMAND = "rg --files --hidden -g '!.git/'"

        function! RgCompleteCommand(args)
          return "rg ^ --color never --no-filename --no-line-number ".a:args." . | awk '!seen[$0]++'"
        endfunction

        inoremap <expr> <C-l> fzf#vim#complete(fzf#wrap({
        \ 'prefix': '^.*$',
        \ 'source': function('RgCompleteCommand'),
        \ 'options': '--ansi'
        \}))
      '';
    }

    {
      plugin = rainbow;
      config = ''
        let g:rainbow_active = 1
        let g:rainbow_conf = {
        \  'ctermfgs': [
        \    'darkred', 'darkgreen', 'darkmagenta', 'darkcyan', 'red',
        \    'yellow', 'green', 'darkyellow', 'magenta', 'cyan', 'darkyellow'
        \  ]
        \}
      '';
    }

    {
      plugin = vim-argwrap;
      config = ''
        nnoremap <silent> <Leader>w :ArgWrap<CR>
      '';
    }

    {
      plugin = vim-polyglot;
      config = ''
        " Use vim-scala for scala
        let g:polyglot_disabled = ['scala']

        " JSON conceal off
        let g:vim_json_syntax_conceal = 0
      '';
    }

    {
      plugin = mkPlugin "vim-ctrlsf";
      config = ''
        map <Leader>f <Plug>CtrlSFPrompt
      '';
    }

    # Color scheme
    {
      plugin = zenburn;
      config = ''
        let g:zenburn_high_Contrast=1
        colorscheme zenburn
        highlight Visual term=reverse cterm=reverse
        highlight MatchParen cterm=bold ctermbg=none ctermfg=magenta
        highlight TrailingWhitespace ctermfg=darkgreen
      '';
    }

  ];

in
{
  home = {
    packages = [
      pkgs.fzf
      pkgs.ripgrep
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.neovim = {
    inherit plugins;

    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    extraConfig = builtins.concatStringsSep "\n" [
      (lib.fileContents ./init.vim)
    ];
  };
}
