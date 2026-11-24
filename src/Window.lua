local Window = {}

local function captureSlot(name, value)
    return {[2] = name, [3] = {[name] = value}}
end

local function invoke(library, callback, ...)
    if type(callback) == "function" then
        library:SafeCallback(callback, ...)
    end
end

local function create(library, className, properties)
    return library:Create(className, properties)
end

local function register(library, instance, properties)
    library:AddToRegistry(instance, properties)
    return instance
end

local function button(library, parent, text, size, position)
    local item = create(library, "TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = library.MainColor,
        BorderColor3 = library.OutlineColor,
        BorderSizePixel = 1,
        Font = library.Font,
        Text = text,
        TextColor3 = library.FontColor,
        TextSize = 13,
        TextStrokeTransparency = 0,
        Size = size,
        Position = position or UDim2.new(),
        Parent = parent,
    })
    register(library, item, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "OutlineColor",
        TextColor3 = "FontColor",
    })
    library:OnHighlight(item, item, {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "AccentColor",
    }, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "OutlineColor",
    })
    return item
end

local function makeOption(library, groupbox, name, kind, default, callback)
    local flag = groupbox.Window:Flag(name)
    local option = {
        Name = name,
        Type = kind,
        Value = default,
        Callback = callback,
        Changed = nil,
        Flag = flag,
        Parent = groupbox,
    }
    function option:OnChanged(fn)
        self.Changed = fn
        invoke(library, fn, self.Value)
        return self
    end
    function option:SetValue(value)
        self.Value = value
        invoke(library, self.Callback, value)
        invoke(library, self.Changed, value)
        return self
    end
    if kind == "Toggle" then
        library.Toggles[flag] = option
    else
        library.Options[flag] = option
    end
    return option
end

