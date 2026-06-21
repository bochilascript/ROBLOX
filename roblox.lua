local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local showCommandsWindow
local showCmdBar
local CmdsFrame
local togglePlayerListWindow

currentCategory = "Menu"
customWaypoints = {}
customWPButtons = {}
currentPlaceId = tostring(game.PlaceId)

function saveCustomWaypoints()  
    pcall(function()
        if writefile then
            local allData = {}
            if isfile and isfile("ch_waypoints.json") then
                local content = readfile("ch_waypoints.json")
                if content then
                    local ok, decoded = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
                    if ok and type(decoded) == "table" then
                        allData = decoded
                    end
                end
            end
            allData[currentPlaceId] = customWaypoints
            writefile("ch_waypoints.json", game:GetService("HttpService"):JSONEncode(allData))
        end
    end)
end

function loadCustomWaypoints()
    customWaypoints = {}
    local success, content = pcall(function()
        if isfile and isfile("ch_waypoints.json") then
            return readfile("ch_waypoints.json")
        end
    end)
    if success and content then
        local ok, data = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
        if ok and type(data) == "table" then
            local isOldFormat = false
            for k, v in pairs(data) do
                if type(v) == "table" and #v > 0 and type(v[1]) == "number" then
                    isOldFormat = true
                    break
                end
            end
            if isOldFormat then
                local migrated = {}
                for k, v in pairs(data) do
                    if type(v) == "table" and #v > 0 and type(v[1]) == "number" then
                        migrated[k] = v
                    end
                end
                customWaypoints = migrated
                pcall(function()
                    if writefile then
                        local allData = {}
                        allData[currentPlaceId] = customWaypoints
                        writefile("ch_waypoints.json", game:GetService("HttpService"):JSONEncode(allData))
                    end
                end)
            else
                local mapWPs = data[currentPlaceId]
                if type(mapWPs) == "table" then
                    customWaypoints = mapWPs
                end
            end
        end
    end
end

local existingGui = PlayerGui:FindFirstChild("CHCheatGUI")
if existingGui then
    pcall(function() existingGui:Destroy() end)
end

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
MainFrame.Size = UDim2.new(0, 600, 0, 340)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
-- Hotkey toggle (left bracket) untuk show/hide GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.LeftBracket then
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

CmdsFrame = Instance.new("Frame")
CmdsFrame.Name = "CmdsFrame"
CmdsFrame.Size = UDim2.new(1, 0, 1, 0)
CmdsFrame.Visible = false
CmdsFrame.BackgroundTransparency = 1
CmdsFrame.Parent = ButtonsFrame

local CreditsFrame = Instance.new("Frame")
CreditsFrame.Name = "CreditsFrame"
CreditsFrame.Size = UDim2.new(1, 0, 1, 0)
CreditsFrame.Visible = false
CreditsFrame.BackgroundTransparency = 1
CreditsFrame.Parent = ButtonsFrame

-- Left quick panel under profile picture
do
    local QuickPanel = Instance.new("ScrollingFrame")
    QuickPanel.Name = "QuickPanel"
    QuickPanel.Size = UDim2.new(1, -10, 1, -105)
    QuickPanel.Position = UDim2.new(0, 5, 0, 100)
    QuickPanel.BackgroundTransparency = 1
    QuickPanel.BorderSizePixel = 0
    QuickPanel.ScrollBarThickness = 3
    QuickPanel.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
    QuickPanel.ScrollingDirection = Enum.ScrollingDirection.Y
    QuickPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
    QuickPanel.Parent = ProfileContent

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = QuickPanel

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        QuickPanel.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    local function makeSmallBtn(text, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 28)
        btn.LayoutOrder = order
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
    local utilityKeywords = {"free cam","freecam","click tp","clicktp","speed","save wp","savewp","swp"}
    local function matchesAny(text, keywords)
        local lower = string.lower(text)
        for _, k in ipairs(keywords) do
            if string.find(lower, k, 1, true) then return true end
        end
        return false
    end

    local function getChunks(s)
        local chunks = {}
        local pos = 1
        while pos <= #s do
            local startD, endD = string.find(s, "^%d+", pos)
            if startD then
                table.insert(chunks, tonumber(string.sub(s, startD, endD)) or 0)
                pos = endD + 1
            else
                local startND, endND = string.find(s, "^[^%d]+", pos)
                if startND then
                    table.insert(chunks, string.sub(s, startND, endND))
                    pos = endND + 1
                else
                    break
                end
            end
        end
        return chunks
    end

    local function naturalCompare(aStr, bStr)
        local aName, bName = tostring(aStr):lower(), tostring(bStr):lower()
        if aName == bName then return tostring(aStr) < tostring(bStr) end
        
        local aChunks = getChunks(aName)
        local bChunks = getChunks(bName)
        
        for i = 1, math.min(#aChunks, #bChunks) do
            local ac, bc = aChunks[i], bChunks[i]
            if typeof(ac) ~= typeof(bc) then
                return typeof(ac) == "number"
            elseif ac ~= bc then
                return ac < bc
            end
        end
        return #aChunks < #bChunks
    end

    setCategory = function(cat)
        currentCategory = cat
        for _, child in ipairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if cat == "Menu" then
                    -- show only items that are NOT in Rusuh or Utility
                    child.Visible = (not matchesAny(child.Text, rusuhKeywords))
                    and (not matchesAny(child.Text, utilityKeywords))
                    and (child:GetAttribute("IsFixedWP") ~= true)
                elseif cat == "Rusuh" then
                    child.Visible = matchesAny(child.Text, rusuhKeywords)
                else
                    child.Visible = false
                end
            elseif child:IsA("TextBox") then
                child.Visible = false
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
            -- Show UtilityFrame and hide ScrollFrame/CmdsFrame
            ScrollFrame.Visible = false
            CmdsFrame.Visible = false
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
            if not spdBox then
                for _, ch in ipairs(ScrollFrame:GetChildren()) do
                    if ch:IsA("TextBox") and string.lower(tostring(ch.PlaceholderText)) == "speed" then spdBox = ch break end
                end
            end
            local swpBtn   = UtilityScroll:FindFirstChild("SWPBtn")   or ScrollFrame:FindFirstChild("SWPBtn") or findBtn("Save WP")
            local swpBox   = UtilityScroll:FindFirstChild("SWPBox")   or ScrollFrame:FindFirstChild("SWPBox")

            local function moveToUtil(child, order)
                if child then child.Parent = UtilityScroll child.Visible = true child.LayoutOrder = order end
            end
            moveToUtil(clickBtn, 1); moveToUtil(tpBox, 2)
            moveToUtil(freeBtn, 3);  moveToUtil(fcBox, 4)
            moveToUtil(spdBtn, 5);   moveToUtil(spdBox, 6)
            moveToUtil(swpBtn, 7);   moveToUtil(swpBox, 8)
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
            elseif cat == "Waypoints" then
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

            -- Urutkan dengan natural sort (abjad & nomor berurutan)
            table.sort(fixed, function(a, b)
                return naturalCompare(a.Text or "", b.Text or "")
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
                restore("TPBox"); restore("FCBox"); restore("SpeedBox"); restore("SWPBox")
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
            if cat == "Commands" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = true
                CreditsFrame.Visible = false
            elseif cat == "Credits" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = false
                CreditsFrame.Visible = true
            else
                CmdsFrame.Visible = false
                CreditsFrame.Visible = false
                ScrollFrame.Visible = true
            end
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
            if not spdBox then
                for _, ch in ipairs(ScrollFrame:GetChildren()) do
                    if ch:IsA("TextBox") and string.lower(tostring(ch.PlaceholderText)) == "speed" then
                        spdBox = ch; break
                    end
                end
            end
            local swpBtn  = findButtonByText("Save WP")
            local swpBox  = ScrollFrame:FindFirstChild("SWPBox")
            local ordered = {clickBtn, tpBox, freeBtn, fcBox, spdBtn, spdBox, swpBtn, swpBox}
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

    createCreditsWindow = function()
        if CreditsFrame:FindFirstChild("CreditsScroll") then return end
        
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "CreditsScroll"
        scrollFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 150)
        scrollFrame.Parent = CreditsFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = scrollFrame

        local creditsList = {
            { title = "Github", value = "Github: https://github.com/bochilascript", url = "https://github.com/bochilascript" },
            { title = "Telegram Channel", value = "Telegram: https://t.me/pocketedition09", url = "https://t.me/pocketedition09" }
        }

        for idx, cred in ipairs(creditsList) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Name = "CredItem"
            itemFrame.Size = UDim2.new(1, -8, 0, 48)
            itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            itemFrame.LayoutOrder = idx
            itemFrame.Parent = scrollFrame

            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 6)
            itemCorner.Parent = itemFrame

            local dot = Instance.new("Frame")
            dot.Name = "Dot"
            dot.Size = UDim2.new(0, 6, 0, 6)
            dot.Position = UDim2.new(0, 8, 0, 12)
            dot.BackgroundColor3 = Color3.fromRGB(0, 220, 130)
            dot.BorderSizePixel = 0
            dot.Parent = itemFrame
            local dotCorner = Instance.new("UICorner")
            dotCorner.CornerRadius = UDim.new(1, 0)
            dotCorner.Parent = dot

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -70, 0, 20)
            titleLabel.Position = UDim2.new(0, 22, 0, 4)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.TextSize = 12
            titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            titleLabel.Text = cred.title
            titleLabel.Parent = itemFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(1, -70, 0, 18)
            valueLabel.Position = UDim2.new(0, 22, 0, 24)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextXAlignment = Enum.TextXAlignment.Left
            valueLabel.TextSize = 10
            valueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            valueLabel.Text = cred.value
            valueLabel.Parent = itemFrame

            local copyBtn = Instance.new("TextButton")
            copyBtn.Size = UDim2.new(0, 50, 0, 28)
            copyBtn.Position = UDim2.new(1, -58, 0.5, -14)
            copyBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
            copyBtn.Text = "Copy"
            copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            copyBtn.Font = Enum.Font.GothamBold
            copyBtn.TextSize = 11
            copyBtn.Parent = itemFrame

            local copyCorner = Instance.new("UICorner")
            copyCorner.CornerRadius = UDim.new(0, 4)
            copyCorner.Parent = copyBtn

            copyBtn.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(cred.url)
                    copyBtn.Text = "Copied!"
                    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
                    task.delay(1.5, function()
                        copyBtn.Text = "Copy"
                        copyBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
                    end)
                end
            end)
        end
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
    local btnWaypoints = makeSmallBtn("Waypoints", 4)
    btnWaypoints.MouseButton1Click:Connect(function()
        setCategory("Waypoints")
    end)

    local btnCommands = makeSmallBtn("Commands", 5)
    btnCommands.MouseButton1Click:Connect(function()
        if showCommandsWindow then
            showCommandsWindow()
        else
            setCategory("Commands")
        end
    end)

    local btnPlayers = makeSmallBtn("Players", 5.5)
    btnPlayers.MouseButton1Click:Connect(function()
        if togglePlayerListWindow then
            togglePlayerListWindow()
        end
    end)

    local btnCredits = makeSmallBtn("Credits", 6)
    btnCredits.MouseButton1Click:Connect(function()
        createCreditsWindow()
        setCategory("Credits")
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
TitleLabel.Text = "BY PIXECUTE"
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
MiniFrame.Image = "https://files.catbox.moe/61e1tk.webp"
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
    local url = "https://files.catbox.moe/61e1tk.webp"
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

-- Custom Waypoints Container (Mancing)
do
    local function makeCustomWPBtn(name, comps)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 150, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.BackgroundTransparency = 0.1
        btn.Text = name
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(0, 220, 130) -- Green text for custom waypoints
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn:SetAttribute("IsFixedWP", true)
        btn:SetAttribute("IsCustomWP", true)
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
        
        -- Delete button
        local del = Instance.new("TextButton")
        del.Size = UDim2.new(0, 18, 0, 18)
        del.Position = UDim2.new(1, -26, 0.5, -9)
        del.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        del.Text = "x"
        del.TextColor3 = Color3.fromRGB(255, 255, 255)
        del.Font = Enum.Font.GothamBold
        del.TextSize = 12
        del.ZIndex = 5
        del.Parent = btn
        
        local delCorner = Instance.new("UICorner")
        delCorner.CornerRadius = UDim.new(0, 4)
        delCorner.Parent = del
        
        del.MouseButton1Click:Connect(function()
            customWaypoints[name] = nil
            saveCustomWaypoints()
            btn:Destroy()
            
            for idx, button in ipairs(customWPButtons) do
                if button == btn then
                    table.remove(customWPButtons, idx)
                    break
                end
            end
            
            task.defer(function()
                if currentCategory == "Waypoints" then
                    setCategory("Waypoints")
                end
            end)
        end)
        
        table.insert(customWPButtons, btn)
        return btn
    end

    local function refreshCustomWaypointButtons()
        for _, btn in ipairs(customWPButtons) do
            pcall(function() btn:Destroy() end)
        end
        customWPButtons = {}
        for name, comps in pairs(customWaypoints) do
            if type(comps) == "table" then
                makeCustomWPBtn(name, comps)
            end
        end
    end
    
    saveCurrentPositionAsWaypoint = function(name)
        if not name or name == "" then return end
        local lp = game:GetService("Players").LocalPlayer
        local char = lp.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        if not root then return end
        
        local components = {root.CFrame:GetComponents()}
        customWaypoints[name] = components
        saveCustomWaypoints()
        
        makeCustomWPBtn(name, components)
        
        task.defer(function()
            if currentCategory == "Waypoints" then
                setCategory("Waypoints")
            end
        end)
    end
    
    loadCustomWaypoints()
    refreshCustomWaypointButtons()
end

CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    pcall(function()
        local targetParent = (typeof(gethui) == "function" and gethui())
            or (typeof(get_hidden_gui) == "function" and get_hidden_gui())
            or game:GetService("CoreGui")
            or PlayerGui
        if targetParent then
            local bar = targetParent:FindFirstChild("CHCmdBarGUI")
            if bar then bar:Destroy() end
        end
    end)
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
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 340)})
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

