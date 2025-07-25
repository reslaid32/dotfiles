-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- LSP config
  { "neovim/nvim-lspconfig" },
  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  -- Gitsigns
  { "lewis6991/gitsigns.nvim" },
  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  -- Nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
})

-- Highlight groups
vim.cmd("highlight Normal guibg=#0d0d0d guifg=#d0d0d0")
vim.cmd("highlight Comment guifg=#555555 gui=italic")
vim.cmd("highlight Keyword guifg=#5fd7ff gui=bold")
vim.cmd("highlight String guifg=#87d787")
vim.cmd("highlight Function guifg=#af87ff")
vim.cmd("highlight Type guifg=#5fd7af gui=bold")
vim.cmd("highlight Error guifg=#ff5f5f gui=bold")

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("set termguicolors")

vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Setup nvim-cmp
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- clang-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.cc", "*.cxx", "*.hh", "*.hxx" },
  callback = function()
    vim.cmd("silent! write")
    vim.cmd("silent! !clang-format -i %")
    vim.cmd("silent! edit!")
  end,
})

-- LSP setup
local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
  capabilities = capabilities
})
-- lspconfig.lua_ls.setup({ capabilities = capabilities })

-- Gitsigns setup
require('gitsigns').setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '━' },
    topdelete    = { text = '━' },
    changedelete = { text = '╏' },
  },
  signcolumn = true,
  numhl      = false,
  linehl     = false,
}

-- Bufferline setup
require("bufferline").setup {
  options = {
    mode = "tabs",
    show_close_icon = false,
    show_buffer_close_icons = false,
    show_tab_indicators = true,
    separator_style = "thin",
  },
}

-- Treesitter setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp" },
  highlight = { enable = true },
}

-- Nvim-tree setup
require('nvim-tree').setup()

-- Toggle tree
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>")

-- Binds
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
