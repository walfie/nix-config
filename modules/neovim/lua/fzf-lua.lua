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

local function with_preview(f)
  return function()
    f({
      winopts = {
        preview = {
          hidden = "nohidden",
          layout = "vertical",
          vertical = "up:90%",
        }
      }
    })
  end
end

local lsp_actions = {
  ["Type definitions"] = with_preview(fzf.lsp_typedefs),
  ["Signature help"] = vim.lsp.buf.signature_help,
  ["Rename"] = vim.lsp.buf.rename,
  ["References"] = with_preview(fzf.lsp_references),
  ["Outgoing calls"] = fzf.lsp_outgoing_calls,
  ["Incoming calls"] = fzf.lsp_incoming_calls,
  ["Implementations"] = with_preview(fzf.lsp_implementations),
  ["Hover"] = vim.lsp.buf.hover,
  ["Formatting"] = vim.lsp.buf.formatting,
  ["Definitions"] = with_preview(fzf.lsp_definitions),
  ["Declarations"] = with_preview(fzf.lsp_declarations),
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

-- Fuzzy autocomplete current line
vim.keymap.set("i", "<C-x><C-l>", function()
  fzf.grep_project({
    search = string.gsub(vim.api.nvim_get_current_line(), "%s", ".+"),
    no_esc = true,
    actions = {
      ["default"] = function(selected)
        local parts = vim.split(selected[1], ":")
        local line = table.concat(parts, ":", 4, #parts)
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, row - 1, row, true, { line })
      end
    },
  })
end)

-- In later versions of neovim we can use "LspAttach".
-- E.g., `vim.api.nvim_create_autocmd("LspAttach", { callback = ... })`
do
  function nmap(keys, fn, desc)
    vim.keymap.set("n", keys, fn, { desc = desc })
  end

  -- Set keymaps based on some recommendations from `nvim-lspconfig`
  nmap("gD", with_preview(fzf.lsp_declarations), "LSP declarations")
  nmap("gd", with_preview(fzf.lsp_definitions), "LSP definitions")
  nmap("gi", with_preview(fzf.lsp_implementations), "LSP implementations")
  nmap("K", vim.lsp.buf.hover, "LSP hover")
  nmap("<C-k>", vim.lsp.buf.signature_help, "LSP signature help")
  nmap("gr", with_preview(fzf.lsp_references), "LSP references")
  nmap("<Space>D", with_preview(fzf.lsp_typedefs), "LSP type definition")
  nmap("<Space>rn", vim.lsp.buf.rename, "LSP rename")
  nmap("<Space>ca", fzf.lsp_code_actions, "LSP code action")
  nmap("<Space><Space>", "<Space>")
end

