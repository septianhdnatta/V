local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ====== Device Verification System ======
local WHITELIST_URL = "https://raw.githubusercontent.com/seohaesu/StrideX/refs/heads/main/svip.txt"
local deviceId = game:GetService("RbxAnalyticsService"):GetClientId()
local isVerified = false

local function checkDeviceVerification()
    local success, result = pcall(function()
        return game:HttpGet(WHITELIST_URL)
    end)
    
    if success and result then
        for line in result:gmatch("[^\r\n]+") do
            if line:match("^%s*(.-)%s*$") == deviceId then
                return true
            end
        end
    end
    return false
end

-- ====== Modern Theme System v5.0 ======
local Themes = {
    Dark = {
        MainBg = Color3.fromRGB(18, 18, 24),
        SecondaryBg = Color3.fromRGB(24, 24, 32),
        BoxBg = Color3.fromRGB(28, 28, 36),
        ItemBg = Color3.fromRGB(32, 32, 42),
        Border = Color3.fromRGB(45, 45, 60),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(108, 121, 255),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Danger = Color3.fromRGB(237, 66, 69),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(142, 146, 166),
        TextMuted = Color3.fromRGB(96, 101, 123)
    },
    Light = {
        MainBg = Color3.fromRGB(255, 255, 255),
        SecondaryBg = Color3.fromRGB(249, 249, 251),
        BoxBg = Color3.fromRGB(245, 245, 248),
        ItemBg = Color3.fromRGB(240, 240, 245),
        Border = Color3.fromRGB(228, 228, 234),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(108, 121, 255),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Danger = Color3.fromRGB(237, 66, 69),
        TextPrimary = Color3.fromRGB(23, 25, 35),
        TextSecondary = Color3.fromRGB(96, 101, 123),
        TextMuted = Color3.fromRGB(142, 146, 166)
    }
}

local currentTheme = "Dark"
local activeTheme = Themes[currentTheme]

-- ====== CUSTOM ANIMATION SYSTEM v5.0 ======
local AnimationPacks = {
    {Name = "2016 Animation (MM2)", Idle = "387947158", Walk = "387947975", Run = "387947975", Jump = "387947158", Fall = "387947158"},
    {Name = "(UGC) Oh Really?", Idle = "98004748982532", Walk = "98004748982532", Run = "98004748982532", Jump = "98004748982532", Fall = "98004748982532"},
    {Name = "Astronaut", Idle = "891621366", Walk = "891667138", Run = "10921039308", Jump = "891627522", Fall = "891617961"},
    {Name = "Adidas Community", Idle = "122257458498464", Walk = "122150855457006", Run = "82598234841035", Jump = "75290611992385", Fall = "98600215928904"},
    {Name = "Bold", Idle = "16738333868", Walk = "16738340646", Run = "16738337225", Jump = "16738336650", Fall = "16738333171"},
    {Name = "(UGC) Slasher", Idle = "140051337061095", Walk = "140051337061095", Run = "140051337061095", Jump = "140051337061095", Fall = "140051337061095"},
    {Name = "(UGC) Retro", Idle = "80479383912838", Walk = "107806791584829", Run = "107806791584829", Jump = "139390570947836", Fall = "80479383912838"},
    {Name = "(UGC) Magician", Idle = "139433213852503", Walk = "139433213852503", Run = "139433213852503", Jump = "139433213852503", Fall = "139433213852503"},
    {Name = "(UGC) John Doe", Idle = "72526127498800", Walk = "72526127498800", Run = "72526127498800", Jump = "72526127498800", Fall = "72526127498800"},
    {Name = "(UGC) Noli", Idle = "139360856809483", Walk = "139360856809483", Run = "139360856809483", Jump = "139360856809483", Fall = "139360856809483"},
    {Name = "(UGC) Coolkid", Idle = "95203125292023", Walk = "95203125292023", Run = "95203125292023", Jump = "95203125292023", Fall = "95203125292023"},
    {Name = "Borock", Idle = "3293641938", Walk = "3293641938", Run = "3236836670", Jump = "3293641938", Fall = "3293641938"},
    {Name = "Bubbly", Idle = "910004836", Walk = "910034870", Run = "10921057244", Jump = "910016857", Fall = "910001910"},
    {Name = "Cartoony", Idle = "742637544", Walk = "742640026", Run = "10921076136", Jump = "742637942", Fall = "742637151"},
    {Name = "Confident", Idle = "1069977950", Walk = "1070017263", Run = "1070001516", Jump = "1069984524", Fall = "1069973677"},
    {Name = "Catwalk Glam", Idle = "133806214992291", Walk = "109168724482748", Run = "81024476153754", Jump = "116936326516985", Fall = "92294537340807"},
    {Name = "Cowboy", Idle = "1014390418", Walk = "1014421541", Run = "1014401683", Jump = "1014394726", Fall = "1014384571"},
    {Name = "Elder", Idle = "10921101664", Walk = "10921111375", Run = "10921104374", Jump = "10921107367", Fall = "10921105765"},
    {Name = "Ghost", Idle = "616006778", Walk = "616013216", Run = "616013216", Jump = "616008936", Fall = "616005863"},
    {Name = "Knight", Idle = "657595757", Walk = "10921127095", Run = "10921121197", Jump = "910016857", Fall = "10921122579"},
    {Name = "Levitation", Idle = "616006778", Walk = "616013216", Run = "616010382", Jump = "616008936", Fall = "616005863"},
    {Name = "Mage", Idle = "707742142", Walk = "707897309", Run = "10921148209", Jump = "10921149743", Fall = "707829716"},
    {Name = "MrToilet", Idle = "4417977954", Walk = "4417977954", Run = "4417979645", Jump = "4417977954", Fall = "4417977954"},
    {Name = "Ninja", Idle = "656117400", Walk = "656121766", Run = "656118852", Jump = "656117878", Fall = "656115606"},
    {Name = "NFL", Idle = "92080889861410", Walk = "110358958299415", Run = "117333533048078", Jump = "119846112151352", Fall = "129773241321032"},
    {Name = "OldSchool", Idle = "10921230744", Walk = "10921244891", Run = "10921240218", Jump = "10921242013", Fall = "10921241244"},
    {Name = "Patrol", Idle = "1149612882", Walk = "1151231493", Run = "1150967949", Jump = "1148811837", Fall = "1148863382"},
    {Name = "Pirate", Idle = "750781874", Walk = "750785693", Run = "750783738", Jump = "750782230", Fall = "750780242"},
    {Name = "Default Retarget", Idle = "95884606664820", Walk = "115825677624788", Run = "102294264237491", Jump = "117150377950987", Fall = "110205622518029"},
    {Name = "Popstar", Idle = "1212900985", Walk = "1212980338", Run = "1212980348", Jump = "1212954642", Fall = "1212900995"},
    {Name = "Princess", Idle = "941003647", Walk = "941028902", Run = "941015281", Jump = "941008832", Fall = "941000007"},
    {Name = "R6", Idle = "12521158637", Walk = "12518152696", Run = "12518152696", Jump = "12520880485", Fall = "12520972571"},
    {Name = "R15 Reanimated", Idle = "4211217646", Walk = "4211223236", Run = "4211220381", Jump = "4211219390", Fall = "4211216152"},
    {Name = "Robot", Idle = "616088211", Walk = "616095330", Run = "10921250460", Jump = "616090535", Fall = "616087089"},
    {Name = "Sneaky", Idle = "1132473842", Walk = "1132510133", Run = "1132494274", Jump = "1132489853", Fall = "1132469004"},
    {Name = "Sports (Adidas)", Idle = "18537376492", Walk = "18537392113", Run = "18537384940", Jump = "18537380791", Fall = "18537367238"},
    {Name = "Soldier", Idle = "3972151362", Walk = "3972151362", Run = "3972151362", Jump = "3972151362", Fall = "3972151362"},
    {Name = "Stylish", Idle = "616136790", Walk = "616146177", Run = "10921276116", Jump = "616139451", Fall = "616134815"},
    {Name = "Stylized Female", Idle = "4708191566", Walk = "4708193840", Run = "4708192705", Jump = "4708188025", Fall = "4708186162"},
    {Name = "Superhero", Idle = "10921288909", Walk = "10921298616", Run = "10921291831", Jump = "10921294559", Fall = "10921293373"},
    {Name = "Toy", Idle = "782841498", Walk = "782843345", Run = "10921306285", Jump = "10921308158", Fall = "782846423"},
    {Name = "Udzal", Idle = "3303162274", Walk = "3303162967", Run = "3303162967", Jump = "3303162967", Fall = "3303162967"},
    {Name = "Vampire", Idle = "1083445855", Walk = "1083473930", Run = "10921320299", Jump = "1083455352", Fall = "1083443587"},
    {Name = "Werewolf", Idle = "1083195517", Walk = "1083178339", Run = "10921336997", Jump = "1083218792", Fall = "1083189019"},
    {Name = "Wicked (Popular)", Idle = "118832222982049", Walk = "92072849924640", Run = "72301599441680", Jump = "104325245285198", Fall = "121152442762481"},
    {Name = "No Boundaries (Walmart)", Idle = "18747067405", Walk = "18747074203", Run = "18747070484", Jump = "18747069148", Fall = "18747062535"},
    {Name = "Zombie", Idle = "616158929", Walk = "616168032", Run = "616163682", Jump = "616161997", Fall = "616157476"},
    {Name = "(UGC) Zombie", Idle = "77672872857991", Walk = "113603435314095", Run = "113603435314095", Jump = "113603435314095", Fall = "113603435314095"},
    {Name = "(UGC) TailWag", Idle = "129026910898635", Walk = "129026910898635", Run = "129026910898635", Jump = "129026910898635", Fall = "129026910898635"},
    {Name = "Gojo", Idle = "95643163365384", Walk = "95643163365384", Run = "95643163365384", Jump = "95643163365384", Fall = "95643163365384"},
    {Name = "Geto", Idle = "85811471336028", Walk = "85811471336028", Run = "85811471336028", Jump = "85811471336028", Fall = "85811471336028"}
}

