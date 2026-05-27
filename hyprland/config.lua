local config = {
  programs = {
    alacritty = os.getenv("HYPRLAND_PROGRAM_ALACRITTY") or "alacritty",
    rofi = os.getenv("HYPRLAND_PROGRAM_ROFI") or "rofi",
    hyprlock = os.getenv("HYPRLAND_PROGRAM_HYPRLOCK") or "hyprlock",
    quickshell = os.getenv("HYPRLAND_PROGRAM_QUICKSHELL") or "qs"
  },
}

return config
