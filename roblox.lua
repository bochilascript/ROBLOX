local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Enabled = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "CHCheatGUI"

ScreenGui.IgnoreGuiInset = true
local LightingContainer = Instance.new("Frame")
LightingContainer.Size = UDim2.new(1, 0, 1, 0)
LightingContainer.BackgroundTransparency = 1
LightingContainer.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 560, 0, 320)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
-- Hotkey toggle (semicolon) untuk show/hide GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local glassEffect = Instance.new("Frame")
glassEffect.Size = UDim2.new(1, 0, 1, 0)
glassEffect.BackgroundColor3 = Color3.fromRGB(0, 80, 255)
glassEffect.BackgroundTransparency = 0.95
glassEffect.Parent = MainFrame

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 12)
glassCorner.Parent = glassEffect

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 220, 130)
mainStroke.Thickness = 2
mainStroke.Transparency = 0
mainStroke.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 1, -30)
Container.Position = UDim2.new(0, 0, 0, 30)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0, 170, 1, -2)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ProfileFrame.BackgroundTransparency = 0
ProfileFrame.Parent = Container

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 8)
profileCorner.Parent = ProfileFrame

local ProfileContent = Instance.new("Frame")
ProfileContent.Size = UDim2.new(1, -10, 1, -10)
ProfileContent.Position = UDim2.new(0, 5, 0, 5)
ProfileContent.BackgroundTransparency = 1
ProfileContent.Parent = ProfileFrame

local ProfilePicture = Instance.new("ImageLabel")
ProfilePicture.Size = UDim2.new(0, 80, 0, 80)
-- move a bit upward so it doesn't overlap the quick menu
ProfilePicture.Position = UDim2.new(0.5, -40, 0, 12)
ProfilePicture.BackgroundColor3 = Color3.fromRGB(0, 50, 150)
ProfilePicture.BorderSizePixel = 0
ProfilePicture.Parent = ProfileContent

local pictureCorner = Instance.new("UICorner")
pictureCorner.CornerRadius = UDim.new(0, 40)
pictureCorner.Parent = ProfilePicture

local pictureStroke = Instance.new("UIStroke")
pictureStroke.Color = Color3.fromRGB(0, 200, 120)
pictureStroke.Thickness = 2
pictureStroke.Parent = ProfilePicture

local userId = Player.UserId

local function loadThumbnailWithFallbacks()
    local success1, result1 = pcall(function()
        return game:GetService("Players"):GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    
    if success1 and result1 and result1 ~= "" then
        ProfilePicture.Image = result1
        return
    end
    
    local success2 = pcall(function()
        ProfilePicture.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=150&height=150&format=png"
    end)
    
    if success2 then
        return
    end
    
    ProfilePicture.Image = "rbxasset://textures/ui/avatar_placeholder.png"
end

-- Speed input box to set desired walk speed
local SpeedBox = Instance.new("TextBox")
SpeedBox.Name = "SpeedBox"
SpeedBox.LayoutOrder = 6
SpeedBox.Size = UDim2.new(0, 150, 0, 35)
SpeedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpeedBox.BackgroundTransparency = 0.1
SpeedBox.Text = tostring(desiredSpeed)
SpeedBox.PlaceholderText = "Speed"
SpeedBox.TextSize = 15
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.ClearTextOnFocus = false
SpeedBox.LayoutOrder = 6
SpeedBox.Parent = ScrollFrame

do
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = SpeedBox

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = Color3.fromRGB(0, 130, 80)
    boxStroke.Thickness = 1.5
    boxStroke.Parent = SpeedBox

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = SpeedBox
end

SpeedBox.FocusLost:Connect(function()
    local n = tonumber(SpeedBox.Text)
    if n and n > 0 and n < 1000 then
        desiredSpeed = n
        if speedOn then
            local char = Player.Character or Player.CharacterAdded:Wait()
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = desiredSpeed end
        end
    else
        SpeedBox.Text = tostring(desiredSpeed)
    end
end)

-- (blok Fixed Waypoints dipindah setelah createButton/setButtonActive)

ProfilePicture.Image = "rbxasset://textures/ui/avatar_placeholder.png"

task.spawn(loadThumbnailWithFallbacks)
task.delay(3, loadThumbnailWithFallbacks)

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 2, 1, 0)
Divider.Position = UDim2.new(0, 170, 0, 0)
Divider.BackgroundColor3 = Color3.fromRGB(0, 220, 130)
Divider.BackgroundTransparency = 0
Divider.BorderSizePixel = 0
Divider.Parent = Container

local dividerCorner = Instance.new("UICorner")
dividerCorner.CornerRadius = UDim.new(1, 0)
dividerCorner.Parent = Divider

local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Size = UDim2.new(1, -180, 1, 0)
ButtonsFrame.Position = UDim2.new(0, 180, 0, 10)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ClipsDescendants = true
ButtonsFrame.Parent = Container

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
ScrollFrame.ScrollBarImageTransparency = 0.5
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = ButtonsFrame

-- Dedicated Utility container (2 columns) to keep pairs aligned
local UtilityFrame = Instance.new("Frame")
UtilityFrame.Name = "UtilityFrame"
UtilityFrame.Size = UDim2.new(1, 0, 1, 0)
UtilityFrame.Visible = false
UtilityFrame.BackgroundTransparency = 1
UtilityFrame.Parent = ButtonsFrame

-- Scrolling container for Utility items
local UtilityScroll = Instance.new("ScrollingFrame")
UtilityScroll.Name = "UtilityScroll"
UtilityScroll.Size = UDim2.new(1, 0, 1, 0)
UtilityScroll.BackgroundTransparency = 1
UtilityScroll.ScrollBarThickness = 6
UtilityScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
UtilityScroll.ScrollBarImageTransparency = 0.5
UtilityScroll.ScrollingDirection = Enum.ScrollingDirection.Y
UtilityScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
UtilityScroll.Parent = UtilityFrame

local UtilityGrid = Instance.new("UIGridLayout")
UtilityGrid.CellSize = UDim2.new(0, 150, 0, 35)
UtilityGrid.CellPadding = UDim2.new(0, 8, 0, 8)
UtilityGrid.FillDirection = Enum.FillDirection.Horizontal
UtilityGrid.FillDirectionMaxCells = 2
UtilityGrid.SortOrder = Enum.SortOrder.LayoutOrder
UtilityGrid.StartCorner = Enum.StartCorner.TopLeft
UtilityGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
UtilityGrid.VerticalAlignment = Enum.VerticalAlignment.Top
UtilityGrid.Parent = UtilityScroll

UtilityGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    UtilityScroll.CanvasSize = UDim2.new(0, 0, 0, UtilityGrid.AbsoluteContentSize.Y + 10)
end)

