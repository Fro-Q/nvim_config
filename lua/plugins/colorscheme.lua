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
			dim_inactive = {
				shade = "dark",
				enabled = false,
				percentage = 0.1,
			},
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = { "italic" },
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {},
			default_integrations = true,
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				telescope = true,
				which_key = true,
				alpha = true,
				mason = true,
				neotree = true,
			},
			custom_highlights = function(C)
				return {
					WinSeparator = { fg = C.surface0 },
				}
			end,
		})

		vim.cmd("colorscheme catppuccin")
	end,
}
