--[[
====================================================================
 Rivals UE - "Unnamed Enhancements" UI Library
 Fully readable / reusable extract - zero encoded strings
====================================================================

 WHAT THIS IS
   The complete Linoria-style UI library used by "Unnamed Enhancements"
   (Rivals UE), recovered from the obfuscated loader in plain Lua.

 MODULES (all factories taking a `captures` table; captures[0] = the
 library's Create method, other slots = services/globals):
   Native.library        core: Create(), ScreenGui, window, resizing, notifications
   Native.configuration  config manager (save/load/delete configs)
   Native.themes         theme manager + 13 built-in palettes
   Native.keyPicker      keybind picker element
   Native.toggle / slider / dropdown / colorPicker / tabBox / tab
   Native.buttons / textLabel / containerSize
   Native.drawing        Drawing-API rendering helpers
   Native.dependencies   shared service dependencies
   Native.valueCallbacks value callback registry
   Native.recoveredXX_*  runtime helpers (fonts, watermark, misc UI logic)

 ASSETS (no base64, no escaped binary - real files in ./assets/)
   BurbankBigCondensed-Black.otf   title font
   Minecraft-Regular.otf           pixel font (regular)
   Minecraft-Bold.otf              pixel font (bold)
   SmallestPixel-7.ttf             smallest pixel font
   fs-Tahoma-8px.ttf               Tahoma-style pixel font
   ProggyClean.ttf                 monospace pixel font
   ProggyTiny.ttf                  tiny monospace pixel font
   PixelArial11.ttf                pixel Arial
   watermark_image.png             247x247 watermark/logo image
   watermark_text.blob             base64 text asset decoded at RUNTIME by the
                                   cheat's VM (PRNG-style keystream; cannot be
                                   decoded statically). Pure data, not needed
                                   for the UI library itself - safe to delete.

   Assets.read(name)  -> returns the file's binary content (readfile)
   Assets.install()   -> writes fonts into the executor workspace folder
                         (getcustomasset/getsynasset) and returns a
                         { name -> rbxasset://... } url table for FontFace
   Asset files must be shipped next to this script (see README).

 SCHEDULER STUB
   The original loader had a watchdog (__step) that aborts long loops.
   It is stubbed out here; define your own before loading if needed.
]]

local arguments = table.pack(...)
local sharedEnv = getgenv and getgenv() or _G
local Native = {}

-- Scheduler watchdog stub (original: aborts execution after 20s of no progress)
local function __step(id)
end

-- ---------------------------------------------------------------------
-- Assets: file-based resource loading (replaces the 9 base64 blobs)
-- ---------------------------------------------------------------------
local Assets = {}

Assets.Folder = 'RivalsUE_Assets'       -- executor workspace folder used by install()
Assets.Source = 'RivalsUE/assets'       -- where readfile() looks for shipped files

Assets.Fonts = {
    Title    = 'BurbankBigCondensed-Black.otf',
    PixelReg = 'Minecraft-Regular.otf',
    PixelBold= 'Minecraft-Bold.otf',
    Small    = 'SmallestPixel-7.ttf',
    Tahoma   = 'fs-Tahoma-8px.ttf',
    Mono     = 'ProggyClean.ttf',
    MonoTiny = 'ProggyTiny.ttf',
    Arial    = 'PixelArial11.ttf',
}
Assets.Images = {
    Watermark = 'watermark_image.png',
}

function Assets.read(name)
    local ok, content = pcall(readfile, Assets.Source .. '/' .. name)
    if ok then
        return content
    end
    warn('[UE Assets] could not read ' .. tostring(name) .. ' from ' .. Assets.Source)
    return nil
end

function Assets.install()
    local getcustomassetfn = getcustomasset or getsynasset
    local urls = {}
    if not getcustomassetfn then
        warn('[UE Assets] getcustomasset/getsynasset not available; fonts not installed')
        return urls
    end
    for _, name in pairs(Assets.Fonts) do
        local content = Assets.read(name)
        if content then
            local dest = Assets.Folder .. '/' .. name
            if not isfile(dest) then
                writefile(dest, content)
            end
            urls[name] = getcustomassetfn(dest)
        end
    end
    for _, name in pairs(Assets.Images) do
        local content = Assets.read(name)
        if content then
            local dest = Assets.Folder .. '/' .. name
            if not isfile(dest) then
                writefile(dest, content)
            end
            urls[name] = getcustomassetfn(dest)
        end
    end
    return urls
end

Native.Assets = Assets

function Native.library(captures)
    local capture09 = captures[9]
    local capture11 = captures[11]
    local uiLibrary = captures[0]
    local capture10 = captures[10]
    local capture17 = captures[17]
    local playersService = captures[22]
    local capture12 = captures[12]
    local capture19 = captures[19]
    local textService = captures[18]
    local userInputService = captures[6]
    local capture08 = captures[8]
    local capture14 = captures[14]
    local capture02 = captures[2]
    local teamsService = captures[21]
    local contextActionService = captures[13]
    local capture01 = captures[1]
    local capture05 = captures[5]
    local capture03 = captures[3]
    local capture16 = captures[16]
    local capture20 = captures[20]
    local capture04 = captures[4]
    local capture07 = captures[7]
    local capture23 = captures[23]
    local capture15 = captures[15]

    return function()
        capture08[3][capture08[2] ] = function()
            local players = playersService:GetPlayers()

            for index = 1, #players do
                __step(5)

                players[index] = players[index].Name
            end

            table.sort(players, function(value028, value029)
                return value028 < value029
            end)

            return players
        end
        capture11[3][capture11[2] ] = function()
            local teams = teamsService:GetTeams()

            for index2 = 1, #teams do
                __step(6)

                teams[index2] = teams[index2].Name
            end

            table.sort(teams, function(value032, value033)
                return value032 < value033
            end)

            return teams
        end

        function uiLibrary:SafeCallback(callback, ...)
            if not callback then
                return
            end
            if not uiLibrary.NotifyOnError then
                return callback(...)
            end

            local success, resultOrError = pcall(callback, ...)

            if not success then
                local matchStart, matchEnd = resultOrError:find(':%d+: ')

                if not matchEnd then
                    return uiLibrary:Notify(resultOrError)
                end

                return uiLibrary:Notify(resultOrError:sub(matchEnd + 1), 3)
            end
        end
        function uiLibrary:AttemptSave()
            if uiLibrary.SaveManager then
                uiLibrary.SaveManager:Save()
            end
        end
        function uiLibrary:Create(classOrInstance, properties)
            local instance3 = classOrInstance

            if typeof(classOrInstance) == 'string' then
                instance3 = Instance.new(classOrInstance)
            end

            for key, value in next, properties do
                __step(7)

                local success2, resultOrError2 = pcall(function()
                    instance3[key] = value
                end)

                if not success2 then
                    capture17(resultOrError2)
                end
            end

            return instance3
        end
        function uiLibrary:EnableFlagCopying(enabled)
            uiLibrary.FlagCopying = enabled
        end
        function uiLibrary:ApplyTextStroke(label)
            label.TextStrokeTransparency = 1

            return uiLibrary:Create('UIStroke', {
                Color = Color3.new(0, 0, 0),
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = label,
            })
        end
        function uiLibrary:CreateLabel(properties2, isHud)
            local textLabel = uiLibrary:Create('TextLabel', {
                BackgroundTransparency = 1,
                Font = uiLibrary.Font,
                TextColor3 = uiLibrary.FontColor,
                TextSize = 16,
                TextStrokeTransparency = 0,
            })

            uiLibrary:ApplyTextStroke(textLabel)
            uiLibrary:AddToRegistry(textLabel, {
                TextColor3 = 'FontColor',
            }, isHud)

            return uiLibrary:Create(textLabel, properties2)
        end
        function uiLibrary:MakeDraggable(frame, dragHeight, respectDragLock)
            frame.Active = true

            frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if respectDragLock == true and uiLibrary.CantDragForced == true then
                        return
                    end

                    local dragOffset = Vector2.new(capture03.X - frame.AbsolutePosition.X, capture03.Y - frame.AbsolutePosition.Y)

                    if dragOffset.Y > (dragHeight or 40) then
                        return
                    end

                    while userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        __step(8)

                        frame.Position = UDim2.new(0, capture03.X - dragOffset.X + frame.Size.X.Offset * frame.AnchorPoint.X, 0, capture03.Y - dragOffset.Y + frame.Size.Y.Offset * frame.AnchorPoint.Y)

                        capture04:Wait()
                    end
                end
            end)
        end

        local screenGui = Instance.new('ScreenGui', capture10)

        function uiLibrary:MakeDraggableOutline(frame2, dragHeight2, respectDragLock2)
            frame2.Active = true

            frame2.InputBegan:Connect(function(input2)
                if input2.UserInputType == Enum.UserInputType.MouseButton1 then
                    if respectDragLock2 == true and uiLibrary.CantDragForced == true then
                        return
                    end

                    local dragOffset2 = Vector2.new(capture03.X - frame2.AbsolutePosition.X, capture03.Y - frame2.AbsolutePosition.Y)

                    if dragOffset2.Y > (dragHeight2 or 40) then
                        return
                    end

                    local value070 = uiLibrary:Create(capture01[3][capture01[2] ], {
                        Parent = screenGui,
                        AnchorPoint = frame2.AnchorPoint,
                        BackgroundTransparency = 1,
                        Size = frame2.Size,
                        Position = frame2.Position,
                    })
                    local uIStroke = uiLibrary:Create('UIStroke', {
                        Parent = value070,
                        Color = uiLibrary.AccentColor or Color3.new(0, 0, 0),
                    })

                    uiLibrary.IsDragging = true

                    while(userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) do
                        __step(9)

                        value070.Position = UDim2.new(0, capture03.X - dragOffset2.X + frame2.Size.X.Offset * frame2.AnchorPoint.X, 0, capture03.Y - dragOffset2.Y + frame2.Size.Y.Offset * frame2.AnchorPoint.Y)
                        uIStroke.Color = uiLibrary.AccentColor or Color3.new(0, 0, 0)

                        capture04:Wait()
                    end

                    frame2.Position = value070.Position

                    value070:Destroy()

                    uiLibrary.IsDragging = false
                end
                if input2.UserInputType == Enum.UserInputType.Touch then
                    if respectDragLock2 == true and uiLibrary.CantDragForced == true then
                        return
                    end

                    local value072 = Vector2.new(input2.Position.X - frame2.AbsolutePosition.X, input2.Position.Y - frame2.AbsolutePosition.Y)

                    if value072.Y > (dragHeight2 or 40) then
                        return
                    end

                    local value073 = uiLibrary:Create(capture01[3][capture01[2] ], {
                        Parent = screenGui,
                        AnchorPoint = frame2.AnchorPoint,
                        BackgroundTransparency = 1,
                        Size = frame2.Size,
                        Position = frame2.Position,
                    })
                    local uIStroke2 = uiLibrary:Create('UIStroke', {
                        Parent = value073,
                        Color = uiLibrary.AccentColor or Color3.new(0, 0, 0),
                    })

                    uiLibrary.IsDragging = true

                    local value075 = true
                    local value076

                    value076 = input2.Changed:Connect(function()
                        if input2.UserInputState == Enum.UserInputState.End then
                            value075 = false
                        end
                    end)

                    while value075 do
                        __step(10)

                        value073.Position = UDim2.new(0, input2.Position.X - value072.X + frame2.Size.X.Offset * frame2.AnchorPoint.X, 0, input2.Position.Y - value072.Y + frame2.Size.Y.Offset * frame2.AnchorPoint.Y)
                        uIStroke2.Color = uiLibrary.AccentColor or Color3.new(0, 0, 0)

                        capture04:Wait()
                    end

                    frame2.Position = value073.Position

                    if value076 then
                        value076:Disconnect()
                    end

                    value073:Destroy()

                    uiLibrary.IsDragging = false
                end
            end)
        end
        function uiLibrary:MakeDraggableUsingParent(handle, frame3, dragHeight3, respectDragLock3)
            handle.Active = true

            if uiLibrary.IsMobile == false then
                handle.InputBegan:Connect(function(input3)
                    if input3.UserInputType == Enum.UserInputType.MouseButton1 or input3.UserInputType == Enum.UserInputType.Touch then
                        if respectDragLock3 == true and uiLibrary.CantDragForced == true then
                            return
                        end

                        local dragOffset3 = Vector2.new(capture03.X - frame3.AbsolutePosition.X, capture03.Y - frame3.AbsolutePosition.Y)

                        if dragOffset3.Y > (dragHeight3 or 40) then
                            return
                        end

                        while userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            __step(11)

                            frame3.Position = UDim2.new(0, capture03.X - dragOffset3.X + frame3.Size.X.Offset * frame3.AnchorPoint.X, 0, capture03.Y - dragOffset3.Y + frame3.Size.Y.Offset * frame3.AnchorPoint.Y)

                            capture04:Wait()
                        end
                    end
                end)
            else
                uiLibrary:MakeDraggable(frame3, dragHeight3, respectDragLock3)
            end
        end
        function uiLibrary:MakeResizable(value085, value086)
            value085.Active = true

            local value087 = 25
            local value088 = 0.5
            local value089 = uiLibrary:Create(capture01[3][capture01[2] ], {
                SizeConstraint = Enum.SizeConstraint.RelativeXX,
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -30, 1, -30),
                Visible = true,
                ClipsDescendants = true,
                ZIndex = 1,
                Parent = value085,
            })
            local imageButton = uiLibrary:Create('ImageButton', {
                BackgroundColor3 = uiLibrary.AccentColor,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(2, 0, 2, 0),
                Position = UDim2.new(1, -30, 1, -30),
                ZIndex = 2,
                Parent = value089,
            })
            local uICorner = uiLibrary:Create('UICorner', {
                CornerRadius = UDim.new(0.5, 0),
                Parent = imageButton,
            })

            uiLibrary:AddToRegistry(imageButton, {
                BackgroundColor3 = 'AccentColor',
            })

            value089.Size = UDim2.fromOffset(value087, value087)
            value089.Position = UDim2.new(1, -value087, 1, -value087)
            value086 = value086 or uiLibrary.MinSize

            local value092
            local value093, uIStroke3 = nil, uiLibrary:Create('UIStroke', {
                Color = uiLibrary.AccentColor or Color3.new(0, 0, 0),
            })

            uIStroke3.Color = uiLibrary.AccentColor or Color3.new(0, 0, 0)

            local function value095(value096)
                imageButton.Position = UDim2.new()
                imageButton.Size = UDim2.new(2, 0, 2, 0)
                imageButton.Parent = value089
                imageButton.BackgroundTransparency = value096
                uICorner.Parent = imageButton
                value092 = nil

                if value093 then
                    uIStroke3.Parent = nil
                    value085.Size = value093.Size

                    value093:Destroy()
                end
            end

            if uiLibrary.IsMobile ~= true then
                imageButton.MouseButton1Down:Connect(function()
                    if value092 then
                        return
                    end

                    value092 = Vector2.new(capture03.X - (value085.AbsolutePosition.X + value085.AbsoluteSize.X), capture03.Y - (value085.AbsolutePosition.Y + value085.AbsoluteSize.Y))
                    value093 = uiLibrary:Create(capture01[3][capture01[2] ], {
                        Parent = screenGui,
                        AnchorPoint = value085.AnchorPoint,
                        BackgroundTransparency = 1,
                        Size = value085.Size,
                        Position = value085.Position,
                    })
                    uIStroke3.Parent = value093
                    imageButton.BackgroundTransparency = 1
                    imageButton.Size = UDim2.fromOffset(uiLibrary.ScreenGui.AbsoluteSize.X, uiLibrary.ScreenGui.AbsoluteSize.Y)
                    imageButton.Position = UDim2.new()
                    uICorner.Parent = nil
                    imageButton.Parent = uiLibrary.ScreenGui
                end)
                imageButton.MouseMoved:Connect(function()
                    if not value092 then
                        return
                    end

                    local value097 = Vector2.new(capture03.X - value092.X, capture03.Y - value092.Y)
                    local value098 = Vector2.new(math.clamp(value097.X - value085.AbsolutePosition.X, value086.X, math.huge), math.clamp(value097.Y - value085.AbsolutePosition.Y, value086.Y, math.huge))

                    value093.Size = UDim2.fromOffset(value098.X, value098.Y)
                end)
                imageButton.MouseButton1Up:Connect(function()
                    value095(value088)
                end)
            else
                imageButton.InputBegan:Connect(function(input4)
                    if input4.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    if value092 then
                        return
                    end

                    value092 = Vector2.new(input4.Position.X - (value085.AbsolutePosition.X + value085.AbsoluteSize.X), input4.Position.Y - (value085.AbsolutePosition.Y + value085.AbsoluteSize.Y))
                    value093 = uiLibrary:Create(capture01[3][capture01[2] ], {
                        Parent = screenGui,
                        AnchorPoint = value085.AnchorPoint,
                        BackgroundTransparency = 1,
                        Size = value085.Size,
                        Position = value085.Position,
                    })
                    uIStroke3.Parent = value093
                end)
                imageButton.InputChanged:Connect(function(input5)
                    if input5.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end
                    if not value092 then
                        return
                    end

                    local value101 = Vector2.new(input5.Position.X - value092.X, input5.Position.Y - value092.Y)
                    local value102 = Vector2.new(math.clamp(value101.X - value085.AbsolutePosition.X, value086.X, math.huge), math.clamp(value101.Y - value085.AbsolutePosition.Y, value086.Y, math.huge))

                    value093.Size = UDim2.fromOffset(value102.X, value102.Y)
                end)
                imageButton.InputEnded:Connect(function(input6)
                    if input6.UserInputType ~= Enum.UserInputType.Touch then
                        return
                    end

                    value095(value088)
                end)
            end

            value095(value088)
        end
        function uiLibrary:AddToolTip(text, target)
            local textWidth, textHeight = uiLibrary:GetTextBounds(text, uiLibrary.Font, 14)
            local value109 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = uiLibrary.MainColor,
                BorderColor3 = uiLibrary.OutlineColor,
                Size = UDim2.fromOffset(textWidth + 5, textHeight + 4),
                ZIndex = 100,
                Parent = uiLibrary.ScreenGui,
                Visible = false,
            })
            local value110 = uiLibrary:CreateLabel({
                Position = UDim2.fromOffset(3, 1),
                Size = UDim2.fromOffset(textWidth, textHeight),
                TextSize = 14,
                Text = text,
                TextColor3 = uiLibrary.FontColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = value109.ZIndex + 1,
                Parent = value109,
            })

            uiLibrary:AddToRegistry(value109, {
                BackgroundColor3 = 'MainColor',
                BorderColor3 = capture15[3][capture15[2] ],
            })
            uiLibrary:AddToRegistry(value110, {
                TextColor3 = 'FontColor',
            })

            local value111 = false

            target.MouseEnter:Connect(function()
                if uiLibrary:MouseIsOverOpenedFrame() then
                    return
                end

                value111 = true
                value109.Position = UDim2.fromOffset(capture03.X + 15, capture03.Y + 12)
                value109.Visible = true

                while value111 do
                    __step(12)
                    capture19.Heartbeat:Wait()

                    value109.Position = UDim2.fromOffset(capture03.X + 15, capture03.Y + 12)
                end
            end)
            target.MouseLeave:Connect(function()
                value111 = false
                value109.Visible = false
            end)

            if capture12[3][capture12[2] ] then
                capture12[3][capture12[2] ]:GetPropertyChangedSignal('Visible'):Connect(function()
                    if capture12[3][capture12[2] ].Visible == false then
                        value111 = false
                        value109.Visible = false
                    end
                end)
            end
        end
        function uiLibrary:OnHighlight(target2, styledInstance, highlightProperties, normalProperties, canHighlight)
            local function value118()
                local registryEntry = uiLibrary.RegistryMap[styledInstance]

                for key2, value2 in next, normalProperties do
                    __step(13)

                    styledInstance[key2] = uiLibrary[value2] or value2

                    if registryEntry and registryEntry.Properties[key2] then
                        registryEntry.Properties[key2] = value2
                    end
                end
            end
            local function value122()
                if canHighlight and not canHighlight() then
                    value118()

                    return
                end

                local registryEntry2 = uiLibrary.RegistryMap[styledInstance]

                for key3, value3 in next, highlightProperties do
                    __step(14)

                    styledInstance[key3] = uiLibrary[value3] or value3

                    if registryEntry2 and registryEntry2.Properties[key3] then
                        registryEntry2.Properties[key3] = value3
                    end
                end
            end

            target2.MouseEnter:Connect(function()
                value122()
            end)
            target2.MouseMoved:Connect(function()
                value122()
            end)
            target2.MouseLeave:Connect(function()
                value118()
            end)
        end
        function uiLibrary:MouseIsOverOpenedFrame()
            for key4, value4 in next, uiLibrary.OpenedFrames do
                __step(15)

                local absolutePosition, absoluteSize = key4.AbsolutePosition, key4.AbsoluteSize

                if capture03.X >= absolutePosition.X and capture03.X <= absolutePosition.X + absoluteSize.X and capture03.Y >= absolutePosition.Y and capture03.Y <= absolutePosition.Y + absoluteSize.Y then
                    return true
                end
            end
        end
        function uiLibrary:IsMouseOverFrame(frame4)
            local absolutePosition2, absoluteSize2 = frame4.AbsolutePosition, frame4.AbsoluteSize

            if capture03.X >= absolutePosition2.X and capture03.X <= absolutePosition2.X + absoluteSize2.X and capture03.Y >= absolutePosition2.Y and capture03.Y <= absolutePosition2.Y + absoluteSize2.Y then
                return true
            end
        end
        function uiLibrary:UpdateDependencyBoxes()
            for key5, value5 in next, uiLibrary.DependencyBoxes do
                __step(16)
                value5:Update()
            end
        end
        function uiLibrary:MapValue(inputValue, inputMin, inputMax, outputMin, outputMax)
            return (1 - (inputValue - inputMin) / (inputMax - inputMin)) * outputMin + (inputValue - inputMin) / (inputMax - inputMin) * outputMax
        end
        function uiLibrary:GetTextBounds(text2, font, fontSize, bounds)
            local textSize = textService:GetTextSize(text2, fontSize, font, bounds or Vector2.new(1920, 1080))

            return textSize.X, textSize.Y
        end
        function uiLibrary:GetDarkerColor(color)
            local hue, saturation, brightness = Color3.toHSV(color)

            return Color3.fromHSV(hue, saturation, brightness / 1.5)
        end

        uiLibrary.AccentColorDark = uiLibrary:GetDarkerColor(uiLibrary.AccentColor)

        function uiLibrary:AddToRegistry(instance, properties3, isHud2)
            local registryIndex = #uiLibrary.Registry + 1
            local registryEntry3 = {
                Instance = instance,
                Properties = properties3,
                Idx = registryIndex,
            }

            table.insert(uiLibrary.Registry, registryEntry3)

            uiLibrary.RegistryMap[instance] = registryEntry3

            if isHud2 then
                table.insert(uiLibrary.HudRegistry, registryEntry3)
            end
        end
        function uiLibrary:RemoveFromRegistry(instance2)
            local registryEntry4 = uiLibrary.RegistryMap[instance2]

            if registryEntry4 then
                for index3 = #uiLibrary.Registry, 1, -1 do
                    __step(17)

                    if uiLibrary.Registry[index3] == registryEntry4 then
                        table.remove(uiLibrary.Registry, index3)
                    end
                end
                for index4 = #uiLibrary.HudRegistry, 1, -1 do
                    __step(18)

                    if uiLibrary.HudRegistry[index4] == registryEntry4 then
                        table.remove(uiLibrary.HudRegistry, index4)
                    end
                end

                uiLibrary.RegistryMap[instance2] = nil
            end
        end
        function uiLibrary:UpdateColorsUsingRegistry()
            for key6, value6 in next, uiLibrary.Registry do
                __step(19)

                for key7, value7 in next, value6.Properties do
                    __step(20)

                    if typeof(value7) == 'string' then
                        value6.Instance[key7] = uiLibrary[value7]
                    elseif typeof(value7) == 'function' then
                        value6.Instance[key7] = value7()
                    end
                end
            end
        end
        function uiLibrary:GiveSignal(connection)
            table.insert(uiLibrary.Signals, connection)
        end
        function uiLibrary:Unload()
            for index5 = #uiLibrary.Signals, 1, -1 do
                __step(21)

                local connection2 = table.remove(uiLibrary.Signals, index5)

                connection2:Disconnect()
            end

            if uiLibrary.OnUnload then
                uiLibrary.OnUnload()
            end

            contextActionService:UnbindAction('Freeze')
            capture16:Destroy()
            capture20:Destroy()
            capture05:Destroy()
            capture09:Destroy()
        end
        function uiLibrary:CreateEvent(eventName)
            self.Events[eventName] = Instance.new(capture02[3][capture02[2] ])
        end
        function uiLibrary:FireEvent(eventName2, ...)
            self.Events[eventName2]:Fire(...)
        end
        function uiLibrary:OnEvent(eventName3)
            return self.Events[eventName3].Event
        end
        function uiLibrary:OnUnload(callback2)
            uiLibrary.OnUnload = callback2
        end

        local inputCallbacks = {}

        function uiLibrary:BindToInput(inputType, callback3)
            inputCallbacks[inputType] = inputCallbacks[inputType] or {}

            table.insert(inputCallbacks[inputType], callback3)
        end

        uiLibrary:GiveSignal(userInputService.InputBegan:Connect(function(input7, ...)
            if not capture07[3][capture07[2] ] then
                return
            end

            local value189 = inputCallbacks[input7.KeyCode] or inputCallbacks[input7.UserInputType]

            if value189 then
                for key8, value8 in pairs(value189)do
                    __step(22)
                    task.spawn(value8, input7, ...)
                end
            end
        end))

        function uiLibrary:AddContextMenu(value193, value194)
            local panel = {Visible = false}

            panel.Options = {}
            panel.Container = uiLibrary:Create('ImageButton', {
                BorderColor3 = Color3.new(),
                ZIndex = 14,
                Visible = false,
                Parent = capture09,
                Image = '',
                Active = false,
                AutoButtonColor = false,
            })
            panel.Inner = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = uiLibrary.BackgroundColor,
                BorderColor3 = uiLibrary.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Size = UDim2.fromScale(1, 1),
                ZIndex = 15,
                Parent = panel.Container,
            })

            uiLibrary:Create('UIListLayout', {
                Name = 'Layout',
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = panel.Inner,
            })
            uiLibrary:Create('UIPadding', {
                Name = 'Padding',
                PaddingLeft = UDim.new(0, 0),
                Parent = panel.Inner,
            })

            local function value196()
                panel.Container.Position = UDim2.fromOffset(value193.AbsolutePosition.X + value193.AbsoluteSize.X + 4, value193.AbsolutePosition.Y + 1)
            end
            local function value197()
                local value198 = 60

                for key9, value9 in next, panel.Inner:GetChildren()do
                    __step(23)

                    if value9:IsA('TextLabel') then
                        value198 = math.max(value198, value9.TextBounds.X)
                    end
                end

                panel.Container.Size = UDim2.fromOffset(value198 + 8, panel.Inner.Layout.AbsoluteContentSize.Y + 4)
            end

            local value201 = false

            (value194 or value193).InputBegan:Connect(function(input8)
                if input8.UserInputType == Enum.UserInputType.MouseButton1 and not uiLibrary:MouseIsOverOpenedFrame() then
                    return panel:Hide()
                elseif input8.UserInputType == Enum.UserInputType.MouseButton2 and not uiLibrary:MouseIsOverOpenedFrame() then
                    return panel:Show()
                end
            end)
            uiLibrary:BindToInput(Enum.UserInputType.MouseButton1, function()
                if value201 and not uiLibrary:IsMouseOverFrame(panel.Container) then
                    panel:Hide()
                end
            end)
            uiLibrary:BindToInput(Enum.UserInputType.MouseButton2, function()
                if value201 and not uiLibrary:IsMouseOverFrame(panel.Container) and not uiLibrary:IsMouseOverFrame(value193) then
                    panel:Hide()
                end
            end)
            task.spawn(value196)
            task.spawn(value197)
            uiLibrary:AddToRegistry(panel.Inner, {
                BackgroundColor3 = 'BackgroundColor',
                BorderColor3 = capture15[3][capture15[2] ],
            })

            function panel:Show()
                value196()
                value197()

                value201 = true

                for key10, value10 in next, uiLibrary.OpenedFrames do
                    __step(24)

                    if key10.Name == 'Color' then
                        key10.Visible = false
                        uiLibrary.OpenedFrames[key10] = nil
                    end
                end

                self.Container.Visible = true
                uiLibrary.OpenedFrames[panel.Container] = true
            end
            function panel:Hide()
                value201 = false
                self.Container.Visible = false

                task.wait()

                uiLibrary.OpenedFrames[panel.Container] = nil
            end
            function panel:AddOption(text3, callback4)
                if type(callback4) ~= 'function' then
                    callback4 = function() end
                end

                local value210 = uiLibrary:CreateLabel({
                    Active = false,
                    Size = UDim2.new(1, 0, 0, 15),
                    TextSize = 13,
                    Text = text3,
                    ZIndex = 16,
                    Parent = self.Inner,
                    TextXAlignment = Enum.TextXAlignment.Center,
                })

                uiLibrary:OnHighlight(value210, value210, {
                    TextColor3 = 'AccentColor',
                }, {
                    TextColor3 = 'FontColor',
                })
                value210.InputBegan:Connect(function(input9)
                    if input9.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end

                    callback4()
                end)

                return value210
            end

            return panel
        end

        uiLibrary:GiveSignal(capture09.DescendantRemoving:Connect(function(value212)
            if capture07[3][capture07[2] ] and uiLibrary.RegistryMap[value212] then
                uiLibrary:RemoveFromRegistry(value212)
            end
        end))

        function uiLibrary:SetWatermarkVisibility(visible)
            uiLibrary.Watermark.Visible = visible
        end
        function uiLibrary:SetWatermark(text4)
            local textWidth2, textHeight2 = uiLibrary:GetTextBounds(text4, uiLibrary.Font, 14)

            uiLibrary.Watermark.Size = UDim2.new(0, textWidth2 + 15, 0, textHeight2 * 1.5 + 3)
            uiLibrary.WatermarkText.Text = text4
        end

        local value219 = {
            BarPosition = {
                Top = UDim2.new(0, -1, 0, 0),
                Left = UDim2.new(0, -1, 0, -1),
                Right = UDim2.new(1, -2, 0, -1),
                Bottom = UDim2.new(0, -1, 1, -2),
            },
            BarSize = {
                Top = UDim2.new(1, 3, 0, 2),
                Left = UDim2.new(0, 3, 1, 2),
                Right = UDim2.new(0, 3, 1, 2),
                Bottom = UDim2.new(1, 3, 0, 2),
            },
        }
        local notificationStyle = uiLibrary.NotificationStyle
        local charFn, maxFn = string.char, math.max
        local value223 = function()
            local overrideColor = notificationStyle.OverrideColor

            if overrideColor then
                return overrideColor()
            end

            return uiLibrary.MainColor, uiLibrary.AccentColor, uiLibrary.OutlineColor, uiLibrary.FontColor
        end
        local value225

        do
            local value226 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BorderColor3 = Color3.new(0, 0, 0),
                Position = UDim2.new(0, 100, 0, 10),
                ClipsDescendants = true,
                ZIndex = 100,
            })
            local value227 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BorderMode = Enum.BorderMode.Inset,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 101,
                Parent = value226,
                Name = 'inner',
            })
            local value228 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 1, 0, 1),
                Size = UDim2.new(1, -2, 1, -2),
                ZIndex = 102,
                Parent = value227,
                Name = 'inner',
            })
            local uIGradient = uiLibrary:Create('UIGradient', {
                Rotation = -90,
                Parent = value228,
            })
            local value230 = uiLibrary:CreateLabel({
                Position = UDim2.new(0, 4, 0, 0),
                Size = UDim2.new(1, -4, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 14,
                ZIndex = 103,
                Name = 'label',
                Parent = value228,
            })
            local value231 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BorderSizePixel = 0,
                ZIndex = 104,
                Name = 'bar',
                Parent = value226,
            })

            value225 = value226
        end

        function uiLibrary:CreatePopout(settings)
            if type(settings.Title) ~= 'string' then
                settings.Title = 'No title'
            end
            if typeof(settings.Position) ~= 'UDim2' then
                settings.Position = UDim2.fromOffset(175, 50)
            end

            local screenGui2 = Instance.new('ScreenGui')

            capture23(screenGui2)

            screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Global
            screenGui2.Parent = capture10
            screenGui2.DisplayOrder = (settings.ZIndex or 0) + 19

            if settings.Center then
                settings.AnchorPoint = Vector2.new(0.5, 0.5)
                settings.Position = UDim2.fromScale(0.5, 0.5)
            end

            local popout = {}
            local value236 = uiLibrary:Create(capture01[3][capture01[2] ], {
                AnchorPoint = settings.AnchorPoint,
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Position = settings.Position,
                Size = UDim2.fromOffset(settings.Size.X, settings.Size.Y),
                Visible = settings.AutoShow,
                ZIndex = 1,
                Parent = screenGui2,
            })

            if not settings.RemoveTopbar then
                uiLibrary:MakeDraggableOutline(value236, 25)
            end

            local value237 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = uiLibrary.MainColor,
                BorderColor3 = uiLibrary.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Position = UDim2.new(0, 1, 0, 1),
                Size = UDim2.new(1, -2, 1, -2),
                ZIndex = 1,
                Parent = value236,
            })

            uiLibrary:AddToRegistry(value237, {
                BackgroundColor3 = 'MainColor',
                BorderColor3 = capture15[3][capture15[2] ],
            })

            if not settings.RemoveTopbar then
                local value238 = uiLibrary:CreateLabel({
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    Text = settings.Title or '',
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 1,
                    Font = uiLibrary.Font,
                    Parent = value237,
                })
                local textLabel2 = uiLibrary:Create('TextLabel', {
                    BackgroundTransparency = 1,
                    Font = uiLibrary.Font,
                    TextColor3 = uiLibrary.AccentColor,
                    TextSize = 16,
                    TextStrokeTransparency = 0,
                    Position = UDim2.new(0, -8, 0, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    Text = settings.Version or '',
                    RichText = true,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 1,
                    Parent = value237,
                })

                uiLibrary:AddToRegistry(textLabel2, {
                    TextColor3 = 'AccentColor',
                })
            end

            local value240 = settings.RemoveTopbar and 8 or 25
            local value241 = settings.RemoveTopbar and -16 or -33
            local value242 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = uiLibrary.BackgroundColor,
                BorderColor3 = uiLibrary.OutlineColor,
                Position = UDim2.new(0, 8, 0, value240),
                Size = UDim2.new(1, -16, 1, value241),
                ZIndex = 1,
                Parent = value237,
            })

            uiLibrary:AddToRegistry(value242, {
                BackgroundColor3 = 'BackgroundColor',
                BorderColor3 = capture15[3][capture15[2] ],
            })

            local value243 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = uiLibrary.BackgroundColor,
                BorderColor3 = Color3.new(0, 0, 0),
                BorderMode = Enum.BorderMode.Inset,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 1,
                Parent = value242,
            })

            uiLibrary:AddToRegistry(value243, {
                BackgroundColor3 = 'BackgroundColor',
            })

            local value244 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = uiLibrary.BackgroundColor,
                BorderColor3 = uiLibrary.OutlineColor,
                Position = UDim2.new(0, 8, 0, 8),
                Size = UDim2.new(1, -16, 1, -16),
                ZIndex = 2,
                Visible = true,
                Parent = value243,
            })
            local value245 = uiLibrary:Create(capture01[3][capture01[2] ], {
                BackgroundTransparency = 1,
                Parent = value244,
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromOffset(2, 2),
            })

            uiLibrary:Create('UIListLayout', {
                Padding = UDim.new(0, 0),
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Parent = value245,
            })
            uiLibrary:AddToRegistry(value244, {
                BackgroundColor3 = 'BackgroundColor',
                BorderColor3 = capture15[3][capture15[2] ],
            })
            uiLibrary:AddToRegistry(value245, {
                BackgroundColor3 = 'MainColor',
                BorderColor3 = capture15[3][capture15[2] ],
            })

            popout.Holder = value236
            popout.Container = value245

            function popout:Resize()
                local contentHeight = 0

                for key11, value11 in next, value245:GetChildren()do
                    __step(25)

                    if not value11:IsA('UIListLayout') and value11.Visible then
                        contentHeight = contentHeight + value11.AbsoluteSize.Y
                    end
                end

                value236.Size = UDim2.fromOffset(settings.Size.X, 16 + contentHeight + (value245.AbsolutePosition.Y - value236.AbsolutePosition.Y))
            end
            function popout:Toggle()
                value236.Visible = not value236.Visible
            end
            function popout:GetSize()
                return value245.AbsoluteSize
            end

            value245:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
                task.wait()
                popout:Resize()
            end)
            popout:Resize()
            setmetatable(popout, capture14)

            return popout
        end

        local newFn, newFn2, newFn3 = UDim2.new, ColorSequence.new, ColorSequenceKeypoint.new

        function uiLibrary:Notify(text5, duration)
            local textWidth3, textHeight3 = uiLibrary:GetTextBounds(text5, uiLibrary.Font, 14)

            textHeight3 = textHeight3 + 7

            local transparency = notificationStyle.Transparency
            local value261, value262, value263, value264 = value223()
            local value265 = value225:Clone()

            value265.BackgroundColor3 = value261
            value265.Name = charFn(256 - maxFn(1, #text5 % 256))
            value265.Size = newFn(0, 0, 0, textHeight3)
            value265.Transparency = transparency

            local value266 = value265.inner

            value266.BackgroundColor3 = value261
            value266.BorderColor3 = value263
            value266.Transparency = transparency

            local value267 = value266.inner

            value267.Transparency = transparency

            local uIGradient2 = value267.UIGradient

            uIGradient2.Color = newFn2({
                newFn3(0, uiLibrary:GetDarkerColor(value261)),
                newFn3(1, value261),
            })

            local value269 = value267.label

            value269.Text = text5
            value269.TextColor3 = value264

            local value270 = value265.bar

            value270.BackgroundColor3 = value262
            value270.Size = value219.BarSize[notificationStyle.BarSide] or newFn(0, 3, 1, 2)
            value270.Position = value219.BarPosition[notificationStyle.BarSide]
            value265.Parent = uiLibrary.NotificationArea

            pcall(value265.TweenSize, value265, UDim2.new(0, textWidth3 + 8 + 4, 0, textHeight3), 'Out', 'Quad', 0.4, true)
            task.spawn(function()
                wait(duration or 5)
                pcall(value265.TweenSize, value265, UDim2.new(0, 0, 0, textHeight3), 'Out', 'Quad', 0.4, true)
                wait(0.4)
                value265:Destroy()
            end)
        end
        function uiLibrary:IsVisible()
            return capture07[3][capture07[2] ]
        end

        uiLibrary:CreateEvent('VisibilityChanged')
    end
end
function Native.configuration(captures)
    local toggles = captures[2]
    local options = captures[1]
    local capture03 = captures[3]
    local configManager = captures[0]

    return function()
        local cloneReference = cloneref or function(value007)
            return value007
        end
        local httpService = cloneReference(game:GetService('HttpService'))
        local isfolderFn, isfileFn, listfilesFn = isfolder, isfile, listfiles

        do
            configManager.Folder = ''
            configManager.Ignore = {}
            configManager.Parser = {
                Toggle = {
                    Save = function(optionId, option)
                        return {
                            type = 'Toggle',
                            idx = optionId,
                            value = option.Value,
                        }
                    end,
                    Load = function(optionId2, savedValue)
                        if toggles[optionId2] then
                            toggles[optionId2]:SetValue(savedValue.value)
                        end
                    end,
                },
                Slider = {
                    Save = function(optionId3, option2)
                        return {
                            type = 'Slider',
                            idx = optionId3,
                            value = tostring(option2.Value),
                        }
                    end,
                    Load = function(optionId4, savedValue2)
                        if options[optionId4] then
                            options[optionId4]:SetValue(savedValue2.value)
                        end
                    end,
                },
                Dropdown = {
                    Save = function(optionId5, option3)
                        return {
                            type = 'Dropdown',
                            idx = optionId5,
                            value = option3.Value,
                            mutli = option3.Multi,
                        }
                    end,
                    Load = function(optionId6, savedValue3)
                        if options[optionId6] then
                            options[optionId6]:SetValue(savedValue3.value)
                        end
                    end,
                },
                ColorPicker = {
                    Save = function(optionId7, option4)
                        return {
                            type = 'ColorPicker',
                            idx = optionId7,
                            value = option4.Value:ToHex(),
                            transparency = option4.Transparency,
                        }
                    end,
                    Load = function(optionId8, savedValue4)
                        if options[optionId8] then
                            options[optionId8]:SetValueRGB(Color3.fromHex(savedValue4.value), savedValue4.transparency)
                        end
                    end,
                },
                KeyPicker = {
                    Save = function(optionId9, option5)
                        return {
                            type = 'KeyPicker',
                            idx = optionId9,
                            mode = option5.Mode,
                            key = option5.Value,
                        }
                    end,
                    Load = function(optionId10, savedValue5)
                        if options[optionId10] then
                            options[optionId10]:SetValue({
                                savedValue5.key,
                                savedValue5.mode,
                            })
                        end
                    end,
                },
                Input = {
                    Save = function(optionId11, option6)
                        return {
                            type = 'Input',
                            idx = optionId11,
                            text = option6.Value,
                        }
                    end,
                    Load = function(optionId12, savedValue6)
                        if options[optionId12] and type(savedValue6.text) == 'string' then
                            options[optionId12]:SetValue(savedValue6.text)
                        end
                    end,
                },
            }

            function configManager:BuildFolderTree()
                local folders = {
                    self.Folder,
                    self.Folder .. '/settings',
                    self.Folder .. '/themes',
                }

                for index = 1, #folders do
                    __step(41)

                    local folderPath = folders[index]

                    if not isfolderFn(folderPath) then
                        makefolder(folderPath)
                    end
                end
            end
            function configManager:CheckFolderTree()
                if not isfolderFn(self.Folder) then
                    configManager:BuildFolderTree()
                    task.wait()
                end
            end
            function configManager:SetIgnoreIndexes(indexes)
                for key, value in next, indexes do
                    __step(42)

                    self.Ignore[value] = true
                end
            end
            function configManager:SetFolder(folder)
                self.Folder = folder

                self:BuildFolderTree()
            end
            function configManager:Save(configName, value049)
                if not configName then
                    return false, 'no config file is selected'
                end

                configManager:CheckFolderTree()

                local configPath = self.Folder .. '/settings/' .. configName .. '.json'
                local savedConfig = {objects = {}}

                for key2, value2 in next, toggles do
                    __step(43)

                    if self.Ignore[key2] then
                        continue
                    end

                    table.insert(savedConfig.objects, self.Parser[value2.Type].Save(key2, value2))
                end
                for key3, value3 in next, options do
                    __step(44)

                    if not self.Parser[value3.Type] then
                        continue
                    end
                    if self.Ignore[key3] then
                        continue
                    end

                    table.insert(savedConfig.objects, self.Parser[value3.Type].Save(key3, value3))
                end

                local success, resultOrError = pcall(httpService.JSONEncode, httpService, savedConfig)

                if not success then
                    return false, 'failed to encode data'
                end
                if not value049 then
                    writefile(configPath, resultOrError)
                end

                return true, resultOrError
            end
            function configManager:Load(configOrName)
                if not configOrName then
                    return false, 'no config file is selected'
                end
                if type(configOrName) == 'table' then
                    for key4, value4 in next, configOrName.objects do
                        __step(45)

                        if self.Parser[value4.type] then
                            task.spawn(function()
                                self.Parser[value4.type].Load(value4.idx, value4)
                            end)
                        end
                    end

                    return true
                end

                configManager:CheckFolderTree()

                local configPath2 = self.Folder .. '/settings/' .. configOrName .. '.json'

                if not isfileFn(configPath2) then
                    return false, 'invalid file'
                end

                local success2, resultOrError2 = pcall(httpService.JSONDecode, httpService, readfile(configPath2))

                if not success2 then
                    return false, 'decode error'
                end

                for key5, value5 in next, resultOrError2.objects do
                    __step(46)

                    if self.Parser[value5.type] then
                        task.spawn(function()
                            self.Parser[value5.type].Load(value5.idx, value5)
                        end)
                    end
                end

                return true
            end
            function configManager:Delete(configName2)
                if not configName2 then
                    return false, 'no config file is selected'
                end

                local configPath3 = self.Folder .. '/settings/' .. configName2 .. '.json'

                if not isfileFn(configPath3) then
                    return false, 'invalid file'
                end

                local success3, resultOrError3 = pcall(delfile, configPath3)

                if not success3 then
                    return false, 'delete file error'
                end

                return true
            end
            function configManager:IgnoreThemeSettings()
                self:SetIgnoreIndexes({
                    'ThemeManager_ThemeList',
                    'ThemeManager_CustomThemeList',
                    'ThemeManager_CustomThemeName',
                    'VideoLink',
                    'Brightness',
                    'Contrast',
                    'Saturation',
                    'Brightness',
                    'BlurSize',
                    'FontColor',
                    'RiskColor',
                    'MainColor',
                    'AccentColor',
                    'BackgroundColor',
                    capture03[3][capture03[2] ],
                    'SwordColor',
                    'ItemType',
                    'BackTransparency',
                    'BackColor',
                    'SwordTransparency',
                    'SwordReflectance',
                    'SwordMaterial',
                    'SwordSpeed',
                })
            end
            function configManager:RefreshConfigList()
                local value074 = listfilesFn(self.Folder .. '/settings')
                local value075 = {}

                for index2 = 1, #value074 do
                    __step(47)

                    local value077 = value074[index2]

                    if value077:sub(-5) == '.json' then
                        local matchStart = value077:find('.json', 1, true)
                        local value079 = matchStart
                        local value080 = value077:sub(matchStart, matchStart)

                        while value080 ~= '/' and value080 ~= '\\' and value080 ~= '' do
                            __step(48)

                            matchStart = matchStart - 1
                            value080 = value077:sub(matchStart, matchStart)
                        end

                        if value080 == '/' or value080 == '\\' then
                            table.insert(value075, value077:sub(matchStart + 1, value079 - 1))
                        end
                    end
                end

                return value075
            end
            function configManager:SetLibrary(library)
                self.Library = library
            end
            function configManager:LoadAutoloadConfig()
                configManager:CheckFolderTree()

                if isfileFn(self.Folder .. '/settings/autoload.txt') then
                    local value084 = readfile(self.Folder .. '/settings/autoload.txt')
                    local value085, value086 = self:Load(value084)

                    if not value085 then
                        return self.Library:Notify('Failed to load autoload config: ' .. value086)
                    end
                    if not SILENT then
                        self.Library:Notify(string.format('Auto loaded config %q', value084))
                    end
                end
            end
        end

        getgenv().SaveManager = configManager
    end
end
function Native.themes(captures)
    local themeManager = captures[1]
    local capture02 = captures[2]
    local capture00 = captures[0]

    return function()
        local value005 = cloneref or function(value006)
            return value006
        end
        local httpService = value005(game:GetService('HttpService'))
        local value008 = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request
        local value009 = getcustomasset or getsynasset

        do
            themeManager.Folder = ''
            themeManager.Library = nil
            themeManager.BuiltInThemes = {
                Default = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"131313",\n\t\t\t\t"AccentColor":"a2cdff",\n\t\t\t\t"BackgroundColor":"151515",\n\t\t\t\t"OutlineColor":"212121",\n\t\t\t\t"RiskColor":"ff7425",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                ['Tokyo Night'] = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"191925",\n\t\t\t\t"AccentColor":"6956cb",\n\t\t\t\t"BackgroundColor":"15151e",\n\t\t\t\t"OutlineColor":"272727",\n\t\t\t\t"RiskColor":"fb5f5f",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Nord = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"1c1e20",\n\t\t\t\t"AccentColor":"9effc8",\n\t\t\t\t"BackgroundColor":"1c1e20",\n\t\t\t\t"OutlineColor":"24282d",\n\t\t\t\t"RiskColor":"ff7a00",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Skeet = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"131313",\n\t\t\t\t"AccentColor":"81ff54",\n\t\t\t\t"BackgroundColor":"151515",\n\t\t\t\t"OutlineColor":"2a2a2a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Fatality = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"181537",\n\t\t\t\t"AccentColor":"ca0756",\n\t\t\t\t"BackgroundColor":"201c46",\n\t\t\t\t"OutlineColor":"39335a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Neverlose = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"0c1014",\n\t\t\t\t"AccentColor":"01a3f1",\n\t\t\t\t"BackgroundColor":"0c0f14",\n\t\t\t\t"OutlineColor":"191919",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Onetap = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"1e1d22",\n\t\t\t\t"AccentColor":"faa614",\n\t\t\t\t"BackgroundColor":"18181c",\n\t\t\t\t"OutlineColor":"313033",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Imgui = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"151617",\n\t\t\t\t"AccentColor":"406ba8",\n\t\t\t\t"BackgroundColor":"151617",\n\t\t\t\t"OutlineColor":"242424",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Iniuria = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"1e1d1e",\n\t\t\t\t"AccentColor":"c41275",\n\t\t\t\t"BackgroundColor":"1e1d1e",\n\t\t\t\t"OutlineColor":"33252b",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Primordial = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"181818",\n\t\t\t\t"AccentColor":"d7a6b0",\n\t\t\t\t"BackgroundColor":"1f1f1f",\n\t\t\t\t"OutlineColor":"2a2a2a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Monolith = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"141115",\n\t\t\t\t"AccentColor":"c707bd",\n\t\t\t\t"BackgroundColor":"171417",\n\t\t\t\t"OutlineColor":"272427",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                V3rmillion = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"202020",\n\t\t\t\t"AccentColor":"cd1818",\n\t\t\t\t"BackgroundColor":"202020",\n\t\t\t\t"OutlineColor":"2a2a2a",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
                Dark = {
                    1,
                    httpService:JSONDecode('{\n\t\t\t\t"FontColor":"ffffff",\n\t\t\t\t"MainColor":"0a0a0a",\n\t\t\t\t"AccentColor":"5945ff",\n\t\t\t\t"BackgroundColor":"0a0a0a",\n\t\t\t\t"OutlineColor":"171717",\n\t\t\t\t"RiskColor":"e50000",\n\n\t\t\t\t"ItemType":"Unnamed Enhancements - Cracked",\n\t\t\t\t"SwordColor":"ffffff",\n\t\t\t\t"SwordTransparency":"0",\n\t\t\t\t"SwordReflectance":"0",\n\t\t\t\t"SwordSpeed":"0.15",\n\t\t\t\t"SwordMaterial":"Neon",\n\n\t\t\t\t"Contrast":"0",\n\t\t\t\t"Saturation":"0",\n\t\t\t\t"Brightness":"0",\n\n\n\t\t\t\t"BackColor":"000000",\n\t\t\t\t"BlurSize":"15",\n\t\t\t\t"BackTransparency":"0.7"\n\t\t\t}'),
                },
            }

            function themeManager:ApplyTheme(themeName)
                if not themeName then
                    return
                end

                local value012 = self:GetCustomTheme(themeName)
                local value013 = value012 or self.BuiltInThemes[themeName]

                if not value013 then
                    return
                end
                if self.Library.InnerVideoBackground ~= nil then
                    self.Library.InnerVideoBackground.Visible = false
                end

                local value014 = value013[2]

                for key, value in next, value012 or value014 do
                    __step(2052)

                    if key:find('Color') then
                        self.Library[key] = Color3.fromHex(value)

                        if capture00[key] then
                            capture00[key]:SetValueRGB(Color3.fromHex(value))
                        end
                    else
                        self.Library[key] = value

                        if capture00[key] then
                            capture00[key]:SetValue(value)
                        end
                    end
                end

                self:ThemeUpdate()
            end
            function themeManager:ThemeUpdate()
                if self.Library.InnerVideoBackground ~= nil then
                    self.Library.InnerVideoBackground.Visible = false
                end

                local value018 = {
                    'Contrast',
                    'Saturation',
                    'Brightness',
                    'BlurSize',
                    'FontColor',
                    'RiskColor',
                    'MainColor',
                    'AccentColor',
                    'BackgroundColor',
                    capture02[3][capture02[2] ],
                    'SwordColor',
                    'ItemType',
                    'BackTransparency',
                    'BackColor',
                    'SwordTransparency',
                    'SwordReflectance',
                    'SwordMaterial',
                    'SwordSpeed',
                }

                for key2, value2 in next, value018 do
                    __step(2053)

                    if capture00 and capture00[value2] then
                        self.Library[value2] = capture00[value2].Value
                    end
                end

                self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)

                self.Library:UpdateColorsUsingRegistry()
            end
            function themeManager:LoadDefault()
                local value022 = 'Default'
                local value023 = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')
                local value024 = true

                if value023 then
                    if self.BuiltInThemes[value023] then
                        value022 = value023
                    elseif self:GetCustomTheme(value023) then
                        value022 = value023
                        value024 = false
                    end
                elseif self.BuiltInThemes[self.DefaultTheme] then
                    value022 = self.DefaultTheme
                end
                if value024 then
                    capture00.ThemeManager_ThemeList:SetValue(value022)
                else
                    self:ApplyTheme(value022)
                end
            end
            function themeManager:SaveDefault(themeName2)
                writefile(self.Folder .. '/themes/default.txt', themeName2)
            end
            function themeManager:Delete(fileName)
                if not fileName then
                    return false, 'no config file is selected'
                end

                local value029 = self.Folder .. '/themes/' .. fileName

                if not isfile(value029) then
                    return false, 'invalid file'
                end

                local success, resultOrError = pcall(delfile, value029)

                if not success then
                    return false, 'delete file error'
                end

                return true
            end
            function themeManager:GetCustomTheme(fileName2)
                if not fileName2 then
                    return
                end

                local value034 = self.Folder .. '/themes/' .. fileName2

                if not isfile(value034) then
                    return nil
                end

                local value035 = readfile(value034)
                local success2, resultOrError2 = pcall(httpService.JSONDecode, httpService, value035)

                if not success2 then
                    return nil
                end

                return resultOrError2
            end
            function themeManager:SaveCustomTheme(fileName3)
                if not fileName3 or fileName3:gsub(' ', '') == '' then
                    return self.Library:Notify('Invalid file name for theme (empty)', 3)
                end

                local value040 = {}
                local value041 = {
                    'Contrast',
                    'Saturation',
                    'Brightness',
                    'BlurSize',
                    'FontColor',
                    'RiskColor',
                    'MainColor',
                    'AccentColor',
                    'BackgroundColor',
                    capture02[3][capture02[2] ],
                    'ItemType',
                    'SwordColor',
                    'BackTransparency',
                    'BackColor',
                    'SwordTransparency',
                    'SwordReflectance',
                    'SwordMaterial',
                    'SwordSpeed',
                }

                for key3, value3 in next, value041 do
                    __step(2054)

                    if capture00[value3] then
                        if not value3:find('Color') then
                            value040[value3] = capture00[value3].Value
                        else
                            value040[value3] = capture00[value3].Value:ToHex()
                        end
                    end
                end

                writefile(self.Folder .. '/themes/' .. fileName3, httpService:JSONEncode(value040))
            end
            function themeManager:ReloadCustomThemes()
                local value045 = listfiles(self.Folder .. '/themes')
                local value046 = {}

                for index = 1, #value045 do
                    __step(2055)

                    local value048 = value045[index]

                    if value048:sub(-5) == '.json' then
                        local matchStart = value048:find('.json', 1, true)
                        local value050 = value048:sub(matchStart, matchStart)

                        while value050 ~= '/' and value050 ~= '\\' and value050 ~= '' do
                            __step(2056)

                            matchStart = matchStart - 1
                            value050 = value048:sub(matchStart, matchStart)
                        end

                        if value050 == '/' or value050 == '\\' then
                            table.insert(value046, value048:sub(matchStart + 1))
                        end
                    end
                end

                return value046
            end
            function themeManager:SetLibrary(library)
                self.Library = library
            end
            function themeManager:BuildFolderTree()
                local value054 = {}
                local value055 = self.Folder:split('/')

                for index2 = 1, #value055 do
                    __step(2057)

                    value054[#value054 + 1] = table.concat(value055, '/', 1, index2)
                end

                table.insert(value054, self.Folder .. '/themes')

                for index3 = 1, #value054 do
                    __step(2058)

                    local value058 = value054[index3]

                    if not isfolder(value058) then
                        makefolder(value058)
                    end
                end
            end
            function themeManager:SetFolder(folder)
                self.Folder = folder

                self:BuildFolderTree()
            end
            function themeManager:CreateGroupBox(tab)
                assert(self.Library, 'Must set ThemeManager.Library first!')

                return tab:AddLeftTabbox()
            end
            function themeManager:ApplyToTab(tab2)
                assert(self.Library, 'Must set ThemeManager.Library first!')

                local value065 = self:CreateGroupBox(tab2)

                self:CreateThemeManager(value065)
            end
            function themeManager:ApplyToGroupbox(groupbox)
                assert(self.Library, 'Must set ThemeManager.Library first!')
                self:CreateThemeManager(groupbox)
            end
        end

        getgenv().ThemeManager = themeManager
    end
end
function Native.keyPicker(captures)
    local capture07 = captures[7]
    local capture09 = captures[9]
    local capture03 = captures[3]
    local capture02 = captures[2]
    local capture08 = captures[8]
    local capture00 = captures[0]
    local capture06 = captures[6]
    local capture05 = captures[5]
    local capture04 = captures[4]
    local capture10 = captures[10]
    local capture01 = captures[1]

    return function()
        local value013 = capture03.Modes or {
            'Always',
            'Toggle',
            'Hold',
        }
        local value014 = capture04:AddContextMenu(capture02)
        local value015 = {}

        for key, value in value013 do
            __step(49)

            local value018

            value018 = value014:AddOption(value, function()
                capture00.Mode = value
                value018.TextColor3 = capture04.AccentColor

                for key2, value2 in value015 do
                    __step(50)

                    if value2 ~= value018 then
                        value2.TextColor3 = key2 == capture00.Mode and capture04.AccentColor or capture04.FontColor
                    end
                end

                capture04:AttemptSave()
            end)

            value018:GetPropertyChangedSignal('TextColor3'):Connect(function()
                if value == capture00.Mode then
                    value018.TextColor3 = capture04.AccentColor
                else
                    value018.TextColor3 = capture04.FontColor
                end
            end)

            value015[value] = value018
        end

        if capture04.FlagCopying then
            value014:AddOption('Copy Flag', function()
                pcall(setclipboard, capture00.Idx)
                task.wait()
                capture04:Notify('Copied flag to clipboard!', 2)
                value014:Hide()
            end)
        end

        for key3, value3 in value015 do
            __step(51)

            value3.TextColor3 = key3 == capture00.Mode and capture04.AccentColor or capture04.FontColor
        end

        local value023 = function(value024)
            local mode = capture00.Mode

            mode = mode ~= 'Always' and capture00.Override and 'Override' or mode
            capture05.Text = string.format('[%s] %s (%s)', capture00.Value, capture03.Text, mode)
            capture05.Visible = true
            capture05.TextColor3 = value024 and capture04.AccentColor or capture04.FontColor
            capture04.RegistryMap[capture05].Properties.TextColor3 = value024 and 'AccentColor' or 'FontColor'
        end

        function capture00:Update()
            if not capture00.NoUI then
                local keypickerListMode = capture04.KeypickerListMode
                local value028 = capture00:GetState()

                if keypickerListMode == 'Active' and capture00.Parent.Type == 'Toggle' and (not value028 or not capture00.Parent.Value) then
                    capture05.Visible = false
                elseif keypickerListMode == 'Toggled' and capture00.Parent.Type == 'Toggle' and not capture00.Parent.Value then
                    capture05.Visible = false
                else
                    value023(value028)
                end
            else
                capture05.Visible = false
            end

            local value029 = 0
            local value030 = 0

            for key4, value4 in next, capture04.KeybindContainer:GetChildren()do
                __step(52)

                if value4:IsA('TextLabel') and value4.Visible then
                    value029 = value029 + 18

                    if value4.TextBounds.X > value030 then
                        value030 = value4.TextBounds.X
                    end
                end
            end

            capture04.KeybindFrame.Size = UDim2.new(0, math.max(value030 + 10, 210), 0, value029 + 23)
            capture04.KeybindFrame.Visible = capture04.KeypickerListVisible and value029 ~= 0
        end
        function capture00:OverrideState(overrideState)
            if self.Override == overrideState then
                return
            end

            self.Override = overrideState
            capture00.Toggled = false

            capture00:Update()
        end

        local isMouseButtonPressed, isKeyDown = capture01.IsMouseButtonPressed, capture01.IsKeyDown
        local mouseButton1, mouseButton2 = Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2
        local keyCode = Enum.KeyCode

        function capture00:GetState()
            local mode2 = capture00.Mode

            if mode2 == 'Always' then
                return true
            end

            local value7 = capture00.Value

            if value7 == '...' then
                return true
            end

            local value043 = nil

            if mode2 == 'Hold' then
                if value7 == 'MB1' or value7 == 'MB2' then
                    value043 = value7 == 'MB1' and isMouseButtonPressed(capture01, mouseButton1) or value7 == 'MB2' and isMouseButtonPressed(capture01, mouseButton2)
                else
                    value043 = isKeyDown(capture01, keyCode[value7])
                end
            else
                value043 = capture00.Toggled
            end
            if value043 and self.Override then
                capture00:OverrideState(false)
            end

            return value043 or self.Override
        end
        function capture00:SetValue(newValue)
            local value046, value047 = newValue[1], newValue[2]

            capture07.Text = value046
            capture00.Value, capture00.Mode = value046, value047

            for key5, value5 in value015 do
                __step(53)

                value5.TextColor3 = key5 == capture00.Mode and capture04.AccentColor or capture04.FontColor
            end

            capture00:Update()
        end
        function capture00:OnClick(callback)
            capture00.Clicked = callback
        end
        function capture00:OnChanged(callback2)
            capture00.Changed = callback2

            callback2(capture00.Value)
        end

        if capture08.Addons then
            table.insert(capture08.Addons, capture00)
        end

        function capture00:DoClick()
            if capture00.Override then
                capture00.Override = false
                capture00.Toggled = false
            end
            if capture08.Type == 'Toggle' and capture00.SyncToggleState then
                capture08:SetValue(not capture08.Value)
            end

            capture04:SafeCallback(capture00.Callback, capture00.Toggled)
            capture04:SafeCallback(capture00.Clicked, capture00.Toggled)
        end
        function capture00:SetupConnection(connection)
            table.insert(self.Connections, connection)
            capture04:GiveSignal(connection)
        end
        function capture00:Remove()
            capture10[capture06] = nil

            for key6, value6 in capture00.Connections do
                __step(54)
                value6:Disconnect()
            end

            table.clear(capture00)
            capture02:Destroy()
            capture05:Destroy()
        end
        function capture00:SetModePickerVisibility(visible)
            capture09.Visible = visible
        end
        function capture00:GetModePickerVisibility()
            return capture09.Visible
        end

        local value063 = false
        local value064 = {
            [Enum.KeyCode.Escape] = true,
            [Enum.KeyCode.Backspace] = true,
        }

        capture02.InputBegan:Connect(function(input)
            if not value063 and input.UserInputType == Enum.UserInputType.MouseButton1 and not capture04:MouseIsOverOpenedFrame() then
                value063 = true
                capture07.Text = ''

                local value066
                local value067 = ''

                task.spawn(function()
                    while not value066 do
                        __step(55)

                        if value067 == '...' then
                            value067 = ''
                        end

                        value067 = value067 .. '.'
                        capture07.Text = value067

                        wait(0.4)
                    end
                end)
                wait(0.2)

                local value068

                value068 = capture01.InputBegan:Connect(function(input2)
                    local value070

                    if input2.UserInputType == Enum.UserInputType.Keyboard then
                        value070 = value064[input2.KeyCode] and '...' or input2.KeyCode.Name
                    elseif input2.UserInputType == Enum.UserInputType.MouseButton1 then
                        value070 = 'MB1'
                    elseif input2.UserInputType == Enum.UserInputType.MouseButton2 then
                        value070 = 'MB2'
                    end

                    value066 = true
                    value063 = false
                    capture07.Text = value070
                    capture00.Value = value070

                    capture04:SafeCallback(capture00.ChangedCallback, input2.KeyCode or input2.UserInputType)
                    capture04:SafeCallback(capture00.Changed, input2.KeyCode or input2.UserInputType)
                    capture04:AttemptSave()
                    value068:Disconnect()
                end)
            end
        end)
        capture00:SetupConnection(capture01.InputBegan:Connect(function(input3, gameProcessed)
            if not value063 and not gameProcessed then
                if capture00.Mode == 'Toggle' then
                    local value8 = capture00.Value

                    if value8 == 'MB1' or value8 == 'MB2' then
                        if value8 == 'MB1' and input3.UserInputType == Enum.UserInputType.MouseButton1 or value8 == 'MB2' and input3.UserInputType == Enum.UserInputType.MouseButton2 then
                            capture00.Toggled = not capture00.Toggled

                            capture00:DoClick()
                        end
                    elseif input3.UserInputType == Enum.UserInputType.Keyboard then
                        if input3.KeyCode.Name == value8 then
                            capture00.Toggled = not capture00.Toggled

                            capture00:DoClick()
                        end
                    end
                end

                capture00:Update()
            end
        end))
        capture00:SetupConnection(capture01.InputEnded:Connect(function(input4)
            if not value063 then
                capture00:Update()
            end
        end))
        capture00:Update()

        capture10[capture06] = capture00
    end
end
function Native.toggle(captures)
    local capture10 = captures[10]
    local capture01 = captures[1]
    local capture06 = captures[6]
    local capture12 = captures[12]
    local capture11 = captures[11]
    local capture13 = captures[13]
    local capture09 = captures[9]
    local capture07 = captures[7]
    local capture05 = captures[5]
    local capture02 = captures[2]
    local capture03 = captures[3]
    local capture04 = captures[4]
    local capture14 = captures[14]
    local capture08 = captures[8]
    local capture00 = captures[0]

    return function()
        function capture00:Display()
            capture02.BackgroundColor3 = capture00.Value and capture03.AccentColor or capture03.MainColor
            capture02.BorderColor3 = capture00.Value and capture03.AccentColorDark or capture03.OutlineColor
            capture03.RegistryMap[capture02].Properties.BackgroundColor3 = capture00.Value and 'AccentColor' or 'MainColor'
            capture03.RegistryMap[capture02].Properties.BorderColor3 = capture00.Value and 'AccentColorDark' or capture13[3][capture13[2] ]
        end

        capture00.UpdateColors = capture00.Display

        function capture00:OnChanged(callback)
            table.insert(capture00.ChangedFuncs, callback)
            callback(capture00.Value)
        end
        function capture00:SetValue(newValue)
            if capture00.SettingValue then
                return
            end

            capture00.SettingValue = true
            newValue = not not newValue
            capture00.Value = newValue

            capture00:Display()

            for key, value in next, capture00.Addons do
                __step(26)

                if value.Type == 'KeyPicker' and value.SyncToggleState then
                    value.Toggled = newValue

                    value:Update()
                end
            end

            capture03:SafeCallback(capture00.Callback, newValue)

            for key2, value2 in capture00.ChangedFuncs do
                __step(27)
                capture03:SafeCallback(value2, newValue)
            end

            capture03:UpdateDependencyBoxes()

            capture00.SettingValue = false
        end
        function capture00:SetVisible(visible)
            capture00.Visible = visible
            capture04.Visible = capture00.Visible

            if Blank then
                Blank.Visible = capture00.Visible
            end

            capture01:Resize()
        end
        function capture00:Remove()
            for key3, value3 in capture07 do
                __step(28)
                value3:Destroy()
            end

            capture09[capture05] = nil

            capture06:Destroy()
            table.clear(capture00)
            capture01:Resize()
        end

        capture10.InputBegan:Connect(function(input)
            if capture03.IsDragging then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not capture03:MouseIsOverOpenedFrame() or input.UserInputType == Enum.UserInputType.Touch then
                capture00:SetValue(not capture00.Value)
                capture03:AttemptSave()
            end
        end)

        if capture03.FlagCopying then
            local value032 = capture03:AddContextMenu(capture04, capture10)

            value032:AddOption('Copy Flag', function()
                pcall(setclipboard, capture00.Idx)
                task.wait()
                capture03:Notify('Copied flag to clipboard!', 2)
                value032:Hide()
            end)
        end
        if capture00.Risky then
            capture03:RemoveFromRegistry(capture08)

            capture08.TextColor3 = capture03.RiskColor

            capture03:AddToRegistry(capture08, {
                TextColor3 = 'RiskColor',
            })
        end

        capture00:Display()
        table.insert(capture07, capture01:AddBlank(capture11.BlankSize or 7))
        capture01:Resize()

        capture00.ColorPickerCount = 0
        capture00.ToggleRegion = capture10
        capture00.TextLabel = capture08
        capture00.Container = capture12

        setmetatable(capture00, capture14)

        capture09[capture05] = capture00

        capture03:UpdateDependencyBoxes()
    end
end
function Native.slider(captures)
    local capture04 = captures[4]
    local capture03 = captures[3]
    local capture06 = captures[6]
    local capture11 = captures[11]
    local capture02 = captures[2]
    local capture08 = captures[8]
    local userInputService = captures[16]
    local capture10 = captures[10]
    local capture07 = captures[7]
    local capture00 = captures[0]
    local capture13 = captures[13]
    local slider = captures[1]
    local capture05 = captures[5]
    local capture12 = captures[12]
    local capture15 = captures[15]
    local capture17 = captures[17]
    local capture14 = captures[14]
    local capture09 = captures[9]

    return function()
        function slider:UpdateColors()
            capture03.BackgroundColor3 = capture07.AccentColor
            capture03.BorderColor3 = capture07.AccentColorDark
        end
        function slider:Display()
            local value022 = capture04.Suffix or ''

            if capture04.Compact then
                capture10.Text = capture04.Text .. ': ' .. slider.Value .. value022
            elseif capture04.HideMax then
                capture10.Text = string.format('%s', slider.Value .. value022)
            else
                capture10.Text = string.format('%s/%s', slider.Value .. value022, slider.Max .. value022)
            end

            local value023 = capture07:MapValue(slider.Value, slider.Min, slider.Max, 0, 1)

            if capture05[3][capture05[2] ] then
                capture05[3][capture05[2] ]:Cancel()
            end

            capture05[3][capture05[2] ] = capture09:Create(capture03, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(value023, 0, 1, 0),
            })

            capture05[3][capture05[2] ]:Play()

            capture08.Visible = not (value023 == 1 or value023 == 0)
        end
        function slider:OnChanged(callback)
            table.insert(slider.ChangedFuncs, callback)
            callback(slider.Value)
        end

        local function value026(value027)
            if slider.Increment then
                local value028 = math.round(value027 / slider.Increment) * slider.Increment

                return tonumber(string.format('%.10f', value028))
            elseif slider.Rounding == 0 then
                return math.floor(value027)
            end

            return tonumber(string.format('%.' .. slider.Rounding .. 'f', value027))
        end

        function slider:GetValueFromXOffset(offsetX)
            return value026(capture07:MapValue(offsetX, 0, slider.MaxSize, slider.Min, slider.Max)) + 0
        end
        function slider:Remove()
            for key, value in capture15 do
                __step(32)
                value:Destroy()
            end

            capture14[capture13] = nil

            slider.HolderFrame:Destroy()
            table.clear(slider)
            capture00:Resize()
        end
        function slider:SetValue(newValue)
            local value036 = tonumber(newValue)

            if not value036 then
                return
            end

            value036 = math.clamp(value036, slider.Min, slider.Max)
            slider.Value = value036

            slider:Display()
            capture07:SafeCallback(slider.Callback, slider.Value)

            for key2, value2 in self.ChangedFuncs do
                __step(33)
                capture07:SafeCallback(value2, value036)
            end
        end
        function slider:AddSlider(value040, value041)
            return capture11.AddSlider(capture00, value040, value041, slider)
        end

        capture12.InputBegan:Connect(function(input)
            if capture07.IsDragging then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not capture07:MouseIsOverOpenedFrame() then
                local value043 = capture06.X
                local offset = capture03.Size.X.Offset
                local value045 = value043 - (capture03.AbsolutePosition.X + offset)

                while(userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) do
                    __step(34)

                    local value046 = capture06.X
                    local value047 = math.clamp(offset + (value046 - value043) + value045, 0, slider.MaxSize)
                    local value048 = slider:GetValueFromXOffset(value047)
                    local value5 = slider.Value

                    slider.Value = value048

                    slider:Display()

                    if value048 ~= value5 then
                        capture07:SafeCallback(slider.Callback, slider.Value)

                        for key3, value3 in slider.ChangedFuncs do
                            __step(35)
                            capture07:SafeCallback(value3, value048)
                        end
                    end

                    capture17:Wait()
                end

                capture07:AttemptSave()
            end
            if input.UserInputType == Enum.UserInputType.Touch and not capture07:MouseIsOverOpenedFrame() then
                local value052 = input.Position.X
                local offset2 = capture03.Size.X.Offset
                local value054 = value052 - (capture03.AbsolutePosition.X + offset2)
                local value055 = true
                local value056

                value056 = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        value055 = false
                    end
                end)

                while value055 do
                    __step(36)

                    local value057 = input.Position.X
                    local value058 = math.clamp(offset2 + (value057 - value052) + value054, 0, slider.MaxSize)
                    local value059 = slider:GetValueFromXOffset(value058)
                    local value6 = slider.Value

                    slider.Value = value059

                    slider:Display()

                    if value059 ~= value6 then
                        capture07:SafeCallback(slider.Callback, slider.Value)

                        for key4, value4 in slider.ChangedFuncs do
                            __step(37)
                            capture07:SafeCallback(value4, value059)
                        end
                    end

                    capture17:Wait()
                end

                if value056 then
                    value056:Disconnect()
                end

                capture07:AttemptSave()
            end
        end)

        if capture07.FlagCopying then
            local value063 = capture07:AddContextMenu(capture12)

            value063:AddOption('Copy Flag', function()
                pcall(setclipboard, slider.Idx)
                task.wait()
                capture07:Notify('Copied flag to clipboard!', 2)
                value063:Hide()
            end)
        end

        slider:Display()

        if not capture02 then
            table.insert(capture15, capture00:AddBlank(capture04.BlankSize or 6))
            capture00:Resize()
        end

        capture14[capture13] = slider
    end
end
function Native.dropdown(captures)
    local capture07 = captures[7]
    local capture06 = captures[6]
    local dropdown = captures[0]
    local capture02 = captures[2]
    local capture09 = captures[9]
    local capture13 = captures[13]
    local capture14 = captures[14]
    local capture10 = captures[10]
    local capture04 = captures[4]
    local capture11 = captures[11]
    local capture15 = captures[15]
    local capture12 = captures[12]
    local capture08 = captures[8]
    local capture03 = captures[3]
    local capture05 = captures[5]
    local capture01 = captures[1]

    return function()
        local function value018()
            capture02.Position = UDim2.fromOffset(capture08.AbsolutePosition.X, capture08.AbsolutePosition.Y + capture08.Size.Y.Offset + 1)
        end
        local function value019(value020)
            local value021 = value020 or math.clamp(#dropdown.Values * 20, 0, capture07 * 20) + 1

            capture02.Size = UDim2.fromOffset(capture08.AbsoluteSize.X + 0.5, value021)
        end

        value018()
        value019()
        capture08:GetPropertyChangedSignal('AbsolutePosition'):Connect(value018)

        local value022 = capture01:Create(capture15[3][capture15[2] ], {
            BackgroundColor3 = capture01.MainColor,
            BorderColor3 = capture01.OutlineColor,
            BorderMode = Enum.BorderMode.Inset,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 21,
            Parent = capture02,
        })

        capture01:AddToRegistry(value022, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = capture04[3][capture04[2] ],
        })

        local scrollingFrame = capture01:Create('ScrollingFrame', {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 21,
            Parent = value022,
            TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ScrollBarThickness = capture01.IsMobile and 15 or 3,
            ScrollBarImageColor3 = capture01.AccentColor,
        })

        capture01:AddToRegistry(scrollingFrame, {
            ScrollBarImageColor3 = 'AccentColor',
        })
        capture01:Create('UIListLayout', {
            Padding = UDim.new(0, 0),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = scrollingFrame,
        })

        function dropdown:Display()
            local values = dropdown.Values
            local value026 = ''

            if capture03.Multi then
                for key, value in next, values do
                    __step(111)

                    if dropdown.Value[value] then
                        value026 = value026 .. value .. ', '
                    end
                end

                value026 = value026:sub(1, #value026 - 2)
            else
                value026 = dropdown.Value or ''
            end

            capture11.Text = value026 == '' and '...' or value026
        end
        function dropdown:GetActiveValues()
            if capture03.Multi then
                local value030 = {}

                for key2, value2 in next, dropdown.Value do
                    __step(112)
                    table.insert(value030, key2)
                end

                return value030
            else
                return dropdown.Value and 1 or 0
            end
        end
        function dropdown:BuildDropdownList()
            local values2 = dropdown.Values
            local value035 = {}

            for key3, value3 in next, scrollingFrame:GetChildren()do
                __step(113)

                if not value3:IsA('UIListLayout') then
                    value3:Destroy()
                end
            end

            local value038 = 0

            for key4, value4 in next, values2 do
                __step(114)

                local value041 = {}

                value038 = value038 + 1

                local imageButton = capture01:Create('ImageButton', {
                    BackgroundColor3 = capture01.MainColor,
                    BorderColor3 = capture01.OutlineColor,
                    BorderMode = Enum.BorderMode.Middle,
                    Size = UDim2.new(1, -1, 0, 20),
                    ZIndex = 23,
                    Active = true,
                    Parent = scrollingFrame,
                    Image = '',
                    Active = false,
                    AutoButtonColor = false,
                })

                capture01:AddToRegistry(imageButton, {
                    BackgroundColor3 = 'MainColor',
                    BorderColor3 = capture04[3][capture04[2] ],
                })

                local value043 = capture01:CreateLabel({
                    Active = false,
                    Size = UDim2.new(1, -6, 1, 0),
                    Position = UDim2.new(0, 6, 0, 0),
                    TextSize = 14,
                    Text = value4,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 25,
                    Parent = imageButton,
                })

                capture01:OnHighlight(imageButton, imageButton, {
                    BorderColor3 = capture04[3][capture04[2] ],
                    ZIndex = 24,
                }, {
                    BorderColor3 = capture04[3][capture04[2] ],
                    ZIndex = 23,
                })

                local value044

                if capture03.Multi then
                    value044 = dropdown.Value[value4]
                else
                    value044 = dropdown.Value == value4
                end

                function value041:UpdateButton()
                    if capture03.Multi then
                        value044 = dropdown.Value[value4]
                    else
                        value044 = dropdown.Value == value4
                    end

                    value043.TextColor3 = value044 and capture01.AccentColor or capture01.FontColor
                    capture01.RegistryMap[value043].Properties.TextColor3 = value044 and 'AccentColor' or 'FontColor'
                end

                value043.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        local value047 = not value044

                        if dropdown:GetActiveValues() == 1 and not value047 and not capture03.AllowNull then
                        else
                            if capture03.Multi then
                                value044 = value047

                                if value044 then
                                    dropdown.Value[value4] = true
                                else
                                    dropdown.Value[value4] = nil
                                end
                            else
                                value044 = value047

                                if value044 then
                                    dropdown.Value = value4
                                else
                                    dropdown.Value = nil
                                end

                                for key5, value5 in next, value035 do
                                    __step(115)
                                    value5:UpdateButton()
                                end
                            end

                            value041:UpdateButton()
                            dropdown:Display()
                            capture01:UpdateDependencyBoxes()
                            capture01:SafeCallback(dropdown.Callback, dropdown.Value)
                            capture01:SafeCallback(dropdown.Changed, dropdown.Value)
                            capture01:AttemptSave()
                        end
                    end
                end)
                value041:UpdateButton()

                value035[imageButton] = value041
            end

            dropdown:Display()

            scrollingFrame.CanvasSize = UDim2.fromOffset(0, value038 * 20 + 1)
            scrollingFrame.Visible = false
            scrollingFrame.Visible = true

            local value050 = math.clamp(value038 * 20, 0, capture07 * 20) + 1

            value019(value050)
        end
        function dropdown:SetValues(values3)
            if values3 then
                dropdown.Values = values3
            end

            dropdown:BuildDropdownList()
        end
        function dropdown:OpenDropdown()
            if capture01.IsMobile then
                capture01.CanDrag = false
            end

            capture02.Visible = true
            capture01.OpenedFrames[capture02] = true
            capture10.Rotation = 90

            value019()
        end
        function dropdown:CloseDropdown()
            if capture01.IsMobile then
                capture01.CanDrag = true
            end

            capture02.Visible = false
            capture01.OpenedFrames[capture02] = nil
            capture10.Rotation = 0
        end
        function dropdown:OnChanged(callback)
            dropdown.Changed = callback

            callback(dropdown.Value)
        end
        function dropdown:SetValue(newValue)
            if dropdown.Multi then
                local value059 = {}

                for key6, value6 in next, newValue do
                    __step(116)

                    if dropdown.Illegal or table.find(dropdown.Values, key6) then
                        value059[key6] = true
                    end
                end

                dropdown.Value = value059
            elseif not newValue then
                dropdown.Value = nil
            elseif dropdown.Illegal or table.find(dropdown.Values, newValue) then
                dropdown.Value = newValue
            end

            dropdown:BuildDropdownList()
            capture01:SafeCallback(dropdown.Callback, dropdown.Value)
            capture01:SafeCallback(dropdown.Changed, dropdown.Value)
        end
        function dropdown:Remove()
            for key7, value7 in capture13 do
                __step(117)
                value7:Destroy()
            end

            capture06[capture12] = nil

            capture08:Destroy()
            table.clear(dropdown)
        end

        capture08.InputBegan:Connect(function(input2)
            if capture01.IsDragging then
                return
            end
            if input2.UserInputType == Enum.UserInputType.MouseButton1 and not capture01:MouseIsOverOpenedFrame() or input2.UserInputType == Enum.UserInputType.Touch then
                if capture02.Visible then
                    dropdown:CloseDropdown()
                else
                    dropdown:OpenDropdown()
                end
            end
        end)
        capture14.InputBegan:Connect(function(input3)
            if capture01.IsDragging then
                return
            end
            if input3.UserInputType == Enum.UserInputType.MouseButton1 or input3.UserInputType == Enum.UserInputType.Touch then
                local absolutePosition, absoluteSize = capture02.AbsolutePosition, capture02.AbsoluteSize

                if capture09.X < absolutePosition.X or capture09.X > absolutePosition.X + absoluteSize.X or capture09.Y < absolutePosition.Y - 20 - 1 or capture09.Y > absolutePosition.Y + absoluteSize.Y then
                    dropdown:CloseDropdown()
                end
            end
        end)

        if capture01.FlagCopying then
            local value069 = capture01:AddContextMenu(capture08)

            value069:AddOption('Copy Flag', function()
                pcall(setclipboard, dropdown.Idx)
                task.wait()
                capture01:Notify('Copied flag to clipboard!', 2)
                value069:Hide()
            end)
        end

        dropdown:BuildDropdownList()
        dropdown:Display()

        local value070 = {}

        if typeof(capture03.Default) == 'string' then
            local matchStart = table.find(dropdown.Values, capture03.Default)

            if matchStart then
                table.insert(value070, matchStart)
            end
        elseif typeof(capture03.Default) == 'table' then
            for key8, value8 in next, capture03.Default do
                __step(118)

                local matchStart2 = table.find(dropdown.Values, value8)

                if matchStart2 then
                    table.insert(value070, matchStart2)
                end
            end
        elseif typeof(capture03.Default) == 'number' and dropdown.Values[capture03.Default] ~= nil then
            table.insert(value070, capture03.Default)
        end
        if next(value070) then
            for index = 1, #value070 do
                __step(119)

                local value076 = value070[index]

                if capture03.Multi then
                    dropdown.Value[dropdown.Values[value076] ] = true
                else
                    dropdown.Value = dropdown.Values[value076]
                end
                if not capture03.Multi then
                    break
                end
            end

            dropdown:BuildDropdownList()
            dropdown:Display()
        end

        table.insert(capture13, capture05:AddBlank(capture03.BlankSize or 5))
        capture05:Resize()

        capture06[capture12] = dropdown
    end
end
function Native.colorPicker(captures)
    local colorPicker = captures[0]
    local capture06 = captures[6]
    local capture10 = captures[10]
    local capture23 = captures[23]
    local capture07 = captures[7]
    local capture20 = captures[20]
    local capture01 = captures[1]
    local capture21 = captures[21]
    local capture08 = captures[8]
    local capture22 = captures[22]
    local capture18 = captures[18]
    local capture13 = captures[13]
    local userInputService = captures[17]
    local capture12 = captures[12]
    local capture11 = captures[11]
    local capture02 = captures[2]
    local capture09 = captures[9]
    local capture04 = captures[4]
    local capture15 = captures[15]
    local capture16 = captures[16]
    local capture14 = captures[14]
    local capture19 = captures[19]
    local capture05 = captures[5]
    local capture24 = captures[24]
    local capture03 = captures[3]

    return function()
        local value027 = capture03:AddContextMenu(capture15)

        value027:AddOption('Make gradient', function()
            local value028 = {}

            for key, value in capture18.Addons do
                __step(131)

                if value.Type == 'ColorPicker' then
                    table.insert(value028, value)
                end
            end

            if #value028 < 3 then
                value027:Hide()

                return capture03:Notify('not enough colors for a gradient.', 2)
            end

            local value6, value7 = value028[1].Value, value028[#value028].Value

            for index = 2, #value028 - 1 do
                __step(132)

                local value034 = value028[index]

                value034:SetValueRGB(value6:Lerp(value7, index / #value028), value034.Transparency)
            end

            capture03:Notify('created gradient!', 2)
            value027:Hide()
        end)
        value027:AddOption('Match color', function()
            local value035 = {}

            for key2, value2 in capture18.Addons do
                __step(133)

                if value2.Type == 'ColorPicker' then
                    table.insert(value035, value2)
                end
            end
            for key3, value3 in value035 do
                __step(134)
                value3:SetValueRGB(colorPicker.Value, value3.Transparency)
            end

            capture03:Notify('matched all colors!', 2)
            value027:Hide()
        end)
        value027:AddOption('Copy color', function()
            capture03.ColorClipboard = colorPicker

            capture03:Notify('Copied color!', 2)
            value027:Hide()
        end)
        value027:AddOption('Paste color', function()
            if not capture03.ColorClipboard then
                return capture03:Notify('You have not copied a color!', 2)
            end

            colorPicker:SetValueRGB(capture03.ColorClipboard.Value, capture03.ColorClipboard.Transparency)
            value027:Hide()
        end)

        if capture03.FlagCopying then
            value027:AddOption('Copy Flag', function()
                pcall(setclipboard, colorPicker.Idx)
                task.wait()
                capture03:Notify('Copied flag to clipboard!', 2)
                value027:Hide()
            end)
        end

        capture03:AddToRegistry(capture13, {
            BackgroundColor3 = 'BackgroundColor',
            BorderColor3 = capture02[3][capture02[2] ],
        })
        capture03:AddToRegistry(capture16, {
            BackgroundColor3 = 'AccentColor',
        })
        capture03:AddToRegistry(capture21, {
            BackgroundColor3 = 'BackgroundColor',
            BorderColor3 = capture02[3][capture02[2] ],
        })
        capture03:AddToRegistry(capture20, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = capture02[3][capture02[2] ],
        })
        capture03:AddToRegistry(capture24.Frame, {
            BackgroundColor3 = 'MainColor',
            BorderColor3 = capture02[3][capture02[2] ],
        })
        capture03:AddToRegistry(capture06, {
            TextColor3 = 'FontColor',
        })
        capture03:AddToRegistry(capture07, {
            TextColor3 = 'FontColor',
        })

        local value040 = {}

        for index2 = 0, 1, 0.1 do
            __step(135)
            table.insert(value040, ColorSequenceKeypoint.new(index2, Color3.fromHSV(index2, 1, 1)))
        end

        local uIGradient = capture03:Create('UIGradient', {
            Color = ColorSequence.new(value040),
            Rotation = 90,
            Parent = capture11,
        })

        capture07.FocusLost:Connect(function(value043)
            if value043 then
                local success, resultOrError = pcall(Color3.fromHex, capture07.Text)

                if success and typeof(resultOrError) == 'Color3' then
                    colorPicker.Hue, colorPicker.Sat, colorPicker.Vib = Color3.toHSV(resultOrError)
                end
            end

            colorPicker:Display()
        end)
        capture06.FocusLost:Connect(function(value046)
            if value046 then
                local value047, value048, value049 = capture06.Text:match('(%d+),%s*(%d+),%s*(%d+)')

                if value047 and value048 and value049 then
                    colorPicker.Hue, colorPicker.Sat, colorPicker.Vib = Color3.toHSV(Color3.fromRGB(value047, value048, value049))
                end
            end

            colorPicker:Display()
        end)

        function colorPicker:Display()
            colorPicker.Value = Color3.fromHSV(colorPicker.Hue, colorPicker.Sat, colorPicker.Vib)
            capture12.BackgroundColor3 = Color3.fromHSV(colorPicker.Hue, 1, 1)

            capture03:Create(capture15, {
                BackgroundColor3 = colorPicker.Value,
                BackgroundTransparency = colorPicker.Transparency,
                BorderColor3 = capture03:GetDarkerColor(colorPicker.Value),
            })

            if capture14[3][capture14[2] ] then
                capture14[3][capture14[2] ].BackgroundColor3 = colorPicker.Value
                capture23[3][capture23[2] ].Position = UDim2.new(1 - colorPicker.Transparency, 0, 0, 0)
            end

            capture09.Position = UDim2.new(colorPicker.Sat, 0, 1 - colorPicker.Vib, 0)
            capture22.Position = UDim2.new(0, 0, colorPicker.Hue, 0)
            capture07.Text = '#' .. colorPicker.Value:ToHex()
            capture06.Text = table.concat({
                math.floor(colorPicker.Value.R * 255),
                math.floor(colorPicker.Value.G * 255),
                math.floor(colorPicker.Value.B * 255),
            }, ', ')

            capture03:SafeCallback(colorPicker.Callback, colorPicker.Value)
            capture03:SafeCallback(colorPicker.Changed, colorPicker.Value)
        end
        function colorPicker:OnChanged(callback)
            colorPicker.Changed = callback

            callback(colorPicker.Value)
        end

        local value053 = false

        function colorPicker:Show()
            value053 = true

            for key4, value4 in next, capture03.OpenedFrames do
                __step(136)

                if key4.Name == 'Color' then
                    key4.Visible = false
                    capture03.OpenedFrames[key4] = nil
                end
            end

            capture10.Visible = true
            capture03.OpenedFrames[capture10] = true
        end
        function colorPicker:Hide()
            value053 = false
            capture10.Visible = false
            capture03.OpenedFrames[capture10] = nil
        end
        function colorPicker:SetValue(newValue, value060)
            local value061 = Color3.fromHSV(newValue[1], newValue[2], newValue[3])

            colorPicker.Transparency = value060 or 0

            colorPicker:SetHSVFromRGB(value061)
            colorPicker:Display()
        end
        function colorPicker:Remove()
            capture08[capture19] = nil

            table.clear(colorPicker)
        end
        function colorPicker:SetValueRGB(color, transparency)
            colorPicker.Transparency = transparency or 0

            colorPicker:SetHSVFromRGB(color)
            colorPicker:Display()
        end

        capture12.InputBegan:Connect(function(input)
            if capture03.IsDragging then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local value067 = true
                local value068

                if input.UserInputType == Enum.UserInputType.Touch then
                    value068 = input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            value067 = false
                        end
                    end)
                end

                while value067 and (input.UserInputType == Enum.UserInputType.MouseButton1 and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or input.UserInputType == Enum.UserInputType.Touch) do
                    __step(137)

                    local value069 = input.UserInputType == Enum.UserInputType.MouseButton1 and capture05.X or input.Position.X
                    local value070 = input.UserInputType == Enum.UserInputType.MouseButton1 and capture05.Y or input.Position.Y
                    local value071, value072 = capture12.AbsolutePosition.X, capture12.AbsolutePosition.X + capture12.AbsoluteSize.X
                    local value073, value074 = capture12.AbsolutePosition.Y, capture12.AbsolutePosition.Y + capture12.AbsoluteSize.Y
                    local value075 = math.clamp(value069, value071, value072)
                    local value076 = math.clamp(value070, value073, value074)

                    colorPicker.Sat = (value075 - value071) / (value072 - value071)
                    colorPicker.Vib = 1 - (value076 - value073) / (value074 - value073)

                    colorPicker:Display()
                    capture01:Wait()
                end

                if value068 then
                    value068:Disconnect()
                end

                capture03:AttemptSave()
            end
        end)
        capture11.InputBegan:Connect(function(input2)
            if capture03.IsDragging then
                return
            end
            if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
                local value078 = true
                local value079

                if input2.UserInputType == Enum.UserInputType.Touch then
                    value079 = input2.Changed:Connect(function()
                        if input2.UserInputState == Enum.UserInputState.End then
                            value078 = false
                        end
                    end)
                end

                while value078 and (input2.UserInputType == Enum.UserInputType.MouseButton1 and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or input2.UserInputType == Enum.UserInputType.Touch) do
                    __step(138)

                    local value080 = input2.UserInputType == Enum.UserInputType.MouseButton1 and capture05.Y or input2.Position.Y
                    local value081, value082 = capture11.AbsolutePosition.Y, capture11.AbsolutePosition.Y + capture11.AbsoluteSize.Y
                    local value083 = math.clamp(value080, value081, value082)

                    colorPicker.Hue = (value083 - value081) / (value082 - value081)

                    colorPicker:Display()
                    capture01:Wait()
                end

                if value079 then
                    value079:Disconnect()
                end

                capture03:AttemptSave()
            end
        end)
        capture15.InputBegan:Connect(function(input3)
            if capture03.IsDragging then
                return
            end
            if input3.UserInputType == Enum.UserInputType.MouseButton1 or input3.UserInputType == Enum.UserInputType.Touch then
                if not capture03:MouseIsOverOpenedFrame() then
                    if capture10.Visible then
                        colorPicker:Hide()
                    else
                        colorPicker:Show()
                    end
                end
            elseif input3.UserInputType == Enum.UserInputType.MouseButton2 and not capture03:MouseIsOverOpenedFrame() then
                colorPicker:Hide()
            end
        end)

        if capture14[3][capture14[2] ] then
            capture14[3][capture14[2] ].InputBegan:Connect(function(input4)
                if capture03.IsDragging then
                    return
                end
                if input4.UserInputType == Enum.UserInputType.MouseButton1 or input4.UserInputType == Enum.UserInputType.Touch then
                    local value086 = true
                    local value087

                    if input4.UserInputType == Enum.UserInputType.Touch then
                        value087 = input4.Changed:Connect(function()
                            if input4.UserInputState == Enum.UserInputState.End then
                                value086 = false
                            end
                        end)
                    end

                    while value086 and (input4.UserInputType == Enum.UserInputType.MouseButton1 and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or input4.UserInputType == Enum.UserInputType.Touch) do
                        __step(139)

                        local value088 = input4.UserInputType == Enum.UserInputType.MouseButton1 and capture05.X or input4.Position.X
                        local value089, value090 = capture14[3][capture14[2] ].AbsolutePosition.X, capture14[3][capture14[2] ].AbsolutePosition.X + capture14[3][capture14[2] ].AbsoluteSize.X
                        local value091 = math.clamp(value088, value089, value090)

                        colorPicker.Transparency = 1 - (value091 - value089) / (value090 - value089)

                        colorPicker:Display()
                        capture01:Wait()
                    end

                    if value087 then
                        value087:Disconnect()
                    end

                    capture03:AttemptSave()
                end
            end)
        end

        local value092 = function()
            if not value053 then
                return
            end

            local absolutePosition, absoluteSize = capture10.AbsolutePosition, capture10.AbsoluteSize

            if capture05.X < absolutePosition.X or capture05.X > absolutePosition.X + absoluteSize.X or capture05.Y < absolutePosition.Y - 20 - 1 or capture05.Y > absolutePosition.Y + absoluteSize.Y then
                colorPicker:Hide()
            end
        end

        for key5, value5 in {
            Enum.UserInputType.MouseButton1,
            Enum.UserInputType.MouseButton2,
        }do
            __step(140)
            capture03:BindToInput(value5, value092)
        end

        colorPicker:Display()

        colorPicker.DisplayFrame = capture15
        capture08[capture19] = colorPicker
        capture04.Addons = capture04.Addons or {}

        table.insert(capture04.Addons, colorPicker)

        if capture04.ToggleRegion then
            capture04.ColorPickerCount = capture04.ColorPickerCount + 1

            if capture04.ColorPickerCount > 2 then
                capture04.ToggleRegion.Size = capture04.ToggleRegion.Size - UDim2.new(0, 32, 0, 0)
            end
        end
    end
end
function Native.tabBox(captures)
    local capture04 = captures[4]
    local tabContainer = captures[3]
    local capture08 = captures[8]
    local capture01 = captures[1]
    local capture07 = captures[7]
    local capture06 = captures[6]
    local capture00 = captures[0]
    local capture02 = captures[2]
    local capture05 = captures[5]
    local capture09 = captures[9]

    return function()
        local tabboxes = capture08.Tabboxes

        function tabContainer:Remove()
            capture04:Destroy()
            table.clear(tabContainer)

            tabboxes[capture06.Name or ''] = nil
        end
        function tabContainer:AddTab(value015, value016)
            local panel = {}
            local value018 = capture00:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = capture00.MainColor,
                BorderSizePixel = 1,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                ZIndex = 6,
                Parent = capture02,
            })
            local value019 = capture00:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = capture00.AccentColor,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(1, 0, 0, 1),
                ZIndex = 8,
                Visible = value016 or false,
                Parent = value018,
            })

            capture00:AddToRegistry(value019, {
                BackgroundColor3 = 'AccentColor',
            })

            local value020 = value016 and UDim2.new(1, -1, 1, 0) or UDim2.new(1, 0, 1, 0)
            local value021 = capture00:Create(capture01[3][capture01[2] ], {
                BackgroundTransparency = 0,
                BackgroundColor3 = capture00.MainColor,
                BorderSizePixel = 1,
                BorderColor3 = capture00.OutlineColor,
                BorderMode = Enum.BorderMode.Inset,
                Size = value020,
                ZIndex = 7,
                Parent = value018,
            })

            capture00:AddToRegistry(value018, {
                BackgroundColor3 = 'MainColor',
            })
            capture00:AddToRegistry(value021, {
                BackgroundColor3 = 'MainColor',
                BorderColor3 = capture09[3][capture09[2] ],
            })

            local value022 = capture00:CreateLabel({
                Size = UDim2.new(1, 0, 1, 0),
                TextSize = 14,
                Text = value015,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 7,
                Parent = value018,
            })
            local value023 = capture00:Create(capture01[3][capture01[2] ], {
                BackgroundColor3 = capture00.BackgroundColor,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, 1),
                Visible = false,
                ZIndex = 9,
                Parent = value018,
            })

            capture00:AddToRegistry(value023, {
                BackgroundColor3 = 'BackgroundColor',
            })

            local value024 = capture00:Create(capture01[3][capture01[2] ], {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 4, 0, 20),
                Size = UDim2.new(1, -4, 1, -20),
                ZIndex = 1,
                Visible = false,
                Parent = capture07,
            })

            capture00:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = value024,
            })

            function panel:Show()
                for key, value in next, tabContainer.Tabs do
                    __step(56)
                    value:Hide()
                end

                value024.Visible = true
                value023.Visible = true
                value021.Visible = false
                value019.Visible = true
                value018.BackgroundColor3 = capture00.BackgroundColor
                capture00.RegistryMap[value018].Properties.BackgroundColor3 = 'BackgroundColor'

                panel:Resize()
            end
            function panel:Hide()
                value024.Visible = false
                value023.Visible = false
                value021.Visible = true
                value019.Visible = false
                value018.BackgroundColor3 = capture00.MainColor
                capture00.RegistryMap[value018].Properties.BackgroundColor3 = 'MainColor'
            end
            function panel:Resize()
                local value030 = 0

                for key2, value2 in next, tabContainer.Tabs do
                    __step(57)

                    value030 = value030 + 1
                end
                for key3, value3 in next, capture02:GetChildren()do
                    __step(58)

                    if not value3:IsA('UIListLayout') then
                        value3.Size = UDim2.new(1 / value030, 0, 1, 0)
                    end
                end

                if not value024.Visible then
                    return
                end

                local value035 = 0

                for key4, value4 in next, panel.Container:GetChildren()do
                    __step(59)

                    if not value4:IsA('UIListLayout') and value4.Visible then
                        value035 = value035 + value4.Size.Y.Offset
                    end
                end

                capture04.Size = UDim2.new(1, 0, 0, 20 + value035 + 2 + 2)
            end

            value018.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and not capture00:MouseIsOverOpenedFrame() or input.UserInputType == Enum.UserInputType.Touch then
                    panel:Show()
                    panel:Resize()
                end
            end)

            panel.Container = value024
            tabContainer.Tabs[value015] = panel

            setmetatable(panel, capture05)
            panel:AddBlank(3)
            panel:Resize()

            if #capture02:GetChildren() == 2 then
                panel:Show()
            end

            return panel
        end

        capture08.Tabboxes[capture06.Name or ''] = tabContainer
    end
end
function Native.tab(captures)
    local capture15 = captures[15]
    local capture00 = captures[0]
    local capture10 = captures[10]
    local capture12 = captures[12]
    local capture03 = captures[3]
    local tab = captures[2]
    local capture13 = captures[13]
    local capture07 = captures[7]
    local capture04 = captures[4]
    local capture11 = captures[11]
    local capture05 = captures[5]
    local capture01 = captures[1]
    local capture06 = captures[6]
    local capture08 = captures[8]
    local capture14 = captures[14]
    local capture09 = captures[9]

    return function()
        if capture01.IsMobile then
            local value018 = {
                Left = tick(),
                Right = tick(),
            }

            capture03:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
                capture01.CanDrag = false

                local value019 = tick()

                value018.Left = value019

                task.wait(0.15)

                if value018.Left == value019 then
                    capture01.CanDrag = true
                end
            end)
            capture05:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
                capture01.CanDrag = false

                local value020 = tick()

                value018.Right = value020

                task.wait(0.15)

                if value018.Right == value020 then
                    capture01.CanDrag = true
                end
            end)
        end

        for key, value in next, {capture03, capture05}do
            __step(143)
            value:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                value.CanvasSize = UDim2.fromOffset(0, value.UIListLayout.AbsoluteContentSize.Y)
            end)
        end

        function tab:Resize()
            if capture04[3][capture04[2] ].Visible == true then
                local value024 = 10

                for key2, value2 in next, capture14[3][capture14[2] ]:GetChildren()do
                    __step(144)

                    if not value2:IsA('UIListLayout') and value2.Visible then
                        value024 = value024 + value2.Size.Y.Offset
                    end
                end

                capture04[3][capture04[2] ].Size = UDim2.new(1, -10, 0, value024)
                value024 = value024 + 10
                capture03.Position = UDim2.new(0, 7, 0, 7 + value024)
                capture03.Size = UDim2.new(0.5, -10, 1, -14 - value024)
                capture05.Position = UDim2.new(0.5, 5, 0, 7 + value024)
                capture05.Size = UDim2.new(0.5, -10, 1, -14 - value024)
            else
                capture03.Position = UDim2.new(0, 7, 0, 7)
                capture03.Size = UDim2.new(0.5, -10, 1, -14)
                capture05.Position = UDim2.new(0.5, 5, 0, 7)
                capture05.Size = UDim2.new(0.5, -10, 1, -14)
            end
        end
        function tab:UpdateWarningBox(value028)
            if typeof(value028.Visible) == 'boolean' then
                capture04[3][capture04[2] ].Visible = value028.Visible

                tab:Resize()
            end
            if typeof(value028.Title) == 'string' then
                capture11[3][capture11[2] ].Text = value028.Title
            end
            if typeof(value028.Text) == 'string' then
                capture09[3][capture09[2] ].Text = value028.Text

                local value029 = select(2, capture01:GetTextBounds(value028.Text, capture01.Font, 14, Vector2.new(capture09[3][capture09[2] ].AbsoluteSize.X, math.huge)))

                capture09[3][capture09[2] ].Size = UDim2.new(1, -4, 0, value029)

                tab:Resize()
            end
        end
        function tab:ShowTab()
            capture01.ActiveTab = capture10

            for key3, value3 in next, capture12.Tabs do
                __step(145)
                value3:HideTab()
            end

            capture01.RegistryMap[capture06].Properties.BackgroundColor3 = 'BackgroundColor'
            capture06.BackgroundColor3 = capture01.MainColor
            capture13.Visible = true
            capture15.Color = Color3.fromRGB(0, 0, 0)
            capture07.TextColor3 = capture01.FontColor
            capture08.Visible = true

            tab:Resize()
        end
        function tab:HideTab()
            capture06.BackgroundColor3 = capture01.BackgroundColor
            capture01.RegistryMap[capture06].Properties.BackgroundColor3 = 'MainColor'
            capture15.Color = Color3.fromRGB(25, 25, 25)
            capture07.TextColor3 = capture01:GetDarkerColor(capture01.FontColor)
            capture08.Visible = false
            capture13.Visible = false
        end
        function tab:SetLayoutOrder(order)
            capture06.LayoutOrder = order

            capture00:ApplyLayout()
        end
        function tab:GetSides()
            return {
                Left = capture03,
                Right = capture05,
            }
        end
        function tab:AddLeftGroupbox(value038)
            return self:AddGroupbox({
                Side = 1,
                Name = value038,
            })
        end
        function tab:AddRightGroupbox(value040)
            return self:AddGroupbox({
                Side = 2,
                Name = value040,
            })
        end
        function tab:AddLeftTabbox(value042)
            return tab:AddTabbox({
                Name = value042,
                Side = 1,
            })
        end
        function tab:AddRightTabbox(value044)
            return tab:AddTabbox({
                Name = value044,
                Side = 2,
            })
        end
        function tab:Remove()
            table.clear(tab)
            capture13:Destroy()
            capture06:Destroy()

            capture12.Tabs[capture10] = nil
        end

        capture06.InputBegan:Connect(function(input)
            if capture01.IsDragging then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                tab:ShowTab()
            end
        end)
        capture04[3][capture04[2] ]:GetPropertyChangedSignal('Visible'):Connect(function()
            tab:Resize()
        end)

        capture01.TotalTabs = capture01.TotalTabs + 1

        if capture01.TotalTabs == 1 then
            tab:ShowTab()
        end

        capture12.Tabs[capture10] = tab
    end
end
function Native.dependencies(captures)
    local capture00 = captures[0]
    local capture05 = captures[5]
    local capture04 = captures[4]
    local capture02 = captures[2]
    local capture06 = captures[6]
    local capture03 = captures[3]
    local capture01 = captures[1]

    return function()
        function capture01:Resize()
            capture03.Size = UDim2.new(1, 0, 0, capture06.AbsoluteContentSize.Y)

            capture04:Resize()
        end

        capture06:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            capture01:Resize()
        end)
        capture03:GetPropertyChangedSignal('Visible'):Connect(function()
            capture01:Resize()
        end)

        function capture01:Update()
            local value011 = false

            for key, value in next, capture01.Dependencies do
                __step(99)

                if value[1].Value == value[2] then
                    value011 = true

                    break
                end
            end

            capture03.Visible = value011

            capture01:Resize()
        end
        function capture01:SetupDependencies(value015)
            for key2, value2 in next, value015 do
                __step(100)
                assert(type(value2) == 'table', 'SetupDependencies: Dependency is not of type `table`.')
                assert(value2[1], 'SetupDependencies: Dependency is missing element argument.')
                assert(value2[2] ~= nil, 'SetupDependencies: Dependency is missing value argument.')
            end

            capture01.Dependencies = value015

            capture01:Update()
        end
        function capture01:Remove()
            table.remove(capture00.DependencyBoxes, table.find(capture00.DependencyBoxes, capture01))
            table.clear(capture01)
            capture03:Destroy()
            capture04:Resize()
        end

        capture01.Container = capture05

        setmetatable(capture01, capture02)
        table.insert(capture00.DependencyBoxes, capture01)
    end
end
function Native.valueCallbacks(captures)
    local capture03 = captures[3]
    local capture10 = captures[10]
    local capture00 = captures[0]
    local capture05 = captures[5]
    local capture07 = captures[7]
    local capture09 = captures[9]
    local capture01 = captures[1]
    local capture04 = captures[4]
    local textService = captures[8]
    local capture02 = captures[2]
    local capture06 = captures[6]

    return function()
        function capture00:SetValue(newValue)
            if capture02.MaxLength and #newValue > capture02.MaxLength then
                newValue = newValue:sub(1, capture02.MaxLength)
            end
            if capture00.Numeric then
                if not tonumber(newValue) and newValue:len() > 0 then
                    newValue = capture00.Value
                end
            end

            capture00.Value = newValue
            capture01.Text = newValue

            capture04:SafeCallback(capture00.Callback, capture00.Value)
            capture04:SafeCallback(capture00.Changed, capture00.Value)
        end
        function capture00:Remove()
            for key, value in capture07 do
                __step(146)
                value:Destroy()
            end

            capture03[capture05] = nil

            capture09:Destroy()
            table.clear(capture00)
            capture06:Resize()
        end

        if capture00.Finished then
            capture01.FocusLost:Connect(function(value018)
                capture00:SetValue(capture01.Text)
                capture04:AttemptSave()
            end)
        else
            capture01:GetPropertyChangedSignal('Text'):Connect(function()
                capture00:SetValue(capture01.Text)
                capture04:AttemptSave()
            end)
        end

        local function value019()
            local value020 = 2
            local value021 = capture10.AbsoluteSize.X

            if not capture01:IsFocused() or capture01.TextBounds.X <= value021 - 2 * value020 then
                capture01.Position = UDim2.new(0, value020, 0, 0)
            else
                local cursorPosition = capture01.CursorPosition

                if cursorPosition ~= -1 then
                    local value023 = string.sub(capture01.Text, 1, cursorPosition - 1)
                    local value024 = textService:GetTextSize(value023, capture01.TextSize, capture01.Font, Vector2.new(math.huge, math.huge)).X
                    local value025 = capture01.Position.X.Offset + value024

                    if value025 < value020 then
                        capture01.Position = UDim2.fromOffset(value020 - value024, 0)
                    elseif value025 > value021 - value020 - 1 then
                        capture01.Position = UDim2.fromOffset(value021 - value024 - value020 - 1, 0)
                    end
                end
            end
        end

        task.spawn(value019)
        capture01:GetPropertyChangedSignal('Text'):Connect(value019)
        capture01:GetPropertyChangedSignal('CursorPosition'):Connect(value019)
        capture01.FocusLost:Connect(value019)
        capture01.Focused:Connect(value019)

        if capture04.FlagCopying then
            local value026 = capture04:AddContextMenu(capture09)

            value026:AddOption('Copy Flag', function()
                pcall(setclipboard, capture00.Idx)
                task.wait()
                capture04:Notify('Copied flag to clipboard!', 2)
                value026:Hide()
            end)
        end

        capture04:AddToRegistry(capture01, {
            TextColor3 = 'FontColor',
        })

        function capture00:OnChanged(callback)
            capture00.Changed = callback

            callback(capture00.Value)
        end

        table.insert(capture07, capture06:AddBlank(5))
        capture06:Resize()

        capture03[capture05] = capture00
    end
end
function Native.buttons(captures)
    local capture03 = captures[3]
    local capture01 = captures[1]
    local capture00 = captures[0]
    local capture02 = captures[2]
    local capture04 = captures[4]

    return function()
        function capture01:AddButton(...)
            local value008 = typeof(select(1, ...)) == 'table' and select(1, ...) or {
                Text = select(1, ...),
                Func = select(2, ...),
            }

            assert(typeof(value008.Func) == 'function', 'AddButton: `Func` callback is missing.')

            self.Outer.Size = UDim2.new(0.5, -2, 0, 20)
            value008.Outer, value008.Inner, value008.Label = capture03(value008)
            value008.Outer.Position = UDim2.new(1, 3, 0, 0)
            value008.Outer.Size = UDim2.new(1, -3, 1, 0)
            value008.Outer.Parent = self.Outer

            function value008:AddTooltip(value010)
                if typeof(value010) == 'string' then
                    capture04:AddToolTip(value010, self.Outer)
                end

                return value008
            end

            if typeof(value008.Tooltip) == 'string' then
                value008:AddTooltip(value008.Tooltip)
            end

            capture00(value008)

            return value008
        end

        local value011 = {}

        function capture01:Remove()
            for key, value in value011 do
                __step(156)
                value:Destroy()
            end

            capture01.Outer:Destroy()
            table.clear(capture01)
            capture02:Resize()
        end

        if typeof(capture01.Tooltip) == 'string' then
            capture01:AddTooltip(capture01.Tooltip)
        end

        table.insert(value011, capture02:AddBlank(5))
        capture02:Resize()
    end
end
function Native.textLabel(captures)
    local capture00 = captures[0]
    local capture05 = captures[5]
    local capture02 = captures[2]
    local capture04 = captures[4]
    local capture01 = captures[1]
    local capture03 = captures[3]

    return function()
        function capture04:SetText(text)
            capture03.Text = text

            if capture05 then
                local value010 = select(2, capture02:GetTextBounds(text, capture02.Font, 14, Vector2.new(capture03.AbsoluteSize.X, math.huge)))

                capture03.Size = UDim2.new(1, -4, 0, value010)
            end

            capture00:Resize()
        end

        local value011 = {}

        function capture04:Remove()
            for key, value in value011 do
                __step(185)
                value:Destroy()
            end

            capture03:Destroy()
            table.clear(capture04)
            capture00:Resize()
        end

        if not capture05 then
            setmetatable(capture04, capture01)
        end

        table.insert(value011, capture00:AddBlank(5))
        capture00:Resize()
    end
end
function Native.containerSize(captures)
    local capture01 = captures[1]
    local capture00 = captures[0]
    local capture03 = captures[3]
    local capture02 = captures[2]
    local capture04 = captures[4]

    return function()
        function capture03:SetSize(value008)
            capture01.Size = UDim2.new(1, -4, 0, value008)

            capture04:Resize()
        end
        function capture03:GetOuter()
            return capture01
        end
        function capture03:GetInner()
            return capture00
        end
        function capture03:GetSize()
            return capture00.AbsoluteSize
        end

        local value012 = {}

        table.insert(value012, capture02:AddBlank(5))
        capture02:Resize()
    end
end
function Native.drawing(captures)
    local integrityProductRef = captures[2]
    local smallIntegrityRef = captures[4]
    local integrityOffsetRef = captures[0]
    local outlineColorNameRef = captures[8]
    local largeIntegrityRef = captures[6]
    local frameClassRef = captures[1]
    local integrityModuloRef = captures[5]
    local cloneFunctionRef = captures[3]
    local enabledRef = captures[7]

    return function()
        if integrityOffsetRef[3][integrityOffsetRef[2] ](1386) ~= 4293 then
            while true do
                __step(68)
            end
        else
            local textService = cloneref(game:GetService('TextService'))
            local value012 = {
                Fonts = {
                    UI = 0,
                    System = 1,
                    Plex = 2,
                    Monospace = 3,
                },
            }
            local value013 = getrenv()
            local value014 = value013.math.pi
            local value015 = value013.math.huge
            local value016 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.assert)
            local value017 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.Color3.new)
            local value018 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.Instance.new)
            local value019 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.math.atan2)
            local value020 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.math.clamp)
            local value021 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.math.max)
            local value022 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.setmetatable)
            local value023 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.string.format)
            local value024 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.task.spawn)
            local value025 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.UDim.new)
            local value026 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.UDim2.fromOffset)
            local value027 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.UDim2.new)
            local value028 = cloneFunctionRef[3][cloneFunctionRef[2] ](value013.Vector2.new)
            local value029 = cloneFunctionRef[3][cloneFunctionRef[2] ](game.Destroy)
            local value030 = cloneFunctionRef[3][cloneFunctionRef[2] ](textService.GetTextBoundsAsync)
            local value031 = cloneFunctionRef[3][cloneFunctionRef[2] ](game.HttpGet)
            local value032 = writecustomasset and cloneFunctionRef[3][cloneFunctionRef[2] ](writecustomasset)
            local value033 = protectinstance and cloneFunctionRef[3][cloneFunctionRef[2] ](protectinstance)

            local function value034(value035, value036, value037)
                local value038 = value018(value035)

                for key, value in value036 do
                    __step(69)

                    if key ~= 'Parent' then
                        value038[key] = value
                    end
                end

                if value037 then
                    for key2, value2 in value037 do
                        __step(70)

                        value2.Parent = value038
                    end
                end
                if value033 then
                    if 15746 ~= integrityOffsetRef[3][integrityOffsetRef[2] ](3592) then
                        while true do
                            __step(71)
                        end
                    else
                        value033(value038)
                    end
                end

                value038.Parent = value036.Parent

                return value038
            end

            do
                local value043 = {
                    Font.new('rbxasset://fonts/families/Arial.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    Font.new('rbxasset://fonts/families/HighwayGothic.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    Font.new('rbxasset://fonts/families/Roboto.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                }

                for key3, value3 in value043 do
                    __step(72)
                    game:GetService('TextService'):GetTextBoundsAsync(value034('GetTextBoundsParams', {
                        Text = '\\\\',
                        Size = 12,
                        Font = value3,
                        Width = value015,
                    }))
                end
            end
            do
                local value046 = value034('ScreenGui', {
                    DisplayOrder = 15,
                    IgnoreGuiInset = true,
                    Name = 'drawingDirectory',
                    Parent = cloneref(game:GetService('CoreGui')),
                    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
                })

                local function value047(value048, value049, value050, value051)
                    local value052 = (value049 + value050) / 2
                    local value053 = value050 - value049

                    value048.Position = value026(value052.X, value052.Y)
                    value048.Rotation = value019(value053.Y, value053.X) * 180 / value014
                    value048.Size = value026(value053.Magnitude, value051)
                end

                if largeIntegrityRef[3][largeIntegrityRef[2] ] + 8181 ~= 17576 then
                    while true do
                        __step(73)
                    end
                end

                local value054 = 0
                local value055 = {}
                local value056 = {}

                do
                    if smallIntegrityRef[3][smallIntegrityRef[2] ] - 610 ~= 354 then
                        if integrityOffsetRef[3][integrityOffsetRef[2] ](5140) <= 21280 and 21280 >= integrityOffsetRef[3][integrityOffsetRef[2] ](5140) then
                            while true do
                                __step(74)
                            end
                        else
                            while true do
                                __step(75)
                            end
                        end
                    end

                    local drawingClass = {}

                    function drawingClass.new()
                        value054 = value054 + 1

                        if largeIntegrityRef[3][largeIntegrityRef[2] ] + 3788 ~= 13183 then
                            while true do
                                __step(76)
                            end
                        end

                        local value058 = value054
                        local value059 = value022({
                            _id = value058,
                            __OBJECT_EXISTS = true,
                            _properties = {
                                Color = value017(),
                                From = value028(),
                                Thickness = 1,
                                To = value028(),
                                Transparency = 1,
                                Visible = false,
                                ZIndex = 0,
                            },
                            _frame = value034(frameClassRef[3][frameClassRef[2] ], {
                                Name = value058,
                                AnchorPoint = value028(0.5, 0.5),
                                BackgroundColor3 = value017(),
                                BorderSizePixel = 0,
                                Parent = value046,
                                Position = value027(),
                                Size = value027(),
                                Visible = false,
                                ZIndex = 0,
                            }),
                        }, drawingClass)

                        value055[value058] = value059

                        return value059
                    end
                    function drawingClass:__index(value061)
                        local value062 = self._properties[value061]

                        if value062 ~= nil then
                            return value062
                        end

                        return drawingClass[value061]
                    end
                    function drawingClass:__newindex(value064, value065)
                        if enabledRef[3][enabledRef[2] ] and self.__OBJECT_EXISTS == true then
                            if 26282 >= integrityOffsetRef[3][integrityOffsetRef[2] ](8694) and 26282 <= integrityOffsetRef[3][integrityOffsetRef[2] ](8694) then
                                local value066 = self._properties

                                if enabledRef[3][enabledRef[2] ] and (value066[value064] == nil or value066[value064] == value065 or typeof(value066[value064]) ~= typeof(value065)) then
                                    return
                                end

                                value066[value064] = value065

                                if value064 == 'Color' then
                                    self._frame.BackgroundColor3 = value065
                                elseif value064 == 'From' then
                                    self:_updatePosition()
                                elseif value064 == 'Thickness' then
                                    self._frame.Size = value026(self._frame.AbsoluteSize.X, value021(value065, 1))
                                elseif value064 == 'To' then
                                    self:_updatePosition()
                                elseif value064 == 'Transparency' then
                                    if integrityOffsetRef[3][integrityOffsetRef[2] ](3864) ~= 13262 then
                                        while true do
                                            __step(77)
                                        end
                                    else
                                        self._frame.BackgroundTransparency = value020(1 - value065, 0, 1)
                                    end
                                elseif value064 == 'Visible' then
                                    self._frame.Visible = value065
                                elseif value064 == 'ZIndex' then
                                    self._frame.ZIndex = value065
                                end
                            else
                                while true do
                                    __step(78)
                                end
                            end
                        end
                    end
                    function drawingClass:__iter()
                        return next, self._properties
                    end
                    function drawingClass:__tostring()
                        return 'Drawing'
                    end
                    function drawingClass:Destroy()
                        value055[self._id] = nil
                        self.__OBJECT_EXISTS = false

                        value029(self._frame)
                    end
                    function drawingClass:_updatePosition()
                        local value071 = self._properties

                        value047(self._frame, value071.From, value071.To, value071.Thickness)
                    end

                    drawingClass.Remove = drawingClass.Destroy
                    value056.Line = drawingClass
                end
                do
                    local drawingClass2 = {}

                    function drawingClass2.new()
                        if integrityOffsetRef[3][integrityOffsetRef[2] ](1085) >= 7565 and 7565 <= integrityOffsetRef[3][integrityOffsetRef[2] ](1085) then
                            value054 = value054 + 1

                            local value073 = value054
                            local value074 = value022({
                                _id = value073,
                                __OBJECT_EXISTS = true,
                                _properties = {
                                    Color = value017(),
                                    Filled = false,
                                    NumSides = 0,
                                    Position = value028(),
                                    Radius = 0,
                                    Thickness = 1,
                                    Transparency = 1,
                                    Visible = false,
                                    ZIndex = 0,
                                },
                                _frame = value034(frameClassRef[3][frameClassRef[2] ], {
                                    Name = value073,
                                    AnchorPoint = value028(0.5, 0.5),
                                    BackgroundColor3 = value017(),
                                    BackgroundTransparency = 1,
                                    BorderSizePixel = 0,
                                    Parent = value046,
                                    Position = value027(),
                                    Size = value027(),
                                    Visible = false,
                                    ZIndex = 0,
                                }, {
                                    value034('UICorner', {
                                        Name = '_corner',
                                        CornerRadius = value025(1, 0),
                                    }),
                                    value034('UIStroke', {
                                        Name = '_stroke',
                                        Color = value017(),
                                        Thickness = 1,
                                    }),
                                }),
                            }, drawingClass2)

                            value055[value073] = value074

                            return value074
                        else
                            while true do
                                __step(79)
                            end
                        end
                    end
                    function drawingClass2:__index(value076)
                        local value077 = self._properties[value076]

                        if value077 ~= nil then
                            return value077
                        end

                        return drawingClass2[value076]
                    end
                    function drawingClass2:__newindex(value079, value080)
                        if self.__OBJECT_EXISTS == true then
                            if integrityOffsetRef[3][integrityOffsetRef[2] ](1603) == 7229 then
                                local value081 = self._properties

                                if value081[value079] == nil or value081[value079] == value080 or typeof(value081[value079]) ~= typeof(value080) then
                                    return
                                end

                                value081[value079] = value080

                                if value079 == 'Color' then
                                    if 9871 == integrityModuloRef[3][integrityModuloRef[2] ](8073) then
                                        self._frame.BackgroundColor3 = value080
                                        self._frame._stroke.Color = value080
                                    else
                                        while true do
                                            __step(80)
                                        end
                                    end
                                elseif value079 == 'Filled' then
                                    if 738 <= integrityProductRef[3][integrityProductRef[2] ](6578) and integrityProductRef[3][integrityProductRef[2] ](6578) >= 738 then
                                        self._frame.BackgroundTransparency = value080 and 1 - value081.Transparency or 1
                                    else
                                        while true do
                                            __step(81)
                                        end
                                    end
                                elseif value079 == 'Position' then
                                    self._frame.Position = value026(value080.X, value080.Y)
                                elseif value079 == 'Radius' then
                                    self:_updateRadius()
                                elseif value079 == 'Thickness' then
                                    self._frame._stroke.Thickness = value021(value080, 1)

                                    self:_updateRadius()
                                elseif value079 == 'Transparency' then
                                    self._frame._stroke.Transparency = 1 - value080

                                    if value081.Filled then
                                        self._frame.BackgroundTransparency = 1 - value080
                                    end
                                elseif value079 == 'Visible' then
                                    self._frame.Visible = value080
                                elseif value079 == 'ZIndex' then
                                    self._frame.ZIndex = value080
                                end
                            else
                                while true do
                                    __step(82)
                                end
                            end
                        end
                    end
                    function drawingClass2:__iter()
                        return next, self._properties
                    end
                    function drawingClass2:__tostring()
                        return 'Drawing'
                    end
                    function drawingClass2:Destroy()
                        value055[self._id] = nil
                        self.__OBJECT_EXISTS = false

                        value029(self._frame)
                    end
                    function drawingClass2:_updateRadius()
                        if 30197 >= integrityOffsetRef[3][integrityOffsetRef[2] ](8884) and 30197 <= integrityOffsetRef[3][integrityOffsetRef[2] ](8884) then
                            local value086 = self._properties
                            local value087 = value086.Radius * 2 - value086.Thickness * 2

                            self._frame.Size = value026(value087, value087)
                        else
                            while true do
                                __step(83)
                            end
                        end
                    end

                    drawingClass2.Remove = drawingClass2.Destroy
                    value056.Circle = drawingClass2
                end
                do
                    if integrityProductRef[3][integrityProductRef[2] ](7049) >= 108 and integrityProductRef[3][integrityProductRef[2] ](7049) <= 108 then
                        local value088 = {
                            [value012.Fonts.UI] = Font.new('rbxasset://fonts/families/Arial.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            [value012.Fonts.System] = Font.new('rbxasset://fonts/families/HighwayGothic.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            [value012.Fonts.Plex] = Font.new('rbxasset://fonts/families/Roboto.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            [value012.Fonts.Monospace] = Font.new('rbxasset://fonts/families/Ubuntu.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        }
                        local drawingClass3 = {}

                        function drawingClass3.new()
                            value054 = value054 + 1

                            local value090 = value054
                            local value091 = value022({
                                _id = value090,
                                __OBJECT_EXISTS = true,
                                _properties = {
                                    Center = false,
                                    RichText = false,
                                    Color = value017(),
                                    FontFace = value088[0],
                                    Outline = false,
                                    OutlineColor = value017(),
                                    Position = value028(),
                                    Size = 12,
                                    TextSize = 12,
                                    Text = '',
                                    TextBounds = value028(),
                                    Transparency = 1,
                                    Visible = false,
                                    ZIndex = 0,
                                },
                                _frame = value034('TextLabel', {
                                    Name = value090,
                                    BackgroundTransparency = 1,
                                    FontFace = value088[0],
                                    Parent = value046,
                                    Position = value027(),
                                    Size = value027(),
                                    Text = '',
                                    TextColor3 = value017(),
                                    TextSize = 12,
                                    TextXAlignment = Enum.TextXAlignment.Left,
                                    TextYAlignment = Enum.TextYAlignment.Top,
                                    Visible = false,
                                    ZIndex = 0,
                                }, {
                                    value034('UIStroke', {
                                        Name = '_stroke',
                                        Color = value017(),
                                        Enabled = false,
                                        Thickness = 1,
                                        LineJoinMode = Enum.LineJoinMode.Miter,
                                    }),
                                }),
                            }, drawingClass3)

                            value055[value090] = value091

                            return value091
                        end
                        function drawingClass3:__index(value093)
                            local value094 = self._properties[value093]

                            if value094 ~= nil then
                                if integrityProductRef[3][integrityProductRef[2] ](7282) ~= 810 then
                                    while true do
                                        __step(84)
                                    end
                                else
                                    return value094
                                end
                            end

                            return drawingClass3[value093]
                        end
                        function drawingClass3:__newindex(value096, value097)
                            if self.__OBJECT_EXISTS == true then
                                if integrityProductRef[3][integrityProductRef[2] ](6820) >= 332 and integrityProductRef[3][integrityProductRef[2] ](6820) <= 332 then
                                    local value098 = self._properties

                                    if value096 == 'TextBounds' or value098[value096] == nil or value098[value096] == value097 or typeof(value098[value096]) ~= typeof(value097) then
                                        return
                                    end

                                    value098[value096] = value097

                                    if value096 == 'Position' then
                                        self._frame.Position = value026(value097.X, value097.Y)
                                    elseif value096 == 'Text' then
                                        self._frame.Text = value097

                                        self:_updateTextBounds()
                                    elseif value096 == 'Transparency' then
                                        self._frame.TextTransparency = 1 - value097
                                        self._frame._stroke.Transparency = 1 - value097
                                    elseif value096 == 'Size' or value096 == 'TextSize' then
                                        if 7594 <= integrityModuloRef[3][integrityModuloRef[2] ](5222) and 7594 >= integrityModuloRef[3][integrityModuloRef[2] ](5222) then
                                            self._frame.TextSize = value097

                                            self:_updateTextBounds()
                                        else
                                            while true do
                                                __step(85)
                                            end
                                        end
                                    elseif value096 == 'Visible' then
                                        self._frame.Visible = value097
                                    elseif value096 == 'Center' then
                                        self._frame.TextXAlignment = value097 and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left
                                    elseif value096 == 'Color' then
                                        self._frame.TextColor3 = value097
                                    elseif value096 == 'Font' then
                                        local value099 = value088[value097]

                                        self._frame.FontFace, value098.FontFace = value099, value099

                                        self:_updateTextBounds()
                                    elseif value096 == 'Outline' then
                                        self._frame._stroke.Enabled = value097
                                    elseif value096 == outlineColorNameRef[3][outlineColorNameRef[2] ] then
                                        self._frame._stroke.Color = value097
                                    elseif value096 == 'ZIndex' then
                                        self._frame.ZIndex = value097
                                    elseif value096 == 'FontFace' then
                                        if integrityModuloRef[3][integrityModuloRef[2] ](6592) == 5584 then
                                            self._frame.FontFace = value097

                                            self:_updateTextBounds()
                                        else
                                            while true do
                                                __step(86)
                                            end
                                        end
                                    elseif value096 == 'RichText' then
                                        self._frame.RichText = value097
                                    end
                                else
                                    while true do
                                        __step(87)
                                    end
                                end
                            end
                        end
                        function drawingClass3:__iter()
                            return next, self._properties
                        end
                        function drawingClass3:__tostring()
                            return 'Drawing'
                        end
                        function drawingClass3:Destroy()
                            value055[self._id] = nil
                            self.__OBJECT_EXISTS = false

                            value029(self._frame)
                        end
                        function drawingClass3:_updateTextBounds()
                            local value104 = self._properties

                            value104.TextBounds = value030(textService, value034('GetTextBoundsParams', {
                                Text = value104.Text,
                                Size = value104.Size,
                                Font = value104.FontFace,
                                Width = value015,
                            }))
                        end

                        drawingClass3.Remove = drawingClass3.Destroy
                        value056.Text = drawingClass3
                    else
                        while true do
                            __step(88)
                        end
                    end
                end
                do
                    local drawingClass4 = {}

                    function drawingClass4.new()
                        value054 = value054 + 1

                        local value106 = value054
                        local value107 = value022({
                            _id = value106,
                            __OBJECT_EXISTS = true,
                            _properties = {
                                Color = value017(),
                                Filled = false,
                                Position = value028(),
                                Size = value028(),
                                Thickness = 1,
                                Transparency = 1,
                                Visible = false,
                                ZIndex = 0,
                            },
                            _frame = value034(frameClassRef[3][frameClassRef[2] ], {
                                BackgroundColor3 = value017(),
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                Parent = value046,
                                Position = value027(),
                                Size = value027(),
                                Visible = false,
                                ZIndex = 0,
                            }, {
                                value034('UIStroke', {
                                    Name = '_stroke',
                                    Color = value017(),
                                    Thickness = 1,
                                    LineJoinMode = Enum.LineJoinMode.Miter,
                                }),
                            }),
                        }, drawingClass4)

                        value055[value106] = value107

                        return value107
                    end
                    function drawingClass4:__index(value109)
                        local value110 = self._properties[value109]

                        if value110 ~= nil then
                            return value110
                        end

                        return drawingClass4[value109]
                    end
                    function drawingClass4:__newindex(value112, value113)
                        if self.__OBJECT_EXISTS == true then
                            local value114 = self._properties

                            if value114[value112] == nil or value114[value112] == value113 or typeof(value114[value112]) ~= typeof(value113) then
                                return
                            end

                            value114[value112] = value113

                            if value112 == 'Position' then
                                self:_updateScale()
                            elseif value112 == 'Size' then
                                self:_updateScale()
                            elseif value112 == 'Color' then
                                self._frame.BackgroundColor3 = value113
                                self._frame._stroke.Color = value113
                            elseif value112 == 'Filled' then
                                if -1118 == integrityProductRef[3][integrityProductRef[2] ](5065) then
                                    while true do
                                        __step(89)
                                    end
                                else
                                    self._frame.BackgroundTransparency = value113 and 1 - value114.Transparency or 1
                                end
                            elseif value112 == 'Thickness' then
                                self._frame._stroke.Thickness = value113

                                self:_updateScale()
                            elseif value112 == 'Transparency' then
                                self._frame._stroke.Transparency = 1 - value113

                                if value114.Filled then
                                    if integrityOffsetRef[3][integrityOffsetRef[2] ](7134) ~= 26717 then
                                        while true do
                                            __step(90)
                                        end
                                    else
                                        self._frame.BackgroundTransparency = 1 - value113
                                    end
                                end
                            elseif value112 == 'Visible' then
                                self._frame.Visible = value113
                            elseif value112 == 'ZIndex' then
                                self._frame.ZIndex = value113
                            end
                        end
                    end
                    function drawingClass4:__iter()
                        return next, self._properties
                    end
                    function drawingClass4:__tostring()
                        return 'Drawing'
                    end
                    function drawingClass4:Destroy()
                        value055[self._id] = nil
                        self.__OBJECT_EXISTS = false

                        value029(self._frame)
                    end
                    function drawingClass4:_updateScale()
                        local value119 = self._properties

                        self._frame.Position = value026(value119.Position.X + value119.Thickness, value119.Position.Y + value119.Thickness)

                        local thickness = value119.Thickness

                        self._frame.Size = value026(value119.Size.X - thickness * 2, value119.Size.Y - thickness * 2)
                    end

                    drawingClass4.Remove = drawingClass4.Destroy
                    value056.Square = drawingClass4
                end
                do
                    local drawingClass5 = {}

                    function drawingClass5.new()
                        value054 = value054 + 1

                        local value122 = value054
                        local value123 = value022({
                            _id = value122,
                            _imageId = 0,
                            __OBJECT_EXISTS = true,
                            _properties = {
                                Color = value017(1, 1, 1),
                                Data = '',
                                Position = value028(),
                                Rounding = 0,
                                Size = value028(),
                                Transparency = 1,
                                Uri = '',
                                Visible = false,
                                ZIndex = 0,
                            },
                            _frame = value034('ImageLabel', {
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                Image = '',
                                ImageColor3 = value017(1, 1, 1),
                                Parent = value046,
                                Position = value027(),
                                Size = value027(),
                                Visible = false,
                                ZIndex = 0,
                            }, {
                                value034('UICorner', {
                                    Name = '_corner',
                                    CornerRadius = value025(),
                                }),
                            }),
                        }, drawingClass5)

                        value055[value122] = value123

                        return value123
                    end
                    function drawingClass5:__index(value125)
                        if 108 == integrityProductRef[3][integrityProductRef[2] ](6249) then
                            value016(value125 ~= 'Data', value023("Attempt to read writeonly property '%s'", value125))

                            if value125 == 'Loaded' then
                                return self._frame.IsLoaded
                            end

                            local value126 = self._properties[value125]

                            if value126 ~= nil then
                                return value126
                            end

                            return drawingClass5[value125]
                        else
                            while true do
                                __step(91)
                            end
                        end
                    end
                    function drawingClass5:__newindex(value128, value129)
                        if integrityProductRef[3][integrityProductRef[2] ](2673) == 3516 then
                            while true do
                                __step(92)
                            end
                        elseif self.__OBJECT_EXISTS == true then
                            local value130 = self._properties

                            if value130[value128] == nil or value130[value128] == value129 or typeof(value130[value128]) ~= typeof(value129) then
                                return
                            end

                            value130[value128] = value129

                            if value128 == 'Color' then
                                self._frame.ImageColor3 = value129
                            elseif value128 == 'Data' then
                                self:_newImage(value129)
                            elseif value128 == 'Position' then
                                self._frame.Position = value026(value129.X, value129.Y)
                            elseif value128 == 'Rounding' then
                                self._frame._corner.CornerRadius = value025(0, value129)
                            elseif value128 == 'Size' then
                                if 27215 ~= integrityOffsetRef[3][integrityOffsetRef[2] ](8145) then
                                    while true do
                                        __step(93)
                                    end
                                else
                                    self._frame.Size = value026(value129.X, value129.Y)
                                end
                            elseif value128 == 'Transparency' then
                                self._frame.ImageTransparency = 1 - value129
                            elseif value128 == 'Uri' then
                                self:_newImage(value129, true)
                            elseif value128 == 'Visible' then
                                self._frame.Visible = value129
                            elseif value128 == 'ZIndex' then
                                self._frame.ZIndex = value129
                            end
                        end
                    end
                    function drawingClass5:__iter()
                        return next, self._properties
                    end
                    function drawingClass5:__tostring()
                        return 'Drawing'
                    end
                    function drawingClass5:Destroy()
                        value055[self._id] = nil
                        self.__OBJECT_EXISTS = false

                        value029(self._frame)
                    end
                    function drawingClass5:_newImage(value135, value136)
                        value024(function()
                            self._imageId = self._imageId + 1

                            local value137 = value023('%s-%s.png', self._id, self._imageId)

                            if value136 then
                                local value138

                                while value138 == nil do
                                    __step(94)

                                    local success, resultOrError = pcall(value031, game, value135, true)

                                    if success then
                                        value138 = resultOrError
                                    elseif string.find(string.lower(resultOrError), 'too many requests') then
                                        task.wait(3)
                                    else
                                        error(resultOrError, 2)

                                        return
                                    end
                                end

                                self._properties.Data = value135
                            else
                                self._properties.Uri = ''
                            end

                            self._frame.Image = value032(value137, value135)
                        end)
                    end

                    drawingClass5.Remove = drawingClass5.Destroy
                    value056.Image = drawingClass5
                end

                value012.new = newcclosure(function(value141)
                    return value016(value056[value141], value023("Invalid drawing type '%s'", value141)).new()
                end)
                value012.clear = newcclosure(function()
                    for key4, value4 in value055 do
                        __step(95)

                        if value4.__OBJECT_EXISTS then
                            value4:Destroy()
                        end
                    end
                end)
                value012.cache = value055
            end

            setreadonly(value012, true)
            setreadonly(value012.Fonts, true)

            return value012
        end
    end
end
function Native.emptyCallback()
    return function() end
end
function Native.recovered01_Sw(captures)
    local capture01 = captures[1]
    local capture03 = captures[3]
    local capture00 = captures[0]
    local capture02 = captures[2]

    return function(value006)
        local value007 = value006 and capture02(value006) == 'table' and capture00(value006, capture01)

        capture03:Fire(capture02(value007) == 'string' and value007)
    end
end
function Native.recovered02_iw(captures)
    local capture25 = captures[25]
    local capture03 = captures[3]
    local capture07 = captures[7]
    local capture22 = captures[22]
    local capture11 = captures[11]
    local capture04 = captures[4]
    local capture26 = captures[26]
    local capture05 = captures[5]
    local capture15 = captures[15]
    local capture17 = captures[17]
    local capture20 = captures[20]
    local capture19 = captures[19]
    local capture13 = captures[13]
    local capture10 = captures[10]
    local capture01 = captures[1]
    local capture27 = captures[27]
    local capture06 = captures[6]
    local capture21 = captures[21]
    local capture12 = captures[12]
    local capture16 = captures[16]
    local capture24 = captures[24]
    local capture02 = captures[2]
    local capture23 = captures[23]
    local capture09 = captures[9]
    local capture18 = captures[18]
    local capture08 = captures[8]
    local capture00 = captures[0]
    local capture14 = captures[14]

    return function(value030)
        if not capture16[3][capture16[2] ][capture18] then
            return capture17()
        end
        if not capture06[3][capture06[2] ] then
            capture12[3][capture12[2] ] = capture24:GetPivot().Position
        end

        local value031, value032 = capture09[3][capture09[2] ](capture12[3][capture12[2] ])

        if not value032 then
            return capture17()
        end

        capture00[3][capture00[2] ], capture07.Visible = false, true

        local value033, value034 = capture19[3][capture19[2] ].font, capture19[3][capture19[2] ].size

        capture13.FontFace, capture13.TextSize = value033, value034
        capture01.FontFace, capture01.TextSize = value033, value034

        local value035 = capture26((capture11.CFrame.Position - capture12[3][capture12[2] ]).Magnitude)

        if capture21[3][capture21[2] ] then
            capture13.Text, capture13.Visible = value035 .. 's', true
            capture13.TextColor3 = capture04[3][capture04[2] ]
        else
            capture13.Visible = false
        end

        capture01.Visible, capture01.TextColor3 = capture20[3][capture20[2] ], capture02[3][capture02[2] ]
        capture07.Position, capture07.ZIndex = capture05(value031.X, value031.Y), -value035

        if capture06[3][capture06[2] ] then
            capture06[3][capture06[2] ] = capture06[3][capture06[2] ] + value030

            local value036 = capture22(capture06[3][capture06[2] ] / capture23[3][capture23[2] ], 0, 1)

            for key, value in capture03 do
                __step(4)

                key[value] = value036
            end
        end
        if not capture27[3][capture27[2] ] then
            capture07.Size, capture10[3][capture10[2] ] = capture05(), 0

            return
        end

        local value039, value040

        if capture25[3][capture25[2] ] and capture06[3][capture06[2] ] then
            value039, value040 = 1, capture14[3][capture14[2] ] * (1 - capture22(capture06[3][capture06[2] ] / capture23[3][capture23[2] ], 0, 1))
        else
            value039, value040 = capture08[3][capture08[2] ], capture14[3][capture14[2] ]
        end
        if capture10[3][capture10[2] ] == value040 then
            return
        end

        capture10[3][capture10[2] ] = capture15(capture10[3][capture10[2] ], value040, value039)
        capture07.Size = capture05(capture10[3][capture10[2] ], capture10[3][capture10[2] ])
    end
end
function Native.recovered03_Q(captures)
    local capture00 = captures[0]

    return function()
        capture00.Enabled = Toggles.color_correction_enabled.Value

        if not capture00.Enabled then
            return
        end

        capture00.TintColor = Options.color_correction_tint.Value
        capture00.Saturation = Options.color_correction_saturation.Value
        capture00.Contrast = Options.color_correction_contrast.Value
        capture00.Brightness = Options.color_correction_brightness.Value
    end
end
function Native.recovered05_K(captures)
    local capture01 = captures[1]
    local capture00 = captures[0]

    return function(value004, value005, value006)
        local value007 = capture00[value004]

        return value007 .. capture01[3][capture01[2] ](value005) .. '</font>' .. (value006 and '\n' or '')
    end
end
function Native.recovered07_h(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function(...)
        capture00(capture01, ...)
    end
end
function Native.recovered09_g(captures)
    local capture10 = captures[10]
    local capture04 = captures[4]
    local capture11 = captures[11]
    local capture07 = captures[7]
    local capture03 = captures[3]
    local capture01 = captures[1]
    local capture12 = captures[12]
    local capture08 = captures[8]
    local capture05 = captures[5]
    local capture09 = captures[9]
    local capture00 = captures[0]
    local capture02 = captures[2]
    local capture06 = captures[6]

    return function(value015, value016, value017)
        local value018, value019 = capture11('Attachment', capture03), capture11('Attachment', capture03)

        value018.WorldPosition, value019.WorldPosition = value015, value015

        local value020 = capture05:Clone()
        local value2 = capture08.Value

        value020.Width0, value020.Width1 = value2, value2
        value020.LightEmission = capture10.Value
        value020.TextureSpeed = capture02.Value
        value020.TextureLength = capture01.Value
        value020.Parent = value018
        value020.Color = value017
        value020.Attachment0 = value018
        value020.Attachment1 = value019

        local value022 = {value020}

        for index = 1, capture09.Value - 1 do
            __step(38)

            local value024 = value020:Clone()

            value024.Parent = value020.Parent

            table.insert(value022, value024)
        end

        capture12:Create(value019, capture00(capture04.Value), {WorldPosition = value016}):Play()
        task.delay(capture07.Value, function()
            local value025

            for key, value in value022 do
                __step(39)

                value025 = capture12:Create(value, capture00(capture06.Value), {
                    Width0 = 0,
                    Width1 = 0,
                })

                value025:Play()
            end

            value025.Completed:Wait()
            value018:Destroy()
            value019:Destroy()
        end)
    end
end
function Native.recovered10_S(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function()
        local value2 = Toggles.sunrays_enabled.Value

        if value2 then
            capture00.Enabled = true
            capture00.Spread = Options.sunrays_spread.Value
            capture00.Intensity = Options.sunrays_intensity.Value
        else
            for key, value in capture01 do
                __step(40)

                capture00[key] = value
            end
        end
    end
end
function Native.recovered13_k()
    return function(...)
        return call(...)
    end
end
function Native.recovered14_O(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function(value004, value005)
        if capture00[3][capture00[2] ] then
            capture01[3][capture01[2] ] = capture01[3][capture01[2] ] + value005
        end
    end
end
function Native.recovered15_E(captures)
    local capture01 = captures[1]
    local capture00 = captures[0]

    return function()
        local unpackFn = unpack

        capture01[3][capture01[2] ] = function()
            return unpackFn(capture00)
        end
    end
end
function Native.recovered16_j(captures)
    local capture00 = captures[0]

    return function()
        return capture00
    end
end
function Native.recovered18_z(captures)
    local capture03 = captures[3]
    local capture01 = captures[1]
    local capture00 = captures[0]
    local capture04 = captures[4]
    local capture05 = captures[5]
    local capture06 = captures[6]
    local capture02 = captures[2]

    return function(value009, value010, value011, value012)
        capture03(capture04, value012 and value009 or capture05[3][capture05[2] ](value009), nil)

        if value010 then
            capture00[3][capture00[2] ] = true

            if capture01[3][capture01[2] ] then
                capture06(capture01[3][capture01[2] ])
            end

            capture01[3][capture01[2] ] = capture02(value011 or 1, function()
                capture00[3][capture00[2] ] = nil
            end)
        end
    end
end
function Native.recovered20_W(captures)
    local capture00 = captures[0]

    return function()
        capture00:Fire()
    end
end
function Native.recovered21_vw(captures)
    local capture03 = captures[3]
    local capture01 = captures[1]
    local capture00 = captures[0]
    local userInputService = captures[2]

    return function()
        local mousePosition = userInputService:GetMouseLocation()
        local value007 = (mousePosition - capture01[3][capture01[2] ]) / capture03

        capture00.Position = capture00.Position + UDim2.fromScale(value007.X, value007.Y)
        capture01[3][capture01[2] ] = mousePosition
    end
end
function Native.recovered22_ow()
    return function()
        return Assets.read('BurbankBigCondensed-Black.otf')
    end
end
function Native.recovered23_Qw(captures)
    local capture01 = captures[1]
    local capture00 = captures[0]
    local capture02 = captures[2]

    return function(value005, value006, value007, value008)
        local value009 = capture00:Clone()

        for key, value in value009:GetDescendants()do
            __step(61)

            if value.Name == 'MainEmitter' then
                value.Color = capture01[3][capture01[2] ]
            end
            if value.ClassName == 'ParticleEmitter' then
                value:Emit(5)
            end
        end

        value009.Parent = workspace
        value009.Position = value005.Position

        if capture02[3][capture02[2] ] then
            value009.Anchored = false

            local weldConstraint = Instance.new('WeldConstraint', value009)

            weldConstraint.Part0 = value005
            weldConstraint.Part1 = value009
        end

        task.delay(1, value009.Destroy, value009)
    end
end
function Native.recovered24_N(captures)
    local capture00 = captures[0]

    return function(value003, value004)
        return value004 <= 1 and value003 or capture00(1 - value003.R, 1 - value003.G, 1 - value003.B)
    end
end
function Native.recovered26_Z()
    return function()
        return Assets.read('watermark_text.blob')
    end
end
function Native.recovered27_A(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function(value004, value005, value006, value007)
        return capture00[value004] .. (value007 and value005 or capture01[3][capture01[2] ](value005)) .. (value006 and '</font>\n' or '</font>')
    end
end
function Native.recovered28_u()
    return function()
        return Assets.read('watermark_image.png')
    end
end
function Native.recovered30_Zw()
    return function(...)
        return call(...)
    end
end
function Native.recovered31_B()
    return function()
        return Assets.read('SmallestPixel-7.ttf')
    end
end
function Native.recovered33_Tw(captures)
    local capture04 = captures[4]
    local contextActionService = captures[0]
    local capture03 = captures[3]
    local capture01 = captures[1]
    local capture09 = captures[9]
    local capture07 = captures[7]
    local capture08 = captures[8]
    local capture11 = captures[11]
    local userInputService = captures[6]
    local capture05 = captures[5]
    local capture10 = captures[10]
    local capture02 = captures[2]

    return function()
        local value014 = {}
        local value015 = false
        local value016 = false

        function capture02:Toggle()
            if value016 then
                return
            end

            value015 = not value015
            capture02.Toggled = value015
            capture04[3][capture04[2] ] = value015

            capture02:FireEvent('VisibilityChanged', capture04[3][capture04[2] ])

            capture05.Modal = value015

            if value015 then
                capture09.Visible = true

                local guiService = game:GetService('GuiService')

                task.spawn(function()
                    local mouseIconEnabled = userInputService.MouseIconEnabled
                    local imageLabel = Instance.new('ImageLabel', capture07)

                    imageLabel.Image = 'http://www.roblox.com/asset/?id=4292970642'
                    imageLabel.BackgroundTransparency = 1
                    imageLabel.ZIndex = 125

                    local imageLabel2 = Instance.new('ImageLabel', capture07)

                    imageLabel2.Image = 'http://www.roblox.com/asset/?id=4292970642'
                    imageLabel2.ImageColor3 = Color3.new()
                    imageLabel2.BackgroundTransparency = 1
                    imageLabel2.ZIndex = 124
                    imageLabel.Size, imageLabel2.Size = UDim2.fromOffset(17, 17), UDim2.fromOffset(19, 19)
                    imageLabel.Rotation, imageLabel2.Rotation = -45, -45

                    while value015 and capture07.Parent do
                        __step(127)

                        userInputService.MouseIconEnabled = false

                        local mousePosition = userInputService:GetMouseLocation()
                        local value023 = UDim2.fromOffset(mousePosition.X, mousePosition.Y - guiService:GetGuiInset().Y - 1)

                        imageLabel.ImageColor3 = capture02.AccentColor
                        imageLabel.Position, imageLabel2.Position = value023, value023 - UDim2.fromOffset(1, 1)

                        capture01:Wait()
                    end

                    userInputService.MouseIconEnabled = mouseIconEnabled

                    imageLabel:Destroy()
                    imageLabel2:Destroy()
                end)
            end

            for key, value in capture11 do
                __step(128)
                task.spawn(function()
                    if value.Type == 'Dropdown' then
                        value:CloseDropdown()
                    elseif value.Type == 'KeyPicker' then
                        value:SetModePickerVisibility(false)
                    elseif value.Type == 'ColorPicker' then
                        value:Hide()
                    end
                end)
            end

            if value015 and capture02.BlockInput then
                contextActionService:BindAction('Freeze', function()
                    return Enum.ContextActionResult.Sink
                end, false, table.unpack(Enum.PlayerActions:GetEnumItems()))
            else
                contextActionService:UnbindAction('Freeze')
            end

            capture03.Enabled = value015
            capture10.Enabled = value015
            capture08.Enabled = value015
            capture09.Visible = value015
        end

        capture02:GiveSignal(userInputService.InputBegan:Connect(function(input, gameProcessed)
            if typeof(capture02.ToggleKeybind) == 'table' and capture02.ToggleKeybind.Type == 'KeyPicker' then
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == capture02.ToggleKeybind.Value then
                    task.spawn(capture02.Toggle)
                end
            elseif input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.Insert and not gameProcessed then
                task.spawn(capture02.Toggle)
            end
        end))
    end
end
function Native.recovered34_m()
    return function()
        return Assets.read('Minecraft-Regular.otf')
    end
end
function Native.recovered36_i(captures)
    local capture00 = captures[0]

    return function()
        capture00[3][capture00[2] ] = {
            ['[LEGIT] Magma'] = [[{"objects":[{"idx":"animation_player_enabled","type":"Toggle","value":false},{"idx":"target_highlight","type":"Toggle","value":false},{"idx":"indicator_manipulated","type":"Toggle","value":false},{"idx":"item_remove_vignette","type":"Toggle","value":true},{"idx":"lighting_toggle_ClockTime","type":"Toggle","value":true},{"idx":"ragebot_enabled","type":"Toggle","value":false},{"idx":"movement_noclip","type":"Toggle","value":false},{"idx":"silent_closest_part","type":"Toggle","value":true},{"idx":"KeybindMenu","type":"Toggle","value":true},{"idx":"camera_fov_changer","type":"Toggle","value":true},{"idx":"arm_override_appearance","type":"Toggle","value":true},{"idx":"esp_skeleton_outline","type":"Toggle","value":false},{"idx":"auto_load_enabled","type":"Toggle","value":false},{"idx":"silent_fov_fill","type":"Toggle","value":true},{"idx":"esp_chams","type":"Toggle","value":true},{"idx":"viewmodel_body_color","type":"Toggle","value":true},{"idx":"lighting_toggle_ColorShift_Top","type":"Toggle","value":false},{"idx":"lighting_toggle_FogEnd","type":"Toggle","value":false},{"idx":"lighting_toggle_FogColor","type":"Toggle","value":false},{"idx":"lighting_toggle_ColorShift_Bottom","type":"Toggle","value":true},{"idx":"NotificationColors","type":"Toggle","value":false},{"idx":"movement_infinite_double_jump","type":"Toggle","value":false},{"idx":"exploits_full_auto","type":"Toggle","value":true},{"idx":"spoof_device_enabled","type":"Toggle","value":false},{"idx":"hit_sounds_enabled","type":"Toggle","value":true},{"idx":"lighting_toggle_Ambient","type":"Toggle","value":true},{"idx":"atmosphere_enabled","type":"Toggle","value":true},{"idx":"auto_queue_enabled","type":"Toggle","value":false},{"idx":"indicator_ragebot","type":"Toggle","value":true},{"idx":"viewmodel_offset","type":"Toggle","value":true},{"idx":"shoot_sound_change","type":"Toggle","value":true},{"idx":"viewmodel_disable_textures","type":"Toggle","value":true},{"idx":"indicator_ammo","type":"Toggle","value":true},{"idx":"target_ui_enabled","type":"Toggle","value":true},{"idx":"hit_effects_weld","type":"Toggle","value":false},{"idx":"anti_aim_floor_hide","type":"Toggle","value":false},{"idx":"viewmodel_wireframe","type":"Toggle","value":true},{"idx":"aimbot_fov_outline","type":"Toggle","value":true},{"idx":"esp_healthbar","type":"Toggle","value":true},{"idx":"movement_velocity","type":"Toggle","value":false},{"idx":"arm_disable_textures","type":"Toggle","value":true},{"idx":"aimbot_fov_fill","type":"Toggle","value":true},{"idx":"autoban_maps","type":"Toggle","value":true},{"idx":"hit_sounds_disable","type":"Toggle","value":true},{"idx":"custom_tracer_outline","type":"Toggle","value":false},{"idx":"camera_aspect_ratio","type":"Toggle","value":false},{"idx":"aimbot_fov_moving","type":"Toggle","value":false},{"idx":"chat_spam_enabled","type":"Toggle","value":false},{"idx":"crosshair_disable_game","type":"Toggle","value":true},{"idx":"triggerbot_enabled","type":"Toggle","value":true},{"idx":"lighting_toggle_Brightness","type":"Toggle","value":true},{"idx":"auto_select_enabled","type":"Toggle","value":false},{"idx":"esp_show_team","type":"Toggle","value":false},{"idx":"aimbot_toggle","type":"Toggle","value":false},{"idx":"viewmodel_frames_override","type":"Toggle","value":false},{"idx":"aimbot_match_axis","type":"Toggle","value":true},{"idx":"arm_body_color","type":"Toggle","value":true},{"idx":"ragebot_bait","type":"Toggle","value":true},{"idx":"esp_skeleton","type":"Toggle","value":true},{"idx":"third_person_enabled","type":"Toggle","value":false},{"idx":"target_hit_notify","type":"Toggle","value":false},{"idx":"silent_manipulation","type":"Toggle","value":false},{"idx":"esp_override_appearance","type":"Toggle","value":false},{"idx":"lighting_bool_GlobalShadows","type":"Toggle","value":true},{"idx":"silent_toggle","type":"Toggle","value":true},{"idx":"skybox_enabled","type":"Toggle","value":true},{"idx":"auto_load_silent","type":"Toggle","value":false},{"idx":"esp_world_distance","type":"Toggle","value":true},{"idx":"esp_world_name","type":"Toggle","value":true},{"idx":"targeting_visibleonly","type":"Toggle","value":true},{"idx":"color_correction_enabled","type":"Toggle","value":true},{"idx":"movement_slideboost","type":"Toggle","value":true},{"idx":"autoban_weapons","type":"Toggle","value":true},{"idx":"esp_effects_particle","type":"Toggle","value":true},{"idx":"crosshair_outline","type":"Toggle","value":true},{"idx":"arcade_auto_respawn","type":"Toggle","value":false},{"idx":"ragebot_priority_notification","type":"Toggle","value":true},{"idx":"esp_effects_aura","type":"Toggle","value":false},{"idx":"esp_name","type":"Toggle","value":true},{"idx":"sunrays_enabled","type":"Toggle","value":true},{"idx":"esp_world_image","type":"Toggle","value":true},{"idx":"hit_effects_enabled","type":"Toggle","value":true},{"idx":"viewmodel_material","type":"Toggle","value":true},{"idx":"NotificationClips","type":"Toggle","value":false},{"idx":"esp_fill_moving","type":"Toggle","value":true},{"idx":"esp_body_color","type":"Toggle","value":false},{"idx":"viewmodel_override_appearance","type":"Toggle","value":true},{"idx":"chat_spam_order","type":"Toggle","value":false},{"idx":"silent_showfov","type":"Toggle","value":true},{"idx":"esp_weapon","type":"Toggle","value":true},{"idx":"esp_healthbar_resize","type":"Toggle","value":false},{"idx":"esp_healthbar_moving","type":"Toggle","value":false},{"idx":"hit_effects_disable_marker","type":"Toggle","value":true},{"idx":"movement_fly","type":"Toggle","value":false},{"idx":"hit_effects_disable_numbers","type":"Toggle","value":true},{"idx":"name_spoofer","type":"Toggle","value":false},{"idx":"arcade_auto_ammo","type":"Toggle","value":false},{"idx":"silent_visualize","type":"Toggle","value":true},{"idx":"?","type":"Toggle","value":false},{"idx":"aimbot_showfov","type":"Toggle","value":true},{"idx":"lighting_toggle_FogStart","type":"Toggle","value":false},{"idx":"silent_fov_outline","type":"Toggle","value":true},{"idx":"targeting_limitdistance","type":"Toggle","value":false},{"idx":"exploits_always_backstab","type":"Toggle","value":false},{"idx":"silent_fov_moving","type":"Toggle","value":true},{"idx":"targeting_disableflash","type":"Toggle","value":true},{"idx":"item_status_enabled","type":"Toggle","value":true},{"idx":"weather_enabled","type":"Toggle","value":true},{"idx":"esp_material","type":"Toggle","value":false},{"idx":"anti_aim_enabled","type":"Toggle","value":false},{"idx":"custom_tracer_enabled","type":"Toggle","value":true},{"idx":"aimbot_delay_position","type":"Toggle","value":true},{"idx":"esp_box","type":"Toggle","value":false},{"idx":"esp_distance","type":"Toggle","value":true},{"idx":"ragebot_void_spam","type":"Toggle","value":false},{"idx":"lighting_toggle_ExposureCompensation","type":"Toggle","value":true},{"idx":"ragebot_priority","type":"Toggle","value":true},{"idx":"movement_double_jump_height","type":"Toggle","value":true},{"idx":"arm_material","type":"Toggle","value":false},{"idx":"ambience_enabled","type":"Toggle","value":false},{"idx":"target_tracer","type":"Toggle","value":false},{"idx":"crosshair_enabled","type":"Toggle","value":true},{"idx":"esp_box_moving","type":"Toggle","value":false},{"idx":"viewmodel_chams","type":"Toggle","value":false},{"idx":"aimbot_closest_part","type":"Toggle","value":false},{"idx":"camera_anti_flashbang","type":"Toggle","value":false},{"idx":"esp_fill","type":"Toggle","value":false},{"idx":"exploits_no_spread","type":"Toggle","value":false},{"idx":"targeting_ignore_protected","type":"Toggle","value":true},{"idx":"bloom_enabled","type":"Toggle","value":true},{"idx":"esp_healthbar_type","type":"Dropdown","mutli":false,"value":"gradient"},{"idx":"ragebot_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"triggerbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"crosshair_offset","type":"Slider","value":"0"},{"idx":"bloom_threshold","type":"Slider","value":"0.85"},{"idx":"indicator_ragebot_text_color","type":"ColorPicker","transparency":0,"value":"e3ca71"},{"idx":"movement_velocityvalue","type":"Slider","value":"50"},{"idx":"silent_outline_color1","type":"ColorPicker","transparency":0.8409090909090909,"value":"0a0a0a"},{"idx":"silent_fov_rotation","type":"Slider","value":"0"},{"idx":"esp_effects_aura_color1","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"silent_color2","type":"ColorPicker","transparency":0.6909090909090909,"value":"000000"},{"idx":"esp_fill_rotation_speed","type":"Slider","value":"0.5"},{"idx":"esp_effects_particle_color3","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"indicator_ammo_style","type":"Dropdown","mutli":true,"value":{"\"out of ammo\" if empty":true,"ammo":true,"max ammo":true,"reserve":true}},{"idx":"triggerbot_scoped","type":"Dropdown","mutli":true,"value":{"Sniper":true,"Crossbow":true}},{"idx":"shoot_sound_speed","type":"Slider","value":"1"},{"idx":"aimbot_fov_rotation_speed","type":"Slider","value":"1"},{"idx":"esp_weapon_rotation","type":"Slider","value":"0"},{"idx":"NotificationStyleSortOrder","type":"Dropdown","mutli":false,"value":"Default"},{"idx":"crosshair_bounce","type":"Slider","value":"0"},{"idx":"aimbot_fov_rotation","type":"Slider","value":"0"},{"idx":"bloom_size","type":"Slider","value":"50"},{"idx":"ragebot_weapon","type":"Dropdown","value":"primary"},{"idx":"indicator_lerp","type":"Slider","value":"0.25"},{"idx":"aimbot_color3","type":"ColorPicker","transparency":0,"value":"c8e4ff"},{"idx":"esp_name_type","type":"Dropdown","mutli":false,"value":"Name"},{"idx":"aimbot_outline_color2","type":"ColorPicker","transparency":0.7,"value":"cbe6ff"},{"idx":"auto_select_Secondary","type":"Dropdown","value":"Daggers"},{"idx":"silent_outline_color2","type":"ColorPicker","transparency":0.7727272727272727,"value":"030303"},{"idx":"skybox_disable","type":"Dropdown","mutli":true,"value":{"stars":true,"sun":true,"moon":true}},{"idx":"esp_name_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"auto_select_Primary","type":"Dropdown","value":"Assault Rifle"},{"idx":"aimbot_delay_smooth_x","type":"Slider","value":"4"},{"idx":"viewmodel_chams_settings","type":"Dropdown","mutli":true,"value":{"through walls":true}},{"idx":"esp_world_distance_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_fill_color2","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"esp_world_object_scale","type":"Slider","value":"75"},{"idx":"esp_chams_color2","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"NotificationBarStyle","type":"Dropdown","mutli":false,"value":"Top"},{"idx":"movement_flyvalue","type":"Slider","value":"50"},{"idx":"silent_keybind","type":"KeyPicker","key":"LeftAlt","mode":"Always"},{"idx":"spoof_device_type","type":"Dropdown","value":"controller"},{"idx":"esp_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_fill_color3","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"chat_spam_text","type":"Dropdown","mutli":true,"value":[]},{"idx":"arm_material_value","type":"Dropdown","value":"ForceField"},{"idx":"triggerbot_settings","type":"Dropdown","mutli":true,"value":{"no delay between targets":true,"anti katana":true}},{"idx":"custom_tracer_selected","type":"Dropdown","mutli":false,"value":"drawing"},{"idx":"esp_name_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_yaw","type":"Dropdown","value":"random"},{"idx":"animation_player_keybind","type":"KeyPicker","key":"T","mode":"Toggle"},{"idx":"NotificationColorsFont","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_effects_aura_color2","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"viewmodel_offset_y","type":"Slider","value":"0"},{"idx":"indicator_ammo_divider_color","type":"ColorPicker","transparency":0,"value":"e3ca71"},{"idx":"esp_material_value","type":"Dropdown","value":"Neon"},{"idx":"aimbot_delay_smooth_y","type":"Slider","value":"4"},{"idx":"shoot_sound_volume","type":"Slider","value":"0.2"},{"idx":"weather_rate_multiplier","type":"Slider","value":"0.1"},{"idx":"esp_weapon_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_whitelist","type":"Dropdown","mutli":true,"value":{"Flashbang":true,"Smoke Grenade":true,"Satchel":true,"Subspace Tripmine":true,"Molotov":true,"Grenade":true}},{"idx":"weather_color_2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_outline_color3","type":"ColorPicker","transparency":0.5909090909090908,"value":"000000"},{"idx":"esp_body_color_value","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_healthbar_color_end","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"indicator_text_style","type":"Dropdown","mutli":false,"value":"lower"},{"idx":"esp_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"item_status_override","type":"Dropdown","value":"Prime"},{"idx":"custom_tracer_fade","type":"Slider","value":"1"},{"idx":"target_ui_show_targets","type":"Dropdown","mutli":true,"value":{"aimbot":true,"ragebot":true}},{"idx":"viewmodel_chams_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_position_lerp","type":"Slider","value":"0.5"},{"idx":"indicator_manipulated_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationClipsDistance","type":"Slider","value":"200"},{"idx":"arm_body_color_value","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"indicator_reserve_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_color","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"esp_weapon_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_1","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"indicator_empty_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_skeleton_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"animation_player_start_position","type":"Slider","value":"0"},{"idx":"esp_box_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_lerp_speed","type":"Slider","value":"0.1"},{"idx":"esp_chams_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_world_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"targeting_forgettime","type":"Slider","value":"0"},{"idx":"ragebot_priority_settings","type":"Dropdown","mutli":true,"value":{"voided players":true,"attackers":true}},{"idx":"esp_healthbar_speed","type":"Slider","value":"1"},{"idx":"esp_effects_aura_color3","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"esp_distance_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"exploits_grenade_settings","type":"Dropdown","mutli":true,"value":{"explode on impact":true}},{"idx":"esp_bounds_width_scale","type":"Slider","value":"100"},{"idx":"NotificationAnchorStyle","type":"Dropdown","mutli":false,"value":"Center"},{"idx":"arm_body_transparency","type":"Slider","value":"56"},{"idx":"autoban_first","type":"Dropdown","value":"Riot Shield"},{"idx":"color_correction_contrast","type":"Slider","value":"0"},{"idx":"hit_effects_material","type":"Dropdown","mutli":false,"value":"ForceField"},{"idx":"atmosphere_haze","type":"Slider","value":"0"},{"idx":"triggerbot_part_blacklist","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_sounds_volume","type":"Slider","value":"0.9"},{"idx":"indicator_offset_y","type":"Slider","value":"25"},{"idx":"NotificationColorsMain","type":"ColorPicker","transparency":0,"value":"1c1c1c"},{"idx":"viewmodel_offset_x","type":"Slider","value":"0"},{"idx":"viewmodel_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"indicator_ammo_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_2","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"animation_player_value","type":"Dropdown","mutli":false,"value":"floss"},{"idx":"aimbot_outline_color3","type":"ColorPicker","transparency":0.25,"value":"cee8ff"},{"idx":"triggerbot_max_distance","type":"Slider","value":"250"},{"idx":"silent_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"sunrays_intensity","type":"Slider","value":"0.25"},{"idx":"custom_tracer_lifetime","type":"Slider","value":"1"},{"idx":"viewmodel_body_color_value","type":"ColorPicker","transparency":0,"value":"caa10d"},{"idx":"triggerbot_reaction_time_offset","type":"Slider","value":"5"},{"idx":"bloom_intensity","type":"Slider","value":"1.38"},{"idx":"cosmetics_changer_save_data","type":"Input","text":"{\"Crossbow\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Grenade Launcher\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Medkit\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Burst Rifle\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Spear\":{\"skin\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"charm\":{\"enabled\":true,\"random\":true}},\"Flashbang\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Subspace Tripmine\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Flamethrower\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Grenade\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"random\":true,\"enabled\":true}},\"Fists\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"random\":true,\"enabled\":true}},\"RPG\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Grappler\":{\"skin\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"charm\":{\"enabled\":true,\"random\":true}},\"Scythe\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Slingshot\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Battle Axe\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Flare Gun\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Molotov\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Shotgun\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Permafrost\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Trowel\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Riot Shield\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Assault Rifle\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Sniper\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Maul\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Warpstone\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Shorty\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Jump Pad\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Distortion\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Knife\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Chainsaw\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Warper\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Bow\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"random\":true,\"enabled\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"random\":true,\"enabled\":true}},\"Spray\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Daggers\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"random\":true,\"enabled\":true}},\"Energy Pistols\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Handgun\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Energy Rifle\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Katana\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Satchel\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"War Horn\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Uzi\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Smoke Grenade\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Exogun\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Freeze Ray\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Gunblade\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Paintball Gun\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Minigun\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}},\"Revolver\":{\"charm\":{\"enabled\":true,\"random\":true},\"wrap\":{\"enabled\":true,\"random\":true},\"finisher\":{\"enabled\":true,\"random\":true},\"skin\":{\"enabled\":true,\"random\":true}}}"},{"idx":"aimbot_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"auto_select_Utility","type":"Dropdown","value":"Grenade"},{"idx":"KeybindMenuValue","type":"Dropdown","mutli":false,"value":"Active"},{"idx":"esp_healthbar_slices","type":"Slider","value":"1"},{"idx":"crosshair_bounce_speed","type":"Slider","value":"2.9"},{"idx":"anti_aim_pitch","type":"Dropdown","value":"random"},{"idx":"lighting_colorFogColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"weather_timescale_multiplier","type":"Slider","value":"1"},{"idx":"esp_body_disables","type":"Dropdown","mutli":true,"value":[]},{"idx":"viewmodel_material_value","type":"Dropdown","value":"Neon"},{"idx":"esp_fill_rotation","type":"Slider","value":"45"},{"idx":"viewmodel_chams_alpha_fill","type":"Slider","value":"-0.1"},{"idx":"aimbot_radius","type":"Slider","value":"100"},{"idx":"target_ui_item_scale","type":"Slider","value":"170"},{"idx":"esp_world_name_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_forget_time","type":"Slider","value":"1.5"},{"idx":"crosshair_rotation","type":"Slider","value":"45"},{"idx":"hit_effects_col_3","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"target_highlight_outline","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_distance_rotation","type":"Slider","value":"0"},{"idx":"crosshair_rotation_speed","type":"Slider","value":"0"},{"idx":"color_correction_saturation","type":"Slider","value":"1"},{"idx":"movement_flykeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"NotificationTransparency","type":"Slider","value":"35"},{"idx":"esp_skeleton_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_start","type":"Slider","value":"0"},{"idx":"esp_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"autoban_first_delay","type":"Slider","value":"0"},{"idx":"hit_effects_selected","type":"Dropdown","mutli":true,"value":{"slashes":true,"phantom forces":true}},{"idx":"esp_name_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"chat_spam_mode","type":"Dropdown","value":"custom"},{"idx":"sunrays_spread","type":"Slider","value":"1"},{"idx":"aimbot_delay_smooth_jump","type":"Slider","value":"10"},{"idx":"silent_hitchance","type":"Slider","value":"35"},{"idx":"esp_skeleton_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_body_transparency","type":"Slider","value":"100"},{"idx":"atmosphere_density","type":"Slider","value":"0.45"},{"idx":"esp_distance_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"skybox_value","type":"Dropdown","value":"Classic Roblox"},{"idx":"custom_tracer_emission","type":"Slider","value":"1"},{"idx":"animation_player_end_position","type":"Slider","value":"100"},{"idx":"aimbot_fov_lerp","type":"Slider","value":"0.25"},{"idx":"weather_value","type":"Dropdown","value":"Snow"},{"idx":"auto_queue_mode","type":"Dropdown","value":"1v1"},{"idx":"color_correction_tint","type":"ColorPicker","transparency":0,"value":"ffe380"},{"idx":"weapon_filter","type":"Input","text":""},{"idx":"aimbot_outline_color1","type":"ColorPicker","transparency":0.8409090909090909,"value":"bddfff"},{"idx":"esp_effects_particle_value","type":"Dropdown","mutli":true,"value":{"glowing":true}},{"idx":"atmosphere_decay","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"target_ui_position_y","type":"Slider","value":"70"},{"idx":"crosshair_thickness","type":"Slider","value":"2"},{"idx":"esp_name_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_fill_color1","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"crosshair_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"NotificationColorsOutline","type":"ColorPicker","transparency":0,"value":"323232"},{"idx":"movement_double_jump_height_multiplier","type":"Slider","value":"1.1"},{"idx":"targeting_closest_part_blacklist","type":"Dropdown","mutli":true,"value":{"LeftHand":true,"RightLowerArm":true,"LeftFoot":true,"LeftLowerArm":true,"RightLowerLeg":true,"RightHand":true,"RightFoot":true,"LeftLowerLeg":true}},{"idx":"indicator_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"atmosphere_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"shoot_sound_change_value","type":"Dropdown","mutli":false,"value":"bow"},{"idx":"NotificationPositionX","type":"Slider","value":"50"},{"idx":"aimbot_smoothing","type":"Slider","value":"10"},{"idx":"auto_select_Melee","type":"Dropdown","value":"Riot Shield"},{"idx":"NotificationColorsAccent","type":"ColorPicker","transparency":0,"value":"0055ff"},{"idx":"KeybindMenuTransparency","type":"Slider","value":"50"},{"idx":"movement_noclipkeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"target_tracer_customization","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"lighting_colorColorShift_Top","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"movement_slideboostvalue","type":"Slider","value":"1.1"},{"idx":"ambience_volume","type":"Slider","value":"1"},{"idx":"esp_box_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"viewmodel_offset_z","type":"Slider","value":"-0.3"},{"idx":"custom_tracer_speed","type":"Slider","value":"2"},{"idx":"esp_effects_particle_color1","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"target_hit_notify_duration","type":"Slider","value":"1"},{"idx":"name_spoofer_name","type":"Input","text":""},{"idx":"camera_aspect_ratio_y","type":"Slider","value":"1"},{"idx":"autoban_second","type":"Dropdown","value":"Katana"},{"idx":"indicator_ragebot_status_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"autoban_second_delay","type":"Slider","value":"0"},{"idx":"autoban_map_delay","type":"Slider","value":"0"},{"idx":"aimbot_fill_color3","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"animation_player_speed","type":"Slider","value":"1"},{"idx":"ragebot_void_spam_hide","type":"Slider","value":"0.25"},{"idx":"esp_healthbar_color_start","type":"ColorPicker","transparency":0,"value":"fbe186"},{"idx":"esp_healthbar_color_middle","type":"ColorPicker","transparency":0,"value":"e5c248"},{"idx":"anti_aim_floor_hide_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"esp_weapon_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"anti_aim_custom_yaw","type":"Slider","value":"0"},{"idx":"lighting_colorAmbient","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_blur","type":"Slider","value":"0"},{"idx":"aimbot_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"viewmodel_body_transparency","type":"Slider","value":"100"},{"idx":"target_hit_notify_text","type":"Dropdown","mutli":true,"value":{"Hit {NAME} for {DMG} in the {PART}":true}},{"idx":"lighting_number_ExposureCompensation","type":"Slider","value":"-1.1"},{"idx":"ragebot_mode","type":"Dropdown","value":"gun"},{"idx":"anti_aim_custom_pitch","type":"Slider","value":"0"},{"idx":"silent_fill_color1","type":"ColorPicker","transparency":0.9727272727272728,"value":"f2bb68"},{"idx":"exploits_firerate","type":"Slider","value":"100"},{"idx":"target_highlight_fill","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"third_person_keybind","type":"KeyPicker","key":"H","mode":"Toggle"},{"idx":"NotificationPositionY","type":"Slider","value":"60"},{"idx":"animation_player_custom_input","type":"Input","text":""},{"idx":"movement_velocitykeybind","type":"KeyPicker","key":"G","mode":"Always"},{"idx":"targeting_maxdistance","type":"Slider","value":"250"},{"idx":"targeting_ignore_protected_settings","type":"Dropdown","mutli":true,"value":{"katana deflecting":true,"blocked by riot shield":true}},{"idx":"lighting_colorColorShift_Bottom","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_bounds_type","type":"Dropdown","mutli":false,"value":"dynamic"},{"idx":"esp_fill_color2","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"silent_fov_rotation_speed","type":"Slider","value":"0.1"},{"idx":"crosshair_length","type":"Slider","value":"7"},{"idx":"weather_lifetime_multiplier","type":"Slider","value":"100"},{"idx":"indicator_ragebot_style","type":"Dropdown","mutli":true,"value":{"status":true,"text":true}},{"idx":"crosshair_outline_color_3","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_fill_color1","type":"ColorPicker","transparency":0,"value":"f1d983"},{"idx":"ragebot_shoot_attempts","type":"Slider","value":"1"},{"idx":"esp_box_rotation","type":"Slider","value":"0"},{"idx":"crosshair_color_4","type":"ColorPicker","transparency":0,"value":"dbb634"},{"idx":"crosshair_color_2","type":"ColorPicker","transparency":0,"value":"dfc053"},{"idx":"camera_aspect_ratio_x","type":"Slider","value":"1"},{"idx":"crosshair_color_1","type":"ColorPicker","transparency":0,"value":"e3ca71"},{"idx":"viewmodel_frames_value","type":"Slider","value":"1"},{"idx":"ragebot_priority_targets","type":"Dropdown","mutli":true,"value":[]},{"idx":"shoot_sound_custom_value","type":"Input","text":""},{"idx":"custom_tracer_glow","type":"Slider","value":"5"},{"idx":"atmosphere_offset","type":"Slider","value":"0.4"},{"idx":"silent_fill_color3","type":"ColorPicker","transparency":0.9409090909090909,"value":"f5b14b"},{"idx":"lighting_number_Brightness","type":"Slider","value":"1.7"},{"idx":"silent_fov_lerp","type":"Slider","value":"0.25"},{"idx":"target_ui_position_x","type":"Slider","value":"50"},{"idx":"triggerbot_shoot_delay","type":"Slider","value":"0"},{"idx":"ambience_value","type":"Dropdown","value":"Rain"},{"idx":"aimbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"viewmodel_options","type":"Dropdown","mutli":true,"value":{"jump animation":true,"shoot animation":true,"muzzle flash":true,"sway":true,"sprint animation":true,"idle animation":true,"bobbing":true,"slide animation":true}},{"idx":"esp_skeleton_thickness","type":"Slider","value":"1"},{"idx":"lighting_number_FogEnd","type":"Slider","value":"2500"},{"idx":"custom_tracer_length","type":"Slider","value":"4"},{"idx":"weather_color_3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_rotation_speed","type":"Slider","value":"0.1"},{"idx":"aimbot_color2","type":"ColorPicker","transparency":0,"value":"e4f2ff"},{"idx":"targeting_reactiontime","type":"Slider","value":"30"},{"idx":"color_correction_brightness","type":"Slider","value":"-0.05"},{"idx":"silent_color3","type":"ColorPicker","transparency":0.4363636363636364,"value":"000000"},{"idx":"custom_tracer_width","type":"Slider","value":"0.2"},{"idx":"atmosphere_glare","type":"Slider","value":"4"},{"idx":"custom_tracer_color2","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"indicator_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"crosshair_lerp","type":"Slider","value":"0.25"},{"idx":"silent_fill_color2","type":"ColorPicker","transparency":0.8545454545454545,"value":"000000"},{"idx":"ragebot_void_spam_attack","type":"Slider","value":"0.01"},{"idx":"viewmodel_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"triggerbot_reaction_time","type":"Slider","value":"25"},{"idx":"hit_effects_settings","type":"Dropdown","mutli":true,"value":{"stack damage together":true}},{"idx":"silent_color1","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"hit_sounds_selected","type":"Dropdown","mutli":false,"value":"impact"},{"idx":"weather_color_1","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"lighting_number_FogStart","type":"Slider","value":"0"},{"idx":"viewmodel_recoil","type":"Slider","value":"0"},{"idx":"crosshair_color_3","type":"ColorPicker","transparency":0,"value":"ddbb43"},{"idx":"esp_effects_particle_color2","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"target_highlight_type","type":"Dropdown","mutli":false,"value":"AlwaysOnTop"},{"idx":"targeting_part","type":"Dropdown","mutli":false,"value":"Head"},{"idx":"esp_healthbar_health_lerp","type":"Slider","value":"0.05"},{"idx":"ragebot_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_effects_aura_value","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_effects_col_1","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"indicator_offset_x","type":"Slider","value":"0"},{"idx":"indicator_ammo_max_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_4","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"silent_radius","type":"Slider","value":"110"},{"idx":"esp_distance_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_chams_alpha_fill","type":"Slider","value":"-1"},{"idx":"lighting_number_ClockTime","type":"Slider","value":"9.2"},{"idx":"hit_effects_col_2","type":"ColorPicker","transparency":0,"value":"dab329"},{"idx":"camera_fov_changer_amount","type":"Slider","value":"100"}]}]],
            ['[LEGIT] Winter'] = [[{"objects":[{"idx":"animation_player_enabled","type":"Toggle","value":false},{"idx":"target_highlight","type":"Toggle","value":false},{"idx":"silent_showfov","type":"Toggle","value":true},{"idx":"item_remove_vignette","type":"Toggle","value":true},{"idx":"lighting_toggle_ClockTime","type":"Toggle","value":true},{"idx":"esp_healthbar_moving","type":"Toggle","value":false},{"idx":"ragebot_enabled","type":"Toggle","value":false},{"idx":"aimbot_match_axis","type":"Toggle","value":true},{"idx":"movement_noclip","type":"Toggle","value":false},{"idx":"silent_closest_part","type":"Toggle","value":true},{"idx":"esp_skeleton","type":"Toggle","value":true},{"idx":"camera_fov_changer","type":"Toggle","value":true},{"idx":"third_person_enabled","type":"Toggle","value":false},{"idx":"esp_skeleton_outline","type":"Toggle","value":false},{"idx":"silent_manipulation","type":"Toggle","value":false},{"idx":"NotificationColors","type":"Toggle","value":false},{"idx":"NotificationClips","type":"Toggle","value":false},{"idx":"silent_fov_fill","type":"Toggle","value":true},{"idx":"esp_override_appearance","type":"Toggle","value":false},{"idx":"lighting_bool_GlobalShadows","type":"Toggle","value":true},{"idx":"KeybindMenu","type":"Toggle","value":true},{"idx":"silent_toggle","type":"Toggle","value":true},{"idx":"skybox_enabled","type":"Toggle","value":true},{"idx":"auto_load_silent","type":"Toggle","value":false},{"idx":"lighting_toggle_ColorShift_Top","type":"Toggle","value":false},{"idx":"target_hit_notify","type":"Toggle","value":false},{"idx":"lighting_toggle_FogEnd","type":"Toggle","value":false},{"idx":"esp_world_distance","type":"Toggle","value":true},{"idx":"chat_spam_order","type":"Toggle","value":false},{"idx":"silent_fov_outline","type":"Toggle","value":true},{"idx":"lighting_toggle_ColorShift_Bottom","type":"Toggle","value":true},{"idx":"esp_world_name","type":"Toggle","value":true},{"idx":"targeting_visibleonly","type":"Toggle","value":true},{"idx":"hit_effects_disable_marker","type":"Toggle","value":true},{"idx":"color_correction_enabled","type":"Toggle","value":true},{"idx":"exploits_full_auto","type":"Toggle","value":true},{"idx":"spoof_device_enabled","type":"Toggle","value":false},{"idx":"targeting_disableflash","type":"Toggle","value":true},{"idx":"autoban_weapons","type":"Toggle","value":true},{"idx":"lighting_toggle_Ambient","type":"Toggle","value":true},{"idx":"viewmodel_offset","type":"Toggle","value":true},{"idx":"esp_effects_particle","type":"Toggle","value":true},{"idx":"weather_enabled","type":"Toggle","value":true},{"idx":"name_spoofer","type":"Toggle","value":false},{"idx":"esp_box","type":"Toggle","value":false},{"idx":"autoban_maps","type":"Toggle","value":true},{"idx":"auto_queue_enabled","type":"Toggle","value":false},{"idx":"ragebot_priority","type":"Toggle","value":true},{"idx":"esp_effects_aura","type":"Toggle","value":false},{"idx":"lighting_toggle_FogStart","type":"Toggle","value":false},{"idx":"movement_slideboost","type":"Toggle","value":true},{"idx":"auto_load_enabled","type":"Toggle","value":false},{"idx":"target_tracer","type":"Toggle","value":false},{"idx":"esp_name","type":"Toggle","value":true},{"idx":"anti_aim_enabled","type":"Toggle","value":false},{"idx":"sunrays_enabled","type":"Toggle","value":true},{"idx":"shoot_sound_change","type":"Toggle","value":true},{"idx":"crosshair_disable_game","type":"Toggle","value":true},{"idx":"movement_infinite_double_jump","type":"Toggle","value":false},{"idx":"esp_box_moving","type":"Toggle","value":false},{"idx":"hit_effects_enabled","type":"Toggle","value":true},{"idx":"movement_double_jump_height","type":"Toggle","value":true},{"idx":"indicator_ammo","type":"Toggle","value":true},{"idx":"loadout_unrestricted","type":"Toggle","value":false},{"idx":"esp_fill_moving","type":"Toggle","value":true},{"idx":"crosshair_enabled","type":"Toggle","value":true},{"idx":"hit_effects_weld","type":"Toggle","value":false},{"idx":"anti_aim_floor_hide","type":"Toggle","value":false},{"idx":"movement_fly","type":"Toggle","value":false},{"idx":"esp_body_color","type":"Toggle","value":false},{"idx":"aimbot_fov_outline","type":"Toggle","value":true},{"idx":"crosshair_outline","type":"Toggle","value":true},{"idx":"esp_healthbar","type":"Toggle","value":true},{"idx":"movement_velocity","type":"Toggle","value":false},{"idx":"custom_tracer_outline","type":"Toggle","value":false},{"idx":"esp_weapon","type":"Toggle","value":true},{"idx":"esp_healthbar_resize","type":"Toggle","value":false},{"idx":"esp_chams","type":"Toggle","value":true},{"idx":"item_status_enabled","type":"Toggle","value":true},{"idx":"aimbot_fov_fill","type":"Toggle","value":true},{"idx":"hit_effects_disable_numbers","type":"Toggle","value":true},{"idx":"hit_sounds_enabled","type":"Toggle","value":true},{"idx":"arcade_auto_ammo","type":"Toggle","value":false},{"idx":"silent_visualize","type":"Toggle","value":true},{"idx":"hit_sounds_disable","type":"Toggle","value":true},{"idx":"aimbot_showfov","type":"Toggle","value":true},{"idx":"viewmodel_chams","type":"Toggle","value":true},{"idx":"camera_aspect_ratio","type":"Toggle","value":false},{"idx":"aimbot_fov_moving","type":"Toggle","value":false},{"idx":"targeting_limitdistance","type":"Toggle","value":false},{"idx":"exploits_always_backstab","type":"Toggle","value":false},{"idx":"viewmodel_frames_override","type":"Toggle","value":false},{"idx":"silent_fov_moving","type":"Toggle","value":true},{"idx":"indicator_ragebot","type":"Toggle","value":false},{"idx":"indicator_manipulated","type":"Toggle","value":false},{"idx":"chat_spam_enabled","type":"Toggle","value":false},{"idx":"esp_material","type":"Toggle","value":false},{"idx":"aimbot_closest_part","type":"Toggle","value":false},{"idx":"custom_tracer_enabled","type":"Toggle","value":true},{"idx":"aimbot_delay_position","type":"Toggle","value":true},{"idx":"esp_world_image","type":"Toggle","value":true},{"idx":"esp_distance","type":"Toggle","value":true},{"idx":"ragebot_void_spam","type":"Toggle","value":false},{"idx":"lighting_toggle_ExposureCompensation","type":"Toggle","value":true},{"idx":"lighting_toggle_FogColor","type":"Toggle","value":false},{"idx":"camera_anti_flashbang","type":"Toggle","value":false},{"idx":"esp_fill","type":"Toggle","value":false},{"idx":"ambience_enabled","type":"Toggle","value":true},{"idx":"lighting_toggle_Brightness","type":"Toggle","value":true},{"idx":"bloom_enabled","type":"Toggle","value":true},{"idx":"auto_select_enabled","type":"Toggle","value":false},{"idx":"targeting_ignore_protected","type":"Toggle","value":true},{"idx":"atmosphere_enabled","type":"Toggle","value":true},{"idx":"ragebot_priority_notification","type":"Toggle","value":true},{"idx":"triggerbot_enabled","type":"Toggle","value":true},{"idx":"exploits_no_spread","type":"Toggle","value":false},{"idx":"esp_show_team","type":"Toggle","value":false},{"idx":"aimbot_toggle","type":"Toggle","value":true},{"idx":"esp_healthbar_type","type":"Dropdown","mutli":false,"value":"gradient"},{"idx":"ragebot_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"triggerbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"crosshair_offset","type":"Slider","value":"0"},{"idx":"bloom_threshold","type":"Slider","value":"0.85"},{"idx":"indicator_ragebot_text_color","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"movement_velocityvalue","type":"Slider","value":"50"},{"idx":"silent_outline_color1","type":"ColorPicker","transparency":0.8409090909090909,"value":"bddfff"},{"idx":"silent_fov_rotation","type":"Slider","value":"0"},{"idx":"esp_effects_aura_color1","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"silent_color2","type":"ColorPicker","transparency":0,"value":"e4f2ff"},{"idx":"esp_fill_rotation_speed","type":"Slider","value":"0.5"},{"idx":"esp_effects_particle_color3","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"indicator_ammo_style","type":"Dropdown","mutli":true,"value":{"ammo":true,"max ammo":true,"reserve":true}},{"idx":"lighting_colorColorShift_Bottom","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_speed","type":"Slider","value":"1"},{"idx":"aimbot_fov_rotation_speed","type":"Slider","value":"1"},{"idx":"esp_weapon_rotation","type":"Slider","value":"0"},{"idx":"NotificationStyleSortOrder","type":"Dropdown","mutli":false,"value":"Default"},{"idx":"crosshair_bounce","type":"Slider","value":"0"},{"idx":"aimbot_fov_rotation","type":"Slider","value":"0"},{"idx":"bloom_size","type":"Slider","value":"50"},{"idx":"crosshair_length","type":"Slider","value":"7"},{"idx":"indicator_lerp","type":"Slider","value":"0.25"},{"idx":"aimbot_color3","type":"ColorPicker","transparency":0,"value":"c8e4ff"},{"idx":"viewmodel_offset_z","type":"Slider","value":"-0.7"},{"idx":"aimbot_outline_color2","type":"ColorPicker","transparency":0.7,"value":"cbe6ff"},{"idx":"auto_select_Secondary","type":"Dropdown","value":"Daggers"},{"idx":"silent_outline_color2","type":"ColorPicker","transparency":0.7,"value":"cbe6ff"},{"idx":"crosshair_color_1","type":"ColorPicker","transparency":0,"value":"d1e9ff"},{"idx":"auto_select_Primary","type":"Dropdown","value":"Assault Rifle"},{"idx":"aimbot_delay_smooth_x","type":"Slider","value":"4"},{"idx":"viewmodel_chams_settings","type":"Dropdown","mutli":true,"value":{"through walls":true}},{"idx":"esp_world_distance_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_fill_color2","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"esp_world_object_scale","type":"Slider","value":"75"},{"idx":"esp_chams_color2","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"NotificationBarStyle","type":"Dropdown","mutli":false,"value":"Top"},{"idx":"movement_flyvalue","type":"Slider","value":"50"},{"idx":"silent_keybind","type":"KeyPicker","key":"LeftAlt","mode":"Always"},{"idx":"spoof_device_type","type":"Dropdown","value":"controller"},{"idx":"esp_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_fill_color3","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"chat_spam_text","type":"Dropdown","mutli":true,"value":[]},{"idx":"crosshair_outline_color_3","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"triggerbot_settings","type":"Dropdown","mutli":true,"value":{"no delay between targets":true,"anti katana":true}},{"idx":"custom_tracer_selected","type":"Dropdown","mutli":false,"value":"lightning"},{"idx":"esp_name_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_yaw","type":"Dropdown","value":"random"},{"idx":"animation_player_keybind","type":"KeyPicker","key":"T","mode":"Toggle"},{"idx":"NotificationColorsFont","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_effects_aura_color2","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"viewmodel_offset_y","type":"Slider","value":"0"},{"idx":"ragebot_void_spam_attack","type":"Slider","value":"0.01"},{"idx":"esp_material_value","type":"Dropdown","value":"Neon"},{"idx":"aimbot_delay_smooth_y","type":"Slider","value":"4"},{"idx":"shoot_sound_volume","type":"Slider","value":"1"},{"idx":"weather_rate_multiplier","type":"Slider","value":"1"},{"idx":"esp_weapon_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_whitelist","type":"Dropdown","mutli":true,"value":{"Flashbang":true,"Smoke Grenade":true,"Satchel":true,"Subspace Tripmine":true,"Molotov":true,"Grenade":true}},{"idx":"weather_color_2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_outline_color3","type":"ColorPicker","transparency":0.25,"value":"cee8ff"},{"idx":"esp_body_color_value","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_healthbar_color_end","type":"ColorPicker","transparency":0,"value":"227bce"},{"idx":"indicator_text_style","type":"Dropdown","mutli":false,"value":"lower"},{"idx":"esp_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"item_status_override","type":"Dropdown","value":"Prime"},{"idx":"crosshair_color_4","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"viewmodel_chams_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_position_lerp","type":"Slider","value":"0.5"},{"idx":"indicator_manipulated_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationClipsDistance","type":"Slider","value":"200"},{"idx":"indicator_reserve_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_color","type":"ColorPicker","transparency":0,"value":"f6fbff"},{"idx":"esp_weapon_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_1","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_skeleton_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"animation_player_start_position","type":"Slider","value":"0"},{"idx":"esp_box_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_chams_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_world_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"targeting_forgettime","type":"Slider","value":"0"},{"idx":"ragebot_priority_settings","type":"Dropdown","mutli":true,"value":{"voided players":true,"attackers":true}},{"idx":"esp_healthbar_speed","type":"Slider","value":"1"},{"idx":"esp_effects_aura_color3","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"esp_distance_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_bounds_width_scale","type":"Slider","value":"100"},{"idx":"NotificationAnchorStyle","type":"Dropdown","mutli":false,"value":"Center"},{"idx":"autoban_first","type":"Dropdown","value":"Riot Shield"},{"idx":"color_correction_contrast","type":"Slider","value":"0"},{"idx":"hit_effects_material","type":"Dropdown","mutli":false,"value":"ForceField"},{"idx":"atmosphere_haze","type":"Slider","value":"0"},{"idx":"triggerbot_part_blacklist","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_sounds_volume","type":"Slider","value":"0.9"},{"idx":"indicator_offset_y","type":"Slider","value":"25"},{"idx":"NotificationColorsMain","type":"ColorPicker","transparency":0,"value":"1c1c1c"},{"idx":"viewmodel_offset_x","type":"Slider","value":"0"},{"idx":"viewmodel_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"indicator_ammo_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_2","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"animation_player_value","type":"Dropdown","mutli":false,"value":"floss"},{"idx":"aimbot_outline_color3","type":"ColorPicker","transparency":0.25,"value":"cee8ff"},{"idx":"triggerbot_max_distance","type":"Slider","value":"250"},{"idx":"silent_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"sunrays_intensity","type":"Slider","value":"0.25"},{"idx":"custom_tracer_lifetime","type":"Slider","value":"1"},{"idx":"esp_healthbar_color_start","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"triggerbot_reaction_time_offset","type":"Slider","value":"5"},{"idx":"bloom_intensity","type":"Slider","value":"1.38"},{"idx":"cosmetics_changer_save_data","type":"Input","text":"{\"Crossbow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Crossbow\"}},\"Grenade Launcher\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Uranium Launcher\"}},\"Medkit\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Milk & Cookies\"}},\"Burst Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Burst Rifle\"}},\"Flashbang\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Shining Star\"}},\"Subspace Tripmine\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Subspace Tripmine\"}},\"Flamethrower\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Glitterthrower\"}},\"Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"name\":\"Dynamite\",\"enabled\":true}},\"Fists\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"name\":\"Festive Fists\",\"enabled\":true}},\"RPG\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Squid Launcher\"}},\"Scythe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Crystal Scythe\"}},\"Slingshot\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Harp\"}},\"Battle Axe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Keyttle Axe\"}},\"Flare Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Firework Gun\"}},\"Molotov\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Torch\"}},\"Shotgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Shotgun\"}},\"Permafrost\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Snowman Permafrost\"}},\"Trowel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Paintbrush\"}},\"Riot Shield\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Masterpiece\"}},\"Assault Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Empress\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"name\":\"Tommy Gun\",\"enabled\":true}},\"Sniper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Hyper Sniper\"}},\"Maul\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Maul\"}},\"Warpstone\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Warpeye\"}},\"Shorty\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Not So Shorty\"}},\"Jump Pad\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Jolly Man\"}},\"Distortion\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Sleighstortion\"}},\"Knife\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Keyrambit\"}},\"Chainsaw\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Festive Buzzsaw\"}},\"Warper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Frost Warper\"}},\"Bow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"name\":\"Spellslinger\",\"enabled\":true},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"name\":\"Key Bow\",\"enabled\":true}},\"Spray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Nail Gun\"}},\"Daggers\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"name\":\"Crystal Daggers\",\"enabled\":true}},\"Energy Pistols\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Pistols\"}},\"Handgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Warp Handgun\"}},\"Energy Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Rifle\"}},\"Katana\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Arch Katana\"}},\"Satchel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Potion Satchel\"}},\"War Horn\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Air Horn\"}},\"Uzi\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Money Gun\"}},\"Smoke Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Hourglass\"}},\"Exogun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Midnight Festive Exogun\"}},\"Freeze Ray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Spider Ray\"}},\"Gunblade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Boneblade\"}},\"Paintball Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Snowball Gun\"}},\"Minigun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Fighter Jet\"}},\"Revolver\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Spellslinger\"},\"finisher\":{\"enabled\":true,\"name\":\"Freeze\"},\"skin\":{\"enabled\":true,\"name\":\"Peppermint Sheriff\"}}}"},{"idx":"aimbot_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"auto_select_Utility","type":"Dropdown","value":"Grenade"},{"idx":"KeybindMenuValue","type":"Dropdown","mutli":false,"value":"Active"},{"idx":"esp_healthbar_slices","type":"Slider","value":"1"},{"idx":"crosshair_bounce_speed","type":"Slider","value":"2.9"},{"idx":"anti_aim_pitch","type":"Dropdown","value":"random"},{"idx":"lighting_colorFogColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"weather_timescale_multiplier","type":"Slider","value":"1"},{"idx":"esp_body_disables","type":"Dropdown","mutli":true,"value":[]},{"idx":"movement_double_jump_height_multiplier","type":"Slider","value":"1.1"},{"idx":"esp_fill_rotation","type":"Slider","value":"45"},{"idx":"viewmodel_chams_alpha_fill","type":"Slider","value":"-0.1"},{"idx":"aimbot_radius","type":"Slider","value":"100"},{"idx":"viewmodel_frames_value","type":"Slider","value":"1"},{"idx":"esp_world_name_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_forget_time","type":"Slider","value":"1.5"},{"idx":"crosshair_rotation","type":"Slider","value":"45"},{"idx":"hit_effects_col_3","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"target_highlight_outline","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_distance_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_floor_hide_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"color_correction_saturation","type":"Slider","value":"1"},{"idx":"movement_flykeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"NotificationTransparency","type":"Slider","value":"35"},{"idx":"esp_skeleton_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_start","type":"Slider","value":"0"},{"idx":"esp_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"hit_effects_selected","type":"Dropdown","mutli":true,"value":{"fortnite damage":true,"slashes":true}},{"idx":"esp_name_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"chat_spam_mode","type":"Dropdown","value":"custom"},{"idx":"aimbot_fill_color1","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"aimbot_delay_smooth_jump","type":"Slider","value":"10"},{"idx":"silent_hitchance","type":"Slider","value":"100"},{"idx":"crosshair_color_2","type":"ColorPicker","transparency":0,"value":"bbdfff"},{"idx":"esp_body_transparency","type":"Slider","value":"100"},{"idx":"atmosphere_density","type":"Slider","value":"0.45"},{"idx":"esp_distance_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"targeting_reactiontime","type":"Slider","value":"30"},{"idx":"custom_tracer_emission","type":"Slider","value":"1"},{"idx":"animation_player_end_position","type":"Slider","value":"100"},{"idx":"aimbot_fov_lerp","type":"Slider","value":"0.25"},{"idx":"weather_value","type":"Dropdown","value":"Snow"},{"idx":"auto_queue_mode","type":"Dropdown","value":"1v1"},{"idx":"color_correction_tint","type":"ColorPicker","transparency":0,"value":"bddfff"},{"idx":"aimbot_outline_color1","type":"ColorPicker","transparency":0.8409090909090909,"value":"bddfff"},{"idx":"esp_effects_particle_value","type":"Dropdown","mutli":true,"value":{"glowing":true}},{"idx":"atmosphere_decay","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"crosshair_thickness","type":"Slider","value":"2"},{"idx":"weapon_filter","type":"Input","text":""},{"idx":"esp_name_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"targeting_closest_part_blacklist","type":"Dropdown","mutli":true,"value":{"LeftHand":true,"RightLowerArm":true,"LeftFoot":true,"LeftLowerArm":true,"RightLowerLeg":true,"RightHand":true,"RightFoot":true,"LeftLowerLeg":true}},{"idx":"indicator_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"atmosphere_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"shoot_sound_change_value","type":"Dropdown","mutli":false,"value":"crossbow"},{"idx":"aimbot_smoothing","type":"Slider","value":"10"},{"idx":"auto_select_Melee","type":"Dropdown","value":"Riot Shield"},{"idx":"custom_tracer_glow","type":"Slider","value":"5"},{"idx":"movement_noclipkeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"target_tracer_customization","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"lighting_colorColorShift_Top","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"movement_slideboostvalue","type":"Slider","value":"1.1"},{"idx":"ambience_volume","type":"Slider","value":"0.5"},{"idx":"third_person_keybind","type":"KeyPicker","key":"H","mode":"Toggle"},{"idx":"esp_box_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_speed","type":"Slider","value":"2"},{"idx":"esp_effects_particle_color1","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"custom_tracer_color2","type":"ColorPicker","transparency":0,"value":"f6fbff"},{"idx":"NotificationPositionX","type":"Slider","value":"50"},{"idx":"camera_aspect_ratio_y","type":"Slider","value":"1"},{"idx":"NotificationColorsOutline","type":"ColorPicker","transparency":0,"value":"323232"},{"idx":"indicator_ragebot_status_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationColorsAccent","type":"ColorPicker","transparency":0,"value":"0055ff"},{"idx":"KeybindMenuTransparency","type":"Slider","value":"50"},{"idx":"indicator_offset_x","type":"Slider","value":"0"},{"idx":"ragebot_void_spam_hide","type":"Slider","value":"0.25"},{"idx":"lighting_number_ExposureCompensation","type":"Slider","value":"-1.1"},{"idx":"esp_healthbar_color_middle","type":"ColorPicker","transparency":0,"value":"4e99de"},{"idx":"target_hit_notify_duration","type":"Slider","value":"1"},{"idx":"name_spoofer_name","type":"Input","text":""},{"idx":"autoban_second","type":"Dropdown","value":"Katana"},{"idx":"esp_weapon_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_blur","type":"Slider","value":"0"},{"idx":"aimbot_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"lighting_colorAmbient","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"target_hit_notify_text","type":"Dropdown","mutli":true,"value":{"Hit {NAME} for {DMG} in the {PART}":true}},{"idx":"ragebot_mode","type":"Dropdown","value":"gun"},{"idx":"esp_box_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_rotation_speed","type":"Slider","value":"0"},{"idx":"silent_fill_color1","type":"ColorPicker","transparency":0.9363636363636364,"value":"bddfff"},{"idx":"hit_sounds_selected","type":"Dropdown","mutli":false,"value":"sparkle"},{"idx":"triggerbot_scoped","type":"Dropdown","mutli":true,"value":{"Sniper":true,"Crossbow":true}},{"idx":"animation_player_speed","type":"Slider","value":"1"},{"idx":"anti_aim_custom_yaw","type":"Slider","value":"0"},{"idx":"NotificationPositionY","type":"Slider","value":"60"},{"idx":"animation_player_custom_input","type":"Input","text":""},{"idx":"custom_tracer_fade","type":"Slider","value":"1"},{"idx":"targeting_maxdistance","type":"Slider","value":"250"},{"idx":"anti_aim_custom_pitch","type":"Slider","value":"0"},{"idx":"esp_fill_color2","type":"ColorPicker","transparency":0,"value":"00396d"},{"idx":"esp_bounds_type","type":"Dropdown","mutli":false,"value":"dynamic"},{"idx":"silent_fov_rotation_speed","type":"Slider","value":"0.1"},{"idx":"ragebot_weapon","type":"Dropdown","value":"secondary"},{"idx":"weather_lifetime_multiplier","type":"Slider","value":"100"},{"idx":"indicator_ragebot_style","type":"Dropdown","mutli":true,"value":{"status":true,"text":true}},{"idx":"movement_velocitykeybind","type":"KeyPicker","key":"G","mode":"Always"},{"idx":"targeting_ignore_protected_settings","type":"Dropdown","mutli":true,"value":{"katana deflecting":true}},{"idx":"esp_fill_color1","type":"ColorPicker","transparency":0,"value":"94c2ed"},{"idx":"target_highlight_fill","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"viewmodel_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_name_type","type":"Dropdown","mutli":false,"value":"Name"},{"idx":"crosshair_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"camera_aspect_ratio_x","type":"Slider","value":"1"},{"idx":"ragebot_priority_targets","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_name_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"sunrays_spread","type":"Slider","value":"1"},{"idx":"viewmodel_recoil","type":"Slider","value":"0"},{"idx":"atmosphere_offset","type":"Slider","value":"0.4"},{"idx":"silent_fov_lerp","type":"Slider","value":"0.25"},{"idx":"silent_fill_color3","type":"ColorPicker","transparency":0.9409090909090909,"value":"bddfff"},{"idx":"lighting_number_Brightness","type":"Slider","value":"1.7"},{"idx":"ragebot_shoot_attempts","type":"Slider","value":"2"},{"idx":"esp_skeleton_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_shoot_delay","type":"Slider","value":"0"},{"idx":"ambience_value","type":"Dropdown","value":"Rain"},{"idx":"aimbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"viewmodel_options","type":"Dropdown","mutli":true,"value":{"aiming animation":true,"sway":true,"equip animation":true,"bobbing":true,"jump animation":true,"sprint animation":true,"muzzle flash":true,"shoot animation":true,"idle animation":true,"slide animation":true}},{"idx":"esp_skeleton_thickness","type":"Slider","value":"1"},{"idx":"lighting_number_FogEnd","type":"Slider","value":"2500"},{"idx":"silent_radius","type":"Slider","value":"45"},{"idx":"weather_color_3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_rotation_speed","type":"Slider","value":"0.1"},{"idx":"aimbot_color2","type":"ColorPicker","transparency":0,"value":"e4f2ff"},{"idx":"skybox_value","type":"Dropdown","value":"Smoke"},{"idx":"color_correction_brightness","type":"Slider","value":"-0.09"},{"idx":"silent_color3","type":"ColorPicker","transparency":0,"value":"c8e4ff"},{"idx":"atmosphere_glare","type":"Slider","value":"4"},{"idx":"shoot_sound_custom_value","type":"Input","text":""},{"idx":"silent_fill_color2","type":"ColorPicker","transparency":0.8545454545454545,"value":"bddfff"},{"idx":"indicator_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"crosshair_lerp","type":"Slider","value":"0.25"},{"idx":"custom_tracer_length","type":"Slider","value":"4"},{"idx":"custom_tracer_width","type":"Slider","value":"0.2"},{"idx":"lighting_technology","type":"Dropdown","mutli":false,"value":"Future"},{"idx":"triggerbot_reaction_time","type":"Slider","value":"25"},{"idx":"hit_effects_settings","type":"Dropdown","mutli":true,"value":{"stack damage together":true}},{"idx":"silent_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"weather_color_1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_fov_changer_amount","type":"Slider","value":"100"},{"idx":"lighting_number_FogStart","type":"Slider","value":"0"},{"idx":"ragebot_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"crosshair_color_3","type":"ColorPicker","transparency":0,"value":"b1d9ff"},{"idx":"esp_effects_particle_color2","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"target_highlight_type","type":"Dropdown","mutli":false,"value":"AlwaysOnTop"},{"idx":"targeting_part","type":"Dropdown","mutli":false,"value":"Head"},{"idx":"esp_healthbar_health_lerp","type":"Slider","value":"0.05"},{"idx":"aimbot_fill_color3","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"esp_effects_aura_value","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_effects_col_1","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"indicator_ammo_max_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"indicator_ammo_divider_color","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"crosshair_outline_color_4","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"exploits_firerate","type":"Slider","value":"100"},{"idx":"esp_distance_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_rotation","type":"Slider","value":"0"},{"idx":"esp_chams_alpha_fill","type":"Slider","value":"-1"},{"idx":"hit_effects_col_2","type":"ColorPicker","transparency":0,"value":"a6d4ff"},{"idx":"lighting_number_ClockTime","type":"Slider","value":"9.2"}]}]],
            ["[LEGIT] Rem's Config"] = [[{"objects":[{"idx":"animation_player_enabled","type":"Toggle","value":false},{"idx":"target_highlight","type":"Toggle","value":false},{"idx":"silent_showfov","type":"Toggle","value":true},{"idx":"item_remove_vignette","type":"Toggle","value":true},{"idx":"lighting_toggle_ClockTime","type":"Toggle","value":true},{"idx":"esp_healthbar_moving","type":"Toggle","value":false},{"idx":"ragebot_enabled","type":"Toggle","value":false},{"idx":"aimbot_match_axis","type":"Toggle","value":true},{"idx":"movement_noclip","type":"Toggle","value":false},{"idx":"silent_closest_part","type":"Toggle","value":true},{"idx":"esp_skeleton","type":"Toggle","value":true},{"idx":"camera_fov_changer","type":"Toggle","value":true},{"idx":"third_person_enabled","type":"Toggle","value":false},{"idx":"esp_skeleton_outline","type":"Toggle","value":false},{"idx":"silent_manipulation","type":"Toggle","value":false},{"idx":"NotificationColors","type":"Toggle","value":false},{"idx":"NotificationClips","type":"Toggle","value":false},{"idx":"silent_fov_fill","type":"Toggle","value":true},{"idx":"esp_override_appearance","type":"Toggle","value":false},{"idx":"lighting_bool_GlobalShadows","type":"Toggle","value":true},{"idx":"KeybindMenu","type":"Toggle","value":true},{"idx":"silent_toggle","type":"Toggle","value":true},{"idx":"skybox_enabled","type":"Toggle","value":true},{"idx":"auto_load_silent","type":"Toggle","value":false},{"idx":"lighting_toggle_ColorShift_Top","type":"Toggle","value":false},{"idx":"target_hit_notify","type":"Toggle","value":false},{"idx":"lighting_toggle_FogEnd","type":"Toggle","value":false},{"idx":"esp_world_distance","type":"Toggle","value":true},{"idx":"chat_spam_order","type":"Toggle","value":false},{"idx":"silent_fov_outline","type":"Toggle","value":true},{"idx":"lighting_toggle_ColorShift_Bottom","type":"Toggle","value":true},{"idx":"esp_world_name","type":"Toggle","value":true},{"idx":"targeting_visibleonly","type":"Toggle","value":true},{"idx":"hit_effects_disable_marker","type":"Toggle","value":true},{"idx":"color_correction_enabled","type":"Toggle","value":true},{"idx":"exploits_full_auto","type":"Toggle","value":true},{"idx":"spoof_device_enabled","type":"Toggle","value":false},{"idx":"targeting_disableflash","type":"Toggle","value":true},{"idx":"autoban_weapons","type":"Toggle","value":true},{"idx":"lighting_toggle_Ambient","type":"Toggle","value":true},{"idx":"viewmodel_offset","type":"Toggle","value":true},{"idx":"esp_effects_particle","type":"Toggle","value":true},{"idx":"weather_enabled","type":"Toggle","value":true},{"idx":"name_spoofer","type":"Toggle","value":false},{"idx":"esp_box","type":"Toggle","value":false},{"idx":"autoban_maps","type":"Toggle","value":true},{"idx":"auto_queue_enabled","type":"Toggle","value":false},{"idx":"ragebot_priority","type":"Toggle","value":true},{"idx":"esp_effects_aura","type":"Toggle","value":false},{"idx":"lighting_toggle_FogStart","type":"Toggle","value":false},{"idx":"movement_slideboost","type":"Toggle","value":true},{"idx":"auto_load_enabled","type":"Toggle","value":false},{"idx":"target_tracer","type":"Toggle","value":false},{"idx":"esp_name","type":"Toggle","value":true},{"idx":"anti_aim_enabled","type":"Toggle","value":false},{"idx":"sunrays_enabled","type":"Toggle","value":false},{"idx":"shoot_sound_change","type":"Toggle","value":true},{"idx":"crosshair_disable_game","type":"Toggle","value":false},{"idx":"movement_infinite_double_jump","type":"Toggle","value":false},{"idx":"esp_box_moving","type":"Toggle","value":false},{"idx":"hit_effects_enabled","type":"Toggle","value":true},{"idx":"movement_double_jump_height","type":"Toggle","value":true},{"idx":"indicator_ammo","type":"Toggle","value":true},{"idx":"loadout_unrestricted","type":"Toggle","value":false},{"idx":"esp_fill_moving","type":"Toggle","value":true},{"idx":"crosshair_enabled","type":"Toggle","value":false},{"idx":"hit_effects_weld","type":"Toggle","value":false},{"idx":"anti_aim_floor_hide","type":"Toggle","value":false},{"idx":"movement_fly","type":"Toggle","value":false},{"idx":"esp_body_color","type":"Toggle","value":false},{"idx":"aimbot_fov_outline","type":"Toggle","value":true},{"idx":"crosshair_outline","type":"Toggle","value":true},{"idx":"esp_healthbar","type":"Toggle","value":true},{"idx":"movement_velocity","type":"Toggle","value":false},{"idx":"custom_tracer_outline","type":"Toggle","value":false},{"idx":"esp_weapon","type":"Toggle","value":true},{"idx":"esp_healthbar_resize","type":"Toggle","value":false},{"idx":"esp_chams","type":"Toggle","value":true},{"idx":"item_status_enabled","type":"Toggle","value":true},{"idx":"aimbot_fov_fill","type":"Toggle","value":true},{"idx":"hit_effects_disable_numbers","type":"Toggle","value":true},{"idx":"hit_sounds_enabled","type":"Toggle","value":true},{"idx":"arcade_auto_ammo","type":"Toggle","value":false},{"idx":"silent_visualize","type":"Toggle","value":true},{"idx":"hit_sounds_disable","type":"Toggle","value":true},{"idx":"aimbot_showfov","type":"Toggle","value":true},{"idx":"viewmodel_chams","type":"Toggle","value":true},{"idx":"camera_aspect_ratio","type":"Toggle","value":false},{"idx":"aimbot_fov_moving","type":"Toggle","value":false},{"idx":"targeting_limitdistance","type":"Toggle","value":false},{"idx":"exploits_always_backstab","type":"Toggle","value":false},{"idx":"viewmodel_frames_override","type":"Toggle","value":false},{"idx":"silent_fov_moving","type":"Toggle","value":true},{"idx":"indicator_ragebot","type":"Toggle","value":false},{"idx":"indicator_manipulated","type":"Toggle","value":false},{"idx":"chat_spam_enabled","type":"Toggle","value":false},{"idx":"esp_material","type":"Toggle","value":false},{"idx":"aimbot_closest_part","type":"Toggle","value":false},{"idx":"custom_tracer_enabled","type":"Toggle","value":true},{"idx":"aimbot_delay_position","type":"Toggle","value":true},{"idx":"esp_world_image","type":"Toggle","value":true},{"idx":"esp_distance","type":"Toggle","value":true},{"idx":"ragebot_void_spam","type":"Toggle","value":false},{"idx":"lighting_toggle_ExposureCompensation","type":"Toggle","value":true},{"idx":"lighting_toggle_FogColor","type":"Toggle","value":false},{"idx":"camera_anti_flashbang","type":"Toggle","value":true},{"idx":"esp_fill","type":"Toggle","value":false},{"idx":"ambience_enabled","type":"Toggle","value":true},{"idx":"lighting_toggle_Brightness","type":"Toggle","value":true},{"idx":"bloom_enabled","type":"Toggle","value":true},{"idx":"auto_select_enabled","type":"Toggle","value":false},{"idx":"targeting_ignore_protected","type":"Toggle","value":true},{"idx":"atmosphere_enabled","type":"Toggle","value":true},{"idx":"ragebot_priority_notification","type":"Toggle","value":true},{"idx":"triggerbot_enabled","type":"Toggle","value":true},{"idx":"exploits_no_spread","type":"Toggle","value":false},{"idx":"esp_show_team","type":"Toggle","value":false},{"idx":"aimbot_toggle","type":"Toggle","value":true},{"idx":"esp_healthbar_type","type":"Dropdown","mutli":false,"value":"gradient"},{"idx":"ragebot_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"triggerbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"crosshair_offset","type":"Slider","value":"5"},{"idx":"bloom_threshold","type":"Slider","value":"0.85"},{"idx":"indicator_ragebot_text_color","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"movement_velocityvalue","type":"Slider","value":"50"},{"idx":"silent_outline_color1","type":"ColorPicker","transparency":0.7863636363636364,"value":"c576bd"},{"idx":"silent_fov_rotation","type":"Slider","value":"0"},{"idx":"esp_effects_aura_color1","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"silent_color2","type":"ColorPicker","transparency":0,"value":"e4c4ca"},{"idx":"esp_fill_rotation_speed","type":"Slider","value":"0.5"},{"idx":"esp_effects_particle_color3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"indicator_ammo_style","type":"Dropdown","mutli":true,"value":{"ammo":true,"max ammo":true,"reserve":true}},{"idx":"lighting_colorColorShift_Bottom","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_speed","type":"Slider","value":"1"},{"idx":"aimbot_fov_rotation_speed","type":"Slider","value":"1"},{"idx":"esp_weapon_rotation","type":"Slider","value":"0"},{"idx":"NotificationStyleSortOrder","type":"Dropdown","mutli":false,"value":"Default"},{"idx":"crosshair_bounce","type":"Slider","value":"5"},{"idx":"aimbot_fov_rotation","type":"Slider","value":"0"},{"idx":"bloom_size","type":"Slider","value":"50"},{"idx":"crosshair_length","type":"Slider","value":"13"},{"idx":"indicator_lerp","type":"Slider","value":"0.25"},{"idx":"aimbot_color3","type":"ColorPicker","transparency":0,"value":"d7a6c3"},{"idx":"viewmodel_offset_z","type":"Slider","value":"-0.7"},{"idx":"aimbot_outline_color2","type":"ColorPicker","transparency":0.7,"value":"e38bde"},{"idx":"auto_select_Secondary","type":"Dropdown","value":"Daggers"},{"idx":"silent_outline_color2","type":"ColorPicker","transparency":0.7,"value":"e38cde"},{"idx":"crosshair_color_1","type":"ColorPicker","transparency":0,"value":"fccbfa"},{"idx":"auto_select_Primary","type":"Dropdown","value":"Assault Rifle"},{"idx":"aimbot_delay_smooth_x","type":"Slider","value":"4"},{"idx":"viewmodel_chams_settings","type":"Dropdown","mutli":true,"value":{"through walls":true}},{"idx":"esp_world_distance_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_fill_color2","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"esp_world_object_scale","type":"Slider","value":"75"},{"idx":"esp_chams_color2","type":"ColorPicker","transparency":0,"value":"ff4ded"},{"idx":"NotificationBarStyle","type":"Dropdown","mutli":false,"value":"Top"},{"idx":"movement_flyvalue","type":"Slider","value":"50"},{"idx":"silent_keybind","type":"KeyPicker","key":"LeftAlt","mode":"Always"},{"idx":"spoof_device_type","type":"Dropdown","value":"controller"},{"idx":"esp_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_fill_color3","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"chat_spam_text","type":"Dropdown","mutli":true,"value":[]},{"idx":"crosshair_outline_color_3","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"triggerbot_settings","type":"Dropdown","mutli":true,"value":{"no delay between targets":true,"anti katana":true}},{"idx":"custom_tracer_selected","type":"Dropdown","mutli":false,"value":"lightning"},{"idx":"esp_name_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_yaw","type":"Dropdown","value":"random"},{"idx":"animation_player_keybind","type":"KeyPicker","key":"T","mode":"Toggle"},{"idx":"NotificationColorsFont","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_effects_aura_color2","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"viewmodel_offset_y","type":"Slider","value":"0"},{"idx":"ragebot_void_spam_attack","type":"Slider","value":"0.01"},{"idx":"esp_material_value","type":"Dropdown","value":"Neon"},{"idx":"aimbot_delay_smooth_y","type":"Slider","value":"4"},{"idx":"shoot_sound_volume","type":"Slider","value":"1"},{"idx":"weather_rate_multiplier","type":"Slider","value":"1"},{"idx":"esp_weapon_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_whitelist","type":"Dropdown","mutli":true,"value":{"Flashbang":true,"Smoke Grenade":true,"Satchel":true,"Subspace Tripmine":true,"Molotov":true,"Grenade":true}},{"idx":"weather_color_2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_outline_color3","type":"ColorPicker","transparency":0.2681818181818182,"value":"f296ee"},{"idx":"esp_body_color_value","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_healthbar_color_end","type":"ColorPicker","transparency":0,"value":"9d539b"},{"idx":"indicator_text_style","type":"Dropdown","mutli":false,"value":"lower"},{"idx":"esp_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"item_status_override","type":"Dropdown","value":"Prime"},{"idx":"crosshair_color_4","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"viewmodel_chams_color2","type":"ColorPicker","transparency":0,"value":"d8e9ff"},{"idx":"custom_tracer_position_lerp","type":"Slider","value":"0.5"},{"idx":"indicator_manipulated_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationClipsDistance","type":"Slider","value":"200"},{"idx":"indicator_reserve_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_color","type":"ColorPicker","transparency":0,"value":"c47cc1"},{"idx":"esp_weapon_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_1","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_skeleton_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"animation_player_start_position","type":"Slider","value":"0"},{"idx":"esp_box_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_chams_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_world_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"targeting_forgettime","type":"Slider","value":"0"},{"idx":"ragebot_priority_settings","type":"Dropdown","mutli":true,"value":{"voided players":true,"attackers":true}},{"idx":"esp_healthbar_speed","type":"Slider","value":"1"},{"idx":"esp_effects_aura_color3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"esp_distance_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_bounds_width_scale","type":"Slider","value":"100"},{"idx":"NotificationAnchorStyle","type":"Dropdown","mutli":false,"value":"Center"},{"idx":"autoban_first","type":"Dropdown","value":"Riot Shield"},{"idx":"color_correction_contrast","type":"Slider","value":"0"},{"idx":"hit_effects_material","type":"Dropdown","mutli":false,"value":"ForceField"},{"idx":"atmosphere_haze","type":"Slider","value":"10"},{"idx":"triggerbot_part_blacklist","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_sounds_volume","type":"Slider","value":"0.9"},{"idx":"indicator_offset_y","type":"Slider","value":"25"},{"idx":"NotificationColorsMain","type":"ColorPicker","transparency":0,"value":"1c1c1c"},{"idx":"viewmodel_offset_x","type":"Slider","value":"0"},{"idx":"viewmodel_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"indicator_ammo_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_2","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"animation_player_value","type":"Dropdown","mutli":false,"value":"floss"},{"idx":"aimbot_outline_color3","type":"ColorPicker","transparency":0.2681818181818182,"value":"f296ee"},{"idx":"triggerbot_max_distance","type":"Slider","value":"250"},{"idx":"silent_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"sunrays_intensity","type":"Slider","value":"0.25"},{"idx":"custom_tracer_lifetime","type":"Slider","value":"1"},{"idx":"esp_healthbar_color_start","type":"ColorPicker","transparency":0,"value":"fbb8f8"},{"idx":"triggerbot_reaction_time_offset","type":"Slider","value":"5"},{"idx":"bloom_intensity","type":"Slider","value":"1.38"},{"idx":"cosmetics_changer_save_data","type":"Input","text":"{\"Crossbow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Crossbow\"}},\"Grenade Launcher\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Uranium Launcher\"}},\"Medkit\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Milk & Cookies\"}},\"Burst Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Burst Rifle\"}},\"Flashbang\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Shining Star\"}},\"Subspace Tripmine\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Subspace Tripmine\"}},\"Flamethrower\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glitterthrower\"}},\"Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Dynamite\",\"enabled\":true}},\"Fists\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Festive Fists\",\"enabled\":true}},\"RPG\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Squid Launcher\"}},\"Scythe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Crystal Scythe\"}},\"Slingshot\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Harp\"}},\"Battle Axe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Keyttle Axe\"}},\"Flare Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Firework Gun\"}},\"Molotov\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Torch\"}},\"Shotgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Shotgun\"}},\"Permafrost\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Snowman Permafrost\"}},\"Trowel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Paintbrush\"}},\"Riot Shield\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Masterpiece\"}},\"Assault Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Tommy Gun\",\"enabled\":true}},\"Sniper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hyper Sniper\"}},\"Maul\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Maul\"}},\"Warpstone\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Warpeye\"}},\"Shorty\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Not So Shorty\"}},\"Jump Pad\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Jolly Man\"}},\"Distortion\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Sleighstortion\"}},\"Knife\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Keyrambit\"}},\"Chainsaw\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Festive Buzzsaw\"}},\"Warper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Frost Warper\"}},\"Bow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"name\":\"Ice Queen\",\"enabled\":true},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Key Bow\",\"enabled\":true}},\"Spray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Nail Gun\"}},\"Daggers\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Crystal Daggers\",\"enabled\":true}},\"Energy Pistols\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Pistols\"}},\"Handgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Warp Handgun\"}},\"Energy Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Rifle\"}},\"Katana\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Arch Katana\"}},\"Satchel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Potion Satchel\"}},\"War Horn\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Air Horn\"}},\"Uzi\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Money Gun\"}},\"Smoke Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hourglass\"}},\"Exogun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Midnight Festive Exogun\"}},\"Freeze Ray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Spider Ray\"}},\"Gunblade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Boneblade\"}},\"Paintball Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Snowball Gun\"}},\"Minigun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Fighter Jet\"}},\"Revolver\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Peppermint Sheriff\"}}}"},{"idx":"aimbot_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"auto_select_Utility","type":"Dropdown","value":"Grenade"},{"idx":"KeybindMenuValue","type":"Dropdown","mutli":false,"value":"Active"},{"idx":"esp_healthbar_slices","type":"Slider","value":"1"},{"idx":"crosshair_bounce_speed","type":"Slider","value":"2.9"},{"idx":"anti_aim_pitch","type":"Dropdown","value":"random"},{"idx":"lighting_colorFogColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"weather_timescale_multiplier","type":"Slider","value":"1"},{"idx":"esp_body_disables","type":"Dropdown","mutli":true,"value":[]},{"idx":"movement_double_jump_height_multiplier","type":"Slider","value":"1.1"},{"idx":"esp_fill_rotation","type":"Slider","value":"45"},{"idx":"viewmodel_chams_alpha_fill","type":"Slider","value":"-1.6"},{"idx":"aimbot_radius","type":"Slider","value":"100"},{"idx":"viewmodel_frames_value","type":"Slider","value":"1"},{"idx":"esp_world_name_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_forget_time","type":"Slider","value":"1.5"},{"idx":"crosshair_rotation","type":"Slider","value":"0"},{"idx":"hit_effects_col_3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"target_highlight_outline","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_distance_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_floor_hide_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"color_correction_saturation","type":"Slider","value":"1"},{"idx":"movement_flykeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"NotificationTransparency","type":"Slider","value":"35"},{"idx":"esp_skeleton_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_start","type":"Slider","value":"0"},{"idx":"esp_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"hit_effects_selected","type":"Dropdown","mutli":true,"value":{"Electricity":true,"phantom forces":true}},{"idx":"esp_name_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"chat_spam_mode","type":"Dropdown","value":"custom"},{"idx":"aimbot_fill_color1","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"aimbot_delay_smooth_jump","type":"Slider","value":"10"},{"idx":"silent_hitchance","type":"Slider","value":"100"},{"idx":"crosshair_color_2","type":"ColorPicker","transparency":0,"value":"f7b1f4"},{"idx":"esp_body_transparency","type":"Slider","value":"100"},{"idx":"atmosphere_density","type":"Slider","value":"0.4"},{"idx":"esp_distance_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"targeting_reactiontime","type":"Slider","value":"30"},{"idx":"custom_tracer_emission","type":"Slider","value":"1"},{"idx":"animation_player_end_position","type":"Slider","value":"100"},{"idx":"aimbot_fov_lerp","type":"Slider","value":"0.25"},{"idx":"weather_value","type":"Dropdown","value":"Rain"},{"idx":"auto_queue_mode","type":"Dropdown","value":"1v1"},{"idx":"color_correction_tint","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_outline_color1","type":"ColorPicker","transparency":0.7863636363636364,"value":"c576bd"},{"idx":"esp_effects_particle_value","type":"Dropdown","mutli":true,"value":{"glowing":true}},{"idx":"atmosphere_decay","type":"ColorPicker","transparency":0,"value":"fecaff"},{"idx":"crosshair_thickness","type":"Slider","value":"2"},{"idx":"weapon_filter","type":"Input","text":""},{"idx":"esp_name_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"targeting_closest_part_blacklist","type":"Dropdown","mutli":true,"value":{"LeftFoot":true,"RightLowerArm":true,"LeftHand":true,"LeftLowerArm":true,"RightLowerLeg":true,"RightHand":true,"RightFoot":true,"LeftLowerLeg":true}},{"idx":"indicator_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"atmosphere_color","type":"ColorPicker","transparency":0,"value":"ffc8fd"},{"idx":"shoot_sound_change_value","type":"Dropdown","mutli":false,"value":"crossbow"},{"idx":"aimbot_smoothing","type":"Slider","value":"10"},{"idx":"auto_select_Melee","type":"Dropdown","value":"Riot Shield"},{"idx":"custom_tracer_glow","type":"Slider","value":"4"},{"idx":"movement_noclipkeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"target_tracer_customization","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"lighting_colorColorShift_Top","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"movement_slideboostvalue","type":"Slider","value":"1.1"},{"idx":"ambience_volume","type":"Slider","value":"0.5"},{"idx":"third_person_keybind","type":"KeyPicker","key":"H","mode":"Toggle"},{"idx":"esp_box_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_speed","type":"Slider","value":"2"},{"idx":"esp_effects_particle_color1","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"custom_tracer_color2","type":"ColorPicker","transparency":0,"value":"c47cc1"},{"idx":"NotificationPositionX","type":"Slider","value":"50"},{"idx":"camera_aspect_ratio_y","type":"Slider","value":"1"},{"idx":"NotificationColorsOutline","type":"ColorPicker","transparency":0,"value":"323232"},{"idx":"indicator_ragebot_status_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationColorsAccent","type":"ColorPicker","transparency":0,"value":"0055ff"},{"idx":"KeybindMenuTransparency","type":"Slider","value":"50"},{"idx":"indicator_offset_x","type":"Slider","value":"0"},{"idx":"ragebot_void_spam_hide","type":"Slider","value":"0.25"},{"idx":"lighting_number_ExposureCompensation","type":"Slider","value":"-1.1"},{"idx":"esp_healthbar_color_middle","type":"ColorPicker","transparency":0,"value":"bc75ba"},{"idx":"target_hit_notify_duration","type":"Slider","value":"1"},{"idx":"name_spoofer_name","type":"Input","text":""},{"idx":"autoban_second","type":"Dropdown","value":"Katana"},{"idx":"esp_weapon_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_blur","type":"Slider","value":"0"},{"idx":"aimbot_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"lighting_colorAmbient","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"target_hit_notify_text","type":"Dropdown","mutli":true,"value":{"Hit {NAME} for {DMG} in the {PART}":true}},{"idx":"ragebot_mode","type":"Dropdown","value":"gun"},{"idx":"esp_box_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_rotation_speed","type":"Slider","value":"0.2"},{"idx":"silent_fill_color1","type":"ColorPicker","transparency":0.85,"value":"823b75"},{"idx":"hit_sounds_selected","type":"Dropdown","mutli":false,"value":"sparkle"},{"idx":"triggerbot_scoped","type":"Dropdown","mutli":true,"value":{"Sniper":true,"Crossbow":true}},{"idx":"animation_player_speed","type":"Slider","value":"1"},{"idx":"anti_aim_custom_yaw","type":"Slider","value":"0"},{"idx":"NotificationPositionY","type":"Slider","value":"60"},{"idx":"animation_player_custom_input","type":"Input","text":""},{"idx":"custom_tracer_fade","type":"Slider","value":"1"},{"idx":"targeting_maxdistance","type":"Slider","value":"250"},{"idx":"anti_aim_custom_pitch","type":"Slider","value":"0"},{"idx":"esp_fill_color2","type":"ColorPicker","transparency":0.9409090909090909,"value":"320055"},{"idx":"esp_bounds_type","type":"Dropdown","mutli":false,"value":"dynamic"},{"idx":"silent_fov_rotation_speed","type":"Slider","value":"0.1"},{"idx":"ragebot_weapon","type":"Dropdown","value":"secondary"},{"idx":"weather_lifetime_multiplier","type":"Slider","value":"100"},{"idx":"indicator_ragebot_style","type":"Dropdown","mutli":true,"value":{"status":true,"text":true}},{"idx":"movement_velocitykeybind","type":"KeyPicker","key":"G","mode":"Always"},{"idx":"targeting_ignore_protected_settings","type":"Dropdown","mutli":true,"value":{"katana deflecting":true}},{"idx":"esp_fill_color1","type":"ColorPicker","transparency":0.5727272727272728,"value":"f296ee"},{"idx":"target_highlight_fill","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"viewmodel_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_name_type","type":"Dropdown","mutli":false,"value":"Name"},{"idx":"crosshair_settings","type":"Dropdown","mutli":true,"value":{"position on target":true}},{"idx":"camera_aspect_ratio_x","type":"Slider","value":"1"},{"idx":"ragebot_priority_targets","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_name_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"sunrays_spread","type":"Slider","value":"1"},{"idx":"viewmodel_recoil","type":"Slider","value":"0"},{"idx":"atmosphere_offset","type":"Slider","value":"0.4"},{"idx":"silent_fov_lerp","type":"Slider","value":"0.25"},{"idx":"silent_fill_color3","type":"ColorPicker","transparency":0.6,"value":"9f83a0"},{"idx":"lighting_number_Brightness","type":"Slider","value":"1.7"},{"idx":"ragebot_shoot_attempts","type":"Slider","value":"2"},{"idx":"esp_skeleton_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_shoot_delay","type":"Slider","value":"0"},{"idx":"ambience_value","type":"Dropdown","value":"Rain"},{"idx":"aimbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"viewmodel_options","type":"Dropdown","mutli":true,"value":{"muzzle flash":true,"sway":true,"equip animation":true,"bobbing":true,"jump animation":true,"aiming animation":true,"shoot animation":true,"idle animation":true,"sprint animation":true,"slide animation":true}},{"idx":"esp_skeleton_thickness","type":"Slider","value":"1"},{"idx":"lighting_number_FogEnd","type":"Slider","value":"2500"},{"idx":"silent_radius","type":"Slider","value":"45"},{"idx":"weather_color_3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_rotation_speed","type":"Slider","value":"0.1"},{"idx":"aimbot_color2","type":"ColorPicker","transparency":0,"value":"e4c4ca"},{"idx":"skybox_value","type":"Dropdown","value":"Heaven"},{"idx":"color_correction_brightness","type":"Slider","value":"-0.09"},{"idx":"silent_color3","type":"ColorPicker","transparency":0,"value":"d7a6c3"},{"idx":"atmosphere_glare","type":"Slider","value":"4.1"},{"idx":"shoot_sound_custom_value","type":"Input","text":""},{"idx":"silent_fill_color2","type":"ColorPicker","transparency":0.7,"value":"d7a6d5"},{"idx":"indicator_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"crosshair_lerp","type":"Slider","value":"0.25"},{"idx":"custom_tracer_length","type":"Slider","value":"4"},{"idx":"custom_tracer_width","type":"Slider","value":"0.2"},{"idx":"lighting_technology","type":"Dropdown","mutli":false,"value":"Future"},{"idx":"triggerbot_reaction_time","type":"Slider","value":"25"},{"idx":"hit_effects_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"silent_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"weather_color_1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_fov_changer_amount","type":"Slider","value":"100"},{"idx":"lighting_number_FogStart","type":"Slider","value":"0"},{"idx":"ragebot_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"crosshair_color_3","type":"ColorPicker","transparency":0,"value":"f5a3f1"},{"idx":"esp_effects_particle_color2","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"target_highlight_type","type":"Dropdown","mutli":false,"value":"AlwaysOnTop"},{"idx":"targeting_part","type":"Dropdown","mutli":false,"value":"Head"},{"idx":"esp_healthbar_health_lerp","type":"Slider","value":"0.05"},{"idx":"aimbot_fill_color3","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"esp_effects_aura_value","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_effects_col_1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"indicator_ammo_max_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"indicator_ammo_divider_color","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"crosshair_outline_color_4","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"exploits_firerate","type":"Slider","value":"100"},{"idx":"esp_distance_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_rotation","type":"Slider","value":"0"},{"idx":"esp_chams_alpha_fill","type":"Slider","value":"-1"},{"idx":"hit_effects_col_2","type":"ColorPicker","transparency":0,"value":"f6b9f4"},{"idx":"lighting_number_ClockTime","type":"Slider","value":"0"}]}]],
            ["[RAGE] Rem's Config"] = [[{"objects":[{"idx":"animation_player_enabled","type":"Toggle","value":true},{"idx":"target_highlight","type":"Toggle","value":false},{"idx":"silent_showfov","type":"Toggle","value":true},{"idx":"item_remove_vignette","type":"Toggle","value":true},{"idx":"lighting_toggle_ClockTime","type":"Toggle","value":true},{"idx":"esp_healthbar_moving","type":"Toggle","value":false},{"idx":"ragebot_enabled","type":"Toggle","value":true},{"idx":"aimbot_match_axis","type":"Toggle","value":false},{"idx":"movement_noclip","type":"Toggle","value":true},{"idx":"silent_closest_part","type":"Toggle","value":false},{"idx":"esp_skeleton","type":"Toggle","value":true},{"idx":"camera_fov_changer","type":"Toggle","value":true},{"idx":"third_person_enabled","type":"Toggle","value":true},{"idx":"esp_skeleton_outline","type":"Toggle","value":false},{"idx":"silent_manipulation","type":"Toggle","value":true},{"idx":"NotificationColors","type":"Toggle","value":false},{"idx":"NotificationClips","type":"Toggle","value":false},{"idx":"silent_fov_fill","type":"Toggle","value":true},{"idx":"esp_override_appearance","type":"Toggle","value":false},{"idx":"lighting_bool_GlobalShadows","type":"Toggle","value":true},{"idx":"KeybindMenu","type":"Toggle","value":true},{"idx":"silent_toggle","type":"Toggle","value":true},{"idx":"skybox_enabled","type":"Toggle","value":true},{"idx":"auto_load_silent","type":"Toggle","value":false},{"idx":"lighting_toggle_ColorShift_Top","type":"Toggle","value":false},{"idx":"target_hit_notify","type":"Toggle","value":false},{"idx":"lighting_toggle_FogEnd","type":"Toggle","value":false},{"idx":"esp_world_distance","type":"Toggle","value":true},{"idx":"chat_spam_order","type":"Toggle","value":false},{"idx":"silent_fov_outline","type":"Toggle","value":true},{"idx":"lighting_toggle_ColorShift_Bottom","type":"Toggle","value":true},{"idx":"esp_world_name","type":"Toggle","value":true},{"idx":"targeting_visibleonly","type":"Toggle","value":true},{"idx":"hit_effects_disable_marker","type":"Toggle","value":true},{"idx":"color_correction_enabled","type":"Toggle","value":true},{"idx":"exploits_full_auto","type":"Toggle","value":true},{"idx":"spoof_device_enabled","type":"Toggle","value":false},{"idx":"targeting_disableflash","type":"Toggle","value":false},{"idx":"autoban_weapons","type":"Toggle","value":true},{"idx":"lighting_toggle_Ambient","type":"Toggle","value":true},{"idx":"viewmodel_offset","type":"Toggle","value":true},{"idx":"esp_effects_particle","type":"Toggle","value":true},{"idx":"weather_enabled","type":"Toggle","value":true},{"idx":"name_spoofer","type":"Toggle","value":false},{"idx":"esp_box","type":"Toggle","value":false},{"idx":"autoban_maps","type":"Toggle","value":true},{"idx":"auto_queue_enabled","type":"Toggle","value":false},{"idx":"ragebot_priority","type":"Toggle","value":true},{"idx":"esp_effects_aura","type":"Toggle","value":false},{"idx":"lighting_toggle_FogStart","type":"Toggle","value":false},{"idx":"movement_slideboost","type":"Toggle","value":true},{"idx":"auto_load_enabled","type":"Toggle","value":false},{"idx":"target_tracer","type":"Toggle","value":false},{"idx":"esp_name","type":"Toggle","value":true},{"idx":"anti_aim_enabled","type":"Toggle","value":true},{"idx":"sunrays_enabled","type":"Toggle","value":false},{"idx":"shoot_sound_change","type":"Toggle","value":true},{"idx":"crosshair_disable_game","type":"Toggle","value":true},{"idx":"movement_infinite_double_jump","type":"Toggle","value":true},{"idx":"esp_box_moving","type":"Toggle","value":false},{"idx":"hit_effects_enabled","type":"Toggle","value":true},{"idx":"movement_double_jump_height","type":"Toggle","value":true},{"idx":"indicator_ammo","type":"Toggle","value":true},{"idx":"loadout_unrestricted","type":"Toggle","value":true},{"idx":"esp_fill_moving","type":"Toggle","value":true},{"idx":"crosshair_enabled","type":"Toggle","value":true},{"idx":"hit_effects_weld","type":"Toggle","value":false},{"idx":"anti_aim_floor_hide","type":"Toggle","value":true},{"idx":"movement_fly","type":"Toggle","value":true},{"idx":"esp_body_color","type":"Toggle","value":false},{"idx":"aimbot_fov_outline","type":"Toggle","value":true},{"idx":"crosshair_outline","type":"Toggle","value":true},{"idx":"esp_healthbar","type":"Toggle","value":true},{"idx":"movement_velocity","type":"Toggle","value":true},{"idx":"custom_tracer_outline","type":"Toggle","value":false},{"idx":"esp_weapon","type":"Toggle","value":true},{"idx":"esp_healthbar_resize","type":"Toggle","value":false},{"idx":"esp_chams","type":"Toggle","value":true},{"idx":"item_status_enabled","type":"Toggle","value":true},{"idx":"aimbot_fov_fill","type":"Toggle","value":true},{"idx":"hit_effects_disable_numbers","type":"Toggle","value":true},{"idx":"hit_sounds_enabled","type":"Toggle","value":true},{"idx":"arcade_auto_ammo","type":"Toggle","value":true},{"idx":"silent_visualize","type":"Toggle","value":true},{"idx":"hit_sounds_disable","type":"Toggle","value":true},{"idx":"aimbot_showfov","type":"Toggle","value":false},{"idx":"viewmodel_chams","type":"Toggle","value":true},{"idx":"camera_aspect_ratio","type":"Toggle","value":false},{"idx":"aimbot_fov_moving","type":"Toggle","value":false},{"idx":"targeting_limitdistance","type":"Toggle","value":false},{"idx":"exploits_always_backstab","type":"Toggle","value":true},{"idx":"viewmodel_frames_override","type":"Toggle","value":false},{"idx":"silent_fov_moving","type":"Toggle","value":true},{"idx":"indicator_ragebot","type":"Toggle","value":true},{"idx":"indicator_manipulated","type":"Toggle","value":true},{"idx":"chat_spam_enabled","type":"Toggle","value":false},{"idx":"esp_material","type":"Toggle","value":false},{"idx":"aimbot_closest_part","type":"Toggle","value":false},{"idx":"custom_tracer_enabled","type":"Toggle","value":true},{"idx":"aimbot_delay_position","type":"Toggle","value":false},{"idx":"esp_world_image","type":"Toggle","value":true},{"idx":"esp_distance","type":"Toggle","value":true},{"idx":"ragebot_void_spam","type":"Toggle","value":true},{"idx":"lighting_toggle_ExposureCompensation","type":"Toggle","value":true},{"idx":"lighting_toggle_FogColor","type":"Toggle","value":false},{"idx":"camera_anti_flashbang","type":"Toggle","value":true},{"idx":"esp_fill","type":"Toggle","value":false},{"idx":"ambience_enabled","type":"Toggle","value":true},{"idx":"lighting_toggle_Brightness","type":"Toggle","value":true},{"idx":"bloom_enabled","type":"Toggle","value":true},{"idx":"auto_select_enabled","type":"Toggle","value":true},{"idx":"targeting_ignore_protected","type":"Toggle","value":true},{"idx":"atmosphere_enabled","type":"Toggle","value":true},{"idx":"ragebot_priority_notification","type":"Toggle","value":true},{"idx":"triggerbot_enabled","type":"Toggle","value":false},{"idx":"exploits_no_spread","type":"Toggle","value":true},{"idx":"esp_show_team","type":"Toggle","value":false},{"idx":"aimbot_toggle","type":"Toggle","value":false},{"idx":"esp_healthbar_type","type":"Dropdown","mutli":false,"value":"gradient"},{"idx":"ragebot_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"triggerbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"crosshair_offset","type":"Slider","value":"5"},{"idx":"bloom_threshold","type":"Slider","value":"0.85"},{"idx":"indicator_ragebot_text_color","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"movement_velocityvalue","type":"Slider","value":"50"},{"idx":"silent_outline_color1","type":"ColorPicker","transparency":0.7863636363636364,"value":"c576bd"},{"idx":"silent_fov_rotation","type":"Slider","value":"0"},{"idx":"esp_effects_aura_color1","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"silent_color2","type":"ColorPicker","transparency":0,"value":"e4c4ca"},{"idx":"esp_fill_rotation_speed","type":"Slider","value":"0.5"},{"idx":"esp_effects_particle_color3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"indicator_ammo_style","type":"Dropdown","mutli":true,"value":{"ammo":true,"max ammo":true,"reserve":true}},{"idx":"lighting_colorColorShift_Bottom","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_speed","type":"Slider","value":"1"},{"idx":"aimbot_fov_rotation_speed","type":"Slider","value":"1"},{"idx":"esp_weapon_rotation","type":"Slider","value":"0"},{"idx":"NotificationStyleSortOrder","type":"Dropdown","mutli":false,"value":"Default"},{"idx":"crosshair_bounce","type":"Slider","value":"5"},{"idx":"aimbot_fov_rotation","type":"Slider","value":"0"},{"idx":"bloom_size","type":"Slider","value":"50"},{"idx":"crosshair_length","type":"Slider","value":"13"},{"idx":"indicator_lerp","type":"Slider","value":"0.25"},{"idx":"aimbot_color3","type":"ColorPicker","transparency":0,"value":"d7a6c3"},{"idx":"viewmodel_offset_z","type":"Slider","value":"-0.7"},{"idx":"aimbot_outline_color2","type":"ColorPicker","transparency":0.7,"value":"e38bde"},{"idx":"auto_select_Secondary","type":"Dropdown","value":"Bow"},{"idx":"silent_outline_color2","type":"ColorPicker","transparency":0.7,"value":"e38cde"},{"idx":"crosshair_color_1","type":"ColorPicker","transparency":0,"value":"fccbfa"},{"idx":"auto_select_Primary","type":"Dropdown","value":"Daggers"},{"idx":"aimbot_delay_smooth_x","type":"Slider","value":"4"},{"idx":"viewmodel_chams_settings","type":"Dropdown","mutli":true,"value":{"through walls":true}},{"idx":"esp_world_distance_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_fill_color2","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"esp_world_object_scale","type":"Slider","value":"75"},{"idx":"esp_chams_color2","type":"ColorPicker","transparency":0,"value":"ff4ded"},{"idx":"NotificationBarStyle","type":"Dropdown","mutli":false,"value":"Top"},{"idx":"movement_flyvalue","type":"Slider","value":"100"},{"idx":"silent_keybind","type":"KeyPicker","key":"LeftAlt","mode":"Always"},{"idx":"spoof_device_type","type":"Dropdown","value":"controller"},{"idx":"esp_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_fill_color3","type":"ColorPicker","transparency":1,"value":"000000"},{"idx":"chat_spam_text","type":"Dropdown","mutli":true,"value":[]},{"idx":"crosshair_outline_color_3","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"triggerbot_settings","type":"Dropdown","mutli":true,"value":{"no delay between targets":true,"anti katana":true}},{"idx":"custom_tracer_selected","type":"Dropdown","mutli":false,"value":"lightning"},{"idx":"esp_name_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_yaw","type":"Dropdown","value":"random"},{"idx":"animation_player_keybind","type":"KeyPicker","key":"...","mode":"Toggle"},{"idx":"NotificationColorsFont","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_effects_aura_color2","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"viewmodel_offset_y","type":"Slider","value":"0"},{"idx":"ragebot_void_spam_attack","type":"Slider","value":"0.01"},{"idx":"esp_material_value","type":"Dropdown","value":"Neon"},{"idx":"aimbot_delay_smooth_y","type":"Slider","value":"4"},{"idx":"shoot_sound_volume","type":"Slider","value":"1"},{"idx":"weather_rate_multiplier","type":"Slider","value":"1"},{"idx":"esp_weapon_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_world_whitelist","type":"Dropdown","mutli":true,"value":{"Flashbang":true,"Smoke Grenade":true,"Satchel":true,"Subspace Tripmine":true,"Molotov":true,"Grenade":true}},{"idx":"weather_color_2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"silent_outline_color3","type":"ColorPicker","transparency":0.2681818181818182,"value":"f296ee"},{"idx":"esp_body_color_value","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_healthbar_color_end","type":"ColorPicker","transparency":0,"value":"9d539b"},{"idx":"indicator_text_style","type":"Dropdown","mutli":false,"value":"lower"},{"idx":"esp_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"item_status_override","type":"Dropdown","value":"Prime"},{"idx":"crosshair_color_4","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"viewmodel_chams_color2","type":"ColorPicker","transparency":0,"value":"d8e9ff"},{"idx":"custom_tracer_position_lerp","type":"Slider","value":"0.5"},{"idx":"indicator_manipulated_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationClipsDistance","type":"Slider","value":"200"},{"idx":"indicator_reserve_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_color","type":"ColorPicker","transparency":0,"value":"c47cc1"},{"idx":"esp_weapon_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_1","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_skeleton_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"animation_player_start_position","type":"Slider","value":"0"},{"idx":"esp_box_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_chams_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_world_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"targeting_forgettime","type":"Slider","value":"0"},{"idx":"ragebot_priority_settings","type":"Dropdown","mutli":true,"value":{"voided players":true,"attackers":true}},{"idx":"esp_healthbar_speed","type":"Slider","value":"1"},{"idx":"esp_effects_aura_color3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"esp_distance_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_bounds_width_scale","type":"Slider","value":"100"},{"idx":"NotificationAnchorStyle","type":"Dropdown","mutli":false,"value":"Center"},{"idx":"autoban_first","type":"Dropdown","value":"Riot Shield"},{"idx":"color_correction_contrast","type":"Slider","value":"0"},{"idx":"hit_effects_material","type":"Dropdown","mutli":false,"value":"ForceField"},{"idx":"atmosphere_haze","type":"Slider","value":"10"},{"idx":"triggerbot_part_blacklist","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_sounds_volume","type":"Slider","value":"0.9"},{"idx":"indicator_offset_y","type":"Slider","value":"25"},{"idx":"NotificationColorsMain","type":"ColorPicker","transparency":0,"value":"1c1c1c"},{"idx":"viewmodel_offset_x","type":"Slider","value":"0"},{"idx":"viewmodel_chams_alpha_outline","type":"Slider","value":"1"},{"idx":"indicator_ammo_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_outline_color_2","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"animation_player_value","type":"Dropdown","mutli":false,"value":"solar system"},{"idx":"aimbot_outline_color3","type":"ColorPicker","transparency":0.2681818181818182,"value":"f296ee"},{"idx":"triggerbot_max_distance","type":"Slider","value":"250"},{"idx":"silent_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true}},{"idx":"sunrays_intensity","type":"Slider","value":"0.25"},{"idx":"custom_tracer_lifetime","type":"Slider","value":"1"},{"idx":"esp_healthbar_color_start","type":"ColorPicker","transparency":0,"value":"fbb8f8"},{"idx":"triggerbot_reaction_time_offset","type":"Slider","value":"5"},{"idx":"bloom_intensity","type":"Slider","value":"1.38"},{"idx":"cosmetics_changer_save_data","type":"Input","text":"{\"Crossbow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Crossbow\"}},\"Grenade Launcher\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Uranium Launcher\"}},\"Medkit\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Milk & Cookies\"}},\"Burst Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Burst Rifle\"}},\"Flashbang\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Shining Star\"}},\"Subspace Tripmine\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Subspace Tripmine\"}},\"Flamethrower\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glitterthrower\"}},\"Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Dynamite\",\"enabled\":true}},\"Fists\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Festive Fists\",\"enabled\":true}},\"RPG\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Squid Launcher\"}},\"Scythe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Crystal Scythe\"}},\"Slingshot\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Harp\"}},\"Battle Axe\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Keyttle Axe\"}},\"Flare Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Firework Gun\"}},\"Molotov\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Torch\"}},\"Shotgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Shotgun\"}},\"Permafrost\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Snowman Permafrost\"}},\"Trowel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Paintbrush\"}},\"Riot Shield\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Masterpiece\"}},\"Assault Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Tommy Gun\",\"enabled\":true}},\"Sniper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hyper Sniper\"}},\"Maul\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Glorious Maul\"}},\"Warpstone\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Warpeye\"}},\"Shorty\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Not So Shorty\"}},\"Jump Pad\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Jolly Man\"}},\"Distortion\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Sleighstortion\"}},\"Knife\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Keyrambit\"}},\"Chainsaw\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Festive Buzzsaw\"}},\"Warper\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Frost Warper\"}},\"Bow\":{\"charm\":{\"enabled\":true},\"wrap\":{\"name\":\"Ice Queen\",\"enabled\":true},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Key Bow\",\"enabled\":true}},\"Spray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Nail Gun\"}},\"Daggers\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"name\":\"Crystal Daggers\",\"enabled\":true}},\"Energy Pistols\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Pistols\"}},\"Handgun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Warp Handgun\"}},\"Energy Rifle\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hacker Rifle\"}},\"Katana\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Arch Katana\"}},\"Satchel\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Potion Satchel\"}},\"War Horn\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Air Horn\"}},\"Uzi\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Money Gun\"}},\"Smoke Grenade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Hourglass\"}},\"Exogun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Midnight Festive Exogun\"}},\"Freeze Ray\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Spider Ray\"}},\"Gunblade\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Boneblade\"}},\"Paintball Gun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Snowball Gun\"}},\"Minigun\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Ice Queen\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Fighter Jet\"}},\"Revolver\":{\"charm\":{\"enabled\":true},\"wrap\":{\"enabled\":true,\"name\":\"Borealis\"},\"finisher\":{\"enabled\":true,\"name\":\"BONK!\"},\"skin\":{\"enabled\":true,\"name\":\"Peppermint Sheriff\"}}}"},{"idx":"aimbot_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"auto_select_Utility","type":"Dropdown","value":"Riot Shield"},{"idx":"KeybindMenuValue","type":"Dropdown","mutli":false,"value":"Active"},{"idx":"esp_healthbar_slices","type":"Slider","value":"1"},{"idx":"crosshair_bounce_speed","type":"Slider","value":"2.9"},{"idx":"anti_aim_pitch","type":"Dropdown","value":"random"},{"idx":"lighting_colorFogColor","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"weather_timescale_multiplier","type":"Slider","value":"1"},{"idx":"esp_body_disables","type":"Dropdown","mutli":true,"value":[]},{"idx":"movement_double_jump_height_multiplier","type":"Slider","value":"2"},{"idx":"esp_fill_rotation","type":"Slider","value":"45"},{"idx":"viewmodel_chams_alpha_fill","type":"Slider","value":"-1.6"},{"idx":"aimbot_radius","type":"Slider","value":"1000"},{"idx":"viewmodel_frames_value","type":"Slider","value":"1"},{"idx":"esp_world_name_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_forget_time","type":"Slider","value":"1.5"},{"idx":"crosshair_rotation","type":"Slider","value":"0"},{"idx":"hit_effects_col_3","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"target_highlight_outline","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_distance_rotation","type":"Slider","value":"0"},{"idx":"anti_aim_floor_hide_keybind","type":"KeyPicker","key":"...","mode":"Always"},{"idx":"color_correction_saturation","type":"Slider","value":"1"},{"idx":"movement_flykeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"NotificationTransparency","type":"Slider","value":"35"},{"idx":"esp_skeleton_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"shoot_sound_start","type":"Slider","value":"0"},{"idx":"esp_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"hit_effects_selected","type":"Dropdown","mutli":true,"value":{"Electricity":true,"phantom forces":true}},{"idx":"esp_name_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"chat_spam_mode","type":"Dropdown","value":"custom"},{"idx":"aimbot_fill_color1","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"aimbot_delay_smooth_jump","type":"Slider","value":"10"},{"idx":"silent_hitchance","type":"Slider","value":"100"},{"idx":"crosshair_color_2","type":"ColorPicker","transparency":0,"value":"f7b1f4"},{"idx":"esp_body_transparency","type":"Slider","value":"100"},{"idx":"atmosphere_density","type":"Slider","value":"0.4"},{"idx":"esp_distance_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"targeting_reactiontime","type":"Slider","value":"30"},{"idx":"custom_tracer_emission","type":"Slider","value":"1"},{"idx":"animation_player_end_position","type":"Slider","value":"100"},{"idx":"aimbot_fov_lerp","type":"Slider","value":"0.25"},{"idx":"weather_value","type":"Dropdown","value":"Rain"},{"idx":"auto_queue_mode","type":"Dropdown","value":"1v1"},{"idx":"color_correction_tint","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"aimbot_outline_color1","type":"ColorPicker","transparency":0.7863636363636364,"value":"c576bd"},{"idx":"esp_effects_particle_value","type":"Dropdown","mutli":true,"value":{"glowing":true}},{"idx":"atmosphere_decay","type":"ColorPicker","transparency":0,"value":"fecaff"},{"idx":"crosshair_thickness","type":"Slider","value":"2"},{"idx":"weapon_filter","type":"Input","text":""},{"idx":"esp_name_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"targeting_closest_part_blacklist","type":"Dropdown","mutli":true,"value":{"LeftHand":true,"RightLowerArm":true,"LeftFoot":true,"LeftLowerArm":true,"RightLowerLeg":true,"RightHand":true,"RightFoot":true,"LeftLowerLeg":true}},{"idx":"indicator_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"atmosphere_color","type":"ColorPicker","transparency":0,"value":"ffc8fd"},{"idx":"shoot_sound_change_value","type":"Dropdown","mutli":false,"value":"crossbow"},{"idx":"aimbot_smoothing","type":"Slider","value":"100"},{"idx":"auto_select_Melee","type":"Dropdown","value":"Riot Shield"},{"idx":"custom_tracer_glow","type":"Slider","value":"4"},{"idx":"movement_noclipkeybind","type":"KeyPicker","key":"X","mode":"Toggle"},{"idx":"target_tracer_customization","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"lighting_colorColorShift_Top","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"movement_slideboostvalue","type":"Slider","value":"2.5"},{"idx":"ambience_volume","type":"Slider","value":"0.5"},{"idx":"third_person_keybind","type":"KeyPicker","key":"H","mode":"Toggle"},{"idx":"esp_box_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"custom_tracer_speed","type":"Slider","value":"2"},{"idx":"esp_effects_particle_color1","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"custom_tracer_color2","type":"ColorPicker","transparency":0,"value":"c47cc1"},{"idx":"NotificationPositionX","type":"Slider","value":"50"},{"idx":"camera_aspect_ratio_y","type":"Slider","value":"1"},{"idx":"NotificationColorsOutline","type":"ColorPicker","transparency":0,"value":"323232"},{"idx":"indicator_ragebot_status_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"NotificationColorsAccent","type":"ColorPicker","transparency":0,"value":"0055ff"},{"idx":"KeybindMenuTransparency","type":"Slider","value":"50"},{"idx":"indicator_offset_x","type":"Slider","value":"0"},{"idx":"ragebot_void_spam_hide","type":"Slider","value":"0.25"},{"idx":"lighting_number_ExposureCompensation","type":"Slider","value":"-1.1"},{"idx":"esp_healthbar_color_middle","type":"ColorPicker","transparency":0,"value":"bc75ba"},{"idx":"target_hit_notify_duration","type":"Slider","value":"1"},{"idx":"name_spoofer_name","type":"Input","text":""},{"idx":"autoban_second","type":"Dropdown","value":"Katana"},{"idx":"esp_weapon_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_blur","type":"Slider","value":"0"},{"idx":"aimbot_fov_settings","type":"Dropdown","mutli":true,"value":{"position on target":true,"position on barrel":true}},{"idx":"lighting_colorAmbient","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"target_hit_notify_text","type":"Dropdown","mutli":true,"value":{"Hit {NAME} for {DMG} in the {PART}":true}},{"idx":"ragebot_mode","type":"Dropdown","value":"gun"},{"idx":"esp_box_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"crosshair_rotation_speed","type":"Slider","value":"0.2"},{"idx":"silent_fill_color1","type":"ColorPicker","transparency":0.85,"value":"823b75"},{"idx":"hit_sounds_selected","type":"Dropdown","mutli":false,"value":"sparkle"},{"idx":"triggerbot_scoped","type":"Dropdown","mutli":true,"value":{"Sniper":true,"Crossbow":true}},{"idx":"animation_player_speed","type":"Slider","value":"1"},{"idx":"anti_aim_custom_yaw","type":"Slider","value":"0"},{"idx":"NotificationPositionY","type":"Slider","value":"60"},{"idx":"animation_player_custom_input","type":"Input","text":""},{"idx":"custom_tracer_fade","type":"Slider","value":"1"},{"idx":"targeting_maxdistance","type":"Slider","value":"250"},{"idx":"anti_aim_custom_pitch","type":"Slider","value":"0"},{"idx":"esp_fill_color2","type":"ColorPicker","transparency":0.9409090909090909,"value":"320055"},{"idx":"esp_bounds_type","type":"Dropdown","mutli":false,"value":"dynamic"},{"idx":"silent_fov_rotation_speed","type":"Slider","value":"0.1"},{"idx":"ragebot_weapon","type":"Dropdown","value":"primary"},{"idx":"weather_lifetime_multiplier","type":"Slider","value":"100"},{"idx":"indicator_ragebot_style","type":"Dropdown","mutli":true,"value":{"status":true,"text":true}},{"idx":"movement_velocitykeybind","type":"KeyPicker","key":"G","mode":"Always"},{"idx":"targeting_ignore_protected_settings","type":"Dropdown","mutli":true,"value":{"katana deflecting":true,"blocked by riot shield":true}},{"idx":"esp_fill_color1","type":"ColorPicker","transparency":0.5727272727272728,"value":"f296ee"},{"idx":"target_highlight_fill","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"viewmodel_chams_color","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"esp_name_type","type":"Dropdown","mutli":false,"value":"Name"},{"idx":"crosshair_settings","type":"Dropdown","mutli":true,"value":{"position on target":true}},{"idx":"camera_aspect_ratio_x","type":"Slider","value":"1"},{"idx":"ragebot_priority_targets","type":"Dropdown","mutli":true,"value":[]},{"idx":"esp_name_color1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"sunrays_spread","type":"Slider","value":"1"},{"idx":"viewmodel_recoil","type":"Slider","value":"0"},{"idx":"atmosphere_offset","type":"Slider","value":"0.4"},{"idx":"silent_fov_lerp","type":"Slider","value":"0.25"},{"idx":"silent_fill_color3","type":"ColorPicker","transparency":0.6,"value":"9f83a0"},{"idx":"lighting_number_Brightness","type":"Slider","value":"1.7"},{"idx":"ragebot_shoot_attempts","type":"Slider","value":"2"},{"idx":"esp_skeleton_color2","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"triggerbot_shoot_delay","type":"Slider","value":"0"},{"idx":"ambience_value","type":"Dropdown","value":"Rain"},{"idx":"aimbot_keybind","type":"KeyPicker","key":"MB2","mode":"Hold"},{"idx":"viewmodel_options","type":"Dropdown","mutli":true,"value":{"tilt":true,"aiming animation":true,"sway":true,"equip animation":true,"bobbing":true,"jump animation":true,"muzzle flash":true,"shoot animation":true,"idle animation":true,"sprint animation":true,"slide animation":true}},{"idx":"esp_skeleton_thickness","type":"Slider","value":"1"},{"idx":"lighting_number_FogEnd","type":"Slider","value":"2500"},{"idx":"silent_radius","type":"Slider","value":"300"},{"idx":"weather_color_3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_rotation_speed","type":"Slider","value":"0.1"},{"idx":"aimbot_color2","type":"ColorPicker","transparency":0,"value":"e4c4ca"},{"idx":"skybox_value","type":"Dropdown","value":"Heaven"},{"idx":"color_correction_brightness","type":"Slider","value":"-0.09"},{"idx":"silent_color3","type":"ColorPicker","transparency":0,"value":"d7a6c3"},{"idx":"atmosphere_glare","type":"Slider","value":"4.1"},{"idx":"shoot_sound_custom_value","type":"Input","text":""},{"idx":"silent_fill_color2","type":"ColorPicker","transparency":0.7,"value":"d7a6d5"},{"idx":"indicator_font","type":"Dropdown","mutli":false,"value":"proggy tiny"},{"idx":"crosshair_lerp","type":"Slider","value":"0.25"},{"idx":"custom_tracer_length","type":"Slider","value":"4"},{"idx":"custom_tracer_width","type":"Slider","value":"0.2"},{"idx":"lighting_technology","type":"Dropdown","mutli":false,"value":"Future"},{"idx":"triggerbot_reaction_time","type":"Slider","value":"25"},{"idx":"hit_effects_settings","type":"Dropdown","mutli":true,"value":[]},{"idx":"silent_color1","type":"ColorPicker","transparency":1,"value":"ffffff"},{"idx":"weather_color_1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"camera_fov_changer_amount","type":"Slider","value":"100"},{"idx":"lighting_number_FogStart","type":"Slider","value":"0"},{"idx":"ragebot_settings","type":"Dropdown","mutli":true,"value":{"swap weapons when empty":true,"prefer projectile weapon":true}},{"idx":"crosshair_color_3","type":"ColorPicker","transparency":0,"value":"f5a3f1"},{"idx":"esp_effects_particle_color2","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"target_highlight_type","type":"Dropdown","mutli":false,"value":"AlwaysOnTop"},{"idx":"targeting_part","type":"Dropdown","mutli":false,"value":"Head"},{"idx":"esp_healthbar_health_lerp","type":"Slider","value":"0.05"},{"idx":"aimbot_fill_color3","type":"ColorPicker","transparency":0.8181818181818181,"value":"000000"},{"idx":"esp_effects_aura_value","type":"Dropdown","mutli":true,"value":[]},{"idx":"hit_effects_col_1","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"indicator_ammo_max_color","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"indicator_ammo_divider_color","type":"ColorPicker","transparency":0,"value":"f296ee"},{"idx":"crosshair_outline_color_4","type":"ColorPicker","transparency":0,"value":"000000"},{"idx":"exploits_firerate","type":"Slider","value":"15"},{"idx":"esp_distance_color3","type":"ColorPicker","transparency":0,"value":"ffffff"},{"idx":"esp_box_rotation","type":"Slider","value":"0"},{"idx":"esp_chams_alpha_fill","type":"Slider","value":"-1"},{"idx":"hit_effects_col_2","type":"ColorPicker","transparency":0,"value":"f6b9f4"},{"idx":"lighting_number_ClockTime","type":"Slider","value":"0"}]}]],
        }
    end
end
function Native.recovered37_Lw(captures)
    local capture03 = captures[3]
    local capture02 = captures[2]
    local capture01 = captures[1]
    local capture00 = captures[0]

    return function()
        if capture00.Value then
            local cFrame = capture03.CFrame

            capture01._current.Position = cFrame.Position + capture02
        end
    end
end
function Native.recovered38_c()
    return function()
        return Assets.read('ProggyClean.ttf')
    end
end
function Native.recovered39_a()
    return function()
        return Assets.read('fs-Tahoma-8px.ttf')
    end
end
function Native.recovered40_M(captures)
    local capture00 = captures[0]
    local capture10 = captures[10]
    local capture13 = captures[13]
    local capture07 = captures[7]
    local capture09 = captures[9]
    local capture03 = captures[3]
    local capture16 = captures[16]
    local capture01 = captures[1]
    local capture02 = captures[2]
    local capture06 = captures[6]
    local capture15 = captures[15]
    local capture05 = captures[5]
    local capture17 = captures[17]
    local capture12 = captures[12]
    local capture11 = captures[11]
    local capture04 = captures[4]
    local capture08 = captures[8]
    local capture14 = captures[14]

    return function(value020, value021, value022)
        local value023, value024 = capture08('Line'), capture08('Line')
        local value025 = capture14(1, capture03(capture13.Value))

        value023.Thickness, value024.Thickness = value025 + 2, value025
        value023.Color = Color3.new()

        local uIGradient = Instance.new('UIGradient', value024._frame)

        uIGradient.Color = value022
        uIGradient.Rotation = 0

        local uIGradient2 = Instance.new('UIGradient', value023._frame)

        uIGradient2.Color = capture12
        uIGradient2.Rotation = 0
        uIGradient2.Transparency, uIGradient.Transparency = capture07[3][capture07[2] ], capture07[3][capture07[2] ]
        value024.Color = Color3.new(1, 1, 1)
        value024.ZIndex = 2

        local value028, value029 = nil, 0
        local value, value2 = capture04.Value, capture11.Value
        local value3 = capture15.Value
        local value4 = capture06.Value
        local value034 = value021
        local position = capture17.CFrame.Position

        value028 = capture01.RenderStepped:Connect(function(value036)
            value029 = value029 + value036

            if value029 > value + value2 then
                value023:Remove()
                value024:Remove()

                return value028:Disconnect()
            end
            if value3 ~= 0 then
                local value037 = capture09(capture10(value029 / value3, 1))

                value034 = value020:Lerp(value021, value037)
            end

            local value038, value039 = capture05[3][capture05[2] ](value020)

            if not value039 then
                value023.Visible, value024.Visible = false, false

                return
            end

            local value040, value041 = capture05[3][capture05[2] ](value034)

            if not value041 then
                value023.Visible, value024.Visible = false, false

                return
            end
            if value029 > value then
                local value042 = (value029 - value) / value2
                local value043 = {}

                for index = 0, 9 do
                    __step(142)

                    local value045 = index / 9

                    capture02(value043, capture00(value045, value042 + (1 - value045) / 2))
                end

                value043 = capture16(value043)
                uIGradient.Transparency = value043

                if value4 then
                    uIGradient2.Transparency = value043
                end
            end
            if value4 then
                local unit = (value040 - value038).Unit

                value023.To, value023.From = value040 + unit, value038 - unit
                value023.Visible = true
            else
                value023.Visible = false
            end

            value024.To, value024.From = value040, value038
            value024.Visible = true
        end)
    end
end
function Native.recovered42_r()
    return function()
        return Assets.read('Minecraft-Bold.otf')
    end
end
function Native.recovered45_Ew(captures)
    local capture03 = captures[3]
    local capture00 = captures[0]
    local capture01 = captures[1]
    local capture02 = captures[2]

    return function(value006)
        local value007 = capture00[capture03]

        return capture01((capture02(0, value007.Y, 0) * capture02(value007.X, 0, 0)).LookVector, value006.Unit) > 0.5
    end
end
function Native.recovered46_y()
    return function()
        local protection_fake_positionFn, protection_fake_position_keybindFn = Toggles.protection_fake_position, Options.protection_fake_position_keybind

        do
            return function()
                return protection_fake_positionFn.Value and protection_fake_position_keybindFn:GetState()
            end
        end
    end
end
function Native.recovered47_D(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function()
        local value004 = capture01[3][capture01[2] ]()

        for key, value in next, capture00 do
            __step(157)

            if value.Type == 'Dropdown' and value.SpecialType == 'Player' then
                value:SetValues(value004)
            end
        end
    end
end
function Native.recovered48_s(captures)
    local capture01 = captures[1]
    local capture02 = captures[2]
    local capture00 = captures[0]
    local capture04 = captures[4]
    local capture03 = captures[3]

    return function(value007, value008)
        local value009 = capture01
        local value010, value011

        for key, value in value008 do
            __step(158)

            if capture03[key] or capture02[3][capture02[2] ][key] then
                continue
            elseif capture00(value) ~= 'Instance' or value.ClassName ~= 'MeshPart' then
                continue
            end

            local value014 = capture04[3][capture04[2] ](value.Position)
            local magnitude = (value014 - value007).Magnitude

            if magnitude < value009 then
                value009, value010 = magnitude, value
                value011 = value014
            end
        end

        return value010, value011
    end
end
function Native.recovered49_L(captures)
    local capture00 = captures[0]

    return function()
        capture00.Parent = Toggles.atmosphere_enabled.Value and game:GetService('Lighting') or nil

        if not capture00.Parent then
            return
        end

        capture00.Color = Options.atmosphere_color.Value
        capture00.Decay = Options.atmosphere_decay.Value
        capture00.Glare = Options.atmosphere_glare.Value
        capture00.Haze = Options.atmosphere_haze.Value
        capture00.Density = Options.atmosphere_density.Value
        capture00.Offset = Options.atmosphere_offset.Value
    end
end
function Native.recovered50_e(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function()
        if capture01[3][capture01[2] ] then
            local humanoid = capture00.Humanoid

            return humanoid and humanoid.Health > 0
        end
    end
end
function Native.recovered51_q()
    return function()
        return Assets.read('ProggyTiny.ttf')
    end
end
function Native.recovered52_I()
    return function()
        return Assets.read('PixelArial11.ttf')
    end
end
function Native.recovered53_G(captures)
    local capture06 = captures[6]
    local capture05 = captures[5]
    local capture04 = captures[4]
    local capture01 = captures[1]
    local capture03 = captures[3]
    local capture02 = captures[2]
    local capture00 = captures[0]

    return function()
        if capture05() < capture00[3][capture00[2] ] then
            return
        end

        capture00[3][capture00[2] ] = capture05() + 5

        local value = capture01.Value
        local value010 = capture02.default[value] or capture02.messages[value]

        if not value010 or #value010 == 0 then
            return
        end

        local value011 = 1

        if capture04.Value then
            capture03[3][capture03[2] ] = capture03[3][capture03[2] ] % #value010 + 1
            value011 = capture03[3][capture03[2] ]
        else
            value011 = math.random(1, #value010)
        end

        local value012 = value010[value011]

        capture06:SendAsync(value012)
    end
end
function Native.recovered54_f(captures)
    local capture00 = captures[0]

    return function(value003, value004)
        return value004 <= 1 and value003 or capture00(1 - value003.R, 1 - value003.G, 1 - value003.B)
    end
end
function Native.recovered56_d(captures)
    local capture04 = captures[4]
    local capture00 = captures[0]
    local capture01 = captures[1]
    local capture02 = captures[2]
    local capture03 = captures[3]

    return function()
        local newFn = ColorSequence.new
        local newFn2 = ColorSequenceKeypoint.new
        local fromHSVFn = Color3.fromHSV
        local value010 = 3
        local value011, value012 = {}, {}
        local value013 = 0
        local value014, value015 = 0, 0.25
        local esp_healthbar_typeFn, esp_healthbar_movingFn, esp_healthbar_speedFn = Options.esp_healthbar_type, Toggles.esp_healthbar_moving, Options.esp_healthbar_speed
        local value5, value6, value7 = esp_healthbar_typeFn.Value, esp_healthbar_movingFn.Value, esp_healthbar_speedFn.Value
        local value022 = capture03.gradients.healthbar
        local value023 = function(value024, value025, value026)
            local value027 = {}

            if value026 == 'rainbow' then
                for index = 0, 19 do
                    __step(172)

                    local value029 = index / 19
                    local value030 = value029

                    if value025 then
                        value030 = value030 + value013

                        if value030 > 1 then
                            value030 = value030 - 1
                        end
                    end

                    value027[#value027 + 1] = newFn2(value029, fromHSVFn(value030, 0.5, 1))
                end
            elseif value026 == 'gradient' then
                local value031 = value010 - 1
                local value032 = value014 / value015

                for index2 = 0, value031 do
                    __step(173)

                    local value034 = #value027 + 1
                    local value035 = value012[value034]
                    local value036 = value024[value035]

                    if value025 then
                        local value037 = value012[value034 - 1] or value012[value010]

                        value036 = value036:Lerp(value024[value037], value032)
                    end

                    value027[value034] = newFn2(index2 / value031, value036)
                end
            else
                value027 = value024[1]
            end

            return value027
        end
        local value038 = function()
            capture01[3][capture01[2] ] = newFn(value023(value011, value6, value5))

            for key, value in value022 do
                __step(174)

                value.Color = capture01[3][capture01[2] ]
            end
        end

        capture02.events.gradient_option_changed.Event:Connect(function(value041)
            table.clear(value012)

            value010 = value041 * 3

            for key2, value2 in {
                [value011] = {
                    Options.esp_healthbar_color_start,
                    Options.esp_healthbar_color_middle,
                    Options.esp_healthbar_color_end,
                },
            }do
                __step(175)
                table.clear(key2)

                for key3, value3 in value2 do
                    __step(176)

                    for index3 = 1, value041 do
                        __step(177)
                        table.insert(key2, value3.Value)
                    end
                end
            end

            for index4 = 1, value010 do
                __step(178)
                table.insert(value012, index4)
            end

            value038()
        end)
        esp_healthbar_typeFn:OnChanged(function(value048)
            value5 = value048

            capture02.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
        end)
        esp_healthbar_movingFn:OnChanged(function(value049)
            value6 = value049

            capture02.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
        end)
        esp_healthbar_speedFn:OnChanged(function(value050)
            value7 = value050

            capture02.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
        end)
        capture02.events.gradient_option_changed:Fire(Options.esp_healthbar_slices.Value)
        capture04.RenderStepped:Connect(function(value051)
            if not value6 or not capture00[3][capture00[2] ] then
                return
            end

            value051 = value051 * value010 / 3 * value7
            value013 = value013 + value051
            value014 = value014 + value051

            if value013 > 1 then
                value013 = 0
            end
            if value014 > value015 then
                value014 = 0

                local value052 = table.clone(value012)

                if value6 then
                    value012[1] = value052[value010]

                    for index5 = 2, value010 do
                        __step(179)

                        value012[index5] = value052[index5 - 1]
                    end
                else
                    for index6 = 1, value010 do
                        __step(180)

                        value012[index6] = index6
                    end
                end
            end

            local value055 = newFn(value023(value011, value7, value5))

            capture01[3][capture01[2] ] = value055

            for key4, value4 in value022 do
                __step(181)

                value4.Color = value055
            end
        end)
    end
end
function Native.recovered57_H(captures)
    local capture01 = captures[1]
    local capture00 = captures[0]

    return function(value004, value005)
        for key, value in capture01 do
            __step(182)

            local value008 = value004 + value
            local value009, value010 = capture00[3][capture00[2] ](value008, value005)

            if value009 then
                return true, {
                    c1 = value008,
                    c2 = value008,
                }
            end
        end
    end
end
function Native.recovered58_V(captures)
    local capture05 = captures[5]
    local capture00 = captures[0]
    local capture02 = captures[2]
    local capture10 = captures[10]
    local capture11 = captures[11]
    local capture09 = captures[9]
    local capture13 = captures[13]
    local capture06 = captures[6]
    local capture03 = captures[3]
    local capture01 = captures[1]
    local capture04 = captures[4]
    local capture12 = captures[12]
    local capture14 = captures[14]
    local capture08 = captures[8]
    local capture07 = captures[7]

    return function(value017, value018)
        if not capture13[3][capture13[2] ] then
            return
        end

        local value2 = capture04.Value
        local value3, value4 = capture05.Value, capture00.Value
        local value5 = capture03.Value
        local value023 = (capture10(value018 * capture02.Value) + 1) / 2 * capture07.Value
        local value024

        if value2 > 0 then
            value024 = capture09(value018 * 360 * value2 % 360)
        else
            value024 = capture09(value5)
        end

        capture01[3][capture01[2] ] = capture01[3][capture01[2] ]:Lerp(value017, capture14.Value)

        for key, value in capture12 do
            __step(183)

            local value027, value028 = value[1], value[2]
            local value029 = value024 + capture08 * (key - 1)
            local value030 = capture11(capture06(value029), capture10(value029))
            local value031 = value4 + value023
            local value032 = value3

            value027.To = capture01[3][capture01[2] ] + value030 * value031
            value027.From = capture01[3][capture01[2] ] + value030 * value031 + value030 * value032

            if value028 then
                value031, value032 = value031 - 1, value032 + 2
                value028.To = capture01[3][capture01[2] ] + value030 * value031
                value028.From = capture01[3][capture01[2] ] + value030 * value031 + value030 * value032
            end
        end
    end
end
function Native.recovered60_U(captures)
    local capture01 = captures[1]
    local capture00 = captures[0]
    local capture02 = captures[2]

    return function(value005)
        local value006, value007 = capture02(capture00, value005)

        return capture01(value006.X, value006.Y), value007
    end
end
function Native.recovered61_Dw(captures)
    local capture05 = captures[5]
    local capture01 = captures[1]
    local capture03 = captures[3]
    local capture02 = captures[2]
    local capture04 = captures[4]
    local capture00 = captures[0]

    return function()
        function capture01:Resize()
            local value009 = 0

            for key, value in next, capture01.Container:GetChildren()do
                __step(2040)

                if not value:IsA('UIListLayout') and value.Visible then
                    value009 = value009 + value.Size.Y.Offset
                end
            end

            capture04.Size = UDim2.new(1, 0, 0, 20 + value009 + 2 + 2)
        end

        local groupboxes = capture03.Groupboxes

        function capture01:Remove()
            table.clear(self)
            capture04:Destroy()

            groupboxes[capture00.Name] = nil
        end

        capture01.Container = capture02

        setmetatable(capture01, capture05)
        capture01:AddBlank(3)
        capture01:Resize()

        groupboxes[capture00.Name] = capture01
    end
end
function Native.recovered62_v(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function()
        local value2 = Toggles.bloom_enabled.Value

        if value2 then
            capture00.Enabled = true
            capture00.Size = Options.bloom_size.Value
            capture00.Intensity = Options.bloom_intensity.Value
            capture00.Threshold = Options.bloom_threshold.Value
        else
            for key, value in capture01 do
                __step(2041)

                capture00[key] = value
            end
        end
    end
end
function Native.recovered63_X(captures)
    local capture17 = captures[17]
    local capture22 = captures[22]
    local capture24 = captures[24]
    local capture00 = captures[0]
    local capture14 = captures[14]
    local capture10 = captures[10]
    local capture33 = captures[33]
    local capture18 = captures[18]
    local capture27 = captures[27]
    local capture29 = captures[29]
    local capture25 = captures[25]
    local capture32 = captures[32]
    local capture09 = captures[9]
    local capture20 = captures[20]
    local capture16 = captures[16]
    local capture19 = captures[19]
    local capture28 = captures[28]
    local capture30 = captures[30]
    local capture26 = captures[26]
    local capture07 = captures[7]
    local capture12 = captures[12]
    local capture02 = captures[2]
    local capture08 = captures[8]
    local capture31 = captures[31]
    local capture15 = captures[15]
    local capture01 = captures[1]
    local capture04 = captures[4]
    local capture05 = captures[5]
    local capture13 = captures[13]
    local capture21 = captures[21]
    local capture03 = captures[3]
    local capture11 = captures[11]
    local capture06 = captures[6]
    local capture23 = captures[23]

    return function(value036, value037, value038, value039, value040, value041, value042, value043, value044)
        capture16(8)

        local value3, value4 = capture31.Value, capture15.Value
        local value5 = capture26.Value
        local value6 = capture12.Value
        local value049, value050
        local value051, value052 = nil, nil

        if value038 then
            local value053, value054 = value3['position on target'], value4['position on target']

            if value053 or value054 or value5['position on target'] or value6['position on target'] then
                local value055, value056

                if value040 then
                    value055, value056 = value039, value040
                else
                    value055, value056 = capture10[3][capture10[2] ](value038.Position)
                end
                if value056 then
                    value039, value051, value040 = value055, value055, value056

                    if value053 then
                        value050 = capture02.Position:Lerp(value039, capture00.Value)
                    end
                    if value054 then
                        value049 = capture09.Position:Lerp(value039, capture18.Value)
                    end
                end
            end
        end

        local equippedItem = capture27[3][capture27[2] ].EquippedItem

        if equippedItem and equippedItem.ViewModel and equippedItem.Info.Type == 'Gun' then
            local value058, value059 = not value050 and value3['position on barrel'], not value049 and value4['position on barrel']

            if value058 or value059 or value5['position on barrel'] or value6['position on barrel'] then
                local viewModel = equippedItem.ViewModel

                if viewModel and (#viewModel._muzzle_attachments > 0 or viewModel._body_model and viewModel._body_model.PrimaryPart) then
                    local success, resultOrError, value063 = pcall(function()
                        return capture10[3][capture10[2] ](viewModel:GetMuzzlePosition())
                    end)

                    capture16(8)

                    if success and value063 then
                        value052 = resultOrError

                        if value058 then
                            value050 = capture02.Position:Lerp(resultOrError, capture00.Value)
                        end
                        if value059 then
                            value049 = capture09.Position:Lerp(resultOrError, capture18.Value)
                        end
                    end
                end
            end
            if capture01[3][capture01[2] ] then
                local value064, value065 = capture29[3][capture29[2] ], ''
                local maxAmmo, ammoReserve, ammo = equippedItem.Info.MaxAmmo, equippedItem.Data.AmmoReserve, equippedItem.Data.Ammo

                if maxAmmo and maxAmmo ~= capture06 and (ammoReserve and ammoReserve ~= capture06) and (ammo and ammo ~= capture06) then
                    if value064['"out of ammo" if empty'] and ammo == 0 and ammoReserve == 0 then
                        value041 = value041 .. capture11[3][capture11[2] ]('"out of ammo" if empty', 'out of ammo')
                    else
                        if value064.ammo then
                            value041 = value041 .. capture11[3][capture11[2] ]('ammo', ammo)
                            value065 = capture11[3][capture11[2] ]('ammo divider', '/')
                        end
                        if value064['max ammo'] then
                            value041 = value041 .. value065 .. capture11[3][capture11[2] ]('max ammo', maxAmmo)
                            value065 = capture11[3][capture11[2] ]('ammo divider', '/')
                        end
                        if value064.reserve then
                            value041 = value041 .. value065 .. capture11[3][capture11[2] ]('reserve', ammoReserve)
                        end
                    end
                    if value041 ~= '' then
                        value041 = value041 .. '\n'
                    end
                end
            end
        end
        if not value049 then
            value049 = capture09.Position:Lerp(value036, capture18.Value)
        end
        if not value050 then
            value050 = capture02.Position:Lerp(value036, capture00.Value)
        end

        local value069 = value6['position on target'] and value051 or value6['position on barrel'] and value052 or value036

        capture04[3][capture04[2] ] = capture04[3][capture04[2] ]:Lerp(value069, capture32.Value)
        capture19.Position = capture04[3][capture04[2] ] + capture21[3][capture21[2] ]
        capture19.Text = value041

        local value070 = capture13()

        capture33[3][capture33[2] ](value5['position on target'] and value051 or value5['position on barrel'] and value052 or value036, value070)

        capture02.Position, capture09.Position = value050, value049
        capture24.Position, capture08.Position = value050, value049

        if capture30.Value then
            local value071 = value070 * 360 * capture20.Value % 360

            for key, value in capture03 do
                __step(2046)

                value.Rotation = value071
            end
        end
        if capture23.Value then
            local value074 = value070 * 360 * capture14.Value % 360

            for key2, value2 in capture17 do
                __step(2047)

                value2.Rotation = value074
            end
        end
        if value038 and value040 then
            if capture22.Value then
                capture05.Adornee = value037
                capture05.Enabled = true
            else
                capture05.Adornee = nil
                capture05.Enabled = false
            end
            if capture28.Value then
                capture07.Visible = true
                capture07.To = value039 or capture10[3][capture10[2] ](value038.Position)
                capture07.From = value050
            else
                capture07.Visible = false
            end
        else
            capture07.Visible = false
            capture05.Adornee = nil
            capture05.Enabled = false
        end

        capture25[3][capture25[2] ](value042, value043, value044)
    end
end
function Native.recovered64_p(captures)
    local capture00 = captures[0]

    return function(value003, value004)
        return capture00(value003 * value004 * 120, 1)
    end
end
function Native.recovered65_T(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]

    return function(value004, value005, value006)
        return capture01(capture00, value004, value005, value006)
    end
end
function Native.recovered66_b(captures)
    local capture00 = captures[0]

    return function(value003, value004)
        local value005 = capture00[value004]

        if not value005 then
            return
        end

        value003.TextSize, value003.FontFace = value005.size, value005.font
    end
end
function Native.recovered68_t(captures)
    local capture03 = captures[3]
    local capture14 = captures[14]
    local capture05 = captures[5]
    local capture17 = captures[17]
    local capture10 = captures[10]
    local capture16 = captures[16]
    local capture06 = captures[6]
    local capture13 = captures[13]
    local capture25 = captures[25]
    local capture11 = captures[11]
    local capture27 = captures[27]
    local capture30 = captures[30]
    local capture12 = captures[12]
    local capture07 = captures[7]
    local capture09 = captures[9]
    local capture01 = captures[1]
    local capture29 = captures[29]
    local capture19 = captures[19]
    local capture00 = captures[0]
    local capture21 = captures[21]
    local capture23 = captures[23]
    local capture22 = captures[22]
    local capture15 = captures[15]
    local capture26 = captures[26]
    local capture28 = captures[28]
    local capture18 = captures[18]
    local capture04 = captures[4]
    local capture24 = captures[24]
    local capture02 = captures[2]
    local capture31 = captures[31]
    local capture08 = captures[8]
    local capture20 = captures[20]

    return function()
        local value20, value21 = Toggles.esp_name.Value, Toggles.esp_distance.Value
        local value22 = Toggles.esp_weapon.Value
        local value23, value24 = Toggles.esp_box.Value, Toggles.esp_fill.Value
        local value25 = Toggles.esp_skeleton.Value
        local value26, value27 = Toggles.esp_skeleton_outline.Value, Options.esp_skeleton_thickness.Value
        local value28, value29 = Toggles.esp_healthbar_resize.Value, Options.esp_healthbar_health_lerp.Value
        local value044
        local value045, value046
        local value047 = Options.esp_bounds_type.Value == 'dynamic'
        local value048 = Options.esp_bounds_width_scale.Value / 100
        local value30 = Toggles.esp_show_team.Value
        local value050 = false

        do
            local value051 = function()
                value050 = capture00[3][capture00[2] ] or value20 or value21 or value22 or value23 or value24 or value25 or value045 or value046
            end

            Toggles.esp_healthbar:OnChanged(function(value052)
                capture00[3][capture00[2] ] = value052

                value051()
            end)
            Toggles.esp_name:OnChanged(function(value053)
                value20 = value053

                value051()
            end)
            Toggles.esp_distance:OnChanged(function(value054)
                value21 = value054

                value051()
            end)
            Toggles.esp_weapon:OnChanged(function(value055)
                value22 = value055

                value051()
            end)
            Toggles.esp_box:OnChanged(function(value056)
                value23 = value056

                value051()
            end)
            Toggles.esp_fill:OnChanged(function(value057)
                value24 = value057

                value051()
            end)
            Toggles.esp_skeleton:OnChanged(function(value058)
                value25 = value058

                value051()
            end)
            Toggles.esp_flag_health_text:OnChanged(function(value059)
                value045 = value059

                value051()
            end)
            Toggles.esp_flag_staring_text:OnChanged(function(value060)
                value046 = value060

                value051()
            end)
            Toggles.esp_show_team:OnChanged(function(value061)
                value30 = value061

                capture17.events.esp_color_changed:Fire()
                capture17.events.esp_effects_changed:Fire()
            end)
            Options.esp_bounds_width_scale:OnChanged(function(value062)
                value048 = value062 / 100
            end)
            Options.esp_bounds_type:OnChanged(function(value063)
                value047 = value063 == 'dynamic'
            end)
            Options.esp_skeleton_thickness:OnChanged(function(value064)
                value27 = value064
            end)
            Toggles.esp_skeleton_outline:OnChanged(function(value065)
                value26 = value065
            end)
            Toggles.esp_healthbar_resize:OnChanged(function(value066)
                value28 = value066
            end)
            Options.esp_healthbar_health_lerp:OnChanged(function(value067)
                value29 = value067
            end)
            Options.esp_flag_prefix:OnChanged(function(value068)
                value044 = value068
            end)
            value051()
        end

        local upVector, position, cFrame = capture20.CFrame.UpVector, capture20.CFrame.Position, capture20.CFrame
        local tickFn = tick

        do
            local value073 = {}
            local value074 = function(value075, value076, value077)
                if not value076 or not value077 then
                    return
                end

                local value31, value32 = value076.Value, value077.Value

                value076:OnChanged(function(value080)
                    value31 = value080
                end)
                value077:OnChanged(function(value081)
                    value32 = value081
                end)

                local value082 = capture12.gradients[value075]

                table.insert(value073, function(value083)
                    if value31 then
                        local value084 = value083 * 360 * value32 % 360

                        for key, value in pairs(value082)do
                            __step(2059)

                            value.Rotation = value084
                        end
                    end
                end)
            end

            for key2 in capture12.gradients do
                __step(2060)

                if key2 ~= 'healthbar' then
                    value074(key2, Toggles['esp_' .. key2 .. '_moving'], Options['esp_' .. key2 .. '_rotation_speed'])
                end
            end

            local value088, value089 = capture12.gradients.fill, capture12.gradients.box
            local pairsFn = pairs

            capture11.RenderStepped:Connect(function()
                cFrame = capture20.CFrame
                position, upVector = cFrame.Position, cFrame.UpVector

                local value091 = tickFn()

                for key3, value2 in pairsFn(value073)do
                    __step(2061)
                    value2(value091)
                end
            end)
        end

        local value094 = {
            'RightHand',
            'LeftLowerArm',
            'RightLowerArm',
            'LeftUpperArm',
            'RightUpperArm',
            'LowerTorso',
            'LeftLowerLeg',
            'LeftUpperLeg',
            'LeftFoot',
            'RightFoot',
            'RightLowerLeg',
            'RightUpperLeg',
            'UpperTorso',
            'LeftHand',
            'Head',
        }
        local value095 = {}
        local value096 = {
            ['smallest pixel'] = 8,
            ['proggy tiny'] = 10,
            ['pixel arial'] = 11,
        }

        return function(value097, value098)
            local value099 = {
                connections = {},
                gradients = {},
                drawings = {},
                squares = {},
                images = {},
                lines = {},
                text = {},
            }
            local value100 = function(value101)
                table.insert(value099.connections, value101)

                return value101
            end

            if capture12.running[value097] then
                return
            end

            local value102, value103, value104
            local value105 = capture01(5, capture07[Options.esp_font.Value].size - 2)
            local pairsFn2, value107, value108 = pairs, {}, {}
            local value109

            do
                local floor = Vector2.zero.Floor
                local value111 = function(value112)
                    local value113, value114 = capture09[3][capture09[2] ](value112)

                    if not value114 then
                        return
                    end

                    local value115, value116 = capture14, capture14
                    local value117, value118 = -capture14, -capture14
                    local value119 = false

                    for key4, value3 in pairsFn2(value108)do
                        __step(2062)

                        local cFrame2 = key4.CFrame

                        for key5, value4 in value3 do
                            __step(2063)

                            local value125, value126 = capture09[3][capture09[2] ]((cFrame2 * value4).Position)

                            if not value126 then
                                continue
                            end

                            value119 = true

                            local value127, value128 = value125.X, value125.Y

                            value115, value116 = capture06(value115, value127), capture06(value116, value128)
                            value117, value118 = capture02(value117, value127), capture02(value118, value128)
                        end
                    end

                    local value129 = capture02(10, value117 - value115)
                    local value130 = capture02(10, value118 - value116)
                    local value131 = floor(capture01(value129, value130))
                    local value132 = floor(capture01(value115 + value131.X / 2, value116))

                    return value131, value132
                end

                value109 = function(value133)
                    if value047 then
                        return value111(value133)
                    end

                    local value134 = value133 + upVector * 2.5
                    local value135, value136 = capture09[3][capture09[2] ](value134)

                    if not value136 then
                        return
                    end
                    if (value133 - position).Magnitude > 600 then
                        return value105, floor(value135), value133
                    end

                    local value137 = value133 - upVector * 3.5
                    local value138, value139 = capture09[3][capture09[2] ](value137)

                    if not value139 then
                        return
                    end

                    local value140 = capture02(10, capture25(value138.Y - value135.Y))

                    return floor(capture01(value140 * value048, value140)), floor(value135)
                end
            end

            local value141 = capture13('esp')
            local value142 = capture28({
                settings = function()
                    if not value102 or not value30 and value098._is_ally then
                        return
                    end

                    return capture24()
                end,
                changed = capture27,
            })
            local value143 = function(value144, value145)
                local value146 = value095[value144]
                local value147, value148

                if not value146 then
                    value147, value148 = {}, 0

                    while true do
                        __step(2064)

                        local value149 = Options[value144 .. value148 + 1] or Options[value144]

                        if not value149 then
                            break
                        end

                        value148 = value148 + 1

                        table.insert(value147, value149)
                    end

                    value095[value144] = {value147, value148}
                else
                    value147, value148 = unpack(value146)
                end

                local value150 = {}
                local value151, value152 = (value145 and NumberSequenceKeypoint or ColorSequenceKeypoint).new, value145 and 'Transparency' or 'Value'

                for key6, value5 in value147 do
                    __step(2065)
                    table.insert(value150, value151((key6 - 1) / (value148 - 1), value5[value152] or 0))
                end

                return (value145 and NumberSequence or ColorSequence).new(value150)
            end
            local value155 = function(value156, value157)
                table.insert(capture12.gradients[value156], value157)

                value099.gradients[value156] = value157

                return value157
            end
            local value158, value159
            local value160

            do
                do
                    do
                        for index = 1, 26 do
                            __step(2066)

                            local value162 = index > 13

                            table.insert(value099.lines, capture16('Line', {
                                Visible = false,
                                ZIndex = not value162 and 2 or nil,
                                Thickness = value27 + (value162 and 2 or 0),
                                Color = value162 and Color3.new() or Color3.new(1, 1, 1),
                            }, value099.drawings))
                        end

                        do
                            local value163 = {
                                ColorSequence.new(Options.esp_skeleton_color2.Value, Options.esp_skeleton_color3.Value),
                                ColorSequence.new(Options.esp_skeleton_color1.Value, Options.esp_skeleton_color2.Value),
                                ColorSequence.new(Options.esp_skeleton_color1.Value),
                            }

                            for index2 = 1, 13 do
                                __step(2067)

                                local uIGradient = Instance.new('UIGradient', value099.lines[index2]._frame)
                                local value166 = (index2 - 1) % 3 + 1

                                if index2 == 13 then
                                    uIGradient.Color = ColorSequence.new(Options.esp_skeleton_color3.Value)
                                else
                                    uIGradient.Color = value163[value166]
                                end
                            end
                        end
                    end

                    local value33 = Options.esp_font.Value

                    for index3 = 1, 4 do
                        __step(2068)

                        local value169 = capture16('Text', {
                            Outline = true,
                            Visible = false,
                            Color = Color3.new(1, 1, 1),
                            Middle = true,
                            Center = true,
                            Size = 12,
                        }, value099.drawings)

                        capture03(value169, value33)

                        value099.text[index3] = value169
                    end

                    value160 = value096[value33] or capture07[value33].size

                    for index4 = 1, 4 do
                        __step(2069)

                        value099.squares[index4] = capture16('Square', {
                            Visible = false,
                            Outline = true,
                        }, value099.drawings)
                    end
                    for index5 = 1, 1 do
                        __step(2070)

                        value099.images[index5] = capture16('Image', {
                            Visible = false,
                            Outline = true,
                        }, value099.drawings)
                    end
                end

                value099.squares[1].Thickness = 3
                value099.squares[2].ZIndex = 2
                value099.squares[2].Color = Color3.new(1, 1, 1)
                value099.squares[3].ZIndex = 2
                value099.squares[3].Color = Color3.new(1, 1, 1)
                value099.squares[3].Filled = true
                value099.squares[4].Filled = true
                value099.squares[4].Color = Color3.new(0, 0, 0)
                value099.text[1].Text = value097[Options.esp_name_type.Value]

                capture03(value099.text[1], Options.esp_name_font.Value)

                value099.text[2].Text = 'none'

                local value34 = Options.esp_flag_font.Value

                value158 = capture08[value34]

                capture03(value099.text[4], Options.esp_flag_font.Value)

                value099.text[4].RichText = true
                value099.text[4].Center = false

                do
                    local value173 = value099.images[1]

                    for key7, value6 in {
                        Color = Color3.new(1, 1, 1),
                        Filled = true,
                        ZIndex = -1,
                    }do
                        __step(2071)

                        value173[key7] = value6
                    end

                    local value176, value177 = value173._frame, capture19[Options.esp_fill_image.Value] or capture19.default

                    value176.Image, value176.BackgroundTransparency = value177.image, value177.image ~= '' and 1 or 0
                    value176.BackgroundColor3 = Color3.new(1, 1, 1)
                    value176.AnchorPoint = capture01(0.5, 0.5)
                    value159 = value177.size
                end

                for key8, value7 in {
                    'esp_name_',
                    'esp_weapon_',
                    'esp_distance_',
                }do
                    __step(2072)

                    local value180 = value099.text[key8]._frame
                    local uIGradient2 = Instance.new('UIGradient', value180)

                    value180.AnchorPoint, value180.AutomaticSize = capture01(0.5, 0), Enum.AutomaticSize.XY
                    uIGradient2.Color, uIGradient2.Rotation = value143(value7 .. 'color'), Options[value7 .. 'rotation'].Value

                    value155(value7:split('_')[2], uIGradient2)
                end

                do
                    local value182 = value155('box', Instance.new('UIGradient', value099.squares[2]._frame._stroke))

                    value182.Rotation = Options.esp_box_rotation.Value
                    value099.squares[2]._frame._stroke.UIGradient.Color = value143('esp_box_color')
                end
            end

            local value183

            do
                local value184, value185 = value099.squares[1], value099.squares[2]
                local value186, value187 = capture01(2, 2), capture01(1, 1)

                value183 = function(value188, value189)
                    if value23 then
                        local value190 = value189 - capture01(value188.X / 2, 0)

                        value185.Size = value188
                        value184.Size = value188 + value186
                        value185.Position = value190
                        value184.Position = value190 - value187
                        value185.Visible = true
                        value184.Visible = true
                    else
                        value185.Visible = false
                        value184.Visible = false
                    end
                end
            end

            local value191

            do
                local value192 = value099.images[1]
                local value193 = value155('fill', Instance.new('UIGradient', value192._frame))

                do
                    value193.Color, value193.Transparency, value193.Rotation = value143('esp_fill_color'), value143('esp_fill_color', true), Options.esp_fill_rotation.Value
                end

                local value194 = capture01(1, 1)

                value191 = function(value195, value196, value197)
                    if value24 then
                        local value198 = value196 + capture01(0, value195.Y / 2)

                        if value159 then
                            value195 = value195 * value159
                        end

                        value192.Size = value195
                        value192.Position = value198
                        value192.Visible = true
                    else
                        value192.Visible = false
                    end
                end

                value100(capture17.events.esp_fill_changed.Event:Connect(function(...)
                    value193.Color, value193.Transparency, value193.Rotation = value143('esp_fill_color'), value143('esp_fill_color', true), Options.esp_fill_rotation.Value
                end))
            end

            local value199

            do
                local value200 = value099.text[1]

                value200._frame.AnchorPoint = capture01(0.5, 1)

                local value201 = capture01(0, 2)
                local esp_name_typeFn = Options.esp_name_type

                value100(capture21:Connect(function()
                    value200.Text = value097[esp_name_typeFn.Value]
                end))

                value199 = function(value203, value204)
                    if value20 then
                        value200.Position = value204 - value201
                        value200.Visible = true
                    else
                        value200.Visible = false
                    end
                end
            end

            local value205

            do
                local value206 = value099.text[2]

                value205 = function(value207, value208)
                    if value22 then
                        value206.Position = value208 + capture01(0, value207.Y + 1)
                        value206.Visible = true
                    else
                        value206.Visible = false
                    end
                end

                capture29(value206, value098)
            end

            local value209

            do
                local value210, value211 = value099.text[3], value099.text[2]

                value209 = function(value212, value213, value214)
                    if value21 then
                        value210.Position = value213 + capture01(0, (value211.Visible and value212.Y + value160 or value212.Y) + 2)
                        value210.Visible = true
                        value210.Text = '[' .. capture30((position - value214).Magnitude) .. ']'
                    else
                        value210.Visible = false
                    end
                end
            end

            local value215

            do
                local value216 = {
                    {
                        'LeftUpperArm',
                        'UpperTorso',
                    },
                    {
                        'LeftLowerArm',
                        'LeftUpperArm',
                    },
                    {
                        'LeftLowerArm',
                        'LeftHand',
                    },
                    {
                        'RightUpperArm',
                        'UpperTorso',
                    },
                    {
                        'RightLowerArm',
                        'RightUpperArm',
                    },
                    {
                        'RightHand',
                        'RightLowerArm',
                    },
                    {
                        'LeftUpperLeg',
                        'LowerTorso',
                    },
                    {
                        'LeftLowerLeg',
                        'LeftUpperLeg',
                    },
                    {
                        'LeftFoot',
                        'LeftLowerLeg',
                    },
                    {
                        'RightUpperLeg',
                        'LowerTorso',
                    },
                    {
                        'RightLowerLeg',
                        'RightUpperLeg',
                    },
                    {
                        'RightFoot',
                        'RightLowerLeg',
                    },
                    {
                        'LowerTorso',
                        'UpperTorso',
                    },
                }
                local value217 = value099.lines
                local value218 = false
                local value219 = function()
                    if value218 then
                        return
                    end

                    value218 = true

                    for key9, value8 in value217 do
                        __step(2073)

                        value8.Visible = false
                    end
                end
                local value222 = #value094
                local value223 = function()
                    local value224 = {}
                    local value225 = 0

                    for key10, value9 in pairsFn2(value107)do
                        __step(2074)

                        value225 = value225 + 1
                        value224[key10] = capture09[3][capture09[2] ](key10 ~= 'UpperTorso' and value9.Position or value9.Position + capture22(0, value9.Size.Y / 3, 0))
                    end

                    if value225 ~= value222 then
                        return
                    end

                    return value224
                end

                value215 = function()
                    if not value25 then
                        return value219()
                    end

                    local value228 = value223()

                    if not value228 then
                        return value219()
                    end

                    value218 = false

                    for key11, value10 in value216 do
                        __step(2075)

                        local value231, value232 = value217[key11], value217[key11 + 13]
                        local value233, value234 = value228[value10[1] ], value228[value10[2] ]
                        local unit = (value233 - value234).Unit

                        value231.From, value231.To = value233 + unit, value234 - unit

                        if value26 then
                            local value236 = unit * 2

                            value232.From, value232.To = value233 + value236, value234 - value236
                            value232.Visible = true
                        else
                            value232.Visible = false
                        end

                        value231.Visible = true
                    end
                end
            end

            local value237
            local value238, value239 = 0, 150

            do
                local value240 = value155('healthbar', Instance.new('UIGradient', value099.squares[3]._frame._stroke))

                value240.Color = capture23[3][capture23[2] ]
                value240.Rotation = 90

                local value241, value242 = value099.squares[3], value099.squares[4]

                value241._frame.AnchorPoint = capture01(0, 1)
                value242._frame.AnchorPoint = capture01(0, 1)

                local value243, value244 = 0, 0
                local lerpFn = math.lerp
                local esp_healthbar_health_lerpFn = Options.esp_healthbar_health_lerp
                local value247, value248 = capture01(0, 1), capture01(0, 2)
                local value249 = capture01(5, 0)
                local value250 = capture01(-1, 2)
                local value251 = capture01(1, -1)
                local value252 = capture01(1, -1)

                value100(value097.CharacterAdded:Connect(function()
                    value244 = 0
                end))

                value237 = function(value253, value254, value255)
                    if capture00[3][capture00[2] ] then
                        value254 = value254 - value247
                        value253 = value253 + value248

                        local value256 = value254 - capture01(value253.X / 2 + 6, -value253.Y + 1) - value250

                        if capture00[3][capture00[2] ] then
                            local value257 = value238 / value239

                            value244 = lerpFn(value244, value257, value29)

                            local value258 = capture01(2, capture02(2, (value253.Y - 2) * value244))

                            value241.Size = value258
                            value241.Position = value256
                            value240.Offset = capture01(0, value244 - 1)

                            if value28 then
                                value242.Size = capture01(4, value258.Y + 2)
                                value242.Position = value256 - value252
                            else
                                value242.Size = capture01(4, value253.Y)
                                value242.Position = value256 - value252
                            end

                            value242.Visible = true
                            value241.Visible = true
                        else
                            value242.Visible, value241.Visible = false, false
                        end
                    else
                        value242.Visible, value241.Visible = false, false
                    end
                end
            end

            local value259

            do
                local value260 = {}
                local value261 = function(value262)
                    table.insert(value260, value262())
                end
                local value263 = value099.text[4]

                value259 = function(value264, value265, value266)
                    local value267 = ''

                    for key12, value11 in value260 do
                        __step(2076)

                        local value270 = value11(value044, value266)

                        if value270 then
                            value267 = value267 .. value270
                        end
                    end

                    value263.Text, value263.Visible = value267, true
                    value263.Position = value265 + capture01(value264.X / 2 + 2, 0) + value158
                end

                value261(function()
                    local value271 = {
                        ['bridge only'] = '',
                        minimal = 'HP',
                        full = 'HEALTH',
                    }

                    return function(value272)
                        if value045 then
                            local value273 = value271[value272]

                            return (value273 and capture04[3][capture04[2] ]('health prefix', value273) .. capture04[3][capture04[2] ]('health prefix', capture15[3][capture15[2] ], nil, true) or '') .. capture04[3][capture04[2] ]('health text', capture31(value238), true)
                        end
                    end
                end)
                value261(function()
                    local value274 = capture26(value098)

                    return function(value275, value276)
                        return value046 and value274(position - value276) and capture04[3][capture04[2] ]('staring text', 'staring')
                    end
                end)
            end

            local value277 = false
            local value278 = function()
                if value277 then
                    return
                end

                value277 = true

                for key13, value12 in value099.drawings do
                    __step(2077)

                    value12.Visible = false
                end
            end

            value100(capture17.events.esp_color_changed.Event:Connect(function()
                for key14, value13 in {
                    'esp_name_',
                    'esp_weapon_',
                    'esp_distance_',
                }do
                    __step(2078)

                    local uIGradient3 = value099.text[key14]._frame.UIGradient

                    uIGradient3.Color, uIGradient3.Rotation = value143(value13 .. 'color'), Options[value13 .. 'rotation'].Value
                end

                local uIGradient4 = value099.squares[2]._frame._stroke.UIGradient

                uIGradient4.Color = value143('esp_box_color')
                uIGradient4.Rotation = Options.esp_box_rotation.Value
                value099.text[1].Text = value097[Options.esp_name_type.Value]

                local value35 = Options.esp_font.Value

                for key15, value14 in value099.text do
                    __step(2079)
                    capture03(value14, value35)
                end

                value160 = value096[value35] or capture07[value35].size

                capture03(value099.text[1], Options.esp_name_font.Value)

                do
                    local value288 = {
                        ColorSequence.new(Options.esp_skeleton_color2.Value, Options.esp_skeleton_color3.Value),
                        ColorSequence.new(Options.esp_skeleton_color1.Value, Options.esp_skeleton_color2.Value),
                        ColorSequence.new(Options.esp_skeleton_color1.Value),
                    }

                    for key16, value15 in value099.lines do
                        __step(2080)

                        local value291 = key16 > 13

                        value15.Thickness = value27 + (value291 and 2 or 0)

                        if not value291 then
                            local uIGradient5 = value15._frame.UIGradient
                            local value293 = (key16 - 1) % 3 + 1

                            if key16 == 13 then
                                uIGradient5.Color = ColorSequence.new(Options.esp_skeleton_color3.Value)
                            else
                                uIGradient5.Color = value288[value293]
                            end
                        end
                    end
                end

                value105 = capture01(5, capture07[Options.esp_font.Value].size - 2)

                do
                    local value294, value295 = value099.images[1]._frame, capture19[Options.esp_fill_image.Value] or capture19.default

                    value294.Image, value294.BackgroundTransparency = value295.image, value295.image ~= '' and 1 or 0
                    value159 = value295.size
                end

                local value36 = Options.esp_flag_font.Value

                value158 = capture08[value36]

                capture03(value099.text[4], value36)

                if value102 and value102.Parent then
                    local parent = value102.Parent

                    if not value30 and value098._is_ally then
                        pcall(capture18, value102, 'Parent', workspace)
                    else
                        pcall(capture18, value102, 'Parent', capture10)
                    end

                    value142:change(value102)
                end
            end))
            value100(capture17.events.esp_effects_changed.Event:Connect(function()
                for key17, value16 in {
                    'aura',
                    'particle',
                }do
                    __step(2081)

                    if not value30 and value098._is_ally then
                        value141:destroy(value16)

                        continue
                    end
                    if value102 and Toggles['esp_effects_' .. value16].Value then
                        value141:create(value102, Options['esp_effects_' .. value16 .. '_value'].Value, value16)
                    else
                        value141:destroy(value16)
                    end
                end
            end))
            value100(capture17.events.esp_effects_color_changed.Event:Connect(function()
                for key18, value17 in {
                    'aura',
                    'particle',
                }do
                    __step(2082)
                    value141:update(value17)
                end
            end))

            local cosFn, sinFn, atan2Fn = math.cos, math.sin, math.atan2

            value100(capture11.RenderStepped:Connect(function(value305)
                if not value050 or not value104 or not value30 and value098._is_ally then
                    return value278()
                end
                if value238 <= 0 then
                    return value278()
                end

                local position2 = value104.Position
                local value307, value308 = value109(position2)

                if not value307 then
                    return value278()
                end

                value277 = false

                value215()
                value183(value307, value308)
                value199(value307, value308)
                value191(value307, value308, value305)
                value259(value307, value308, position2)
                value205(value307, value308)
                value209(value307, value308, position2)
                value237(value307, value308, value305)
            end))

            local value309 = function(value310)
                value102 = value310
                value104 = value310:WaitForChild('HumanoidRootPart', capture14)
                value103 = value310:WaitForChild('Humanoid', capture14)

                value100(value103:GetPropertyChangedSignal('Health'):Connect(function()
                    value238 = value103.Health
                end))
                value100(value103:GetPropertyChangedSignal('MaxHealth'):Connect(function()
                    value239 = value103.MaxHealth
                end))

                value238, value239 = value103.Health, value103.MaxHealth

                for key19, value18 in value094 do
                    __step(2083)

                    local value313 = value310:WaitForChild(value18, capture14)
                    local value314 = value313.Size / 2
                    local value315, value316, value317 = value314.X, value314.Y, value314.Z

                    value107[value18], value108[value313] = value313, {
                        capture05(-value315, -value316, -value317),
                        capture05(-value315, -value316, value317),
                        capture05(-value315, value316, -value317),
                        capture05(-value315, value316, value317),
                        capture05(value315, -value316, -value317),
                        capture05(value315, -value316, value317),
                        capture05(value315, value316, -value317),
                        capture05(value315, value316, value317),
                    }
                end

                task.wait()

                if not value30 and value098._is_ally then
                    return
                end

                pcall(function()
                    value310.Parent = capture10
                end)
                value142:change(value102)

                for key20, value19 in {
                    'aura',
                    'particle',
                }do
                    __step(2084)

                    if value102 and Toggles['esp_effects_' .. value19].Value then
                        value141:create(value102, Options['esp_effects_' .. value19 .. '_value'].Value, value19)
                    else
                        value141:destroy(value19)
                    end
                end
            end

            value100(value097.CharacterAdded:Connect(value309))
            value100(value097.CharacterRemoving:Connect(function(value320)
                if value102 == value320 then
                    value102, value104, value103, value238 = nil, nil, nil, 0
                    value099.text[2].Text = 'none'

                    table.clear(value107)
                    table.clear(value108)
                end
            end))

            if value097.Character then
                task.spawn(value309, value097.Character)
            end

            capture12.running[value097] = value099
        end
    end
end
function Native.recovered69_J(captures)
    local capture02 = captures[2]
    local capture01 = captures[1]
    local capture00 = captures[0]

    return function(value005, value006)
        local value007 = capture00(capture02, value005, value006 - value005, capture01)

        return not value007, value007
    end
end
function Native.recovered70_R(captures)
    local capture00 = captures[0]
    local capture01 = captures[1]
    local capture02 = captures[2]

    return function(value005, value006, value007)
        local value008, value009 = capture00(value006, value007), capture02(value006, value007)

        return capture01(value005, value008, value009)
    end
end

return Native