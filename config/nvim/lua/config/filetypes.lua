vim.filetype.add({
	extension = {
		tpl    = "gotmpl", -- Helm templates
		gotmpl = "gotmpl",
		jsonc  = "jsonc",
	},
	filename = {
		["docker-compose.yml"]  = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		[".gitlab-ci.yml"]      = "yaml.gitlab",
	},
	pattern = {
		-- Docker Compose variants: docker-compose.prod.yml, etc.
		["docker%-compose%..*%.ya?ml"]      = "yaml.docker-compose",
		-- GitLab CI variants: .gitlab-ci.staging.yml, etc.
		["%.gitlab%-ci%..*%.ya?ml"]         = "yaml.gitlab",
		-- GitHub Actions
		[".*/%.github/workflows/.*%.ya?ml"] = "yaml.github-actions",
		[".*/%.github/actions/.*%.ya?ml"]   = "yaml.github-actions",
		-- Dockerfile variants: Dockerfile.prod, Dockerfile.dev, etc.
		["Dockerfile%..*"]                  = "dockerfile",
		[".*%.dockerfile"]                  = "dockerfile",
		-- Helm templates: only when a Chart.yaml exists above the file
		[".*/templates/.*%.ya?ml"] = function(path)
			local chart = vim.fs.find("Chart.yaml", {
				path = vim.fs.dirname(path),
				upward = true,
				stop = vim.env.HOME,
			})
			if #chart > 0 then return "helm" end
		end,
	},
})
