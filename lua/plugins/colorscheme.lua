return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	-- Optional; default configuration will be used if setup isn't called.
	config = function()
		require("everforest").setup({
			show_eob = false,
			background = "hard",
			transparent_background_level = 2,
			italics = true,
			disable_italic_comment = false,
			sign_column_background = "none",
			ui_contrast = "high",
			dim_inactive_windows = false,
			diagnostic_text_highlight = true,
			diagnostic_virtual_text = "coloured",
			diagnostic_line_highlight = true,
			spell_foreground = false,
			float_style = "bright",
			inlay_hints_background = "dimmed",
			on_highlights = function(hl_group, palette) end,
			colours_override = function(palette) end,
			disable_italic_comments = false,
		})

		vim.cmd("colorscheme everforest")
	end,
}
