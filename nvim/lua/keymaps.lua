local utils = require("utils")

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Navigate line
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)
keymap("v", "H", "^", opts)
keymap("v", "L", "$", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- no highlight
keymap("n", "<leader>h", ":nohl<cr>", opts)

-- save all buffer
keymap("n", "<leader>w", "<cmd>wa<cr>", opts)
-- exit cur window
keymap("n", "<leader>q", "<cmd>q<cr>", opts)
-- exit all
keymap("n", "<C-q>", "<cmd>wqa!<cr>", opts)

-- p does not replace reigster
keymap("v", "p", '"_dP', opts)

-- Nvim tree
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)
keymap("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", opts)

-- Buffer
keymap("n", "E", "<cmd>bn<cr>", opts)
keymap("n", "R", "<cmd>bp<cr>", opts)
keymap("n", "<leader>d", "<cmd>bd<cr>", opts)

-- Gitsigns
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", opts)
keymap("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", opts)
keymap("n", "]g", "<cmd>Gitsigns next_hunk<cr>", opts)
keymap("n", "[g", "<cmd>Gitsigns prev_hunk<cr>", opts)

-- cppp header/source switch
keymap("n", "<leader>j", "<cmd>ClangdSwitchSourceHeader<cr>", opts)
