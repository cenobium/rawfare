local repo = "https://raw.githubusercontent.com/cenobium/rawfare/main/"
local Library = loadstring(game:HttpGet(repo .. "UIReborn.lua?v=20261124mobilefix"))()

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
local Settings = Tabs.Settings:AddLeftGroupbox("Interface")
Settings:AddLabel("Use the floating screen controls.")
Settings:AddLabel("RightControl also toggles the window.")
Settings:AddLabel("Two-finger touch is supported.")
Settings:AddButton({
    Text = "Unload library",
    Func = function()
        Library:Unload()
    end
})
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
Dock.AnchorPoint = Vector2.new(1, 0.5)
Dock.Position = UDim2.new(1, -12, 0.46, 0)
Dock.Size = UDim2.fromOffset(116, 78)
Dock.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Dock.BorderColor3 = Color3.fromRGB(145, 190, 255)
Dock.BorderSizePixel = 1
Dock.Parent = DockGui

local function MakeDockButton(name, text, y)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Position = UDim2.fromOffset(4, y)
    button.Size = UDim2.new(1, -8, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    button.BorderColor3 = Color3.fromRGB(55, 55, 55)
    button.TextColor3 = Color3.fromRGB(245, 245, 245)
    button.TextSize = 13
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.AutoButtonColor = true
    button.Parent = Dock
    return button
end

local ToggleButton = MakeDockButton("ToggleUI", "HIDE / SHOW", 4)
local LockButton = MakeDockButton("LockUI", "LOCK: OFF", 41)

ToggleButton.Activated:Connect(function()
    Library:Toggle()
end)

LockButton.Activated:Connect(function()
    local locked = Library:ToggleLock()
    LockButton.Text = locked and "LOCK: ON" or "LOCK: OFF"
end)

Library:OnUnload(function()
    if DockGui and DockGui.Parent then
        DockGui:Destroy()
    end
end)

