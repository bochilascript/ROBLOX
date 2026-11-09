-- Auto Teleport Script with UI
-- Sequence: CP1-30 → Summit1 → CP31-46 → Summit2 → CP47-60 → Summit3 → Basecamp
-- Total waktu ~15 menit (900 detik) dibagi rata ke semua waypoint

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- ============================================================
-- CONFIGURATION (Dynamic - bisa diatur via UI)
-- ============================================================
local TargetMinutes = 15  -- default 15 menit, bisa diubah di UI
local MIN_MINUTES = 5
local MAX_MINUTES = 30
local TOTAL_STOPS = 64   -- 61 CP + 3 Summit = 64 waypoints, +1 Basecamp nanti
local INTERVALS = TOTAL_STOPS - 1  -- 63 intervals

local function getDelayPerWaypoint()
    return (TargetMinutes * 60) / INTERVALS
end

local function getTargetTimeFormatted()
    local totalSec = TargetMinutes * 60
    local m = math.floor(totalSec / 60)
    local s = math.floor(totalSec % 60)
    return string.format("%02d:%02d", m, s)
end

local IsRunning = false
local LoopEnabled = false
local LoopCount = 0
local CurrentIndex = 1  -- posisi terakhir di sequence (untuk manual TP & resume)

-- ============================================================
-- SEQUENCE (Urutan yang benar)
-- ============================================================
local Sequence = {
    -- CP 1 - 30
    "1","2","3","4","5","6","7","8","9","10",
    "11","12","13","14","15","16","17","18","19","20",
    "21","22","23","24","25","26","27","28","29","30",
    -- Summit 1
    "Summit1",
    -- CP 31 - 46
    "31","32","33","34","35","36","37","38","39","40",
    "41","42","43","44","45","46",
    -- Summit 2
    "Summit2",
    -- CP 47 - 60 (51 tidak ada)
    "47","48","49","50","51","52","53","54","55","56","57","58","59","60",
    -- Summit 3
    "Summit3",
}

