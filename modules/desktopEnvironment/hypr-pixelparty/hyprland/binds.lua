local vars = require("vars")

local close_menu = "pkill rofi"
local open_menu = "rofi -show drun"
local open_clipboard = "rofi -modi clipboard:cliphist-rofi -show clipboard"

hl.bind(vars.mod .. " + F", hl.dsp.exec_cmd("firefox"))

hl.bind(
	vars.mod .. " + P",
	hl.dsp.exec_cmd([[
  MONTH_YEAR=$(date +'%B_%Y')
  SCREENSHOT_DIR="$HOME/Pictures/Screenshots/$YEAR_MONTH"
  mkdir -p "$SCREENSHOT_DIR"
  XDG_SCREENSHOTS_DIR="$SCREENSHOT_DIR" grimblast --notify -o copysave area
]])
)

hl.bind(vars.mod .. " + Space", hl.dsp.layout("togglesplit"))
hl.bind(vars.mod .. " + K", hl.dsp.exec_cmd("pkill waybar; sleep 0.5 && waybar"))
hl.bind(vars.mod .. " + Q", hl.dsp.exec_cmd([[xdg-terminal-exec bash -c "cd $HOME/; exec bash"]]))
hl.bind(vars.mod .. " + C", hl.dsp.window.close())
hl.bind(vars.mod .. " + E", hl.dsp.exec_cmd("nemo"))
hl.bind(vars.mod .. " + Z", hl.dsp.window.float({ action = "toggle" }))
hl.bind(vars.mod .. " + O", hl.dsp.window.pin({ action = "toggle" }))

hl.bind(vars.mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(vars.mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(vars.mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(vars.mod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(vars.mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(vars.mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("F11", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(vars.mod .. " + F11", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

hl.bind(vars.mod .. " + V", hl.dsp.exec_cmd(close_menu .. " || " .. open_clipboard))

hl.bind(vars.mod .. " + SUPER_L", hl.dsp.exec_cmd(close_menu .. " || " .. open_menu), {long_press = true})

-- mouse binds (old bindm)
hl.bind(vars.mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- workspaces 1–9
for i = 1, 9 do
	hl.bind(vars.mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(vars.mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
