---@module 'lazy'
---@type LazySpec
return {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				-- Include hidden + gitignored files in all pickers, but never .git internals
				vimgrep_arguments = {
					"rg", "--color=never", "--no-heading", "--with-filename",
					"--line-number", "--column", "--smart-case",
					"--hidden", "--no-ignore-vcs",
					"--glob=!.git/**",
					"--glob=!node_modules/**",
					"--glob=!.next/**",
				},
			},
			pickers = {
				live_grep = {
					layout_strategy = "vertical",
					layout_config = { mirror = true, preview_height = 0.5, preview_cutoff = 0 },
				},
				grep_string = {
					layout_strategy = "vertical",
					layout_config = { mirror = true, preview_height = 0.5, preview_cutoff = 0 },
				},
			find_files = {
					layout_strategy = "vertical",
					layout_config = { mirror = true, preview_height = 0.5, preview_cutoff = 0 },
					hidden = true,
					no_ignore = true,
					find_command = {
						"fd", "--type", "f", "--hidden", "--no-ignore-vcs",
						"--exclude", ".git",
						"--exclude", "node_modules",
						"--exclude", ".next",
					},
				},
			},
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		local state = require("telescope.actions.state")

		-- Standard search keymaps
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set({ "n", "v" }, "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
		vim.keymap.set("n", "<leader>sc", builtin.commands, { desc = "[S]earch [C]ommands" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

		-- Search in a specific directory (pick folder via telescope first)
		local function pick_dir_then(callback)
			builtin.find_files({
				prompt_title = "Pick directory...",
				find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local dir = state.get_selected_entry()[1]
						actions.close(prompt_bufnr)
						callback(dir)
					end)
					return true
				end,
			})
		end

		vim.keymap.set("n", "<leader>sF", function()
			pick_dir_then(function(dir)
				builtin.find_files({ cwd = dir, prompt_title = "Files in " .. dir })
			end)
		end, { desc = "[S]earch [F]iles in dir" })

		vim.keymap.set("n", "<leader>sG", function()
			pick_dir_then(function(dir)
				builtin.live_grep({ search_dirs = { dir }, prompt_title = "Grep in " .. dir })
			end)
		end, { desc = "[S]earch by [G]rep in dir" })

		-- LSP keymaps (set on LspAttach so they are buffer-local)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("telescope-lsp-attach", { clear = true }),
			callback = function(event)
				local buf = event.buf
				vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })
				vim.keymap.set("n", "gri", builtin.lsp_implementations, { buffer = buf, desc = "[G]oto [I]mplementation" })
				vim.keymap.set("n", "grd", builtin.lsp_definitions, { buffer = buf, desc = "[G]oto [D]efinition" })
				vim.keymap.set("n", "gO", builtin.lsp_document_symbols, { buffer = buf, desc = "Open Document Symbols" })
				vim.keymap.set("n", "gW", builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = "Open Workspace Symbols" })
				vim.keymap.set("n", "grt", builtin.lsp_type_definitions, { buffer = buf, desc = "[G]oto [T]ype Definition" })
			end,
		})

		-- Diff: compare current file against any file picked via telescope
		vim.keymap.set("n", "<leader>dc", function()
			builtin.find_files({
				prompt_title = "Compare with...",
				attach_mappings = function(prompt_bufnr)
					actions.select_default:replace(function()
						local file = state.get_selected_entry()[1]
						actions.close(prompt_bufnr)
						vim.cmd("vsplit " .. vim.fn.fnameescape(file))
						vim.cmd("windo diffthis")
					end)
					return true
				end,
			})
		end, { desc = "[D]iff [C]ompare with file" })

		vim.keymap.set("n", "<leader>dC", "<cmd>windo diffoff<CR>", { desc = "[D]iff [C]lose" })

		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
		end, { desc = "[S]earch [/] in Open Files" })

		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
