
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local function getSafeParent()
    if gethui then return gethui() end
    local ok, cg = pcall(function() return CoreGui end)
    if ok and cg then return cg end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = getSafeParent()

if GuiParent:FindFirstChild("PXViolenceDistrict") then
    GuiParent:FindFirstChild("PXViolenceDistrict"):Destroy()
end
if GuiParent:FindFirstChild("VD_ESP") then
    GuiParent:FindFirstChild("VD_ESP"):Destroy()
end
if GuiParent:FindFirstChild("VD_FPS") then
    GuiParent:FindFirstChild("VD_FPS"):Destroy()
end

local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
end

local Theme = {
    Background  = Color3.fromRGB(5, 5, 5),
    Surface     = Color3.fromRGB(15, 15, 15),
    SurfaceAlt  = Color3.fromRGB(25, 25, 30),
    Accent      = Color3.fromRGB(255, 50, 50),
    AccentDim   = Color3.fromRGB(150, 30, 30),
    Text        = Color3.fromRGB(255, 255, 255),
    TextDim     = Color3.fromRGB(180, 180, 180),
    ToggleOff   = Color3.fromRGB(60, 60, 60),
    Border      = Color3.fromRGB(255, 255, 255),
    Section     = Color3.fromRGB(255, 50, 50),
    ScrollBar   = Color3.fromRGB(255, 255, 255),
    NotifBg     = Color3.fromRGB(20, 20, 20),
}

local UICommunicationEvent = Instance.new("BindableEvent")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PXViolenceDistrict"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 100
ScreenGui.Parent = GuiParent

local NotifContainer = Instance.new("Frame", ScreenGui)
NotifContainer.Name = "Notifications"
NotifContainer.Size = UDim2.new(0, 260, 1, 0)
NotifContainer.Position = UDim2.new(1, -270, 0, 10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.BorderSizePixel = 0

local NotifLayout = Instance.new("UIListLayout", NotifContainer)
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

local function Notify(title, message, duration)
    duration = duration or 3

    local frame = Instance.new("Frame", NotifContainer)
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.BackgroundColor3 = Theme.NotifBg
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.3

    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = Theme.Accent
    bar.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Size = UDim2.new(1, -16, 0, 16)
    titleLabel.Position = UDim2.new(0, 10, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Accent
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextStrokeTransparency = 0.8
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local msgLabel = Instance.new("TextLabel", frame)
    msgLabel.Size = UDim2.new(1, -16, 0, 16)
    msgLabel.Position = UDim2.new(0, 10, 0, 22)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Theme.Text
    msgLabel.Font = Enum.Font.GothamMedium
    msgLabel.TextSize = 12
    msgLabel.TextStrokeTransparency = 0.9
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true

    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 48)
    }):Play()

    task.delay(duration, function()
        local tw = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1
        })
        tw:Play()
        tw.Completed:Connect(function() frame:Destroy() end)
    end)
end

UICommunicationEvent.Event:Connect(function(action, ...)
    local args = {...}
    if action == "SetAutoAttackState" then
        local state, silent = args[1], args[2]
        if autoAttackToggleObj then
            autoAttackToggleObj.SetState(state, silent)
        end
    elseif action == "ShowNotification" then
        local title, msg, duration = args[1], args[2], args[3]
        Notify(title, msg, duration)
    end
end)

local WINDOW_WIDTH = 320
local WINDOW_HEIGHT = 480
local HEADER_HEIGHT = 32

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, WINDOW_WIDTH, 0, WINDOW_HEIGHT)
MainFrame.Position = UDim2.new(0.5, -(WINDOW_WIDTH / 2), 0.5, -(WINDOW_HEIGHT / 2))
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", MainFrame)
mainStroke.Color = Theme.Border
mainStroke.Thickness = 2

local glass = Instance.new("Frame", MainFrame)
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
glass.BackgroundTransparency = 0.97
glass.BorderSizePixel = 0
Instance.new("UICorner", glass).CornerRadius = UDim.new(0, 12)

local Header = Instance.new("Frame", MainFrame)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, HEADER_HEIGHT)
Header.BackgroundColor3 = Theme.Surface
Header.BorderSizePixel = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local hFix = Instance.new("Frame", Header)
hFix.Size = UDim2.new(1, 0, 0, 8)
hFix.Position = UDim2.new(0, 0, 1, -8)
hFix.BackgroundColor3 = Theme.Surface
hFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PIXECUTE VIOLENCE DISTRICT"
Title.TextColor3 = Theme.Text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.85

do
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local RefreshBtn = Instance.new("TextButton", Header)
RefreshBtn.Size = UDim2.new(0, 20, 0, 20)
RefreshBtn.Position = UDim2.new(1, -74, 0.5, -10)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
RefreshBtn.Text = "R"
RefreshBtn.TextColor3 = Theme.Text
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 12
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", RefreshBtn).Color = Theme.Border


local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -50, 0.5, -10)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", MinBtn).Color = Theme.Border

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -26, 0.5, -10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)
Instance.new("UIStroke", CloseBtn).Color = Theme.Border

local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Name = "Content"
Content.Size = UDim2.new(1, -16, 1, -(HEADER_HEIGHT + 8))
Content.Position = UDim2.new(0, 8, 0, HEADER_HEIGHT + 4)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Theme.ScrollBar
Content.ScrollBarImageTransparency = 0.5
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.BorderSizePixel = 0

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.Padding = UDim.new(0, 4)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local minimized = false
local fullSize = UDim2.new(0, WINDOW_WIDTH, 0, WINDOW_HEIGHT)
local minSize = UDim2.new(0, WINDOW_WIDTH, 0, HEADER_HEIGHT)

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = minimized and minSize or fullSize
    }):Play()
    Content.Visible = not minimized
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

local layoutOrder = 0
local function nextOrder()
    layoutOrder = layoutOrder + 1
    return layoutOrder
end

local function MakeSection(text)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, 0, 0, 22)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = nextOrder()

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -8, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Section
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextStrokeTransparency = 0.85

    local line = Instance.new("Frame", frame)
    line.Size = UDim2.new(1, -8, 0, 1)
    line.Position = UDim2.new(0, 4, 1, -1)
    line.BackgroundColor3 = Theme.Accent
    line.BackgroundTransparency = 0.6
    line.BorderSizePixel = 0
