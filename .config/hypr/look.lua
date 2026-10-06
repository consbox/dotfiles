hl.config({
	general = {
	    gaps_in  = 2,
	    gaps_out = 1,

	    border_size = 1,

	    col = {
		active_border   = { colors = {"rgba(8ec07cff)", "rgba(fe8019ff)"}, angle = 45 },
		inactive_border = "rgba(282828ff)",
	    },

	    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
	    resize_on_border = false,
	    allow_tearing = false,
	    layout = "master",
	},

	decoration = {
	    rounding       = 2,
	    rounding_power = 2,

	    -- Change transparency of focused and unfocused windows
	    active_opacity   = 1.0,
	    inactive_opacity = 1.0,

	    shadow = {
		enabled      = true,
		range        = 4,
		render_power = 3,
		color        = 0xee1a1a1a,
	    },
	},

	animations = {
	    enabled = true,
	},

	misc = {
	    force_default_wallpaper = 0,
	    disable_hyprland_logo = true,
	    background_color = 0x1d2021,
	    middle_click_paste = false,
	},

})

hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })

hl.animation({ leaf = "global",        enabled = true,  speed = 1.0, bezier = "default" })

hl.animation({ leaf = "border",        enabled = true,  speed = 1.0, bezier = "quick" })
hl.animation({ leaf = "borderangle",   enabled = true,  speed = 100.0, bezier = "quick", style = "loop"})
hl.animation({ leaf = "shadowangle",   enabled = true,  speed = 100.0, bezier = "quick", style = "loop"})
hl.animation({ leaf = "glowangle",     enabled = true,  speed = 100.0, bezier = "quick", style = "loop"})

hl.animation({ leaf = "windows",       enabled = true,  speed = 1.0, bezier = "quick" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 1.0, bezier = "quick",          style = "popin" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2.0, bezier = "quick",          style = "popin" })

hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 0.5, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 0.5, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 0.5, bezier = "quick" })

hl.animation({ leaf = "layers",        enabled = true,  speed = 1.0, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 1.0, bezier = "easeOutQuint",   style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.0, bezier = "linear",         style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.0, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.0, bezier = "almostLinear" })

hl.animation({ leaf = "workspaces",    enabled = true,  speed = 0.5, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 0.5, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 0.5, bezier = "almostLinear",   style = "fade" })
