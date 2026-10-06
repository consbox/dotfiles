-- Application
local terminal     = "foot"
local browser      = "firefox"
local editor       = "emacsclient -c"
local file_manager = "pcmanfm-qt"
local menu         = "hyprlauncher"

-- Variables
local MODKEY = "SUPER"

hl.bind(MODKEY .. " + q",      hl.dsp.window.close())
hl.bind(MODKEY .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(MODKEY .. " + e",      hl.dsp.exec_cmd(editor))
hl.bind(MODKEY .. " + w",      hl.dsp.exec_cmd(browser))
hl.bind(MODKEY .. " + d",      hl.dsp.exec_cmd(menu))
hl.bind(MODKEY .. " + l",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(MODKEY .. " + F12",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(MODKEY .. " + F10", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

hl.bind(MODKEY .. " + SHIFT" .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))

-- master layout
hl.bind(MODKEY .. " + n", hl.dsp.layout("cyclenext noloop"))
hl.bind(MODKEY .. " + p", hl.dsp.layout("cycleprev noloop"))

hl.bind(MODKEY .. " + SHIFT + n", hl.dsp.layout("swapnext noloop"))
hl.bind(MODKEY .. " + SHIFT + p", hl.dsp.layout("swapprev noloop"))

hl.bind(MODKEY .. " + m", hl.dsp.layout("focusmaster"))
hl.bind(MODKEY .. " + f ", hl.dsp.layout("swapwithmaster"))

hl.bind(MODKEY .. " + a",       hl.dsp.layout("removemaster"))
hl.bind(MODKEY .. " + SHIFT + a", hl.dsp.layout("addmaster"))

hl.bind(MODKEY .. " + SHIFT" .. " + comma", hl.dsp.layout("mfact -0.1"))
hl.bind(MODKEY .. " + SHIFT" .. " + period", hl.dsp.layout("mfact +0.1"))

-- screenshot
hl.bind(MODKEY .. " + F9 ", hl.dsp.exec_cmd("hyprshot --mode region --output-folder ~/Pictures/screenshots/"))

-- switch between windows
hl.bind(MODKEY .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(MODKEY .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(MODKEY .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(MODKEY .. " + down",  hl.dsp.focus({ direction = "down" }))

-- switch workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(MODKEY .. " + " .. key, hl.dsp.focus({workspace = i}))
    hl.bind(MODKEY .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(MODKEY .. " + TAB ", hl.dsp.focus({ workspace = "previous" }))

-- Example special workspace (scratchpad)
hl.bind(MODKEY .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(MODKEY .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with MODKEY + LMB/RMB and dragging
hl.bind(MODKEY .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(MODKEY .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