end

local function MakeToggle(configKey, text, callback, defaultVal)
    local state = defaultVal or false

    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, 0, 0, 28)
    frame.BackgroundColor3 = Theme.SurfaceAlt
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.LayoutOrder = nextOrder()
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = state and Theme.Text or Theme.TextDim
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextStrokeTransparency = 0.9
    label.TextXAlignment = Enum.TextXAlignment.Left

    local indicator = Instance.new("Frame", frame)
    indicator.Size = UDim2.new(0, 36, 0, 18)
    indicator.Position = UDim2.new(1, -44, 0.5, -9)
    indicator.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
    indicator.BorderSizePixel = 0
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 9)
    Instance.new("UIStroke", indicator).Color = Color3.fromRGB(80, 80, 80)

    local circle = Instance.new("Frame", indicator)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = state and UDim2.new(0, 20, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Theme.Text
    circle.BorderSizePixel = 0
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local function updateVisual()
        if state then
            TweenService:Create(indicator, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Accent}):Play()
            TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(0, 20, 0.5, -7)}):Play()
            label.TextColor3 = Theme.Text
        else
            TweenService:Create(indicator, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ToggleOff}):Play()
            TweenService:Create(circle, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
            label.TextColor3 = Theme.TextDim
        end
    end

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 5

    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        Notify(text, state and "Enabled" or "Disabled", 2)
        if callback then task.spawn(callback, state) end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
    end)

    return {
        SetState = function(v, silent)
            state = v
            updateVisual()
            if callback and not silent then task.spawn(callback, v) end
        end,
        GetState = function() return state end
    }
end

local function MakeSlider(text, min, max, default, callback)
    local value = default or min

    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Theme.SurfaceAlt
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.LayoutOrder = nextOrder()
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.TextDim
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valLabel = Instance.new("TextLabel", frame)
    valLabel.Size = UDim2.new(0, 50, 0, 18)
    valLabel.Position = UDim2.new(1, -55, 0, 2)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(value)
    valLabel.TextColor3 = Theme.Accent
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 11
    valLabel.TextXAlignment = Enum.TextXAlignment.Right

    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 28)
    sliderBg.BackgroundColor3 = Theme.ToggleOff
    sliderBg.BorderSizePixel = 0
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

    local sliderBtn = Instance.new("TextButton", sliderBg)
    sliderBtn.Size = UDim2.new(1, 0, 1, 10)
    sliderBtn.Position = UDim2.new(0, 0, 0, -5)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""

    local sliding = false
    local function update(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relX)
        sliderFill.Size = UDim2.new(relX, 0, 1, 0)
        valLabel.Text = tostring(value)
        if callback then callback(value) end
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            update(input)
        end
    end)
    sliderBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

local function MakeButton(text, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, 0, 0, 26)
    btn.BackgroundColor3 = Theme.SurfaceAlt
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Theme.Accent
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.LayoutOrder = nextOrder()
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        if callback then task.spawn(callback) end
    end)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
    end)
end

local function MakeLabel(text)
    local lbl = Instance.new("TextLabel", Content)
    lbl.Size = UDim2.new(1, -8, 0, 50)
    lbl.Position = UDim2.new(0, 4, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.LayoutOrder = nextOrder()
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "VD_ESP"
ESPFolder.Parent = GuiParent

local ESPConfig = {
    PlayerESP = false,
    GeneratorESP = false,
    HookESP = false,
    PalletESP = false,
    WindowESP = false,
    GateESP = false,
    ShowDistance = true,
    ShowClosestHookOnly = false,
    MaxDistance = math.huge,
}

local ESPColors = {
    Killer    = Color3.fromRGB(255, 30, 45),
    Survivor  = Color3.fromRGB(50, 255, 50),
    Generator = Color3.fromRGB(255, 180, 30),
    Hook      = Color3.fromRGB(255, 80, 80),
    Pallet    = Color3.fromRGB(255, 255, 50),
    Window = Color3.fromRGB(0, 255, 255),
    Gate = Color3.fromRGB(255, 215, 0),
}

local playerESPConns = {}

local function destroyPlayerESP(name)
    local folder = ESPFolder:FindFirstChild(name .. "_ESP")
    if folder then folder:Destroy() end
end

local function CreatePlayerESP(plr)
    if plr == LocalPlayer then return end
    if not plr.Character or not getRoot(plr.Character) then return end
    if ESPFolder:FindFirstChild(plr.Name .. "_ESP") then return end

    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return end

    local holder = Instance.new("Folder")
    holder.Name = plr.Name .. "_ESP"
    holder.Parent = ESPFolder

    local highlight = Instance.new("Highlight", holder)
    highlight.Adornee = plr.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local teamColor = plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 30, 45)
    local role = plr:GetAttribute("Role")
    local espColor = teamColor
    if role == "Killer" then
        espColor = ESPColors.Killer
    end

    highlight.FillColor = espColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0

    local head = plr.Character:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui", holder)
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 100, 0, 150)
        billboard.StudsOffset = Vector3.new(0, 1, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = math.huge

        local label = Instance.new("TextLabel", billboard)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 0, 0, -50)
        label.Size = UDim2.new(0, 100, 0, 100)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = espColor
        label.TextStrokeTransparency = 0.2
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        label.ZIndex = 10

        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not ESPConfig.PlayerESP or not plr or not plr.Parent then
                holder:Destroy()
                conn:Disconnect()
                return
            end
            if not plr.Character or not getRoot(plr.Character) then return end

            local myChar = LocalPlayer.Character
            if myChar and getRoot(myChar) and plr.Character:FindFirstChildOfClass("Humanoid") then
                local studs = math.floor((getRoot(myChar).Position - getRoot(plr.Character).Position).Magnitude)
                local hp = plr.Character:FindFirstChildOfClass("Humanoid").Health

                highlight.Enabled = true
                billboard.Enabled = true
                local roleTag = role == "Killer" and " [KILLER]" or ""
                label.Text = plr.DisplayName .. roleTag .. "\nHP: " .. string.format("%.0f", hp) .. " | " .. studs .. "m"
            end
        end)
        table.insert(playerESPConns, conn)
    end

    plr.CharacterAdded:Connect(function()
        destroyPlayerESP(plr.Name)
        if ESPConfig.PlayerESP then
            repeat task.wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
            CreatePlayerESP(plr)
        end
    end)
