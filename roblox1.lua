-- 🌀 AXIS Admin Panel (Neon-Tech Edition)
-- Professional Macro-Style Aesthetic + Ergonomic Grid Layout
-- Features: Fling, Speed, Infinite Jump, Phase, ESP, Crosshair, Invisibility, Fly, Float, Click TP, Free Cam, Infinite Zoom, Freeze, Aimbot (Wall Check)
-- UI Toggle: RightControl | Includes Menu Tab, Minimize, Close, Keybind System, and Target Tools

local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local startTime = os.time()
local featureBinds = {} -- Store keybinds: { [KeyCode] = toggleFunction }
local bindLabelRefs = {} -- Store references to update labels on reset

-- =========================
-- AXIS DESIGN TOKENS
-- =========================
local THEME = {
    MainBG = Color3.fromRGB(7, 7, 10),         -- Deep Obsidian
    SidebarBG = Color3.fromRGB(11, 11, 15),    -- Sidebar Depth
    Surface = Color3.fromRGB(22, 22, 30),      -- Surface Panels
    Accent = Color3.fromRGB(0, 212, 255),      -- Electric Cyan (#00D4FF)
    SecondaryAccent = Color3.fromRGB(100, 230, 255), -- Sky Glow
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(140, 150, 160),
    ButtonOFF = Color3.fromRGB(30, 30, 40),
    ButtonON = Color3.fromRGB(0, 180, 255),
    Green = Color3.fromRGB(0, 255, 150),
    Red = Color3.fromRGB(255, 70, 70),
    Stroke = Color3.fromRGB(45, 45, 55),
    ModalOverlay = Color3.fromRGB(0, 0, 0)
}

-- Layout Constants
local MAIN_SIZE = UDim2.new(0, 800, 0, 550)
local MAIN_POS = UDim2.new(0.5, -400, 0.5, -275)
local WARNING_POS = UDim2.new(0.5, 410, 0.5, -90)

-- =========================
-- UTILITY FUNCTIONS
-- =========================
local function getPlayer(str)
    str = str:lower()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Name:lower():sub(1, #str) == str or v.DisplayName:lower():sub(1, #str) == str then
            return v
        end
    end
end

-- =========================
-- UI ANIMATION HELPERS
-- =========================
local function createRipple(button)
    button.ClipsDescendants = true
    local mouse = player:GetMouse()
    local pX, pY = mouse.X - button.AbsolutePosition.X, mouse.Y - button.AbsolutePosition.Y
    
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.8
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, pX, 0, pY)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Parent = button
    
    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
    
    local goalSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, goalSize, 0, goalSize),
        BackgroundTransparency = 1
    }):Play()
    
    task.delay(0.5, function() ripple:Destroy() end)
end

local function applyHoverLift(button)
    local originalPos = button.Position
    local liftPos = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale, originalPos.Y.Offset - 5)
    local scale = button:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", button)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = liftPos,
            BackgroundColor3 = THEME.ButtonOFF:Lerp(Color3.new(1,1,1), 0.1)
        }):Play()
        TweenService:Create(scale, TweenInfo.new(0.2), {Scale = 1.1}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        local isActive = button:GetAttribute("Active")
        local targetColor = (isActive) and THEME.Surface or THEME.ButtonOFF
        
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = originalPos,
            BackgroundColor3 = targetColor
        }):Play()
        TweenService:Create(scale, TweenInfo.new(0.2), {Scale = 1}):Play()
    end)
end

local function applyHoverEffect(button, isTab)
    local baseColor = button.BackgroundColor3
    local hoverColor = isTab and THEME.Surface or baseColor:Lerp(Color3.new(1,1,1), 0.1)
    local scale = button:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", button)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
            BackgroundColor3 = hoverColor
        }):Play()
        TweenService:Create(scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1.05
        }):Play()
        
        local text = (button:IsA("TextButton") and button)
        if text and not isTab then
            TweenService:Create(text, TweenInfo.new(0.25), {TextColor3 = THEME.Accent}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        local isActive = button:GetAttribute("Active")
        local targetColor = (isTab and not isActive) and THEME.SidebarBG or (isTab and THEME.Surface or baseColor)
        
        TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
            BackgroundColor3 = targetColor
        }):Play()
        TweenService:Create(scale, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
            Scale = 1
        }):Play()
        
        local text = (button:IsA("TextButton") and button)
        if text and not isTab then
            TweenService:Create(text, TweenInfo.new(0.25), {TextColor3 = THEME.TextPrimary}):Play()
        end
    end)

    button.MouseButton1Down:Connect(function() createRipple(button) end)
