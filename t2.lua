local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Cam = Workspace.CurrentCamera

-- State
local Active = true
local TargetList = {}
local CurrentIndex = 0
local CurrentTarget = nil

local FlingActive = false
local FlingThread = nil
local OriginalCFrame = nil

local FollowActive = false
local FollowConnection = nil
local FollowAnim = nil

local SendPartActive = false
local SendPartLoopThread = nil

-- FREEZE State
local FreezeConnection = nil
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50

-- Network stabilizer placeholder (best-effort)
local NetworkConnection = nil

-- 3D HD Colors - Blue & Black Theme
local COLORS = {
    DARK_BLUE = Color3.fromRGB(0, 50, 20),
    MEDIUM_BLUE = Color3.fromRGB(0, 130, 80),
    LIGHT_BLUE = Color3.fromRGB(0, 160, 110),
    NEON_BLUE = Color3.fromRGB(0, 220, 130),
    DARK_BLACK = Color3.fromRGB(5, 5, 10),
    MEDIUM_BLACK = Color3.fromRGB(15, 15, 20),
    LIGHT_BLACK = Color3.fromRGB(25, 25, 35),
    WHITE = Color3.fromRGB(255, 255, 255),
    GREEN = Color3.fromRGB(0, 255, 128),
    RED = Color3.fromRGB(255, 60, 60),
    GOLD = Color3.fromRGB(255, 215, 0)
}

-- Character refs
local humanoid, rootPart
local function refreshCharacterRefs()
    local char = LP.Character
    if char then
        humanoid = char:FindFirstChildOfClass("Humanoid")
        rootPart = char:FindFirstChild("HumanoidRootPart")
        
        -- Save original movement properties
        if humanoid then
            OriginalWalkSpeed = humanoid.WalkSpeed
            OriginalJumpPower = humanoid.JumpPower
        end
    else
        humanoid = nil
        rootPart = nil
    end
end
refreshCharacterRefs()

LP.CharacterAdded:Connect(function(char)
    pcall(function()
        char:WaitForChild("Humanoid", 5)
        char:WaitForChild("HumanoidRootPart", 5)
    end)
    refreshCharacterRefs()

    if FollowActive then
        if FollowConnection then
            FollowConnection:Disconnect()
            FollowConnection = nil
        end
        if FollowAnim then
            pcall(function() FollowAnim:Stop() end)
            FollowAnim = nil
        end
        FollowActive = false
    end
end)

-- ========== FREEZE CHARACTER SYSTEM ==========
local function freezeCharacter()
    if FreezeConnection then
        FreezeConnection:Disconnect()
    end
    
    FreezeConnection = RunService.Heartbeat:Connect(function()
        if humanoid and rootPart then
            -- Freeze movement
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            
            -- Freeze position (optional, for extra security)
            pcall(function()
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
    
    -- Also disable humanoid controls
    if humanoid then
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
    end
end

local function unfreezeCharacter()
    if FreezeConnection then
        FreezeConnection:Disconnect()
        FreezeConnection = nil
    end
    
    -- Restore movement
    if humanoid then
        humanoid.WalkSpeed = OriginalWalkSpeed
        humanoid.JumpPower = OriginalJumpPower
    end
end

-- ---------- 3D HD GUI - CLEAN LAYOUT ----------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JSY_Spectate_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Controls Frame (RIGHT - DIBAWAH)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, 140, 0, 180)
ControlsFrame.Position = UDim2.new(1, -150, 0, 100)
ControlsFrame.BackgroundColor3 = COLORS.DARK_BLACK
ControlsFrame.BackgroundTransparency = 0.1
ControlsFrame.BorderSizePixel = 0
ControlsFrame.Parent = ScreenGui

local ControlsCorner = Instance.new("UICorner", ControlsFrame)
ControlsCorner.CornerRadius = UDim.new(0, 12)

local ControlsStroke = Instance.new("UIStroke", ControlsFrame)
ControlsStroke.Color = COLORS.NEON_BLUE
ControlsStroke.Thickness = 2

-- Header untuk Controls
local ControlsHeader = Instance.new("TextLabel")
ControlsHeader.Size = UDim2.new(1, 0, 0, 20)
ControlsHeader.Position = UDim2.new(0, 0, 0, 0)
ControlsHeader.BackgroundColor3 = COLORS.DARK_BLUE
ControlsHeader.BorderSizePixel = 0
ControlsHeader.Text = "CONTROLS"
ControlsHeader.TextColor3 = COLORS.NEON_BLUE
ControlsHeader.Font = Enum.Font.GothamBold
ControlsHeader.TextSize = 11
ControlsHeader.Parent = ControlsFrame

local HeaderCorner = Instance.new("UICorner", ControlsHeader)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Profile frame (DI ATAS CONTROL FRAME)
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0, 140, 0, 60)
ProfileFrame.Position = UDim2.new(1, -150, 0, 30)
ProfileFrame.BackgroundColor3 = COLORS.DARK_BLACK
ProfileFrame.BackgroundTransparency = 0.1
ProfileFrame.BorderSizePixel = 0
ProfileFrame.Parent = ScreenGui

