{ config, pkgs, lib, ... }:
let
  plugins = with pkgs.vimPlugins; [
    emmet-vim
    nerdcommenter
    nvim-web-devicons
    traces-vim
    vim-abolish
    vim-eunuch
    vim-fugitive
    vim-repeat
    vim-scala
    vim-sleuth
    vim-surround
    vim-visual-increment

    # Used by nvim-cmp
    luasnip
    cmp-buffer
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path

    {
      plugin = vim-bbye;
      type = "lua";
      config = ''
        -- Delete buffer
        vim.keymap.set("n", "<Leader>q", ":Bdelete<CR>")
        vim.keymap.set("n", "<Leader>Q", ":Bdelete!<CR>")
      '';
    }

    {
      plugin = pkgs.vimExtraPlugins.vim-minibufexpl;
      type = "lua";
      config = ''
        -- https://stackoverflow.com/questions/24466037/hide-lightline-for-minibufexplorer
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "minibufexpl",
          callback = function()
            vim.opt_local.statusline = "%#Normal#"
          end,
        })
      '';
    }

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

    {
      plugin = lsp_signature-nvim;
      type = "lua";
      config = ''
        require("lsp_signature").setup({
          hint_enable = false, -- Virtual hint not needed since `floating_window` is true
          always_trigger = true, -- Continue showing even on newline
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
      plugin = nvim-autopairs;
      type = "lua";
      config = ''
        local autopairs = require("nvim-autopairs")
        autopairs.setup({})
        autopairs.remove_rule("'") -- Single quote is often used on its own in Rust

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      '';
    }

    {
      plugin = pkgs.vimExtraPlugins.neo-tree-nvim;
      type = "lua";
      config = lib.fileContents ./lua/neo-tree.lua;
    }

    {
      plugin = camelcasemotion;
      type = "lua";
      config = ''
        -- Adding some `nmap` calls to avoid deleting trailing underscore
        -- https://github.com/bkad/CamelCaseMotion/issues/10#issuecomment-8704702
        vim.g.camelcasemotion_key = ","
        vim.keymap.set("n", "c,w", "c,e", { remap = true })
        vim.keymap.set("n", "ci,w", "ci,e", { remap = true })
      '';
    }

    {
      plugin = fzf-vim;
      config = ''
        let g:fzf_command_prefix = 'Fzf'

        " Disable preview window
        let g:fzf_preview_window = ""

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
      type = "lua";
      config = ''
        vim.g.rainbow_active = 1
        vim.g.rainbow_conf = {
          ctermfgs = {
            "darkred", "darkgreen", "darkmagenta", "darkcyan", "red",
            "yellow", "green", "darkyellow", "magenta", "cyan", "darkyellow",
          }
        }
      '';
    }

    {
      plugin = vim-argwrap;
      type = "lua";
      config = ''
        vim.keymap.set("n", "<Leader>w", ":ArgWrap<CR>", { silent = true })
      '';
    }

    {
      plugin = vim-polyglot;
      type = "lua";
      config = ''
        -- Use vim-scala for scala
        vim.g.polyglot_disabled = { "scala" }

        -- JSON conceal off
        vim.g.vim_json_syntax_conceal = 0
      '';
    }

    {
      plugin = pkgs.vimExtraPlugins.vim-ctrlsf;
      type = "lua";
      config = ''
        vim.keymap.set("n", "<Leader>f", "<Plug>CtrlSFPrompt")
      '';
    }

    {
      plugin = pkgs.vimExtraPlugins.fzf-lua;
      type = "lua";
      config = ''
        local fzf = require("fzf-lua")
        fzf.setup({
          fzf_opts = {
            ["--layout"] = "default",
          },
          winopts = {
            width = 0.9,
            preview = {
              hidden = "hidden",
            },
          },
        })

        vim.keymap.set("n", "<C-p>", fzf.files)
        vim.keymap.set("n", "<Leader>b", fzf.buffers)
        vim.keymap.set("n", "<Leader>a", fzf.grep_project)
        vim.keymap.set("n", "<Leader>l", fzf.lines)
        vim.keymap.set("n", "<Leader>d", function()
          fzf.grep_project({
            search = "(class|trait|object|struct|enum|type) ",
            no_esc = true,
          })
        end)

        local lsp_actions = {
          ["Type definitions"] = fzf.lsp_typedefs,
          ["Signature help"] = vim.lsp.buf.signature_help,
          ["Rename"] = vim.lsp.buf.rename,
          ["References"] = fzf.lsp_references,
          ["Outgoing calls"] = fzf.lsp_outgoing_calls,
          ["Incoming calls"] = fzf.lsp_incoming_calls,
          ["Implementations"] = fzf.lsp_implementations,
          ["Hover"] = vim.lsp.buf.hover,
          ["Formatting"] = vim.lsp.buf.formatting,
          ["Definitions"] = fzf.lsp_definitions,
          ["Declarations"] = fzf.lsp_declarations,
          ["Code actions"] = fzf.lsp_code_actions,
        }

        vim.keymap.set("n", "gl", function()
          fzf.fzf_exec(vim.tbl_keys(lsp_actions), {
            prompt = "LSP> ",
            actions = {
              ["default"] = function(selected)
                for i, value in ipairs(selected) do
                  lsp_actions[value]()
                end
              end,
            },
          })
        end)

        -- TODO: Set <C-x><C-l> in insert mode to complete line
      '';
    }

    {
      # Color scheme
      plugin = zenburn;
      config = ''
        let g:zenburn_high_Contrast=1
        colorscheme zenburn

        match TrailingWhitespace /\s\+$/
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

    extraConfig = ''
      lua << EOF
      ${ lib.fileContents ./lua/init.lua }
      EOF
    '';
  };
}
