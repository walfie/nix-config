-- Note: `@variable@` is replaced in nix via `pkgs.substituteAll`

local nvim_lsp = require("lspconfig")

nvim_lsp.rnix.setup({ cmd = { "@rnix_cmd@" } })

nvim_lsp.gopls.setup({ cmd = { "@gopls_cmd@" } })

nvim_lsp.pyright.setup({ cmd = { "@pyright_cmd@", "--stdio" } })

nvim_lsp.terraformls.setup({ cmd = { "@terraformls_cmd@", "serve" } })

nvim_lsp.tsserver.setup({
  cmd = { "@tsserver_cmd@", "--stdio", "--tsserver-path", "@tsserver_path@" },
})

-- https://github.com/simrat39/rust-tools.nvim/tree/b696e6dee1e79a53159f1c0472289f5486ac31bc#configuration
require("rust-tools").setup({
  tools = {
    hover_with_actions = true,
    inlay_hints = {
      parameter_hints_prefix = "« ",
      other_hints_prefix = "» ",
      highlight = "LspInlayHint",
    },
  },
  -- Override default rust-tools settings
  -- https://github.com/neovim/nvim-lspconfig/blob/bdfcca4af7ac8171e6d4ae4b375aad61ff747429/doc/server_configurations.md#rust_analyzer
  server = {
    cmd = { "@rust_analyzer_cmd@" },
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

