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
  local function nmap(keys, fn, desc)
    vim.keymap.set("n", keys, fn, { desc = desc })
  end

  nmap("<C-p>", fzf.files, "Find files")
  nmap("<Leader>b", fzf.buffers, "Find buffers")
  nmap("<Leader>a", fzf.grep_project, "Find in project")
  nmap("<Leader>l", fzf.lines, "Find lines in open buffers")
  nmap("<Leader>d", function()
    fzf.grep_project({
      search = "(class|trait|object|struct|enum|type) ",
      no_esc = true,
    })
  end, "Find definition")

  -- There are other mappings with the <Space> prefix, so we should provide a
  -- way to use default <Space>
  vim.keymap.set("n", "<Space><Space>", "<Space>")

  local function preview(f, size)
    local opts = {
      winopts = {
        preview = {
          hidden = "nohidden",
          layout = "vertical",
          vertical = "up:" .. (size or 90) .. "%",
        }
      }
    }

    return function()
      f(opts)
    end
  end

  local actions = {
    { desc = "Code actions", fn = fzf.lsp_code_actions, nmap = "<Space>ca" },
    { desc = "Declarations", fn = preview(fzf.lsp_declarations), nmap = "gD" },
    { desc = "Definitions", fn = preview(fzf.lsp_definitions), nmap = "gd" },
    { desc = "Document diagnostics", fn = fzf.document_diagnostics },
    { desc = "Document symbols", fn = fzf.lsp_document_symbols },
    { desc = "Formatting", fn = vim.lsp.buf.formatting },
    { desc = "Hover", fn = vim.lsp.buf.hover, nmap = "K" },
    { desc = "Implementations", fn = preview(fzf.lsp_implementations, 70), nmap = "gi" },
    { desc = "Incoming calls", fn = fzf.lsp_incoming_calls },
    { desc = "Outgoing calls", fn = fzf.lsp_outgoing_calls },
    { desc = "References", fn = preview(fzf.lsp_references), nmap = "gr" },
    { desc = "Rename", fn = vim.lsp.buf.rename, nmap = "<Space>rn" },
    { desc = "Signature help", fn = vim.lsp.buf.signature_help, nmap = "<C-k>" },
    { desc = "Type definitions", fn = preview(fzf.lsp_typedefs), nmap = "<Space>D" },
    { desc = "Workplace diagnostics", fn = fzf.diagnostics_workspace },
    { desc = "Workplace symbols", fn = fzf.lsp_workplace_symbols },
  }

  local action_descriptions = {}
  local action_to_fn = {}
  for i, value in ipairs(actions) do
    if (value.nmap ~= nil) then
      nmap(value.nmap, value.fn, value.desc .. " (LSP)")
    end

    table.insert(action_descriptions, value.desc)
    action_to_fn[value.desc] = value.fn
  end

  -- Fuzzy finder for common LSP actions
  nmap("gl", function()
    fzf.fzf_exec(action_descriptions, {
      prompt = "LSP> ",
      actions = {
        ["default"] = function(selected)
          for i, value in ipairs(selected) do
            action_to_fn[value]()
          end
        end,
      },
    })
  end, "LSP actions")
end