-- Left quick panel under profile picture
do
    local QuickPanel = Instance.new("Frame")
    QuickPanel.Name = "QuickPanel"
    QuickPanel.Size = UDim2.new(1, -10, 0, 120)
    QuickPanel.Position = UDim2.new(0, 5, 0, 110)
    QuickPanel.BackgroundTransparency = 1
    QuickPanel.Parent = ProfileContent

    local function makeSmallBtn(text, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.Position = UDim2.new(0, 0, 0, (order-1)*34)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 0.1
        btn.Text = text
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Parent = QuickPanel

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn

        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(0, 130, 80)
        s.Thickness = 1.5
        s.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(s, TweenInfo.new(0.15), {Color = Color3.fromRGB(0, 200, 120)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(s, TweenInfo.new(0.15), {Color = Color3.fromRGB(0, 130, 80)}):Play()
        end)
        return btn
    end

    local function scrollToLabel(labelText)
        if not ScrollFrame or not ScrollFrame:FindFirstChildOfClass("UIGridLayout") then return end
        for _, child in ipairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") and string.find(string.lower(child.Text), string.lower(labelText), 1, true) then
                task.wait() -- ensure AbsolutePosition is ready
                local targetY = child.AbsolutePosition.Y - ScrollFrame.AbsolutePosition.Y + ScrollFrame.CanvasPosition.Y - 10
                ScrollFrame.CanvasPosition = Vector2.new(0, math.max(targetY, 0))
                break
            end
        end
    end

    -- filtering helpers
    local rusuhKeywords = {"bringpart","spectator","noclip","tendang","unanchor","fly","esp","esp team"}
    local utilityKeywords = {"free cam","freecam","click tp","clicktp","speed","set waypoint","waypoint"}
    local function matchesAny(text, keywords)
        local lower = string.lower(text)
        for _, k in ipairs(keywords) do
            if string.find(lower, k, 1, true) then return true end
        end
        return false
    end

    local function setCategory(cat)
        for _, child in ipairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if cat == "Menu" then
                    -- show only items that are NOT in Rusuh or Utility
                     child.Visible = (not matchesAny(child.Text, rusuhKeywords))
                    and (not matchesAny(child.Text, utilityKeywords))
                    and (child:GetAttribute("IsFixedWP") ~= true)
                elseif cat == "Rusuh" then
                    child.Visible = matchesAny(child.Text, rusuhKeywords)
                elseif cat == "Utility" then
                    child.Visible = false
                elseif cat == "Mancing" then
                    child.Visible = false
end
            elseif child:IsA("TextBox") then
                -- Hide all textboxes in Menu dan Rusuh; Utility: tampilkan tiga textbox pasangan
                if cat == "Utility" then
                    child.Visible = false
                elseif cat == "Mancing" then
                    child.Visible = false
                else
                    child.Visible = false
                end
            end
        end

        -- Alphabetically sort Menu buttons for clarity
        if cat == "Menu" then
            local btns = {}
            for _, ch in ipairs(ScrollFrame:GetChildren()) do
                if ch:IsA("TextButton") and ch.Visible and type(ch.Text) == "string" then
                    table.insert(btns, ch)
                end
            end
            table.sort(btns, function(a,b)
                local at = string.lower(a.Text or "")
                local bt = string.lower(b.Text or "")
                return at < bt
            end)
            for i, b in ipairs(btns) do
                b.LayoutOrder = i
            end
        end

        -- Build paired rows for Utility to guarantee alignment
        local function ensureRow(index)
            local name = "UtilityRow"..tostring(index)
            local row = ScrollFrame:FindFirstChild(name)
            if not row then
                row = Instance.new("Frame")
                row.Name = name
                row.Size = UDim2.new(1, -8, 0, 35)
                row.BackgroundTransparency = 1
                row.Parent = ScrollFrame
                local grid = Instance.new("UIGridLayout")
                grid.CellSize = UDim2.new(0.5, -6, 1, 0)
                grid.CellPadding = UDim2.new(0, 8, 0, 0)
                grid.FillDirection = Enum.FillDirection.Horizontal
                grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
                grid.SortOrder = Enum.SortOrder.LayoutOrder
                grid.Parent = row
            end
            return row
        end

        if cat == "Utility" then
            -- Show UtilityFrame and hide ScrollFrame
            ScrollFrame.Visible = false
            UtilityFrame.Visible = true
            local function findBtn(txt)
                local needle = string.lower(txt)
                for _, ch in ipairs(ScrollFrame:GetChildren()) do
                    if ch:IsA("TextButton") and ch.Text and string.find(string.lower(ch.Text), needle, 1, true) then
                        return ch
                    end
                end
                return nil
            end
            -- Prefer finding by Name to be robust (gunakan UtilityScroll agar bisa scroll)
            local clickBtn = UtilityScroll:FindFirstChild("ClickTPBtn") or ScrollFrame:FindFirstChild("ClickTPBtn") or findBtn("Click TP")
            local tpBox    = UtilityScroll:FindFirstChild("TPBox")     or ScrollFrame:FindFirstChild("TPBox")
            local freeBtn  = UtilityScroll:FindFirstChild("FreeCamBtn") or ScrollFrame:FindFirstChild("FreeCamBtn") or findBtn("Free Cam")
            local fcBox    = UtilityScroll:FindFirstChild("FCBox")      or ScrollFrame:FindFirstChild("FCBox")
            local spdBtn   = UtilityScroll:FindFirstChild("SpeedBtn")   or ScrollFrame:FindFirstChild("SpeedBtn") or findBtn("Speed")
            local spdBox   = UtilityScroll:FindFirstChild("SpeedBox")   or ScrollFrame:FindFirstChild("SpeedBox")
            local wpBtn    = UtilityScroll:FindFirstChild("WaypointBtn") or ScrollFrame:FindFirstChild("WaypointBtn") or findBtn("Set Waypoint")
            local wpBox    = UtilityScroll:FindFirstChild("WaypointBox") or ScrollFrame:FindFirstChild("WaypointBox")
            if not spdBox then
                for _, ch in ipairs(ScrollFrame:GetChildren()) do
                    if ch:IsA("TextBox") and string.lower(tostring(ch.PlaceholderText)) == "speed" then spdBox = ch break end
                end
            end

            local function moveToUtil(child, order)
                if child then child.Parent = UtilityScroll child.Visible = true child.LayoutOrder = order end
            end
            moveToUtil(clickBtn, 1); moveToUtil(tpBox, 2)
            moveToUtil(freeBtn, 3);  moveToUtil(fcBox, 4)
            moveToUtil(spdBtn, 5);   moveToUtil(spdBox, 6)
            moveToUtil(wpBtn, 7);    moveToUtil(wpBox, 8)
            -- juga pindahkan tombol waypoint tetap (urut A->Z)
            -- jangan tampilkan tombol waypoint tetap di Utility
            for _, ch in ipairs(UtilityScroll:GetChildren()) do
                if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") == true then
                    ch.Parent = ScrollFrame
                    ch.Visible = false
                end
            end
            for _, ch in ipairs(ScrollFrame:GetChildren()) do
                if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") == true then
                    ch.Visible = false
                end
            end
            -- -- also move fixed waypoint buttons if present
            -- local nextOrder = 7
            -- for _, ch in ipairs(ScrollFrame:GetChildren()) do
            --     if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") == true then
            --         moveToUtil(ch, nextOrder)
            --         nextOrder += 1
            --     end
            -- end
            elseif cat == "Mancing" then
            -- Tampilkan khusus tombol waypoint tetap (IsFixedWP) di UtilityScroll
            ScrollFrame.Visible = false
            UtilityFrame.Visible = true

            -- Singkirkan item non-waypoint dari UtilityScroll
            for _, ch in ipairs(UtilityScroll:GetChildren()) do
                if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") ~= true then
                    ch.Parent = ScrollFrame
                    ch.Visible = false
                elseif ch:IsA("TextBox") then
                    ch.Parent = ScrollFrame
                    ch.Visible = false
                end
            end

            -- Kumpulkan tombol waypoint tetap dari kedua parent
            local fixed = {}
            for _, ch in ipairs(ScrollFrame:GetChildren()) do
                if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") == true then
                    table.insert(fixed, ch)
                end
            end
            for _, ch in ipairs(UtilityScroll:GetChildren()) do
                if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") == true then
                    table.insert(fixed, ch)
                end
            end

            -- Urutkan A->Z
            table.sort(fixed, function(a, b)
                local at = tostring(a.Text or ""):lower()
                local bt = tostring(b.Text or ""):lower()
                return at < bt
            end)

            -- Tempatkan berurutan dari atas
            local order = 1
            for _, ch in ipairs(fixed) do
                ch.Parent = UtilityScroll
                ch.Visible = true
                ch.LayoutOrder = order
                order = order + 1
            end
        else
            -- Leaving Utility: move items back to ScrollFrame and hide UtilityFrame
            if UtilityFrame.Visible then
                local function restore(nameOrBtn)
                    local inst
                    if type(nameOrBtn) == "string" then
                        inst = UtilityScroll:FindFirstChild(nameOrBtn)
                    else
                        inst = nameOrBtn
                    end
                    if inst then inst.Parent = ScrollFrame inst.Visible = false end
                end
                restore("TPBox"); restore("FCBox"); restore("SpeedBox"); restore("WaypointBox")
                -- restore fixed waypoint buttons
                for _, ch in ipairs(UtilityScroll:GetChildren()) do
                    if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") == true then
                        ch.Parent = ScrollFrame
                        ch.Visible = false
                    end
                end
                -- buttons may not have unique names; find by text
                for _, ch in ipairs(UtilityScroll:GetChildren()) do
                    if ch:IsA("TextButton") then ch.Parent = ScrollFrame ch.Visible = false end
                end
            end
            UtilityFrame.Visible = false
            ScrollFrame.Visible = true
        end
        -- enforce Utility ordering so each button is beside its textbox
        if cat == "Utility" then
            local function findButtonByText(txt)
                local needle = string.lower(txt)
                for _, ch in ipairs(ScrollFrame:GetChildren()) do
                    if ch:IsA("TextButton") and ch.Text then
                        local hay = string.lower(ch.Text)
                        if string.find(hay, needle, 1, true) then
                            return ch
                        end
                    end
                end
                return nil
            end
            local clickBtn = findButtonByText("Click TP")
            local tpBox   = ScrollFrame:FindFirstChild("TPBox")
            local freeBtn = findButtonByText("Free Cam")
            local fcBox   = ScrollFrame:FindFirstChild("FCBox")
            local spdBtn  = findButtonByText("Speed")
            local spdBox  = ScrollFrame:FindFirstChild("SpeedBox")
            local wpBtn   = findButtonByText("Set Waypoint")
            local wpBox   = ScrollFrame:FindFirstChild("WaypointBox")
            if not spdBox then
                for _, ch in ipairs(ScrollFrame:GetChildren()) do
                    if ch:IsA("TextBox") and string.lower(tostring(ch.PlaceholderText)) == "speed" then
                        spdBox = ch; break
                    end
                end
            end
            local ordered = {clickBtn, tpBox, freeBtn, fcBox, spdBtn, spdBox, wpBtn, wpBox}
            local keep = {}
            local order = 1
            for _, inst in ipairs(ordered) do
                if inst then
                    inst.Visible = true
                    inst.LayoutOrder = order
                    keep[inst] = true
                    order = order + 1
                end
            end
            for _, ch in ipairs(ScrollFrame:GetChildren()) do
                if not keep[ch] then
                    if ch:IsA("TextButton") or ch:IsA("TextBox") or ch:IsA("Frame") or ch:IsA("ImageButton") or ch:IsA("ImageLabel") then
                        ch.Visible = false
                    end
                end
            end
        end
        -- also toggle SpeedBox (in case it's not parented directly to ScrollFrame yet in some executors)
        if typeof(SpeedBox) == "Instance" then
            SpeedBox.Visible = (cat == "Utility")
        end
        -- ensure layout recalculates
        task.defer(function()
            ScrollFrame.CanvasPosition = Vector2.new(0, 0)
        end)
    end

    local btnMenu = makeSmallBtn("Menu", 1)
    btnMenu.MouseButton1Click:Connect(function()
        setCategory("Menu")
    end)

    local btnRusuh = makeSmallBtn("Rusuh", 2)
    btnRusuh.MouseButton1Click:Connect(function()
        setCategory("Rusuh")
    end)

    local btnSpeed = makeSmallBtn("Utility", 3)
    btnSpeed.MouseButton1Click:Connect(function()
        setCategory("Utility")
    end)
    local btnMancing = makeSmallBtn("Mancing", 4)
    btnMancing.MouseButton1Click:Connect(function()
        setCategory("Mancing")
    end)
    -- default to Menu
    setCategory("Menu")
end

local ButtonGrid = Instance.new("UIGridLayout")
ButtonGrid.CellSize = UDim2.new(0, 150, 0, 35)
ButtonGrid.CellPadding = UDim2.new(0, 8, 0, 8)
ButtonGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonGrid.VerticalAlignment = Enum.VerticalAlignment.Top
ButtonGrid.SortOrder = Enum.SortOrder.LayoutOrder
ButtonGrid.StartCorner = Enum.StartCorner.TopLeft
ButtonGrid.Parent = ScrollFrame

ButtonGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonGrid.AbsoluteContentSize.Y + 10)
end)

local Navbar = Instance.new("Frame")
Navbar.Size = UDim2.new(1, 0, 0, 30)
Navbar.Position = UDim2.new(0, 0, 0, 0)
Navbar.BackgroundColor3 = Color3.fromRGB(0,0,20)
Navbar.BackgroundTransparency = 0
Navbar.Parent = MainFrame

local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 12)
navCorner.Parent = Navbar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "CHIL SCRIPT"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Color3.fromRGB(0, 200, 120)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Navbar

