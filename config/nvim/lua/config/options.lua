vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = "a"

vim.o.showmode = false

-- Merge vim clipboard with system one's
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

-- nbsp = non-breakable space
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "•", nbsp = "␣" }

vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

-- Use spaces instead of tab characters, 2 spaces wide (tabstop left at default 8 for display)
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
