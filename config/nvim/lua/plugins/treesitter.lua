---@module 'lazy'
---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
	config = function()
		local parsers = {
			-- Vim/Neovim
			"vim",
			"vimdoc",
			"lua",
			"luadoc",
			-- Shell
			"bash",
			"fish",
			-- Web
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"json",
			-- Python
			"python",
			-- Infrastructure
			"dockerfile",
			"yaml",
			"toml",
			-- Git
			"git_config",
			"git_rebase",
			"gitcommit",
			"gitignore",
			-- Markup / docs
			"markdown",
			"markdown_inline",
			"latex",
			"typst",
			-- DB / schema
			"prisma",
			-- Misc
			"c",
			"diff",
			"query",
			"regex",
		}
		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match
				local language = vim.treesitter.language.get_lang(filetype)
				if not language then
					return
				end
				if not vim.treesitter.language.add(language) then
					return
				end
				vim.treesitter.start(buf, language)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
