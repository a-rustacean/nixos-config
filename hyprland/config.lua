local config = {
  programs = {
    alacritty = os.getenv("HYPRLAND_PROGRAM_ALACRITTY") or "alacritty",
    hyprlauncher = os.getenv("HYPRLAND_PROGRAM_HYPRLAUNCHER") or "hyprlauncher",
    hyprpaper = os.getenv("HYPRLAND_PROGRAM_HYPRPAPER") or "hyprpaper",
    hyprlock = os.getenv("HYPRLAND_PROGRAM_HYPRLOCK") or "hyprlock",
    hyprshutdown = os.getenv("HYPRLAND_PROGRAM_HYPRSHUTDOWN") or "hyprshutdown",
    quickshell = os.getenv("HYPRLAND_PROGRAM_QUICKSHELL") or "qs",
    dunst = os.getenv("HYPRLAND_PROGRAM_DUNST") or "dunst",
  },
}

return config
