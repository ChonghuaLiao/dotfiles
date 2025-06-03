-- config: https://wezfurlong.org/wezterm/config/lua/config/index.html
local wezterm = require("wezterm")

wezterm.on("update-right-status", function(window)
	local date = wezterm.strftime("%a, %Y-%m-%d %H:%M:%S ")
	window:set_right_status(wezterm.format({
		{ Text = date },
	}))
end)
local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

local ADMIN_ICON = utf8.char(0xf49c)

local CMD_ICON = utf8.char(0xe62a)
local NU_ICON = utf8.char(0xe7a8)
local PS_ICON = utf8.char(0xe70f)
local ELV_ICON = utf8.char(0xfc6f)
local WSL_ICON = utf8.char(0xf83c)
local YORI_ICON = utf8.char(0xf1d4)
local NYA_ICON = utf8.char(0xf61a)

local VIM_ICON = utf8.char(0xe62b)
local PAGER_ICON = utf8.char(0xf718)
local FUZZY_ICON = utf8.char(0xf0b0)
local HOURGLASS_ICON = utf8.char(0xf252)
local SUNGLASS_ICON = utf8.char(0xf9df)

local PYTHON_ICON = utf8.char(0xf820)
local NODE_ICON = utf8.char(0xe74e)
local DENO_ICON = utf8.char(0xe628)
local LAMBDA_ICON = utf8.char(0xfb26)

local SUP_IDX = {
	"¹",
	"²",
	"³",
	"⁴",
	"⁵",
	"⁶",
	"⁷",
	"⁸",
	"⁹",
	"¹⁰",
	"¹¹",
	"¹²",
	"¹³",
	"¹⁴",
	"¹⁵",
	"¹⁶",
	"¹⁷",
	"¹⁸",
	"¹⁹",
	"²⁰",
}
local SUB_IDX = {
	"₁",
	"₂",
	"₃",
	"₄",
	"₅",
	"₆",
	"₇",
	"₈",
	"₉",
	"₁₀",
	"₁₁",
	"₁₂",
	"₁₃",
	"₁₄",
	"₁₅",
	"₁₆",
	"₁₇",
	"₁₈",
	"₁₉",
	"₂₀",
}

-- change the title of tab to current working directory.
-- ref:
-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html#format-tab-title
-- https://wezfurlong.org/wezterm/config/lua/PaneInformation.html
-- https://wezfurlong.org/wezterm/config/lua/pane/get_current_working_dir.html
--
function basename(s)
	return string.gsub(s, "(.*[/\\])(.*)", "%2")
end
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#121212"
	local background = "#4E4E4E"
	local foreground = "#1C1B19"
	local dim_foreground = "#3A3A3A"

	if tab.is_active then
		background = "#FBB829"
		foreground = "#1C1B19"
	elseif hover then
		background = "#FF8700"
		foreground = "#1C1B19"
	end

	local edge_foreground = background
	local process_name = tab.active_pane.foreground_process_name
	local pane_title = tab.active_pane.title
	local exec_name = basename(process_name):gsub("%.exe$", "")
	local title_with_icon

	if exec_name == "nu" then
		title_with_icon = NU_ICON .. " NuShell"
	elseif exec_name == "pwsh" then
		title_with_icon = PS_ICON .. " PS"
	elseif exec_name == "cmd" then
		title_with_icon = CMD_ICON .. " CMD"
	elseif exec_name == "elvish" then
		title_with_icon = ELV_ICON .. " Elvish"
	elseif exec_name == "wsl" or exec_name == "wslhost" then
		title_with_icon = WSL_ICON .. " WSL"
	elseif exec_name == "nyagos" then
		title_with_icon = NYA_ICON .. " " .. pane_title:gsub(".*: (.+) %- .+", "%1")
	elseif exec_name == "yori" then
		title_with_icon = YORI_ICON .. " " .. pane_title:gsub(" %- Yori", "")
	elseif exec_name == "nvim" then
		title_with_icon = VIM_ICON .. pane_title:gsub("^(%S+)%s+(%d+/%d+) %- nvim", " %2 %1")
	elseif exec_name == "bat" or exec_name == "less" or exec_name == "moar" then
		title_with_icon = PAGER_ICON .. " " .. exec_name:upper()
	elseif exec_name == "fzf" or exec_name == "hs" or exec_name == "peco" then
		title_with_icon = FUZZY_ICON .. " " .. exec_name:upper()
	elseif exec_name == "btm" or exec_name == "ntop" then
		title_with_icon = SUNGLASS_ICON .. " " .. exec_name:upper()
	elseif exec_name == "python" or exec_name == "hiss" then
		title_with_icon = PYTHON_ICON .. " " .. exec_name
	elseif exec_name == "node" then
		title_with_icon = NODE_ICON .. " " .. exec_name:upper()
	elseif exec_name == "deno" then
		title_with_icon = DENO_ICON .. " " .. exec_name:upper()
	elseif exec_name == "bb" or exec_name == "cmd-clj" or exec_name == "janet" or exec_name == "hy" then
		title_with_icon = LAMBDA_ICON .. " " .. exec_name:gsub("bb", "Babashka"):gsub("cmd%-clj", "Clojure")
	else
		title_with_icon = HOURGLASS_ICON .. " " .. exec_name
	end
	if pane_title:match("^Administrator: ") then
		title_with_icon = title_with_icon .. " " .. ADMIN_ICON
	end
	local left_arrow = SOLID_LEFT_ARROW
	if tab.tab_index == 0 then
		left_arrow = SOLID_LEFT_MOST
	end
	local id = SUB_IDX[tab.tab_index + 1]
	local pid = SUP_IDX[tab.active_pane.pane_index + 1]
	local title = " " .. wezterm.truncate_right(title_with_icon, max_width - 6) .. " "

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_arrow },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = id },
		{ Text = title },
		{ Foreground = { Color = dim_foreground } },
		{ Text = pid },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Attribute = { Intensity = "Normal" } },
	}