end

-- =========================
-- GUI CORE SETUP
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AxisMacroUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 2147483647 
gui.IgnoreGuiInset = true 
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global 

local success, targetParent = pcall(function() return game:GetService("CoreGui") end)
if not success or not targetParent then
    targetParent = player:WaitForChild("PlayerGui")
end
gui.Parent = targetParent

-- Minimized Icon
local minIcon = Instance.new("TextButton")
minIcon.Name = "MinimizedIcon"
minIcon.Size = UDim2.new(0, 45, 0, 45)
minIcon.Position = UDim2.new(0.5, -22, 0, -60) 
minIcon.BackgroundColor3 = THEME.MainBG
minIcon.Text = "A"
minIcon.Font = Enum.Font.GothamBold
minIcon.TextColor3 = THEME.Accent
minIcon.TextSize = 22
minIcon.ZIndex = 50
minIcon.Parent = gui
minIcon.Visible = false

Instance.new("UICorner", minIcon).CornerRadius = UDim.new(1, 0)
local iconStroke = Instance.new("UIStroke", minIcon)
iconStroke.Color = THEME.Accent
iconStroke.Thickness = 2
applyHoverEffect(minIcon, false)

local main = Instance.new("Frame")
main.Size = MAIN_SIZE
main.Position = MAIN_POS
main.BackgroundColor3 = THEME.MainBG
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = false 
main.ZIndex = 10 
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = THEME.Accent
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.5

-- Header Buttons Container
local headerButtons = Instance.new("Frame")
headerButtons.Size = UDim2.new(0, 80, 0, 40)
headerButtons.Position = UDim2.new(1, -90, 0, 10)
headerButtons.BackgroundTransparency = 1
headerButtons.ZIndex = 500
headerButtons.Parent = main

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeButton"
minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
minimizeBtn.Position = UDim2.new(0, 0, 0, 0)
minimizeBtn.BackgroundColor3 = THEME.Surface
minimizeBtn.Text = "_"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextColor3 = THEME.TextSecondary
minimizeBtn.TextSize = 18
minimizeBtn.ZIndex = 501
minimizeBtn.Parent = headerButtons
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)
applyHoverLift(minimizeBtn)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(0, 40, 0, 0)
closeBtn.BackgroundColor3 = THEME.Surface
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = THEME.Red
closeBtn.TextSize = 22
closeBtn.ZIndex = 501
closeBtn.Parent = headerButtons
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
applyHoverLift(closeBtn)

-- Warning Modal Overlay (Side-Aligned)
local modalOverlay = Instance.new("Frame")
modalOverlay.Name = "ModalOverlay"
modalOverlay.Size = UDim2.new(1, 0, 1, 0)
modalOverlay.BackgroundTransparency = 1
modalOverlay.Visible = false
modalOverlay.ZIndex = 2000 
modalOverlay.Parent = gui

local warningModal = Instance.new("Frame")
warningModal.Size = UDim2.new(0, 300, 0, 180)
warningModal.Position = WARNING_POS
warningModal.BackgroundColor3 = THEME.MainBG
warningModal.BorderSizePixel = 0
warningModal.ClipsDescendants = true
warningModal.Parent = modalOverlay
Instance.new("UICorner", warningModal).CornerRadius = UDim.new(0, 12)
local modalStroke = Instance.new("UIStroke", warningModal)
modalStroke.Color = THEME.Red
modalStroke.Thickness = 2

local warningText = Instance.new("TextLabel")
warningText.Size = UDim2.new(1, -40, 0, 60)
warningText.Position = UDim2.new(0, 20, 0, 30)
warningText.BackgroundTransparency = 1
warningText.Text = "Are you sure you want to completely close AXIS?"
warningText.Font = Enum.Font.GothamBold
warningText.TextColor3 = THEME.TextPrimary
warningText.TextSize = 14
warningText.TextWrapped = true
warningText.Parent = warningModal

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.4, 0, 0, 40)
confirmBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
confirmBtn.BackgroundColor3 = THEME.Red
confirmBtn.Text = "CONFIRM"
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextColor3 = THEME.TextPrimary
confirmBtn.TextSize = 12
confirmBtn.Parent = warningModal
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)
applyHoverEffect(confirmBtn, false)

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0.4, 0, 0, 40)
cancelBtn.Position = UDim2.new(0.55, 0, 0.7, 0)
cancelBtn.BackgroundColor3 = THEME.Surface
cancelBtn.Text = "CANCEL"
cancelBtn.Font = Enum.Font.GothamBold
cancelBtn.TextColor3 = THEME.TextPrimary
cancelBtn.TextSize = 12
cancelBtn.Parent = warningModal
Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8)
applyHoverEffect(cancelBtn, false)

