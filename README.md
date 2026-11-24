# UI Reborn Enhancement

A compact, touch-ready Roblox Luau UI library built around the extracted Rivals UE interface source.

## Run in Delta

Execute the repository entrypoint:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/init.lua"))()
```

The entrypoint loads the inline library, installs its bundled fonts and image assets, bootstraps the library, and builds the demo window. The clean library reads from `assets/`; the inline build does not need that folder.

## Included

- `Rivals_UE_UI_Library.lua`: readable extracted UE library.
- `Rivals_UE_UI_Library_inline.lua`: single-file build with embedded assets and Delta folder creation.
- `assets/`: the extracted font files and watermark image used by the clean library.
- `Rivals_UE_themes.json`: all 13 built-in theme palettes.
- `src/Bootstrap.lua`: service/capture bootstrap, themes, configuration manager, notifications, and cleanup.
- `src/Window.lua`: compact window, original UE tab and tabbox factory integration, two-column tabs, groupboxes, and controls.
- `init.lua`: runnable entrypoint and interface demo.

## Window API

```lua
local Library = Bootstrap.start(Native)
local Window = WindowModule.attach(Library, {
    Title = "My UI",
    Width = 320,
    Height = 230,
    ToggleKey = Enum.KeyCode.RightControl,
})

local tab = Window:CreateTab("Main")
local left = tab:AddLeftGroupbox("General")
local right = tab:AddRightGroupbox("Settings")

left:AddToggle({Text = "Enabled", Default = false, Callback = function(value) end})
left:AddSlider({Text = "Amount", Min = 0, Max = 100, Default = 25})
left:AddDropdown({Text = "Mode", Values = {"One", "Two"}, Default = "One"})
right:AddButton({Text = "Run", Func = function() end})
```

Available groupbox controls: `AddToggle`, `AddSlider`, `AddDropdown`,
`AddColorPicker`, `AddKeyPicker`, `AddInput`, `AddButton`, `AddLabel`,
`AddDivider`, `AddBlank`, `AddContainer`, `AddDependency`, and `AddButtonGroup`.

Tabs expose `AddLeftGroupbox`, `AddRightGroupbox`, `AddGroupbox`,
`AddLeftTabbox`, `AddRightTabbox`, and `AddSection`.

The default window is a small horizontal rectangle (320 × 230). It can be dragged from the title area, resized from its lower-right corner, and hidden/restored with RightControl. Hiding disables the entire ScreenGui; it does not collapse the window into a bar or icon.

## Notes

The window builder uses the original UE library methods plus the `Native.tab`, `Native.tabBox`, `Native.textLabel`, `Native.containerSize`, `Native.dependencies`, `Native.valueCallbacks`, `Native.toggle`, `Native.slider`,
`Native.dropdown`, `Native.colorPicker`, `Native.keyPicker`, and `Native.buttons` factories. The remaining control adapters use the library's original font, color registry, hover, and callback methods. This repository rebuilds the UI toolkit and demo interface; it does not recreate the original game's compiled feature callbacks. Delta runtime testing is still required on-device before treating executor compatibility as verified.