end)

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local pane = tab.active_pane
-- 	local title = basename(pane.foreground_process_name)
-- 	local color = "black"
-- 	if tab.is_active then
-- 		color = "orange"
-- 	end
-- 	local edge_background = "#121212"
-- 	local background = "#4E4E4E"
-- 	local foreground = "#1C1B19"
-- 	local dim_foreground = "#3A3A3A"
--
-- 	if tab.is_active then
-- 		background = "#FBB829"
-- 		foreground = "#1C1B19"
-- 	elseif hover then
-- 		background = "#FF8700"
-- 		foreground = "#1C1B19"
-- 	end
-- 	return {
-- 		{ Background = { Color = edge_background } },
-- 		{ Foreground = { Color = edge_foreground } },
-- 		{ Text = " " .. title .. " " },
-- 		{ Attribute = { Intensity = "Bold" } },
-- 	}
-- end)
--
local wez_conf = {
	font = wezterm.font("Iosevka Nerd Font", { weight = "Medium" }),

	font_rules = {
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font({
				family = "Iosevka Nerd Font",
				weight = "Bold",
				style = "Italic",
			}),
		},
		{
			italic = true,
			intensity = "Half",
			font = wezterm.font({
				family = "Iosevka Nerd Font",
				weight = "DemiBold",
				style = "Italic",
			}),
		},
		{
			italic = true,
			intensity = "Normal",
			font = wezterm.font({
				family = "Iosevka Nerd Font",
				weight = "Medium",
				style = "Italic",
			}),
		},
	},
	--
	-- font = wezterm.font("Iosevka Nerd Font", { weight = "Medium" }),
	-- font = wezterm.font("Iosevka Nerd Font", { weight = "Bold" }),
	-- font = wezterm.font("Iosevka Nerd Font", { weight = "Medium", italic=true }),
	-- font = wezterm.font('Monaco', { weight = 'Medium' }),
	-- font = wezterm.font_with_fallback({
	--    -- "IBM Plex Mono",
	--   -- "Azeret Mono",
	--   "Iosevka Nerd Font",
	--   -- "JetBrains Mono Nerd Font",
	--   -- "Noto Sans SC",
	-- }),
	font_size = 17,
	line_height = 1.0,
	cell_width = 0.85,
	-- color scheme can be found here: https://github.com/mbadominimallato/iTerm2-Color-Schemes/tree/master/wezterm
	color_scheme = "ayu_light",
	-- color_scheme = "DoomOne",
	-- color_scheme = "Material",
	-- color_scheme = "flexoki-light",
	-- color_scheme = "MaterialDark",
	-- color_scheme = "MaterialDark",
	-- color_scheme = "Dark+",
	-- color_scheme = "ayu",
	-- color_scheme = "tokyonight",
	-- color_scheme = "nord",
	-- color_scheme = "everforest",
	-- default_cursor_style = "BlinkingBar",
	-- cursor_blink_rate = 400,
	-- cursor_thickness = '1pt',
	window_decorations = "RESIZE",
	macos_window_background_blur = 10,
	-- window_background_opacity = 0.9,
	window_background_opacity = 1,
	force_reverse_video_cursor = false,
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,
	colors = {
		tab_bar = {
      background = "rgba(12%, 12%, 18%, 90%)",
		},
	},
			--
			-- background = "#1C1B19",
	text_background_opacity = 1,

	window_padding = {
		left = 5,
		right = 0,
		top = 5,
		bottom = 0,
	},
	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = false,
	use_ime = true,
	-- term = "wezterm",
	-- set term to wezterm will break the nvim titlestring option, see https://github.com/wez/wezterm/issues/2112
	term = "xterm-256color",
	automatically_reload_config = true,
}

local action = wezterm.action
wez_conf.keys = {
	{ key = "LeftArrow", mods = "SHIFT|ALT", action = action.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "SHIFT|ALT", action = action.MoveTabRelative(1) },
	{ key = "s", mods = "CMD", action = action.SendString("\x1b\x3a\x77\x0a") },
}
-- bind_super_key_to_vim('s'),

return wez_conf
