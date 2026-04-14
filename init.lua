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
      wk.setup({
        delay = 0,
      })

      wk.register({
        k = {
          name = "Comment",
          l = "Line comment",
          b = "Block comment",
        },
        r = {
          name = "Refactor",
          n = "Rename",
          m = "Extract method",
          v = "Introduce variable",
          f = "Introduce field",
          s = "Change signature",
          r = "Refactor menu",
        },
        g = {
          name = "Goto",
          d = "Definition",
          y = "Type definition",
          i = "Implementation",
          u = "Usages",
          t = "Test",
          b = "Back",
          f = "Forward",
        },
      }, { prefix = "<leader>" })
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
})

------------------------------------------------------------
-- Comment mappings (IdeaVim actions → commentary)
------------------------------------------------------------
map("n", "<leader>kl", ":Commentary<CR>")
map("n", "<leader>kb", "gc") -- block comment via gc in visual mode

------------------------------------------------------------
-- Goto mappings (IdeaVim → LSP)
------------------------------------------------------------
local lsp = require("lspconfig")

-- Basic LSP servers (adjust as needed)
lsp.lua_ls.setup({})
lsp.tsserver.setup({})
lsp.pyright.setup({})

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