local currentAnimPackIndex = 1
local animationTracks = {}
local customAnimEnabled = false

-- ====== God Mode System ======
local godModeEnabled = false
local originalHumanoidSettings = {}
local godModeConnection = nil

local function enableGodMode(character)
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    originalHumanoidSettings = {
        MaxHealth = humanoid.MaxHealth,
        Health = humanoid.Health
    }
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    if godModeConnection then
        godModeConnection:Disconnect()
    end
    
    godModeConnection = humanoid.HealthChanged:Connect(function(health)
        if godModeEnabled and health < math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    print("✅ God Mode ENABLED")
end

local function disableGodMode(character)
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    
    if originalHumanoidSettings.MaxHealth then
        humanoid.MaxHealth = originalHumanoidSettings.MaxHealth
        humanoid.Health = originalHumanoidSettings.Health
    end
    
    print("❌ God Mode DISABLED")
end

-- ====== Custom Animation Functions ======
local function stopAllAnimations(humanoid)
    for _, track in pairs(animationTracks) do
        if track and track.IsPlaying then
            track:Stop(0.1)
        end
    end
    animationTracks = {}
end

local function loadCustomAnimation(humanoid, animId, stateName)
    if not humanoid or not animId or animId == "" then return nil end
    
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. animId
    
    local track = humanoid:LoadAnimation(animation)
    animationTracks[stateName] = track
    
    return track
end

local function applyCustomAnimPack(character, packIndex)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local pack = AnimationPacks[packIndex]
    if not pack then return end
    
    stopAllAnimations(humanoid)
    
    -- Load all animations from pack
    loadCustomAnimation(humanoid, pack.Idle, "Idle")
    loadCustomAnimation(humanoid, pack.Walk, "Walk")
    loadCustomAnimation(humanoid, pack.Run, "Run")
    loadCustomAnimation(humanoid, pack.Jump, "Jump")
    loadCustomAnimation(humanoid, pack.Fall, "Fall")
    
    print("✅ Loaded Animation Pack: " .. pack.Name)
end

local function playCustomAnimation(stateName)
    if not customAnimEnabled then return end
    
    local track = animationTracks[stateName]
    if track and not track.IsPlaying then
        -- Stop other animations
        for name, otherTrack in pairs(animationTracks) do
            if name ~= stateName and otherTrack.IsPlaying then
                otherTrack:Stop(0.1)
            end
        end
        
        track:Play(0.1)
    end
end

-- ====== Device Verification UI ======
local function createVerificationUI()
    local guiName = "AutoWalkRecorderPro"
    local oldGui = playerGui:FindFirstChild(guiName)
    if oldGui then oldGui:Destroy() end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = guiName
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    local function addCorner(parent, radius)
        local corner = Instance.new("UICorner", parent)
        corner.CornerRadius = UDim.new(0, radius or 12)
        return corner
    end
    
    local function addStroke(parent, color, thickness)
        local stroke = Instance.new("UIStroke", parent)
        stroke.Color = color or activeTheme.Border
        stroke.Thickness = thickness or 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Transparency = 0
        return stroke
    end
    
    local mainPanel = Instance.new("Frame", screenGui)
    mainPanel.Name = "VerificationPanel"
    mainPanel.Size = UDim2.new(0, 400, 0, 250)
    mainPanel.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainPanel.BackgroundColor3 = activeTheme.MainBg
    mainPanel.BorderSizePixel = 0
    mainPanel.Active = true
    
    addCorner(mainPanel, 16)
    addStroke(mainPanel, activeTheme.Border, 1)
    
    local titleLabel = Instance.new("TextLabel", mainPanel)
    titleLabel.Size = UDim2.new(1, -32, 0, 28)
    titleLabel.Position = UDim2.new(0, 16, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Device Not Verified"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = activeTheme.Warning
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local messageLabel = Instance.new("TextLabel", mainPanel)
    messageLabel.Size = UDim2.new(1, -32, 0, 40)
    messageLabel.Position = UDim2.new(0, 16, 0, 60)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = "Device ID anda belum diverifikasi.\nSilakan copy Device ID dan hubungi admin."
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.TextSize = 12
    messageLabel.TextColor3 = activeTheme.TextSecondary
    messageLabel.TextXAlignment = Enum.TextXAlignment.Center
    messageLabel.TextWrapped = true
    
    local deviceIdBox = Instance.new("Frame", mainPanel)
    deviceIdBox.Size = UDim2.new(1, -32, 0, 48)
    deviceIdBox.Position = UDim2.new(0, 16, 0, 115)
    deviceIdBox.BackgroundColor3 = activeTheme.BoxBg
    deviceIdBox.BorderSizePixel = 0
    
    addCorner(deviceIdBox, 10)
    addStroke(deviceIdBox, activeTheme.Border, 1)
    
    local deviceIdText = Instance.new("TextLabel", deviceIdBox)
    deviceIdText.Size = UDim2.new(1, -16, 1, 0)
    deviceIdText.Position = UDim2.new(0, 8, 0, 0)
    deviceIdText.BackgroundTransparency = 1
    deviceIdText.Text = deviceId
    deviceIdText.Font = Enum.Font.Code
    deviceIdText.TextSize = 11
    deviceIdText.TextColor3 = activeTheme.TextPrimary
    deviceIdText.TextXAlignment = Enum.TextXAlignment.Center
    deviceIdText.TextTruncate = Enum.TextTruncate.AtEnd
    
    local copyBtn = Instance.new("TextButton", mainPanel)
    copyBtn.Size = UDim2.new(1, -32, 0, 44)
    copyBtn.Position = UDim2.new(0, 16, 0, 180)
    copyBtn.BackgroundColor3 = activeTheme.Accent
    copyBtn.BorderSizePixel = 0
    copyBtn.Text = "Copy Device ID"
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = Color3.new(1, 1, 1)
    
    addCorner(copyBtn, 10)
    
    copyBtn.MouseEnter:Connect(function()
        TweenService:Create(copyBtn, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.AccentHover}):Play()
    end)
    
    copyBtn.MouseLeave:Connect(function()
        TweenService:Create(copyBtn, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.Accent}):Play()
    end)
    
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(deviceId)
        copyBtn.Text = "Copied!"
        TweenService:Create(copyBtn, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.Success}):Play()
        task.wait(2)
        copyBtn.Text = "Copy Device ID"
        TweenService:Create(copyBtn, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.Accent}):Play()
    end)
end

-- Check verification at startup
print("Checking device verification...")
isVerified = checkDeviceVerification()

if not isVerified then
    print("Device not verified! ID: " .. deviceId)
    createVerificationUI()
    return
end

print("Device verified! Loading StrideX v5.0...")

-- ====== Universal JSON Parser v5.0 ======
local JSONParser = {}

function JSONParser.detectFormat(data)
    if type(data) ~= "table" then
        return nil, "Invalid data type"
    end
    
    if data.Frames and type(data.Frames) == "table" then
        return JSONParser.detectFormat(data.Frames)
    end
    
    if #data > 0 then
        local firstFrame = data[1]
        
        if type(firstFrame) == "table" and firstFrame.Position and type(firstFrame.Position) == "table" then
            if firstFrame.LookVector and type(firstFrame.LookVector) == "table" then
                return "native", data
            end
        end
        
        if type(firstFrame) == "table" and (firstFrame.cf or firstFrame.CFrame) then
            return "cframe", data
        end
        
        if type(firstFrame) == "table" and (firstFrame.pos or firstFrame.position) then
            return "posrot", data
        end
        
        if type(firstFrame) == "table" then
            if firstFrame.x or firstFrame.X or firstFrame.pos_x or firstFrame.posX or 
               firstFrame.px or firstFrame[1] then
                return "arrayobjects", data
            end
        end
        
        if type(firstFrame) == "number" then
            return "packed", data
        end
    end
    
    for key, value in pairs(data) do
        if type(value) == "table" and #value > 0 then
            return JSONParser.detectFormat(value)
        end
    end
    
    return nil, "Unknown format - no valid frames found"
end