AirwalkBtn = createButton("", "Jalan di udara")

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

function toggleAirwalk(state)
    if state == nil then
        AirwalkActive = not AirwalkActive
    else
        AirwalkActive = state
    end
    if AirwalkActive then
        StartAirwalk()
        setButtonActive(AirwalkBtn, true)
    else
        StopAirwalk()
        setButtonActive(AirwalkBtn, false)
    end
end

AirwalkBtn.MouseButton1Click:Connect(function()
    toggleAirwalk()
end)

LocalPlayer.CharacterAdded:Connect(function()
    StopAirwalk()
    setButtonActive(AirwalkBtn, false)
end)

ESPBtn = createButton("", "ESP")
ESPTeamBtn = createButton("", "ESP Team")
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
        billboard.MaxDistance = math.huge

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

function toggleESP(state)
    if state == nil then
        ESPenabled = not ESPenabled
    else
        ESPenabled = state
    end
    if ESPenabled then
        ESPTeamMode = false
        setButtonActive(ESPBtn, true)
        setButtonActive(ESPTeamBtn, false)
        startESP()
    else
        setButtonActive(ESPBtn, false)
        stopESP()
    end
end

function toggleESPTeam(state)
    local newState
    if state == nil then
        newState = not (ESPenabled and ESPTeamMode)
    else
        newState = state
    end
    if newState then
        ESPTeamMode = true
        if not ESPenabled then
            ESPenabled = true
        else
            stopESP()
        end
        setButtonActive(ESPTeamBtn, true)
        setButtonActive(ESPBtn, false)
        startESP()
    else
        setButtonActive(ESPTeamBtn, false)
        ESPenabled = false
        ESPTeamMode = false
        stopESP()
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    toggleESP()
end)

ESPTeamBtn.MouseButton1Click:Connect(function()
    toggleESPTeam()
end)

local Player = game.Players.LocalPlayer

LampBtn = createButton("", "Lampu")
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

function toggleLampu(state)
    if state == nil then
        lampOn = not lampOn
    else
        lampOn = state
    end
    local char = Player.Character or Player.CharacterAdded:Wait()
    if lampOn then
        addHeadLamp(char)
        setButtonActive(LampBtn, true)
    else
        removeHeadLamp()
        setButtonActive(LampBtn, false)
    end
end

LampBtn.MouseButton1Click:Connect(function()
    toggleLampu()
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

JumpBtn = createButton("", "Infinite Jump")

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

function toggleInfiniteJump(state)
    if state == nil then
        infiniteJumpEnabled = not infiniteJumpEnabled
    else
        infiniteJumpEnabled = state
    end
    setButtonActive(JumpBtn, infiniteJumpEnabled)
end

JumpBtn.MouseButton1Click:Connect(function()
    toggleInfiniteJump()
end)

-- Helper to auto re-execute script on teleport / rejoin
local function queueTeleport()
    local qot = (syn and syn.queue_on_teleport) or queue_on_teleport
    if qot then
        pcall(function()
            qot([[loadstring(game:HttpGet("https://pastebin.com/raw/zh4yDg0Q"))()]])
        end)
    end
end

-- Rejoin button (Menu): rejoin same server if possible, else rejoin place
RejoinBtn = createButton("", "Rejoin")
RejoinBtn.LayoutOrder = 1
function rejoinServer()
    local player = game:GetService("Players").LocalPlayer
    local ts = game:GetService("TeleportService")
    local currentPlaceId = game.PlaceId
    local currentJobId = game.JobId
    queueTeleport()
    local ok = pcall(function()
        ts:TeleportToPlaceInstance(currentPlaceId, currentJobId, player)
    end)
    if not ok then
        pcall(function()
            ts:Teleport(currentPlaceId, player)
        end)
    end
end
RejoinBtn.MouseButton1Click:Connect(rejoinServer)

-- Refresh button (Menu): respawn the character quickly
RefreshBtn = createButton("", "Refresh")
RefreshBtn.LayoutOrder = 2

-- Anti AFK (Menu)
AntiAFKBtn = createButton("", "Anti AFK")
AntiAFKBtn.LayoutOrder = 3
local antiAFKConnection = nil

function refreshCharacter()
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
end
RefreshBtn.MouseButton1Click:Connect(refreshCharacter)

function toggleAntiAFK(state)
    local targetState
    if state == nil then
        targetState = not antiAFKConnection
    else
        targetState = state
    end
    if not targetState then
        if antiAFKConnection then
            antiAFKConnection:Disconnect()
            antiAFKConnection = nil
        end
        setButtonActive(AntiAFKBtn, false)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="Anti AFK", Text="Dinonaktifkan", Duration=3})
        end)
    else
        if not antiAFKConnection then
            local VirtualUser = game:GetService("VirtualUser")
            antiAFKConnection = game.Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
        setButtonActive(AntiAFKBtn, true)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {Title="Anti AFK", Text="Aktif", Duration=3})
        end)
    end
end
AntiAFKBtn.MouseButton1Click:Connect(function()
    toggleAntiAFK()
end)

local httpService = game:GetService("HttpService")
local teleportService = game:GetService("TeleportService")
local placeId = game.PlaceId
local jobId = game.JobId

local ServerHopGui = nil
local function createServerHopWindow()
    if ServerHopGui then
        ServerHopGui.Visible = not ServerHopGui.Visible
        return
    end

    local guiParent = nil
    local ok = pcall(function()
        if typeof(gethui) == "function" then guiParent = gethui()
        elseif typeof(get_hidden_gui) == "function" then guiParent = get_hidden_gui()
        elseif game:GetService("CoreGui") then guiParent = game:GetService("CoreGui")
        else guiParent = PlayerGui end
    end)
    if not guiParent then guiParent = PlayerGui end

    local sgui = Instance.new("ScreenGui")
    sgui.Name = "ServerHopGui"
    sgui.ResetOnSpawn = false
    sgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sgui.Parent = guiParent

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 340, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -170, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = sgui
    ServerHopGui = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 8)
    topCorner.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Server List"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 30, 0, 30)
    refreshBtn.Position = UDim2.new(1, -60, 0, 0)
    refreshBtn.BackgroundTransparency = 1
    refreshBtn.Text = "R"
    refreshBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
    refreshBtn.TextSize = 16
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.Parent = topBar

    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(1, -20, 0, 40)
    infoFrame.Position = UDim2.new(0, 10, 0, 35)
    infoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = mainFrame

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoFrame

    local placeIdLabel = Instance.new("TextLabel")
    placeIdLabel.Size = UDim2.new(1, -10, 0, 20)
    placeIdLabel.Position = UDim2.new(0, 8, 0, 2)
    placeIdLabel.BackgroundTransparency = 1
    placeIdLabel.Font = Enum.Font.Gotham
    placeIdLabel.TextSize = 11
    placeIdLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    placeIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    placeIdLabel.Text = "Place ID: " .. tostring(placeId)
    placeIdLabel.Parent = infoFrame

    local jobIdLabel = Instance.new("TextButton")
    jobIdLabel.Size = UDim2.new(1, -10, 0, 18)
    jobIdLabel.Position = UDim2.new(0, 8, 0, 20)
    jobIdLabel.BackgroundTransparency = 1
    jobIdLabel.Font = Enum.Font.Gotham
    jobIdLabel.TextSize = 10
    jobIdLabel.TextColor3 = Color3.fromRGB(0, 220, 130)
    jobIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local cleanJobId = tostring(game.JobId)
    if cleanJobId ~= "" then
        if #cleanJobId > 16 then
            jobIdLabel.Text = "Job ID (Click to Copy): " .. string.sub(cleanJobId, 1, 8) .. "..." .. string.sub(cleanJobId, -8)
        else
            jobIdLabel.Text = "Job ID (Click to Copy): " .. cleanJobId
        end
    else
        jobIdLabel.Text = "Job ID (Click to Copy): Loading..."
    end
    jobIdLabel.Parent = infoFrame

    jobIdLabel.MouseButton1Click:Connect(function()
        if setclipboard then
            local currentJobId = tostring(game.JobId)
            if currentJobId ~= "" then
                setclipboard(currentJobId)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "JobId Copied!",
                    Text = "Server Job ID has been copied to clipboard.",
                    Duration = 3
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "JobId Error",
                    Text = "Job ID is not loaded yet.",
                    Duration = 3
                })
            end
        end
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -85)
    scroll.Position = UDim2.new(0, 10, 0, 80)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = scroll

    local function refreshServers()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
        end

        local loading = Instance.new("TextLabel")
        loading.Size = UDim2.new(1, 0, 0, 30)
        loading.BackgroundTransparency = 1
        loading.Text = "Loading servers..."
        loading.TextColor3 = Color3.fromRGB(200, 200, 200)
        loading.Font = Enum.Font.Gotham
        loading.TextSize = 14
        loading.Parent = scroll
        
        task.spawn(function()
            local currentPlaceId = tostring(game.PlaceId)
            local currentJobId = tostring(game.JobId)

            -- Update info labels in case JobId loaded late
            pcall(function()
                placeIdLabel.Text = "Place ID: " .. currentPlaceId
                if currentJobId ~= "" then
                    if #currentJobId > 16 then
                        jobIdLabel.Text = "Job ID (Click to Copy): " .. string.sub(currentJobId, 1, 8) .. "..." .. string.sub(currentJobId, -8)
                    else
                        jobIdLabel.Text = "Job ID (Click to Copy): " .. currentJobId
                    end
                else
                    jobIdLabel.Text = "Job ID (Click to Copy): Loading..."
                end
            end)

            local success, result = pcall(function()
                return game:HttpGetAsync("https://games.roblox.com/v1/games/" .. currentPlaceId .. "/servers/Public?sortOrder=Desc&limit=100")
            end)

            loading:Destroy()

            if success and result then
                local ok, data = pcall(function() return httpService:JSONDecode(result).data end)
                if ok and data then
                    -- Check if our current server is in the fetched list
                    local hasCurrent = false
                    if currentJobId ~= "" then
                        for _, v in ipairs(data) do
                            if type(v) == "table" and v.id == currentJobId then
                                hasCurrent = true
                                break
                            end
                        end
                    end
                    
                    -- If our server is not in the API list, manually insert it at the very top
                    if not hasCurrent and currentJobId ~= "" then
                        table.insert(data, 1, {
                            id = currentJobId,
                            playing = #game.Players:GetPlayers(),
                            maxPlayers = game.Players.MaxPlayers,
                            ping = 99
                        })
                    end

                    local count = 0
                    for _, v in ipairs(data) do
                        if type(v) == "table" and v.playing and v.maxPlayers and (v.id == currentJobId or v.playing < v.maxPlayers) then
                            local isCurrent = (v.id == currentJobId)
                            count = count + 1
                            local sBtn = Instance.new("TextButton")
                            sBtn.Size = UDim2.new(1, -10, 0, 35)
                            if isCurrent then
                                sBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
                                sBtn.Text = string.format("Server %d (YOU) | Players: %d/%d | Ping: %s", count, v.playing, v.maxPlayers, tostring(v.ping or "?"))
                                sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            else
                                sBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                                sBtn.Text = string.format("Server %d | Players: %d/%d | Ping: %s", count, v.playing, v.maxPlayers, tostring(v.ping or "?"))
                                sBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                            end
                            sBtn.Font = Enum.Font.Gotham
                            sBtn.TextSize = 12
                            sBtn.Parent = scroll

                            local sCorner = Instance.new("UICorner")
                            sCorner.CornerRadius = UDim.new(0, 6)
                            sCorner.Parent = sBtn

                            if not isCurrent then
                                sBtn.MouseButton1Click:Connect(function()
                                    sBtn.Text = "Joining..."
                                    sBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
                                    queueTeleport()
                                    teleportService:TeleportToPlaceInstance(currentPlaceId, v.id)
                                end)
                            end
                        end
                    end
                    scroll.CanvasSize = UDim2.new(0, 0, 0, count * 40)
                end
            end
        end)
    end

    refreshBtn.MouseButton1Click:Connect(refreshServers)
    refreshServers()

    -- Basic dragging functionality
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function serverhop()
    createServerHopWindow()
