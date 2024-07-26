return {
	"rebelot/heirline.nvim",
	opts = function(_, opts)
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- load colors from colorscheme's palette
		-- local colors = require("catppuccin.palettes").get_palette("macchiato")

		local colors = {
			rosewater = "#f4dbd6",
			flamingo = "#f0c6c6",
			pink = "#f5bde6",
			mauve = "#c6a0f6",
			red = "#ed8796",
			maroon = "#ee99a0",
			peach = "#f5a97f",
			yellow = "#eed49f",
			green = "#a6da95",
			teal = "#8bd5ca",
			sky = "#91d7e3",
			sapphire = "#7dc4e4",
			blue = "#8aadf4",
			lavender = "#b7bdf8",
			text = "#cad3f5",
			subtext1 = "#b8c0e0",
			subtext0 = "#a5adcb",
			overlay2 = "#939ab7",
			overlay1 = "#8087a2",
			overlay0 = "#6e738d",
			surface2 = "#5b6078",
			surface1 = "#494d64",
			surface0 = "#363a4f",
			base = "#24273a",
			mantle = "#1e2030",
			crust = "#181926",
		}
		require("heirline").load_colors(colors)

		local ViMode = {
			init = function(self)
				-- get current mode
				self.mode = vim.fn.mode(1)
			end,

			-- map the mode to a string
			static = {
				mode_names = {
					n = "N",
					no = "N?",
					nov = "N?",
					noV = "N?",
					["no\22"] = "N?",
					niI = "Ni",
					niR = "Nr",
					niV = "Nv",
					nt = "Nt",
					v = "V",
					vs = "Vs",
					V = "V_",
					Vs = "Vs",
					["\22"] = "^V",
					["\22s"] = "^V",
					s = "S",
					S = "S_",
					["\19"] = "^S",
					i = "I",
					ic = "Ic",
					ix = "Ix",
					R = "R",
					Rc = "Rc",
					Rx = "Rx",
					Rv = "Rv",
					Rvc = "Rv",
					Rvx = "Rv",
					c = "C",
					cv = "Ex",
					r = "...",
					rm = "M",
					["r?"] = "?",
					["!"] = "!",
					t = "T",
				},
				mode_colors = {
					n = "maroon",
					i = "green",
					v = "sky",
					V = "sky",
					["\22"] = "sky",
					c = "peach",
					s = "mauve",
					S = "mauve",
					["\19"] = "mauve",
					R = "peach",
					r = "peach",
					["!"] = "red",
					t = "red",
				},
			},
			-- define the component
			provider = function(self)
				return "@%2(" .. self.mode_names[self.mode] .. "%)"
			end,
			hl = function(self)
				-- get the first character of the mode
				local mode = self.mode:sub(1, 1)
				return { fg = self.mode_colors[mode], bold = true }
			end,
			update = {
				"ModeChanged",
				pattern = "*:*",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		-- surround the ViMode with some characters
		ViMode = utils.surround({ "█", "█" }, "surface2", { ViMode })

		-- filename block
		local FileNameBlock = {
			init = function(self)
				-- get filename of current buffer
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
		}

		-- filename provider

		local FileName = {
			init = function(self)
				self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
				if self.lfilename == "" then
					self.lfilename = "[No Name]"
				end
			end,
			hl = { fg = "text", italic = true },

			flexible = 2,

			{
				provider = function(self)
					return self.lfilename
				end,
			},
			{
				provider = function(self)
					return vim.fn.pathshorten(self.lfilename)
				end,
			},
		}

		local FileIcon = {
			init = function(self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		local FileFlags = {
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = " ",
				hl = { fg = "sky" },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = "",
				hl = { fg = "peach" },
			},
		}

		local FileNameModifer = {
			hl = function()
				if vim.bo.modified then
					-- use `force` because we need to override the child's hl foreground
					return { fg = "sky", bold = true, force = true }
				end
			end,
		}

		FileNameBlock =
			utils.insert(FileNameBlock, utils.insert(FileNameModifer, FileName), FileFlags, { provider = "%<" })

		-- filetype
		local FileType = {
			provider = function()
				return string.upper(vim.bo.filetype)
			end,
			hl = { fg = utils.get_highlight("Type").fg, bold = true },
		}

		--file encoding
		local FileEncoding = {
			provider = function()
				local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
				return enc ~= "utf-8" and enc:upper()
			end,
		}

		-- file format
		local FileFormat = {
			provider = function()
				local fmt = vim.bo.fileformat
				return fmt ~= "unix" and fmt:upper()
			end,
		}

		-- file size
		local FileSize = {
			provider = function()
				-- stackoverflow, compute human readable file size
				local suffix = { "b", "k", "M", "G", "T", "P", "E" }
				local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
				fsize = (fsize < 0 and 0) or fsize
				if fsize < 1024 then
					return fsize .. suffix[1]
				end
				local i = math.floor((math.log(fsize) / math.log(1024)))
				return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
			end,
		}

		-- last modified time
		local FileLastModified = {
			-- did you know? Vim is full of functions!
			provider = function()
				local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
				return (ftime > 0) and os.date("%c", ftime)
			end,
		}

		-- percentage through file
		local Ruler = {
			-- %l = current line number
			-- %L = number of lines in the buffer
			-- %c = column number
			-- %P = percentage through file of displayed window
			provider = "%7(%l/%3L%):%2c %P",
		}

		-- scrollbar
		local ScrollBar = {
			static = {
				-- sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
				sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
			},
			provider = function(self)
				local curr_line = vim.api.nvim_win_get_cursor(0)[1]
				local lines = vim.api.nvim_buf_line_count(0)
				local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
				return string.rep(self.sbar[i], 2)
			end,
			hl = { fg = "sky", bg = "surface2" },
		}

		-- LSP diagnostics
		local Diagnostics = {

			condition = conditions.has_diagnostics,

			static = {
				error_icon = "E",
				warn_icon = "W",
				info_icon = "I",
				hint_icon = "H",
			},

			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,

			update = { "DiagnosticChanged", "BufEnter" },

			{
				provider = "![",
				hl = { fg = "overlay0" },
			},
			{
				provider = function(self)
					return self.errors > 0
						and (
							self.error_icon
							.. self.errors
							.. (self.warnings + self.hints + self.info > 0 and " " or "")
						)
				end,
				hl = { fg = "maroon" },
			},
			{
				provider = function(self)
					return self.warnings > 0
						and (self.warn_icon .. self.warnings .. (self.hints + self.info > 0 and " " or ""))
				end,
				hl = { fg = "peach" },
			},
			{
				provider = function(self)
					return self.info > 0 and (self.info_icon .. self.info .. (self.hints > 0 and " " or ""))
				end,
				hl = { fg = "green" },
			},
			{
				provider = function(self)
					return self.hints > 0 and (self.hint_icon .. self.hints)
				end,
				hl = { fg = "sky" },
			},
			{
				provider = "]",
				hl = { fg = "overlay0" },
			},
		}

		-- git status
		local Git = {
			condition = conditions.is_git_repo,

			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,

			hl = { fg = "mauve" },

			{ -- git branch name
				provider = function(self)
					return " " .. self.status_dict.head
				end,
				hl = { bold = true },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = "(",
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ("+" .. count)
				end,
				hl = { fg = "green" },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("-" .. count)
				end,
				hl = { fg = "red" },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("~" .. count)
				end,
				hl = { fg = "yellow" },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = ")",
			},
		}

		local HelpFileName = {
			condition = function()
				return vim.bo.filetype == "help"
			end,
			provider = function()
				local filename = vim.api.nvim_buf_get_name(0)
				return vim.fn.fnamemodify(filename, ":t")
			end,
			hl = { fg = colors.blue },
		}

		local Align = { provider = "%=" }
		local Space = { provider = " " }

		local DefaultStatusline = {
			ViMode,
			Space,
			FileNameBlock,
			Space,
			Git,
			Space,
			Diagnostics,
			Align,
			FileType,
			Space,
			Ruler,
			Space,
			ScrollBar,
		}

		local InactiveStatusline = {
			condition = conditions.is_not_active,
			FileType,
			Align,
		}

		local SpecialStatusline = {
			condition = function()
				return conditions.buffer_matches({
					buftype = { "nofile", "prompt", "help", "quickfix" },
					filetype = { "^git.*", "fugitive" },
				})
			end,

			FileType,
			Space,
			HelpFileName,
			Align,
		}

		local TerminalName = {
			-- we could add a condition to check that buftype == 'terminal'
			-- or we could do that later (see #conditional-statuslines below)
			provider = function()
				local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
				return " " .. tname
			end,
			hl = { fg = "mauve" },
		}

		local TerminalStatusline = {

			condition = function()
				return conditions.buffer_matches({ buftype = { "terminal" } })
			end,

			hl = { bg = "dark_red" },

			-- Quickly add a condition to the ViMode to only show it when buffer is active!
			{ condition = conditions.is_active, ViMode, Space },
			FileType,
			Space,
			TerminalName,
			Align,
		}

		local StatusLines = {

			hl = function()
				if conditions.is_active() then
					return "StatusLine"
				else
					return "StatusLineNC"
				end
			end,

			fallthrough = false,

			SpecialStatusline,
			TerminalStatusline,
			InactiveStatusline,
			DefaultStatusline,
		}

		-- tab numbers
		local TablineBufnr = {
			provider = function(self)
				return " " .. tostring(self.bufnr) .. ". "
			end,
			hl = "Comment",
		}

		local TablineFileName = {
			provider = function(self)
				local filename = self.filename
				filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
				return filename
			end,
			hl = function(self)
				local modified = vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				return {
					bold = self.is_active or self.is_visible,
					italic = not modified,
					fg = (modified and "sky") or "text",
				}
			end,
		}

		local TablineFileFlags = {
			{
				condition = function(self)
					return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				end,
				provider = "  ",
				hl = { fg = "sky" },
			},
			{
				condition = function(self)
					return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
						or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
				end,
				provider = function(self)
					if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
						return "  "
					else
						return ""
					end
				end,
				hl = { fg = "peach" },
			},
		}

		local TablineFileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,
			hl = function(self)
				if self.is_active then
					return { bg = "surface1", fg = "sky" }
				-- why not?
				elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
					return { fg = "gray" }
				else
					return "TabLine"
				end
			end,
			on_click = {
				callback = function(_, minwid, _, button)
					if button == "m" then
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
						end)
					else
						vim.api.nvim_win_set_buf(0, minwid)
					end
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = "heirline_tabline_buffer_callback",
			},
			TablineBufnr,
			FileIcon,
			TablineFileName,
			TablineFileFlags,
		}

		local TablineCloseButton = {
			condition = function(self)
				return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
			end,
			{
				provider = " 󰅖 ",
				hl = { fg = "rosewater" },
				on_click = {
					callback = function(_, minwid)
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
							vim.cmd.redrawtabline()
						end)
					end,
					minwid = function(self)
						return self.bufnr
					end,
					name = "heirline_tabline_close_buffer_callback",
				},
			},
		}

		local TablineBufferBlock = utils.surround({ " ", "" }, function(self)
			if self.is_active then
				return utils.get_highlight("TabLineSel").bg
			else
				return utils.get_highlight("TabLine").bg
			end
		end, { TablineFileNameBlock, TablineCloseButton })

		local get_bufs = function()
			return vim.tbl_filter(function(bufnr)
				return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
			end, vim.api.nvim_list_bufs())
		end

		local buflist_cache = {}

		vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
			callback = function()
				vim.schedule(function()
					local buffers = get_bufs()
					for i, v in ipairs(buffers) do
						buflist_cache[i] = v
					end
					for i = #buffers + 1, #buflist_cache do
						buflist_cache[i] = nil
					end

					if #buflist_cache > 1 then
						vim.o.showtabline = 2
					elseif vim.o.showtabline ~= 1 then
						vim.o.showtabline = 1
					end
				end)
			end,
		})

		local TablinePicker = {
			condition = function(self)
				return self._show_picker
			end,
			init = function(self)
				local bufname = vim.api.nvim_buf_get_name(self.bufnr)
				bufname = vim.fn.fnamemodify(bufname, ":t")
				local label = bufname:sub(1, 1)
				local i = 2
				while self._picker_labels[label] do
					if i > #bufname then
						break
					end
					label = bufname:sub(i, i)
					i = i + 1
				end
				self._picker_labels[label] = self.bufnr
				self.label = label
			end,
			provider = function(self)
				return self.label
			end,
			hl = { fg = "red", bold = true },
		}

		local BufferLine = utils.make_buflist(
			{ TablineBufferBlock, TablinePicker },
			{ provider = " ", hl = { fg = "gray" } },
			{ provider = " ", hl = { fg = "gray" } },
			function()
				return buflist_cache
			end,
			false
		)

		local Tabpage = {
			provider = function(self)
				return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
			end,
			hl = function(self)
				if not self.is_active then
					return "TabLine"
				else
					return "TabLineSel"
				end
			end,
		}

		local TabpageClose = {
			provider = " 󰅖 ",
			hl = { fg = "rosewater" },
		}

		local TabPages = {
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			{ provider = "%=" },
			utils.make_tablist(Tabpage),
			TabpageClose,
		}

		local TabLineOffset = {
			condition = function(self)
				local win = vim.api.nvim_tabpage_list_wins(0)[1]
				local bufnr = vim.api.nvim_win_get_buf(win)
				self.winid = win
				if vim.bo[bufnr].filetype == "neo-tree" then
					self.title = "Tree"
					return true
				end
			end,

			provider = function(self)
				local title = self.title
				local width = vim.api.nvim_win_get_width(self.winid)
				local pad = math.ceil((width - #title) / 2)
				return string.rep(" ", pad) .. title .. string.rep(" ", pad)
			end,

			hl = function(self)
				if vim.api.nvim_get_current_win() == self.winid then
					return "TablineSel"
				else
					return "Tabline"
				end
			end,
		}

		local TabLine = { TabLineOffset, BufferLine, TabPages }

		require("heirline").setup({
			statusline = StatusLines,
			tabline = TabLine,
		})

		vim.o.showtabline = 2
		vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
	end,
}
