return {
	-- "neanias/everforest-nvim",
	"catppuccin/nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	-- Optional; default configuration will be used if setup isn't called.
	config = function()
		require("catppuccin").setup({
			flavour = "macchiato",
			transparent_background = true,
			show_end_of_buffer = false,
			term_colors = false,
		})

		vim.cmd("colorscheme catppuccin")
	end,
}