-- Scan Line Effect
local scanLine = Instance.new("Frame")
scanLine.Name = "ScanLine"
scanLine.Size = UDim2.new(1, 0, 0, 1)
scanLine.Position = UDim2.new(0, 0, 0, 0)
scanLine.BackgroundColor3 = THEME.Accent
scanLine.BackgroundTransparency = 0.8
scanLine.BorderSizePixel = 0
scanLine.ZIndex = 11
scanLine.Parent = main

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 200, 1, 0)
sidebar.BackgroundColor3 = THEME.SidebarBG
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 12
sidebar.Parent = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)

local sidebarBorder = Instance.new("Frame")
sidebarBorder.Name = "SidebarBorder"
sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
sidebarBorder.Position = UDim2.new(1, 0, 0, 0)
sidebarBorder.BackgroundColor3 = THEME.Stroke
sidebarBorder.BorderSizePixel = 0
sidebarBorder.Parent = sidebar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 80)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "AXIS"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = THEME.Accent
titleLabel.TextSize = 24
titleLabel.ZIndex = 13
titleLabel.Parent = sidebar

local sidebarList = Instance.new("Frame")
sidebarList.Size = UDim2.new(1, -20, 1, -100)
sidebarList.Position = UDim2.new(0, 10, 0, 90)
sidebarList.BackgroundTransparency = 1
sidebarList.ZIndex = 13
sidebarList.Parent = sidebar

local sidebarLayout = Instance.new("UIListLayout", sidebarList)
sidebarLayout.Padding = UDim.new(0, 10)
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Area
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -200, 1, 0)
content.Position = UDim2.new(0, 200, 0, 0)
content.BackgroundTransparency = 1
content.ZIndex = 12
content.Parent = main

local function makePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = THEME.Accent
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ZIndex = 13
    page.Parent = content
    
    local padding = Instance.new("UIPadding", page)
    padding.PaddingLeft, padding.PaddingRight = UDim.new(0, 35), UDim.new(0, 35)
    padding.PaddingTop, padding.PaddingBottom = UDim.new(0, 60), UDim.new(0, 40)
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 18)
    return page
end

local pages = {
    Menu = makePage("Menu"),
    Movement = makePage("Movement"),
    Combat = makePage("Combat"),
    Utility = makePage("Utility"),
    Visuals = makePage("Visuals")
}
pages.Menu.Visible = true

local tabCount = 0
local function makeTab(name, page)
    tabCount = tabCount + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = (name == "Menu") and THEME.Surface or THEME.SidebarBG
    btn.BackgroundTransparency = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = (name == "Menu") and THEME.Accent or THEME.TextSecondary
    btn.TextSize = 13
    btn.ZIndex = 14
    btn.LayoutOrder = tabCount
    btn.Parent = sidebarList
    btn:SetAttribute("Active", name == "Menu")

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = THEME.Stroke
    btnStroke.Thickness = 1
    btnStroke.Transparency = (name == "Menu") and 0.2 or 0.8

    local activeIndicator = Instance.new("Frame")
    activeIndicator.Name = "ActiveIndicator"
    activeIndicator.Size = UDim2.new(0, 4, 0.4, 0)
    activeIndicator.Position = UDim2.new(0, 8, 0.3, 0)
    activeIndicator.BackgroundColor3 = THEME.Accent
    activeIndicator.Visible = (name == "Menu")
    activeIndicator.BorderSizePixel = 0
    activeIndicator.ZIndex = 15
    activeIndicator.Parent = btn
    Instance.new("UICorner", activeIndicator).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        for _, b in ipairs(sidebarList:GetChildren()) do 
            if b:IsA("TextButton") then 
                b.TextColor3 = THEME.TextSecondary 
                b.BackgroundColor3 = THEME.SidebarBG
                b:SetAttribute("Active", false)
                local s = b:FindFirstChildOfClass("UIStroke")
                if s then s.Transparency = 0.8 end
                if b:FindFirstChild("ActiveIndicator") then b.ActiveIndicator.Visible = false end
            end
        end
        page.Visible = true
        btn:SetAttribute("Active", true)
        btn.TextColor3 = THEME.Accent
        btn.BackgroundColor3 = THEME.Surface
        btnStroke.Transparency = 0.2
        if btn:FindFirstChild("ActiveIndicator") then btn.ActiveIndicator.Visible = true end
    end)
    
    applyHoverEffect(btn, true)