end

local playerAddedConn = nil

local function startPlayerESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreatePlayerESP(plr)
        end
    end
    if not playerAddedConn then
        playerAddedConn = Players.PlayerAdded:Connect(function(plr)
            if ESPConfig.PlayerESP then
                plr.CharacterAdded:Connect(function()
                    if ESPConfig.PlayerESP then
                        destroyPlayerESP(plr.Name)
                        repeat task.wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
                        CreatePlayerESP(plr)
                    end
                end)
                if plr.Character and getRoot(plr.Character) then
                    CreatePlayerESP(plr)
                end
            end
        end)
    end
end

local function stopPlayerESP()
    for _, v in ipairs(ESPFolder:GetChildren()) do
        if v.Name:sub(-4) == "_ESP" then
            v:Destroy()
        end
    end
    for _, conn in ipairs(playerESPConns) do
        pcall(function() conn:Disconnect() end)
    end
    playerESPConns = {}
    if playerAddedConn then
        playerAddedConn:Disconnect()
        playerAddedConn = nil
    end
end

local objectESPConns = {}

local function createObjectESP(tag, obj, displayName, color, showPercent)
    if not obj or not obj.Parent then return end
    local id = tag .. "_" .. tostring(obj:GetDebugId())
    if ESPFolder:FindFirstChild(id) then return end

    local holder = Instance.new("Folder")
    holder.Name = id
    holder.Parent = ESPFolder

    local hl = Instance.new("Highlight", holder)
    hl.Adornee = obj
    hl.FillColor = color
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local attachPart = obj:FindFirstChild("Main") or obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
    if attachPart then
        local bb = Instance.new("BillboardGui", holder)
        bb.Adornee = attachPart
        bb.Size = UDim2.new(0, 100, 0, 50)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = math.huge

        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.BackgroundTransparency = 1
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 14
        txt.TextColor3 = color
        txt.TextStrokeTransparency = 0.2
        txt.TextYAlignment = Enum.TextYAlignment.Center

        local conn
        conn = task.spawn(function()
            while task.wait(0.25) do
                if not obj or not obj.Parent then
                    holder:Destroy()
                    break
                end

            if not ESPConfig[tag] then
                holder:Destroy()
                break
            end

            local myRoot = LocalPlayer.Character and getRoot(LocalPlayer.Character)
            if not myRoot or not attachPart or not attachPart.Parent then return end

            local dist = math.floor((myRoot.Position - attachPart.Position).Magnitude)

            hl.Enabled = true
            bb.Enabled = true

            local display = displayName
            if showPercent then
                -- Helper robust untuk mencari progress dari attribute atau Value object
                local function getObjectProgress(targetObj)
                    if not targetObj then return 0 end

                    -- 1. Cari di attributes targetObj
                    local progAttr = targetObj:GetAttribute("Progress") or targetObj:GetAttribute("RepairProgress") or targetObj:GetAttribute("OpenProgress") or targetObj:GetAttribute("Opened") or targetObj:GetAttribute("OpenedPercent") or targetObj:GetAttribute("ActivationProgress")
                    if progAttr then return progAttr end
                    
                    -- 2. Cari di descendants (attributes & ValueBase) secara mendalam
                    for _, desc in ipairs(targetObj:GetDescendants()) do
                        local attr = desc:GetAttribute("Progress") or desc:GetAttribute("RepairProgress") or desc:GetAttribute("OpenProgress") or desc:GetAttribute("Opened") or desc:GetAttribute("OpenedPercent") or desc:GetAttribute("ActivationProgress")
                        if attr then return attr end
                        
                        if desc:IsA("ValueBase") and (desc.Name == "Progress" or desc.Name == "RepairProgress" or desc.Name == "OpenProgress" or desc.Name == "Opened" or desc.Name == "ActivationProgress") then
                            return desc.Value
                        end
                    end
                    
                    -- 3. Cari di parent dan descendants parent
                    if targetObj.Parent then
                        local pProgAttr = targetObj.Parent:GetAttribute("Progress") or targetObj.Parent:GetAttribute("RepairProgress") or targetObj.Parent:GetAttribute("OpenProgress") or targetObj.Parent:GetAttribute("ActivationProgress")
                        if pProgAttr then return pProgAttr end
                        
                        for _, desc in ipairs(targetObj.Parent:GetDescendants()) do
                            local attr = desc:GetAttribute("Progress") or desc:GetAttribute("RepairProgress") or desc:GetAttribute("OpenProgress") or desc:GetAttribute("Opened") or desc:GetAttribute("OpenedPercent") or desc:GetAttribute("ActivationProgress")
                            if attr then return attr end
                        end
                    end
                    
                    return 0
                end
                
                local prog = getObjectProgress(obj)
                local pct = math.floor(prog > 1 and prog or (prog * 100))
                if pct > 100 then pct = 100 end
                if pct < 0 then pct = 0 end
                display = displayName .. " [" .. pct .. "%]"
            end

            if ESPConfig.ShowDistance then
                display = display .. "\n" .. dist .. "m"
            end
            txt.Text = display
            end         end)
        table.insert(objectESPConns, conn)
    end
end