function JSONParser.convertToNative(format, data)
    if format == "native" then
        return data
    end
    
    local converted = {}
    
    if format == "arrayobjects" then
        for i, frame in ipairs(data) do
            local posX, posY, posZ
            
            if type(frame[1]) == "number" then
                posX, posY, posZ = frame[1], frame[2], frame[3]
            else
                posX = frame.x or frame.X or frame.pos_x or frame.posX or frame.px or frame.position_x
                posY = frame.y or frame.Y or frame.pos_y or frame.posY or frame.py or frame.position_y
                posZ = frame.z or frame.Z or frame.pos_z or frame.posZ or frame.pz or frame.position_z
            end
            
            if not (posX and posY and posZ) then
                warn("Frame " .. i .. " missing position data, skipping...")
                continue
            end
            
            local lookX = frame.rotX or frame.rot_x or frame.lookX or frame.look_x or 
                         frame.dirX or frame.dir_x or frame.lx or 0
            local lookY = frame.rotY or frame.rot_y or frame.lookY or frame.look_y or 
                         frame.dirY or frame.dir_y or frame.ly or 0
            local lookZ = frame.rotZ or frame.rot_z or frame.lookZ or frame.look_z or 
                         frame.dirZ or frame.dir_z or frame.lz or -1
            
            local lookMagnitude = math.sqrt(lookX*lookX + lookY*lookY + lookZ*lookZ)
            if lookMagnitude > 0 then
                lookX = lookX / lookMagnitude
                lookY = lookY / lookMagnitude
                lookZ = lookZ / lookMagnitude
            end
            
            local upX = frame.upX or frame.up_x or frame.ux or 0
            local upY = frame.upY or frame.up_y or frame.uy or 1
            local upZ = frame.upZ or frame.up_z or frame.uz or 0
            
            local velX = frame.velX or frame.vel_x or frame.vx or frame.velocityX or 0
            local velY = frame.velY or frame.vel_y or frame.vy or frame.velocityY or 0
            local velZ = frame.velZ or frame.vel_z or frame.vz or frame.velocityZ or 0
            
            local state = frame.state or frame.State or frame.action or "Running"
            
            table.insert(converted, {
                Position = {posX, posY, posZ},
                LookVector = {lookX, lookY, lookZ},
                UpVector = {upX, upY, upZ},
                Velocity = {velX, velY, velZ},
                State = state,
                HumanoidState = "Running",
                BodyFrame = {Motors = {}}
            })
        end
        
    elseif format == "cframe" then
        for _, frame in ipairs(data) do
            local cf = frame.cf or frame.CFrame
            local cfData = type(cf) == "table" and cf or {cf}
            
            if #cfData >= 12 then
                table.insert(converted, {
                    Position = {cfData[1], cfData[2], cfData[3]},
                    LookVector = {cfData[4], cfData[5], cfData[6]},
                    UpVector = {cfData[10], cfData[11], cfData[12]},
                    Velocity = frame.velocity or frame.vel or {0, 0, 0},
                    State = frame.state or frame.State or "Running",
                    HumanoidState = "Running",
                    BodyFrame = frame.BodyFrame or {Motors = {}}
                })
            end
        end
        
    elseif format == "posrot" then
        for _, frame in ipairs(data) do
            local pos = frame.pos or frame.position or frame.Position
            local rot = frame.rot or frame.rotation or frame.Rotation or frame.look or frame.LookVector
            
            if pos and #pos >= 3 then
                table.insert(converted, {
                    Position = {pos[1], pos[2], pos[3]},
                    LookVector = rot and #rot >= 3 and {rot[1], rot[2], rot[3]} or {0, 0, -1},
                    UpVector = frame.up or {0, 1, 0},
                    Velocity = frame.velocity or frame.vel or {0, 0, 0},
                    State = frame.state or "Running",
                    HumanoidState = "Running",
                    BodyFrame = frame.BodyFrame or {Motors = {}}
                })
            end
        end
        
    elseif format == "packed" then
        for i = 1, #data, 12 do
            if i + 11 <= #data then
                table.insert(converted, {
                    Position = {data[i], data[i+1], data[i+2]},
                    LookVector = {data[i+3], data[i+4], data[i+5]},
                    UpVector = {data[i+9], data[i+10], data[i+11]},
                    Velocity = {0, 0, 0},
                    State = "Running",
                    HumanoidState = "Running",
                    BodyFrame = {Motors = {}}
                })
            end
        end
    end
    
    return converted
end

-- ====== File System ======
local SAVE_FILE = "Replays.json"
local hasFileAPI = (writefile and readfile and isfile) and true or false

local function safeWrite(data)
    if hasFileAPI then 
        pcall(function()
            writefile(SAVE_FILE, HttpService:JSONEncode(data))
        end)
    end
end

local function safeRead()
    if hasFileAPI and isfile(SAVE_FILE) then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end)
        if ok and decoded then 
            local format, parsedData = JSONParser.detectFormat(decoded)
            if format then
                if format ~= "native" then
                    warn("Detected non-native format: " .. format .. ", converting...")
                    local converted = JSONParser.convertToNative(format, parsedData)
                    if #converted > 0 then
                        return {{Name = "Imported Replay", Frames = converted, Selected = false}}
                    end
                end
            end
            return decoded 
        end
    end
    return {}
end

local function importJSON(jsonString)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(jsonString)
    end)
    
    if not ok then
        return nil, "Failed to parse JSON: " .. tostring(decoded)
    end
    
    local format, parsedData = JSONParser.detectFormat(decoded)
    if not format then
        return nil, parsedData or "Unknown JSON format"
    end
    
    local converted = JSONParser.convertToNative(format, parsedData)
    if #converted == 0 then
        return nil, "No valid frames found after conversion"
    end
    
    return converted, format
end

local savedReplays = safeRead()

-- ====== Full Body Recording System v5.0 ======
local BodyRecorder = {}
BodyRecorder.__index = BodyRecorder

function BodyRecorder.new(character)
    local self = setmetatable({}, BodyRecorder)
    self.character = character
    self.motors = {}
    self.originalC0s = {}
    self.smoothBuffers = {}
    
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            local motorName = descendant.Name
            self.motors[motorName] = descendant
            self.originalC0s[motorName] = descendant.C0
            self.smoothBuffers[motorName] = {}
        end
    end
    
    return self
end

function BodyRecorder:captureFrame()
    local frame = {
        Motors = {}
    }
    
    for name, motor in pairs(self.motors) do
        if motor and motor.Parent then
            local c0 = motor.C0
            local c1 = motor.C1
            frame.Motors[name] = {
                C0 = {c0:GetComponents()},
                C1 = {c1:GetComponents()}
            }
        end
    end
    
    return frame
end

