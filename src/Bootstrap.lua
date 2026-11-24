local Bootstrap = {}

local function getService(name)
    return game:GetService(name)
end

local function makeLibrary()
    return {
        FontColor = Color3.fromRGB(255, 255, 255),
        MainColor = Color3.fromRGB(19, 19, 19),
        AccentColor = Color3.fromRGB(162, 205, 255),
        OutlineColor = Color3.fromRGB(33, 33, 33),
        BackgroundColor = Color3.fromRGB(21, 21, 21),
        NotifyOnError = true,
        Unnamed = "UI Reborn Enhancement",
        SaveManager = nil,
        ThemeManager = nil,
        ScreenGui = nil,
        Registry = {},
        RegistryMap = {},
        Flags = {},
        Options = {},
        Toggles = {},
        Events = {},
    }
end

local function makeCaptures(library, bindings)
    assert(type(bindings) == "table", "UI Reborn Enhancement: bindings table required")

    local captures = table.clone(bindings)
    captures[0] = library
    captures[6] = captures[6] or getService("UserInputService")
    captures[13] = captures[13] or getService("ContextActionService")
    captures[18] = captures[18] or getService("TextService")
    captures[19] = captures[19] or getService("RunService")
    captures[21] = captures[21] or getService("Teams")
    captures[22] = captures[22] or getService("Players")

    local required = {
        1, 2, 3, 4, 5, 7, 8, 9, 10, 11, 12, 14, 15, 16, 17, 20, 23,
    }

    for _, index in ipairs(required) do
        assert(captures[index] ~= nil, ("UI Reborn Enhancement: capture %d is not mapped"):format(index))
    end

    return captures
end

function Bootstrap.start(Native, bindings)
    assert(type(Native) == "table", "Native library table required")
    assert(type(Native.library) == "function", "Native.library factory missing")

    local library = makeLibrary()
    local captures = makeCaptures(library, bindings)

    local extendLibrary = Native.library(captures)
    assert(type(extendLibrary) == "function", "Native.library did not return its extension function")
    extendLibrary()

    local parent = captures[10]
    if parent == nil then
        local getHidden = gethui
        parent = type(getHidden) == "function" and getHidden() or getService("CoreGui")
    end

    library.Captures = captures

    library.ScreenGui = library:Create("ScreenGui", {
        Name = "UI Reborn Enhancement",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = parent,
    })

    local shared = type(getgenv) == "function" and getgenv() or _G
    shared.Library = library
    shared.Options = library.Options
    shared.Toggles = library.Toggles

    return library, captures
end

return Bootstrap
