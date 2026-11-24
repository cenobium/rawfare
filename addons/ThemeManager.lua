local HttpService = game:GetService("HttpService")

local ThemeManager = {
    Folder = "UIReborn",
    BuiltInThemes = {
        ["Default"] = {FontColor="ffffff", MainColor="1c1c1c", AccentColor="0055ff", BackgroundColor="141414", OutlineColor="323232"},
        ["Midnight"] = {FontColor="e8eaf0", MainColor="181b24", AccentColor="7897ff", BackgroundColor="101219", OutlineColor="303747"},
        ["Mint"] = {FontColor="ffffff", MainColor="202a27", AccentColor="43c59e", BackgroundColor="151d1a", OutlineColor="34443e"},
        ["Rose"] = {FontColor="ffffff", MainColor="2a2027", AccentColor="e36b9a", BackgroundColor="1c151a", OutlineColor="49313f"},
        ["Violet"] = {FontColor="ffffff", MainColor="251f31", AccentColor="a78bfa", BackgroundColor="191523", OutlineColor="3e3450"},
        ["Amber"] = {FontColor="ffffff", MainColor="2b261d", AccentColor="e6ad55", BackgroundColor="1d1a14", OutlineColor="49402d"},
        ["Ocean"] = {FontColor="f2f7ff", MainColor="1b2934", AccentColor="55b8e8", BackgroundColor="121d25", OutlineColor="30495a"}
    },
    Fields = {"FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor"}
}

local function envfn(name)
    local env = type(getgenv) == "function" and getgenv() or _G
    return env[name] or _G[name]
end

function ThemeManager:SetLibrary(library)
    self.Library = library
end

function ThemeManager:SetFolder(folder)
    self.Folder = folder
    self:BuildFolderTree()
end

function ThemeManager:BuildFolderTree()
    local makefolder, isfolder = envfn("makefolder"), envfn("isfolder")
    if not makefolder or not isfolder then return false end
    for _, path in ipairs({self.Folder, self.Folder .. "/themes"}) do
        if not isfolder(path) then pcall(makefolder, path) end
    end
    return true
end

function ThemeManager:ThemeUpdate()
    local lib = self.Library
    lib.AccentColorDark = lib:GetDarkerColor(lib.AccentColor)
    lib:UpdateColorsUsingRegistry()
end

function ThemeManager:ApplyTheme(name)
    local theme = self.BuiltInThemes[name] or self:GetCustomTheme(name)
    if not theme then return false, "theme not found" end
    for _, field in ipairs(self.Fields) do
        if theme[field] then self.Library[field] = Color3.fromHex(theme[field]) end
    end
    self:ThemeUpdate()
    if self.Library.Options.ThemeManager_ThemeList then
        self.Library.Options.ThemeManager_ThemeList.Value = name
    end
    return true
end

function ThemeManager:SaveDefault(name)
    local writefile = envfn("writefile")
    if not writefile then return false, "writefile unavailable" end
    local ok, err = pcall(writefile, self.Folder .. "/themes/default.txt", name)
    return ok, ok and nil or tostring(err)
end

function ThemeManager:GetDefault()
    local readfile, isfile = envfn("readfile"), envfn("isfile")
    local path = self.Folder .. "/themes/default.txt"
    if not readfile or not isfile or not isfile(path) then return "Default" end
    local ok, name = pcall(readfile, path)
    return ok and name or "Default"
end

function ThemeManager:GetCustomTheme(name)
    local readfile, isfile = envfn("readfile"), envfn("isfile")
    local path = self.Folder .. "/themes/" .. tostring(name) .. ".json"
    if not readfile or not isfile or not isfile(path) then return nil end
    local ok, content = pcall(readfile, path)
    if not ok then return nil end
    local decodedOk, data = pcall(HttpService.JSONDecode, HttpService, content)
    return decodedOk and data or nil
end

function ThemeManager:SaveCustomTheme(name)
    if type(name) ~= "string" or name:gsub("[%s%p]", "") == "" or name:find("[/\\]") then
        return false, "invalid theme name"
    end
    local writefile = envfn("writefile")
    if not writefile then return false, "writefile unavailable" end
    local data = {}
    for _, field in ipairs(self.Fields) do data[field] = self.Library[field]:ToHex() end
    local ok, err = pcall(writefile, self.Folder .. "/themes/" .. name .. ".json", HttpService:JSONEncode(data))
    return ok, ok and nil or tostring(err)
end

function ThemeManager:RefreshCustomThemes()
    local listfiles = envfn("listfiles")
    if not listfiles then return {} end
    local ok, files = pcall(listfiles, self.Folder .. "/themes")
    if not ok then return {} end
    local names = {}
    for _, path in ipairs(files) do
        local name = tostring(path):match("([^/\\]+)%.json$")
        if name and name ~= "default" then table.insert(names, name) end
    end
    table.sort(names)
    return names
end

ThemeManager:BuildFolderTree()
return ThemeManager