end

-- ==========================================
-- PLAYER LIST GUI & FUNCTIONS (BY ANTIGRAVITY)
-- ==========================================
local PlayerListFrame = nil
local PlayerListScroll = nil
local PlayerListSearchBox = nil
local currentSpectateTarget = nil
local playerConnections = {}
local refreshPlayerList
local updateCanvasSize

updateCanvasSize = function()
    if not PlayerListScroll then return end
    local height = 10
    for _, item in ipairs(PlayerListScroll:GetChildren()) do
        if item:IsA("Frame") and item.Name == "PlayerItem" then
            height = height + item.Size.Y.Offset + 5
        end
    end
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, height)
end

local function getPlayerThumbnail(targetUserId)
    local success, result = pcall(function()
        return game:GetService("Players"):GetUserThumbnailAsync(targetUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if success and result then
        return result
    end
    return "rbxasset://textures/ui/avatar_placeholder.png"
end

local function createPlayerRow(targetPlayer, index)
    local row = Instance.new("Frame")
    row.Name = "PlayerItem"
    row.Size = UDim2.new(1, -8, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    row.LayoutOrder = index
    row.Parent = PlayerListScroll

    local rowCorner = Instance.new("UICorner")
    rowCorner.CornerRadius = UDim.new(0, 6)
    rowCorner.Parent = row

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = Color3.fromRGB(40, 40, 45)
    rowStroke.Thickness = 1
    rowStroke.Parent = row

    -- Avatar Thumbnail
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 36, 0, 36)
    avatar.Position = UDim2.new(0, 8, 0, 7)
    avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    avatar.BorderSizePixel = 0
    avatar.Image = "rbxasset://textures/ui/avatar_placeholder.png"
    avatar.Parent = row

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatar

    task.spawn(function()
        local img = getPlayerThumbnail(targetPlayer.UserId)
        if avatar and avatar.Parent then
            avatar.Image = img
        end
    end)

    -- Player Labels Container
    local info = Instance.new("Frame")
    info.Name = "Info"
    info.Size = UDim2.new(1, -178, 0, 42)
    info.Position = UDim2.new(0, 52, 0, 4)
    info.BackgroundTransparency = 1
    info.Parent = row

    local dispLabel = Instance.new("TextLabel")
    dispLabel.Size = UDim2.new(1, 0, 0.5, 0)
    dispLabel.BackgroundTransparency = 1
    dispLabel.Font = Enum.Font.GothamBold
    dispLabel.TextSize = 12
    dispLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dispLabel.TextXAlignment = Enum.TextXAlignment.Left
    dispLabel.Text = targetPlayer.DisplayName
    dispLabel.Parent = info

    local userLabel = Instance.new("TextLabel")
    userLabel.Size = UDim2.new(1, 0, 0.5, 0)
    userLabel.Position = UDim2.new(0, 0, 0.5, 0)
    userLabel.BackgroundTransparency = 1
    userLabel.Font = Enum.Font.Gotham
    userLabel.TextSize = 10
    userLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    userLabel.TextXAlignment = Enum.TextXAlignment.Left
    userLabel.Text = "@" .. targetPlayer.Name
    userLabel.Parent = info

    -- Action Buttons Container
    local btns = Instance.new("Frame")
    btns.Name = "Buttons"
    btns.Size = UDim2.new(0, 120, 0, 26)
    btns.Position = UDim2.new(1, -126, 0, 12)
    btns.BackgroundTransparency = 1
    btns.Parent = row

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Parent = btns

    -- Helper to create action buttons
    local function makeActBtn(text, color, strokeColor, order, sizeX)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, sizeX, 1, 0)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.LayoutOrder = order
        btn.Parent = btns

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn

        local s = Instance.new("UIStroke")
        s.Color = strokeColor
        s.Thickness = 1
        s.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(s, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(s, TweenInfo.new(0.15), {Color = strokeColor}):Play()
        end)

        return btn
    end

    -- TP Button
    local tpBtn = makeActBtn("TP", Color3.fromRGB(0, 130, 80), Color3.fromRGB(0, 200, 120), 1, 30)
    tpBtn.MouseButton1Click:Connect(function()
        local lplr = game.Players.LocalPlayer
        local char = lplr.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end

        local targetChar = targetPlayer.Character
        local targetHrp = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso"))
        
        if not targetHrp and targetChar then
            targetHrp = targetChar:FindFirstChildWhichIsA("BasePart", true)
        end

        if not targetHrp then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Teleport Gagal",
                    Text = "Karakter player target belum memuat di device Anda (terlalu jauh).",
                    Duration = 4
                })
            end)
            return
        end

        local startPos = hrp.Position
        local targetPos = targetHrp.Position
        local distance = (targetPos - startPos).Magnitude

        -- Jika jarak dekat (< 500 studs), langsung instant TP secara aman
        if distance < 500 then
            local previousAnchored = hrp.Anchored
            hrp.Anchored = true
            
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Teleporting...",
                    Text = "Menyiapkan map untuk " .. targetPlayer.DisplayName,
                    Duration = 2
                })
            end)

            char:PivotTo(targetHrp.CFrame * CFrame.new(0, 3, 0))
            
            -- Request streaming agar map termuat
            pcall(function()
                game.Players.LocalPlayer:RequestStreamAroundAsync(targetPos)
            end)
            
            task.wait(0.3)
            hrp.Anchored = previousAnchored

            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Teleport Sukses",
                    Text = "Teleport ke " .. targetPlayer.DisplayName .. " selesai.",
                    Duration = 3
                })
            end)
        else
            -- Jika jarak jauh (>= 500 studs), lakukan TpWalk (teleportasi bertahap) agar tidak dibatalkan server/anti-cheat
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Safe Teleport",
                    Text = string.format("Teleport bertahap berjalan... Jarak: %.0f studs", distance),
                    Duration = 4
                })
            end)

            -- Matikan sementara gravity dan velocity agar tidak terpengaruh fisika
            local oldGravity = workspace.Gravity
            workspace.Gravity = 0
            hrp.AssemblyLinearVelocity = Vector3.zero

            local speed = 300 -- studs per detik (aman dari kick/rubberband anti-cheat di kebanyakan game)
            local reached = false
            local connection
            
            connection = RunService.Heartbeat:Connect(function(dt)
                local myChar = lplr.Character
                local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
                local tChar = targetPlayer.Character
                local tHrp = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso") or tChar:FindFirstChild("UpperTorso"))
                
                if not tHrp and tChar then
                    tHrp = tChar:FindFirstChildWhichIsA("BasePart", true)
                end

                if not myHrp or not tHrp then
                    reached = true
                    connection:Disconnect()
                    workspace.Gravity = oldGravity
                    return
                end

                local curPos = myHrp.Position
                local destPos = tHrp.Position
                local dist = (destPos - curPos).Magnitude
                local dir = (destPos - curPos).Unit
                local step = speed * dt

                if dist <= step then
                    myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 3, 0)
                    reached = true
                    connection:Disconnect()
                    workspace.Gravity = oldGravity
                    pcall(function()
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Teleport Sukses",
                            Text = "Sampai di target secara aman.",
                            Duration = 3
                        })
                    end)
                else
                    myHrp.CFrame = CFrame.new(curPos + dir * step, destPos)
                    myHrp.AssemblyLinearVelocity = Vector3.zero
                end
            end)

            -- Safety timeout (jika macet)
            task.delay(15, function()
                if connection and connection.Connected then
                    connection:Disconnect()
                    workspace.Gravity = oldGravity
                    pcall(function()
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Teleport Timeout",
                            Text = "Proses teleport dibatalkan karena waktu habis.",
                            Duration = 3
                        })
                    end)
                end
            end)
        end
    end)

    -- View (Spectate) Button
    local isViewing = (currentSpectateTarget == targetPlayer)
    local viewBtnText = isViewing and "Stop" or "View"
    local viewBtnColor = isViewing and Color3.fromRGB(200, 80, 50) or Color3.fromRGB(0, 100, 150)
    local viewBtnStroke = isViewing and Color3.fromRGB(255, 120, 100) or Color3.fromRGB(0, 160, 220)
    
    local viewBtn = makeActBtn(viewBtnText, viewBtnColor, viewBtnStroke, 2, 38)
    viewBtn.MouseButton1Click:Connect(function()
        local camera = workspace.CurrentCamera
        if currentSpectateTarget == targetPlayer then
            currentSpectateTarget = nil
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                camera.CameraSubject = hum
            end
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Spectate",
                    Text = "Stopped spectating",
                    Duration = 3
                })
            end)
        else
            currentSpectateTarget = targetPlayer
            local char = targetPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                camera.CameraSubject = hum
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Spectate",
                        Text = "Viewing: " .. targetPlayer.DisplayName,
                        Duration = 3
                    })
                end)
            else
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Spectate Error",
                        Text = "Player character not found",
                        Duration = 3
                    })
                end)
            end
        end
        refreshPlayerList()
    end)

    -- Add Friend Button
    local isFriend = false
    pcall(function()
        isFriend = game.Players.LocalPlayer:IsFriendsWith(targetPlayer.UserId)
    end)

    local addBtn
    if isFriend then
        addBtn = makeActBtn("Teman", Color3.fromRGB(20, 20, 25), Color3.fromRGB(40, 40, 45), 3, 44)
        addBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
        addBtn.Active = false
    else
        addBtn = makeActBtn("Tambah", Color3.fromRGB(40, 40, 45), Color3.fromRGB(60, 60, 65), 3, 44)
        addBtn.MouseButton1Click:Connect(function()
            pcall(function()
                game:GetService("StarterGui"):SetCore("PromptSendFriendRequest", targetPlayer)
            end)
            addBtn.Text = "Proses"
            addBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            addBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            task.delay(3, function()
                if addBtn and addBtn.Parent then
                    local stillFriend = false
                    pcall(function()
                        stillFriend = game.Players.LocalPlayer:IsFriendsWith(targetPlayer.UserId)
                    end)
                    if stillFriend then
                        addBtn.Text = "Teman"
                        addBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
                        addBtn.Active = false
                        addBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                        local stroke = addBtn:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(40, 40, 45) end
                    else
                        addBtn.Text = "Tambah"
                        addBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                        addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    end
                end
            end)
        end)
    end

    -- Expanded Detail Area Frame
    local expandedFrame = Instance.new("Frame")
    expandedFrame.Name = "ExpandedArea"
    expandedFrame.Size = UDim2.new(1, -16, 0, 60)
    expandedFrame.Position = UDim2.new(0, 8, 0, 52)
    expandedFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    expandedFrame.BorderSizePixel = 0
    expandedFrame.Visible = false
    expandedFrame.Parent = row

    local exCorner = Instance.new("UICorner")
    exCorner.CornerRadius = UDim.new(0, 6)
    exCorner.Parent = expandedFrame

    local exStroke = Instance.new("UIStroke")
    exStroke.Color = Color3.fromRGB(30, 30, 35)
    exStroke.Thickness = 1
    exStroke.Parent = expandedFrame

    -- Left Details (Umur Akun & Tim)
    local detailInfo = Instance.new("Frame")
    detailInfo.Name = "DetailInfo"
    detailInfo.Size = UDim2.new(0, 100, 1, 0)
    detailInfo.Position = UDim2.new(0, 8, 0, 0)
    detailInfo.BackgroundTransparency = 1
    detailInfo.Parent = expandedFrame

    local ageLabel = Instance.new("TextLabel")
    ageLabel.Size = UDim2.new(1, 0, 0.5, 0)
    ageLabel.BackgroundTransparency = 1
    ageLabel.Font = Enum.Font.Gotham
    ageLabel.TextSize = 11
    ageLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ageLabel.TextXAlignment = Enum.TextXAlignment.Left
    local days = targetPlayer.AccountAge
    local ageText = ""
    if days < 30 then
        ageText = days .. " hari"
    elseif days < 365 then
        ageText = math.floor(days / 30) .. " bulan"
    else
        ageText = math.floor(days / 365.25) .. " tahun"
    end
    ageLabel.Text = "Umur: " .. ageText
    ageLabel.Parent = detailInfo

    local teamLabel = Instance.new("TextLabel")
    teamLabel.Size = UDim2.new(1, 0, 0.5, 0)
    teamLabel.Position = UDim2.new(0, 0, 0.5, 0)
    teamLabel.BackgroundTransparency = 1
    teamLabel.Font = Enum.Font.Gotham
    teamLabel.TextSize = 11
    teamLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    teamLabel.TextXAlignment = Enum.TextXAlignment.Left
    teamLabel.Text = "Tim: " .. (targetPlayer.Team and targetPlayer.Team.Name or "Tidak ada")
    teamLabel.Parent = detailInfo

    -- Right Action Buttons (Fling, ESP, Copy)
    local exBtns = Instance.new("Frame")
    exBtns.Name = "ExtraButtons"
    exBtns.Size = UDim2.new(0, 180, 1, 0)
    exBtns.Position = UDim2.new(0, 110, 0, 0)
    exBtns.BackgroundTransparency = 1
    exBtns.Parent = expandedFrame

    local exListLayout = Instance.new("UIListLayout")
    exListLayout.FillDirection = Enum.FillDirection.Horizontal
    exListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    exListLayout.Padding = UDim.new(0, 4)
    exListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    exListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    exListLayout.Parent = exBtns

    local function makeExActBtn(text, color, strokeColor, order, sizeX)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, sizeX, 0, 26)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.LayoutOrder = order
        btn.Parent = exBtns

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn

        local s = Instance.new("UIStroke")
        s.Color = strokeColor
        s.Thickness = 1
        s.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(s, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(s, TweenInfo.new(0.15), {Color = strokeColor}):Play()
        end)

        return btn
    end

    -- Copy ID Button
    local copyBtn = makeExActBtn("Salin ID", Color3.fromRGB(40, 40, 45), Color3.fromRGB(60, 60, 65), 1, 46)
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(tostring(targetPlayer.UserId))
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Salin ID",
                    Text = "User ID player berhasil disalin!",
                    Duration = 2
                })
            end)
        end
    end)

    -- Copy User Button
    local copyUserBtn = makeExActBtn("Salin User", Color3.fromRGB(40, 40, 45), Color3.fromRGB(60, 60, 65), 2, 54)
    copyUserBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(targetPlayer.Name)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Salin Username",
                    Text = "Username player berhasil disalin!",
                    Duration = 2
                })
            end)
        end
    end)

    -- Toggle ESP Button
    local COREGUI = game:GetService("CoreGui")
    local espBtn = makeExActBtn("ESP", Color3.fromRGB(0, 100, 150), Color3.fromRGB(0, 160, 220), 3, 32)
    if COREGUI:FindFirstChild(targetPlayer.Name .. "_ESP") then
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
        espBtn.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 240, 150)
    end
    espBtn.MouseButton1Click:Connect(function()
        if COREGUI:FindFirstChild(targetPlayer.Name .. "_ESP") then
            destroyPlayerESP(targetPlayer.Name)
            espBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
            espBtn.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 160, 220)
        else
            CreateESP(targetPlayer)
            espBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 120)
            espBtn.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(0, 240, 150)
        end
    end)

    -- Fling Button
    local flingActive = false
    local flingBtn = makeExActBtn("Fling", Color3.fromRGB(150, 50, 50), Color3.fromRGB(200, 100, 100), 4, 36)
    flingBtn.MouseButton1Click:Connect(function()
        local lplr = game.Players.LocalPlayer
        local char = lplr.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end

        flingActive = not flingActive
        if flingActive then
            flingBtn.Text = "Stop"
            flingBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            flingBtn.FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(255, 150, 50)
            
            task.spawn(function()
                local oldGravity = workspace.Gravity
                workspace.Gravity = 0
                
                local originalCFrame = hrp.CFrame
                
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "Flinging...",
                        Text = "Menyerang " .. targetPlayer.DisplayName .. ". Klik Stop untuk kembali.",
                        Duration = 3
                    })
                end)

                while flingActive and targetPlayer and targetPlayer.Parent do
                    RunService.Heartbeat:Wait()
                    local myChar = lplr.Character
                    local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
                    local tChar = targetPlayer.Character
                    local tHrp = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso") or tChar:FindFirstChild("UpperTorso"))
                    
                    if not myHrp then break end
                    if not tHrp then
                        tHrp = tChar and tChar:FindFirstChildWhichIsA("BasePart", true)
                    end

                    if tHrp then
                        myHrp.AssemblyLinearVelocity = Vector3.new(0, 99999, 0)
                        myHrp.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
                        myHrp.CFrame = tHrp.CFrame * CFrame.new(math.random(-1,1)*0.4, 0, math.random(-1,1)*0.4)
                    else
                        myHrp.AssemblyLinearVelocity = Vector3.zero
                        myHrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end
                
                flingActive = false
                workspace.Gravity = oldGravity
                
                -- Restore original state if loop finished naturally
                if flingBtn and flingBtn.Parent then
                    flingBtn.Text = "Fling"
                    flingBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
                    local stroke = flingBtn:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = Color3.fromRGB(200, 100, 100) end
                end
                
                local myChar = lplr.Character
                local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
                if myHrp and originalCFrame then
                    -- Temporarily anchor character for 0.1s to fully stop momentum
                    local prevAnchored = myHrp.Anchored
                    myHrp.Anchored = true
                    myHrp.AssemblyLinearVelocity = Vector3.zero
                    myHrp.AssemblyAngularVelocity = Vector3.zero
                    myHrp.CFrame = originalCFrame
                    task.wait(0.1)
                    myHrp.Anchored = prevAnchored
                end
            end)
        else
            flingActive = false
            -- Instantly update UI states on click
            flingBtn.Text = "Fling"
            flingBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            local stroke = flingBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(200, 100, 100) end
        end
    end)

    -- Expand/Collapse Interaction (Clicking info or left part)
    local isExpanded = false
    local toggleExpand
    toggleExpand = function()
        isExpanded = not isExpanded
        if isExpanded then
            row.Size = UDim2.new(1, -8, 0, 120)
            expandedFrame.Visible = true
        else
            row.Size = UDim2.new(1, -8, 0, 50)
            expandedFrame.Visible = false
            flingActive = false
        end
        updateCanvasSize()
    end

    local clickDetector = Instance.new("TextButton")
    clickDetector.Name = "ClickDetector"
    clickDetector.Size = UDim2.new(1, -135, 0, 48)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = row

    clickDetector.MouseButton1Click:Connect(toggleExpand)
