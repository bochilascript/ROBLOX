local Player = game.Players.LocalPlayer
local function getSafeGuiParent()
    if gethui then
        local s, h = pcall(gethui)
        if s and h then return h end
    end
    local s, c = pcall(function() return game:GetService("CoreGui") end)
    if s and c then return c end
    return Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui", 5) or Player:WaitForChild("PlayerGui")
end
local PlayerGui = getSafeGuiParent()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Player
local player = Player
showCommandsWindow = nil
showCmdBar = nil
CmdBarFrame = nil
CmdsFrame = nil
MiniUnanchorBtn = nil
Attachment1 = nil
plistSendPartTarget = nil
syncDanceTarget = nil
syncDanceLoop = nil
myPlayingTracks = {}
plistSendPartDescendantConn = nil
MainGuiToggleConn = nil
ShiftLockShortcutConn = nil
SpeedShortcutConn = nil
FlyV3ShortcutConn = nil
FreecamShortcutConn = nil
MiniFrameToggleConn = nil
local currentLanguage = "EN"
local LangDict = {
    ["Menu"] = { EN = "Menu", ID = "Menu" },
    ["Rusuh"] = { EN = "Combat", ID = "Rusuh" },
    ["Utility"] = { EN = "Utility", ID = "Utilitas" },
    ["Waypoints"] = { EN = "Waypoints", ID = "Titik Lokasi" },
    ["Commands"] = { EN = "Commands", ID = "Perintah" },
    ["Players"] = { EN = "Players", ID = "Pemain" },
    ["Friends"] = { EN = "Friends", ID = "Teman" },
    ["Credits"] = { EN = "Credits", ID = "Kredit" },
    ["Changelogs"] = { EN = "Changelogs", ID = "Riwayat" },
    ["Click TP"] = { EN = "Click TP", ID = "Klik TP" },
    ["TP Tool"] = { EN = "TP Tool", ID = "TP Tool" },
    ["Free Cam"] = { EN = "Free Cam", ID = "Kamera Bebas" },
    ["Speed"] = { EN = "Speed", ID = "Kecepatan" },
    ["Save WP"] = { EN = "Save WP", ID = "Simpan Lokasi" },
    ["Tween TP"] = { EN = "Tween TP", ID = "Tween TP" },
    ["BTools"] = { EN = "BTools", ID = "BTools" },
    ["Jump Power"] = { EN = "Jump Power", ID = "Jump Power" },
    ["Invisible"] = { EN = "Invisible", ID = "Tak Terlihat" },
    ["Visible"] = { EN = "Visible", ID = "Terlihat" },
    ["FPS & Ping"] = { EN = "FPS & Ping", ID = "FPS & Ping" },
    ["Noclip"] = { EN = "Noclip", ID = "Tembus Tembok" },
    ["Fly"] = { EN = "Fly", ID = "Terbang" },
    ["Fling"] = { EN = "Fling", ID = "Putar Badan" },
    ["Unanchor"] = { EN = "Unanchor", ID = "Lepas Kunci" },
    ["Spectator"] = { EN = "Spectator", ID = "Penonton" },
    ["Bring Part"] = { EN = "Bring Part", ID = "Tarik Objek" },
    ["ESP"] = { EN = "ESP", ID = "ESP" },
    ["ESP Team"] = { EN = "ESP Team", ID = "ESP Team" },
    ["Server Hop"] = { EN = "Server Hop", ID = "Pindah Server" },
    ["Rejoin"] = { EN = "Rejoin", ID = "Masuk Ulang" },
    ["Respawn"] = { EN = "Respawn", ID = "Lahir Ulang" },
    ["Anti Lag"] = { EN = "Anti Lag", ID = "Anti Lag" },
    ["Lampu"] = { EN = "Lampu", ID = "Lampu" },
    ["Fly V2"] = { EN = "Fly V2", ID = "Fly V2" },
    ["Fly V3"] = { EN = "Fly V3", ID = "Fly V3" },
    ["Max Zoom"] = { EN = "Max Zoom", ID = "Max Zoom" },
    ["Quick Tools"] = { EN = "Quick Tools", ID = "Quick Tools" },
    ["Animasi"] = { EN = "Animasi", ID = "Animasi" },
    ["Emotes"] = { EN = "Emotes", ID = "Emote" },
    ["Clone Avatar"] = { EN = "Clone Avatar", ID = "Kloning Avatar" },
    ["Headsit"] = { EN = "Headsit", ID = "Duduk Kepala" },
    ["Controls"] = { EN = "Controls", ID = "Kontrol" },
    ["TeleportBtn"] = { EN = "Teleport", ID = "Teleport" },
    ["KickBtn"] = { EN = "Kick", ID = "Tendang" },
    ["KickingBtn"] = { EN = "Kicking", ID = "Menendang" },
    ["FollowBtn"] = { EN = "Follow", ID = "Ikuti" },
    ["FollowingBtn"] = { EN = "Following", ID = "Mengikuti" },
    ["SendPartBtn"] = { EN = "Send: OFF", ID = "Kirim: OFF" },
    ["SendingOnBtn"] = { EN = "Send: ON", ID = "Kirim: ON" },
    ["PrevBtn"] = { EN = "Prev", ID = "Sebelum" },
    ["CloseBtn"] = { EN = "Close", ID = "Tutup" },
    ["NextBtn"] = { EN = "Next", ID = "Lanjut" },
    ["AgeLabel"] = { EN = "Account age", ID = "Umur akun" },
    ["AgeDaysLabel"] = { EN = "Age: %s days", ID = "Umur: %s hari" },
    ["NameLabel"] = { EN = "Name", ID = "Nama" },
    ["Command Bar"] = { EN = "Command Bar", ID = "Command Bar" },
    ["Player List"] = { EN = "Player List", ID = "Daftar Pemain" },
    ["Dex Explorer"] = { EN = "Dex Explorer", ID = "Dex Explorer" },
    ["Infinite Jump"] = { EN = "Infinite Jump", ID = "Infinite Jump" },
    ["Shift Lock"] = { EN = "Shift Lock", ID = "Shift Lock" },
    ["Chat Logs"] = { EN = "Chat Logs", ID = "Catatan Chat" },
    ["Fling Aura"] = { EN = "Fling Aura", ID = "Aura Fling" },
    ["Orbit Fling"] = { EN = "Orbit Fling", ID = "Orbit Fling" },
    ["Walk Fling"] = { EN = "Walk Fling", ID = "Walk Fling" },
    ["Anti Fling"] = { EN = "Anti Fling", ID = "Anti Fling" },
    ["Touch Fling"] = { EN = "Touch Fling", ID = "Fling Sentuhan" },
    ["Part Inspector"] = { EN = "Part Inspector", ID = "Inspektur Objek" },
    ["Collision"] = { EN = "Collision Status", ID = "Status Tabrakan" },
    ["Anchored"] = { EN = "Anchored", ID = "Kunci Posisi" },
    ["PartName"] = { EN = "Part Name", ID = "Nama Objek" },
    ["ClassName"] = { EN = "Class Name", ID = "Tipe Objek" },
    ["ToggleCollision"] = { EN = "Toggle Collision", ID = "Ubah Tabrakan (CanCollide)" },
    ["SearchCmds"] = { EN = "Search commands...", ID = "Cari perintah..." },
    ["Click Yeet"] = { EN = "Click Yeet", ID = "Klik Lempar" },
    ["Crash Server"] = { EN = "Crash Server", ID = "Lag Server" },
    ["SearchPlayers"] = { EN = "Search players...", ID = "Cari pemain..." },
    ["SearchWP"] = { EN = "Search waypoint...", ID = "Cari Waypoint..." },
    ["CmdBarPH"] = { EN = "Type command... (ex: swp name)", ID = "Ketik perintah... (cth: swp nama)" },
    ["FriendList"] = { EN = "Friend List", ID = "Daftar Teman" },
    ["ShortcutsKey"] = { EN = "Shortcuts", ID = "Shortcut PC" },
    ["ShortcutsDesc"] = { EN = "<b><font color=\"rgb(255, 60, 60)\">[</font></b>  - Open / Close GUI\n<b><font color=\"rgb(255, 60, 60)\">]</font></b>  - Toggle Speed Hack\n<b><font color=\"rgb(255, 60, 60)\">\\</font></b>  - Toggle Jump Power\n<b><font color=\"rgb(255, 60, 60)\">'</font></b>  - Open Command Bar\n<b><font color=\"rgb(255, 60, 60)\">T</font></b>  - Toggle Free Cam\n<b><font color=\"rgb(255, 60, 60)\">RightCtrl</font></b>  - Toggle Floating Logo\n\n*Note for <b>\\</b>: Disable 'UI Navigation Toggle' in Roblox Settings for it to work properly.", ID = "<b><font color=\"rgb(255, 60, 60)\">[</font></b>  - Buka / Tutup GUI\n<b><font color=\"rgb(255, 60, 60)\">]</font></b>  - Aktif / Matikan Speed Hack\n<b><font color=\"rgb(255, 60, 60)\">\\</font></b>  - Aktif / Matikan Jump Power\n<b><font color=\"rgb(255, 60, 60)\">'</font></b>  - Buka Command Bar\n<b><font color=\"rgb(255, 60, 60)\">T</font></b>  - Aktif / Matikan Free Cam\n<b><font color=\"rgb(255, 60, 60)\">RightCtrl</font></b>  - Sembunyikan Logo\n\n*Catatan untuk <b>\\</b>: Matikan 'Tombol Navigasi UI' di Pengaturan Roblox agar pintasan berfungsi." },
    ["CL_370"] = { EN = "- Massive UI update: Mobile draggable sliders for Speed & Jump Power\n- Safe Raycast landing algorithm for Fly V1 to prevent clipping\n- Draggable Mobile Command Bar\n- Added Config System (Auto-saves your settings locally)\n- Tab Rusuh Expansion: Added Hitbox Expander & Silent Aim\n- Custom Keybind Settings (Change hotkeys dynamically)\n- Added Free Cam shortcut (T), Hide Logo (RightCtrl) & Max Zoom noclip\n- Incremented version to v3.7.0", ID = "- Pembaruan UI Masif: Slider Mobile yang bisa digeser untuk Speed & Jump Power\n- Algoritma pendaratan aman Raycast untuk Fly V1 agar tidak nyangkut\n- Command Bar Mobile yang bisa di-drag\n- Sistem Config (Otomatis save settingan script)\n- Ekspansi Tab Rusuh: Menambahkan Hitbox Expander & Silent Aim\n- Kustomisasi Tombol/Keybind (Ganti pintasan sesuka hati)\n- Menambahkan shortcut Free Cam (T), Hide Logo (RightCtrl) & noclip Max Zoom\n- Menaikkan versi script menjadi v3.7.0" },
    ["CL_360"] = { EN = "- Added Shortcuts PC category to easily view keybinds\n- Added \\ shortcut to toggle Jump Power on/off\n- Improved Jump Trail size to be smaller and sleeker\n- Fixed active features cleanup not working properly when closing the GUI\n- Incremented version to v3.6.0", ID = "- Menambahkan kategori Shortcut PC untuk melihat pintasan keyboard\n- Menambahkan shortcut tombol \\ untuk mengaktifkan/mematikan Jump Power\n- Memperbaiki ukuran trail lompat agar lebih kecil dan ramping\n- Memperbaiki pembersihan fitur yang aktif saat GUI utama ditutup agar langsung mati\n- Menaikkan versi script menjadi v3.6.0" },
    ["CL_350"] = { EN = "- Renamed Fly V3 button in main GUI to Quick Tools\n- Added Spectate and Refresh buttons to Quick Tools\n- Switched Mobile Fly in Quick Tools to Fly V1 (better compatibility)\n- Fixed active Send Part button overlay color in Player List\n- Fixed Noclip movement bugs when disabling fly/noclip\n- Fixed Bring Part getting stuck after Send Part finishes\n- Changed Send Part to continuous loop mode\n- Updated Refresh button in Quick Tools to use refresh instead of respawn\n- Fixed local register limit error in Quick Tools\n- Added Fling (one-shot instant fling) to Spectate and Player List\n- Optimized Player List layout and removed redundant Kick button\n- Added joint-breaking to Part Scanner Bring to prevent map damage\n- Kept currently brought part at the top of the Part Scanner list\n- Improved Yeet in Part Scanner to instantly fling and vanish the part\n- Added ;ifling, ;walkfling, and ;antifling commands to Command Bar/List\n- Fixed Spectate & Player List flings by welding separate flingPart (preventing self-fling) and extending duration to 2s\n- Added God Mode (Kebal) & Health Monitor button to Quick Tools\n- Optimized Part Scanner lag by caching players and walking parent trees\n- Improved Yeet to teleport parts to sky boundary (99999, 9999, 99999) to bypass anti-void resets\n- Increased unanchor and yeet radius to 1000 studs\n- Reworked Part Scanner Unanchor to target unanchored parts and loop for 2.5s\n- Fixed Fly V3 fling when turning off and optimized main GUI startup rendering speed\n- Fixed top-clipped category buttons by adding padding to ScrollFrame and UtilityScroll\n- Added Fling Aura and Orbit Fling features to Combat category and Quick Tools\n- Added ;flingaura and ;orbitfling commands to Command Bar/List", ID = "- Mengubah tombol Fly V3 di GUI utama menjadi Quick Tools\n- Menambahkan tombol Spectate dan Refresh ke Quick Tools\n- Mengubah tombol Terbang mobile di Quick Tools menjadi Fly V1 (lebih kompatibel)\n- Memperbaiki warna tombol aktif Send Part pada Player List agar tidak menyatu/putih polos\n- Perbaikan bug gerakan Noclip setelah mematikan fly/noclip\n- Perbaikan Bring Part tersangkut setelah Send Part selesai\n- Mengubah Send Part menjadi mode loop terus-menerus\n- Memperbarui tombol Refresh di Quick Tools menggunakan metode refresh asli, bukan respawn\n- Memperbaiki error limit register lokal pada Quick Tools\n- Menambahkan Fling (instant fling sekali jalan) pada Spectate dan Player List\n- Mengoptimalkan tata letak Player List dan menghapus tombol Kick\n- Menambahkan pemutusan sambungan objek (BreakJoints) pada Bring Part Scanner agar map tidak rusak\n- Mengunci posisi part yang sedang di-bring di baris teratas Part Scanner\n- Memperbarui fungsi Yeet di Part Scanner agar langsung terlempar dan hilang seketika\n- Menambahkan perintah ;ifling, ;walkfling, dan ;antifling ke Command Bar/List\n- Memperbaiki Fling Spectate & Player List menggunakan metode welded flingPart (anti mati) dan durasi 2 detik\n- Menambahkan tombol Kebal (God Mode) & Health Monitor di Quick Tools\n- Mengoptimalkan lag Part Scanner dengan cache player dan penelusuran parent\n- Memperbarui Yeet untuk memindahkan part ke koordinat langit (99999, 9999, 99999) agar tidak reset\n- Meningkatkan radius unanchor dan yeet menjadi 1000 studs\n- Merombak Unanchor Part Scanner untuk part terlepas dan melakukan loop selama 2.5 detik\n- Perbaikan karakter terlempar saat mematikan Fly V3 dan optimasi kecepatan render awal GUI\n- Memperbaiki tombol kategori yang terlalu ke atas dengan menambahkan padding pada ScrollFrame dan UtilityScroll\n- Menambahkan fitur Fling Aura dan Orbit Fling pada kategori Rusuh dan Quick Tools\n- Menambahkan perintah ;flingaura dan ;orbitfling ke Command Bar/List" },
    ["CL_340"] = { EN = "- Added Spectator Player List Search & Alphabetical Sorting\n- Fixed Physics bugs on Fly V1\n- Fixed Player List Send Part integration\n- Added Quick Tools Mini Panel (Fly V3, Bring Part & Noclip)\n- UI/UX Improvements (Glow removal, Color fixes)\n- Added Invite Button to Friend List (Top bar only)\n- Re-positioned Speed Trails to Feet\n- Combined Spectator Search box into the Player List GUI\n- Fixed Spectator red highlight getting stuck on target change", ID = "- Penambahan Pencarian & Pengurutan Abjad Player List Spectator\n- Perbaikan bug fisik terpelanting pada Fly V1\n- Perbaikan Send Part yang tidak merespon di Player List\n- Penambahan Mini Panel Quick Tools (Fly V3, Bring Part & Noclip)\n- Peningkatan UI/UX (Hapus glow, Perbaikan warna)\n- Perambahan tombol Invite di Friend List (Hanya di top bar)\n- Perbaikan posisi Speed Trail ke Kaki\n- Menggabungkan kotak pencarian Spectator ke dalam GUI daftar pemain\n- Perbaikan sorotan merah Spectator yang tersangkut saat ganti target" },
    ["CL_330"] = { EN = "- Added Dual Language System (English & Indonesian)\n- FE Invisible Rework (Bypasses StreamingEnabled & 100% Server Sync)\n- Fixed notification translations\n- UI scaling & layout adjustments for bilingual support", ID = "- Penambahan Sistem Dua Bahasa (Inggris & Indonesia)\n- Rombak ulang FE Invisible (Anti-bug StreamingEnabled & 100% tersinkron dengan Server)\n- Perbaikan bug terjemahan pada notifikasi\n- Penyesuaian teks & layout UI untuk bahasa" },
    ["CL_320"] = { EN = "- Custom cursor support in Command Bar\n- Fixed Infinite Jump bug\n- Fixed camera stutter on TP Tool (First Person)\n- Harmonized Server Hop GUI design\n- Fixed hidden Respawn button\n- Fixed camera issues on Invisible feature", ID = "- Dukungan custom cursor pada Command Bar\n- Perbaikan bug Infinite Jump tidak melompat\n- Perbaikan kamera tersendat pada TP Tool (First Person)\n- Menyeragamkan tampilan GUI Server Hop dengan UI lain\n- Perbaikan tombol Respawn yang tersembunyi\n- Perbaikan kamera nyasar pada fitur Invisible" },
    ["CL_310"] = { EN = "- Integrated BTools automatically to Utility tab\n- Added Premium Jump Power Customizer\n- Enhanced Instant Long-Range Teleport (Segmented Fast-TP & Raycast Ground Check)\n- Improved TP Tool with Auto Cursor Unlock\n- Added ;tweentp and ;jumppower to Command List", ID = "- Integrasi BTools ke tab Utility secara otomatis\n- Penambahan Premium Jump Power Customizer\n- Penyempurnaan Teleport Jarak Jauh Instan (Segmented Fast-TP & Raycast Ground Check)\n- Penyempurnaan TP Tool dengan Auto Cursor Unlock\n- Perintah ;tweentp dan ;jumppower ke Command List" },
    ["CL_300"] = { EN = "- Reconstructed Anti Lag (0% Idle CPU, event-driven lighting/water lock, 0.1s streaming pause)\n- Added BTools Feature (Hammer, Move, Grab, Clone)\n- Added Mobile Shift Lock (Shoulder view + body movement)\n- Added ESP Customization (Independent Chams, Name, Tracer toggle)\n- Added Changelog & Script Version Tab", ID = "- Rekonstruksi Anti Lag (0% Idle CPU, event-driven pengunci cahaya/air, jeda streaming 0.1s)\n- Penambahan Fitur BTools (Hammer, Move, Grab, Clone)\n- Penambahan Mobile Shift Lock (Sudut pandang bahu + pergerakan tubuh)\n- Penambahan Kustomisasi ESP (Toggle Chams, Name, Tracer independen)\n- Penambahan Tab Changelog & Versi Script" },
    ["CL_250"] = { EN = "- Added Enter confirmation button to Command Bar\n- Auto alphabetical sorting for Command List on startup\n- Fixed Luau compiler 200 register limit\n- Added Friend List Window (Join & Auto Re-execute)", ID = "- Pengurutan abjad Command List otomatis saat startup\n- Perbaikan register limit 200 Luau compiler\n- Penambahan Window Friend List (Join & Auto Re-execute)" },
    ["CL_200"] = { EN = "- ESP billboard with health bar & distance indicator\n- Fixed unlimited ESP distance bug (math.huge)", ID = "- ESP billboard dengan health bar & indikator jarak\n- Perbaikan bug jarak ESP tidak terbatas (math.huge)" },
    ["Invisible_On"] = { EN = "Invisible Mode Activated!", ID = "FE Invisible Aktif!" },
    ["Visible_On"] = { EN = "Visible Mode Activated!", ID = "Karakter terlihat kembali!" },
    ["Teleporting"] = { EN = "Teleporting...", ID = "Melakukan Teleport..." },
    ["SyncBtn"] = { EN = "Sync", ID = "Sinkron" },
    ["Auto Clicker (PC)"] = { EN = "Auto Clicker (PC Only)", ID = "Auto Clicker (PC Only)" },
}
local translatableElements = {}
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
                    local isCharPart = false
                    local p = part.Parent
                    while p and p ~= Workspace do
                        if p:FindFirstChildOfClass("Humanoid") then
                            isCharPart = true
                            break
                        end
                        p = p.Parent
                    end
                    if not isCharPart then
                        part.AssemblyLinearVelocity = Vector3.new(math.random(-50,50), math.random(20,100), math.random(-50,50))
                    end
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
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                end
            end)
        end)
    end)
end
local flying = false
local frozenPos = nil

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
    local attach1 = targetHRP:FindFirstChild("JSY_SendPartAttach") or Instance.new("Attachment", targetHRP)
    attach1.Name = "JSY_SendPartAttach"
    local function SendForcePart(v)
        if not v:IsA("BasePart") then return end
        if v.Anchored then return end
        if v.Parent and v.Parent:FindFirstChildOfClass("Humanoid") then return end
        if v.Name == "Handle" then return end
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
            task.wait(2)
            pcall(function()
                if v and v:IsA("BasePart") then
                    v.AssemblyLinearVelocity = Vector3.zero
                    v.AssemblyAngularVelocity = Vector3.zero
                end
                if align and align.Parent then align:Destroy() end
                if torque and torque.Parent then torque:Destroy() end
                if attach2 and attach2.Parent then attach2:Destroy() end
                if v and v.Parent then
                    pcall(function() v.CanCollide = originalCanCollide end)
                end
            end)
        end)
    end
    local parts = GetAllPartsRecursive(Workspace)
    for _, p in ipairs(parts) do
        pcall(function()
            if not p.Anchored then
                SendForcePart(p)
            end
        end)
    end
end

function executeInstantFling(targetPlayer)
    if not targetPlayer then return end
    local lp = Players.LocalPlayer
    local myChar = lp and lp.Character
    local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
    if not myHrp then return end
    local tChar = targetPlayer.Character
    local tHrp = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso"))
    if not tHrp then return end
    task.spawn(function()
        local origCF = myHrp.CFrame
        local origGrav = workspace.Gravity
        workspace.Gravity = 0
        local flingPart = Instance.new("Part")
        flingPart.Anchored = false
        flingPart.CanCollide = false
        flingPart.Transparency = 1
        flingPart.Size = Vector3.new(1, 1, 1)
        flingPart.CFrame = myHrp.CFrame
        flingPart.Parent = workspace
        local flingWeld = Instance.new("WeldConstraint")
        flingWeld.Part0 = flingPart
        flingWeld.Part1 = myHrp
        flingWeld.Parent = flingPart
        local BV = Instance.new("BodyVelocity")
        BV.Parent = flingPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if myHum then
            myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        end
        local startFling = tick()
        local angle = 0
        while tick() - startFling < 2.0 and tHrp and tHrp.Parent do
            angle = angle + 100
            pcall(function()
                local offset = CFrame.new(0, 0.5, 0)
                if angle % 400 == 0 then
                    offset = CFrame.new(0, 1.5, 0)
                elseif angle % 400 == 100 then
                    offset = CFrame.new(0, -1.5, 0)
                elseif angle % 400 == 200 then
                    offset = CFrame.new(2.25, 1.5, -2.25)
                elseif angle % 400 == 300 then
                    offset = CFrame.new(-2.25, -1.5, 2.25)
                end
                myHrp.CFrame = tHrp.CFrame * offset * CFrame.Angles(math.rad(angle), 0, 0)
                flingPart.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
                flingPart.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
            end)
            RunService.Heartbeat:Wait()
        end
        task.wait(0.1)
        workspace.Gravity = origGrav
        if myHum then
            myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        end
        pcall(function() flingPart:Destroy() end)
        pcall(function()
            myHrp.Anchored = true
            myHrp.AssemblyLinearVelocity = Vector3.zero
            myHrp.AssemblyAngularVelocity = Vector3.zero
            myHrp.CFrame = origCF
            task.wait(0.1)
            myHrp.Anchored = false
        end)
    end)
end
function tr(key)
    local entry = LangDict[key]
    if entry then
        return entry[currentLanguage] or key
    end
    return key
end
function addTranslatable(guiElement, key, propertyName, prefix)
    propertyName = propertyName or "Text"
    prefix = prefix or ""
    table.insert(translatableElements, {element = guiElement, key = key, prop = propertyName, prefix = prefix})
    pcall(function() guiElement[propertyName] = prefix .. tr(key) end)
end
function updateLanguage(lang)
    currentLanguage = lang
    for _, item in ipairs(translatableElements) do
        if item.element then
            pcall(function()
                if item.customUpdate then
                    item.customUpdate()
                elseif item.prop == "Text" then
                    item.element.Text = item.prefix .. tr(item.key)
                elseif item.prop == "PlaceholderText" then
                    item.element.PlaceholderText = item.prefix .. tr(item.key)
                end
            end)
        end
    end
end
function makeSmoothDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
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
pcall(function()
    local coreGui = game:GetService("CoreGui")
    local gethui = (gethui or function() return nil end)
    local hui = gethui()
    for _, guiName in ipairs({"CHCmdBarGUI", "PIXECUTE SPECTATE", "FriendListFrame", "PlayerListFrame", "CHCheatGUI"}) do
        for _, parent in ipairs({PlayerGui, coreGui, hui}) do
            if parent then
                for _, child in ipairs(parent:GetChildren()) do
                    if child.Name == guiName then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end
    end
end)
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
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
local ModalFix = Instance.new("TextButton")
ModalFix.Name = "ModalFix"
ModalFix.Size = UDim2.new(0, 0, 0, 0)
ModalFix.BackgroundTransparency = 1
ModalFix.Text = ""
ModalFix.Modal = true
ModalFix.Parent = MainFrame
MainGuiToggleConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        if MainFrame.Visible then
            local tw = TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.new(0,0,0,0)})
            tw:Play()
            tw.Completed:Connect(function() MainFrame.Visible = false end)
        else
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 340)}):Play()
            pcall(function() updateExternalCursorVisibility() end)
        end
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
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0
mainStroke.Parent = MainFrame
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 100, 0, 20)
VersionLabel.Position = UDim2.new(1, -110, 1, -25)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.TextSize = 11
VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
VersionLabel.TextYAlignment = Enum.TextYAlignment.Bottom
VersionLabel.Text = "v3.7.0"
VersionLabel.ZIndex = 15
VersionLabel.Parent = MainFrame
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, 0, 1, -30)
Container.Position = UDim2.new(0, 0, 0, 30)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0, 170, 1, -2)
ProfileFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
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
ProfilePicture.Position = UDim2.new(0.5, -40, 0, 12)
ProfilePicture.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProfilePicture.BorderSizePixel = 0
ProfilePicture.Parent = ProfileContent
local pictureCorner = Instance.new("UICorner")
pictureCorner.CornerRadius = UDim.new(0, 40)
pictureCorner.Parent = ProfilePicture
local pictureStroke = Instance.new("UIStroke")
pictureStroke.Color = Color3.fromRGB(255, 255, 255)
pictureStroke.Thickness = 2
pictureStroke.Parent = ProfilePicture
local userId = Player.UserId
function loadThumbnailWithFallbacks()
    local success1, result1 = pcall(function()
        return "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=420&h=420"
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
ProfilePicture.Image = "rbxasset://textures/ui/avatar_placeholder.png"
task.spawn(loadThumbnailWithFallbacks)
task.delay(3, loadThumbnailWithFallbacks)
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 2, 1, 0)
Divider.Position = UDim2.new(0, 170, 0, 0)
Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Divider.BackgroundTransparency = 0
Divider.BorderSizePixel = 0
Divider.Parent = Container
local dividerCorner = Instance.new("UICorner")
dividerCorner.CornerRadius = UDim.new(1, 0)
dividerCorner.Parent = Divider
local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Size = UDim2.new(1, -190, 1, -30)
ButtonsFrame.Position = UDim2.new(0, 180, 0, 15)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.ClipsDescendants = true
ButtonsFrame.Parent = Container
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFrame.ScrollBarImageTransparency = 0.5
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = ButtonsFrame
local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingTop = UDim.new(0, 10)
ScrollPadding.PaddingBottom = UDim.new(0, 10)
ScrollPadding.Parent = ScrollFrame
local UtilityFrame = Instance.new("Frame")
UtilityFrame.Name = "UtilityFrame"
UtilityFrame.Size = UDim2.new(1, 0, 1, 0)
UtilityFrame.Visible = false
UtilityFrame.BackgroundTransparency = 1
UtilityFrame.Parent = ButtonsFrame
local UtilityScroll = Instance.new("ScrollingFrame")
UtilityScroll.Name = "UtilityScroll"
UtilityScroll.Size = UDim2.new(1, 0, 1, 0)
UtilityScroll.BackgroundTransparency = 1
UtilityScroll.ScrollBarThickness = 6
UtilityScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
UtilityScroll.ScrollBarImageTransparency = 0.5
UtilityScroll.ScrollingDirection = Enum.ScrollingDirection.Y
UtilityScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
UtilityScroll.Parent = UtilityFrame
local UtilityPadding = Instance.new("UIPadding")
UtilityPadding.PaddingTop = UDim.new(0, 10)
UtilityPadding.PaddingBottom = UDim.new(0, 10)
UtilityPadding.Parent = UtilityScroll
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
    UtilityScroll.CanvasSize = UDim2.new(0, 0, 0, UtilityGrid.AbsoluteContentSize.Y + 30)
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
    ConfigFrame = Instance.new("Frame")
    ConfigFrame.Name = "ConfigFrame"
    ConfigFrame.Size = UDim2.new(1, 0, 1, 0)
    ConfigFrame.Visible = false
    ConfigFrame.BackgroundTransparency = 1
    ConfigFrame.Parent = ButtonsFrame
ChangelogsFrame = Instance.new("Frame")
ChangelogsFrame.Name = "ChangelogsFrame"
ChangelogsFrame.Size = UDim2.new(1, 0, 1, 0)
ChangelogsFrame.Visible = false
ChangelogsFrame.BackgroundTransparency = 1
ChangelogsFrame.Parent = ButtonsFrame
ShortcutsFrame = Instance.new("Frame")
ShortcutsFrame.Name = "ShortcutsFrame"
ShortcutsFrame.Size = UDim2.new(1, 0, 1, 0)
ShortcutsFrame.Visible = false
ShortcutsFrame.BackgroundTransparency = 1
ShortcutsFrame.Parent = ButtonsFrame
InfoFrame = Instance.new("Frame")
InfoFrame.Name = "InfoFrame"
InfoFrame.Size = UDim2.new(1, 0, 1, 0)
InfoFrame.Visible = false
InfoFrame.BackgroundTransparency = 1
InfoFrame.Parent = ButtonsFrame
do
    local QuickPanel = Instance.new("ScrollingFrame")
    QuickPanel.Name = "QuickPanel"
    QuickPanel.Size = UDim2.new(1, -10, 1, -105)
    QuickPanel.Position = UDim2.new(0, 5, 0, 100)
    QuickPanel.BackgroundTransparency = 1
    QuickPanel.BorderSizePixel = 0
    QuickPanel.ScrollBarThickness = 3
    QuickPanel.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
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
    local categoryButtons = {}
    local function makeSmallBtn(textKey, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 24)
        btn.LayoutOrder = order
        btn.BackgroundTransparency = 1
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        btn.Parent = QuickPanel
        addTranslatable(btn, textKey, "Text")
        categoryButtons[textKey] = btn
        btn.MouseEnter:Connect(function()
            if currentCategory ~= textKey then
                TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if currentCategory ~= textKey then
                TweenService:Create(btn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
            end
        end)
        return btn
    end
    local function scrollToLabel(labelText)
        if not ScrollFrame or not ScrollFrame:FindFirstChildOfClass("UIGridLayout") then return end
        for _, child in ipairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") and string.find(string.lower(child.Text), string.lower(labelText), 1, true) then
                task.wait()
                local targetY = child.AbsolutePosition.Y - ScrollFrame.AbsolutePosition.Y + ScrollFrame.CanvasPosition.Y - 10
                ScrollFrame.CanvasPosition = Vector2.new(0, math.max(targetY, 0))
                break
            end
        end
    end
    local rusuhKeywords = {"bringpart", "tarik objek", "spectator", "penonton", "noclip", "tembus tembok", "tendang", "unanchor", "lepas kunci", "fly", "terbang", "esp", "esp team", "quick tools", "quick", "anti fling", "antifling", "fling aura", "aura fling", "orbit fling", "orbit", "click yeet", "crash server", "touch fling", "touchfling", "vehicle fly", "terbang kendaraan", "auto clicker", "autoclicker", "spam click", "walk fling", "walkfling", "hitbox", "aimbot"}
    local utilityKeywords = {"free cam", "freecam", "kamera bebas", "click tp", "clicktp", "klik tp", "speed", "kecepatan", "save wp", "savewp", "swp", "simpan lokasi", "btools", "tween tp", "tweentp", "jump power", "jumppower", "jp", "tp tool", "tptool", "invisible", "tak terlihat", "visible", "terlihat", "fps & ping", "chat logs", "chatlogs", "part inspector", "inspektur objek", "shift lock", "shiftlock", "respawn", "anti afk", "antiafk", "command bar", "cmd", "infinite jump", "lampu"}
    local function matchesAny(text, keywords)
        local lower = string.lower(text or "")
        for _, k in ipairs(keywords) do
            if string.find(lower, k, 1, true) then
                if k == "esp" and string.find(lower, "respawn", 1, true) then
                else
                    return true
                end
            end
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
        for name, btn in pairs(categoryButtons) do
            if name == cat then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            else
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    TextColor3 = Color3.fromRGB(255, 50, 50)
                }):Play()
            end
        end
        for _, child in ipairs(ScrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                if cat == "Menu" then
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
            local tweenBtn = UtilityScroll:FindFirstChild("TweenTPBtn") or ScrollFrame:FindFirstChild("TweenTPBtn") or findBtn("Tween TP")
            local btoolsBtn = UtilityScroll:FindFirstChild("BToolsBtn") or ScrollFrame:FindFirstChild("BToolsBtn") or findBtn("BTools")
            local jumpBtn  = UtilityScroll:FindFirstChild("JumpPowerBtn") or ScrollFrame:FindFirstChild("JumpPowerBtn") or findBtn("Jump Power")
            local jumpBox  = UtilityScroll:FindFirstChild("JumpPowerBox") or ScrollFrame:FindFirstChild("JumpPowerBox")
            local tptoolBtn = UtilityScroll:FindFirstChild("TPToolBtn") or ScrollFrame:FindFirstChild("TPToolBtn") or findBtn("TP Tool")
            local invisBtn = UtilityScroll:FindFirstChild("InvisibleBtn") or ScrollFrame:FindFirstChild("InvisibleBtn") or findBtn("Invisible")
            local visBtn = UtilityScroll:FindFirstChild("VisibleBtn") or ScrollFrame:FindFirstChild("VisibleBtn") or findBtn("Visible")
            local fpsBtn = UtilityScroll:FindFirstChild("FPSPingBtn") or ScrollFrame:FindFirstChild("FPSPingBtn") or findBtn("FPS & Ping")
            local chatLogsBtn = UtilityScroll:FindFirstChild("ChatLogsBtn") or ScrollFrame:FindFirstChild("ChatLogsBtn") or findBtn("Chat Logs")
            local partInspectorBtn = UtilityScroll:FindFirstChild("PartInspectorBtn") or ScrollFrame:FindFirstChild("PartInspectorBtn") or findBtn("Part Inspector")
            
            local cmdBarBtn = UtilityScroll:FindFirstChild("CmdBarBtn") or ScrollFrame:FindFirstChild("CmdBarBtn") or findBtn("Command Bar")
            local shiftLockBtn = UtilityScroll:FindFirstChild("ShiftLockBtn") or ScrollFrame:FindFirstChild("ShiftLockBtn") or findBtn("Shift Lock")
            local infJumpBtn = UtilityScroll:FindFirstChild("JumpBtn") or ScrollFrame:FindFirstChild("JumpBtn") or findBtn("Infinite Jump")
            local antiAFKBtn = UtilityScroll:FindFirstChild("AntiAFKBtn") or ScrollFrame:FindFirstChild("AntiAFKBtn") or findBtn("Anti AFK")
            local respawnBtn = UtilityScroll:FindFirstChild("RespawnBtn") or ScrollFrame:FindFirstChild("RespawnBtn") or findBtn("Respawn")
            local lampBtn = UtilityScroll:FindFirstChild("LampBtn") or ScrollFrame:FindFirstChild("LampBtn") or findBtn("Lampu")

            local function moveToUtil(child, order)
                if child then child.Parent = UtilityScroll child.Visible = true child.LayoutOrder = order end
            end
            
            -- TextBoxes (order 1 to 10)
            moveToUtil(clickBtn, 1); moveToUtil(tpBox, 2)
            moveToUtil(freeBtn, 3);  moveToUtil(fcBox, 4)
            moveToUtil(jumpBtn, 5);  moveToUtil(jumpBox, 6)
            moveToUtil(swpBtn, 7);   moveToUtil(swpBox, 8)
            moveToUtil(spdBtn, 9);   moveToUtil(spdBox, 10)
            
            -- Alphabetically Sorted (order 11+)
            moveToUtil(antiAFKBtn, 11)
            moveToUtil(btoolsBtn, 12)
            moveToUtil(chatLogsBtn, 13)
            moveToUtil(cmdBarBtn, 14)
            moveToUtil(fpsBtn, 15)
            moveToUtil(infJumpBtn, 16)
            moveToUtil(invisBtn, 17)
            moveToUtil(lampBtn, 18)
            moveToUtil(partInspectorBtn, 19)
            moveToUtil(respawnBtn, 20)
            moveToUtil(shiftLockBtn, 21)
            moveToUtil(tptoolBtn, 22)
            moveToUtil(tweenBtn, 23)
            moveToUtil(visBtn, 24)
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
            elseif cat == "Waypoints" then
            ScrollFrame.Visible = false
            UtilityFrame.Visible = true
            for _, ch in ipairs(UtilityScroll:GetChildren()) do
                if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") ~= true then
                    ch.Parent = ScrollFrame
                    ch.Visible = false
                elseif ch:IsA("TextBox") then
                    ch.Parent = ScrollFrame
                    ch.Visible = false
                end
            end
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
            table.sort(fixed, function(a, b)
                return naturalCompare(a.Text or "", b.Text or "")
            end)
            local order = 1
            for _, ch in ipairs(fixed) do
                ch.Parent = UtilityScroll
                ch.Visible = true
                ch.LayoutOrder = order
                order = order + 1
            end
        else
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
                for _, ch in ipairs(UtilityScroll:GetChildren()) do
                    if ch:IsA("TextButton") and ch:GetAttribute("IsFixedWP") == true then
                        ch.Parent = ScrollFrame
                        ch.Visible = false
                    end
                end
                for _, ch in ipairs(UtilityScroll:GetChildren()) do
                    if ch:IsA("TextButton") then ch.Parent = ScrollFrame ch.Visible = false end
                end
            end
            UtilityFrame.Visible = false
            if cat == "Commands" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = true
                CreditsFrame.Visible = false
                ChangelogsFrame.Visible = false
                ConfigFrame.Visible = false
                ShortcutsFrame.Visible = false
                InfoFrame.Visible = false
            elseif cat == "Credits" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = false
                CreditsFrame.Visible = true
                ChangelogsFrame.Visible = false
                ConfigFrame.Visible = false
                ShortcutsFrame.Visible = false
                InfoFrame.Visible = false
            elseif cat == "Config" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = false
                CreditsFrame.Visible = false
                ChangelogsFrame.Visible = false
                ConfigFrame.Visible = true
                ShortcutsFrame.Visible = false
                InfoFrame.Visible = false
            elseif cat == "Changelogs" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = false
                CreditsFrame.Visible = false
                ChangelogsFrame.Visible = true
                ConfigFrame.Visible = false
                ShortcutsFrame.Visible = false
                InfoFrame.Visible = false
            elseif cat == "Shortcuts" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = false
                CreditsFrame.Visible = false
                ChangelogsFrame.Visible = false
                ConfigFrame.Visible = false
                ShortcutsFrame.Visible = true
                InfoFrame.Visible = false
            elseif cat == "Info" then
                ScrollFrame.Visible = false
                CmdsFrame.Visible = false
                CreditsFrame.Visible = false
                ChangelogsFrame.Visible = false
                ConfigFrame.Visible = false
                ShortcutsFrame.Visible = false
                InfoFrame.Visible = true
            else
                CmdsFrame.Visible = false
                CreditsFrame.Visible = false
                ChangelogsFrame.Visible = false
                ConfigFrame.Visible = false
                ShortcutsFrame.Visible = false
                InfoFrame.Visible = false
                ScrollFrame.Visible = true
            end
        end
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
            local tweenBtn = findButtonByText("Tween TP")
            local btoolsBtn = findButtonByText("BTools")
            local jumpBtn = findButtonByText("Jump Power")
            local jumpBox = ScrollFrame:FindFirstChild("JumpPowerBox")
            local tptoolBtn = findButtonByText("TP Tool")
            local ordered = {clickBtn, tpBox, freeBtn, fcBox, spdBtn, spdBox, jumpBtn, jumpBox, swpBtn, swpBox, tweenBtn, btoolsBtn, tptoolBtn}
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
        if typeof(SpeedBox) == "Instance" then
            SpeedBox.Visible = (cat == "Utility")
        end
        if typeof(JumpPowerBox) == "Instance" then
            JumpPowerBox.Visible = (cat == "Utility")
        end
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
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.Parent = CreditsFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = scrollFrame
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)
        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, -10, 0, 80)
        header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        header.LayoutOrder = 1
        header.Parent = scrollFrame
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)
        local hStroke = Instance.new("UIStroke", header)
        hStroke.Color = Color3.fromRGB(40, 40, 50)
        hStroke.Thickness = 1
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0.6, 0)
        title.BackgroundTransparency = 1
        title.Text = "Chil Script Universal"
        title.TextColor3 = Color3.fromRGB(255, 50, 50)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 20
        title.Parent = header
        local subtitle = Instance.new("TextLabel")
        subtitle.Size = UDim2.new(1, 0, 0.4, 0)
        subtitle.Position = UDim2.new(0, 0, 0.6, 0)
        subtitle.BackgroundTransparency = 1
        subtitle.Text = "by Pixecute"
        subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
        subtitle.Font = Enum.Font.GothamMedium
        subtitle.TextSize = 11
        subtitle.Parent = header
        local staffCard = Instance.new("Frame")
        staffCard.Size = UDim2.new(1, -10, 0, 70)
        staffCard.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        staffCard.LayoutOrder = 2
        staffCard.Parent = scrollFrame
        Instance.new("UICorner", staffCard).CornerRadius = UDim.new(0, 8)
        local sStroke = Instance.new("UIStroke", staffCard)
        sStroke.Color = Color3.fromRGB(40, 40, 50)
        sStroke.Thickness = 1
        local devRole = Instance.new("TextLabel")
        devRole.Size = UDim2.new(1, -20, 0, 20)
        devRole.Position = UDim2.new(0, 10, 0, 10)
        devRole.BackgroundTransparency = 1
        devRole.Text = "👑 OWNER & DEVELOPER"
        devRole.TextColor3 = Color3.fromRGB(255, 200, 50)
        devRole.Font = Enum.Font.GothamBold
        devRole.TextSize = 11
        devRole.TextXAlignment = Enum.TextXAlignment.Left
        devRole.Parent = staffCard
        local devName = Instance.new("TextLabel")
        devName.Size = UDim2.new(1, -20, 0, 30)
        devName.Position = UDim2.new(0, 10, 0, 28)
        devName.BackgroundTransparency = 1
        devName.Text = "PIXECUTE"
        devName.TextColor3 = Color3.fromRGB(255, 255, 255)
        devName.Font = Enum.Font.GothamBlack
        devName.TextSize = 18
        devName.TextXAlignment = Enum.TextXAlignment.Left
        devName.Parent = staffCard
        local disclaimerCard = Instance.new("Frame")
        disclaimerCard.Size = UDim2.new(1, -10, 0, 75)
        disclaimerCard.BackgroundColor3 = Color3.fromRGB(25, 15, 15)
        disclaimerCard.LayoutOrder = 3
        disclaimerCard.Parent = scrollFrame
        Instance.new("UICorner", disclaimerCard).CornerRadius = UDim.new(0, 8)
        local discStroke = Instance.new("UIStroke", disclaimerCard)
        discStroke.Color = Color3.fromRGB(100, 40, 40)
        discStroke.Thickness = 1
        local discTitle = Instance.new("TextLabel")
        discTitle.Size = UDim2.new(1, -20, 0, 20)
        discTitle.Position = UDim2.new(0, 10, 0, 8)
        discTitle.BackgroundTransparency = 1
        discTitle.Text = "⚠️ DISCLAIMER"
        discTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
        discTitle.Font = Enum.Font.GothamBold
        discTitle.TextSize = 11
        discTitle.TextXAlignment = Enum.TextXAlignment.Left
        discTitle.Parent = disclaimerCard
        local discText = Instance.new("TextLabel")
        discText.Size = UDim2.new(1, -20, 0, 40)
        discText.Position = UDim2.new(0, 10, 0, 26)
        discText.BackgroundTransparency = 1
        discText.Text = "Use this script responsibly. We are not responsible for any actions taken against your Roblox account."
        discText.TextColor3 = Color3.fromRGB(255, 200, 200)
        discText.Font = Enum.Font.Gotham
        discText.TextSize = 9
        discText.TextWrapped = true
        discText.TextXAlignment = Enum.TextXAlignment.Left
        discText.TextYAlignment = Enum.TextYAlignment.Top
        discText.Parent = disclaimerCard
    end
    local function syncToggle(currentActive, targetState, toggleFunc)
        if targetState ~= nil and currentActive ~= targetState then
            pcall(toggleFunc)
        end
    end
    local function getConfigsList()
        local list = {}
        if isfile("PIXECUTE_CONFIG/configs_index.json") then
            local success, content = pcall(function() return readfile("PIXECUTE_CONFIG/configs_index.json") end)
            if success and content then
                local ok, decoded = pcall(function() return game:GetService("HttpService"):JSONDecode(content) end)
                if ok and type(decoded) == "table" then
                    list = decoded
                end
            end
        end
        return list
    end
    local function saveConfigsList(list)
        pcall(function()
            if not isfolder("PIXECUTE_CONFIG") then makefolder("PIXECUTE_CONFIG") end
            writefile("PIXECUTE_CONFIG/configs_index.json", game:GetService("HttpService"):JSONEncode(list))
        end)
    end
    local function SaveConfig(name)
        if not name or name == "" then return end
        local HttpService = game:GetService("HttpService")
        local config = {
            flyV3 = flyV3Active,
            noclip = noclipActive,
            bringPart = blackHoleActive,
            airwalk = isAirwalkActive,
            esp = isEspEnabled,
            espTeam = isEspTeamEnabled,
            lampu = isLampuON,
            infJump = infJumpActive,
            antiAFK = isAntiAFKActive,
            fullbright = isFullbright,
            aimbot = aimbotEnabled,
            speed = speedActive,
            clickTP = clickTPActive,
            unanchor = unanchorActive,
            antiLag = antiLagActive,
            btools = isBToolsActive,
            jumpPower = isJumpActive,
            tptool = tptoolActive,
            shiftLock = shiftLockActive,
        }
        local success, json = pcall(function() return HttpService:JSONEncode(config) end)
        if success then
            if not isfolder("PIXECUTE_CONFIG") then makefolder("PIXECUTE_CONFIG") end
            writefile("PIXECUTE_CONFIG/" .. name .. ".json", json)
            local list = getConfigsList()
            local found = false
            for _, v in ipairs(list) do
                if v == name then found = true break end
            end
            if not found then
                table.insert(list, name)
                saveConfigsList(list)
            end
            writefile("PIXECUTE_CONFIG/autoload.txt", name)
            if refreshConfigsUI then
                refreshConfigsUI()
            end
        end
    end
    local function LoadConfig(name)
        if not name or name == "" then return end
        local HttpService = game:GetService("HttpService")
        local filePath = "PIXECUTE_CONFIG/" .. name .. ".json"
        if isfile(filePath) then
            local success, result = pcall(function()
                return HttpService:JSONDecode(readfile(filePath))
            end)
            if success and type(result) == "table" then
                syncToggle(flyV3Active, result.flyV3, toggleFlyV3)
                syncToggle(noclipActive, result.noclip, toggleNoclip)
                syncToggle(blackHoleActive, result.bringPart, toggleBringPart)
                syncToggle(isAirwalkActive, result.airwalk, toggleAirwalk)
                syncToggle(isEspEnabled, result.esp, toggleESP)
                syncToggle(isEspTeamEnabled, result.espTeam, toggleESPTeam)
                syncToggle(isLampuON, result.lampu, toggleLampu)
                syncToggle(infJumpActive, result.infJump, toggleInfiniteJump)
                syncToggle(isAntiAFKActive, result.antiAFK, toggleAntiAFK)
                syncToggle(isFullbright, result.fullbright, toggleFullbright)
                syncToggle(aimbotEnabled, result.aimbot, toggleAimbot)
                syncToggle(speedActive, result.speed, toggleSpeed)
                syncToggle(clickTPActive, result.clickTP, toggleClickTP)
                syncToggle(unanchorActive, result.unanchor, toggleUnanchor)
                syncToggle(antiLagActive, result.antiLag, toggleAntiLag)
                syncToggle(isBToolsActive, result.btools, toggleBTools)
                syncToggle(isJumpActive, result.jumpPower, toggleJumpPower)
                syncToggle(tptoolActive, result.tptool, toggleTPTool)
                syncToggle(shiftLockActive, result.shiftLock, toggleShiftLock)
                pcall(function()
                    writefile("PIXECUTE_CONFIG/autoload.txt", name)
                end)
            end
        end
    end
    local function DeleteConfig(name)
        if not name or name == "" then return end
        local filePath = "PIXECUTE_CONFIG/" .. name .. ".json"
        if isfile(filePath) then
            pcall(function() delfile(filePath) end)
        end
        local list = getConfigsList()
        for i, v in ipairs(list) do
            if v == name then
                table.remove(list, i)
                break
            end
        end
        saveConfigsList(list)
        if isfile("PIXECUTE_CONFIG/autoload.txt") then
            local success, auto = pcall(function() return readfile("PIXECUTE_CONFIG/autoload.txt") end)
            if success and auto == name then
                pcall(function() delfile("PIXECUTE_CONFIG/autoload.txt") end)
            end
        end
        if refreshConfigsUI then
            refreshConfigsUI()
        end
    end
    createConfigWindow = function()
        if ConfigFrame:FindFirstChild("ConfigScroll") then return end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ConfigScroll"
        scrollFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
        scrollFrame.Parent = ConfigFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = scrollFrame
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 25)
        title.BackgroundTransparency = 1
        title.Text = "Settings / Config"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 15
        title.LayoutOrder = 1
        title.Parent = scrollFrame
        local nameInput = Instance.new("TextBox")
        nameInput.Name = "ConfigNameInput"
        nameInput.Size = UDim2.new(0, 200, 0, 32)
        nameInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        nameInput.Text = ""
        nameInput.PlaceholderText = "Config Name..."
        nameInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        nameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameInput.Font = Enum.Font.GothamBold
        nameInput.TextSize = 13
        nameInput.LayoutOrder = 2
        Instance.new("UICorner", nameInput).CornerRadius = UDim.new(0, 6)
        nameInput.Parent = scrollFrame
        local saveBtn = Instance.new("TextButton")
        saveBtn.Size = UDim2.new(0, 200, 0, 30)
        saveBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        saveBtn.Text = "Save Config"
        saveBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.LayoutOrder = 3
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)
        saveBtn.Parent = scrollFrame
        saveBtn.MouseButton1Click:Connect(function()
            local text = nameInput.Text
            text = string.gsub(text, "[^%w%-_]", "")
            if text ~= "" then
                SaveConfig(text)
                nameInput.Text = ""
            end
        end)
        local listTitle = Instance.new("TextLabel")
        listTitle.Size = UDim2.new(1, 0, 0, 20)
        listTitle.BackgroundTransparency = 1
        listTitle.Text = "Saved Configs:"
        listTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
        listTitle.Font = Enum.Font.GothamBold
        listTitle.TextSize = 12
        listTitle.LayoutOrder = 4
        listTitle.Parent = scrollFrame
        configListItemsFrame = Instance.new("Frame")
        configListItemsFrame.Name = "ItemsFrame"
        configListItemsFrame.Size = UDim2.new(1, 0, 0, 0)
        configListItemsFrame.BackgroundTransparency = 1
        configListItemsFrame.LayoutOrder = 5
        configListItemsFrame.Parent = scrollFrame
        refreshConfigsUI = function()
            if not configListItemsFrame then return end
            configListItemsFrame:ClearAllChildren()
            local itemsLayout = Instance.new("UIListLayout")
            itemsLayout.Padding = UDim.new(0, 6)
            itemsLayout.SortOrder = Enum.SortOrder.Name
            itemsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            itemsLayout.Parent = configListItemsFrame
            itemsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                configListItemsFrame.Size = UDim2.new(1, 0, 0, itemsLayout.AbsoluteContentSize.Y + 5)
            end)
            local configs = getConfigsList()
            for _, cfgName in ipairs(configs) do
                local row = Instance.new("Frame")
                row.Name = cfgName
                row.Size = UDim2.new(0, 200, 0, 30)
                row.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                row.BackgroundTransparency = 0.2
                row.Parent = configListItemsFrame
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
                local nameLbl = Instance.new("TextLabel")
                nameLbl.Size = UDim2.new(1, -75, 1, 0)
                nameLbl.Position = UDim2.new(0, 8, 0, 0)
                nameLbl.BackgroundTransparency = 1
                nameLbl.Text = cfgName
                nameLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
                nameLbl.Font = Enum.Font.GothamBold
                nameLbl.TextSize = 12
                nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                nameLbl.Parent = row
                local loadButton = Instance.new("TextButton")
                loadButton.Size = UDim2.new(0, 40, 0, 22)
                loadButton.Position = UDim2.new(1, -66, 0.5, -11)
                loadButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                loadButton.Text = "Load"
                loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                loadButton.Font = Enum.Font.GothamBold
                loadButton.TextSize = 10
                Instance.new("UICorner", loadButton).CornerRadius = UDim.new(0, 4)
                loadButton.Parent = row
                loadButton.MouseButton1Click:Connect(function()
                    LoadConfig(cfgName)
                end)
                local delButton = Instance.new("TextButton")
                delButton.Size = UDim2.new(0, 20, 0, 22)
                delButton.Position = UDim2.new(1, -24, 0.5, -11)
                delButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                delButton.Text = "X"
                delButton.TextColor3 = Color3.fromRGB(255, 50, 50)
                delButton.Font = Enum.Font.GothamBold
                delButton.TextSize = 10
                Instance.new("UICorner", delButton).CornerRadius = UDim.new(0, 4)
                delButton.Parent = row
                delButton.MouseButton1Click:Connect(function()
                    DeleteConfig(cfgName)
                end)
            end
        end
        refreshConfigsUI()
    end
    createInfoWindow = function()
        if InfoFrame:FindFirstChild("InfoScroll") then return end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "InfoScroll"
        scrollFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollFrame.Parent = InfoFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.Parent = scrollFrame
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
        end)
        local infos = {
            { titleEN = "Fly V1 (Raycast)", titleID = "Terbang V1 (Aman)", descEN = "Safe flying mechanism with auto ground collision detection so you won't get stuck.", descID = "Sistem terbang aman yang punya sensor daratan, dijamin karakter nggak bakal nyangkut di tanah pas dimatikan." },
            { titleEN = "Fly V3 & Quick Fly", titleID = "Terbang V3 & Cepat", descEN = "Physics-based flying that acts like a jet/plane. Highly maneuverable.", descID = "Terbang menggunakan physics BodyMover, lebih lincah dan mulus kayak pesawat jet." },
            { titleEN = "Noclip", titleID = "Tembus Tembok", descEN = "Allows you to walk through solid walls and objects like a ghost.", descID = "Bikin karakter lu bisa jalan nembus dinding dan benda padat layaknya hantu." },
            { titleEN = "Airwalk", titleID = "Jalan di udara", descEN = "Spawns an invisible platform below your feet preventing you from falling.", descID = "Bikin pijakan platform transparan di bawah kaki lu biar lu bisa jalan/berdiri di udara." },
            { titleEN = "Click TP", titleID = "Klik TP", descEN = "Hold CTRL and Left-Click anywhere on your screen to instantly teleport there.", descID = "Tahan tombol CTRL lalu klik kiri di mana aja, karakter lu bakal langsung teleport ke titik itu." },
            { titleEN = "Tween TP", titleID = "Tween TP", descEN = "Teleports smoothly avoiding anti-cheats instead of instantly blinking.", descID = "Teleport secara perlahan (terbang lurus) menuju target biar nggak gampang terdeteksi anti-cheat." },
            { titleEN = "Save WP", titleID = "Simpan Lokasi", descEN = "Saves your current location so you can easily teleport back anytime.", descID = "Nyimpen posisi lu berdiri saat ini, biar nanti gampang teleport balik ke tempat yang sama." },
            { titleEN = "Jump Power & Speed", titleID = "Jump Power & Kecepatan", descEN = "Adjust how fast and high you can go. Can be configured in the Utility Tab.", descID = "Bisa diatur di Tab Utility buat ngubah seberapa kencang lari lu dan setinggi apa lu bisa lompat." },
            { titleEN = "ESP & ESP Team", titleID = "ESP & ESP Team", descEN = "Wallhack that highlights all players (or team only) displaying their names, health, and distance.", descID = "Fitur wallhack (tembus dinding) yang nampilin nama, darah, dan jarak pemain lain/tim." },
            { titleEN = "Hitbox Expander", titleID = "Hitbox", descEN = "Expands the hitbox (HumanoidRootPart) of all other players making it extremely easy to hit them.", descID = "Membesarkan ukuran hitbox (badan) pemain lain, bikin serangan/tembakan lu pasti kena walau meleset dikit." },
            { titleEN = "Aimbot (Silent Aim)", titleID = "Aimbot", descEN = "Automatically locks your camera to the closest player. Best used for shooting games.", descID = "Otomatis ngunci arah kamera lu ke pemain terdekat. Sangat cocok buat main game tembak-tembakan FPS." },
            { titleEN = "Part Scanner", titleID = "Part Scanner", descEN = "Scans all parts in the map and allows you to Unanchor, Yeet, or Bring them.", descID = "Mendeteksi semua objek/part di map, lalu ngasih lu opsi buat Unanchor, Yeet (buang ke void), atau Bring (tarik ke lu)." },
            { titleEN = "Bring Part & Unanchor", titleID = "Tarik Objek & Lepas Kunci", descEN = "Pulls all unanchored parts towards you like a blackhole. Turn on Unanchor to detach buildings.", descID = "Naruh lubang hitam di karakter lu buat narik semua part. Gunakan Unanchor untuk ngelepas bangunan yang menempel." },
            { titleEN = "BTools", titleID = "BTools", descEN = "Gives you creator building tools to delete unanchored parts from the map.", descID = "Ngasi lu item alat bangun (Hammer) biar lu bisa ngapus objek/bangunan orang lain di map." },
            { titleEN = "Fling (Kick)", titleID = "Putar Badan", descEN = "Glitch your character physics to forcefully knock other players into the sky.", descID = "Nge-glitch physics lu, jadi kalau lu nabrak orang lain, orang itu bakal mental ke bulan/terpental sangat jauh." },
            { titleEN = "Fling Aura & Orbit", titleID = "Fling Aura & Orbit", descEN = "Aura automatically kicks nearby players. Orbit rapidly spins around a target.", descID = "Aura menendang pemain yang ngedeket otomatis. Orbit ngelilingin target dengan cepat biar dia kena tabrak fling." },
            { titleEN = "Spectate", titleID = "Penonton", descEN = "Switch your camera to view what another player is currently seeing/doing.", descID = "Pindah sudut pandang kamera lu ke pemain lain buat mantau layar/aktivitas dia diem-diem." },
            { titleEN = "Free Cam", titleID = "Kamera Bebas", descEN = "Detaches the camera from your body so you can fly around the map invisibly.", descID = "Ngelepas kamera lu dari karakter, jadi lu bisa jalan-jalan liat map pake kamera tanpa ketahuan." },
            { titleEN = "Anti Lag", titleID = "Anti Lag", descEN = "Lowers graphics, water physics, and lighting to massively boost your FPS.", descID = "Nurunin setingan grafik, menghapus tekstur air, dan bayangan buat ngurangin lag secara drastis." },
            { titleEN = "Server Hop", titleID = "Pindah Server", descEN = "Quickly scans for a different server lobby and teleports you into it.", descID = "Cari lobi server lain yang beda ping/pemain, lalu otomatis mindahin lu ke server itu." },
            { titleEN = "Clone Avatar", titleID = "Kloning Avatar", descEN = "Copies the outfits, hats, and accessories of another player instantly.", descID = "Nge-copy dan makaian kostum, aksesoris, serta avatar pemain lain langsung di karakter lu." },
            { titleEN = "Emote Bypass", titleID = "Emote Bypass", descEN = "Plays specific internal Roblox dances/emotes regardless of game settings.", descID = "Maksa muter animasi joget (dance) tersembunyi yang biasanya dilarang di game tersebut." },
            { titleEN = "Chat Logs", titleID = "Chat Logs", descEN = "Saves everyone's chat messages, even if they delete them from the chatbox.", descID = "Nyimpen jejak chat semua pemain. Kalau ada yang ngirim pesan terus dihapus/nge-clear chat, bakal tetep kebaca di sini." },
            { titleEN = "DEX Explorer", titleID = "DEX Explorer", descEN = "An advanced tool used to inspect the internal files and scripts of the game.", descID = "Alat khusus sekelas developer (Dark Dex) buat membongkar isi file map dan script yang ada di dalam game." },
            { titleEN = "Command Bar", titleID = "Command Bar", descEN = "Draggable bar at the bottom. Type commands like ;speed 100, ;fly, ;jp 500.", descID = "Kolom perintah di bawah layar. Ketik perintah chat kayak ;speed 100, ;fly, atau ;hitbox 50." }
        }
        for idx, info in ipairs(infos) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Name = "InfoItem"
            itemFrame.Size = UDim2.new(1, -10, 0, 100)
            itemFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            itemFrame.BorderSizePixel = 0
            itemFrame.LayoutOrder = idx
            itemFrame.Parent = scrollFrame
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = itemFrame
            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -20, 0, 30)
            titleLbl.Position = UDim2.new(0, 10, 0, 5)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextSize = 16
            titleLbl.TextColor3 = Color3.fromRGB(255, 80, 80)
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.Text = currentLanguage == "EN" and info.titleEN or info.titleID
            titleLbl.Parent = itemFrame
            local descLbl = Instance.new("TextLabel")
            descLbl.Size = UDim2.new(1, -20, 1, -40)
            descLbl.Position = UDim2.new(0, 10, 0, 35)
            descLbl.BackgroundTransparency = 1
            descLbl.Font = Enum.Font.Gotham
            descLbl.TextSize = 13
            descLbl.TextColor3 = Color3.fromRGB(220, 220, 220)
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.TextYAlignment = Enum.TextYAlignment.Top
            descLbl.TextWrapped = true
            descLbl.Text = currentLanguage == "EN" and info.descEN or info.descID
            descLbl.Parent = itemFrame
            table.insert(translatableElements, {
                element = titleLbl,
                customUpdate = function()
                    titleLbl.Text = currentLanguage == "EN" and info.titleEN or info.titleID
                end
            })
            table.insert(translatableElements, {
                element = descLbl,
                customUpdate = function()
                    descLbl.Text = currentLanguage == "EN" and info.descEN or info.descID
                end
            })
            local tService = game:GetService("TextService")
            local bounds = tService:GetTextSize(descLbl.Text, descLbl.TextSize, descLbl.Font, Vector2.new(280, 9999))
            itemFrame.Size = UDim2.new(1, -10, 0, math.max(80, 45 + bounds.Y))
        end
    end
    local createShortcutsWindow = function()
        if ShortcutsFrame:FindFirstChild("ShortcutsScroll") then return end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ShortcutsScroll"
        scrollFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
        scrollFrame.Parent = ShortcutsFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = scrollFrame
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = "ShortcutsItem"
        itemFrame.Size = UDim2.new(1, -8, 0, 190)
        itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        itemFrame.Parent = scrollFrame
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 6)
        itemCorner.Parent = itemFrame
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -16, 0, 22)
        titleLabel.Position = UDim2.new(0, 8, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.TextSize = 14
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.Text = "PC Keyboard Shortcuts"
        titleLabel.Parent = itemFrame
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, -16, 1, -38)
        valueLabel.Position = UDim2.new(0, 8, 0, 34)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.TextYAlignment = Enum.TextYAlignment.Top
        valueLabel.TextSize = 13
        valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        valueLabel.RichText = true
        addTranslatable(valueLabel, "ShortcutsDesc", "Text")
        valueLabel.TextWrapped = true
        valueLabel.Parent = itemFrame
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        end)
    end
    createChangelogsWindow = function()
        if ChangelogsFrame:FindFirstChild("ChangelogsScroll") then return end
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ChangelogsScroll"
        scrollFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
        scrollFrame.Parent = ChangelogsFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = scrollFrame
        local changelogs = {
            { title = "v3.7.0 (Premium Combat & UI Update)", key = "CL_370" },
            { title = "v3.6.0 (Shortcuts & UX Update)", key = "CL_360" },
            { title = "v3.5.0 (Quick Tools Update)", key = "CL_350" },
            { title = "v3.4.0 (Spectate & Bug Fixes)", key = "CL_340" },
            { title = "v3.3.0 (Globalisation & Invis Rework)", key = "CL_330" },
            { title = "v3.2.0 (Bug Fixes & UX)", key = "CL_320" },
            { title = "v3.1.0 (Premium & TP Update)", key = "CL_310" },
            { title = "v3.0.0 (Anti Lag & Features)", key = "CL_300" },
            { title = "v2.5.0 (Optimasi & GUI)", key = "CL_250" },
            { title = "v2.0.0 (ESP Update)", key = "CL_200" }
        }
        for idx, log in ipairs(changelogs) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Name = "LogItem"
            itemFrame.Size = UDim2.new(1, -8, 0, 95)
            itemFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            itemFrame.LayoutOrder = idx
            itemFrame.Parent = scrollFrame
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 6)
            itemCorner.Parent = itemFrame
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -16, 0, 22)
            titleLabel.Position = UDim2.new(0, 8, 0, 4)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.TextSize = 12
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.Text = log.title
            titleLabel.Parent = itemFrame
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(1, -16, 0, 65)
            valueLabel.Position = UDim2.new(0, 8, 0, 26)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextXAlignment = Enum.TextXAlignment.Left
            valueLabel.TextYAlignment = Enum.TextYAlignment.Top
            valueLabel.TextSize = 10
            valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            addTranslatable(valueLabel, log.key, "Text")
            valueLabel.TextWrapped = true
            valueLabel.Parent = itemFrame
        end
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
        end)
    end
    function sendPublicChat(message)
        pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local ChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local SayMessage = ChatEvents and ChatEvents:FindFirstChild("SayMessageRequest")
            if SayMessage then
                SayMessage:FireServer(message, "All")
            end
        end)
        pcall(function()
            local TextChatService = game:GetService("TextChatService")
            local TextChannels = TextChatService:FindFirstChild("TextChannels")
            local ChatChannel = TextChannels and TextChannels:FindFirstChild("RBXGeneral")
            if ChatChannel then
                ChatChannel:SendAsync(message)
            end
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
    local btnWaypoints = makeSmallBtn("Waypoints", 4)
    btnWaypoints.MouseButton1Click:Connect(function()
        if toggleWaypointListWindow then
            toggleWaypointListWindow()
        else
            setCategory("Waypoints")
        end
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
    local btnFriends = makeSmallBtn("Friends", 5.7)
    btnFriends.MouseButton1Click:Connect(function()
        if toggleFriendListWindow then
            toggleFriendListWindow()
        end
    end)
    local btnCredits = makeSmallBtn("Credits", 6)
    btnCredits.MouseButton1Click:Connect(function()
        createCreditsWindow()
        setCategory("Credits")
    end)
    local btnConfig = makeSmallBtn("Config", 7)
    btnConfig.MouseButton1Click:Connect(function()
        createConfigWindow()
        setCategory("Config")
    end)
    local btnShortcuts = makeSmallBtn("ShortcutsKey", 8)
    btnShortcuts.MouseButton1Click:Connect(function()
        createShortcutsWindow()
        setCategory("Shortcuts")
    end)
    local btnInfo = makeSmallBtn("Info", 9)
    btnInfo.MouseButton1Click:Connect(function()
        createInfoWindow()
        setCategory("Info")
    end)
    local btnChangelogs = makeSmallBtn("Changelogs", 9)
    btnChangelogs.MouseButton1Click:Connect(function()
        createChangelogsWindow()
        setCategory("Changelogs")
    end)
    setCategory("Menu")
    task.spawn(function()
        task.wait(1)
        if isfile("PIXECUTE_CONFIG/autoload.txt") then
            local success, auto = pcall(function() return readfile("PIXECUTE_CONFIG/autoload.txt") end)
            if success and auto and auto ~= "" then
                LoadConfig(auto)
            end
        end
    end)
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
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ButtonGrid.AbsoluteContentSize.Y + 30)
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
TitleLabel.Text = "Chil Script Universal by Pixecute"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 14
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Navbar
task.spawn(function()
    while ScreenGui and ScreenGui.Parent do
        TweenService:Create(TitleLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        task.wait(1)
        TweenService:Create(TitleLabel, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            TextColor3 = Color3.fromRGB(200, 200, 200)
        }):Play()
        task.wait(1)
    end
end)
local LangBtn = Instance.new("TextButton")
LangBtn.Size = UDim2.new(0, 30, 0, 25)
LangBtn.Position = UDim2.new(1, -65, 0.5, -12)
LangBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LangBtn.Text = currentLanguage
LangBtn.Font = Enum.Font.GothamBold
LangBtn.TextSize = 13
LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LangBtn.Parent = Navbar
local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 6)
langCorner.Parent = LangBtn
LangBtn.MouseButton1Click:Connect(function()
    local newLang = currentLanguage == "EN" and "ID" or "EN"
    LangBtn.Text = newLang
    updateLanguage(newLang)
end)
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
MiniFrame.Size = UDim2.new(0, 45, 0, 45)
MiniFrame.Position = UDim2.new(0.5, -22, 0, 8)
MiniFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MiniFrame.BackgroundTransparency = 0.05
MiniFrame.Image = "https://files.catbox.moe/xuvh8s.jpg"
MiniFrame.ScaleType = Enum.ScaleType.Fit
MiniFrame.Visible = true
MiniFrame.Active = true
MiniFrame.Draggable = true
MiniFrame.Parent = ScreenGui
local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 10)
miniCorner.Parent = MiniFrame
local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(255, 255, 255)
miniStroke.Thickness = 1.5
miniStroke.Parent = MiniFrame
MiniFrameToggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and not UserInputService:GetFocusedTextBox() then
        if input.KeyCode == Enum.KeyCode.RightControl then
            MiniFrame.Visible = not MiniFrame.Visible
        end
    end
end)
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
local isShiftLockActive = false
ShiftLockShortcutConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        isShiftLockActive = not isShiftLockActive
        if updateExternalCursorVisibility then
            updateExternalCursorVisibility()
        end
    end
end)
local mouseInPlayerList = false
function updateExternalCursorVisibility()
    if isShiftLockActive or mouseInPlayerList then
        ExternalCursor.Visible = false
    else
        local cmdVis = false
        if typeof(CmdBarFrame) == "Instance" and CmdBarFrame then cmdVis = CmdBarFrame.Visible end
        ExternalCursor.Visible = (ScreenGui.Enabled == true) and ((MainFrame.Visible == true) or cmdVis)
    end
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
do
    local url = "https://files.catbox.moe/xuvh8s.jpg"
    local ok, data = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and data and type(writefile) == "function" then
        local fileName = "mini_logo_v3.png"
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
do
    local function makeCustomWPBtn(name, comps)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 150, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        btn.BackgroundTransparency = 0.1
        btn.Text = name
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn:SetAttribute("IsFixedWP", true)
        btn:SetAttribute("IsCustomWP", true)
        btn.Visible = true
        btn.Parent = ScrollFrame
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = btn
        local p = Instance.new("UIPadding"); p.PaddingLeft = UDim.new(0,12); p.Parent = btn
        btn.MouseButton1Click:Connect(function()
            local ok, cf = pcall(function() return CFrame.new(table.unpack(comps)) end)
            if ok and typeof(cf)=="CFrame" then
                if typeof(safeTeleportToCFrame) == "function" then
                    safeTeleportToCFrame(cf)
                else
                    local lplr = game:GetService("Players").LocalPlayer
                    local char = lplr.Character or lplr.CharacterAdded:Wait()
                    if char then char:PivotTo(cf) end
                end
            end
        end)
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
        if refreshWaypointList then
            refreshWaypointList()
        end
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
    pcall(function()
        if speedOn then pcall(toggleSpeed) end
        if flying then pcall(disableFly) end
        if flyV3Active then pcall(toggleFlyV3, false) end
        if aktif then pcall(toggleUnanchor, false) end
        if plistSendPartTarget then pcall(stopPlistSendPart) end
        if syncDanceTarget then pcall(stopSyncDance) end
        if followTarget then pcall(stopFollow) end
        if headsitTarget then pcall(stopHeadsit) end
        if currentSpectateTarget then pcall(stopSpectate) end
        if ESPenabled then pcall(toggleESP, false) end
        if isEspEnabled then pcall(toggleESP, false) end
        if noclipActive then pcall(toggleNoclip, false) end
        if blackHoleActive then pcall(toggleBringPart, false) end
        if flingAuraActive then pcall(toggleFlingAura, false) end
        if orbitFlingActive then pcall(toggleOrbitFling, false) end
        if walkFlingActive then pcall(toggleWalkFling, false) end
        if antiFlingActive then pcall(toggleAntiFling, false) end
        if godModeActive then pcall(toggleGodMode, false) end
        if jumpPowerOn then pcall(toggleJumpPower, false) end
        unanchorV2Active = false
        unanchorV2Loop = nil
        if MainGuiToggleConn then pcall(function() MainGuiToggleConn:Disconnect() end) MainGuiToggleConn = nil end
        if ShiftLockShortcutConn then pcall(function() ShiftLockShortcutConn:Disconnect() end) ShiftLockShortcutConn = nil end
        if SpeedShortcutConn then pcall(function() SpeedShortcutConn:Disconnect() end) SpeedShortcutConn = nil end
        if FlyV3ShortcutConn then pcall(function() FlyV3ShortcutConn:Disconnect() end) FlyV3ShortcutConn = nil end
        if JumpPowerShortcutConn then pcall(function() JumpPowerShortcutConn:Disconnect() end) JumpPowerShortcutConn = nil end
        if FreecamShortcutConn then pcall(function() FreecamShortcutConn:Disconnect() end) FreecamShortcutConn = nil end
        if MiniFrameToggleConn then pcall(function() MiniFrameToggleConn:Disconnect() end) MiniFrameToggleConn = nil end
        local coreGui = game:GetService("CoreGui")
        for _, guiName in ipairs({"CHCmdBarGUI", "PIXECUTE SPECTATE", "FriendListFrame", "PlayerListFrame"}) do
            local g = coreGui:FindFirstChild(guiName)
            if g then pcall(function() g:Destroy() end) end
        end
        if CmdBarFrame and CmdBarFrame.Parent then
            pcall(function() CmdBarFrame.Visible = false end)
        end
        local pGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, guiName in ipairs({"CHCmdBarGUI"}) do
                local g = pGui:FindFirstChild(guiName)
                if g then pcall(function() g:Destroy() end) end
            end
        end
    end)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
end)
MinimizeBtn = nil
MiniFrame.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            MainFrame.Visible = false
        end)
    else
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 340)})
        tween:Play()
    end
end)
local buttonStates = {}
function createButton(icon, textKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BackgroundTransparency = 0.1
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 50, 50)
    addTranslatable(btn, textKey, "Text", icon .. "  ")
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = 0
    btn.AutoButtonColor = false
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.Parent = btn
    local defaultColor = Color3.fromRGB(15, 15, 15)
    local hoverColor = Color3.fromRGB(25, 25, 25)
    buttonStates[btn] = false
    btn.MouseEnter:Connect(function()
        if not buttonStates[btn] then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = hoverColor
            }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if not buttonStates[btn] then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = defaultColor
            }):Play()
        end
    end)
    btn.Parent = ScrollFrame
    return btn
end
function setButtonActive(button, active)
    if not button then return end
    buttonStates[button] = active
    local stroke = button:FindFirstChildOfClass("UIStroke")
    if active then
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(255, 255, 255)
            }):Play()
        end
    else
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            TextColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(255, 50, 50)
            }):Play()
        end
    end
end
local AirwalkActive = false
local AirWPart = nil
local baseY = nil
AirwalkBtn = createButton("", "Jalan di udara")
function StartAirwalk()
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
function StopAirwalk()
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
    if ESPenabled then
        stopESP()
        task.spawn(function()
            task.wait(0.5)
            if ESPenabled then
                startESP()
            end
        end)
    end
end)
ESPBtn = createButton("", "ESP")
ESPTeamBtn = createButton("", "ESP Team")
ESPNamesEnabled = true
local COREGUI = game:GetService("CoreGui")
local ESPenabled = false
local ESPTeamMode = false
local espTransparency = 0.3
function getRoot(char)
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end
function destroyPlayerESP(name)
    pcall(function()
        for _, v in pairs(COREGUI:GetChildren()) do
            if v.Name == name .. "_ESP" then
                v:Destroy()
            end
        end
    end)
end
function CreateESP(plr)
    if plr == LocalPlayer then return end
    if not plr.Character or not getRoot(plr.Character) then return end
    if COREGUI:FindFirstChild(plr.Name .. "_ESP") then return end
    if ESPTeamMode and plr.Team == LocalPlayer.Team then return end

    local holder = Instance.new("Folder")
    holder.Name = plr.Name .. "_ESP"
    holder.Parent = COREGUI
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = plr.Character
    highlight.Name = plr.Name .. "_HL"
    highlight.Parent = holder
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    local teamColor = plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 30, 45)
    highlight.FillColor = teamColor
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0

    local head = plr.Character:FindFirstChild("Head")
    if head and ESPNamesEnabled then
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
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = teamColor
        label.TextStrokeTransparency = 0.2
        label.TextYAlignment = Enum.TextYAlignment.Bottom
        label.ZIndex = 10
        local function updateLabel()
            if COREGUI:FindFirstChild(plr.Name .. "_ESP") and ESPNamesEnabled then
                local myChar = LocalPlayer.Character
                if plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid") and myChar and getRoot(myChar) then
                    local studs = math.floor((getRoot(myChar).Position - getRoot(plr.Character).Position).Magnitude)
                    local hp = plr.Character:FindFirstChildOfClass("Humanoid").Health
                    label.Text = plr.Name .. "\nHP: " .. string.format("%.0f", hp) .. " | " .. studs .. "s"
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
playerAddedConnection = nil
function startESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            CreateESP(plr)
        end
    end
    if not playerAddedConnection then
        playerAddedConnection = Players.PlayerAdded:Connect(function(plr)
            if ESPenabled then
                plr.CharacterAdded:Connect(function(char)
                    if ESPenabled then
                        destroyPlayerESP(plr.Name)
                        repeat task.wait(1) until plr.Character and getRoot(plr.Character) and plr.Character:FindFirstChildOfClass("Humanoid")
                        CreateESP(plr)
                    end
                end)
                if plr.Character and getRoot(plr.Character) then
                    CreateESP(plr)
                end
            end
        end)
    end
end
function stopESP()
    for _, v in pairs(COREGUI:GetChildren()) do
        if string.sub(v.Name, -4) == "_ESP" then
            v:Destroy()
        end
    end
    for _, plr in pairs(Players:GetPlayers()) do
        pcall(function()
            local char = plr.Character
            if char then
            end
        end)
    end
    if playerAddedConnection then
        playerAddedConnection:Disconnect()
        playerAddedConnection = nil
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
        if MiniEspBtn then
            MiniEspBtn.Text = "ESP: ON"
            MiniEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        startESP()
    else
        setButtonActive(ESPBtn, false)
        if MiniEspBtn then
            MiniEspBtn.Text = "ESP: OFF"
            MiniEspBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
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
LampBtn = createButton("", "Lampu")
local lampOn = false
local headLamp = nil
function addHeadLamp(char)
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
function removeHeadLamp()
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
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local infiniteJumpEnabled = false
local jumpPowerBoost = 25
local slowFallSpeed = -50
JumpBtn = createButton("", "Infinite Jump")
function updateCharacterRefs(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
end
player.CharacterAdded:Connect(updateCharacterRefs)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
RejoinBtn = createButton("", "Rejoin")
RejoinBtn.LayoutOrder = 1
function rejoinServer()
    local player = game:GetService("Players").LocalPlayer
    local ts = game:GetService("TeleportService")
    local currentPlaceId = game.PlaceId
    local currentJobId = game.JobId
    local ok = false
    if #game.Players:GetPlayers() > 1 and currentJobId ~= "" then
        ok = pcall(function()
            ts:TeleportToPlaceInstance(currentPlaceId, currentJobId, player)
        end)
    end
    if not ok then
        pcall(function()
            ts:Teleport(currentPlaceId, player)
        end)
    end
end
RejoinBtn.MouseButton1Click:Connect(rejoinServer)
RefreshBtn = createButton("", "Refresh")
RefreshBtn.Name = "RefreshBtn"
RefreshBtn.LayoutOrder = 2
RespawnBtn = createButton("", "Respawn")
RespawnBtn.Name = "RespawnBtn"
RespawnBtn.LayoutOrder = 3
AntiAFKBtn = createButton("", "Anti AFK")
AntiAFKBtn.Name = "AntiAFKBtn"
AntiAFKBtn.LayoutOrder = 4
local antiAFKConnection = nil
function refreshCharacter(keepPosition)
    if keepPosition == nil then keepPosition = true end
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    if not plr then return end
    local char = plr.Character
    if not char then return end
    local savedCFrame = nil
    if keepPosition then
        pcall(function() savedCFrame = char:GetPivot() end)
    end
    local hum = char:FindFirstChild("Humanoid")
    if hum then
        hum.Health = 0
    elseif char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart:Destroy()
    end
    if keepPosition and savedCFrame then
        local newChar = plr.CharacterAdded:Wait()
        local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            task.wait(0.3)
            pcall(function() newChar:PivotTo(savedCFrame) end)
        end
    end
end
RefreshBtn.MouseButton1Click:Connect(function() refreshCharacter(true) end)
RespawnBtn.MouseButton1Click:Connect(function() refreshCharacter(false) end)
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
FullbrightBtn = createButton("", "Fullbright")
FullbrightBtn.LayoutOrder = 4
local fullbrightOn = false
local lightingConns = {}
function toggleFullbright(state)
    if state == nil then
        fullbrightOn = not fullbrightOn
    else
        fullbrightOn = state
    end
    local Lighting = game:GetService("Lighting")
    if fullbrightOn then
        local function setFB()
            pcall(function()
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                Lighting.Brightness = 2
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 999999
                Lighting.FogStart = 999999
            end)
        end
        setFB()
        table.insert(lightingConns, Lighting.Changed:Connect(setFB))
        setButtonActive(FullbrightBtn, true)
    else
        for _, conn in ipairs(lightingConns) do
            if conn then conn:Disconnect() end
        end
        lightingConns = {}
        pcall(function()
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
        end)
        setButtonActive(FullbrightBtn, false)
    end
end
FullbrightBtn.MouseButton1Click:Connect(function()
    toggleFullbright()
end)
AimbotBtn = createButton("", "Aimbot")
AimbotBtn.LayoutOrder = 5
local aimbotEnabled = false
local aimbotConnection = nil
function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local lplr = game.Players.LocalPlayer
    local myChar = lplr.Character
    local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))
    if not myHrp then return nil end
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= lplr and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local targetHrp = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character.Head
            local dist = (targetHrp.Position - myHrp.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestPlayer = plr
            end
        end
    end
    return closestPlayer
end
function toggleAimbot(state)
    if state == nil then
        aimbotEnabled = not aimbotEnabled
    else
        aimbotEnabled = state
    end
    setButtonActive(AimbotBtn, aimbotEnabled)
    if aimbotEnabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local camera = workspace.CurrentCamera
                local targetPos = target.Character.Head.Position
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            end
        end)
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
    end
end
AimbotBtn.MouseButton1Click:Connect(function()
    toggleAimbot()
end)
InvisibleBtn = createButton("", "Invisible")
InvisibleBtn.Name = "InvisibleBtn"
VisibleBtn = createButton("", "Visible")
VisibleBtn.Name = "VisibleBtn"
FPSPingBtn = createButton("", "FPS & Ping")
FPSPingBtn.Name = "FPSPingBtn"
local invisRunning = false
local invisFakeChar = nil
local invisRealChar = nil
local invisDiedConn = nil
InvisibleBtn.MouseButton1Click:Connect(function()
    if invisRunning then return end
    local plr = game:GetService("Players").LocalPlayer
    local char = plr.Character
    if not char then return end
    invisRunning = true
    setButtonActive(InvisibleBtn, true)
    setButtonActive(VisibleBtn, false)
    char.Archivable = true
    invisFakeChar = char:Clone()
    invisRealChar = char
    local currentCFrame = char:GetPivot()
    invisFakeChar.Parent = workspace
    invisFakeChar:PivotTo(currentCFrame)
    plr.Character = invisFakeChar
    workspace.CurrentCamera.CameraSubject = invisFakeChar:FindFirstChildOfClass("Humanoid")
    invisRealChar:PivotTo(currentCFrame + Vector3.new(0, 10000, 0))
    task.wait(0.05)
    invisRealChar.Parent = game:GetService("Lighting")
    local anim = invisFakeChar:FindFirstChild("Animate")
    if anim then
        anim.Disabled = true
        anim.Disabled = false
    end
    for _, v in ipairs(invisFakeChar:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name == "HumanoidRootPart" then
                v.Transparency = 1
            else
                v.Transparency = 0.5
            end
        elseif v:IsA("Decal") then
            v.Transparency = 0.5
        end
    end
    local fakeHum = invisFakeChar:FindFirstChildOfClass("Humanoid")
    if fakeHum then
        invisDiedConn = fakeHum.Died:Connect(function()
            invisRunning = false
            pcall(function()
                plr.Character = invisRealChar
                invisRealChar.Parent = workspace
                invisRealChar:FindFirstChildOfClass("Humanoid").Health = 0
                invisFakeChar:Destroy()
            end)
            if invisDiedConn then invisDiedConn:Disconnect() end
        end)
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = tr("Invisible"),
            Text = tr("Invisible_On"),
            Duration = 5
        })
    end)
end)
VisibleBtn.MouseButton1Click:Connect(function()
    if not invisRunning then return end
    invisRunning = false
    local plr = game:GetService("Players").LocalPlayer
    if invisRealChar and invisFakeChar then
        pcall(function()
            local currentCFrame = invisFakeChar:GetPivot()
            invisRealChar.Parent = workspace
            invisRealChar:PivotTo(currentCFrame)
            invisFakeChar:Destroy()
            plr.Character = invisRealChar
            workspace.CurrentCamera.CameraSubject = invisRealChar:FindFirstChildOfClass("Humanoid")
            if invisDiedConn then invisDiedConn:Disconnect() end
            local anim = invisRealChar:FindFirstChild("Animate")
            if anim then
                anim.Disabled = true
                anim.Disabled = false
            end
        end)
    end
    invisRealChar = nil
    invisFakeChar = nil
    setButtonActive(VisibleBtn, true)
    setButtonActive(InvisibleBtn, false)
    task.delay(0.5, function() setButtonActive(VisibleBtn, false) end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = tr("Visible"),
            Text = tr("Visible_On"),
            Duration = 3
        })
    end)
end)
FPSPingBtn.MouseButton1Click:Connect(function()
    if typeof(_G.ToggleFPSPingMonitor) == "function" then
        _G.ToggleFPSPingMonitor()
    end
end)
local httpService = game:GetService("HttpService")
local teleportService = game:GetService("TeleportService")
local placeId = game.PlaceId
local jobId = game.JobId
local ServerHopGui = nil
function createServerHopWindow()
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
    mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    ServerHopGui = mainFrame
    local modal = Instance.new("TextButton")
    modal.Size = UDim2.new(0, 0, 0, 0)
    modal.BackgroundTransparency = 1
    modal.Text = ""
    modal.Modal = true
    modal.Parent = mainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.Parent = mainFrame
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 10)
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topCover.BorderSizePixel = 0
    topCover.Parent = topBar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    addTranslatable(title, "ServerList", "Text")
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1.5
    closeStroke.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -54, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
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
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1.5
    minStroke.Parent = minBtn
    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            mainFrame:TweenSize(UDim2.new(0, 340, 0, 30), "Out", "Quad", 0.3, true)
            minBtn.Text = "+"
        else
            mainFrame:TweenSize(UDim2.new(0, 340, 0, 360), "Out", "Quad", 0.3, true)
            minBtn.Text = "-"
        end
    end)
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 22, 0, 22)
    refreshBtn.Position = UDim2.new(1, -80, 0.5, -11)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    refreshBtn.BackgroundTransparency = 0.1
    refreshBtn.Text = "R"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 13
    refreshBtn.Parent = topBar
    local refCorner = Instance.new("UICorner")
    refCorner.CornerRadius = UDim.new(0, 6)
    refCorner.Parent = refreshBtn
    local refStroke = Instance.new("UIStroke")
    refStroke.Color = Color3.fromRGB(255, 255, 255)
    refStroke.Thickness = 1
    refStroke.Parent = refreshBtn
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(1, -20, 0, 40)
    infoFrame.Position = UDim2.new(0, 10, 0, 35)
    infoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    infoFrame.BackgroundTransparency = 0.5
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
    jobIdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                    local hasCurrent = false
                    if currentJobId ~= "" then
                        for _, v in ipairs(data) do
                            if type(v) == "table" and v.id == currentJobId then
                                hasCurrent = true
                                break
                            end
                        end
                    end
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
                                sBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
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
                                    teleportService:TeleportToPlaceInstance(tonumber(currentPlaceId) or game.PlaceId, v.id, game.Players.LocalPlayer)
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
function serverhop()
    createServerHopWindow()
end
PlayerListFrame = nil
PlayerListScroll = nil
PlayerListSearchBox = nil
currentSpectateTarget = nil
expandedPlayerUserId = nil
playerConnections = {}
refreshPlayerList = nil
updateCanvasSize = nil
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
function getPlayerThumbnail(targetUserId)
    local success, result = pcall(function()
        return game:GetService("Players"):GetUserThumbnailAsync(targetUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    if success and result then
        return result
    end
    return "rbxasset://textures/ui/avatar_placeholder.png"
end
local function cloneAvatar(targetPlayer)
    if not targetPlayer then return end
    local myChar = game.Players.LocalPlayer.Character
    if not myChar then return end
    local myHumanoid = myChar:FindFirstChildOfClass("Humanoid")
    if not myHumanoid then return end
    local targetChar = targetPlayer.Character
    local successDesc, desc = pcall(function()
        return game.Players:GetHumanoidDescriptionFromUserId(targetPlayer.UserId)
    end)
    local applied = false
    if successDesc and desc then
        local successApply, err = pcall(function()
            myHumanoid:ApplyDescription(desc)
        end)
        if successApply then
            applied = true
        else
            warn("ApplyDescription failed: " .. tostring(err))
        end
    end
    if not applied and targetChar then
        for _, item in ipairs(myChar:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("BodyColors") or item:IsA("ShirtGraphic") or item:IsA("CharacterMesh") then
                item:Destroy()
            end
        end
        local myShirt = myChar:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", myChar)
        local myPants = myChar:FindFirstChildOfClass("Pants") or Instance.new("Pants", myChar)
        local targetShirt = targetChar:FindFirstChildOfClass("Shirt")
        local targetPants = targetChar:FindFirstChildOfClass("Pants")
        if targetShirt then myShirt.ShirtTemplate = targetShirt.ShirtTemplate else myShirt:Destroy() end
        if targetPants then myPants.PantsTemplate = targetPants.PantsTemplate else myPants:Destroy() end
        local myColors = myChar:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors", myChar)
        local targetColors = targetChar:FindFirstChildOfClass("BodyColors")
        if targetColors then
            for _, prop in ipairs({"HeadColor3", "LeftArmColor3", "LeftLegColor3", "RightArmColor3", "RightLegColor3", "TorsoColor3"}) do
                pcall(function() myColors[prop] = targetColors[prop] end)
            end
        end
        local myHead = myChar:FindFirstChild("Head")
        local targetHead = targetChar:FindFirstChild("Head")
        if myHead and targetHead then
            local myFace = myHead:FindFirstChildOfClass("Decal") or Instance.new("Decal", myHead)
            local targetFace = targetHead:FindFirstChildOfClass("Decal")
            if targetFace then
                myFace.Texture = targetFace.Texture
            else
                myFace:Destroy()
            end
        end
        for _, item in ipairs(targetChar:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("ShirtGraphic") or item:IsA("CharacterMesh") then
                local oldArch = item.Archivable
                item.Archivable = true
                local clone = item:Clone()
                item.Archivable = oldArch
                if clone then
                    clone.Parent = myChar
                end
            end
        end
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Clone Avatar",
            Text = "Avatar cloned: " .. targetPlayer.DisplayName,
            Duration = 3
        })
    end)
end
local function promptClone()
    local old = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("CloneAvatarPrompt")
    if old then pcall(function() old:Destroy() end) end
    local cloneGui = Instance.new("ScreenGui")
    cloneGui.Name = "CloneAvatarPrompt"
    cloneGui.ResetOnSpawn = false
    local successParentPrompt, errParentPrompt = pcall(function()
        cloneGui.Parent = game:GetService("CoreGui")
    end)
    if not successParentPrompt then
        cloneGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 320)
    frame.Position = UDim2.new(0.5, -150, 0.5, -160)
    frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    frame.BackgroundTransparency = 0.1
    frame.ClipsDescendants = true
    frame.Parent = cloneGui
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 0, 40)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "CLONE AVATAR"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -30, 0, 8)
    close.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 12
    close.Parent = frame
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
    local closeStroke = Instance.new("UIStroke", close)
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1.5
    close.MouseButton1Click:Connect(function() cloneGui:Destroy() end)
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 24, 0, 24)
    minBtn.Position = UDim2.new(1, -58, 0, 8)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.Parent = frame
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
    local minStroke = Instance.new("UIStroke", minBtn)
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1.5
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(1, -20, 0, 32)
    searchFrame.Position = UDim2.new(0, 10, 0, 45)
    searchFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    searchFrame.BackgroundTransparency = 0.2
    searchFrame.Parent = frame
    Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 8)
    local searchStroke = Instance.new("UIStroke", searchFrame)
    searchStroke.Color = Color3.fromRGB(255, 255, 255)
    searchStroke.Thickness = 1.5
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.Position = UDim2.new(0, 10, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.GothamBold
    searchBox.Text = ""
    addTranslatable(searchBox, "SearchPlayers", "PlaceholderText")
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 12
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchFrame
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -95)
    scroll.Position = UDim2.new(0, 10, 0, 85)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scroll.Parent = frame
    local isMinimized = false
    local normalSize = UDim2.new(0, 300, 0, 320)
    local minimizedSize = UDim2.new(0, 300, 0, 40)
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            minBtn.Text = "+"
            TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
            scroll.Visible = false
            searchFrame.Visible = false
        else
            minBtn.Text = "-"
            TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize}):Play()
            task.delay(0.1, function()
                if not isMinimized then
                    scroll.Visible = true
                    searchFrame.Visible = true
                end
            end)
        end
    end)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    local function populate()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        local filter = searchBox.Text:lower()
        local plist = game.Players:GetPlayers()
        table.sort(plist, function(a, b)
            return (a.DisplayName or ""):lower() < (b.DisplayName or ""):lower()
        end)
        local count = 0
        for _, p in ipairs(plist) do
            if p ~= game.Players.LocalPlayer then
                local disp = (p.DisplayName or ""):lower()
                local name = (p.Name or ""):lower()
                if filter == "" or disp:find(filter, 1, true) or name:find(filter, 1, true) then
                    count = count + 1
                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, -6, 0, 48)
                    row.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
                    row.LayoutOrder = count
                    row.Parent = scroll
                    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
                    local img = Instance.new("ImageLabel")
                    img.Size = UDim2.new(0, 36, 0, 36)
                    img.Position = UDim2.new(0, 6, 0.5, -18)
                    img.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
                    img.Parent = row
                    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
                    img.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p.UserId) .. "&w=48&h=48"
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Size = UDim2.new(0.5, -40, 0, 18)
                    nameLabel.Position = UDim2.new(0, 48, 0.1, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Font = Enum.Font.GothamBold
                    nameLabel.TextSize = 11
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    nameLabel.Text = p.DisplayName
                    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    nameLabel.Parent = row
                    local userLabel = Instance.new("TextLabel")
                    userLabel.Size = UDim2.new(0.5, -40, 0, 14)
                    userLabel.Position = UDim2.new(0, 48, 0.5, 0)
                    userLabel.BackgroundTransparency = 1
                    userLabel.Font = Enum.Font.Gotham
                    userLabel.TextSize = 9
                    userLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                    userLabel.Text = "@" .. p.Name
                    userLabel.TextXAlignment = Enum.TextXAlignment.Left
                    userLabel.Parent = row
                    local cloneBtn = Instance.new("TextButton")
                    cloneBtn.Size = UDim2.new(0.3, 0, 0, 28)
                    cloneBtn.Position = UDim2.new(1, -6, 0.5, -14)
                    cloneBtn.AnchorPoint = Vector2.new(1, 0.5)
                    cloneBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    cloneBtn.Text = "Clone"
                    cloneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    cloneBtn.Font = Enum.Font.GothamBold
                    cloneBtn.TextSize = 11
                    cloneBtn.Parent = row
                    Instance.new("UICorner", cloneBtn).CornerRadius = UDim.new(0, 6)
                    cloneBtn.MouseButton1Click:Connect(function()
                        cloneAvatar(p)
                    end)
                end
            end
        end
    end
    populate()
    searchBox:GetPropertyChangedSignal("Text"):Connect(populate)
    local conn1 = game.Players.PlayerAdded:Connect(populate)
    local conn2 = game.Players.PlayerRemoving:Connect(populate)
    cloneGui.Destroying:Connect(function()
        conn1:Disconnect()
        conn2:Disconnect()
    end)
end
function safeTeleportToPlayer(targetPlayer)
    if not targetPlayer then return end
    local char = Player.Character
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
    local targetCFrame = targetHrp.CFrame * CFrame.new(0, 3, 0)
    if tweenTpEnabled then
        if typeof(safeTeleportToCFrame) == "function" then
            safeTeleportToCFrame(targetCFrame)
            return
        end
    end
    local wasFlyV1Active = getgenv().tpwalking
    if wasFlyV1Active then
        getgenv().tpwalking = false
        task.wait(0.1)
    end
    local startPos = hrp.Position
    local targetPos = targetHrp.Position
    local distance = (targetPos - startPos).Magnitude
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
    pcall(function()
        Player:RequestStreamAroundAsync(targetPos)
    end)
    task.wait(0.3)
    hrp.Anchored = previousAnchored
    if wasFlyV1Active then
        task.wait(0.1)
        getgenv().tpwalking = true
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Teleport Sukses",
            Text = "Teleport ke " .. targetPlayer.DisplayName .. " selesai.",
            Duration = 3
        })
    end)
end
local headsitActive = false
local headsitConn = nil
local headsitTarget = nil
local followActive = false
local followConn = nil
local followTarget = nil
local plistSendPartTarget = nil
local plistSendPartLoopThread = nil
local function stopHeadsit()
    headsitActive = false
    headsitTarget = nil
    if headsitConn then
        headsitConn:Disconnect()
        headsitConn = nil
    end
    local myChar = game.Players.LocalPlayer.Character
    local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local hrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
    if hum then hum.Sit = false end
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.CFrame = hrp.CFrame * CFrame.new(0, 3, -1)
    end
end
local function startHeadsit(targetPlayer)
    stopHeadsit()
    local myChar = game.Players.LocalPlayer.Character
    local hum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local hrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
    if not hum or not hrp or not targetPlayer then return end
    headsitActive = true
    headsitTarget = targetPlayer
    hum.Sit = true
    headsitConn = RunService.Heartbeat:Connect(function()
        if not headsitActive then return end
        if not targetPlayer or not targetPlayer.Parent then
            stopHeadsit()
            return
        end
        local tChar = targetPlayer.Character
        local tHrp = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso"))
        if tHrp then
            hum.Sit = true
            hrp.CFrame = tHrp.CFrame * CFrame.Angles(0, 0, 0) * CFrame.new(0, 1.6, 0.4)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end
local function stopFollow()
    followActive = false
    followTarget = nil
    if followConn then
        followConn:Disconnect()
        followConn = nil
    end
end

local function stopSyncDance()
    if syncDanceLoop then task.cancel(syncDanceLoop) syncDanceLoop = nil end
    syncDanceTarget = nil
    for _, t in ipairs(myPlayingTracks) do pcall(function() t:Stop() end) end
    table.clear(myPlayingTracks)
end

local function startSyncDance(targetPlayer)
    stopSyncDance()
    if not targetPlayer or not targetPlayer.Character then return end
    syncDanceTarget = targetPlayer
    local lastAnimId = nil
    
    syncDanceLoop = task.spawn(function()
        while syncDanceTarget and syncDanceTarget.Character and syncDanceTarget.Character.Parent do
            local hum = syncDanceTarget.Character:FindFirstChildOfClass("Humanoid")
            local myChar = Player.Character
            local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
            if hum and myHum then
                local playing = hum:GetPlayingAnimationTracks()
                local foundEmote = nil
                for _, track in ipairs(playing) do
                    if track.Weight > 0.1 and (tostring(track.Priority) == "Enum.AnimationPriority.Action" or tostring(track.Priority) == "Enum.AnimationPriority.Action4" or tostring(track.Priority) == "Enum.AnimationPriority.Action3" or tostring(track.Priority) == "Enum.AnimationPriority.Action2") then
                        foundEmote = track
                        break
                    end
                end
                
                if foundEmote then
                    local id = ""
                    if typeof(foundEmote.Animation) == "Instance" and foundEmote.Animation:IsA("Animation") then
                        id = foundEmote.Animation.AnimationId
                    end
                    if id ~= "" and id ~= lastAnimId then
                        for _, t in ipairs(myPlayingTracks) do pcall(function() t:Stop() end) end
                        table.clear(myPlayingTracks)
                        
                        lastAnimId = id
                        local anim = Instance.new("Animation")
                        anim.AnimationId = lastAnimId
                        local newTrack = myHum:LoadAnimation(anim)
                        newTrack:Play()
                        pcall(function() newTrack.TimePosition = foundEmote.TimePosition end)
                        pcall(function() newTrack.Speed = foundEmote.Speed end)
                        table.insert(myPlayingTracks, newTrack)
                    elseif id ~= "" and id == lastAnimId then
                        for _, t in ipairs(myPlayingTracks) do
                            pcall(function() t.Speed = foundEmote.Speed end)
                        end
                    end
                else
                    if lastAnimId then
                        for _, t in ipairs(myPlayingTracks) do pcall(function() t:Stop() end) end
                        table.clear(myPlayingTracks)
                        lastAnimId = nil
                    end
                end
            end
            task.wait(0.2)
        end
        stopSyncDance()
    end)
end

local function startFollow(targetPlayer)
    stopFollow()
    local myChar = game.Players.LocalPlayer.Character
    local hrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
    if not hrp or not targetPlayer then return end
    followActive = true
    followTarget = targetPlayer
    followConn = RunService.Heartbeat:Connect(function()
        if not followActive then return end
        if not targetPlayer or not targetPlayer.Parent then
            stopFollow()
            return
        end
        local tChar = targetPlayer.Character
        local tHrp = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso"))
        if tHrp then
            hrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 3)
        end
    end)
end
local function stopPlistSendPart()
    if plistSendPartTarget then
        plistSendPartTarget = nil
        if plistSendPartDescendantConn then
            pcall(function() plistSendPartDescendantConn:Disconnect() end)
            plistSendPartDescendantConn = nil
        end
        if not blackHoleActive then
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local torq = v:FindFirstChild("BringTorque")
                    local align = v:FindFirstChild("BringAlign")
                    local att = v:FindFirstChild("BringAttachment")
                    if torq or align or att then
                        pcall(function()
                            if torq then torq:Destroy() end
                            if align then align:Destroy() end
                            if att then att:Destroy() end
                            v:SetAttribute("WasBrought", true)
                            v.Anchored = true
                        end)
                    end
                end
            end
            DisableNetwork()
        else
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local torq = v:FindFirstChild("BringTorque")
                    local align = v:FindFirstChild("BringAlign")
                    if torq or align then
                        v.Anchored = false
                    end
                end
            end
        end
    end
end
local function startPlistSendPart(targetPlayer)
    stopPlistSendPart()
    plistSendPartTarget = targetPlayer
    EnableNetwork()
    OneTimeUnanchor()
    for _, v in ipairs(GetAllPartsRecursive(Workspace)) do
        if v:GetAttribute("WasBrought") then
            v.Anchored = false
        end
        ForcePart(v)
    end
    if plistSendPartDescendantConn then plistSendPartDescendantConn:Disconnect() end
    plistSendPartDescendantConn = Workspace.DescendantAdded:Connect(function(v)
        if plistSendPartTarget and v:IsA("BasePart") then
            if v:GetAttribute("WasBrought") then
                v.Anchored = false
            end
            ForcePart(v)
        end
    end)
    task.delay(3, function()
        if plistSendPartTarget == targetPlayer then
            stopPlistSendPart()
            refreshPlayerList()
        end
    end)
end
function createPlayerRow(targetPlayer, index)
    local isExpanded = (expandedPlayerUserId == targetPlayer.UserId)
    local row = Instance.new("Frame")
    row.Name = "PlayerItem"
    row.Size = isExpanded and UDim2.new(1, -8, 0, 120) or UDim2.new(1, -8, 0, 50)
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
    local avatar = Instance.new("ImageButton")
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
    avatar.MouseButton1Click:Connect(function()
        cloneAvatar(targetPlayer)
    end)
    task.spawn(function()
        local img = getPlayerThumbnail(targetPlayer.UserId)
        if avatar and avatar.Parent then
            avatar.Image = img
        end
    end)
    local info = Instance.new("Frame")
    info.Name = "Info"
    info.Size = UDim2.new(1, -210, 0, 42)
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
    local prefix = "⚫ "
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        local lpPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
        local tHrp = targetPlayer.Character and (targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("Torso"))
        if tHrp then
            if lpPos then
                local dist = math.floor((lpPos - tHrp.Position).Magnitude)
                prefix = "🟢 [" .. dist .. "m] "
            else
                prefix = "🟢 "
            end
        end
    end)
    dispLabel.Text = prefix .. targetPlayer.DisplayName
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
    local btns = Instance.new("Frame")
    btns.Name = "Buttons"
    btns.Size = UDim2.new(0, 148, 0, 26)
    btns.Position = UDim2.new(1, -154, 0, 12)
    btns.BackgroundTransparency = 1
    btns.Parent = row
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Parent = btns
    local function makeActBtn(text, color, strokeColor, order, sizeX)
        if color == Color3.fromRGB(15, 15, 15) then color = Color3.fromRGB(25, 25, 25) end
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
        s.Color = strokeColor or Color3.fromRGB(40, 40, 45)
        s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = btn
        local hoverColor = Color3.new(math.min(color.R + 0.05, 1), math.min(color.G + 0.05, 1), math.min(color.B + 0.05, 1))
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        end)
        return btn
    end
    local cloneBtn = makeActBtn("Clone", Color3.fromRGB(15, 15, 15), Color3.fromRGB(255, 50, 50), 0.5, 36)
    cloneBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    cloneBtn.MouseButton1Click:Connect(function()
        cloneAvatar(targetPlayer)
    end)
    local tpBtn = makeActBtn("TP", Color3.fromRGB(15, 15, 15), Color3.fromRGB(255, 50, 50), 1, 26)
    tpBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    tpBtn.MouseButton1Click:Connect(function()
        safeTeleportToPlayer(targetPlayer)
    end)
    local isViewing = (currentSpectateTarget == targetPlayer)
    local viewBtnText = isViewing and "Stop" or "View"
    local viewBtnColor = isViewing and Color3.fromRGB(150, 50, 50) or Color3.fromRGB(15, 15, 15)
    local viewBtnStroke = isViewing and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 50, 50)
    local viewBtn = makeActBtn(viewBtnText, viewBtnColor, viewBtnStroke, 2, 34)
    if isViewing then
        viewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        viewBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
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
    local isFriend = false
    pcall(function()
        isFriend = game.Players.LocalPlayer:IsFriendsWith(targetPlayer.UserId)
    end)
    local addBtn
    if isFriend then
        addBtn = makeActBtn("Teman", Color3.fromRGB(15, 15, 15), Color3.fromRGB(40, 40, 45), 3, 40)
        addBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
        addBtn.Active = false
    else
        addBtn = makeActBtn("Tambah", Color3.fromRGB(15, 15, 15), Color3.fromRGB(255, 50, 50), 3, 40)
        addBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        addBtn.MouseButton1Click:Connect(function()
            pcall(function()
                game:GetService("StarterGui"):SetCore("PromptSendFriendRequest", targetPlayer)
            end)
            addBtn.Text = "Proses"
            addBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            local stroke = addBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(120, 120, 120) end
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
                        local strokeInner = addBtn:FindFirstChildOfClass("UIStroke")
                        if strokeInner then strokeInner.Color = Color3.fromRGB(40, 40, 45) end
                    else
                        addBtn.Text = "Tambah"
                        addBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                        local strokeInner = addBtn:FindFirstChildOfClass("UIStroke")
                        if strokeInner then strokeInner.Color = Color3.fromRGB(255, 50, 50) end
                    end
                end
            end)
        end)
    end
    local expandedFrame = Instance.new("Frame")
    expandedFrame.Name = "ExpandedArea"
    expandedFrame.Size = UDim2.new(1, -16, 0, 68)
    expandedFrame.Position = UDim2.new(0, 8, 0, 50)
    expandedFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    expandedFrame.BorderSizePixel = 0
    expandedFrame.Visible = isExpanded
    expandedFrame.Parent = row
    local exCorner = Instance.new("UICorner")
    exCorner.CornerRadius = UDim.new(0, 6)
    exCorner.Parent = expandedFrame
    local exStroke = Instance.new("UIStroke")
    exStroke.Color = Color3.fromRGB(30, 30, 35)
    exStroke.Thickness = 1
    exStroke.Parent = expandedFrame
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
    local exBtns = Instance.new("Frame")
    exBtns.Name = "ExtraButtons"
    exBtns.Size = UDim2.new(1, -114, 0, 26)
    exBtns.Position = UDim2.new(0, 108, 0, 6)
    exBtns.BackgroundTransparency = 1
    exBtns.Parent = expandedFrame
    local exListLayout = Instance.new("UIListLayout")
    exListLayout.FillDirection = Enum.FillDirection.Horizontal
    exListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    exListLayout.Padding = UDim.new(0, 4)
    exListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    exListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    exListLayout.Parent = exBtns
    local function makeExActBtn(text, color, strokeColor, order, sizeX)
        if color == Color3.fromRGB(15, 15, 15) then color = Color3.fromRGB(25, 25, 25) end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.333, -3, 0, 26)
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
        s.Color = strokeColor or Color3.fromRGB(40, 40, 45)
        s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = btn
        local hoverColor = Color3.new(math.min(color.R + 0.05, 1), math.min(color.G + 0.05, 1), math.min(color.B + 0.05, 1))
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        end)
        return btn
    end
    local exBtns2 = Instance.new("Frame")
    exBtns2.Name = "ExtraButtons2"
    exBtns2.Size = UDim2.new(1, -114, 0, 26)
    exBtns2.Position = UDim2.new(0, 108, 0, 36)
    exBtns2.BackgroundTransparency = 1
    exBtns2.Parent = expandedFrame
    local exListLayout2 = Instance.new("UIListLayout")
    exListLayout2.FillDirection = Enum.FillDirection.Horizontal
    exListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    exListLayout2.Padding = UDim.new(0, 4)
    exListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
    exListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Left
    exListLayout2.Parent = exBtns2
    local function makeExActBtn2(text, color, strokeColor, order, sizeX)
        if color == Color3.fromRGB(15, 15, 15) then color = Color3.fromRGB(25, 25, 25) end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.166, -4, 0, 26)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.TextWrapped = true
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.LayoutOrder = order
        btn.Parent = exBtns2
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 4)
        c.Parent = btn
        local s = Instance.new("UIStroke")
        s.Color = strokeColor or Color3.fromRGB(40, 40, 45)
        s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = btn
        local hoverColor = Color3.new(math.min(color.R + 0.05, 1), math.min(color.G + 0.05, 1), math.min(color.B + 0.05, 1))
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
        end)
        return btn
    end
    local copyBtn = makeExActBtn("Salin ID", Color3.fromRGB(40, 40, 45), Color3.fromRGB(60, 60, 65), 1, 50)
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(tostring(targetPlayer.UserId))
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = tr("Salin ID") or "Salin ID",
                    Text = "User ID player berhasil disalin!",
                    Duration = 2
                })
            end)
        end
    end)
    local copyUserBtn = makeExActBtn("Salin User", Color3.fromRGB(40, 40, 45), Color3.fromRGB(60, 60, 65), 2, 60)
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
    local COREGUI = game:GetService("CoreGui")
    local espBtn = makeExActBtn("ESP", Color3.fromRGB(0, 100, 150), Color3.fromRGB(0, 160, 220), 3, 36)
    if COREGUI:FindFirstChild(targetPlayer.Name .. "_ESP") then
        espBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        local stroke = espBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(255, 255, 255) end
    end
    espBtn.MouseButton1Click:Connect(function()
        if COREGUI:FindFirstChild(targetPlayer.Name .. "_ESP") then
            destroyPlayerESP(targetPlayer.Name)
            espBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
            local stroke = espBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(0, 160, 220) end
        else
            CreateESP(targetPlayer)
            espBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            local stroke = espBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(255, 255, 255) end
        end
    end)
    local flingActive = false
    local flingBtn = makeExActBtn2("Fling", Color3.fromRGB(150, 50, 50), Color3.fromRGB(200, 100, 100), 0, 42)
    flingBtn.MouseButton1Click:Connect(function()
        local lplr = game.Players.LocalPlayer
        local char = lplr.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end
        flingActive = not flingActive
        if flingActive then
            flingBtn.Text = "Stop"
            flingBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            local stroke = flingBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(255, 150, 50) end
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
                local flingPart = Instance.new("Part")
                flingPart.Anchored = false
                flingPart.CanCollide = false
                flingPart.Transparency = 1
                flingPart.Size = Vector3.new(1, 1, 1)
                flingPart.CFrame = hrp.CFrame
                flingPart.Parent = workspace
                local flingWeld = Instance.new("WeldConstraint")
                flingWeld.Part0 = flingPart
                flingWeld.Part1 = hrp
                flingWeld.Parent = flingPart
                local BV = Instance.new("BodyVelocity")
                BV.Parent = flingPart
                BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                local myHum = char:FindFirstChildOfClass("Humanoid")
                if myHum then
                    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                end
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
                        flingPart.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
                        flingPart.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
                        myHrp.CFrame = tHrp.CFrame * CFrame.new(math.random(-1,1)*0.4, 0, math.random(-1,1)*0.4)
                    else
                        flingPart.AssemblyLinearVelocity = Vector3.zero
                        flingPart.AssemblyAngularVelocity = Vector3.zero
                    end
                end
                flingActive = false
                workspace.Gravity = oldGravity
                if myHum then
                    myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                end
                pcall(function() flingPart:Destroy() end)
                if flingBtn and flingBtn.Parent then
                    flingBtn.Text = "Fling"
                    flingBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
                    local stroke = flingBtn:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = Color3.fromRGB(200, 100, 100) end
                end
                local myChar = lplr.Character
                local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
                if myHrp and originalCFrame then
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
            flingBtn.Text = "Fling"
            flingBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
            local stroke = flingBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(200, 100, 100) end
        end
    end)
    local instFlingBtn = makeExActBtn2("IFling", Color3.fromRGB(180, 60, 0), Color3.fromRGB(255, 120, 50), 1, 45)
    instFlingBtn.MouseButton1Click:Connect(function()
        executeInstantFling(targetPlayer)
    end)
    local isHeadsit = (headsitTarget == targetPlayer)
    local headsitBtnText = isHeadsit and "Stop" or tr("Headsit")
    local headsitBtnColor = isHeadsit and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(0, 100, 150)
    local headsitBtnStroke = isHeadsit and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(0, 160, 220)
    local headsitBtn = makeExActBtn2(headsitBtnText, headsitBtnColor, headsitBtnStroke, 2, 50)
    headsitBtn.MouseButton1Click:Connect(function()
        if headsitTarget == targetPlayer then
            stopHeadsit()
            headsitBtn.Text = tr("Headsit")
            headsitBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
            local stroke = headsitBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(0, 160, 220) end
        else
            startHeadsit(targetPlayer)
            headsitBtn.Text = "Stop"
            headsitBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            local stroke = headsitBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(255, 150, 50) end
        end
    end)
    local isFollow = (followTarget == targetPlayer)
    local followBtnText = isFollow and "Stop" or tr("FollowBtn")
    local followBtnColor = isFollow and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(0, 100, 150)
    local followBtnStroke = isFollow and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(0, 160, 220)
    local followBtn = makeExActBtn2(followBtnText, followBtnColor, followBtnStroke, 3, 45)
    followBtn.MouseButton1Click:Connect(function()
        if followTarget == targetPlayer then
            stopFollow()
            followBtn.Text = tr("FollowBtn")
            followBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
            local stroke = followBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(0, 160, 220) end
        else
            startFollow(targetPlayer)
            followBtn.Text = "Stop"
            followBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            local stroke = followBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(255, 150, 50) end
        end
    end)
    local isSending = (plistSendPartTarget == targetPlayer)
    local sendBtnText = isSending and tr("SendingOnBtn") or tr("SendPartBtn")
    local sendBtnColor = isSending and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(0, 100, 150)
    local sendBtnStroke = isSending and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(0, 160, 220)
    local sendBtn = makeExActBtn2(sendBtnText, sendBtnColor, sendBtnStroke, 4, 82)
    sendBtn.MouseButton1Click:Connect(function()
        if plistSendPartTarget == targetPlayer then
            stopPlistSendPart()
            sendBtn.Text = tr("SendPartBtn")
            sendBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
            local stroke = sendBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(0, 160, 220) end
        else
            startPlistSendPart(targetPlayer)
            sendBtn.Text = tr("SendingOnBtn")
            sendBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            local stroke = sendBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(255, 150, 50) end
        end
    end)
    local isSyncing = (syncDanceTarget == targetPlayer)
    local syncBtnText = isSyncing and "Stop" or tr("SyncBtn")
    local syncBtnColor = isSyncing and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(0, 100, 150)
    local syncBtnStroke = isSyncing and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(0, 160, 220)
    local syncBtn = makeExActBtn2(syncBtnText, syncBtnColor, syncBtnStroke, 5, 45)
    syncBtn.MouseButton1Click:Connect(function()
        if syncDanceTarget == targetPlayer then
            stopSyncDance()
            syncBtn.Text = tr("SyncBtn")
            syncBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 150)
            local stroke = syncBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(0, 160, 220) end
        else
            startSyncDance(targetPlayer)
            syncBtn.Text = "Stop"
            syncBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            local stroke = syncBtn:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = Color3.fromRGB(255, 150, 50) end
        end
    end)
    local toggleExpand = function()
        if expandedPlayerUserId == targetPlayer.UserId then
            expandedPlayerUserId = nil
        else
            expandedPlayerUserId = targetPlayer.UserId
        end
        refreshPlayerList()
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
    local lp = game:GetService("Players").LocalPlayer
    local lpPos = nil
    if lp and lp.Character then
        local lpHrp = lp.Character:FindFirstChild("HumanoidRootPart") or lp.Character:FindFirstChild("Torso")
        if lpHrp then lpPos = lpHrp.Position end
    end
    table.sort(sortedPlayers, function(a, b)
        local distA, distB = math.huge, math.huge
        if lpPos then
            if a.Character then
                local aHrp = a.Character:FindFirstChild("HumanoidRootPart") or a.Character:FindFirstChild("Torso")
                if aHrp then distA = (aHrp.Position - lpPos).Magnitude end
            end
            if b.Character then
                local bHrp = b.Character:FindFirstChild("HumanoidRootPart") or b.Character:FindFirstChild("Torso")
                if bHrp then distB = (bHrp.Position - lpPos).Magnitude end
            end
        end
        local aIsDetected = (distA ~= math.huge)
        local bIsDetected = (distB ~= math.huge)
        if aIsDetected ~= bIsDetected then
            return aIsDetected
        end
        if aIsDetected and bIsDetected then
            if math.abs(distA - distB) > 0.1 then
                return distA < distB
            end
        end
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
function createPlayerListWindow()
    if PlayerListFrame then return end
    local sgui = ScreenGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "PlayerListFrame"
    mainFrame.Size = UDim2.new(0, 450, 0, 360)
    mainFrame.Position = UDim2.new(0.5, 120, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    PlayerListFrame = mainFrame
    mainFrame.MouseEnter:Connect(function()
        mouseInPlayerList = true
        pcall(function() updateExternalCursorVisibility() end)
    end)
    mainFrame.MouseLeave:Connect(function()
        mouseInPlayerList = false
        pcall(function() updateExternalCursorVisibility() end)
    end)
    local modal = Instance.new("TextButton")
    modal.Size = UDim2.new(0, 0, 0, 0)
    modal.BackgroundTransparency = 1
    modal.Text = ""
    modal.Modal = true
    modal.Parent = mainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.Parent = mainFrame
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 10)
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topCover.BorderSizePixel = 0
    topCover.Parent = topBar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Player List"
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1.5
    closeStroke.Parent = closeBtn
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -54, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
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
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1
    minStroke.Parent = minBtn
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 22, 0, 22)
    refreshBtn.Position = UDim2.new(1, -80, 0.5, -11)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    refreshBtn.BackgroundTransparency = 0.1
    refreshBtn.Text = "R"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 13
    refreshBtn.Parent = topBar
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 6)
    refreshCorner.Parent = refreshBtn
    local refreshStroke = Instance.new("UIStroke")
    refreshStroke.Color = Color3.fromRGB(255, 255, 255)
    refreshStroke.Thickness = 1
    refreshStroke.Parent = refreshBtn
    refreshBtn.MouseButton1Click:Connect(function()
        refreshPlayerList()
    end)
    local isMinimized = false
    local normalSize = UDim2.new(0, 450, 0, 360)
    local minimizedSize = UDim2.new(0, 450, 0, 30)
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
    searchFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    searchFrame.BackgroundTransparency = 0.2
    searchFrame.Parent = mainFrame
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame
    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = Color3.fromRGB(255, 255, 255)
    searchStroke.Thickness = 1.5
    searchStroke.Parent = searchFrame
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.Position = UDim2.new(0, 10, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.GothamBold
    searchBox.Text = ""
    addTranslatable(searchBox, "SearchPlayers", "PlaceholderText")
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
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scroll.Parent = mainFrame
    PlayerListScroll = scroll
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll
    makeSmoothDraggable(mainFrame, topBar)
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
FriendListFrame = nil
FriendListScroll = nil
refreshFriendList = nil
activeJoinConn = nil
function createFriendListWindow()
    if FriendListFrame then return end
    local sgui = ScreenGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "FriendListFrame"
    mainFrame.Size = UDim2.new(0, 340, 0, 360)
    mainFrame.Position = UDim2.new(0.5, 120, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    FriendListFrame = mainFrame
    local modal = Instance.new("TextButton")
    modal.Size = UDim2.new(0, 0, 0, 0)
    modal.BackgroundTransparency = 1
    modal.Text = ""
    modal.Modal = true
    modal.Parent = mainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.Parent = mainFrame
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 10)
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topCover.BorderSizePixel = 0
    topCover.Parent = topBar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Friend List"
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1.5
    closeStroke.Parent = closeBtn
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -54, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
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
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1
    minStroke.Parent = minBtn
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(0, 22, 0, 22)
    refreshBtn.Position = UDim2.new(1, -80, 0.5, -11)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    refreshBtn.BackgroundTransparency = 0.1
    refreshBtn.Text = "R"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 12
    refreshBtn.Parent = topBar
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 6)
    refreshCorner.Parent = refreshBtn
    local inviteBtn = Instance.new("TextButton")
    inviteBtn.Size = UDim2.new(0, 50, 0, 22)
    inviteBtn.Position = UDim2.new(1, -135, 0.5, -11)
    inviteBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    inviteBtn.Text = "Invite"
    inviteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    inviteBtn.Font = Enum.Font.GothamBold
    inviteBtn.TextSize = 11
    inviteBtn.Parent = topBar
    local inviteCorner = Instance.new("UICorner")
    inviteCorner.CornerRadius = UDim.new(0, 6)
    inviteCorner.Parent = inviteBtn
    inviteBtn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("SocialService"):PromptGameInvite(game.Players.LocalPlayer)
        end)
    end)
    local isMinimized = false
    local normalSize = UDim2.new(0, 340, 0, 360)
    local minimizedSize = UDim2.new(0, 340, 0, 30)
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            minBtn.Text = "+"
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize})
            tween:Play()
            scroll.Visible = false
        else
            minBtn.Text = "-"
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize})
            tween:Play()
            task.delay(0.1, function()
                if not isMinimized then
                    scroll.Visible = true
                    if refreshFriendList then
                        refreshFriendList()
                    end
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
            scroll.Visible = true
        end
    end)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -45)
    scroll.Position = UDim2.new(0, 10, 0, 38)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scroll.Parent = mainFrame
    FriendListScroll = scroll
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
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
    refreshFriendList = function()
        if not FriendListScroll then return end
        for _, child in ipairs(FriendListScroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        local success, result = pcall(function()
            return Player:GetFriendsOnline(100)
        end)
        if not success or type(result) ~= "table" then
            local errLabel = Instance.new("TextLabel")
            errLabel.Size = UDim2.new(1, 0, 0, 40)
            errLabel.BackgroundTransparency = 1
            errLabel.Text = "Gagal mengambil daftar teman online."
            errLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
            errLabel.Font = Enum.Font.GothamBold
            errLabel.TextSize = 12
            errLabel.Parent = FriendListScroll
            return
        end
        if #result == 0 then
            local emptyLabel = Instance.new("TextLabel")
            emptyLabel.Size = UDim2.new(1, 0, 0, 40)
            emptyLabel.BackgroundTransparency = 1
            emptyLabel.Text = "Tidak ada teman yang online."
            emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            emptyLabel.Font = Enum.Font.GothamBold
            emptyLabel.TextSize = 12
            emptyLabel.Parent = FriendListScroll
            return
        end
        table.sort(result, function(a, b)
            return tostring(a.DisplayName):lower() < tostring(b.DisplayName):lower()
        end)
        for idx, friend in ipairs(result) do
            local row = Instance.new("Frame")
            row.Name = "FriendRow"
            row.Size = UDim2.new(1, -5, 0, 48)
            row.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
            row.BackgroundTransparency = 0.2
            row.LayoutOrder = idx
            row.Parent = FriendListScroll
            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 8)
            rowCorner.Parent = row
            local avatar = Instance.new("ImageLabel")
            avatar.Size = UDim2.new(0, 36, 0, 36)
            avatar.Position = UDim2.new(0, 6, 0.5, -18)
            avatar.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
            avatar.BorderSizePixel = 0
            avatar.Image = "rbxasset://textures/ui/avatar_placeholder.png"
            avatar.Parent = row
            local avCorner = Instance.new("UICorner")
            avCorner.CornerRadius = UDim.new(0, 18)
            avCorner.Parent = avatar
            task.spawn(function()
                local thumbSuccess, thumbResult = pcall(function()
                    return game:GetService("Players"):GetUserThumbnailAsync(friend.VisitorId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
                end)
                if thumbSuccess and thumbResult then
                    avatar.Image = thumbResult
                end
            end)
            local infoFrame = Instance.new("Frame")
            infoFrame.Size = UDim2.new(1, -110, 1, 0)
            infoFrame.Position = UDim2.new(0, 48, 0, 0)
            infoFrame.BackgroundTransparency = 1
            infoFrame.Parent = row
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.Position = UDim2.new(0, 0, 0, 4)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = tostring(friend.DisplayName) .. " (@" .. tostring(friend.UserName) .. ")"
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 11
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = infoFrame
            local locLabel = Instance.new("TextLabel")
            locLabel.Size = UDim2.new(1, 0, 0.5, -4)
            locLabel.Position = UDim2.new(0, 0, 0.5, 0)
            locLabel.BackgroundTransparency = 1
            locLabel.Text = tostring(friend.LastLocation or "Online")
            locLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            locLabel.Font = Enum.Font.Gotham
            locLabel.TextSize = 9
            locLabel.TextXAlignment = Enum.TextXAlignment.Left
            locLabel.ClipsDescendants = true
            locLabel.Parent = infoFrame
            local isPlaying = friend.PlaceId and friend.PlaceId > 0 and friend.LastLocation ~= "Website" and friend.LastLocation ~= "Studio" and friend.LastLocation ~= "Offline"
            if isPlaying then
                local joinBtn = Instance.new("TextButton")
                joinBtn.Size = UDim2.new(0, 65, 0, 28)
                joinBtn.Position = UDim2.new(1, -71, 0.5, -14)
                joinBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                joinBtn.Text = "Copy Link"
                joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                joinBtn.Font = Enum.Font.GothamBold
                joinBtn.TextSize = 10
                joinBtn.Parent = row
                local joinCorner = Instance.new("UICorner")
                joinCorner.CornerRadius = UDim.new(0, 6)
                joinCorner.Parent = joinBtn
                joinBtn.MouseEnter:Connect(function()
                    TweenService:Create(joinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                end)
                joinBtn.MouseLeave:Connect(function()
                    TweenService:Create(joinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                end)
                joinBtn.MouseButton1Click:Connect(function()
                    local fPlaceId = tostring(friend.PlaceId)
                    local fJobId   = (friend.GameId and tostring(friend.GameId) ~= ""
                                      and tostring(friend.GameId) ~= "0")
                                     and tostring(friend.GameId) or nil
                    local joinUrl
                    if fJobId then
                        joinUrl = "https://www.roblox.com/games/" .. fPlaceId .. "?gameInstanceId=" .. fJobId
                    else
                        joinUrl = "https://www.roblox.com/games/" .. fPlaceId
                    end
                    if setclipboard then
                        pcall(function() setclipboard(joinUrl) end)
                        joinBtn.Text = "Link ✓"
                        joinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                        task.delay(2.5, function()
                            if joinBtn and joinBtn.Parent then
                                joinBtn.Text  = "Copy Link"
                                joinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                            end
                        end)
                    else
                        joinBtn.Text = "No CB"
                        joinBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                        task.delay(2, function()
                            if joinBtn and joinBtn.Parent then
                                joinBtn.Text  = "Copy Link"
                                joinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                            end
                        end)
                    end
                end)
            end
        end
    end
    refreshBtn.MouseButton1Click:Connect(refreshFriendList)
    refreshFriendList()
end
toggleFriendListWindow = function()
    if not FriendListFrame then
        createFriendListWindow()
    end
FriendListFrame.Visible = not FriendListFrame.Visible
    if FriendListFrame.Visible and refreshFriendList then
        refreshFriendList()
    end
end
WaypointListFrame = nil
WaypointListScroll = nil
refreshWaypointList = nil
toggleWaypointListWindow = nil
tweenTpEnabled = false
function safeTeleportToCFrame(cf)
    local lplr = game:GetService("Players").LocalPlayer
    local char = lplr.Character or lplr.CharacterAdded:Wait()
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
    if not root then return end
    if flying then
        frozenPos = cf.Position
    end
    local targetPos = cf.Position
    local startPos = root.Position
    local dist = (targetPos - startPos).Magnitude
    if tweenTpEnabled then
        local speed = 150
        local duration = dist / speed
        root.Anchored = true
        pcall(function()
            lplr:RequestStreamAroundAsync(targetPos)
        end)
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(root, tweenInfo, {CFrame = cf})
        tween:Play()
        tween.Completed:Connect(function()
            pcall(function()
                lplr:RequestStreamAroundAsync(targetPos)
            end)
            task.wait(0.2)
            root.Anchored = false
        end)
    else
        root.Anchored = true
        root.CFrame = cf
        pcall(function()
            lplr:RequestStreamAroundAsync(targetPos)
        end)
        task.spawn(function()
            local startTime = tick()
            local floorLoaded = false
            while tick() - startTime < 1.5 do
                local ray = Ray.new(root.Position, Vector3.new(0, -10, 0))
                local hit = workspace:FindPartOnRayWithIgnoreList(ray, {char})
                if hit then
                    floorLoaded = true
                    break
                end
                task.wait(0.02)
            end
            if root and root.Parent then
                root.Anchored = false
            end
        end)
    end
end
function createWaypointListWindow()
    if WaypointListFrame then return end
    local sgui = ScreenGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "WaypointListFrame"
    mainFrame.Size = UDim2.new(0, 340, 0, 360)
    mainFrame.Position = UDim2.new(0.5, -470, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    WaypointListFrame = mainFrame
    local modal = Instance.new("TextButton")
    modal.Size = UDim2.new(0, 0, 0, 0)
    modal.BackgroundTransparency = 1
    modal.Text = ""
    modal.Modal = true
    modal.Parent = mainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.Parent = mainFrame
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 10)
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topCover.BorderSizePixel = 0
    topCover.Parent = topBar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Waypoints"
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1.5
    closeStroke.Parent = closeBtn
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -54, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
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
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1.5
    minStroke.Parent = minBtn
    local isMinimized = false
    local normalSize = UDim2.new(0, 340, 0, 360)
    local minimizedSize = UDim2.new(0, 340, 0, 30)
    local saveFrame = Instance.new("Frame")
    saveFrame.Name = "SaveFrame"
    saveFrame.Size = UDim2.new(1, -20, 0, 32)
    saveFrame.Position = UDim2.new(0, 10, 0, 38)
    saveFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    saveFrame.BackgroundTransparency = 0.2
    saveFrame.Parent = mainFrame
    local saveCorner = Instance.new("UICorner")
    saveCorner.CornerRadius = UDim.new(0, 8)
    saveCorner.Parent = saveFrame
    local saveStroke = Instance.new("UIStroke")
    saveStroke.Color = Color3.fromRGB(255, 255, 255)
    saveStroke.Thickness = 1.5
    saveStroke.Parent = saveFrame
    local saveBox = Instance.new("TextBox")
    saveBox.Name = "SaveBox"
    saveBox.Size = UDim2.new(1, -75, 1, 0)
    saveBox.Position = UDim2.new(0, 10, 0, 0)
    saveBox.BackgroundTransparency = 1
    saveBox.Font = Enum.Font.GothamBold
    saveBox.Text = ""
    saveBox.PlaceholderText = "Nama Waypoint..."
    saveBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    saveBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveBox.TextSize = 14
    saveBox.TextXAlignment = Enum.TextXAlignment.Left
    saveBox.ClearTextOnFocus = false
    saveBox.Parent = saveFrame
    local addBtn = Instance.new("TextButton")
    addBtn.Size = UDim2.new(0, 55, 0, 24)
    addBtn.Position = UDim2.new(1, -60, 0.5, -12)
    addBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    addBtn.Text = "Save"
    addBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    addBtn.Font = Enum.Font.GothamBold
    addBtn.TextSize = 11
    addBtn.Parent = saveFrame
    local addCorner = Instance.new("UICorner")
    addCorner.CornerRadius = UDim.new(0, 6)
    addCorner.Parent = addBtn
    addBtn.MouseButton1Click:Connect(function()
        local name = saveBox.Text
        if name and name ~= "" then
            if typeof(saveCurrentPositionAsWaypoint) == "function" then
                saveCurrentPositionAsWaypoint(name)
            end
            saveBox.Text = ""
        end
    end)
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(1, -20, 0, 32)
    searchFrame.Position = UDim2.new(0, 10, 0, 74)
    searchFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    searchFrame.BackgroundTransparency = 0.2
    searchFrame.Parent = mainFrame
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.Position = UDim2.new(0, 10, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.GothamBold
    searchBox.Text = ""
    addTranslatable(searchBox, "SearchWP", "PlaceholderText")
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 14
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchFrame
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -145)
    scroll.Position = UDim2.new(0, 10, 0, 110)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scroll.Parent = mainFrame
    WaypointListScroll = scroll
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
    local coordsLabel = Instance.new("TextLabel")
    coordsLabel.Size = UDim2.new(1, -20, 0, 20)
    coordsLabel.Position = UDim2.new(0, 10, 1, -25)
    coordsLabel.BackgroundTransparency = 1
    coordsLabel.Font = Enum.Font.SourceSansSemibold
    coordsLabel.TextSize = 13
    coordsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
    coordsLabel.Text = "X: 0 | Y: 0 | Z: 0"
    coordsLabel.Parent = mainFrame
    RunService.RenderStepped:Connect(function()
        if mainFrame.Visible and not isMinimized then
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
            if root then
                local pos = root.Position
                coordsLabel.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
            else
                coordsLabel.Text = "X: -- | Y: -- | Z: --"
            end
        end
    end)
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            minBtn.Text = "+"
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize})
            tween:Play()
            saveFrame.Visible = false
            searchFrame.Visible = false
            scroll.Visible = false
            coordsLabel.Visible = false
        else
            minBtn.Text = "-"
            local tween = TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize})
            tween:Play()
            task.delay(0.1, function()
                if not isMinimized then
                    saveFrame.Visible = true
                    searchFrame.Visible = true
                    scroll.Visible = true
                    coordsLabel.Visible = true
                    if refreshWaypointList then
                        refreshWaypointList()
                    end
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
            saveFrame.Visible = true
            searchFrame.Visible = true
            scroll.Visible = true
            coordsLabel.Visible = true
        end
    end)
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
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if refreshWaypointList then
            refreshWaypointList()
        end
    end)
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
    refreshWaypointList = function()
        if not WaypointListScroll then return end
        for _, child in ipairs(WaypointListScroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        local query = string.lower(searchBox.Text)
        local wps = {}
        for name, comps in pairs(customWaypoints) do
            if query == "" or string.find(string.lower(name), query, 1, true) then
                table.insert(wps, {name = name, comps = comps})
            end
        end
        table.sort(wps, function(a, b)
            return naturalCompare(a.name, b.name)
        end)
        for idx, item in ipairs(wps) do
            local name = item.name
            local comps = item.comps
            local row = Instance.new("Frame")
            row.Name = "WaypointRow"
            row.Size = UDim2.new(1, -5, 0, 38)
            row.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            row.BackgroundTransparency = 0
            row.LayoutOrder = idx
            row.Parent = WaypointListScroll
            local rowCorner = Instance.new("UICorner")
            rowCorner.CornerRadius = UDim.new(0, 8)
            rowCorner.Parent = row
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -85, 1, 0)
            nameLabel.Position = UDim2.new(0, 8, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 11
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = row
            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0, 32, 0, 26)
            tpBtn.Position = UDim2.new(1, -68, 0.5, -13)
            tpBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            tpBtn.Text = "TP"
            tpBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
            tpBtn.Font = Enum.Font.GothamBold
            tpBtn.TextSize = 10
            tpBtn.Parent = row
            local tpCorner = Instance.new("UICorner")
            tpCorner.CornerRadius = UDim.new(0, 6)
            tpCorner.Parent = tpBtn
            tpBtn.MouseEnter:Connect(function()
                TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end)
            tpBtn.MouseLeave:Connect(function()
                TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            end)
            tpBtn.MouseButton1Click:Connect(function()
                local ok, cf = pcall(function() return CFrame.new(table.unpack(comps)) end)
                if ok and typeof(cf) == "CFrame" then
                    safeTeleportToCFrame(cf)
                end
            end)
            local delBtn = Instance.new("TextButton")
            delBtn.Size = UDim2.new(0, 26, 0, 26)
            delBtn.Position = UDim2.new(1, -32, 0.5, -13)
            delBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            delBtn.Text = "X"
            delBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
            delBtn.Font = Enum.Font.GothamBold
            delBtn.TextSize = 10
            delBtn.Parent = row
            local delCorner = Instance.new("UICorner")
            delCorner.CornerRadius = UDim.new(0, 6)
            delCorner.Parent = delBtn
            delBtn.MouseEnter:Connect(function()
                TweenService:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
            end)
            delBtn.MouseLeave:Connect(function()
                TweenService:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            end)
            delBtn.MouseButton1Click:Connect(function()
                customWaypoints[name] = nil
                saveCustomWaypoints()
                row:Destroy()
                if refreshWaypointList then
                    refreshWaypointList()
                end
                pcall(refreshCustomWaypointButtons)
            end)
        end
    end
end
toggleWaypointListWindow = function()
    if not WaypointListFrame then
        createWaypointListWindow()
    end
    WaypointListFrame.Visible = not WaypointListFrame.Visible
    if WaypointListFrame.Visible and refreshWaypointList then
        refreshWaypointList()
    end
end
ChatLogsFrame = nil
ChatLogsScroll = nil
ChatLogsSearchBox = nil
refreshChatLogsUI = nil
toggleChatLogsWindow = nil
_G.ChatLogsTable = _G.ChatLogsTable or {}
_G.ChatLogsCache = _G.ChatLogsCache or {}
local function findPlr(name)
    if not name then return nil end
    local Players = game:GetService("Players")
    local p = Players:FindFirstChild(name)
    if p then return p end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower or string.lower(player.DisplayName) == lower then
            return player
        end
    end
    return nil
end
local function logChatMessage(sender, msg, isWhisper)
    local plr = findPlr(sender)
    local username = plr and plr.Name or sender
    local now = tick()
    local cacheKey = string.lower(username) .. "_" .. msg
    local lastTime = _G.ChatLogsCache[cacheKey]
    if lastTime and (now - lastTime) < 0.5 then
        return
    end
    _G.ChatLogsCache[cacheKey] = now
    task.spawn(function()
        task.wait(5)
        if _G.ChatLogsCache[cacheKey] == now then
            _G.ChatLogsCache[cacheKey] = nil
        end
    end)
    local formattedSender = sender
    if plr then
        formattedSender = plr.DisplayName .. " (@" .. plr.Name .. ")"
    end
    if isWhisper then
        formattedSender = "[WHISPER] " .. formattedSender
    end
    table.insert(_G.ChatLogsTable, {
        Sender = formattedSender,
        RawSender = username,
        Message = msg,
        Time = os.date("%H:%M:%S"),
        IsWhisper = isWhisper
    })
    if #_G.ChatLogsTable > 250 then
        table.remove(_G.ChatLogsTable, 1)
    end
    if refreshChatLogsUI then
        refreshChatLogsUI()
    end
end
if _G.ChatLogsLegacyConnection then
    pcall(function() _G.ChatLogsLegacyConnection:Disconnect() end)
    _G.ChatLogsLegacyConnection = nil
end
if _G.ChatLogsModernConnection then
    pcall(function() _G.ChatLogsModernConnection:Disconnect() end)
    _G.ChatLogsModernConnection = nil
end
pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local chatEvents = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents", 5)
    local onMessage = chatEvents and chatEvents:WaitForChild("OnMessageDoneFiltering", 5)
    if onMessage and onMessage:IsA("RemoteEvent") then
        _G.ChatLogsLegacyConnection = onMessage.OnClientEvent:Connect(function(messageData)
            if messageData and messageData.FromSpeaker and messageData.Message then
                local isWhisper = false
                if messageData.OriginalChannel and (string.find(messageData.OriginalChannel, "To ") or string.find(messageData.OriginalChannel, "From ") or string.find(string.lower(messageData.OriginalChannel), "whisper")) then
                    isWhisper = true
                end
                logChatMessage(tostring(messageData.FromSpeaker), tostring(messageData.Message), isWhisper)
            end
        end)
    end
end)
pcall(function()
    local textChatService = game:GetService("TextChatService")
    _G.ChatLogsModernConnection = textChatService.MessageReceived:Connect(function(textChatMessage)
        if textChatMessage.TextSource and textChatMessage.Text then
            local isWhisper = false
            if textChatMessage.TextChannel and (string.find(textChatMessage.TextChannel.Name, "Whisper") or string.find(textChatMessage.TextChannel.Name, "Private")) then
                isWhisper = true
            end
            logChatMessage(tostring(textChatMessage.TextSource.Name), tostring(textChatMessage.Text), isWhisper)
        end
    end)
end)
function createChatLogsWindow()
    if ChatLogsFrame then return end
    local sgui = ScreenGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "ChatLogsFrame"
    mainFrame.Size = UDim2.new(0, 340, 0, 360)
    mainFrame.Position = UDim2.new(0.5, 120, 0.5, -180)
    mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = sgui
    ChatLogsFrame = mainFrame
    local modal = Instance.new("TextButton")
    modal.Size = UDim2.new(0, 0, 0, 0)
    modal.BackgroundTransparency = 1
    modal.Text = ""
    modal.Modal = true
    modal.Parent = mainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.Parent = mainFrame
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, 12)
    topCorner.Parent = topBar
    local topCover = Instance.new("Frame")
    topCover.Size = UDim2.new(1, 0, 0, 10)
    topCover.Position = UDim2.new(0, 0, 1, -10)
    topCover.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topCover.BorderSizePixel = 0
    topCover.Parent = topBar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -130, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Chat Logs"
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1.5
    closeStroke.Parent = closeBtn
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -54, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
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
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1.5
    minStroke.Parent = minBtn
    local clearBtn = Instance.new("TextButton")
    clearBtn.Size = UDim2.new(0, 45, 0, 22)
    clearBtn.Position = UDim2.new(1, -105, 0.5, -11)
    clearBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    clearBtn.Text = "Clear"
    clearBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    clearBtn.Font = Enum.Font.GothamBold
    clearBtn.TextSize = 10
    clearBtn.Parent = topBar
    Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 4)
    local clearStroke = Instance.new("UIStroke", clearBtn)
    clearStroke.Color = Color3.fromRGB(60, 60, 65)
    clearStroke.Thickness = 1
    clearBtn.MouseButton1Click:Connect(function()
        _G.ChatLogsTable = {}
        if refreshChatLogsUI then
            refreshChatLogsUI()
        end
    end)
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 45, 0, 22)
    copyBtn.Position = UDim2.new(1, -155, 0.5, -11)
    copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    copyBtn.Text = "Copy"
    copyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 10
    copyBtn.Parent = topBar
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 4)
    local copyStroke = Instance.new("UIStroke", copyBtn)
    copyStroke.Color = Color3.fromRGB(60, 60, 65)
    copyStroke.Thickness = 1
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            local text = ""
            for _, logEntry in ipairs(_G.ChatLogsTable) do
                text = text .. "[" .. logEntry.Time .. "] " .. logEntry.Sender .. ": " .. logEntry.Message .. "\n"
            end
            setclipboard(text)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Chat Logs",
                    Text = "Logs copied to clipboard!",
                    Duration = 3
                })
            end)
        end
    end)
    local isMinimized = false
    local normalSize = UDim2.new(0, 340, 0, 360)
    local minimizedSize = UDim2.new(0, 340, 0, 30)
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(1, -20, 0, 32)
    searchFrame.Position = UDim2.new(0, 10, 0, 38)
    searchFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    searchFrame.BackgroundTransparency = 0.2
    searchFrame.Parent = mainFrame
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame
    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color = Color3.fromRGB(255, 255, 255)
    searchStroke.Thickness = 1.5
    searchStroke.Parent = searchFrame
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.Position = UDim2.new(0, 10, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.GothamBold
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search chat logs..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.TextSize = 14
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchFrame
    ChatLogsSearchBox = searchBox
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if refreshChatLogsUI then
            refreshChatLogsUI()
        end
    end)
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
                    refreshChatLogsUI()
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
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -85)
    scroll.Position = UDim2.new(0, 10, 0, 78)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    scroll.Parent = mainFrame
    ChatLogsScroll = scroll
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)
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
    refreshChatLogsUI = function()
        if not ChatLogsScroll then return end
        for _, child in ipairs(ChatLogsScroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        local query = ChatLogsSearchBox and string.lower(ChatLogsSearchBox.Text) or ""
        local count = 0
        for idx, logEntry in ipairs(_G.ChatLogsTable) do
            local senderMatch = string.find(string.lower(logEntry.Sender), query, 1, true)
            local msgMatch = string.find(string.lower(logEntry.Message), query, 1, true)
            if query == "" or senderMatch or msgMatch then
                count = count + 1
                local row = Instance.new("Frame")
                row.Name = "ChatLogEntry"
                row.Size = UDim2.new(1, -10, 0, 0)
                row.BackgroundTransparency = 1
                row.LayoutOrder = count
                row.Parent = ChatLogsScroll
                local targetPlayer = findPlr(logEntry.RawSender)
                local showTp = targetPlayer and targetPlayer ~= game.Players.LocalPlayer
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 13
                label.TextColor3 = Color3.fromRGB(230, 230, 230)
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Top
                label.TextWrapped = true
                label.RichText = true
                local v = 0
                for i = 1, #logEntry.Sender do v = v + string.byte(logEntry.Sender, i) end
                local color = Color3.fromHSV((v % 360) / 360, 0.6, 0.9)
                local hexColor = string.format("rgb(%d,%d,%d)", color.R*255, color.G*255, color.B*255)
                label.Text = string.format("[%s] <font color=\"%s\">%s</font>: %s", logEntry.Time, hexColor, logEntry.Sender, logEntry.Message)
                label.Parent = row
                local wrapWidth = 310
                if showTp then
                    wrapWidth = 272
                    label.Size = UDim2.new(1, -42, 1, 0)
                    local tpBtn = Instance.new("TextButton")
                    tpBtn.Name = "TPBtn"
                    tpBtn.Size = UDim2.new(0, 32, 0, 20)
                    tpBtn.Position = UDim2.new(1, -45, 0.5, -10)
                    tpBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    tpBtn.Text = "TP"
                    tpBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                    tpBtn.Font = Enum.Font.GothamBold
                    tpBtn.TextSize = 10
                    tpBtn.Parent = row
                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(0, 4)
                    c.Parent = tpBtn
                    tpBtn.MouseEnter:Connect(function()
                        TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                    end)
                    tpBtn.MouseLeave:Connect(function()
                        TweenService:Create(tpBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                    end)
                    tpBtn.MouseButton1Click:Connect(function()
                        if targetPlayer and targetPlayer.Parent then
                            safeTeleportToPlayer(targetPlayer)
                        end
                    end)
                else
                    label.Size = UDim2.new(1, 0, 1, 0)
                end
                local textService = game:GetService("TextService")
                local plainText = "[" .. logEntry.Time .. "] " .. logEntry.Sender .. ": " .. logEntry.Message
                local size = textService:GetTextSize(plainText, label.TextSize, label.Font, Vector2.new(wrapWidth, 1000))
                row.Size = UDim2.new(1, -5, 0, size.Y + 6)
                if showTp and row:FindFirstChild("TPBtn") then
                    row.TPBtn.Position = UDim2.new(1, -45, 0.5, -10)
                end
            end
        end
    end
end
toggleChatLogsWindow = function()
    if not ChatLogsFrame then
        createChatLogsWindow()
    end
    ChatLogsFrame.Visible = not ChatLogsFrame.Visible
    if ChatLogsFrame.Visible then
        refreshChatLogsUI()
    end
end
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
    SpeedBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    SpeedBox.TextSize = 15
    SpeedBox.Font = Enum.Font.GothamBold
    SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBox.ClearTextOnFocus = false
    SpeedBox.Parent = ScrollFrame
    local c_spd = Instance.new("UICorner")
    c_spd.CornerRadius = UDim.new(0, 8)
    c_spd.Parent = SpeedBox
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
function lerpColor(c1, c2, t)
	return Color3.new(
		c1.R + (c2.R - c1.R) * t,
		c1.G + (c2.G - c1.G) * t,
		c1.B + (c2.B - c1.B) * t
	)
end
function addSelendang(char)
	if selendangPart then
		selendangPart:Destroy()
		selendangPart = nil
	end
	for _, p in ipairs(char:GetDescendants()) do
		if p.Name == "SpeedTrailAtt" or p.Name == "SpeedTrailInst" then
			p:Destroy()
		end
	end
	local leftFoot = char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg")
	local rightFoot = char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg")
	if not leftFoot or not rightFoot then return end
	selendangPart = Instance.new("Folder")
	selendangPart.Name = "SelendangPart"
	selendangPart.Parent = char
	local trails = {}
	for _, foot in ipairs({leftFoot, rightFoot}) do
		local attTop1 = Instance.new("Attachment")
		attTop1.Name = "SpeedTrailAtt"
		attTop1.Position = Vector3.new(0, 0.4, 0)
		attTop1.Parent = foot
		local attBottom1 = Instance.new("Attachment")
		attBottom1.Name = "SpeedTrailAtt"
		attBottom1.Position = Vector3.new(0, -0.4, 0)
		attBottom1.Parent = foot
		local newTrail1 = Instance.new("Trail")
		newTrail1.Name = "SpeedTrailInst"
		newTrail1.Attachment0 = attTop1
		newTrail1.Attachment1 = attBottom1
		newTrail1.Lifetime = 1.2
		newTrail1.MinLength = 0.05
		newTrail1.LightEmission = 0.8
		newTrail1.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(1, 1)
		})
		newTrail1.WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.0),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0)
		})
		newTrail1.Parent = foot
		table.insert(trails, newTrail1)
		local attTop2 = Instance.new("Attachment")
		attTop2.Name = "SpeedTrailAtt"
		attTop2.Position = Vector3.new(0.4, 0, 0)
		attTop2.Parent = foot
		local attBottom2 = Instance.new("Attachment")
		attBottom2.Name = "SpeedTrailAtt"
		attBottom2.Position = Vector3.new(-0.4, 0, 0)
		attBottom2.Parent = foot
		local newTrail2 = Instance.new("Trail")
		newTrail2.Name = "SpeedTrailInst"
		newTrail2.Attachment0 = attTop2
		newTrail2.Attachment1 = attBottom2
		newTrail2.Lifetime = 1.2
		newTrail2.MinLength = 0.05
		newTrail2.LightEmission = 0.8
		newTrail2.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(1, 1)
		})
		newTrail2.WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.0),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0)
		})
		newTrail2.Parent = foot
		table.insert(trails, newTrail2)
	end
	task.spawn(function()
		local step = 0
		while speedOn and selendangPart and selendangPart.Parent do
			local idx1 = math.floor(step) % #colors + 1
			local idx2 = (idx1 % #colors) + 1
			local t = step % 1
			local col = lerpColor(colors[idx1], colors[idx2], t)
			for _, tr in ipairs(trails) do
				if tr and tr.Parent then
					tr.Color = ColorSequence.new(col)
				end
			end
			step += 0.02
			task.wait(0.03)
		end
	end)
end
function removeSelendang()
	if selendangPart then
		selendangPart:Destroy()
		selendangPart = nil
	end
	local char = Player.Character
	if char then
		for _, p in ipairs(char:GetDescendants()) do
			if p.Name == "SpeedTrailAtt" or p.Name == "SpeedTrailInst" then
				pcall(function() p:Destroy() end)
			end
		end
	end
end
local speedConnection
local updatingSpeed = false
local lastGameSpeed = 16
local function setupSpeedListener(char)
	if speedConnection then speedConnection:Disconnect() end
	local hum = char:WaitForChild("Humanoid", 5)
	if not hum then return end
	local function checkSpeed()
		if updatingSpeed then return end
		local currentSpeed = hum.WalkSpeed
		if speedOn then
			updatingSpeed = true
			if currentSpeed ~= desiredSpeed and currentSpeed ~= (desiredSpeed + (lastGameSpeed - 16)) then
				lastGameSpeed = currentSpeed
			end
			local finalSpeed = desiredSpeed
			if lastGameSpeed > 16 then
				finalSpeed = desiredSpeed + (lastGameSpeed - 16)
			end
			hum.WalkSpeed = finalSpeed
			updatingSpeed = false
		else
			lastGameSpeed = currentSpeed
		end
	end
	speedConnection = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(checkSpeed)
	checkSpeed()
end
function toggleSpeed()
	speedOn = not speedOn
	local char = Player.Character or Player.CharacterAdded:Wait()
	local hum = char:FindFirstChild("Humanoid")
	if speedOn then
		addSelendang(char)
		setButtonActive(SpeedBtn, true)
		if hum then
			updatingSpeed = true
			local currentSpeed = hum.WalkSpeed
			if currentSpeed > 16 then
				lastGameSpeed = currentSpeed
			end
			local finalSpeed = desiredSpeed
			if lastGameSpeed > 16 then
				finalSpeed = desiredSpeed + (lastGameSpeed - 16)
			end
			hum.WalkSpeed = finalSpeed
			updatingSpeed = false
		end
	else
		removeSelendang()
		setButtonActive(SpeedBtn, false)
		if hum then
			updatingSpeed = true
			hum.WalkSpeed = lastGameSpeed
			updatingSpeed = false
		end
	end
end
SpeedBtn.MouseButton1Click:Connect(toggleSpeed)
SpeedShortcutConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if UserInputService:GetFocusedTextBox() then return end
	if input.KeyCode == Enum.KeyCode.RightBracket then
		toggleSpeed()
	end
end)
Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	setupSpeedListener(char)
	if speedOn then
		addSelendang(char)
		setButtonActive(SpeedBtn, true)
	else
		setButtonActive(SpeedBtn, false)
	end
end)
if Player.Character then
	task.spawn(setupSpeedListener, Player.Character)
end
local walkFlingActive = false
local walkFlingConn = nil
local walkFlingSpeed = 10000
local function doWalkFlingBurst(root)
    if not (root and root.Parent) then return end
    local ok, vel = pcall(function() return root.Velocity end)
    if not ok or typeof(vel) ~= "Vector3" then vel = Vector3.new(0,0,0) end
    pcall(function()
        root.Velocity = vel * walkFlingSpeed + Vector3.new(0, walkFlingSpeed, 0)
    end)
    RunService.RenderStepped:Wait()
    if root and root.Parent then
        pcall(function() root.Velocity = vel end)
    end
    RunService.Stepped:Wait()
    if root and root.Parent then
        pcall(function() root.Velocity = vel + Vector3.new(0, 0.1, 0) end)
    end
end
FlingBtn = createButton("", "Tendang")
local hiddenfling = false
local flingThread
function fling()
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
        if walkFlingConn then walkFlingConn:Disconnect() end
        walkFlingConn = RunService.Heartbeat:Connect(function()
            if not hiddenfling then
                if walkFlingConn then walkFlingConn:Disconnect(); walkFlingConn = nil end
                return
            end
            local char = Players.LocalPlayer and Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then task.spawn(doWalkFlingBurst, root) end
        end)
    else
        setButtonActive(FlingBtn, false)
        if walkFlingConn then walkFlingConn:Disconnect(); walkFlingConn = nil end
    end
end)
WalkFlingBtn = createButton("", "Walk Fling")
WalkFlingBtn.Name = "WalkFlingBtn"
function toggleWalkFling(state)
    if state == nil then
        walkFlingActive = not walkFlingActive
    else
        walkFlingActive = state
    end
    if walkFlingActive then
        setButtonActive(WalkFlingBtn, true)
        if walkFlingConn then walkFlingConn:Disconnect() end
        walkFlingConn = RunService.Heartbeat:Connect(function()
            if not walkFlingActive then return end
            local char = Players.LocalPlayer and Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                task.spawn(doWalkFlingBurst, root)
            end
        end)
    else
        setButtonActive(WalkFlingBtn, false)
        if walkFlingConn then walkFlingConn:Disconnect(); walkFlingConn = nil end
    end
end
WalkFlingBtn.MouseButton1Click:Connect(function()
    toggleWalkFling()
end)
AntiFlingBtn = createButton("", "Anti Fling")
AntiFlingBtn.Name = "AntiFlingBtn"
local antiFlingActive = false
local antiFlingConns = {}
local antiFlingTracked = {}
local function antiFlingApply(p)
    if not (p and typeof(p) == "Instance" and p:IsA("BasePart")) then return end
    if antiFlingTracked[p] then return end
    antiFlingTracked[p] = true
    pcall(function() p.CanCollide = false end)
end
local function antiFlingClear(p)
    if antiFlingTracked[p] then
        antiFlingTracked[p] = nil
        pcall(function() p.CanCollide = true end)
    end
end
local function antiFlingHookChar(char)
    if not char then return end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then antiFlingApply(d) end
    end
    table.insert(antiFlingConns, char.DescendantAdded:Connect(function(inst)
        if inst:IsA("BasePart") and antiFlingActive then antiFlingApply(inst) end
    end))
    table.insert(antiFlingConns, char.DescendantRemoving:Connect(function(inst)
        if inst:IsA("BasePart") then antiFlingClear(inst) end
    end))
end
function toggleAntiFling(state)
    if state == nil then
        antiFlingActive = not antiFlingActive
    else
        antiFlingActive = state
    end
    if antiFlingActive then
        setButtonActive(AntiFlingBtn, true)
        antiFlingTracked = {}
        local lp = Players.LocalPlayer
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp then
                antiFlingHookChar(plr.Character)
                table.insert(antiFlingConns, plr.CharacterAdded:Connect(function(char)
                    if antiFlingActive then antiFlingHookChar(char) end
                end))
            end
        end
        table.insert(antiFlingConns, Players.PlayerAdded:Connect(function(plr)
            if plr ~= lp and antiFlingActive then
                if plr.Character then antiFlingHookChar(plr.Character) end
                table.insert(antiFlingConns, plr.CharacterAdded:Connect(function(char)
                    if antiFlingActive then antiFlingHookChar(char) end
                end))
            end
        end))
        table.insert(antiFlingConns, RunService.PreSimulation:Connect(function()
            for p in pairs(antiFlingTracked) do
                pcall(function()
                    if p and p.Parent and p.CanCollide ~= false then
                        p.CanCollide = false
                    end
                end)
            end
        end))
    else
        setButtonActive(AntiFlingBtn, false)
        antiFlingActive = false
        for _, c in ipairs(antiFlingConns) do pcall(function() c:Disconnect() end) end
        antiFlingConns = {}
        for p in pairs(antiFlingTracked) do
            pcall(function() if p and p.Parent then p.CanCollide = true end end)
        end
        antiFlingTracked = {}
    end
end
AntiFlingBtn.MouseButton1Click:Connect(function()
    toggleAntiFling()
end)
HitboxBtn = createButton("", "Hitbox")
HitboxBtn.Name = "HitboxBtn"
hitboxActive = false
hitboxConnection = nil
hitboxSize = 20
function toggleHitbox(state)
    if state == nil then hitboxActive = not hitboxActive else hitboxActive = state end
    setButtonActive(HitboxBtn, hitboxActive)
    if hitboxActive then
        hitboxConnection = RunService.RenderStepped:Connect(function()
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Bright red")
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        end)
    else
        if hitboxConnection then hitboxConnection:Disconnect() hitboxConnection = nil end
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
                hrp.CanCollide = false
            end
        end
    end
end
HitboxBtn.MouseButton1Click:Connect(function() toggleHitbox() end)

AutoClickerBtn = createButton("", "Auto Clicker (PC)")
AutoClickerBtn.Name = "AutoClickerBtn"
autoClickerActive = false
autoClickerConnection = nil
function toggleAutoClicker(state)
    if state == nil then autoClickerActive = not autoClickerActive else autoClickerActive = state end
    setButtonActive(AutoClickerBtn, autoClickerActive)
    if autoClickerActive then
        autoClickerConnection = task.spawn(function()
            while autoClickerActive do
                if mouse1click then
                    pcall(function() mouse1click() end)
                else
                    pcall(function()
                        local vu = game:GetService("VirtualUser")
                        vu:CaptureController()
                        vu:ClickButton1(Vector2.new())
                    end)
                end
                pcall(function()
                    local char = Player.Character
                    if char then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end)
                task.wait(0.05)
            end
        end)
    else
        if autoClickerConnection then 
            task.cancel(autoClickerConnection) 
            autoClickerConnection = nil 
        end
    end
end
AutoClickerBtn.MouseButton1Click:Connect(function() toggleAutoClicker() end)
AimbotBtn = createButton("", "Aimbot")
AimbotBtn.Name = "AimbotBtn"
aimbotActive = false
aimbotConnection = nil
function toggleAimbot(state)
    if state == nil then aimbotActive = not aimbotActive else aimbotActive = state end
    setButtonActive(AimbotBtn, aimbotActive)
    if aimbotActive then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local myPos = char.HumanoidRootPart.Position
            local cam = Workspace.CurrentCamera
            local closestPlayer = nil
            local shortestDistance = math.huge
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    if p.Team and Player.Team and p.Team == Player.Team then continue end
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
                local currentCFrame = cam.CFrame
                local newCFrame = CFrame.new(currentCFrame.Position, targetPos)
                cam.CFrame = currentCFrame:Lerp(newCFrame, 0.15)
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    end
end
AimbotBtn.MouseButton1Click:Connect(function() toggleAimbot() end)
MaxZoomBtn = nil
maxZoomActive = false
maxZoomConnection = nil
function toggleMaxZoom(state)
    if state == nil then maxZoomActive = not maxZoomActive else maxZoomActive = state end
    if MaxZoomBtn then
        setButtonActive(MaxZoomBtn, maxZoomActive)
    end
    if MiniMaxZoomBtn then
        MiniMaxZoomBtn.Text = maxZoomActive and "Max Zoom: ON" or "Max Zoom: OFF"
        MiniMaxZoomBtn.TextColor3 = maxZoomActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 50, 50)
    end
    if maxZoomActive then
        Player.CameraMaxZoomDistance = 100000
        Player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        if not maxZoomConnection then
            maxZoomConnection = RunService.RenderStepped:Connect(function()
                if Player.CameraMaxZoomDistance ~= 100000 then
                    Player.CameraMaxZoomDistance = 100000
                end
                if Player.DevCameraOcclusionMode ~= Enum.DevCameraOcclusionMode.Invisicam then
                    Player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
                end
            end)
        end
    else
        if maxZoomConnection then
            maxZoomConnection:Disconnect()
            maxZoomConnection = nil
        end
        Player.CameraMaxZoomDistance = 128
        Player.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
    end
end
FlingAuraBtn = createButton("", "Fling Aura")
FlingAuraBtn.Name = "FlingAuraBtn"
flingAuraActive = false
flingAuraRange = 35
flingAuraConnection = nil
function toggleFlingAura(state)
    if state == nil then
        flingAuraActive = not flingAuraActive
    else
        flingAuraActive = state
    end
    local MiniFlingBtn = MiniButtons and MiniButtons["MiniFlingAuraBtn"]
    if flingAuraActive then
        setButtonActive(FlingAuraBtn, true)
        if MiniFlingBtn then
            MiniFlingBtn.Text = "Fling Aura: ON"
            MiniFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        if flingAuraConnection then flingAuraConnection:Disconnect() end
        flingAuraConnection = RunService.Heartbeat:Connect(function()
            if not flingAuraActive then return end
            local lp = Players.LocalPlayer
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end
            local targetHRP = nil
            local shortestDist = flingAuraRange
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        targetHRP = plr.Character.HumanoidRootPart
                    end
                end
            end
            if targetHRP then
                local originalCF = hrp.CFrame
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0.2, 0)
                hrp.Velocity = Vector3.new(999999, 999999, 999999)
                RunService.RenderStepped:Wait()
                if hrp and hrp.Parent then
                    hrp.Velocity = Vector3.zero
                    hrp.CFrame = originalCF
                end
            end
        end)
    else
        setButtonActive(FlingAuraBtn, false)
        if MiniFlingBtn then
            MiniFlingBtn.Text = "Fling Aura: OFF"
            MiniFlingBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        if flingAuraConnection then
            flingAuraConnection:Disconnect()
            flingAuraConnection = nil
        end
    end
end
FlingAuraBtn.MouseButton1Click:Connect(function()
    toggleFlingAura()
end)
OrbitFlingBtn = createButton("", "Orbit Fling")
OrbitFlingBtn.Name = "OrbitFlingBtn"
orbitFlingActive = false
orbitFlingConnection = nil
orbitFlingTarget = nil
function toggleOrbitFling(state, targetPlayer)
    if state == nil then
        orbitFlingActive = not orbitFlingActive
    else
        orbitFlingActive = state
    end
    local MiniOrbitBtn = MiniButtons and MiniButtons["MiniOrbitFlingBtn"]
    if orbitFlingActive then
        orbitFlingTarget = targetPlayer or getClosestPlayer()
        if not orbitFlingTarget then
            orbitFlingActive = false
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Orbit Fling",
                    Text = "No target player found nearby.",
                    Duration = 3
                })
            end)
            return
        end
        setButtonActive(OrbitFlingBtn, true)
        if MiniOrbitBtn then
            MiniOrbitBtn.Text = "Orbit: " .. string.sub(orbitFlingTarget.Name, 1, 8)
            MiniOrbitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        local angle = 0
        local radius = 4
        local speed = 0.5
        if orbitFlingConnection then orbitFlingConnection:Disconnect() end
        orbitFlingConnection = RunService.Heartbeat:Connect(function()
            if not orbitFlingActive then return end
            local lp = Players.LocalPlayer
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if not orbitFlingTarget or not orbitFlingTarget.Parent or not orbitFlingTarget.Character then
                toggleOrbitFling(false)
                return
            end
            local tHrp = orbitFlingTarget.Character:FindFirstChild("HumanoidRootPart")
            local tHum = orbitFlingTarget.Character:FindFirstChildOfClass("Humanoid")
            if not tHrp or (tHum and tHum.Health <= 0) then
                local nextTarget = getClosestPlayer()
                if nextTarget then
                    orbitFlingTarget = nextTarget
                    if MiniOrbitBtn then
                        MiniOrbitBtn.Text = "Orbit: " .. string.sub(orbitFlingTarget.Name, 1, 8)
                    end
                else
                    toggleOrbitFling(false)
                    return
                end
            end
            angle = angle + speed
            local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            hrp.CFrame = CFrame.new(tHrp.Position + offset, tHrp.Position)
            hrp.Velocity = Vector3.new(999999, 999999, 999999)
        end)
    else
        setButtonActive(OrbitFlingBtn, false)
        if MiniOrbitBtn then
            MiniOrbitBtn.Text = "Orbit Fling: OFF"
            MiniOrbitBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        if orbitFlingConnection then
            orbitFlingConnection:Disconnect()
            orbitFlingConnection = nil
        end
        orbitFlingTarget = nil
        pcall(function()
            local char = Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.zero
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end)
    end
end

TouchFlingBtn = createButton("", "Touch Fling")
TouchFlingBtn.Name = "TouchFlingBtn"
touchFlingActive = false
touchFlingConnection = nil
touchFlingToolConnections = {}
touchFlingDebounces = {}
touchFlingCharacterConn = nil

function cleanupTouchFlingToolConnections()
    for _, conn in ipairs(touchFlingToolConnections) do
        pcall(function() conn:Disconnect() end)
    end
    touchFlingToolConnections = {}
end

function hookToolParts(tool)
    if not tool:IsA("Tool") then return end
    
    local function hookPart(part)
        if not part:IsA("BasePart") then return end
        local conn = part.Touched:Connect(function(hit)
            if not touchFlingActive then return end
            if not hit or not hit.Parent then return end
            
            local targetChar = hit.Parent
            if targetChar:IsA("Accessory") then
                targetChar = targetChar.Parent
            end
            
            local targetPlr = Players:GetPlayerFromCharacter(targetChar)
            local lp = Players.LocalPlayer
            if targetPlr and targetPlr ~= lp then
                local hum = targetChar:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local now = tick()
                    if not touchFlingDebounces[targetPlr] or (now - touchFlingDebounces[targetPlr] > 3) then
                        touchFlingDebounces[targetPlr] = now
                        executeInstantFling(targetPlr)
                    end
                end
            end
        end)
        table.insert(touchFlingToolConnections, conn)
    end

    for _, descendant in ipairs(tool:GetDescendants()) do
        hookPart(descendant)
    end
    
    local childAddedConn = tool.DescendantAdded:Connect(hookPart)
    table.insert(touchFlingToolConnections, childAddedConn)
end

function setupTouchFlingMonitoring()
    cleanupTouchFlingToolConnections()
    if not touchFlingActive then return end
    
    local lp = Players.LocalPlayer
    local char = lp.Character
    if not char then return end
    
    local currentTool = char:FindFirstChildOfClass("Tool")
    if currentTool then
        hookToolParts(currentTool)
    end
    
    local childAddedConn = char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            cleanupTouchFlingToolConnections()
            hookToolParts(child)
        end
    end)
    table.insert(touchFlingToolConnections, childAddedConn)
end

function toggleTouchFling(state)
    if state == nil then
        touchFlingActive = not touchFlingActive
    else
        touchFlingActive = state
    end
    
    if TouchFlingBtn then
        setButtonActive(TouchFlingBtn, touchFlingActive)
    end
    
    cleanupTouchFlingToolConnections()
    if touchFlingCharacterConn then
        touchFlingCharacterConn:Disconnect()
        touchFlingCharacterConn = nil
    end
    
    if touchFlingActive then
        setupTouchFlingMonitoring()
        local lp = Players.LocalPlayer
        touchFlingCharacterConn = lp.CharacterAdded:Connect(function()
            task.wait(0.5)
            if touchFlingActive then
                setupTouchFlingMonitoring()
            end
        end)
    else
        touchFlingDebounces = {}
    end
end

TouchFlingBtn.MouseButton1Click:Connect(function()
    toggleTouchFling()
end)

ClickYeetBtn = createButton("", "Click Yeet")
ClickYeetBtn.Name = "ClickYeetBtn"
ClickYeetBtn.MouseButton1Click:Connect(function()
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Click Yeet (OP)") or Instance.new("Tool")
    tool.Name = "Click Yeet (OP)"
    tool.RequiresHandle = false
    tool.ToolTip = _G.currentLang == "ID" and "Klik part/player manapun untuk melemparnya seketika!" or "Click any part or player to instantly fling them to the void!"
    
    local mouse = game.Players.LocalPlayer:GetMouse()
    local conn
    
    tool.Equipped:Connect(function()
        conn = mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target then
                local char = target.Parent
                if char and char:FindFirstChildOfClass("Humanoid") then
                    target = char:FindFirstChild("HumanoidRootPart") or target
                end
                
                pcall(function()
                    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    target:BreakJoints()
                    target.CanCollide = false
                    target.Anchored = false
                    target.CFrame = CFrame.new(99999, 9999, 99999)
                    target.AssemblyLinearVelocity = Vector3.new(0, 50000, 0)
                    task.wait(0.05)
                    target:Destroy()
                end)
            end
        end)
    end)
    
    tool.Unequipped:Connect(function()
        if conn then conn:Disconnect() end
    end)
    
    tool.Parent = game.Players.LocalPlayer.Backpack
    game.StarterGui:SetCore("SendNotification", {
        Title = "Click Yeet",
        Text = "Alat Click Yeet berhasil ditambahkan ke Backpack Anda!",
        Duration = 3
    })
end)

LagServerBtn = createButton("", "Crash Server")
LagServerBtn.Name = "LagServerBtn"
local lagServerActive = false
LagServerBtn.MouseButton1Click:Connect(function()
    lagServerActive = not lagServerActive
    setButtonActive(LagServerBtn, lagServerActive)
    if lagServerActive then
        game.StarterGui:SetCore("SendNotification", {
            Title = tr("Crash Server"),
            Text = _G.currentLang == "ID" and "Mengirim spam physics ke server... (Berpotensi membuat lag semua player)" or "Sending spam physics to server... (Potentially lags all players)",
            Duration = 3
        })
        task.spawn(function()
            while lagServerActive do
                local parts = scanParts()
                for _, p in ipairs(parts) do
                    if not lagServerActive then break end
                    pcall(function()
                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        p.AssemblyLinearVelocity = Vector3.new(math.random(-99999, 99999), math.random(-99999, 99999), math.random(-99999, 99999))
                        p.AssemblyAngularVelocity = Vector3.new(math.random(-99999, 99999), math.random(-99999, 99999), math.random(-99999, 99999))
                    end)
                end
                task.wait()
            end
        end)
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Crash Server",
            Text = "Crash Server dimatikan.",
            Duration = 3
        })
    end
end)
OrbitFlingBtn.MouseButton1Click:Connect(function()
    toggleOrbitFling()
end)
ClickTPBtn = createButton("", "Click TP")
ClickTPBtn.Name = "ClickTPBtn"
ClickTPBtn.LayoutOrder = 1
FreeCamBtn = createButton("", "Free Cam")
FreeCamBtn.Name = "FreeCamBtn"
FreeCamBtn.LayoutOrder = 3
TweenTPBtn = createButton("", "Tween TP")
TweenTPBtn.Name = "TweenTPBtn"
TweenTPBtn.LayoutOrder = 4
TweenTPBtn.MouseButton1Click:Connect(function()
    tweenTpEnabled = not tweenTpEnabled
    setButtonActive(TweenTPBtn, tweenTpEnabled)
end)
local TPBox
local findPlayerByQuery
local clickTpOn = false
local freecamOn = false
local freecamYaw, freecamPitch = 0, 0
local freecamPos
local freecamSpeed = 1
local clickTpConnection = nil
local freecamInputConn = nil
local savedFreecamWalkSpeed = nil
local savedFreecamJumpPower = nil
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
                        if typeof(safeTeleportToCFrame) == "function" then
                            safeTeleportToCFrame(CFrame.new(targetPos))
                        else
                            char:PivotTo(CFrame.new(targetPos))
                        end
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
            if typeof(safeTeleportToCFrame) == "function" then
                safeTeleportToCFrame(CFrame.new(targetPos))
            else
                player.Character:PivotTo(CFrame.new(targetPos))
            end
        else
            setButtonActive(ClickTPBtn, true)
            task.delay(0.1, function() setButtonActive(ClickTPBtn, false) end)
        end
    else
        toggleClickTP()
    end
end
ClickTPBtn.MouseButton1Click:Connect(handleClickTPClick)
function setFreecam(state)
    freecamOn = state
    local cam = workspace.CurrentCamera
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    local animateScript = char:FindFirstChild("Animate")
    if freecamOn then
        if hum then
            savedFreecamWalkSpeed = hum.WalkSpeed
            savedFreecamJumpPower = hum.JumpPower
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end
        if animateScript then
            animateScript.Disabled = true
        end
        if hrp then hrp.Anchored = true end
        cam.CameraType = Enum.CameraType.Scriptable
        freecamPos = cam.CFrame.Position
        local rx, ry = cam.CFrame:ToOrientation()
        freecamPitch, freecamYaw = rx, ry
        setButtonActive(FreeCamBtn, true)
        
        if not freecamInputConn then
            freecamInputConn = UserInputService.InputChanged:Connect(function(input, gpe)
                if not freecamOn then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    local md = input.Delta
                    freecamYaw = freecamYaw - (md.X/300)
                    freecamPitch = math.clamp(freecamPitch - (md.Y/300), -math.rad(89), math.rad(89))
                elseif input.UserInputType == Enum.UserInputType.Touch and not gpe then
                    local viewportWidth = workspace.CurrentCamera.ViewportSize.X
                    if input.Position.X > viewportWidth / 2 then
                        local md = input.Delta
                        freecamYaw = freecamYaw - (md.X/300)
                        freecamPitch = math.clamp(freecamPitch - (md.Y/300), -math.rad(89), math.rad(89))
                    end
                end
            end)
        end
        
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
                    
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.MoveDirection.Magnitude > 0 then
                        local flatLook = (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
                        local flatRight = (cam.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
                        local forwardInput = hum.MoveDirection:Dot(flatLook)
                        local rightInput = hum.MoveDirection:Dot(flatRight)
                        delta += (cam.CFrame.LookVector * forwardInput) + (cam.CFrame.RightVector * rightInput)
                    end
                    
                    if delta.Magnitude > 0 then
                        delta = delta.Unit
                    end
                    freecamPos += delta * freecamSpeed
                    
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                    else
                        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    end
                end
                cam.CFrame = CFrame.new(freecamPos) * CFrame.fromOrientation(freecamPitch, freecamYaw, 0)
                RunService.RenderStepped:Wait()
            end
        end)
    else
        if freecamInputConn then
            freecamInputConn:Disconnect()
            freecamInputConn = nil
        end
        if hrp then hrp.Anchored = false end
        if hum then
            if savedFreecamWalkSpeed then hum.WalkSpeed = savedFreecamWalkSpeed end
            if savedFreecamJumpPower then hum.JumpPower = savedFreecamJumpPower end
        end
        if animateScript then
            animateScript.Disabled = false
        end
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        setButtonActive(FreeCamBtn, false)
    end
end
FreeCamBtn.MouseButton1Click:Connect(function()
    setFreecam(not freecamOn)
end)
FreecamShortcutConn = UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.T then
        setFreecam(not freecamOn)
    end
end)
TPBox = Instance.new("TextBox")
TPBox.Name = "TPBox"
TPBox.LayoutOrder = 2
TPBox.Size = UDim2.new(0, 150, 0, 35)
TPBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 12)
    p.Parent = TPBox
end
local FCBox = Instance.new("TextBox")
FCBox.Name = "FCBox"
FCBox.LayoutOrder = 4
FCBox.Size = UDim2.new(0, 150, 0, 35)
FCBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
SWPBtn = createButton("", "Save WP")
SWPBtn.Name = "SWPBtn"
SWPBtn.LayoutOrder = 5
SWPBox = Instance.new("TextBox")
SWPBox.Name = "SWPBox"
SWPBox.LayoutOrder = 6
SWPBox.Size = UDim2.new(0, 150, 0, 35)
SWPBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
    for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if string.lower(plr.Name) == lower then return plr end
    end
    for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if string.lower(plr.DisplayName) == lower then return plr end
    end
    for _,plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if string.find(string.lower(plr.Name), lower, 1, true) == 1 or string.find(string.lower(plr.DisplayName), lower, 1, true) == 1 then
            return plr
        end
    end
    return nil
end
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local function resolveCatalogAnimationId(assetId)
    local finalId = "rbxassetid://" .. tostring(assetId)
    local ok, objs = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(assetId))
    end)
    if ok and objs and objs[1] then
        local obj = objs[1]
        if obj:IsA("Animation") then
            return obj.AnimationId
        else
            local subAnim = obj:FindFirstChildOfClass("Animation") or obj:FindFirstChildOfClass("Animation", true)
            if subAnim then
                return subAnim.AnimationId
            end
        end
    end
    local okHttp, content = pcall(function()
        return game:HttpGet("https://assetdelivery.roblox.com/v1/asset/?id=" .. tostring(assetId))
    end)
    if okHttp and content then
        local urlPattern = "<url>(.-)</url>"
        local foundUrl = content:match(urlPattern)
        if foundUrl then
            foundUrl = foundUrl:gsub("&amp;", "&")
            if foundUrl:find("id=%d+") or foundUrl:find("rbxassetid://%d+") or foundUrl:find("roblox.com/asset") then
                return foundUrl
            end
        end
        local idPattern = "id=(%d+)"
        local foundId = content:match(idPattern)
        if foundId then
            return "rbxassetid://" .. foundId
        end
    end
    return finalId
end
local animations = {
    Idle = 105221645767714,
    Fly = 88952942370104,
}
local animTracks = {}
local animator
function setupAnimator(hum)
    animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
    animTracks = {}
    for name, id in pairs(animations) do
        local anim = Instance.new("Animation")
        anim.AnimationId = resolveCatalogAnimationId(id)
        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        animTracks[name] = track
    end
end
setupAnimator(humanoid)
flying = false
local flySpeed = 2
local currentFlySpeed = 2
local pressed = {Up=false,Down=false,Left=false,Right=false}
local moving = false
local savedOrientation = nil
local oldGravity = Workspace.Gravity
frozenPos = nil


local FlyV1Btn = createButton("", "Fly V1")
function noclip(state)
    for _,v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") and not v:FindFirstAncestorOfClass("Accessory") then
            v.CanCollide = not state
        end
    end
end
function enableFly()
    flying = true
    humanoid.PlatformStand = true
    noclipActive = true
    if enableNoclip then enableNoclip() else noclip(true) end
    Workspace.Gravity = 0
    setButtonActive(FlyV1Btn, true)
    if MiniFlyTapBtn then
        MiniFlyTapBtn.Text = "Fly (Mobile): ON"
        MiniFlyTapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    frozenPos = root.Position
    local _, y, _ = root.CFrame:ToOrientation()
    savedOrientation = CFrame.Angles(0, math.rad(y), 0)
    if animTracks.Idle then animTracks.Idle:Play() end
end
function disableFly()
    flying = false
    humanoid.PlatformStand = false
    if not blackHoleActive then
        noclipActive = false
        if disableNoclip then disableNoclip() else noclip(false) end
    end
    Workspace.Gravity = oldGravity
    frozenPos = nil
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        local rayOrigin = root.Position
        local rayDirection = Vector3.new(0, -500, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Player.Character, Workspace.CurrentCamera}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local rayResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if rayResult then
            local hip = humanoid.HipHeight > 0 and humanoid.HipHeight or 2
            root.CFrame = CFrame.new(rayResult.Position + Vector3.new(0, hip + (root.Size.Y / 2) + 0.1, 0))
        else
            root.CFrame = root.CFrame + Vector3.new(0, 1.5, 0)
        end
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    setButtonActive(FlyV1Btn, false)
    if MiniFlyTapBtn then
        MiniFlyTapBtn.Text = "Fly (Mobile): OFF"
        MiniFlyTapBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
    for _, t in pairs(animTracks) do if t.IsPlaying then t:Stop() end end
end
FlyV1Btn.MouseButton1Click:Connect(function()
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
	if input.KeyCode == Enum.KeyCode.Space then pressed.Space = true end
	if input.KeyCode == Enum.KeyCode.LeftControl then pressed.Ctrl = true end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then pressed.Up = false end
	if input.KeyCode == Enum.KeyCode.S then pressed.Down = false end
	if input.KeyCode == Enum.KeyCode.A then pressed.Left = false end
	if input.KeyCode == Enum.KeyCode.D then pressed.Right = false end
	if input.KeyCode == Enum.KeyCode.Space then pressed.Space = false end
	if input.KeyCode == Enum.KeyCode.LeftControl then pressed.Ctrl = false end
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
    if pressed.Space then dir += Vector3.new(0, 1, 0) end
    if pressed.Ctrl then dir -= Vector3.new(0, 1, 0) end
    
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.MoveDirection.Magnitude > 0 then
        local flatLook = (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        local flatRight = (cam.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
        local forwardInput = hum.MoveDirection:Dot(flatLook)
        local rightInput = hum.MoveDirection:Dot(flatRight)
        dir += (lookVec * forwardInput) + (rightVec * rightInput)
    end
    if dir.Magnitude > 0 then
        moving = true
        if pressed.Up then
            currentFlySpeed = math.min(currentFlySpeed + (dt * 3), flySpeed * 3)
        else
            currentFlySpeed = flySpeed
        end
        frozenPos = root.Position + dir.Unit * currentFlySpeed * dt * 60
        root.CFrame = CFrame.new(frozenPos, frozenPos + lookVec)
    else
        moving = false
        currentFlySpeed = flySpeed
        if frozenPos then
            root.CFrame = CFrame.new(frozenPos, frozenPos + lookVec)
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
    setButtonActive(FlyV1Btn, false)
end)
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    setupAnimator(humanoid)
    humanoid.Died:Connect(function()
        disableFly()
        setButtonActive(FlyV1Btn, false)
    end)
    setButtonActive(FlyV1Btn, false)
end)
setButtonActive(FlyV1Btn, false)
UnanchorBtn = createButton("", "Unanchor")
local aktif = false
local folder, attachment1, koneksi1
local RADIUS = 500
local activeParts = {}
local function isMapAsset(o)
    local name = string.lower(o.Name)
    if name == "baseplate" or name == "terrain" or name == "road" or name == "sidewalk"
       or name == "floor" or name == "wall" or name == "glass" or name == "window"
       or name == "roof" or name == "ceiling" or name == "door" or name == "stairs"
       or name == "pillar" or name == "support" or name == "building" or name == "house"
       or name == "rock" or name == "stone" or name == "batu" or name == "tree"
       or name == "leaf" or name == "leaves" or name == "trunk" or name == "branch"
       or name == "grass" or name == "hill" or name == "mountain" or name == "water" then
        return true
    end
    local p = o.Parent
    if p and p:IsA("Model") then
        local pName = string.lower(p.Name)
        if pName:find("map") or pName:find("lobby") or pName:find("terrain")
           or pName:find("city") or pName:find("building") or pName:find("tree")
           or pName:find("rock") or pName:find("stone") or pName:find("batu")
           or pName:find("nature") or pName:find("environment") or pName:find("road") then
            return true
        end
    end
    return false
end
function scanParts()
    local parts = {}
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return parts end
    local charSet = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr.Character then
            charSet[plr.Character] = true
        end
    end
    local radius = 1000
    local rawParts = workspace:GetPartBoundsInRadius(root.Position, radius)
    for _, part in ipairs(rawParts) do
        if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(workspace.CurrentCamera) then
            local isCharPart = false
            local p = part.Parent
            while p and p ~= workspace do
                if charSet[p] or p:FindFirstChildOfClass("Humanoid") then
                    isCharPart = true
                    break
                end
                p = p.Parent
            end
            if not isCharPart and string.lower(part.Name) ~= "baseplate" and part.Name ~= "Handle" and part.Name ~= "HumanoidRootPart" and part.Name ~= "Torso" then
                table.insert(parts, part)
            end
        end
    end
    return parts
end
function applyForce(part)
    if not part or not part.Parent then return end
    part.CanCollide = false
    pcall(function() part:BreakJoints() end)
    for _, x in ipairs(part:GetChildren()) do
        if x:IsA("Weld") or x:IsA("WeldConstraint") or x:IsA("ManualWeld") or x:IsA("Motor6D")
            or x:IsA("RopeConstraint") or x:IsA("RodConstraint") or x:IsA("SpringConstraint") or x:IsA("CableConstraint")
            or x:IsA("BodyMover") or x:IsA("RocketPropulsion") or x:IsA("AlignPosition") or x:IsA("Torque") or x:IsA("Attachment")
        then
            pcall(function() x:Destroy() end)
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
function mulaiUnanchor()
    folder = Instance.new("Folder", workspace)
    local part = Instance.new("Part", folder)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    attachment1 = Instance.new("Attachment", part)
    task.spawn(function()
        settings().Physics.AllowSleep = false
        while aktif do
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
function stopUnanchor()
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
        if UnanchorBtn then setButtonActive(UnanchorBtn, true) end
        mulaiUnanchor()
    else
        if UnanchorBtn then setButtonActive(UnanchorBtn, false) end
        stopUnanchor()
    end
    if UnanchorBtn and UnanchorBtn.Parent then
        UnanchorBtn.Text = aktif and "Stop" or "Unanchor"
    end
    if unanchorBtn and unanchorBtn.Parent then
        unanchorBtn.Text = aktif and "Stop" or "Unanchor"
        unanchorBtn.BackgroundColor3 = aktif and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(200, 100, 0)
    end
end
UnanchorBtn.MouseButton1Click:Connect(function()
    toggleUnanchor()
end)
BringPartBtn = createButton("", "BringPart")
local character, humanoidRootPart, head
blackHoleActive = false
scannerBroughtPart = nil
local DescendantAddedConnection
local NetworkConnection
local Folder = Instance.new("Folder", Workspace)
Folder.Name = "BringPartFolder"
local TargetPart = Instance.new("Part", Folder)
TargetPart.Anchored = true
TargetPart.CanCollide = false
TargetPart.Transparency = 1
Attachment1 = Instance.new("Attachment", TargetPart)
local YeetFolder = Instance.new("Folder", Workspace)
YeetFolder.Name = "YeetPartFolder"
local YeetTargetPart = Instance.new("Part", YeetFolder)
YeetTargetPart.Name = "YeetTargetPart"
YeetTargetPart.Anchored = true
YeetTargetPart.CanCollide = false
YeetTargetPart.Transparency = 1
YeetTargetPart.CFrame = CFrame.new(0, -9999, 0)
local YeetAttachment = Instance.new("Attachment", YeetTargetPart)
YeetAttachment.Name = "YeetAttachment"
RunService.RenderStepped:Connect(function()
	if blackHoleActive or scannerBroughtPart or plistSendPartTarget then
		local char = plistSendPartTarget and plistSendPartTarget.Character or LocalPlayer.Character
		local target = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("Head"))
		if target then
			if plistSendPartTarget then
				Attachment1.WorldCFrame = target.CFrame
			else
				Attachment1.WorldCFrame = target.CFrame * CFrame.new(0, 10, 0)
			end
		end
	end
end)
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
function EnableNetwork()
	if NetworkConnection then return end
	NetworkConnection = RunService.Heartbeat:Connect(function()
		pcall(function()
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
		end)
	end)
end
function DisableNetwork()
	if NetworkConnection then
		NetworkConnection:Disconnect()
		NetworkConnection = nil
	end
end
function ForcePart(v)
	if v:IsA("BasePart")
	and not v.Anchored
	and v.Transparency < 1
	and not v.Parent:FindFirstChildOfClass("Humanoid")
	and not v.Parent:FindFirstChild("Head")
	and v.Name ~= "Handle" then
		if v:GetAttribute("ScannerStopped") then return end
		if v:FindFirstChild("BringAlign") then return end
		v.CanCollide = false
		local char = LocalPlayer.Character
		local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
		if hrp then
			v.CFrame = Attachment1.WorldCFrame
		end
		if v:FindFirstChild("BringAttachment") then v:FindFirstChild("BringAttachment"):Destroy() end
		if v:FindFirstChild("BringAlign") then v:FindFirstChild("BringAlign"):Destroy() end
		if v:FindFirstChild("BringTorque") then v:FindFirstChild("BringTorque"):Destroy() end
		local Torque = Instance.new("Torque", v)
		Torque.Name = "BringTorque"
		Torque.Torque = Vector3.new(100000, 100000, 100000)
		local AlignPosition = Instance.new("AlignPosition", v)
		AlignPosition.Name = "BringAlign"
		local Attachment2 = Instance.new("Attachment", v)
		Attachment2.Name = "BringAttachment"
		Torque.Attachment0 = Attachment2
		AlignPosition.MaxForce = math.huge
		AlignPosition.MaxVelocity = math.huge
		AlignPosition.Responsiveness = 200
		AlignPosition.Attachment0 = Attachment2
		AlignPosition.Attachment1 = Attachment1
		v:SetAttribute("WasBrought", true)
	end
end
function YeetPart(v)
	if v:IsA("BasePart") then
		task.spawn(function()
			pcall(function()
				pcall(function() sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge) end)
				pcall(function() v:BreakJoints() end)
				v.CanCollide = false
				v.Anchored = false
				v.CFrame = CFrame.new(99999, 9999, 99999)
				v.AssemblyLinearVelocity = Vector3.new(0, 50000, 0)
				task.wait(0.05)
				v:Destroy()
			end)
		end)
	end
end
function OneTimeUnanchor()
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
					local isCharPart = false
					local p = part.Parent
					while p and p ~= Workspace do
						if p:FindFirstChildOfClass("Humanoid") then
							isCharPart = true
							break
						end
						p = p.Parent
					end
					if not isCharPart then
						part.AssemblyLinearVelocity = Vector3.new(
							math.random(-50, 50),
							math.random(20, 100),
							math.random(-50, 50)
						)
					end
				end
			end
			task.wait(0.2)
		end
		getgenv().UnanchorCooldown = false
	end)
end
local function yeetAllParts()
    if blackHoleActive then
        blackHoleActive = false
        setButtonActive(BringPartBtn, false)
        if DescendantAddedConnection then
            DescendantAddedConnection:Disconnect()
            DescendantAddedConnection = nil
        end
    end
    if plistSendPartTarget then
        stopPlistSendPart()
    end
    if scannerBroughtPart then
        StopScannerBring()
    end
    EnableNetwork()
    local partsToYeet = scanParts()
    if #partsToYeet > 0 then
        task.spawn(function()
            for _, part in ipairs(partsToYeet) do
                task.spawn(function()
                    YeetPart(part)
                end)
            end
        end)
    end
end
function GetAllPartsRecursive(parent)
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
		if MiniBringBtn then
            MiniBringBtn.Text = "Bring Part: ON"
            MiniBringBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
		EnableNetwork()
		if enableNoclip then enableNoclip() end
		character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		head = character:WaitForChild("Head")
		OneTimeUnanchor()
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v:SetAttribute("ScannerStopped", nil)
			end
		end
		task.spawn(function()
			while blackHoleActive do
				for _, v in ipairs(GetAllPartsRecursive(Workspace)) do
					if not blackHoleActive then break end
					if v:GetAttribute("WasBrought") then
						v.Anchored = false
					end
					ForcePart(v)
				end
				task.wait(1.5)
			end
		end)
		if DescendantAddedConnection then DescendantAddedConnection:Disconnect() end
		DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if blackHoleActive and v:IsA("BasePart") then
				if v:GetAttribute("WasBrought") then
					v.Anchored = false
				end
				ForcePart(v)
			end
		end)
	else
		setButtonActive(BringPartBtn, false)
        if MiniBringBtn then
            MiniBringBtn.Text = "Bring Part: OFF"
            MiniBringBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
		if DescendantAddedConnection then
			DescendantAddedConnection:Disconnect()
			DescendantAddedConnection = nil
		end
		if not noclipActive and not flying and disableNoclip then
			disableNoclip()
		end
		for _, v in ipairs(Workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				local torq = v:FindFirstChild("BringTorque")
				local align = v:FindFirstChild("BringAlign")
				local att = v:FindFirstChild("BringAttachment")
				if torq or align or att then
					pcall(function()
						if torq then torq:Destroy() end
						if align then align:Destroy() end
						if att then att:Destroy() end
						v:SetAttribute("WasBrought", true)
						v.Anchored = true
					end)
				end
			end
		end
		DisableNetwork()
	end
end
BringPartBtn.MouseButton1Click:Connect(function()
    toggleBringPart()
end)
AntiLagBtn = createButton("", "Anti Lag")
antiLagActive = false
connections = {}
originalStates = {}
function safeSet(obj, prop, val)
    local success, current = pcall(function() return obj[prop] end)
    if success then
        if not originalStates[obj] then
            originalStates[obj] = {}
        end
        if originalStates[obj][prop] == nil then
            originalStates[obj][prop] = current
        end
        pcall(function() obj[prop] = val end)
    end
end
function makeBurik(v)
    if not antiLagActive then return end
    pcall(function()
        if v:IsA("BasePart") then
            safeSet(v, "Material", Enum.Material.SmoothPlastic)
            safeSet(v, "Reflectance", 0)
            safeSet(v, "CastShadow", false)
            if v:IsA("MeshPart") then
                safeSet(v, "TextureID", "")
                safeSet(v, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif v:IsA("Decal") or v:IsA("Texture") then
            safeSet(v, "Transparency", 1)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                safeSet(v, "Lifetime", NumberRange.new(0))
            end
            safeSet(v, "Enabled", false)
        elseif v:IsA("Explosion") then
            safeSet(v, "BlastPressure", 1)
            safeSet(v, "BlastRadius", 1)
        elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("Highlight") or v:IsA("Clouds") then
            safeSet(v, "Enabled", false)
        elseif v:IsA("Sound") then
            safeSet(v, "Playing", false)
        elseif v:IsA("Light") then
            safeSet(v, "Enabled", false)
        elseif v:IsA("SpecialMesh") then
            safeSet(v, "TextureId", "")
        elseif v:IsA("PostEffect") then
            safeSet(v, "Enabled", false)
        elseif v:IsA("Atmosphere") then
            safeSet(v, "Density", 0)
        elseif v:IsA("Shirt") then
            safeSet(v, "ShirtTemplate", "")
        elseif v:IsA("Pants") then
            safeSet(v, "PantsTemplate", "")
        elseif v:IsA("ShirtGraphic") then
            safeSet(v, "Graphic", "")
        end
    end)
end
function applyAntiLag()
    local l = game.Lighting
    local t = game.Workspace.Terrain
    local function lockLightingAndTerrain()
        safeSet(t, "WaterWaveSize", 0)
        safeSet(t, "WaterWaveSpeed", 0)
        safeSet(t, "WaterReflectance", 0)
        safeSet(t, "WaterTransparency", 0)
        safeSet(t, "Decoration", false)
        safeSet(l, "GlobalShadows", false)
        safeSet(l, "FogEnd", 9e9)
        safeSet(l, "Brightness", 0)
    end
    lockLightingAndTerrain()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    if setfpscap then
        pcall(function() setfpscap(999) end)
    end
    task.spawn(function()
        local targets = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            table.insert(targets, v)
        end
        for _, v in ipairs(l:GetDescendants()) do
            table.insert(targets, v)
        end
        local count = 0
        for _, v in ipairs(targets) do
            if not antiLagActive then break end
            makeBurik(v)
            count = count + 1
            if count % 300 == 0 then
                task.wait()
            end
        end
    end)
    connections[#connections+1] = workspace.DescendantAdded:Connect(function(obj)
        if antiLagActive then
            task.wait(0.1)
            if antiLagActive then
                makeBurik(obj)
            end
        end
    end)
    connections[#connections+1] = l.DescendantAdded:Connect(function(obj)
        if antiLagActive then
            task.wait(0.1)
            if antiLagActive then
                makeBurik(obj)
            end
        end
    end)
    connections[#connections+1] = l.Changed:Connect(function()
        if antiLagActive then
            lockLightingAndTerrain()
        end
    end)
    connections[#connections+1] = t.Changed:Connect(function()
        if antiLagActive then
            lockLightingAndTerrain()
        end
    end)
end
function resetAntiLag()
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
    if setfpscap then
        pcall(function() setfpscap(60) end)
    end
end
function toggleAntiLag(state)
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
BToolsBtn = createButton("", "BTools")
BToolsBtn.Name = "BToolsBtn"
BToolsActive = false
function toggleBTools()
    local backpack = Player:FindFirstChildOfClass("Backpack")
    local char = Player.Character
    local found = false
    local function cleanTools(parent)
        if not parent then return end
        for _, item in ipairs(parent:GetChildren()) do
            if item:IsA("HopperBin") then
                pcall(function() item:Destroy() end)
                found = true
            end
        end
    end
    cleanTools(backpack)
    cleanTools(char)
    if found then
        BToolsActive = false
        setButtonActive(BToolsBtn, false)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "BTools",
                Text = "Dihapus dari inventory",
                Duration = 3
            })
        end)
    else
        BToolsActive = true
        setButtonActive(BToolsBtn, true)
        pcall(function()
            for i = 1, 4 do
                local tool = Instance.new("HopperBin")
                tool.BinType = i
                tool.Parent = backpack
            end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "BTools",
                Text = "BTools diberikan!",
                Duration = 3
            })
        end)
    end
end
BToolsBtn.MouseButton1Click:Connect(toggleBTools)

PartInspectorBtn = createButton("", "Part Inspector")
PartInspectorBtn.Name = "PartInspectorBtn"
partInspectorActive = false
partInspectorConnection = nil
inspectedPart = nil

PartInspectorFrame = nil
PartInspectorTitle = nil
PartInspectorNameVal = nil
PartInspectorClassVal = nil
PartInspectorCollideVal = nil
PartInspectorAnchoredVal = nil
PartInspectorToggleCollideBtn = nil

function createPartInspectorWindow()
    if PartInspectorFrame then return end
    
    PartInspectorFrame = Instance.new("Frame")
    PartInspectorFrame.Size = UDim2.new(0, 260, 0, 200)
    PartInspectorFrame.Position = UDim2.new(0.5, -130, 0.5, -100)
    PartInspectorFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    PartInspectorFrame.BackgroundTransparency = 0.15
    PartInspectorFrame.BorderSizePixel = 0
    PartInspectorFrame.Active = true
    PartInspectorFrame.Visible = false
    PartInspectorFrame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner", PartInspectorFrame)
    corner.CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", PartInspectorFrame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    
    local header = Instance.new("Frame", PartInspectorFrame)
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    header.BorderSizePixel = 0
    makeSmoothDraggable(PartInspectorFrame, header)
    
    local headerCorner = Instance.new("UICorner", header)
    headerCorner.CornerRadius = UDim.new(0, 10)
    
    local headerFix = Instance.new("Frame", header)
    headerFix.Size = UDim2.new(1, 0, 0, 6)
    headerFix.Position = UDim2.new(0, 0, 1, -6)
    headerFix.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    headerFix.BorderSizePixel = 0
    
    PartInspectorTitle = Instance.new("TextLabel", header)
    PartInspectorTitle.Size = UDim2.new(1, -40, 1, 0)
    PartInspectorTitle.Position = UDim2.new(0, 10, 0, 0)
    PartInspectorTitle.BackgroundTransparency = 1
    PartInspectorTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PartInspectorTitle.Font = Enum.Font.GothamBold
    PartInspectorTitle.TextSize = 12
    PartInspectorTitle.TextXAlignment = Enum.TextXAlignment.Left
    addTranslatable(PartInspectorTitle, "Part Inspector")
    
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -26, 0.5, -10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
    
    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0, 20, 0, 20)
    minBtn.Position = UDim2.new(1, -50, 0.5, -10)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)
    
    closeBtn.MouseButton1Click:Connect(function()
        togglePartInspector(false)
    end)
    
    local content = Instance.new("Frame", PartInspectorFrame)
    content.Size = UDim2.new(1, -20, 1, -40)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.BackgroundTransparency = 1
    
    local isMin = false
    minBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        minBtn.Text = isMin and "+" or "-"
        content.Visible = not isMin
        PartInspectorFrame.Size = isMin and UDim2.new(0, 260, 0, 30) or UDim2.new(0, 260, 0, 200)
    end)
    
    local layout = Instance.new("UIListLayout", content)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    
    local function createLabelRow(labelKey, order)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 20)
        row.BackgroundTransparency = 1
        row.LayoutOrder = order
        row.Parent = content
        
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        addTranslatable(lbl, labelKey)
        
        local val = Instance.new("TextLabel", row)
        val.Size = UDim2.new(0.6, 0, 1, 0)
        val.Position = UDim2.new(0.4, 0, 0, 0)
        val.BackgroundTransparency = 1
        val.TextColor3 = Color3.fromRGB(255, 255, 255)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 11
        val.TextXAlignment = Enum.TextXAlignment.Left
        val.Text = "-"
        
        return val
    end
    
    PartInspectorNameVal = createLabelRow("PartName", 1)
    PartInspectorClassVal = createLabelRow("ClassName", 2)
    PartInspectorCollideVal = createLabelRow("Collision", 3)
    PartInspectorAnchoredVal = createLabelRow("Anchored", 4)
    

end

function updateInspectedPartUI()
    if not inspectedPart then return end
    pcall(function()
        PartInspectorNameVal.Text = tostring(inspectedPart.Name)
        PartInspectorClassVal.Text = tostring(inspectedPart.ClassName)
        PartInspectorCollideVal.Text = inspectedPart.CanCollide and (_G.currentLang == "ID" and "Padat (Tidak Nembus)" or "Solid (Can't Clip)") or (_G.currentLang == "ID" and "Nembus (CanCollide OFF)" or "Clip (CanCollide OFF)")
        PartInspectorCollideVal.TextColor3 = inspectedPart.CanCollide and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        PartInspectorAnchoredVal.Text = inspectedPart.Anchored and (_G.currentLang == "ID" and "Ya" or "Yes") or (_G.currentLang == "ID" and "Tidak" or "No")
    end)
end

function togglePartInspector(state)
    if state == nil then
        partInspectorActive = not partInspectorActive
    else
        partInspectorActive = state
    end
    
    if PartInspectorBtn then
        setButtonActive(PartInspectorBtn, partInspectorActive)
    end
    if MiniPartInspectorBtn then
        MiniPartInspectorBtn.Text = partInspectorActive and "Part Inspector: ON" or "Part Inspector: OFF"
        MiniPartInspectorBtn.TextColor3 = partInspectorActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 50, 50)
    end
    
    if partInspectorActive then
        createPartInspectorWindow()
        PartInspectorFrame.Visible = true
        
        local mouse = Players.LocalPlayer:GetMouse()
        if partInspectorConnection then partInspectorConnection:Disconnect() end
        partInspectorConnection = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local target = mouse.Target
                if target and target:IsA("BasePart") then
                    inspectedPart = target
                    updateInspectedPartUI()
                end
            end
        end)
    else
        if partInspectorConnection then
            partInspectorConnection:Disconnect()
            partInspectorConnection = nil
        end
        if PartInspectorFrame then
            PartInspectorFrame.Visible = false
        end
        inspectedPart = nil
    end
end

PartInspectorBtn.MouseButton1Click:Connect(function()
    togglePartInspector()
end)

JumpPowerBtn = createButton("", "Jump Power")
JumpPowerBtn.Name = "JumpPowerBtn"
local desiredJumpPower = 50
local jumpPowerOn = false
do
    JumpPowerBox = Instance.new("TextBox")
    JumpPowerBox.Name = "JumpPowerBox"
    JumpPowerBox.Text = tostring(desiredJumpPower)
    JumpPowerBox.PlaceholderText = "Jump (50-500)"
    JumpPowerBox.Size = UDim2.new(0, 150, 0, 35)
    JumpPowerBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    JumpPowerBox.TextSize = 15
    JumpPowerBox.Font = Enum.Font.GothamBold
    JumpPowerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpPowerBox.ClearTextOnFocus = false
    JumpPowerBox.Parent = ScrollFrame
    local c_jp = Instance.new("UICorner")
    c_jp.CornerRadius = UDim.new(0, 8)
    c_jp.Parent = JumpPowerBox
    local p_jp = Instance.new("UIPadding")
    p_jp.PaddingLeft = UDim.new(0, 12)
    p_jp.Parent = JumpPowerBox
    JumpPowerBox.FocusLost:Connect(function()
        local n = tonumber(JumpPowerBox.Text)
        if n then
            n = math.clamp(n, 50, 500)
            desiredJumpPower = n
            if jumpPowerOn then
                local char = Player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = desiredJumpPower
                end
            end
        end
        JumpPowerBox.Text = tostring(desiredJumpPower)
    end)
end
local jumpTrailPart
local function addJumpTrail(char)
	if jumpTrailPart then
		pcall(function() jumpTrailPart:Destroy() end)
		jumpTrailPart = nil
	end
	for _, p in ipairs(char:GetDescendants()) do
		if p.Name == "JumpTrailAtt" or p.Name == "JumpTrailInst" then
			pcall(function() p:Destroy() end)
		end
	end
	local leftHand = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftHand")
	local rightHand = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
	if not leftHand and not rightHand then return end
	jumpTrailPart = Instance.new("Folder")
	jumpTrailPart.Name = "JumpTrailPart"
	jumpTrailPart.Parent = char
	
	local function createHandTrail(handPart)
		if not handPart then return end
		
		-- Trail 1 (Vertical)
		local attTop1 = Instance.new("Attachment")
		attTop1.Name = "JumpTrailAtt"
		attTop1.Position = Vector3.new(0, 0.6, 0)
		attTop1.Parent = handPart
		local attBottom1 = Instance.new("Attachment")
		attBottom1.Name = "JumpTrailAtt"
		attBottom1.Position = Vector3.new(0, -0.6, 0)
		attBottom1.Parent = handPart
		local newTrail1 = Instance.new("Trail")
		newTrail1.Name = "JumpTrailInst"
		newTrail1.Attachment0 = attTop1
		newTrail1.Attachment1 = attBottom1
		newTrail1.Lifetime = 1.2
		newTrail1.MinLength = 0.05
		newTrail1.LightEmission = 0.1
		newTrail1.Color = ColorSequence.new(Color3.fromRGB(220, 20, 20))
		newTrail1.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(1, 1)
		})
		newTrail1.WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.0),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0)
		})
		newTrail1.Parent = handPart
		
		-- Trail 2 (Horizontal)
		local attTop2 = Instance.new("Attachment")
		attTop2.Name = "JumpTrailAtt"
		attTop2.Position = Vector3.new(0.4, 0, 0)
		attTop2.Parent = handPart
		local attBottom2 = Instance.new("Attachment")
		attBottom2.Name = "JumpTrailAtt"
		attBottom2.Position = Vector3.new(-0.4, 0, 0)
		attBottom2.Parent = handPart
		local newTrail2 = Instance.new("Trail")
		newTrail2.Name = "JumpTrailInst"
		newTrail2.Attachment0 = attTop2
		newTrail2.Attachment1 = attBottom2
		newTrail2.Lifetime = 1.2
		newTrail2.MinLength = 0.05
		newTrail2.LightEmission = 0.1
		newTrail2.Color = ColorSequence.new(Color3.fromRGB(220, 20, 20))
		newTrail2.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(1, 1)
		})
		newTrail2.WidthScale = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1.0),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0)
		})
		newTrail2.Parent = handPart
	end
	
	createHandTrail(leftHand)
	createHandTrail(rightHand)
end
local function removeJumpTrail()
	if jumpTrailPart then
		pcall(function() jumpTrailPart:Destroy() end)
		jumpTrailPart = nil
	end
	local char = Player.Character
	if char then
		for _, p in ipairs(char:GetDescendants()) do
			if p.Name == "JumpTrailAtt" or p.Name == "JumpTrailInst" then
				pcall(function() p:Destroy() end)
			end
		end
	end
end
function toggleJumpPower(state)
    if state == nil then
        jumpPowerOn = not jumpPowerOn
    else
        jumpPowerOn = state
    end
    local char = Player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if jumpPowerOn then
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = desiredJumpPower
        end
        if char then
            addJumpTrail(char)
        end
        setButtonActive(JumpPowerBtn, true)
    else
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = 50
        end
        removeJumpTrail()
        setButtonActive(JumpPowerBtn, false)
    end
end
JumpPowerBtn.MouseButton1Click:Connect(function()
    toggleJumpPower()
end)
JumpPowerShortcutConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.BackSlash then
        toggleJumpPower()
    end
end)
Player.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum and jumpPowerOn then
        task.wait(0.5)
        if jumpPowerOn then
            hum.UseJumpPower = true
            hum.JumpPower = desiredJumpPower
            addJumpTrail(char)
        end
    end
end)
TPToolBtn = createButton("", "TP Tool")
TPToolBtn.Name = "TPToolBtn"
local tpToolActive = false
local function giveTPTool(char)
    local backpack = Player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    if backpack:FindFirstChild("TP Tool") or (char and char:FindFirstChild("TP Tool")) then
        return
    end
    local tool = Instance.new("Tool")
    tool.Name = "TP Tool"
    tool.RequiresHandle = false
    tool.ManualActivationOnly = true
    local toolEquipped = false
    local mouseConn = nil
    tool.Equipped:Connect(function()
        toolEquipped = true
        pcall(function()
            if typeof(updateExternalCursorVisibility) == "function" then
                updateExternalCursorVisibility()
            end
        end)
    end)
    tool.Unequipped:Connect(function()
        toolEquipped = false
        pcall(function()
            if typeof(updateExternalCursorVisibility) == "function" then
                updateExternalCursorVisibility()
            end
        end)
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and toolEquipped and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = Player:GetMouse()
            if mouse then
                local targetPos = mouse.Hit.Position + Vector3.new(0, 3, 0)
                local character = Player.Character
                local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))
                if hrp then
                    if typeof(safeTeleportToCFrame) == "function" then
                        safeTeleportToCFrame(CFrame.new(targetPos))
                    else
                        character:PivotTo(CFrame.new(targetPos))
                    end
                end
            end
        end
    end)
    tool.Parent = backpack
end
local function removeTPTool()
    local backpack = Player:FindFirstChildOfClass("Backpack")
    if backpack then
        local t = backpack:FindFirstChild("TP Tool")
        if t then pcall(function() t:Destroy() end) end
    end
    local char = Player.Character
    if char then
        local t = char:FindFirstChild("TP Tool")
        if t then pcall(function() t:Destroy() end) end
    end
end
function toggleTPTool(state)
    if state == nil then
        tpToolActive = not tpToolActive
    else
        tpToolActive = state
    end
    if tpToolActive then
        giveTPTool(Player.Character)
        setButtonActive(TPToolBtn, true)
    else
        removeTPTool()
        setButtonActive(TPToolBtn, false)
    end
end
TPToolBtn.MouseButton1Click:Connect(function()
    toggleTPTool()
end)
Player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if tpToolActive then
        giveTPTool(char)
    end
end)
ShiftLockBtn = createButton("", "Shift Lock")
shiftLockActive = false
local shiftLockConnection = nil
function toggleShiftLock(state)
    if state == nil then
        shiftLockActive = not shiftLockActive
    else
        shiftLockActive = state
    end
    if shiftLockActive then
        setButtonActive(ShiftLockBtn, true)
        pcall(function()
            if shiftLockConnection then shiftLockConnection:Disconnect() end
            shiftLockConnection = RunService.RenderStepped:Connect(function()
                local character = Player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local camera = workspace.CurrentCamera
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if root and camera and humanoid and humanoid.Health > 0 then
                    local lookVector = camera.CFrame.LookVector
                    local angle = math.atan2(-lookVector.X, -lookVector.Z)
                    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, angle, 0)
                    humanoid.CameraOffset = Vector3.new(1.75, 0, 0)
                    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
                end
            end)
        end)
    else
        setButtonActive(ShiftLockBtn, false)
        if shiftLockConnection then
            pcall(function() shiftLockConnection:Disconnect() end)
            shiftLockConnection = nil
        end
        pcall(function()
            local character = Player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.CameraOffset = Vector3.new(0, 0, 0)
            end
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end)
    end
end
ShiftLockBtn.MouseButton1Click:Connect(function()
    toggleShiftLock()
end)
NoclipBtn = createButton("", "Noclip Ghost")
noclipActive = false
noclipConnection = nil
function enableNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        local char = Player.Character
        if char then
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:FindFirstAncestorOfClass("Accessory") then
                    obj.CanCollide = false
                end
            end
        end
    end)
end
function disableNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local char = Player.Character
    if char then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:FindFirstAncestorOfClass("Accessory") then
                pcall(function() obj.CanCollide = true end)
            end
        end
    end
end
function onCharacterAdded(newCharacter)
    if noclipActive then
        newCharacter:WaitForChild("HumanoidRootPart")
        task.wait(0.5)
        if noclipActive then
            enableNoclip()
        end
    end
end
function toggleNoclip(state)
    if state == nil then
        noclipActive = not noclipActive
    else
        noclipActive = state
    end
    if noclipActive then
        enableNoclip()
        setButtonActive(NoclipBtn, true)
        if MiniNoclipBtn then
            MiniNoclipBtn.Text = "Noclip: ON"
            MiniNoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    else
        disableNoclip()
        setButtonActive(NoclipBtn, false)
        if MiniNoclipBtn then
            MiniNoclipBtn.Text = "Noclip: OFF"
            MiniNoclipBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
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
EmoteBtn = createButton("", "Emotes")
CloneAvatarBtn = createButton("", "Clone Avatar")
FlyV2Btn = createButton("", "Fly V2")
FlyV3Btn = createButton("", "Quick Tools")
RealFlyV3Btn = createButton("", "Fly V3")
ServerHopBtn = createButton("", "Server Hop")
DexBtn = createButton("", "Dex Explorer")
MaxZoomBtn = createButton("", "Max Zoom")
MaxZoomBtn.Name = "MaxZoomBtn"
MaxZoomBtn.MouseButton1Click:Connect(function() toggleMaxZoom() end)
CmdBarBtn = createButton("", "Command Bar")
CmdBarBtn.MouseButton1Click:Connect(function()
    if showCmdBar then
        showCmdBar()
    end
end)
function launchDex()
    local ok, err = pcall(function()
        local success, result = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/bochilascript/ROBLOX/refs/heads/main/dex.lua")
        end)
        if success and result and result ~= "" then
            local func, loadErr = loadstring(result)
            if func then
                func()
            else
                warn("Dex loadstring error: " .. tostring(loadErr))
            end
        else
            warn("Dex HTTP request failed")
        end
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
    local success, err = pcall(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = Workspace.CurrentCamera
local Active = true
local TargetList = {}
local CurrentIndex = 0
local CurrentTarget = nil
local updateProfile
local FlingActive = false
local FlingThread = nil
local OriginalCFrame = nil
local FollowActive = false
local FollowConnection = nil
local FollowAnim = nil
local SendPartActive = false
local SendPartLoopThread = nil
local FreezeConnection = nil
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local NetworkConnection = nil
local COLORS = {
    DARK_BLUE = Color3.fromRGB(15, 15, 15),
    MEDIUM_BLUE = Color3.fromRGB(25, 25, 25),
    LIGHT_BLUE = Color3.fromRGB(255, 255, 255),
    NEON_BLUE = Color3.fromRGB(255, 50, 50),
    DARK_BLACK = Color3.fromRGB(5, 5, 5),
    MEDIUM_BLACK = Color3.fromRGB(15, 15, 15),
    LIGHT_BLACK = Color3.fromRGB(25, 25, 25),
    WHITE = Color3.fromRGB(255, 255, 255),
    GREEN = Color3.fromRGB(0, 150, 50),
    RED = Color3.fromRGB(255, 50, 50),
    GOLD = Color3.fromRGB(255, 215, 0)
}
local humanoid, rootPart
local function refreshCharacterRefs()
    local char = LP.Character
    if char then
        humanoid = char:FindFirstChildOfClass("Humanoid")
        rootPart = char:FindFirstChild("HumanoidRootPart")
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
local function freezeCharacter()
    if FreezeConnection then
        FreezeConnection:Disconnect()
    end
    FreezeConnection = RunService.Heartbeat:Connect(function()
        if humanoid and rootPart then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            pcall(function()
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
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
    if humanoid then
        humanoid.WalkSpeed = OriginalWalkSpeed
        humanoid.JumpPower = OriginalJumpPower
    end
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PIXECUTE SPECTATE"
ScreenGui.ResetOnSpawn = false
local successParent, errParent = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not successParent then
    ScreenGui.Parent = PlayerGui or (game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui"))
end
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(0, 140, 0, 80)
ProfileFrame.Position = UDim2.new(1, -150, 0, 8)
ProfileFrame.BackgroundColor3 = COLORS.DARK_BLACK
ProfileFrame.BackgroundTransparency = 0.1
ProfileFrame.BorderSizePixel = 0
ProfileFrame.Parent = ScreenGui
local ProfileCorner = Instance.new("UICorner", ProfileFrame)
ProfileCorner.CornerRadius = UDim.new(0, 12)
local ProfileStroke = Instance.new("UIStroke")
ProfileStroke.Color = Color3.fromRGB(255, 50, 50)
ProfileStroke.Thickness = 1
ProfileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ProfileStroke.Parent = ProfileFrame
local titleBg = ProfileFrame
local SpectateTitle = Instance.new("TextLabel")
SpectateTitle.Size = UDim2.new(1, 0, 0, 20)
SpectateTitle.Position = UDim2.new(0, 0, 0, 0)
SpectateTitle.BackgroundTransparency = 1
SpectateTitle.Font = Enum.Font.GothamBold
SpectateTitle.TextSize = 10
SpectateTitle.TextColor3 = COLORS.NEON_BLUE
SpectateTitle.Text = "PIXECUTE SPECTATE"
SpectateTitle.TextXAlignment = Enum.TextXAlignment.Center
SpectateTitle.ZIndex = 10
SpectateTitle.Parent = ProfileFrame
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, 140, 0, 180)
ControlsFrame.Position = UDim2.new(1, -150, 0, 100)
ControlsFrame.BackgroundColor3 = COLORS.DARK_BLACK
ControlsFrame.BackgroundTransparency = 0.1
ControlsFrame.BorderSizePixel = 0
ControlsFrame.Parent = ScreenGui
local ControlsCorner = Instance.new("UICorner", ControlsFrame)
ControlsCorner.CornerRadius = UDim.new(0, 12)
local ControlsStroke = Instance.new("UIStroke")
ControlsStroke.Color = Color3.fromRGB(255, 50, 50)
ControlsStroke.Thickness = 1
ControlsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ControlsStroke.Parent = ControlsFrame
local ControlsHeader = Instance.new("TextLabel")
ControlsHeader.Size = UDim2.new(1, 0, 0, 20)
ControlsHeader.Position = UDim2.new(0, 0, 0, 0)
ControlsHeader.BackgroundColor3 = COLORS.DARK_BLUE
ControlsHeader.BorderSizePixel = 0
ControlsHeader.Text = tr("Controls")
ControlsHeader.TextColor3 = COLORS.NEON_BLUE
ControlsHeader.Font = Enum.Font.GothamBold
ControlsHeader.TextSize = 11
ControlsHeader.Parent = ControlsFrame
local HeaderCorner = Instance.new("UICorner", ControlsHeader)
HeaderCorner.CornerRadius = UDim.new(0, 12)
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = ProfileFrame
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 8, 0, 30)
Avatar.BackgroundColor3 = COLORS.MEDIUM_BLACK
Avatar.BorderSizePixel = 0
local AvatarCorner = Instance.new("UICorner", Avatar)
AvatarCorner.CornerRadius = UDim.new(0, 8)
local UserInfoFrame = Instance.new("Frame", ProfileFrame)
UserInfoFrame.Size = UDim2.new(1, -60, 1, -28)
UserInfoFrame.Position = UDim2.new(0, 56, 0, 24)
UserInfoFrame.BackgroundTransparency = 1
local UsernameLabel = Instance.new("TextLabel", UserInfoFrame)
UsernameLabel.Size = UDim2.new(1, 0, 0.4, 0)
UsernameLabel.Position = UDim2.new(0,0,0,0)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextColor3 = COLORS.WHITE
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.TextSize = 12
UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
UsernameLabel.Text = tr("NameLabel")
local AgeLabel = Instance.new("TextLabel", UserInfoFrame)
AgeLabel.Size = UDim2.new(1,0,0.3,0)
AgeLabel.Position = UDim2.new(0,0,0.4,0)
AgeLabel.BackgroundTransparency = 1
AgeLabel.Font = Enum.Font.Gotham
AgeLabel.TextColor3 = COLORS.LIGHT_BLUE
AgeLabel.TextXAlignment = Enum.TextXAlignment.Left
AgeLabel.TextSize = 10
AgeLabel.Text = tr("AgeLabel")
local IdLabel = Instance.new("TextLabel", UserInfoFrame)
IdLabel.Size = UDim2.new(1,0,0.3,0)
IdLabel.Position = UDim2.new(0,0,0.7,0)
IdLabel.BackgroundTransparency = 1
IdLabel.Font = Enum.Font.Gotham
IdLabel.TextColor3 = COLORS.LIGHT_BLUE
IdLabel.TextXAlignment = Enum.TextXAlignment.Left
IdLabel.TextSize = 10
IdLabel.Text = "ID"
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Size = UDim2.new(0, 5, 0, 5)
StatusIndicator.Position = UDim2.new(1, -10, 0, 8)
StatusIndicator.BackgroundColor3 = COLORS.RED
StatusIndicator.BorderSizePixel = 0
StatusIndicator.Parent = ProfileFrame
local StatusCorner = Instance.new("UICorner", StatusIndicator)
StatusCorner.CornerRadius = UDim.new(1, 0)
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
local TeleBtn = createControlButton(ControlsFrame, tr("TeleportBtn"), COLORS.DARK_BLUE, 0.15, "")
local FlingBtn = createControlButton(ControlsFrame, "Fling", COLORS.DARK_BLUE, 0.35, "")
local FollowBtn = createControlButton(ControlsFrame, tr("FollowBtn"), COLORS.DARK_BLUE, 0.55, "")
local SendPartBtn = createControlButton(ControlsFrame, tr("SendPartBtn"), COLORS.DARK_BLUE, 0.75, "")
local SpectatorPlayerListFrame = Instance.new("Frame")
local SearchBox = Instance.new("TextBox")
local SpListScroll = Instance.new("ScrollingFrame")
SpectatorPlayerListFrame.Size = UDim2.new(0, 160, 0, 240)
SpectatorPlayerListFrame.Position = UDim2.new(1, -330, 0, 40)
SpectatorPlayerListFrame.BackgroundColor3 = COLORS.DARK_BLACK
SpectatorPlayerListFrame.BackgroundTransparency = 0.1
SpectatorPlayerListFrame.BorderSizePixel = 0
SpectatorPlayerListFrame.Parent = ScreenGui
local SpListCorner = Instance.new("UICorner", SpectatorPlayerListFrame)
SpListCorner.CornerRadius = UDim.new(0, 12)
local SpListStroke = Instance.new("UIStroke", SpectatorPlayerListFrame)
SpListStroke.Color = COLORS.NEON_BLUE
SpListStroke.Thickness = 2
SearchBox.Size = UDim2.new(1, -10, 0, 24)
SearchBox.Position = UDim2.new(0, 5, 0, 5)
SearchBox.BackgroundColor3 = COLORS.MEDIUM_BLACK
SearchBox.BorderSizePixel = 0
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 10
SearchBox.TextColor3 = COLORS.WHITE
SearchBox.PlaceholderText = tr("SearchPlayers")
SearchBox.PlaceholderColor3 = COLORS.NEON_BLUE
SearchBox.Text = ""
SearchBox.TextXAlignment = Enum.TextXAlignment.Center
SearchBox.Parent = SpectatorPlayerListFrame
local SearchCorner = Instance.new("UICorner", SearchBox)
SearchCorner.CornerRadius = UDim.new(0, 4)
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if refreshSpectatorPlayerList then
        refreshSpectatorPlayerList()
    end
end)
SpListScroll.Size = UDim2.new(1, -10, 1, -40)
SpListScroll.Position = UDim2.new(0, 5, 0, 35)
SpListScroll.BackgroundTransparency = 1
SpListScroll.ScrollBarThickness = 4
SpListScroll.ScrollBarImageColor3 = COLORS.NEON_BLUE
SpListScroll.Parent = SpectatorPlayerListFrame
local SpListLayout = Instance.new("UIListLayout")
SpListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpListLayout.Padding = UDim.new(0, 4)
SpListLayout.Parent = SpListScroll
function refreshSpectatorPlayerList()
    for _, child in ipairs(SpListScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local txt = string.lower(SearchBox.Text)
    local sortedList = {}
    for _, p in ipairs(TargetList) do
        table.insert(sortedList, p)
    end
    local lp = game:GetService("Players").LocalPlayer
    local lpPos = nil
    if lp and lp.Character then
        local lpHrp = lp.Character:FindFirstChild("HumanoidRootPart") or lp.Character:FindFirstChild("Torso")
        if lpHrp then lpPos = lpHrp.Position end
    end
    table.sort(sortedList, function(a, b)
        local distA, distB = math.huge, math.huge
        if lpPos then
            if a.Character then
                local aHrp = a.Character:FindFirstChild("HumanoidRootPart") or a.Character:FindFirstChild("Torso")
                if aHrp then distA = (aHrp.Position - lpPos).Magnitude end
            end
            if b.Character then
                local bHrp = b.Character:FindFirstChild("HumanoidRootPart") or b.Character:FindFirstChild("Torso")
                if bHrp then distB = (bHrp.Position - lpPos).Magnitude end
            end
        end
        local aIsDetected = (distA ~= math.huge)
        local bIsDetected = (distB ~= math.huge)
        if aIsDetected ~= bIsDetected then
            return aIsDetected
        end
        if aIsDetected and bIsDetected then
            if math.abs(distA - distB) > 0.1 then
                return distA < distB
            end
        end
        return string.lower(a.DisplayName) < string.lower(b.DisplayName)
    end)
        local ySize = 0
    local urutan = 0
    for _, p in ipairs(sortedList) do
        local i = table.find(TargetList, p)
        if txt == "" or string.find(string.lower(p.Name), txt, 1, true) or string.find(string.lower(p.DisplayName), txt, 1, true) then
            urutan = urutan + 1
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.BackgroundColor3 = COLORS.MEDIUM_BLACK
            btn.TextColor3 = COLORS.WHITE
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 10
            local prefix = "⚫ "
            pcall(function()
                local lp = game:GetService("Players").LocalPlayer
                local lpPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
                local tHrp = p.Character and (p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso"))
                if tHrp then
                    if lpPos then
                        local dist = math.floor((lpPos - tHrp.Position).Magnitude)
                        prefix = "🟢 [" .. dist .. "m] "
                    else
                        prefix = "🟢 "
                    end
                end
            end)
            btn.Text = " " .. prefix .. p.DisplayName .. " (@" .. p.Name .. ")"
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.LayoutOrder = urutan
            btn.Parent = SpListScroll
            if p == CurrentTarget then
                btn.BackgroundColor3 = COLORS.DARK_BLUE
                btn.TextColor3 = COLORS.NEON_BLUE
            end
            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 4)
            btn.MouseButton1Click:Connect(function()
                if CurrentTarget ~= p then
                    CurrentTarget = p
                    CurrentIndex = table.find(TargetList, p) or 1
                    updateProfile(CurrentTarget)
                    if FollowActive then stopFollow() end
                    refreshSpectatorPlayerList()
                end
            end)
            ySize = ySize + 29
        end
    end
    SpListScroll.CanvasSize = UDim2.new(0, 0, 0, ySize)
end
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
    button.MouseEnter:Connect(function()
        local hoverColor = isClose and Color3.fromRGB(255, 100, 100) or COLORS.MEDIUM_BLUE
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = buttonColor}):Play()
    end)
    return button
end
local PrevBtn = createNavButton3D(BottomFrame, tr("PrevBtn"), 0.05, "", false)
local CloseNavBtn = createNavButton3D(BottomFrame, tr("CloseBtn"), 0.35, "", true)
local NextBtn = createNavButton3D(BottomFrame, tr("NextBtn"), 0.65, "", false)
local function openProfileFrame()
    TweenService:Create(ProfileFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 140, 0, 80)
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
updateProfile = function(plr)
    if ProfileFrame.BackgroundTransparency == 1 then
        openProfileFrame()
    end
    if plr and plr:IsA("Player") then
        UsernameLabel.Text = plr.Name
        AgeLabel.Text = string.format(tr("AgeDaysLabel"), tostring(plr.AccountAge or 0))
        IdLabel.Text = "ID: " .. tostring(plr.UserId)
        StatusIndicator.BackgroundColor3 = COLORS.GREEN
        task.spawn(function()
            TweenService:Create(UsernameLabel, TweenInfo.new(0.3), {TextColor3 = COLORS.GREEN}):Play()
            task.wait(0.3)
            TweenService:Create(UsernameLabel, TweenInfo.new(0.3), {TextColor3 = COLORS.NEON_BLUE}):Play()
        end)
        pcall(function()
            Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=150&height=150&format=png"
        end)
    else
        UsernameLabel.Text = tr("NameLabel")
        AgeLabel.Text = tr("AgeLabel")
        IdLabel.Text = "ID"
        Avatar.Image = ""
        UsernameLabel.TextColor3 = COLORS.NEON_BLUE
        StatusIndicator.BackgroundColor3 = COLORS.RED
    end
    if typeof(refreshSpectatorPlayerList) == "function" then
        refreshSpectatorPlayerList()
    end
end
local function turnOffSendPart()
    SendPartActive = false
    if SendPartLoopThread then
        pcall(function() task.cancel(SendPartLoopThread) end)
        SendPartLoopThread = nil
    end
    pcall(function()
        SendPartBtn.Text = tr("SendPartBtn")
        TweenService:Create(SendPartBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
    end)
    unfreezeCharacter()
end
SendPartBtn.MouseButton1Click:Connect(function()
    if SendPartActive then
        turnOffSendPart()
        return
    end
    SendPartActive = true
    SendPartBtn.Text = tr("SendingOnBtn")
    TweenService:Create(SendPartBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.GREEN}):Play()
    freezeCharacter()
    if SendPartLoopThread then
        pcall(function() task.cancel(SendPartLoopThread) end)
    end
    SendPartLoopThread = task.spawn(function()
        if CurrentTarget and CurrentTarget.Character then
            pcall(function()
                sendUnanchoredPartsToTarget(CurrentTarget)
            end)
        end
        task.wait(3)
        turnOffSendPart()
    end)
end)
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
                if refreshSpectatorPlayerList then refreshSpectatorPlayerList() end
                return
            end
        end
    end
    if CurrentIndex < 1 or CurrentIndex > #TargetList then
        CurrentIndex = 1
    end
    CurrentTarget = TargetList[CurrentIndex]
    updateProfile(CurrentTarget)
    if refreshSpectatorPlayerList then refreshSpectatorPlayerList() end
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
        if SendPartActive then
            turnOffSendPart()
        end
    end
end)
PrevBtn.MouseButton1Click:Connect(function()
    if #TargetList == 0 then safeRefreshTargetList() end
    if #TargetList == 0 then return end
    local nextIndex = CurrentIndex - 1
    if nextIndex < 1 then nextIndex = #TargetList end
    if nextIndex >= 1 and nextIndex <= #TargetList then
        CurrentIndex = nextIndex
        CurrentTarget = TargetList[CurrentIndex]
        updateProfile(CurrentTarget)
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
        openProfileFrame()
    end
end)
RunService.RenderStepped:Connect(function()
    if not Active then return end
    if CurrentTarget and CurrentTarget.Character then
        local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            Cam.CameraSubject = hrp
        end
    end
end)
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
FlingBtn.MouseButton1Click:Connect(function()
    if not CurrentTarget then return end
    local lpHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local tHrp = CurrentTarget.Character and (CurrentTarget.Character:FindFirstChild("HumanoidRootPart") or CurrentTarget.Character:FindFirstChild("Torso"))
    if not lpHRP or not tHrp then return end
    task.spawn(function()
        FlingBtn.Text = "Flinging..."
        TweenService:Create(FlingBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.RED}):Play()
        local origCF = lpHRP.CFrame
        local origGrav = workspace.Gravity
        workspace.Gravity = 0
        local flingPart = Instance.new("Part")
        flingPart.Anchored = false
        flingPart.CanCollide = false
        flingPart.Transparency = 1
        flingPart.Size = Vector3.new(1, 1, 1)
        flingPart.CFrame = lpHRP.CFrame
        flingPart.Parent = workspace
        local flingWeld = Instance.new("WeldConstraint")
        flingWeld.Part0 = flingPart
        flingWeld.Part1 = lpHRP
        flingWeld.Parent = flingPart
        local BV = Instance.new("BodyVelocity")
        BV.Parent = flingPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local myHum = LP.Character:FindFirstChildOfClass("Humanoid")
        if myHum then
            myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        end
        local startFling = tick()
        local angle = 0
        while tick() - startFling < 2.0 and tHrp and tHrp.Parent do
            angle = angle + 100
            pcall(function()
                local offset = CFrame.new(0, 0.5, 0)
                if angle % 400 == 0 then
                    offset = CFrame.new(0, 1.5, 0)
                elseif angle % 400 == 100 then
                    offset = CFrame.new(0, -1.5, 0)
                elseif angle % 400 == 200 then
                    offset = CFrame.new(2.25, 1.5, -2.25)
                elseif angle % 400 == 300 then
                    offset = CFrame.new(-2.25, -1.5, 2.25)
                end
                lpHRP.CFrame = tHrp.CFrame * offset * CFrame.Angles(math.rad(angle), 0, 0)
                flingPart.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
                flingPart.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
            end)
            RunService.Heartbeat:Wait()
        end
        task.wait(0.1)
        workspace.Gravity = origGrav
        if myHum then
            myHum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        end
        pcall(function() flingPart:Destroy() end)
        pcall(function()
            lpHRP.Anchored = true
            lpHRP.AssemblyLinearVelocity = Vector3.zero
            lpHRP.AssemblyAngularVelocity = Vector3.zero
            lpHRP.CFrame = origCF
            task.wait(0.1)
            lpHRP.Anchored = false
        end)
        FlingBtn.Text = "Fling"
        TweenService:Create(FlingBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
    end)
end)
local function stopFollow()
    FollowActive = false
    if FollowConnection then FollowConnection:Disconnect() FollowConnection = nil end
    if FollowAnim then pcall(function() FollowAnim:Stop() end) FollowAnim = nil end
    FollowBtn.Text = tr("FollowBtn")
    TweenService:Create(FollowBtn, TweenInfo.new(0.3), {BackgroundColor3 = COLORS.DARK_BLUE}):Play()
end
local function startFollowToTarget(target)
    if not target or not rootPart or not humanoid then return end
    FollowActive = true
    FollowBtn.Text = tr("FollowingBtn")
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
CloseNavBtn.MouseButton1Click:Connect(function()
    TweenService:Create(ProfileFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(ControlsFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(BottomFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    pcall(function()
        TweenService:Create(SpectatorPlayerListFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    end)
    pcall(function()
        TweenService:Create(titleBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(titleStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        TweenService:Create(SpectateTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    end)
    task.wait(0.4)
    Active = false
    SendPartActive = false
    unfreezeCharacter()
    if FollowConnection then FollowConnection:Disconnect() FollowConnection = nil end
    if FollowAnim then pcall(function() FollowAnim:Stop() end) FollowAnim = nil end
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        Cam.CameraSubject = LP.Character:FindFirstChild("Humanoid")
    end
    pcall(function() ScreenGui:Destroy() end)
end)
task.defer(function()
    refreshTargetList()
    if #TargetList > 0 then
        CurrentIndex = 1
        CurrentTarget = TargetList[1]
        updateProfile(CurrentTarget)
    end
end)
    end)
    if not success then
        warn("Spectator error: " .. tostring(err))
    end
end
SpectatorBtn.MouseButton1Click:Connect(launchSpectator)
ServerHopBtn.MouseButton1Click:Connect(serverhop)
function launchAnimasi()
    local success, err = pcall(function()
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local getAnimateFolder, applyAnimation, captureDefaultAnimations, createAnimationButton
local defaultAnimationIds = nil
getAnimateFolder = function(character)
    if not character then
        return nil
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        wait(0.5)
        humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return nil
        end
    end
    local animate = humanoid:FindFirstChild("Animate")
    if not animate then
        animate = character:FindFirstChild("Animate")
    end
    if not animate then
        animate = Instance.new("Folder")
        animate.Name = "Animate"
        animate.Parent = humanoid
        local animateScript = Instance.new("Script")
        animateScript.Name = "Animate"
        animateScript.Source = [[
            local Figure = script.Parent.Parent
            local Torso = Figure:WaitForChild("Torso")
            local RightShoulder = Torso:WaitForChild("Right Shoulder")
            local LeftShoulder = Torso:WaitForChild("Left Shoulder")
            local RightHip = Torso:WaitForChild("Right Hip")
            local LeftHip = Torso:WaitForChild("Left Hip")
            local Neck = Torso:WaitForChild("Neck")
            local Humanoid = Figure:WaitForChild("Humanoid")
            local pose = "Standing"
            function createAnimation(id)
                local animation = Instance.new("Animation")
                animation.AnimationId = id
                return animation
            end
            script.Parent.Animate.Disabled = false
        ]]
        animateScript.Parent = animate
    end
    return animate
end
applyAnimation = function(animate, animationData)
    if not animate then
        return false
    end
    local success = true
    local function setAnimation(part, animationId)
        if part and part:IsA("Animation") then
            pcall(function()
                part.AnimationId = animationId
            end)
        end
    end
    if animate.idle then
        setAnimation(animate.idle.Animation1, animationData.idle1)
        setAnimation(animate.idle.Animation2, animationData.idle2)
    end
    if animate.walk then
        if animate.walk.WalkAnim then
            setAnimation(animate.walk.WalkAnim, animationData.walk)
        elseif animate.walk.walk then
            setAnimation(animate.walk.walk, animationData.walk)
        end
    end
    if animate.run then
        if animate.run.RunAnim then
            setAnimation(animate.run.RunAnim, animationData.run)
        elseif animate.run.run then
            setAnimation(animate.run.run, animationData.run)
        elseif animate.run.Animation then
            setAnimation(animate.run.Animation, animationData.run)
        end
    end
    if animate.jump then
        if animate.jump.JumpAnim then
            setAnimation(animate.jump.JumpAnim, animationData.jump)
        elseif animate.jump.jump then
            setAnimation(animate.jump.jump, animationData.jump)
        end
    end
    if animate.climb and animate.climb.ClimbAnim then
        setAnimation(animate.climb.ClimbAnim, animationData.climb)
    end
    if animate.fall then
        if animate.fall.FallAnim then
            setAnimation(animate.fall.FallAnim, animationData.fall)
        elseif animate.fall.fall then
            setAnimation(animate.fall.fall, animationData.fall)
        end
    end
    return success
end
captureDefaultAnimations = function(animate)
    if defaultAnimationIds then return end
    local data = {}
    local function getAnimationId(part)
        if part and part:IsA("Animation") then
            return part.AnimationId
        end
        return nil
    end
    if animate:FindFirstChild("idle") then
        data.idle1 = getAnimationId(animate.idle:FindFirstChild("Animation1"))
        data.idle2 = getAnimationId(animate.idle:FindFirstChild("Animation2"))
    end
    if animate:FindFirstChild("walk") then
        data.walk = getAnimationId(animate.walk:FindFirstChild("WalkAnim") or animate.walk:FindFirstChild("walk"))
    end
    if animate:FindFirstChild("run") then
        data.run = getAnimationId(animate.run:FindFirstChild("RunAnim") or animate.run:FindFirstChild("run") or animate.run:FindFirstChild("Animation"))
    end
    if animate:FindFirstChild("jump") then
        data.jump = getAnimationId(animate.jump:FindFirstChild("JumpAnim") or animate.jump:FindFirstChild("jump"))
    end
    if animate:FindFirstChild("climb") then
        data.climb = getAnimationId(animate.climb:FindFirstChild("ClimbAnim"))
    end
    if animate:FindFirstChild("fall") then
        data.fall = getAnimationId(animate.fall:FindFirstChild("FallAnim") or animate.fall:FindFirstChild("fall"))
    end
    if data.idle1 or data.walk or data.run then
        defaultAnimationIds = data
    end
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = PlayerGui
ScreenGui.Enabled = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "AnimationMenu"
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 320)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = MainFrame
local mainBorder = Instance.new("UIStroke")
mainBorder.Color = Color3.fromRGB(255, 255, 255)
mainBorder.Thickness = 2
mainBorder.Parent = MainFrame
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(255, 255, 255)
shadow.ImageTransparency = 0.95
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = MainFrame
shadow.ZIndex = -1
local Navbar = Instance.new("Frame")
Navbar.Size = UDim2.new(1, 0, 0, 50)
Navbar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Navbar.BackgroundTransparency = 0.1
Navbar.Parent = MainFrame
local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 12)
navCorner.Parent = Navbar
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -60, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PIXECUTE ANIMASI"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 16
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Navbar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.95, -65, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
MinimizeBtn.Text = "-"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Parent = Navbar
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = MinimizeBtn
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.95, -30, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Navbar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -110)
ScrollFrame.Position = UDim2.new(0, 5, 0, 100)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)
local bundleInput = Instance.new("TextBox")
bundleInput.Size = UDim2.new(0.7, -15, 0, 30)
bundleInput.Position = UDim2.new(0, 10, 0, 60)
bundleInput.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
bundleInput.BackgroundTransparency = 0.1
bundleInput.PlaceholderText = "Bundle ID (cth: 33)"
bundleInput.Text = ""
bundleInput.TextSize = 12
bundleInput.Font = Enum.Font.GothamMedium
bundleInput.TextColor3 = Color3.fromRGB(255,255,255)
bundleInput.Parent = MainFrame
Instance.new("UICorner", bundleInput).CornerRadius = UDim.new(0, 6)
local bundleLoadBtn = Instance.new("TextButton")
bundleLoadBtn.Size = UDim2.new(0.3, -5, 0, 30)
bundleLoadBtn.Position = UDim2.new(0.7, 5, 0, 60)
bundleLoadBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bundleLoadBtn.Text = "Load"
bundleLoadBtn.Font = Enum.Font.GothamBold
bundleLoadBtn.TextSize = 12
bundleLoadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bundleLoadBtn.Parent = MainFrame
Instance.new("UICorner", bundleLoadBtn).CornerRadius = UDim.new(0, 6)
bundleLoadBtn.MouseButton1Click:Connect(function()
    local bundleId = tonumber(bundleInput.Text)
    if not bundleId then return end
    bundleLoadBtn.Text = "Loading..."
    task.spawn(function()
        local BundleMapping = {
            [33] = "Vampire",
            [27] = "Ninja",
            [26] = "Superhero",
            [28] = "Zombie",
            [29] = "Penyihir",
            [32] = "Robot",
            [31] = "Mainan",
            [30] = "Penatua",
            [34] = "Levitasi",
            [25] = "Astronaut",
            [35] = "Manusia Serigala",
            [36] = "Ksatria",
            [37] = "Bajak Laut",
            [82] = "Bergaya",
            [81] = "Sekolah Tua",
            [83] = "Retro",
            [84] = "Putri",
            [85] = "Cowboy",
            [86] = "Patrol",
            [87] = "Sneaky",
        }
        local mappedName = BundleMapping[bundleId]
        if mappedName and AnimationData[mappedName] then
            local customPack = AnimationData[mappedName]
            local character = Player.Character
            if character then
                local animate = getAnimateFolder(character)
                if animate then
                    captureDefaultAnimations(animate)
                    applyAnimation(animate, customPack)
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local animator = humanoid:FindFirstChildOfClass("Animator")
                        if animator then
                            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                track:Stop(0.1)
                            end
                        end
                    end
                    if activeButton then
                        resetButtonToNormal(activeButton)
                    end
                    activeButton = nil
                    currentAnimation = mappedName
                    for _, child in ipairs(ScrollFrame:GetChildren()) do
                        if child:IsA("Frame") and child.Name == mappedName then
                            activeButton = child
                            local button = child.Button
                            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            button.TextColor3 = Color3.fromRGB(15, 15, 15)
                            break
                        end
                    end
                end
            end
            bundleLoadBtn.Text = "Loaded!"
            task.wait(1.5)
            bundleLoadBtn.Text = "Load"
            return
        end
        local AssetService = game:GetService("AssetService")
        local success, data = pcall(function()
            return AssetService:GetBundleDetailsAsync(bundleId)
        end)
        if success and data and data.Items then
            local customPack = {}
            local count = 0
            for _, item in ipairs(data.Items) do
                if item.Id then
                    local name = string.lower(item.Name or "")
                    local resolvedId = nil
                    local resolvedId = resolveCatalogAnimationId(item.Id)
                    if string.find(name, "idle") then
                        if not customPack.idle1 then
                            customPack.idle1 = resolvedId
                        else
                            customPack.idle2 = resolvedId
                        end
                        count = count + 1
                    elseif string.find(name, "walk") then
                        customPack.walk = resolvedId
                        count = count + 1
                    elseif string.find(name, "run") then
                        customPack.run = resolvedId
                        count = count + 1
                    elseif string.find(name, "jump") then
                        customPack.jump = resolvedId
                        count = count + 1
                    elseif string.find(name, "climb") then
                        customPack.climb = resolvedId
                        count = count + 1
                    elseif string.find(name, "fall") then
                        customPack.fall = resolvedId
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                local character = Player.Character
                if character then
                    local animate = getAnimateFolder(character)
                    if animate then
                        captureDefaultAnimations(animate)
                        applyAnimation(animate, customPack)
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local animator = humanoid:FindFirstChildOfClass("Animator")
                            if animator then
                                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                                    track:Stop(0.1)
                                end
                            end
                        end
                        local bundleName = data.Name or ("Bundle " .. bundleId)
                        AnimationData[bundleName] = customPack
                        local newBtn = createAnimationButton(bundleName, customPack)
                        newBtn.Parent = ScrollFrame
                        if activeButton then
                            resetButtonToNormal(activeButton)
                        end
                        activeButton = newBtn
                        currentAnimation = bundleName
                        local button = newBtn.Button
                        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        button.TextColor3 = Color3.fromRGB(15, 15, 15)
                    end
                end
                bundleLoadBtn.Text = "Loaded!"
            else
                bundleLoadBtn.Text = "No Anims"
            end
        else
            bundleLoadBtn.Text = "Error Load"
        end
        task.wait(1.5)
        bundleLoadBtn.Text = "Load"
    end)
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
local isMinimized = false
local normalSize = UDim2.new(0, 300, 0, 320)
local minimizedSize = UDim2.new(0, 300, 0, 50)
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MinimizeBtn.Text = "+"
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize})
        tween:Play()
        ScrollFrame.Visible = false
    else
        MinimizeBtn.Text = "-"
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize})
        tween:Play()
        task.delay(0.1, function()
            if not isMinimized then
                ScrollFrame.Visible = true
            end
        end)
    end
end)
AnimationData = {
     ["Retro"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921258489",
        idle2 = "http://www.roblox.com/asset/?id=10921259953",
        walk = "http://www.roblox.com/asset/?id=10921269718",
        run = "http://www.roblox.com/asset/?id=10921261968",
        jump = "http://www.roblox.com/asset/?id=10921263860",
        climb = "http://www.roblox.com/asset/?id=10921257536",
        fall = "http://www.roblox.com/asset/?id=10921262864"
    },
    ["Komunitas Adidas"] = {
        idle1 = "rbxassetid://122257458498464",
        idle2 = "rbxassetid://102357151005774",
        walk = "rbxassetid://122150855457006",
        run = "rbxassetid://82598234841035",
        jump = "rbxassetid://75290611992385",
        climb = "rbxassetid://88763136693023",
        fall = "rbxassetid://98600215928904"
    },
    ["Catwalk Glam"] = {
        idle1 = "http://www.roblox.com/asset/?id=133806214992291",
        idle2 = "http://www.roblox.com/asset/?id=94970088341563",
        walk = "http://www.roblox.com/asset/?id=109168724482748",
        run = "http://www.roblox.com/asset/?id=81024476153754",
        jump = "http://www.roblox.com/asset/?id=116936326516985",
        climb = "http://www.roblox.com/asset/?id=119377220967554",
        fall = "http://www.roblox.com/asset/?id=92294537340807"
    },
    ["Penjahat Populer"] = {
        idle1 = "http://www.roblox.com/asset/?id=118832222982049",
        idle2 = "http://www.roblox.com/asset/?id=76049494037641",
        walk = "http://www.roblox.com/asset/?id=92072849924640",
        run = "http://www.roblox.com/asset/?id=72301599441680",
        jump = "http://www.roblox.com/asset/?id=104325245285198",
        climb = "http://www.roblox.com/asset/?id=131326830509784",
        fall = "http://www.roblox.com/asset/?id=121152442762481"
    },
    ["NFL"] = {
        idle1 = "http://www.roblox.com/asset/?id=92080889861410",
        idle2 = "http://www.roblox.com/asset/?id=74451233229259",
        walk = "http://www.roblox.com/asset/?id=110358958299415",
        run = "http://www.roblox.com/asset/?id=117333533048078",
        jump = "http://www.roblox.com/asset/?id=119846112151352",
        climb = "http://www.roblox.com/asset/?id=134630013742019",
        fall = "http://www.roblox.com/asset/?id=129773241321032"
    },
    ["Tidak Ada Batas"] = {
        idle1 = "http://www.roblox.com/asset/?id=92080889861410",
        idle2 = "http://www.roblox.com/asset/?id=74451233229259",
        walk = "http://www.roblox.com/asset/?id=110358958299415",
        run = "http://www.roblox.com/asset/?id=117333533048078",
        jump = "http://www.roblox.com/asset/?id=119846112151352",
        climb = "http://www.roblox.com/asset/?id=134630013742019",
        fall = "http://www.roblox.com/asset/?id=129773241321032"
    },
    ["Olahraga Adidas"] = {
        idle1 = "http://www.roblox.com/asset/?id=18537376492",
        idle2 = "http://www.roblox.com/asset/?id=18537371272",
        walk = "http://www.roblox.com/asset/?id=18537392113",
        run = "http://www.roblox.com/asset/?id=18537384940",
        jump = "http://www.roblox.com/asset/?id=18537380791",
        climb = "http://www.roblox.com/asset/?id=18537363391",
        fall = "http://www.roblox.com/asset/?id=18537367238"
    },
    ["Tebal oleh E.L.F"] = {
        idle1 = "http://www.roblox.com/asset/?id=16738333868",
        idle2 = "http://www.roblox.com/asset/?id=16738334710",
        walk = "http://www.roblox.com/asset/?id=16738340646",
        run = "http://www.roblox.com/asset/?id=16738337225",
        jump = "http://www.roblox.com/asset/?id=16738336650",
        climb = "http://www.roblox.com/asset/?id=16738332169",
        fall = "http://www.roblox.com/asset/?id=16738333171"
    },
    ["Bergaya"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921272275",
        idle2 = "http://www.roblox.com/asset/?id=10921273958",
        walk = "http://www.roblox.com/asset/?id=10921283326",
        run = "http://www.roblox.com/asset/?id=10921276116",
        jump = "http://www.roblox.com/asset/?id=10921279832",
        climb = "http://www.roblox.com/asset/?id=10921271391",
        fall = "http://www.roblox.com/asset/?id=10921278648"
    },
    ["Sekolah Tua"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921230744",
        idle2 = "http://www.roblox.com/asset/?id=10921232093",
        walk = "http://www.roblox.com/asset/?id=10921244891",
        run = "http://www.roblox.com/asset/?id=10921240218",
        jump = "http://www.roblox.com/asset/?id=10921242013",
        climb = "http://www.roblox.com/asset/?id=10921229866",
        fall = "http://www.roblox.com/asset/?id=10921241244"
    },
    ["Vampire"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921315373",
        idle2 = "http://www.roblox.com/asset/?id=10921316709",
        walk = "http://www.roblox.com/asset/?id=10921326949",
        run = "http://www.roblox.com/asset/?id=10921320299",
        jump = "http://www.roblox.com/asset/?id=10921322186",
        climb = "http://www.roblox.com/asset/?id=10921314188",
        fall = "http://www.roblox.com/asset/?id=10921321317"
    },
    ["Superhero"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921315373",
        idle2 = "http://www.roblox.com/asset/?id=10921316709",
        walk = "http://www.roblox.com/asset/?id=10921326949",
        run = "http://www.roblox.com/asset/?id=10921320299",
        jump = "http://www.roblox.com/asset/?id=10921322186",
        climb = "http://www.roblox.com/asset/?id=10921314188",
        fall = "http://www.roblox.com/asset/?id=10921321317"
    },
    ["Ninja"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921155160",
        idle2 = "http://www.roblox.com/asset/?id=10921155867",
        walk = "http://www.roblox.com/asset/?id=10921162768",
        run = "http://www.roblox.com/asset/?id=10921157929",
        jump = "http://www.roblox.com/asset/?id=10921160088",
        climb = "http://www.roblox.com/asset/?id=10921154678",
        fall = "http://www.roblox.com/asset/?id=10921159222"
    },
    ["Bubby"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921155160",
        idle2 = "http://www.roblox.com/asset/?id=10921155867",
        walk = "http://www.roblox.com/asset/?id=10921162768",
        run = "http://www.roblox.com/asset/?id=10921157929",
        jump = "http://www.roblox.com/asset/?id=10921160088",
        climb = "http://www.roblox.com/asset/?id=10921154678",
        fall = "http://www.roblox.com/asset/?id=10921159222"
    },
    ["Cartoon"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921071918",
        idle2 = "http://www.roblox.com/asset/?id=10921072875",
        walk = "http://www.roblox.com/asset/?id=10921082452",
        run = "http://www.roblox.com/asset/?id=10921076136",
        jump = "http://www.roblox.com/asset/?id=10921078135",
        climb = "http://www.roblox.com/asset/?id=10921070953",
        fall = "http://www.roblox.com/asset/?id=10921077030"
    },
    ["Zombie"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921344533",
        idle2 = "http://www.roblox.com/asset/?id=10921345304",
        walk = "http://www.roblox.com/asset/?id=10921355261",
        run = "http://www.roblox.com/asset/?id=616163682",
        jump = "http://www.roblox.com/asset/?id=10921351278",
        climb = "http://www.roblox.com/asset/?id=10921343576",
        fall = "http://www.roblox.com/asset/?id=10921350320"
    },
    ["Penyihir"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921144709",
        idle2 = "http://www.roblox.com/asset/?id=10921145797",
        walk = "http://www.roblox.com/asset/?id=10921152678",
        run = "http://www.roblox.com/asset/?id=10921148209",
        jump = "http://www.roblox.com/asset/?id=10921149743",
        climb = "http://www.roblox.com/asset/?id=10921143404",
        fall = "http://www.roblox.com/asset/?id=10921148939"
    },
    ["Robot"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921248039",
        idle2 = "http://www.roblox.com/asset/?id=10921248831",
        walk = "http://www.roblox.com/asset/?id=10921255446",
        run = "http://www.roblox.com/asset/?id=10921250460",
        jump = "http://www.roblox.com/asset/?id=10921252123",
        climb = "http://www.roblox.com/asset/?id=10921247141",
        fall = "http://www.roblox.com/asset/?id=10921251156"
    },
    ["Mainan"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921301576",
        idle2 = "http://www.roblox.com/asset/?id=10921302207",
        walk = "http://www.roblox.com/asset/?id=10921312010",
        run = "http://www.roblox.com/asset/?id=10921306285",
        jump = "http://www.roblox.com/asset/?id=10921308158",
        climb = "http://www.roblox.com/asset/?id=10921300839",
        fall = "http://www.roblox.com/asset/?id=10921307241"
    },
    ["Penatua"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921101664",
        idle2 = "http://www.roblox.com/asset/?id=10921102574",
        walk = "http://www.roblox.com/asset/?id=10921111375",
        run = "http://www.roblox.com/asset/?id=10921104374",
        jump = "http://www.roblox.com/asset/?id=10921107367",
        climb = "http://www.roblox.com/asset/?id=10921100400",
        fall = "http://www.roblox.com/asset/?id=10921105765"
    },
    ["Levitasi"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921132962",
        idle2 = "http://www.roblox.com/asset/?id=10921133721",
        walk = "http://www.roblox.com/asset/?id=10921140719",
        run = "http://www.roblox.com/asset/?id=10921135644",
        jump = "http://www.roblox.com/asset/?id=10921137402",
        climb = "http://www.roblox.com/asset/?id=10921132092",
        fall = "http://www.roblox.com/asset/?id=10921136539"
    },
    ["Astronaut"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921034824",
        idle2 = "http://www.roblox.com/asset/?id=10921036806",
        walk = "http://www.roblox.com/asset/?id=10921046031",
        run = "http://www.roblox.com/asset/?id=10921039308",
        jump = "http://www.roblox.com/asset/?id=10921042494",
        climb = "http://www.roblox.com/asset/?id=10921032124",
        fall = "http://www.roblox.com/asset/?id=10921040576"
    },
    ["Manusia Serigala"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921330408",
        idle2 = "http://www.roblox.com/asset/?id=10921333667",
        walk = "http://www.roblox.com/asset/?id=10921342074",
        run = "http://www.roblox.com/asset/?id=10921336997",
        jump = "http://www.roblox.com/asset/?id=1083218792",
        climb = "http://www.roblox.com/asset/?id=10921329322",
        fall = "http://www.roblox.com/asset/?id=10921337907"
    },
    ["Ksatria"] = {
        idle1 = "http://www.roblox.com/asset/?id=10921117521",
        idle2 = "http://www.roblox.com/asset/?id=10921118894",
        walk = "http://www.roblox.com/asset/?id=10921127095",
        run = "http://www.roblox.com/asset/?id=10921121197",
        jump = "http://www.roblox.com/asset/?id=10921123517",
        climb = "http://www.roblox.com/asset/?id=10921116196",
        fall = "http://www.roblox.com/asset/?id=10921122579"
    },
    ["Bajak Laut"] = {
        idle1 = "http://www.roblox.com/asset/?id=750781874",
        idle2 = "http://www.roblox.com/asset/?id=750782770",
        walk = "http://www.roblox.com/asset/?id=750785693",
        run = "http://www.roblox.com/asset/?id=750783738",
        jump = "http://www.roblox.com/asset/?id=750782230",
        climb = "http://www.roblox.com/asset/?id=750779899",
        fall = "http://www.roblox.com/asset/?id=750780242"
    },
    ["Percaya Diri"] = {
        idle1 = "http://www.roblox.com/asset/?id=1069977950",
        idle2 = "http://www.roblox.com/asset/?id=1069987858",
        walk = "http://www.roblox.com/asset/?id=1070017263",
        run = "http://www.roblox.com/asset/?id=1070001516",
        jump = "http://www.roblox.com/asset/?id=1069984524",
        climb = "http://www.roblox.com/asset/?id=1069946257",
        fall = "http://www.roblox.com/asset/?id=1069973677"
    },
    ["Popstar"] = {
        idle1 = "http://www.roblox.com/asset/?id=1212900985",
        idle2 = "http://www.roblox.com/asset/?id=1212954651",
        walk = "http://www.roblox.com/asset/?id=1212980338",
        run = "http://www.roblox.com/asset/?id=1212980348",
        jump = "http://www.roblox.com/asset/?id=1212954642",
        climb = "http://www.roblox.com/asset/?id=1213044953",
        fall = "http://www.roblox.com/asset/?id=1212900995"
    },
    ["Patrol"] = {
        idle1 = "http://www.roblox.com/asset/?id=1149612882",
        idle2 = "http://www.roblox.com/asset/?id=1150842221",
        walk = "http://www.roblox.com/asset/?id=1151231493",
        run = "http://www.roblox.com/asset/?id=1150967949",
        jump = "http://www.roblox.com/asset/?id=1150944216",
        climb = "http://www.roblox.com/asset/?id=1148811837",
        fall = "http://www.roblox.com/asset/?id=1148863382"
    },
    ["Sneaky"] = {
        idle1 = "http://www.roblox.com/asset/?id=1132473842",
        idle2 = "http://www.roblox.com/asset/?id=1132477671",
        walk = "http://www.roblox.com/asset/?id=1132510133",
        run = "http://www.roblox.com/asset/?id=1132494274",
        jump = "http://www.roblox.com/asset/?id=1132489853",
        climb = "http://www.roblox.com/asset/?id=1132461372",
        fall = "http://www.roblox.com/asset/?id=1132469004"
    },
    ["Putri"] = {
        idle1 = "http://www.roblox.com/asset/?id=941003647",
        idle2 = "http://www.roblox.com/asset/?id=941013098",
        walk = "http://www.roblox.com/asset/?id=941028902",
        run = "http://www.roblox.com/asset/?id=941015281",
        jump = "http://www.roblox.com/asset/?id=941008832",
        climb = "http://www.roblox.com/asset/?id=940996062",
        fall = "http://www.roblox.com/asset/?id=941000007"
    },
    ["Cowboy"] = {
        idle1 = "http://www.roblox.com/asset/?id=1014390418",
        idle2 = "http://www.roblox.com/asset/?id=1014398616",
        walk = "http://www.roblox.com/asset/?id=1014421541",
        run = "http://www.roblox.com/asset/?id=1014401683",
        jump = "http://www.roblox.com/asset/?id=1014394726",
        climb = "http://www.roblox.com/asset/?id=1014380606",
        fall = "http://www.roblox.com/asset/?id=1014384571"
    },
    ["Wanita Berkilau"] = {
        idle1 = "http://www.roblox.com/asset/?id=4708191566",
        idle2 = "http://www.roblox.com/asset/?id=4708192150",
        walk = "http://www.roblox.com/asset/?id=4708193840",
        run = "http://www.roblox.com/asset/?id=4708192705",
        jump = "http://www.roblox.com/asset/?id=4708188025",
        climb = "http://www.roblox.com/asset/?id=4708184253",
        fall = "http://www.roblox.com/asset/?id=4708186162"
    },
    ["Tuan Toilet"] = {
        idle1 = "http://www.roblox.com/asset/?id=4417977954",
        idle2 = "http://www.roblox.com/asset/?id=4417978624",
        walk = "http://www.roblox.com/asset/?id=4708193840",
        run = "http://www.roblox.com/asset/?id=4417979645",
        jump = "http://www.roblox.com/asset/?id=4708188025",
        climb = "http://www.roblox.com/asset/?id=4708184253",
        fall = "http://www.roblox.com/asset/?id=4708186162"
    },
    ["Ud'zal"] = {
        idle1 = "rbxassetid://3303162274",
        idle2 = "rbxassetid://3303162549",
        walk = "http://www.roblox.com/asset/?id=3303162967",
        run = "http://www.roblox.com/asset/?id=3236836670",
        jump = "http://www.roblox.com/asset/?id=4708188025",
        climb = "http://www.roblox.com/asset/?id=4708184253",
        fall = "http://www.roblox.com/asset/?id=4708186162"
    },
    ["Beroco Sang Penakluk"] = {
        idle1 = "rbxassetid://3293641938",
        idle2 = "rbxassetid://3293642554",
        walk = "http://www.roblox.com/asset/?id=10921269718",
        run = "http://www.roblox.com/asset/?id=3236836670",
        jump = "http://www.roblox.com/asset/?id=4708188025",
        climb = "http://www.roblox.com/asset/?id=4708184253",
        fall = "http://www.roblox.com/asset/?id=4708186162"
    }
}
getAnimateFolder = function(character)
    if not character then
        return nil
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        wait(0.5)
        humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return nil
        end
    end
    local animate = humanoid:FindFirstChild("Animate")
    if not animate then
        animate = character:FindFirstChild("Animate")
    end
    if not animate then
        animate = Instance.new("Folder")
        animate.Name = "Animate"
        animate.Parent = humanoid
        local animateScript = Instance.new("Script")
        animateScript.Name = "Animate"
        animateScript.Source = [[
            local Figure = script.Parent.Parent
            local Torso = Figure:WaitForChild("Torso")
            local RightShoulder = Torso:WaitForChild("Right Shoulder")
            local LeftShoulder = Torso:WaitForChild("Left Shoulder")
            local RightHip = Torso:WaitForChild("Right Hip")
            local LeftHip = Torso:WaitForChild("Left Hip")
            local Neck = Torso:WaitForChild("Neck")
            local Humanoid = Figure:WaitForChild("Humanoid")
            local pose = "Standing"
            function createAnimation(id)
                local animation = Instance.new("Animation")
                animation.AnimationId = id
                return animation
            end
            script.Parent.Animate.Disabled = false
        ]]
        animateScript.Parent = animate
    end
    return animate
end
applyAnimation = function(animate, animationData)
    if not animate then
        return false
    end
    local success = true
    local function setAnimation(part, animationId)
        if part and part:IsA("Animation") then
            pcall(function()
                part.AnimationId = animationId
            end)
        end
    end
    if animate.idle then
        setAnimation(animate.idle.Animation1, animationData.idle1)
        setAnimation(animate.idle.Animation2, animationData.idle2)
    end
    if animate.walk then
        if animate.walk.WalkAnim then
            setAnimation(animate.walk.WalkAnim, animationData.walk)
        elseif animate.walk.walk then
            setAnimation(animate.walk.walk, animationData.walk)
        end
    end
    if animate.run then
        if animate.run.RunAnim then
            setAnimation(animate.run.RunAnim, animationData.run)
        elseif animate.run.run then
            setAnimation(animate.run.run, animationData.run)
        elseif animate.run.Animation then
            setAnimation(animate.run.Animation, animationData.run)
        end
    end
    if animate.jump then
        if animate.jump.JumpAnim then
            setAnimation(animate.jump.JumpAnim, animationData.jump)
        elseif animate.jump.jump then
            setAnimation(animate.jump.jump, animationData.jump)
        end
    end
    if animate.climb and animate.climb.ClimbAnim then
        setAnimation(animate.climb.ClimbAnim, animationData.climb)
    end
    if animate.fall then
        if animate.fall.FallAnim then
            setAnimation(animate.fall.FallAnim, animationData.fall)
        elseif animate.fall.fall then
            setAnimation(animate.fall.fall, animationData.fall)
        end
    end
    return success
end
local function resetButtonToNormal(buttonContainer)
    if buttonContainer and buttonContainer:FindFirstChild("Button") then
        local button = buttonContainer.Button
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = Color3.fromRGB(15, 15, 15),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        local stroke = button:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(120, 120, 120)
            }):Play()
        end
    end
end
captureDefaultAnimations = function(animate)
    if defaultAnimationIds then return end
    local data = {}
    local function getAnimationId(part)
        if part and part:IsA("Animation") then
            return part.AnimationId
        end
        return nil
    end
    if animate:FindFirstChild("idle") then
        data.idle1 = getAnimationId(animate.idle:FindFirstChild("Animation1"))
        data.idle2 = getAnimationId(animate.idle:FindFirstChild("Animation2"))
    end
    if animate:FindFirstChild("walk") then
        data.walk = getAnimationId(animate.walk:FindFirstChild("WalkAnim") or animate.walk:FindFirstChild("walk"))
    end
    if animate:FindFirstChild("run") then
        data.run = getAnimationId(animate.run:FindFirstChild("RunAnim") or animate.run:FindFirstChild("run") or animate.run:FindFirstChild("Animation"))
    end
    if animate:FindFirstChild("jump") then
        data.jump = getAnimationId(animate.jump:FindFirstChild("JumpAnim") or animate.jump:FindFirstChild("jump"))
    end
    if animate:FindFirstChild("climb") then
        data.climb = getAnimationId(animate.climb:FindFirstChild("ClimbAnim"))
    end
    if animate:FindFirstChild("fall") then
        data.fall = getAnimationId(animate.fall:FindFirstChild("FallAnim") or animate.fall:FindFirstChild("fall"))
    end
    if data.idle1 or data.walk or data.run then
        defaultAnimationIds = data
    end
end
local function applyCurrentAnimationToCharacter(character)
    if currentAnimation and AnimationData[currentAnimation] then
        local animate = getAnimateFolder(character)
        if animate then
            applyAnimation(animate, AnimationData[currentAnimation])
        end
    end
end
Player.CharacterAdded:Connect(function(character)
    defaultAnimationIds = nil
    character:WaitForChild("Humanoid")
    applyCurrentAnimationToCharacter(character)
end)
createAnimationButton = function(animationName, animationData)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = animationName
    buttonContainer.Size = UDim2.new(0.9, 0, 0, 45)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = ScrollFrame
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    button.Text = animationName
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.GothamMedium
    button.AutoButtonColor = false
    button.Parent = buttonContainer
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    button.MouseEnter:Connect(function()
        if activeButton ~= buttonContainer then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            }):Play()
        end
    end)
    button.MouseLeave:Connect(function()
        if activeButton ~= buttonContainer then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            }):Play()
        end
    end)
    button.MouseButton1Click:Connect(function()
        local character = Player.Character
        if not character then
            character = Player.CharacterAdded:Wait()
            wait(0.5)
        end
        local animate = getAnimateFolder(character)
        if not animate then return end
        if activeButton == buttonContainer then
            captureDefaultAnimations(animate)
            if defaultAnimationIds then
                applyAnimation(animate, defaultAnimationIds)
            end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop(0.1)
                    end
                end
            end
            resetButtonToNormal(buttonContainer)
            activeButton = nil
            currentAnimation = nil
            return
        end
        captureDefaultAnimations(animate)
        local success = applyAnimation(animate, animationData)
        if success then
            if activeButton then
                resetButtonToNormal(activeButton)
            end
            currentAnimation = animationName
            activeButton = buttonContainer
            TweenService:Create(button, TweenInfo.new(0.3), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                TextColor3 = Color3.fromRGB(15, 15, 15)
            }):Play()
            TweenService:Create(button, TweenInfo.new(0.1), {
                Size = UDim2.new(1, -4, 1, -4),
                Position = UDim2.new(0, 2, 0, 2)
            }):Play()
            wait(0.1)
            TweenService:Create(button, TweenInfo.new(0.2), {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end
    end)
    return buttonContainer
end
for animationName, data in pairs(AnimationData) do
    local button = createAnimationButton(animationName, data)
    button.Parent = ScrollFrame
end
    end)
    if not success then
        warn("Animasi error: " .. tostring(err))
    end
end
AnimasiBtn.MouseButton1Click:Connect(launchAnimasi)
function launchEmote()
    local success, err = pcall(function()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
do
    local old = playerGui:FindFirstChild("EmoteBypass")
    if old then pcall(function() old:Destroy() end) end
end
local gui = Instance.new("ScreenGui")
gui.Name = "EmoteBypass"
gui.ResetOnSpawn = false
gui.Parent = playerGui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 360)
frame.Position = UDim2.new(0.5, -150, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
frame.BackgroundTransparency = 0.1
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 10, 0, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "BYPASS EMOTE BY PIXECUTE"
title.Parent = frame
local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0, 24, 0, 24)
btnMin.Position = UDim2.new(1, -52, 0, 6)
btnMin.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
btnMin.AutoButtonColor = true
btnMin.Text = "-"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 16
btnMin.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMin.Parent = frame
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 6)
local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 24, 0, 24)
btnClose.Position = UDim2.new(1, -24, 0, 6)
btnClose.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
btnClose.AutoButtonColor = true
btnClose.Text = "X"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 14
btnClose.TextColor3 = Color3.fromRGB(255,255,255)
btnClose.Parent = frame
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 6)
local contentHolder = Instance.new("Frame")
contentHolder.Name = "Content"
contentHolder.BackgroundTransparency = 1
contentHolder.Size = UDim2.new(1, 0, 1, -34)
contentHolder.Position = UDim2.new(0, 0, 0, 34)
contentHolder.Parent = frame
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
local function updateRigStatus()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    local rig = hum and hum.RigType or Enum.HumanoidRigType.R6
    if rig == Enum.HumanoidRigType.R6 then
        statusLabel.Text = "Rig: R6 (tidak didukung)"
        if btnPlay then
            btnPlay.Active = false
            btnPlay.BackgroundColor3 = Color3.fromRGB(15,15,15)
            btnPlay.TextColor3 = Color3.fromRGB(120, 120, 120)
            btnPlay.TextTransparency = 0.4
        end
    else
        statusLabel.Text = "Rig: R15 (siap)"
        if btnPlay then
            btnPlay.Active = true
            btnPlay.BackgroundColor3 = Color3.fromRGB(15,15,15)
            btnPlay.TextColor3 = Color3.fromRGB(255,255,255)
            btnPlay.TextTransparency = 0
        end
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
input.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
input.BackgroundTransparency = 0.1
input.PlaceholderText = "Enter Animation AssetId (e.g. 507776043)"
input.Text = "103040723950430"
input.TextSize = 14
input.Font = Enum.Font.GothamMedium
input.TextColor3 = Color3.fromRGB(255,255,255)
input.ClearTextOnFocus = false
input.Parent = contentHolder
Instance.new("UICorner", input).CornerRadius = UDim.new(0,8)
local btnPlay = Instance.new("TextButton")
btnPlay.Size = UDim2.new(0.48, -10, 0, 32)
btnPlay.Position = UDim2.new(0, 10, 0, 66)
btnPlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
btnStop.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
btnStop.Text = "Stop"
btnStop.Font = Enum.Font.GothamBold
btnStop.TextSize = 14
btnStop.TextColor3 = Color3.fromRGB(255, 50, 50)
btnStop.Parent = contentHolder
Instance.new("UICorner", btnStop).CornerRadius = UDim.new(0,8)
local blendOn = false
local loopOn = true
local btnBlend = Instance.new("TextButton")
btnBlend.Size = UDim2.new(0.48, -10, 0, 24)
btnBlend.Position = UDim2.new(0, 10, 0, 100)
btnBlend.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
btnBlend.Font = Enum.Font.GothamBold
btnBlend.TextSize = 12
btnBlend.TextColor3 = Color3.fromRGB(255,255,255)
btnBlend.Parent = contentHolder
Instance.new("UICorner", btnBlend).CornerRadius = UDim.new(0,6)
local btnLoop = Instance.new("TextButton")
btnLoop.Size = UDim2.new(0.48, -10, 0, 24)
btnLoop.Position = UDim2.new(1, -10, 0, 100)
btnLoop.AnchorPoint = Vector2.new(1,0)
btnLoop.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
    local finalId = resolveCatalogAnimationId(id)
    anim.AnimationId = finalId
    local ok, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    if not ok or not track then
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
        local numeric = string.match(input.Text or "", "(%d+)")
        id = tonumber(numeric)
    end
    if not id then return end
    playEmoteById(id)
end)
btnStop.MouseButton1Click:Connect(stopEmote)
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
local EmoteList = {
    {name = "Gojo Floating", id = 103040723950430},
    {name = "Nod", id = 507770453},
    {name = "Wave", id = 507777826},
    {name = "Cheer", id = 507770677},
    {name = "Point", id = 507770239},
}
local searchBar = Instance.new("TextBox")
searchBar.Size = UDim2.new(1, -20, 0, 28)
searchBar.Position = UDim2.new(0, 10, 0, 132)
searchBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
searchBar.BackgroundTransparency = 0.1
searchBar.PlaceholderText = "Cari Emote di Roblox Catalog..."
searchBar.Text = ""
searchBar.TextSize = 12
searchBar.Font = Enum.Font.GothamMedium
searchBar.TextColor3 = Color3.fromRGB(255,255,255)
searchBar.Parent = contentHolder
Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0,6)
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, -20, 0, 22)
listLabel.Position = UDim2.new(0, 10, 0, 166)
listLabel.BackgroundTransparency = 1
listLabel.Font = Enum.Font.GothamBold
listLabel.TextSize = 13
listLabel.TextColor3 = Color3.fromRGB(255,255,255)
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Text = "Pilih Emote:"
listLabel.Parent = contentHolder
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 0, 118)
Scroll.Position = UDim2.new(0, 10, 0, 192)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
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
        BackgroundColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(15, 15, 15),
        TextColor3 = state and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(255, 255, 255)
    }):Play()
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if stroke then
        TweenService:Create(stroke, TweenInfo.new(0.15), {
            Color = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 120, 120)
        }):Play()
    end
end
local function createItem(name, id)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        if activeButton and activeButton ~= btn then setActive(activeButton, false) end
        activeButton = btn
        setActive(btn, true)
        input.Text = tostring(id)
        playEmoteById(id)
    end)
end
for _, item in ipairs(EmoteList) do
    createItem(item.name, item.id)
end
local function searchEmotes(keyword)
    listLabel.Text = "Mencari..."
    task.spawn(function()
        local AvatarEditorService = game:GetService("AvatarEditorService")
        local params = CatalogSearchParams.new()
        params.AssetTypes = {Enum.AvatarAssetType.EmoteAnimation}
        params.SearchKeyword = keyword
        local success, pages = pcall(function()
            return AvatarEditorService:SearchCatalogAsync(params)
        end)
        if success and pages then
            for _, child in ipairs(Scroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            activeButton = nil
            local items = pages:GetCurrentPage()
            if items and #items > 0 then
                for _, item in ipairs(items) do
                    createItem(item.Name, item.Id)
                end
                listLabel.Text = "Hasil Pencarian:"
            else
                listLabel.Text = "Tidak ada hasil."
            end
        else
            listLabel.Text = "Gagal memproses data."
        end
    end)
end
searchBar.FocusLost:Connect(function(enterPressed)
    if enterPressed and searchBar.Text ~= "" then
        searchEmotes(searchBar.Text)
    end
end)
local uis = game:GetService("UserInputService")
uis.InputBegan:Connect(function(io, gpe)
    if gpe then return end
    if io.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
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
    end)
    if not success then
        warn("Emote error: " .. tostring(err))
    end
end
EmoteBtn.MouseButton1Click:Connect(launchEmote)
CloneAvatarBtn.MouseButton1Click:Connect(promptClone)
function launchFlyV2()
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
	Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
	Frame.BackgroundTransparency = 0.1
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
	Frame.Size = UDim2.new(0, 190, 0, 57)
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
	local fStroke = Instance.new("UIStroke", Frame)
	fStroke.Color = Color3.fromRGB(255, 50, 50)
	fStroke.Thickness = 1
	local function styleBtn(btn, text, isRed)
		btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		btn.Font = Enum.Font.GothamBold
		btn.Text = text
		btn.TextColor3 = isRed and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
		btn.TextSize = 10
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	end
	local function styleLbl(lbl, text, isRed)
		lbl.BackgroundTransparency = 1
		lbl.Font = Enum.Font.GothamBold
		lbl.Text = text
		lbl.TextColor3 = isRed and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)
		lbl.TextSize = 10
	end
	up.Name = "up"
	up.Parent = Frame
	up.Size = UDim2.new(0, 44, 0, 28)
	styleBtn(up, "NAIK", false)
	down.Name = "down"
	down.Parent = Frame
	down.Position = UDim2.new(0, 0, 0.491228074, 0)
	down.Size = UDim2.new(0, 44, 0, 28)
	styleBtn(down, "TURUN", false)
	onof.Name = "onof"
	onof.Parent = Frame
	onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
	onof.Size = UDim2.new(0, 56, 0, 28)
	styleBtn(onof, "Klik Untuk Terbang!", false)
	onof.TextScaled = true
	TextLabel.Parent = Frame
	TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
	TextLabel.Size = UDim2.new(0, 100, 0, 28)
	styleLbl(TextLabel, "FLY V2 BY MANNN", true)
	TextLabel.TextScaled = true
	TextLabel.TextWrapped = true
	plus.Name = "plus"
	plus.Parent = Frame
	plus.Position = UDim2.new(0.231578946, 0, 0, 0)
	plus.Size = UDim2.new(0, 45, 0, 28)
	styleBtn(plus, "+", false)
	plus.TextScaled = true
	plus.TextWrapped = true
	speed.Name = "speed"
	speed.Parent = Frame
	speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
	speed.Size = UDim2.new(0, 44, 0, 28)
	styleLbl(speed, "1", false)
	speed.TextScaled = true
	speed.TextWrapped = true
	mine.Name = "mine"
	mine.Parent = Frame
	mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
	mine.Size = UDim2.new(0, 45, 0, 29)
	styleBtn(mine, "-", false)
	mine.TextScaled = true
	mine.TextWrapped = true
	closebutton.Name = "Close"
	closebutton.Parent = Frame
	closebutton.Size = UDim2.new(0, 45, 0, 28)
	closebutton.Position = UDim2.new(0, 0, -1, 27)
	styleBtn(closebutton, "X", true)
	closebutton.TextSize = 14
	mini.Name = "minimize"
	mini.Parent = Frame
	mini.Size = UDim2.new(0, 45, 0, 28)
	mini.Position = UDim2.new(0, 44, -1, 27)
	styleBtn(mini, "-", true)
	mini.TextSize = 14
	mini2.Name = "minimize2"
	mini2.Parent = Frame
	mini2.Size = UDim2.new(0, 45, 0, 28)
	mini2.Position = UDim2.new(0, 44, -1, 57)
	styleBtn(mini2, "+", true)
	mini2.TextSize = 14
	mini2.Visible = false
	local speeds = 1
	local speaker = game:GetService("Players").LocalPlayer
	local chr = game.Players.LocalPlayer.Character
	local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
	local nowe = false
	local noclipConnectionFly2 = nil
    local flyV2CustomIdleId = "102256275785620"
    local flyV2CustomFlyId = "100132174228207"
    local flyV2IdleTrack = nil
    local flyV2FlyTrack = nil
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "GUI TERBANG V2";
		Text = "by Mannn";
		Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
	local Duration = 5;
	Frame.Active = true
	Frame.Draggable = true
	onof.MouseButton1Down:connect(function()
		if nowe == true then
			nowe = false
			if noclipConnectionFly2 then
				noclipConnectionFly2:Disconnect()
				noclipConnectionFly2 = nil
			end
            if flyV2IdleTrack then pcall(function() flyV2IdleTrack:Stop() end) end
            if flyV2FlyTrack then pcall(function() flyV2FlyTrack:Stop() end) end
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
			-- Animasi khusus dihapus sesuai permintaan
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

VehicleFlyBtn = createButton("", "Vehicle Fly")
VehicleFlyBtn.Name = "VehicleFlyBtn"
local vFlyActive = false
local vFlyConnection = nil

function toggleVehicleFly(state)
    if state == nil then vFlyActive = not vFlyActive else vFlyActive = state end
    setButtonActive(VehicleFlyBtn, vFlyActive)
    
    local char = Player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    if vFlyActive then
        local seat = hum.SeatPart
        if not seat or (not seat:IsA("VehicleSeat") and not seat:IsA("Seat")) then
            vFlyActive = false
            setButtonActive(VehicleFlyBtn, false)
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Vehicle Fly",
                    Text = "Anda harus duduk di dalam kendaraan terlebih dahulu!",
                    Duration = 3
                })
            end)
            return
        end
        
        local vehicle = seat.Parent
        local primary = vehicle:IsA("Model") and vehicle.PrimaryPart or seat
        if not primary then primary = seat end
        
        local bg = Instance.new("BodyGyro")
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = primary.CFrame
        bg.Parent = primary
        
        local bv = Instance.new("BodyVelocity")
        bv.velocity = Vector3.new(0,0,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = primary
        
        local cam = workspace.CurrentCamera
        local speed = 50
        
        vFlyConnection = RunService.RenderStepped:Connect(function()
            if not hum.SeatPart then
                toggleVehicleFly(false)
                return
            end
            
            local lookVector = cam.CFrame.lookVector
            local moveVector = Vector3.new(0,0,0)
            
            local w = UserInputService:IsKeyDown(Enum.KeyCode.W)
            local s = UserInputService:IsKeyDown(Enum.KeyCode.S)
            local a = UserInputService:IsKeyDown(Enum.KeyCode.A)
            local d = UserInputService:IsKeyDown(Enum.KeyCode.D)
            local space = UserInputService:IsKeyDown(Enum.KeyCode.Space)
            local lctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            
            if w then moveVector = moveVector + lookVector end
            if s then moveVector = moveVector - lookVector end
            if a then moveVector = moveVector - cam.CFrame.RightVector end
            if d then moveVector = moveVector + cam.CFrame.RightVector end
            if space then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if lctrl then moveVector = moveVector + Vector3.new(0, -1, 0) end
            
            local isPC = w or s or a or d
            if not isPC then
                if hum and hum.MoveDirection.Magnitude > 0 then
                    local flatLook = (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
                    local flatRight = (cam.CFrame.RightVector * Vector3.new(1, 0, 1)).Unit
                    local forwardInput = hum.MoveDirection:Dot(flatLook)
                    local rightInput = hum.MoveDirection:Dot(flatRight)
                    moveVector += (cam.CFrame.LookVector * forwardInput) + (cam.CFrame.RightVector * rightInput)
                end
            end
            
            if moveVector.Magnitude > 0 then
                bv.velocity = moveVector.Unit * speed
            else
                bv.velocity = Vector3.new(0,0,0)
            end
            bg.cframe = cam.CFrame
        end)
    else
        if vFlyConnection then
            vFlyConnection:Disconnect()
            vFlyConnection = nil
        end
        local seat = hum.SeatPart
        if seat then
            local vehicle = seat.Parent
            local primary = vehicle:IsA("Model") and vehicle.PrimaryPart or seat
            if primary then
                local oldBg = primary:FindFirstChildOfClass("BodyGyro")
                if oldBg then oldBg:Destroy() end
                local oldBv = primary:FindFirstChildOfClass("BodyVelocity")
                if oldBv then oldBv:Destroy() end
            end
        end
    end
end
VehicleFlyBtn.MouseButton1Click:Connect(function() toggleVehicleFly() end)

do
    flyV3Active = false
    flyV3Movers = {}
    flyV3Enabled = false
    MiniButtons = {}
    function toggleFlyV3(state)
        if state == nil then
            flyV3Active = not flyV3Active
        else
            flyV3Active = state
        end
        if not flyV3Active then
            if toggleNoclip then toggleNoclip(false) end
            for _, mover in ipairs(flyV3Movers) do
                if mover and mover.Parent then mover:Destroy() end
            end
            flyV3Movers = {}
            local char = Player.Character
            local primaryPart = char and char.PrimaryPart
            if primaryPart then
                primaryPart.AssemblyLinearVelocity = Vector3.zero
                primaryPart.AssemblyAngularVelocity = Vector3.zero
            end
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.PlatformStand = false
                pcall(function() char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            end
        else
            if toggleNoclip then toggleNoclip(true) end
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.PlatformStand = true
            end
        end
    end
    function toggleFlyV3Permission(state)
        if state == nil then
            flyV3Enabled = not flyV3Enabled
        else
            flyV3Enabled = state
        end
        if not flyV3Enabled then
            toggleFlyV3(false)
        end
    end
    godModeActive = false
    godModeConnection = nil
    function toggleGodMode(state)
        if state == nil then
            godModeActive = not godModeActive
        else
            godModeActive = state
        end
        local MiniGodBtn = MiniButtons and MiniButtons["MiniGodBtn"]
        if godModeActive then
            if MiniGodBtn then
                MiniGodBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                MiniGodBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            end
            if not godModeConnection then
                godModeConnection = RunService.Heartbeat:Connect(function()
                    local char = game.Players.LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        pcall(function()
                            hum.MaxHealth = 999999
                            hum.Health = 999999
                        end)
                    end
                end)
            end
        else
            if MiniGodBtn then
                MiniGodBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                MiniGodBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            end
            if godModeConnection then
                godModeConnection:Disconnect()
                godModeConnection = nil
            end
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum.MaxHealth = 100
                    hum.Health = 100
                end)
            end
        end
    end
    MiniPanelFrame = Instance.new("Frame")
    MiniPanelFrame.Size = UDim2.new(0, 250, 0, 390)
    MiniPanelFrame.Position = UDim2.new(1, -260, 0.5, -50)
    MiniPanelFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    MiniPanelFrame.BackgroundTransparency = 0.1
    MiniPanelFrame.BorderSizePixel = 0
    MiniPanelFrame.Active = true
    MiniPanelFrame.Draggable = false
    MiniPanelFrame.Visible = false
    MiniPanelFrame.Parent = ScreenGui
    MiniPanelCorner = Instance.new("UICorner", MiniPanelFrame)
    MiniPanelCorner.CornerRadius = UDim.new(0, 12)
    mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(255, 255, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.Parent = MiniPanelFrame
    MiniPanelHeader = Instance.new("Frame", MiniPanelFrame)
    MiniPanelHeader.Size = UDim2.new(1, 0, 0, 30)
    MiniPanelHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MiniPanelHeader.BorderSizePixel = 0
    makeSmoothDraggable(MiniPanelFrame, MiniPanelHeader)
    MiniHeaderCorner = Instance.new("UICorner", MiniPanelHeader)
    MiniHeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderBottomFix = Instance.new("Frame", MiniPanelHeader)
    HeaderBottomFix.Size = UDim2.new(1, 0, 0, 6)
    HeaderBottomFix.Position = UDim2.new(0, 0, 1, -6)
    HeaderBottomFix.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    HeaderBottomFix.BorderSizePixel = 0
    MiniPanelTitle = Instance.new("TextLabel", MiniPanelHeader)
    MiniPanelTitle.Size = UDim2.new(1, -60, 1, 0)
    MiniPanelTitle.Position = UDim2.new(0, 10, 0, 0)
    MiniPanelTitle.BackgroundTransparency = 1
    MiniPanelTitle.Text = "Quick Tools"
    MiniPanelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MiniPanelTitle.Font = Enum.Font.GothamBold
    MiniPanelTitle.TextSize = 12
    MiniPanelTitle.TextXAlignment = Enum.TextXAlignment.Left
    MiniMinimizeBtn = Instance.new("TextButton", MiniPanelHeader)
    MiniMinimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    MiniMinimizeBtn.Position = UDim2.new(1, -55, 0.5, -11)
    MiniMinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    MiniMinimizeBtn.BackgroundTransparency = 0.1
    MiniMinimizeBtn.Text = "-"
    MiniMinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MiniMinimizeBtn.Font = Enum.Font.GothamBold
    MiniMinimizeBtn.TextSize = 14
    Instance.new("UICorner", MiniMinimizeBtn).CornerRadius = UDim.new(0, 6)
    minStroke = Instance.new("UIStroke", MiniMinimizeBtn)
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1
    MiniCloseBtn = Instance.new("TextButton", MiniPanelHeader)
    MiniCloseBtn.Size = UDim2.new(0, 22, 0, 22)
    MiniCloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
    MiniCloseBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    MiniCloseBtn.BackgroundTransparency = 0.1
    MiniCloseBtn.Text = "X"
    MiniCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MiniCloseBtn.Font = Enum.Font.GothamBold
    MiniCloseBtn.TextSize = 13
    Instance.new("UICorner", MiniCloseBtn).CornerRadius = UDim.new(0, 6)
    clsStroke = Instance.new("UIStroke", MiniCloseBtn)
    clsStroke.Color = Color3.fromRGB(255, 255, 255)
    clsStroke.Thickness = 1
    MiniContent = Instance.new("Frame", MiniPanelFrame)
    MiniContent.Size = UDim2.new(1, 0, 1, -30)
    MiniContent.Position = UDim2.new(0, 0, 0, 30)
    MiniContent.BackgroundTransparency = 1
    local buttonsData = {
        {name = "MiniBringBtn", text = "Bring Part: OFF"},
        {name = "MiniDexBtn", text = "Dex Explorer"},
        {name = "MiniEspBtn", text = "ESP: OFF"},
        {name = "MiniFlingAuraBtn", text = "Fling Aura: OFF"},
        {name = "MiniFlyTapBtn", text = "Fly (Mobile): OFF"},
        {name = "MiniFlyV3Btn", text = "Fly PC: OFF  [E]"},
        {name = "MiniFlyV3SpeedBtn", text = "Fly V3: OFF  [Q]"},
        {name = "MiniGodBtn", text = "HP: 100"},
        {name = "MiniMaxZoomBtn", text = "Max Zoom: OFF"},
        {name = "MiniNoclipBtn", text = "Noclip: OFF"},
        {name = "MiniOrbitFlingBtn", text = "Orbit Fling: OFF"},
        {name = "MiniPartInspectorBtn", text = "Part Inspector: OFF"},
        {name = "MiniScannerBtn", text = "Part Scanner: OFF"},
        {name = "MiniPlayerListBtn", text = "Player List: OFF"},
        {name = "MiniRefreshBtn", text = "Refresh Char"},
        {name = "MiniSpectateBtn", text = "Spectate: OFF"},
        {name = "MiniUnanchorV1Btn", text = "Unanchor v1"},
        {name = "MiniUnanchorV2Btn", text = "Unanchor v2: OFF"},
        {name = "MiniYeetPartsBtn", text = "Yeet All Parts"}
    }
    MiniButtons = {}
    local columns = 2
    local btnWidth = 0.46
    local startX = 0.027
    local gapX = 0.026
    local startY = 8
    local btnHeight = 28
    local gapY = 6
    for i, data in ipairs(buttonsData) do
        local col = (i - 1) % columns
        local row = math.floor((i - 1) / columns)
        local btn = Instance.new("TextButton", MiniContent)
        btn.Name = data.name
        btn.Size = UDim2.new(btnWidth, 0, 0, btnHeight)
        btn.Position = UDim2.new(startX + (col * (btnWidth + gapX)), 0, 0, startY + (row * (btnHeight + gapY)))
        btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        btn.Text = data.text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        MiniButtons[data.name] = btn
    end
    MiniFlyV3Btn = MiniButtons["MiniFlyV3Btn"]
    MiniFlyV3SpeedBtn = MiniButtons["MiniFlyV3SpeedBtn"]
    MiniBringBtn = MiniButtons["MiniBringBtn"]
    MiniScannerBtn = MiniButtons["MiniScannerBtn"]
    MiniNoclipBtn = MiniButtons["MiniNoclipBtn"]
    MiniFlyTapBtn = MiniButtons["MiniFlyTapBtn"]
    MiniUnanchorV1Btn = MiniButtons["MiniUnanchorV1Btn"]
    MiniUnanchorV2Btn = MiniButtons["MiniUnanchorV2Btn"]
    MiniSpectateBtn = MiniButtons["MiniSpectateBtn"]
    MiniRefreshBtn = MiniButtons["MiniRefreshBtn"]
    MiniPlayerListBtn = MiniButtons["MiniPlayerListBtn"]
    MiniEspBtn = MiniButtons["MiniEspBtn"]
    MiniYeetPartsBtn = MiniButtons["MiniYeetPartsBtn"]
    MiniGodBtn = MiniButtons["MiniGodBtn"]
    MiniFlingAuraBtn = MiniButtons["MiniFlingAuraBtn"]
    MiniOrbitFlingBtn = MiniButtons["MiniOrbitFlingBtn"]
    MiniDexBtn = MiniButtons["MiniDexBtn"]
    MiniMaxZoomBtn = MiniButtons["MiniMaxZoomBtn"]
    MiniPartInspectorBtn = MiniButtons["MiniPartInspectorBtn"]
    flyV1PCEnabled = false
    MiniDexBtn.MouseButton1Click:Connect(launchDex)
    MiniMaxZoomBtn.MouseButton1Click:Connect(function() toggleMaxZoom() end)
    MiniPartInspectorBtn.MouseButton1Click:Connect(function() togglePartInspector() end)
    MiniFlyV3Btn.MouseButton1Click:Connect(function()
        flyV1PCEnabled = not flyV1PCEnabled
        if not flyV1PCEnabled and flying then disableFly() end
    end)
    MiniFlyV3SpeedBtn.MouseButton1Click:Connect(function()
        flyV3Enabled = not flyV3Enabled
        if not flyV3Enabled and flyV3Active then toggleFlyV3(false) end
    end)
    MiniBringBtn.MouseButton1Click:Connect(function() toggleBringPart() end)
    MiniYeetPartsBtn.MouseButton1Click:Connect(function() yeetAllParts() end)
    MiniGodBtn.MouseButton1Click:Connect(function() toggleGodMode() end)
    MiniFlingAuraBtn.MouseButton1Click:Connect(function() toggleFlingAura() end)
    MiniOrbitFlingBtn.MouseButton1Click:Connect(function() toggleOrbitFling() end)
    task.spawn(function()
        while true do
            pcall(function()
                local btn = MiniButtons["MiniGodBtn"]
                if btn then
                    local char = game.Players.LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local currentHP = hum.Health
                        if godModeActive then
                            btn.Text = "Kebal: " .. (currentHP > 1000 and "999K" or tostring(math.floor(currentHP)))
                            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            btn.Text = "HP: " .. tostring(math.floor(currentHP))
                            btn.TextColor3 = Color3.fromRGB(255, 50, 50)
                        end
                    else
                        btn.Text = "HP: 0"
                        btn.TextColor3 = Color3.fromRGB(255, 50, 50)
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
    MiniScannerBtn.MouseButton1Click:Connect(function()
        if PartScannerFrame and PartScannerFrame.Visible then
            PartScannerFrame.Visible = false
            MiniScannerBtn.Text = "Part Scanner: OFF"
            MiniScannerBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            createPartScannerWindow()
            PartScannerFrame.Visible = true
            refreshPartScanner()
            MiniScannerBtn.Text = "Part Scanner: ON"
            MiniScannerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    MiniNoclipBtn.MouseButton1Click:Connect(function() toggleNoclip() end)
    MiniFlyTapBtn.MouseButton1Click:Connect(function()
        if flying then disableFly() else enableFly() end
    end)
    MiniUnanchorV1Btn.MouseButton1Click:Connect(function()
        MiniUnanchorV1Btn.Text = "Wait..."
        MiniUnanchorV1Btn.TextColor3 = Color3.fromRGB(255, 150, 50)
        local lp = game:GetService("Players").LocalPlayer
        local lpPos = lp.Character and (lp.Character:FindFirstChild("HumanoidRootPart") or lp.Character:FindFirstChild("Torso"))
        if lpPos then
            EnableNetwork()
            local charSet = {}
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr.Character then
                    charSet[plr.Character] = true
                end
            end
            task.spawn(function()
                local start = tick()
                while tick() - start < 2.5 do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj.Anchored and obj.Transparency < 1 then
                            local isChar = false
                            local p = obj.Parent
                            while p and p ~= workspace do
                                if charSet[p] or p:FindFirstChildOfClass("Humanoid") then
                                    isChar = true
                                    break
                                end
                                p = p.Parent
                            end
                            if not isChar and string.lower(obj.Name) ~= "baseplate" and obj.Name ~= "Handle" then
                                if (obj.Position - lpPos.Position).Magnitude <= 1000 then
                                    obj.CanCollide = false
                                    obj.Anchored = false
                                    pcall(function() obj:BreakJoints() end)
                                    obj.AssemblyLinearVelocity = Vector3.new(0, -20, 0)
                                end
                            end
                        end
                    end
                    task.wait(0.25)
                end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj.Anchored then
                        obj.CanCollide = true
                    end
                end
            end)
        end
        if OneTimeUnanchor then pcall(function() OneTimeUnanchor() end) end
        task.delay(2.6, function()
            MiniUnanchorV1Btn.Text = "Unanchor v1"
            MiniUnanchorV1Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
        end)
    end)
    MiniUnanchorV2Btn.MouseButton1Click:Connect(function()
        toggleUnanchor()
        if aktif then
            MiniUnanchorV2Btn.Text = "Unanchor v2: ON"
            MiniUnanchorV2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            MiniUnanchorV2Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        else
            MiniUnanchorV2Btn.Text = "Unanchor v2: OFF"
            MiniUnanchorV2Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
            MiniUnanchorV2Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        end
    end)
    MiniSpectateBtn.MouseButton1Click:Connect(function() launchSpectator() end)
    MiniRefreshBtn.MouseButton1Click:Connect(function() pcall(function() refreshCharacter(true) end) end)
    MiniEspBtn.MouseButton1Click:Connect(function()
        if typeof(toggleESP) == "function" then toggleESP() end
    end)
    MiniPlayerListBtn.MouseButton1Click:Connect(function()
        if PlayerListFrame and PlayerListFrame.Visible then
            PlayerListFrame.Visible = false
            MiniPlayerListBtn.Text = "Player List: OFF"
            MiniPlayerListBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        else
            createPlayerListWindow()
            PlayerListFrame.Visible = true
            refreshPlayerList()
            MiniPlayerListBtn.Text = "Player List: ON"
            MiniPlayerListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    FlyV3Btn.MouseButton1Click:Connect(function()
        MiniPanelFrame.Visible = not MiniPanelFrame.Visible
        setButtonActive(FlyV3Btn, MiniPanelFrame.Visible)
        if not MiniPanelFrame.Visible then
            isMinPanelMinimized = false
            MiniMinimizeBtn.Text = "-"
            MiniPanelFrame.Size = UDim2.new(0, 250, 0, 390)
            MiniContent.Visible = true
        end
    end)
    RealFlyV3Btn.MouseButton1Click:Connect(function()
        toggleFlyV3()
        setButtonActive(RealFlyV3Btn, flyV3Active)
    end)
    isMinPanelMinimized = false
    MiniMinimizeBtn.MouseButton1Click:Connect(function()
        isMinPanelMinimized = not isMinPanelMinimized
        if isMinPanelMinimized then
            MiniMinimizeBtn.Text = "+"
            game:GetService("TweenService"):Create(MiniPanelFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 250, 0, 30)}):Play()
            MiniContent.Visible = false
        else
            MiniMinimizeBtn.Text = "-"
            game:GetService("TweenService"):Create(MiniPanelFrame, TweenInfo.new(0.25), {Size = UDim2.new(0, 250, 0, 390)}):Play()
            MiniContent.Visible = true
        end
    end)
    MiniCloseBtn.MouseButton1Click:Connect(function()
        MiniPanelFrame.Visible = false
        setButtonActive(FlyV3Btn, false)
    end)
    FlyV3ShortcutConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.E and flyV1PCEnabled then
            if flying then disableFly() else enableFly() end
        end
        if input.KeyCode == Enum.KeyCode.Q and flyV3Enabled then
            toggleFlyV3()
        end
    end)
    task.spawn(function()
        while ScreenGui and ScreenGui.Parent and task.wait(0.1) do
            pcall(function()
                if flyV1PCEnabled then
                    MiniFlyV3Btn.Text = "Fly PC: ON  [E]"
                    MiniFlyV3Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniFlyV3Btn.Text = "Fly PC: OFF  [E]"
                    MiniFlyV3Btn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if flyV3Enabled then
                    MiniFlyV3SpeedBtn.Text = "Fly V3: ON  [Q]"
                    MiniFlyV3SpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniFlyV3SpeedBtn.Text = "Fly V3: OFF  [Q]"
                    MiniFlyV3SpeedBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if PartScannerFrame and PartScannerFrame.Visible then
                    MiniScannerBtn.Text = "Part Scanner: ON"
                    MiniScannerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniScannerBtn.Text = "Part Scanner: OFF"
                    MiniScannerBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if blackHoleActive then
                    MiniBringBtn.Text = "Bring Part: ON"
                    MiniBringBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniBringBtn.Text = "Bring Part: OFF"
                    MiniBringBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if ESPenabled then
                    MiniEspBtn.Text = "ESP: ON"
                    MiniEspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniEspBtn.Text = "ESP: OFF"
                    MiniEspBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if noclipActive then
                    MiniNoclipBtn.Text = "Noclip: ON"
                    MiniNoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniNoclipBtn.Text = "Noclip: OFF"
                    MiniNoclipBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if flying then
                    MiniFlyTapBtn.Text = "Fly (Mobile): ON"
                    MiniFlyTapBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniFlyTapBtn.Text = "Fly (Mobile): OFF"
                    MiniFlyTapBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                local specGui = PlayerGui:FindFirstChild("PIXECUTE SPECTATE") or (game:GetService("CoreGui") and game:GetService("CoreGui"):FindFirstChild("PIXECUTE SPECTATE"))
                if specGui and specGui.Enabled then
                    MiniSpectateBtn.Text = "Spectate: ON"
                    MiniSpectateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniSpectateBtn.Text = "Spectate: OFF"
                    MiniSpectateBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if PlayerListFrame and PlayerListFrame.Visible then
                    MiniPlayerListBtn.Text = "Player List: ON"
                    MiniPlayerListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniPlayerListBtn.Text = "Player List: OFF"
                    MiniPlayerListBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if flingAuraActive then
                    MiniFlingAuraBtn.Text = "Fling Aura: ON"
                    MiniFlingAuraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniFlingAuraBtn.Text = "Fling Aura: OFF"
                    MiniFlingAuraBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
                if orbitFlingActive then
                    if orbitFlingTarget then
                        MiniOrbitFlingBtn.Text = "Orbit: " .. string.sub(orbitFlingTarget.Name, 1, 8)
                    else
                        MiniOrbitFlingBtn.Text = "Orbit: ON"
                    end
                    MiniOrbitFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    MiniOrbitFlingBtn.Text = "Orbit Fling: OFF"
                    MiniOrbitFlingBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
                end
            end)
        end
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
            local isFocused = UserInputService:GetFocusedTextBox() ~= nil
            if not isFocused and UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity += camCFrame.LookVector
                rotation *= CFrame.Angles(math.rad(-40), 0, 0)
            end
            if not isFocused and UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity -= camCFrame.LookVector
                rotation *= CFrame.Angles(math.rad(40), 0, 0)
            end
            if not isFocused and UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity += camCFrame.RightVector
                rotation *= CFrame.Angles(0, 0, math.rad(-40))
            end
            if not isFocused and UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity -= camCFrame.RightVector
                rotation *= CFrame.Angles(0, 0, math.rad(40))
            end
            if not isFocused and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity += Vector3.yAxis
            end
            if not isFocused and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                velocity -= Vector3.yAxis
            end
            local isPC = not isFocused and (UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.D))
            if not isPC then
                local hum = char and char:FindFirstChild("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    local flatLook = (camCFrame.LookVector * Vector3.new(1, 0, 1)).Unit
                    local flatRight = (camCFrame.RightVector * Vector3.new(1, 0, 1)).Unit
                    local forwardInput = hum.MoveDirection:Dot(flatLook)
                    local rightInput = hum.MoveDirection:Dot(flatRight)
                    velocity += (camCFrame.LookVector * forwardInput) + (camCFrame.RightVector * rightInput)
                    rotation *= CFrame.Angles(math.rad(-40 * forwardInput), 0, math.rad(-40 * rightInput))
                end
            end
            local tweenInfo = TweenInfo.new(0.5)
            TweenService:Create(bodyVelocity, tweenInfo, { Velocity = velocity * 50 * 4.5 }):Play()
            bodyVelocity.Parent = primaryPart
            TweenService:Create(bodyGyro, tweenInfo, { CFrame = rotation }):Play()
            bodyGyro.Parent = primaryPart
        end
    end)
end
JumpBtn.LayoutOrder = 4
SpeedBtn.LayoutOrder = 5
NoclipBtn.LayoutOrder = 7
FlingBtn.LayoutOrder = 8
FlyV1Btn.LayoutOrder = 9
UnanchorBtn.LayoutOrder = 10
BringPartBtn.LayoutOrder = 11
AntiLagBtn.LayoutOrder = 12
SpectatorBtn.LayoutOrder = 15
AnimasiBtn.LayoutOrder = 16
FlyV2Btn.LayoutOrder = 18.5
ClickTPBtn.LayoutOrder = 19
FreeCamBtn.LayoutOrder = 21
TPBox.LayoutOrder = 20
SWPBtn.LayoutOrder = 22
SWPBox.LayoutOrder = 23
ChatLogsBtn = createButton("", "Chat Logs")
ChatLogsBtn.Name = "ChatLogsBtn"
ChatLogsBtn.MouseButton1Click:Connect(function()
    toggleChatLogsWindow()
end);
task.spawn(function()
    local btns = {
        AirwalkBtn, ESPBtn, ESPTeamBtn, LampBtn, JumpBtn, SpeedBtn, NoclipBtn, FlingBtn, FlyV1Btn,
        UnanchorBtn, BringPartBtn, AntiLagBtn, SpectatorBtn,
        AnimasiBtn, CloneAvatarBtn, EmoteBtn, FlyV2Btn, FlyV3Btn, RealFlyV3Btn, VehicleFlyBtn, ClickTPBtn, FreeCamBtn, TweenTPBtn, ServerHopBtn, SWPBtn, DexBtn, CmdBarBtn,
        BToolsBtn, ShiftLockBtn, JumpPowerBtn, TPToolBtn, ChatLogsBtn,
        WalkFlingBtn, AntiFlingBtn, FlingAuraBtn, OrbitFlingBtn, HitboxBtn, AutoClickerBtn, AimbotBtn, MaxZoomBtn,
        ClickYeetBtn, LagServerBtn, TouchFlingBtn, PartInspectorBtn
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
        if btn == JumpPowerBtn and JumpPowerBox then
            JumpPowerBox.LayoutOrder = order
            order = order + 1
        end
    end
end)
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
    local invisibleLoop = nil
    local function setInvisible(state)
        if state then
            if not invisibleLoop then
                invisibleLoop = RunService.Stepped:Connect(function()
                    if Player.Character then
                        for _, v in ipairs(Player.Character:GetDescendants()) do
                            if v:IsA("BasePart") or v:IsA("Decal") then
                                if v.Name ~= "HumanoidRootPart" then
                                    v.Transparency = 1
                                end
                            end
                        end
                    end
                end)
                notifyPlayer("Visibility", "Karakter menjadi invisible.")
            end
        else
            if invisibleLoop then
                invisibleLoop:Disconnect()
                invisibleLoop = nil
                if Player.Character then
                    for _, v in ipairs(Player.Character:GetDescendants()) do
                        if v:IsA("BasePart") or v:IsA("Decal") then
                            if v.Name ~= "HumanoidRootPart" then
                                v.Transparency = 0
                            end
                        end
                    end
                end
                notifyPlayer("Visibility", "Karakter sekarang visible.")
            end
        end
    end
    local monitorGui = nil
    local monitorConnection = nil
    _G.ToggleFPSPingMonitor = function()
        if monitorGui then
            if monitorConnection then monitorConnection:Disconnect() end
            monitorGui:Destroy()
            monitorGui = nil
            notifyPlayer("Monitor", "FPS & Ping Monitor ditutup.")
            if FPSPingBtn and typeof(setActive) == "function" then setActive(FPSPingBtn, false) end
        else
            monitorGui = Instance.new("ScreenGui")
            monitorGui.Name = "FPSPingMonitor"
            monitorGui.ResetOnSpawn = false
            if FPSPingBtn and typeof(setActive) == "function" then setActive(FPSPingBtn, true) end
            local guiParent = nil
            if typeof(gethui) == "function" then guiParent = gethui()
            elseif typeof(get_hidden_gui) == "function" then guiParent = get_hidden_gui()
            elseif game:GetService("CoreGui") then guiParent = game:GetService("CoreGui")
            else guiParent = PlayerGui end
            monitorGui.Parent = guiParent
            local monitorFrame = Instance.new("Frame")
            monitorFrame.Size = UDim2.new(0, 140, 0, 70)
            monitorFrame.Position = UDim2.new(1, -150, 0, 10)
            monitorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            monitorFrame.BackgroundTransparency = 0.3
            monitorFrame.BorderSizePixel = 0
            monitorFrame.Active = true
            monitorFrame.Parent = monitorGui
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = monitorFrame
            local topBar = Instance.new("Frame")
            topBar.Size = UDim2.new(1, 0, 0, 20)
            topBar.BackgroundTransparency = 1
            topBar.Parent = monitorFrame
            local dragging = false
            local dragInput, dragStart, startPos
            monitorFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = monitorFrame.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then dragging = false end
                    end)
                end
            end)
            monitorFrame.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    monitorFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 20, 0, 20)
            closeBtn.Position = UDim2.new(1, -25, 0, 2)
            closeBtn.BackgroundTransparency = 1
            closeBtn.Text = "X"
            closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.TextSize = 14
            closeBtn.Parent = monitorFrame
            closeBtn.MouseButton1Click:Connect(function()
                _G.ToggleFPSPingMonitor()
            end)
            local fpsLabel = Instance.new("TextLabel")
            fpsLabel.Size = UDim2.new(1, -30, 0, 25)
            fpsLabel.Position = UDim2.new(0, 10, 0, 15)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.Text = "FPS: ..."
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            fpsLabel.Font = Enum.Font.GothamBold
            fpsLabel.TextSize = 14
            fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
            fpsLabel.Parent = monitorFrame
            local pingLabel = Instance.new("TextLabel")
            pingLabel.Size = UDim2.new(1, -30, 0, 25)
            pingLabel.Position = UDim2.new(0, 10, 0, 40)
            pingLabel.BackgroundTransparency = 1
            pingLabel.Text = "Ping: ..."
            pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            pingLabel.Font = Enum.Font.GothamBold
            pingLabel.TextSize = 14
            pingLabel.TextXAlignment = Enum.TextXAlignment.Left
            pingLabel.Parent = monitorFrame
            local lastUpdate = tick()
            local frames = 0
            monitorConnection = RunService.RenderStepped:Connect(function()
                frames = frames + 1
                local now = tick()
                if now - lastUpdate >= 1 then
                    fpsLabel.Text = "FPS: " .. frames
                    frames = 0
                    lastUpdate = now
                    local ok, pingData = pcall(function()
                        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                    end)
                    if ok and pingData then
                        pingLabel.Text = "Ping: " .. string.format("%.0f", pingData) .. " ms"
                    else
                        pingLabel.Text = "Ping: N/A"
                    end
                end
            end)
            notifyPlayer("Monitor", "FPS & Ping Monitor dibuka.")
        end
    end
    local function toggleFPSMonitor()
        _G.ToggleFPSPingMonitor()
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
        { name = "tptool", aliases = {"tooltp"}, desc = "Aktifkan/nonaktifkan TP Tool di inventory.", usage = "" },
        { name = "tweentp", aliases = {"tween"}, desc = "Aktifkan/nonaktifkan Tween TP (Teleport bertahap).", usage = "" },
        { name = "unanchor", aliases = {}, desc = "Aktifkan/nonaktifkan fitur unanchor parts.", usage = "" },
        { name = "fling", aliases = {"tendang"}, desc = "Aktifkan/nonaktifkan mode fling untuk lempar pemain.", usage = "" },
        { name = "ifling", aliases = {"instantfling"}, desc = "Teleport ke pemain, fling secara instan, lalu balik ke posisi semula.", usage = " [nama]" },
        { name = "walkfling", aliases = {"wfling", "wf", "unwalkfling", "unwfling", "unwf"}, desc = "Aktifkan/nonaktifkan mode walkfling (menendang objek/orang saat berjalan).", usage = "" },
        { name = "antifling", aliases = {"af", "unantifling"}, desc = "Aktifkan/nonaktifkan mode anti-fling agar tidak bisa terlempar oleh orang lain.", usage = "" },
        { name = "flingaura", aliases = {"fa", "unflingaura"}, desc = "Aktifkan/nonaktifkan Fling Aura (menendang musuh yang mendekat secara otomatis).", usage = "" },
        { name = "orbitfling", aliases = {"orbit", "unorbitfling"}, desc = "Aktifkan/nonaktifkan Orbit Fling (mengorbit di sekitar pemain lain untuk menabrak/fling mereka).", usage = " [nama]" },
        { name = "explorer", aliases = {"dex"}, desc = "Buka DEX Explorer.", usage = "" },
        { name = "airwalk", aliases = {"walkonair"}, desc = "Aktifkan/nonaktifkan jalan di udara.", usage = "" },
        { name = "esp", aliases = {}, desc = "Aktifkan/nonaktifkan ESP.", usage = "" },
        { name = "espteam", aliases = {}, desc = "Aktifkan/nonaktifkan ESP Team.", usage = "" },
        { name = "lampu", aliases = {"light", "lamp"}, desc = "Aktifkan/nonaktifkan lampu kepala.", usage = "" },
        { name = "infjump", aliases = {"infinitejump"}, desc = "Aktifkan/nonaktifkan loncat tanpa batas.", usage = "" },
        { name = "jumppower", aliases = {"jp", "jump"}, desc = "Atur tinggi lompatan (50-500) atau aktifkan/nonaktifkan jump power.", usage = " [angka]" },
        { name = "rejoin", aliases = {"rj"}, desc = "Masuk kembali ke server ini.", usage = "" },
        { name = "refresh", aliases = {"re", "respawn"}, desc = "Muat ulang karakter Anda.", usage = "" },
        { name = "antiafk", aliases = {}, desc = "Aktifkan/nonaktifkan anti AFK.", usage = "" },
        { name = "serverhop", aliases = {"shop"}, desc = "Buka menu Server Hop.", usage = "" },
        { name = "bringpart", aliases = {"bp"}, desc = "Aktifkan/nonaktifkan penarik part (blackhole).", usage = "" },
        { name = "yeetparts", aliases = {"yeetall", "yeet"}, desc = "Lempar semua objek di sekitar ke void secara instan.", usage = "" },
        { name = "antilag", aliases = {"boost"}, desc = "Aktifkan/nonaktifkan pengurang lag (Anti Lag).", usage = "" },
        { name = "btools", aliases = {"bt"}, desc = "Dapatkan Building Tools (BTools).", usage = "" },
        { name = "shiftlock", aliases = {"sl"}, desc = "Aktifkan/nonaktifkan Shift Lock.", usage = "" },
        { name = "noclip", aliases = {}, desc = "Aktifkan/nonaktifkan noclip ghost.", usage = "" },
        { name = "spectate", aliases = {"spectator", "view"}, desc = "Buka menu Spectator.", usage = "" },
        { name = "animasi", aliases = {"anims"}, desc = "Buka menu Animasi.", usage = "" },
        { name = "emote", aliases = {"emotes"}, desc = "Buka menu Emote Bypass.", usage = "" },
        { name = "clone", aliases = {"cloneavatar"}, desc = "Clone avatar orang lain.", usage = "[nama]" },
        { name = "headsit", aliases = {}, desc = "Duduk di atas kepala pemain.", usage = " [nama]" },
        { name = "unheadsit", aliases = {"noheadsit"}, desc = "Berhenti duduk di atas kepala pemain.", usage = "" },
        { name = "follow", aliases = {}, desc = "Ikuti pemain secara otomatis.", usage = " [nama]" },
        { name = "unfollow", aliases = {"nofollow"}, desc = "Berhenti mengikuti pemain.", usage = "" },
        { name = "cmdbar", aliases = {}, desc = "Tampilkan Command Bar.", usage = "" },
        { name = "credits", aliases = {}, desc = "Tampilkan info Credits.", usage = "" },
        { name = "players", aliases = {"playerlist", "plist"}, desc = "Menampilkan/menyembunyikan daftar pemain.", usage = "" },
        { name = "friends", aliases = {"friendlist", "flist"}, desc = "Menampilkan/menyembunyikan daftar teman online.", usage = "" },
        { name = "waypoints", aliases = {"wps", "wplist"}, desc = "Menampilkan kategori Waypoints.", usage = "" },
        { name = "menu", aliases = {"mainmenu"}, desc = "Menampilkan kategori Menu Utama.", usage = "" },
        { name = "rusuh", aliases = {}, desc = "Menampilkan kategori Rusuh (trolling).", usage = "" },
        { name = "utility", aliases = {"utils"}, desc = "Menampilkan kategori Utility.", usage = "" },
        { name = "fullbright", aliases = {"fb"}, desc = "Aktifkan/nonaktifkan Fullbright.", usage = "" },
        { name = "hitbox", aliases = {"hb"}, desc = "Atur ukuran hitbox musuh atau aktifkan/nonaktifkan.", usage = " [ukuran]" },
        { name = "aimbot", aliases = {"aim"}, desc = "Aktifkan/nonaktifkan Aimbot.", usage = "" },
        { name = "invisible", aliases = {"invis"}, desc = "Membuat karakter menjadi transparan (invisible lokal).", usage = "" },
        { name = "visible", aliases = {"vis"}, desc = "Membuat karakter kembali terlihat.", usage = "" },
        { name = "fps", aliases = {"fpsmonitor"}, desc = "Tampilkan/sembunyikan monitor FPS.", usage = "" },
        { name = "chatlogs", aliases = {"logs", "clogs", "clog"}, desc = "Menampilkan/menyembunyikan catatan chat (Chat Logs).", usage = "" },
        { name = "maxzoom", aliases = {"mz"}, desc = "Bypass batas jarak zoom kamera.", usage = "" },
        { name = "autoclicker", aliases = {"clicker", "autoclick"}, desc = "Mengaktifkan/mematikan Auto Clicker (PC Only).", usage = "" },
        { name = "sync", aliases = {"syncdance", "copyemote"}, desc = "Menyalin/sinkronisasi animasi dengan pemain lain.", usage = " [nama]" },
        { name = "unsync", aliases = {}, desc = "Berhenti sinkronisasi animasi.", usage = "" }
    }
    table.sort(commandsList, function(a, b)
        return a.name < b.name
    end)
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
        if CmdsFrame:FindFirstChild("ListScroll") then return end
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
        searchIcon.Text = "🔍"
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
        addTranslatable(searchBox, "SearchCmds", "PlaceholderText")
        searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        searchBox.TextSize = 14
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.ClearTextOnFocus = false
        searchBox.Parent = searchFrame
        local barBtn = Instance.new("TextButton")
        barBtn.Name = "OpenBarBtn"
        barBtn.Size = UDim2.new(0, 105, 0, 32)
        barBtn.Position = UDim2.new(1, -110, 0, 5)
        barBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        barBtn.Text = "Command Bar"
        barBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        barBtn.Font = Enum.Font.GothamBold
        barBtn.TextSize = 12
        barBtn.Parent = CmdsFrame
        local barCorner = Instance.new("UICorner")
        barCorner.CornerRadius = UDim.new(0, 6)
        barCorner.Parent = barBtn
        barBtn.MouseButton1Click:Connect(function()
            showCmdBar()
        end)
        local scrollFrame = Instance.new("ScrollingFrame")
        scrollFrame.Name = "ListScroll"
        scrollFrame.Size = UDim2.new(1, -10, 1, -45)
        scrollFrame.Position = UDim2.new(0, 5, 0, 40)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 4
        scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #commandsList * 56 + 15)
        scrollFrame.Visible = true
        scrollFrame.Parent = CmdsFrame
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 8)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = scrollFrame
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
                local cmdNameVal = Instance.new("StringValue")
                cmdNameVal.Name = "CmdNameValue"
                cmdNameVal.Value = cmdData.name
                cmdNameVal.Parent = itemFrame
                local cmdDescVal = Instance.new("StringValue")
                cmdDescVal.Name = "CmdDescValue"
                cmdDescVal.Value = cmdData.desc
                cmdDescVal.Parent = itemFrame
                local dot = Instance.new("Frame")
                dot.Name = "Dot"
                dot.Size = UDim2.new(0, 6, 0, 6)
                dot.Position = UDim2.new(0, 8, 0, 12)
                dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dot.BorderSizePixel = 0
                dot.Parent = itemFrame
                local dotCorner = Instance.new("UICorner")
                dotCorner.CornerRadius = UDim.new(1, 0)
                dotCorner.Parent = dot
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
        local commandText = cleanMsg
        for _, prefix in ipairs({";", "'", "\\", "/", "/e "}) do
            if string.sub(string.lower(cleanMsg), 1, #prefix) == prefix then
                commandText = string.sub(cleanMsg, #prefix + 1):gsub("^%s+", "")
                break
            end
        end
        local args = {}
        for word in string.gmatch(commandText, "%S+") do
            table.insert(args, word)
        end
        if #args == 0 then return end
        local cmd = string.lower(args[1])
        table.remove(args, 1)
        local fullArgString = table.concat(args, " ")
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
                        if typeof(safeTeleportToCFrame) == "function" then
                            safeTeleportToCFrame(cf)
                        else
                            local lplr = game:GetService("Players").LocalPlayer
                            local char = lplr.Character or lplr.CharacterAdded:Wait()
                            if char then char:PivotTo(cf) end
                        end
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
        elseif cmd == "jumppower" or cmd == "jp" or cmd == "jump" then
            local num = tonumber(fullArgString)
            if num then
                num = math.clamp(num, 50, 500)
                desiredJumpPower = num
                if JumpPowerBox then JumpPowerBox.Text = tostring(desiredJumpPower) end
                if jumpPowerOn then
                    local char = Player.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.UseJumpPower = true
                        hum.JumpPower = desiredJumpPower
                    end
                end
            else
                toggleJumpPower()
            end
        elseif cmd == "tptool" or cmd == "tooltp" then
            toggleTPTool()
        elseif cmd == "tweentp" or cmd == "tween" then
            tweenTpEnabled = not tweenTpEnabled
            if TweenTPBtn then
                setButtonActive(TweenTPBtn, tweenTpEnabled)
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
                if target then
                    safeTeleportToPlayer(target)
                else
                    notifyPlayer("Teleport", "Pemain tidak ditemukan: " .. tostring(targetName))
                end
            end
        elseif cmd == "unanchor" then
            toggleUnanchor()
        elseif cmd == "ifling" or cmd == "instantfling" then
            local targetName = fullArgString
            if targetName and targetName ~= "" then
                local target = findPlayerByQuery(targetName)
                if target then
                    local lp = Players.LocalPlayer
                    local myChar = lp and lp.Character
                    local myHrp = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
                    local tChar = target.Character
                    local tHrp = tChar and (tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("Torso"))
                    if myHrp and tHrp then
                        task.spawn(function()
                            local origCF = myHrp.CFrame
                            local origGrav = workspace.Gravity
                            workspace.Gravity = 0
                            for _ = 1, 5 do
                                pcall(function()
                                    myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0.5, 0)
                                    myHrp.AssemblyLinearVelocity = Vector3.new(9e7, 9e8, 9e7)
                                    myHrp.AssemblyAngularVelocity = Vector3.new(9e8, 9e8, 9e8)
                                end)
                                RunService.Heartbeat:Wait()
                            end
                            task.wait(0.2)
                            workspace.Gravity = origGrav
                            pcall(function()
                                myHrp.Anchored = true
                                myHrp.AssemblyLinearVelocity = Vector3.zero
                                myHrp.AssemblyAngularVelocity = Vector3.zero
                                myHrp.CFrame = origCF
                                task.wait(0.1)
                                myHrp.Anchored = false
                            end)
                        end)
                    else
                        notifyPlayer("IFling", "Karakter target/Anda tidak valid.")
                    end
                else
                    notifyPlayer("IFling", "Pemain tidak ditemukan: " .. tostring(targetName))
                end
            end
        elseif cmd == "walkfling" or cmd == "wfling" or cmd == "wf" then
            walkFlingActive = not walkFlingActive
            if walkFlingActive then
                setButtonActive(WalkFlingBtn, true)
                if walkFlingConn then walkFlingConn:Disconnect() end
                walkFlingConn = RunService.Heartbeat:Connect(function()
                    if not walkFlingActive then return end
                    local char = Players.LocalPlayer and Players.LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then task.spawn(doWalkFlingBurst, root) end
                end)
                notifyPlayer("Walk Fling", "Walk Fling aktif.")
            else
                setButtonActive(WalkFlingBtn, false)
                if walkFlingConn then walkFlingConn:Disconnect(); walkFlingConn = nil end
                notifyPlayer("Walk Fling", "Walk Fling mati.")
            end
        elseif cmd == "unwalkfling" or cmd == "unwfling" or cmd == "unwf" then
            walkFlingActive = false
            setButtonActive(WalkFlingBtn, false)
            if walkFlingConn then walkFlingConn:Disconnect(); walkFlingConn = nil end
            notifyPlayer("Walk Fling", "Walk Fling mati.")
        elseif cmd == "antifling" or cmd == "af" then
            antiFlingActive = not antiFlingActive
            if antiFlingActive then
                setButtonActive(AntiFlingBtn, true)
                antiFlingTracked = {}
                local lp = Players.LocalPlayer
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= lp then
                        antiFlingHookChar(plr.Character)
                        table.insert(antiFlingConns, plr.CharacterAdded:Connect(function(char)
                            if antiFlingActive then antiFlingHookChar(char) end
                        end))
                    end
                end
                table.insert(antiFlingConns, Players.PlayerAdded:Connect(function(plr)
                    if plr ~= lp and antiFlingActive then
                        if plr.Character then antiFlingHookChar(plr.Character) end
                        table.insert(antiFlingConns, plr.CharacterAdded:Connect(function(char)
                            if antiFlingActive then antiFlingHookChar(char) end
                        end))
                    end
                end))
                table.insert(antiFlingConns, RunService.PreSimulation:Connect(function()
                    for p in pairs(antiFlingTracked) do
                        pcall(function()
                            if p and p.Parent and p.CanCollide ~= false then
                                p.CanCollide = false
                            end
                        end)
                    end
                end))
                notifyPlayer("Anti Fling", "Anti Fling aktif.")
            else
                setButtonActive(AntiFlingBtn, false)
                for _, c in ipairs(antiFlingConns) do pcall(function() c:Disconnect() end) end
                antiFlingConns = {}
                for p in pairs(antiFlingTracked) do
                    pcall(function() if p and p.Parent then p.CanCollide = true end end)
                end
                antiFlingTracked = {}
                notifyPlayer("Anti Fling", "Anti Fling mati.")
            end
        elseif cmd == "unantifling" then
            antiFlingActive = false
            setButtonActive(AntiFlingBtn, false)
            for _, c in ipairs(antiFlingConns) do pcall(function() c:Disconnect() end) end
            antiFlingConns = {}
            for p in pairs(antiFlingTracked) do
                pcall(function() if p and p.Parent then p.CanCollide = true end end)
            end
            antiFlingTracked = {}
            notifyPlayer("Anti Fling", "Anti Fling mati.")
        elseif cmd == "flingaura" or cmd == "fa" then
            toggleFlingAura()
            notifyPlayer("Fling Aura", flingAuraActive and "Fling Aura aktif." or "Fling Aura mati.")
        elseif cmd == "unflingaura" or cmd == "noflingaura" or cmd == "unfa" then
            toggleFlingAura(false)
            notifyPlayer("Fling Aura", "Fling Aura mati.")
        elseif cmd == "orbitfling" or cmd == "orbit" then
            local targetName = fullArgString
            if targetName and targetName ~= "" then
                local target = findPlayerByQuery(targetName)
                if target then
                    toggleOrbitFling(true, target)
                    notifyPlayer("Orbit Fling", "Mengorbit di sekitar " .. target.Name)
                else
                    notifyPlayer("Orbit Fling", "Pemain tidak ditemukan: " .. targetName)
                end
            else
                toggleOrbitFling()
                notifyPlayer("Orbit Fling", orbitFlingActive and "Orbit Fling aktif." or "Orbit Fling mati.")
            end
        elseif cmd == "unorbitfling" or cmd == "unorbit" or cmd == "noorbit" then
            toggleOrbitFling(false)
            notifyPlayer("Orbit Fling", "Orbit Fling mati.")
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
        elseif cmd == "yeetparts" or cmd == "yeetall" or cmd == "yeet" then
            yeetAllParts()
            notifyPlayer("Yeet Parts", "Semua objek di sekitar telah di-yeet ke void.")
        elseif cmd == "antilag" or cmd == "boost" then
            toggleAntiLag()
        elseif cmd == "btools" or cmd == "bt" then
            toggleBTools()
        elseif cmd == "shiftlock" or cmd == "sl" then
            toggleShiftLock()
        elseif cmd == "noclip" then
            toggleNoclip()
        elseif cmd == "spectate" or cmd == "spectator" or cmd == "view" then
            launchSpectator()
        elseif cmd == "animasi" or cmd == "anims" then
            launchAnimasi()
        elseif cmd == "emote" or cmd == "emotes" then
            launchEmote()
        elseif cmd == "clone" or cmd == "cloneavatar" or cmd == "copyavatar" then
            local targetName = fullArgString
            if targetName and targetName ~= "" then
                local target = findPlayerByQuery(targetName)
                if target then
                    cloneAvatar(target)
                else
                    notifyPlayer("Clone Avatar", "Pemain tidak ditemukan: " .. tostring(targetName))
                end
            end
        elseif cmd == "headsit" then
            local targetName = fullArgString
            if targetName and targetName ~= "" then
                local target = findPlayerByQuery(targetName)
                if target then
                    startHeadsit(target)
                else
                    notifyPlayer("Headsit", "Pemain tidak ditemukan: " .. tostring(targetName))
                end
            end
        elseif cmd == "unheadsit" or cmd == "noheadsit" then
            stopHeadsit()
        elseif cmd == "follow" then
            local targetName = fullArgString
            if targetName and targetName ~= "" then
                local target = findPlayerByQuery(targetName)
                if target then
                    startFollow(target)
                else
                    notifyPlayer("Follow", "Pemain tidak ditemukan: " .. tostring(targetName))
                end
            end
        elseif cmd == "unfollow" or cmd == "nofollow" then
            stopFollow()
        elseif cmd == "cmdbar" then
            showCmdBar()
        elseif cmd == "credits" then
            createCreditsWindow()
            setCategory("Credits")
        elseif cmd == "cmds" or cmd == "commands" then
            showCommandsWindow()
        elseif cmd == "fullbright" or cmd == "fb" then
            if toggleFullbright then
                toggleFullbright()
            end
        elseif cmd == "aimbot" or cmd == "aim" then
            if toggleAimbot then
                toggleAimbot()
            end
        elseif cmd == "maxzoom" or cmd == "mz" then
            if toggleMaxZoom then
                toggleMaxZoom()
            end
        elseif cmd == "hitbox" or cmd == "hb" then
            if #args > 0 then
                local size = tonumber(args[1])
                if size then
                    hitboxSize = size
                    if hitboxActive then
                        toggleHitbox(false)
                        toggleHitbox(true)
                    end
                end
            else
                if toggleHitbox then toggleHitbox() end
            end
        elseif cmd == "players" or cmd == "playerlist" or cmd == "plist" then
            if togglePlayerListWindow then
                togglePlayerListWindow()
            end
        elseif cmd == "friends" or cmd == "friendlist" or cmd == "flist" then
            if toggleFriendListWindow then
                toggleFriendListWindow()
            end
        elseif cmd == "waypoints" or cmd == "wps" or cmd == "wplist" then
            if setCategory then
                setCategory("Waypoints")
            end
        elseif cmd == "menu" or cmd == "mainmenu" then
            if setCategory then
                setCategory("Menu")
            end
                 elseif cmd == "rusuh" then
            if CmdListFrame then CmdListFrame:Destroy() CmdListFrame = nil end
            setCategory("Rusuh")
        elseif cmd == "utility" or cmd == "utils" then
            if CmdListFrame then CmdListFrame:Destroy() CmdListFrame = nil end
            setCategory("Utility")
        elseif cmd == "invisible" or cmd == "invis" then
            setInvisible(true)
        elseif cmd == "visible" or cmd == "vis" then
            setInvisible(false)
        elseif cmd == "fps" or cmd == "fpsmonitor" then
            toggleFPSMonitor()
        elseif cmd == "chatlogs" or cmd == "logs" or cmd == "clogs" or cmd == "clog" then
            if toggleChatLogsWindow then
                toggleChatLogsWindow()
            end
        elseif cmd == "autoclicker" or cmd == "clicker" or cmd == "autoclick" then
            if toggleAutoClicker then
                toggleAutoClicker()
            end
        elseif cmd == "sync" or cmd == "syncdance" or cmd == "copyemote" then
            local target = getTargetPlayer(args[1])
            if target then startSyncDance(target) end
        elseif cmd == "unsync" then
            stopSyncDance()
        end
    end
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
    CmdBarFrame = Instance.new("Frame")
    CmdBarFrame.Name = "CmdBarFrame"
    CmdBarFrame.Size = UDim2.new(0, 440, 0, 44)
    CmdBarFrame.Position = UDim2.new(0.5, -220, 0.5, -22)
    CmdBarFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    CmdBarFrame.BackgroundTransparency = 0.1
    CmdBarFrame.Visible = false
    CmdBarFrame.ZIndex = 99999
    CmdBarFrame.Active = true
    CmdBarFrame.Parent = CmdBarGui
    CmdBarFrame:GetPropertyChangedSignal("Visible"):Connect(updateExternalCursorVisibility)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    local function updateDrag(input)
        local delta = input.Position - dragStart
        CmdBarFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    CmdBarFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    CmdBarFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    local cmdCorner = Instance.new("UICorner")
    cmdCorner.CornerRadius = UDim.new(0, 10)
    cmdCorner.Parent = CmdBarFrame
    local cmdStroke = Instance.new("UIStroke")
    cmdStroke.Color = Color3.fromRGB(255, 255, 255)
    cmdStroke.Thickness = 1.5
    cmdStroke.Transparency = 0
    cmdStroke.Parent = CmdBarFrame
    local dragHandle = Instance.new("Frame")
    dragHandle.Name = "DragHandle"
    dragHandle.Size = UDim2.new(1, 0, 1, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.ZIndex = 99999
    dragHandle.Parent = CmdBarFrame
    local CmdBarInput = Instance.new("TextBox")
    CmdBarInput.Name = "CmdBarInput"
    CmdBarInput.Size = UDim2.new(1, -96, 1, -10)
    CmdBarInput.Position = UDim2.new(0, 10, 0, 5)
    CmdBarInput.BackgroundTransparency = 1
    CmdBarInput.Font = Enum.Font.GothamBold
    CmdBarInput.TextSize = 15
    CmdBarInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    CmdBarInput.TextTransparency = 0
    addTranslatable(CmdBarInput, "CmdBarPH", "PlaceholderText")
    CmdBarInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    CmdBarInput.TextXAlignment = Enum.TextXAlignment.Left
    CmdBarInput.Text = ""
    CmdBarInput.ClearTextOnFocus = false
    CmdBarInput.ZIndex = 100000
    CmdBarInput.Parent = CmdBarFrame
    local enterBarBtn = Instance.new("TextButton")
    enterBarBtn.Name = "EnterBarBtn"
    enterBarBtn.Size = UDim2.new(0, 36, 0, 36)
    enterBarBtn.Position = UDim2.new(1, -80, 0, 4)
    enterBarBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    enterBarBtn.Text = "⏎"
    enterBarBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    enterBarBtn.TextSize = 16
    enterBarBtn.Font = Enum.Font.GothamBold
    enterBarBtn.ZIndex = 100001
    enterBarBtn.Parent = CmdBarFrame
    local enterBtnCorner = Instance.new("UICorner")
    enterBtnCorner.CornerRadius = UDim.new(0, 6)
    enterBtnCorner.Parent = enterBarBtn
    enterBarBtn.MouseButton1Click:Connect(function()
        local text = CmdBarInput.Text
        if text and text ~= "" then
            local ok, err = pcall(handleChatCommand, text)
            if not ok then
                warn("Command Bar Error: " .. tostring(err))
            end
        end
        CmdBarInput.Text = ""
        task.defer(function()
            if CmdBarFrame.Visible then
                CmdBarInput:CaptureFocus()
            end
        end)
    end)
    local closeBarBtn = Instance.new("TextButton")
    closeBarBtn.Name = "CloseBarBtn"
    closeBarBtn.Size = UDim2.new(0, 36, 0, 36)
    closeBarBtn.Position = UDim2.new(1, -40, 0, 4)
    closeBarBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeBarBtn.Text = "X"
    closeBarBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBarBtn.TextSize = 16
    closeBarBtn.Font = Enum.Font.GothamBold
    closeBarBtn.ZIndex = 100001
    closeBarBtn.Parent = CmdBarFrame
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBarBtn
    local closeStroke = Instance.new("UIStroke", closeBarBtn)
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1.5
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
        if not CmdBarFrame or not CmdBarFrame:IsDescendantOf(game) then return end
        local cx = CmdBarFrame.Position.X.Offset
        local cy = CmdBarFrame.Position.Y.Offset
        if not CmdBarFrame.Visible then
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
    executingFromCmdBar = false
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
            hideCmdBar()
        end
    end)
    pcall(function()
        local Mouse = Player:GetMouse()
        Mouse.KeyDown:Connect(function(key)
            if key == "'" then
                showCmdBar()
            end
        end)
    end)
    pcall(function()
        if Player then
            Player.Chatted:Connect(function(msg)
                if not executingFromCmdBar then
                    pcall(handleChatCommand, msg)
                end
            end)
        end
    end)
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.MessageReceived:Connect(function(textChatMessage)
                if Player and textChatMessage.TextSource and textChatMessage.TextSource.UserId == Player.UserId then
                    if not executingFromCmdBar then
                        pcall(handleChatCommand, textChatMessage.Text)
                    end
                end
            end)
        end
    end)
end)
if not success then
    warn("Failed to initialize command bar: " .. tostring(err))
end
pcall(function()
    local function applyStrokeToButton(btn)
        if not btn:IsA("TextButton") and not btn:IsA("ImageButton") then return end
        local parent = btn.Parent
        while parent do
            if parent.Name == "QuickPanel" then
                return
            end
            parent = parent.Parent
        end
        if btn.Name == "ClickDetector" or btn.Name == "ModalFix" or (btn.BackgroundTransparency == 1 and btn.Text == "") then
            return
        end
        if btn:FindFirstChildOfClass("UIStroke") then
            return
        end
        local s = Instance.new("UIStroke")
        s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        local textColor = btn:IsA("TextButton") and btn.TextColor3 or nil
        if textColor == Color3.fromRGB(255, 255, 255) then
            s.Color = Color3.fromRGB(80, 80, 80)
        elseif textColor == Color3.fromRGB(255, 50, 50) then
            s.Color = Color3.fromRGB(255, 50, 50)
        else
            s.Color = textColor or Color3.fromRGB(120, 120, 120)
        end
        s.Parent = btn
    end
    ScreenGui.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
            task.defer(function()
                if descendant.Parent then
                    applyStrokeToButton(descendant)
                end
            end)
        end
    end)
    for _, descendant in ipairs(ScreenGui:GetDescendants()) do
        if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
            applyStrokeToButton(descendant)
        end
    end
end)
local ScannerState = {
    Frame = nil,
    Scroll = nil,
    AutoRefresh = nil,
    BringHeartbeat = nil,
    IsScanning = false
}
local function StopScannerBring()
    if scannerBroughtPart then
        local part = scannerBroughtPart
        scannerBroughtPart = nil
        if ScannerState.BringHeartbeat then
            pcall(function() ScannerState.BringHeartbeat:Disconnect() end)
            ScannerState.BringHeartbeat = nil
        end
        pcall(function()
            local torq = part:FindFirstChild("ScannerBringTorque")
            local align = part:FindFirstChild("ScannerBringAlign")
            local att = part:FindFirstChild("ScannerBringAttachment")
            if torq then torq:Destroy() end
            if align then align:Destroy() end
            if att then att:Destroy() end
            part.CanCollide = true
            part.Anchored = true
        end)
    end
    pcall(refreshPartScanner)
end
local function StartScannerBring(part)
    StopScannerBring()
    if not part or not part.Parent then return end
    scannerBroughtPart = part
    EnableNetwork()
    pcall(function()
        part.CanCollide = false
        part.Anchored = false
        pcall(function() part:BreakJoints() end)
        for _, x in ipairs(part:GetChildren()) do
            if x:IsA("Weld") or x:IsA("WeldConstraint") or x:IsA("ManualWeld") or x:IsA("Motor6D") then
                pcall(function() x:Destroy() end)
            end
        end
        local char = LocalPlayer.Character
        local hrp = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
        if hrp then
            part.CFrame = hrp.CFrame * CFrame.new(0, 10, 0)
        end
        for _, x in ipairs(part:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then x:Destroy() end
        end
        local torq = part:FindFirstChild("ScannerBringTorque") or Instance.new("Torque", part)
        torq.Name = "ScannerBringTorque"
        torq.Torque = Vector3.new(100000, 100000, 100000)
        local align = part:FindFirstChild("ScannerBringAlign") or Instance.new("AlignPosition", part)
        align.Name = "ScannerBringAlign"
        align.MaxForce = math.huge
        align.MaxVelocity = math.huge
        align.Responsiveness = 200
        local att = part:FindFirstChild("ScannerBringAttachment") or Instance.new("Attachment", part)
        att.Name = "ScannerBringAttachment"
        torq.Attachment0 = att
        align.Attachment0 = att
        align.Attachment1 = Attachment1
    end)
    ScannerState.BringHeartbeat = RunService.Heartbeat:Connect(function()
        if not scannerBroughtPart or not scannerBroughtPart.Parent then
            StopScannerBring()
            return
        end
        pcall(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            scannerBroughtPart.CanCollide = false
            scannerBroughtPart.Anchored = false
            local char = LocalPlayer.Character
            local hrp = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            if hrp then
                scannerBroughtPart.CFrame = hrp.CFrame * CFrame.new(0, 10, 0)
                scannerBroughtPart.AssemblyLinearVelocity = Vector3.new(0, 30, 0)
            end
        end)
    end)
    pcall(refreshPartScanner)
end
local function isCharacterPart(part)
    for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        if p.Character and part:IsDescendantOf(p.Character) then
            return true
        end
    end
    return false
end
function refreshPartScanner()
    if not PartScannerFrame or not PartScannerFrame.Visible then return end
    if ScannerState.IsScanning then return end
    ScannerState.IsScanning = true
    task.spawn(function()
        local lp = game:GetService("Players").LocalPlayer
        local lpPos = nil
        if lp and lp.Character then
            local lpHrp = lp.Character:FindFirstChild("HumanoidRootPart") or lp.Character:FindFirstChild("Torso")
            if lpHrp then lpPos = lpHrp.Position end
        end
        local unanchoredParts = {}
        if scannerBroughtPart and scannerBroughtPart.Parent then
            table.insert(unanchoredParts, scannerBroughtPart)
        end
        local charSet = {}
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr.Character then
                charSet[plr.Character] = true
            end
        end
        local allDescendants = workspace:GetDescendants()
        for i, obj in ipairs(allDescendants) do
            if i % 2000 == 0 then
                task.wait()
                if not PartScannerFrame or not PartScannerFrame.Visible then
                    ScannerState.IsScanning = false
                    return
                end
            end
            if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(workspace.CurrentCamera) then
                if obj ~= scannerBroughtPart then
                    local belongsToChar = false
                    local p = obj.Parent
                    while p and p ~= workspace do
                        if charSet[p] or p:FindFirstChildOfClass("Humanoid") then
                            belongsToChar = true
                            break
                        end
                        p = p.Parent
                    end
                    if not belongsToChar and obj.Name ~= "HumanoidRootPart" and obj.Name ~= "Torso" then
                        table.insert(unanchoredParts, obj)
                    end
                end
            end
        end
        table.sort(unanchoredParts, function(a, b)
            local aPos, bPos
            pcall(function() aPos = a.Position end)
            pcall(function() bPos = b.Position end)
            if aPos and bPos and lpPos then
                return (aPos - lpPos).Magnitude < (bPos - lpPos).Magnitude
            end
            return a.Name < b.Name
        end)
        for _, child in ipairs(ScannerState.Scroll:GetChildren()) do
            if child:IsA("Frame") and child.Name == "PartItem" then child:Destroy() end
        end
        local count = 0
        for _, part in ipairs(unanchoredParts) do
            if count >= 100 then break end
            count = count + 1
            local row = Instance.new("Frame")
            row.Name = "PartItem"
            row.Size = UDim2.new(1, -8, 0, 40)
            row.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            row.BorderSizePixel = 0
            row.LayoutOrder = count
            row:SetAttribute("PartRef", tostring(part))
            row.Parent = ScannerState.Scroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
            local distText = ""
            pcall(function()
                if lpPos then distText = "[" .. math.floor((part.Position - lpPos).Magnitude) .. "m] " end
            end)
            local title = Instance.new("TextLabel", row)
            title.Size = UDim2.new(1, -230, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.TextSize = 11
            title.TextColor3 = Color3.fromRGB(200, 200, 200)
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.TextTruncate = Enum.TextTruncate.AtEnd
            title.Text = "🧱 " .. distText .. part.Name
            local btns = Instance.new("Frame", row)
            btns.Size = UDim2.new(0, 220, 1, 0)
            btns.Position = UDim2.new(1, -224, 0, 0)
            btns.BackgroundTransparency = 1
            local blay = Instance.new("UIListLayout", btns)
            blay.FillDirection = Enum.FillDirection.Horizontal
            blay.Padding = UDim.new(0, 4)
            blay.VerticalAlignment = Enum.VerticalAlignment.Center
            local function makeBtn(txt, col, w, strokeColor)
                local b = Instance.new("TextButton", btns)
                b.Size = UDim2.new(0, w, 0, 28)
                b.BackgroundColor3 = col
                b.Text = txt
                b.Font = Enum.Font.GothamBold
                b.TextSize = 10
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                local s = Instance.new("UIStroke", b)
                s.Color = strokeColor or Color3.fromRGB(40, 40, 45)
                s.Thickness = 1
                s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                return b
            end
            local partBeingBrought = (part == scannerBroughtPart) or (part:FindFirstChild("ScannerBringAlign") ~= nil) or (part:FindFirstChild("BringAlign") ~= nil)
            local bringBtn = makeBtn(partBeingBrought and "Stop" or "Bring", partBeingBrought and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(50, 120, 220), 46, partBeingBrought and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(100, 180, 255))
            bringBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    local isBrought = (part == scannerBroughtPart) or (part:FindFirstChild("ScannerBringAlign") ~= nil) or (part:FindFirstChild("BringAlign") ~= nil)
                    if isBrought then
                        if scannerBroughtPart == part then
                            StopScannerBring()
                        end
                        local torq = part:FindFirstChild("BringTorque") or part:FindFirstChild("ScannerBringTorque")
                        local align = part:FindFirstChild("BringAlign") or part:FindFirstChild("ScannerBringAlign")
                        local att = part:FindFirstChild("BringAttachment") or part:FindFirstChild("ScannerBringAttachment")
                        pcall(function()
                            if torq then torq:Destroy() end
                            if align then align:Destroy() end
                            if att then att:Destroy() end
                        end)
                        part:SetAttribute("ScannerStopped", true)
                        part.Anchored = true
                        bringBtn.Text = "Bring"
                        bringBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
                        local stroke = bringBtn:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(100, 180, 255) end
                    else
                        part:SetAttribute("ScannerStopped", nil)
                        if blackHoleActive then
                            part.Anchored = false
                            ForcePart(part)
                        else
                            StartScannerBring(part)
                        end
                        bringBtn.Text = "Stop"
                        bringBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
                        local stroke = bringBtn:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Color3.fromRGB(255, 150, 50) end
                    end
                end)
            end)
            local tpBtn = makeBtn("Teleport", Color3.fromRGB(150, 50, 150), 70, Color3.fromRGB(220, 100, 220))
            tpBtn.MouseButton1Click:Connect(function()
                if lp and lp.Character then
                    local wasFlyV1Active = getgenv().tpwalking
                    if wasFlyV1Active then
                        getgenv().tpwalking = false
                        task.wait(0.1)
                    end
                    local tHrp = lp.Character:FindFirstChild("HumanoidRootPart") or lp.Character:FindFirstChild("Torso")
                    if tHrp then
                        local targetCF = part.CFrame * CFrame.new(0, 3, 0)
                        if flying then
                            frozenPos = targetCF.Position
                        end
                        tHrp.CFrame = targetCF
                    end
                    if wasFlyV1Active then
                        task.wait(0.1)
                        getgenv().tpwalking = true
                    end
                end
            end)
            local yeetBtn = makeBtn("Yeet", Color3.fromRGB(200, 40, 40), 42, Color3.fromRGB(255, 100, 100))
            yeetBtn.MouseButton1Click:Connect(function()
                if scannerBroughtPart == part then
                    StopScannerBring()
                end
                pcall(function()
                    pcall(function() sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge) end)
                    local char = lp and lp.Character
                    local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
                    if hrp then
                        part.CFrame = hrp.CFrame * CFrame.new(0, 5, 0)
                    end
                    pcall(function() part:BreakJoints() end)
                    part.CanCollide = false
                    part.Anchored = false
                    part.CFrame = CFrame.new(99999, 9999, 99999)
                    part.AssemblyLinearVelocity = Vector3.new(0, 50000, 0)
                    task.wait(0.05)
                    part:Destroy()
                end)
                task.delay(0.2, function() refreshPartScanner() end)
            end)
            local destroyBtn = makeBtn("Destroy", Color3.fromRGB(150, 0, 0), 50, Color3.fromRGB(255, 50, 50))
            destroyBtn.MouseButton1Click:Connect(function()
                if scannerBroughtPart == part then
                    StopScannerBring()
                end
                pcall(function()
                    pcall(function() sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge) end)
                    pcall(function() part:BreakJoints() end)
                    part.CanCollide = false
                    part.Anchored = false
                    part.CFrame = CFrame.new(99999, 9999, 99999)
                    part.AssemblyLinearVelocity = Vector3.new(0, 50000, 0)
                    task.wait(0.05)
                    part:Destroy()
                end)
                task.delay(0.1, function() refreshPartScanner() end)
            end)
        end
        ScannerState.IsScanning = false
    end)
end
function createPartScannerWindow()
    if PartScannerFrame then return end
    PartScannerFrame = Instance.new("Frame", ScreenGui)
    PartScannerFrame.Name = "PartScannerFrame"
    PartScannerFrame.Size = UDim2.new(0, 420, 0, 380)
    PartScannerFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
    PartScannerFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    PartScannerFrame.BackgroundTransparency = 0.1
    PartScannerFrame.BorderSizePixel = 0
    PartScannerFrame.Visible = false
    PartScannerFrame.ClipsDescendants = true
    PartScannerFrame.Active = true
    PartScannerFrame.Draggable = false
    Instance.new("UICorner", PartScannerFrame).CornerRadius = UDim.new(0, 12)
    local scannerModal = Instance.new("TextButton", PartScannerFrame)
    scannerModal.Size = UDim2.new(0, 0, 0, 0)
    scannerModal.BackgroundTransparency = 1
    scannerModal.Text = ""
    scannerModal.Modal = true
    local stroke = Instance.new("UIStroke", PartScannerFrame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    local topBar = Instance.new("Frame", PartScannerFrame)
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    topBar.BorderSizePixel = 0
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 12)
    makeSmoothDraggable(PartScannerFrame, topBar)
    local title = Instance.new("TextLabel", topBar)
    title.Size = UDim2.new(1, -150, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Part Scanner"
    title.TextColor3 = Color3.fromRGB(200, 200, 200)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
    closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = Color3.fromRGB(255, 255, 255)
    closeStroke.Thickness = 1
    closeBtn.MouseButton1Click:Connect(function()
        PartScannerFrame.Visible = false
        if ScannerState.AutoRefresh then
            task.cancel(ScannerState.AutoRefresh)
            ScannerState.AutoRefresh = nil
        end
    end)
    local minBtn = Instance.new("TextButton", topBar)
    minBtn.Size = UDim2.new(0, 22, 0, 22)
    minBtn.Position = UDim2.new(1, -54, 0.5, -11)
    minBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
    local minStroke = Instance.new("UIStroke", minBtn)
    minStroke.Color = Color3.fromRGB(255, 255, 255)
    minStroke.Thickness = 1
    local isMinimized = false
    local normalSize = UDim2.new(0, 420, 0, 380)
    local minimizedSize = UDim2.new(0, 420, 0, 30)
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            minBtn.Text = "+"
            game:GetService("TweenService"):Create(PartScannerFrame, TweenInfo.new(0.25), {Size = minimizedSize}):Play()
            ScannerState.Scroll.Visible = false
        else
            minBtn.Text = "-"
            game:GetService("TweenService"):Create(PartScannerFrame, TweenInfo.new(0.25), {Size = normalSize}):Play()
            ScannerState.Scroll.Visible = true
        end
    end)
    local refreshBtn = Instance.new("TextButton", topBar)
    refreshBtn.Size = UDim2.new(0, 22, 0, 22)
    refreshBtn.Position = UDim2.new(1, -80, 0.5, -11)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    refreshBtn.Text = "R"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)
    local refreshStroke = Instance.new("UIStroke", refreshBtn)
    refreshStroke.Color = Color3.fromRGB(255, 255, 255)
    refreshStroke.Thickness = 1
    refreshBtn.MouseButton1Click:Connect(function()
        refreshPartScanner()
    end)
    local syncBtn = Instance.new("TextButton", topBar)
    syncBtn.Size = UDim2.new(0, 22, 0, 22)
    syncBtn.Position = UDim2.new(1, -106, 0.5, -11)
    syncBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
    syncBtn.Text = "S"
    syncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    syncBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", syncBtn).CornerRadius = UDim.new(0, 6)
    local syncStroke = Instance.new("UIStroke", syncBtn)
    syncStroke.Color = Color3.fromRGB(255, 255, 255)
    syncStroke.Thickness = 1
    syncBtn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Visual Sync",
                Text = "Menyelaraskan visual part dengan server...",
                Duration = 1.5
            })
            local charSet = {}
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr.Character then charSet[plr.Character] = true end
            end
            local count = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(workspace.CurrentCamera) then
                    local isChar = false
                    local p = obj.Parent
                    while p and p ~= workspace do
                        if charSet[p] or p:FindFirstChildOfClass("Humanoid") then
                            isChar = true
                            break
                        end
                        p = p.Parent
                    end
                    if not isChar and string.lower(obj.Name) ~= "baseplate" and obj.Name ~= "Handle" then
                        pcall(function()
                            if obj:IsA("BasePart") then
                                local orig = obj.Transparency
                                obj.Transparency = orig == 1 and 0.99 or 1
                                obj.Transparency = orig
                                obj.AssemblyLinearVelocity = obj.AssemblyLinearVelocity
                            end
                            count = count + 1
                        end)
                    end
                end
                if count % 1000 == 0 then
                    task.wait()
                end
            end
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Visual Sync",
                Text = "Visual sinkron selesai!",
                Duration = 1.5
            })
            pcall(refreshPartScanner)
        end)
    end)
    ScannerState.Scroll = Instance.new("ScrollingFrame", PartScannerFrame)
    ScannerState.Scroll.Size = UDim2.new(1, -16, 1, -42)
    ScannerState.Scroll.Position = UDim2.new(0, 8, 0, 38)
    ScannerState.Scroll.BackgroundTransparency = 1
    ScannerState.Scroll.ScrollBarThickness = 4
    local lay = Instance.new("UIListLayout", ScannerState.Scroll)
    lay.Padding = UDim.new(0, 6)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScannerState.Scroll.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 10)
    end)
    PartScannerFrame:GetPropertyChangedSignal("Visible"):Connect(function()
        if PartScannerFrame.Visible then
            if not ScannerState.AutoRefresh then
                ScannerState.AutoRefresh = task.spawn(function()
                    while PartScannerFrame.Visible do
                        pcall(refreshPartScanner)
                        task.wait(2.5)
                    end
                end)
            end
        else
            if ScannerState.AutoRefresh then
                task.cancel(ScannerState.AutoRefresh)
                ScannerState.AutoRefresh = nil
            end
        end
    end)
end
do
    local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
    Mouse.Button1Down:Connect(function()
        if not PartScannerFrame or not PartScannerFrame.Visible then return end
        local guiObjects = game:GetService("Players").LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(Mouse.X, Mouse.Y)
        for _, obj in ipairs(guiObjects) do
            if obj:IsDescendantOf(PartScannerFrame) then return end
        end
        local target = Mouse.Target
        if not target or not target:IsA("BasePart") or target.Anchored then return end
        local isChar = false
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p.Character and target:IsDescendantOf(p.Character) then
                isChar = true; break
            end
        end
        if isChar then return end
        if not ScannerState.Scroll then return end
        local found = nil
        for _, row in ipairs(ScannerState.Scroll:GetChildren()) do
            if row:IsA("Frame") and row.Name == "PartItem" then
                if row:GetAttribute("PartRef") == tostring(target) then
                    found = row
                    break
                end
            end
        end
        if found then
            local rowPos = found.AbsolutePosition.Y - ScannerState.Scroll.AbsolutePosition.Y + ScannerState.Scroll.CanvasPosition.Y
            game:GetService("TweenService"):Create(ScannerState.Scroll, TweenInfo.new(0.2), {
                CanvasPosition = Vector2.new(0, math.max(0, rowPos - 40))
            }):Play()
            local origCol = found.BackgroundColor3
            found.BackgroundColor3 = Color3.fromRGB(200, 180, 0)
            task.delay(0.4, function()
                pcall(function() found.BackgroundColor3 = origCol end)
            end)
        else
            ScannerState.IsScanning = false
            refreshPartScanner()
        end
    end)
end