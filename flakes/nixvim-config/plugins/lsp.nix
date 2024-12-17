{
  config = {
    plugins.lsp = {
      enable = true;
      servers = {
        basedpyright.enable = true;
        cssls.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        nil_ls.enable = true;
        terraformls.enable = true;
        ts_ls.enable = true;
      };
    };

    plugins.rustaceanvim = {
      enable = true;

      settings.tools.hover_actions.replace_builtin_hover = false;

      # https://github.com/rust-lang/rust-analyzer/blob/6e8a54d0f68702cf7981c8299357838eb0f4d5b2/docs/user/generated_config.adoc
      settings.server.default_settings.rust-analyzer = {
        imports = {
          # Auto-imported paths from current crate should prefer `crate::` rather than `super::`
          prefix = "crate";
          # Prefer grouping imports by module rather than crate.
          # E.g., avoid `use a::{b::c, d::{e, f}};`
          granularity.group = "module";
        };

        # Compile with all features to prevent "code is inactive due to #[cfg] directives" messages
        # https://users.rust-lang.org/t/can-i-stop-vscode-rust-analyzer-from-shading-out-cfgs/58773/4
        cargo.features = "all";

        # Use different directory for rust-analyzer to avoid `cargo build` triggering full rebuilds.
        # https://github.com/rust-lang/rust-analyzer/pull/15681
        #cargo.targetDir = true;
      };
    };

    plugins.none-ls = {
      enable = true;
      sources.formatting = {
        black.enable = true;
        buildifier.enable = true;
        nixpkgs_fmt.enable = true;
      };
    };
  };
}