task.spawn(function()
    while true do
        TweenService:Create(TitleLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(0, 220, 130)
        }):Play()
        task.wait(1)
        TweenService:Create(TitleLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(0, 200, 120)
        }):Play()
        task.wait(1)
    end
end)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -12)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
MinimizeBtn.BackgroundTransparency = 0.1
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Parent = Navbar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = MinimizeBtn

local minimizeStroke = Instance.new("UIStroke")
minimizeStroke.Color = Color3.fromRGB(0, 200, 120)
minimizeStroke.Thickness = 1
minimizeStroke.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.BackgroundTransparency = 0.1
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Navbar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(200, 100, 100)
closeStroke.Thickness = 1
closeStroke.Parent = CloseBtn

local MiniFrame = Instance.new("ImageButton")
MiniFrame.Size = UDim2.new(0, 40, 0, 40)
MiniFrame.Position = UDim2.new(1, -50, 0.5, -20)
MiniFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MiniFrame.BackgroundTransparency = 0.1
MiniFrame.Image = "https://files.catbox.moe/jqehi8.jpg"
MiniFrame.ScaleType = Enum.ScaleType.Fit
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true
MiniFrame.Parent = ScreenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 12)
miniCorner.Parent = MiniFrame

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(0, 220, 130)
miniStroke.Thickness = 1.5
miniStroke.Parent = MiniFrame


-- External cursor overlay to help when zoom/locked cursor hides the pointer
local ExternalCursor = Instance.new("Frame")
ExternalCursor.Name = "ExternalCursor"
ExternalCursor.Size = UDim2.fromOffset(18, 18)
ExternalCursor.AnchorPoint = Vector2.new(0.5, 0.5)
ExternalCursor.BackgroundTransparency = 1
ExternalCursor.Visible = false
ExternalCursor.ZIndex = 1000
ExternalCursor.Parent = ScreenGui
do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromScale(1, 1)
    dot.BackgroundTransparency = 1
    dot.Parent = ExternalCursor
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = dot
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = dot
end

local function updateExternalCursorVisibility()
    ExternalCursor.Visible = (ScreenGui.Enabled == true) and (MainFrame.Visible == true)
end

ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(updateExternalCursorVisibility)
MainFrame:GetPropertyChangedSignal("Visible"):Connect(updateExternalCursorVisibility)
updateExternalCursorVisibility()

RunService.RenderStepped:Connect(function()
    if ExternalCursor.Visible then
        local pos = UserInputService:GetMouseLocation()
        ExternalCursor.Position = UDim2.fromOffset(pos.X, pos.Y)
    end
end)
-- Try to load MiniFrame image from external URL via executor APIs (if available)
do
    local url = "https://files.catbox.moe/jqehi8.jpg"
    local ok, data = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and data and type(writefile) == "function" then
        local fileName = "mini_logo.png"
        pcall(function() writefile(fileName, data) end)
        local getasset = (typeof(getcustomasset) == "function" and getcustomasset)
            or (typeof(getsynasset) == "function" and getsynasset)
        if getasset then
            local assetPath = getasset(fileName)
            if assetPath and assetPath ~= "" then
                MiniFrame.Image = assetPath
            end
        end
    end
end

-- Fixed Waypoints (from JSON) -> buttons under Utility after Speed
do
    local FixedWPs = {
        FISHERMAN = {Components={15.01081371307373,18.508968353271486,2886.0537109375,0.9958893656730652,-0.00034908627276308835,0.09057725220918656,-0.000014927989468560554,0.9999919533729553,0.0040184142999351028,-0.09057792276144028,-0.0040032509714365009,0.9958813786506653}},
        VOLCANOCAVERN = {Components={1108.23095703125,87.50140380859375,-10248.6572265625,0.008187858387827874,0.00759594701230526,0.9999376535415649,-0.000013005867003812455,0.9999711513519287,-0.007596094626933336,-0.9999665021896362,0.000049182814109371978,0.00818772055208683}},
        CRYSTALDEPTHS = {Components={5735.92822265625,-903.3184814453125,15410.943359375,0.03468192741274834,1.9270406104165972e-10,-0.999398410320282,-1.3490972783358757e-9,1,1.4600259889974155e-10,0.999398410320282,1.3432219780895594e-9,0.03468192741274834}},
        MEGAISLE    = {Components={-1106.183837890625,9.433477401733399,1673.1512451171876,-0.09335505962371826,-0.0016087450785562397,-0.9956315755844116,-3.806699453434703e-7,0.9999986886978149,-0.0016157656209543348,0.9956328868865967,-0.00015045782492961735,-0.09335494041442871}},
        UNDERPIRATE = {Components={3426.990966796875,-297.8707275390625,3349.144287109375,-0.958910346031189,0.0010387625079602004,-0.28370723128318789,-0.00001326077472185716,0.9999931454658508,0.003706137416884303,0.2837091088294983,0.003557611722499132,-0.9589037299156189}},
        MAZEROOM    = {Components={3374.086669921875,-296.6719665527344,3139.554931640625,0.8391153812408447,-0.009866614826023579,0.5438639521598816,0.004914095625281334,0.9999321699142456,0.01055859960615635,-0.5439311861991882,-0.006187278311699629,0.8391069769859314}},
        PIRATEROOM  = {Components={3301.304931640625,-303.5945129394531,3039.94482421875,-0.4016875624656677,0.01344492007046938,-0.915678083896637,0.008394800126552582,0.9999042749404907,0.010998997837305069,0.9157382249832153,-0.003268786007538438,-0.4017619788646698}},
        PIRATE      = {Components={3439.093017578125,5.684804916381836,3517.234375,0.977802574634552,0.0008971329079940915,-0.20952670276165009,-0.000011892683687619865,0.9999910593032837,0.004226256627589464,0.2095286101102829,-0.004129956476390362,0.97779381275177}},
        MEGATROPICAL= {Components={-1158.0535888671876,3.4714646339416506,3630.33203125,0.6973140239715576,-0.10207787901163101,0.7094598412513733,-8.278624896718157e-9,0.9898070693016052,0.14241456985473634,-0.7167657613754273,-0.09930767863988877,0.6902063488960266}},
        MEGACRATER  = {Components={407.9861755371094,6.750679016113281,4121.13134765625,-0.996380627155304,-0.0005656401626765728,-0.08500161021947861,-0.000010052577636088245,0.9999786615371704,-0.006536467000842094,0.08500349521636963,-0.006511954590678215,-0.9963593482971191}},
        HARTA       = {Components={-3602.19677734375,-277.58441162109377,-1587.53759765625,0.999807596206665,0.0001278429408557713,0.01961546018719673,-0.000008475522918161005,0.9999814629554749,-0.006085243541747332,-0.01961587555706501,0.006083906162530184,0.9997890591621399}},
        LUARKUIL    = {Components={1479.4808349609376,9.090734481811524,-343.2374267578125,-0.897347092628479,-0.00088000443065539,-0.4413246214389801,0.0000018022124095296022,0.9999979734420776,-0.0019976538605988027,0.44132551550865176,-0.0017933814087882639,-0.897345244884491}},
        PATUNG      = {Components={-3736.75341796875,-133.80055236816407,-1015.416259765625,-0.9695653915405273,-0.0017945958534255624,-0.244826078414917,-0.000010721681064751465,0.999973475933075,-0.007287415210157633,0.24483263492584229,-0.007062999531626701,-0.9695396423339844}},
        UNDERGROUND = {Components={2133.65087890625,-89.73197937011719,-694.9803466796875,0.9973929524421692,-0.00033288178383372724,-0.07216134667396546,-8.688780326338019e-7,0.9999892711639404,-0.004624960478395224,0.07216212153434754,0.0046129655092954639,0.9973822236061096}},
        DALAMKUIL   = {Components={1471.4512939453126,-20.628217697143556,-614.5638427734375,-0.17553499341011048,-0.002957490272819996,0.9844687581062317,-0.000005203882210480515,0.9999954700469971,0.0030032077338546516,-0.9844731688499451,0.0005220481543801725,-0.1755342036485672}},
        ESO         = {Components={3211.76708984375,-1301.3892822265626,1411.2330322265626,0.41895541548728945,-0.0020274349953979255,-0.9080045819282532,0.0000018786241753332434,0.9999974966049194,-0.0022319701965898277,0.9080068469047546,0.0009333821362815797,0.41895437240600588}},
        RUIN        = {Components={6100.0380859375,-584.4552612304688,4667.64892578125,-0.04940324276685715,0.006274937652051449,0.9987591505050659,-0.000006197193670232082,0.9999802708625794,-0.006282915826886892,-0.9987788796424866,-0.00031658177613280714,-0.049402229487895969}},
        TROPICAL    = {Components={-2049.992431640625,7.765800476074219,3659.89111328125,-0.7001360654830933,-0.0021480624563992025,0.7140061855316162,-0.000005275551757222274,0.9999954700469971,0.003003281308338046,-0.7140094637870789,0.002098941011354327,-0.7001329064369202}},
        CRATER      = {Components={1077.8387451171876,5.977067470550537,5119.4794921875,0.4851735830307007,-4.953440679855703e-8,0.8744178414344788,-5.273897940583083e-8,1,8.591083400233401e-8,-0.8744178414344788,-8.77975736557346e-8,0.4851735830307007}},
        KOHANA      = {Components={-602.82275390625,17.505319595336915,652.0319213867188,0.9999975562095642,0.0000015247237570292783,0.0021858136169612409,-0.000005804166448797332,0.9999980926513672,0.00196487782523036,-0.002185806632041931,-0.001964885974302888,0.9999956488609314}},
        CORAL       = {Components={-2746.401611328125,5.49059534072876,2182.592529296875,0.6984241008758545,-0.0031200835946947338,0.7156773805618286,-0.000013386315913521685,0.9999904632568359,0.0043726721778512,-0.7156841158866882,-0.003063580021262169,0.6984174251556397}},
        VOLCANO     = {Components={-445.505615234375,16.619747161865236,154.78125,-0.21563377976417542,-1.2664203019596698e-8,0.9764742851257324,2.1402719596608223e-8,1,1.7695654719318555e-8,-0.9764742851257324,2.4714987389984345e-8,-0.21563377976417542}},
    }

    local function makeWPBtn(name, comps)
        -- Buat tombol langsung (tanpa createButton) agar tidak tergantung urutan definisi
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 150, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 0.1
        btn.Text = name
        btn.TextSize = 15
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn:SetAttribute("IsFixedWP", true)
        btn.Visible = true
        btn.Parent = ScrollFrame
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = btn
        local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0,130,80); s.Thickness = 1.5; s.Parent = btn
        local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0,12); p.Parent = btn
        btn.MouseButton1Click:Connect(function()
            local ok, cf = pcall(function() return CFrame.new(table.unpack(comps)) end)
            if ok and typeof(cf)=="CFrame" then
                local lplr = game:GetService("Players").LocalPlayer
                local char = lplr.Character or lplr.CharacterAdded:Wait()
                if char then char:PivotTo(cf) end
            end
        end)
        return btn
    end

    for name, data in pairs(FixedWPs) do
        if type(data)=="table" and type(data.Components)=="table" then
            makeWPBtn(name, data.Components)
        end
    end
