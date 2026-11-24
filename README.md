# UI Reborn

A compact Roblox Luau UI library based on the LinoriaLib architecture.

## Files

- `UIReborn.lua` - the library source. Load it to create your own interface.
- `Example.lua` - a working showcase with tabs, groupboxes and controls.
- `docs/README.md` - API and layout guide.
- `LICENSE` - MIT license and upstream attribution.

## Run the showcase

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/Example.lua?update=20261124b957"))()
```

## Load the library in your own script

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/UIReborn.lua"))()
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

The library has not yet been runtime-tested in Delta on iOS.