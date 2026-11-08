-- =========================================
-- ROBLOX TRIO FPS BOOSTER (ULTIMATE VERSION)
-- + Minimize/Close UI & CPU Optimized Auto-Detect
-- =========================================

local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain

-- Hapus GUI lama jika ada
if CoreGui:FindFirstChild("TrioFPSBoosterUI") then
    CoreGui.TrioFPSBoosterUI:Destroy()
end

-- =========================================
-- 1. MEMBUAT TAMPILAN GUI
-- =========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrioFPSBoosterUI"
ScreenGui.Parent = CoreGui

-- Frame Utama (Background)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 230)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser lewat seluruh body frame
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true -- Biar rapi pas di-minimize

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar (Bagian Atas)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

-- Tambalan kotak di bawah sudut TopBar biar nyatu sama MainFrame
local TopBarPatch = Instance.new("Frame")
TopBarPatch.Size = UDim2.new(1, 0, 0, 10)
TopBarPatch.Position = UDim2.new(0, 0, 1, -10)
TopBarPatch.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBarPatch.BorderSizePixel = 0
TopBarPatch.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ TRIO BOOSTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tombol Minimize (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Frame Konten (Wadah Tombol Booster)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function CreateBoostButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 210, 0, 45)
    btn.Position = UDim2.new(0.5, -105, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local LiteBtn = CreateBoostButton("LITE MODE", 15)
local SafeBtn = CreateBoostButton("SAFE MODE", 70)
local ExtremeBtn = CreateBoostButton("EXTREME MODE", 125)

-- =========================================
-- 2. LOGIKA UI (MINIMIZE & CLOSE)
-- =========================================
local isMinimized = false

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 40), "Out", "Quint", 0.3, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 230), "Out", "Quint", 0.3, true)
    end
end)

-- =========================================
-- 3. LOGIKA BOOSTER, CACHE, & OPTIMASI CPU
-- =========================================
local currentMode = "NORMAL" 
local autoDetectConnection = nil
local cache = {
    Global = {
        WaterWaveSize = Terrain.WaterWaveSize,
        WaterWaveSpeed = Terrain.WaterWaveSpeed,
        WaterReflectance = Terrain.WaterReflectance,
        WaterTransparency = Terrain.WaterTransparency,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        Brightness = Lighting.Brightness,
        Decoration = Terrain.Decoration
    },
    Objects = {} 
}

local function OptimizeObject(v, modeType)
    if modeType == "SAFE" or modeType == "EXTREME" then
        if v:IsA("BasePart") then
            if not cache.Objects[v] then cache.Objects[v] = {Material = v.Material, Reflectance = v.Reflectance} end
            pcall(function() v.Material = Enum.Material.SmoothPlastic; v.Reflectance = 0 end)
        elseif v:IsA("Decal") or v:IsA("Texture") then
            if not cache.Objects[v] then cache.Objects[v] = {Transparency = v.Transparency} end
            pcall(function() v.Transparency = 1 end)
        end
    end

    if modeType == "EXTREME" then
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            if not cache.Objects[v] then cache.Objects[v] = {Lifetime = v.Lifetime} end
            pcall(function() v.Lifetime = NumberRange.new(0) end)
        elseif v:IsA("Explosion") then
            if not cache.Objects[v] then cache.Objects[v] = {BlastPressure = v.BlastPressure, BlastRadius = v.BlastRadius} end
            pcall(function() v.BlastPressure = 1; v.BlastRadius = 1 end)
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            if not cache.Objects[v] then cache.Objects[v] = {Enabled = v.Enabled} end
            pcall(function() v.Enabled = false end)
        end
    end
end

local function RestoreNormal()
    if autoDetectConnection then
        autoDetectConnection:Disconnect()
        autoDetectConnection = nil
    end

    Terrain.WaterWaveSize = cache.Global.WaterWaveSize
    Terrain.WaterWaveSpeed = cache.Global.WaterWaveSpeed
    Terrain.WaterReflectance = cache.Global.WaterReflectance
    Terrain.WaterTransparency = cache.Global.WaterTransparency
    Lighting.GlobalShadows = cache.Global.GlobalShadows
    Lighting.FogEnd = cache.Global.FogEnd
    Lighting.Brightness = cache.Global.Brightness
    pcall(function() Terrain.Decoration = cache.Global.Decoration end)

    for obj, props in pairs(cache.Objects) do
        if obj and obj.Parent then
            for propName, propValue in pairs(props) do
                pcall(function() obj[propName] = propValue end) 
            end
        end
    end