local ProfileCorner = Instance.new("UICorner", ProfileFrame)
ProfileCorner.CornerRadius = UDim.new(0, 12)

local ProfileStroke = Instance.new("UIStroke", ProfileFrame)
ProfileStroke.Color = COLORS.NEON_BLUE
ProfileStroke.Thickness = 2

local Avatar = Instance.new("ImageLabel")
Avatar.Parent = ProfileFrame
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 8, 0.5, -20)
Avatar.BackgroundColor3 = COLORS.MEDIUM_BLACK
Avatar.BorderSizePixel = 0

local AvatarCorner = Instance.new("UICorner", Avatar)
AvatarCorner.CornerRadius = UDim.new(0, 8)

local AvatarStroke = Instance.new("UIStroke", Avatar)
AvatarStroke.Color = COLORS.NEON_BLUE
AvatarStroke.Thickness = 2

local UserInfoFrame = Instance.new("Frame", ProfileFrame)
UserInfoFrame.Size = UDim2.new(1, -52, 1, -12)
UserInfoFrame.Position = UDim2.new(0, 48, 0, 6)
UserInfoFrame.BackgroundTransparency = 1

-- Username Label - Format Rapi
local UsernameLabel = Instance.new("TextLabel", UserInfoFrame)
UsernameLabel.Size = UDim2.new(1, 0, 0.4, 0)
UsernameLabel.Position = UDim2.new(0,0,0,0)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextColor3 = COLORS.NEON_BLUE
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.TextSize = 12
UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
UsernameLabel.Text = "Nama"

-- Age Label - Format Rapi
local AgeLabel = Instance.new("TextLabel", UserInfoFrame)
AgeLabel.Size = UDim2.new(1,0,0.3,0)
AgeLabel.Position = UDim2.new(0,0,0.4,0)
AgeLabel.BackgroundTransparency = 1
AgeLabel.Font = Enum.Font.Gotham
AgeLabel.TextColor3 = COLORS.LIGHT_BLUE
AgeLabel.TextXAlignment = Enum.TextXAlignment.Left
AgeLabel.TextSize = 10
AgeLabel.Text = "Umur akun"

-- ID Label - Format Rapi
local IdLabel = Instance.new("TextLabel", UserInfoFrame)
IdLabel.Size = UDim2.new(1,0,0.3,0)
IdLabel.Position = UDim2.new(0,0,0.7,0)
IdLabel.BackgroundTransparency = 1
IdLabel.Font = Enum.Font.Gotham
IdLabel.TextColor3 = COLORS.LIGHT_BLUE
IdLabel.TextXAlignment = Enum.TextXAlignment.Left
IdLabel.TextSize = 10
IdLabel.Text = "ID"

-- Status Indicator untuk Profile
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Size = UDim2.new(0, 5, 0, 5)
StatusIndicator.Position = UDim2.new(1, -10, 0, 8)
StatusIndicator.BackgroundColor3 = COLORS.RED
StatusIndicator.BorderSizePixel = 0
StatusIndicator.Parent = ProfileFrame