function BodyRecorder:applyFrame(frame, smoothness)
    smoothness = smoothness or 0.3
    
    if not frame or not frame.Motors then return end
    
    for name, data in pairs(frame.Motors) do
        local motor = self.motors[name]
        if motor and motor.Parent then
            local c0Components = data.C0
            local c1Components = data.C1
            
            if c0Components and #c0Components == 12 then
                local targetC0 = CFrame.new(unpack(c0Components))
                
                table.insert(self.smoothBuffers[name], targetC0)
                if #self.smoothBuffers[name] > 3 then
                    table.remove(self.smoothBuffers[name], 1)
                end
                
                local avgC0 = targetC0
                if #self.smoothBuffers[name] > 1 then
                    local sumPos = Vector3.new()
                    local rotations = {}
                    for _, cf in ipairs(self.smoothBuffers[name]) do
                        sumPos = sumPos + cf.Position
                        table.insert(rotations, cf.Rotation)
                    end
                    local avgPos = sumPos / #self.smoothBuffers[name]
                    avgC0 = CFrame.new(avgPos) * rotations[#rotations]
                end
                
                motor.C0 = motor.C0:Lerp(avgC0, smoothness)
            end
            
            if c1Components and #c1Components == 12 then
                local targetC1 = CFrame.new(unpack(c1Components))
                motor.C1 = motor.C1:Lerp(targetC1, smoothness)
            end
        end
    end
end

function BodyRecorder:reset()
    for name, motor in pairs(self.motors) do
        if motor and motor.Parent and self.originalC0s[name] then
            motor.C0 = self.originalC0s[name]
        end
    end
    self.smoothBuffers = {}
    for name in pairs(self.motors) do
        self.smoothBuffers[name] = {}
    end
end

function BodyRecorder:cleanup()
    self:reset()
    self.motors = {}
    self.originalC0s = {}
    self.smoothBuffers = {}
end

-- ====== ENHANCED Animation Controller v5.0 ======
local AnimationController = {}
AnimationController.__index = AnimationController

function AnimationController.new(character)
    local self = setmetatable({}, AnimationController)
    self.character = character
    self.humanoid = character:WaitForChild("Humanoid")
    self.hrp = character:WaitForChild("HumanoidRootPart")
    self.currentState = "Idle"
    self.targetCFrame = nil
    self.lerpAlpha = 0.3
    self.previousVelocity = Vector3.new()
    self.stateBuffer = {}
    self.bufferSize = 8
    self.positionBuffer = {}
    self.positionBufferSize = 4
    self.lastJumpTime = 0
    self.jumpCooldown = 0.2
    self.rotationBuffer = {}
    self.rotationBufferSize = 3
    
    -- Ground Detection System
    self.isGrounded = false
    self.groundCheckDistance = 4
    self.lastGroundedTime = 0
    self.airTime = 0
    
    -- Jump System
    self.isJumping = false
    self.jumpStartTime = 0
    self.jumpDuration = 0
    self.preJumpFrames = 0
    
    return self
end

function AnimationController:checkGroundBelow()
    if not self.hrp or not self.hrp.Parent then
        return false
    end
    
    local origin = self.hrp.Position
    local direction = Vector3.new(0, -self.groundCheckDistance, 0)
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {self.character}
    
    local result = workspace:Raycast(origin, direction, rayParams)
    
    if result then
        self.lastGroundedTime = tick()
        self.airTime = 0
        return true
    else
        self.airTime = tick() - self.lastGroundedTime
        return false
    end
end

function AnimationController:smoothMoveTo(targetCF, velocity)
    if not self.character or not self.hrp or not self.hrp.Parent then
        return
    end
    
    self.isGrounded = self:checkGroundBelow()
    
    local smoothedVelocity = self.previousVelocity:Lerp(velocity, 0.4)
    self.previousVelocity = smoothedVelocity
    
    table.insert(self.positionBuffer, targetCF.Position)
    if #self.positionBuffer > self.positionBufferSize then
        table.remove(self.positionBuffer, 1)
    end
    
    local avgPosition = targetCF.Position
    if #self.positionBuffer > 1 then
        local sumPos = Vector3.new()
        for _, pos in ipairs(self.positionBuffer) do
            sumPos = sumPos + pos
        end
        avgPosition = sumPos / #self.positionBuffer
    end
    
    table.insert(self.rotationBuffer, targetCF.LookVector)
    if #self.rotationBuffer > self.rotationBufferSize then
        table.remove(self.rotationBuffer, 1)
    end
    
    local avgLookVector = targetCF.LookVector
    if #self.rotationBuffer > 1 then
        local sumLook = Vector3.new()
        for _, look in ipairs(self.rotationBuffer) do
            sumLook = sumLook + look
        end
        avgLookVector = (sumLook / #self.rotationBuffer).Unit
    end
    
    local smoothCF = CFrame.lookAt(avgPosition, avgPosition + avgLookVector)
    self.hrp.CFrame = self.hrp.CFrame:Lerp(smoothCF, self.lerpAlpha)
    self.hrp.AssemblyLinearVelocity = smoothedVelocity
end

function AnimationController:applyRecordedState(recordedState)
    if not self.humanoid then return end
    
    -- Play custom animation if enabled
    if customAnimEnabled then
        playCustomAnimation(recordedState)
    end
    
    if recordedState == "Jumping" then
        if not self.isJumping then
            self.humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            self.isJumping = true
            self.jumpStartTime = tick()
        end
    elseif recordedState == "Falling" then
        if self.airTime > 0.3 then
            self.humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    elseif recordedState == "Running" then
        self.humanoid.WalkSpeed = 22
        self.isJumping = false
    elseif recordedState == "Walking" then
        self.humanoid.WalkSpeed = 16
        self.isJumping = false
    else
        self.humanoid.WalkSpeed = 16
        self.isJumping = false
    end
    
    self.currentState = recordedState
end

function AnimationController:applyState(state, forceJump)
    table.insert(self.stateBuffer, state)
    if #self.stateBuffer > self.bufferSize then
        table.remove(self.stateBuffer, 1)
    end
    
    local stateCount = {}
    for _, s in ipairs(self.stateBuffer) do
        stateCount[s] = (stateCount[s] or 0) + 1
    end
    
    local dominantState = state
    local maxCount = 0
    for s, count in pairs(stateCount) do
        if count > maxCount then
            maxCount = count
            dominantState = s
        end
    end
    
    if self.currentState == dominantState or not self.humanoid then return end
    self.currentState = dominantState
    
    -- Play custom animation if enabled
    if customAnimEnabled then
        playCustomAnimation(dominantState)
    end
    
    local currentTime = tick()
    
    if dominantState == "Idle" then
        self.humanoid.WalkSpeed = 0
    elseif dominantState == "Walking" then
        self.humanoid.WalkSpeed = 16
    elseif dominantState == "Running" then
        self.humanoid.WalkSpeed = 22
    elseif dominantState == "Jumping" then
        if currentTime - self.lastJumpTime > self.jumpCooldown or forceJump then
            self.humanoid.Jump = true
            self.lastJumpTime = currentTime
        end
    elseif dominantState == "Falling" then
        if self.airTime > 0.2 then
            self.humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
end

function AnimationController:detectState(velocity)
    local horizontalSpeed = Vector2.new(velocity.X, velocity.Z).Magnitude
    local verticalSpeed = velocity.Y
    
    self.isGrounded = self:checkGroundBelow()
    
    if self.isGrounded or self.airTime < 0.1 then
        if horizontalSpeed > 18 then
            return "Running"
        elseif horizontalSpeed > 2 then
            return "Walking"
        else
            return "Idle"
        end
    end
    
    if verticalSpeed > 20 then
        return "Jumping"
    elseif verticalSpeed < -20 and self.airTime > 0.2 then
        return "Falling"
    end
    
    if horizontalSpeed > 18 then
        return "Running"
    elseif horizontalSpeed > 2 then
        return "Walking"
    else
        return "Idle"
    end
end

function AnimationController:stopAll()
    self.currentState = "Idle"
    self.targetCFrame = nil
    self.stateBuffer = {}
    self.positionBuffer = {}
    self.rotationBuffer = {}
    self.previousVelocity = Vector3.new()
    self.isJumping = false
    self.airTime = 0
    if self.humanoid then
        self.humanoid.WalkSpeed = 16
    end
end

function AnimationController:cleanup()
    self:stopAll()
end

-- ====== UI Helper Functions ======
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner", parent)
    corner.CornerRadius = UDim.new(0, radius or 12)
    return corner
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = color or activeTheme.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Transparency = 0
    return stroke
end

local function createModernButton(parent, text, emoji, size, position, color)
    local button = Instance.new("TextButton", parent)
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = color or activeTheme.Accent
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = ""
    button.AutoButtonColor = false
    
    addCorner(button, 12)
    
    local emojiLabel = nil
    if emoji then
        emojiLabel = Instance.new("TextLabel", button)
        emojiLabel.Size = UDim2.new(0, 24, 0, 24)
        emojiLabel.Position = UDim2.new(0, 12, 0.5, -12)
        emojiLabel.BackgroundTransparency = 1
        emojiLabel.Text = emoji
        emojiLabel.Font = Enum.Font.GothamBold
        emojiLabel.TextSize = 18
        emojiLabel.TextColor3 = Color3.new(1, 1, 1)
    end
    
    local label = Instance.new("TextLabel", button)
    label.Size = UDim2.new(1, emoji and -44 or -24, 1, 0)
    label.Position = UDim2.new(0, emoji and 40 or 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(
                math.min((color or activeTheme.Accent).R * 255 + 20, 255) / 255,
                math.min((color or activeTheme.Accent).G * 255 + 20, 255) / 255,
                math.min((color or activeTheme.Accent).B * 255 + 20, 255) / 255
            )
        }):Play()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset + 2)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = color or activeTheme.Accent
        }):Play()
        TweenService:Create(button, TweenInfo.new(0.2), {Size = size}):Play()
    end)
    
    return button, emojiLabel, label
end

-- ====== Animation Selection Dialog ======
local screenGui
local animPackLabel

local function createAnimationDialog()
    local dialogBg = Instance.new("Frame", screenGui)
    dialogBg.Size = UDim2.new(1, 0, 1, 0)
    dialogBg.Position = UDim2.new(0, 0, 0, 0)
    dialogBg.BackgroundColor3 = Color3.new(0, 0, 0)
    dialogBg.BackgroundTransparency = 0.6
    dialogBg.BorderSizePixel = 0
    dialogBg.ZIndex = 100
    
    local dialog = Instance.new("Frame", dialogBg)
    dialog.Size = UDim2.new(0, 0, 0, 0)
    dialog.Position = UDim2.new(0.5, 0, 0.5, 0)
    dialog.AnchorPoint = Vector2.new(0.5, 0.5)
    dialog.BackgroundColor3 = activeTheme.MainBg
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 101
    
    addCorner(dialog, 16)
    addStroke(dialog, activeTheme.Border, 2)
    
    TweenService:Create(dialog, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 500, 0, 450)
    }):Play()
    
    local titleLabel = Instance.new("TextLabel", dialog)
    titleLabel.Size = UDim2.new(1, -32, 0, 28)
    titleLabel.Position = UDim2.new(0, 16, 0, 16)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎭 Select Animation Pack"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = activeTheme.TextPrimary
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 102
    
    local descLabel = Instance.new("TextLabel", dialog)
    descLabel.Size = UDim2.new(1, -32, 0, 18)
    descLabel.Position = UDim2.new(0, 16, 0, 48)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = "Choose animation pack for playback (ID: 1-" .. #AnimationPacks .. ")"
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextSize = 11
    descLabel.TextColor3 = activeTheme.TextSecondary
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 102
    
    local scrollFrame = Instance.new("ScrollingFrame", dialog)
    scrollFrame.Size = UDim2.new(1, -32, 0, 290)
    scrollFrame.Position = UDim2.new(0, 16, 0, 76)
    scrollFrame.BackgroundColor3 = activeTheme.BoxBg
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = activeTheme.Border
    scrollFrame.ZIndex = 102
    
    addCorner(scrollFrame, 12)
    
    local listLayout = Instance.new("UIListLayout", scrollFrame)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    
    for i, pack in ipairs(AnimationPacks) do
        local item = Instance.new("TextButton", scrollFrame)
        item.Size = UDim2.new(1, -12, 0, 40)
        item.BackgroundColor3 = i == currentAnimPackIndex and activeTheme.Accent or activeTheme.ItemBg
        item.BorderSizePixel = 0
        item.Text = ""
        item.LayoutOrder = i
        item.ZIndex = 103
        
        addCorner(item, 10)
        
        local idLabel = Instance.new("TextLabel", item)
        idLabel.Size = UDim2.new(0, 40, 1, 0)
        idLabel.Position = UDim2.new(0, 0, 0, 0)
        idLabel.BackgroundTransparency = 1
        idLabel.Text = tostring(i)
        idLabel.Font = Enum.Font.GothamBold
        idLabel.TextSize = 16
        idLabel.TextColor3 = i == currentAnimPackIndex and Color3.new(1, 1, 1) or activeTheme.Accent
        idLabel.ZIndex = 104
        
        local nameLabel = Instance.new("TextLabel", item)
        nameLabel.Size = UDim2.new(1, -50, 1, 0)
        nameLabel.Position = UDim2.new(0, 45, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = pack.Name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 12
        nameLabel.TextColor3 = i == currentAnimPackIndex and Color3.new(1, 1, 1) or activeTheme.TextPrimary
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 104
        
        item.MouseButton1Click:Connect(function()
            currentAnimPackIndex = i
            
            -- Update all items
            for _, otherItem in ipairs(scrollFrame:GetChildren()) do
                if otherItem:IsA("TextButton") then
                    local isSelected = otherItem == item
                    otherItem.BackgroundColor3 = isSelected and activeTheme.Accent or activeTheme.ItemBg
                    local otherId = otherItem:FindFirstChild("TextLabel")
                    local otherName = otherItem:FindFirstChildOfClass("TextLabel") and otherItem:FindFirstChildOfClass("TextLabel"):FindFirstChildOfClass("TextLabel")
                    if otherId then
                        otherId.TextColor3 = isSelected and Color3.new(1, 1, 1) or activeTheme.Accent
                    end
                    for _, child in ipairs(otherItem:GetChildren()) do
                        if child:IsA("TextLabel") and child ~= otherId then
                            child.TextColor3 = isSelected and Color3.new(1, 1, 1) or activeTheme.TextPrimary
                        end
                    end
                end
            end
            
            -- Apply animation pack
            if player.Character then
                applyCustomAnimPack(player.Character, currentAnimPackIndex)
            end
            
            -- Update main UI label
            if animPackLabel then
                animPackLabel.Text = string.format("Animation: %d - %s", currentAnimPackIndex, pack.Name)
            end
        end)
        
        item.MouseEnter:Connect(function()
            if i ~= currentAnimPackIndex then
                TweenService:Create(item, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.BoxBg}):Play()
            end
        end)
        
        item.MouseLeave:Connect(function()
            if i ~= currentAnimPackIndex then
                TweenService:Create(item, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.ItemBg}):Play()
            end
        end)
    end
    
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
    end)
    
    local buttonContainer = Instance.new("Frame", dialog)
    buttonContainer.Size = UDim2.new(1, -32, 0, 52)
    buttonContainer.Position = UDim2.new(0, 16, 1, -68)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.ZIndex = 102
    
    local closeBtn = Instance.new("TextButton", buttonContainer)
    closeBtn.Size = UDim2.new(1, 0, 1, 0)
    closeBtn.Position = UDim2.new(0, 0, 0, 0)
    closeBtn.BackgroundColor3 = activeTheme.Accent
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Apply & Close"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.ZIndex = 103
    
    addCorner(closeBtn, 12)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.AccentHover}):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = activeTheme.Accent}):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(dialog, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.2)
        dialogBg:Destroy()
    end)
    
    return dialogBg
