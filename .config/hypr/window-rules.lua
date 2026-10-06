hl.window_rule({
	name = "firefox",
	match = {
	    class = "firefox",
	},
	workspace = "2",
})

hl.window_rule({
	name = "mpv",
	match = {
	    class = "mpv",
	},
	float = true
})

hl.window_rule({
	name = "steam",
	match = {
	    class = "steam",
	},
	workspace = "4",
})

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
	class      = "^$",
	title      = "^$",
	xwayland   = true,
	float      = true,
	fullscreen = false,
	pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
