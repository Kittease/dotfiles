return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	keys = {
		{ "<leader>mt", "<cmd>Markview toggle<CR>",       desc = "[M]arkview [T]oggle" },
		{ "<leader>mh", "<cmd>Markview hybridToggle<CR>", desc = "[M]arkview [H]ybrid toggle" },
		{ "<leader>ms", "<cmd>Markview splitToggle<CR>",  desc = "[M]arkview [S]plit toggle" },
	},
}
