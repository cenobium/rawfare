local repo = "https://raw.githubusercontent.com/cenobium/rawfare/main/"
local Library = loadstring(game:HttpGet(repo .. "UIReborn.lua?v=20261124api-docs"))()

Library.Font = Enum.Font.Gotham
Library.MainColor = Color3.fromRGB(18, 18, 18)
Library.BackgroundColor = Color3.fromRGB(12, 12, 12)
Library.AccentColor = Color3.fromRGB(145, 190, 255)
Library.OutlineColor = Color3.fromRGB(38, 38, 38)
Library:UpdateColorsUsingRegistry()

local Camera = workspace.CurrentCamera
local Viewport = Camera and Camera.ViewportSize or Vector2.new(900, 600)
local WindowWidth = math.min(900, Viewport.X - 32)
local WindowHeight = math.min(460, Viewport.Y - 48)

local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua?v=20261124"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua?v=20261124"))()
SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
SaveManager:SetFolder("UIReborn")
ThemeManager:SetFolder("UIReborn")
SaveManager:SetIgnoreIndexes({"MenuKey", "ThemeManager_ThemeList", "ThemeManager_CustomThemeName", "SaveManager_ConfigName", "SaveManager_ConfigList", "SaveManager_ImportConfig", "SaveManager_CommunityList"})

local Window = Library:CreateWindow({
    Title = "UI Reborn",
    Center = true,
    AutoShow = true,
    TabPadding = 5,
    MenuFadeTime = 0.15,
    Size = UDim2.fromOffset(WindowWidth, WindowHeight)
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Settings = Window:AddTab("Settings")
}

local Main = Tabs.Main:AddLeftGroupbox("Showcase")
local Right = Tabs.Main:AddRightGroupbox("Controls")

Main:AddLabel("Linoria-based UI library")
Main:AddToggle("DemoToggle", {
    Text = "Example toggle",
    Default = false
})
Main:AddSlider("DemoSlider", {
    Text = "Example slider",
    Default = 35,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%"
})
Main:AddDropdown("DemoDropdown", {
    Text = "Example dropdown",
    Values = {"First", "Second", "Third"},
    Default = 1
})
Main:AddButton({
    Text = "Show notification",
    Func = function()
        Library:Notify("UI Reborn is working", 3)
    end
})
Right:AddLabel("Accent color"):AddColorPicker("DemoColor", {
    Default = Color3.fromRGB(145, 190, 255),
    Title = "Accent color",
    Callback = function(color)
        Library.AccentColor = color
        Library:UpdateColorsUsingRegistry()
    end
})
Right:AddLabel("Menu key"):AddKeyPicker("MenuKey", {
    Default = "RightControl",
    Mode = "Toggle",
    Text = "Toggle interface",
    NoUI = true
})
Right:AddInput("DemoInput", {
    Text = "Text input",
    Default = "",
    Placeholder = "Type here",
    Finished = false
})
local Menu = Tabs.Settings:AddLeftGroupbox("Menu")
Menu:AddLabel("Menu key"):AddKeyPicker("MenuKey", {
    Default = "RightControl",
    Mode = "Toggle",
    Text = "Menu",
    NoUI = true,
    ChangedCallback = function(key)
        Library.ToggleKeybind = Options.MenuKey
    end
})
Library.ToggleKeybind = Options.MenuKey

local MenuTransparency = Menu:AddSlider("MenuTransparency", {
    Text = "Menu transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(value)
        local alpha = math.clamp(value, 0, 1)
        for _, item in ipairs(Library.ScreenGui:GetDescendants()) do
            if item:IsA("Frame") or item:IsA("ScrollingFrame") or item:IsA("TextButton") then
                if item:GetAttribute("UIRebornBaseTransparency") == nil then
                    item:SetAttribute("UIRebornBaseTransparency", item.BackgroundTransparency)
                end
                local base = item:GetAttribute("UIRebornBaseTransparency")
                item.BackgroundTransparency = base + (1 - base) * alpha
            end
        end
    end
})
Menu:AddDropdown("KeybindMenuMode", {
    Text = "Keybind menu mode",
    Values = {"Active", "Toggled", "All"},
    Default = "All",
    Callback = function(value)
        Library.KeybindListMode = value
        for _, option in pairs(Options) do
            if option.Type == "KeyPicker" and option.Update then option:Update() end
        end
    end
})
Menu:AddButton({
    Text = "Unload library",
    Func = function()
        Library:Unload()
    end
})

local ThemeBox = Tabs.Settings:AddLeftTabbox("Theme / Background")
local ThemeTab = ThemeBox:AddTab("Theme")
local BackgroundTab = ThemeBox:AddTab("Background")
local ThemeGroup = ThemeTab:AddLeftGroupbox("Theme colors")
local function addThemeColor(id, title, field)
    ThemeGroup:AddLabel(title):AddColorPicker(id, {
        Default = Library[field],
        Title = title,
        Callback = function(color)
            Library[field] = color
            ThemeManager:ThemeUpdate()
        end
    })
end
addThemeColor("FontColor", "Font color", "FontColor")
addThemeColor("MainColor", "Main color", "MainColor")
addThemeColor("AccentColor", "Accent color", "AccentColor")
addThemeColor("BackgroundColor", "Background color", "BackgroundColor")
addThemeColor("OutlineColor", "Outline color", "OutlineColor")

local builtInThemes = {}
for name in pairs(ThemeManager.BuiltInThemes) do table.insert(builtInThemes, name) end
table.sort(builtInThemes)
local customThemes = ThemeManager:RefreshCustomThemes()
for _, name in ipairs(customThemes) do table.insert(builtInThemes, name) end
ThemeGroup:AddDropdown("ThemeManager_ThemeList", {
    Text = "Theme list",
    Values = builtInThemes,
    Default = ThemeManager:GetDefault(),
    Callback = function(name)
        if name then
            local ok, err = ThemeManager:ApplyTheme(name)
            if not ok then Library:Notify(err, 3) end
        end
    end
})
ThemeGroup:AddInput("ThemeManager_CustomThemeName", {
    Text = "Custom theme name",
    Default = "",
    Placeholder = "Theme name"
})
ThemeGroup:AddButton({Text = "Save theme", Func = function()
    local ok, err = ThemeManager:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)
    Library:Notify(ok and "Theme saved" or tostring(err), 3)
    local values = {}
    for name in pairs(ThemeManager.BuiltInThemes) do table.insert(values, name) end
    for _, name in ipairs(ThemeManager:RefreshCustomThemes()) do table.insert(values, name) end
    table.sort(values)
    Options.ThemeManager_ThemeList:SetValues(values)
end}):AddButton({Text = "Set default", Func = function()
    local name = Options.ThemeManager_ThemeList.Value
    if not name then return Library:Notify("Select a theme", 2) end
    local ok, err = ThemeManager:SaveDefault(name)
    Library:Notify(ok and ("Default theme: " .. name) or tostring(err), 3)
end})