end

makeTab("Menu", pages.Menu)
makeTab("Movement", pages.Movement)
makeTab("Combat", pages.Combat)
makeTab("Utility", pages.Utility)
makeTab("Visuals", pages.Visuals)

-- =========================
-- MENU DASHBOARD CONTENT
-- =========================
local function createHeader(parent, text)
    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(1, 0, 0, 25)
    h.BackgroundTransparency = 1
    h.Text = text:upper()
    h.Font = Enum.Font.GothamBold
    h.TextColor3 = THEME.TextSecondary
    h.TextSize = 11
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.ZIndex = 15
    h.Parent = parent
end

createHeader(pages.Menu, "System Status")
local runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Size = UDim2.new(1, 0, 0, 50)
runtimeLabel.BackgroundColor3 = THEME.Surface
runtimeLabel.Text = "Runtime: 00:00:00"
runtimeLabel.Font = Enum.Font.GothamBold
runtimeLabel.TextColor3 = THEME.Accent
runtimeLabel.TextSize = 16
runtimeLabel.ZIndex = 15
runtimeLabel.Parent = pages.Menu
Instance.new("UICorner", runtimeLabel).CornerRadius = UDim.new(0, 10)
local runStroke = Instance.new("UIStroke", runtimeLabel)
runStroke.Color = THEME.Stroke

createHeader(pages.Menu, "Control Configuration")
local bindContainer = Instance.new("Frame")
bindContainer.Size = UDim2.new(1, 0, 0, 220) -- Expanded
bindContainer.BackgroundColor3 = THEME.Surface
bindContainer.ZIndex = 15
bindContainer.Parent = pages.Menu
Instance.new("UICorner", bindContainer).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", bindContainer).Color = THEME.Stroke

local bindList = Instance.new("UIListLayout", bindContainer)
bindList.Padding = UDim.new(0, 8)
Instance.new("UIPadding", bindContainer).PaddingLeft = UDim.new(0, 15)
Instance.new("UIPadding", bindContainer).PaddingTop = UDim.new(0, 15)

local function addBind(text, key)
    local b = Instance.new("TextLabel")
    b.Size = UDim2.new(1, 0, 0, 20)
    b.BackgroundTransparency = 1
    b.Text = text .. ": [" .. key .. "]"
    b.Font = Enum.Font.GothamSemibold
    b.TextColor3 = THEME.TextPrimary
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ZIndex = 16
    b.Parent = bindContainer
end

addBind("Master UI Toggle", "RightControl")
addBind("Minimize Panel", "Top Right Icon")
addBind("Aimbot Lock", "Hold RightMouse")
addBind("Click Teleport", "Left Control + Click")
addBind("Float & FreeCam", "Space (Up) / E (Down)")
addBind("FreeCam Look", "Hold MouseButton2")

createHeader(pages.Menu, "Configuration Reset")
local resetBindsBtn = Instance.new("TextButton")
resetBindsBtn.Size = UDim2.new(1, 0, 0, 45)
resetBindsBtn.BackgroundColor3 = THEME.Red
resetBindsBtn.Text = "RESET ALL BINDS"
resetBindsBtn.Font = Enum.Font.GothamBold
resetBindsBtn.TextColor3 = THEME.TextPrimary
resetBindsBtn.TextSize = 14
resetBindsBtn.ZIndex = 15
resetBindsBtn.Parent = pages.Menu
Instance.new("UICorner", resetBindsBtn).CornerRadius = UDim.new(0, 10)
applyHoverEffect(resetBindsBtn, false)

resetBindsBtn.MouseButton1Click:Connect(function()
    featureBinds = {}
    for _, btn in pairs(bindLabelRefs) do
        btn.Text = "[NONE]"
        btn.TextColor3 = THEME.TextSecondary
        local s = btn:FindFirstChildOfClass("UIStroke")
        if s then s.Transparency = 0.8 end
    end
end)

createHeader(pages.Menu, "Development")
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, 0, 0, 50)
creditsLabel.BackgroundColor3 = THEME.Surface
creditsLabel.Text = "Build Version: 2.2.0 - Credits: IOOscripts"
creditsLabel.Font = Enum.Font.GothamBold
creditsLabel.TextColor3 = THEME.Accent
creditsLabel.TextSize = 15
creditsLabel.ZIndex = 15
creditsLabel.Parent = pages.Menu
Instance.new("UICorner", creditsLabel).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", creditsLabel).Color = THEME.Stroke

