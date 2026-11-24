local repo = "https://raw.githubusercontent.com/cenobium/rawfare/main/"
local Library = loadstring(game:HttpGet(repo .. "UIReborn.lua?v=20261124touchslider3"))()

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
        local Point = IsTouch and Vector2.new(Input.Position.X, Input.Position.Y) or Vector2.new(Library.Mouse.X, Library.Mouse.Y)
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

