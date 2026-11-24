local base = "https://raw.githubusercontent.com/cenobium/rawfare/main/"

local function load(path)
    local source = game:HttpGet(base .. path)
    return assert(loadstring(source))()
end

local Native = load("Rivals_UE_UI_Library_inline.lua")
local Bootstrap = load("src/Bootstrap.lua")
local Window = load("src/Window.lua")

local Library = Bootstrap.start(Native)
local UI = Window.attach(Library, {
    Title = "UI Reborn Enhancement",
    Width = 320,
    Height = 230,
    ToggleKey = Enum.KeyCode.RightControl,
})

local main = UI:CreateTab("Main")
local interface = main:AddLeftGroupbox("Interface")
local appearance = main:AddRightGroupbox("Appearance")

interface:AddLabel("RightControl toggles the full interface")
interface:AddButton({
    Text = "Test notification",
    Func = function()
        Library:Notify("UI Reborn Enhancement is ready", 2)
    end,
})
interface:AddButton({
    Text = "Unload interface",
    Func = function()
        UI:Unload()
    end,
})

local themes = {
    "Default",
    "Tokyo Night",
    "Nord",
    "Skeet",
    "Fatality",
    "Neverlose",
    "Onetap",
    "Imgui",
    "Iniuria",
    "Primordial",
    "Monolith",
    "V3rmillion",
    "Dark",
}

appearance:AddDropdown({
    Text = "Theme",
    Flag = "UI_Theme",
    Values = themes,
    Default = "Default",
    Callback = function(value)
        Library.ThemeManager:ApplyTheme(value)
    end,
})
appearance:AddToggle({
    Text = "Show watermark",
    Flag = "UI_Watermark",
    Default = false,
    Callback = function(value)
        Library:SetWatermark("UI Reborn Enhancement")
        Library:SetWatermarkVisibility(value)
    end,
})
appearance:AddSlider({
    Text = "Window width",
    Flag = "UI_Width",
    Min = 280,
    Max = 520,
    Default = 320,
    Suffix = " px",
    Callback = function(value)
        UI.Root.Size = UDim2.fromOffset(value, UI.Root.Size.Y.Offset)
    end,
})
appearance:AddSlider({
    Text = "Window height",
    Flag = "UI_Height",
    Min = 180,
    Max = 420,
    Default = 230,
    Suffix = " px",
    Callback = function(value)
        UI.Root.Size = UDim2.fromOffset(UI.Root.Size.X.Offset, value)
    end,
})

local settings = UI:CreateTab("Settings")
local controls = settings:AddLeftGroupbox("Controls")
controls:AddLabel("Drag the title area to move the window")
controls:AddLabel("Use the bottom-right corner to resize")
controls:AddLabel("Press RightControl to hide or restore it")

print("[UI Reborn Enhancement] loaded")