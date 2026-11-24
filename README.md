# UI Reborn

A compact Roblox Luau UI library based on the LinoriaLib architecture.

## Files

- `UIReborn.lua` - the library source. Load it to create your own interface.
- `Example.lua` - a working showcase with tabs, groupboxes and controls.
- `docs/README.md` - API and layout guide.
- `LICENSE` - MIT license and upstream attribution.

## Run the showcase

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/Example.lua?update=unlimited-multi-20261124"))()
```

## Load the library in your own script

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/UIReborn.lua?v=unlimited-multi-20261124"))()
local Window = Library:CreateWindow({
    Title = "My UI",
    Center = true,
    AutoShow = true,
    Size = UDim2.fromOffset(560, 300)
})
local Main = Window:AddTab("Main")
local Group = Main:AddLeftGroupbox("General")
Group:AddButton({Text = "Click me", Func = function() Library:Notify("Hello", 2) end})
```

See [the documentation](docs/README.md) for controls and layout examples.

The core library bundles `Library.SaveManager` and `Library.ThemeManager`. The Settings tab includes configuration management, clipboard import/export, community config loading, theme management, menu keybind and transparency, keybind display modes, and background effects. Settings uses separate Theme and Background groups in a stable two-column layout; it does not use the experimental tabbox control. Local config persistence requires executor file APIs. The community config registry starts empty until reviewed entries are added. The showcase includes persistent on-screen Toggle UI and Lock UI controls outside the main window. The floating controls are draggable and share the window lock state. The color picker supports touch input and can be dragged. The two-finger restore gesture is disabled to prevent accidental reopening during gameplay.