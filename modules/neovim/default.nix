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
      plugin = barbar-nvim;
      type = "lua";
      config = ''
        require("bufferline").setup({
          animation = false,
          icons = {
            buffer_index = true,
            filetype = { enabled = true },
            button = false,
          },
        })

        -- Switch between buffers
        vim.keymap.set("n", "<C-h>", "<Cmd>BufferPrevious<CR>", { silent = true })
        vim.keymap.set("n", "<C-l>", "<Cmd>BufferNext<CR>", { silent = true })

        local bufferline_api = require("bufferline.api")
        vim.api.nvim_create_user_command(
          "B",
          bufferline_api.pick_buffer,
          { desc = "Pick a buffer" }
        )

        for index = 1,9 do
          vim.api.nvim_create_user_command("B" .. index, function()
            bufferline_api.goto_buffer(index)
          end, { desc = "Go to buffer " .. index })
        end

        -- Delete buffer
        vim.keymap.set("n", "<Leader>q", "<Cmd>BufferClose<CR>")
        vim.keymap.set("n", "<Leader>Q", "<Cmd>BufferClose!<CR>")
      '';
    }

    {
      plugin = which-key-nvim;
      type = "lua";
      config = ''
        require("which-key").setup({})
      '';
    }

    rust-tools-nvim
    none-ls-nvim
    {
      plugin = pkgs.vimExtraPlugins.nvim-lspconfig;
      type = "lua";
      config = lib.fileContents (pkgs.substituteAll {
        src = ./lua/lsp.lua;

        black_cmd = "${pkgs.black}/bin/black";
        buildifier_cmd = "${pkgs.bazel-buildtools}/bin/buildifier";
        cssls_cmd = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server";
        eslint_cmd = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-eslint-language-server";
        gopls_cmd = "${pkgs.gopls}/bin/gopls";
        html_cmd = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-html-language-server";
        jsonls_cmd = "${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-json-language-server";
        pyright_cmd = "${pkgs.pyright}/bin/pyright-langserver";
        rnix_cmd = "${pkgs.rnix-lsp}/bin/rnix-lsp";
        nixpkgs_fmt_cmd = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        rust_analyzer_cmd = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        starlark_rust_cmd = "${pkgs.starlark-rust}/bin/starlark";
        terraformls_cmd = "${pkgs.terraform-ls}/bin/terraform-ls";
        tsserver_cmd = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        tsserver_path = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/";
      });
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
      plugin = neo-tree-nvim;
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
      plugin = trouble-nvim;
      type = "lua";
      config = ''
        local trouble = require("trouble")
        trouble.setup({})
        vim.keymap.set("n", "<Leader>x", "<Cmd>TroubleToggle<CR>")
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
      plugin = fzf-lua;
      type = "lua";
      config = lib.fileContents (pkgs.substituteAll {
        src = ./lua/fzf-lua.lua;
        fzf_bin = "${pkgs.skim}/bin/sk";
      });
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
        highlight LspInlayHint ctermfg=darkgray
      '';
    }

  ];

in
{
  home = {
    packages = [
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