end

CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        MiniFrame.Visible = true
    end)
end)

MiniFrame.MouseButton1Click:Connect(function()
    MiniFrame.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 280)})
    tween:Play()
end)

local buttonStates = {}

local function createButton(icon, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.1
    btn.Text = icon .. "  " .. text
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = 0
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(0, 130, 80)
    btnStroke.Thickness = 1.5
    btnStroke.Parent = btn
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = btn

    local defaultColor = Color3.fromRGB(0, 0, 0)
    local hoverColor = Color3.fromRGB(20, 20, 60)

    buttonStates[btn] = false

    btn.MouseEnter:Connect(function()
        if not buttonStates[btn] then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = hoverColor
            }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(0, 200, 120)
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not buttonStates[btn] then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = defaultColor
            }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(0, 130, 80)
            }):Play()
        end
    end)

    btn.Parent = ScrollFrame
    return btn
end

local function setButtonActive(button, active)
    buttonStates[button] = active
    if active then
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 220, 130)
        }):Play()
        TweenService:Create(button:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {
            Color = Color3.fromRGB(0, 240, 150)
        }):Play()
    else
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        }):Play()
        TweenService:Create(button:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {
            Color = Color3.fromRGB(0, 130, 80)
        }):Play()
    end
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local AirwalkActive = false
local AirWPart = nil
local baseY = nil

local AirwalkBtn = createButton("", "Jalan di udara")

local function StartAirwalk()
    if AirWPart then return end
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")

    AirWPart = Instance.new("Part", Workspace)
    AirWPart.Size = Vector3.new(7, 1, 3)
    AirWPart.Anchored = true
    AirWPart.Transparency = 1
    AirWPart.CanCollide = true
    AirWPart.Name = "Airwalk"

    baseY = root.Position.Y - (root.Size.Y/2 + 0.5)
    AirWPart.Position = Vector3.new(root.Position.X, baseY, root.Position.Z)

    task.spawn(function()
        while AirwalkActive and AirWPart do
            AirWPart.Position = Vector3.new(root.Position.X, AirWPart.Position.Y, root.Position.Z)
            task.wait(0.05)
        end
    end)

    humanoid.StateChanged:Connect(function(_, new)
        if not AirwalkActive then return end
        if new == Enum.HumanoidStateType.Jumping then
            if root and AirWPart then
                AirWPart.Position = Vector3.new(AirWPart.Position.X, root.Position.Y - (root.Size.Y/16 + 0), AirWPart.Position.Z)
            end
        end
    end)
end

local function StopAirwalk()
    AirwalkActive = false
    if AirWPart then
        AirWPart:Destroy()
        AirWPart = nil
    end
end

AirwalkBtn.MouseButton1Click:Connect(function()
    AirwalkActive = not AirwalkActive
    if AirwalkActive then
        StartAirwalk()
        setButtonActive(AirwalkBtn, true)
    else
        StopAirwalk()
        setButtonActive(AirwalkBtn, false)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    StopAirwalk()
    setButtonActive(AirwalkBtn, false)
end)

local ESPBtn = createButton("", "ESP")
local ESPTeamBtn = createButton("", "ESP Team")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local COREGUI = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local ESPenabled = false
local ESPTeamMode = false
local espTransparency = 0.3

local function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function destroyPlayerESP(name)
    for _, v in pairs(COREGUI:GetChildren()) do
        if v.Name == name .. "_ESP" then
            v:Destroy()
        end
    end
end

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    if not plr.Character or not getRoot(plr.Character) then return end
    if COREGUI:FindFirstChild(plr.Name .. "_ESP") then return end

    local holder = Instance.new("Folder")
    holder.Name = plr.Name .. "_ESP"
    holder.Parent = COREGUI

    for _, part in pairs(plr.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = plr.Name
            box.Parent = holder
            box.Adornee = part
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = part.Size
            box.Transparency = espTransparency
            if ESPTeamMode then
                box.Color = BrickColor.new(plr.TeamColor == LocalPlayer.TeamColor and "Bright green" or "Bright red")
            else
                box.Color = plr.TeamColor
            end
        end
    end

    local head = plr.Character:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Name = plr.Name
        billboard.Parent = holder
        billboard.Size = UDim2.new(0, 100, 0, 150)
        billboard.StudsOffset = Vector3.new(0, 1, 0)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 0, 0, -50)
        label.Size = UDim2.new(0, 100, 0, 100)
        label.Font = Enum.Font.SourceSansSemibold
        label.TextSize = 20
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        label.ZIndex = 10

        local function updateLabel()
            if COREGUI:FindFirstChild(plr.Name .. "_ESP") then
                local myChar = LocalPlayer.Character
                if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and myChar and getRoot(myChar) then
                    local studs = math.floor((getRoot(myChar).Position - getRoot(plr.Character).Position).Magnitude)
                    local hp = plr.Character:FindFirstChildOfClass("Humanoid").Health
                    label.Text = "Name: " .. plr.Name .. " | Health: " .. string.format("%.1f", hp) .. " | Studs: " .. studs
                end
            end
        end

        RunService.RenderStepped:Connect(updateLabel)
    end

    plr.CharacterAdded:Connect(function()
        if ESPenabled then
            destroyPlayerESP(plr.Name)
            repeat task.wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
            CreateESP(plr)
        else
            destroyPlayerESP(plr.Name)
        end
    end)
    plr:GetPropertyChangedSignal("TeamColor"):Connect(function()
        if ESPenabled then
            destroyPlayerESP(plr.Name)
            if plr.Character and getRoot(plr.Character) then
                CreateESP(plr)
            end
        end
    end)
end

local function startESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreateESP(plr)
        end
    end
end

local function stopESP()
    for _, v in pairs(COREGUI:GetChildren()) do
        if string.sub(v.Name, -4) == "_ESP" then
            v:Destroy()
        end
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    ESPenabled = not ESPenabled
    if ESPenabled then
        ESPTeamMode = false
        setButtonActive(ESPBtn, true)
        setButtonActive(ESPTeamBtn, false)
        startESP()
    else
        setButtonActive(ESPBtn, false)
        stopESP()
    end
end)

ESPTeamBtn.MouseButton1Click:Connect(function()
    local newState = not (ESPenabled and ESPTeamMode)
    if newState then
        -- enable team mode
        ESPTeamMode = true
        if not ESPenabled then
            ESPenabled = true
        else
            -- refresh current ESP to apply team colors
            stopESP()
        end
        setButtonActive(ESPTeamBtn, true)
        setButtonActive(ESPBtn, false)
        startESP()
    else
        -- disable ESP entirely when toggling off team mode
        setButtonActive(ESPTeamBtn, false)
        ESPenabled = false
        ESPTeamMode = false
        stopESP()
    end
end)

local Player = game.Players.LocalPlayer

local LampBtn = createButton("", "Lampu")
local lampOn = false
local headLamp = nil