-- ============================================================
-- WAYPOINTS DATA (Door dihapus)
-- ============================================================
local Waypoints = {
    ['1'] = { -39.602760314941406, -445.82781982421875, -2047.157958984375, 0.99993896484375, 0, 0.011049048975110054, 0, 1, 0, -0.011049048975110054, 0, 0.99993896484375 },
    ['2'] = { -763.3936157226562, -440.2308044433594, -2047.8321533203125, -0.99993896484375, 0, -0.011049048975110054, 0, 1, 0, 0.011049048975110054, 0, -0.99993896484375 },
    ['3'] = { -1200.27978515625, -409.065185546875, -2058.96533203125, 0.5263622999191284, 0, 0.8502603769302368, 0, 1, 0, -0.8502603769302368, 0, 0.5263622999191284 },
    ['4'] = { -1790.4073486328125, -396.1968078613281, -1649.6978759765625, 0.8128194808959961, 0, 0.5825157165527344, 0, 1, 0, -0.5825157165527344, 0, 0.8128194808959961 },
    ['5'] = { -2181.809326171875, -316.470458984375, -1372.7607421875, 0.9762648344039917, 0, 0.2165801227092743, 0, 1, 0, -0.2165801227092743, 0, 0.9762648344039917 },
    ['6'] = { -2585.88916015625, -257.3282775878906, -868.4403076171875, 0.6130572557449341, 0, 0.7900384664535522, 0, 1, 0, -0.7900384664535522, 0, 0.6130572557449341 },
    ['7'] = { -2970.87841796875, -255.894287109375, -344.25579833984375, 0.41178226470947266, 0, 0.9112823009490967, 0, 1, 0, -0.9112823009490967, 0, 0.41178226470947266 },
    ['8'] = { -3076.01220703125, -221.64627075195312, 86.81864166259766, -0.9999475479125977, 0, 0.010272185318171978, 0, 1, 0, -0.010272185318171978, 0, -0.9999475479125977 },
    ['9'] = { -3418.9599609375, -189.24891662597656, -75.70112609863281, -0.9298096895217896, 0.0035068828146904707, 0.36802446842193604, 0.006837847642600536, 0.9999465942382812, 0.00774731207638979, -0.36797767877578735, 0.009720019064843655, -0.9297839403152466 },
    ['10'] = { -2963.39501953125, -161.24862670898438, 141.07516479492188, -0.7132464647293091, 0, 0.7009139060974121, 0, 1, 0, -0.7009139060974121, 0, -0.7132464647293091 },
    ['11'] = { -2560.7880859375, -117.06157684326172, 503.7752990722656, -0.7132464647293091, 0, 0.7009139060974121, 0, 1, 0, -0.7009139060974121, 0, -0.7132464647293091 },
    ['12'] = { -2204.171142578125, -192.25003051757812, 877.6216430664062, -0.7132464647293091, 0, 0.7009139060974121, 0, 1, 0, -0.7009139060974121, 0, -0.7132464647293091 },
    ['13'] = { -1949.82421875, -107.00003051757812, 1118.5667724609375, -0.7132464647293091, 0, 0.7009139060974121, 0, 1, 0, -0.7009139060974121, 0, -0.7132464647293091 },
    ['14'] = { -1692.9918212890625, -65.15070343017578, 1413.4444580078125, -0.8521722555160522, 0, 0.5232616066932678, 0, 1, 0, -0.5232616066932678, 0, -0.8521722555160522 },
    ['15'] = { -1023.1178588867188, 92.15010833740234, 1929.338134765625, -0.8521722555160522, 0, 0.5232616066932678, 0, 1, 0, -0.5232616066932678, 0, -0.8521722555160522 },
    ['16'] = { -1081.266357421875, 142.80467224121094, 2345.054443359375, -0.23513579368591309, 0, 0.9719625115394592, 0, 1, 0, -0.9719625115394592, 0, -0.23513579368591309 },
    ['17'] = { -891.533203125, 154.9279022216797, 2476.693603515625, -0.9663119316101074, 0, -0.25737494230270386, 0, 1, 0, 0.25737494230270386, 0, -0.9663119316101074 },
    ['18'] = { -1369.81298828125, 178.75, 2313.856689453125, -0.9552162885665894, 0, -0.29590874910354614, 0, 1, 0, 0.29590874910354614, 0, -0.9552162885665894 },
    ['19'] = { -1217.6195068359375, 186.7979278564453, 2172.91064453125, -0.823849081993103, 0, 0.5668092370033264, 0, 1, 0, -0.5668092370033264, 0, -0.823849081993103 },
    ['20'] = { -727.58251953125, 204.9434356689453, 2189.258544921875, -0.8038957118988037, 0, 0.5947709083557129, 0, 1, 0, -0.5947709083557129, 0, -0.8038957118988037 },
    ['21'] = { -968.112060546875, 214.8636474609375, 1973.055419921875, -0.7902032136917114, 0, 0.6128448843955994, 0, 1, 0, -0.6128448843955994, 0, -0.7902032136917114 },
    ['22'] = { -1036.9462890625, 290.28125, 2312.305419921875, -0.8343451023101807, 0, 0.551242470741272, 0, 1, 0, -0.551242470741272, 0, -0.8343451023101807 },
    ['23'] = { -567.8616333007812, 302.0621032714844, 2126.623046875, -0.6947848796844482, 0, 0.7192177772521973, 0, 1, 0, -0.7192177772521973, 0, -0.6947848796844482 },
    ['24'] = { -605.412109375, 330.9400634765625, 1861.9896240234375, -0.989930272102356, 0, -0.14155566692352295, 0, 1, 0, 0.14155566692352295, 0, -0.989930272102356 },
    ['25'] = { -727.60546875, 383.1625061035156, 1998.6015625, -0.6372699737548828, 0, 0.7706405520439148, 0, 1, 0, -0.7706405520439148, 0, -0.6372699737548828 },
    ['26'] = { -912.87744140625, 460.8364562988281, 2198.6240234375, -0.661766767501831, 0, 0.7497102618217468, 0, 1, 0, -0.7497102618217468, 0, -0.661766767501831 },
    ['27'] = { -416.7947998046875, 652.0316162109375, 2415.37548828125, -0.9976334571838379, 0, 0.06875792890787125, 0, 1, 0, -0.06875792890787125, 0, -0.9976334571838379 },
    ['28'] = { -435.54833984375, 768.499755859375, 2766.34228515625, -0.7939882278442383, 0, 0.6079330444335938, 0, 1, 0, -0.6079330444335938, 0, -0.7939882278442383 },
    ['29'] = { -1127.1597900390625, 807, 3372.840087890625, -0.7081245183944702, 0, 0.7060877084732056, 0, 1, 0, -0.7060877084732056, 0, -0.7081245183944702 },
    ['30'] = { -1665.0789794921875, 861.7049560546875, 3896.12109375, -0.6922168731689453, 0, 0.7216900587081909, 0, 1, 0, -0.7216900587081909, 0, -0.6922168731689453 },
    ['31'] = { -3208.1259765625, 1224.1087646484375, 5415.60595703125, 0.7156596183776855, 0, 0.6984492540359497, 0, 1, 0, -0.6984492540359497, 0, 0.7156596183776855 },
    ['32'] = { -4131.05419921875, 1286.1617431640625, 6334.318359375, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['33'] = { -4779.71728515625, 1246.672119140625, 6973.67822265625, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['34'] = { -5104.7490234375, 1280.383056640625, 7296.62451171875, -0.9922061562538147, -1.196546950410493e-08, 0.12460702657699585, -1.290443218948667e-08, 1, -6.728254842158776e-09, -0.12460702657699585, -8.28379942419133e-09, -0.9922061562538147 },
    ['35'] = { -5906.7548828125, 1349.5059814453125, 8050.458984375, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['36'] = { -5739.99169921875, 1535.8084716796875, 7995.68798828125, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['37'] = { -5800.921875, 1653.548583984375, 8926.6435546875, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['38'] = { -6269.56396484375, 1769.7003173828125, 9539.9169921875, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['39'] = { -6566.14892578125, 1920.9962158203125, 10077.556640625, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['40'] = { -6986.53173828125, 1984.10498046875, 11040.6572265625, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['41'] = { -7196.86083984375, 2149.434326171875, 11415.978515625, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['42'] = { -7187.53759765625, 2249.607666015625, 11425.451171875, 0.4808754324913025, 0, 0.8767889142036438, 0, 1, 0, -0.8767889142036438, 0, 0.4808754324913025 },
    ['43'] = { -7560.58935546875, 2336.252197265625, 12171.2119140625, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['44'] = { -8046.4521484375, 2340.252197265625, 13035.5556640625, 0.6907247304916382, 0, 0.7231178283691406, 0, 1, 0, -0.7231178283691406, 0, 0.6907247304916382 },
    ['45'] = { -8595.0634765625, 2341.600341796875, 14021.45703125, 0.4894595146179199, 0, 0.8720260262489319, 0, 1, 0, -0.8720260262489319, 0, 0.4894595146179199 },
    ['46'] = { -8886.265625, 2631.393310546875, 14546.599609375, 0.4894595146179199, 0, 0.8720260262489319, 0, 1, 0, -0.8720260262489319, 0, 0.4894595146179199 },
    ['47'] = { -10202.1630859375, 3108.33251953125, 16887.615234375, 0.4894595146179199, 0, 0.8720260262489319, 0, 1, 0, -0.8720260262489319, 0, 0.4894595146179199 },
    ['48'] = { -10865.791015625, 3187.33251953125, 18173.337890625, 0.4894595146179199, 0, 0.8720260262489319, 0, 1, 0, -0.8720260262489319, 0, 0.4894595146179199 },
    ['49'] = { -11208.8837890625, 3385.33251953125, 18026.61328125, 0.4894595146179199, 0, 0.8720260262489319, 0, 1, 0, -0.8720260262489319, 0, 0.4894595146179199 },
    ['50'] = { -11019.734375, 3501.33251953125, 18480.263671875, 0.4894595146179199, 0, 0.8720260262489319, 0, 1, 0, -0.8720260262489319, 0, 0.4894595146179199 },
    ['51'] = {-9844.9912109375,3565.006591796875,19292.74609375,-0.8719677925109863,-0.006268313154578209,0.4895232021808624,0.0005895465146750212,0.9999038577079773,0.013853839598596096,-0.4895629584789276,0.012368698604404927,-0.871880292892456},
    ['52'] = { -9966.939453125, 3645.348388671875, 18880.3125, -0.8719677925109863, -0.006268313154578209, 0.4895232021808624, 0.0005895465146750212, 0.9999038577079773, 0.013853839598596096, -0.4895629584789276, 0.012368698604404926, -0.871880292892456 },
    ['53'] = { -10439.640625, 3645.13671875, 18980.796875, -0.8719677925109863, -0.006268313154578209, 0.4895232021808624, 0.0005895465146750212, 0.9999038577079773, 0.013853839598596096, -0.4895629584789276, 0.012368698604404926, -0.871880292892456 },
    ['54'] = { -10497.7919921875, 3856.693359375, 19393.080078125, -0.8719677925109863, -0.006268313154578209, 0.4895232021808624, 0.0005895465146750212, 0.9999038577079773, 0.013853839598596096, -0.4895629584789276, 0.012368698604404926, -0.871880292892456 },
    ['55'] = { -10226.794921875, 3949.18505859375, 19006.486328125, -0.8719677925109863, -0.006268313154578209, 0.4895232021808624, 0.0005895465146750212, 0.9999038577079773, 0.013853839598596096, -0.4895629584789276, 0.012368698604404926, -0.871880292892456 },
    ['56'] = { -8704.10546875, 3916.33251953125, 19461.982421875, -0.9547500610351562, 0, 0.2974095642566681, 0, 1, 0, -0.2974095642566681, 0, -0.9547500610351562 },
    ['57'] = { -7827.6220703125, 4062.33251953125, 19653.228515625, -0.8720157146453857, 0, 0.48947787284851074, 0, 1, 0, -0.48947787284851074, 0, -0.8720157146453857 },
    ['58'] = { -7671.212890625, 4126.33251953125, 19070.4453125, -0.4894595146179199, 0, -0.8720260262489319, 0, 1, 0, 0.8720260262489319, 0, -0.4894595146179199 },
    ['59'] = { -7573.64697265625, 4618.33251953125, 18701.01953125, -0.25623464584350586, 0, -0.9666146039962769, 0, 1, 0, 0.9666146039962769, 0, -0.25623464584350586 },
    ['60'] = { -7297.947265625, 4749.9384765625, 17686.236328125, -0.25991499423980713, 0, -0.9656315445899963, 0, 1, 0, 0.9656315445899963, 0, -0.25991499423980713 },
    ['Basecamp'] = { 643.4777221679688, -380.3736267089844, -2047.0133056640625, -9.298324584960938e-06, 0.9997743964195251, -0.02124033309519291, 0.9999999403953552, 9.298324584960938e-06, -9.872019290924072e-08, 9.872019290924072e-08, -0.02124033309519291, -0.9997744560241699 },
    ['Summit1'] = { -2938.5703125, 1299.238525390625, 5156.52685546875, 0.682720422744751, 0.014175484888255596, -0.7305421233177185, -0.017337867990136147, 0.9998445510864258, 0.003198124933987856, 0.7304739356040955, 0.01048261858522892, 0.6828601360321045 },
    ['Summit2'] = { -9967.2216796875, 3127.38916015625, 16470.90234375, 0.8727096915245056, 0.01421638298779726, -0.4880324900150299, -0.017524784430861473, 0.999843955039978, -0.0022127307020127773, 0.4879249036312103, 0.010483736172318459, 0.872822642326355 },
    ['Summit3'] = { -6331.85107421875, 5085.443359375, 14090.947265625, -0.31036508083343506, 0.014216133393347263, -0.95051109790802, -0.005552482791244984, 0.9998440146446228, 0.016766993328928947, 0.9506012201309204, 0.010481586679816246, -0.3102377653121948 },
}

-- ============================================================
-- CORE FUNCTIONS
-- ============================================================
local function buildCFrame(data)
    if type(data) ~= "table" or data[1] == nil or data[2] == nil or data[3] == nil then
        return nil
    end
    if data[4] ~= nil and data[5] ~= nil and data[6] ~= nil and data[7] ~= nil and data[8] ~= nil and data[9] ~= nil and data[10] ~= nil and data[11] ~= nil and data[12] ~= nil then
        return CFrame.new(data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11], data[12])
    end
    return CFrame.new(data[1], data[2], data[3])
end

local CachedWaypoints = {}
for name, raw in pairs(Waypoints) do
    local cf = buildCFrame(raw)
    if cf then
        CachedWaypoints[name] = cf
    end
end

local function getPlayerRoot()
    local player = Players.LocalPlayer
    if not player then return nil end
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

local function teleportTo(name)
    local waypoint = CachedWaypoints[name]
    if waypoint == nil then
        return false, "Waypoint not found: " .. tostring(name)
    end
    local root = getPlayerRoot()
    if not root then
        return false, "Character/HumanoidRootPart not found"
    end
    root.CFrame = waypoint
    return true
end

local function teleportToBasecamp()
    local args = {"Basecamp"}
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("TeleportConfirm")
    remote:FireServer(unpack(args))
end

-- ============================================================
-- UI CREATION
-- ============================================================
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hapus UI lama jika ada
if playerGui:FindFirstChild("AutoTPGui") then
    playerGui:FindFirstChild("AutoTPGui"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoTPGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

-- ==================== MAIN FRAME ====================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 470)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -235)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.ClipsDescendants = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 120, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.3
mainStroke.Parent = MainFrame

-- Glow effect (gradient overlay)
local GlowFrame = Instance.new("Frame")
GlowFrame.Name = "Glow"
GlowFrame.Size = UDim2.new(1, 0, 0, 80)
GlowFrame.Position = UDim2.new(0, 0, 0, 0)
GlowFrame.BackgroundColor3 = Color3.fromRGB(40, 80, 200)
GlowFrame.BackgroundTransparency = 0.85
GlowFrame.BorderSizePixel = 0
GlowFrame.Parent = MainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 12)
glowCorner.Parent = GlowFrame

-- ==================== TITLE BAR ====================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 25, 45)
TitleBar.BackgroundTransparency = 0.3
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⛰️ Auto Teleport"
TitleLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinimizeBtn"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(180, 180, 220)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TitleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- ==================== CONTENT AREA ====================
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(0, 260, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- ==================== MANUAL TP PANEL (RIGHT SIDE) ====================
local ManualPanel = Instance.new("Frame")
ManualPanel.Name = "ManualPanel"
ManualPanel.Size = UDim2.new(0, 170, 1, -50)
ManualPanel.Position = UDim2.new(0, 280, 0, 45)
ManualPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 35)
ManualPanel.BorderSizePixel = 0
ManualPanel.Parent = MainFrame

local manualPanelCorner = Instance.new("UICorner")
manualPanelCorner.CornerRadius = UDim.new(0, 10)
manualPanelCorner.Parent = ManualPanel

local manualPanelStroke = Instance.new("UIStroke")
manualPanelStroke.Color = Color3.fromRGB(60, 80, 140)
manualPanelStroke.Thickness = 1
manualPanelStroke.Transparency = 0.5
manualPanelStroke.Parent = ManualPanel

-- Manual TP Title
local ManualTitle = Instance.new("TextLabel")
ManualTitle.Name = "ManualTitle"
ManualTitle.Size = UDim2.new(1, 0, 0, 28)
ManualTitle.Position = UDim2.new(0, 0, 0, 2)
ManualTitle.BackgroundTransparency = 1
ManualTitle.Text = "📋 Manual TP"
ManualTitle.TextColor3 = Color3.fromRGB(200, 220, 255)
ManualTitle.TextSize = 13
ManualTitle.Font = Enum.Font.GothamBold
ManualTitle.Parent = ManualPanel

-- Scrollable list
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "WaypointList"
ScrollFrame.Size = UDim2.new(1, -10, 1, -34)
ScrollFrame.Position = UDim2.new(0, 5, 0, 32)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  -- auto-sized below
ScrollFrame.Parent = ManualPanel

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = ScrollFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(1, 0, 0, 22)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.GothamSemibold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = ContentFrame

-- Current Waypoint Label
local WaypointLabel = Instance.new("TextLabel")
WaypointLabel.Name = "Waypoint"
WaypointLabel.Size = UDim2.new(1, 0, 0, 22)
WaypointLabel.Position = UDim2.new(0, 0, 0, 24)
WaypointLabel.BackgroundTransparency = 1
WaypointLabel.Text = "Current: —"
WaypointLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
WaypointLabel.TextSize = 13
WaypointLabel.Font = Enum.Font.Gotham
WaypointLabel.TextXAlignment = Enum.TextXAlignment.Left
WaypointLabel.Parent = ContentFrame

-- Progress Label
local ProgressLabel = Instance.new("TextLabel")
ProgressLabel.Name = "Progress"
ProgressLabel.Size = UDim2.new(1, 0, 0, 22)
ProgressLabel.Position = UDim2.new(0, 0, 0, 48)
ProgressLabel.BackgroundTransparency = 1
ProgressLabel.Text = "Progress: 0 / " .. #Sequence .. " (+Basecamp)"
ProgressLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
ProgressLabel.TextSize = 13
ProgressLabel.Font = Enum.Font.Gotham
ProgressLabel.TextXAlignment = Enum.TextXAlignment.Left
ProgressLabel.Parent = ContentFrame

-- Progress Bar Background
local ProgressBarBG = Instance.new("Frame")
ProgressBarBG.Name = "ProgressBarBG"
ProgressBarBG.Size = UDim2.new(1, 0, 0, 8)
ProgressBarBG.Position = UDim2.new(0, 0, 0, 74)
ProgressBarBG.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
ProgressBarBG.BorderSizePixel = 0
ProgressBarBG.Parent = ContentFrame

local pbgCorner = Instance.new("UICorner")
pbgCorner.CornerRadius = UDim.new(0, 4)
pbgCorner.Parent = ProgressBarBG

-- Progress Bar Fill
local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Name = "Fill"
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.Parent = ProgressBarBG

local pbfCorner = Instance.new("UICorner")
pbfCorner.CornerRadius = UDim.new(0, 4)
pbfCorner.Parent = ProgressBarFill

local pbfGradient = Instance.new("UIGradient")
pbfGradient.Color = ColorSequence.new(Color3.fromRGB(60, 120, 255), Color3.fromRGB(140, 80, 255))
pbfGradient.Parent = ProgressBarFill

-- Timer Label
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Name = "Timer"
TimerLabel.Size = UDim2.new(1, 0, 0, 22)
TimerLabel.Position = UDim2.new(0, 0, 0, 88)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "⏱️ Time: 00:00 / ~" .. getTargetTimeFormatted()
TimerLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
TimerLabel.TextSize = 13
TimerLabel.Font = Enum.Font.GothamSemibold
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
TimerLabel.Parent = ContentFrame

-- Loop Count Label
local LoopLabel = Instance.new("TextLabel")
LoopLabel.Name = "LoopCount"
LoopLabel.Size = UDim2.new(1, 0, 0, 22)
LoopLabel.Position = UDim2.new(0, 0, 0, 112)
LoopLabel.BackgroundTransparency = 1
LoopLabel.Text = "🔁 Loop: 0"
LoopLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
LoopLabel.TextSize = 13
LoopLabel.Font = Enum.Font.Gotham
LoopLabel.TextXAlignment = Enum.TextXAlignment.Left
LoopLabel.Parent = ContentFrame

-- Delay Info Label
local DelayLabel = Instance.new("TextLabel")
DelayLabel.Name = "DelayInfo"
DelayLabel.Size = UDim2.new(1, 0, 0, 22)
DelayLabel.Position = UDim2.new(0, 0, 0, 136)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = string.format("⏳ Delay: %.1fs per CP", getDelayPerWaypoint())
DelayLabel.TextColor3 = Color3.fromRGB(150, 170, 200)
DelayLabel.TextSize = 12
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = ContentFrame

-- Separator 1
local Separator = Instance.new("Frame")
Separator.Size = UDim2.new(1, 0, 0, 1)
Separator.Position = UDim2.new(0, 0, 0, 162)
Separator.BackgroundColor3 = Color3.fromRGB(50, 60, 100)
Separator.BorderSizePixel = 0
Separator.Parent = ContentFrame

-- ==================== TIME INPUT ====================
local TimeInputLabel = Instance.new("TextLabel")
TimeInputLabel.Name = "TimeInputLabel"
TimeInputLabel.Size = UDim2.new(0, 110, 0, 28)
TimeInputLabel.Position = UDim2.new(0, 0, 0, 170)
TimeInputLabel.BackgroundTransparency = 1
TimeInputLabel.Text = "⏱️ Waktu (menit):"
TimeInputLabel.TextColor3 = Color3.fromRGB(200, 210, 240)
TimeInputLabel.TextSize = 12
TimeInputLabel.Font = Enum.Font.GothamSemibold
TimeInputLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeInputLabel.Parent = ContentFrame

-- Minus Button
local MinusBtn = Instance.new("TextButton")
MinusBtn.Name = "MinusBtn"
MinusBtn.Size = UDim2.new(0, 32, 0, 28)
MinusBtn.Position = UDim2.new(0, 115, 0, 170)
MinusBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
MinusBtn.BorderSizePixel = 0
MinusBtn.Text = "−"
MinusBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
MinusBtn.TextSize = 18
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.Parent = ContentFrame

local minusBtnCorner = Instance.new("UICorner")
minusBtnCorner.CornerRadius = UDim.new(0, 6)
minusBtnCorner.Parent = MinusBtn

-- Time TextBox
local TimeInput = Instance.new("TextBox")
TimeInput.Name = "TimeInput"
TimeInput.Size = UDim2.new(0, 55, 0, 28)
TimeInput.Position = UDim2.new(0, 150, 0, 170)
TimeInput.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
TimeInput.BorderSizePixel = 0
TimeInput.Text = tostring(TargetMinutes)
TimeInput.PlaceholderText = "15"
TimeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 140)
TimeInput.TextSize = 14
TimeInput.Font = Enum.Font.GothamBold
TimeInput.ClearTextOnFocus = false
TimeInput.Parent = ContentFrame

local timeInputCorner = Instance.new("UICorner")
timeInputCorner.CornerRadius = UDim.new(0, 6)
timeInputCorner.Parent = TimeInput

local timeInputStroke = Instance.new("UIStroke")
timeInputStroke.Color = Color3.fromRGB(80, 100, 180)
timeInputStroke.Thickness = 1.5
timeInputStroke.Parent = TimeInput

-- Plus Button
local PlusBtn = Instance.new("TextButton")
PlusBtn.Name = "PlusBtn"
PlusBtn.Size = UDim2.new(0, 32, 0, 28)
PlusBtn.Position = UDim2.new(0, 208, 0, 170)
PlusBtn.BackgroundColor3 = Color3.fromRGB(50, 70, 80)
PlusBtn.BorderSizePixel = 0
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
PlusBtn.TextSize = 18
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.Parent = ContentFrame

local plusBtnCorner = Instance.new("UICorner")
plusBtnCorner.CornerRadius = UDim.new(0, 6)
plusBtnCorner.Parent = PlusBtn

-- Function to update all time-related UI
local function updateTimeUI()
    local delay = getDelayPerWaypoint()
    DelayLabel.Text = string.format("⏳ Delay: %.1fs per CP", delay)
    TimerLabel.Text = "⏱️ Time: 00:00 / ~" .. getTargetTimeFormatted()
    TimeInput.Text = tostring(TargetMinutes)
end

-- Minus button: kurangi 1 menit
MinusBtn.MouseButton1Click:Connect(function()
    if IsRunning then return end
    TargetMinutes = math.max(MIN_MINUTES, TargetMinutes - 1)
    updateTimeUI()
end)

-- Plus button: tambah 1 menit
PlusBtn.MouseButton1Click:Connect(function()
    if IsRunning then return end
    TargetMinutes = math.min(MAX_MINUTES, TargetMinutes + 1)
    updateTimeUI()
end)

-- Manual text input
TimeInput.FocusLost:Connect(function(enterPressed)
    if IsRunning then
        TimeInput.Text = tostring(TargetMinutes)
        return
    end
    local num = tonumber(TimeInput.Text)
    if num and num >= MIN_MINUTES and num <= MAX_MINUTES then
        TargetMinutes = math.floor(num)
    end
    updateTimeUI()
end)

-- Separator 2
local Separator2 = Instance.new("Frame")
Separator2.Size = UDim2.new(1, 0, 0, 1)
Separator2.Position = UDim2.new(0, 0, 0, 205)
Separator2.BackgroundColor3 = Color3.fromRGB(50, 60, 100)
Separator2.BorderSizePixel = 0
Separator2.Parent = ContentFrame

-- ==================== BUTTONS ====================
local function createButton(name, text, pos, color, textColor)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = ContentFrame
    btn.AutoButtonColor = true

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    return btn
end

-- Start Button
local StartBtn = createButton(
    "StartBtn",
    "▶  START",
    UDim2.new(0, 0, 0, 215),
    Color3.fromRGB(30, 140, 70),
    Color3.fromRGB(220, 255, 230)
)

-- Stop Button
local StopBtn = createButton(
    "StopBtn",
    "⏹  STOP",
    UDim2.new(0, 0, 0, 258),
    Color3.fromRGB(160, 40, 40),
    Color3.fromRGB(255, 210, 210)
)

-- Loop Toggle Button
local LoopBtn = createButton(
    "LoopBtn",
    "🔁  LOOP: OFF",
    UDim2.new(0, 0, 0, 301),
    Color3.fromRGB(50, 50, 80),
    Color3.fromRGB(180, 180, 220)
)

-- Route Info
local RouteInfo = Instance.new("TextLabel")
RouteInfo.Name = "RouteInfo"
RouteInfo.Size = UDim2.new(1, 0, 0, 30)
RouteInfo.Position = UDim2.new(0, 0, 0, 345)
RouteInfo.BackgroundTransparency = 1
RouteInfo.Text = "CP1→30 ▸ S1 ▸ CP31→46 ▸ S2 ▸ CP47→60 ▸ S3 ▸ Base"
RouteInfo.TextColor3 = Color3.fromRGB(120, 140, 180)
RouteInfo.TextSize = 10
RouteInfo.Font = Enum.Font.Gotham
RouteInfo.TextXAlignment = Enum.TextXAlignment.Center
RouteInfo.TextWrapped = true
RouteInfo.Parent = ContentFrame

-- ============================================================
-- MANUAL TP BUTTONS (populate scroll list)
-- ============================================================
local manualButtons = {}  -- store references

local function getButtonColor(name)
    if name == "Summit1" or name == "Summit2" or name == "Summit3" then
        return Color3.fromRGB(120, 60, 20), Color3.fromRGB(255, 200, 120)  -- orange/gold for summits
    elseif name == "Basecamp" then
        return Color3.fromRGB(30, 100, 60), Color3.fromRGB(180, 255, 200)  -- green for base
    else
        return Color3.fromRGB(30, 35, 60), Color3.fromRGB(180, 200, 255)  -- blue-ish for CPs
    end
end

local function getButtonLabel(name)
    if name == "Summit1" then return "⛰️ Summit 1"
    elseif name == "Summit2" then return "⛰️ Summit 2"
    elseif name == "Summit3" then return "⛰️ Summit 3"
    elseif name == "Basecamp" then return "🏕️ Basecamp"
    else return "📍 CP " .. name
    end
end

-- Build the full list: Sequence + Basecamp
local FullList = {}
for i, v in ipairs(Sequence) do
    table.insert(FullList, v)
end
table.insert(FullList, "Basecamp")

local function highlightCurrentButton()
    for idx, btn in ipairs(manualButtons) do
        local name = FullList[idx]
        local bgColor, _ = getButtonColor(name)
        if idx == CurrentIndex then
            -- Highlight active
            btn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = bgColor
            local _, txtColor = getButtonColor(name)
            btn.TextColor3 = txtColor
        end
    end
end

local function updateProgressUI()
    local totalSteps = #FullList
    ProgressLabel.Text = "Progress: " .. CurrentIndex .. " / " .. totalSteps
    ProgressBarFill.Size = UDim2.new(CurrentIndex / totalSteps, 0, 1, 0)
    if CurrentIndex <= #Sequence then
        WaypointLabel.Text = "Current: " .. getSectionLabel(Sequence[CurrentIndex])
    else
        WaypointLabel.Text = "Current: 🏕️ BASECAMP"
    end
    highlightCurrentButton()
end

for idx, name in ipairs(FullList) do
    local bgColor, txtColor = getButtonColor(name)
    local label = getButtonLabel(name)

    local btn = Instance.new("TextButton")
    btn.Name = "ManualTP_" .. name
    btn.Size = UDim2.new(1, -6, 0, 26)
    btn.BackgroundColor3 = bgColor
    btn.BorderSizePixel = 0
    btn.Text = label
    btn.TextColor3 = txtColor
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamSemibold
    btn.LayoutOrder = idx
    btn.AutoButtonColor = true
    btn.Parent = ScrollFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn

    -- Click handler: manual teleport
    btn.MouseButton1Click:Connect(function()
        if IsRunning then return end  -- jangan manual TP saat auto running

        CurrentIndex = idx

        if name == "Basecamp" then
            teleportToBasecamp()
            StatusLabel.Text = "Status: 🏕️ Manual → Basecamp"
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 180)
        else
            local ok, err = teleportTo(name)
            if ok then
                StatusLabel.Text = "Status: 📍 Manual → " .. label
                StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            else
                StatusLabel.Text = "Status: ❌ " .. tostring(err)
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            end
        end

        updateProgressUI()
    end)

    -- Hover effect
    btn.MouseEnter:Connect(function()
        if idx ~= CurrentIndex then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 70, 130)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if idx ~= CurrentIndex then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = bgColor}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 100, 200)}):Play()
        end
    end)

    table.insert(manualButtons, btn)