local Lighting = game:GetService("Lighting")
local Blur = Lighting:FindFirstChild("UIRebornBlur") or Instance.new("BlurEffect")
Blur.Name = "UIRebornBlur"
Blur.Parent = Lighting
local ColorEffect = Lighting:FindFirstChild("UIRebornColor") or Instance.new("ColorCorrectionEffect")
ColorEffect.Name = "UIRebornColor"
ColorEffect.Parent = Lighting
local BackgroundGroup = BackgroundTab:AddLeftGroupbox("Background effects")
BackgroundGroup:AddSlider("BackgroundBlur", {
    Text = "Blur",
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Callback = function(value) Blur.Size = value end
})
BackgroundGroup:AddSlider("BackgroundContrast", {
    Text = "Contrast",
    Default = 5,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(value) ColorEffect.Contrast = (value - 5) / 5 end
})
BackgroundGroup:AddSlider("BackgroundSaturation", {
    Text = "Saturation",
    Default = 5,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Callback = function(value) ColorEffect.Saturation = (value - 5) / 5 end
})
BackgroundGroup:AddSlider("BackgroundBrightness", {
    Text = "Brightness",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(value) ColorEffect.Brightness = (value - 0.5) * 2 end
})

local Configuration = Tabs.Settings:AddRightGroupbox("Configuration")
Configuration:AddInput("SaveManager_ConfigName", {
    Text = "Config name",
    Default = "",
    Placeholder = "Enter config name"
})
Configuration:AddDropdown("SaveManager_ConfigList", {
    Text = "Config list",
    Values = SaveManager:RefreshConfigList(),
    AllowNull = true
})
local function refreshConfigs()
    Options.SaveManager_ConfigList:SetValues(SaveManager:RefreshConfigList())
    Options.SaveManager_ConfigList:SetValue(nil)