end

-- Continue dengan UI setup...
local guiName = "AutoWalkRecorderPro"
local oldGui = playerGui:FindFirstChild(guiName)
if oldGui then oldGui:Destroy() end

screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainPanel = Instance.new("Frame", screenGui)
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.new(0, 400, 0, 650)
mainPanel.Position = UDim2.new(0.5, -200, 0.5, -325)
mainPanel.BackgroundColor3 = activeTheme.MainBg
mainPanel.BorderSizePixel = 0
mainPanel.Active = true
mainPanel.Draggable = true
mainPanel.ClipsDescendants = true

addCorner(mainPanel, 18)
addStroke(mainPanel, activeTheme.Border, 2)

local contentContainer = Instance.new("Frame", mainPanel)
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.Position = UDim2.new(0, 0, 0, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.BorderSizePixel = 0

local header = Instance.new("Frame", mainPanel)
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = activeTheme.SecondaryBg
header.BorderSizePixel = 0
header.ZIndex = 2

addCorner(header, 18)

local statusIndicator = Instance.new("Frame", header)
statusIndicator.Size = UDim2.new(0, 12, 0, 12)
statusIndicator.Position = UDim2.new(0, 12, 0.5, -6)
statusIndicator.BackgroundColor3 = activeTheme.Success
statusIndicator.BorderSizePixel = 0

addCorner(statusIndicator, 6)

task.spawn(function()
    while true do
        TweenService:Create(statusIndicator, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0.7
        }):Play()
        task.wait(0.8)
        TweenService:Create(statusIndicator, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
            BackgroundTransparency = 0
        }):Play()
        task.wait(0.8)
    end
end)

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, -180, 0, 22)
titleLabel.Position = UDim2.new(0, 28, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "StrideX v5.0"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = activeTheme.TextPrimary
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local subtitleLabel = Instance.new("TextLabel", header)
subtitleLabel.Size = UDim2.new(1, -180, 0, 14)
subtitleLabel.Position = UDim2.new(0, 28, 0, 34)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Custom Animations • God Mode • Raycast"
subtitleLabel.Font = Enum.Font.GothamMedium
subtitleLabel.TextSize = 10
subtitleLabel.TextColor3 = activeTheme.TextMuted
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local themeBtn = Instance.new("TextButton", header)
themeBtn.Size = UDim2.new(0, 36, 0, 36)
themeBtn.Position = UDim2.new(1, -120, 0.5, -18)
themeBtn.BackgroundColor3 = activeTheme.BoxBg
themeBtn.Text = currentTheme == "Dark" and "🌙" or "☀️"
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 18
themeBtn.BorderSizePixel = 0

addCorner(themeBtn, 12)

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 36, 0, 36)
minimizeBtn.Position = UDim2.new(1, -78, 0.5, -18)
minimizeBtn.BackgroundColor3 = activeTheme.BoxBg
minimizeBtn.Text = "─"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = activeTheme.TextPrimary
minimizeBtn.BorderSizePixel = 0

addCorner(minimizeBtn, 12)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -36, 0.5, -18)
closeBtn.BackgroundColor3 = activeTheme.Danger
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BorderSizePixel = 0

addCorner(closeBtn, 12)

local minimizedBtn = Instance.new("TextButton", screenGui)
minimizedBtn.Size = UDim2.new(0, 70, 0, 70)
minimizedBtn.Position = UDim2.new(0.5, -35, 0.5, -35)
minimizedBtn.BackgroundColor3 = activeTheme.Accent
minimizedBtn.BorderSizePixel = 0
minimizedBtn.Text = "📱"
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.TextSize = 32
minimizedBtn.Visible = false
minimizedBtn.ZIndex = 50
minimizedBtn.Active = true
minimizedBtn.Draggable = true

addCorner(minimizedBtn, 35)
addStroke(minimizedBtn, activeTheme.Border, 3)

local controlBox = Instance.new("Frame", contentContainer)
controlBox.Size = UDim2.new(1, -24, 0, 410)
controlBox.Position = UDim2.new(0, 12, 0, 72)
controlBox.BackgroundColor3 = activeTheme.BoxBg
controlBox.BorderSizePixel = 0
controlBox.ZIndex = 10

addCorner(controlBox, 14)

local statusIconBg = Instance.new("Frame", controlBox)
statusIconBg.Size = UDim2.new(0, 48, 0, 48)
statusIconBg.Position = UDim2.new(0, 12, 0, 12)
statusIconBg.BackgroundColor3 = activeTheme.Accent
statusIconBg.BorderSizePixel = 0
statusIconBg.ZIndex = 11

addCorner(statusIconBg, 12)

local statusIcon = Instance.new("TextLabel", statusIconBg)
statusIcon.Size = UDim2.new(1, 0, 1, 0)
statusIcon.BackgroundTransparency = 1
statusIcon.Text = "▶️"
statusIcon.Font = Enum.Font.GothamBold
statusIcon.TextSize = 24
statusIcon.TextColor3 = Color3.new(1, 1, 1)
statusIcon.ZIndex = 12

local statusTitle = Instance.new("TextLabel", controlBox)
statusTitle.Size = UDim2.new(1, -72, 0, 20)
statusTitle.Position = UDim2.new(0, 68, 0, 16)
statusTitle.BackgroundTransparency = 1
statusTitle.Text = "Ready"
statusTitle.Font = Enum.Font.GothamBold
statusTitle.TextSize = 14
statusTitle.TextColor3 = activeTheme.TextPrimary
statusTitle.TextXAlignment = Enum.TextXAlignment.Left
statusTitle.ZIndex = 11

local statusDesc = Instance.new("TextLabel", controlBox)
statusDesc.Size = UDim2.new(1, -72, 0, 16)
statusDesc.Position = UDim2.new(0, 68, 0, 38)
statusDesc.BackgroundTransparency = 1
statusDesc.Text = "Full Body • Raycast • Frames: 0"
statusDesc.Font = Enum.Font.GothamMedium
statusDesc.TextSize = 10
statusDesc.TextColor3 = activeTheme.TextSecondary
statusDesc.TextXAlignment = Enum.TextXAlignment.Left
statusDesc.ZIndex = 11

local separator1 = Instance.new("Frame", controlBox)
separator1.Size = UDim2.new(1, -20, 0, 2)
separator1.Position = UDim2.new(0, 10, 0, 72)
separator1.BackgroundColor3 = activeTheme.Border
separator1.BorderSizePixel = 0
separator1.ZIndex = 11

local controlTitle = Instance.new("TextLabel", controlBox)
controlTitle.Size = UDim2.new(1, -20, 0, 18)
controlTitle.Position = UDim2.new(0, 10, 0, 82)
controlTitle.BackgroundTransparency = 1
controlTitle.Text = "CONTROLS"
controlTitle.Font = Enum.Font.GothamBold
controlTitle.TextSize = 11
controlTitle.TextColor3 = activeTheme.TextMuted
controlTitle.TextXAlignment = Enum.TextXAlignment.Left
controlTitle.ZIndex = 11

local recordBtn, recordEmoji, recordLabel = createModernButton(controlBox, "Record", "⏺️", UDim2.new(0.48, -5, 0, 44), UDim2.new(0, 10, 0, 106), activeTheme.Danger)
recordBtn.ZIndex = 11
if recordEmoji then recordEmoji.ZIndex = 12 end
recordLabel.ZIndex = 12

local saveBtn, saveEmoji, saveLabel = createModernButton(controlBox, "Save", "💾", UDim2.new(0.48, -5, 0, 44), UDim2.new(0.52, 5, 0, 106), activeTheme.Success)
saveBtn.ZIndex = 11
if saveEmoji then saveEmoji.ZIndex = 12 end
saveLabel.ZIndex = 12