end

-- Set canvas size based on content
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 6)
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 6)
end)

-- Initial highlight
highlightCurrentButton()

-- ============================================================
-- DRAGGING
-- ============================================================
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================================
-- MINIMIZE / CLOSE
-- ============================================================
local isMinimized = false

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        ManualPanel.Visible = false
        MainFrame.Size = UDim2.new(0, 460, 0, 40)
        MinBtn.Text = "+"
    else
        ContentFrame.Visible = true
        ManualPanel.Visible = true
        MainFrame.Size = UDim2.new(0, 460, 0, 470)
        MinBtn.Text = "—"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    IsRunning = false
    ScreenGui:Destroy()
end)

-- ============================================================
-- BUTTON LOGIC
-- ============================================================

-- Format waktu mm:ss
local function formatTime(seconds)
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d", m, s)
end

-- Get section label
local function getSectionLabel(name)
    if name == "Summit1" then return "⛰️ SUMMIT 1"
    elseif name == "Summit2" then return "⛰️ SUMMIT 2"
    elseif name == "Summit3" then return "⛰️ SUMMIT 3"
    else return "📍 CP " .. name
    end
end

-- Start sequence (mulai dari CurrentIndex, bisa resume)
local function runSequence()
    LoopCount = LoopCount + 1
    LoopLabel.Text = "🔁 Loop: " .. LoopCount

    local startTime = tick()
    local totalSteps = #FullList  -- Sequence + Basecamp
    local startIdx = CurrentIndex

    -- Jika sudah di Basecamp (last index), mulai dari awal
    if startIdx > #Sequence then
        startIdx = 1
        CurrentIndex = 1
    end

    -- Teleport semua CP/Summit mulai dari startIdx
    for i = startIdx, #Sequence do
        if not IsRunning then break end

        local name = Sequence[i]
        CurrentIndex = i

        -- Update UI
        StatusLabel.Text = "Status: ▶ Running"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        WaypointLabel.Text = "Current: " .. getSectionLabel(name)
        ProgressLabel.Text = "Progress: " .. i .. " / " .. totalSteps
        ProgressBarFill.Size = UDim2.new(i / totalSteps, 0, 1, 0)
        highlightCurrentButton()

        -- Teleport
        local ok, err = teleportTo(name)
        if not ok then
            warn("[AutoTP] " .. tostring(err))
        end

        -- Wait with countdown timer update (delay dinamis)
        local currentDelay = getDelayPerWaypoint()
        local waitEnd = tick() + currentDelay
        while tick() < waitEnd and IsRunning do
            local elapsed = tick() - startTime
            TimerLabel.Text = "⏱️ Time: " .. formatTime(elapsed) .. " / ~" .. getTargetTimeFormatted()
            task.wait(0.5)
        end
    end

    -- Teleport ke Basecamp
    if IsRunning then
        CurrentIndex = #FullList  -- Basecamp = last index
        StatusLabel.Text = "Status: 🏕️ Returning to Basecamp..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        WaypointLabel.Text = "Current: 🏕️ BASECAMP"
        ProgressLabel.Text = "Progress: " .. totalSteps .. " / " .. totalSteps
        ProgressBarFill.Size = UDim2.new(1, 0, 1, 0)
        highlightCurrentButton()

        teleportToBasecamp()

        local elapsed = tick() - startTime
        TimerLabel.Text = "⏱️ Time: " .. formatTime(elapsed) .. " / ~" .. getTargetTimeFormatted()

        task.wait(3)  -- tunggu sebentar di basecamp

        -- Reset CurrentIndex untuk loop berikutnya
        CurrentIndex = 1
    end
