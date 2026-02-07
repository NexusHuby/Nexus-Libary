--[[
    Nexus|Escape Tsunami for Brainrots - Complete Edition Fixed v8
    Fixes: Brainrot collection, Wave protection with VIP walls (stay until wave passes), Base Upgrade, Auto Clicker, ESP Skeleton, Spawn Machines
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

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for character properly
local character = player.Character
if not character then
    character = player.CharacterAdded:Wait()
end

local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

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
local UpgradeBrainrotFunction = getRemote(RemoteFunctions, "UpgradeBrainrot")
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
    }
}

-- State Variables
local autoCollectCash = false
local autoCollectCashTweened = false
local autoUpgradeSpeed = false
local selectedSpeedAmount = 1
local autoUpgradeCarry = false
local autoSellInventory = false
local autoRebirth = false

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

-- Auto Collect Specific Brainrot Variables
local autoCollectSpecificBrainrot = false
local selectedBrainrotToCollect = nil
local isCollectingBrainrot = false
local positionBeforeCollecting = nil
local brainrotDropdownOpen = false

-- MODIFIED: Wave Protection Variables - Stay until wave completely passes
local waveProtectionEnabled = false
local waveProtectionRange = 125
local isHidingFromWave = false
local waveHidePosition = nil
local waveHideStartTime = nil
local currentWavePart = nil -- Track the specific wave we're hiding from
local WAVE_CHECK_INTERVAL = 0.1 -- Check more frequently
local WAVE_SAFETY_BUFFER = 50 -- Extra distance to ensure wave is gone

-- Auto Clicker Variables
local autoClickerEnabled = false
local autoClickerCPS = 10
local autoClickerButton = nil
local autoClickerLoop = nil

-- Stages Tab Variables
local selectedStage = nil
local autoTweenToStage = false
local isTweeningToStage = false

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

-- Stages/Rarities for VIP Walls (in order from Common to Celestial)
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

-- Get Player Base
local function getPlayerBase()
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then return nil end
    
    for _, base in ipairs(bases:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local slots = base:FindFirstChild("Slots")
            if slots then
                local ownerAttr = base:GetAttribute("Owner")
                if ownerAttr == player.UserId or ownerAttr == player.Name then
                    return base
                end
                
                local targetPart = base:IsA("Model") and base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart", true)
                if targetPart then
                    local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                    if distance < 100 then
                        return base
                    end
                end
            end
        end
    end
    
    local closestBase = nil
    local closestDistance = math.huge
    
    for _, base in ipairs(bases:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local slots = base:FindFirstChild("Slots")
            if slots then
                local targetPart = base:IsA("Model") and base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart", true)
                if targetPart then
                    local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestBase = base
                    end
                end
            end
        end
    end
    
    return closestBase
end

-- Get all brainrots from ReplicatedStorage for dropdown
local function getAllBrainrotsFromStorage()
    local brainrotList = {}
    local assets = ReplicatedStorage:FindFirstChild("Assets")
    if not assets then return brainrotList end
    
    local brainrotsFolder = assets:FindFirstChild("Brainrots")
    if not brainrotsFolder then return brainrotList end
    
    for _, rarity in ipairs(RARITY_ORDER) do
        local rarityFolder = brainrotsFolder:FindFirstChild(rarity)
        if rarityFolder then
            for _, brainrotModel in ipairs(rarityFolder:GetChildren()) do
                if brainrotModel:IsA("Model") then
                    table.insert(brainrotList, {
                        name = brainrotModel.Name,
                        rarity = rarity,
                        fullName = rarity .. " | " .. brainrotModel.Name
                    })
                end
            end
        end
    end
    
    return brainrotList
end

-- Find specific brainrot in ActiveBrainrots
local function findBrainrotInActive(brainrotName, rarity)
    local activeBrainrots = Workspace:FindFirstChild("ActiveBrainrots")
    if not activeBrainrots then 
        warn("ActiveBrainrots folder not found!")
        return nil 
    end
    
    local foldersToCheck = {}
    if rarity then
        local folder = activeBrainrots:FindFirstChild(rarity)
        if folder then 
            table.insert(foldersToCheck, folder) 
        end
    else
        for _, folder in ipairs(activeBrainrots:GetChildren()) do
            if folder:IsA("Folder") then
                table.insert(foldersToCheck, folder)
            end
        end
    end
    
    for _, folder in ipairs(foldersToCheck) do
        for _, renderedBrainrot in ipairs(folder:GetChildren()) do
            if renderedBrainrot:IsA("Model") and renderedBrainrot.Name == "RenderedBrainrot" then
                for _, child in ipairs(renderedBrainrot:GetChildren()) do
                    if child:IsA("Model") and child.Name == brainrotName then
                        local targetPart = renderedBrainrot.PrimaryPart 
                        if not targetPart then
                            targetPart = renderedBrainrot:FindFirstChild("HumanoidRootPart")
                        end
                        if not targetPart then
                            targetPart = renderedBrainrot:FindFirstChildWhichIsA("BasePart")
                        end
                        if not targetPart and child then
                            targetPart = child:FindFirstChildWhichIsA("BasePart")
                        end
                        
                        local prompt = renderedBrainrot:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if not prompt and child then
                            prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
                        end
                        
                        if targetPart then
                            return {
                                model = renderedBrainrot,
                                brainrotModel = child,
                                part = targetPart,
                                name = brainrotName,
                                rarity = folder.Name,
                                cframe = targetPart.CFrame,
                                prompt = prompt
                            }
                        end
                    end
                end
            end
        end
    end
    
    return nil
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

-- Safe tween to position
local function safeTweenToPosition(targetPosition, targetCFrame, useGapIfNeeded)
    useGapIfNeeded = useGapIfNeeded ~= false
    
    local safeTargetPos = Vector3.new(targetPosition.X, math.max(targetPosition.Y, 15), targetPosition.Z)
    local safeTargetCFrame = CFrame.new(safeTargetPos) * (targetCFrame - targetCFrame.Position)
    
    local finalTween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.8), {CFrame = safeTargetCFrame})
    finalTween:Play()
    finalTween.Completed:Wait()
    
    return true