local StatusCorner = Instance.new("UICorner", StatusIndicator)
StatusCorner.CornerRadius = UDim.new(1, 0)

-- Improved 3D Button Function untuk Controls
local function createControlButton(parent, text, bgColor, positionY, icon)
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(0.9, 0, 0, 30)
    ButtonContainer.Position = UDim2.new(0.5, 0, positionY, 0)
    ButtonContainer.AnchorPoint = Vector2.new(0.5, 0)
    ButtonContainer.BackgroundColor3 = COLORS.MEDIUM_BLACK
    ButtonContainer.BorderSizePixel = 0
    ButtonContainer.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner", ButtonContainer)
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    
    local ButtonStroke = Instance.new("UIStroke", ButtonContainer)
    ButtonStroke.Color = COLORS.NEON_BLUE
    ButtonStroke.Thickness = 2
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -4, 1, -4)
    Button.Position = UDim2.new(0, 2, 0, 2)
    Button.BackgroundColor3 = bgColor
    Button.BorderSizePixel = 0
    Button.TextColor3 = COLORS.WHITE
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 10
    Button.Text = (icon or "") .. " " .. text
    Button.AutoButtonColor = false
    Button.Parent = ButtonContainer
    
    local ButtonInnerCorner = Instance.new("UICorner", Button)
    ButtonInnerCorner.CornerRadius = UDim.new(0, 6)
    
    -- Improved Hover effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.MEDIUM_BLUE}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {TextColor3 = COLORS.NEON_BLUE}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {TextColor3 = COLORS.WHITE}):Play()
    end)
    
    return Button
end

-- Create control buttons di frame kanan dengan spacing yang rapi
local TeleBtn = createControlButton(ControlsFrame, "TELEPORT", COLORS.DARK_BLUE, 0.15, "")
local KickBtn = createControlButton(ControlsFrame, "KICK", COLORS.DARK_BLUE, 0.35, "")
local FollowBtn = createControlButton(ControlsFrame, "FOLLOW", COLORS.DARK_BLUE, 0.55, "")
local SendPartBtn = createControlButton(ControlsFrame, "SEND PART", COLORS.DARK_BLUE, 0.75, "")

-- Bottom navigation (CENTER BOTTOM) - Prev - Close - Next
local BottomFrame = Instance.new("Frame")
BottomFrame.Size = UDim2.new(0, 320, 0, 50)
BottomFrame.Position = UDim2.new(0.5, -160, 1, -70)
BottomFrame.BackgroundColor3 = COLORS.DARK_BLACK
BottomFrame.BackgroundTransparency = 0.1
BottomFrame.BorderSizePixel = 0
BottomFrame.Parent = ScreenGui

local BottomCorner = Instance.new("UICorner", BottomFrame)
BottomCorner.CornerRadius = UDim.new(0, 12)

local BottomStroke = Instance.new("UIStroke", BottomFrame)
BottomStroke.Color = COLORS.NEON_BLUE
BottomStroke.Thickness = 2

local function createNavButton3D(parent, text, positionX, icon, isClose)
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(0, 90, 0, 35)
    ButtonContainer.Position = UDim2.new(positionX, 0, 0.5, 0)
    ButtonContainer.AnchorPoint = Vector2.new(0, 0.5)
    
    local buttonColor = isClose and COLORS.RED or COLORS.DARK_BLUE
    ButtonContainer.BackgroundColor3 = COLORS.MEDIUM_BLACK
    ButtonContainer.BorderSizePixel = 0
    ButtonContainer.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner", ButtonContainer)
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    
    local ButtonStroke = Instance.new("UIStroke", ButtonContainer)
    ButtonStroke.Color = COLORS.NEON_BLUE
    ButtonStroke.Thickness = 2
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 1, -4)
    button.Position = UDim2.new(0, 2, 0, 2)
    button.BackgroundColor3 = buttonColor
    button.BorderSizePixel = 0
    button.TextColor3 = COLORS.WHITE
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Text = (icon or "") .. " " .. text
    button.Parent = ButtonContainer
    
    local ButtonInnerCorner = Instance.new("UICorner", button)
    ButtonInnerCorner.CornerRadius = UDim.new(0, 6)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        local hoverColor = isClose and Color3.fromRGB(255, 100, 100) or COLORS.MEDIUM_BLUE
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = buttonColor}):Play()
    end)
    
    return button