-- Update Runtime Timer
task.spawn(function()
    while main.Parent do
        local seconds = os.time() - startTime
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        runtimeLabel.Text = string.format("Runtime: %02d:%02d:%02d", h, m, s)
        task.wait(1)
    end
end)

-- =========================
-- MINIMIZE & CLOSE LOGIC
-- =========================
local isMinimized = false
local isUIOpen = true

local function restoreUI()
    isMinimized = false
    isUIOpen = true
    minIcon.Visible = true
    TweenService:Create(minIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -22, 0, -60)}):Play()
    task.delay(0.3, function()
        minIcon.Visible = false
        main.Visible = true
        TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = MAIN_SIZE, Position = MAIN_POS, BackgroundTransparency = 0}):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.5), {Transparency = 0.5}):Play()
    end)
end

local function minimizeUI()
    isMinimized = true
    isUIOpen = true
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    TweenService:Create(main, info, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0, 25), BackgroundTransparency = 1}):Play()
    TweenService:Create(mainStroke, info, {Transparency = 1}):Play()
    task.delay(0.5, function()
        main.Visible = false
        minIcon.Visible = true
        TweenService:Create(minIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -22, 0, 25)}):Play()
    end)
end

minimizeBtn.MouseButton1Click:Connect(minimizeUI)
minIcon.MouseButton1Click:Connect(restoreUI)

closeBtn.MouseButton1Click:Connect(function()
    modalOverlay.Visible = true
    TweenService:Create(warningModal, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 180)}):Play()
end)

cancelBtn.MouseButton1Click:Connect(function()
    TweenService:Create(warningModal, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(0.3, function() modalOverlay.Visible = false end)
end)

confirmBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- =========================
-- FEATURE TOGGLE COMPONENT
-- =========================

local function createToggle(parent, text, callback, hideBind)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = THEME.Surface
    btn.Text = "     " .. text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = THEME.TextPrimary
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 16
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = THEME.Stroke
    stroke.Thickness = 1
    stroke.Transparency = 0.5

    -- Keybind Button
    local bindBtn
    if not hideBind then
        bindBtn = Instance.new("TextButton")
        bindBtn.Name = "Keybind"
        bindBtn.Size = UDim2.new(0, 60, 0, 24)
        bindBtn.Position = UDim2.new(1, -115, 0.5, -12)
        bindBtn.BackgroundColor3 = THEME.ButtonOFF
        bindBtn.Text = "[NONE]"
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.TextColor3 = THEME.TextSecondary
        bindBtn.TextSize = 10
        bindBtn.ZIndex = 17
        bindBtn.Parent = btn
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)
        local bindStroke = Instance.new("UIStroke", bindBtn)
        bindStroke.Color = THEME.Accent
        bindStroke.Thickness = 1
        bindStroke.Transparency = 0.8
        table.insert(bindLabelRefs, bindBtn)
    end

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 34, 0, 16)
    indicator.Position = UDim2.new(1, -44, 0.5, -8)
    indicator.BackgroundColor3 = THEME.ButtonOFF
    indicator.ZIndex = 16
    indicator.Parent = btn
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = THEME.TextSecondary
    knob.ZIndex = 18
    knob.Parent = indicator
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = false
    local currentBind = nil

    local function toggleState()
        state = not state
        btn.Text = "     " .. text .. ": " .. (state and "ON" or "OFF")
        TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = state and THEME.ButtonON or THEME.ButtonOFF}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
            BackgroundColor3 = Color3.new(1,1,1)
        }):Play()
        callback(state)
    end

    btn.MouseButton1Click:Connect(toggleState)

    -- Keybind Logic
    if bindBtn then
        bindBtn.MouseButton1Click:Connect(function()
            if currentBind then featureBinds[currentBind] = nil end
            bindBtn.Text = "[...]"
            bindBtn.TextColor3 = THEME.Accent
            local connection
            connection = UIS.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentBind = input.KeyCode
                    featureBinds[currentBind] = toggleState
                    bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
                    bindBtn.TextColor3 = THEME.Accent
                    local s = bindBtn:FindFirstChildOfClass("UIStroke")
                    if s then s.Transparency = 0.2 end
                    connection:Disconnect()
                end
            end)
        end)
        applyHoverEffect(bindBtn, false)
    end

    applyHoverEffect(btn, false)
    return btn
end

