local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

local Window = {}
Window.__index = Window

local DEFAULTS = {
    Title = "Rawfare",
    Width = 620,
    Height = 340,
    MinWidth = 420,
    MinHeight = 260,
    Background = Color3.fromRGB(13, 15, 19),
    Surface = Color3.fromRGB(18, 21, 27),
    Raised = Color3.fromRGB(23, 27, 34),
    Border = Color3.fromRGB(43, 49, 59),
    Text = Color3.fromRGB(222, 228, 238),
    Muted = Color3.fromRGB(128, 139, 154),
    Accent = Color3.fromRGB(55, 139, 255)
}

local function make(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function merge(defaults, options)
    local result = {}
    for key, value in pairs(defaults) do
        result[key] = value
    end
    for key, value in pairs(options or {}) do
        result[key] = value
    end
    return result
end

function Window.new(options)
    local self = setmetatable({}, Window)
    self.Options = merge(DEFAULTS, options)
    self.Tabs = {}
    self.SelectedTab = nil
    self.Visible = true
    self.Destroyed = false
    self.Connections = {}

    local player = Players.LocalPlayer
    local guiParent
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then
            guiParent = result
        end
    end
    if not guiParent then
        guiParent = player:WaitForChild("PlayerGui")
    end
    local screen = make("ScreenGui", {
        Name = "RawfareUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 999
    }, guiParent)
    self.Screen = screen

    local root = make("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(self.Options.Width, self.Options.Height),
        BackgroundColor3 = self.Options.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, screen)
    self.Root = root

    make("UIStroke", {
        Color = self.Options.Border,
        Thickness = 1
    }, root)

    local scale = make("UIScale", { Scale = 1 }, root)
    self.Scale = scale

    local title = make("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = self.Options.Surface,
        BorderSizePixel = 0
    }, root)
    self.TitleBar = title

    make("TextLabel", {
        Name = "Title",
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -24, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamSemibold,
        Text = self.Options.Title,
        TextColor3 = self.Options.Text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, title)

    make("Frame", {
        Name = "TitleDivider",
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = self.Options.Border,
        BorderSizePixel = 0
    }, title)

    local tabs = make("Frame", {
        Name = "TabBar",
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = self.Options.Background,
        BorderSizePixel = 0
    }, root)
    self.TabBar = tabs

    local tabLayout = make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, tabs)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 9)
    }, tabs)

    local divider = make("Frame", {
        Position = UDim2.new(0, 0, 0, 69),
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = self.Options.Border,
        BorderSizePixel = 0
    }, root)

    local content = make("Frame", {
        Name = "Content",
        Position = UDim2.fromOffset(10, 80),
        Size = UDim2.new(1, -20, 1, -90),
        BackgroundTransparency = 1
    }, root)
    self.Content = content

    local grip = make("TextButton", {
        Name = "ResizeGrip",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -3, 1, -3),
        Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Text = "◢",
        TextColor3 = self.Options.Accent,
        TextSize = 13,
        Font = Enum.Font.Gotham
    }, root)
    self.ResizeGrip = grip

    local preview = make("Frame", {
        Name = "InteractionOutline",
        Visible = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 20
    }, screen)
    make("UIStroke", {
        Color = self.Options.Accent,
        Thickness = 1
    }, preview)
    self.Preview = preview

    local function viewportChanged()
        local camera = Workspace.CurrentCamera
        if not camera then
            return
        end
        local viewport = camera.ViewportSize
        local availableWidth = math.max(1, viewport.X - 24)
        local availableHeight = math.max(1, viewport.Y - 36)
        local fit = math.min(1, availableWidth / root.Size.X.Offset, availableHeight / root.Size.Y.Offset)
        scale.Scale = fit
        local absoluteSize = root.AbsoluteSize
        local position = root.Position
        local halfX = absoluteSize.X / 2
        local halfY = absoluteSize.Y / 2
        local x = math.clamp(position.X.Offset, halfX + 8, viewport.X - halfX - 8)
        local y = math.clamp(position.Y.Offset, halfY + 8, viewport.Y - halfY - 8)
        root.Position = UDim2.fromOffset(x, y)
    end

    local function beginPreview()
        preview.Position = UDim2.fromOffset(root.AbsolutePosition.X, root.AbsolutePosition.Y)
        preview.Size = UDim2.fromOffset(root.AbsoluteSize.X, root.AbsoluteSize.Y)
        preview.Visible = true
    end

    local function commitPreview()
        preview.Visible = false
    end

    local dragInput
    local dragStart
    local startPosition
    local dragging = false

    title.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragging = true
        dragInput = input
        dragStart = input.Position
        startPosition = root.Position
        beginPreview()
    end)

    local resizeInput
    local resizeStart
    local startSize
    local resizing = false

    grip.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        resizing = true
        resizeInput = input
        resizeStart = input.Position
        startSize = root.Size
        beginPreview()
    end)

    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            local viewport = Workspace.CurrentCamera.ViewportSize
            local half = root.AbsoluteSize / 2
            local x = math.clamp(startPosition.X.Offset + delta.X, half.X + 8, viewport.X - half.X - 8)
            local y = math.clamp(startPosition.Y.Offset + delta.Y, half.Y + 8, viewport.Y - half.Y - 8)
            preview.Position = UDim2.fromOffset(x - half.X, y - half.Y)
        elseif resizing and (input == resizeInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - resizeStart
            local factor = scale.Scale
            local width = math.max(self.Options.MinWidth, startSize.X.Offset + delta.X / factor)
            local height = math.max(self.Options.MinHeight, startSize.Y.Offset + delta.Y / factor)
            preview.Size = UDim2.fromOffset(width * factor, height * factor)
        end
    end))

    table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
            local camera = Workspace.CurrentCamera
            local center = preview.Position + UDim2.fromOffset(preview.AbsoluteSize.X / 2, preview.AbsoluteSize.Y / 2)
            root.Position = center
            dragging = false
            dragInput = nil
            commitPreview()
        elseif resizing and (input == resizeInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
            local factor = scale.Scale
            root.Size = UDim2.fromOffset(
                math.max(self.Options.MinWidth, preview.AbsoluteSize.X / factor),
                math.max(self.Options.MinHeight, preview.AbsoluteSize.Y / factor)
            )
            resizing = false
            resizeInput = nil
            commitPreview()
            viewportChanged()
        end
    end))

    local camera = Workspace.CurrentCamera
    if camera then
        table.insert(self.Connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(viewportChanged))
    end
    viewportChanged()

    self._TabLayout = tabLayout
    self._Divider = divider
    self._ViewportChanged = viewportChanged

    return self
