return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {

		spec = {
			{ "<leader>f", desc = "Fuzzy Finder" },
			{ "<leader>d", desc = "Diagnostics" },
			{ "<leader>s", desc = "Splits" },
			{ "<leader>h", desc = "Gitsigns" },
			{ "<leader>b", desc = "Buffers" },
			{ "<leader>t", desc = "Terminal" },
			{ "<leader>x", desc = "Troubles" },
		},
	},
}