local function clearObjectESPByTag(tag)
    for _, child in ipairs(ESPFolder:GetChildren()) do
        if tag == "All" or string.sub(child.Name, 1, #tag) == tag then
            child:Destroy()
        end
    end
    for i, thread in ipairs(objectESPConns) do
        if type(thread) == "thread" then
            task.cancel(thread)
        end
    end
    if tag == "All" then objectESPConns = {} end
end

local function refreshObjectESP()
    clearObjectESPByTag("GeneratorESP")
    clearObjectESPByTag("HookESP")
    clearObjectESPByTag("PalletESP")
    clearObjectESPByTag("WindowESP")
    clearObjectESPByTag("GateESP")

    local closestHook, closestDist = nil, math.huge
    if ESPConfig.ShowClosestHookOnly and ESPConfig.HookESP then
        local myRoot = LocalPlayer.Character and getRoot(LocalPlayer.Character)
        if myRoot then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "Hook" and obj:IsA("Model") then
                    local p = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
                    if p then
                        local d = (myRoot.Position - p.Position).Magnitude
                        if d < closestDist then closestDist = d; closestHook = obj end
                    end
                end
            end
        end
    end

    local searchArea = workspace:GetChildren()
    local mapFolder = workspace:FindFirstChild("Map") or workspace:FindFirstChild("MapLighting")
    if mapFolder then
        for _, v in ipairs(mapFolder:GetDescendants()) do
            if v:IsA("Model") then table.insert(searchArea, v) end
        end
    else
        searchArea = workspace:GetDescendants()     end

    for _, obj in ipairs(searchArea) do
        if obj:IsA("Model") then
            local name = obj.Name
            if name == "Generator" and ESPConfig.GeneratorESP then
                if obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart") then
                    createObjectESP("GeneratorESP", obj, "Generator", ESPColors.Generator, true)
                end
            elseif name == "Hook" and ESPConfig.HookESP then
                if ESPConfig.ShowClosestHookOnly then
                    if obj == closestHook then
                        createObjectESP("HookESP", obj, "CLOSEST HOOK", ESPColors.Hook, false)
                    end
                else
                    createObjectESP("HookESP", obj, "Hook", ESPColors.Hook, false)
                end
            elseif (name == "Pallet" or name == "Palletwrong") and ESPConfig.PalletESP then
                createObjectESP("PalletESP", obj, "Pallet", ESPColors.Pallet, false)
            elseif name == "Window" and ESPConfig.WindowESP then
                createObjectESP("WindowESP", obj, "Window", ESPColors.Window, false)
            elseif (name == "Gate" or name == "Escape" or name:find("Lever") or name:find("Exit")) and ESPConfig.GateESP then
                createObjectESP("GateESP", obj, "Exit", ESPColors.Gate, true)
            end
        end
    end
end

task.spawn(function()
    while task.wait(5) do
        if ESPConfig.PlayerESP then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and getRoot(plr.Character) then
                    if not ESPFolder:FindFirstChild(plr.Name .. "_ESP") then
                        CreatePlayerESP(plr)
                    end
                end
            end
        end
    end
end)

local autoAttackActive = false


MakeSection("PLAYER ESP")

MakeToggle("PlayerESP", "Player ESP", function(val)
    ESPConfig.PlayerESP = val
    if val then
        startPlayerESP()
    else
        stopPlayerESP()
    end
end)

MakeSection("OBJECT ESP")

MakeToggle("GeneratorESP", "Generator ESP", function(val)
    ESPConfig.GeneratorESP = val
    if val then refreshObjectESP() else clearObjectESPByTag("GeneratorESP") end
end)

MakeToggle("HookESP", "Hook ESP", function(val)
    ESPConfig.HookESP = val
    if val then refreshObjectESP() else clearObjectESPByTag("HookESP") end
end)

MakeToggle("PalletESP", "Pallet ESP", function(val)
    ESPConfig.PalletESP = val
    if val then refreshObjectESP() else clearObjectESPByTag("PalletESP") end
end)

MakeToggle("WindowESP", "Window ESP", function(val)
    ESPConfig.WindowESP = val
    if val then refreshObjectESP() else clearObjectESPByTag("WindowESP") end
end)

MakeToggle("GateESP", "Gate & Lever ESP", function(val)
    ESPConfig.GateESP = val
    if val then refreshObjectESP() else clearObjectESPByTag("GateESP") end
end)

MakeSection("ESP SETTINGS")


MakeToggle("ClosestHook", "Show Only Closest Hook", function(val)
    ESPConfig.ShowClosestHookOnly = val
    if ESPConfig.HookESP then
        clearObjectESPByTag("HookESP")
        refreshObjectESP()
    end
end)

MakeSection("AUTO FEATURES")

MakeToggle("KebalTwistOfFate", "Kebal Twist of Fate", function(val)
    kebalTwistActive = val
    if val then
        if not godModeConnection then
            godModeConnection = RunService.Heartbeat:Connect(function()
                local c = LocalPlayer.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h then
                    pcall(function()
                        if h.MaxHealth < 999999 then h.MaxHealth = 999999 end
                        if h.Health < 50 or h.Health < h.MaxHealth then
                            h.Health = 999999
                        end
                    end)
                end
                
                -- Auto Self-Revive / Restore Collision if Knocked or Dead
                if c and (c:GetAttribute("Knocked") or c:GetAttribute("IsDead") or (h and h.Health <= 1)) then
                    pcall(function()
                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        if remotes then
                            local healing = remotes:FindFirstChild("Healing")
                            local collision = remotes:FindFirstChild("Collision")
                            if healing and healing:FindFirstChild("Reset") then
                                healing.Reset:FireServer(LocalPlayer)
                            end
                            if collision and collision:FindFirstChild("EnableCollision") then
                                collision.EnableCollision:FireServer()
                            end
                        end
                    end)
                end
            end)
        end
        UICommunicationEvent:Fire("ShowNotification", "Kebal Twist", "God Mode & Auto-Revive Activated", 2)
    else
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        pcall(function()
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if h then
                h.MaxHealth = 100
                h.Health = 100
            end
        end)
        UICommunicationEvent:Fire("ShowNotification", "Kebal Twist", "God Mode Deactivated", 2)
    end
end)

MakeButton("Instant Self Heal/Revive", function()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local healing = remotes:FindFirstChild("Healing")
            local collision = remotes:FindFirstChild("Collision")
            
            local healingSuccess = false
            if healing and healing:FindFirstChild("Reset") then
                healing.Reset:FireServer(LocalPlayer)
                healingSuccess = true
            end
            
            local collisionSuccess = false
            if collision and collision:FindFirstChild("EnableCollision") then
                collision.EnableCollision:FireServer()
                collisionSuccess = true
            end
            
            if healingSuccess or collisionSuccess then
                UICommunicationEvent:Fire("ShowNotification", "Self Heal", "Instantly self-healed and restored collision!", 2)
            else
                UICommunicationEvent:Fire("ShowNotification", "Self Heal", "Remotes not found", 2)
            end
        end
    end)
end)