end

-- Tombol navigasi: Prev - Close - Next
local PrevBtn = createNavButton3D(BottomFrame, "PREV", 0.05, "", false)
local CloseNavBtn = createNavButton3D(BottomFrame, "CLOSE", 0.35, "", true)
local NextBtn = createNavButton3D(BottomFrame, "NEXT", 0.65, "", false)

-- Function untuk membuka kembali profil frame
local function openProfileFrame()
    TweenService:Create(ProfileFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 140, 0, 60)
    }):Play()
    
    TweenService:Create(Avatar, TweenInfo.new(0.3), {
        BackgroundTransparency = 0,
        ImageTransparency = 0
    }):Play()
    
    TweenService:Create(UsernameLabel, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(AgeLabel, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(IdLabel, TweenInfo.new(0.3), {
        TextTransparency = 0
    }):Play()
    
    TweenService:Create(StatusIndicator, TweenInfo.new(0.3), {
        BackgroundTransparency = 0
    }):Play()
end

-- Function to update profile dengan efek visual
local function updateProfile(plr)
    if ProfileFrame.BackgroundTransparency == 1 then
        openProfileFrame()
    end
    
    if plr and plr:IsA("Player") then
        UsernameLabel.Text = plr.Name
        AgeLabel.Text = "Umur: " .. tostring(plr.AccountAge or 0) .. " hari"
        IdLabel.Text = "ID: " .. tostring(plr.UserId)
        
        StatusIndicator.BackgroundColor3 = COLORS.GREEN
        
        -- Animation effect
        TweenService:Create(UsernameLabel, TweenInfo.new(0.3), {TextColor3 = COLORS.GREEN}):Play()
        task.wait(0.3)
        TweenService:Create(UsernameLabel, TweenInfo.new(0.3), {TextColor3 = COLORS.NEON_BLUE}):Play()
        
        pcall(function()
            Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=150&height=150&format=png"
        end)
    else
        UsernameLabel.Text = "Nama"
        AgeLabel.Text = "Umur akun"
        IdLabel.Text = "ID"
        Avatar.Image = ""
        UsernameLabel.TextColor3 = COLORS.NEON_BLUE
        StatusIndicator.BackgroundColor3 = COLORS.RED
    end
end

-- ========== COMPLETE SEND PART FUNCTION ==========
local function OneTimeUnanchor()
    if _G.__JSY_UnanchorCooldown then return end
    _G.__JSY_UnanchorCooldown = true
    task.spawn(function()
        local start = tick()
        while tick() - start < 1 do
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("RopeConstraint") then
                    local p0 = obj.Attachment0 and obj.Attachment0.Parent
                    local p1 = obj.Attachment1 and obj.Attachment1.Parent
                    pcall(function() obj:Destroy() end)
                    if p0 and p0:IsA("BasePart") then p0.Anchored = false end
                    if p1 and p1:IsA("BasePart") then p1.Anchored = false end
                end
            end

            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and not part.Anchored then
                    part.AssemblyLinearVelocity = Vector3.new(math.random(-50,50), math.random(20,100), math.random(-50,50))
                end
            end

            task.wait(0.2)
        end
        _G.__JSY_UnanchorCooldown = false
    end)
end

local function GetAllPartsRecursive(parent)
    local parts = {}
    for _, obj in ipairs(parent:GetChildren()) do
        if obj:IsA("BasePart") then
            table.insert(parts, obj)
        elseif obj:IsA("Model") or obj:IsA("Folder") then
            for _, p in ipairs(GetAllPartsRecursive(obj)) do
                table.insert(parts, p)
            end
        end
    end
    return parts
end

local function EnableNetworkStabilizer()
    if NetworkConnection then return end
    pcall(function()
        NetworkConnection = RunService.Heartbeat:Connect(function()
            pcall(function()
                if sethiddenproperty then
                    sethiddenproperty(LP, "SimulationRadius", math.huge)
                end
            end)
        end)
    end)
end

local function DisableNetworkStabilizer()
    if NetworkConnection then
        NetworkConnection:Disconnect()
        NetworkConnection = nil
    end
end

local function sendUnanchoredPartsToTarget(target)
    if not target or not target.Character then return end
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    EnableNetworkStabilizer()
    OneTimeUnanchor()

    local folder = Workspace:FindFirstChild("JSY_SendPartFolder") or Instance.new("Folder", Workspace)
    folder.Name = "JSY_SendPartFolder"

    local targetPart = folder:FindFirstChild("TargetPart") or Instance.new("Part", folder)
    targetPart.Name = "TargetPart"
    targetPart.Anchored = true
    targetPart.CanCollide = false
    targetPart.Transparency = 1
    targetPart.Size = Vector3.new(1,1,1)
    targetPart.CFrame = targetHRP.CFrame
    local attach1 = targetPart:FindFirstChild("Attachment") or Instance.new("Attachment", targetPart)

    local function ForcePart(v)
        if not v:IsA("BasePart") then return end
        if v.Anchored then return end
        if v.Parent and v.Parent:FindFirstChildOfClass("Humanoid") then return end
        if v.Name == "Handle" then return end

        local originalCFrame = v.CFrame
        local originalAnchored = v.Anchored
        local originalCanCollide = v.CanCollide

        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("AlignPosition") or x:IsA("Torque") or x:IsA("RocketPropulsion") or x:IsA("AlignOrientation") then
                pcall(function() x:Destroy() end)
            end
        end

        v.CanCollide = false

        local torque = Instance.new("Torque")
        torque.Parent = v
        torque.Torque = Vector3.new(100000,100000,100000)

        local align = Instance.new("AlignPosition")
        align.Parent = v
        align.MaxForce = math.huge
        align.MaxVelocity = math.huge
        align.Responsiveness = 200

        local attach2 = Instance.new("Attachment", v)
        torque.Attachment0 = attach2
        align.Attachment0 = attach2
        align.Attachment1 = attach1

        task.spawn(function()
            local started = tick()
            while tick() - started < 2 do
                if not v or not v.Parent then break end
                task.wait(0.05)
            end

            pcall(function()
                if v and v:IsA("BasePart") then
                    v.AssemblyLinearVelocity = Vector3.zero
                    v.AssemblyAngularVelocity = Vector3.zero
                end

                if align and align.Parent then align:Destroy() end
                if torque and torque.Parent then torque:Destroy() end
                
                for _, child in ipairs(v:GetChildren()) do
                    if child:IsA("Attachment") then
                        if child ~= attach1 then
                            pcall(function() child:Destroy() end)
                        end
                    end
                end

                if v and v.Parent then
                    pcall(function()
                        v.CanCollide = originalCanCollide
                        v.Anchored = originalAnchored
                        task.wait(0.05)
                        v.CFrame = originalCFrame
                    end)
                end
            end)
        end)
    end

    local parts = GetAllPartsRecursive(Workspace)
    for _, p in ipairs(parts) do
        pcall(function()
            if not p.Anchored then
                ForcePart(p)
            end
        end)
    end

    task.spawn(function()
        local duration = 5
        local start = tick()
        while tick() - start < duration do
            if attach1 and targetHRP then
                pcall(function()
                    attach1.WorldCFrame = targetHRP.CFrame
                    targetPart.CFrame = targetHRP.CFrame
                end)
            end
            task.wait()
        end
        pcall(function() folder:Destroy() end)
        DisableNetworkStabilizer()
    end)
end

-- ========== AUTO-OFF SEND PART FUNCTION ==========
local function turnOffSendPart()
    if SendPartActive then
        SendPartActive = false
        SendPartBtn.Text = "ðŸ“¦ SEND PART"
        TweenService:Create(SendPartBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
        unfreezeCharacter()
    end
end

-- ========== TARGETING SYSTEM ==========
local function getTargetablePlayers()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(list, p)
        end
    end
    return list
end

local function refreshTargetList()
    local oldTarget = CurrentTarget
    TargetList = getTargetablePlayers()
    
    if #TargetList == 0 then
        CurrentIndex = 0
        CurrentTarget = nil
        updateProfile(nil)
        return
    end
    
    if oldTarget and table.find(TargetList, oldTarget) then
        CurrentIndex = table.find(TargetList, oldTarget)
        CurrentTarget = oldTarget
        updateProfile(CurrentTarget)
        return
    end
    
    if oldTarget then
        for i, player in ipairs(TargetList) do
            if player.UserId == oldTarget.UserId then
                CurrentIndex = i
                CurrentTarget = player
                updateProfile(CurrentTarget)
                return
            end
        end
    end
    
    if CurrentIndex < 1 or CurrentIndex > #TargetList then
        CurrentIndex = 1
    end
    
    CurrentTarget = TargetList[CurrentIndex]
    updateProfile(CurrentTarget)
end

local refreshDebounce = false
local function safeRefreshTargetList()
    if refreshDebounce then return end
    refreshDebounce = true
    
    refreshTargetList()
    
    task.wait(0.5)
    refreshDebounce = false
end

refreshTargetList()

-- Event listeners dengan debounce
Players.PlayerAdded:Connect(function(plr) 
    task.wait(0.1)
    safeRefreshTargetList()
end)

Players.PlayerRemoving:Connect(function(plr)
    task.wait(0.1)
    safeRefreshTargetList()
    
    if CurrentTarget and plr == CurrentTarget then
        CurrentTarget = nil
        updateProfile(nil)
        
        if FollowActive then
            stopFollow()
        end
        
        if FlingActive then
            FlingActive = false
            KickBtn.Text = "KICK"
            TweenService:Create(KickBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
        end
        
        if SendPartActive then
            turnOffSendPart()
        end
    end
end)

-- Navigation buttons
PrevBtn.MouseButton1Click:Connect(function()
    if #TargetList == 0 then safeRefreshTargetList() end
    if #TargetList == 0 then return end
    
    local nextIndex = CurrentIndex - 1
    if nextIndex < 1 then nextIndex = #TargetList end
    
    if nextIndex >= 1 and nextIndex <= #TargetList then
        CurrentIndex = nextIndex
        CurrentTarget = TargetList[CurrentIndex]
        updateProfile(CurrentTarget)
        turnOffSendPart()
        openProfileFrame()
    end
end)

NextBtn.MouseButton1Click:Connect(function()
    if #TargetList == 0 then safeRefreshTargetList() end
    if #TargetList == 0 then return end
    
    local nextIndex = CurrentIndex + 1
    if nextIndex > #TargetList then nextIndex = 1 end
    
    if nextIndex >= 1 and nextIndex <= #TargetList then
        CurrentIndex = nextIndex
        CurrentTarget = TargetList[CurrentIndex]
        updateProfile(CurrentTarget)
        turnOffSendPart()
        openProfileFrame()
    end
end)

-- ========== CAMERA SYSTEM ==========
RunService.RenderStepped:Connect(function()
    if not Active then return end
    if CurrentTarget and CurrentTarget.Character then
        local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            Cam.CameraSubject = hrp
        end
    end
end)

-- ========== TELEPORT FUNCTION ==========
TeleBtn.MouseButton1Click:Connect(function()
    if not CurrentTarget then return end
    local lpHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
    if lpHRP and targetHRP then
        lpHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
        TweenService:Create(TeleBtn, TweenInfo.new(0.5), {BackgroundColor3 = COLORS.GREEN}):Play()
        task.wait(0.5)
        TweenService:Create(TeleBtn, TweenInfo.new(0.5), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
    end
end)

-- ========== KICK/FLING FUNCTION ==========
local function flingLoop()
    while FlingActive do
        RunService.Heartbeat:Wait()
        local lpHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local targetHRP = CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        if lpHRP and targetHRP then
            local dir = (targetHRP.Position - lpHRP.Position)
            if dir.Magnitude > 0 then
                lpHRP.AssemblyLinearVelocity = dir.Unit * 500
            end
            lpHRP.CFrame = targetHRP.CFrame
        end
    end
end

KickBtn.MouseButton1Click:Connect(function()
    if not CurrentTarget then return end
    local lpHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not lpHRP then return end

    FlingActive = not FlingActive

    if FlingActive then
        OriginalCFrame = lpHRP.CFrame
        KickBtn.Text = "KICKING"
        TweenService:Create(KickBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.RED}):Play()
        if not FlingThread then
            FlingThread = task.spawn(flingLoop)
        end
    else
        FlingActive = false
        KickBtn.Text = "KICK"
        TweenService:Create(KickBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
        FlingThread = nil
        task.defer(function()
            pcall(function()
                if lpHRP and OriginalCFrame then
                    lpHRP.AssemblyLinearVelocity = Vector3.zero
                    lpHRP.AssemblyAngularVelocity = Vector3.zero
                    task.wait(0.1)
                    lpHRP.CFrame = OriginalCFrame
                end
            end)
        end)
    end
end)

-- ========== FOLLOW FUNCTION ==========
local function stopFollow()
    FollowActive = false
    if FollowConnection then FollowConnection:Disconnect() FollowConnection = nil end
    if FollowAnim then pcall(function() FollowAnim:Stop() end) FollowAnim = nil end
    FollowBtn.Text = "FOLLOW"
    TweenService:Create(FollowBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
end

local function startFollowToTarget(target)
    if not target or not rootPart or not humanoid then return end
    FollowActive = true
    FollowBtn.Text = "FOLLOWING"
    TweenService:Create(FollowBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.GREEN}):Play()

    pcall(function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://100681208320300"
        FollowAnim = humanoid:LoadAnimation(anim)
        FollowAnim.Looped = true
        FollowAnim:Play()
    end)

    FollowConnection = RunService.Heartbeat:Connect(function()
        if not FollowActive then return end
        if not target.Character then stopFollow() return end
        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP then stopFollow() return end
        rootPart.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
    end)
end

FollowBtn.MouseButton1Click:Connect(function()
    if FollowActive then
        stopFollow()
        return
    end
    if not CurrentTarget then return end
    refreshCharacterRefs()
    startFollowToTarget(CurrentTarget)
end)

-- ========== SEND PART BUTTON (PERSISTENT TOGGLE) ==========
SendPartBtn.MouseButton1Click:Connect(function()
    SendPartActive = not SendPartActive

    if SendPartActive then
        SendPartBtn.Text = "SENDING (ON)"
        TweenService:Create(SendPartBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.GREEN}):Play()
        freezeCharacter()

        if not SendPartLoopThread then
            SendPartLoopThread = task.spawn(function()
                while SendPartActive do
                    if CurrentTarget and CurrentTarget.Character then
                        pcall(function()
                            sendUnanchoredPartsToTarget(CurrentTarget)
                        end)
                    end
                    task.wait(2.2)
                end
                SendPartLoopThread = nil
            end)
        end
    else
        SendPartBtn.Text = "SEND PART"
        TweenService:Create(SendPartBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
        unfreezeCharacter()
    end
end)

-- ========== MAIN CLOSE FUNCTION ==========
CloseNavBtn.MouseButton1Click:Connect(function()
    TweenService:Create(ProfileFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(ControlsFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BottomFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.4)
    
    Active = false
    FlingActive = false
    SendPartActive = false
    
    unfreezeCharacter()
    
    if FollowConnection then FollowConnection:Disconnect() FollowConnection = nil end
    if FollowAnim then pcall(function() FollowAnim:Stop() end) FollowAnim = nil end
    
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        Cam.CameraSubject = LP.Character:FindFirstChild("Humanoid")
    end
    
    pcall(function() ScreenGui:Destroy() end)
end)

-- Initial setup
task.defer(function()
    refreshTargetList()
    if #TargetList > 0 then
        CurrentIndex = 1
        CurrentTarget = TargetList[1]
        updateProfile(CurrentTarget)
    end
end)