end

-- Tombol Close: Kembalikan ke normal, lalu hancurkan UI
CloseBtn.MouseButton1Click:Connect(function()
    RestoreNormal()
    ScreenGui:Destroy()
end)

local function ApplyBoost(modeType)
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    pcall(function() Terrain.Decoration = false end)

    for _, v in pairs(game:GetDescendants()) do
        OptimizeObject(v, modeType)
    end

    if autoDetectConnection then autoDetectConnection:Disconnect() end
    autoDetectConnection = game.DescendantAdded:Connect(function(v)
        -- CPU OPTIMIZATION: Hanya eksekusi jika objeknya adalah grafis visual
        if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Explosion") or v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            task.defer(function() -- Menggunakan task.defer agar CPU tidak terbebani secara instan
                OptimizeObject(v, modeType)
            end)
        end
    end)
end

-- =========================================
-- 4. INTERAKSI TOMBOL BOOSTER
-- =========================================
local function UpdateUI()
    local btns = {LITE = LiteBtn, SAFE = SafeBtn, EXTREME = ExtremeBtn}
    for modeName, btn in pairs(btns) do
        if currentMode == modeName then
            btn.Text = modeName .. " MODE: ON"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            btn.Text = modeName .. " MODE: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end
end

local function HandleClick(clickedMode)
    if currentMode == clickedMode then
        RestoreNormal()
        currentMode = "NORMAL"
    else
        RestoreNormal()
        ApplyBoost(clickedMode)
        currentMode = clickedMode
    end
    UpdateUI()
end

LiteBtn.MouseButton1Click:Connect(function() HandleClick("LITE") end)
SafeBtn.MouseButton1Click:Connect(function() HandleClick("SAFE") end)
ExtremeBtn.MouseButton1Click:Connect(function() HandleClick("EXTREME") end)-- =========================================
-- ROBLOX TRIO FPS BOOSTER (ULTIMATE VERSION)
-- + Minimize/Close UI & CPU Optimized Auto-Detect
-- =========================================

local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain

-- Hapus GUI lama jika ada
if CoreGui:FindFirstChild("TrioFPSBoosterUI") then
    CoreGui.TrioFPSBoosterUI:Destroy()
end

-- =========================================
-- 1. MEMBUAT TAMPILAN GUI
-- =========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TrioFPSBoosterUI"
ScreenGui.Parent = CoreGui

-- Frame Utama (Background)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 230)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser lewat seluruh body frame
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true -- Biar rapi pas di-minimize

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar (Bagian Atas)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

-- Tambalan kotak di bawah sudut TopBar biar nyatu sama MainFrame
local TopBarPatch = Instance.new("Frame")
TopBarPatch.Size = UDim2.new(1, 0, 0, 10)
TopBarPatch.Position = UDim2.new(0, 0, 1, -10)
TopBarPatch.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBarPatch.BorderSizePixel = 0
TopBarPatch.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ TRIO BOOSTER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Tombol Minimize (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Frame Konten (Wadah Tombol Booster)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function CreateBoostButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 210, 0, 45)
    btn.Position = UDim2.new(0.5, -105, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = ContentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local LiteBtn = CreateBoostButton("LITE MODE", 15)
local SafeBtn = CreateBoostButton("SAFE MODE", 70)
local ExtremeBtn = CreateBoostButton("EXTREME MODE", 125)

-- =========================================
-- 2. LOGIKA UI (MINIMIZE & CLOSE)
-- =========================================
local isMinimized = false

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 40), "Out", "Quint", 0.3, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 250, 0, 230), "Out", "Quint", 0.3, true)
    end
end)

-- =========================================
-- 3. LOGIKA BOOSTER, CACHE, & OPTIMASI CPU
-- =========================================
local currentMode = "NORMAL" 
local autoDetectConnection = nil
local cache = {
    Global = {
        WaterWaveSize = Terrain.WaterWaveSize,
        WaterWaveSpeed = Terrain.WaterWaveSpeed,
        WaterReflectance = Terrain.WaterReflectance,
        WaterTransparency = Terrain.WaterTransparency,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        Brightness = Lighting.Brightness,
        Decoration = Terrain.Decoration
    },
    Objects = {} 
}