end


refreshPlayerList = function()
    if not PlayerListFrame or not PlayerListFrame.Visible then return end
    
    for _, child in ipairs(PlayerListScroll:GetChildren()) do
        if child:IsA("Frame") and child.Name == "PlayerItem" then
            child:Destroy()
        end
    end

    local query = string.lower(PlayerListSearchBox.Text)
    local count = 0

    local sortedPlayers = game:GetService("Players"):GetPlayers()
    table.sort(sortedPlayers, function(a, b)
        return string.lower(a.DisplayName) < string.lower(b.DisplayName)
    end)

    for _, plr in ipairs(sortedPlayers) do
        if plr ~= game.Players.LocalPlayer then
            local nameMatch = string.find(string.lower(plr.Name), query, 1, true)
            local dispMatch = string.find(string.lower(plr.DisplayName), query, 1, true)
            if query == "" or nameMatch or dispMatch then
                count = count + 1
                createPlayerRow(plr, count)
            end
        end
    end
    updateCanvasSize()
end

local function createPlayerListWindow()
    if PlayerListFrame then return end

    local sgui = ScreenGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "PlayerListFrame"
    mainFrame.Size = UDim2.new(0, 340, 0, 360)
    mainFrame.Position = UDim2.new(0.5, 120, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    PlayerListFrame = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 220, 130)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.Parent = mainFrame

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(0, 0, 20)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar

    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 10)
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.BackgroundColor3 = Color3.fromRGB(0, 0, 20)
    topCover.BorderSizePixel = 0
    topCover.Parent = topBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Player List"
    title.TextColor3 = Color3.fromRGB(0, 200, 120)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.Parent = topBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = Color3.fromRGB(200, 100, 100)
    closeStroke.Thickness = 1
    closeStroke.Parent = closeBtn

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -54, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
    minBtn.BackgroundTransparency = 0.1
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 13
    minBtn.Parent = topBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minBtn

    local minStroke = Instance.new("UIStroke")
    minStroke.Color = Color3.fromRGB(0, 200, 120)
    minStroke.Thickness = 1
    minStroke.Parent = minBtn

    local isMinimized = false
    local normalSize = UDim2.new(0, 340, 0, 360)
    local minimizedSize = UDim2.new(0, 340, 0, 30)

    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            minBtn.Text = "+"
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize})
            tween:Play()
            searchFrame.Visible = false
            scroll.Visible = false
        else
            minBtn.Text = "-"
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize})
            tween:Play()
            task.delay(0.1, function()
                if not isMinimized then
                    searchFrame.Visible = true
                    scroll.Visible = true
                    refreshPlayerList()
                end
            end)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        if isMinimized then
            isMinimized = false
            minBtn.Text = "-"
            mainFrame.Size = normalSize
            searchFrame.Visible = true
            scroll.Visible = true
        end
    end)

    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(1, -20, 0, 32)
    searchFrame.Position = UDim2.new(0, 10, 0, 38)
    searchFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    searchFrame.BackgroundTransparency = 0.2
    searchFrame.Parent = mainFrame

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame

    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = Color3.fromRGB(0, 130, 80)
    searchStroke.Thickness = 1.5
    searchStroke.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.Position = UDim2.new(0, 10, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.GothamBold
    searchBox.Text = ""
    searchBox.PlaceholderText = "Cari pemain..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 14
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchFrame
    PlayerListSearchBox = searchBox

    searchBox:GetPropertyChangedSignal("Text"):Connect(refreshPlayerList)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -85)
    scroll.Position = UDim2.new(0, 10, 0, 78)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
    scroll.Parent = mainFrame
    PlayerListScroll = scroll

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll

    -- Drag logic
    local dragging, dragInput, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Dynamic Connections
    table.insert(playerConnections, game:GetService("Players").PlayerAdded:Connect(refreshPlayerList))
    table.insert(playerConnections, game:GetService("Players").PlayerRemoving:Connect(function(leavingPlr)
        if leavingPlr == currentSpectateTarget then
            currentSpectateTarget = nil
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end
        refreshPlayerList()
    end))

    -- Clean up connections on frame destroy
    mainFrame.Destroying:Connect(function()
        for _, conn in ipairs(playerConnections) do
            if conn then conn:Disconnect() end
        end
        playerConnections = {}
        currentSpectateTarget = nil
    end)
end

togglePlayerListWindow = function()
    if not PlayerListFrame then
        createPlayerListWindow()
    end
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    if PlayerListFrame.Visible then
        refreshPlayerList()
    end
end

-- Hook camera update for spectating loop safely
RunService.RenderStepped:Connect(function()
    if currentSpectateTarget then
        local camera = workspace.CurrentCamera
        local char = currentSpectateTarget.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and camera.CameraSubject ~= hum then
            camera.CameraSubject = hum
        end
    end
end)

