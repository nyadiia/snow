return {
	font = wezterm.font_with_fallback {
		"Mononoki Nerd Font",
		-- "JetBrainsMono Nerd Font",
		-- "azuki_font"
		-- { family = "CozetteHiDpi", weight = "Regular" },
		-- "FiraCode Nerd Font",
	},
	font_size = 10,
	--
	-- man fix the nix config
	front_end = "WebGpu",

	enable_tab_bar = false,
	color_scheme = 'Gruvbox Material (Gogh)',
	window_background_opacity = 0.8,
}