MakeToggle("AutoGen", "Auto Complete Generator", function(val)
    if val then
        local deleted = {}
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local gen = remotes:FindFirstChild("Generator")
                if gen then
                    local names = {"SkillCheckResultEvent", "SkillCheckFailEvent", "SkillCheckEvent"}
                    for _, n in ipairs(names) do
                        local r = gen:FindFirstChild(n)
                        if r then
                            local dummy = Instance.new("RemoteEvent")
                            dummy.Name = r.Name
                            dummy.Parent = gen
                            r:Destroy()
                            table.insert(deleted, n)
                        end
                    end
                end
            end
        end)
        if #deleted > 0 then
            Notify("Auto Generator", "Deleted: " .. table.concat(deleted, ", "), 4)
        else
            Notify("Auto Generator", "Remotes not found or already deleted", 3)
        end
    end
end)

local originalHealRemotes = {}

MakeToggle("AntiFailHeal", "Anti-Fail Healing", function(val)
    if val then
        local deleted = {}
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes then
                local heal = remotes:FindFirstChild("Healing")
                if heal then
                    local names = {"SkillCheckResultEvent", "SkillCheckFailEvent", "SkillCheckEvent"}
                    for _, n in ipairs(names) do
                        local r = heal:FindFirstChild(n)
                        if r and not originalHealRemotes[n] then
                            originalHealRemotes[n] = r:Clone()
                            local dummy = Instance.new("RemoteEvent")
                            dummy.Name = r.Name
                            dummy.Parent = heal
                            r:Destroy()
                            table.insert(deleted, n)
                        end
                    end
                end
            end
        end)
        if #deleted > 0 then
            Notify("Anti-Fail Heal", "Dummied: " .. table.concat(deleted, ", "), 4)
        else
            Notify("Anti-Fail Heal", "Already dummied or not found", 3)
        end
    end
end)

MakeSection("COMBAT FEATURES")

local aimbotActive = false
local fovCircle = nil
local crosshairDot = nil
local camera = workspace.CurrentCamera
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

MakeToggle("AimbotToggle", "Aimbot", function(val)
    aimbotActive = val
    if val then
        if not _G.VDAimbotLoop then
            _G.VDAimbotLoop = runService.RenderStepped:Connect(function()
                if aimbotActive then
                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                    local myPos = char.HumanoidRootPart.Position
                    local cam = workspace.CurrentCamera
                    local closestPlayer = nil
                    local shortestDistance = math.huge
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                            if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then continue end
                            local pos = p.Character.HumanoidRootPart.Position
                            local dist = (pos - myPos).Magnitude
                            if dist < shortestDistance then
                                shortestDistance = dist
                                closestPlayer = p
                            end
                        end
                    end
                    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local isAiming = userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) 
                                      or userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                        if not isAiming then
                            for _, touch in ipairs(userInputService:GetTouches()) do
                                if touch.UserInputState == Enum.UserInputState.Begin or touch.UserInputState == Enum.UserInputState.Change then
                                    isAiming = true; break
                                end
                            end
                        end
                        if isAiming then
                            local targetPos = closestPlayer.Character.HumanoidRootPart.Position
                            local currentCFrame = cam.CFrame
                            local newCFrame = CFrame.new(currentCFrame.Position, targetPos)
                            cam.CFrame = currentCFrame:Lerp(newCFrame, 0.15)
                        end
                    end
                end
            end)
        end
    else
        if _G.VDAimbotLoop then
            _G.VDAimbotLoop:Disconnect()
            _G.VDAimbotLoop = nil
        end
    end
end)

local hitboxActive = false
MakeToggle("HitboxToggle", "Expand Hitboxes", function(val)
    hitboxActive = val
    if not _G.VDHitboxLoop then
        _G.VDHitboxLoop = runService.Heartbeat:Connect(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        if hitboxActive then
                            hrp.Size = Vector3.new(15, 15, 15)
                            hrp.Transparency = 0.8
                            hrp.BrickColor = BrickColor.new("Bright red")
                            hrp.Material = Enum.Material.Neon
                            hrp.CanCollide = false
                        else
                            hrp.Size = Vector3.new(2, 2, 1)
                            hrp.Transparency = 1
                        end
                    end
                end
            end
        end)
    end
end)

local crosshairOffsetX = -15
local crosshairOffsetY = 0

MakeToggle("CrosshairToggle", "External Crosshair", function(val)
    if val then
        if not crosshairDot then
            local cg = Instance.new("ScreenGui")
            cg.Name = "ViolenceDistrictCrosshair"
            cg.ResetOnSpawn = false
            pcall(function() cg.Parent = game:GetService("CoreGui") end)
            if not cg.Parent then cg.Parent = LocalPlayer:WaitForChild("PlayerGui") end
            
            local f = Instance.new("Frame")
            f.Name = "Dot"
            f.Size = UDim2.new(0, 6, 0, 6)
            f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.Position = UDim2.new(0.5, crosshairOffsetX, 0.5, crosshairOffsetY)
            f.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            f.BorderSizePixel = 0
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(1, 0)
            c.Parent = f
            f.Parent = cg
            crosshairDot = cg
        end
        crosshairDot.Enabled = true
    else
        if crosshairDot then crosshairDot.Enabled = false end
    end
end)

MakeSlider("Crosshair X Offset", -200, 200, -15, function(val)
    crosshairOffsetX = val
    if crosshairDot and crosshairDot:FindFirstChild("Dot") then
        crosshairDot.Dot.Position = UDim2.new(0.5, crosshairOffsetX, 0.5, crosshairOffsetY)
    end
end)