local function addHeadLamp(char)
    local head = char:FindFirstChild("Head")
    if not head then return end
    if char:FindFirstChild("HeadLamp") then return end

    headLamp = Instance.new("Part")
    headLamp.Name = "HeadLamp"
    headLamp.Size = Vector3.new(0.5,0.5,0.5)
    headLamp.Shape = Enum.PartType.Ball
    headLamp.Color = Color3.fromRGB(255,255,255)
    headLamp.Material = Enum.Material.Neon
    headLamp.Anchored = false
    headLamp.CanCollide = false
    headLamp.CFrame = head.CFrame * CFrame.new(0,0.8,0)
    headLamp.Parent = char

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = headLamp
    weld.Parent = headLamp

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255,255,255)
    light.Range = 100
    light.Brightness = 2
    light.Parent = headLamp
end

local function removeHeadLamp()
    if headLamp and headLamp.Parent then
        headLamp:Destroy()
    end
    headLamp = nil
end

LampBtn.MouseButton1Click:Connect(function()
    lampOn = not lampOn
    local char = Player.Character or Player.CharacterAdded:Wait()
    if lampOn then
        addHeadLamp(char)
        setButtonActive(LampBtn, true)
    else
        removeHeadLamp()
        setButtonActive(LampBtn, false)
    end
end)

Player.CharacterAdded:Connect(function(char)
    if lampOn then
        task.wait(1)
        addHeadLamp(char)
        setButtonActive(LampBtn, true)
    else
        setButtonActive(LampBtn, false)
    end
end)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local infiniteJumpEnabled = false
local jumpPowerBoost = 25
local slowFallSpeed = -50

local JumpBtn = createButton("", "Infinite Jump")

local function updateCharacterRefs(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end
player.CharacterAdded:Connect(updateCharacterRefs)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        local goalVelocity = Vector3.new(root.Velocity.X, jumpPowerBoost, root.Velocity.Z)
        local tween = TweenService:Create(root, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Velocity = goalVelocity})
        tween:Play()
    end
end)

RunService.Stepped:Connect(function()
    if humanoid and infiniteJumpEnabled then
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            if root.Velocity.Y < slowFallSpeed then
                root.Velocity = Vector3.new(root.Velocity.X, slowFallSpeed, root.Velocity.Z)
            end
        end
    end
end)

JumpBtn.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    setButtonActive(JumpBtn, infiniteJumpEnabled)
end)

-- Rejoin button (Menu): rejoin same server if possible, else rejoin place
local RejoinBtn = createButton("", "Rejoin")
RejoinBtn.LayoutOrder = 1
RejoinBtn.MouseButton1Click:Connect(function()
    local player = game:GetService("Players").LocalPlayer
    local ts = game:GetService("TeleportService")
    local placeId = game.PlaceId
    local jobId = game.JobId
    local ok = pcall(function()
        ts:TeleportToPlaceInstance(placeId, jobId, player)
    end)
    if not ok then
        pcall(function()
            ts:Teleport(placeId, player)
        end)
    end
end)

-- Refresh button (Menu): respawn the character quickly
local RefreshBtn = createButton("", "Refresh")
RefreshBtn.LayoutOrder = 2
RefreshBtn.MouseButton1Click:Connect(function()
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    if not plr then return end

    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local savedCFrame = hrp and hrp.CFrame
    local savedVel = hrp and hrp.AssemblyLinearVelocity

    -- clean respawn
    pcall(function() plr:LoadCharacter() end)

    -- wait for new character then restore position
    local newChar = plr.Character or plr.CharacterAdded:Wait()
    local newHRP = newChar:WaitForChild("HumanoidRootPart", 5)
    if newHRP and savedCFrame then
        -- small delay to let Roblox finish placing the character
        task.delay(0.2, function()
            pcall(function()
                newHRP.CFrame = savedCFrame
                if savedVel then newHRP.AssemblyLinearVelocity = savedVel end
            end)
        end)
    end
end)

local Player = game.Players.LocalPlayer
local SpeedBtn = createButton("", "Speed")
SpeedBtn.Name = "SpeedBtn"
SpeedBtn.LayoutOrder = 5
local desiredSpeed = 50

-- Inline Speed control textbox placed directly under Speed button
do
    local SpeedBox2 = Instance.new("TextBox")
    SpeedBox2.Name = "SpeedBox"
    SpeedBox2.LayoutOrder = 6
    SpeedBox2.Size = UDim2.new(0, 150, 0, 35)
    SpeedBox2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SpeedBox2.BackgroundTransparency = 0.1
    SpeedBox2.Text = tostring(desiredSpeed)
    SpeedBox2.PlaceholderText = "Speed"
    SpeedBox2.TextSize = 15
    SpeedBox2.Font = Enum.Font.GothamBold
    SpeedBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBox2.ClearTextOnFocus = false
    SpeedBox2.LayoutOrder = 6
    SpeedBox2.Parent = ScrollFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = SpeedBox2

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 80, 160)
    s.Thickness = 1.5
    s.Parent = SpeedBox2

    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 12)
    p.Parent = SpeedBox2

    SpeedBox2.FocusLost:Connect(function()
        local n = tonumber(SpeedBox2.Text)
        if n and n > 0 and n < 1000 then
            desiredSpeed = n
            if speedOn then
                local char = Player.Character or Player.CharacterAdded:Wait()
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = desiredSpeed end
            end
        else
            SpeedBox2.Text = tostring(desiredSpeed)
        end
    end)
end

local speedOn = false
local selendangPart = nil

local colors = {
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,127,0),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,0,255),
	Color3.fromRGB(75,0,130),
	Color3.fromRGB(148,0,211)
}

local function lerpColor(c1, c2, t)
	return Color3.new(
		c1.R + (c2.R - c1.R) * t,
		c1.G + (c2.G - c1.G) * t,
		c1.B + (c2.B - c1.B) * t
	)
end

local function addSelendang(char)
	if selendangPart then
		selendangPart:Destroy()
		selendangPart = nil
	end

	local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
	if not torso then return end

	selendangPart = Instance.new("Part")
	selendangPart.Name = "SelendangPart"
	selendangPart.Size = Vector3.new(0.5,0.5,0.5)
	selendangPart.Transparency = 1
	selendangPart.Anchored = false
	selendangPart.CanCollide = false
	selendangPart.CFrame = torso.CFrame
	selendangPart.Parent = char

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = torso
	weld.Part1 = selendangPart
	weld.Parent = selendangPart

	local trails = {}
	local spacing = -0.04
	local startY = 0.5

	for i = 1, 40 do
		local yPos = startY + (i-1) * spacing
		local attLeft = Instance.new("Attachment", selendangPart)
		attLeft.Position = Vector3.new(-1, yPos, 0)

		local attRight = Instance.new("Attachment", selendangPart)
		attRight.Position = Vector3.new(1, yPos, 0)

		local newTrail = Instance.new("Trail")
		newTrail.Attachment0 = attLeft
		newTrail.Attachment1 = attRight
		newTrail.Lifetime = 0.6
		newTrail.MinLength = 0.1
		newTrail.LightEmission = 1
		newTrail.Transparency = NumberSequence.new(0,1)
		newTrail.WidthScale = NumberSequence.new(0.5,0)
		newTrail.Parent = selendangPart

		table.insert(trails, newTrail)
	end

	task.spawn(function()
		local step = 0
		while speedOn and selendangPart and selendangPart.Parent do
			local idx1 = math.floor(step) % #colors + 1
			local idx2 = (idx1 % #colors) + 1
			local t = step % 1
			local col = lerpColor(colors[idx1], colors[idx2], t)
			for _, tr in ipairs(trails) do
				tr.Color = ColorSequence.new(col)
			end
			step += 0.02
			task.wait(0.03)
		end
	end)
end

local function removeSelendang()
	if selendangPart then
		selendangPart:Destroy()
		selendangPart = nil
	end
end

SpeedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	local char = Player.Character or Player.CharacterAdded:Wait()
	local hum = char:FindFirstChild("Humanoid")

	if speedOn then
		if hum then hum.WalkSpeed = desiredSpeed end
		addSelendang(char)
		setButtonActive(SpeedBtn, true)
	else
		if hum then hum.WalkSpeed = 16 end
		removeSelendang()
		setButtonActive(SpeedBtn, false)
	end
end)

Player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid")
	task.wait(0.5)
	if speedOn then
		hum.WalkSpeed = desiredSpeed
		addSelendang(char)
		setButtonActive(SpeedBtn, true)
	else
		hum.WalkSpeed = 16
		setButtonActive(SpeedBtn, false)
	end
end)

local FlingBtn = createButton("", "Tendang")
local hiddenfling = false
local flingThread

