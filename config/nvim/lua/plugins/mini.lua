---@module 'lazy'
---@type LazySpec
return {
	"nvim-mini/mini.nvim",
	config = function()
		-- Better text-object motions (e.g. va), di), etc.)
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		-- saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- sd'   - [S]urround [D]elete [']quotes
		-- sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		-- Delete current buffer while keeping the window layout intact
		require("mini.bufremove").setup()
		vim.keymap.set("n", "<leader>bd", function()
			require("mini.bufremove").delete(0, false)
		end, { desc = "[B]uffer [D]elete" })
		vim.keymap.set("n", "<leader>bD", function()
			require("mini.bufremove").delete(0, true)
		end, { desc = "[B]uffer [D]elete force" })

		-- Simple statusline
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_git = function()
			return ""
		end

		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
