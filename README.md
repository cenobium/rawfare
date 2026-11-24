# UI Reborn

A compact Roblox Luau UI library based on the LinoriaLib architecture.

## Files

- `UIReborn.lua` - the library source. Load it to create your own interface.
- `Example.lua` - a working showcase with tabs, groupboxes and controls.
- `docs/README.md` - API and layout guide.
- `LICENSE` - MIT license and upstream attribution.

## Run the showcase

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/Example.lua?update=foundation-global-touch-input-20261124"))()
```

## Load the library in your own script

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/UIReborn.lua?v=foundation-20261124-3"))()
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

The core library bundles `Library.SaveManager` and `Library.ThemeManager`. Use `Library:CreateSettingsTab(Window, {Folder = "MyScript"})` to add the complete reusable Settings tab with menu key synchronization, theme colors and presets, background effects, config management, clipboard import/export, autoload, and community config loading. `Library:CreateWindow()` automatically adds the floating HIDE / SHOW and LOCK controls outside the main window. The color picker supports mouse and touch dragging using dedicated touch-move tracking. Background blur and color correction start neutral at execution. Local config persistence requires executor file APIs; clipboard actions require clipboard APIs. The community config registry starts empty until reviewed entries are added.