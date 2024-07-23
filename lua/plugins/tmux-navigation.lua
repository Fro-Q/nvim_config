return {
	"alexghergh/nvim-tmux-navigation",
	config = function()
		require("nvim-tmux-navigation").setup({
			keybindings = {
				left = "<C-h>",
				down = "<C-j>",
				up = "<C-k>",
				right = "<C-l>",
				previous = "<C-\\>",
				next = "<C-Space>",
			},
			-- cycle_navigation = true,
			-- cycle_reset = "<C-Space>",
			-- enable_default_keybindings = true,
			-- enable_default_keybindings = false,
		})
	end,
}
