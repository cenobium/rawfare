# UI Reborn API Reference

UI Reborn is a Luau UI library based on LinoriaLib. This guide documents the APIs actually present in `UIReborn.lua`. It is intended as the reference for scripts and code-generating assistants.

## Load

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/cenobium/rawfare/main/UIReborn.lua"
))()
```

The library creates its ScreenGui when loaded. Load it once per script session.

## Create a window

```lua
local Window = Library:CreateWindow({
    Title = "My interface",
    Center = true,
    AutoShow = true,
    Size = UDim2.fromOffset(700, 450),
    Position = UDim2.fromOffset(100, 80),
    TabPadding = 5,
    MenuFadeTime = 0.15
})
```

Window configuration:
- `Title`: title text.
- `Center`: center the window.
- `AutoShow`: show the window after creation.
- `Size`: UDim2 window size. Default is 560x300.
- `Position`: UDim2 position when not centered.
- `TabPadding`: spacing between tabs.
- `MenuFadeTime`: toggle animation duration.

Also supported: legacy call `Library:CreateWindow("Title", true)`.

## Tabs and two-column layout

```lua
local Main = Window:AddTab("Main")
local Settings = Window:AddTab("Settings")

local Aimbot = Main:AddLeftGroupbox("Aimbot")
local Checks = Main:AddRightGroupbox("Checks")
local Extra = Main:AddGroupbox({ Name = "Extra", Side = 1 })
```

Each tab has left and right columns. Groupboxes stack vertically in their column. Controls are added to groupboxes in order.

Tab methods:
- `Window:AddTab(name)`
- `Tab:AddGroupbox({ Name = name, Side = 1 or 2 })`
- `Tab:AddLeftGroupbox(name)`
- `Tab:AddRightGroupbox(name)`
- `Tab:AddLeftTabbox(name)`
- `Tab:AddRightTabbox(name)`
- `Tab:AddTabbox({ Name = name, Side = 1 or 2 })`
- `Tab:ShowTab()`, `Tab:HideTab()`, `Tab:SetLayoutOrder(number)`
- `Tab:Show()`, `Tab:Hide()`, `Tab:Resize()`
- `Groupbox:Resize()`
- `Window:SetWindowTitle(text)`

## Controls

Every control is created from a groupbox. Most controls take a unique string ID and an info table. IDs are used in `Options` or `Toggles`.

### Toggle

```lua
Aimbot:AddToggle("Enabled", {
    Text = "Enable aimbot",
    Default = false,
    Callback = function(value)
        print(value)
    end,
    Risky = false,
    Tooltip = "Enable or disable this feature"
})
```

Info fields: `Text` (required), `Default`, `Callback`, `Risky`, `Tooltip`, `BlankSize`.

### Slider

```lua
Aimbot:AddSlider("Smoothness", {
    Text = "Smoothness",
    Default = 35,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Callback = function(value) end
})
```

Info fields: `Text`, `Default`, `Min`, `Max`, `Rounding` (required), `Callback`, `Compact`, `Tooltip`, `Suffix`, `HideMax`, `BlankSize`.

### Dropdown

```lua
Aimbot:AddDropdown("AimPart", {
    Text = "Aim part",
    Values = {
        "HumanoidRootPart",
        "LeftHand",
        "RightHand",
        "Head",
        "Torso"
    },
    Default = "Head",
    Callback = function(value)
        print(value)
    end
})
```

Info fields: `Values` (required), `Text`, `Default`, `AllowNull`, `Multi`, `Compact`, `Callback`, `Tooltip`, `SpecialType`.

- `Default` may be a value, an index, or a table of values for a multi-select.
- Set `Multi = true` for multiple selections. The value is a dictionary, e.g. `{ Head = true, Torso = true }`.
- Set `AllowNull = true` to allow no selection.
- `SpecialType = "Player"` or `"Team"` fills values from current players or teams and permits no selection.
- Use `Options.AimPart:SetValues(newValues)` to replace the list.

### Dedicated multi-select dropdown

Use `AddMultiDropdown` when an option should accept more than one value. It uses the same dropdown UI and keeps the existing `AddDropdown` single-select behavior unchanged.

```lua
Aimbot:AddMultiDropdown("TargetParts", {
    Text = "Target body parts",
    Values = {
        "HumanoidRootPart",
        "Left Hand",
        "Right Hand",
        "Head",
        "Torso"
    },
    Default = {"Head", "Right Hand"},
    Callback = function(values)
        print(table.concat(values, ", "))
    end
})