local function makeGroupbox(tab, name, side)
    local library = tab.Window.Library
    local window = tab.Window
    side = (side == 2 or side == "Right") and 2 or 1
    local column = side == 2 and tab.Right or tab.Left
    local outer = create(library, "Frame", {
        BackgroundColor3 = library.MainColor,
        BorderColor3 = library.OutlineColor,
        BorderSizePixel = 1,
        Size = UDim2.new(1, -2, 0, 38),
        Parent = column,
    })
    register(library, outer, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "OutlineColor",
    })
    local heading = library:CreateLabel({
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(7, 2),
        Size = UDim2.new(1, -14, 0, 19),
        Font = library.Font,
        Text = name or "Group",
        TextColor3 = library.AccentColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = outer,
    })
    register(library, heading, {TextColor3 = "AccentColor"})
    local content = create(library, "Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(6, 23),
        Size = UDim2.new(1, -12, 0, 8),
        Parent = outer,
    })
    local layout = create(library, "UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = content,
    })
    local groupbox = {
        Name = name,
        Outer = outer,
        Inner = content,
        Layout = layout,
        Tab = tab,
        Window = window,
        Side = side,
        Controls = {},
    }
    function groupbox:Resize()
        local height = layout.AbsoluteContentSize.Y
        content.Size = UDim2.new(1, -12, 0, height + 2)
        outer.Size = UDim2.new(1, -2, 0, height + 31)
        for _, columnFrame in ipairs({tab.Left, tab.Right}) do
            local columnLayout = columnFrame:FindFirstChildOfClass("UIListLayout")
            if columnLayout and columnFrame:IsA("ScrollingFrame") then
                columnFrame.CanvasSize = UDim2.fromOffset(0, columnLayout.AbsoluteContentSize.Y + 8)
            end
        end
        if type(tab.ResizePanel) == "function" then
            tab:ResizePanel()
        end
    end
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        groupbox:Resize()
    end)
    local function addRow(height)
        local row = create(library, "Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, height),
            Parent = content,
        })
        table.insert(groupbox.Controls, row)
        return row
    end
    function groupbox:AddBlank(height)
        local row = addRow(height or 6)
        self:Resize()
        return row
    end
    function groupbox:AddDivider()
        local row = addRow(8)
        local line = create(library, "Frame", {
            BackgroundColor3 = library.OutlineColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Parent = row,
        })
        register(library, line, {BackgroundColor3 = "OutlineColor"})
        self:Resize()
        return line
    end
    function groupbox:AddContainer(height)
        local outer = addRow(height or 50)
        outer.BackgroundTransparency = 0
        outer.BackgroundColor3 = library.BackgroundColor
        outer.BorderColor3 = library.OutlineColor
        outer.BorderSizePixel = 1
        register(library, outer, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor"})
        local inner = create(library, "Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(3, 3),
            Size = UDim2.new(1, -6, 1, -6),
            Parent = outer,
        })
        local object = {}
        local containerFactory = library.Native and library.Native.containerSize
        assert(type(containerFactory) == "function", "Native.containerSize factory missing")
        local initialize = containerFactory({
            [0] = inner,
            [1] = outer,
            [2] = groupbox,
            [3] = object,
            [4] = groupbox,
        })
        initialize()
        function object:Create(className, properties)
            properties = properties or {}
            properties.Parent = inner
            return create(library, className, properties)
        end
        function object:Remove()
            outer:Destroy()
            groupbox:Resize()
        end
        groupbox:Resize()
        return object
    end
    function groupbox:AddLabel(value)
        local text = type(value) == "table" and value.Text or value
        local row = addRow(19)
        local label = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(1, -4, 1, 0),
            Text = tostring(text or ""),
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local object = {Label = label, Outer = row}
        local textFactory = library.Native and library.Native.textLabel
        if type(textFactory) == "function" then
            local initialize = textFactory({
                [0] = groupbox,
                [1] = {},
                [2] = library,
                [3] = label,
                [4] = object,
                [5] = false,
            })
            initialize()
            local originalRemove = object.Remove
            function object:Remove()
                if originalRemove then
                    originalRemove(self)
                end
                row:Destroy()
                groupbox:Resize()
            end
        else
            function object:SetText(nextText)
                label.Text = tostring(nextText)
                return self
            end
            function object:Remove()
                row:Destroy()
                groupbox:Resize()
            end
        end
        self:Resize()
        return object
    end
    function groupbox:AddButton(value, callback)
        local config = type(value) == "table" and value or {Text = value, Func = callback}
        local row = addRow(22)
        local action = button(library, row, config.Text or "Button", UDim2.new(1, 0, 1, 0))
        action.MouseButton1Click:Connect(function()
            invoke(library, config.Func or config.Callback)
        end)
        local object = {Outer = row, Button = action}
        function object:Remove()
            row:Destroy()
            groupbox:Resize()
        end
        self:Resize()
        return object
    end
    function groupbox:AddButtonGroup(config)
        config = config or {}
        local row = addRow(20)
        local outer = create(library, "Frame", {
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Size = UDim2.new(1, -2, 1, 0),
            Parent = row,
        })
        local inner = create(library, "Frame", {
            BackgroundColor3 = library.BackgroundColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Size = UDim2.new(1, -4, 1, -4),
            Position = UDim2.fromOffset(2, 2),
            Parent = outer,
        })
        register(library, outer, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
        register(library, inner, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor"})
        local buttonGroup = {
            Outer = outer,
            Inner = inner,
            Tooltip = config.Tooltip,
        }
        function buttonGroup:AddTooltip(value)
            if type(value) == "string" then
                library:AddToolTip(value, self.Outer)
            end
            return self
        end
        local function createButton(configValue)
            local buttonOuter = create(library, "Frame", {
                BackgroundColor3 = library.MainColor,
                BorderColor3 = library.OutlineColor,
                BorderSizePixel = 1,
                Parent = outer,
            })
            local buttonInner = create(library, "Frame", {
                BackgroundColor3 = library.BackgroundColor,
                BorderColor3 = library.OutlineColor,
                BorderSizePixel = 1,
                Position = UDim2.fromOffset(1, 1),
                Size = UDim2.new(1, -2, 1, -2),
                Parent = buttonOuter,
            })
            local label = library:CreateLabel({
                Active = true,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = configValue.Text or "Button",
                TextColor3 = library.FontColor,
                TextSize = 13,
                Parent = buttonInner,
            })
            register(library, buttonOuter, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
            register(library, buttonInner, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor"})
            return buttonOuter, buttonInner, label
        end
        local function bindButton(configValue)
            configValue.Label.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    invoke(library, configValue.Func)
                end
            end)
            library:OnHighlight(configValue.Label, configValue.Label, {
                TextColor3 = "AccentColor",
                BorderColor3 = "AccentColor",
            }, {
                TextColor3 = "FontColor",
                BorderColor3 = "OutlineColor",
            })
        end
        local initialize = library.Native.buttons({
            [0] = bindButton,
            [1] = buttonGroup,
            [2] = groupbox,
            [3] = createButton,
            [4] = library,
        })
        initialize()
        local nativeRemove = buttonGroup.Remove
        function buttonGroup:Remove()
            nativeRemove(self)
            if row.Parent then
                row:Destroy()
            end
            groupbox:Resize()
        end
        self:Resize()
        return buttonGroup
    end
    function groupbox:AddToggle(value, callback)
        local config = type(value) == "table" and value or {Text = value, Default = false, Callback = callback}
        local row = addRow(21)
        local nameLabel = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(1, -26, 1, 0),
            Text = config.Text or config.Name or "Toggle",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local box = create(library, "Frame", {
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.new(1, -18, 0.5, -7),
            Size = UDim2.fromOffset(14, 14),
            Parent = row,
        })
        register(library, box, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
        local click = create(library, "TextButton", {
            BackgroundTransparency = 1,
            Text = "",
            Size = UDim2.new(1, 0, 1, 0),
            Parent = row,
        })
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Toggle", "Toggle", config.Default == true, config.Callback or callback)
        option.Idx = option.Flag
        option.ChangedFuncs = {}
        option.Addons = {}
        option.SettingValue = false
        option.Visible = true
        option.Risky = config.Risky == true
        local borderSlot = captureSlot("OutlineColor", library.OutlineColor)
        borderSlot[3] = setmetatable({}, {
            __index = function(_, key)
                return library[key]
            end,
        })
        local toggleFactory = library.Native and library.Native.toggle
        assert(type(toggleFactory) == "function", "Native.toggle factory missing")
        local initialize = toggleFactory({
            [0] = option,
            [1] = groupbox,
            [2] = box,
            [3] = library,
            [4] = row,
            [5] = option.Flag,
            [6] = row,
            [7] = {},
            [8] = nameLabel,
            [9] = library.Toggles,
            [10] = click,
            [11] = {BlankSize = 0},
            [12] = content,
            [13] = borderSlot,
            [14] = {},
        })
        initialize()
        self:Resize()
        return option
    end
    function groupbox:AddSlider(value, callback)
        local config = type(value) == "table" and value or {Text = value, Min = 0, Max = 100, Default = 0, Callback = callback}
        local min = tonumber(config.Min) or 0
        local max = tonumber(config.Max) or 100
        local row = addRow(34)
        local title = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(0.72, 0, 0, 16),
            Text = config.Text or config.Name or "Slider",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local valueLabel = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.new(0.72, 0, 0, 0),
            Size = UDim2.new(0.28, -2, 0, 16),
            Text = "",
            TextColor3 = library.AccentColor,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = row,
        })
        register(library, valueLabel, {TextColor3 = "AccentColor"})
        local track = create(library, "Frame", {
            Active = true,
            BackgroundColor3 = library.OutlineColor,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(2, 21),
            Size = UDim2.new(1, -4, 0, 7),
            Parent = row,
        })
        register(library, track, {BackgroundColor3 = "OutlineColor"})
        local fill = create(library, "Frame", {
            BackgroundColor3 = library.AccentColor,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 0, 1, 0),
            Parent = track,
        })
        register(library, fill, {BackgroundColor3 = "AccentColor"})
        local thumb = create(library, "Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = library.AccentColor,
            BorderColor3 = library.AccentColorDark,
            BorderSizePixel = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(7, 7),
            Visible = false,
            ZIndex = 3,
            Parent = track,
        })
        register(library, thumb, {BackgroundColor3 = "AccentColor", BorderColor3 = "AccentColorDark"})
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Slider", "Slider", tonumber(config.Default) or min, config.Callback or callback)
        option.Min = min
        option.Max = max
        option.MaxSize = math.max(track.AbsoluteSize.X, 1)
        option.Increment = tonumber(config.Step or config.Increment)
        option.Rounding = tonumber(config.Decimals) or 0
        option.Idx = option.Flag
        option.ChangedFuncs = {}
        option.HolderFrame = row
        option.SettingValue = false
        option.Visible = true
        local tweenSlot = captureSlot("Tween", nil)
        local sliderFactory = library.Native and library.Native.slider
        assert(type(sliderFactory) == "function", "Native.slider factory missing")
        local initialize = sliderFactory({
            [0] = groupbox,
            [1] = option,
            [2] = true,
            [3] = fill,
            [4] = {
                Min = min,
                Max = max,
                Suffix = config.Suffix or "",
                Compact = config.Compact == true,
                HideMax = config.HideMax == true,
                BlankSize = 0,
            },
            [5] = tweenSlot,
            [6] = library.Mouse,
            [7] = library,
            [8] = thumb,
            [9] = library.TweenService,
            [10] = valueLabel,
            [11] = groupbox,
            [12] = track,
            [13] = option.Flag,
            [14] = library.Options,
            [15] = {title, valueLabel, track},
            [16] = library.UserInputService,
            [17] = library.RunService.RenderStepped,
        })
        initialize()
        local originalDisplay = option.Display
        function option:Display()
            originalDisplay(self)
            local ratio = library:MapValue(self.Value, self.Min, self.Max, 0, 1)
            thumb.Position = UDim2.new(ratio, 0, 0.5, 0)
            library:UpdateDependencyBoxes()
        end
        local function updateMaxSize()
            option.MaxSize = math.max(track.AbsoluteSize.X, 1)
            option:Display()
        end
        track:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateMaxSize)
        updateMaxSize()
        option:SetValue(option.Value)
        self:Resize()
        return option
    end
    function groupbox:AddDropdown(value, callback)
        local config = type(value) == "table" and value or {Text = value, Values = {}, Default = nil, Callback = callback}
        local row = addRow(23)
        library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(0.42, 0, 1, 0),
            Text = config.Text or config.Name or "Dropdown",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local anchor = create(library, "Frame", {
            Active = true,
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.new(0.44, 0, 0, 1),
            Size = UDim2.new(0.56, 0, 1, -2),
            Parent = row,
        })
        register(library, anchor, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
        local valueLabel = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 0),
            Size = UDim2.new(1, -22, 1, 0),
            Text = "",
            TextColor3 = library.FontColor,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = anchor,
        })
        local arrow = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -18, 0, 0),
            Size = UDim2.fromOffset(16, 20),
            Text = ">",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = anchor,
        })
        local popup = create(library, "Frame", {
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Visible = false,
            ZIndex = 20,
            Parent = library.ScreenGui,
        })
        register(library, popup, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
        local outsideEvent = Instance.new("BindableEvent")
        local outsideConnection = library.UserInputService.InputBegan:Connect(function(input)
            if popup.Visible then
                outsideEvent:Fire(input)
            end
        end)
        local values = config.Values or {}
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Dropdown", "Dropdown", config.Multi and {} or config.Default or values[1], config.Callback or callback)
        option.Values = values
        option.Multi = config.Multi == true
        option.AllowNull = config.AllowNull == true
        option.Illegal = config.Illegal == true
        option.Idx = option.Flag
        local borderSlot = captureSlot("OutlineColor", library.OutlineColor)
        borderSlot[3] = setmetatable({}, {
            __index = function(_, key)
                return library[key]
            end,
        })
        local dropdownFactory = library.Native and library.Native.dropdown
        assert(type(dropdownFactory) == "function", "Native.dropdown factory missing")
        local initialize = dropdownFactory({
            [0] = option,
            [1] = library,
            [2] = popup,
            [3] = {
                Multi = option.Multi,
                Default = config.Default,
                AllowNull = option.AllowNull,
                Illegal = option.Illegal,
                BlankSize = 0,
            },
            [4] = borderSlot,
            [5] = groupbox,
            [6] = library.Options,
            [7] = tonumber(config.MaxVisibleRows) or 6,
            [8] = anchor,
            [9] = library.Mouse,
            [10] = arrow,
            [11] = valueLabel,
            [12] = option.Flag,
            [13] = {popup},
            [14] = {InputBegan = outsideEvent.Event},
            [15] = captureSlot("Frame", "Frame"),
        })
        initialize()
        local nativeSetValue = option.SetValue
        function option:SetValue(nextValue)
            nativeSetValue(self, nextValue)
            library:UpdateDependencyBoxes()
            return self
        end
        local nativeRemove = option.Remove
        function option:Remove()
            nativeRemove(self)
            outsideConnection:Disconnect()
            outsideEvent:Destroy()
            if row.Parent then
                row:Destroy()
            end
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddColorPicker(value, callback)
        local config = type(value) == "table" and value or {Text = value, Default = Color3.new(1, 1, 1), Callback = callback}
        local row = addRow(22)
        library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(1, -34, 1, 0),
            Text = config.Text or config.Name or "Color",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local swatch = create(library, "TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = config.Default or Color3.new(1, 1, 1),
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.new(1, -29, 0, 3),
            Size = UDim2.fromOffset(27, 16),
            Text = "",
            Parent = row,
        })
        register(library, swatch, {BorderColor3 = "OutlineColor"})
        local popup = create(library, "Frame", {
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(208, 178),
            Visible = false,
            ZIndex = 40,
            Parent = library.ScreenGui,
        })
        local inner = create(library, "Frame", {
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(3, 3),
            Size = UDim2.new(1, -6, 1, -6),
            ZIndex = 40,
            Parent = popup,
        })
        local sv = create(library, "Frame", {
            Active = true,
            BackgroundColor3 = config.Default or Color3.new(1, 1, 1),
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(6, 6),
            Size = UDim2.fromOffset(138, 108),
            ZIndex = 41,
            Parent = inner,
        })
        local whiteLayer = create(library, "Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 42,
            Parent = sv,
        })
        create(library, "UIGradient", {
            Rotation = 0,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = whiteLayer,
        })
        local blackLayer = create(library, "Frame", {
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 43,
            Parent = sv,
        })
        create(library, "UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
            Parent = blackLayer,
        })
        local svHandle = create(library, "Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 1,
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromOffset(8, 8),
            ZIndex = 44,
            Parent = sv,
        })
        local hue = create(library, "Frame", {
            Active = true,
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(151, 6),
            Size = UDim2.fromOffset(14, 108),
            ZIndex = 41,
            Parent = inner,
        })
        local hueHandle = create(library, "Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 1,
            Position = UDim2.new(0, -2, 0, 0),
            Size = UDim2.new(1, 4, 0, 3),
            ZIndex = 44,
            Parent = hue,
        })
        local alphaBar = create(library, "Frame", {
            Active = true,
            BackgroundColor3 = config.Default or Color3.new(1, 1, 1),
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(6, 121),
            Size = UDim2.fromOffset(159, 8),
            ZIndex = 41,
            Parent = inner,
        })
        create(library, "UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = alphaBar,
        })
        local alphaHandle = create(library, "Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 1,
            Position = UDim2.new(1, -2, 0, -3),
            Size = UDim2.fromOffset(4, 14),
            ZIndex = 44,
            Parent = alphaBar,
        })
        local rgbInput = create(library, "TextBox", {
            BackgroundColor3 = library.BackgroundColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            ClearTextOnFocus = false,
            Font = library.Font,
            Position = UDim2.fromOffset(6, 139),
            Size = UDim2.fromOffset(92, 20),
            Text = "",
            TextColor3 = library.FontColor,
            TextSize = 11,
            ZIndex = 42,
            Parent = inner,
        })
        local hexInput = create(library, "TextBox", {
            BackgroundColor3 = library.BackgroundColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            ClearTextOnFocus = false,
            Font = library.Font,
            Position = UDim2.fromOffset(103, 139),
            Size = UDim2.fromOffset(62, 20),
            Text = "",
            TextColor3 = library.FontColor,
            TextSize = 11,
            ZIndex = 42,
            Parent = inner,
        })
        register(library, rgbInput, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor", TextColor3 = "FontColor"})
        register(library, hexInput, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor", TextColor3 = "FontColor"})
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Color", "ColorPicker", config.Default or Color3.new(1, 1, 1), config.Callback or callback)
        option.Transparency = tonumber(config.Transparency) or 0
        option.Hue, option.Sat, option.Vib = Color3.toHSV(option.Value)
        option.Addons = groupbox.Addons or {}
        groupbox.Addons = option.Addons
        groupbox.ColorPickerCount = groupbox.ColorPickerCount or 0
        function option:SetHSVFromRGB(color)
            self.Hue, self.Sat, self.Vib = Color3.toHSV(color)
        end
        local outlineSlot = captureSlot("OutlineColor", library.OutlineColor)
        outlineSlot[3] = setmetatable({}, {
            __index = function(_, key)
                return library[key]
            end,
        })
        local alphaSlot = captureSlot("Frame", alphaBar)
        local alphaThumbSlot = captureSlot("Thumb", alphaHandle)
        local colorFactory = library.Native and library.Native.colorPicker
        assert(type(colorFactory) == "function", "Native.colorPicker factory missing")
        local initialize = colorFactory({
            [0] = option,
            [1] = library.RunService.RenderStepped,
            [2] = outlineSlot,
            [3] = library,
            [4] = groupbox,
            [5] = library.Mouse,
            [6] = rgbInput,
            [7] = hexInput,
            [8] = library.Options,
            [9] = svHandle,
            [10] = popup,
            [11] = hue,
            [12] = sv,
            [13] = whiteLayer,
            [14] = alphaSlot,
            [15] = swatch,
            [16] = hueHandle,
            [17] = library.UserInputService,
            [18] = groupbox,
            [19] = option.Flag,
            [20] = inner,
            [21] = blackLayer,
            [22] = hueHandle,
            [23] = alphaThumbSlot,
            [24] = {Frame = alphaBar},
        })
        initialize()
        local alphaEntry = library.RegistryMap[alphaBar]
        alphaEntry.Properties.BackgroundColor3 = function()
            return option.Value
        end
        local updatePosition = function()
            popup.Position = UDim2.fromOffset(swatch.AbsolutePosition.X - popup.AbsoluteSize.X + swatch.AbsoluteSize.X, swatch.AbsolutePosition.Y + swatch.AbsoluteSize.Y + 2)
        end
        swatch:GetPropertyChangedSignal("AbsolutePosition"):Connect(updatePosition)
        updatePosition()
        local originalDisplay = option.Display
        function option:Display()
            originalDisplay(self)
            library:UpdateDependencyBoxes()
        end
        local nativeRemove = option.Remove
        function option:Remove()
            nativeRemove(self)
            for index = #groupbox.Addons, 1, -1 do
                if groupbox.Addons[index] == self then
                    table.remove(groupbox.Addons, index)
                end
            end
            if popup.Parent then
                popup:Destroy()
            end
            if row.Parent then
                row:Destroy()
            end
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddKeyPicker(value, callback)
        local config = type(value) == "table" and value or {Text = value, Default = Enum.KeyCode.Unknown, Callback = callback}
        local row = addRow(22)
        library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(1, -82, 1, 0),
            Text = config.Text or config.Name or "Keybind",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local keyButton = button(library, row, "", UDim2.fromOffset(76, 20), UDim2.new(1, -76, 0, 1))
        keyButton.Text = ""
        local keyText = library:CreateLabel({
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextColor3 = library.FontColor,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = keyButton,
        })
        local modePicker = create(library, "Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(1, 1),
            Visible = false,
            Parent = row,
        })
        local keybindLabel = library:CreateLabel({
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = false,
            Parent = library.KeybindContainer,
        })
        local default = config.Default or Enum.KeyCode.Unknown
        local defaultValue = tostring(default)
        if typeof(default) == "EnumItem" then
            if default == Enum.UserInputType.MouseButton1 then
                defaultValue = "MB1"
            elseif default == Enum.UserInputType.MouseButton2 then
                defaultValue = "MB2"
            else
                defaultValue = default.Name
            end
        end
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "KeyPicker", "KeyPicker", defaultValue, config.Callback or callback)
        option.Value = defaultValue
        option.Mode = config.Mode or "Toggle"
        option.Toggled = false
        option.Override = false
        option.NoUI = config.NoUI == true
        option.SyncToggleState = config.SyncToggleState == true
        option.ChangedCallback = config.ChangedCallback
        option.Connections = {}
        option.Idx = option.Flag
        option.Parent = {Addons = {}, Type = "KeyPicker"}
        local keypickerFactory = library.Native and library.Native.keyPicker
        assert(type(keypickerFactory) == "function", "Native.keyPicker factory missing")
        local initialize = keypickerFactory({
            [0] = option,
            [1] = library.UserInputService,
            [2] = keyButton,
            [3] = {
                Text = config.Text or config.Name or "Keybind",
                Modes = config.Modes or {"Always", "Toggle", "Hold"},
            },
            [4] = library,
            [5] = keybindLabel,
            [6] = option.Flag,
            [7] = keyText,
            [8] = option.Parent,
            [9] = modePicker,
            [10] = library.Options,
        })
        initialize()
        local nativeSetValue = option.SetValue
        function option:SetValue(nextValue)
            nativeSetValue(self, nextValue)
            library:UpdateDependencyBoxes()
            return self
        end
        local nativeRemove = option.Remove
        function option:Remove()
            nativeRemove(self)
            if row.Parent then
                row:Destroy()
            end
            if modePicker.Parent then
                modePicker:Destroy()
            end
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddInput(value, callback)
        local config = type(value) == "table" and value or {Text = value, Default = "", Callback = callback}
        local row = addRow(23)
        library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(0.42, 0, 1, 0),
            Text = config.Text or config.Name or "Input",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local input = create(library, "TextBox", {
            BackgroundColor3 = library.BackgroundColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            ClearTextOnFocus = false,
            Font = library.Font,
            Position = UDim2.new(0.43, 0, 0, 1),
            Size = UDim2.new(0.57, 0, 1, -2),
            Text = tostring(config.Default or ""),
            TextColor3 = library.FontColor,
            TextSize = 12,
            Parent = row,
        })
        register(library, input, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor", TextColor3 = "FontColor"})
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Input", "Input", input.Text, config.Callback or callback)
        local valueFactory = library.Native and library.Native.valueCallbacks
        if type(valueFactory) == "function" then
            local initialize = valueFactory({
                [0] = option,
                [1] = input,
                [2] = {
                    MaxLength = config.MaxLength,
                    Numeric = config.Numeric,
                    Finished = config.Finished ~= false,
                },
                [3] = library.Options,
                [4] = library,
                [5] = option.Flag,
                [6] = groupbox,
                [7] = {},
                [8] = library.TextService,
                [9] = row,
                [10] = row,
            })
            initialize()
            local nativeSetValue = option.SetValue
            function option:SetValue(nextValue)
                nativeSetValue(self, nextValue)
                library:UpdateDependencyBoxes()
                return self
            end
        else
            input.FocusLost:Connect(function()
                option:SetValue(input.Text)
            end)
            function option:SetValue(nextValue)
                self.Value = tostring(nextValue or "")
                input.Text = self.Value
                invoke(library, self.Callback, self.Value)
                invoke(library, self.Changed, self.Value)
                library:UpdateDependencyBoxes()
                return self
            end
        end
        self:Resize()
        return option
    end
    function groupbox:AddDependency(dependencies, name)
        local container = create(library, "Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = false,
            Parent = content,
        })
        local dependencyLayout = create(library, "UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            Parent = container,
        })
        local dependency = {}
        local dependencyFactory = library.Native and library.Native.dependencies
        assert(type(dependencyFactory) == "function", "Native.dependencies factory missing")
        local initialize = dependencyFactory({
            [0] = library,
            [1] = dependency,
            [2] = {},
            [3] = container,
            [4] = groupbox,
            [5] = container,
            [6] = dependencyLayout,
        })
        initialize()
        local adapter = {
            Window = window,
            Left = container,
            Right = container,
            ResizePanel = function()
                groupbox:Resize()
            end,
        }
        dependency.Groupbox = makeGroupbox(adapter, name or "Dependent controls", 1)
        dependency.Groupbox.Outer.Parent = container
        for _, method in ipairs({
            "AddToggle",
            "AddSlider",
            "AddDropdown",
            "AddColorPicker",
            "AddKeyPicker",
            "AddInput",
            "AddButton",
            "AddLabel",
            "AddDivider",
            "AddBlank",
        }) do
            local methodName = method
            dependency[methodName] = function(self, ...)
                return self.Groupbox[methodName](self.Groupbox, ...)
            end
        end
        dependency:SetupDependencies(dependencies or {})
        groupbox:Resize()
        return dependency
    end
    function groupbox:AddTabbox(tabName)
        local frame = create(library, "Frame", {
            Name = tostring(tab.Name or tab.Window.Library.ActiveTab or "Tab") .. "_" .. tostring(tabName or "Tabbox"),
            BackgroundColor3 = library.BackgroundColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Size = UDim2.new(1, 0, 0, 44),
            Parent = content,
        })
        register(library, frame, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor"})
        local tabs = create(library, "Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = frame,
        })
        local body = create(library, "Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(4, 22),
            Size = UDim2.new(1, -8, 1, -24),
            Parent = frame,
        })
        local tabContainer = {Tabs = {}}
        local panelMeta = {__index = {}}
        function panelMeta.__index:AddBlank(height)
            local blank = create(library, "Frame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, tonumber(height) or 3),
                Parent = self.Container,
            })
            self:Resize()
            return blank
        end
        local nativeTabbox = library.Native and library.Native.tabBox
        assert(type(nativeTabbox) == "function", "Native.tabBox factory missing")
        local borderSlot = captureSlot("OutlineColor", library.OutlineColor)
        borderSlot[3] = setmetatable({}, {
            __index = function(_, key)
                return library[key]
            end,
        })
        local initialize = nativeTabbox({
            [0] = library,
            [1] = captureSlot("Frame", "Frame"),
            [2] = tabs,
            [3] = tabContainer,
            [4] = frame,
            [5] = panelMeta,
            [6] = frame,
            [7] = body,
            [8] = library,
            [9] = borderSlot,
        })
        initialize()
        local originalRemoveTabbox = tabContainer.Remove
        function tabContainer:Remove()
            originalRemoveTabbox(self)
            groupbox.Tabbox = nil
            groupbox:Resize()
        end
        groupbox.Tabbox = tabContainer
        local originalAddTab = tabContainer.AddTab
        function tabContainer:AddTab(label, selected)
            local panel = originalAddTab(self, label, selected)
            local adapter = {
                Window = window,
                Left = panel.Container,
                Right = panel.Container,
                ResizePanel = function()
                    panel:Resize()
                end,
            }
            panel.Groupbox = makeGroupbox(adapter, label, 1)
            panel.Groupbox.Outer.Parent = panel.Container
            panel:Resize()
            for _, method in ipairs({
                "AddToggle",
                "AddSlider",
                "AddDropdown",
                "AddColorPicker",
                "AddKeyPicker",
                "AddInput",
                "AddButton",
                "AddLabel",
                "AddDivider",
                "AddBlank",
            }) do
                local methodName = method
                panelMeta.__index[methodName] = panelMeta.__index[methodName] or function(self, ...)
                    return self.Groupbox[methodName](self.Groupbox, ...)
                end
            end
            return panel
        end
        self:Resize()
        return tabContainer
    end
    function groupbox:Remove()
        if self.Tabbox and self.Tabbox.Remove then
            self.Tabbox:Remove()
        end
        outer:Destroy()
        self:Resize()
    end
    groupbox:Resize()
    return groupbox
