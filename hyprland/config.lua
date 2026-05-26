local config = {
  programs = {
    alacritty = os.getenv("HYPRLAND_ALACRITTY_EXE") or "alacritty",
    rofi = os.getenv("HYPRLAND_ROFI_EXE") or "rofi",
    hyprpaper = os.getenv("HYPRLAND_HYPRPAPER_EXE") or "hyprpaper",
    quickshell = os.getenv("HYPRLAND_QUICKSHELL_EXE") or "qs"
  },
}

return config