local function fling()
    local lp = Players.LocalPlayer
    while hiddenfling do
        RunService.Heartbeat:Wait()
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.Velocity
            hrp.Velocity = vel * 99999 + Vector3.new(0, 99999, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
        end
    end
end

FlingBtn.MouseButton1Click:Connect(function()
    hiddenfling = not hiddenfling
    if hiddenfling then
        setButtonActive(FlingBtn, true)
        flingThread = coroutine.create(fling)
        coroutine.resume(flingThread)
    else
        setButtonActive(FlingBtn, false)
    end
end)

-- Waypoint system with click-to-create functionality
local Waypoints = {}
local WaypointBtn = createButton("", "Set Waypoint")
WaypointBtn.Name = "WaypointBtn"
WaypointBtn.LayoutOrder = 6

-- Waypoint name input box
local WaypointBox = Instance.new("TextBox")
WaypointBox.Size = UDim2.new(0, 150, 0, 25)
WaypointBox.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
WaypointBox.BackgroundTransparency = 0.2
WaypointBox.Text = ""
WaypointBox.PlaceholderText = "waypoint name"
WaypointBox.TextSize = 14
WaypointBox.Font = Enum.Font.Gotham
WaypointBox.TextColor3 = Color3.fromRGB(255, 255, 255)
WaypointBox.Parent = ButtonsFrame
local wpCorner = Instance.new("UICorner")
wpCorner.CornerRadius = UDim.new(0, 6)
wpCorner.Parent = WaypointBox
local wpStroke = Instance.new("UIStroke")
wpStroke.Color = Color3.fromRGB(0, 220, 130)
wpStroke.Thickness = 1
wpStroke.Parent = WaypointBox
local wpPadding = Instance.new("UIPadding")
wpPadding.PaddingLeft = UDim.new(0, 8)
wpPadding.Parent = WaypointBox

-- Function to save waypoints
local function saveWaypoints()
    local success, json = pcall(function()
        return game:GetService("HttpService"):JSONEncode(Waypoints)
    end)
    if success then
        pcall(function()
            writefile("waypoints.json", json)
        end)
    end
end

-- Function to load waypoints
local function loadWaypoints()
    local success, json = pcall(function()
        return readfile("waypoints.json")
    end)
    if success then
        local success2, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(json)
        end)
        if success2 then
            Waypoints = data
        end
    end
end

-- Function to create waypoint button in utility
local function createWaypointButton(name, comps)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0.1
    btn.Text = "📍 " .. name
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn:SetAttribute("IsCustomWP", true)
    btn.Visible = false
    btn.Parent = ScrollFrame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 150, 255)
    s.Thickness = 1.5
    s.Parent = btn
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 12)
    p.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        local ok, cf = pcall(function()
            return CFrame.new(table.unpack(comps))
        end)
        if ok and typeof(cf) == "CFrame" then
            local lplr = game:GetService("Players").LocalPlayer
            local char = lplr.Character or lplr.CharacterAdded:Wait()
            if char then
                char:PivotTo(cf)
            end
        end
    end)
    
    btn.MouseButton2Click:Connect(function()
        Waypoints[name] = nil
        saveWaypoints()
        btn:Destroy()
    end)
    
    return btn
end

-- Load existing waypoints
loadWaypoints()

-- Create buttons for existing waypoints
for name, data in pairs(Waypoints) do
    if type(data) == "table" and type(data.Components) == "table" then
        createWaypointButton(name, data.Components)
    end
end

WaypointBtn.MouseButton1Click:Connect(function()
    local name = WaypointBox.Text
    if not name or name == "" then
        return
    end
    
    local char = Player.Character or Player.CharacterAdded:Wait()
    local cf
    if char then
        cf = char:GetPivot()
    end
    
    if not cf then
        return
    end
    
    Waypoints[name] = { Components = { cf:GetComponents() } }
    saveWaypoints()
    createWaypointButton(name, Waypoints[name].Components)
    WaypointBox.Text = ""
end)

-- Click TP and Free Cam integrations
local ClickTPBtn = createButton("", "Click TP")
ClickTPBtn.Name = "ClickTPBtn"
ClickTPBtn.LayoutOrder = 1
local FreeCamBtn = createButton("", "Free Cam")
FreeCamBtn.Name = "FreeCamBtn"
FreeCamBtn.LayoutOrder = 3

local clickTpOn = false
local freecamOn = false
local freecamYaw, freecamPitch = 0, 0
local freecamPos
local freecamSpeed = 2

ClickTPBtn.MouseButton1Click:Connect(function()
    clickTpOn = not clickTpOn
    setButtonActive(ClickTPBtn, clickTpOn)
end)

local function setFreecam(state)
    freecamOn = state
    local cam = workspace.CurrentCamera
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if freecamOn then
        if hrp then hrp.Anchored = true end
        cam.CameraType = Enum.CameraType.Scriptable
        freecamPos = cam.CFrame.Position
        local rx, ry = cam.CFrame:ToOrientation()
        freecamPitch, freecamYaw = rx, ry
        setButtonActive(FreeCamBtn, true)
        task.spawn(function()
            while freecamOn do
                if not UserInputService:GetFocusedTextBox() then
                    local delta = Vector3.new()
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then delta += cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then delta -= cam.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then delta -= cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then delta += cam.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then delta += Vector3.new(0,1,0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then delta -= Vector3.new(0,1,0) end
                    freecamPos += delta * freecamSpeed
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                        local md = UserInputService:GetMouseDelta()
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                        freecamYaw = freecamYaw - (md.X/300)
                        freecamPitch = math.clamp(freecamPitch - (md.Y/300), -math.rad(89), math.rad(89))
                    else
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    end
                end
                cam.CFrame = CFrame.new(freecamPos) * CFrame.fromOrientation(freecamPitch, freecamYaw, 0)
                RunService.RenderStepped:Wait()
            end
        end)
    else
        if hrp then hrp.Anchored = false end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        setButtonActive(FreeCamBtn, false)
    end
end

FreeCamBtn.MouseButton1Click:Connect(function()
    setFreecam(not freecamOn)
end)

-- Teleport-by-name UI (like admin2): a TextBox under Click TP
local TPBox = Instance.new("TextBox")
TPBox.Name = "TPBox"
TPBox.LayoutOrder = 2
TPBox.Size = UDim2.new(0, 150, 0, 35)
TPBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TPBox.BackgroundTransparency = 0.1
TPBox.Text = ""
TPBox.PlaceholderText = "Player name / @user"
TPBox.TextSize = 15
TPBox.Font = Enum.Font.GothamBold
TPBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TPBox.ClearTextOnFocus = false
TPBox.Parent = ScrollFrame
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = TPBox
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 130, 80)
    s.Thickness = 1.5
    s.Parent = TPBox
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 12)
    p.Parent = TPBox
end

-- Freecam speed TextBox under Free Cam
local FCBox = Instance.new("TextBox")
FCBox.Name = "FCBox"
FCBox.LayoutOrder = 4
FCBox.Size = UDim2.new(0, 150, 0, 35)
FCBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FCBox.BackgroundTransparency = 0.1
FCBox.Text = tostring(freecamSpeed)
FCBox.PlaceholderText = "Freecam speed"
FCBox.TextSize = 15
FCBox.Font = Enum.Font.GothamBold
FCBox.TextColor3 = Color3.fromRGB(255, 255, 255)
FCBox.ClearTextOnFocus = false
FCBox.Parent = ScrollFrame
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = FCBox
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 130, 80)
    s.Thickness = 1.5
    s.Parent = FCBox
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 12)
    p.Parent = FCBox
end

FCBox.FocusLost:Connect(function()
    local n = tonumber(FCBox.Text)
    if n and n > 0 and n < 200 then
        freecamSpeed = n
    else
        FCBox.Text = tostring(freecamSpeed)
    end
end)

local function findPlayerByQuery(q)
    if not q or q == "" then return nil end
    q = q:gsub("^@", "")
    local lower = string.lower(q)
    -- exact Name
    for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if string.lower(plr.Name) == lower then return plr end
    end
    -- exact DisplayName
    for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if string.lower(plr.DisplayName) == lower then return plr end
    end
    -- startswith Name or DisplayName
    for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if string.find(string.lower(plr.Name), lower, 1, true) == 1 or string.find(string.lower(plr.DisplayName), lower, 1, true) == 1 then
            return plr
        end
    end
    return nil
end

