-- NVim Config
-- Adapted from kickstart.nvim

-- Leader key must be set before lazy.nvim loads any plugin
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- [[ Vim/NVim config ]]
require("config.options")
require("config.filetypes")
require("config.keymaps")
require("config.autocmds")

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require("lazy").setup({
	require("plugins.colorscheme"),
	require("plugins.which-key"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.formatting"),
	require("plugins.completion"),
	require("plugins.treesitter"),
	require("plugins.todo-comments"),
	require("plugins.mini"),
	require("plugins.gitsigns"),
	require("plugins.debug"),
	require("plugins.indent_line"),
	require("plugins.lint"),
	require("plugins.autopairs"),
	require("plugins.neo-tree"),
	require("plugins.markview"),
	require("plugins.neocodeium"),
	require("plugins.grug-far"),
	require("plugins.autotag"),
}, {
	ui = { icons = {} },
})

-- vim: ts=2 sts=2 sw=2