end

-- Start button
StartBtn.MouseButton1Click:Connect(function()
    if IsRunning then return end
    IsRunning = true
    LoopCount = 0

    -- Disable time input saat running
    TimeInput.TextEditable = false
    StartBtn.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
    StartBtn.Text = "▶  RUNNING..."

    task.spawn(function()
        if LoopEnabled then
            while IsRunning do
                runSequence()
                if IsRunning then
                    StatusLabel.Text = "Status: 🔄 Restarting loop..."
                    StatusLabel.TextColor3 = Color3.fromRGB(180, 150, 255)
                    task.wait(2)
                end
            end
        else
            runSequence()
        end

        -- Selesai
        IsRunning = false
        StatusLabel.Text = "Status: ✅ Completed"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        WaypointLabel.Text = "Current: —"
        ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
        StartBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 70)
        highlightCurrentButton()
        StartBtn.Text = "▶  START"
        TimeInput.TextEditable = true
    end)
end)

-- Stop button
StopBtn.MouseButton1Click:Connect(function()
    IsRunning = false
    StatusLabel.Text = "Status: ⏹ Stopped"
    StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    StartBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 70)
    StartBtn.Text = "▶  START"
    TimeInput.TextEditable = true
end)

-- Loop toggle
LoopBtn.MouseButton1Click:Connect(function()
    LoopEnabled = not LoopEnabled
    if LoopEnabled then
        LoopBtn.Text = "🔁  LOOP: ON"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 160)
        LoopBtn.TextColor3 = Color3.fromRGB(150, 200, 255)
    else
        LoopBtn.Text = "🔁  LOOP: OFF"
        LoopBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
        LoopBtn.TextColor3 = Color3.fromRGB(180, 180, 220)
    end
end)

-- ============================================================
-- HOVER EFFECTS
-- ============================================================
local function addHover(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.Name == "StartBtn" and IsRunning then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 80, 40)}):Play()
        elseif btn.Name == "LoopBtn" and LoopEnabled then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 80, 160)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end
    end)
end

addHover(StartBtn, Color3.fromRGB(30, 140, 70), Color3.fromRGB(40, 180, 90))
addHover(StopBtn, Color3.fromRGB(160, 40, 40), Color3.fromRGB(200, 60, 60))
addHover(LoopBtn, Color3.fromRGB(50, 50, 80), Color3.fromRGB(70, 70, 110))
addHover(MinBtn, Color3.fromRGB(60, 60, 90), Color3.fromRGB(80, 80, 120))
addHover(CloseBtn, Color3.fromRGB(180, 50, 50), Color3.fromRGB(220, 70, 70))
addHover(MinusBtn, Color3.fromRGB(60, 50, 80), Color3.fromRGB(90, 60, 100))
addHover(PlusBtn, Color3.fromRGB(50, 70, 80), Color3.fromRGB(70, 100, 100))