local loadBtn, loadEmoji, loadLabel = createModernButton(controlBox, "Load JSON", "📂", UDim2.new(0.48, -5, 0, 44), UDim2.new(0, 10, 0, 156), activeTheme.Accent)
loadBtn.ZIndex = 11
if loadEmoji then loadEmoji.ZIndex = 12 end
loadLabel.ZIndex = 12

local queueBtn, queueEmoji, queueLabel = createModernButton(controlBox, "Queue", "📋", UDim2.new(0.48, -5, 0, 44), UDim2.new(0.52, 5, 0, 156), Color3.fromRGB(138, 100, 220))
queueBtn.ZIndex = 11
if queueEmoji then queueEmoji.ZIndex = 12 end
queueLabel.ZIndex = 12

local separator2 = Instance.new("Frame", controlBox)
separator2.Size = UDim2.new(1, -20, 0, 2)
separator2.Position = UDim2.new(0, 10, 0, 210)
separator2.BackgroundColor3 = activeTheme.Border
separator2.BorderSizePixel = 0
separator2.ZIndex = 11

-- Speed Input
local currentSpeed = 1
local speedInputBox, speedInputStroke

local speedLabel = Instance.new("TextLabel", controlBox)
speedLabel.Size = UDim2.new(1, -20, 0, 18)
speedLabel.Position = UDim2.new(0, 10, 0, 220)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Playback Speed"
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 12
speedLabel.TextColor3 = activeTheme.TextMuted
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = 11

local speedBox = Instance.new("Frame", controlBox)
speedBox.Size = UDim2.new(1, -20, 0, 44)
speedBox.Position = UDim2.new(0, 10, 0, 242)
speedBox.BackgroundColor3 = activeTheme.SecondaryBg
speedBox.BorderSizePixel = 0
speedBox.ZIndex = 11

addCorner(speedBox, 10)
speedInputStroke = addStroke(speedBox, activeTheme.Border, 2)

speedInputBox = Instance.new("TextBox", speedBox)
speedInputBox.Size = UDim2.new(1, -24, 1, 0)
speedInputBox.Position = UDim2.new(0, 12, 0, 0)
speedInputBox.BackgroundTransparency = 1
speedInputBox.Text = tostring(currentSpeed)
speedInputBox.Font = Enum.Font.GothamMedium
speedInputBox.TextSize = 13
speedInputBox.TextColor3 = activeTheme.TextPrimary
speedInputBox.PlaceholderText = "0.1 - 5.0"
speedInputBox.PlaceholderColor3 = activeTheme.TextMuted
speedInputBox.TextXAlignment = Enum.TextXAlignment.Left
speedInputBox.ClearTextOnFocus = false
speedInputBox.ZIndex = 12

speedInputBox.Focused:Connect(function()
    TweenService:Create(speedInputStroke, TweenInfo.new(0.2), {Color = activeTheme.Accent, Thickness = 3}):Play()
end)

speedInputBox.FocusLost:Connect(function()
    TweenService:Create(speedInputStroke, TweenInfo.new(0.2), {Color = activeTheme.Border, Thickness = 2}):Play()
    local speedValue = tonumber(speedInputBox.Text)
    if speedValue then
        currentSpeed = math.clamp(speedValue, 0.1, 5.0)
        speedInputBox.Text = string.format("%.2f", currentSpeed)
    else
        speedInputBox.Text = string.format("%.2f", currentSpeed)
    end
end)

-- God Mode Button
local godModeBtn, godModeEmoji, godModeLabel = createModernButton(controlBox, "God Mode OFF", "🛡️", UDim2.new(1, -20, 0, 44), UDim2.new(0, 10, 0, 296), Color3.fromRGB(255, 140, 0))
godModeBtn.ZIndex = 11
if godModeEmoji then godModeEmoji.ZIndex = 12 end
godModeLabel.ZIndex = 12

-- Animation Pack Button
local animBtn, animEmoji, animLabel = createModernButton(controlBox, "Animation Pack", "🎭", UDim2.new(1, -20, 0, 44), UDim2.new(0, 10, 0, 350), Color3.fromRGB(139, 69, 255))
animBtn.ZIndex = 11
if animEmoji then animEmoji.ZIndex = 12 end
animLabel.ZIndex = 12

animPackLabel = Instance.new("TextLabel", controlBox)
animPackLabel.Size = UDim2.new(1, -20, 0, 12)
animPackLabel.Position = UDim2.new(0, 10, 0, 398)
animPackLabel.BackgroundTransparency = 1
animPackLabel.Text = "Animation: Disabled"
animPackLabel.Font = Enum.Font.GothamMedium
animPackLabel.TextSize = 9
animPackLabel.TextColor3 = activeTheme.TextMuted
animPackLabel.TextXAlignment = Enum.TextXAlignment.Center
animPackLabel.ZIndex = 11

local replayBox = Instance.new("Frame", contentContainer)
replayBox.Size = UDim2.new(1, -24, 0, 150)
replayBox.Position = UDim2.new(0, 12, 0, 494)
replayBox.BackgroundColor3 = activeTheme.BoxBg
replayBox.BorderSizePixel = 0
replayBox.ZIndex = 10

addCorner(replayBox, 14)

local replayTitle = Instance.new("TextLabel", replayBox)
replayTitle.Size = UDim2.new(1, -130, 0, 18)
replayTitle.Position = UDim2.new(0, 10, 0, 10)
replayTitle.BackgroundTransparency = 1
replayTitle.Text = "SAVED REPLAYS"
replayTitle.Font = Enum.Font.GothamBold
replayTitle.TextSize = 11
replayTitle.TextColor3 = activeTheme.TextMuted
replayTitle.TextXAlignment = Enum.TextXAlignment.Left
replayTitle.ZIndex = 11

local checkAllBtn = Instance.new("TextButton", replayBox)
checkAllBtn.Size = UDim2.new(0, 58, 0, 24)
checkAllBtn.Position = UDim2.new(1, -122, 0, 8)
checkAllBtn.BackgroundColor3 = activeTheme.Success
checkAllBtn.BorderSizePixel = 0
checkAllBtn.Text = "✓ All"
checkAllBtn.Font = Enum.Font.GothamBold
checkAllBtn.TextSize = 10
checkAllBtn.TextColor3 = Color3.new(1, 1, 1)
checkAllBtn.ZIndex = 11

addCorner(checkAllBtn, 8)

local clearAllBtn = Instance.new("TextButton", replayBox)
clearAllBtn.Size = UDim2.new(0, 58, 0, 24)
clearAllBtn.Position = UDim2.new(1, -60, 0, 8)
clearAllBtn.BackgroundColor3 = activeTheme.Danger
clearAllBtn.BorderSizePixel = 0
clearAllBtn.Text = "✗ All"
clearAllBtn.Font = Enum.Font.GothamBold
clearAllBtn.TextSize = 10
clearAllBtn.TextColor3 = Color3.new(1, 1, 1)
clearAllBtn.ZIndex = 11

addCorner(clearAllBtn, 8)

local replayScroll = Instance.new("ScrollingFrame", replayBox)
replayScroll.Size = UDim2.new(1, -20, 1, -42)
replayScroll.Position = UDim2.new(0, 10, 0, 36)
replayScroll.BackgroundTransparency = 1
replayScroll.BorderSizePixel = 0
replayScroll.ScrollBarThickness = 6
replayScroll.ScrollBarImageColor3 = activeTheme.Border
replayScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
replayScroll.ZIndex = 11

local replayLayout = Instance.new("UIListLayout", replayScroll)
replayLayout.SortOrder = Enum.SortOrder.LayoutOrder
replayLayout.Padding = UDim.new(0, 6)

replayLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    replayScroll.CanvasSize = UDim2.new(0, 0, 0, replayLayout.AbsoluteContentSize.Y + 6)
end)

local copyrightLabel = Instance.new("TextLabel", contentContainer)
copyrightLabel.Size = UDim2.new(1, 0, 0, 12)
copyrightLabel.Position = UDim2.new(0, 0, 1, -12)
copyrightLabel.BackgroundTransparency = 1
copyrightLabel.Text = "© Hunwo 2025 • StrideX v5.0"
copyrightLabel.Font = Enum.Font.GothamMedium
copyrightLabel.TextSize = 9
copyrightLabel.TextColor3 = activeTheme.TextMuted
copyrightLabel.TextXAlignment = Enum.TextXAlignment.Center
copyrightLabel.ZIndex = 11

-- ====== BUTTON FUNCTIONS ======
godModeBtn.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    
    if godModeEnabled then
        godModeLabel.Text = "God Mode ON"
        godModeBtn.BackgroundColor3 = activeTheme.Success
        if player.Character then
            enableGodMode(player.Character)
        end
    else
        godModeLabel.Text = "God Mode OFF"
        godModeBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
        if player.Character then
            disableGodMode(player.Character)
        end
    end
end)

animBtn.MouseButton1Click:Connect(function()
    createAnimationDialog()
end)

checkAllBtn.MouseButton1Click:Connect(function()
    for _, replay in ipairs(savedReplays) do
        replay.Selected = true
    end
    refreshReplayList()
    safeWrite(savedReplays)
end)

clearAllBtn.MouseButton1Click:Connect(function()
    for _, replay in ipairs(savedReplays) do
        replay.Selected = false
    end
    refreshReplayList()
    safeWrite(savedReplays)
end)

