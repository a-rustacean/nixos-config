local config = {
  programs = {
    alacritty = os.getenv("HYPRLAND_PROGRAM_ALACRITTY") or "alacritty",
    rofi = os.getenv("HYPRLAND_PROGRAM_ROFI") or "rofi",
    hyprpaper = os.getenv("HYPRLAND_PROGRAM_HYPRPAPER") or "hyprpaper",
    hyprlock = os.getenv("HYPRLAND_PROGRAM_HYPRLOCK") or "hyprlock",
    hyprshutdown = os.getenv("HYPRLAND_PROGRAM_HYPRSHUTDOWN") or "hyprshutdown",
    quickshell = os.getenv("HYPRLAND_PROGRAM_QUICKSHELL") or "qs"
  },
}

return config