MakeSlider("Crosshair Y Offset", -200, 200, 0, function(val)
    crosshairOffsetY = val
    if crosshairDot and crosshairDot:FindFirstChild("Dot") then
        crosshairDot.Dot.Position = UDim2.new(0.5, crosshairOffsetX, 0.5, crosshairOffsetY)
    end
end)

MakeButton("Shoot Killer (Escape Carry)", function()
    local char = LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    local gun = char:FindFirstChild("Twist of Fate") or LocalPlayer.Backpack:FindFirstChild("Twist of Fate")
    if not gun or not hum then
        Notify("Auto Escape", "You must have Twist of Fate!", 3)
        return
    end
    
    if gun.Parent == LocalPlayer.Backpack then
        hum:EquipTool(gun)
        task.wait(0.1)
    end
    
    local closestPlayer = nil
    local shortestDistance = 50
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then continue end
            local dist = (p.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestPlayer = p
            end
        end
    end
    
    if closestPlayer then
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote then
            local items = remote:FindFirstChild("Items")
            if items then
                local twist = items:FindFirstChild("Twist of Fate")
                if twist then
                    local fireRemote = twist:FindFirstChild("Fire")
                    if fireRemote then
                        local dir = (closestPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Unit
                        fireRemote:FireServer(gun, dir)
                        Notify("Auto Escape", "Shot fired at killer!", 3)
                    end
                end
            end
        end
    else
        Notify("Auto Escape", "Killer not found nearby!", 3)
    end
end)

local noAimShiftActive = false
MakeToggle("NoAimShiftToggle", "Disable Aim Camera Shift", function(val)
    noAimShiftActive = val
    if not _G.VDNoAimShiftLoop then
        _G.VDNoAimShiftLoop = runService.RenderStepped:Connect(function()
            if noAimShiftActive then
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.CameraOffset ~= Vector3.new(0, 0, 0) then
                    hum.CameraOffset = Vector3.new(0, 0, 0)
                end
            end
        end)
    end
end)

local function isCarryingSurvivor()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("Weld") or v:IsA("Motor6D") or v:IsA("WeldConstraint") then
            local p1 = v.Part1 and v.Part1.Parent
            local p0 = v.Part0 and v.Part0.Parent
            if (p1 and Players:GetPlayerFromCharacter(p1) and p1 ~= char) or 
               (p0 and Players:GetPlayerFromCharacter(p0) and p0 ~= char) then
                return true
            end
        end
    end
    return false
end

local isBusyWithSurvivor = false
local autoAttackToggleObj = nil
local wasAutoAttackEnabled = false
local kebalTwistActive = false
local godModeConnection = nil
local isShootingTwist = false

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() then
        if method == "FireServer" and typeof(self) == "Instance" then
            local name = self.Name
            if name == "CarrySurvivorEvent" or name == "HookEvent" or name == "HookPhase" or name == "PlayAnimation" then
                print("[VD DEBUG] Carry/Hook Event detected:", name, "autoAttackActive:", autoAttackActive, "isBusyWithSurvivor:", isBusyWithSurvivor)
                if autoAttackActive and not isBusyWithSurvivor then
                    isBusyWithSurvivor = true
                    wasAutoAttackEnabled = true
                    autoAttackActive = false                     task.spawn(function()
                        UICommunicationEvent:Fire("SetAutoAttackState", false, true)
                        UICommunicationEvent:Fire("ShowNotification", "Auto Attack", "Paused (Carrying)", 2)
                    end)
                end
            elseif name == "HookEventsucceess" or name == "HookCommit" or name == "HookReject" or name == "SelfUnHookEvent" or name == "UnhookSuccess" or name == "UnHookEvent" or name == "DropSurvivorEvent" then
                print("[VD DEBUG] Drop/Hook Success Event detected:", name, "wasAutoAttackEnabled:", wasAutoAttackEnabled)
                if wasAutoAttackEnabled then
                    wasAutoAttackEnabled = false
                    isBusyWithSurvivor = false 
                    task.spawn(function()
                        UICommunicationEvent:Fire("SetAutoAttackState", true, true)
                        UICommunicationEvent:Fire("ShowNotification", "Auto Attack", "Resumed", 2)
                    end)
                    task.delay(1.5, function()
                        autoAttackActive = true 
                        print("[VD DEBUG] autoAttackActive set back to true")
                    end)
                else
                    task.delay(1.5, function() isBusyWithSurvivor = false end)
                end
            elseif name == "Fire" and self.Parent and self.Parent.Name == "Twist of Fate" then
                if aimbotActive then
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local myPos = myChar.HumanoidRootPart.Position
                        local closestPlayer = nil
                        local shortestDistance = math.huge
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                                if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then continue end
                                local pos = p.Character.HumanoidRootPart.Position
                                local dist = (pos - myPos).Magnitude
                                if dist < shortestDistance then
                                    shortestDistance = dist
                                    closestPlayer = p
                                end
                            end
                        end
                        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local targetPos = closestPlayer.Character.HumanoidRootPart.Position
                            local head = closestPlayer.Character:FindFirstChild("Head")
                            if head then targetPos = head.Position end
                            
                            local gunPos = myPos
                            local gun = myChar:FindFirstChild("Twist of Fate")
                            if gun and gun:FindFirstChild("Handle") then gunPos = gun.Handle.Position end
                            
                            local direction = (targetPos - gunPos).Unit
                            args[2] = direction
                        end
                    end
                end
            end
        end
    end
    return oldNamecall(self, unpack(args))
end))

