local Tab = {}

local REQUIRED = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}

function Tab.attach(Native, captures)
    assert(type(Native) == "table" and type(Native.tab) == "function", "Native.tab factory missing")
    assert(type(captures) == "table", "Native.tab captures must be a table")
    for _, index in ipairs(REQUIRED) do
        assert(captures[index] ~= nil, ("Native.tab capture %d is missing"):format(index))
    end
    local tab = captures[2]
    assert(type(tab) == "table", "Native.tab capture 2 must be the tab object")
    local initialize = Native.tab(captures)
    assert(type(initialize) == "function", "Native.tab did not return its initializer")
    initialize()
    return tab
end

return Tab