local selected = Options.TargetParts:GetSelectedValues()
Options.TargetParts:SelectAll()
Options.TargetParts:Clear()
Options.TargetParts:SetValue({"Head", "Right Hand"})
Options.TargetParts:SetValues({"Head", "Torso"})
```

Info fields: `Text`, `Values` (required), `Default` (array or selected-value dictionary), `Callback`, `Tooltip`, `Compact`, `BlankSize`.

- Callback receives a dictionary such as `{Head = true, ["Right Hand"] = true}`.
- `GetSelectedValues()` returns an array of selected names for easy `table.concat`.
- `SelectAll()` selects every available value.
- `Clear()` clears all selected values.
- `SetValue(table)` accepts either an array of names or a selected-value dictionary.
- `SetValues(newValues)` replaces the available choices and rebuilds the list.

### Input

```lua
Aimbot:AddInput("TargetName", {
    Text = "Target name",
    Default = "",
    Placeholder = "Enter a name",
    Numeric = false,
    Finished = false,
    Callback = function(value) end
})
```

Info fields: `Text` (required), `Default`, `Placeholder`, `Numeric`, `Finished`, `Callback`.

### Button

```lua
Aimbot:AddButton({
    Text = "Run",
    Func = function() end,
    Tooltip = "Run the action",
    DoubleClick = false
})
```

Legacy form is also supported: `Aimbot:AddButton("Run", function() end)`. Buttons can be placed side by side by chaining: `Aimbot:AddButton({...}):AddButton({...})`.

### Label, divider and spacing

```lua
local Label = Aimbot:AddLabel("Target settings")
Label:SetText("Updated label")
Aimbot:AddDivider()
Aimbot:AddBlank(8)
```

Methods: `AddLabel(text, doesWrap)`, `Label:SetText(text)`, `AddDivider()`, `AddBlank(pixelHeight)`.

### Color picker

```lua
Aimbot:AddLabel("Accent"):AddColorPicker("Accent", {
    Default = Color3.fromRGB(145, 190, 255),
    Title = "Accent",
    Transparency = 0,
    Callback = function(color) end
})
```

Info fields: `Default` (Color3, required), `Title`, `Transparency`, `Callback`.

Color picker option methods: `SetValue(hsv, transparency)`, `SetValueRGB(color3, transparency)`, `SetHSVFromRGB(color3)`, `OnChanged(callback)`.

### Key picker

```lua
Aimbot:AddLabel("Aim key"):AddKeyPicker("AimKey", {
    Default = "Q",
    Mode = "Hold",
    Modes = { "Always", "Toggle", "Hold" },
    Text = "Aimbot",
    Callback = function(value) end,
    ChangedCallback = function(key) end
})
```

Info fields: `Default` (required), `Mode`, `Modes`, `Text`, `Callback`, `ChangedCallback`, `SyncToggleState`, `KeyboardOnly`.

Modes are `Always`, `Toggle`, and `Hold`. Key picker methods: `GetState()`, `SetValue(data)`, `OnClick(callback)`, `OnChanged(callback)`, `DoClick()`, `Update()`.

To attach a key picker to a toggle, call it on the toggle object: `Toggles.Enabled:AddKeyPicker("EnabledKey", { Default = "Q", Mode = "Toggle", SyncToggleState = true })` when using a toggle that exposes the addon method.

### Dependency box

```lua
local Advanced = Aimbot:AddDependencyBox()
Advanced:SetupDependencies({
    { Toggles.Enabled, true }
})
Advanced:AddToggle("Prediction", {
    Text = "Prediction",
    Default = false
})
Advanced:AddSlider("PredictionAmount", {
    Text = "Prediction amount",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0
})
```

A dependency box is another groupbox-like container. It becomes visible only when every listed toggle matches its required value. Methods: `SetupDependencies(dependencies)`, `Update()`, `Resize()`. Each dependency is a pair: `{ toggleObject, requiredBoolean }`.

### Tabbox

```lua
local WeaponBox = Main:AddLeftTabbox("Weapon")
local Rifle = WeaponBox:AddTab("Rifle")
local Pistol = WeaponBox:AddTab("Pistol")

