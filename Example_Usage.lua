local base = "https://raw.githubusercontent.com/cenobium/rawfare/main/"

local function load(path)
    return assert(loadstring(game:HttpGet(base .. path)))()
end

local Native = load("Rivals_UE_UI_Library_inline.lua")
local Bootstrap = load("src/Bootstrap.lua")
local WindowModule = load("src/Window.lua")

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

left:AddToggle({
    Text = "Enabled",
    Flag = "Enabled",
    Default = false,
    Callback = function(value)
        print("Enabled:", value)
    end,
})
left:AddSlider({
    Text = "Amount",
    Flag = "Amount",
    Min = 0,
    Max = 100,
    Default = 25,
})
left:AddDropdown({
    Text = "Mode",
    Flag = "Mode",
    Values = {"One", "Two", "Three"},
    Default = "One",
})
right:AddButton({
    Text = "Notify",
    Func = function()
        Library:Notify("Ready", 2)
    end,
})