local function applyTheme()
    activeTheme = Themes[currentTheme]
    mainPanel.BackgroundColor3 = activeTheme.MainBg
    header.BackgroundColor3 = activeTheme.SecondaryBg
    titleLabel.TextColor3 = activeTheme.TextPrimary
    subtitleLabel.TextColor3 = activeTheme.TextMuted
    controlBox.BackgroundColor3 = activeTheme.BoxBg
    statusTitle.TextColor3 = activeTheme.TextPrimary
    statusDesc.TextColor3 = activeTheme.TextSecondary
    statusIconBg.BackgroundColor3 = activeTheme.Accent
    themeBtn.Text = currentTheme == "Dark" and "🌙" or "☀️"
    
    for _, item in ipairs(replayScroll:GetChildren()) do
        if item:IsA("Frame") then
            item.BackgroundColor3 = activeTheme.ItemBg
        end
    end
end

themeBtn.MouseButton1Click:Connect(function()
    currentTheme = currentTheme == "Dark" and "Light" or "Dark"
    applyTheme()
    refreshReplayList()
end)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.4)
        mainPanel.Visible = false
        minimizedBtn.Visible = true
        minimizedBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(minimizedBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 70, 0, 70)
        }):Play()
    else
        TweenService:Create(minimizedBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.3)
        minimizedBtn.Visible = false
        mainPanel.Visible = true
        mainPanel.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
            Size = UDim2.new(0, 400, 0, 650),
            BackgroundTransparency = 0
        }):Play()
    end
end)

