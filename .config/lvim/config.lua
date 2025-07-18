local lspconfig = require("lspconfig")

local target_filetypes = {
  "c", "cpp", "objc", "objcpp", "c++",
  "h", "hpp", "hh", "hxx", "cxx", "cc"
}

lvim.builtin.treesitter.indent = {
  enable = true,
  disable = target_filetypes,
}

vim.list_extend(lvim.builtin.treesitter.ignore_install, { "c", "cpp" })
lvim.builtin.treesitter.highlight.disable = target_filetypes

vim.api.nvim_create_autocmd("FileType", {
  pattern = target_filetypes,
  callback = function()
    vim.b.indent_blankline_enabled = false
  end,
})

lspconfig.clangd.setup {
  filetypes = target_filetypes,
}

local function clang_format_on_save()
  local ft = vim.bo.filetype
  for _, v in ipairs(target_filetypes) do
    if ft == v then
      vim.lsp.buf.format({ async = false })
      break
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = clang_format_on_save,
})
