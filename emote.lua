
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- cleanup previous if exists
do
    local old = playerGui:FindFirstChild("EmoteBypass")
    if old then pcall(function() old:Destroy() end) end
end

-- Gui
local gui = Instance.new("ScreenGui")
gui.Name = "EmoteBypass"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 360)
frame.Position = UDim2.new(0.5, -150, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
frame.BackgroundTransparency = 0.1
frame.Parent = gui
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 220, 130)
stroke.Thickness = 2

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(0, 220, 130)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Bypass Emote (AssetId)"
title.Parent = frame

-- window controls
local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0, 24, 0, 24)
btnMin.Position = UDim2.new(1, -52, 0, 6)
btnMin.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
btnMin.AutoButtonColor = true
btnMin.Text = "-"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 16
btnMin.TextColor3 = Color3.fromRGB(255,255,255)
btnMin.Parent = frame
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 6)

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 24, 0, 24)
btnClose.Position = UDim2.new(1, -24, 0, 6)
btnClose.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
btnClose.AutoButtonColor = true
btnClose.Text = "X"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 14
btnClose.TextColor3 = Color3.fromRGB(255,255,255)
btnClose.Parent = frame
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)

-- content holder
local contentHolder = Instance.new("Frame")
contentHolder.Name = "Content"
contentHolder.BackgroundTransparency = 1
contentHolder.Size = UDim2.new(1, 0, 1, -34)
contentHolder.Position = UDim2.new(0, 0, 0, 34)
contentHolder.Parent = frame

