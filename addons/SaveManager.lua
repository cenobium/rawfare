local HttpService = game:GetService("HttpService")

local SaveManager = {
    Folder = "UIReborn",
    Ignore = {},
    CommunityIndex = "https://raw.githubusercontent.com/cenobium/rawfare/main/community-configs/index.json"
}

local function available(name)
    return type(_G[name]) == "function" or type(getgenv) == "function" and type(getgenv()[name]) == "function"
end

local function envfn(name)
    local env = type(getgenv) == "function" and getgenv() or _G
    return env[name] or _G[name]
end

function SaveManager:SetLibrary(library)
    self.Library = library
    self.Toggles = library.Toggles
    self.Options = library.Options
end

function SaveManager:SetFolder(folder)
    self.Folder = folder
    self:BuildFolderTree()
end

function SaveManager:SetIgnoreIndexes(indexes)
    for _, index in ipairs(indexes) do self.Ignore[index] = true end
end

function SaveManager:BuildFolderTree()
    local makefolder = envfn("makefolder")
    local isfolder = envfn("isfolder")
    if not makefolder or not isfolder then return false, "executor file APIs unavailable" end
    for _, path in ipairs({self.Folder, self.Folder .. "/settings", self.Folder .. "/themes"}) do
        if not isfolder(path) then
            local ok, err = pcall(makefolder, path)
            if not ok then return false, tostring(err) end
        end
    end
    return true
end

local Parsers = {
    Toggle = {
        Save = function(id, object) return {type="Toggle", idx=id, value=object.Value} end,
        Load = function(self, data) if self.Toggles[data.idx] then self.Toggles[data.idx]:SetValue(data.value) end end
    },
    Slider = {
        Save = function(id, object) return {type="Slider", idx=id, value=object.Value} end,
        Load = function(self, data) if self.Options[data.idx] then self.Options[data.idx]:SetValue(tonumber(data.value)) end end
    },
    Dropdown = {
        Save = function(id, object) return {type="Dropdown", idx=id, value=object.Value, multi=object.Multi} end,
        Load = function(self, data) if self.Options[data.idx] then self.Options[data.idx]:SetValue(data.value) end end
    },
    ColorPicker = {
        Save = function(id, object) return {type="ColorPicker", idx=id, value=object.Value:ToHex(), transparency=object.Transparency} end,
        Load = function(self, data) if self.Options[data.idx] then self.Options[data.idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency or 0) end end
    },
    KeyPicker = {
        Save = function(id, object) return {type="KeyPicker", idx=id, key=object.Value, mode=object.Mode} end,
        Load = function(self, data) if self.Options[data.idx] then self.Options[data.idx]:SetValue({data.key, data.mode}) end end
    },
    Input = {
        Save = function(id, object) return {type="Input", idx=id, text=object.Value} end,
        Load = function(self, data) if self.Options[data.idx] and type(data.text) == "string" then self.Options[data.idx]:SetValue(data.text) end end
    }
}

function SaveManager:Export()
    local data = {version=1, objects={}}
    for id, object in pairs(self.Toggles) do
        if not self.Ignore[id] and Parsers[object.Type] then
            table.insert(data.objects, Parsers[object.Type].Save(id, object))
        end
    end
    for id, object in pairs(self.Options) do
        if not self.Ignore[id] and Parsers[object.Type] then
            table.insert(data.objects, Parsers[object.Type].Save(id, object))
        end
    end
    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if not ok then return nil, "could not encode configuration" end
    return encoded
end

function SaveManager:Import(encoded)
    local ok, data = pcall(HttpService.JSONDecode, HttpService, encoded)
    if not ok or type(data) ~= "table" or type(data.objects) ~= "table" then
        return false, "invalid configuration data"
    end
    for _, item in ipairs(data.objects) do
        local parser = Parsers[item.type]
        if parser then
            pcall(parser.Load, self, item)
        end
    end
    return true
end

function SaveManager:Save(name)
    if type(name) ~= "string" or name:gsub("[%s%p]", "") == "" then return false, "enter a config name" end
    if name:find("[/\\]") or #name > 48 then return false, "invalid config name" end
    local writefile = envfn("writefile")
    if not writefile then return false, "writefile is unavailable" end
    local encoded, err = self:Export()
    if not encoded then return false, err end
    local ok, result = pcall(writefile, self.Folder .. "/settings/" .. name .. ".json", encoded)
    if not ok then return false, tostring(result) end
    return true
