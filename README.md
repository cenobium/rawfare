# UI Reborn Enhancement

A compact, touch-ready Roblox Luau UI library built around the extracted Rivals UE interface source.

## Run in Delta

Execute the repository entrypoint:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/rawfare/main/init.lua"))()
```

The entrypoint loads the inline library, installs its bundled fonts and image assets, bootstraps the library, and builds the demo window.

## Included

- `Rivals_UE_UI_Library.lua`: readable extracted UE library.
- `Rivals_UE_UI_Library_inline.lua`: single-file build with embedded assets and Delta folder creation.
- `src/Bootstrap.lua`: service/capture bootstrap, themes, configuration manager, notifications, and cleanup.
- `src/Window.lua`: compact window, original UE tab factory integration, two-column tabs, groupboxes, and controls.
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
`AddDivider`, and `AddBlank`.

Tabs expose `AddLeftGroupbox`, `AddRightGroupbox`, `AddGroupbox`,
`AddLeftTabbox`, `AddRightTabbox`, and `AddSection`.

The default window is a small horizontal rectangle (320 × 230). It can be dragged from the title area, resized from its lower-right corner, and hidden/restored with RightControl. Hiding disables the entire ScreenGui; it does not collapse the window into a bar or icon.

## Notes

The window builder uses the original UE library methods and `Native.tab` factory for tab behavior. The new groupbox/control adapters provide the public UI API; they do not recreate the original game's compiled feature callbacks. Delta runtime testing is still required on-device before treating executor compatibility as verified.