end
local function notifyResult(ok, err, successText)
    Library:Notify(ok and successText or tostring(err), 3)
end
Configuration:AddButton({Text = "Create config", Func = function()
    local name = Options.SaveManager_ConfigName.Value
    local ok, err = SaveManager:Save(name)
    notifyResult(ok, err, "Config created")
    if ok then refreshConfigs() end
end}):AddButton({Text = "Load config", Func = function()
    local ok, err = SaveManager:Load(Options.SaveManager_ConfigList.Value)
    notifyResult(ok, err, "Config loaded")
end})
Configuration:AddButton({Text = "Overwrite config", Func = function()
    local ok, err = SaveManager:Save(Options.SaveManager_ConfigList.Value)
    notifyResult(ok, err, "Config overwritten")
end}):AddButton({Text = "Delete config", Func = function()
    local ok, err = SaveManager:Delete(Options.SaveManager_ConfigList.Value)
    notifyResult(ok, err, "Config deleted")
    if ok then refreshConfigs() end
end})
Configuration:AddButton({Text = "Refresh list", Func = refreshConfigs})
local autoloadName = SaveManager:GetAutoload() or "none"
local autoloadLabel = Configuration:AddLabel("Current autoload config: " .. autoloadName, true)
Configuration:AddButton({Text = "Set autoload", Func = function()
    local name = Options.SaveManager_ConfigList.Value
    if not name then return Library:Notify("Select a config", 2) end
    local ok, err = SaveManager:SetAutoload(name)
    if ok then autoloadLabel:SetText("Current autoload config: " .. name) end
    notifyResult(ok, err, "Autoload config set")
end}):AddButton({Text = "Remove autoload", Func = function()
    local ok, err = SaveManager:RemoveAutoload()
    if ok then autoloadLabel:SetText("Current autoload config: none") end
    notifyResult(ok, err, "Autoload config removed")
end})
Configuration:AddDivider()
Configuration:AddInput("SaveManager_ImportConfig", {
    Text = "Paste config here",
    Default = "",
    Placeholder = "Paste JSON configuration"
})
Configuration:AddButton({Text = "Import pasted config", Func = function()
    local ok, err = SaveManager:Import(Options.SaveManager_ImportConfig.Value)
    notifyResult(ok, err, "Config imported")
end}):AddButton({Text = "Copy config", Func = function()
    local ok, err = SaveManager:CopyToClipboard()
    notifyResult(ok, err, "Config copied to clipboard")
end})
Configuration:AddButton({Text = "Paste clipboard config", Func = function()
    local getclipboard = (type(getgenv) == "function" and getgenv().getclipboard) or getclipboard
    if not getclipboard then return Library:Notify("Clipboard read is unavailable", 3) end
    local ok, value = pcall(getclipboard)
    if not ok or type(value) ~= "string" then return Library:Notify("Clipboard read failed", 3) end
    Options.SaveManager_ImportConfig:SetValue(value)
end})
Configuration:AddDivider()
Configuration:AddDropdown("SaveManager_CommunityList", {
    Text = "Community configs",
    Values = SaveManager:RefreshCommunityList(),
    AllowNull = true
})
Configuration:AddButton({Text = "Refresh community list", Func = function()
    Options.SaveManager_CommunityList:SetValues(SaveManager:RefreshCommunityList())
    Options.SaveManager_CommunityList:SetValue(nil)
end}):AddButton({Text = "Load community config", Func = function()
    local ok, err = SaveManager:LoadCommunity(Options.SaveManager_CommunityList.Value)
    notifyResult(ok, err, "Community config loaded")
end})

local defaultTheme = ThemeManager:GetDefault()
if defaultTheme then ThemeManager:ApplyTheme(defaultTheme) end
local loadedAuto = SaveManager:LoadAutoloadConfig()
if loadedAuto then Library:Notify("Autoload config loaded", 3) end

