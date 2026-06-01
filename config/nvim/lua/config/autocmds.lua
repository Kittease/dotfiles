-- Makefiles require real tabs
vim.api.nvim_create_autocmd("FileType", {
	pattern = "make",
	callback = function()
		vim.bo.expandtab = false
		vim.bo.softtabstop = 0
	end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})