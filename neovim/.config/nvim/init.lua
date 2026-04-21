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
  -- 🎨 CATPPUCCIN THEME (MOCHA)
  ----------------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          telescope = true,
          which_key = true,
          cmp = true,
          gitsigns = true,
          mason = true,
          native_lsp = {
            enabled = true,
          },
	  lualine = true,
        },
      })
        vim.cmd.colorscheme("catppuccin")

        -- Comments → light green
        vim.api.nvim_set_hl(0, "Comment", {
        fg = "#a6e3a1",
        italic = true,
        })

        -- Line numbers → light yellow
        vim.api.nvim_set_hl(0, "LineNr", {
        fg = "#f9e2af",
        })

        vim.api.nvim_set_hl(0, "CursorLineNr", {
        fg = "#f9e2af",
        bold = true,
        })
    end,
  },

  ----------------------------------------------------------
  -- ICONS (fix warnings)
  ----------------------------------------------------------
  { "echasnovski/mini.icons", config = true },

  ----------------------------------------------------------
  -- WHICH-KEY
  ----------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

  ----------------------------------------------------------
  -- TELESCOPE
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
  -- LUALINE
  ----------------------------------------------------------
{
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'wombat',
        icons_enabled = true,
        section_separators = '',
        component_separators = '',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
    })
  end
},

  ----------------------------------------------------------
  -- UTILITIES
  ----------------------------------------------------------
  { "tpope/vim-commentary" },
  { "machakann/vim-highlightedyank" },
})

------------------------------------------------------------
-- BASIC KEYMAPS
------------------------------------------------------------
local map = vim.keymap.set

-- Escape
map("i", "jk", "<Esc>")

-- RESTORED: é → :
map("n", "é", ":")

-- Core navigation habits
map("n", "f", "/")
map("n", "Q", "gq")

-- Word operations (Rider-style)
map("n", "<leader>d", "diw")
map("n", "<leader>y", "yiw")
map("n", "<leader>c", "ciw")
map("n", "<leader>p", "viwp")
map("n", "<leader>a", "ggVG")

------------------------------------------------------------
-- LSP (Neovim 0.11+ MODERN API)
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

-- LSP servers
vim.lsp.config("pyright", {})
vim.lsp.enable("pyright")

vim.lsp.config("ts_ls", {})
vim.lsp.enable("ts_ls")

vim.lsp.config("omnisharp", {
  cmd = { "omnisharp" }
})
vim.lsp.enable("omnisharp")

------------------------------------------------------------
-- COMPLETION
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
-- TELESCOPE
------------------------------------------------------------
local telescope = require("telescope.builtin")

map("n", "<leader>ff", telescope.find_files)
map("n", "<leader>fc", telescope.live_grep)
map("n", "<leader>fr", telescope.oldfiles)

------------------------------------------------------------
-- WHICH-KEY (RESTORED LABELS)
------------------------------------------------------------
local wk = require("which-key")

wk.setup({})

wk.add({

  -- GO TO
  { "<leader>g", group = "Go to" },
  { "<leader>gd", desc = "Definition" },
  { "<leader>gi", desc = "Implementation" },
  { "<leader>gu", desc = "Usages" },

  -- REFACTOR
  { "<leader>r", group = "Refactor" },
  { "<leader>rn", desc = "Rename" },

  -- WORD OPERATIONS
  { "<leader>d", desc = "Cut word" },
  { "<leader>y", desc = "Copy word" },
  { "<leader>c", desc = "Change word" },
  { "<leader>p", desc = "Paste over word" },
  { "<leader>a", desc = "Select all" },

  -- FIND
  { "<leader>f", group = "Find" },
  { "<leader>ff", desc = "Files" },
  { "<leader>fc", desc = "Search text" },
  { "<leader>fr", desc = "Recent files" },
})