autoAttackToggleObj = MakeToggle("AutoAttack", "Auto Attack", function(val)
    autoAttackActive = val
    if not val then wasAutoAttackEnabled = false end end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if isBusyWithSurvivor and not isCarryingSurvivor() then
            print("[VD DEBUG] Failsafe triggered: No survivor weld found. Resetting state.")
            isBusyWithSurvivor = false
            if wasAutoAttackEnabled then
                wasAutoAttackEnabled = false
                autoAttackActive = true
                task.spawn(function()
                    UICommunicationEvent:Fire("SetAutoAttackState", true, true)
                    UICommunicationEvent:Fire("ShowNotification", "Auto Attack", "Resumed (Failsafe)", 2)
                end)
            end
        end
        if autoAttackActive then
            pcall(function()
                if isBusyWithSurvivor or isCarryingSurvivor() then return end                 local myRoot = LocalPlayer.Character and getRoot(LocalPlayer.Character)
                if not myRoot then return end
                local targetInRange = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and getRoot(p.Character) then
                        if p.Team ~= LocalPlayer.Team then
                            local d = (getRoot(p.Character).Position - myRoot.Position).Magnitude
                            if d <= 5 then                                 targetInRange = true
                                break
                            end
                        end
                    end
                end
                if targetInRange then
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if remotes then
                        local attacks = remotes:FindFirstChild("Attacks")
                        if attacks then
                            local atk = attacks:FindFirstChild("BasicAttack") or attacks:FindFirstChild("Attack")
                            if atk then 
                                atk:FireServer() 
                                task.wait(2)                             end
                        end
                    end
                end
            end)
        end
    end
end)

MakeToggle("AutoLeave", "Auto Leave Generator", function(val)
    task.spawn(function()
        while val do
            task.wait(0.3)
            local root = LocalPlayer.Character and getRoot(LocalPlayer.Character)
            if root then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local role = p:GetAttribute("Role")
                        if role == "Killer" then
                            local kRoot = getRoot(p.Character)
                            if kRoot then
                                local dist = (root.Position - kRoot.Position).Magnitude
                                if dist < 30 then
                                    pcall(function()
                                        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                                        if remotes then
                                            local gen = remotes:FindFirstChild("Generator")
                                            if gen then
                                                local leave = gen:FindFirstChild("LeaveGenerator")
                                                if leave then leave:FireServer() end
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end
            end
            if not val then break end
        end
    end)
end)


MakeSection("VISUAL")

MakeToggle("Fullbright", "Fullbright", function(val)
    if val then
        _G._VD_OrigLighting = _G._VD_OrigLighting or {
            Ambient = Lighting.Ambient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows,
            OutdoorAmbient = Lighting.OutdoorAmbient,
        }
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)

        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("AtmosphereEffect") or v:IsA("Atmosphere") then
                v.Enabled = false
            end
        end
    else
        if _G._VD_OrigLighting then
            Lighting.Ambient = _G._VD_OrigLighting.Ambient
            Lighting.Brightness = _G._VD_OrigLighting.Brightness
            Lighting.ClockTime = _G._VD_OrigLighting.ClockTime
            Lighting.FogEnd = _G._VD_OrigLighting.FogEnd
            Lighting.GlobalShadows = _G._VD_OrigLighting.GlobalShadows
            Lighting.OutdoorAmbient = _G._VD_OrigLighting.OutdoorAmbient
        end
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("AtmosphereEffect") or v:IsA("Atmosphere") then
                v.Enabled = true
            end
        end
    end
end)

local fpsActive = false
local fpsLabel = nil

MakeToggle("FPSCounter", "FPS Counter", function(val)
    fpsActive = val
    if val then
        if not fpsLabel then
            local fpsGui = Instance.new("ScreenGui", GuiParent)
            fpsGui.Name = "VD_FPS"
            fpsGui.ResetOnSpawn = false
            fpsGui.DisplayOrder = 200

            fpsLabel = Instance.new("TextLabel", fpsGui)
            fpsLabel.Size = UDim2.new(0, 80, 0, 24)
            fpsLabel.Position = UDim2.new(0, 10, 0, 10)
            fpsLabel.BackgroundColor3 = Theme.NotifBg
            fpsLabel.BackgroundTransparency = 0.15
            fpsLabel.BorderSizePixel = 0
            fpsLabel.Font = Enum.Font.GothamBold
            fpsLabel.TextSize = 12
            fpsLabel.TextColor3 = Theme.Accent
            fpsLabel.Text = "FPS: --"
            Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 8)

            task.spawn(function()
                local lastTime = tick()
                local frameCount = 0
                RunService.RenderStepped:Connect(function()
                    frameCount = frameCount + 1
                    local now = tick()
                    if now - lastTime >= 1 then
                        if fpsLabel and fpsLabel.Parent then
                            fpsLabel.Text = "FPS: " .. frameCount
                        end
                        frameCount = 0
                        lastTime = now
                    end
                end)
            end)
        end
        fpsLabel.Visible = true
        if fpsLabel.Parent then fpsLabel.Parent.Enabled = true end
    else
        if fpsLabel then
            fpsLabel.Visible = false
        end
    end
end)

MakeSection("TELEPORTATION")

MakeButton("TP to Closest Generator", function()
    local closest, cDist = nil, math.huge
    local root = LocalPlayer.Character and getRoot(LocalPlayer.Character)
    if not root then Notify("Teleport", "No character found", 2) return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            local prog = obj:GetAttribute("RepairProgress") or 0
            if prog < 1 then
                local part = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (root.Position - part.Position).Magnitude
                    if d < cDist then cDist = d; closest = part end
                end
            end
        end
    end

    if closest then
        root.CFrame = closest.CFrame * CFrame.new(0, 5, 3)
        Notify("Teleport", "Moved to closest generator (" .. math.floor(cDist) .. "m)", 3)
    else
        Notify("Teleport", "No incomplete generators found", 2)
    end
end)

MakeButton("TP to Escape / Gate", function()
    local root = LocalPlayer.Character and getRoot(LocalPlayer.Character)
    if not root then Notify("Teleport", "No character found", 2) return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj.Name == "Escape" or obj.Name == "Gate") and obj:IsA("Model") then
            local part = obj:FindFirstChildWhichIsA("BasePart")
            if part then
                root.CFrame = part.CFrame * CFrame.new(0, 5, 0)
                Notify("Teleport", "Moved to " .. obj.Name, 3)
                return
            end
        end
    end
    Notify("Teleport", "No escape zone found", 2)
end)