end

-- Sequential tween through all VIP walls up to target
local function tweenToStageWallSequential(targetRarity)
    if not targetRarity then return false end
    if isTweeningToStage then return false end
    
    isTweeningToStage = true
    
    local success, result = pcall(function()
        local walls = getVIPWallsInOrder(targetRarity)
        
        if #walls == 0 then return false end
        
        for i, wallData in ipairs(walls) do
            if not isTweeningToStage then return false end
            
            local targetCFrame = wallData.part.CFrame * CFrame.new(0, 0, -5)
            local tweenTime = (i == #walls) and 1.0 or 0.6
            
            local tween = TweenService:Create(
                humanoidRootPart, 
                TweenInfo.new(tweenTime), 
                {CFrame = targetCFrame}
            )
            
            tween:Play()
            tween.Completed:Wait()
            
            if i < #walls then
                task.wait(0.3)
            end
        end
        
        return true
    end)
    
    isTweeningToStage = false
    return success and result
end

-- Auto Tween to Stage Loop
local function autoTweenToStageLoop()
    while autoTweenToStage do
        local success, err = pcall(function()
            if not selectedStage then
                task.wait(2)
                return
            end
            
            local walls = getVIPWallsInOrder(selectedStage)
            if #walls == 0 then return end
            
            local finalWall = walls[#walls]
            local distance = (humanoidRootPart.Position - finalWall.part.Position).Magnitude
            
            if distance > 15 then
                tweenToStageWallSequential(selectedStage)
            end
        end)
        
        task.wait(3)
    end
end

-- MODIFIED: Wave Protection Loop - Stay in VIP wall until wave COMPLETELY passes
local function waveProtectionLoop()
    print("Wave Protection (VIP Walls) started - Enhanced Version")
    isHidingFromWave = false
    waveHidePosition = nil
    waveHideStartTime = nil
    currentWavePart = nil
    
    while waveProtectionEnabled do
        local success, err = pcall(function()
            local activeTsunamis = Workspace:FindFirstChild("ActiveTsunamis")
            
            -- If no active tsunamis and we were hiding, return to position
            if not activeTsunamis or #activeTsunamis:GetChildren() == 0 then
                if isHidingFromWave and waveHidePosition then
                    print("No active waves detected - returning to position")
                    
                    local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
                    returnTween:Play()
                    returnTween.Completed:Wait()
                    
                    isHidingFromWave = false
                    waveHidePosition = nil
                    waveHideStartTime = nil
                    currentWavePart = nil
                    print("Returned to original position - all waves gone")
                end
                return
            end
            
            -- Find nearest wave
            local nearestWave = nil
            local nearestDist = math.huge
            
            for _, wave in ipairs(activeTsunamis:GetChildren()) do
                local wavePart = nil
                if wave:IsA("BasePart") then
                    wavePart = wave
                elseif wave:IsA("Model") then
                    wavePart = wave.PrimaryPart or wave:FindFirstChildWhichIsA("BasePart")
                end
                
                if wavePart then
                    local distance = (humanoidRootPart.Position - wavePart.Position).Magnitude
                    if distance < nearestDist then
                        nearestDist = distance
                        nearestWave = wavePart
                    end
                end
            end
            
            -- If wave is within detection range
            if nearestWave and nearestDist <= waveProtectionRange then
                if not isHidingFromWave then
                    print("Wave detected at", nearestDist, "studs - moving to VIP wall!")
                    
                    -- Store position before hiding
                    waveHidePosition = humanoidRootPart.CFrame
                    waveHideStartTime = tick()
                    currentWavePart = nearestWave
                    
                    -- Cancel brainrot collection if active
                    if isCollectingBrainrot then
                        print("Cancelling brainrot collection - WAVE PRIORITY!")
                        isCollectingBrainrot = false
                    end
                    
                    -- Get nearest VIP wall
                    local nearestWall = getNearestVIPWall()
                    if nearestWall then
                        isHidingFromWave = true
                        
                        -- Tween to wall immediately
                        local targetCFrame = nearestWall.part.CFrame * CFrame.new(0, 0, -5)
                        
                        local emergencyTween = TweenService:Create(
                            humanoidRootPart,
                            TweenInfo.new(0.5),
                            {CFrame = targetCFrame}
                        )
                        
                        emergencyTween:Play()
                        emergencyTween.Completed:Wait()
                        
                        print("Now hiding at VIP wall:", nearestWall.name)
                    end
                else
                    -- We're already hiding - check if we need to stay
                    -- Keep checking if the wave still exists
                    if currentWavePart and currentWavePart.Parent then
                        local currentDist = (humanoidRootPart.Position - currentWavePart.Position).Magnitude
                        
                        -- If wave is still too close, stay in wall
                        if currentDist <= (waveProtectionRange + WAVE_SAFETY_BUFFER) then
                            -- Keep player in VIP wall (anti-afk movement)
                            local nearestWall = getNearestVIPWall()
                            if nearestWall then
                                local targetCFrame = nearestWall.part.CFrame * CFrame.new(0, 0, -5)
                                -- Small adjustment to keep player in place
                                if (humanoidRootPart.Position - targetCFrame.Position).Magnitude > 5 then
                                    humanoidRootPart.CFrame = targetCFrame
                                end
                            end
                        end
                    else
                        -- Our tracked wave is gone, but there might be others
                        -- Wait a bit then check if any waves are still close
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
                            print("Wave passed - returning to position")
                            
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
            elseif nearestWave and nearestDist > waveProtectionRange and isHidingFromWave then
                -- Wave is far away now, return to position
                print("Wave moved far away - returning to position")
                
                local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
                returnTween:Play()
                returnTween.Completed:Wait()
                
                isHidingFromWave = false
                waveHidePosition = nil
                waveHideStartTime = nil
                currentWavePart = nil
            end
        end)
        
        if not success then
            warn("Wave protection error:", err)
        end
        
        task.wait(WAVE_CHECK_INTERVAL)
    end
    
    -- Cleanup when disabled
    if isHidingFromWave and waveHidePosition then
        local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
        returnTween:Play()
    end
    
    isHidingFromWave = false
    waveHidePosition = nil
    waveHideStartTime = nil
    currentWavePart = nil
    print("Wave Protection stopped")
end

-- Proximity prompt activation with extended hold
local function activateProximityPrompt(prompt)
    if not prompt then return false end
    if not prompt:IsA("ProximityPrompt") then return false end
    
    prompt:InputHoldBegin()
    task.wait(1.5)
    prompt:InputHoldEnd()
    
    return true
end

-- Auto Collect Specific Brainrot Loop
local function autoCollectSpecificBrainrotLoop()
    while autoCollectSpecificBrainrot do
        local success, err = pcall(function()
            if not selectedBrainrotToCollect then
                task.wait(2)
                return
            end
            
            if isHidingFromWave then
                task.wait(1)
                return
            end
            
            local foundBrainrot = findBrainrotInActive(selectedBrainrotToCollect.name, selectedBrainrotToCollect.rarity)
            
            if foundBrainrot then
                isCollectingBrainrot = true
                positionBeforeCollecting = humanoidRootPart.CFrame
                
                local targetCFrame = foundBrainrot.cframe + Vector3.new(0, 5, 0)
                safeTweenToPosition(foundBrainrot.part.Position, targetCFrame, false)
                
                task.wait(0.3)
                
                if foundBrainrot.prompt then
                    activateProximityPrompt(foundBrainrot.prompt)
                else
                    firetouchinterest(humanoidRootPart, foundBrainrot.part, 0)
                    task.wait(0.05)
                    firetouchinterest(humanoidRootPart, foundBrainrot.part, 1)
                end
                
                task.wait(1.0)
                
                local base = getPlayerBase()
                if base then
                    local basePart = base:FindFirstChildWhichIsA("BasePart", true)
                    if basePart then
                        safeTweenToPosition(basePart.Position, basePart.CFrame + Vector3.new(0, 5, 0), false)
                    end
                end
                
                isCollectingBrainrot = false
                positionBeforeCollecting = nil
                task.wait(2)
            else
                task.wait(1)
            end
        end)
        
        if not success then
            isCollectingBrainrot = false
        end
        
        task.wait(0.5)
    end
    
    isCollectingBrainrot = false
end

-- Auto functions
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

local function autoHitLoop()
    while autoHitEnabled do
        local success, err = pcall(function()
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

-- Auto Collect Cash Loop - Modified
local function autoCollectCashLoop()
    local resetTimer = 0
    
    while autoCollectCash do
        local success, err = pcall(function()
            local base = getPlayerBase()
            if base then
                -- Tween to base first
                local basePart = base:FindFirstChildWhichIsA("BasePart", true)
                if basePart then
                    local targetCFrame = basePart.CFrame + Vector3.new(0, 5, 0)
                    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.5), {CFrame = targetCFrame})
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(0.2)
                end
                
                local slots = base:FindFirstChild("Slots")
                if slots then
                    for i = 1, 40 do
                        if not autoCollectCash then break end
                        local slot = slots:FindFirstChild("Slot" .. i) or slots:FindFirstChild("slot" .. i)
                        if slot then
                            local collectPart = slot:FindFirstChild("Collect")
                            if collectPart and collectPart:IsA("BasePart") then
                                collectPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, 0)
                                if CollectMoneyEvent then
                                    CollectMoneyEvent:FireServer()
                                end
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end)
        
        resetTimer = resetTimer + 0.05
        if resetTimer >= 5 then
            local currentPos = humanoidRootPart.CFrame
            character:BreakJoints()
            resetTimer = 0
            
            player.CharacterAdded:Wait()
            task.wait(0.5)
            if humanoidRootPart then
                humanoidRootPart.CFrame = currentPos
            end
        end
        
        task.wait(0.05)
    end
    autoCollectCashTweened = false
end

-- Auto Collect Gold Bars Loop
local function autoCollectGoldBarsLoop()
    while autoCollectGoldBars do
        local success, err = pcall(function()
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

-- Auto Spin Wheel Loop
local function autoSpinWheelLoop()
    local Net = require(ReplicatedStorage.Packages.Net)
    local WheelSpinRoll = Net:RemoteFunction("WheelSpin.Roll")
    local WheelSpinComplete = Net:RemoteEvent("WheelSpin.Complete")
    
    while autoSpinWheel do
        local success, err = pcall(function()
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
        
        if not success then
            task.wait(3)
        end
        
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
    
    -- Make draggable
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

-- Visible Hitbox
local visibleHitboxParts = {}

local function visibleHitboxLoop()
    while hitboxExtenderEnabled do
        local success, err = pcall(function()
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character then
                    local targetChar = targetPlayer.Character
                    local head = targetChar:FindFirstChild("Head")
                    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
                    
                    if head then
                        if not head:GetAttribute("OriginalSize") then
                            head:SetAttribute("OriginalSize", head.Size)
                            head:Set
