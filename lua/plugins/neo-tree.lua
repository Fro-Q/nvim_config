return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"3rd/image.nvim",
	},
	config = function()
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

		require("neo-tree").setup({
			sources = {
				"filesystem",
				"buffers",
				"git_status",
				"document_symbols",
			},
			add_blank_line_at_top = false, -- Add a blank line at the top of the tree.
			auto_clean_after_session_restore = true, -- Automatically clean up broken neo-tree buffers saved in sessions
			close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
			default_source = "filesystem",
			enable_diagnostics = true,
			enable_git_status = true,
			enable_modified_markers = true, -- Show markers for files with unsaved changes.
			enable_opened_markers = true, -- Enable tracking of opened files. Required for `components.name.highlight_opened_files`
			enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
			enable_cursor_hijack = true,
			git_status_async = true,
			-- These options are for people with VERY large git repos
			git_status_async_options = {
				batch_size = 1000, -- how many lines of git status results to process at a time
				batch_delay = 10, -- delay in ms between batches. Spreads out the workload to let other processes run.
				max_lines = 10000, -- How many lines of git status results to process. Anything after this will be dropped.
				-- Anything before this will be used. The last items to be processed are the untracked files.
			},
			hide_root_node = false, -- Hide the root node.
			retain_hidden_root_indent = false, -- IF the root node is hidden, keep the indentation anyhow.
			-- This is needed if you use expanders because they render in the indent.
			log_level = "info", -- "trace", "debug", "info", "warn", "error", "fatal"
			log_to_file = false, -- true, false, "/path/to/file.log", use :NeoTreeLogs to show the file
			open_files_in_last_window = true, -- false = open files in top left window
			open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "edgy" }, -- when opening files, do not use windows containing these filetypes or buftypes
			-- popup_border_style is for input and confirmation dialogs.
			-- Configurtaion of floating window is done in the individual source sections.
			-- "NC" is a special style that works well with NormalNC set
			popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
			resize_timer_interval = 500, -- in ms, needed for containers to redraw right aligned and faded content
			-- set to -1 to disable the resize timer entirely
			sort_case_insensitive = false, -- used when sorting files and directories in the tree
			sort_function = nil, -- uses a custom function for sorting files and directories in the tree
			use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
			use_default_mappings = true,
			-- source_selector provides clickable tabs to switch between sources.
			source_selector = {
				winbar = false, -- toggle to show selector on winbar
				statusline = false, -- toggle to show selector on statusline
				show_scrolled_off_parent_node = true, -- this will replace the tabs with the parent path
				-- of the top visible node when scrolled down.
				sources = {
					{ source = "filesystem" },
					{ source = "buffers" },
					{ source = "git_status" },
					{ source = "document_symbols" },
				},
				content_layout = "center", -- only with `tabs_layout` = "equal", "focus"
				--                start  : |/ 󰓩 bufname     \/...
				--                end    : |/     󰓩 bufname \/...
				--                center : |/   󰓩 bufname   \/...
				tabs_layout = "active", -- start, end, center, equal, focus
				--             start  : |/  a  \/  b  \/  c  \            |
				--             end    : |            /  a  \/  b  \/  c  \|
				--             center : |      /  a  \/  b  \/  c  \      |
				--             equal  : |/    a    \/    b    \/    c    \|
				--             active : |/  focused tab    \/  b  \/  c  \|
				truncation_character = "…", -- character to use when truncating the tab label
				tabs_min_width = nil, -- nil | int: if int padding is added based on `content_layout`
				tabs_max_width = nil, -- this will truncate text even if `text_trunc_to_fit = false`
				padding = 0, -- can be int or table
				-- padding = { left = 2, right = 0 },
				separator = "█", -- can be string or table, see below
				-- separator = { left = "▏", right = "▕" },
				-- separator = { left = "/", right = "\\", override = nil },     -- |/  a  \/  b  \/  c  \...
				-- separator = { left = "/", right = "\\", override = "right" }, -- |/  a  \  b  \  c  \...
				-- separator = { left = "/", right = "\\", override = "left" }, -- |/  a  /  b  /  c  /...
				-- separator = { left = "/", right = "\\", override = "active" }, -- |/  a  / b:active \  c  \...
				-- separator = "|",                                              -- ||  a  |  b  |  c  |...
				separator_active = nil, -- set separators around the active tab. nil falls back to `source_selector.separator`
				show_separator_on_edge = false,
				--                       true  : |/    a    \/    b    \/    c    \|
				--                       false : |     a    \/    b    \/    c     |
				highlight_tab = "NeoTreeTabInactive",
				highlight_tab_active = "NeoTreeTabActive",
				highlight_background = "NeoTreeTabInactive",
				highlight_separator = "NeoTreeTabSeparatorInactive",
				highlight_separator_active = "NeoTreeTabSeparatorActive",
			},
			--
			--event_handlers = {
			--  {
			--    event = "before_render",
			--    handler = function (state)
			--      -- add something to the state that can be used by custom components
			--    end
			--  },
			--  {
			--    event = "file_opened",
			--    handler = function(file_path)
			--      --auto close
			--      require("neo-tree.command").execute({ action = "close" })
			--    end
			--  },
			--  {
			--    event = "file_opened",
			--    handler = function(file_path)
			--      --clear search after opening a file
			--      require("neo-tree.sources.filesystem").reset_search()
			--    end
			--  },
			--  {
			--    event = "file_renamed",
			--    handler = function(args)
			--      -- fix references to file
			--      print(args.source, " renamed to ", args.destination)
			--    end
			--  },
			--  {
			--    event = "file_moved",
			--    handler = function(args)
			--      -- fix references to file
			--      print(args.source, " moved to ", args.destination)
			--    end
			--  },
			--  {
			--    event = "neo_tree_buffer_enter",
			--    handler = function()
			--      vim.cmd 'highlight! Cursor blend=100'
			--    end
			--  },
			--  {
			--    event = "neo_tree_buffer_leave",
			--    handler = function()
			--      vim.cmd 'highlight! Cursor guibg=#5f87af blend=0'
			--    end
			--  },
			-- {
			--   event = "neo_tree_window_before_open",
			--   handler = function(args)
			--     print("neo_tree_window_before_open", vim.inspect(args))
			--   end
			-- },
			-- {
			--   event = "neo_tree_window_after_open",
			--   handler = function(args)
			--     vim.cmd("wincmd =")
			--   end
			-- },
			-- {
			--   event = "neo_tree_window_before_close",
			--   handler = function(args)
			--     print("neo_tree_window_before_close", vim.inspect(args))
			--   end
			-- },
			-- {
			--   event = "neo_tree_window_after_close",
			--   handler = function(args)
			--     vim.cmd("wincmd =")
			--   end
			-- }
			--},
			default_component_configs = {
				container = {
					enable_character_fade = true,
					width = "100%",
					right_padding = 0,
				},
				diagnostics = {
					symbols = {
						hint = "H",
						info = "I",
						warn = "W",
						error = "E",
					},
					highlights = {
						hint = "DiagnosticSignHint",
						info = "DiagnosticSignInfo",
						warn = "DiagnosticSignWarn",
						error = "DiagnosticSignError",
					},
				},
				indent = {
					indent_size = 2,
					padding = 1,
					-- indent guides
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					-- expander config, needed for nesting files
					with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "󰉖",
					folder_empty_open = "󰷏",
					-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
					-- then these will never be used.
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = " ",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = true,
					highlight_opened_files = false, -- Requires `enable_opened_markers = true`.
					-- Take values in { false (no highlight), true (only loaded),
					-- "all" (both loaded and unloaded)}. For more information,
					-- see the `show_unloaded` config of the `buffers` source.
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "+", -- NOTE: you can set any of these to an empty string to not show them
						deleted = "-",
						modified = "~",
						renamed = ">",
						-- Status type
						untracked = "?",
						ignored = "/",
						unstaged = "!",
						staged = "",
						conflict = "",
					},
					align = "right",
				},
				-- If you don't want to use these columns, you can set `enabled = false` for each of them individually
				file_size = {
					enabled = true,
					required_width = 64, -- min width of window required to show this column
				},
				type = {
					enabled = true,
					required_width = 110, -- min width of window required to show this column
				},
				last_modified = {
					enabled = true,
					required_width = 88, -- min width of window required to show this column
				},
				created = {
					enabled = false,
					required_width = 120, -- min width of window required to show this column
				},
				symlink_target = {
					enabled = false,
				},
			},
			renderers = {
				directory = {
					{ "indent" },
					{ "icon" },
					{ "current_filter" },
					{
						"container",
						content = {
							{ "name", zindex = 10 },
							{
								"symlink_target",
								zindex = 10,
								highlight = "NeoTreeSymbolicLinkTarget",
							},
							{ "clipboard", zindex = 10 },
							{
								"diagnostics",
								errors_only = true,
								zindex = 20,
								align = "right",
								hide_when_expanded = true,
							},
							{ "git_status", zindex = 10, align = "right", hide_when_expanded = true },
							{ "file_size", zindex = 10, align = "right" },
							{ "type", zindex = 10, align = "right" },
							{ "last_modified", zindex = 10, align = "right" },
							{ "created", zindex = 10, align = "right" },
						},
					},
				},
				file = {
					{ "indent" },
					{ "icon" },
					{
						"container",
						content = {
							{
								"name",
								zindex = 10,
							},
							{
								"symlink_target",
								zindex = 10,
								highlight = "NeoTreeSymbolicLinkTarget",
							},
							{ "clipboard", zindex = 10 },
							{ "bufnr", zindex = 10 },
							{ "modified", zindex = 20, align = "right" },
							{ "diagnostics", zindex = 20, align = "right" },
							{ "git_status", zindex = 10, align = "right" },
							{ "file_size", zindex = 10, align = "right" },
							{ "type", zindex = 10, align = "right" },
							{ "last_modified", zindex = 10, align = "right" },
							{ "created", zindex = 10, align = "right" },
						},
					},
				},
				message = {
					{ "indent", with_markers = false },
					{ "name", highlight = "NeoTreeMessage" },
				},
				terminal = {
					{ "indent" },
					{ "icon" },
					{ "name" },
					{ "bufnr" },
				},
			},
			nesting_rules = {},
			-- Global custom commands that will be available in all sources (if not overridden in `opts[source_name].commands`)
			--
			-- You can then reference the custom command by adding a mapping to it:
			--    globally    -> `opts.window.mappings`
			--    locally     -> `opt[source_name].window.mappings` to make it source specific.
			--
			-- commands = {              |  window {                 |  filesystem {
			--   hello = function()      |    mappings = {           |    commands = {
			--     print("Hello world")  |      ["<C-c>"] = "hello"  |      hello = function()
			--   end                     |    }                      |        print("Hello world in filesystem")
			-- }                         |  }                        |      end
			--
			-- see `:h neo-tree-custom-commands-global`
			commands = {
				trash = function(state)
					local node = state.tree:get_node()
					if node.type == "message" then
						return
					end
					local _, name = require("neo-tree.utils").split_path(node.path)
					local msg = string.format("Are you sure you want to trash '%s'?", name)
					require("neo-tree.ui.inputs").confirm(msg, function(confirmed)
						if not confirmed then
							return
						end
						vim.api.nvim_command("silent !trash " .. node.path)
						require("neo-tree.sources.manager").refresh(state)
					end)
				end,
			}, -- A list of functions

			window = { -- see https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup for
				-- possible options. These can also be functions that return these options.
				position = "left", -- left, right, top, bottom, float, current
				width = 40, -- applies to left and right positions
				height = 15, -- applies to top and bottom positions
				auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
				popup = { -- settings that apply to float position only
					size = {
						height = "80%",
						width = "50%",
					},
					position = "50%", -- 50% means center it
					-- you can also specify border here, if you want a different setting from
					-- the global popup_border_style.
				},
				same_level = false, -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
				insert_as = "child", -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
				-- "child":   Insert nodes as children of the directory under cursor.
				-- "sibling": Insert nodes  as siblings of the directory under cursor.
				-- Mappings for tree window. See `:h neo-tree-mappings` for a list of built-in commands.
				-- You can also create your own commands by providing a function instead of a string.
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					-- root dir
					["<c-[>"] = "navigate_up",
					["<c-]>"] = "set_root",
					["."] = "set_root",

					-- navigation
					["h"] = "close_node",
					["<bs>"] = "close_node",
					["<S-Tab>"] = "close_node",
					["<leader>sh"] = "open_split",
					["<leader>sv"] = "open_vsplit",
					["t"] = "open_tabnew",

					-- buffers and tabs
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },

					-- preview
					["<C-f>"] = { "scroll_preview", config = { direction = -10 } },
					["<C-b>"] = { "scroll_preview", config = { direction = 10 } },

					["<esc>"] = "cancel", -- close preview or floating neo-tree window
					["R"] = "refresh",

					-- file operation
					["a"] = {
						"add",
						config = {
							show_path = "relative", -- "none", "relative", "absolute"
						},
					},
					["d"] = "trash",
					["D"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
					["m"] = "move", -- takes text input for destination, also accepts the config.show_path and config.insert_as options
					["e"] = "toggle_auto_expand_width",
					["q"] = "close_window",
					["?"] = "show_help",

					["i"] = "show_file_details",
					["O"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
				},
			},
			filesystem = {
				commands = {
					navigate_preview = function(state)
						local node = state.tree:get_node()

						if node and node.type == "directory" then
							require("neo-tree.sources.filesystem.commands").toggle_node(state)
							vim.api.nvim_feedkeys("j", "n", true)
						else
							require("neo-tree.sources.common.preview").toggle(state)
						end
					end,
					navigate_open = function(state)
						local node = state.tree:get_node()

						if node and node.type == "directory" then
							require("neo-tree.sources.filesystem.commands").toggle_node(state)
							vim.api.nvim_feedkeys("j", "n", true)
						else
							require("neo-tree.sources.filesystem.commands").open(state)
						end
					end,
				},
				window = {
					mappings = {
						["l"] = "navigate_preview",
						["<Tab>"] = "navigate_preview",

						["<cr>"] = "navigate_open",
						["o"] = "navigate_open",
						["<2-LeftMouse>"] = "navigate_open",

						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
						["f"] = "filter_on_submit",
						["<C-x>"] = "clear_filter",
					},
					fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
						["<down>"] = "move_cursor_down",
						["<C-n>"] = "move_cursor_down",
						["<up>"] = "move_cursor_up",
						["<C-p>"] = "move_cursor_up",
					},
				},
				async_directory_scan = "auto", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
				-- "always" means directory scans are always async.
				-- "never"  means directory scans are never async.
				scan_mode = "shallow", -- "shallow": Don't scan into directories to detect possible empty directory a priori
				-- "deep": Scan into directories to detect empty or grouped empty directories a priori.
				bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
				cwd_target = {
					sidebar = "tab", -- sidebar is when position = left or right
					current = "window", -- current is when position = current
				},
				check_gitignore_in_search = true, -- check gitignore status for files/directories when searching
				-- setting this to false will speed up searches, but gitignored
				-- items won't be marked if they are visible.
				-- The renderer section provides the renderers that will be used to render the tree.
				--   The first level is the node type.
				--   For each node type, you can specify a list of components to render.
				--       Components are rendered in the order they are specified.
				--         The first field in each component is the name of the function to call.
				--         The rest of the fields are passed to the function as the "config" argument.
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					force_visible_in_empty_folder = false, -- when true, hidden files will be shown if the root folder is otherwise empty
					show_hidden_count = true, -- when true, the number of hidden items in each folder will be shown as the last entry
					hide_dotfiles = true,
					hide_gitignored = true,
					hide_hidden = true, -- only works on Windows for hidden files/directories
					hide_by_name = {
						".DS_Store",
						"thumbs.db",
						--"node_modules",
					},
					hide_by_pattern = { -- uses glob style patterns
						--"*.meta",
						--"*/src/*/tsconfig.json"
					},
					always_show = { -- remains visible even if other settings would normally hide it
						--".gitignored",
					},
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						--".DS_Store",
						--"thumbs.db"
					},
					never_show_by_pattern = { -- uses glob style patterns
						--".null-ls_*",
					},
				},
				find_by_full_path_words = false, -- `false` means it only searches the tail of a path.
				-- `true` will change the filter into a full path
				-- search with space as an implicit ".*", so
				-- `fi init`
				-- will match: `./sources/filesystem/init.lua
				--find_command = "fd", -- this is determined automatically, you probably don't need to set it
				--find_args = {  -- you can specify extra args to pass to the find command.
				--  fd = {
				--  "--exclude", ".git",
				--  "--exclude",  "node_modules"
				--  }
				--},
				---- or use a function instead of list of strings
				--find_args = function(cmd, path, search_term, args)
				--  if cmd ~= "fd" then
				--    return args
				--  end
				--  --maybe you want to force the filter to always include hidden files:
				--  table.insert(args, "--hidden")
				--  -- but no one ever wants to see .git files
				--  table.insert(args, "--exclude")
				--  table.insert(args, ".git")
				--  -- or node_modules
				--  table.insert(args, "--exclude")
				--  table.insert(args, "node_modules")
				--  --here is where it pays to use the function, you can exclude more for
				--  --short search terms, or vary based on the directory
				--  if string.len(search_term) < 4 and path == "/home/cseickel" then
				--    table.insert(args, "--exclude")
				--    table.insert(args, "Library")
				--  end
				--  return args
				--end,
				group_empty_dirs = false, -- when true, empty folders will be grouped together
				search_limit = 50, -- max number of search results when using filters
				follow_current_file = {
					enabled = false, -- This will find and focus the file in the active buffer every time
					--               -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
				-- in whatever position is specified in window.position
				-- "open_current",-- netrw disabled, opening a directory opens within the
				-- window like netrw would, regardless of window.position
				-- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
				use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
				-- instead of relying on nvim autocmd events.
			},
			buffers = {
				commands = {
					navigate_preview = function(state)
						local node = state.tree:get_node()

						if node and node.type == "directory" then
							require("neo-tree.sources.buffers.commands").toggle_node(state)
							vim.api.nvim_feedkeys("j", "n", true)
						else
							require("neo-tree.sources.common.preview").toggle(state)
						end
					end,
					navigate_open = function(state)
						local node = state.tree:get_node()

						if node and node.type == "directory" then
							require("neo-tree.sources.buffers.commands").toggle_node(state)
							vim.api.nvim_feedkeys("j", "n", true)
						else
							require("neo-tree.sources.buffers.commands").open(state)
						end
					end,
				},

				bind_to_cwd = true,
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--              -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				group_empty_dirs = true, -- when true, empty directories will be grouped together
				show_unloaded = false, -- When working with sessions, for example, restored but unfocused buffers
				-- are mark as "unloaded". Turn this on to view these unloaded buffer.
				terminals_first = false, -- when true, terminals will be listed before file buffers
				window = {
					mappings = {
						["<Tab>"] = "navigate_preview",
						["l"] = "navigate_preview",

						["<cr>"] = "navigate_open",
						["o"] = "navigate_open",
						["<2-LeftMouse>"] = "navigate_open",

						["bd"] = "buffer_delete",
					},
				},
			},
			git_status = {
				window = {
					mappings = {
						["<c-[>"] = "noop",
						["<c-]>"] = "noop",
						["."] = "noop",
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},
			document_symbols = {
				follow_cursor = false,
				client_filters = "first",
				renderers = {
					root = {
						{ "indent" },
						{ "icon", default = "C" },
						{ "name", zindex = 10 },
					},
					symbol = {
						{ "indent", with_expanders = true },
						{ "kind_icon", default = "?" },
						{
							"container",
							content = {
								{ "name", zindex = 10 },
								{ "kind_name", zindex = 20, align = "right" },
							},
						},
					},
				},
				window = {
					mappings = {
						["<cr>"] = "jump_to_symbol",
						["o"] = "jump_to_symbol",
						["l"] = "toggle_node",
						["<Tab>"] = "toggle_node",
						["<S-Tab>"] = "close_node",
						["<bs>"] = "close_node",

						["A"] = "noop", -- also accepts the config.show_path and config.insert_as options.
						["d"] = "noop",
						["y"] = "noop",
						["x"] = "noop",
						["p"] = "noop",
						["c"] = "noop",
						["m"] = "noop",
						["a"] = "noop",
						["D"] = "noop",
						["<c-]>"] = "noop",
						["<c-[>"] = "noop",
						["i"] = "noop",
						["."] = "noop",
						["/"] = "filter",
						["f"] = "filter_on_submit",
					},
				},
				custom_kinds = {
					-- define custom kinds here (also remember to add icon and hl group to kinds)
					-- ccls
					-- [252] = 'TypeAlias',
					-- [253] = 'Parameter',
					-- [254] = 'StaticMethod',
					-- [255] = 'Macro',
				},
				kinds = {
					Unknown = { icon = "?", hl = "" },
					Root = { icon = "", hl = "NeoTreeRootName" },
					File = { icon = "󰈙", hl = "Tag" },
					Module = { icon = "", hl = "Exception" },
					Namespace = { icon = "󰌗", hl = "Include" },
					Package = { icon = "󰏖", hl = "Label" },
					Class = { icon = "󰌗", hl = "Include" },
					Method = { icon = "", hl = "Function" },
					Property = { icon = "󰆧", hl = "@property" },
					Field = { icon = "", hl = "@field" },
					Constructor = { icon = "", hl = "@constructor" },
					Enum = { icon = "󰒻", hl = "@number" },
					Interface = { icon = "", hl = "Type" },
					Function = { icon = "󰊕", hl = "Function" },
					Variable = { icon = "", hl = "@variable" },
					Constant = { icon = "", hl = "Constant" },
					String = { icon = "󰀬", hl = "String" },
					Number = { icon = "󰎠", hl = "Number" },
					Boolean = { icon = "", hl = "Boolean" },
					Array = { icon = "󰅪", hl = "Type" },
					Object = { icon = "󰅩", hl = "Type" },
					Key = { icon = "󰌋", hl = "" },
					Null = { icon = "", hl = "Constant" },
					EnumMember = { icon = "", hl = "Number" },
					Struct = { icon = "󰌗", hl = "Type" },
					Event = { icon = "", hl = "Constant" },
					Operator = { icon = "󰆕", hl = "Operator" },
					TypeParameter = { icon = "󰊄", hl = "Type" },

					-- ccls
					-- TypeAlias = { icon = ' ', hl = 'Type' },
					-- Parameter = { icon = ' ', hl = '@parameter' },
					-- StaticMethod = { icon = '󰠄 ', hl = 'Function' },
					-- Macro = { icon = ' ', hl = 'Macro' },
				},
			},
			example = {
				renderers = {
					custom = {
						{ "indent" },
						{ "icon", default = "C" },
						{ "custom" },
						{ "name" },
					},
				},
				window = {
					mappings = {
						["<cr>"] = "toggle_node",
						["<C-e>"] = "example_command",
						["d"] = "show_debug_info",
					},
				},
			},
		})
	end,
}