MakeButton("Safe TP to Generator (Tween)", function()
    local closest, cDist = nil, math.huge
    local root = LocalPlayer.Character and getRoot(LocalPlayer.Character)
    if not root then Notify("Teleport", "No character found", 2) return end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Generator" and obj:IsA("Model") then
            local prog = obj:GetAttribute("RepairProgress") or 0
            if prog < 1 then
                local part = obj:FindFirstChild("Main") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (root.Position - part.Position).Magnitude
                    if d < cDist then cDist = d; closest = part end
                end
            end
        end
    end

    if closest then
        local targetCF = closest.CFrame * CFrame.new(0, 3, 3)
        local speed = 80          local duration = math.min(cDist / speed, 10)  
        Notify("Safe TP", "Tweening to generator... (" .. string.format("%.1f", duration) .. "s)", duration + 1)

        local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            CFrame = targetCF
        })
        tween:Play()
    else
        Notify("Safe TP", "No incomplete generators found", 2)
    end
end)

MakeSection("DEBUG")

MakeButton("Print All Remotes", function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then
        Notify("Debug", "No 'Remotes' folder found", 2)
        return
    end

    local count = 0
    local function scan(parent, indent)
        for _, child in ipairs(parent:GetChildren()) do
            local prefix = string.rep("  ", indent)
            local className = child.ClassName
            print(prefix .. child.Name .. " [" .. className .. "]")
            count = count + 1
            if #child:GetChildren() > 0 then
                scan(child, indent + 1)
            end
        end
    end

    print("========== VIOLENCE DISTRICT REMOTES ==========")
    scan(remotes, 0)
    print("===============================================")
    Notify("Debug", "Printed " .. count .. " remotes to console (F9)", 4)
end)

MakeSection("PERFORMANCE")

MakeToggle("MobileOpt", "Mobile Optimization", function(val)
    if val then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        pcall(function() sethiddenproperty(Lighting, "Technology", 2) end)
        local removed = 0
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v:Destroy()
                removed = removed + 1
            end
        end
        Notify("Performance", "Optimized! Removed " .. removed .. " effects", 3)
    end
end)

MakeToggle("DisableShadows", "Disable Shadows", function(val)
    Lighting.GlobalShadows = not val
end)

MakeToggle("ReduceRender", "Reduce Render Distance", function(val)
    if val then
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    else
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
    end
end)

MakeSection("SCRIPT CONTROLS")

MakeLabel("Info: The 'R' button on the top right is to Refresh All ESPs when moving Maps.\nInfo: Tombol 'R' di kanan atas adalah untuk Refresh Semua ESP pada saat pindah Map.")

local function RefreshAllESP()
    stopPlayerESP()
    clearObjectESPByTag("All")
    if ESPConfig.PlayerESP then startPlayerESP() end
    if ESPConfig.GeneratorESP or ESPConfig.HookESP or ESPConfig.PalletESP or ESPConfig.WindowESP or ESPConfig.GateESP then
        refreshObjectESP()
    end
end

RefreshBtn.MouseButton1Click:Connect(function()
    RefreshAllESP()
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.delay(1.5, function()
        RefreshAllESP()
        pcall(function() Notify("Auto Refresh", "Map loaded, ESP Refreshed!", 2) end)
    end)
end)

MakeButton("Clear All ESP", function()
    stopPlayerESP()
    for _, child in ipairs(ESPFolder:GetChildren()) do child:Destroy() end
    ESPConfig.PlayerESP = false
    ESPConfig.GeneratorESP = false
    ESPConfig.HookESP = false
    ESPConfig.PalletESP = false
    ESPConfig.WindowESP = false
    ESPConfig.GateESP = false
    for _, obj in ipairs(GuiParent:FindFirstChild("PXViolenceDistrict") and GuiParent.PXViolenceDistrict:GetDescendants() or {}) do
        if obj:IsA("TextLabel") and (
            obj.Text == "Player ESP" or obj.Text == "Generator ESP" or 
            obj.Text == "Hook ESP" or obj.Text == "Pallet ESP" or 
            obj.Text == "Window ESP" or obj.Text == "Gate & Lever ESP") then
            local toggleFrame = obj.Parent
            local indicator = toggleFrame:FindFirstChild("Indicator")
            if indicator then
                obj.TextColor3 = Theme.TextDim
                indicator.BackgroundColor3 = Theme.ToggleOff
                indicator.UIStroke.Color = Theme.Border
                TweenService:Create(indicator.Knob, TweenInfo.new(0.2), {
                    Position = UDim2.new(0, 2, 0.5, 0),
                    BackgroundColor3 = Theme.TextDim
                }):Play()
            end
        end
    end

    Notify("ESP", "All ESP cleared & disabled", 2)
end)

MakeButton("Unload Script", function()
    Notify("Script", "Unloading...", 1)
    task.wait(0.5)
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    pcall(function()
        local c = LocalPlayer.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then
            h.MaxHealth = 100
            h.Health = 100
        end
    end)
    -- Restore original healing remotes if they were dummied
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local heal = remotes:FindFirstChild("Healing")
            if heal then
                for name, original in pairs(originalHealRemotes) do
                    local dummy = heal:FindFirstChild(name)
                    if dummy then dummy:Destroy() end
                    original.Parent = heal
                end
                table.clear(originalHealRemotes)
            end
        end
    end)
    
    if _G.VDAimbotLoop then _G.VDAimbotLoop:Disconnect(); _G.VDAimbotLoop = nil end
    if _G.VDNoAimShiftLoop then
        _G.VDNoAimShiftLoop:Disconnect(); _G.VDNoAimShiftLoop = nil
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
        end)
    end
    if _G.VDHitboxLoop then 
        _G.VDHitboxLoop:Disconnect(); _G.VDHitboxLoop = nil 
        -- Reset all hitboxes
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                    end
                end
            end
        end)
    end

    if crosshairDot then crosshairDot:Destroy(); crosshairDot = nil end
    
    stopPlayerESP()
    for _, conn in ipairs(objectESPConns) do pcall(function() conn:Disconnect() end) end
    if fpsLabel and fpsLabel.Parent then fpsLabel.Parent:Destroy() end
    ESPFolder:Destroy()
    ScreenGui:Destroy()
end)

Notify("PIXECUTE", "Violence District loaded!", 3)