local function createGridContainer(parent)
    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, 0, 0, 0)
    grid.BackgroundTransparency = 1
    grid.AutomaticSize = Enum.AutomaticSize.Y
    grid.ZIndex = 14
    grid.Parent = parent
    
    local layout = Instance.new("UIGridLayout", grid)
    layout.CellPadding = UDim2.new(0, 15, 0, 15)
    layout.CellSize = UDim2.new(0.5, -8, 0, 50)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    return grid
end

-- =========================
-- FEATURE IMPLEMENTATIONS
-- =========================

-- MOVEMENT PAGE
createHeader(pages.Movement, "Physics Modification")
local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, 0, 0, 52)
speedContainer.BackgroundTransparency = 1
speedContainer.ZIndex = 15
speedContainer.Parent = pages.Movement

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.75, -8, 1, 0)
speedBox.BackgroundColor3 = THEME.Surface:Lerp(Color3.new(1,1,1), 0.05)
speedBox.PlaceholderText = "Input Speed..."
speedBox.Text = ""
speedBox.TextColor3 = THEME.TextPrimary
speedBox.PlaceholderColor3 = THEME.TextSecondary
speedBox.Font = Enum.Font.GothamBold
speedBox.TextSize = 14
speedBox.ZIndex = 16
speedBox.Parent = speedContainer
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", speedBox).Color = THEME.Accent

local applySpeed = Instance.new("TextButton")
applySpeed.Size = UDim2.new(0.25, 0, 1, 0)
applySpeed.Position = UDim2.new(0.75, 0, 0, 0)
applySpeed.BackgroundColor3 = THEME.Accent
applySpeed.Text = "APPLY"
applySpeed.TextColor3 = THEME.MainBG
applySpeed.Font = Enum.Font.GothamBold
applySpeed.TextSize = 12
applySpeed.ZIndex = 16
applySpeed.Parent = speedContainer
Instance.new("UICorner", applySpeed).CornerRadius = UDim.new(0, 8)
applyHoverEffect(applySpeed, false)

applySpeed.MouseButton1Click:Connect(function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = tonumber(speedBox.Text) or 16 end
end)

local movementGrid = createGridContainer(pages.Movement)

createToggle(movementGrid, "Flight Mode", function(s)
    _G.Flying = s
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if s then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        local bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        task.spawn(function()
            while _G.Flying and hrp.Parent do
                if not UIS:GetFocusedTextBox() then
                    local cam = workspace.CurrentCamera
                    local dir = Vector3.new(0,0,0)
                    if UIS:IsKeyDown("W") then dir = dir + cam.CFrame.LookVector end
                    if UIS:IsKeyDown("S") then dir = dir - cam.CFrame.LookVector end
                    if UIS:IsKeyDown("A") then dir = dir - cam.CFrame.RightVector end
                    if UIS:IsKeyDown("D") then dir = dir + cam.CFrame.RightVector end
                    bv.Velocity = dir * 60
                    bg.CFrame = cam.CFrame
                end
                RunService.RenderStepped:Wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end)

createToggle(movementGrid, "Float Mode", function(s)
    _G.Floating = s
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if s then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(0, 1e9, 0)
        bv.Velocity = Vector3.new(0,0,0)
        task.spawn(function()
            while _G.Floating and hrp.Parent do
                if not UIS:GetFocusedTextBox() then
                    local vel = Vector3.new(0,0,0)
                    if UIS:IsKeyDown("Space") then vel = Vector3.new(0, 50, 0)
                    elseif UIS:IsKeyDown("E") then vel = Vector3.new(0, -50, 0) end
                    bv.Velocity = vel
                end
                RunService.Heartbeat:Wait()
            end
            if bv then bv:Destroy() end
        end)
    end
end)

createToggle(movementGrid, "Click TP", function(s) _G.ClickTP = s end)
createToggle(movementGrid, "Infinite Jump", function(s) _G.InfJump = s end)
UIS.JumpRequest:Connect(function() if _G.InfJump then player.Character.Humanoid:ChangeState("Jumping") end end)

-- COMBAT PAGE
createHeader(pages.Combat, "Offensive Operations")
local combatGrid = createGridContainer(pages.Combat)

local function isPartVisible(targetPart, character)
    local origin = workspace.CurrentCamera.CFrame.Position
    local destination = targetPart.Position
    local direction = (destination - origin)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {player.Character, character}
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, params)
    if not result then return true end
    if not result.Instance.CanCollide or result.Instance.Transparency > 0.75 then return true end
    return false
end

