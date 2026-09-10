hl.on("hyprland.start", function ()
	  -- useful and nice stuff
	  hl.exec_cmd("waybar")
	  hl.exec_cmd("hyprpaper")
	  hl.exec_cmd("hypridle")
	  hl.exec_cmd("fnott")
	  hl.exec_cmd("emacs --daemon")
	  -- systemd stuff
	  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)
