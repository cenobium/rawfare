local repo = "https://raw.githubusercontent.com/cenobium/rawfare/main/"
local Library = loadstring(game:HttpGet(repo .. "UIReborn.lua?v=touch-window-picker-fix-20261124"))()

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
    Main = Window:AddTab("Main")
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

Main:AddMultiDropdown("DemoTargetParts", {
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
        local selected = {}
        for name, enabled in pairs(values) do
            if enabled then table.insert(selected, name) end
        end
        table.sort(selected)
        print("Selected parts: " .. table.concat(selected, ", "))
    end
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
Right:AddLabel("Key picker"):AddKeyPicker("DemoKey", {
    Default = "RightControl",
    Mode = "Toggle",
    Text = "Demo key",
    NoUI = true
})
Right:AddInput("DemoInput", {
    Text = "Text input",
    Default = "",
    Placeholder = "Type here",
    Finished = false
})
local Settings = Library:CreateSettingsTab(Window, {
    Folder = "UIReborn"
})

Library:Notify("UI Reborn is working", 3)