local Player = game.Players.LocalPlayer
SpeedBtn = createButton("", "Speed")
SpeedBtn.Name = "SpeedBtn"
SpeedBtn.LayoutOrder = 5
local desiredSpeed = 50

do
    SpeedBox = Instance.new("TextBox")
    SpeedBox.Name = "SpeedBox"
    SpeedBox.Text = tostring(desiredSpeed)
    SpeedBox.PlaceholderText = "Speed (16-300)"
    SpeedBox.LayoutOrder = 6
    SpeedBox.Size = UDim2.new(0, 150, 0, 35)
    SpeedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    SpeedBox.BackgroundTransparency = 0.1
    SpeedBox.TextSize = 15
    SpeedBox.Font = Enum.Font.GothamBold
    SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBox.ClearTextOnFocus = false
    SpeedBox.Parent = ScrollFrame

    local c_spd = Instance.new("UICorner")
    c_spd.CornerRadius = UDim.new(0, 8)
    c_spd.Parent = SpeedBox

    local s_spd = Instance.new("UIStroke")
    s_spd.Color = Color3.fromRGB(0, 130, 80)
    s_spd.Thickness = 1.5
    s_spd.Parent = SpeedBox

    local p_spd = Instance.new("UIPadding")
    p_spd.PaddingLeft = UDim.new(0, 12)
    p_spd.Parent = SpeedBox

    SpeedBox.FocusLost:Connect(function()
        local n = tonumber(SpeedBox.Text)
        if n then
            n = math.clamp(n, 16, 300)
            desiredSpeed = n
            if speedOn then
                local char = Player.Character or Player.CharacterAdded:Wait()
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.WalkSpeed = desiredSpeed end
            end
        end
        SpeedBox.Text = tostring(desiredSpeed)
    end)
end

local speedOn = false
local selendangPart = nil

local colors = {
	Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(150, 200, 255)
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

	local torso = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	if not torso then return end

	selendangPart = Instance.new("Part")
	selendangPart.Name = "SelendangPart"
	selendangPart.Size = Vector3.new(0.5,0.5,0.5)
	selendangPart.Transparency = 1
	selendangPart.Anchored = false
	selendangPart.CanCollide = false
	selendangPart.CFrame = torso.CFrame * CFrame.new(0, -2.5, 0)
	selendangPart.Parent = char

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = torso
	weld.Part1 = selendangPart
	weld.Parent = selendangPart

	local trails = {}
	for i = 1, 2 do
		local yPos = (i - 1.5) * 0.2
		local attLeft = Instance.new("Attachment", selendangPart)
		attLeft.Position = Vector3.new(-0.8, yPos, 0)

		local attRight = Instance.new("Attachment", selendangPart)
		attRight.Position = Vector3.new(0.8, yPos, 0)

		local newTrail = Instance.new("Trail")
		newTrail.Attachment0 = attLeft
		newTrail.Attachment1 = attRight
		newTrail.Lifetime = 0.5
		newTrail.MinLength = 0.1
		newTrail.LightEmission = 0.8
		newTrail.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.4),
			NumberSequenceKeypoint.new(1, 1)
		})
		newTrail.WidthScale = NumberSequence.new(0.4, 0)
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

local function toggleSpeed()
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
end

SpeedBtn.MouseButton1Click:Connect(toggleSpeed)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if UserInputService:GetFocusedTextBox() then return end
	if input.KeyCode == Enum.KeyCode.RightBracket then
		toggleSpeed()
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

FlingBtn = createButton("", "Tendang")
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

-- Click TP and Free Cam integrations
ClickTPBtn = createButton("", "Click TP")
ClickTPBtn.Name = "ClickTPBtn"
ClickTPBtn.LayoutOrder = 1
FreeCamBtn = createButton("", "Free Cam")
FreeCamBtn.Name = "FreeCamBtn"
FreeCamBtn.LayoutOrder = 3

local TPBox
local findPlayerByQuery

local clickTpOn = false
local freecamOn = false
local freecamYaw, freecamPitch = 0, 0
local freecamPos
local freecamSpeed = 2

local clickTpConnection = nil
function toggleClickTP(state)
    if state == nil then
        clickTpOn = not clickTpOn
    else
        clickTpOn = state
    end
    setButtonActive(ClickTPBtn, clickTpOn)
    
    if clickTpOn then
        if not clickTpConnection then
            local Mouse = Player:GetMouse()
            clickTpConnection = Mouse.Button1Down:Connect(function()
                if clickTpOn and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
                    local targetPos = Mouse.Hit.Position + Vector3.new(0, 3, 0)
                    local char = Player.Character
                    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
                    if hrp then
                        char:PivotTo(CFrame.new(targetPos))
                    end
                end
            end)
        end
    else
        if clickTpConnection then
            clickTpConnection:Disconnect()
            clickTpConnection = nil
        end
    end
end

function handleClickTPClick()
    local query = TPBox.Text
    if query and query ~= "" then
        local target = findPlayerByQuery(query)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character then
            local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
            player.Character:PivotTo(CFrame.new(targetPos))
        else
            setButtonActive(ClickTPBtn, true)
            task.delay(0.1, function() setButtonActive(ClickTPBtn, false) end)
        end
    else
        toggleClickTP()
    end
end

ClickTPBtn.MouseButton1Click:Connect(handleClickTPClick)

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
TPBox = Instance.new("TextBox")
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

-- Save Waypoint UI: a TextButton and a TextBox
SWPBtn = createButton("", "Save WP")
SWPBtn.Name = "SWPBtn"
SWPBtn.LayoutOrder = 5

SWPBox = Instance.new("TextBox")
SWPBox.Name = "SWPBox"
SWPBox.LayoutOrder = 6
SWPBox.Size = UDim2.new(0, 150, 0, 35)
SWPBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SWPBox.BackgroundTransparency = 0.1
SWPBox.Text = ""
SWPBox.PlaceholderText = "Waypoint Name"
SWPBox.TextSize = 15
SWPBox.Font = Enum.Font.GothamBold
SWPBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SWPBox.ClearTextOnFocus = false
SWPBox.Parent = ScrollFrame
do
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = SWPBox
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 130, 80)
    s.Thickness = 1.5
    s.Parent = SWPBox
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 12)
    p.Parent = SWPBox
end

SWPBtn.MouseButton1Click:Connect(function()
    local name = SWPBox.Text
    if name and name ~= "" then
        if typeof(saveCurrentPositionAsWaypoint) == "function" then
            saveCurrentPositionAsWaypoint(name)
        end
        SWPBox.Text = ""
        SWPBox:ReleaseFocus()
        setButtonActive(SWPBtn, true)
        task.delay(0.5, function() setButtonActive(SWPBtn, false) end)
    else
        SWPBox.PlaceholderText = "Enter name first!"
        SWPBox:ReleaseFocus()
        task.delay(1.5, function() SWPBox.PlaceholderText = "Waypoint Name" end)
    end
end)

findPlayerByQuery = function(q)
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

UnanchorBtn = createButton("", "Unanchor")
local player = game.Players.LocalPlayer
local aktif = false
local folder, attachment1, koneksi1
local RADIUS = 500

local activeParts = {}

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
        while aktif do
            -- Cache parts once a second instead of every frame
            activeParts = scanParts()
            
            for _, pl in next, game.Players:GetPlayers() do
                if pl ~= player then
                    pl.MaximumSimulationRadius = 0
                    pcall(function() sethiddenproperty(pl, "SimulationRadius", 0) end)
                end
            end
            player.MaximumSimulationRadius = math.pow(math.huge, math.huge)
            pcall(function() setsimulationradius(math.huge) end)
            
            task.wait(1)
        end
    end)

    koneksi1 = game:GetService("RunService").Stepped:Connect(function()
        if attachment1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            attachment1.Parent.Position = player.Character.HumanoidRootPart.Position
        end
        for _, v in ipairs(activeParts) do
            applyForce(v)
        end
    end)
end

local function stopUnanchor()
    if koneksi1 then koneksi1:Disconnect() end
    if folder then folder:Destroy() end
    folder, attachment1 = nil, nil
end

function toggleUnanchor(state)
    if state == nil then
        aktif = not aktif
    else
        aktif = state
    end
    if aktif then
        setButtonActive(UnanchorBtn, true)
        mulaiUnanchor()
    else
        setButtonActive(UnanchorBtn, false)
        stopUnanchor()
    end
end

UnanchorBtn.MouseButton1Click:Connect(function()
    toggleUnanchor()
end)

BringPartBtn = createButton("", "BringPart")

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

function toggleBringPart(state)
	if state == nil then
		blackHoleActive = not blackHoleActive
	else
		blackHoleActive = state
	end

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

		if DescendantAddedConnection then DescendantAddedConnection:Disconnect() end
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
end

BringPartBtn.MouseButton1Click:Connect(function()
    toggleBringPart()
end)

AntiLagBtn = createButton("", "Anti Lag")
antiLagActive = false
connections = {}
originalStates = {}

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

local function toggleAntiLag(state)
    if state == nil then
        antiLagActive = not antiLagActive
    else
        antiLagActive = state
    end
    if antiLagActive then
        setButtonActive(AntiLagBtn, true)
        applyAntiLag()
    else
        setButtonActive(AntiLagBtn, false)
        resetAntiLag()
    end
end

AntiLagBtn.MouseButton1Click:Connect(function()
    toggleAntiLag()
end)

NoclipBtn = createButton("", "Noclip Ghost")
noclipActive = false
noclipConnection = nil

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

local function toggleNoclip(state)
    if state == nil then
        noclipActive = not noclipActive
    else
        noclipActive = state
    end
    
    if noclipActive then
        enableNoclip()
        setButtonActive(NoclipBtn, true)
    else
        disableNoclip()
        setButtonActive(NoclipBtn, false)
    end
end

NoclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

Player.CharacterAdded:Connect(onCharacterAdded)

if Player.Character then
    task.wait(0.5)
    onCharacterAdded(Player.Character)
end

SpectatorBtn = createButton("", "Spectator")
AnimasiBtn = createButton("", "Animasi")
FlyV2Btn = createButton("", "Fly V2")
FlyV3Btn = createButton("", "Fly V3")
ServerHopBtn = createButton("", "Server Hop")
DexBtn = createButton("", "Dex Explorer")

CmdBarBtn = createButton("", "Command Bar")
CmdBarBtn.MouseButton1Click:Connect(function()
    if showCmdBar then
        showCmdBar()
    end
end)

function launchDex()
    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/bochilascript/ROBLOX/refs/heads/main/dex.lua"))()
    end)
    if not ok then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Dex Explorer",
                Text = "Failed to load: " .. tostring(err),
                Duration = 5
            })
        end)
    end
end
DexBtn.MouseButton1Click:Connect(launchDex)

function launchSpectator()
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
end
SpectatorBtn.MouseButton1Click:Connect(launchSpectator)

ServerHopBtn.MouseButton1Click:Connect(serverhop)

function launchAnimasi()
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
        warn("HttpGet failed for Animasi") 
    end
end
AnimasiBtn.MouseButton1Click:Connect(launchAnimasi)