end

function Window:CreateTab(name)
    assert(not self.Destroyed, "Window has been destroyed")
    local tabButton = make("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.fromOffset(76, 34),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = self.Options.Muted,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        AutoButtonColor = false
    }, self.TabBar)

    local page = make("Frame", {
        Name = name .. "Page",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false
    }, self.Content)

    local function createColumn(columnName, position)
        local column = make("ScrollingFrame", {
            Name = columnName,
            Position = position,
            Size = UDim2.new(0.5, -5, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.Options.Accent,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, page)
        make("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        }, column)
        make("UIPadding", {
            PaddingRight = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 4)
        }, column)
        return column
    end

    local left = createColumn("LeftColumn", UDim2.fromOffset(0, 0))
    local right = createColumn("RightColumn", UDim2.new(0.5, 5, 0, 0))
    local tab = {Name = name, Button = tabButton, Page = page, Left = left, Right = right}
    table.insert(self.Tabs, tab)

    tabButton.Activated:Connect(function()
        self:SelectTab(name)
    end)

    if not self.SelectedTab then
        self:SelectTab(name)
    end

    return tab
end

function Window:SelectTab(name)
    for _, tab in ipairs(self.Tabs) do
        local selected = tab.Name == name
        tab.Page.Visible = selected
        tab.Button.TextColor3 = selected and self.Options.Text or self.Options.Muted
        tab.Button.BackgroundColor3 = self.Options.Raised
        tab.Button.BackgroundTransparency = selected and 0 or 1
        if selected then
            self.SelectedTab = name
        end
    end
end

function Window:SetVisible(state)
    if self.Destroyed then
        return
    end
    if state == nil then
        self.Visible = not self.Visible
    else
        self.Visible = state
    end
    self.Screen.Enabled = self.Visible
end

function Window:Toggle()
    self:SetVisible(not self.Visible)
end

function Window:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    for _, connection in ipairs(self.Connections) do
        connection:Disconnect()
    end
    self.Screen:Destroy()
end

return Window
