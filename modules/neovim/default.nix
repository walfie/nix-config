# Useful article on setting up vim in nix
# http://ivanbrennan.nyc/2018-05-09/vim-on-nixos
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
    # LSP config initially based on: https://sharksforarms.dev/posts/neovim-rust/
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = ''
        local nvim_lsp = require'lspconfig'

        nvim_lsp.tsserver.setup {
          cmd = {
            "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server",
            "--stdio",
            "--tsserver-path",
            "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib/",
          },
        }

        nvim_lsp.rnix.setup {
          cmd = { "${pkgs.rnix-lsp}/bin/rnix-lsp" },
        }
      '';
    }

    # https://github.com/simrat39/rust-tools.nvim/tree/b696e6dee1e79a53159f1c0472289f5486ac31bc#configuration
    {
      plugin = rust-tools-nvim;
      type = "lua";
      config = ''
        require'rust-tools'.setup {
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
        }
      '';
    }

    # Used by nvim-cmp
    luasnip
    cmp-buffer
    cmp-nvim-lsp
    cmp-nvim-lua
    cmp-path

    # https://github.com/hrsh7th/nvim-cmp/tree/058100d81316239f3874064064f0f0c5d43c2103#recommended-configuration
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
        local cmp = require'cmp'
        cmp.setup {
          snippet = {
            expand = function(args)
              require'luasnip'.lsp_expand(args.body)
            end,
          },
          preselect = cmp.PreselectMode.None,
          mapping = {
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<S-Tab>'] = cmp.mapping.select_prev_item(),
            ['<Tab>'] = cmp.mapping.select_next_item(),
            ['<CR>'] = cmp.mapping.confirm(),
          },
          -- Installed sources
          sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            { name = 'luasnip' },
            { name = 'buffer' },
            { name = 'path' },
          },
        }
      '';
    }

    # Other
    camelcasemotion
    delimitMate
    emmet-vim
    fzf-vim
    fzfWrapper
    nerdcommenter
    nerdtree
    rainbow
    traces-vim
    vim-abolish
    vim-bbye
    vim-eunuch
    vim-fugitive
    vim-nerdtree-tabs
    vim-polyglot
    vim-repeat
    vim-scala
    vim-sleuth
    vim-surround
    vim-visual-increment

    # Color scheme
    zenburn
  ];

  optionalPlugins = builtins.map mkOptionalPlugin (with pkgs.vimPlugins; [
  ]);

  customPlugins = builtins.map mkPlugin [
    "vim-argwrap"
    "vim-ctrlsf"
    "vim-minibufexpl"
    "vim-rescript"
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
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    plugins = plugins ++ optionalPlugins ++ customPlugins;
    extraConfig = builtins.concatStringsSep "\n" [
      (lib.fileContents ./init.vim)
    ];
  };
}