createToggle(combatGrid, "Snap Aimbot", function(s) _G.Aimbot = s end, true)
createToggle(combatGrid, "Team Check", function(s) _G.TeamCheck = s end)
createToggle(combatGrid, "Touch Fling", function(s)
    _G.FlingOn = s
    if s then
        task.spawn(function()
            local lp = Players.LocalPlayer
            local movel = 0.1
            while _G.FlingOn do
                RunService.Heartbeat:Wait()
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.Velocity
                    hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    hrp.Velocity = vel
                    RunService.Stepped:Wait()
                    hrp.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = -movel
                end
            end
        end)
    end
end)

local aiming = false
UIS.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton2 then aiming = false end end)

RunService.RenderStepped:Connect(function()
    -- Pauses snapping if Free Cam is active
    if _G.Aimbot and aiming and not _G.FreeCam then
        local target, dist = nil, 2000 -- Added distance threshold (2000 studs) to prevent spawn locking
        local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
        
        if myPos then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    -- Refined Team Check (Robust Check)
                    if _G.TeamCheck and player.Team and v.Team == player.Team then continue end
                    
                    local char = v.Character
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local head = char:FindFirstChild("Head")
                    if root then
                        local d = (myPos - root.Position).Magnitude
                        if d < dist then -- Checks if distance is less than current closest AND less than max range (2000)
                            if (head and isPartVisible(head, char)) or isPartVisible(root, char) then
                                target, dist = v, d
                            end
                        end
                    end
                end
            end
            
            if target and target.Character then 
                local aimPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
                if aimPart then
                    -- Modern snapping
                    workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, aimPart.Position)
                end
            end
        end
    end
end)

-- UTILITY PAGE
createHeader(pages.Utility, "Target Control")
local targetContainer = Instance.new("Frame")
targetContainer.Size = UDim2.new(1, 0, 0, 110)
targetContainer.BackgroundTransparency = 1
targetContainer.ZIndex = 15
targetContainer.Parent = pages.Utility

local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(1, 0, 0, 45)
userBox.BackgroundColor3 = THEME.Surface
userBox.PlaceholderText = "Target Username..."
userBox.Text = ""
userBox.TextColor3 = THEME.TextPrimary
userBox.Font = Enum.Font.GothamBold
userBox.TextSize = 14
userBox.ZIndex = 16
userBox.Parent = targetContainer
Instance.new("UICorner", userBox).CornerRadius = UDim.new(0, 8)
local userStroke = Instance.new("UIStroke", userBox)
userStroke.Color = THEME.Stroke
userStroke.Thickness = 1

local targetGrid = Instance.new("Frame")
targetGrid.Size = UDim2.new(1, 0, 0, 50)
targetGrid.Position = UDim2.new(0, 0, 0, 55)
targetGrid.BackgroundTransparency = 1
targetGrid.ZIndex = 15
targetGrid.Parent = targetContainer
local tgLayout = Instance.new("UIGridLayout", targetGrid)
tgLayout.CellPadding = UDim2.new(0, 10, 0, 0)
tgLayout.CellSize = UDim2.new(0.33, -7, 1, 0)

local function createTargetBtn(text, color, action)
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = THEME.Surface
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = color
    b.TextSize = 11
    b.ZIndex = 16
    b.Parent = targetGrid
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke", b)
    s.Color = color
    s.Transparency = 0.6
    
    b.MouseButton1Click:Connect(function()
        local target = getPlayer(userBox.Text)
        if target then action(target) end
    end)
    applyHoverEffect(b, false)
end

createTargetBtn("TP TO", THEME.Accent, function(t)
    if t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame
    end
end)

createTargetBtn("BRING", THEME.Green, function(t)
    if t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        t.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    end
end)

createTargetBtn("FLING", THEME.Red, function(t)
    if t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local oldPos = player.Character.HumanoidRootPart.CFrame
        task.spawn(function()
            local start = tick()
            while tick() - start < 1.5 do
                RunService.Heartbeat:Wait()
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local thrp = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
                if hrp and thrp then
                    hrp.CFrame = thrp.CFrame
                    hrp.Velocity = Vector3.new(99999, 99999, 99999)
                end
            end
            player.Character.HumanoidRootPart.CFrame = oldPos
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end)
    end
end)

createHeader(pages.Utility, "Environmental Control")
local utilityGrid = createGridContainer(pages.Utility)

