------------------------------------------------------------
-- Leader key
------------------------------------------------------------
vim.g.mapleader = " "

------------------------------------------------------------
-- Basic options (IdeaVim equivalents)
------------------------------------------------------------
vim.opt.scrolloff = 5
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.timeout = false -- IdeaVim: set notimeout

------------------------------------------------------------
-- Keymaps
------------------------------------------------------------
local map = vim.keymap.set

-- jk = escape
map("i", "jk", "<Esc>")

-- é = :
map("n", "é", ":")

-- f = /
map("n", "f", "/")

-- Q = gq (format)
map("n", "Q", "gq")

-- Edit and reload config (IdeaVim: \e and \r)
map("n", "\\e", ":e $MYVIMRC<CR>")
map("n", "\\r", ":source $MYVIMRC<CR>")

-- Word operations
map("n", "<leader>d", "diw")   -- cut word
map("n", "<leader>y", "yiw")   -- yank word
map("n", "<leader>c", "ciw")   -- change word
map("n", "<leader>p", "viwp")  -- paste over word

-- Select all
map("n", "<leader>a", "ggVG")

------------------------------------------------------------
-- Plugin manager: lazy.nvim
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
-- Plugins (IdeaVim equivalents)
------------------------------------------------------------
require("lazy").setup({
  -- Highlight yanked text (IdeaVim: vim-highlightedyank)
  {
    "machakann/vim-highlightedyank",
  },

  -- Commentary (IdeaVim: vim-commentary)
  {
    "tpope/vim-commentary",
  },

  -- Which-key (IdeaVim: built-in which-key)
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup({ delay = 0 })

      wk.add({
        -- Goto group
        { "<leader>g", group = "Goto" },
        { "<leader>gd", desc = "Definition" },
        { "<leader>gy", desc = "Type definition" },
        { "<leader>gi", desc = "Implementation" },
        { "<leader>gu", desc = "Usages" },
        { "<leader>gt", desc = "Test" },
        { "<leader>gb", desc = "Back" },
        { "<leader>gf", desc = "Forward" },

        -- Comment group
        { "<leader>k", group = "Comment" },
        { "<leader>kl", desc = "Line comment" },
        { "<leader>kb", desc = "Block comment" },

        -- Word operations
        { "<leader>d", desc = "Cut word" },
        { "<leader>y", desc = "Yank word" },
        { "<leader>c", desc = "Change word" },
        { "<leader>p", desc = "Paste word" },
        { "<leader>a", desc = "Select all" },

        -- Refactor group (placeholders unless you add a refactor plugin)
        { "<leader>r", group = "Refactor" },
        { "<leader>rn", desc = "Rename" },
        { "<leader>rm", desc = "Extract method" },
        { "<leader>rv", desc = "Introduce variable" },
        { "<leader>rf", desc = "Introduce field" },
        { "<leader>rs", desc = "Change signature" },
        { "<leader>rr", desc = "Refactor menu" },
      })
    end,
  },

  -- Easymotion alternative (IdeaVim: easymotion)
  {
    "phaazon/hop.nvim",
    branch = "v2",
    config = function()
      require("hop").setup()
      map("n", "<leader>j", ":HopChar2<CR>")
    end,
  },

  {
    "neovim/nvim-lspconfig",
  },

  {
     "echasnovski/mini.icons"
  },

  {
     "nvim-tree/nvim-web-devicons"
  },
})

------------------------------------------------------------
-- Comment mappings (IdeaVim actions → commentary)
------------------------------------------------------------
map("n", "<leader>kl", ":Commentary<CR>")
map("n", "<leader>kb", "gc") -- block comment via gc in visual mode

------------------------------------------------------------
-- Goto mappings (IdeaVim → LSP)
------------------------------------------------------------
-- LSP setup for Neovim 0.12.1
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

lspconfig.lua_ls.setup({})

-- tsserver is deprecated → use ts_ls
lspconfig.ts_ls.setup({})

lspconfig.pyright.setup({})

map("n", "<leader>gd", vim.lsp.buf.definition)
map("n", "<leader>gy", vim.lsp.buf.type_definition)
map("n", "<leader>gi", vim.lsp.buf.implementation)
map("n", "<leader>gu", vim.lsp.buf.references)
map("n", "<leader>gt", vim.lsp.buf.declaration)
map("n", "<leader>gb", "<C-o>")
map("n", "<leader>gf", "<C-i>")

------------------------------------------------------------
-- Cursor compatibility: wrap vim.cmd calls
------------------------------------------------------------
pcall(vim.cmd, "syntax on")
pcall(vim.cmd, "filetype plugin indent on")