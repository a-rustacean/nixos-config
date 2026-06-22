require("monitors")
require("autostart")
require("animations")
require("keybinds")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
  general = {
    gaps_in          = 6,
    gaps_out         = 12,
    border_size      = 2,

    col              = {
      active_border   = "rgba(7c7c7cff)",
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = false,
    allow_tearing    = false,
    layout           = "dwindle",
  },

  decoration = {
    rounding         = 10,
    rounding_power   = 2,
    active_opacity   = 1,
    inactive_opacity = 0.9,

    shadow           = {
      enabled      = true,
      range        = 4,
      render_power = 3,
      color        = 0xee1a1a1a,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
  },

  misc = {
    force_default_wallpaper = -1,
    disable_hyprland_logo   = true,
  },

  input = {
    kb_layout      = "us",
    kb_variant     = "",
    kb_model       = "",
    kb_options     = "",
    kb_rules       = "",

    follow_mouse   = 1,

    sensitivity    = 0, -- -1.0 - 1.0, 0 means no modification.
    natural_scroll = true,
    scroll_factor  = 0.3,
    accel_profile  = "flat",
  },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace"
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name           = "suppress-maximize-events",
  match          = { class = ".*" },

  suppress_event = "maximize",
})

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name     = "fix-xwayland-drags",
  match    = {
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

hl.window_rule({
  match        = { class = "(pinentry-)(.*)" },
  stay_focused = true,
})

-- Disable opaque region on Ghostty so Hyprland blurs behind its transparency
hl.on("window.open", function(win)
  if win.class == "com.mitchellh.ghostty" then
    hl.exec_cmd("hyprctl setprop window=" .. win.address .. " no_blur 0")
  end
end)
