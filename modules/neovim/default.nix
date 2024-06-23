{ pkgs, lib, ... }:
let
  mkPlugin = value: { programs.nixvim = value; };
  plugins = map mkPlugin [
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
      extraPlugins = [ pkgs.vimPlugins.lsp_signature-nvim ];
      autoCmd = [{
        event = [ "LspAttach" ];
        callback.__raw = ''function(args)
          require("lsp_signature").on_attach({
            bind = true,
            hint_enable = false, -- Virtual hint not needed since `floating_window` is true
            always_trigger = true, -- Continue showing even on newline
          }, args.buf)
        end'';
      }];
    }

    {
      extraPlugins = [ pkgs.vimPlugins.zenburn ];
      colorscheme = "zenburn";
      globals.zenburn_high_Contrast = 1;

      extraConfigVim = ''
        match TrailingWhitespace /\s\+$/
        highlight Visual term=reverse cterm=reverse
        highlight MatchParen cterm=bold ctermbg=none ctermfg=magenta
        highlight TrailingWhitespace ctermfg=darkgreen
        highlight LspInlayHint ctermfg=darkgray
      '';
    }

    (
      let
        colors = [ "DarkRed" "DarkGreen" "DarkMagenta" "DarkCyan" "Red" "Yellow" "Green" "DarkYellow" "Magenta" "Cyan" "DarkYellow" ];
        toName = color: "RainbowDelimiter${color}";
        toAttrSet = color: { name = toName color; value = { ctermfg = color; }; };
      in
      {
        highlight = builtins.listToAttrs (builtins.map toAttrSet colors);
        plugins.rainbow-delimiters = {
          enable = true;
          highlight = builtins.map toName colors;
        };
      }
    )
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

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    extraConfigLua = lib.fileContents ./lua/init.lua;

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
      treesitter.enable = true;
      which-key.enable = true;
    };
  };
}