Rifle:AddToggle("RifleEnabled", {
    Text = "Enable rifle",
    Default = true
})
Pistol:AddSlider("PistolDelay", {
    Text = "Delay",
    Default = 10,
    Min = 0,
    Max = 100,
    Rounding = 0
})
```

A tabbox is a nested tab strip inside a column. Its tabs support the same control methods as groupboxes.

## Reading and changing values

Controls are registered in global tables:
- Toggles use `Toggles[id]`.
- Sliders, dropdowns, inputs, color pickers and key pickers use `Options[id]`.

```lua
Toggles.Enabled:SetValue(true)
print(Toggles.Enabled.Value)

Options.Smoothness:SetValue(75)
print(Options.Smoothness.Value)

Options.AimPart:SetValue("Head")
Options.AimPart:SetValues({ "Head", "Torso" })

Options.TargetName:SetValue("Player")
Options.Accent:SetValueRGB(Color3.fromRGB(255, 80, 80))
Options.AimKey:SetValue({ "Q", "Hold" })
```

Common option methods:
- `SetValue(value)`
- `OnChanged(callback)`
- Dropdown: `SetValues(values)`, `GetActiveValues()`, `OpenDropdown()`, `CloseDropdown()`
- Color picker: `SetValueRGB(color, transparency)`
- Key picker: `GetState()`, `OnClick(callback)`

`OnChanged(callback)` immediately calls the callback with the current value, then calls it when the value changes.

## Library utilities

```lua
Library:Notify("Loaded", 3)
Library:SetWatermark("My script | user")
Library:SetWatermarkVisibility(true)
Library:Toggle()
Library:SetLocked(true)
Library:ToggleLock()
```

Available library methods:
- `Notify(text, seconds)`
- `SetWatermark(text)`, `SetWatermarkVisibility(boolean)`
- `Toggle()` toggles the main window.
- `SetToggleKeybind(keyPickerOrKeyName)` sets the menu key source. Pass the menu `KeyPicker` option or a keyboard key name.
- `SetLocked(boolean)`, `ToggleLock()` control window dragging.
- `Unload()` disconnects library signals and destroys the UI.
- `OnUnload(callback)` registers an unload callback.
- `GiveSignal(connection)` registers a connection for cleanup.
- `SafeCallback(callback, ...)` invokes a callback safely when error notifications are enabled.
- `UpdateColorsUsingRegistry()` reapplies registered theme colors.
- `Create(class, properties)`, `CreateLabel(properties)`, `GetTextBounds(text, font, size)`, `GetDarkerColor(color)`, `MapValue(...)` are low-level helpers.

The library also exposes registry helpers `AddToRegistry` and `RemoveFromRegistry`, tooltip/highlight helpers, `MakeDraggable`, `MouseIsOverOpenedFrame`, `IsMouseOverFrame`, and `UpdateDependencyBoxes`. These are lower-level APIs; most scripts do not need them.

## Mobile and window behavior

- The showcase adds a separate floating **HIDE / SHOW** control so the window can be restored after hiding.
- The floating dock can be dragged by its title strip.
- The floating dock and main window share the library lock state.
- The two-finger restore gesture is disabled because ordinary multi-touch gameplay input could accidentally reopen the window.
- The color picker popup opens centered, has a drag handle, and tracks touch movement by touch ID. Saturation/value, hue, and transparency controls support touch and mouse dragging.

## What is not bundled

The core library includes the bundled `Library.ThemeManager` and `Library.SaveManager` modules, plus the Settings showcase in `Example.lua`. It does not bundle game-specific features such as aimbots, ESP, targeting logic, or arbitrary game APIs; those belong in scripts built on top of the UI library. Executor-dependent features such as local file storage and clipboard access require the corresponding executor functions.

## API parity audit

The public function inventory in this repository's core `UIReborn.lua` was compared against LinoriaLib's upstream `Library.lua`. All upstream core function names were present in the local library at the time of this audit. UI Reborn additionally exposes `Library:SetLocked` and `Library:ToggleLock`, plus its mobile color-picker positioning/input helpers. This is a name-level parity check, not a claim that every internal behavior is identical.

Upstream reference: https://github.com/violin-suzutsuki/LinoriaLib


## Reusable Settings API

Every script can create the same complete Settings tab with one library call. Do not rebuild Menu, Theme, Background, or Configuration groupboxes in each game script.

```lua
local Settings = Library:CreateSettingsTab(Window, {
    Folder = "MyScript",
    Name = "Settings",
    MenuKey = "RightControl"
})
```

The call initializes the bundled managers and creates four standard groups:

**Menu**
- Keyboard-only menu key picker, synchronized with `Library:SetToggleKeybind`.
- Menu transparency slider.
- Keybind list mode: Active, Toggled, or All.

**Theme**
- Font, main, accent, background, and outline color pickers.
- Built-in and custom theme list.
- Save custom theme, set default, and refresh themes.

**Background**
- Background transparency.
- Blur, contrast, saturation, and brightness effects.

**Configuration**
- Create, load, overwrite, delete, and refresh local configs.
- Set/remove autoload and display the current autoload name.
- Import pasted JSON, copy config, and import from clipboard.
- Refresh and load reviewed community configs.

The API uses IDs prefixed with `UIReborn_` to avoid collisions with game controls. Local persistence requires executor file APIs. Clipboard actions require clipboard APIs. Community configs require HTTP access.

## Floating controls

`Library:CreateWindow()` automatically creates a separate floating control dock. Every showcase and script using the library gets:

- **HIDE / SHOW** to hide or restore the entire main interface.
- **LOCK** to toggle window and dock dragging.
- A draggable title strip.
- A separate ScreenGui, so the controls remain visible while the main library window is hidden.

Do not create a second dock in the showcase. The controls are removed by `Library:Unload()`.

## Manager API

The managers are bundled in `UIReborn.lua` and initialized by `CreateSettingsTab`. They can also be configured manually:

```lua
local SaveManager = Library.SaveManager
local ThemeManager = Library.ThemeManager

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("MyScript")
SaveManager:SetIgnoreIndexes({"OptionId"})
SaveManager:Save("default")
SaveManager:Load("default")
SaveManager:Delete("default")
SaveManager:RefreshConfigList()
SaveManager:SetAutoload("default")
SaveManager:RemoveAutoload()
SaveManager:LoadAutoloadConfig()
SaveManager:Export()
SaveManager:Import(jsonString)
SaveManager:CopyToClipboard()
SaveManager:PasteFromClipboard()
SaveManager:RefreshCommunityList()
SaveManager:LoadCommunity("Community config")

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScript")
ThemeManager:ApplyTheme("Midnight")
ThemeManager:SaveCustomTheme("My theme")
ThemeManager:RefreshCustomThemes()
ThemeManager:SaveDefault("My theme")
ThemeManager:GetDefault()
```

Theme colors are synchronized with the reusable Settings color pickers when a theme is applied. The default theme and autoload config are applied when the Settings API is created.


## Foundation verification checklist

Run these in the Roblox client with the target executor. Static source checks do not replace runtime testing.

1. Load `Example.lua`. Confirm the floating HIDE / SHOW and LOCK dock appears outside the window.
2. Press HIDE. Confirm the complete main interface disappears while the dock stays visible. Press SHOW and confirm the full window returns.
3. Drag the dock title strip with touch. Confirm it follows the active finger and stays inside the viewport.
4. Open the accent color picker. Tap a new point in the saturation/value square, drag continuously, change hue, and test transparency. Confirm the swatch and callback update on every movement.
5. Repeat color picker tests with a mouse. Confirm touch and mouse input do not leave a stuck drag state.
6. Open Settings, change the menu key with a physical keyboard, and confirm the selected key hides and restores the menu. Confirm the old key no longer toggles it.
7. Save a named config, change controls, load it, and confirm toggles, sliders, dropdowns, colors, and keybinds restore. Confirm later changes autosave to the active config.
8. Save a custom theme, apply another theme, reapply the custom theme, and confirm all five theme color pickers and the UI colors synchronize.
9. Set an autoload config, unload and reload the showcase, and confirm it loads. Remove autoload and confirm it no longer loads.
10. Unload the library. Confirm the floating dock, main ScreenGui, and Settings lighting effects are removed.

Do not mark these runtime checks complete until they have been exercised in the target Roblox client and executor.


Mobile input uses dedicated touch-move tracking for the color picker, picker drag handle, and floating controls. Background effects initialize to neutral values, including blur size zero.