end

function SaveManager:Load(name)
    if type(name) ~= "string" or name == "" then return false, "select a config" end
    local readfile, isfile = envfn("readfile"), envfn("isfile")
    local path = self.Folder .. "/settings/" .. name .. ".json"
    if not readfile or not isfile or not isfile(path) then return false, "config file not found" end
    local ok, content = pcall(readfile, path)
    if not ok then return false, tostring(content) end
    return self:Import(content)
end

function SaveManager:Delete(name)
    local delfile, isfile = envfn("delfile"), envfn("isfile")
    local path = self.Folder .. "/settings/" .. tostring(name) .. ".json"
    if not delfile or not isfile or not isfile(path) then return false, "config file not found or deletefile unavailable" end
    local ok, err = pcall(delfile, path)
    return ok, ok and nil or tostring(err)
end

function SaveManager:RefreshConfigList()
    local listfiles = envfn("listfiles")
    if not listfiles then return {} end
    local ok, files = pcall(listfiles, self.Folder .. "/settings")
    if not ok then return {} end
    local names = {}
    for _, path in ipairs(files) do
        local name = tostring(path):match("([^/\\]+)%.json$")
        if name then table.insert(names, name) end
    end
    table.sort(names)
    return names
end

function SaveManager:SetAutoload(name)
    local writefile = envfn("writefile")
    if not writefile then return false, "writefile is unavailable" end
    local ok, err = pcall(writefile, self.Folder .. "/settings/autoload.txt", name)
    return ok, ok and nil or tostring(err)
end

function SaveManager:RemoveAutoload()
    local delfile, isfile = envfn("delfile"), envfn("isfile")
    local path = self.Folder .. "/settings/autoload.txt"
    if not isfile or not delfile or not isfile(path) then return false, "no autoload config is set" end
    local ok, err = pcall(delfile, path)
    return ok, ok and nil or tostring(err)
end

function SaveManager:GetAutoload()
    local readfile, isfile = envfn("readfile"), envfn("isfile")
    local path = self.Folder .. "/settings/autoload.txt"
    if not readfile or not isfile or not isfile(path) then return nil end
    local ok, value = pcall(readfile, path)
    return ok and value or nil
end

function SaveManager:LoadAutoloadConfig()
    local name = self:GetAutoload()
    if not name or name == "" then return false, "no autoload config" end
    return self:Load(name)
end

function SaveManager:CopyToClipboard()
    local setclipboard = envfn("setclipboard") or envfn("toclipboard")
    if not setclipboard then return false, "clipboard write is unavailable" end
    local data, err = self:Export()
    if not data then return false, err end
    local ok, result = pcall(setclipboard, data)
    return ok, ok and nil or tostring(result)
end

function SaveManager:PasteFromClipboard()
    local getclipboard = envfn("getclipboard") or envfn("readclipboard")
    if not getclipboard then return false, "clipboard read is unavailable" end
    local ok, value = pcall(getclipboard)
    if not ok or type(value) ~= "string" then return false, "could not read clipboard" end
    return self:Import(value)
end

function SaveManager:RefreshCommunityList()
    local request = envfn("request") or envfn("http_request")
    local gameHttp = game.HttpGet
    local ok, body = pcall(function()
        if request then
            local response = request({Url=self.CommunityIndex, Method="GET"})
            return response.Body or response.body
        end
        return game:HttpGet(self.CommunityIndex)
    end)
    if not ok or type(body) ~= "string" then return {} end
    local decodedOk, entries = pcall(HttpService.JSONDecode, HttpService, body)
    if not decodedOk or type(entries) ~= "table" then return {} end
    self.CommunityEntries = {}
    local names = {}
    for _, entry in ipairs(entries) do
        if type(entry) == "table" and type(entry.name) == "string" and type(entry.url) == "string" then
            self.CommunityEntries[entry.name] = entry.url
            table.insert(names, entry.name)
        end
    end
    table.sort(names)
    return names
end

function SaveManager:LoadCommunity(name)
    local url = self.CommunityEntries and self.CommunityEntries[name]
    if not url then return false, "select a community config" end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if not ok or type(body) ~= "string" then return false, "could not download community config" end
    return self:Import(body)
end

SaveManager:BuildFolderTree()
return SaveManager
