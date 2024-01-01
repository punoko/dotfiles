local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.font = wezterm.font('MesloLGS Nerd Font')
config.font_size = 14.0

config.color_scheme = 'SeaShells'
config.window_background_opacity = 0.9
config.window_decorations = 'TITLE | RESIZE | MACOS_FORCE_DISABLE_SHADOW'

config.enable_scroll_bar = true
config.bold_brightens_ansi_colors = false
config.adjust_window_size_when_changing_font_size = false


wezterm.on('toggle-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 1.0
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)

config.disable_default_key_bindings = true
config.keys = {
-- to disable just one key 
--{ key = 'x',      mods = 'CMD',         action='DisableDefaultAssignment' },
  { key = 'w',      mods = 'CMD',         action = act.CloseCurrentPane { confirm = false } },
  { key = 'n',      mods = 'CMD',         action = act.SpawnWindow },
  { key = 't',      mods = 'CMD',         action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'd',      mods = 'CMD',         action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd',      mods = 'CMD|SHIFT',   action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'c',      mods = 'CMD',         action = act.CopyTo 'Clipboard' },
  { key = 'v',      mods = 'CMD',         action = act.PasteFrom 'Clipboard' },
  { key = 'k',      mods = 'CMD',         action = act.ClearScrollback 'ScrollbackAndViewport' },
  { key = 'f',      mods = 'CMD',         action = act.Search { CaseInSensitiveString = '' } },
  { key = '[',      mods = 'CMD',         action = act.ActivatePaneDirection('Prev') },
  { key = ']',      mods = 'CMD',         action = act.ActivatePaneDirection('Next') },
  { key = 'Enter',  mods = 'CMD|SHIFT',   action = act.TogglePaneZoomState },
  { key = 'Tab',    mods = 'CTRL',        action = act.ActivateTabRelative(1) },
  { key = 'Tab',    mods = 'CTRL|SHIFT',  action = act.ActivateTabRelative(-1) },
  { key = 'h',      mods = 'CMD',         action = act.HideApplication },
  { key = 'm',      mods = 'CMD',         action = act.Hide },
  { key = '-',      mods = 'CMD',         action = act.DecreaseFontSize },
  { key = '=',      mods = 'CMD',         action = act.IncreaseFontSize },
  { key = '0',      mods = 'CMD',         action = act.ResetFontSize },
  { key = 'u',      mods = 'CMD',         action = act.EmitEvent 'toggle-opacity' },
}

return config
