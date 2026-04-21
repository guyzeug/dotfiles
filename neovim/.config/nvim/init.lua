------------------------------------------------------------
-- BOOTSTRAP lazy.nvim
------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------
-- CORE OPTIONS
------------------------------------------------------------
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

------------------------------------------------------------
-- PLUGINS
------------------------------------------------------------
require("lazy").setup({

  ----------------------------------------------------------
  -- UI / ICONS
  ----------------------------------------------------------
  { "echasnovski/mini.icons", config = true },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

  ----------------------------------------------------------
  -- FILE SEARCH (Rider "Search Everywhere")
  ----------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  ----------------------------------------------------------
  -- LSP MANAGEMENT
  ----------------------------------------------------------
  { "williamboman/mason.nvim", config = true },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "pyright",
          "ts_ls",
          "omnisharp",
        }
      })
    end
  },

  { "neovim/nvim-lspconfig" },

  ----------------------------------------------------------
  -- COMPLETION
  ----------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
    }
  },

  ----------------------------------------------------------
  -- UTILITIES
  ----------------------------------------------------------
  { "tpope/vim-commentary" },
  { "machakann/vim-highlightedyank" },

  {
    "phaazon/hop.nvim",
    config = true,
  },
})

------------------------------------------------------------
-- BASIC KEYMAPS (Rider-like)
------------------------------------------------------------
local map = vim.keymap.set

map("i", "jk", "<Esc>")

map("n", "f", "/")
map("n", "Q", "gq")

map("n", "<leader>d", "diw")
map("n", "<leader>y", "yiw")
map("n", "<leader>c", "ciw")
map("n", "<leader>p", "viwp")
map("n", "<leader>a", "ggVG")

------------------------------------------------------------
-- LSP (MODERN 0.11+ API)
------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local opts = { buffer = buf, silent = true }

    map("n", "<leader>gd", vim.lsp.buf.definition, opts)
    map("n", "<leader>gi", vim.lsp.buf.implementation, opts)
    map("n", "<leader>gu", vim.lsp.buf.references, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
  end,
})

-- LSP servers (NEW API)
vim.lsp.config("pyright", {})
vim.lsp.enable("pyright")

vim.lsp.config("ts_ls", {})
vim.lsp.enable("ts_ls")

vim.lsp.config("omnisharp", {
  cmd = { "omnisharp" }
})
vim.lsp.enable("omnisharp")

------------------------------------------------------------
-- COMPLETION (nvim-cmp)
------------------------------------------------------------
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
  }
})

------------------------------------------------------------
-- TELESCOPE (SEARCH)
------------------------------------------------------------
local telescope = require("telescope.builtin")

map("n", "<leader>ff", telescope.find_files)
map("n", "<leader>fc", telescope.live_grep)
map("n", "<leader>fr", telescope.oldfiles)

------------------------------------------------------------
-- WHICH-KEY (MODERN STYLE)
------------------------------------------------------------
require("which-key").setup({
  preset = "modern",
})

------------------------------------------------------------
-- HOP (motion navigation)
------------------------------------------------------------
map("n", "<leader>j", ":HopWord<CR>")
