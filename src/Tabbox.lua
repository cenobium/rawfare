local Tabbox = {}

local REQUIRED = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}

function Tabbox.attach(Native, captures)
    assert(type(Native) == "table" and type(Native.tabBox) == "function", "Native.tabBox factory missing")
    assert(type(captures) == "table", "Native.tabBox captures must be a table")
    for _, index in ipairs(REQUIRED) do
        assert(captures[index] ~= nil, ("Native.tabBox capture %d is missing"):format(index))
    end
    local tabContainer = captures[3]
    assert(type(tabContainer) == "table", "Native.tabBox capture 3 must be the tab container")
    local initialize = Native.tabBox(captures)
    assert(type(initialize) == "function", "Native.tabBox did not return its initializer")
    initialize()
    return tabContainer
end

return Tabbox