local function OptimizeObject(v, modeType)
    if modeType == "SAFE" or modeType == "EXTREME" then
        if v:IsA("BasePart") then
            if not cache.Objects[v] then cache.Objects[v] = {Material = v.Material, Reflectance = v.Reflectance} end
            pcall(function() v.Material = Enum.Material.SmoothPlastic; v.Reflectance = 0 end)
        elseif v:IsA("Decal") or v:IsA("Texture") then
            if not cache.Objects[v] then cache.Objects[v] = {Transparency = v.Transparency} end
            pcall(function() v.Transparency = 1 end)
        end
    end

    if modeType == "EXTREME" then
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            if not cache.Objects[v] then cache.Objects[v] = {Lifetime = v.Lifetime} end
            pcall(function() v.Lifetime = NumberRange.new(0) end)
        elseif v:IsA("Explosion") then
            if not cache.Objects[v] then cache.Objects[v] = {BlastPressure = v.BlastPressure, BlastRadius = v.BlastRadius} end
            pcall(function() v.BlastPressure = 1; v.BlastRadius = 1 end)
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            if not cache.Objects[v] then cache.Objects[v] = {Enabled = v.Enabled} end
            pcall(function() v.Enabled = false end)
        end
    end
end

local function RestoreNormal()
    if autoDetectConnection then
        autoDetectConnection:Disconnect()
        autoDetectConnection = nil
    end

    Terrain.WaterWaveSize = cache.Global.WaterWaveSize
    Terrain.WaterWaveSpeed = cache.Global.WaterWaveSpeed
    Terrain.WaterReflectance = cache.Global.WaterReflectance
    Terrain.WaterTransparency = cache.Global.WaterTransparency
    Lighting.GlobalShadows = cache.Global.GlobalShadows
    Lighting.FogEnd = cache.Global.FogEnd
    Lighting.Brightness = cache.Global.Brightness
    pcall(function() Terrain.Decoration = cache.Global.Decoration end)

    for obj, props in pairs(cache.Objects) do
        if obj and obj.Parent then
            for propName, propValue in pairs(props) do
                pcall(function() obj[propName] = propValue end) 
            end
        end
    end
end

-- Tombol Close: Kembalikan ke normal, lalu hancurkan UI
CloseBtn.MouseButton1Click:Connect(function()
    RestoreNormal()
    ScreenGui:Destroy()
end)

local function ApplyBoost(modeType)
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 0
    pcall(function() Terrain.Decoration = false end)

    for _, v in pairs(game:GetDescendants()) do
        OptimizeObject(v, modeType)
    end

    if autoDetectConnection then autoDetectConnection:Disconnect() end
    autoDetectConnection = game.DescendantAdded:Connect(function(v)
        -- CPU OPTIMIZATION: Hanya eksekusi jika objeknya adalah grafis visual
        if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Explosion") or v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            task.defer(function() -- Menggunakan task.defer agar CPU tidak terbebani secara instan
                OptimizeObject(v, modeType)
            end)
        end
    end)
end

-- =========================================
-- 4. INTERAKSI TOMBOL BOOSTER
-- =========================================
local function UpdateUI()
    local btns = {LITE = LiteBtn, SAFE = SafeBtn, EXTREME = ExtremeBtn}
    for modeName, btn in pairs(btns) do
        if currentMode == modeName then
            btn.Text = modeName .. " MODE: ON"
            btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            btn.Text = modeName .. " MODE: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end
end

local function HandleClick(clickedMode)
    if currentMode == clickedMode then
        RestoreNormal()
        currentMode = "NORMAL"
    else
        RestoreNormal()
        ApplyBoost(clickedMode)
        currentMode = clickedMode
    end
    UpdateUI()
end

LiteBtn.MouseButton1Click:Connect(function() HandleClick("LITE") end)
SafeBtn.MouseButton1Click:Connect(function() HandleClick("SAFE") end)
ExtremeBtn.MouseButton1Click:Connect(function() HandleClick("EXTREME") end)