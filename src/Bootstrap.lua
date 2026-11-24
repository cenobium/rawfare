local Bootstrap = {}

local function makeSlot(name, value)
    local values = {}
    if value ~= nil then
        values[name] = value
    end
    return {
        [2] = name,
        [3] = setmetatable(values, {
            __index = function(_, key)
                return value
            end,
        }),
    }
end

local function getParent()
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then
            return result
        end
    end
    return game:GetService("CoreGui")
end

local function protect(instance)
    local fn = protect_gui or protectgui
    if type(fn) ~= "function" and type(syn) == "table" then
        fn = syn.protect_gui
    end
    if type(fn) == "function" then
        pcall(fn, instance)
    end
end

local function makeFolder(parent, name)
    local folder = Instance.new("Folder")
    folder.Name = name
    folder.Parent = parent
    return folder
end

local function makeLibrary(Native)
    local players = game:GetService("Players")
    local userInput = game:GetService("UserInputService")
    local runService = game:GetService("RunService")
    local textService = game:GetService("TextService")
    local teams = game:GetService("Teams")
    local contextAction = game:GetService("ContextActionService")
    local parent = getParent()
    local player = players.LocalPlayer
    local mouse = player and player:GetMouse() or {X = 0, Y = 0}
    local assetUrls = {}
    if Native.Assets and type(Native.Assets.install) == "function" then
        local ok, result = pcall(Native.Assets.install)
        if ok and type(result) == "table" then
            assetUrls = result
        end
    end
    local font = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    local titleAsset = assetUrls["BurbankBigCondensed-Black.otf"]
    if titleAsset then
        local ok, result = pcall(Font.new, titleAsset)
        if ok then
            font = result
        end
    end
    local library = {
        Unnamed = "UI Reborn Enhancement",
        Font = font,
        FontColor = Color3.fromRGB(255, 255, 255),
        MainColor = Color3.fromRGB(19, 19, 19),
        AccentColor = Color3.fromRGB(162, 205, 255),
        OutlineColor = Color3.fromRGB(33, 33, 33),
        BackgroundColor = Color3.fromRGB(21, 21, 21),
        RiskColor = Color3.fromRGB(255, 116, 37),
        NotifyOnError = true,
        FlagCopying = false,
        IsMobile = userInput.TouchEnabled,
        CanDrag = true,
        CantDragForced = false,
        MinSize = Vector2.new(280, 180),
        Registry = {},
        RegistryMap = {},
        HudRegistry = {},
        Signals = {},
        Events = {},
        Flags = {},
        Options = {},
        Toggles = {},
        DependencyBoxes = {},
        OpenedFrames = {},
        Tabs = {},
        Tabboxes = {},
        TotalTabs = 0,
        NotificationStyle = {
            Transparency = 0,
            BarSide = "Bottom",
        },
        KeypickerListMode = "Active",
        KeypickerListVisible = false,
        UserInputService = userInput,
        Players = players,
        RunService = runService,
        TextService = textService,
        Teams = teams,
        ContextActionService = contextAction,
        AssetUrls = assetUrls,
    }
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UI Reborn Enhancement"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.DisplayOrder = 999
    screenGui.Parent = parent
    protect(screenGui)
    library.ScreenGui = screenGui
    local cleanupA = makeFolder(screenGui, "UE_Cleanup_A")
    local cleanupB = makeFolder(screenGui, "UE_Cleanup_B")
    local cleanupC = makeFolder(screenGui, "UE_Cleanup_C")
    local state = {Visible = true}
    local playerValues = {}
    local teamValues = {}
    local outlineSlot = makeSlot("OutlineColor", library.OutlineColor)
    local optionalGui = makeSlot("ActiveContainer", nil)
    local captures = {
        [0] = library,
        [1] = makeSlot("new", Instance.new),
        [2] = makeSlot("BindableEvent", nil),
        [3] = mouse,
        [4] = runService.RenderStepped,
        [5] = cleanupA,
        [6] = userInput,
        [7] = makeSlot("Visible", true),
        [8] = makeSlot("GetPlayers", nil),
        [9] = screenGui,
        [10] = parent,
        [11] = makeSlot("GetTeams", nil),
        [12] = optionalGui,
        [13] = contextAction,
        [14] = {},
        [15] = outlineSlot,
        [16] = cleanupB,
        [17] = warn,
        [18] = textService,
        [19] = runService,
        [20] = cleanupC,
        [21] = teams,
        [22] = players,
        [23] = protect,
    }
    captures[1][3] = {new = Instance.new}
    captures[2][3] = {BindableEvent = "BindableEvent"}
    captures[7][3] = {Visible = true}
    captures[8][3] = playerValues
    captures[11][3] = teamValues
    captures[12][3] = {}
    captures[15][3] = setmetatable({}, {
        __index = function(_, key)
            return library[key]
        end,
    })
    captures[7][3] = setmetatable({Visible = true}, {
        __index = function(_, key)
            return state[key]
        end,
        __newindex = function(target, key, value)
            rawset(target, key, value)
            state[key] = value
        end,
    })
    local extend = Native.library(captures)
    assert(type(extend) == "function", "Native.library did not return its extension")
    extend()
    library.Captures = captures
    library.Native = Native
    library:ApplyLayout = nil
    library.CaptureState = state
    library:CreateEvent("VisibilityChanged")
    function library:ApplyLayout()
        for index, tab in ipairs(self.TabOrder or {}) do
            if tab.Button then
                tab.Button.LayoutOrder = index
            end
        end
    end
    library.NotificationArea = library:Create("Frame", {
        Name = "Notifications",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -8, 0, 8),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.fromOffset(260, 180),
        Parent = screenGui,
    })
    library:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = library.NotificationArea,
    })
    library.Watermark = library:Create("Frame", {
        BackgroundColor3 = library.MainColor,
        BorderColor3 = library.OutlineColor,
        Size = UDim2.fromOffset(160, 24),
        Position = UDim2.fromOffset(8, 8),
        Visible = false,
        Parent = screenGui,
    })
    library.WatermarkText = library:CreateLabel({
        Size = UDim2.fromScale(1, 1),
        Text = library.Unnamed,
        TextSize = 14,
        Parent = library.Watermark,
    })
    library:AddToRegistry(library.Watermark, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "OutlineColor",
    })
    local themeManager = {}
    local themeSetup = Native.themes({
        [0] = library.Options,
        [1] = themeManager,
        [2] = makeSlot("OutlineColor", "OutlineColor"),
    })
    themeSetup()
    themeManager:SetLibrary(library)
    if type(isfolder) == "function" and type(makefolder) == "function" then
        pcall(themeManager.SetFolder, themeManager, "RivalsUE")
    else
        themeManager.GetCustomTheme = function()
            return nil
        end
    end
    pcall(themeManager.ApplyTheme, themeManager, "Default")
    library.ThemeManager = themeManager
    local configManager = {}
    local configSetup = Native.configuration({
        [0] = configManager,
        [1] = library.Options,
        [2] = library.Toggles,
        [3] = makeSlot("OutlineColor", "OutlineColor"),
    })
    configSetup()
    configManager:SetLibrary(library)
    configManager.Folder = "RivalsUE"
    configManager:IgnoreThemeSettings()
    library.SaveManager = configManager
    local shared = type(getgenv) == "function" and getgenv() or _G
    shared.Library = library
    shared.Options = library.Options
    shared.Toggles = library.Toggles
    shared.ThemeManager = themeManager
    shared.SaveManager = configManager
    return library, Native, captures
end

function Bootstrap.start(Native)
    assert(type(Native) == "table", "Native library table required")
    assert(type(Native.library) == "function", "Native.library factory missing")
    local library, native, captures = makeLibrary(Native)
    return library, native, captures
end

return Bootstrap