ClickTPBtn.MouseButton1Click:Connect(function()
    local query = TPBox.Text
    local target = findPlayerByQuery(query)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character.PrimaryPart then
        local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
        player.Character:SetPrimaryPartCFrame(CFrame.new(targetPos))
    else
        -- keep button visual feedback
        setButtonActive(ClickTPBtn, true)
        task.delay(0.1, function() setButtonActive(ClickTPBtn, false) end)
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

local animations = {
    Idle = 100681208320300,
    Fly = 73980801925168,
}

local animTracks = {}
local animator

local function setupAnimator(hum)
    animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
    animTracks = {}

    for name, id in pairs(animations) do
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. id
        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = true
        animTracks[name] = track
    end
end

setupAnimator(humanoid)

local flying = false
local flySpeed = 2
local pressed = {Up=false,Down=false,Left=false,Right=false}
local moving = false
local savedOrientation = nil
local oldGravity = Workspace.Gravity
local frozenPos = nil

local gui = Instance.new("ScreenGui")
gui.Name = "FlyGui"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local DPad = Instance.new("Frame")
DPad.Size = UDim2.new(0,140,0,140)
DPad.Position = UDim2.new(0,15,1,-155)
DPad.BackgroundColor3 = Color3.fromRGB(25,25,25)
DPad.BackgroundTransparency = 0.05
DPad.Visible = false
DPad.Parent = gui
Instance.new("UICorner", DPad).CornerRadius = UDim.new(0,12)

local function createBtn(txt,pos)
    local btn = Instance.new("TextButton")
    btn.Text = txt
    btn.Size = UDim2.new(0,45,0,45)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Parent = DPad
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    return btn
end

local UpBtn = createBtn("^", UDim2.new(0.5,-22,0,8))
local DownBtn = createBtn("v", UDim2.new(0.5,-22,1,-53))
local LeftBtn = createBtn("<", UDim2.new(0,8,0.5,-22))
local RightBtn = createBtn(">", UDim2.new(1,-53,0.5,-22))

local function connectBtn(btn,key)
    btn.MouseButton1Down:Connect(function() pressed[key]=true btn.BackgroundColor3=Color3.fromRGB(90,90,90) end)
    btn.MouseButton1Up:Connect(function() pressed[key]=false btn.BackgroundColor3=Color3.fromRGB(50,50,50) end)
end
connectBtn(UpBtn,"Up")
connectBtn(DownBtn,"Down")
connectBtn(LeftBtn,"Left")
connectBtn(RightBtn,"Right")

local FlyBtn = createButton("", "Fly")

local function noclip(state)
    for _,v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not state
        end
    end
end

local function enableFly()
    flying = true
    DPad.Visible = true
    humanoid.PlatformStand = true
    noclip(true)
    Workspace.Gravity = 0
    
    setButtonActive(FlyBtn, true)

    frozenPos = root.Position
    local _, y, _ = root.CFrame:ToOrientation()
    savedOrientation = CFrame.Angles(0, math.rad(y), 0)

    if animTracks.Idle then animTracks.Idle:Play() end
end

local function disableFly()
    flying = false
    DPad.Visible = false
    humanoid.PlatformStand = false
    noclip(false)
    Workspace.Gravity = oldGravity
    frozenPos = nil
    
    setButtonActive(FlyBtn, false)

    for _, t in pairs(animTracks) do if t.IsPlaying then t:Stop() end end
end

FlyBtn.MouseButton1Click:Connect(function()
    if flying then 
        disableFly() 
    else 
        enableFly() 
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if not flying then return end
	if input.KeyCode == Enum.KeyCode.W then pressed.Up = true end
	if input.KeyCode == Enum.KeyCode.S then pressed.Down = true end
	if input.KeyCode == Enum.KeyCode.A then pressed.Left = true end
	if input.KeyCode == Enum.KeyCode.D then pressed.Right = true end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then pressed.Up = false end
	if input.KeyCode == Enum.KeyCode.S then pressed.Down = false end
	if input.KeyCode == Enum.KeyCode.A then pressed.Left = false end
	if input.KeyCode == Enum.KeyCode.D then pressed.Right = false end
end)

RunService.Heartbeat:Connect(function(dt)
    if not flying or not root then return end

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    local cam = workspace.CurrentCamera
    local lookVec = cam.CFrame.LookVector
    local rightVec = cam.CFrame.RightVector
    local dir = Vector3.zero

    if pressed.Up then dir += lookVec end
    if pressed.Down then dir -= lookVec end
    if pressed.Left then dir -= rightVec end
    if pressed.Right then dir += rightVec end

    if dir.Magnitude > 0 then
        moving = true
        frozenPos = root.Position + dir.Unit * flySpeed * dt * 60
        root.CFrame = CFrame.new(frozenPos, frozenPos + lookVec)
    else
        moving = false
        if frozenPos and savedOrientation then
            root.CFrame = CFrame.new(frozenPos) * savedOrientation
        end
    end

    if moving then
        if animTracks.Idle and animTracks.Idle.IsPlaying then animTracks.Idle:Stop() end
        if animTracks.Fly and not animTracks.Fly.IsPlaying then animTracks.Fly:Play() end
    else
        if animTracks.Fly and animTracks.Fly.IsPlaying then animTracks.Fly:Stop() end
        if animTracks.Idle and not animTracks.Idle.IsPlaying then animTracks.Idle:Play() end
    end
end)

humanoid.Died:Connect(function()
    disableFly()
    setButtonActive(FlyBtn, false)
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    setupAnimator(humanoid)
    
    humanoid.Died:Connect(function()
        disableFly()
        setButtonActive(FlyBtn, false)
    end)
    
    setButtonActive(FlyBtn, false)
end)

setButtonActive(FlyBtn, false)

local UnanchorBtn = createButton("", "Unanchor")
local player = game.Players.LocalPlayer
local aktif = false
local folder, attachment1, koneksi1
local RADIUS = 500

local function scanParts()
    local parts = {}
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return parts end

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") 
        and not part.Anchored 
        and not part:IsDescendantOf(player.Character) then
            local dist = (part.Position - root.Position).Magnitude
            if dist <= RADIUS then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

local function applyForce(part)
    if not part or not part.Parent then return end
    part.CanCollide = false

    for _, x in next, part:GetChildren() do
        if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") 
        or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity")
        or x:IsA("RocketPropulsion") then
            x:Destroy()
        end
    end

    if not part:FindFirstChildOfClass("Torque") then
        local torque = Instance.new("Torque", part)
        torque.Torque = Vector3.new(100000,100000,100000)
        local align = Instance.new("AlignPosition", part)
        local at2 = Instance.new("Attachment", part)
        torque.Attachment0 = at2
        align.MaxForce = 9e15
        align.MaxVelocity = math.huge
        align.Responsiveness = 200
        align.Attachment0 = at2
        if attachment1 then
            align.Attachment1 = attachment1
        end
    end

    if attachment1 then
        local dist = (part.Position - attachment1.WorldPosition).Magnitude
        if dist <= RADIUS then
            local arah = (attachment1.WorldPosition - part.Position).Unit
            part.AssemblyLinearVelocity = arah * 200
        end
    end
end

local function mulaiUnanchor()
    folder = Instance.new("Folder", workspace)
    local part = Instance.new("Part", folder)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    attachment1 = Instance.new("Attachment", part)

    task.spawn(function()
        settings().Physics.AllowSleep = false
        while aktif and task.wait() do
            for _, pl in next, game.Players:GetPlayers() do
                if pl ~= player then
                    pl.MaximumSimulationRadius = 0
                    sethiddenproperty(pl, "SimulationRadius", 0)
                end
            end
            player.MaximumSimulationRadius = math.pow(math.huge, math.huge)
            setsimulationradius(math.huge)
        end
    end)

    koneksi1 = game:GetService("RunService").Stepped:Connect(function()
        local list = scanParts()
        for _, v in pairs(list) do
            applyForce(v)
        end
    end)
end

local function stopUnanchor()
    if koneksi1 then koneksi1:Disconnect() end
    if folder then folder:Destroy() end
    folder, attachment1 = nil, nil
end

UnanchorBtn.MouseButton1Click:Connect(function()
    aktif = not aktif
    if aktif then
        setButtonActive(UnanchorBtn, true)
        mulaiUnanchor()
    else
        setButtonActive(UnanchorBtn, false)
        stopUnanchor()
    end
end)

local BringPartBtn = createButton("", "BringPart")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local character, humanoidRootPart, head
local blackHoleActive = false
local DescendantAddedConnection
local NetworkConnection

local Folder = Instance.new("Folder", Workspace)
Folder.Name = "BringPartFolder"
local TargetPart = Instance.new("Part", Folder)
TargetPart.Anchored = true
TargetPart.CanCollide = false
TargetPart.Transparency = 1
local Attachment1 = Instance.new("Attachment", TargetPart)

if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14.46, 14.46, 14.46)
	}

	function Network.RetainPart(part)
		if part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
			table.insert(Network.BaseParts, part)
			part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
			part.CanCollide = false
		end
	end
end

local function EnableNetwork()
	if NetworkConnection then return end
	NetworkConnection = RunService.Heartbeat:Connect(function()
		pcall(function()
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
		end)
	end)
end

local function DisableNetwork()
	if NetworkConnection then
		NetworkConnection:Disconnect()
		NetworkConnection = nil
	end
end

local function ForcePart(v)
	if v:IsA("BasePart") 
	and not v.Anchored 
	and not v.Parent:FindFirstChildOfClass("Humanoid") 
	and not v.Parent:FindFirstChild("Head") 
	and v.Name ~= "Handle" then

		for _, x in ipairs(v:GetChildren()) do
			if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
				x:Destroy()
			end
		end

		if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
		if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
		if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end

		v.CanCollide = false
		local Torque = Instance.new("Torque", v)
		Torque.Torque = Vector3.new(100000, 100000, 100000)
		local AlignPosition = Instance.new("AlignPosition", v)
		local Attachment2 = Instance.new("Attachment", v)
		Torque.Attachment0 = Attachment2
		AlignPosition.MaxForce = math.huge
		AlignPosition.MaxVelocity = math.huge
		AlignPosition.Responsiveness = 200
		AlignPosition.Attachment0 = Attachment2
		AlignPosition.Attachment1 = Attachment1
	end
end

local function OneTimeUnanchor()
	if getgenv().UnanchorCooldown then return end
	getgenv().UnanchorCooldown = true

	task.spawn(function()
		local startTime = tick()

		while tick() - startTime < 1 do
			for _, obj in pairs(Workspace:GetDescendants()) do
				if obj:IsA("RopeConstraint") then
					local part0 = obj.Attachment0 and obj.Attachment0.Parent
					local part1 = obj.Attachment1 and obj.Attachment1.Parent
					pcall(function() obj:Destroy() end)
					if part0 and part0:IsA("BasePart") then part0.Anchored = false end
					if part1 and part1:IsA("BasePart") then part1.Anchored = false end
				end
			end

			for _, part in pairs(Workspace:GetDescendants()) do
				if part:IsA("BasePart") and not part.Anchored then
					part.AssemblyLinearVelocity = Vector3.new(
						math.random(-50, 50),
						math.random(20, 100),
						math.random(-50, 50)
					)
				end
			end

			task.wait(0.2)
		end

		getgenv().UnanchorCooldown = false
	end)
end

local function GetAllPartsRecursive(parent)
	local parts = {}
	for _, obj in ipairs(parent:GetChildren()) do
		if obj:IsA("BasePart") then
			table.insert(parts, obj)
		elseif obj:IsA("Folder") or obj:IsA("Model") then
			for _, childPart in ipairs(GetAllPartsRecursive(obj)) do
				table.insert(parts, childPart)
			end
		end
	end
	return parts
end