Library:OnUnload(function()
    if Blur and Blur.Parent then Blur:Destroy() end
    if ColorEffect and ColorEffect.Parent then ColorEffect:Destroy() end
end)
local Parent = Library.ScreenGui.Parent
local PreviousDock = Parent:FindFirstChild("UIRebornControls")
if PreviousDock then
    PreviousDock:Destroy()
end

local DockGui = Instance.new("ScreenGui")
DockGui.Name = "UIRebornControls"
DockGui.IgnoreGuiInset = true
DockGui.ResetOnSpawn = false
DockGui.DisplayOrder = 10000
DockGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
DockGui.Parent = Parent

local Dock = Instance.new("Frame")
Dock.Name = "Controls"
Dock.AnchorPoint = Vector2.new(0.5, 1)
Dock.Position = UDim2.new(0.5, 0, 1, -18)
Dock.Size = UDim2.fromOffset(154, 64)
Dock.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Dock.BorderColor3 = Color3.fromRGB(145, 190, 255)
Dock.BorderSizePixel = 1
Dock.Active = true
Dock.Parent = DockGui

local DockInputService = game:GetService("UserInputService")
local DockRunService = game:GetService("RunService")

local DockTitle = Instance.new("TextLabel")
DockTitle.Name = "DragHandle"
DockTitle.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
DockTitle.BorderSizePixel = 0
DockTitle.Size = UDim2.new(1, 0, 0, 19)
DockTitle.Font = Enum.Font.GothamBold
DockTitle.TextSize = 10
DockTitle.TextColor3 = Color3.fromRGB(225, 225, 225)
DockTitle.Text = "UI REBORN CONTROLS"
DockTitle.Parent = Dock

local function MakeDockButton(name, text, x)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Position = UDim2.fromOffset(x, 23)
    button.Size = UDim2.fromOffset(72, 35)
    button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    button.BorderColor3 = Color3.fromRGB(55, 55, 55)
    button.TextColor3 = Color3.fromRGB(245, 245, 245)
    button.TextSize = 11
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.AutoButtonColor = true
    button.Parent = Dock
    return button
end

local ToggleButton = MakeDockButton("ToggleUI", "HIDE / SHOW", 3)
local LockButton = MakeDockButton("LockUI", "LOCK: OFF", 79)

DockTitle.Active = true
DockTitle.InputBegan:Connect(function(Input)
    local IsTouch = Input.UserInputType == Enum.UserInputType.Touch
    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and not IsTouch then
        return
    end
    if Library.Locked then
        return
    end

    local Start = IsTouch and Vector2.new(Input.Position.X, Input.Position.Y) or DockInputService:GetMouseLocation()
    local Origin = Dock.AbsolutePosition
    local Dragging = true
    local EndConnection
    if IsTouch then
        EndConnection = Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End or Input.UserInputState == Enum.UserInputState.Cancel then
                Dragging = false
            end
        end)
    end

    repeat
        local Point = IsTouch and Vector2.new(Input.Position.X, Input.Position.Y) or DockInputService:GetMouseLocation()
        local Camera = workspace.CurrentCamera
        local Viewport = Camera and Camera.ViewportSize or Vector2.new(800, 600)
        local X = math.clamp(Origin.X + Point.X - Start.X, 4, math.max(4, Viewport.X - Dock.AbsoluteSize.X - 4))
        local Y = math.clamp(Origin.Y + Point.Y - Start.Y, 4, math.max(4, Viewport.Y - Dock.AbsoluteSize.Y - 4))
        Dock.Position = UDim2.fromOffset(X + Dock.AbsoluteSize.X * 0.5, Y + Dock.AbsoluteSize.Y)
        DockRunService.RenderStepped:Wait()
    until (IsTouch and not Dragging) or (not IsTouch and not DockInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1))

    if EndConnection then
        EndConnection:Disconnect()
    end
end)

ToggleButton.Activated:Connect(function()
    Library:Toggle()
end)

LockButton.Activated:Connect(function()
    local locked = Library:ToggleLock()
    LockButton.Text = locked and "LOCK: ON" or "LOCK: OFF"
    DockTitle.Text = locked and "UI REBORN CONTROLS | LOCKED" or "UI REBORN CONTROLS"
end)

Library:OnUnload(function()
    if DockGui and DockGui.Parent then
        DockGui:Destroy()
    end
end)

