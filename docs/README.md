# UI Reborn API

## Load

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/UIReborn.lua"))()
```

## Create a window

```lua
local Window = Library:CreateWindow({
    Title = "My interface",
    Center = true,
    AutoShow = true,
    Size = UDim2.fromOffset(560, 300),
    TabPadding = 5,
    MenuFadeTime = 0.15
})
```

## Tabs and layout

```lua
local Tabs = {
    Main = Window:AddTab("Main"),
    Settings = Window:AddTab("Settings")
}

local Left = Tabs.Main:AddLeftGroupbox("General")
local Right = Tabs.Main:AddRightGroupbox("Extra")
```

Each tab can contain left and right groupboxes. Groupboxes and tabbox tabs share the same control methods. Content scrolls when it exceeds the available height.

## Controls

### Toggle

```lua
Left:AddToggle("Enabled", {
    Text = "Enable feature",
    Default = false,
    Callback = function(value)
        print(value)
    end
})
```

### Button

```lua
Left:AddButton({
    Text = "Run",
    Func = function()
        print("Clicked")
    end
})
```

### Slider

```lua
Left:AddSlider("Power", {
    Text = "Power",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%"
})
```

### Dropdown

```lua
Left:AddDropdown("Mode", {
    Text = "Mode",
    Values = {"One", "Two", "Three"},
    Default = 1
})
```

### Input

```lua
Left:AddInput("Name", {
    Text = "Name",
    Default = "",
    Placeholder = "Enter a name",
    Finished = false
})
```

### Label with color picker or key picker

```lua
Left:AddLabel("Accent"):AddColorPicker("Accent", {
    Default = Color3.fromRGB(145, 190, 255),
    Title = "Accent"
})

Left:AddLabel("Bind"):AddKeyPicker("FeatureBind", {
    Default = "F",
    Mode = "Toggle",
    Text = "Feature"
})
```

## Reading and changing values

Controls are registered in the global `Toggles` and `Options` tables.

```lua
Toggles.Enabled:SetValue(true)
print(Toggles.Enabled.Value)

Options.Power:SetValue(75)
print(Options.Power.Value)

Options.Mode:SetValue("Two")
print(Options.Mode.Value)
```

## Window controls

The example provides a **Toggle UI** button. It hides the complete window; restore it with RightControl or the two-finger touch gesture.

Use the lock methods to prevent accidental movement:

```lua
Library:SetLocked(true)
Library:SetLocked(false)
Library:ToggleLock()
```

The Settings showcase includes a **Lock UI position** toggle wired to `SetLocked`.

## Unload

```lua
Library:Unload()
```

The window can be toggled with RightControl or a two-finger touch gesture.

## Mobile layout and color picker

The example sizes the window from the current viewport. The color picker popup stays inside the visible screen and can be moved by dragging its top strip.


## Persistent mobile controls

The showcase creates a separate `UIRebornControls` ScreenGui. Its Toggle UI button remains visible when the main window is hidden, so the interface can always be restored. Lock UI independently enables or disables window dragging. Both controls stay outside the main window.

## Touch color picker

The saturation/value area, hue strip, and transparency strip read touch positions rather than the mouse pointer. The popup opens centered on screen and has a visible **DRAG COLOR PICKER** header.
