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

interface:AddLabel({Text = "RightControl or\n2-finger touch", TextWrapped = true})
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
local resetButton = interface:AddButtonGroup()
resetButton:AddButton({
    Text = "Reset theme",
    Func = function()
        Library.ThemeManager:ApplyTheme("Default")
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
    Text = "Width",
    Flag = "UI_Width",
    Min = 280,
    Max = 520,
    Default = 320,
    Suffix = " px",
    Compact = true,
    HideMax = true,
    Callback = function(value)
        UI.Root.Size = UDim2.fromOffset(value, UI.Root.Size.Y.Offset)
    end,
})
appearance:AddSlider({
    Text = "Height",
    Flag = "UI_Height",
    Min = 180,
    Max = 420,
    Default = 230,
    Suffix = " px",
    Compact = true,
    HideMax = true,
    Callback = function(value)
        UI.Root.Size = UDim2.fromOffset(UI.Root.Size.X.Offset, value)
    end,
})

local controls = main:AddLeftGroupbox("Control Showcase")
local demoToggle = controls:AddToggle({
    Text = "Example toggle",
    Flag = "Demo_Toggle",
    Default = false,
})
controls:AddSlider({
    Text = "Example slider",
    Flag = "Demo_Slider",
    Min = 0,
    Max = 100,
    Default = 35,
})
controls:AddDropdown({
    Text = "Example dropdown",
    Flag = "Demo_Dropdown",
    Values = {"First", "Second", "Third"},
    Default = "First",
})
controls:AddColorPicker({
    Text = "Example color",
    Flag = "Demo_Color",
    Default = Color3.fromRGB(162, 205, 255),
})
controls:AddKeyPicker({
    Text = "Example key",
    Flag = "Demo_Key",
    Default = Enum.KeyCode.G,
    Parent = demoToggle,
    SyncToggleState = true,
})
controls:AddInput({
    Text = "Example input",
    Flag = "Demo_Input",
    Default = "Type here",
})
local previewContainer = controls:AddContainer(42)
Library:CreateLabel({
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Text = "Original container size factory",
    TextSize = 12,
    Parent = previewContainer:GetInner(),
})
local dependent = controls:AddDependency({
    {Library.Toggles.Demo_Toggle, true},
}, "Toggle dependent")
dependent:AddLabel("This section appears when the example toggle is enabled")

local profileTabs = main:AddLeftTabbox("Profiles")
local standardProfile = profileTabs:AddTab("Standard")
standardProfile:AddLabel("Original UE tabbox factory")
standardProfile:AddToggle({Text = "Profile enabled", Default = true})
local compactProfile = profileTabs:AddTab("Compact")
compactProfile:AddLabel("Touch-ready tab panels")

local settings = UI:CreateTab("Settings")
local help = settings:AddLeftGroupbox("Controls")
help:AddLabel("Drag the title area to move the window")
help:AddLabel("Use the bottom-right corner to resize")
help:AddLabel("RightControl or two-finger touch restores it")
help:AddToggle({
    Text = "Show keybind list",
    Flag = "UI_Keybind_List",
    Default = false,
    Callback = function(value)
        Library.KeypickerListVisible = value
        for _, option in pairs(Library.Options) do
            if option.Type == "KeyPicker" and option.Update then
                option:Update()
            end
        end
    end,
})
help:AddDropdown({
    Text = "Keybind list mode",
    Flag = "UI_Keybind_Mode",
    Values = {"Active", "Toggled"},
    Default = "Active",
    Callback = function(value)
        Library.KeypickerListMode = value
        for _, option in pairs(Library.Options) do
            if option.Type == "KeyPicker" and option.Update then
                option:Update()
            end
        end
    end,
})

local configs = settings:AddRightGroupbox("Configuration")
local configName = configs:AddInput({
    Text = "Config name",
    Flag = "Config_Name",
    Default = "default",
})
configs:AddButton({
    Text = "Save config",
    Func = function()
        local ok, saved, result = pcall(Library.SaveManager.Save, Library.SaveManager, configName.Value)
        Library:Notify(ok and saved and "Config saved" or (ok and result or "Config save failed"), 3)
    end,
})
configs:AddButton({
    Text = "Load config",
    Func = function()
        local ok, loaded, result = pcall(Library.SaveManager.Load, Library.SaveManager, configName.Value)
        Library:Notify(ok and loaded and "Config loaded" or (ok and result or "Config load failed"), 3)
    end,
})
configs:AddButton({
    Text = "Delete config",
    Func = function()
        local ok, deleted, result = pcall(Library.SaveManager.Delete, Library.SaveManager, configName.Value)
        Library:Notify(ok and deleted and "Config deleted" or (ok and result or "Config delete failed"), 3)
    end,
})
configs:AddButton({
    Text = "Load autoload config",
    Func = function()
        local ok = pcall(Library.SaveManager.LoadAutoloadConfig, Library.SaveManager)
        Library:Notify(ok and "Autoload checked" or "Autoload failed", 3)
    end,
})

print("[UI Reborn Enhancement] loaded")