minimizedBtn.MouseButton1Click:Connect(function()
    isMinimized = false
    TweenService:Create(minimizedBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    minimizedBtn.Visible = false
    mainPanel.Visible = true
    mainPanel.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainPanel, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
        Size = UDim2.new(0, 400, 0, 650),
        BackgroundTransparency = 0
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    screenGui:Destroy()
end)

-- ====== CHARACTER & RECORDING LOGIC ======
local character, humanoidRootPart, animController, bodyRecorder
local isRecording, isPaused = false, false
local recordData = {}
local currentReplayToken = nil
local autoQueueRunning = false
local frameCount = 0
local recordingConnection = nil

local function onCharacterAdded(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart", 10)
    
    if animController then
        animController:cleanup()
    end
    if bodyRecorder then
        bodyRecorder:cleanup()
    end
    
    if character:FindFirstChild("Humanoid") then
        animController = AnimationController.new(character)
        bodyRecorder = BodyRecorder.new(character)
        
        if godModeEnabled then
            task.wait(0.5)
            enableGodMode(character)
        end
        
        if customAnimEnabled and currentAnimPackIndex > 0 then
            applyCustomAnimPack(character, currentAnimPackIndex)
        end
    end
    
    if isRecording then
        stopRecording()
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then 
    task.spawn(function()
        onCharacterAdded(player.Character)
    end)
end

local function updateStatus(state, animation, frames)
    statusTitle.Text = state or "Ready"
    statusDesc.Text = string.format("Full Body • Raycast • Frames: %d", frames or 0)
    
    local emojiMap = {
        Idle = "▶️",
        Walking = "🚶",
        Running = "🏃",
        Jumping = "⬆️",
        Falling = "⬇️"
    }
    
    statusIcon.Text = emojiMap[animation] or "▶️"
    
    local colorMap = {
        Recording = activeTheme.Danger,
        Playing = activeTheme.Accent,
        Paused = activeTheme.Warning,
        Ready = activeTheme.Success
    }
    
    local color = colorMap[state] or activeTheme.Accent
    TweenService:Create(statusIconBg, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
end

local function startRecording()
    if not humanoidRootPart or not humanoidRootPart.Parent or not bodyRecorder then
        return
    end
    
    recordData = {}
    frameCount = 0
    isRecording = true
    
    recordLabel.Text = "Stop"
    if recordEmoji then recordEmoji.Text = "⏹️" end
    recordBtn.BackgroundColor3 = activeTheme.Warning
    updateStatus("Recording", "Idle", 0)
    
    if recordingConnection then
        recordingConnection:Disconnect()
        recordingConnection = nil
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local lastRecordTime = tick()
    local recordInterval = 1/60
    
    recordingConnection = RunService.Heartbeat:Connect(function()
        if not isRecording then return end
        
        local currentTime = tick()
        if currentTime - lastRecordTime < recordInterval then
            return
        end
        lastRecordTime = currentTime
        
        if humanoidRootPart and humanoidRootPart.Parent and character and character.Parent and bodyRecorder and humanoid then
            local cf = humanoidRootPart.CFrame
            local velocity = humanoidRootPart.AssemblyLinearVelocity
            local humanoidState = humanoid:GetState()
            
            local recordedState = animController:detectState(velocity)
            
            if humanoidState == Enum.HumanoidStateType.Jumping then
                recordedState = "Jumping"
            elseif humanoidState == Enum.HumanoidStateType.Freefall or humanoidState == Enum.HumanoidStateType.Flying then
                if velocity.Y < -15 and animController.airTime > 0.2 then
                    recordedState = "Falling"
                else
                    recordedState = "Jumping"
                end
            end
            
            local bodyFrame = bodyRecorder:captureFrame()
            
            table.insert(recordData, {
                Position = {cf.Position.X, cf.Position.Y, cf.Position.Z},
                LookVector = {cf.LookVector.X, cf.LookVector.Y, cf.LookVector.Z},
                UpVector = {cf.UpVector.X, cf.UpVector.Y, cf.UpVector.Z},
                Velocity = {velocity.X, velocity.Y, velocity.Z},
                State = recordedState,
                HumanoidState = humanoidState.Name,
                BodyFrame = bodyFrame
            })
            
            frameCount = #recordData
            if frameCount % 15 == 0 then
                updateStatus("Recording", recordedState, frameCount)
            end
        else
            stopRecording()
        end
    end)
end

local function stopRecording()
    isRecording = false
    
    if recordingConnection then
        recordingConnection:Disconnect()
        recordingConnection = nil
    end
    
    recordLabel.Text = "Record"
    if recordEmoji then recordEmoji.Text = "⏺️" end
    recordBtn.BackgroundColor3 = activeTheme.Danger
    updateStatus("Ready", "Idle", frameCount)
end

-- ====== PLAY REPLAY WITH CUSTOM ANIMATION ======
local function playReplay(data)
    if not humanoidRootPart or not humanoidRootPart.Parent or not bodyRecorder then
        return
    end
    
    local token = {}
    currentReplayToken = token
    isPaused = false
    
    -- Enable custom animation for playback
    local wasAnimEnabled = customAnimEnabled
    if not customAnimEnabled and currentAnimPackIndex > 0 then
        customAnimEnabled = true
        applyCustomAnimPack(character, currentAnimPackIndex)
    end
    
    task.spawn(function()
        local index, totalFrames = 1, #data
        local humanoid = character:FindFirstChild("Humanoid")
        
        -- TELEPORT TO START POSITION
        local firstFrame = data[1]
        local recordStartPos = Vector3.new(firstFrame.Position[1], firstFrame.Position[2], firstFrame.Position[3])
        local lookVec = Vector3.new(firstFrame.LookVector[1], firstFrame.LookVector[2], firstFrame.LookVector[3])
        local upVec = Vector3.new(firstFrame.UpVector[1], firstFrame.UpVector[2], firstFrame.UpVector[3])
        
        humanoidRootPart.CFrame = CFrame.lookAt(recordStartPos, recordStartPos + lookVec, upVec)
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        
        task.wait(0.1)
        
        local positionOffset = Vector3.new(0, 0, 0)
        local lastState = "Idle"
        
        while index <= totalFrames do
            if currentReplayToken ~= token then break end
            
            while isPaused and currentReplayToken == token do
                if animController then animController:stopAll() end
                updateStatus("Paused", "Idle", math.floor(index))
                task.wait(0.05)
            end
            
            if humanoidRootPart and humanoidRootPart.Parent and character and character.Parent and currentReplayToken == token and bodyRecorder and humanoid then
                local frame = data[math.floor(index)]
                if not frame then break end
                
                local recordedPos = Vector3.new(frame.Position[1], frame.Position[2], frame.Position[3])
                local targetPos = recordedPos + positionOffset
                
                local lookVec = Vector3.new(frame.LookVector[1], frame.LookVector[2], frame.LookVector[3])
                local upVec = Vector3.new(frame.UpVector[1], frame.UpVector[2], frame.UpVector[3])
                local velocity = Vector3.new(frame.Velocity[1], frame.Velocity[2], frame.Velocity[3]) * currentSpeed
                
                local playbackState = frame.State or "Idle"
                
                local targetCFrame = CFrame.lookAt(targetPos, targetPos + lookVec, upVec)
                
                pcall(function()
                    if animController then
                        animController:smoothMoveTo(targetCFrame, velocity)
                        animController:applyRecordedState(playbackState)
                    else
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(targetCFrame, 0.3)
                        humanoidRootPart.AssemblyLinearVelocity = velocity
                    end
                    
                    
                    if frame.BodyFrame and frame.BodyFrame.Motors then
                        bodyRecorder:applyFrame(frame.BodyFrame, 0.3)
                    end
                end)
                
                if index % 5 == 0 then
                    updateStatus("Playing", playbackState, math.floor(index))
                end
                
                lastState = playbackState
            else
                break
            end
            
            index = index + currentSpeed
            task.wait()
        end
        
        if animController then animController:stopAll() end
        if bodyRecorder then bodyRecorder:reset() end
        if currentReplayToken == token then
            currentReplayToken = nil
            updateStatus("Ready", "Idle", totalFrames)
        end
        
        -- Restore animation state
        if not wasAnimEnabled then
            customAnimEnabled = false
            stopAllAnimations(humanoid)
        end
    end)
end

local function playQueue()
    if autoQueueRunning then
        autoQueueRunning = false
        queueLabel.Text = "Queue"
        if queueEmoji then queueEmoji.Text = "📋" end
        queueBtn.BackgroundColor3 = Color3.fromRGB(138, 100, 220)
        updateStatus("Ready", "Idle", 0)
        return
    end
    
    autoQueueRunning = true
    queueLabel.Text = "Stop"
    if queueEmoji then queueEmoji.Text = "⏹️" end
    queueBtn.BackgroundColor3 = activeTheme.Warning
    
    task.spawn(function()
        while autoQueueRunning do
            local queue = {}
            for _, r in ipairs(savedReplays) do
                if r.Selected then
                    table.insert(queue, r.Frames)
                end
            end
            
            if #queue == 0 then
                autoQueueRunning = false
                queueLabel.Text = "Queue"
                if queueEmoji then queueEmoji.Text = "📋" end
                queueBtn.BackgroundColor3 = Color3.fromRGB(138, 100, 220)
                updateStatus("Ready", "Idle", 0)
                return
            end
            
            for i, frames in ipairs(queue) do
                if not autoQueueRunning then break end
                playReplay(frames)
                while currentReplayToken do
                    task.wait(0.1)
                end
                task.wait(0.5)
            end
            
            if character and character:FindFirstChild("Humanoid") and not godModeEnabled then
                character.Humanoid.Health = 0
            end
            if not godModeEnabled then
                player.CharacterAdded:Wait()
                onCharacterAdded(player.Character)
                task.wait(1)
            end
        end
    end)
end

-- ====== REPLAY LIST ITEMS ======
function createReplayItem(saved, index)
    local item = Instance.new("Frame", replayScroll)
    item.Size = UDim2.new(1, 0, 0, 52)
    item.BackgroundColor3 = activeTheme.ItemBg
    item.BorderSizePixel = 0
    item.LayoutOrder = index
    item.ZIndex = 12
    
    addCorner(item, 12)
    
    local checkbox = Instance.new("TextButton", item)
    checkbox.Size = UDim2.new(0, 24, 0, 24)
    checkbox.Position = UDim2.new(0, 10, 0.5, -12)
    checkbox.BackgroundColor3 = saved.Selected and activeTheme.Success or activeTheme.BoxBg
    checkbox.BorderSizePixel = 0
    checkbox.Text = saved.Selected and "✓" or ""
    checkbox.Font = Enum.Font.GothamBold
    checkbox.TextSize = 14
    checkbox.TextColor3 = Color3.new(1, 1, 1)
    checkbox.ZIndex = 13
    
    addCorner(checkbox, 8)
    addStroke(checkbox, saved.Selected and activeTheme.Success or activeTheme.Border, 2)
    
    checkbox.MouseButton1Click:Connect(function()
        saved.Selected = not saved.Selected
        checkbox.Text = saved.Selected and "✓" or ""
        TweenService:Create(checkbox, TweenInfo.new(0.2), {
            BackgroundColor3 = saved.Selected and activeTheme.Success or activeTheme.BoxBg
        }):Play()
        local stroke = checkbox:FindFirstChildOfClass("UIStroke")
        if stroke then
            TweenService:Create(stroke, TweenInfo.new(0.2), {
                Color = saved.Selected and activeTheme.Success or activeTheme.Border
            }):Play()
        end
        safeWrite(savedReplays)
    end)
    
    local nameLabel = Instance.new("TextLabel", item)
    nameLabel.Size = UDim2.new(0, 110, 0, 18)
    nameLabel.Position = UDim2.new(0, 40, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = saved.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 11
    nameLabel.TextColor3 = activeTheme.TextPrimary
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 13
    
    local infoLabel = Instance.new("TextLabel", item)
    infoLabel.Size = UDim2.new(0, 110, 0, 14)
    infoLabel.Position = UDim2.new(0, 40, 0, 30)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = string.format("%d frames • ~%ds", #saved.Frames, math.floor(#saved.Frames / 60))
    infoLabel.Font = Enum.Font.GothamMedium
    infoLabel.TextSize = 9
    infoLabel.TextColor3 = activeTheme.TextSecondary
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.ZIndex = 13
    
    local function createEmojiBtn(emoji, pos, color, callback)
        local btn = Instance.new("TextButton", item)
        btn.Size = UDim2.new(0, 32, 0, 32)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.BorderSizePixel = 0
        btn.Text = emoji
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.ZIndex = 13
        
        addCorner(btn, 10)
        
        btn.MouseButton1Click:Connect(callback)
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 34, 0, 34),
                BackgroundColor3 = Color3.fromRGB(
                    math.min(color.R * 255 + 20, 255) / 255,
                    math.min(color.G * 255 + 20, 255) / 255,
                    math.min(color.B * 255 + 20, 255) / 255
                )
            }):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 32, 0, 32),
                BackgroundColor3 = color
            }):Play()
        end)
        
        return btn
    end
    
    createEmojiBtn("▶️", UDim2.new(0, 160, 0.5, -16), activeTheme.Accent, function()
        playReplay(saved.Frames)
    end)
    
    createEmojiBtn("⏸️", UDim2.new(0, 198, 0.5, -16), activeTheme.Warning, function()
        isPaused = not isPaused
    end)
    
    createEmojiBtn("✏️", UDim2.new(0, 236, 0.5, -16), Color3.fromRGB(138, 100, 220), function()
        local newName = "Replay " .. os.date("%H:%M:%S")
        saved.Name = newName
        nameLabel.Text = newName
        safeWrite(savedReplays)
    end)
    
    createEmojiBtn("🗑️", UDim2.new(0, 274, 0.5, -16), activeTheme.Danger, function()
        TweenService:Create(item, TweenInfo.new(0.3), {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        table.remove(savedReplays, index)
        refreshReplayList()
        safeWrite(savedReplays)
    end)
    
    local upBtn = createEmojiBtn("⬆️", UDim2.new(0, 312, 0, 6), activeTheme.BoxBg, function()
        if index > 1 then
            savedReplays[index], savedReplays[index - 1] = savedReplays[index - 1], savedReplays[index]
            refreshReplayList()
            safeWrite(savedReplays)
        end
    end)
    upBtn.Size = UDim2.new(0, 32, 0, 18)
    upBtn.TextSize = 10
    
    local downBtn = createEmojiBtn("⬇️", UDim2.new(0, 312, 1, -24), activeTheme.BoxBg, function()
        if index < #savedReplays then
            savedReplays[index], savedReplays[index + 1] = savedReplays[index + 1], savedReplays[index]
            refreshReplayList()
            safeWrite(savedReplays)
        end
    end)
    downBtn.Size = UDim2.new(0, 32, 0, 18)
    downBtn.TextSize = 10
end

function refreshReplayList()
    for _, c in ipairs(replayScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    
    for i, r in ipairs(savedReplays) do
        createReplayItem(r, i)
    end
end

refreshReplayList()

recordBtn.MouseButton1Click:Connect(function()
    if isRecording then
        stopRecording()
    else
        startRecording()
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    if #recordData > 0 then
        local timestamp = os.date("%H:%M:%S")
        table.insert(savedReplays, {
            Name = "Replay " .. timestamp,
            Frames = recordData,
            Selected = false
        })
        refreshReplayList()
        safeWrite(savedReplays)
        recordData = {}
        frameCount = 0
        stopRecording()
        updateStatus("Ready", "Idle", 0)
    end
end)

loadBtn.MouseButton1Click:Connect(function()
    print("📂 Import JSON: Use external tool or paste JSON")
end)

queueBtn.MouseButton1Click:Connect(playQueue)

screenGui.Destroying:Connect(function()
    if recordingConnection then
        recordingConnection:Disconnect()
    end
    if animController then 
        animController:cleanup() 
    end
    if bodyRecorder then
        bodyRecorder:cleanup()
    end
    if currentReplayToken then 
        currentReplayToken = nil 
    end
    if godModeConnection then
        godModeConnection:Disconnect()
    end
    stopAllAnimations(player.Character and player.Character:FindFirstChildOfClass("Humanoid"))
    autoQueueRunning = false
    isRecording = false
    godModeEnabled = false
    customAnimEnabled = false
end)

print("╔════════════════════════════════════════════╗")
print("║       STRIDEX v5.0 - CUSTOM ANIMATIONS     ║")
print("╚════════════════════════════════════════════╝")
print("")
print("✅ DEVICE VERIFIED!")
print("✅ v5.0 NEW FEATURES:")
print("   • 🎭 50+ Custom Animation Packs")
print("   • 🎨 Animation Pack Selector (ID: 1-" .. #AnimationPacks .. ")")
print("   • 🛡️ God Mode - No Damage")
print("   • 🏃 Advanced Ground Detection (Raycast)")
print("   • 🦘 Smooth Jump System")
print("   • 📱 Mobile-Friendly UI")
print("")
print("✅ ANIMATION PACKS INCLUDED:")
print("   • 2016 Animation (MM2)")
print("   • Astronaut, Bold, Bubbly, Cartoony")
print("   • Confident, Cowboy, Elder, Ghost")
print("   • Knight, Mage, Ninja, Pirate")
print("   • Princess, Robot, Superhero, Vampire")
print("   • Zombie, Werewolf, Wicked (Popular)")
print("   • Gojo, Geto, UGC Animations")
print("   • And 30+ more!")
print("")
print("🎮 HOW TO USE:")
print("   1. Click 'Animation Pack' button")
print("   2. Select animation by ID (1-" .. #AnimationPacks .. ")")
print("   3. Record or Play replays with animations")
print("   4. Enable God Mode for no damage")
print("")
print("🎯 CONTROLS:")
print("   • Record: Start/Stop recording")
print("   • Save: Save current recording")
print("   • Queue: Auto-play selected replays")
print("   • Animation Pack: Choose custom animations")
print("   • God Mode: Toggle invincibility")
print("")
print("📱 MOBILE & DESKTOP READY!")
print("Device ID: " .. deviceId)