BringPartBtn.MouseButton1Click:Connect(function()
	blackHoleActive = not blackHoleActive

	if blackHoleActive then
		setButtonActive(BringPartBtn, true)
		EnableNetwork()

		character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		head = character:WaitForChild("Head")

		OneTimeUnanchor()

		for _, v in ipairs(GetAllPartsRecursive(Workspace)) do
			ForcePart(v)
		end

		DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if blackHoleActive and v:IsA("BasePart") then
				ForcePart(v)
			end
		end)

		task.spawn(function()
			while blackHoleActive and RunService.RenderStepped:Wait() do
				if head then
					Attachment1.WorldCFrame = head.CFrame * CFrame.new(0, 10, 0)
				else
					Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(0, 10, 0)
				end
			end
		end)
	else
		setButtonActive(BringPartBtn, false)
		DisableNetwork()
		if DescendantAddedConnection then
			DescendantAddedConnection:Disconnect()
			DescendantAddedConnection = nil
		end
	end
end)

local AntiLagBtn = createButton("", "Anti Lag")
local antiLagActive = false
local connections = {}
local originalStates = {}

local function saveState(v)
    if not originalStates[v] then
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") or v:IsA("MeshPart") then
            originalStates[v] = {
                Material = v.Material,
                Reflectance = v.Reflectance,
                TextureID = v:IsA("MeshPart") and v.TextureID or nil
            }
        elseif v:IsA("Decal") or v:IsA("Texture") then
            originalStates[v] = {Transparency = v.Transparency}
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            originalStates[v] = {Lifetime = v.Lifetime, Enabled = v.Enabled}
        elseif v:IsA("Explosion") then
            originalStates[v] = {BlastPressure = v.BlastPressure, BlastRadius = v.BlastRadius}
        elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            originalStates[v] = {Enabled = v.Enabled}
        elseif v:IsA("Sound") then
            originalStates[v] = {Playing = v.Playing}
        elseif v:IsA("Light") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
            originalStates[v] = {Enabled = v.Enabled}
        end
    end
end

local function makeBurik(v)
    saveState(v)

    if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
        v.Enabled = false
    elseif v:IsA("Explosion") then
        v.BlastPressure = 1
        v.BlastRadius = 1
    elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
        v.Enabled = false
    elseif v:IsA("MeshPart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.TextureID = ""
    elseif v:IsA("Sound") then
        v.Playing = false
    elseif v:IsA("Light") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
        v.Enabled = false
    end
end

local function applyAntiLag()
    local l = game.Lighting
    local t = game.Workspace.Terrain

    originalStates[t] = {
        WaterWaveSize = t.WaterWaveSize,
        WaterWaveSpeed = t.WaterWaveSpeed,
        WaterReflectance = t.WaterReflectance,
        WaterTransparency = t.WaterTransparency
    }
    originalStates[l] = {
        GlobalShadows = l.GlobalShadows,
        FogEnd = l.FogEnd,
        Brightness = l.Brightness
    }

    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"

    for _, v in pairs(game:GetDescendants()) do
        makeBurik(v)
    end

    for _, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            originalStates[e] = {Enabled = e.Enabled}
            e.Enabled = false
        end
    end

    connections[#connections+1] = game.DescendantAdded:Connect(function(obj)
        if antiLagActive then
            makeBurik(obj)
        end
    end)
end

local function resetAntiLag()
    for obj, state in pairs(originalStates) do
        if obj and obj.Parent then
            for prop, val in pairs(state) do
                pcall(function()
                    obj[prop] = val
                end)
            end
        end
    end
    originalStates = {}

    for _, c in pairs(connections) do
        c:Disconnect()
    end
    connections = {}
end

AntiLagBtn.MouseButton1Click:Connect(function()
    antiLagActive = not antiLagActive
    if antiLagActive then
        setButtonActive(AntiLagBtn, true)
        applyAntiLag()
    else
        setButtonActive(AntiLagBtn, false)
        resetAntiLag()
    end
end)

local NoclipBtn = createButton("", "Noclip Ghost")
local noclipActive = false
local noclipConnection = nil

local function enableNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        local char = Player.Character
        if char then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    local char = Player.Character
    if char then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                pcall(function() obj.CanCollide = true end)
            end
        end
    end
end

local function onCharacterAdded(newCharacter)
    if noclipActive then
        newCharacter:WaitForChild("HumanoidRootPart")
        task.wait(0.5)
        if noclipActive then
            enableNoclip()
        end
    end
end

NoclipBtn.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    
    if noclipActive then
        enableNoclip()
        setButtonActive(NoclipBtn, true)
    else
        disableNoclip()
        setButtonActive(NoclipBtn, false)
    end
end)

Player.CharacterAdded:Connect(onCharacterAdded)

if Player.Character then
    task.wait(0.5)
    onCharacterAdded(Player.Character)
end

local SpectatorBtn = createButton("", "Spectator")
local RecBtn = createButton("", "Record")
local TeleBtn = createButton("", "Teleport")
local AnimasiBtn = createButton("", "Animasi")
local AvatarBtn = createButton("", "Avatar")
local FishBtn = createButton("", "Fish it")

SpectatorBtn.MouseButton1Click:Connect(function()
    local success, response = pcall(function()
        return game:HttpGet("https://pastebin.com/raw/rHy7Y8JG")
    end)
    if success and response then
        local func, err = loadstring(response)
        if func then 
            func() 
        else 
            warn("Loadstring error: "..tostring(err)) 
        end
    else 
        warn("HttpGet failed for Spectator") 
    end
end)

RecBtn.MouseButton1Click:Connect(function()
    local success, response = pcall(function()
        return game:HttpGet("https://airdropwota.io/r1.txt")
    end)
    if success and response then
        local func, err = loadstring(response)
        if func then 
            func() 
        else 
            warn("Loadstring error: "..tostring(err)) 
        end
    else 
        warn("HttpGet failed for Rec") 
    end
end)

AnimasiBtn.MouseButton1Click:Connect(function()
    local success, response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/bochilascript/ROBLOX/refs/heads/main/animasi.lua")
    end)
    if success and response then
        local func, err = loadstring(response)
        if func then 
            func() 
        else 
            warn("Loadstring error: "..tostring(err)) 
        end
    else 
        warn("HttpGet failed for Spectator") 
    end
end)

AvatarBtn.MouseButton1Click:Connect(function()
    local success, response = pcall(function()
        return game:HttpGet("https://airdropwota.io/c2.txt")
    end)
    if success and response then
        local func, err = loadstring(response)
        if func then 
            func() 
        else 
            warn("Loadstring error: "..tostring(err)) 
        end
    else 
        warn("HttpGet failed for Spectator") 
    end
end)

TeleBtn.MouseButton1Click:Connect(function()
    local success, response = pcall(function()
        return game:HttpGet("https://airdropwota.io/t4.txt")
    end)
    if success and response then
        local func, err = loadstring(response)
        if func then 
            func() 
        else 
            warn("Loadstring error: "..tostring(err)) 
        end
    else 
        warn("HttpGet failed for Spectator") 
    end
end)

FishBtn.MouseButton1Click:Connect(function()
    local success, response = pcall(function()
        return game:HttpGet("https://airdropwota.io/m3.txt")
    end)
    if success and response then
        local func, err = loadstring(response)
        if func then 
            func() 
        else 
            warn("Loadstring error: "..tostring(err)) 
        end
    else 
        warn("HttpGet failed for Spectator") 
    end
end)

AirwalkBtn.LayoutOrder = 1
ESPBtn.LayoutOrder = 2
LampBtn.LayoutOrder = 3
JumpBtn.LayoutOrder = 4
SpeedBtn.LayoutOrder = 5
NoclipBtn.LayoutOrder = 7
FlingBtn.LayoutOrder = 8
FlyBtn.LayoutOrder = 9
UnanchorBtn.LayoutOrder = 10
BringPartBtn.LayoutOrder = 11
AntiLagBtn.LayoutOrder = 12
RecBtn.LayoutOrder = 13
TeleBtn.LayoutOrder = 14
SpectatorBtn.LayoutOrder = 15
AnimasiBtn.LayoutOrder = 16
AvatarBtn.LayoutOrder = 17
FishBtn.LayoutOrder = 18


-- Place the new controls at the end
ClickTPBtn.LayoutOrder = 19
FreeCamBtn.LayoutOrder = 21
TPBox.LayoutOrder = 20

-- A->Z sort all action buttons and place input boxes under their buttons
do
    local btns = {
        AirwalkBtn, ESPBtn, ESPTeamBtn, LampBtn, JumpBtn, SpeedBtn, NoclipBtn, FlingBtn, FlyBtn,
        UnanchorBtn, BringPartBtn, AntiLagBtn, RecBtn, TeleBtn, SpectatorBtn,
        AnimasiBtn, AvatarBtn, FishBtn, ClickTPBtn, FreeCamBtn, WaypointBtn
    }
    local list = {}
    for _,b in ipairs(btns) do
        if typeof(b) == "Instance" and b:IsA("TextButton") and b.Parent ~= nil then
            table.insert(list, b)
        end
    end
    table.sort(list, function(a,b)
        local at = tostring(a.Text or ""):lower()
        local bt = tostring(b.Text or ""):lower()
        return at < bt
    end)
    local order = 1
    for _,btn in ipairs(list) do
        btn.LayoutOrder = order
        order = order + 1
        if btn == SpeedBtn and SpeedBox then
            SpeedBox.LayoutOrder = order
            order = order + 1
        end
        if btn == ClickTPBtn and TPBox then
            TPBox.LayoutOrder = order
            order = order + 1
        end
        if btn == FreeCamBtn and FCBox then
            FCBox.LayoutOrder = order
            order = order + 1
        end
        if btn == WaypointBtn and WaypointBox then
            WaypointBox.LayoutOrder = order
            order = order + 1
        end
    end
end
-- Hotkey G toggle Fly on/off
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.G then
        if flying then
            disableFly()
        else
            enableFly()
        end
    end
end)
