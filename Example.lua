local repo = "https://raw.githubusercontent.com/cenobium/rawfare/main/"
local Library = loadstring(game:HttpGet(repo .. "UIReborn.lua"))()

Library.Font = Enum.Font.Gotham
Library.MainColor = Color3.fromRGB(18, 18, 18)
Library.BackgroundColor = Color3.fromRGB(12, 12, 12)
Library.AccentColor = Color3.fromRGB(145, 190, 255)
Library.OutlineColor = Color3.fromRGB(38, 38, 38)
Library:UpdateColorsUsingRegistry()

local Window = Library:CreateWindow({
    Title = "UI Reborn",
    Center = true,
    AutoShow = true,
    TabPadding = 5,
    MenuFadeTime = 0.15,
    Size = UDim2.fromOffset(560, 300)
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
Right:AddLabel("Color"):AddColorPicker("DemoColor", {
    Default = Color3.fromRGB(145, 190, 255),
    Title = "Accent color"
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
Settings:AddButton({
    Text = "Toggle UI",
    Func = function()
        Library:Toggle()
    end
})
Settings:AddToggle("LockUI", {
    Text = "Lock UI position",
    Default = false,
    Callback = function(value)
        Library:SetLocked(value)
    end
})
Settings:AddLabel("Restore: RightControl")
Settings:AddLabel("Mobile: two-finger touch")
Settings:AddButton({
    Text = "Unload library",
    Func = function()
        Library:Unload()
    end
})