-- status label (shows rig type / errors)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 18)
statusLabel.Position = UDim2.new(0, 10, 0, 6)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextColor3 = Color3.fromRGB(180, 220, 200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Text = ""
statusLabel.Parent = contentHolder

-- rig detection + status & Play availability
local function updateRigStatus()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    local rig = hum and hum.RigType or Enum.HumanoidRigType.R6
    if rig == Enum.HumanoidRigType.R6 then
        statusLabel.Text = "Rig: R6 (tidak didukung)"
        btnPlay.Active = false
        btnPlay.AutoButtonColor = false
        btnPlay.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btnPlay.TextTransparency = 0.4
    else
        statusLabel.Text = "Rig: R15 (siap)"
        btnPlay.Active = true
        btnPlay.AutoButtonColor = true
        btnPlay.BackgroundColor3 = Color3.fromRGB(0,120,90)
        btnPlay.TextTransparency = 0
    end
end

task.defer(updateRigStatus)
player.CharacterAdded:Connect(function()
    task.wait(0.2)
    updateRigStatus()
end)

local input = Instance.new("TextBox")
input.Name = "AssetBox"
input.Size = UDim2.new(1, -20, 0, 32)
input.Position = UDim2.new(0, 10, 0, 24)
input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
input.BackgroundTransparency = 0.1
input.PlaceholderText = "Enter Animation AssetId (e.g. 507776043)"
input.Text = "103040723950430" -- Gojo Floating default
input.TextSize = 14
input.Font = Enum.Font.GothamMedium
input.TextColor3 = Color3.fromRGB(255,255,255)
input.ClearTextOnFocus = false
input.Parent = contentHolder
Instance.new("UICorner", input).CornerRadius = UDim.new(0,8)
local s1 = Instance.new("UIStroke", input)
s1.Color = Color3.fromRGB(0,130,80)
s1.Thickness = 1.5

local btnPlay = Instance.new("TextButton")
btnPlay.Size = UDim2.new(0.48, -10, 0, 32)
btnPlay.Position = UDim2.new(0, 10, 0, 66)
btnPlay.BackgroundColor3 = Color3.fromRGB(0, 120, 90)
btnPlay.Text = "Play"
btnPlay.Font = Enum.Font.GothamBold
btnPlay.TextSize = 14
btnPlay.TextColor3 = Color3.fromRGB(255,255,255)
btnPlay.Parent = contentHolder
Instance.new("UICorner", btnPlay).CornerRadius = UDim.new(0,8)

local btnStop = Instance.new("TextButton")
btnStop.Size = UDim2.new(0.48, -10, 0, 32)
btnStop.Position = UDim2.new(1, -10, 0, 66)
btnStop.AnchorPoint = Vector2.new(1,0)
btnStop.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
btnStop.Text = "Stop"
btnStop.Font = Enum.Font.GothamBold
btnStop.TextSize = 14
btnStop.TextColor3 = Color3.fromRGB(255,255,255)
btnStop.Parent = contentHolder
Instance.new("UICorner", btnStop).CornerRadius = UDim.new(0,8)

-- Toggles: Blend (smooth with default anims) and Loop
local blendOn = true
local loopOn = true

local btnBlend = Instance.new("TextButton")
btnBlend.Size = UDim2.new(0.48, -10, 0, 24)
btnBlend.Position = UDim2.new(0, 10, 0, 100)
btnBlend.BackgroundColor3 = Color3.fromRGB(0, 80, 60)
btnBlend.Font = Enum.Font.GothamBold
btnBlend.TextSize = 12
btnBlend.TextColor3 = Color3.fromRGB(255,255,255)
btnBlend.Parent = contentHolder
Instance.new("UICorner", btnBlend).CornerRadius = UDim.new(0,6)

local btnLoop = Instance.new("TextButton")
btnLoop.Size = UDim2.new(0.48, -10, 0, 24)
btnLoop.Position = UDim2.new(1, -10, 0, 100)
btnLoop.AnchorPoint = Vector2.new(1,0)
btnLoop.BackgroundColor3 = Color3.fromRGB(0, 80, 60)
btnLoop.Font = Enum.Font.GothamBold
btnLoop.TextSize = 12
btnLoop.TextColor3 = Color3.fromRGB(255,255,255)
btnLoop.Parent = contentHolder
Instance.new("UICorner", btnLoop).CornerRadius = UDim.new(0,6)

local function refreshToggleTexts()
    btnBlend.Text = blendOn and "Blend: ON" or "Blend: OFF"
    btnLoop.Text = loopOn and "Loop: ON" or "Loop: OFF"
end
refreshToggleTexts()

btnBlend.MouseButton1Click:Connect(function()
    blendOn = not blendOn
    refreshToggleTexts()
end)

btnLoop.MouseButton1Click:Connect(function()
    loopOn = not loopOn
    refreshToggleTexts()
end)

-- Logic
local currentTrack: AnimationTrack? = nil

local function getAnimator()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil, nil end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    return hum, animator
end

local function stopEmote()
    if currentTrack then
        pcall(function()
            currentTrack:Stop(0.2)
            currentTrack:Destroy()
        end)
        currentTrack = nil
    end
    -- re-enable default Animate if it was disabled
    local char = player.Character
    if char then
        local animate = char:FindFirstChild("Animate")
        if animate then pcall(function() animate.Disabled = false end) end
    end
end

local function playEmoteById(id)
    stopEmote()
    local hum, animator = getAnimator()
    if not hum or not animator then return end
    if hum.RigType == Enum.HumanoidRigType.R6 then
        statusLabel.Text = "Rig: R6 tidak didukung untuk emote"
        return
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(id)
    local ok, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    if not ok or not track then
        -- fallback for older rigs/executors
        ok, track = pcall(function()
            return hum:LoadAnimation(anim)
        end)
    end
    if ok and track then
        currentTrack = track
        track.Priority = blendOn and Enum.AnimationPriority.Movement or Enum.AnimationPriority.Action4
        track.Looped = loopOn
        pcall(function()
            local fade = 0.25
            track:Play(fade, 1, 1)
            if track.AdjustSpeed then track:AdjustSpeed(1) end
            if track.AdjustWeight then
                local weight = blendOn and 0.6 or 1
                track:AdjustWeight(weight, fade)
            end
        end)
        statusLabel.Text = "Rig: R15 (emote aktif)"
    else
        local msg = "[Emote] Gagal memuat anim: " .. tostring(id)
        statusLabel.Text = msg
        warn(msg)
    end
end

btnPlay.MouseButton1Click:Connect(function()
    local id = tonumber(input.Text)
    if not id then
        -- try to parse if user pasted full rbxasset url/id
        local numeric = string.match(input.Text or "", "(%d+)")
        id = tonumber(numeric)
    end
    if not id then return end
    playEmoteById(id)
end)

btnStop.MouseButton1Click:Connect(stopEmote)

-- auto-stop when character respawns or dies
player.CharacterAdded:Connect(function()
    stopEmote()
end)

do
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Died:Connect(function()
            stopEmote()
        end)
    end
end

-- Emote list (scrollable) similar to AnimationData
local EmoteList = {
    {name = "Gojo Floating", id = 103040723950430},
    {name = "Nod", id = 507770453},
    {name = "Wave", id = 507777826},
    {name = "Cheer", id = 507770677},
    {name = "Point", id = 507770239},
}

local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, -20, 0, 22)
listLabel.Position = UDim2.new(0, 10, 0, 106)
listLabel.BackgroundTransparency = 1
listLabel.Font = Enum.Font.GothamBold
listLabel.TextSize = 13
listLabel.TextColor3 = Color3.fromRGB(255,255,255)
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Text = "Pilih Emote:"
listLabel.Parent = contentHolder

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -150)
Scroll.Position = UDim2.new(0, 10, 0, 136)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = contentHolder

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = Scroll
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

local activeButton: TextButton? = nil
local function setActive(btn: TextButton?, state: boolean)
    if not btn then return end
    TweenService:Create(btn, TweenInfo.new(0.15), {
        BackgroundColor3 = state and Color3.fromRGB(0, 200, 120) or Color3.fromRGB(0, 120, 90)
    }):Play()
end

local function createItem(name, id)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 90)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        -- highlight
        if activeButton and activeButton ~= btn then setActive(activeButton, false) end
        activeButton = btn
        setActive(btn, true)
        -- put id to textbox and play
        input.Text = tostring(id)
        playEmoteById(id)
    end)
end

for _, item in ipairs(EmoteList) do
    createItem(item.name, item.id)
end

-- Close with RightShift
local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(io, gpe)
    if gpe then return end
    if io.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- Minimize & Close handlers
local minimized = false
btnMin.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentHolder.Visible = not minimized
    local target = minimized and UDim2.new(0, 320, 0, 40) or UDim2.new(0, 320, 0, 360)
    TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = target}):Play()
end)

btnClose.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
