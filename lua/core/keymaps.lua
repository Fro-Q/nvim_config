vim.g.mapleader = " "

local key = vim.keymap

-- insert mode
key.set("i", "jk", function()
	if require("cmp").visible() then
		require("cmp").abort()
	else
		vim.cmd("stopinsert")
	end
end, { desc = "Exit insert mode with jk" })
key.set("i", "JK", "<Esc>", { desc = "Exit insert mode with JK" })

-- view mode
key.set("v", "J", ":m '>+1<CR>gv=gv")
key.set("v", "K", ":m '<-2<CR>gv=gv")
-- split view
key.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
key.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
key.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
key.set("n", "<leader>sw", "<cmd>close<CR>", { desc = "Close current split" })

-- cancle search highlight
key.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- buffer navigation
key.set("n", "<S-L>", ":bnext<CR>")
key.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
key.set("n", "<S-H>", ":bprevious<CR>")
key.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
key.set("n", "<leader>c", ":bdelete<CR>", { desc = "Close buffer" })
key.set("n", "<leader>bg", function()
	local tabline = require("heirline").tabline
	local buflist = tabline._buflist[1]
	buflist._picker_labels = {}
	buflist._show_picker = true
	vim.cmd.redrawtabline()
	local char = vim.fn.getcharstr()
	local bufnr = buflist._picker_labels[char]
	if bufnr then
		vim.api.nvim_win_set_buf(0, bufnr)
	end
	buflist._show_picker = false
	vim.cmd.redrawtabline()
end, { desc = "Buffer picker" })

-- open neo-tree
vim.keymap.set("n", "<leader>e", function()
	-- vim.cmd("Neotree focus toggle filesystem left")
	vim.cmd([[
    Neotree focus toggle filesystem left
    horizontal wincmd =
  ]])
end, { desc = "Toggle file explorer" }) -- toggle file explorer

vim.keymap.set("n", "<leader>`", function()
	vim.cmd("Neotree focus toggle document_symbols right")
end, { desc = "Toggle document symbols" }) -- toggle document symbols

-- auto session
-- key.set("n", "<leader>ss", ":SessionSave<CR>", { desc = "Save session" })
-- key.set("n", "<leader>sr", ":SessionRestore<CR>", { desc = "Load session" })

-- increase or decrease number under cursor
key.set("n", "-", "<C-a>", { desc = "Increase number under cursor" })
key.set("n", "+", "<C-x>", { desc = "Decrease number under cursor" })

-- format file or range
-- key.set({ "n", "v" }, "<leader>mp", function()
-- 	require("conform").format({
-- 		lsp_fallback = true,
-- 		async = false,
-- 		timeout_ms = 1000,
-- 	})
-- end, { desc = "Format file or range (in visual mode)" })

-- lint file
key.set("n", "<leader>l", function()
	require("lint").try_lint()
end, { desc = "Trigger linting for current file" })

-- open terminal
key.set(
	"n",
	"<leader>t1",
	":1ToggleTerm size=10 dir=./ direction=horizontal name=Term1<CR>",
	{ desc = "Toggle terminal 1" }
)
key.set(
	"n",
	"<leader>t2",
	":2ToggleTerm size=10 dir=./ direction=horizontal name=Term2<CR>",
	{ desc = "Toggle terminal 2" }
)
key.set(
	"n",
	"<leader>t3",
	":3ToggleTerm size=10 dir=./ direction=horizontal name=Term3<CR>",
	{ desc = "Toggle terminal 3" }
)
key.set(
	"n",
	"<leader>t4",
	":4ToggleTerm size=10 dir=./ direction=horizontal name=Term4<CR>",
	{ desc = "Toggle terminal 4" }
)

key.set("n", "<leader>ta", ":ToggleTermToggleAll<CR>", { desc = "Toggle all terminals" })

key.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode with jk" })
