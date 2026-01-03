-- Emote Bypass (AssetId)
-- UI mini: textbox AssetId + Play/Stop; hijau theme

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

local input = Instance.new("TextBox")
input.Name = "AssetBox"
input.Size = UDim2.new(1, -20, 0, 32)
input.Position = UDim2.new(0, 10, 0, 38)
input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
input.BackgroundTransparency = 0.1
input.PlaceholderText = "Enter Animation AssetId (e.g. 507776043)"
input.Text = "103040723950430" -- Gojo Floating default
input.TextSize = 14
input.Font = Enum.Font.GothamMedium
input.TextColor3 = Color3.fromRGB(255,255,255)
input.ClearTextOnFocus = false
input.Parent = frame
Instance.new("UICorner", input).CornerRadius = UDim.new(0,8)
local s1 = Instance.new("UIStroke", input)
s1.Color = Color3.fromRGB(0,130,80)
s1.Thickness = 1.5

local btnPlay = Instance.new("TextButton")
btnPlay.Size = UDim2.new(0.48, -10, 0, 32)
btnPlay.Position = UDim2.new(0, 10, 0, 80)
btnPlay.BackgroundColor3 = Color3.fromRGB(0, 120, 90)
btnPlay.Text = "Play"
btnPlay.Font = Enum.Font.GothamBold
btnPlay.TextSize = 14
btnPlay.TextColor3 = Color3.fromRGB(255,255,255)
btnPlay.Parent = frame
Instance.new("UICorner", btnPlay).CornerRadius = UDim.new(0,8)

local btnStop = Instance.new("TextButton")
btnStop.Size = UDim2.new(0.48, -10, 0, 32)
btnStop.Position = UDim2.new(1, -10, 0, 80)
btnStop.AnchorPoint = Vector2.new(1,0)
btnStop.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
btnStop.Text = "Stop"
btnStop.Font = Enum.Font.GothamBold
btnStop.TextSize = 14
btnStop.TextColor3 = Color3.fromRGB(255,255,255)
btnStop.Parent = frame
Instance.new("UICorner", btnStop).CornerRadius = UDim.new(0,8)

-- Logic
local currentTrack: AnimationTrack? = nil

local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:FindFirstChildOfClass("Humanoid")
end

local function stopEmote()
    if currentTrack then
        pcall(function()
            currentTrack:Stop(0.2)
            currentTrack:Destroy()
        end)
        currentTrack = nil
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

    stopEmote()
    local hum = getHumanoid()
    if not hum then return end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(id)
    local ok, track = pcall(function()
        return hum:LoadAnimation(anim)
    end)
    if ok and track then
        currentTrack = track
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = true
        track:Play(0.1)
    end
end)

btnStop.MouseButton1Click:Connect(stopEmote)

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
listLabel.Position = UDim2.new(0, 10, 0, 120)
listLabel.BackgroundTransparency = 1
listLabel.Font = Enum.Font.GothamBold
listLabel.TextSize = 13
listLabel.TextColor3 = Color3.fromRGB(255,255,255)
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Text = "Pilih Emote:"
listLabel.Parent = frame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -150)
Scroll.Position = UDim2.new(0, 10, 0, 150)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = frame

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
        btnPlay:Activate()
        btnPlay.MouseButton1Click:Fire()
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
