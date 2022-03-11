local wezterm = require("wezterm")

local config = {
	check_for_updates = false,
	font = wezterm.font("JetBrainsMono Nerd Font"),
	color_scheme = "GitHub Dark",
	tab_bar_at_bottom = true,
	inactive_pane_hsb = { hue = 1.0, saturation = 0.5, brightness = 1.0 },
	exit_behavior = "Close",
	leader = { key = "`", mods = "" },

	mouse_bindings = {
		{
			event = { Down = { streak = 3, button = "Left" } },
			action = { SelectTextAtMouseCursor = "SemanticZone" },
			mods = "NONE",
		},
	},

	-- LuaFormatter off
	keys = {
		-- panes
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "s", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = "v", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

		-- tabs
		{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "b", mods = "LEADER", action = "ActivateLastTab" },
		{ key = "w", mods = "LEADER", action = "ShowTabNavigator" },
		{ key = "p", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "n", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
		{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },

		-- utils
		{ key = "`", mods = "LEADER", action = wezterm.action({ SendString = "`" }) },
		{
			key = "~",
			mods = "LEADER|SHIFT",
			action = wezterm.action({
				SplitVertical = { domain = "CurrentPaneDomain", args = { "@homeDirectory@/.nix-profile/bin/htop" } },
			}),
		},
		{ key = "r", mods = "LEADER", action = "ReloadConfiguration" },
		{ key = "l", mods = "CTRL", action = wezterm.action({ ClearScrollback = "ScrollbackAndViewport" }) },
		{ key = "[", mods = "LEADER", action = "ActivateCopyMode" },
		{ key = "E", mods = "LEADER", action = wezterm.action({ EmitEvent = "open_in_vim" }) },

		-- selection
		{ key = "S", mods = "LEADER|SHIFT", action = "QuickSelect" },
	},
	-- LuaFormatter on
}

wezterm.on("update-right-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	-- Figure out the cwd and host of the current pane.
	-- This will pick up the hostname for the remote host if your
	-- shell is using OSC 7 on the remote host.
	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		cwd_uri = cwd_uri:sub(8)
		local slash = cwd_uri:find("/")
		if slash then
			local hostname = cwd_uri:sub(1, slash - 1)
			-- Remove the domain name portion of the hostname
			local dot = hostname:find("[.]")
			if dot then
				hostname = hostname:sub(1, dot - 1)
			end
			-- and extract the cwd from the uri
			-- cwd = cwd_uri:sub(slash)

			-- table.insert(cells, cwd);
			table.insert(cells, hostname)
		end
	end

	local date = wezterm.strftime("📆 %a %b %-d %H:%M")
	table.insert(cells, date)

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format("🔋%.0f%% ", b.state_of_charge * 100))
	end

	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = ""

	-- Color palette for the backgrounds of each cell
	local colors = { "#3c1361", "#52307c", "#663a82", "#7c5295", "#b491c8" }

	-- Foreground color for the text across the fade
	local text_fg = "#c0c0c0"

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function _G.push(text)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = colors[cell_no] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		_G.push(cell)
	end

	window:set_right_status(wezterm.format(elements))
end)

wezterm.on("open_in_vim", function(window, pane)
	local filename = os.tmpname() .. "_hist"
	local file = io.open(filename, "w")
	file:write(pane:get_logical_lines_as_text(3000))
	file:close()

	window:perform_action(
		wezterm.action({
			SendString = "nvim " .. filename .. " -c 'call cursor(3000,0)'\n",
		}),
		pane
	)
end)

return config