-- FreeCam Logic
local freecamPos = workspace.CurrentCamera.CFrame.Position
local freecamYaw, freecamPitch = 0, 0
createToggle(utilityGrid, "Free Cam", function(s)
    _G.FreeCam = s
    local cam = workspace.CurrentCamera
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if s then
        if hrp then hrp.Anchored = true end
        cam.CameraType = Enum.CameraType.Scriptable
        freecamPos = cam.CFrame.Position
        local rx, ry, rz = cam.CFrame:ToOrientation()
        freecamYaw, freecamPitch = ry, rx
        
        task.spawn(function()
            while _G.FreeCam do
                if not UIS:GetFocusedTextBox() then
                    local delta = Vector3.new()
                    -- Movement
                    if UIS:IsKeyDown(Enum.KeyCode.W) then delta = delta + cam.CFrame.LookVector end
                    if UIS:IsKeyDown("S") then delta = delta - cam.CFrame.LookVector end
                    if UIS:IsKeyDown("A") then delta = delta - cam.CFrame.RightVector end
                    if UIS:IsKeyDown("D") then delta = delta + cam.CFrame.RightVector end
                    if UIS:IsKeyDown("Space") then delta = delta + Vector3.new(0, 1, 0) end
                    if UIS:IsKeyDown("E") then delta = delta - Vector3.new(0, 1, 0) end
                    
                    freecamPos = freecamPos + (delta * 2)
                    
                    -- Rotation (Hold Right Click)
                    if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                        local mouseDelta = UIS:GetMouseDelta()
                        UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                        freecamYaw = freecamYaw - (mouseDelta.X / 300)
                        freecamPitch = math.clamp(freecamPitch - (mouseDelta.Y / 300), -math.rad(89), math.rad(89))
                    else
                        UIS.MouseBehavior = Enum.MouseBehavior.Default
                    end
                end
                
                cam.CFrame = CFrame.new(freecamPos) * CFrame.fromOrientation(freecamPitch, freecamYaw, 0)
                RunService.RenderStepped:Wait()
            end
            cam.CameraType = Enum.CameraType.Custom
            UIS.MouseBehavior = Enum.MouseBehavior.Default
            if hrp then hrp.Anchored = false end
        end)
    else
        cam.CameraType = Enum.CameraType.Custom
        UIS.MouseBehavior = Enum.MouseBehavior.Default
        if hrp then hrp.Anchored = false end
    end
end)

createToggle(utilityGrid, "Noclip (Phase)", function(s) _G.Noclip = s end)
createToggle(utilityGrid, "Freeze", function(s)
    if player.Character then for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.Anchored = s end end end
end)
RunService.Stepped:Connect(function()
    if _G.Noclip and player.Character then for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
end)

-- VISUALS PAGE
createHeader(pages.Visuals, "Visual Intelligence")
local visualGrid = createGridContainer(pages.Visuals)

createToggle(visualGrid, "Infinite Zoom", function(s)
    _G.InfZoom = s
    player.CameraMaxZoomDistance = s and 1e6 or 128
end)

local espActive = false
createToggle(visualGrid, "Chams ESP", function(s) espActive = s end)
createToggle(visualGrid, "Invisibility", function(s)
    if player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then v.Transparency = s and 1 or 0 end
            if v:IsA("Decal") then v.Transparency = s and 1 or 0 end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if espActive then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local highlight = p.Character:FindFirstChild("AxisESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "AxisESP"
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.5
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
                    highlight.Parent = p.Character
                end
                highlight.FillColor = p.TeamColor.Color
                highlight.Enabled = true
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("AxisESP") then p.Character.AxisESP:Destroy() end end
    end
end)

-- KEYBOARD LISTENER (For Master Toggle, Keybinds, and Click TP)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then 
        if isMinimized then
            restoreUI()
        else
            minimizeUI()
        end
    end
    
    -- Click TP Logic (Left Control + Click)
    if _G.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mousePos = UIS:GetMouseLocation()
        local ray = workspace.CurrentCamera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000)
        if result and player.Character then
            player.Character:SetPrimaryPartCFrame(CFrame.new(result.Position + Vector3.new(0, 3, 0)))
        end
    end

    local action = featureBinds[input.KeyCode]
    if action then
        action()
    end
end)

-- Animations Loop
task.spawn(function()
    while main.Parent do
        local t1 = TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.2})
        t1:Play()
        scanLine.Position = UDim2.new(0, 0, 0, 0)
        TweenService:Create(scanLine, TweenInfo.new(4, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 0, 1, 0)}):Play()
        t1.Completed:Wait()
        local t2 = TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.7})
        t2:Play()
        t2.Completed:Wait()
    end
end)