local function launchFlyV2()
	local main = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local up = Instance.new("TextButton")
	local down = Instance.new("TextButton")
	local onof = Instance.new("TextButton")
	local TextLabel = Instance.new("TextLabel")
	local plus = Instance.new("TextButton")
	local speed = Instance.new("TextLabel")
	local mine = Instance.new("TextButton")
	local closebutton = Instance.new("TextButton")
	local mini = Instance.new("TextButton")
	local mini2 = Instance.new("TextButton")

	main.Name = "main"
	main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	main.ResetOnSpawn = false

	Frame.Parent = main
	Frame.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
	Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
	Frame.Size = UDim2.new(0, 190, 0, 57)

	up.Name = "up"
	up.Parent = Frame
	up.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	up.Size = UDim2.new(0, 44, 0, 28)
	up.Font = Enum.Font.SourceSans
	up.Text = "NAIK"
	up.TextColor3 = Color3.fromRGB(0, 0, 0)
	up.TextSize = 14.000

	down.Name = "down"
	down.Parent = Frame
	down.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	down.Position = UDim2.new(0, 0, 0.491228074, 0)
	down.Size = UDim2.new(0, 44, 0, 28)
	down.Font = Enum.Font.SourceSans
	down.Text = "TURUN"
	down.TextColor3 = Color3.fromRGB(0, 0, 0)
	down.TextSize = 14.000

	onof.Name = "onof"
	onof.Parent = Frame
	onof.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
	onof.Size = UDim2.new(0, 56, 0, 28)
	onof.Font = Enum.Font.SourceSans
	onof.Text = "Klik Untuk Terbang!"
	onof.TextColor3 = Color3.fromRGB(0, 0, 0)
	onof.TextSize = 14.000

	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
	TextLabel.Size = UDim2.new(0, 100, 0, 28)
	TextLabel.Font = Enum.Font.SourceSans
	TextLabel.Text = "FLY V2 BY MANNN"
	TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextWrapped = true

	plus.Name = "plus"
	plus.Parent = Frame
	plus.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	plus.Position = UDim2.new(0.231578946, 0, 0, 0)
	plus.Size = UDim2.new(0, 45, 0, 28)
	plus.Font = Enum.Font.SourceSans
	plus.Text = "+"
	plus.TextColor3 = Color3.fromRGB(0, 0, 0)
	plus.TextScaled = true
	plus.TextSize = 14.000
	plus.TextWrapped = true

	speed.Name = "speed"
	speed.Parent = Frame
	speed.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
	speed.Size = UDim2.new(0, 44, 0, 28)
	speed.Font = Enum.Font.SourceSans
	speed.Text = "1"
	speed.TextColor3 = Color3.fromRGB(0, 0, 0)
	speed.TextScaled = true
	speed.TextSize = 14.000
	speed.TextWrapped = true

	mine.Name = "mine"
	mine.Parent = Frame
	mine.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
	mine.Size = UDim2.new(0, 45, 0, 29)
	mine.Font = Enum.Font.SourceSans
	mine.Text = "-"
	mine.TextColor3 = Color3.fromRGB(0, 0, 0)
	mine.TextScaled = true
	mine.TextSize = 14.000
	mine.TextWrapped = true

	closebutton.Name = "Close"
	closebutton.Parent = main.Frame
	closebutton.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	closebutton.Font = "SourceSans"
	closebutton.Size = UDim2.new(0, 45, 0, 28)
	closebutton.Text = "X"
	closebutton.TextSize = 30
	closebutton.Position =  UDim2.new(0, 0, -1, 27)

	mini.Name = "minimize"
	mini.Parent = main.Frame
	mini.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	mini.Font = "SourceSans"
	mini.Size = UDim2.new(0, 45, 0, 28)
	mini.Text = "-"
	mini.TextSize = 40
	mini.Position = UDim2.new(0, 44, -1, 27)

	mini2.Name = "minimize2"
	mini2.Parent = main.Frame
	mini2.BackgroundColor3 = Color3.fromRGB(144, 213, 255)
	mini2.Font = "SourceSans"
	mini2.Size = UDim2.new(0, 45, 0, 28)
	mini2.Text = "+"
	mini2.TextSize = 40
	mini2.Position = UDim2.new(0, 44, -1, 57)
	mini2.Visible = false

	local speeds = 1

	local speaker = game:GetService("Players").LocalPlayer

	local chr = game.Players.LocalPlayer.Character
	local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

	local nowe = false
	local noclipConnectionFly2 = nil

	game:GetService("StarterGui"):SetCore("SendNotification", { 
		Title = "GUI TERBANG V3";
		Text = "by Mannn";
		Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
	local Duration = 5;

	Frame.Active = true -- main = gui
	Frame.Draggable = true

	onof.MouseButton1Down:connect(function()

		if nowe == true then
			nowe = false

			if noclipConnectionFly2 then
				noclipConnectionFly2:Disconnect()
				noclipConnectionFly2 = nil
			end

			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
			speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
		else 
			nowe = true

			if not noclipConnectionFly2 then
				noclipConnectionFly2 = game:GetService("RunService").Stepped:Connect(function()
					local chr = speaker.Character
					if chr then
						for _, obj in ipairs(chr:GetDescendants()) do
							if obj:IsA("BasePart") then
								obj.CanCollide = false
							end
						end
					end
				end)
			end

			for i = 1, speeds do
				spawn(function()

					local hb = game:GetService("RunService").Heartbeat	

tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end

				end)
			end
			game.Players.LocalPlayer.Character.Animate.Disabled = true
			local Char = game.Players.LocalPlayer.Character
			local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

			for i,v in next, Hum:GetPlayingAnimationTracks() do
				v:AdjustSpeed(0)
			end
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
			speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
			speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
		end

if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then

local plr = game.Players.LocalPlayer
			local torso = plr.Character.Torso
			local flying = true
			local deb = true
			local ctrl = {f = 0, b = 0, l = 0, r = 0}
			local lastctrl = {f = 0, b = 0, l = 0, r = 0}
			local maxspeed = 50
			local speed = 0

local bg = Instance.new("BodyGyro", torso)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.cframe = torso.CFrame
			local bv = Instance.new("BodyVelocity", torso)
			bv.velocity = Vector3.new(0,0.1,0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			if nowe == true then
				plr.Character.Humanoid.PlatformStand = true
			end
			while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
				game:GetService("RunService").RenderStepped:Wait()

				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed+.5+(speed/maxspeed)
					if speed > maxspeed then
						speed = maxspeed
					end
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
					speed = speed-1
					if speed < 0 then
						speed = 0
					end
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
					lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
					bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				else
					bv.velocity = Vector3.new(0,0,0)
				end
				--	game.Players.LocalPlayer.Character.Animate.Disabled = true
				bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
			end
			ctrl = {f = 0, b = 0, l = 0, r = 0}
			lastctrl = {f = 0, b = 0, l = 0, r = 0}
			speed = 0
			bg:Destroy()
			bv:Destroy()
			plr.Character.Humanoid.PlatformStand = false
			game.Players.LocalPlayer.Character.Animate.Disabled = false
			tpwalking = false

else
			local plr = game.Players.LocalPlayer
			local UpperTorso = plr.Character.UpperTorso
			local flying = true
			local deb = true
			local ctrl = {f = 0, b = 0, l = 0, r = 0}
			local lastctrl = {f = 0, b = 0, l = 0, r = 0}
			local maxspeed = 50
			local speed = 0

local bg = Instance.new("BodyGyro", UpperTorso)
			bg.P = 9e4
			bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			bg.cframe = UpperTorso.CFrame
			local bv = Instance.new("BodyVelocity", UpperTorso)
			bv.velocity = Vector3.new(0,0.1,0)
			bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
			if nowe == true then
				plr.Character.Humanoid.PlatformStand = true
			end
			while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
				wait()

				if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
					speed = speed+.5+(speed/maxspeed)
					if speed > maxspeed then
						speed = maxspeed
					end
				elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
					speed = speed-1
					if speed < 0 then
						speed = 0
					end
				end
				if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
					bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
					lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
				elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
					bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				else
					bv.velocity = Vector3.new(0,0,0)
				end

				bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
			end
			ctrl = {f = 0, b = 0, l = 0, r = 0}
			lastctrl = {f = 0, b = 0, l = 0, r = 0}
			speed = 0
			bg:Destroy()
			bv:Destroy()
			plr.Character.Humanoid.PlatformStand = false
			game.Players.LocalPlayer.Character.Animate.Disabled = false
			tpwalking = false

end

end)

	local movingUp = false
	up.MouseButton1Down:Connect(function()
		movingUp = true
		while movingUp do
			task.wait()
			pcall(function()
				local char = game.Players.LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.CFrame = hrp.CFrame * CFrame.new(0, 1, 0)
				end
			end)
		end
	end)

	up.MouseButton1Up:Connect(function()
		movingUp = false
	end)

	up.MouseLeave:Connect(function()
		movingUp = false
	end)

	local movingDown = false
	down.MouseButton1Down:Connect(function()
		movingDown = true
		while movingDown do
			task.wait()
			pcall(function()
				local char = game.Players.LocalPlayer.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.CFrame = hrp.CFrame * CFrame.new(0, -1, 0)
				end
			end)
		end
	end)

	down.MouseButton1Up:Connect(function()
		movingDown = false
	end)

	down.MouseLeave:Connect(function()
		movingDown = false
	end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
		wait(0.7)
		game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false

	end)

plus.MouseButton1Down:connect(function()
		speeds = speeds + 1
		speed.Text = speeds
		if nowe == true then

tpwalking = false
			for i = 1, speeds do
				spawn(function()

					local hb = game:GetService("RunService").Heartbeat	

tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end

				end)
			end
		end
	end)
	mine.MouseButton1Down:connect(function()
		if speeds == 1 then
			speed.Text = 'tidak bisa kurang dari 1'
			wait(1)
			speed.Text = speeds
		else
			speeds = speeds - 1
			speed.Text = speeds
			if nowe == true then
				tpwalking = false
				for i = 1, speeds do
					spawn(function()

						local hb = game:GetService("RunService").Heartbeat	

tpwalking = true
						local chr = game.Players.LocalPlayer.Character
						local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
						while tpwalking and hb:Wait() and chr and hum and hum.Parent do
							if hum.MoveDirection.Magnitude > 0 then
								chr:TranslateBy(hum.MoveDirection)
							end
						end

					end)
				end
			end
		end
	end)

	closebutton.MouseButton1Click:Connect(function()
		main:Destroy()
	end)

	mini.MouseButton1Click:Connect(function()
		up.Visible = false
		down.Visible = false
		onof.Visible = false
		plus.Visible = false
		speed.Visible = false
		mine.Visible = false
		mini.Visible = false
		mini2.Visible = true
		main.Frame.BackgroundTransparency = 1
		closebutton.Position =  UDim2.new(0, 0, -1, 57)
	end)

	mini2.MouseButton1Click:Connect(function()
		up.Visible = true
		down.Visible = true
		onof.Visible = true
		plus.Visible = true
		speed.Visible = true
		mine.Visible = true
		mini.Visible = true
		mini2.Visible = false
		main.Frame.BackgroundTransparency = 0 
		closebutton.Position =  UDim2.new(0, 0, -1, 27)
	end)
end

FlyV2Btn.MouseButton1Click:Connect(function()
    launchFlyV2()
end)

-- toggleFlyV3 globalized
do
    local flyV3Active = false
    local flyV3Movers = {}

    toggleFlyV3 = function(state)
        if state == nil then
            flyV3Active = not flyV3Active
        else
            flyV3Active = state
        end
        setButtonActive(FlyV3Btn, flyV3Active)
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = flyV3Active end
        if not flyV3Active and flyV3Movers[1] then
            flyV3Movers[1].Parent = nil
            flyV3Movers[2].Parent = nil
        end
    end

    FlyV3Btn.MouseButton1Click:Connect(function()
        toggleFlyV3()
    end)

    RunService.Heartbeat:Connect(function()
        if not flyV3Active then return end
        local char = Player.Character
        local primaryPart = char and char.PrimaryPart
        local camera = workspace.CurrentCamera
        if primaryPart then
            local bodyVelocity, bodyGyro = unpack(flyV3Movers)
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro = Instance.new("BodyGyro")
                bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bodyGyro.P = 9e4
                local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
                bodyAngularVelocity.AngularVelocity = Vector3.yAxis * 9e9
                bodyAngularVelocity.MaxTorque = Vector3.yAxis * 9e9
                bodyAngularVelocity.P = 9e9
                flyV3Movers = { bodyVelocity, bodyGyro, bodyAngularVelocity }
            end
            local camCFrame = camera.CFrame
            local velocity = Vector3.zero
            local rotation = camCFrame.Rotation
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity += camCFrame.LookVector
                rotation *= CFrame.Angles(math.rad(-40), 0, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity -= camCFrame.LookVector
                rotation *= CFrame.Angles(math.rad(40), 0, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity += camCFrame.RightVector
                rotation *= CFrame.Angles(0, 0, math.rad(-40))
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity -= camCFrame.RightVector
                rotation *= CFrame.Angles(0, 0, math.rad(40))
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity += Vector3.yAxis
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                velocity -= Vector3.yAxis
            end
            
            local tweenInfo = TweenInfo.new(0.5)
            TweenService:Create(bodyVelocity, tweenInfo, { Velocity = velocity * 50 * 4.5 }):Play()
            bodyVelocity.Parent = primaryPart
            TweenService:Create(bodyGyro, tweenInfo, { CFrame = rotation }):Play()
            bodyGyro.Parent = primaryPart
        end
    end)
end

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
SpectatorBtn.LayoutOrder = 15
AnimasiBtn.LayoutOrder = 16
FlyV2Btn.LayoutOrder = 18.5

-- Place the new controls at the end
ClickTPBtn.LayoutOrder = 19
FreeCamBtn.LayoutOrder = 21
TPBox.LayoutOrder = 20
SWPBtn.LayoutOrder = 22
SWPBox.LayoutOrder = 23

-- A->Z sort all action buttons and place input boxes under their buttons
(function()
    local btns = {
        AirwalkBtn, ESPBtn, ESPTeamBtn, LampBtn, JumpBtn, SpeedBtn, NoclipBtn, FlingBtn, FlyBtn,
        UnanchorBtn, BringPartBtn, AntiLagBtn, SpectatorBtn,
        AnimasiBtn, FlyV2Btn, FlyV3Btn, ClickTPBtn, FreeCamBtn, ServerHopBtn, SWPBtn, DexBtn, CmdBarBtn
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
        if btn == SWPBtn and SWPBox then
            SWPBox.LayoutOrder = order
            order = order + 1
        end
    end
end)()

-- Hook chat commands & Command Bar (e.g. swp <name>) like Infinite Yield
local success, err = pcall(function()
    local lastSavedWaypointName = nil
    local lastSavedWaypointTime = 0

    local function notifyPlayer(title, text)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = 5
            })
        end)
    end
    local commandsList = {
        { name = "cmds", aliases = {"commands"}, desc = "Menampilkan daftar perintah ini.", usage = "" },
        { name = "swp", aliases = {"savewp", "savewaypoint"}, desc = "Simpan posisi saat ini sebagai waypoint.", usage = " [nama]" },
        { name = "tpwp", aliases = {"wp"}, desc = "Teleportasi ke waypoint yang disimpan.", usage = " [nama]" },
        { name = "speed", aliases = {"spd", "ws"}, desc = "Atur kecepatan jalan (16-300) atau aktifkan/nonaktifkan speed.", usage = " [angka]" },
        { name = "fly", aliases = {}, desc = "Aktifkan mode terbang.", usage = "" },
        { name = "unfly", aliases = {"nofly"}, desc = "Nonaktifkan mode terbang.", usage = "" },
        { name = "flyv2", aliases = {}, desc = "Buka menu Fly V2.", usage = "" },
        { name = "flyv3", aliases = {}, desc = "Aktifkan/nonaktifkan Fly V3.", usage = "" },
        { name = "freecam", aliases = {"fc"}, desc = "Aktifkan/nonaktifkan mode kamera bebas.", usage = "" },
        { name = "nofreecam", aliases = {"nofc"}, desc = "Nonaktifkan mode kamera bebas.", usage = "" },
        { name = "clicktp", aliases = {"ctp"}, desc = "Aktifkan/nonaktifkan teleport dengan klik (Ctrl + klik).", usage = "" },
        { name = "tp", aliases = {"teleport"}, desc = "Teleportasi ke pemain lain.", usage = " [nama]" },
        { name = "unanchor", aliases = {}, desc = "Aktifkan/nonaktifkan fitur unanchor parts.", usage = "" },
        { name = "fling", aliases = {"tendang"}, desc = "Aktifkan/nonaktifkan mode fling untuk lempar pemain.", usage = "" },
        { name = "explorer", aliases = {"dex"}, desc = "Buka DEX Explorer.", usage = "" },
        { name = "airwalk", aliases = {"walkonair"}, desc = "Aktifkan/nonaktifkan jalan di udara.", usage = "" },
        { name = "esp", aliases = {}, desc = "Aktifkan/nonaktifkan ESP.", usage = "" },
        { name = "espteam", aliases = {}, desc = "Aktifkan/nonaktifkan ESP Team.", usage = "" },
        { name = "lampu", aliases = {"light", "lamp"}, desc = "Aktifkan/nonaktifkan lampu kepala.", usage = "" },
        { name = "infjump", aliases = {"infinitejump"}, desc = "Aktifkan/nonaktifkan loncat tanpa batas.", usage = "" },
        { name = "rejoin", aliases = {"rj"}, desc = "Masuk kembali ke server ini.", usage = "" },
        { name = "refresh", aliases = {"re", "respawn"}, desc = "Muat ulang karakter Anda.", usage = "" },
        { name = "antiafk", aliases = {}, desc = "Aktifkan/nonaktifkan anti AFK.", usage = "" },
        { name = "serverhop", aliases = {"shop"}, desc = "Buka menu Server Hop.", usage = "" },
        { name = "bringpart", aliases = {"bp"}, desc = "Aktifkan/nonaktifkan penarik part (blackhole).", usage = "" },
        { name = "antilag", aliases = {"boost"}, desc = "Aktifkan/nonaktifkan pengurang lag (Anti Lag).", usage = "" },
        { name = "noclip", aliases = {}, desc = "Aktifkan/nonaktifkan noclip ghost.", usage = "" },
        { name = "spectate", aliases = {"spectator", "view"}, desc = "Buka menu Spectator.", usage = "" },
        { name = "animasi", aliases = {"anims"}, desc = "Buka menu Animasi.", usage = "" },
        { name = "cmdbar", aliases = {}, desc = "Tampilkan Command Bar.", usage = "" },
        { name = "credits", aliases = {}, desc = "Tampilkan info Credits.", usage = "" }
    }

    local CmdListFrame = nil

    local function makeDraggable(frame, parentFrame)
        parentFrame = parentFrame or frame
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            parentFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = parentFrame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    local function createCommandsWindow()
        if not CmdsFrame then return end
        if CmdsFrame:FindFirstChild("ListScroll") then return end -- Already created

        -- Search Bar Container
        local searchFrame = Instance.new("Frame")
        searchFrame.Name = "SearchFrame"
        searchFrame.Size = UDim2.new(1, -120, 0, 32)
        searchFrame.Position = UDim2.new(0, 5, 0, 5)
        searchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        searchFrame.Parent = CmdsFrame

        local searchCorner = Instance.new("UICorner")
        searchCorner.CornerRadius = UDim.new(0, 6)
        searchCorner.Parent = searchFrame

        local searchStroke = Instance.new("UIStroke")
        searchStroke.Color = Color3.fromRGB(40, 40, 45)
        searchStroke.Thickness = 1
        searchStroke.Parent = searchFrame

        local searchIcon = Instance.new("TextLabel")
        searchIcon.Name = "Icon"
        searchIcon.Size = UDim2.new(0, 20, 1, 0)
        searchIcon.Position = UDim2.new(0, 8, 0, 0)
        searchIcon.BackgroundTransparency = 1
        searchIcon.Font = Enum.Font.Gotham
        searchIcon.Text = "Ã°Å¸â€Â"
        searchIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
        searchIcon.TextSize = 14
        searchIcon.Parent = searchFrame

        local searchBox = Instance.new("TextBox")
        searchBox.Name = "SearchBox"
        searchBox.Size = UDim2.new(1, -38, 1, 0)
        searchBox.Position = UDim2.new(0, 30, 0, 0)
        searchBox.BackgroundTransparency = 1
        searchBox.Font = Enum.Font.Gotham
        searchBox.Text = ""
        searchBox.PlaceholderText = "Search commands..."
        searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        searchBox.TextSize = 14
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.ClearTextOnFocus = false
        searchBox.Parent = searchFrame

        -- Command Bar Button
        local barBtn = Instance.new("TextButton")
        barBtn.Name = "OpenBarBtn"
        barBtn.Size = UDim2.new(0, 105, 0, 32)
        barBtn.Position = UDim2.new(1, -110, 0, 5)
        barBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 80)
        barBtn.Text = "Command Bar"
        barBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        barBtn.Font = Enum.Font.GothamBold
        barBtn.TextSize = 12
        barBtn.Parent = CmdsFrame

        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0, 6)
        barCorner.Parent = barBtn

        barBtn.MouseButton1Click:Connect(function()
            showCmdBar()
        end)

        -- Scrolling Frame for commands
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ListScroll"
        scrollFrame.Size = UDim2.new(1, -10, 1, -45)
        scrollFrame.Position = UDim2.new(0, 5, 0, 40)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 220, 130)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #commandsList * 56 + 15)
        scrollFrame.Visible = true
        scrollFrame.Parent = CmdsFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = scrollFrame

        -- Render Command Items
        for idx, cmdData in ipairs(commandsList) do
            local renderSuccess, renderErr = pcall(function()
                local itemFrame = Instance.new("Frame")
                itemFrame.Name = "CmdItem"
                itemFrame.Size = UDim2.new(1, -8, 0, 48)
                itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                itemFrame.BackgroundTransparency = 0
                itemFrame.LayoutOrder = idx
                itemFrame.Visible = true
                itemFrame.Parent = scrollFrame

                local itemCorner = Instance.new("UICorner")
                itemCorner.CornerRadius = UDim.new(0, 6)
                itemCorner.Parent = itemFrame

                -- Store command name/description in StringValues
                local cmdNameVal = Instance.new("StringValue")
                cmdNameVal.Name = "CmdNameValue"
                cmdNameVal.Value = cmdData.name
                cmdNameVal.Parent = itemFrame

                local cmdDescVal = Instance.new("StringValue")
                cmdDescVal.Name = "CmdDescValue"
                cmdDescVal.Value = cmdData.desc
                cmdDescVal.Parent = itemFrame

                -- Dot Indicator
                local dot = Instance.new("Frame")
                dot.Name = "Dot"
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.Position = UDim2.new(0, 8, 0, 12)
                dot.BackgroundColor3 = Color3.fromRGB(0, 220, 130)
                dot.BorderSizePixel = 0
                dot.Parent = itemFrame
                local dotCorner = Instance.new("UICorner")
                dotCorner.CornerRadius = UDim.new(1, 0)
                dotCorner.Parent = dot

                -- Title and Aliases
                local aliasesStr = ""
                if #cmdData.aliases > 0 then
                    aliasesStr = "  (" .. table.concat(cmdData.aliases, ", ") .. ")"
                end

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "CmdTitle"
                nameLabel.Size = UDim2.new(1, -26, 0, 20)
                nameLabel.Position = UDim2.new(0, 22, 0, 4)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.TextSize = 12
                nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                nameLabel.Text = cmdData.name .. cmdData.usage .. aliasesStr
                nameLabel.Visible = true
                nameLabel.ZIndex = 10
                nameLabel.Parent = itemFrame

                -- Description
                local descLabel = Instance.new("TextLabel")
                descLabel.Name = "CmdDesc"
                descLabel.Size = UDim2.new(1, -26, 0, 18)
                descLabel.Position = UDim2.new(0, 22, 0, 24)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextSize = 10
                descLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                descLabel.Text = cmdData.desc
                descLabel.Visible = true
                descLabel.ZIndex = 10
                descLabel.Parent = itemFrame
            end)
            if not renderSuccess then
                warn("Failed to render command item " .. tostring(idx) .. ": " .. tostring(renderErr))
            end
        end

        -- Search Filtering Connection
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local query = string.lower(searchBox.Text)
            local visibleCount = 0
            for _, item in ipairs(scrollFrame:GetChildren()) do
                if item:IsA("Frame") and item.Name == "CmdItem" then
                    local cNameVal = item:FindFirstChild("CmdNameValue")
                    local cDescVal = item:FindFirstChild("CmdDescValue")
                    local cName = cNameVal and string.lower(cNameVal.Value) or ""
                    local cDesc = cDescVal and string.lower(cDescVal.Value) or ""
                    local visible = false
                    if string.find(cName, query, 1, true) or string.find(cDesc, query, 1, true) then
                        visible = true
                        visibleCount = visibleCount + 1
                    end
                    item.Visible = visible
                end
            end
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, visibleCount * 56 + 15)
        end)
    end

    showCommandsWindow = function()
        local success, err = pcall(createCommandsWindow)
        if not success then
            warn("Failed to create commands window: " .. tostring(err))
        end
        if setCategory then
            setCategory("Commands")
        end
    end

    local function handleChatCommand(message)
        if typeof(message) ~= "string" then return end
        
        local cleanMsg = message:gsub("^%s+", ""):gsub("%s+$", "")
        if cleanMsg == "" then return end
        
        -- Remove leading prefix if present (like ; or ' or \ or / or /e)
        local commandText = cleanMsg
        for _, prefix in ipairs({";", "'", "\\", "/", "/e "}) do
            if string.sub(string.lower(cleanMsg), 1, #prefix) == prefix then
                commandText = string.sub(cleanMsg, #prefix + 1):gsub("^%s+", "")
                break
            end
        end
        
        -- Split into command and arguments
        local args = {}
        for word in string.gmatch(commandText, "%S+") do
            table.insert(args, word)
        end
        
        if #args == 0 then return end
        
        local cmd = string.lower(args[1])
        table.remove(args, 1)
        local fullArgString = table.concat(args, " ")
        
        -- Command Handlers
        if cmd == "swp" or cmd == "savewp" or cmd == "savewaypoint" then
            local name = fullArgString
            if name and name ~= "" then
                local now = os.clock()
                if lastSavedWaypointName == name and (now - lastSavedWaypointTime) < 0.5 then
                    return
                end
                lastSavedWaypointName = name
                lastSavedWaypointTime = now
                
                local saveFunc = saveCurrentPositionAsWaypoint or (typeof(_G.saveCurrentPositionAsWaypoint) == "function" and _G.saveCurrentPositionAsWaypoint)
                if typeof(saveFunc) == "function" then
                    saveFunc(name)
                    pcall(function()
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "Waypoint Saved",
                            Text = "Saved waypoint: " .. name,
                            Duration = 3
                        })
                    end)
                end
            end
            
        elseif cmd == "tpwp" or cmd == "wp" then
            local name = fullArgString
            if name and name ~= "" then
                local comps = customWaypoints[name]
                if comps then
                    local ok, cf = pcall(function() return CFrame.new(table.unpack(comps)) end)
                    if ok and typeof(cf) == "CFrame" then
                        local lplr = game:GetService("Players").LocalPlayer
                        local char = lplr.Character or lplr.CharacterAdded:Wait()
                        if char then char:PivotTo(cf) end
                        notifyPlayer("Waypoint", "Teleported to: " .. name)
                    end
                else
                    notifyPlayer("Waypoint", "Waypoint tidak ditemukan: " .. name)
                end
            end

        elseif cmd == "speed" or cmd == "spd" or cmd == "ws" then
            local num = tonumber(fullArgString)
            if num then
                num = math.clamp(num, 16, 300)
                desiredSpeed = num
                if SpeedBox then SpeedBox.Text = tostring(desiredSpeed) end
                if speedOn then
                    local char = Player.Character
                    local hum = char and char:FindFirstChild("Humanoid")
                    if hum then hum.WalkSpeed = desiredSpeed end
                end
            else
                toggleSpeed()
            end
            
        elseif cmd == "fly" then
            if not flying then
                enableFly()
            end
            
        elseif cmd == "unfly" or cmd == "nofly" then
            if flying then
                disableFly()
            end

        elseif cmd == "flyv2" then
            launchFlyV2()

        elseif cmd == "flyv3" then
            if typeof(toggleFlyV3) == "function" then
                toggleFlyV3()
            end
            
        elseif cmd == "freecam" or cmd == "fc" then
            setFreecam(not freecamOn)
            
        elseif cmd == "nofreecam" or cmd == "nofc" then
            if freecamOn then
                setFreecam(false)
            end
            
        elseif cmd == "clicktp" or cmd == "ctp" then
            toggleClickTP()

        elseif cmd == "tp" or cmd == "teleport" then
            local targetName = fullArgString
            if targetName and targetName ~= "" then
                local target = findPlayerByQuery(targetName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character then
                    local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
                    player.Character:PivotTo(CFrame.new(targetPos))
                    notifyPlayer("Teleport", "Teleported to: " .. target.DisplayName)
                else
                    notifyPlayer("Teleport", "Pemain tidak ditemukan: " .. tostring(targetName))
                end
            end
            
        elseif cmd == "unanchor" then
            toggleUnanchor()

        elseif cmd == "fling" or cmd == "tendang" then
            hiddenfling = not hiddenfling
            if hiddenfling then
                setButtonActive(FlingBtn, true)
                flingThread = coroutine.create(fling)
                coroutine.resume(flingThread)
            else
                setButtonActive(FlingBtn, false)
            end
            
        elseif cmd == "explorer" or cmd == "dex" then
            launchDex()

        elseif cmd == "airwalk" or cmd == "walkonair" then
            toggleAirwalk()

        elseif cmd == "esp" then
            toggleESP()

        elseif cmd == "espteam" then
            toggleESPTeam()

        elseif cmd == "lampu" or cmd == "light" or cmd == "lamp" then
            toggleLampu()

        elseif cmd == "infjump" or cmd == "infinitejump" then
            toggleInfiniteJump()

        elseif cmd == "rejoin" or cmd == "rj" then
            rejoinServer()

        elseif cmd == "refresh" or cmd == "re" or cmd == "respawn" then
            refreshCharacter()

        elseif cmd == "antiafk" then
            toggleAntiAFK()

        elseif cmd == "serverhop" or cmd == "shop" then
            serverhop()

        elseif cmd == "bringpart" or cmd == "bp" then
            toggleBringPart()

        elseif cmd == "antilag" or cmd == "boost" then
            toggleAntiLag()

        elseif cmd == "noclip" then
            toggleNoclip()

        elseif cmd == "spectate" or cmd == "spectator" or cmd == "view" then
            launchSpectator()

        elseif cmd == "animasi" or cmd == "anims" then
            launchAnimasi()

        elseif cmd == "cmdbar" then
            showCmdBar()

        elseif cmd == "credits" then
            createCreditsWindow()
            setCategory("Credits")

        elseif cmd == "cmds" or cmd == "commands" then
            showCommandsWindow()
        end
    end

    -- Create Command Bar GUI (tiru cara dari Infinite Yield)
    local CmdBarGuiParent = nil
    local successParent, errParent = pcall(function()
        if typeof(gethui) == "function" then
            CmdBarGuiParent = gethui()
        elseif typeof(get_hidden_gui) == "function" then
            CmdBarGuiParent = get_hidden_gui()
        elseif game:GetService("CoreGui") then
            CmdBarGuiParent = game:GetService("CoreGui")
        else
            CmdBarGuiParent = PlayerGui
        end
    end)
    if not successParent or not CmdBarGuiParent then
        CmdBarGuiParent = PlayerGui
    end

    local CmdBarGui = Instance.new("ScreenGui")
    CmdBarGui.Name = "CHCmdBarGUI"
    CmdBarGui.ResetOnSpawn = false
    CmdBarGui.DisplayOrder = 2147483647
    CmdBarGui.IgnoreGuiInset = true
    CmdBarGui.Parent = CmdBarGuiParent

    -- Create Command Bar UI
    local CmdBarFrame = Instance.new("Frame")
    CmdBarFrame.Name = "CmdBarFrame"
    CmdBarFrame.Size = UDim2.new(0, 440, 0, 44)
    CmdBarFrame.Position = UDim2.new(0.5, -220, 0.5, -22)
    CmdBarFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    CmdBarFrame.BackgroundTransparency = 0.1
    CmdBarFrame.Visible = false
    CmdBarFrame.ZIndex = 99999
    CmdBarFrame.Active = true
    CmdBarFrame.Parent = CmdBarGui

    local cmdCorner = Instance.new("UICorner")
    cmdCorner.CornerRadius = UDim.new(0, 10)
    cmdCorner.Parent = CmdBarFrame

    local cmdStroke = Instance.new("UIStroke")
    cmdStroke.Color = Color3.fromRGB(0, 220, 130)
    cmdStroke.Thickness = 1.5
    cmdStroke.Transparency = 0
    cmdStroke.Parent = CmdBarFrame

    -- Drag bar (top strip)
    local dragHandle = Instance.new("Frame")
    dragHandle.Name = "DragHandle"
    dragHandle.Size = UDim2.new(1, 0, 1, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.ZIndex = 99999
    dragHandle.Parent = CmdBarFrame

    -- TextBox input
    local CmdBarInput = Instance.new("TextBox")
    CmdBarInput.Name = "CmdBarInput"
    CmdBarInput.Size = UDim2.new(1, -52, 1, -10)
    CmdBarInput.Position = UDim2.new(0, 10, 0, 5)
    CmdBarInput.BackgroundTransparency = 1
    CmdBarInput.Font = Enum.Font.GothamBold
    CmdBarInput.TextSize = 15
    CmdBarInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    CmdBarInput.TextTransparency = 0
    CmdBarInput.PlaceholderText = "Ketik perintah... (cth: swp nama)"
    CmdBarInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    CmdBarInput.TextXAlignment = Enum.TextXAlignment.Left
    CmdBarInput.Text = ""
    CmdBarInput.ClearTextOnFocus = false
    CmdBarInput.ZIndex = 100000
    CmdBarInput.Parent = CmdBarFrame

    -- Close (X) button
    local closeBarBtn = Instance.new("TextButton")
    closeBarBtn.Name = "CloseBarBtn"
    closeBarBtn.Size = UDim2.new(0, 36, 0, 36)
    closeBarBtn.Position = UDim2.new(1, -40, 0, 4)
    closeBarBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBarBtn.BackgroundTransparency = 0.2
    closeBarBtn.Text = "X"
    closeBarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBarBtn.TextSize = 16
    closeBarBtn.Font = Enum.Font.GothamBold
    closeBarBtn.ZIndex = 100001
    closeBarBtn.Parent = CmdBarFrame

    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBarBtn

    -- Drag logic
    do
        local dragging = false
        local dragStart, startPos

        dragHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = CmdBarFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                CmdBarFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    -- Prevent ' or ; from appearing when first opened via shortcut
    CmdBarInput:GetPropertyChangedSignal("Text"):Connect(function()
        if CmdBarInput.Text == "'" or CmdBarInput.Text == ";" then
            CmdBarInput.Text = ""
        end
    end)

    local function hideCmdBar()
        TweenService:Create(CmdBarFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(CmdBarFrame.Position.X.Scale, CmdBarFrame.Position.X.Offset,
                                  CmdBarFrame.Position.Y.Scale, CmdBarFrame.Position.Y.Offset - 40)
        }):Play()
        task.delay(0.18, function()
            CmdBarFrame.Visible = false
            CmdBarInput.Text = ""
        end)
    end

    closeBarBtn.MouseButton1Click:Connect(hideCmdBar)

    showCmdBar = function()
        local cx = CmdBarFrame.Position.X.Offset
        local cy = CmdBarFrame.Position.Y.Offset
        if not CmdBarFrame.Visible then
            -- Reset to center if first open
            CmdBarFrame.Position = UDim2.new(0.5, -220, 0.5, -62)
            CmdBarFrame.Visible = true
            TweenService:Create(CmdBarFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, -220, 0.5, -22)
            }):Play()
        end
        pcall(function() RunService.RenderStepped:Wait() end)
        CmdBarInput.Text = ""
        CmdBarInput:CaptureFocus()
    end

    -- Enter runs command but keeps bar open & re-focuses
    CmdBarInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local text = CmdBarInput.Text
            if text and text ~= "" then
                local ok, err = pcall(handleChatCommand, text)
                if not ok then
                    warn("Command Bar Error: " .. tostring(err))
                end
            end
            CmdBarInput.Text = ""
            -- Re-focus so user can keep typing (friendly for mobile)
            task.defer(function()
                if CmdBarFrame.Visible then
                    CmdBarInput:CaptureFocus()
                end
            end)
        end
        -- NOTE: tidak memanggil hideCmdBar() di sini supaya bar tetap terbuka
    end)

    -- Keybind ' to open Command Bar
    pcall(function()
        local Mouse = Player:GetMouse()
        Mouse.KeyDown:Connect(function(key)
            if key == "'" then
                showCmdBar()
            end
        end)
    end)

    -- Connect legacy chat event
    pcall(function()
        if Player then
            Player.Chatted:Connect(function(msg)
                pcall(handleChatCommand, msg)
            end)
        end
    end)

    -- Connect modern TextChatService event if applicable
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.MessageReceived:Connect(function(textChatMessage)
                if Player and textChatMessage.TextSource and textChatMessage.TextSource.UserId == Player.UserId then
                    pcall(handleChatCommand, textChatMessage.Text)
                end
            end)
        end
    end)
end)
if not success then
    warn("Failed to initialize command bar: " .. tostring(err))
end