end

function Window.attach(library, settings)
    settings = settings or {}
    local userInput = library.UserInputService
    local width = math.clamp(tonumber(settings.Width) or 320, 280, 620)
    local height = math.clamp(tonumber(settings.Height) or 230, 180, 520)
    local root = create(library, "Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = library.MainColor,
        BorderColor3 = library.OutlineColor,
        BorderSizePixel = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(width, height),
        Parent = library.ScreenGui,
    })
    register(library, root, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
    local topbar = create(library, "Frame", {
        BackgroundColor3 = library.MainColor,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 26),
        Parent = root,
    })
    register(library, topbar, {BackgroundColor3 = "MainColor"})
    local title = library:CreateLabel({
        Position = UDim2.fromOffset(8, 0),
        Size = UDim2.new(1, -42, 1, 0),
        Font = library.Font,
        Text = settings.Title or library.Unnamed or "UI Reborn Enhancement",
        TextColor3 = library.FontColor,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topbar,
    })
    local window
    local close = create(library, "TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = library.MainColor,
        BorderSizePixel = 0,
        Font = library.Font,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.fromOffset(25, 25),
        Text = "x",
        TextColor3 = library.FontColor,
        TextSize = 14,
        Parent = topbar,
    })
    register(library, close, {BackgroundColor3 = "MainColor", TextColor3 = "FontColor"})
    close.MouseButton1Click:Connect(function()
        if window then
            window:SetVisible(false)
        else
            library.ScreenGui.Enabled = false
        end
    end)
    local tabBar = create(library, "Frame", {
        BackgroundColor3 = library.BackgroundColor,
        BorderColor3 = library.OutlineColor,
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(7, 29),
        Size = UDim2.new(1, -14, 0, 25),
        Parent = root,
    })
    register(library, tabBar, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor"})
    local tabLayout = create(library, "UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabBar,
    })
    local content = create(library, "Frame", {
        BackgroundColor3 = library.BackgroundColor,
        BorderColor3 = library.OutlineColor,
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(7, 59),
        Size = UDim2.new(1, -14, 1, -66),
        Parent = root,
    })
    register(library, content, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor"})
    window = {
        Library = library,
        Root = root,
        Topbar = topbar,
        Content = content,
        TabBar = tabBar,
        Tabs = {},
        Flags = {},
    }
    function window:Flag(name)
        local key = tostring(name or "Option"):gsub("%s+", "_")
        local count = (self.Flags[key] or 0) + 1
        self.Flags[key] = count
        return count == 1 and key or key .. "_" .. tostring(count)
    end
    function window:SetVisible(visible)
        visible = visible == true
        library.ScreenGui.Enabled = visible
        for _, gui in ipairs(library.PopoutGuis or {}) do
            if gui and gui.Parent then
                gui.Enabled = visible
            end
        end
        if library.Captures and library.Captures[7] then
            local slot = library.Captures[7]
            slot[3][slot[2]] = visible
        end
        if library.CaptureState then
            library.CaptureState.Visible = visible
        end
        pcall(library.FireEvent, library, "VisibilityChanged", visible)
        return self
    end
    function window:Toggle()
        return self:SetVisible(not library.ScreenGui.Enabled)
    end
    function window:SetTitle(value)
        title.Text = tostring(value or "")
        return self
    end
    function window:SetSize(nextWidth, nextHeight)
        local current = root.Size
        local nextW = math.clamp(tonumber(nextWidth) or current.X.Offset, 280, 620)
        local nextH = math.clamp(tonumber(nextHeight) or current.Y.Offset, 180, 520)
        root.Size = UDim2.fromOffset(nextW, nextH)
        return self
    end
    function window:GetSize()
        return root.AbsoluteSize
    end
    function window:SetPosition(position)
        assert(typeof(position) == "UDim2", "SetPosition expects UDim2")
        root.Position = position
        return self
    end
    function window:GetPosition()
        return root.Position
    end
    function window:Unload()
        library:Unload()
    end
    function window:CreateTab(name)
        local page = create(library, "Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 5),
            Size = UDim2.new(1, -10, 1, -10),
            Visible = #self.Tabs == 0,
            Parent = content,
        })
        local left = create(library, "ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0.5, -5, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = library.AccentColor,
            CanvasSize = UDim2.new(),
            Parent = page,
        })
        local right = create(library, "ScrollingFrame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 5, 0, 0),
            Size = UDim2.new(0.5, -5, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = library.AccentColor,
            CanvasSize = UDim2.new(),
            Parent = page,
        })
        local leftLayout = create(library, "UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = left})
        local rightLayout = create(library, "UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = right})
        leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            left.CanvasSize = UDim2.fromOffset(0, leftLayout.AbsoluteContentSize.Y + 8)
        end)
        rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            right.CanvasSize = UDim2.fromOffset(0, rightLayout.AbsoluteContentSize.Y + 8)
        end)
        local tabButton = button(library, tabBar, name, UDim2.new(0, 72, 1, 0))
        tabButton.Text = ""
        local tabText = library:CreateLabel({
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = name,
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = tabButton,
        })
        register(library, tabText, {TextColor3 = "FontColor"})
        local indicator = create(library, "Frame", {
            BackgroundColor3 = library.AccentColor,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2),
            Visible = false,
            Parent = tabButton,
        })
        register(library, indicator, {BackgroundColor3 = "AccentColor"})
        local tabStroke = create(library, "UIStroke", {
            Color = Color3.fromRGB(0, 0, 0),
            Parent = tabButton,
        })
        local warningFrame = create(library, "Frame", {
            BackgroundColor3 = library.BackgroundColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.fromOffset(7, 7),
            Size = UDim2.new(1, -14, 0, 0),
            Visible = false,
            Parent = page,
        })
        local warningContent = create(library, "Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 1),
            Size = UDim2.new(1, -10, 1, -2),
            Parent = warningFrame,
        })
        local warningTitle = library:CreateLabel({
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            TextColor3 = library.AccentColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = warningContent,
        })
        local warningText = library:CreateLabel({
            Position = UDim2.fromOffset(0, 19),
            Size = UDim2.new(1, 0, 0, 0),
            Text = "",
            TextColor3 = library.FontColor,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = warningContent,
        })
        register(library, warningFrame, {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor"})
        register(library, warningTitle, {TextColor3 = "AccentColor"})
        local tab = {
            Name = name,
            Window = self,
            Page = page,
            Button = tabButton,
            Left = left,
            Right = right,
            Groupboxes = {},
        }
        function tab:AddGroupbox(config)
            local boxName = type(config) == "table" and config.Name or config
            local side = type(config) == "table" and config.Side or 1
            local groupbox = makeGroupbox(self, boxName, side)
            table.insert(self.Groupboxes, groupbox)
            return groupbox
        end
        function tab:AddTabbox(config)
            local boxName = type(config) == "table" and config.Name or config
            local side = type(config) == "table" and config.Side or 1
            local groupbox = self:AddGroupbox({Name = boxName or "Tabs", Side = side})
            return groupbox:AddTabbox(boxName)
        end
        function tab:AddSection(config)
            return self:AddGroupbox(config)
        end
        table.insert(self.Tabs, tab)
        library.TabOrder = self.Tabs
        local nativeTab = library.Native and library.Native.tab
        if type(nativeTab) == "function" then
            local nativeCaptures = {
                [0] = library,
                [1] = library,
                [2] = tab,
                [3] = left,
                [4] = captureSlot("Warning", warningFrame),
                [5] = right,
                [6] = tabButton,
                [7] = tabText,
                [8] = page,
                [9] = captureSlot("Body", warningText),
                [10] = name,
                [11] = captureSlot("Title", warningTitle),
                [12] = library,
                [13] = indicator,
                [14] = captureSlot("Container", warningContent),
                [15] = tabStroke,
            }
            local initializeTab = nativeTab(nativeCaptures)
            initializeTab()
            local tabTextEntry = library.RegistryMap[tabText]
            tabTextEntry.Properties.TextColor3 = function()
                return library.ActiveTab == name and library.FontColor or library:GetDarkerColor(library.FontColor)
            end
            local nativeRemove = tab.Remove
            function tab:Remove()
                local wasActive = library.ActiveTab == name
                local index = table.find(window.Tabs, self)
                nativeRemove(self)
                if page.Parent then
                    page:Destroy()
                end
                if index then
                    table.remove(window.Tabs, index)
                end
                library.TabOrder = window.Tabs
                library.TotalTabs = #window.Tabs
                library:ApplyLayout()
                if wasActive and #window.Tabs > 0 then
                    window.Tabs[math.clamp(index or 1, 1, #window.Tabs)]:ShowTab()
                end
            end
        end
        tabButton.MouseButton1Click:Connect(function()
            tab:ShowTab()
        end)
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            local count = math.max(#window.Tabs, 1)
            for index, entry in ipairs(window.Tabs) do
                entry.Button.Size = UDim2.new(1 / count, 0, 1, 0)
                entry.Button.LayoutOrder = index
            end
        end)
        return tab
    end
    function window:AddTab(name)
        return self:CreateTab(name)
    end
    if library.MakeDraggableOutline then
        library:MakeDraggableOutline(root, 26, true)
    end
    if library.MakeResizable then
        library:MakeResizable(root, Vector2.new(280, 180))
    end
    local toggleKey = settings.ToggleKey or Enum.KeyCode.RightControl
    local toggleConnection = userInput.InputBegan:Connect(function(input, processed)
        if not processed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleKey then
            window:Toggle()
        end
    end)
    library:GiveSignal(toggleConnection)
    library.Window = window
    library.CreateWindow = function(self, config)
        if self.Window and self.Window.Root and self.Window.Root.Parent then
            return self.Window
        end
        return Window.attach(self, config)
    end
    library.CreateTab = function(self, name)
        assert(self.Window, "CreateWindow must be called first")
        return self.Window:CreateTab(name)
    end
    window.AddSection = function(self, name, side)
        local tab
        for _, candidate in ipairs(self.Tabs) do
            if candidate.Name == library.ActiveTab then
                tab = candidate
                break
            end
        end
        tab = tab or self.Tabs[#self.Tabs]
        assert(tab, "CreateTab must be called first")
        return tab:AddGroupbox({Name = name, Side = side or 1})
    end
    library.AddSection = function(self, name, side)
        assert(self.Window, "CreateWindow must be called first")
        return self.Window:AddSection(name, side)
    end
    library.ToggleUI = function()
        return window:Toggle()
    end
    return window
end

return Window