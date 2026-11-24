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
            if columnLayout then
                columnFrame.CanvasSize = UDim2.fromOffset(0, columnLayout.AbsoluteContentSize.Y + 8)
            end
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
        function object:SetText(nextText)
            label.Text = tostring(nextText)
            return self
        end
        function object:Remove()
            row:Destroy()
            groupbox:Resize()
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
        local mark = create(library, "Frame", {
            BackgroundColor3 = library.AccentColor,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(3, 3),
            Size = UDim2.fromOffset(8, 8),
            Visible = config.Default == true,
            Parent = box,
        })
        register(library, mark, {BackgroundColor3 = "AccentColor"})
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Toggle", "Toggle", config.Default == true, config.Callback or callback)
        function option:Display()
            mark.Visible = self.Value
            box.BackgroundColor3 = self.Value and library.AccentColor or library.MainColor
            box.BorderColor3 = self.Value and library.AccentColorDark or library.OutlineColor
        end
        local click = create(library, "TextButton", {
            BackgroundTransparency = 1,
            Text = "",
            Size = UDim2.new(1, 0, 1, 0),
            Parent = row,
        })
        click.MouseButton1Click:Connect(function()
            option:SetValue(not option.Value)
            option:Display()
            library:UpdateDependencyBoxes()
        end)
        option:Display()
        function option:Remove()
            row:Destroy()
            library.Toggles[self.Flag] = nil
            groupbox:Resize()
        end
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
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Slider", "Slider", tonumber(config.Default) or min, config.Callback or callback)
        local function display()
            local ratio = max == min and 0 or math.clamp((option.Value - min) / (max - min), 0, 1)
            fill.Size = UDim2.new(ratio, 0, 1, 0)
            local digits = tonumber(config.Decimals) or 0
            valueLabel.Text = string.format("%." .. digits .. "f", option.Value) .. (config.Suffix or "")
        end
        function option:SetValue(nextValue)
            local number = math.clamp(tonumber(nextValue) or min, min, max)
            local step = tonumber(config.Step)
            if step and step > 0 then
                number = min + math.floor((number - min) / step + 0.5) * step
            end
            self.Value = number
            display()
            invoke(library, self.Callback, number)
            invoke(library, self.Changed, number)
            return self
        end
        local dragging = false
        local function update(input)
            local ratio = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            option:SetValue(min + (max - min) * ratio)
        end
        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)
        library.UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        library.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        option:SetValue(option.Value)
        function option:Remove()
            row:Destroy()
            library.Options[self.Flag] = nil
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddDropdown(value, callback)
        local config = type(value) == "table" and value or {Text = value, Values = {}, Default = nil, Callback = callback}
        local row = addRow(23)
        local title = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(0.42, 0, 1, 0),
            Text = config.Text or config.Name or "Dropdown",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local values = config.Values or {}
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Dropdown", "Dropdown", config.Default or values[1], config.Callback or callback)
        local picker = button(library, row, tostring(option.Value or "Select"), UDim2.new(0.56, 0, 1, 0), UDim2.new(0.44, 0, 0, 0))
        local popup = create(library, "Frame", {
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.new(0.44, 0, 1, 2),
            Size = UDim2.new(0.56, 0, 0, 0),
            Visible = false,
            ZIndex = 40,
            Parent = row,
        })
        register(library, popup, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
        local popupLayout = create(library, "UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = popup,
        })
        local function redraw()
            picker.Text = type(option.Value) == "table" and table.concat(option.Value, ", ") or tostring(option.Value or "Select")
        end
        function option:SetValue(nextValue)
            self.Value = nextValue
            redraw()
            invoke(library, self.Callback, nextValue)
            invoke(library, self.Changed, nextValue)
            return self
        end
        for index, item in ipairs(values) do
            local choice = create(library, "TextButton", {
                AutoButtonColor = false,
                BackgroundColor3 = library.MainColor,
                BorderSizePixel = 0,
                Font = library.Font,
                Text = tostring(item),
                TextColor3 = library.FontColor,
                TextSize = 12,
                Size = UDim2.new(1, 0, 0, 20),
                LayoutOrder = index,
                ZIndex = 41,
                Parent = popup,
            })
            choice.MouseButton1Click:Connect(function()
                if config.Multi then
                    local selected = type(option.Value) == "table" and table.clone(option.Value) or {}
                    local found = table.find(selected, item)
                    if found then
                        table.remove(selected, found)
                    else
                        table.insert(selected, item)
                    end
                    option:SetValue(selected)
                else
                    option:SetValue(item)
                    popup.Visible = false
                end
            end)
        end
        popupLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            popup.Size = UDim2.new(1, 0, 0, math.min(popupLayout.AbsoluteContentSize.Y, 120))
        end)
        picker.MouseButton1Click:Connect(function()
            popup.Visible = not popup.Visible
            if popup.Visible then
                popup.Size = UDim2.new(1, 0, 0, math.min(popupLayout.AbsoluteContentSize.Y, 120))
            end
        end)
        redraw()
        function option:Remove()
            popup:Destroy()
            row:Destroy()
            library.Options[self.Flag] = nil
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddColorPicker(value, callback)
        local config = type(value) == "table" and value or {Text = value, Default = Color3.new(1, 1, 1), Callback = callback}
        local row = addRow(22)
        local title = library:CreateLabel({
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
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "Color", "ColorPicker", config.Default or Color3.new(1, 1, 1), config.Callback or callback)
        local palette = {
            Color3.fromRGB(255, 255, 255),
            Color3.fromRGB(162, 205, 255),
            Color3.fromRGB(255, 120, 120),
            Color3.fromRGB(255, 190, 90),
            Color3.fromRGB(140, 230, 160),
            Color3.fromRGB(190, 150, 255),
        }
        local panel = create(library, "Frame", {
            BackgroundColor3 = library.MainColor,
            BorderColor3 = library.OutlineColor,
            BorderSizePixel = 1,
            Position = UDim2.new(1, -154, 1, 2),
            Size = UDim2.fromOffset(150, 30),
            Visible = false,
            ZIndex = 40,
            Parent = row,
        })
        register(library, panel, {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor"})
        for index, color in ipairs(palette) do
            local chip = create(library, "TextButton", {
                AutoButtonColor = false,
                BackgroundColor3 = color,
                BorderColor3 = library.OutlineColor,
                BorderSizePixel = 1,
                Position = UDim2.fromOffset(5 + (index - 1) * 23, 6),
                Size = UDim2.fromOffset(19, 18),
                Text = "",
                ZIndex = 41,
                Parent = panel,
            })
            chip.MouseButton1Click:Connect(function()
                option:SetValue(color)
                panel.Visible = false
            end)
        end
        function option:SetValue(color)
            self.Value = color
            swatch.BackgroundColor3 = color
            invoke(library, self.Callback, color)
            invoke(library, self.Changed, color)
            return self
        end
        function option:SetValueRGB(color)
            return self:SetValue(color)
        end
        swatch.MouseButton1Click:Connect(function()
            panel.Visible = not panel.Visible
        end)
        option:SetValue(option.Value)
        function option:Remove()
            panel:Destroy()
            row:Destroy()
            library.Options[self.Flag] = nil
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddKeyPicker(value, callback)
        local config = type(value) == "table" and value or {Text = value, Default = Enum.KeyCode.Unknown, Callback = callback}
        local row = addRow(22)
        local title = library:CreateLabel({
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(2, 0),
            Size = UDim2.new(1, -82, 1, 0),
            Text = config.Text or config.Name or "Keybind",
            TextColor3 = library.FontColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })
        local keyButton = button(library, row, tostring(config.Default and config.Default.Name or "None"), UDim2.fromOffset(76, 20), UDim2.new(1, -76, 0, 1))
        local option = makeOption(library, groupbox, config.Flag or config.Text or config.Name or "KeyPicker", "KeyPicker", config.Default or Enum.KeyCode.Unknown, config.Callback or callback)
        local listening = false
        keyButton.MouseButton1Click:Connect(function()
            listening = true
            keyButton.Text = "Press key"
        end)
        local connection
        connection = library.UserInputService.InputBegan:Connect(function(input, processed)
            if not listening or processed then
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                option:SetValue(input.KeyCode)
                keyButton.Text = input.KeyCode.Name
                listening = false
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                option:SetValue(input.UserInputType)
                keyButton.Text = input.UserInputType.Name
                listening = false
            end
        end)
        function option:Remove()
            connection:Disconnect()
            row:Destroy()
            library.Options[self.Flag] = nil
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddInput(value, callback)
        local config = type(value) == "table" and value or {Text = value, Default = "", Callback = callback}
        local row = addRow(23)
        local title = library:CreateLabel({
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
        input.FocusLost:Connect(function()
            option:SetValue(input.Text)
        end)
        function option:SetValue(nextValue)
            self.Value = tostring(nextValue or "")
            input.Text = self.Value
            invoke(library, self.Callback, self.Value)
            invoke(library, self.Changed, self.Value)
            return self
        end
        function option:Remove()
            row:Destroy()
            library.Options[self.Flag] = nil
            groupbox:Resize()
        end
        self:Resize()
        return option
    end
    function groupbox:AddTabbox(tabName)
        local frame = create(library, "Frame", {
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
        local tabbox = {Frame = frame, Tabs = {}, Active = nil}
        function tabbox:AddTab(label)
            local tabButton = button(library, tabs, label, UDim2.new(1 / math.max(#self.Tabs + 1, 1), 0, 1, 0), UDim2.new())
            local page = create(library, "Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = body,
            })
            local pageLayout = create(library, "UIListLayout", {Padding = UDim.new(0, 4), Parent = page})
            local child = makeGroupbox(tab, label, side)
            child.Outer.Parent = page
            child.Outer.Size = UDim2.new(1, -2, 0, 38)
            local entry = {Button = tabButton, Page = page, Groupbox = child}
            function entry:Show()
                for _, other in ipairs(tabbox.Tabs) do
                    other.Page.Visible = false
                end
                page.Visible = true
                tabbox.Active = entry
            end
            tabButton.MouseButton1Click:Connect(function()
                entry:Show()
            end)
            table.insert(self.Tabs, entry)
            if not self.Active then
                entry:Show()
            end
            return child
        end
        self:Resize()
        return tabbox
    end
    function groupbox:Remove()
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
        local tab = {
            Name = name,
            Window = self,
            Page = page,
            Button = tabButton,
            Left = left,
            Right = right,
            Groupboxes = {},
        }
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
        local warningTitle = library:CreateLabel({
            Position = UDim2.fromOffset(5, 1),
            Size = UDim2.new(1, -10, 0, 18),
            Text = "",
            TextColor3 = library.AccentColor,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = warningFrame,
        })
        local warningText = library:CreateLabel({
            Position = UDim2.fromOffset(5, 20),
            Size = UDim2.new(1, -10, 0, 0),
            Text = "",
            TextColor3 = library.FontColor,
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = warningFrame,
        })
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
                [7] = tabButton,
                [8] = page,
                [9] = captureSlot("Body", warningText),
                [10] = name,
                [11] = captureSlot("Title", warningTitle),
                [12] = library,
                [13] = indicator,
                [14] = captureSlot("Container", warningFrame),
                [15] = tabStroke,
            }
            local initializeTab = nativeTab(nativeCaptures)
            initializeTab()
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
        local tab = self.Tabs[#self.Tabs]
        assert(tab, "CreateTab must be called first")
        return tab:AddGroupbox({Name = name, Side = side or 1})
    end
    library.ToggleUI = function()
        return window:Toggle()
    end
    return window
end

return Window