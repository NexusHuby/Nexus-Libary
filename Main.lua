--[[
    Nexus|Escape Tsunami for Brainrots - Ultimate Edition v12
    NEW: FPS Optimizer, Server Hopper, Rejoin, Discord Webhook Integration
    NEW: Brainrot ESP with Names & Rarity Colors + VIP Wall Bypass
    Fixes: Auto Collect Cash base detection, Instant proximity prompts
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = Workspace.CurrentCamera
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- CRITICAL: Wait for character with timeout
local character = player.Character
if not character then
    character = player.CharacterAdded:Wait()
end

-- CRITICAL: Wait for HumanoidRootPart with retry
local humanoidRootPart, humanoid
local function waitForCharacterParts()
    local startTime = tick()
    while tick() - startTime < 10 do
        character = player.Character
        if character then
            humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            humanoid = character:FindFirstChild("Humanoid")
            if humanoidRootPart and humanoid then
                return true
            end
        end
        task.wait(0.1)
    end
    return false
end

if not waitForCharacterParts() then
    warn("Failed to load character parts! Retrying...")
    character = player.CharacterAdded:Wait()
    waitForCharacterParts()
end

print("Character loaded:", character and character.Name or "NIL")
print("HRP loaded:", humanoidRootPart and "YES" or "NO")
print("Humanoid loaded:", humanoid and "YES" or "NO")

-- Safely get Remotes with error handling
local function getRemote(path, name)
    local success, result = pcall(function()
        local remote = path:WaitForChild(name, 5)
        return remote
    end)
    
    if success and result then
        print("Found remote:", name)
        return result
    else
        warn("Remote not found:", name)
        return nil
    end
end

-- Get Remote Events/Functions safely
local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
local RemoteFunctions = ReplicatedStorage:FindFirstChild("RemoteFunctions")

if not RemoteEvents then
    warn("RemoteEvents folder not found!")
    RemoteEvents = ReplicatedStorage
end

if not RemoteFunctions then
    warn("RemoteFunctions folder not found!")
    RemoteFunctions = ReplicatedStorage
end

-- Get remotes safely
local CollectMoneyEvent = getRemote(RemoteEvents, "CollectMoney")
local UpgradeSpeedFunction = getRemote(RemoteFunctions, "UpgradeSpeed")
local UpgradeCarryFunction = getRemote(RemoteFunctions, "UpgradeCarry")
local SellAllFunction = getRemote(RemoteFunctions, "SellAll")
local SellToolFunction = getRemote(RemoteFunctions, "SellTool")
local RebirthFunction = getRemote(RemoteFunctions, "Rebirth")
local UpdateCollectedBrainrots = getRemote(RemoteEvents, "UpdateCollectedBrainrots")

-- Configuration
local CONFIG = {
    TITLE = "Nexus|Escape Tsunami for Brainrots",
    COLORS = {
        Background = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 0.08,
        Sidebar = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(87, 242, 135),
        Danger = Color3.fromRGB(255, 100, 100),
        White = Color3.fromRGB(255, 255, 255),
        Gray = Color3.fromRGB(180, 180, 180),
        DarkGray = Color3.fromRGB(100, 100, 100),
        Hover = Color3.fromRGB(55, 55, 65),
        ESP = Color3.fromRGB(255, 0, 0),
        DropdownBg = Color3.fromRGB(30, 30, 35),
        DropdownHover = Color3.fromRGB(50, 50, 60),
        DropdownSelected = Color3.fromRGB(70, 70, 85)
    },
    -- RARITY COLORS FOR ESP
    RARITY_COLORS = {
        Common = Color3.fromRGB(169, 169, 169),
        Uncommon = Color3.fromRGB(0, 255, 0),
        Rare = Color3.fromRGB(0, 100, 255),
        Epic = Color3.fromRGB(128, 0, 128),
        Legendary = Color3.fromRGB(255, 215, 0),
        Mythical = Color3.fromRGB(255, 0, 255),
        Secret = Color3.fromRGB(255, 0, 0),
        Divine = Color3.fromRGB(255, 255, 255),
        Celestial = Color3.fromRGB(0, 255, 255),
        Cosmic = Color3.fromRGB(75, 0, 130)
    }
}

-- State Variables
local autoCollectCash = false
local autoUpgradeSpeed = false
local selectedSpeedAmount = 1
local autoUpgradeCarry = false
local autoSellInventory = false
local autoRebirth = false
local autoFarmUltra = false
local ultraFarmCollecting = false
local instantProximityEnabled = false

-- Combat Tab Variables
local hitboxExtenderEnabled = false
local autoHitEnabled = false
local hitboxVisualEnabled = false
local hitboxRange = 10
local hitboxVisualPart = nil
local espEnabled = false
local espObjects = {}
local skeletonESPObjects = {}

-- Event Tab Variables
local autoCollectGoldBars = false
local autoCompleteObby = false
local autoSpinWheel = false
local autoTeleportTickets = false
local autoTeleportConsoles = false

-- Auto Collect Specific Brainrot Variables
local autoCollectSpecificBrainrot = false
local selectedBrainrotToCollect = nil
local isCollectingBrainrot = false

-- Wave Protection Variables
local waveProtectionEnabled = false
local waveProtectionRange = 125
local isHidingFromWave = false
local waveHidePosition = nil
local waveHideStartTime = nil
local currentWavePart = nil
local WAVE_CHECK_INTERVAL = 0.1
local WAVE_SAFETY_BUFFER = 50

-- Auto Clicker Variables
local autoClickerEnabled = false
local autoClickerCPS = 10
local autoClickerButton = nil
local autoClickerLoop = nil

-- Stages Tab Variables
local selectedStage = nil
local autoTweenToStage = false
local isTweeningToStage = false

-- NEW: Brainrot ESP Variables
local brainrotESPEnabled = false
local brainrotESPObjects = {}
local showBrainrotNames = true
local showBrainrotDistance = true
local espMaxDistance = 1000

-- NEW: VIP Wall Bypass Variables
local vipWallBypassEnabled = false
local vipWallNoclip = false

-- NEW: FPS Optimizer Variables
local fpsOptimized = false
local originalSettings = {}

-- NEW: Server Hopper Variables
local serverHopInProgress = false

-- NEW: Discord Webhook Variables
local webhookEnabled = false
local webhookURL = ""
local notifiedBrainrots = {} -- Prevent duplicate notifications
local WEBHOOK_COOLDOWN = 300 -- 5 minutes between notifications for same brainrot

-- Rarity order for brainrot dropdown
local RARITY_ORDER = {
    "Celestial",
    "Cosmic", 
    "Divine",
    "Infinity",
    "Legendary",
    "Mythical",
    "Secret",
    "Epic",
    "Rare",
    "Uncommon",
    "Common"
}

-- Stages/Rarities for VIP Walls
local STAGE_RARITIES = {
    "Common",
    "Uncommon", 
    "Rare",
    "Epic",
    "Legendary",
    "Mythical",
    "Cosmic",
    "Secret",
    "Celestial"
}

-- Priority rarities for Auto Farm Ultra
local PRIORITY_RARITIES = {"Secret", "Divine", "Celestial"}

-- FIXED: Get Player Base
local function getPlayerBase()
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then return nil end
    
    for _, base in ipairs(bases:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local ownerAttr = base:GetAttribute("Owner")
            if ownerAttr == player.UserId then
                return base
            end
        end
    end
    
    for _, base in ipairs(bases:GetChildren()) do
        if base.Name == tostring(player.UserId) or 
           base.Name == player.Name or 
           base.Name:find(tostring(player.UserId)) then
            return base
        end
    end
    
    local closestBase = nil
    local closestDistance = math.huge
    
    for _, base in ipairs(bases:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local slots = base:FindFirstChild("Slots")
            if slots then
                for _, slot in ipairs(slots:GetChildren()) do
                    local ownerValue = slot:FindFirstChild("Owner")
                    if ownerValue and (ownerValue.Value == player.Name or ownerValue.Value == player.UserId) then
                        return base
                    end
                end
                
                local targetPart = base:IsA("Model") and base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart", true)
                if targetPart then
                    local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                    if distance < closestDistance and distance < 500 then
                        closestDistance = distance
                        closestBase = base
                    end
                end
            end
        end
    end
    
    return closestBase
end

-- Get VIP Wall for specific rarity/stage
local function getVIPWallForRarity(rarity)
    local defaultMap = Workspace:FindFirstChild("DefaultMap_SharedInstances")
    if not defaultMap then return nil end
    
    local vipWalls = defaultMap:FindFirstChild("VIPWalls")
    if not vipWalls then return nil end
    
    for _, wall in ipairs(vipWalls:GetChildren()) do
        if wall:IsA("BasePart") or wall:IsA("Model") then
            if wall.Name:find(rarity) or wall.Name:lower():find(rarity:lower()) then
                local targetPart = wall:IsA("BasePart") and wall or wall.PrimaryPart or wall:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    return {
                        part = targetPart,
                        model = wall:IsA("Model") and wall or nil,
                        name = wall.Name,
                        rarity = rarity
                    }
                end
            end
        end
    end
    
    local rarityIndex = table.find(STAGE_RARITIES, rarity)
    if rarityIndex then
        local walls = vipWalls:GetChildren()
        if walls[rarityIndex] then
            local wall = walls[rarityIndex]
            local targetPart = wall:IsA("BasePart") and wall or wall.PrimaryPart or wall:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                return {
                    part = targetPart,
                    model = wall:IsA("Model") and wall or nil,
                    name = wall.Name,
                    rarity = rarity
                }
            end
        end
    end
    
    return nil
end

-- Get all VIP walls in order from Common to target
local function getVIPWallsInOrder(targetRarity)
    local targetIndex = table.find(STAGE_RARITIES, targetRarity)
    if not targetIndex then return {} end
    
    local walls = {}
    for i = 1, targetIndex do
        local rarity = STAGE_RARITIES[i]
        local wallData = getVIPWallForRarity(rarity)
        if wallData then
            table.insert(walls, wallData)
        end
    end
    
    return walls
end

-- Get nearest VIP wall for wave protection
local function getNearestVIPWall()
    local defaultMap = Workspace:FindFirstChild("DefaultMap_SharedInstances")
    if not defaultMap then return nil end
    
    local vipWalls = defaultMap:FindFirstChild("VIPWalls")
    if not vipWalls then return nil end
    
    local nearestWall = nil
    local nearestDist = math.huge
    
    for _, wall in ipairs(vipWalls:GetChildren()) do
        if wall:IsA("BasePart") or wall:IsA("Model") then
            local targetPart = wall:IsA("BasePart") and wall or wall.PrimaryPart or wall:FindFirstChildWhichIsA("BasePart")
            if targetPart then
                local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                if distance < nearestDist then
                    nearestDist = distance
                    nearestWall = {
                        part = targetPart,
                        model = wall:IsA("Model") and wall or nil,
                        name = wall.Name,
                        distance = distance
                    }
                end
            end
        end
    end
    
    return nearestWall
end

-- Safe tween to position with speed parameter
local function safeTweenToPosition(targetPosition, targetCFrame, speed)
    speed = speed or 0.8
    local safeTargetPos = Vector3.new(targetPosition.X, math.max(targetPosition.Y, 15), targetPosition.Z)
    local safeTargetCFrame = CFrame.new(safeTargetPos) * (targetCFrame - targetCFrame.Position)
    
    local finalTween = TweenService:Create(humanoidRootPart, TweenInfo.new(speed), {CFrame = safeTargetCFrame})
    finalTween:Play()
    finalTween.Completed:Wait()
    
    return true
end

-- FAST tween for emergency situations
local function fastTweenToPosition(targetCFrame)
    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.3), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Sequential tween through all VIP walls up to target with speed
local function tweenToStageWallSequential(targetRarity, speed)
    speed = speed or 0.6
    if not targetRarity then return false end
    if isTweeningToStage then return false end
    
    isTweeningToStage = true
    
    local success, result = pcall(function()
        local walls = getVIPWallsInOrder(targetRarity)
        
        if #walls == 0 then return false end
        
        for i, wallData in ipairs(walls) do
            if not isTweeningToStage and not autoFarmUltra then return false end
            
            local targetCFrame = wallData.part.CFrame * CFrame.new(0, 0, -5)
            local tweenTime = (i == #walls) and speed or (speed * 0.8)
            
            local tween = TweenService:Create(
                humanoidRootPart, 
                TweenInfo.new(tweenTime), 
                {CFrame = targetCFrame}
            )
            
            tween:Play()
            tween.Completed:Wait()
        end
        
        return true
    end)
    
    isTweeningToStage = false
    return success and result
end

-- Tween back to base through VIP walls safely
local function tweenBackToBase()
    local base = getPlayerBase()
    if not base then return false end
    
    local basePart = base:FindFirstChildWhichIsA("BasePart", true)
    if not basePart then return false end
    
    for i = #STAGE_RARITIES, 1, -1 do
        if not autoFarmUltra then return false end
        
        local rarity = STAGE_RARITIES[i]
        local wall = getVIPWallForRarity(rarity)
        if wall then
            local targetCFrame = wall.part.CFrame * CFrame.new(0, 0, -5)
            fastTweenToPosition(targetCFrame)
        end
    end
    
    fastTweenToPosition(basePart.CFrame + Vector3.new(0, 5, 0))
    return true
end

-- Find brainrots of specific rarities
local function findPriorityBrainrots()
    local foundBrainrots = {}
    local activeBrainrots = Workspace:FindFirstChild("ActiveBrainrots")
    if not activeBrainrots then return foundBrainrots end
    
    for _, rarity in ipairs(PRIORITY_RARITIES) do
        local folder = activeBrainrots:FindFirstChild(rarity)
        if folder then
            for _, renderedBrainrot in ipairs(folder:GetChildren()) do
                if renderedBrainrot:IsA("Model") and renderedBrainrot.Name == "RenderedBrainrot" then
                    for _, child in ipairs(renderedBrainrot:GetChildren()) do
                        if child:IsA("Model") then
                            local targetPart = renderedBrainrot.PrimaryPart or renderedBrainrot:FindFirstChildWhichIsA("BasePart")
                            local prompt = renderedBrainrot:FindFirstChildWhichIsA("ProximityPrompt", true)
                            
                            if targetPart then
                                table.insert(foundBrainrots, {
                                    model = renderedBrainrot,
                                    brainrotModel = child,
                                    part = targetPart,
                                    name = child.Name,
                                    rarity = rarity,
                                    cframe = targetPart.CFrame,
                                    prompt = prompt
                                })
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    
    return foundBrainrots
end

-- FIXED: Truly instant proximity prompt activation
local function instantProximityPrompt(prompt)
    if not prompt then return false end
    if not prompt:IsA("ProximityPrompt") then return false end
    
    prompt:InputHoldBegin()
    task.wait(0.01)
    prompt:InputHoldEnd()
    
    pcall(function()
        if prompt.HoldDuration > 0 then
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if prompt and prompt.Parent then
                    prompt:InputHoldEnd()
                else
                    connection:Disconnect()
                end
            end)
            task.delay(0.05, function()
                if connection then connection:Disconnect() end
            end)
        end
    end)
    
    return true
end

-- Check for waves
local function isWaveNearby()
    local activeTsunamis = Workspace:FindFirstChild("ActiveTsunamis")
    if not activeTsunamis then return false, nil end
    
    local nearestWave = nil
    local nearestDist = math.huge
    
    for _, wave in ipairs(activeTsunamis:GetChildren()) do
        local wavePart = wave:IsA("BasePart") and wave or wave.PrimaryPart or wave:FindFirstChildWhichIsA("BasePart")
        if wavePart then
            local distance = (humanoidRootPart.Position - wavePart.Position).Magnitude
            if distance < nearestDist then
                nearestDist = distance
                nearestWave = wavePart
            end
        end
    end
    
    return nearestWave and nearestDist <= waveProtectionRange, nearestWave
end

-- Hide from wave (emergency)
local function emergencyHideFromWave()
    if isHidingFromWave then return true end
    
    local nearestWall = getNearestVIPWall()
    if not nearestWall then return false end
    
    isHidingFromWave = true
    waveHidePosition = humanoidRootPart.CFrame
    
    local targetCFrame = nearestWall.part.CFrame * CFrame.new(0, 0, -5)
    local emergencyTween = TweenService:Create(
        humanoidRootPart,
        TweenInfo.new(0.2),
        {CFrame = targetCFrame}
    )
    
    emergencyTween:Play()
    emergencyTween.Completed:Wait()
    
    print("Emergency hide at:", nearestWall.name)
    return true
end

-- NEW: Auto Farm Ultra Loop
local function autoFarmUltraLoop()
    print("Auto Farm Ultra Started!")
    local maxBeforeReturn = 5
    
    while autoFarmUltra do
        local success, err = pcall(function()
            local waveNearby, wavePart = isWaveNearby()
            if waveNearby then
                print("Wave detected! Emergency hiding...")
                emergencyHideFromWave()
                
                while autoFarmUltra do
                    local stillNearby, _ = isWaveNearby()
                    if not stillNearby then
                        task.wait(1)
                        break
                    end
                    task.wait(0.2)
                end
                
                if waveHidePosition and not ultraFarmCollecting then
                    fastTweenToPosition(waveHidePosition)
                    waveHidePosition = nil
                end
                isHidingFromWave = false
                return
            end
            
            if isHidingFromWave then
                task.wait(0.5)
                return
            end
            
            print("Tweening to Secret area...")
            tweenToStageWallSequential("Secret", 0.4)
            
            ultraFarmCollecting = true
            local brainrots = findPriorityBrainrots()
            
            if #brainrots > 0 then
                print("Found", #brainrots, "priority brainrots!")
                
                local collected = 0
                for i = 1, #brainrots do
                    if not autoFarmUltra then break end
                    if collected >= maxBeforeReturn then break end
                    
                    local waveCheck, _ = isWaveNearby()
                    if waveCheck then
                        print("Wave approaching during collection!")
                        emergencyHideFromWave()
                        ultraFarmCollecting = false
                        return
                    end
                    
                    local brainrot = brainrots[i]
                    print("Collecting:", brainrot.name, "(" .. brainrot.rarity .. ")")
                    
                    fastTweenToPosition(brainrot.cframe + Vector3.new(0, 3, 0))
                    task.wait(0.1)
                    
                    if brainrot.prompt then
                        if instantProximityEnabled then
                            instantProximityPrompt(brainrot.prompt)
                        else
                            brainrot.prompt:InputHoldBegin()
                            task.wait(brainrot.prompt.HoldDuration or 0.5)
                            brainrot.prompt:InputHoldEnd()
                        end
                    else
                        firetouchinterest(humanoidRootPart, brainrot.part, 0)
                        task.wait(0.05)
                        firetouchinterest(humanoidRootPart, brainrot.part, 1)
                    end
                    
                    if UpdateCollectedBrainrots then
                        UpdateCollectedBrainrots:FireServer(brainrot.model)
                    end
                    
                    collected = collected + 1
                    task.wait(0.2)
                end
                
                print("Collected " .. collected .. " brainrots, returning to base...")
                tweenBackToBase()
                task.wait(2)
            else
                print("No priority brainrots found, waiting...")
                task.wait(3)
            end
            
            ultraFarmCollecting = false
        end)
        
        if not success then
            warn("Auto Farm Ultra error:", err)
            ultraFarmCollecting = false
            task.wait(1)
        end
        
        task.wait(0.5)
    end
    
    print("Auto Farm Ultra Stopped")
    ultraFarmCollecting = false
    isHidingFromWave = false
end

-- FIXED: Auto Collect Cash
local function autoCollectCashLoop()
    local resetTimer = 0
    local verifiedBase = nil
    
    print("Auto Collect Cash initializing...")
    
    while autoCollectCash do
        local success, err = pcall(function()
            verifiedBase = getPlayerBase()
            
            if not verifiedBase then
                warn("No base found! Waiting...")
                return
            end
            
            local ownerAttr = verifiedBase:GetAttribute("Owner")
            if ownerAttr ~= player.UserId then
                local slots = verifiedBase:FindFirstChild("Slots")
                local ownsSlot = false
                
                if slots then
                    for _, slot in ipairs(slots:GetChildren()) do
                        local ownerValue = slot:FindFirstChild("Owner")
                        if ownerValue and (ownerValue.Value == player.Name or ownerValue.Value == player.UserId) then
                            ownsSlot = true
                            break
                        end
                    end
                end
                
                if not ownsSlot then
                    warn("Base ownership mismatch! Skipping...")
                    return
                end
            end
            
            local slots = verifiedBase:FindFirstChild("Slots")
            if slots then
                for i = 1, 40 do
                    if not autoCollectCash then break end
                    local slot = slots:FindFirstChild("Slot" .. i) or slots:FindFirstChild("slot" .. i)
                    if slot then
                        local collectPart = slot:FindFirstChild("Collect")
                        if collectPart and collectPart:IsA("BasePart") then
                            local slotOwner = slot:FindFirstChild("Owner")
                            if slotOwner and (slotOwner.Value == player.Name or slotOwner.Value == player.UserId) then
                                collectPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, 0)
                                if CollectMoneyEvent then
                                    CollectMoneyEvent:FireServer()
                                end
                            end
                            task.wait(0.05)
                        end
                    end
                end
            end
        end)
        
        if not success then
            warn("Auto Collect Cash error:", err)
        end
        
        resetTimer = resetTimer + 0.05
        if resetTimer >= 5 then
            character:BreakJoints()
            resetTimer = 0
            
            player.CharacterAdded:Wait()
            task.wait(0.5)
        end
        
        task.wait(0.05)
    end
end

-- FIXED: Arcade Event - Teleport Tickets
local function autoTeleportTicketsLoop()
    while autoTeleportTickets do
        local success, err = pcall(function()
            local arcadeTickets = Workspace:FindFirstChild("ArcadeEventTickets")
            if not arcadeTickets then return end
            
            local ticketModels = arcadeTickets:GetChildren()
            if #ticketModels < 2 then return end
            
            for i, ticketModel in ipairs(ticketModels) do
                if not autoTeleportTickets then break end
                
                local ticket = ticketModel:FindFirstChild("Ticket")
                if ticket then
                    local innerTicket = ticket:FindFirstChild("Ticket")
                    if innerTicket and innerTicket:IsA("BasePart") then
                        innerTicket.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                        
                        firetouchinterest(humanoidRootPart, innerTicket, 0)
                        task.wait(0.01)
                        firetouchinterest(humanoidRootPart, innerTicket, 1)
                    end
                end
            end
        end)
        
        task.wait(0.05)
    end
end

-- Arcade Event - Teleport Game Consoles
local function autoTeleportConsolesLoop()
    while autoTeleportConsoles do
        local success, err = pcall(function()
            local arcadeConsoles = Workspace:FindFirstChild("ArcadeEventConsoles")
            if not arcadeConsoles then return end
            
            for _, consoleModel in ipairs(arcadeConsoles:GetChildren()) do
                if not autoTeleportConsoles then break end
                
                if consoleModel.Name == "Game Console" then
                    local console = consoleModel:FindFirstChild("Game Console")
                    if console and console:IsA("BasePart") then
                        console.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                        
                        firetouchinterest(humanoidRootPart, console, 0)
                        task.wait(0.01)
                        firetouchinterest(humanoidRootPart, console, 1)
                    end
                end
            end
        end)
        
        task.wait(0.05)
    end
end

-- NEW: Instant Proximity Prompt Loop
local function instantProximityLoop()
    while instantProximityEnabled do
        local success, err = pcall(function()
            local prompts = {}
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local parent = obj.Parent
                    if parent and parent:IsA("BasePart") then
                        local distance = (humanoidRootPart.Position - parent.Position).Magnitude
                        if distance <= 10 then
                            table.insert(prompts, obj)
                        end
                    end
                end
            end
            
            for _, prompt in ipairs(prompts) do
                if prompt and prompt.Parent then
                    if not prompt.IsHeld then
                        instantProximityPrompt(prompt)
                    end
                end
            end
        end)
        
        task.wait(0.1)
    end
end

-- Other loops
local function autoHitLoop()
    while autoHitEnabled do
        pcall(function()
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character then
                    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
                        if distance <= hitboxRange then
                            local tool = character:FindFirstChildWhichIsA("Tool") or getAndEquipTool()
                            if tool then
                                humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, Vector3.new(targetHRP.Position.X, humanoidRootPart.Position.Y, targetHRP.Position.Z))
                                simulateClick()
                                if tool:FindFirstChild("Attack") and tool.Attack:IsA("RemoteEvent") then
                                    tool.Attack:FireServer(targetPlayer)
                                end
                            end
                            break
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end

local function autoCollectGoldBarsLoop()
    while autoCollectGoldBars do
        pcall(function()
            local moneyEventParts = Workspace:FindFirstChild("MoneyEventParts")
            if not moneyEventParts then return end
            
            for _, child in ipairs(moneyEventParts:GetChildren()) do
                if not autoCollectGoldBars then break end
                
                if child:IsA("Model") and child.Name == "GoldBar" then
                    local mainPart = child:FindFirstChild("Main")
                    if mainPart and mainPart:IsA("BasePart") then
                        child:SetPrimaryPartCFrame(humanoidRootPart.CFrame * CFrame.new(0, 0, -3))
                        
                        firetouchinterest(humanoidRootPart, mainPart, 0)
                        task.wait(0.05)
                        firetouchinterest(humanoidRootPart, mainPart, 1)
                        
                        task.wait(0.1)
                    end
                end
            end
        end)
        
        task.wait(0.2)
    end
end

local function autoSpinWheelLoop()
    local success, Net = pcall(function()
        return require(ReplicatedStorage.Packages.Net)
    end)
    
    if not success then
        warn("Net package not found")
        return
    end
    
    local WheelSpinRoll = Net:RemoteFunction("WheelSpin.Roll")
    local WheelSpinComplete = Net:RemoteEvent("WheelSpin.Complete")
    
    while autoSpinWheel do
        pcall(function()
            local ClientGlobals = require(ReplicatedStorage.Client.Modules.ClientGlobals)
            local spins = ClientGlobals.PlayerData:TryIndex({"WheelSpins", "Money"}) or 0
            
            if spins > 0 then
                local result, _, _, spinId = WheelSpinRoll:InvokeServer("Money", false)
                
                if result then
                    task.wait(7.5)
                    
                    if spinId then
                        WheelSpinComplete:FireServer(spinId)
                    end
                    
                    task.wait(1)
                else
                    task.wait(2)
                end
            else
                local EconomyMath = require(ReplicatedStorage.Shared.utils.EconomyMath)
                local coins = ClientGlobals.PlayerData:TryIndex({"SpecialCurrency", "MoneyCoin"}) or 0
                
                if coins >= EconomyMath.WheelCoinCost then
                    local result, _, _, spinId = WheelSpinRoll:InvokeServer("Money", false)
                    
                    if result then
                        task.wait(7.5)
                        if spinId then
                            WheelSpinComplete:FireServer(spinId)
                        end
                        task.wait(1)
                    else
                        task.wait(2)
                    end
                else
                    task.wait(5)
                end
            end
        end)
        
        task.wait(1)
    end
end

local function autoUpgradeSpeedLoop()
    while autoUpgradeSpeed do
        if UpgradeSpeedFunction then
            pcall(function()
                UpgradeSpeedFunction:InvokeServer(selectedSpeedAmount)
            end)
        end
        task.wait(0.5)
    end
end

local function autoUpgradeCarryLoop()
    while autoUpgradeCarry do
        if UpgradeCarryFunction then
            pcall(function()
                UpgradeCarryFunction:InvokeServer()
            end)
        end
        task.wait(0.5)
    end
end

local function autoRebirthLoop()
    while autoRebirth do
        if RebirthFunction then
            pcall(function()
                RebirthFunction:InvokeServer()
            end)
        end
        task.wait(2)
    end
end

local function autoSellInventoryLoop()
    while autoSellInventory do
        if SellAllFunction then
            pcall(function()
                SellAllFunction:InvokeServer()
            end)
        end
        task.wait(1)
    end
end

-- Helper functions
local function getAndEquipTool()
    local backpack = player:WaitForChild("Backpack")
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = character
            return tool
        end
    end
    return nil
end

local function simulateClick()
    pcall(function()
        local tool = character:FindFirstChildWhichIsA("Tool")
        if tool then
            tool:Activate()
        end
    end)
end

-- Visible Hitbox
local visibleHitboxParts = {}

local function visibleHitboxLoop()
    while hitboxExtenderEnabled do
        pcall(function()
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character then
                    local targetChar = targetPlayer.Character
                    local head = targetChar:FindFirstChild("Head")
                    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                    
                    if head then
                        if not head:GetAttribute("OriginalSize") then
                            head:SetAttribute("OriginalSize", head.Size)
                            head:SetAttribute("OriginalTransparency", head.Transparency)
                        end
                        
                        head.Size = Vector3.new(hitboxRange, hitboxRange, hitboxRange)
                        head.Transparency = 0.3
                        head.Color = Color3.fromRGB(255, 0, 0)
                        head.Material = Enum.Material.Neon
                        
                        if not visibleHitboxParts[targetPlayer] then
                            visibleHitboxParts[targetPlayer] = {}
                        end
                        visibleHitboxParts[targetPlayer].Head = head
                    end
                    
                    if hrp then
                        if not hrp:GetAttribute("OriginalSize") then
                            hrp:SetAttribute("OriginalSize", hrp.Size)
                        end
                        hrp.Size = Vector3.new(hitboxRange * 0.5, hitboxRange * 0.5, hitboxRange * 0.5)
                        visibleHitboxParts[targetPlayer].HRP = hrp
                    end
                    
                    for _, part in ipairs(targetChar:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "Head" and part.Name ~= "HumanoidRootPart" then
                            if not part:GetAttribute("OriginalSize") then
                                part:SetAttribute("OriginalSize", part.Size)
                            end
                            part.Size = part:GetAttribute("OriginalSize") * 1.5
                        end
                    end
                end
            end
        end)
        
        task.wait(0.5)
    end
    
    pcall(function()
        for targetPlayer, parts in pairs(visibleHitboxParts) do
            if targetPlayer.Character then
                for partName, part in pairs(parts) do
                    if part and part.Parent then
                        part.Size = part:GetAttribute("OriginalSize") or part.Size
                        if partName == "Head" then
                            part.Transparency = part:GetAttribute("OriginalTransparency") or 0
                            part.Color = Color3.fromRGB(255, 255, 255)
                            part.Material = Enum.Material.Plastic
                        end
                    end
                end
            end
        end
        visibleHitboxParts = {}
    end)
end

-- Player ESP Functions
local function createESP(targetPlayer)
    if targetPlayer == player then return end
    if espObjects[targetPlayer] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = targetPlayer.Name .. "_ESP"
    espFolder.Parent = playerGui
    
    local function onCharacterAdded(char)
        task.wait(1)
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local humanoid = char:FindFirstChild("Humanoid")
        
        if not hrp or not head then return end
        
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESPBox"
        box.Size = hrp.Size + Vector3.new(2, 3, 2)
        box.Color3 = CONFIG.COLORS.ESP
        box.Transparency = 0.5
        box.ZIndex = 10
        box.AlwaysOnTop = true
        box.Adornee = hrp
        box.Parent = espFolder
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPName"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = head
        billboard.Parent = espFolder
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = CONFIG.COLORS.ESP
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
        
        if humanoid then
            local healthLabel = Instance.new("TextLabel")
            healthLabel.Name = "ESPHealth"
            healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
            healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
            healthLabel.BackgroundTransparency = 1
            healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
            healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            healthLabel.TextStrokeTransparency = 0
            healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            healthLabel.Font = Enum.Font.GothamBold
            healthLabel.TextSize = 12
            healthLabel.Parent = billboard
            
            humanoid.HealthChanged:Connect(function()
                if healthLabel and healthLabel.Parent then
                    healthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                end
            end)
        end
    end
    
    if targetPlayer.Character then
        onCharacterAdded(targetPlayer.Character)
    end
    
    targetPlayer.CharacterAdded:Connect(onCharacterAdded)
    espObjects[targetPlayer] = espFolder
end

local function removeESP(targetPlayer)
    if espObjects[targetPlayer] then
        espObjects[targetPlayer]:Destroy()
        espObjects[targetPlayer] = nil
    end
end

local function espLoop()
    for p, _ in pairs(espObjects) do
        removeESP(p)
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            createESP(p)
        end
    end
    
    local playerAddedConnection = Players.PlayerAdded:Connect(function(p)
        if espEnabled then
            createESP(p)
        end
    end)
    
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(p)
        removeESP(p)
    end)
    
    while espEnabled do
        task.wait(1)
    end
    
    playerAddedConnection:Disconnect()
    playerRemovingConnection:Disconnect()
    
    for p, _ in pairs(espObjects) do
        removeESP(p)
    end
end

-- ============================================
-- BRAINROT ESP SYSTEM
-- ============================================

local function createBrainrotESP(brainrotModel, rarity, name, position)
    if brainrotESPObjects[brainrotModel] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "BrainrotESP_" .. tostring(brainrotModel)
    espFolder.Parent = playerGui
    
    local color = CONFIG.RARITY_COLORS[rarity] or CONFIG.COLORS.White
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "BrainrotBox"
    box.Size = Vector3.new(4, 4, 4)
    box.Color3 = color
    box.Transparency = 0.3
    box.ZIndex = 10
    box.AlwaysOnTop = true
    
    local adornPart = brainrotModel:IsA("Model") and brainrotModel.PrimaryPart or brainrotModel:FindFirstChildWhichIsA("BasePart")
    if not adornPart then
        adornPart = Instance.new("Part")
        adornPart.Name = "ESPAdornPart"
        adornPart.Size = Vector3.new(1, 1, 1)
        adornPart.Position = position
        adornPart.Anchored = true
        adornPart.CanCollide = false
        adornPart.Transparency = 1
        adornPart.Parent = Workspace.CurrentCamera
        
        task.delay(10, function()
            if adornPart then adornPart:Destroy() end
        end)
    end
    
    box.Adornee = adornPart
    box.Parent = espFolder
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BrainrotBillboard"
    billboard.Size = UDim2.new(0, 200, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    
    if adornPart then
        billboard.Adornee = adornPart
    end
    billboard.Parent = espFolder
    
    if showBrainrotNames then
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "BrainrotName"
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name or "Unknown Brainrot"
        nameLabel.TextColor3 = color
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
    end
    
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Name = "RarityLabel"
    rarityLabel.Size = UDim2.new(1, 0, 0.5, 0)
    rarityLabel.Position = UDim2.new(0, 0, 0.5, 0)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = "[" .. rarity .. "]"
    rarityLabel.TextColor3 = color
    rarityLabel.TextStrokeTransparency = 0
    rarityLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    rarityLabel.Font = Enum.Font.GothamBold
    rarityLabel.TextSize = 12
    rarityLabel.Parent = billboard
    
    if showBrainrotDistance then
        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistanceLabel"
        distLabel.Size = UDim2.new(1, 0, 0.3, 0)
        distLabel.Position = UDim2.new(0, 0, 1, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.Text = ""
        distLabel.TextColor3 = CONFIG.COLORS.White
        distLabel.TextStrokeTransparency = 0
        distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        distLabel.Font = Enum.Font.Gotham
        distLabel.TextSize = 10
        distLabel.Parent = billboard
        
        task.spawn(function()
            while distLabel and distLabel.Parent and brainrotESPEnabled do
                if humanoidRootPart and adornPart then
                    local dist = (humanoidRootPart.Position - adornPart.Position).Magnitude
                    distLabel.Text = math.floor(dist) .. " studs"
                    
                    if dist > espMaxDistance then
                        billboard.Enabled = false
                    else
                        billboard.Enabled = true
                    end
                end
                task.wait(0.5)
            end
        end)
    end
    
    brainrotESPObjects[brainrotModel] = {
        folder = espFolder,
        box = box,
        billboard = billboard,
        adornPart = adornPart
    }
    
    return espFolder
end

local function removeBrainrotESP(brainrotModel)
    if brainrotESPObjects[brainrotModel] then
        brainrotESPObjects[brainrotModel].folder:Destroy()
        brainrotESPObjects[brainrotModel] = nil
    end
end

local function clearAllBrainrotESP()
    for model, _ in pairs(brainrotESPObjects) do
        removeBrainrotESP(model)
    end
    brainrotESPObjects = {}
end

local function brainrotESPLoop()
    print("Brainrot ESP Started")
    
    while brainrotESPEnabled do
        local success, err = pcall(function()
            local activeBrainrots = Workspace:FindFirstChild("ActiveBrainrots")
            if not activeBrainrots then return end
            
            local currentBrainrots = {}
            
            for _, rarity in ipairs(RARITY_ORDER) do
                local folder = activeBrainrots:FindFirstChild(rarity)
                if folder then
                    for _, renderedBrainrot in ipairs(folder:GetChildren()) do
                        if renderedBrainrot:IsA("Model") and renderedBrainrot.Name == "RenderedBrainrot" then
                            for _, child in ipairs(renderedBrainrot:GetChildren()) do
                                if child:IsA("Model") then
                                    local brainrotName = child.Name
                                    local targetPart = renderedBrainrot.PrimaryPart or renderedBrainrot:FindFirstChildWhichIsA("BasePart")
                                    
                                    if targetPart then
                                        local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                                        
                                        if distance <= espMaxDistance then
                                            currentBrainrots[renderedBrainrot] = true
                                            
                                            if not brainrotESPObjects[renderedBrainrot] then
                                                createBrainrotESP(renderedBrainrot, rarity, brainrotName, targetPart.Position)
                                            end
                                        else
                                            if brainrotESPObjects[renderedBrainrot] then
                                                removeBrainrotESP(renderedBrainrot)
                                            end
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
            
            for model, _ in pairs(brainrotESPObjects) do
                if not currentBrainrots[model] or not model.Parent then
                    removeBrainrotESP(model)
                end
            end
        end)
        
        if not success then
            warn("Brainrot ESP error:", err)
        end
        
        task.wait(1)
    end
    
    clearAllBrainrotESP()
    print("Brainrot ESP Stopped")
end

-- ============================================
-- VIP WALL BYPASS
-- ============================================

local function bypassVIPWalls()
    local defaultMap = Workspace:FindFirstChild("DefaultMap_SharedInstances")
    if not defaultMap then return false end
    
    local vipWalls = defaultMap:FindFirstChild("VIPWalls")
    if not vipWalls then return false end
    
    local count = 0
    
    for _, wall in ipairs(vipWalls:GetDescendants()) do
        if wall:IsA("BasePart") then
            wall.CanCollide = false
            wall.CanQuery = false
            count = count + 1
        end
        
        if wall:IsA("TouchTransmitter") or wall:IsA("TouchInterest") then
            wall:Destroy()
            count = count + 1
        end
    end
    
    for _, wall in ipairs(vipWalls:GetChildren()) do
        if wall:IsA("Model") then
            for _, part in ipairs(wall:GetDescendants()) do
                if part:IsA("BasePart") and (part.Name:find("Glass") or part.Name:find("Door")) then
                    part.CanCollide = false
                    part.Transparency = 0.9
                end
                
                if part:IsA("ProximityPrompt") then
                    part.Enabled = false
                    part:Destroy()
                end
            end
        end
    end
    
    print("VIP Wall Bypass applied to", count, "parts")
    return true
end

local function restoreVIPWalls()
    local defaultMap = Workspace:FindFirstChild("DefaultMap_SharedInstances")
    if not defaultMap then return end
    
    local vipWalls = defaultMap:FindFirstChild("VIPWalls")
    if not vipWalls then return end
    
    for _, wall in ipairs(vipWalls:GetDescendants()) do
        if wall:IsA("BasePart") then
            wall.CanCollide = true
            wall.CanQuery = true
            
            if wall.Name:find("Glass") or wall.Name:find("Door") then
                wall.Transparency = 0.5
            end
        end
    end
    
    print("VIP Walls restored")
end

local function vipWallNoclipLoop()
    while vipWallNoclip do
        bypassVIPWalls()
        task.wait(5)
    end
    
    restoreVIPWalls()
end

-- ============================================
-- NEW: FPS OPTIMIZER
-- ============================================

local function optimizeFPS()
    if fpsOptimized then return end
    
    -- Save original settings
    originalSettings = {
        QualityLevel = settings().Rendering.QualityLevel,
        Shadows = Lighting.GlobalShadows,
        Technology = settings().Rendering.MeshPartDetailLevel,
        Particles = true,
        Textures = true
    }
    
    -- Lower render quality
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    -- Disable shadows
    Lighting.GlobalShadows = false
    
    -- Lower mesh detail
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    
    -- Remove unnecessary effects
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
    
    -- Optimize workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- Disable casting shadows on parts
            obj.CastShadow = false
            
            -- Reduce texture quality
            if obj:IsA("MeshPart") then
                obj.TextureID = ""
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
    
    fpsOptimized = true
    print("FPS Optimized!")
end

local function restoreFPS()
    if not fpsOptimized then return end
    
    settings().Rendering.QualityLevel = originalSettings.QualityLevel
    Lighting.GlobalShadows = originalSettings.Shadows
    settings().Rendering.MeshPartDetailLevel = originalSettings.Technology
    
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = true
        end
    end
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CastShadow = true
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = true
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0
        end
    end
    
    fpsOptimized = false
    print("FPS Settings Restored")
end

-- ============================================
-- NEW: SERVER HOPPER
-- ============================================

local function getServerList()
    local success, result = pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        return result.data
    else
        warn("Failed to get server list")
        return {}
    end
end

local function hopToLowestPlayerServer()
    if serverHopInProgress then return end
    serverHopInProgress = true
    
    print("Finding server with lowest players...")
    
    local servers = getServerList()
    if #servers == 0 then
        warn("No servers found")
        serverHopInProgress = false
        return
    end
    
    -- Find server with lowest players
    local targetServer = nil
    local lowestPlayers = math.huge
    
    for _, server in ipairs(servers) do
        if server.playing < server.maxPlayers and server.playing < lowestPlayers then
            lowestPlayers = server.playing
            targetServer = server
        end
    end
    
    if targetServer then
        print("Teleporting to server with", lowestPlayers, "players...")
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, player)
    else
        warn("No suitable server found")
    end
    
    serverHopInProgress = false
end

local function rejoinServer()
    print("Rejoining current server...")
    TeleportService:Teleport(game.PlaceId, player)
end

-- ============================================
-- NEW: DISCORD WEBHOOK SYSTEM
-- ============================================

local function sendDiscordWebhook(embedData)
    if not webhookEnabled or webhookURL == "" then return end
    
    local success, err = pcall(function()
        local data = {
            embeds = {embedData}
        }
        
        local headers = {
            ["Content-Type"] = "application/json"
        }
        
        local request = (syn and syn.request) or (http and http.request) or request
        if request then
            request({
                Url = webhookURL,
                Method = "POST",
                Headers = headers,
                Body = HttpService:JSONEncode(data)
            })
        else
            -- Fallback for executors without request function
            game:HttpPost(webhookURL, HttpService:JSONEncode(data), false, headers)
        end
    end)
    
    if not success then
        warn("Webhook failed:", err)
    end
end

local function checkForRareBrainrots()
    local activeBrainrots = Workspace:FindFirstChild("ActiveBrainrots")
    if not activeBrainrots then return end
    
    local rareRarities = {"Celestial", "Divine", "Secret"}
    
    for _, rarity in ipairs(rareRarities) do
        local folder = activeBrainrots:FindFirstChild(rarity)
        if folder then
            for _, renderedBrainrot in ipairs(folder:GetChildren()) do
                if renderedBrainrot:IsA("Model") and renderedBrainrot.Name == "RenderedBrainrot" then
                    for _, child in ipairs(renderedBrainrot:GetChildren()) do
                        if child:IsA("Model") then
                            local brainrotName = child.Name
                            local uniqueId = tostring(renderedBrainrot)
                            
                            -- Check if already notified (cooldown)
                            if not notifiedBrainrots[uniqueId] or (tick() - notifiedBrainrots[uniqueId]) > WEBHOOK_COOLDOWN then
                                notifiedBrainrots[uniqueId] = tick()
                                
                                -- Get server info
                                local playerCount = #Players:GetPlayers()
                                local maxPlayers = Players.MaxPlayers
                                local serverId = game.JobId
                                
                                -- Create join link
                                local joinLink = "https://www.roblox.com/games/start?placeId=" .. game.PlaceId .. "&launchData=" .. serverId
                                
                                local embed = {
                                    title = "🚨 Rare Brainrot Spawned! 🚨",
                                    description = "A rare brainrot has been detected in a server!",
                                    color = CONFIG.RARITY_COLORS[rarity]:ToHex(),
                                    fields = {
                                        {
                                            name = "Brainrot Name",
                                            value = brainrotName,
                                            inline = true
                                        },
                                        {
                                            name = "Rarity",
                                            value = rarity,
                                            inline = true
                                        },
                                        {
                                            name = "Server Players",
                                            value = playerCount .. "/" .. maxPlayers,
                                            inline = true
                                        },
                                        {
                                            name = "Join Server",
                                            value = "[Click to Join](" .. joinLink .. ")",
                                            inline = false
                                        }
                                    },
                                    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                                    footer = {
                                        text = "Nexus Brainrot Tracker v12"
                                    }
                                }
                                
                                sendDiscordWebhook(embed)
                                print("Webhook sent for", brainrotName, "(" .. rarity .. ")")
                            end
                            
                            break
                        end
                    end
                end
            end
        end
    end
end

local function webhookCheckLoop()
    while webhookEnabled do
        pcall(checkForRareBrainrots)
        task.wait(10) -- Check every 10 seconds
    end
end

-- Auto Clicker Button
local function createAutoClickerButton()
    if autoClickerButton then
        autoClickerButton:Destroy()
        autoClickerButton = nil
    end
    
    if autoClickerLoop then
        autoClickerLoop = nil
    end
    
    local clickerGui = Instance.new("ScreenGui")
    clickerGui.Name = "AutoClickerGUI"
    clickerGui.ResetOnSpawn = false
    clickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    clickerGui.Parent = playerGui
    
    local button = Instance.new("TextButton")
    button.Name = "AutoClickerButton"
    button.Size = UDim2.new(0, 100, 0, 100)
    button.Position = UDim2.new(0.8, 0, 0.5, 0)
    button.BackgroundColor3 = CONFIG.COLORS.Accent
    button.BorderSizePixel = 0
    button.Text = "🖱️\nAUTO\nCLICK\nON"
    button.TextColor3 = CONFIG.COLORS.White
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.TextWrapped = true
    button.Parent = clickerGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = CONFIG.COLORS.White
    stroke.Thickness = 3
    stroke.Parent = button
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local function startClicking()
        if autoClickerLoop then return end
        
        button.BackgroundColor3 = CONFIG.COLORS.Success
        button.Text = "🖱️\nAUTO\nCLICK\nON\n" .. autoClickerCPS .. " CPS"
        
        autoClickerLoop = task.spawn(function()
            while autoClickerEnabled do
                pcall(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    
                    local tool = character:FindFirstChildWhichIsA("Tool")
                    if tool then
                        tool:Activate()
                    end
                end)
                
                local waitTime = 1 / autoClickerCPS
                task.wait(waitTime)
            end
        end)
    end
    
    local function stopClicking()
        autoClickerLoop = nil
        button.BackgroundColor3 = CONFIG.COLORS.Accent
        button.Text = "🖱️\nAUTO\nCLICK\nOFF"
    end
    
    if autoClickerEnabled then
        startClicking()
    else
        stopClicking()
    end
    
    autoClickerButton = clickerGui
    
    return {
        Start = startClicking,
        Stop = stopClicking,
        UpdateCPS = function(newCPS)
            autoClickerCPS = newCPS
            if autoClickerEnabled then
                button.Text = "🖱️\nAUTO\nCLICK\nON\n" .. autoClickerCPS .. " CPS"
            end
        end,
        Destroy = function()
            clickerGui:Destroy()
            autoClickerButton = nil
            autoClickerLoop = nil
        end
    }
end

-- Wave Protection Loop
local function waveProtectionLoop()
    print("Wave Protection Started")
    isHidingFromWave = false
    waveHidePosition = nil
    waveHideStartTime = nil
    currentWavePart = nil
    
    while waveProtectionEnabled do
        local success, err = pcall(function()
            local activeTsunamis = Workspace:FindFirstChild("ActiveTsunamis")
            
            if not activeTsunamis or #activeTsunamis:GetChildren() == 0 then
                if isHidingFromWave and waveHidePosition then
                    task.wait(1)
                    
                    local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
                    returnTween:Play()
                    returnTween.Completed:Wait()
                    
                    isHidingFromWave = false
                    waveHidePosition = nil
                    waveHideStartTime = nil
                    currentWavePart = nil
                end
                return
            end
            
            local nearestWave = nil
            local nearestDist = math.huge
            
            for _, wave in ipairs(activeTsunamis:GetChildren()) do
                local wavePart = wave:IsA("BasePart") and wave or wave.PrimaryPart or wave:FindFirstChildWhichIsA("BasePart")
                if wavePart then
                    local distance = (humanoidRootPart.Position - wavePart.Position).Magnitude
                    if distance < nearestDist then
                        nearestDist = distance
                        nearestWave = wavePart
                    end
                end
            end
            
            if nearestWave and nearestDist <= waveProtectionRange then
                if not isHidingFromWave then
                    waveHidePosition = humanoidRootPart.CFrame
                    waveHideStartTime = tick()
                    
                    if isCollectingBrainrot or ultraFarmCollecting then
                        isCollectingBrainrot = false
                        ultraFarmCollecting = false
                    end
                    
                    local nearestWall = getNearestVIPWall()
                    if nearestWall then
                        isHidingFromWave = true
                        
                        local targetCFrame = nearestWall.part.CFrame * CFrame.new(0, 0, -5)
                        
                        local emergencyTween = TweenService:Create(
                            humanoidRootPart,
                            TweenInfo.new(0.5),
                            {CFrame = targetCFrame}
                        )
                        
                        emergencyTween:Play()
                        emergencyTween.Completed:Wait()
                    end
                else
                    if currentWavePart and currentWavePart.Parent then
                        local currentDist = (humanoidRootPart.Position - currentWavePart.Position).Magnitude
                        
                        if currentDist <= (waveProtectionRange + WAVE_SAFETY_BUFFER) then
                            local nearestWall = getNearestVIPWall()
                            if nearestWall then
                                local targetCFrame = nearestWall.part.CFrame * CFrame.new(0, 0, -5)
                                if (humanoidRootPart.Position - targetCFrame.Position).Magnitude > 5 then
                                    humanoidRootPart.CFrame = targetCFrame
                                end
                            end
                        end
                    else
                        task.wait(0.5)
                        local stillThreatened = false
                        
                        for _, wave in ipairs(activeTsunamis:GetChildren()) do
                            local wavePart = wave:IsA("BasePart") and wave or wave.PrimaryPart or wave:FindFirstChildWhichIsA("BasePart")
                            if wavePart then
                                local dist = (humanoidRootPart.Position - wavePart.Position).Magnitude
                                if dist <= (waveProtectionRange + WAVE_SAFETY_BUFFER) then
                                    stillThreatened = true
                                    currentWavePart = wavePart
                                    break
                                end
                            end
                        end
                        
                        if not stillThreatened then
                            if waveHidePosition then
                                local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
                                returnTween:Play()
                                returnTween.Completed:Wait()
                                
                                isHidingFromWave = false
                                waveHidePosition = nil
                                waveHideStartTime = nil
                                currentWavePart = nil
                            end
                        end
                    end
                end
            elseif nearestWave and nearestDist > waveProtectionRange and isHidingFromWave then
                local hideTime = tick() - (waveHideStartTime or tick())
                if hideTime >= 3 then
                    if waveHidePosition then
                        local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
                        returnTween:Play()
                        returnTween.Completed:Wait()
                        
                        isHidingFromWave = false
                        waveHidePosition = nil
                        waveHideStartTime = nil
                        currentWavePart = nil
                    end
                end
            end
        end)
        
        if not success then
            warn("Wave protection error:", err)
        end
        
        task.wait(WAVE_CHECK_INTERVAL)
    end
    
    if isHidingFromWave and waveHidePosition then
        local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
        returnTween:Play()
    end
    
    isHidingFromWave = false
    waveHidePosition = nil
    waveHideStartTime = nil
    currentWavePart = nil
end

-- Create GUI
local function createGUI()
    local success, err = pcall(function()
        print("Creating GUI...")
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "NexusBrainrotHub"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui
        
        print("ScreenGui created")

        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 850, 0, 600)
        mainFrame.Position = UDim2.new(0.5, -425, 0.5, -300)
        mainFrame.BackgroundColor3 = CONFIG.COLORS.Background
        mainFrame.BackgroundTransparency = CONFIG.COLORS.BackgroundTransparency
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.ClipsDescendants = true
        mainFrame.Parent = screenGui
        
        print("MainFrame created")

        local mainStroke = Instance.new("UIStroke")
        mainStroke.Color = CONFIG.COLORS.White
        mainStroke.Thickness = 1.2
        mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        mainStroke.Parent = mainFrame

        local mainCorner = Instance.new("UICorner")
        mainCorner.CornerRadius = UDim.new(0, 16)
        mainCorner.Parent = mainFrame

        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 50)
        titleBar.BackgroundTransparency = 1
        titleBar.Parent = mainFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -100, 1, 0)
        titleLabel.Position = UDim2.new(0, 20, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = CONFIG.TITLE .. " v12"
        titleLabel.TextColor3 = CONFIG.COLORS.White
        titleLabel.TextSize = 16
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar

        local closeBtn = Instance.new("TextButton")
        closeBtn.Name = "CloseBtn"
        closeBtn.Size = UDim2.new(0, 32, 0, 32)
        closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
        closeBtn.BackgroundTransparency = 1
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.Text = "✕"
        closeBtn.TextColor3 = CONFIG.COLORS.Danger
        closeBtn.TextSize = 18
        closeBtn.Parent = titleBar

        closeBtn.MouseButton1Click:Connect(function()
            -- Disable all features
            autoCollectCash = false
            autoUpgradeSpeed = false
            autoUpgradeCarry = false
            autoSellInventory = false
            autoRebirth = false
            autoFarmUltra = false
            instantProximityEnabled = false
            hitboxExtenderEnabled = false
            waveProtectionEnabled = false
            autoCollectSpecificBrainrot = false
            autoClickerEnabled = false
            autoSpinWheel = false
            autoTweenToStage = false
            espEnabled = false
            autoTeleportTickets = false
            autoTeleportConsoles = false
            brainrotESPEnabled = false
            vipWallBypassEnabled = false
            vipWallNoclip = false
            webhookEnabled = false
            
            if autoClickerButton then
                autoClickerButton:Destroy()
            end
            
            clearAllBrainrotESP()
            
            for p, _ in pairs(espObjects) do
                if espObjects[p] then
                    espObjects[p]:Destroy()
                    espObjects[p] = nil
                end
            end
            
            screenGui:Destroy()
        end)

        local sidebar = Instance.new("Frame")
        sidebar.Name = "Sidebar"
        sidebar.Size = UDim2.new(0, 200, 1, -50)
        sidebar.Position = UDim2.new(0, 0, 0, 50)
        sidebar.BackgroundColor3 = CONFIG.COLORS.Sidebar
        sidebar.BackgroundTransparency = 0.3
        sidebar.BorderSizePixel = 0
        sidebar.Parent = mainFrame

        local sidebarCorner = Instance.new("UICorner")
        sidebarCorner.CornerRadius = UDim.new(0, 16)
        sidebarCorner.Parent = sidebar

        local tabContainer = Instance.new("Frame")
        tabContainer.Name = "TabContainer"
        tabContainer.Size = UDim2.new(1, -20, 1, -20)
        tabContainer.Position = UDim2.new(0, 10, 0, 10)
        tabContainer.BackgroundTransparency = 1
        tabContainer.Parent = sidebar

        local tabList = Instance.new("UIListLayout")
        tabList.FillDirection = Enum.FillDirection.Vertical
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 8)
        tabList.Parent = tabContainer

        local contentContainer = Instance.new("Frame")
        contentContainer.Name = "ContentContainer"
        contentContainer.Size = UDim2.new(1, -220, 1, -70)
        contentContainer.Position = UDim2.new(0, 210, 0, 60)
        contentContainer.BackgroundTransparency = 1
        contentContainer.Parent = mainFrame

        local currentTab = nil

        local function createTab(name, icon)
            local tabBtn = Instance.new("TextButton")
            tabBtn.Name = name .. "Tab"
            tabBtn.Size = UDim2.new(1, 0, 0, 45)
            tabBtn.BackgroundColor3 = CONFIG.COLORS.Background
            tabBtn.BackgroundTransparency = 0.5
            tabBtn.BorderSizePixel = 0
            tabBtn.AutoButtonColor = false
            tabBtn.Font = Enum.Font.GothamBold
            tabBtn.Text = "   " .. icon .. "  " .. name
            tabBtn.TextColor3 = CONFIG.COLORS.Gray
            tabBtn.TextSize = 14
            tabBtn.TextXAlignment = Enum.TextXAlignment.Left
            tabBtn.Parent = tabContainer
            
            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 10)
            tabCorner.Parent = tabBtn
            
            local contentFrame = Instance.new("ScrollingFrame")
            contentFrame.Name = name .. "Content"
            contentFrame.Size = UDim2.new(1, 0, 1, 0)
            contentFrame.BackgroundTransparency = 1
            contentFrame.BorderSizePixel = 0
            contentFrame.ScrollBarThickness = 6
            contentFrame.ScrollBarImageColor3 = CONFIG.COLORS.Accent
            contentFrame.Visible = false
            contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
            contentFrame.Parent = contentContainer
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 10)
            listLayout.Parent = contentFrame
            
            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                contentFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
            end)
            
            tabBtn.MouseButton1Click:Connect(function()
                if currentTab == contentFrame then return end
                if currentTab then
                    currentTab.Visible = false
                end
                for _, child in ipairs(tabContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        TweenService:Create(child, TweenInfo.new(0.2), {
                            BackgroundColor3 = CONFIG.COLORS.Background,
                            TextColor3 = CONFIG.COLORS.Gray
                        }):Play()
                    end
                end
                currentTab = contentFrame
                contentFrame.Visible = true
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = CONFIG.COLORS.Accent,
                    TextColor3 = CONFIG.COLORS.White
                }):Play()
            end)
            
            return contentFrame
        end

        -- Create all tabs
        local automationTab = createTab("Automation", "⚡")
        local combatTab = createTab("Combat", "⚔️")
        local visualTab = createTab("Visual", "👁️")
        local eventTab = createTab("Event", "🎉")
        local stagesTab = createTab("Stages", "🏆")
        local sellTab = createTab("Sell", "💰")
        local serverTab = createTab("Server", "🌐") -- NEW: Server tab
        local settingsTab = createTab("Settings", "⚙️")

        print("Tabs created")

        -- Helper Functions for GUI elements
        local function createToggle(parent, name, description, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 70)
            frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Parent = parent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -100, 0, 25)
            title.Position = UDim2.new(0, 15, 0, 10)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = name
            title.TextColor3 = CONFIG.COLORS.White
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -100, 0, 20)
            desc.Position = UDim2.new(0, 15, 0, 35)
            desc.BackgroundTransparency = 1
            desc.Font = Enum.Font.Gotham
            desc.Text = description
            desc.TextColor3 = CONFIG.COLORS.Gray
            desc.TextSize = 11
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = frame
            
            local toggle = Instance.new("Frame")
            toggle.Size = UDim2.new(0, 50, 0, 26)
            toggle.Position = UDim2.new(1, -65, 0.5, -13)
            toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            toggle.BorderSizePixel = 0
            toggle.Parent = frame
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(1, 0)
            toggleCorner.Parent = toggle
            
            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 22, 0, 22)
            knob.Position = UDim2.new(0, 2, 0.5, -11)
            knob.BackgroundColor3 = CONFIG.COLORS.White
            knob.BorderSizePixel = 0
            knob.Parent = toggle
            
            local knobCorner = Instance.new("UICorner")
            knobCorner.CornerRadius = UDim.new(1, 0)
            knobCorner.Parent = knob
            
            local enabled = false
            
            local clickBtn = Instance.new("TextButton")
            clickBtn.Name = "ClickButton"
            clickBtn.Size = UDim2.new(1, 0, 1, 0)
            clickBtn.BackgroundTransparency = 1
            clickBtn.Text = ""
            clickBtn.Parent = frame
            
            local toggleClick = Instance.new("TextButton")
            toggleClick.Name = "ToggleClick"
            toggleClick.Size = UDim2.new(0, 50, 0, 26)
            toggleClick.Position = UDim2.new(1, -65, 0.5, -13)
            toggleClick.BackgroundTransparency = 1
            toggleClick.Text = ""
            toggleClick.Parent = frame
            
            local function updateToggle()
                enabled = not enabled
                
                if enabled then
                    TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Success}):Play()
                    TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 26, 0.5, -11)}):Play()
                else
                    TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
                    TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
                end
                
                local success, err = pcall(function()
                    callback(enabled)
                end)
                
                if not success then
                    warn("Toggle callback error:", err)
                end
            end
            
            clickBtn.MouseButton1Click:Connect(updateToggle)
            toggleClick.MouseButton1Click:Connect(updateToggle)
            
            return frame
        end

        local function createSlider(parent, name, description, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 90)
            frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Parent = parent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -100, 0, 25)
            title.Position = UDim2.new(0, 15, 0, 10)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = name
            title.TextColor3 = CONFIG.COLORS.White
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -100, 0, 20)
            desc.Position = UDim2.new(0, 15, 0, 30)
            desc.BackgroundTransparency = 1
            desc.Font = Enum.Font.Gotham
            desc.Text = description
            desc.TextColor3 = CONFIG.COLORS.Gray
            desc.TextSize = 11
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.Parent = frame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Position = UDim2.new(1, -65, 0, 10)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(default)
            valueLabel.TextColor3 = CONFIG.COLORS.Accent
            valueLabel.TextSize = 14
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = frame
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Name = "SliderBg"
            sliderBg.Size = UDim2.new(1, -30, 0, 8)
            sliderBg.Position = UDim2.new(0, 15, 0, 60)
            sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            sliderBg.BorderSizePixel = 0
            sliderBg.Parent = frame
            
            local sliderBgCorner = Instance.new("UICorner")
            sliderBgCorner.CornerRadius = UDim.new(1, 0)
            sliderBgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "SliderFill"
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = CONFIG.COLORS.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            local sliderFillCorner = Instance.new("UICorner")
            sliderFillCorner.CornerRadius = UDim.new(1, 0)
            sliderFillCorner.Parent = sliderFill
            
            local sliderKnob = Instance.new("Frame")
            sliderKnob.Name = "SliderKnob"
            sliderKnob.Size = UDim2.new(0, 16, 0, 16)
            sliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            sliderKnob.BackgroundColor3 = CONFIG.COLORS.White
            sliderKnob.BorderSizePixel = 0
            sliderKnob.Parent = sliderBg
            
            local sliderKnobCorner = Instance.new("UICorner")
            sliderKnobCorner.CornerRadius = UDim.new(1, 0)
            sliderKnobCorner.Parent = sliderKnob
            
            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Name = "SliderBtn"
            sliderBtn.Size = UDim2.new(1, 0, 1, 0)
            sliderBtn.BackgroundTransparency = 1
            sliderBtn.Text = ""
            sliderBtn.Parent = sliderBg
            
            local currentValue = default
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (pos * (max - min)))
                
                if value ~= currentValue then
                    currentValue = value
                    valueLabel.Text = tostring(value)
                    
                    TweenService:Create(sliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                    TweenService:Create(sliderKnob, TweenInfo.new(0.1), {Position = UDim2.new(pos, -8, 0.5, -8)}):Play()
                    
                    pcall(function()
                        callback(value)
                    end)
                end
            end
            
            local dragging = false
            
            sliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            sliderBtn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)
            
            return frame
        end

        local function createButton(parent, name, callback, color)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 45)
            btn.BackgroundColor3 = color or CONFIG.COLORS.Accent
            btn.BorderSizePixel = 0
            btn.Font = Enum.Font.GothamBold
            btn.Text = name
            btn.TextColor3 = CONFIG.COLORS.White
            btn.TextSize = 14
            btn.Parent = parent
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 10)
            btnCorner.Parent = btn
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 123, 255)}):Play()
            end)
            
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color or CONFIG.COLORS.Accent}):Play()
            end)
            
            btn.MouseButton1Click:Connect(function()
                local success, err = pcall(callback)
                if not success then
                    warn("Button error:", err)
                end
            end)
            
            return btn
        end

        local function createTextBox(parent, name, placeholder, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -20, 0, 80)
            frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
            frame.BackgroundTransparency = 0.3
            frame.BorderSizePixel = 0
            frame.Parent = parent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = frame
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -30, 0, 25)
            title.Position = UDim2.new(0, 15, 0, 10)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = name
            title.TextColor3 = CONFIG.COLORS.White
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.Parent = frame
            
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, -30, 0, 30)
            textBox.Position = UDim2.new(0, 15, 0, 40)
            textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            textBox.BorderSizePixel = 0
            textBox.Font = Enum.Font.Gotham
            textBox.Text = ""
            textBox.PlaceholderText = placeholder
            textBox.TextColor3 = CONFIG.COLORS.White
            textBox.PlaceholderColor3 = CONFIG.COLORS.Gray
            textBox.TextSize = 12
            textBox.ClearTextOnFocus = false
            textBox.Parent = frame
            
            local textCorner = Instance.new("UICorner")
            textCorner.CornerRadius = UDim.new(0, 8)
            textCorner.Parent = textBox
            
            textBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(textBox.Text)
                end
            end)
            
            return frame
        end

        -- NEW: Create Section Header
        local function createSection(parent, title)
            local section = Instance.new("TextLabel")
            section.Size = UDim2.new(1, -20, 0, 30)
            section.BackgroundTransparency = 1
            section.Font = Enum.Font.GothamBold
            section.Text = "━━ " .. title .. " ━━"
            section.TextColor3 = CONFIG.COLORS.Accent
            section.TextSize = 14
            section.Parent = parent
            return section
        end

        -- ==================== AUTOMATION TAB ====================
        createToggle(automationTab, "Auto Collect Cash", "Collects only YOUR base cash, resets every 5s", function(enabled)
            autoCollectCash = enabled
            if enabled then 
                task.spawn(autoCollectCashLoop) 
            end
        end)

        createSlider(automationTab, "Auto Upgrade Speed", "Select speed upgrade amount", 1, 10, 1, function(value)
            selectedSpeedAmount = value
        end)

        createToggle(automationTab, "Auto Upgrade Speed", "Automatically upgrades speed", function(enabled)
            autoUpgradeSpeed = enabled
            if enabled then 
                task.spawn(autoUpgradeSpeedLoop) 
            end
        end)

        createToggle(automationTab, "Auto Upgrade Carry", "Automatically upgrades carry capacity", function(enabled)
            autoUpgradeCarry = enabled
            if enabled then 
                task.spawn(autoUpgradeCarryLoop) 
            end
        end)

        createToggle(automationTab, "Auto Rebirth", "Automatically rebirths when possible", function(enabled)
            autoRebirth = enabled
            if enabled then 
                task.spawn(autoRebirthLoop) 
            end
        end)

        createToggle(automationTab, "Auto Farm Ultra", "Farms Secret/Divine/Celestial, collects 5, returns", function(enabled)
            autoFarmUltra = enabled
            if enabled then
                task.spawn(autoFarmUltraLoop)
            end
        end)

        createToggle(automationTab, "Instant Proximity Prompts", "Instantly activates all nearby prompts", function(enabled)
            instantProximityEnabled = enabled
            if enabled then
                task.spawn(instantProximityLoop)
            end
        end)

        createToggle(automationTab, "Auto Clicker", "Draggable button that auto-clicks continuously", function(enabled)
            autoClickerEnabled = enabled
            if enabled then
                createAutoClickerButton()
            else
                if autoClickerButton then
                    autoClickerButton:Destroy()
                    autoClickerButton = nil
                end
            end
        end)

        createSlider(automationTab, "Clicker CPS", "Clicks per second", 1, 50, 10, function(value)
            autoClickerCPS = value
            if autoClickerButton and autoClickerEnabled then
                local button = autoClickerButton:FindFirstChild("AutoClickerButton")
                if button then
                    button.Text = "🖱️\nAUTO\nCLICK\nON\n" .. value .. " CPS"
                end
            end
        end)

        -- ==================== COMBAT TAB ====================
        createToggle(combatTab, "Visible Hitbox", "Makes enemy heads BIG and RED", function(enabled)
            hitboxExtenderEnabled = enabled
            if enabled then
                task.spawn(visibleHitboxLoop)
            end
        end)

        createSlider(combatTab, "Head Size", "How big to make heads (5-50 studs)", 5, 50, 15, function(value)
            hitboxRange = value
        end)

        createToggle(combatTab, "Show Range Visual", "Shows sphere around you", function(enabled)
            hitboxVisualEnabled = enabled
            if enabled then
                task.spawn(function()
                    while hitboxVisualEnabled do
                        if hitboxVisualPart then
                            hitboxVisualPart.Size = Vector3.new(hitboxRange * 2, hitboxRange * 2, hitboxRange * 2)
                            if humanoidRootPart then
                                hitboxVisualPart.CFrame = humanoidRootPart.CFrame
                            end
                        elseif not hitboxVisualPart then
                            hitboxVisualPart = Instance.new("Part")
                            hitboxVisualPart.Name = "HitboxVisual"
                            hitboxVisualPart.Shape = Enum.PartType.Ball
                            hitboxVisualPart.Material = Enum.Material.ForceField
                            hitboxVisualPart.Color = Color3.fromRGB(88, 101, 242)
                            hitboxVisualPart.Transparency = 0.7
                            hitboxVisualPart.CanCollide = false
                            hitboxVisualPart.Anchored = true
                            hitboxVisualPart.Size = Vector3.new(hitboxRange * 2, hitboxRange * 2, hitboxRange * 2)
                            hitboxVisualPart.Parent = Workspace
                        end
                        task.wait(0.05)
                    end
                    if hitboxVisualPart then
                        hitboxVisualPart:Destroy()
                        hitboxVisualPart = nil
                    end
                end)
            else
                if hitboxVisualPart then
                    hitboxVisualPart:Destroy()
                    hitboxVisualPart = nil
                end
            end
        end)

        createToggle(combatTab, "Player ESP + Skeleton", "Shows skeleton, distance, boxes, names, health", function(enabled)
            espEnabled = enabled
            if enabled then
                task.spawn(espLoop)
            else
                for p, _ in pairs(espObjects) do
                    if espObjects[p] then
                        espObjects[p]:Destroy()
                        espObjects[p] = nil
                    end
                end
            end
        end)

        createToggle(combatTab, "Auto Hit", "Auto attacks enemies in range", function(enabled)
            autoHitEnabled = enabled
            if enabled then 
                task.spawn(autoHitLoop) 
            end
        end)

        -- ==================== VISUAL TAB ====================
        createSection(visualTab, "BRAINROT ESP")
        
        createToggle(visualTab, "Brainrot ESP", "Shows ESP boxes on all brainrots with rarity colors", function(enabled)
            brainrotESPEnabled = enabled
            if enabled then
                task.spawn(brainrotESPLoop)
            else
                clearAllBrainrotESP()
            end
        end)
        
        createToggle(visualTab, "Show Brainrot Names", "Display brainrot names on ESP", function(enabled)
            showBrainrotNames = enabled
        end)
        
        createToggle(visualTab, "Show Distance", "Show distance to brainrots", function(enabled)
            showBrainrotDistance = enabled
        end)
        
        createSlider(visualTab, "ESP Max Distance", "Maximum distance to show ESP", 100, 5000, 1000, function(value)
            espMaxDistance = value
        end)
        
        createSection(visualTab, "VIP WALL BYPASS")
        
        createToggle(visualTab, "VIP Wall Bypass", "Removes collision from VIP walls (walk through)", function(enabled)
            vipWallBypassEnabled = enabled
            if enabled then
                bypassVIPWalls()
            else
                restoreVIPWalls()
            end
        end)
        
        createToggle(visualTab, "Persistent VIP Noclip", "Continuously bypass walls (for respawning walls)", function(enabled)
            vipWallNoclip = enabled
            if enabled then
                task.spawn(vipWallNoclipLoop)
            else
                restoreVIPWalls()
            end
        end)
        
        createButton(visualTab, "Force Bypass VIP Walls Now", function()
            local success = bypassVIPWalls()
            if success then
                print("VIP Walls bypassed successfully!")
            else
                warn("Failed to find VIP walls")
            end
        end)

        -- ==================== EVENT TAB ====================
        createSection(eventTab, "ARCADE")
        
        createToggle(eventTab, "Auto Teleport Tickets", "Teleports arcade tickets to you", function(enabled)
            autoTeleportTickets = enabled
            if enabled then 
                task.spawn(autoTeleportTicketsLoop) 
            end
        end)

        createToggle(eventTab, "Auto Teleport Consoles", "Teleports game consoles to you", function(enabled)
            autoTeleportConsoles = enabled
            if enabled then 
                task.spawn(autoTeleportConsolesLoop) 
            end
        end)

        createSection(eventTab, "MONEY")

        createToggle(eventTab, "Auto Complete Obby", "Auto completes all 3 obbies", function(enabled)
            autoCompleteObby = enabled
            if enabled then 
                task.spawn(autoCompleteObbyLoop) 
            end
        end)

        createToggle(eventTab, "Auto Collect Gold Bars", "Teleports gold bar models to you", function(enabled)
            autoCollectGoldBars = enabled
            if enabled then 
                task.spawn(autoCollectGoldBarsLoop) 
            end
        end)

        createToggle(eventTab, "Auto Spin Wheel", "Automatically spins the wheel when near", function(enabled)
            autoSpinWheel = enabled
            if enabled then 
                task.spawn(autoSpinWheelLoop) 
            end
        end)

        -- ==================== STAGES TAB ====================
        createSlider(stagesTab, "Select Stage", "Stage number (1-9)", 1, 9, 1, function(value)
            selectedStage = STAGE_RARITIES[value]
        end)

        createButton(stagesTab, "Tween to Selected Stage", function()
            if not selectedStage then
                warn("Please select a stage first!")
                return
            end
            tweenToStageWallSequential(selectedStage)
        end)

        createToggle(stagesTab, "Auto Tween to Stage", "Automatically tweens to selected stage wall", function(enabled)
            autoTweenToStage = enabled
            if enabled then
                if not selectedStage then
                    warn("Please select a stage first!")
                    autoTweenToStage = false
                    return
                end
                task.spawn(autoTweenToStageLoop)
            end
        end)

        -- ==================== SELL TAB ====================
        createToggle(sellTab, "Auto Sell Inventory", "Sells all your brainrots automatically", function(enabled)
            autoSellInventory = enabled
            if enabled then 
                task.spawn(autoSellInventoryLoop) 
            end
        end)

        createButton(sellTab, "Sell Holding Brainrots", function()
            if SellToolFunction then
                SellToolFunction:InvokeServer()
                print("Sold holding brainrots!")
            else
                warn("SellTool remote not found!")
            end
        end)

        -- ==================== SERVER TAB (NEW) ====================
        createSection(serverTab, "SERVER MANAGEMENT")
        
        createButton(serverTab, "🔄 Rejoin Current Server", function()
            rejoinServer()
        end, Color3.fromRGB(88, 101, 242))
        
        createButton(serverTab, "🌐 Hop to Lowest Player Server", function()
            hopToLowestPlayerServer()
        end, Color3.fromRGB(87, 242, 135))
        
        createSection(serverTab, "SERVER INFO")
        
        local serverInfoFrame = Instance.new("Frame")
        serverInfoFrame.Size = UDim2.new(1, -20, 0, 100)
        serverInfoFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
        serverInfoFrame.BackgroundTransparency = 0.3
        serverInfoFrame.BorderSizePixel = 0
        serverInfoFrame.Parent = serverTab
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 12)
        infoCorner.Parent = serverInfoFrame
        
        local playerCountLabel = Instance.new("TextLabel")
        playerCountLabel.Size = UDim2.new(1, -20, 0, 25)
        playerCountLabel.Position = UDim2.new(0, 10, 0, 10)
        playerCountLabel.BackgroundTransparency = 1
        playerCountLabel.Font = Enum.Font.GothamBold
        playerCountLabel.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
        playerCountLabel.TextColor3 = CONFIG.COLORS.White
        playerCountLabel.TextSize = 14
        playerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
        playerCountLabel.Parent = serverInfoFrame
        
        local serverIdLabel = Instance.new("TextLabel")
        serverIdLabel.Size = UDim2.new(1, -20, 0, 25)
        serverIdLabel.Position = UDim2.new(0, 10, 0, 40)
        serverIdLabel.BackgroundTransparency = 1
        serverIdLabel.Font = Enum.Font.Gotham
        serverIdLabel.Text = "Server ID: " .. string.sub(game.JobId, 1, 8) .. "..."
        serverIdLabel.TextColor3 = CONFIG.COLORS.Gray
        serverIdLabel.TextSize = 12
        serverIdLabel.TextXAlignment = Enum.TextXAlignment.Left
        serverIdLabel.Parent = serverInfoFrame
        
        local pingLabel = Instance.new("TextLabel")
        pingLabel.Size = UDim2.new(1, -20, 0, 25)
        pingLabel.Position = UDim2.new(0, 10, 0, 70)
        pingLabel.BackgroundTransparency = 1
        pingLabel.Font = Enum.Font.Gotham
        pingLabel.Text = "Ping: Calculating..."
        pingLabel.TextColor3 = CONFIG.COLORS.Gray
        pingLabel.TextSize = 12
        pingLabel.TextXAlignment = Enum.TextXAlignment.Left
        pingLabel.Parent = serverInfoFrame
        
        -- Update ping
        task.spawn(function()
            while serverInfoFrame and serverInfoFrame.Parent do
                local ping = player:GetNetworkPing() * 1000
                pingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"
                task.wait(5)
            end
        end)
        
        -- Update player count
        Players.PlayerAdded:Connect(function()
            if playerCountLabel and playerCountLabel.Parent then
                playerCountLabel.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
            end
        end)
        
        Players.PlayerRemoving:Connect(function()
            if playerCountLabel and playerCountLabel.Parent then
                playerCountLabel.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
            end
        end)

        -- ==================== SETTINGS TAB ====================
        createSection(settingsTab, "FPS OPTIMIZER")
        
        createToggle(settingsTab, "Optimize FPS", "Lowers graphics quality for better performance", function(enabled)
            if enabled then
                optimizeFPS()
            else
                restoreFPS()
            end
        end)
        
        createSection(settingsTab, "DISCORD WEBHOOK")
        
        createTextBox(settingsTab, "Webhook URL", "Paste your Discord webhook URL here...", function(text)
            webhookURL = text
            print("Webhook URL set!")
        end)
        
        createToggle(settingsTab, "Enable Webhook Notifications", "Sends alerts when Celestial/Divine/Secret spawn", function(enabled)
            webhookEnabled = enabled
            if enabled then
                if webhookURL == "" then
                    warn("Please set webhook URL first!")
                    webhookEnabled = false
                    return
                end
                task.spawn(webhookCheckLoop)
                print("Webhook notifications enabled!")
            end
        end)
        
        createSection(settingsTab, "WAVE PROTECTION")
        
        createToggle(settingsTab, "Wave Protection (VIP Walls)", "Stays in VIP walls until wave passes", function(enabled)
            waveProtectionEnabled = enabled
            if enabled then
                task.spawn(waveProtectionLoop)
            end
        end)

        createSlider(settingsTab, "Wave Detection Range", "How far to detect waves", 50, 200, 125, function(value)
            waveProtectionRange = value
        end)

        createSection(settingsTab, "MISC")
        
        createButton(settingsTab, "📋 Copy Discord Link", function()
            local discordLink = "https://discord.gg/nexus "
            if setclipboard then
                setclipboard(discordLink)
                print("Discord link copied!")
            else
                print("Discord Link:", discordLink)
            end
        end)

        -- Select Automation tab by default
        task.delay(0.5, function()
            local autoTab = tabContainer:FindFirstChild("AutomationTab")
            if autoTab then
                autoTab.MouseButton1Click:Fire()
            end
        end)

        print("GUI Created Successfully!")
    end)
    
    if not success then
        warn("GUI Creation Failed:", err)
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "ErrorGui"
        errorGui.Parent = playerGui
        
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(0, 400, 0, 100)
        errorLabel.Position = UDim2.new(0.5, -200, 0.5, -50)
        errorLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        errorLabel.Text = "GUI Error: " .. tostring(err)
        errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        errorLabel.TextWrapped = true
        errorLabel.Parent = errorGui
    end
end

-- Character respawn handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    
    if vipWallBypassEnabled then
        task.delay(1, bypassVIPWalls)
    end
end)

-- CRITICAL: Delay GUI creation
task.delay(2, function()
    print("Creating GUI after delay...")
    createGUI()
end)

print("Script loaded, waiting to create GUI...")
