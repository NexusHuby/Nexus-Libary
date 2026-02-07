--[[
    Nexus|Escape Tsunami for Brainrots - Modified Edition
    Changes:
    - Longer proximity prompt hold for brainrot collection
    - Stay in VIP walls longer during waves (don't instantly die)
    - Removed: Auto Spawn Machine toggle
    - Fixed ESP toggle functionality
    - Removed: Auto Upgrade Selected Brainrot toggle and dropdown
    - Removed: Auto Upgrade Brainrot toggle
    - Removed: Auto Upgrade Base toggle
    - Modified Auto Collect Cash: Tween to base first, spawn collect parts, reset every 5s
    - Added: Copy Discord Link button in Settings
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

-- Wave Protection Variables (using VIP walls instead of gaps)
local waveProtectionEnabled = false
local waveProtectionRange = 125 -- Between 100-150 as requested
local isHidingFromWave = false
local waveHidePosition = nil
local waveHideStartTime = nil -- NEW: Track how long we've been hiding
local MIN_WAVE_HIDE_TIME = 3 -- NEW: Minimum seconds to stay in VIP wall

-- FIXED: Auto Clicker Variables - Draggable auto-clicking button
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
    
    -- Find base that belongs to local player
    for _, base in ipairs(bases:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            -- Check if this is our base by looking for owner attribute or proximity
            local slots = base:FindFirstChild("Slots")
            if slots then
                -- Additional check: see if we can find a player-specific identifier
                local ownerAttr = base:GetAttribute("Owner")
                if ownerAttr == player.UserId or ownerAttr == player.Name then
                    return base
                end
                
                -- Fallback: check if base has our character's proximity
                local targetPart = base:IsA("Model") and base.PrimaryPart or base:FindFirstChildWhichIsA("BasePart", true)
                if targetPart then
                    local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
                    -- If we're very close to this base, it's probably ours
                    if distance < 100 then
                        return base
                    end
                end
            end
        end
    end
    
    -- If no specific owner found, return the closest base
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
    
    print("Looking for brainrot:", brainrotName, "in rarity:", rarity or "any")
    
    local foldersToCheck = {}
    if rarity then
        local folder = activeBrainrots:FindFirstChild(rarity)
        if folder then 
            table.insert(foldersToCheck, folder) 
        else
            warn("Rarity folder not found:", rarity)
        end
    else
        for _, folder in ipairs(activeBrainrots:GetChildren()) do
            if folder:IsA("Folder") then
                table.insert(foldersToCheck, folder)
            end
        end
    end
    
    for _, folder in ipairs(foldersToCheck) do
        print("Checking folder:", folder.Name)
        for _, renderedBrainrot in ipairs(folder:GetChildren()) do
            if renderedBrainrot:IsA("Model") and renderedBrainrot.Name == "RenderedBrainrot" then
                for _, child in ipairs(renderedBrainrot:GetChildren()) do
                    if child:IsA("Model") and child.Name == brainrotName then
                        print("Found brainrot model inside RenderedBrainrot:", child.Name)
                        
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
                        
                        -- Look for proximity prompt
                        local prompt = renderedBrainrot:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if not prompt and child then
                            prompt = child:FindFirstChildWhichIsA("ProximityPrompt", true)
                        end
                        
                        if targetPart then
                            print("Found target part at position:", targetPart.Position)
                            return {
                                model = renderedBrainrot,
                                brainrotModel = child,
                                part = targetPart,
                                name = brainrotName,
                                rarity = folder.Name,
                                cframe = targetPart.CFrame,
                                prompt = prompt
                            }
                        else
                            warn("Found brainrot but no BasePart for position!")
                        end
                    end
                end
            end
        end
    end
    
    print("Brainrot not found:", brainrotName)
    return nil
end

-- Get VIP Wall for specific rarity/stage
local function getVIPWallForRarity(rarity)
    local defaultMap = Workspace:FindFirstChild("DefaultMap_SharedInstances")
    if not defaultMap then
        warn("DefaultMap_SharedInstances not found!")
        return nil
    end
    
    local vipWalls = defaultMap:FindFirstChild("VIPWalls")
    if not vipWalls then
        warn("VIPWalls folder not found!")
        return nil
    end
    
    -- Look for wall with matching rarity name
    for _, wall in ipairs(vipWalls:GetChildren()) do
        if wall:IsA("BasePart") or wall:IsA("Model") then
            -- Check if wall name contains the rarity
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
    
    -- If no specific match, try to find by order in the folder
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
    
    warn("VIP Wall not found for rarity:", rarity)
    return nil
end

-- Get all VIP walls in order from Common to target
local function getVIPWallsInOrder(targetRarity)
    local targetIndex = table.find(STAGE_RARITIES, targetRarity)
    if not targetIndex then
        warn("Invalid target rarity:", targetRarity)
        return {}
    end
    
    local walls = {}
    for i = 1, targetIndex do
        local rarity = STAGE_RARITIES[i]
        local wallData = getVIPWallForRarity(rarity)
        if wallData then
            table.insert(walls, wallData)
            print("Added wall to path:", rarity, "at position", wallData.part.Position)
        else
            warn("Could not find wall for:", rarity)
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

-- Check if position is safe
local function isPositionSafe(position)
    if position.Y < 10 then
        return false, "under_map"
    end
    return true, nil
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
    if not targetRarity then
        warn("No stage selected!")
        return false
    end
    
    if isTweeningToStage then
        warn("Already tweening to a stage!")
        return false
    end
    
    isTweeningToStage = true
    
    local success, result = pcall(function()
        local walls = getVIPWallsInOrder(targetRarity)
        
        if #walls == 0 then
            warn("No VIP walls found for path to:", targetRarity)
            return false
        end
        
        print("Starting sequential tween through", #walls, "walls to reach", targetRarity)
        
        -- Tween through each wall in order
        for i, wallData in ipairs(walls) do
            if not isTweeningToStage then
                print("Tweening cancelled")
                return false
            end
            
            print(string.format("Tweening to wall %d/%d: %s", i, #walls, wallData.rarity))
            
            -- Tween to position in front of wall
            local targetCFrame = wallData.part.CFrame * CFrame.new(0, 0, -5)
            
            -- Use shorter tween time for intermediate walls, longer for final
            local tweenTime = (i == #walls) and 1.0 or 0.6
            
            local tween = TweenService:Create(
                humanoidRootPart, 
                TweenInfo.new(tweenTime), 
                {CFrame = targetCFrame}
            )
            
            tween:Play()
            tween.Completed:Wait()
            
            -- Small pause between walls (except after the last one)
            if i < #walls then
                task.wait(0.3)
            end
        end
        
        print("Arrived at final destination:", targetRarity)
        return true
    end)
    
    isTweeningToStage = false
    
    if not success then
        warn("Error in sequential tween:", result)
        return false
    end
    
    return result
end

-- Auto Tween to Stage Loop
local function autoTweenToStageLoop()
    print("Auto Tween to Stage started for:", selectedStage)
    
    while autoTweenToStage do
        local success, err = pcall(function()
            if not selectedStage then
                task.wait(2)
                return
            end
            
            -- Check if we're already near the final wall
            local walls = getVIPWallsInOrder(selectedStage)
            if #walls == 0 then
                task.wait(2)
                return
            end
            
            local finalWall = walls[#walls]
            local distance = (humanoidRootPart.Position - finalWall.part.Position).Magnitude
            
            -- If far from final wall, do full sequence
            if distance > 15 then
                tweenToStageWallSequential(selectedStage)
            end
        end)
        
        if not success then
            warn("Auto tween to stage error:", err)
        end
        
        task.wait(3)
    end
    
    print("Auto Tween to Stage stopped")
end

-- MODIFIED: Wave Protection Loop - Stays in VIP walls longer
local function waveProtectionLoop()
    print("Wave Protection (VIP Walls) started")
    isHidingFromWave = false
    waveHidePosition = nil
    waveHideStartTime = nil
    
    while waveProtectionEnabled do
        local success, err = pcall(function()
            -- Check for active tsunamis/waves
            local activeTsunamis = Workspace:FindFirstChild("ActiveTsunamis")
            if not activeTsunamis then
                -- No waves, check if we should return
                if isHidingFromWave and waveHidePosition then
                    -- NEW: Check if minimum hide time has passed
                    local hideTime = tick() - (waveHideStartTime or tick())
                    if hideTime < MIN_WAVE_HIDE_TIME then
                        -- Stay in wall for minimum time
                        return
                    end
                    
                    task.wait(1) -- Extra safety wait
                    
                    -- Return to previous position
                    local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
                    returnTween:Play()
                    returnTween.Completed:Wait()
                    
                    isHidingFromWave = false
                    waveHidePosition = nil
                    waveHideStartTime = nil
                    print("Returned from VIP wall - wave gone after", hideTime, "seconds")
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
            
            -- If wave is between 100-150 studs, go to nearest VIP wall
            if nearestWave and nearestDist >= 100 and nearestDist <= 150 then
                if not isHidingFromWave then
                    print("Wave detected at", nearestDist, "studs - moving to VIP wall!")
                    
                    -- Store position before hiding (unless we're collecting brainrots, safety first)
                    if not isHidingFromWave then
                        waveHidePosition = humanoidRootPart.CFrame
                        waveHideStartTime = tick() -- NEW: Start tracking hide time
                    end
                    
                    -- Cancel brainrot collection if active - SAFETY FIRST
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
                        
                        -- Fast tween for emergency
                        local emergencyTween = TweenService:Create(
                            humanoidRootPart,
                            TweenInfo.new(0.5), -- Fast tween
                            {CFrame = targetCFrame}
                        )
                        
                        emergencyTween:Play()
                        emergencyTween.Completed:Wait()
                        
                        print("Now hiding at VIP wall:", nearestWall.name)
                    else
                        warn("No VIP wall found for protection!")
                    end
                end
            elseif nearestWave and nearestDist > 150 and isHidingFromWave then
                -- Wave is far away now, check minimum hide time before returning
                local hideTime = tick() - (waveHideStartTime or tick())
                if hideTime >= MIN_WAVE_HIDE_TIME then
                    if waveHidePosition then
                        local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
                        returnTween:Play()
                        returnTween.Completed:Wait()
                        
                        isHidingFromWave = false
                        waveHidePosition = nil
                        waveHideStartTime = nil
                        print("Returned from VIP wall - wave far away after", hideTime, "seconds")
                    end
                end
            end
        end)
        
        if not success then
            warn("Wave protection error:", err)
        end
        
        task.wait(0.2) -- Check frequently
    end
    
    -- Cleanup
    if isHidingFromWave and waveHidePosition then
        local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = waveHidePosition})
        returnTween:Play()
    end
    
    isHidingFromWave = false
    waveHidePosition = nil
    waveHideStartTime = nil
    print("Wave Protection stopped")
end

-- MODIFIED: Longer proximity prompt activation (hold longer)
local function activateProximityPrompt(prompt)
    if not prompt then return false end
    if not prompt:IsA("ProximityPrompt") then return false end
    
    print("Activating proximity prompt with extended hold...")
    
    -- MODIFIED: Hold for 1.5 seconds instead of instant
    prompt:InputHoldBegin()
    task.wait(1.5) -- Increased from 0.1 to 1.5 seconds
    prompt:InputHoldEnd()
    
    return true
end

-- MODIFIED: Auto Collect Specific Brainrot Loop - Longer proximity hold
local function autoCollectSpecificBrainrotLoop()
    print("Auto Collect Specific Brainrot started for:", selectedBrainrotToCollect and selectedBrainrotToCollect.name or "None")
    
    while autoCollectSpecificBrainrot do
        local success, err = pcall(function()
            if not selectedBrainrotToCollect then
                task.wait(2)
                return
            end
            
            -- Check if we need to hide from wave first (SAFETY PRIORITY)
            if isHidingFromWave then
                print("Waiting for wave protection to finish...")
                task.wait(1)
                return
            end
            
            local foundBrainrot = findBrainrotInActive(selectedBrainrotToCollect.name, selectedBrainrotToCollect.rarity)
            
            if foundBrainrot then
                isCollectingBrainrot = true
                positionBeforeCollecting = humanoidRootPart.CFrame
                
                -- Tween to brainrot
                local targetCFrame = foundBrainrot.cframe + Vector3.new(0, 5, 0)
                safeTweenToPosition(foundBrainrot.part.Position, targetCFrame, false) -- Don't use gaps
                
                task.wait(0.3) -- Small wait to arrive
                
                -- MODIFIED: Longer activation hold
                if foundBrainrot.prompt then
                    print("Activating proximity prompt with extended hold...")
                    activateProximityPrompt(foundBrainrot.prompt)
                else
                    -- Fallback to touch interest
                    firetouchinterest(humanoidRootPart, foundBrainrot.part, 0)
                    task.wait(0.05)
                    firetouchinterest(humanoidRootPart, foundBrainrot.part, 1)
                end
                
                -- Wait a bit longer for collection to process
                task.wait(1.0) -- Increased from 0.5 to 1.0
                
                -- Return to base
                local base = getPlayerBase()
                if base then
                    local basePart = base:FindFirstChildWhichIsA("BasePart", true)
                    if basePart then
                        safeTweenToPosition(basePart.Position, basePart.CFrame + Vector3.new(0, 5, 0), false)
                    end
                end
                
                isCollectingBrainrot = false
                positionBeforeCollecting = nil
                task.wait(2) -- Wait before next collection
            else
                task.wait(1)
            end
        end)
        
        if not success then
            warn("Auto collect specific brainrot error:", err)
            isCollectingBrainrot = false
        end
        
        task.wait(0.5)
    end
    
    isCollectingBrainrot = false
    print("Auto Collect Specific Brainrot stopped")
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

-- MODIFIED: Auto Collect Cash Loop - Tween to base first, spawn parts, reset every 5s
local function autoCollectCashLoop()
    local resetTimer = 0
    
    while autoCollectCash do
        local success, err = pcall(function()
            local base = getPlayerBase()
            if base then
                -- MODIFIED: First tween to base
                local basePart = base:FindFirstChildWhichIsA("BasePart", true)
                if basePart then
                    -- Tween to base position
                    local targetCFrame = basePart.CFrame + Vector3.new(0, 5, 0)
                    local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.5), {CFrame = targetCFrame})
                    tween:Play()
                    tween.Completed:Wait()
                    task.wait(0.2) -- Small wait after arriving
                end
                
                local slots = base:FindFirstChild("Slots")
                if slots then
                    -- MODIFIED: Spawn collect parts at player position
                    for i = 1, 40 do
                        if not autoCollectCash then break end
                        local slot = slots:FindFirstChild("Slot" .. i) or slots:FindFirstChild("slot" .. i)
                        if slot then
                            local collectPart = slot:FindFirstChild("Collect")
                            if collectPart and collectPart:IsA("BasePart") then
                                -- Move collect part to player instead of moving player to part
                                collectPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -3, 0)
                                if CollectMoneyEvent then
                                    CollectMoneyEvent:FireServer()
                                end
                                task.wait(0.05) -- Faster collection
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

-- Auto Collect Gold Bars
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
                print("Auto Spinning Wheel... Spins left:", spins)
                
                local result, _, _, spinId = WheelSpinRoll:InvokeServer("Money", false)
                
                if result then
                    task.wait(7.5)
                    
                    if spinId then
                        WheelSpinComplete:FireServer(spinId)
                    end
                    
                    task.wait(1)
                else
                    warn("Spin failed, retrying...")
                    task.wait(2)
                end
            else
                local EconomyMath = require(ReplicatedStorage.Shared.utils.EconomyMath)
                local coins = ClientGlobals.PlayerData:TryIndex({"SpecialCurrency", "MoneyCoin"}) or 0
                
                if coins >= EconomyMath.WheelCoinCost then
                    print("Buying spin with coins...")
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
                    print("No spins or coins available, waiting...")
                    task.wait(5)
                end
            end
        end)
        
        if not success then
            warn("Auto spin wheel error:", err)
            task.wait(3)
        end
        
        task.wait(1)
    end
    
    print("Auto Spin Wheel stopped")
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

-- FIXED: Auto Clicker - Draggable button that auto-clicks continuously
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
    
    -- FIXED: Continuous auto-clicking loop
    local function startClicking()
        if autoClickerLoop then return end
        
        button.BackgroundColor3 = CONFIG.COLORS.Success
        button.Text = "🖱️\nAUTO\nCLICK\nON\n" .. autoClickerCPS .. " CPS"
        
        autoClickerLoop = task.spawn(function()
            while autoClickerEnabled do
                local success, err = pcall(function()
                    -- Method 1: VirtualInputManager for actual mouse clicks
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    
                    -- Method 2: Activate equipped tool
                    local tool = character:FindFirstChildWhichIsA("Tool")
                    if tool then
                        tool:Activate()
                    end
                end)
                
                -- Calculate wait time based on CPS
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
    
    -- Start immediately if enabled
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

-- VISIBLE HITBOX
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

-- FIXED: Skeleton ESP with Distance - Better cleanup and state management
local function createSkeletonESP(targetPlayer)
    if targetPlayer == player then return end
    if skeletonESPObjects[targetPlayer] then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = targetPlayer.Name .. "_SkeletonESP"
    espFolder.Parent = playerGui
    
    local lines = {}
    local distanceLabel = nil
    local renderConnection = nil
    
    local function onCharacterAdded(char)
        task.wait(1)
        
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        -- Create distance label
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DistanceLabel"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = espFolder
        
        distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 1, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = "0 studs"
        distanceLabel.TextColor3 = CONFIG.COLORS.White
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        distanceLabel.Font = Enum.Font.GothamBold
        distanceLabel.TextSize = 14
        distanceLabel.Parent = billboard
        
        -- Function to update skeleton lines
        local function updateSkeleton()
            if not espEnabled then return end
            if not targetPlayer.Character then return end
            
            -- Get body parts
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
            local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
            local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
            local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if not (head and torso and root) then return end
            
            -- Update distance
            if distanceLabel and distanceLabel.Parent then
                local dist = math.floor((humanoidRootPart.Position - root.Position).Magnitude)
                distanceLabel.Text = dist .. " studs"
                billboard.Adornee = head
            end
            
            -- Clear old lines
            for _, line in ipairs(lines) do
                if line then line:Destroy() end
            end
            lines = {}
            
            -- Function to create line between two parts
            local function createLine(part1, part2, color)
                if not (part1 and part2) then return end
                
                local line = Instance.new("LineHandleAdornment")
                line.Name = "SkeletonLine"
                line.Color3 = color or CONFIG.COLORS.ESP
                line.Thickness = 2
                line.ZIndex = 10
                line.AlwaysOnTop = true
                line.Adornee = workspace.Terrain -- Attach to terrain to avoid part destruction issues
                line.Parent = espFolder
                
                -- Update line positions
                local function updateLine()
                    if not (part1.Parent and part2.Parent) then 
                        line:Destroy()
                        return 
                    end
                    local pos1 = part1.Position
                    local pos2 = part2.Position
                    line.Length = (pos2 - pos1).Magnitude
                    line.CFrame = CFrame.lookAt(pos1, pos2) * CFrame.new(0, 0, -line.Length / 2)
                end
                
                -- Update immediately and store reference
                updateLine()
                table.insert(lines, line)
                
                -- Update on render step
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if not line or not line.Parent then
                        connection:Disconnect()
                        return
                    end
                    updateLine()
                end)
            end
            
            -- Create skeleton lines
            createLine(head, torso, CONFIG.COLORS.ESP)
            createLine(torso, leftArm, CONFIG.COLORS.ESP)
            createLine(torso, rightArm, CONFIG.COLORS.ESP)
            createLine(torso, leftLeg, CONFIG.COLORS.ESP)
            createLine(torso, rightLeg, CONFIG.COLORS.ESP)
            createLine(leftArm, leftLeg and leftLeg:FindFirstChild("LeftLowerLeg") or leftLeg, CONFIG.COLORS.ESP)
            createLine(rightArm, rightLeg and rightLeg:FindFirstChild("RightLowerLeg") or rightLeg, CONFIG.COLORS.ESP)
        end
        
        -- Update skeleton when character changes
        char:WaitForChild("Humanoid").Died:Connect(function()
            for _, line in ipairs(lines) do
                if line then line:Destroy() end
            end
            lines = {}
        end)
        
        -- Continuous update
        while espEnabled and targetPlayer.Character == char do
            updateSkeleton()
            task.wait(0.1)
        end
    end
    
    if targetPlayer.Character then
        onCharacterAdded(targetPlayer.Character)
    end
    
    targetPlayer.CharacterAdded:Connect(onCharacterAdded)
    skeletonESPObjects[targetPlayer] = espFolder
end

local function removeSkeletonESP(targetPlayer)
    if skeletonESPObjects[targetPlayer] then
        skeletonESPObjects[targetPlayer]:Destroy()
        skeletonESPObjects[targetPlayer] = nil
    end
end

-- FIXED: Regular ESP (boxes, names, health) - Better cleanup
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
        
        local tracer = Instance.new("Frame")
        tracer.Name = "ESPTracer"
        tracer.BackgroundColor3 = CONFIG.COLORS.ESP
        tracer.BorderSizePixel = 0
        tracer.Size = UDim2.new(0, 2, 0, 2)
        tracer.Parent = espFolder
        
        -- Store connection for cleanup
        local connection = RunService.RenderStepped:Connect(function()
            if not espEnabled or not tracer.Parent then 
                connection:Disconnect()
                return 
            end
            if not targetPlayer.Character or not hrp.Parent then 
                tracer.Visible = false
                return 
            end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                local target = Vector2.new(screenPos.X, screenPos.Y)
                local distance = (center - target).Magnitude
                
                tracer.Visible = true
                tracer.Size = UDim2.new(0, distance, 0, 2)
                tracer.Position = UDim2.new(0, math.min(center.X, target.X), 0, math.min(center.Y, target.Y))
                tracer.Rotation = math.deg(math.atan2(target.Y - center.Y, target.X - center.X))
            else
                tracer.Visible = false
            end
        end)
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

-- FIXED: ESP Loop with proper state management
local function espLoop()
    -- Clear existing ESP first
    for p, _ in pairs(espObjects) do
        removeESP(p)
    end
    for p, _ in pairs(skeletonESPObjects) do
        removeSkeletonESP(p)
    end
    
    -- Create ESP for all current players
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            createESP(p)
            createSkeletonESP(p)
        end
    end
    
    -- Handle new players
    local playerAddedConnection = Players.PlayerAdded:Connect(function(p)
        if espEnabled then
            createESP(p)
            createSkeletonESP(p)
        end
    end)
    
    -- Handle players leaving
    local playerRemovingConnection = Players.PlayerRemoving:Connect(function(p)
        removeESP(p)
        removeSkeletonESP(p)
    end)
    
    -- Keep loop running while enabled
    while espEnabled do
        task.wait(1)
    end
    
    -- Cleanup when disabled
    playerAddedConnection:Disconnect()
    playerRemovingConnection:Disconnect()
    
    for p, _ in pairs(espObjects) do
        removeESP(p)
    end
    for p, _ in pairs(skeletonESPObjects) do
        removeSkeletonESP(p)
    end
end

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NexusBrainrotHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 750, 0, 500)
mainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
mainFrame.BackgroundColor3 = CONFIG.COLORS.Background
mainFrame.BackgroundTransparency = CONFIG.COLORS.BackgroundTransparency
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

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
titleLabel.Text = CONFIG.TITLE
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
    hitboxExtenderEnabled = false
    waveProtectionEnabled = false
    autoCollectSpecificBrainrot = false
    autoClickerEnabled = false
    autoSpinWheel = false
    autoTweenToStage = false
    espEnabled = false
    
    if autoClickerButton then
        autoClickerButton:Destroy()
    end
    
    for p, _ in pairs(espObjects) do
        removeESP(p)
    end
    for p, _ in pairs(skeletonESPObjects) do
        removeSkeletonESP(p)
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

local automationTab = createTab("Automation", "⚡")
local combatTab = createTab("Combat", "⚔️")
local eventTab = createTab("Event", "🎉")
local stagesTab = createTab("Stages", "🏆")
local sellTab = createTab("Sell", "💰")
local settingsTab = createTab("Settings", "⚙️")

-- Helper Functions
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
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = frame
    
    clickBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        
        if enabled then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Success}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 26, 0.5, -11)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
        end
    end)
    
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
            
            callback(value)
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

local function createWorkingDropdown(parent, name, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = false
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
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, -30, 0, 32)
    dropdownBtn.Position = UDim2.new(0, 15, 0, 40)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Text = "🔍 Click to select brainrot..."
    dropdownBtn.TextColor3 = CONFIG.COLORS.Gray
    dropdownBtn.TextSize = 12
    dropdownBtn.TextTruncate = Enum.TextTruncate.AtEnd
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = dropdownBtn
    
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = "DropdownContainer"
    dropdownContainer.Size = UDim2.new(0, 300, 0, 0)
    dropdownContainer.Position = UDim2.new(0, frame.AbsolutePosition.X + 15, 0, 0)
    dropdownContainer.BackgroundColor3 = CONFIG.COLORS.DropdownBg
    dropdownContainer.BorderSizePixel = 0
    dropdownContainer.Visible = false
    dropdownContainer.ZIndex = 1000
    dropdownContainer.Parent = screenGui
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = dropdownContainer
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = CONFIG.COLORS.Accent
    containerStroke.Thickness = 2
    containerStroke.Parent = dropdownContainer
    
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 0, 35)
    searchBox.Position = UDim2.new(0, 10, 0, 10)
    searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    searchBox.BorderSizePixel = 0
    searchBox.Font = Enum.Font.Gotham
    searchBox.Text = "Search..."
    searchBox.TextColor3 = CONFIG.COLORS.White
    searchBox.TextSize = 12
    searchBox.ClearTextOnFocus = true
    searchBox.ZIndex = 1001
    searchBox.Parent = dropdownContainer
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -20, 1, -55)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 50)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = CONFIG.COLORS.Accent
    scrollingFrame.ZIndex = 1001
    scrollingFrame.Parent = dropdownContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = scrollingFrame
    
    local allBrainrots = getAllBrainrotsFromStorage()
    local currentSelection = nil
    local isOpen = false
    
    local function updatePosition()
        local absPos = frame.AbsolutePosition
        local absSize = frame.AbsoluteSize
        dropdownContainer.Position = UDim2.new(0, absPos.X + 15, 0, absPos.Y + 75)
    end
    
    local function populateOptions(filterText)
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local filtered = {}
        local searchLower = filterText:lower()
        
        for _, brainrot in ipairs(allBrainrots) do
            if brainrot.fullName:lower():find(searchLower) or searchLower == "" or searchLower == "search..." then
                table.insert(filtered, brainrot)
            end
        end
        
        for i, brainrotInfo in ipairs(filtered) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Name = "Option_" .. i
            optionBtn.Size = UDim2.new(1, 0, 0, 35)
            optionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            optionBtn.BorderSizePixel = 0
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.Text = "   " .. brainrotInfo.fullName
            optionBtn.TextColor3 = CONFIG.COLORS.White
            optionBtn.TextSize = 11
            optionBtn.TextXAlignment = Enum.TextXAlignment.Left
            optionBtn.ZIndex = 1002
            optionBtn.Parent = scrollingFrame
            
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 6)
            optionCorner.Parent = optionBtn
            
            local colorBar = Instance.new("Frame")
            colorBar.Size = UDim2.new(0, 4, 0, 25)
            colorBar.Position = UDim2.new(0, 8, 0.5, -12)
            colorBar.BorderSizePixel = 0
            colorBar.ZIndex = 1003
            colorBar.Parent = optionBtn
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = colorBar
            
            if brainrotInfo.rarity == "Common" then
                colorBar.BackgroundColor3 = Color3.fromRGB(169, 169, 169)
            elseif brainrotInfo.rarity == "Uncommon" then
                colorBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif brainrotInfo.rarity == "Rare" then
                colorBar.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            elseif brainrotInfo.rarity == "Epic" then
                colorBar.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
            elseif brainrotInfo.rarity == "Legendary" then
                colorBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            elseif brainrotInfo.rarity == "Mythical" then
                colorBar.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
            elseif brainrotInfo.rarity == "Secret" then
                colorBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            else
                colorBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            optionBtn.MouseEnter:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundColor3 = CONFIG.COLORS.DropdownHover}):Play()
            end)
            
            optionBtn.MouseLeave:Connect(function()
                if currentSelection ~= brainrotInfo then
                    TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
                end
            end)
            
            optionBtn.MouseButton1Click:Connect(function()
                currentSelection = brainrotInfo
                dropdownBtn.Text = brainrotInfo.fullName
                dropdownBtn.TextColor3 = CONFIG.COLORS.White
                
                isOpen = false
                TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 300, 0, 0)}):Play()
                task.delay(0.2, function()
                    dropdownContainer.Visible = false
                end)
                
                callback(brainrotInfo)
                print("Selected brainrot:", brainrotInfo.fullName)
            end)
        end
        
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #filtered * 39)
    end
    
    populateOptions("")
    
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            updatePosition()
            dropdownContainer.Visible = true
            TweenService:Create(dropdownContainer, TweenInfo.new(0.25), {Size = UDim2.new(0, 300, 0, 300)}):Play()
            searchBox.Text = ""
            searchBox:CaptureFocus()
        else
            TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 300, 0, 0)}):Play()
            task.delay(0.2, function()
                dropdownContainer.Visible = false
            end)
        end
    end)
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        populateOptions(searchBox.Text)
    end)
    
    local clickConnection
    clickConnection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
            local mousePos = UserInputService:GetMouseLocation()
            local containerPos = dropdownContainer.AbsolutePosition
            local containerSize = dropdownContainer.AbsoluteSize
            
            local btnPos = dropdownBtn.AbsolutePosition
            local btnSize = dropdownBtn.AbsoluteSize
            
            local outsideDropdown = (mousePos.X < containerPos.X or mousePos.X > containerPos.X + containerSize.X or
                                    mousePos.Y < containerPos.Y or mousePos.Y > containerPos.Y + containerSize.Y)
            local outsideButton = (mousePos.X < btnPos.X or mousePos.X > btnPos.X + btnSize.X or
                                   mousePos.Y < btnPos.Y or mousePos.Y > btnPos.Y + btnSize.Y)
            
            if outsideDropdown and outsideButton then
                isOpen = false
                TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 300, 0, 0)}):Play()
                task.delay(0.2, function()
                    dropdownContainer.Visible = false
                end)
            end
        end
    end)
    
    scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if isOpen then
            updatePosition()
        end
    end)
    
    frame.Destroying:Connect(function()
        if clickConnection then
            clickConnection:Disconnect()
        end
        dropdownContainer:Destroy()
    end)
    
    return frame
end

local function createStageDropdown(parent, name, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = false
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
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, -30, 0, 32)
    dropdownBtn.Position = UDim2.new(0, 15, 0, 40)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Text = "🏆 Select Stage..."
    dropdownBtn.TextColor3 = CONFIG.COLORS.Gray
    dropdownBtn.TextSize = 12
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = dropdownBtn
    
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = "StageDropdownContainer"
    dropdownContainer.Size = UDim2.new(0, 280, 0, 0)
    dropdownContainer.Position = UDim2.new(0, frame.AbsolutePosition.X + 15, 0, 0)
    dropdownContainer.BackgroundColor3 = CONFIG.COLORS.DropdownBg
    dropdownContainer.BorderSizePixel = 0
    dropdownContainer.Visible = false
    dropdownContainer.ZIndex = 1000
    dropdownContainer.Parent = screenGui
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 12)
    containerCorner.Parent = dropdownContainer
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = CONFIG.COLORS.Accent
    containerStroke.Thickness = 2
    containerStroke.Parent = dropdownContainer
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -20, 1, -20)
    scrollingFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = CONFIG.COLORS.Accent
    scrollingFrame.ZIndex = 1001
    scrollingFrame.Parent = dropdownContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = scrollingFrame
    
    local currentSelection = nil
    local isOpen = false
    
    local rarityColors = {
        Common = Color3.fromRGB(169, 169, 169),
        Uncommon = Color3.fromRGB(0, 255, 0),
        Rare = Color3.fromRGB(0, 100, 255),
        Epic = Color3.fromRGB(150, 0, 255),
        Legendary = Color3.fromRGB(255, 215, 0),
        Mythical = Color3.fromRGB(255, 0, 100),
        Cosmic = Color3.fromRGB(0, 255, 255),
        Secret = Color3.fromRGB(255, 0, 0),
        Celestial = Color3.fromRGB(255, 255, 0)
    }
    
    local function updatePosition()
        local absPos = frame.AbsolutePosition
        dropdownContainer.Position = UDim2.new(0, absPos.X + 15, 0, absPos.Y + 75)
    end
    
    local function populateOptions()
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        for i, rarity in ipairs(STAGE_RARITIES) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Name = "StageOption_" .. rarity
            optionBtn.Size = UDim2.new(1, 0, 0, 40)
            optionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            optionBtn.BorderSizePixel = 0
            optionBtn.Font = Enum.Font.GothamBold
            optionBtn.Text = "  " .. rarity
            optionBtn.TextColor3 = CONFIG.COLORS.White
            optionBtn.TextSize = 13
            optionBtn.TextXAlignment = Enum.TextXAlignment.Left
            optionBtn.ZIndex = 1002
            optionBtn.Parent = scrollingFrame
            
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 8)
            optionCorner.Parent = optionBtn
            
            local colorBar = Instance.new("Frame")
            colorBar.Size = UDim2.new(0, 6, 0, 30)
            colorBar.Position = UDim2.new(0, 8, 0.5, -15)
            colorBar.BackgroundColor3 = rarityColors[rarity] or Color3.fromRGB(255, 255, 255)
            colorBar.BorderSizePixel = 0
            colorBar.ZIndex = 1003
            colorBar.Parent = optionBtn
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(1, 0)
            barCorner.Parent = colorBar
            
            optionBtn.MouseEnter:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundColor3 = CONFIG.COLORS.DropdownHover}):Play()
            end)
            
            optionBtn.MouseLeave:Connect(function()
                if currentSelection ~= rarity then
                    TweenService:Create(optionBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
                end
            end)
            
            optionBtn.MouseButton1Click:Connect(function()
                currentSelection = rarity
                dropdownBtn.Text = "🏆 " .. rarity
                dropdownBtn.TextColor3 = rarityColors[rarity] or CONFIG.COLORS.White
                
                isOpen = false
                TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 280, 0, 0)}):Play()
                task.delay(0.2, function()
                    dropdownContainer.Visible = false
                end)
                
                callback(rarity)
                print("Selected stage:", rarity)
            end)
        end
        
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #STAGE_RARITIES * 44)
    end
    
    populateOptions()
    
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            updatePosition()
            dropdownContainer.Visible = true
            TweenService:Create(dropdownContainer, TweenInfo.new(0.25), {Size = UDim2.new(0, 280, 0, 350)}):Play()
        else
            TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 280, 0, 0)}):Play()
            task.delay(0.2, function()
                dropdownContainer.Visible = false
            end)
        end
    end)
    
    local clickConnection
    clickConnection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
            local mousePos = UserInputService:GetMouseLocation()
            local containerPos = dropdownContainer.AbsolutePosition
            local containerSize = dropdownContainer.AbsoluteSize
            
            local btnPos = dropdownBtn.AbsolutePosition
            local btnSize = dropdownBtn.AbsoluteSize
            
            local outsideDropdown = (mousePos.X < containerPos.X or mousePos.X > containerPos.X + containerSize.X or
                                    mousePos.Y < containerPos.Y or mousePos.Y > containerPos.Y + containerSize.Y)
            local outsideButton = (mousePos.X < btnPos.X or mousePos.X > btnPos.X + btnSize.X or
                                   mousePos.Y < btnPos.Y or mousePos.Y > btnPos.Y + btnSize.Y)
            
            if outsideDropdown and outsideButton then
                isOpen = false
                TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 280, 0, 0)}):Play()
                task.delay(0.2, function()
                    dropdownContainer.Visible = false
                end)
            end
        end
    end)
    
    frame.Destroying:Connect(function()
        if clickConnection then
            clickConnection:Disconnect()
        end
        dropdownContainer:Destroy()
    end)
    
    return frame
end

local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.BackgroundColor3 = CONFIG.COLORS.Accent
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
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Accent}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            warn("Button error:", err)
        end
    end)
    
    return btn
end

-- ==================== AUTOMATION TAB ====================
-- MODIFIED: Auto Collect Cash now tweens to base first
createToggle(automationTab, "Auto Collect Cash", "Tween to base, spawn collect parts, reset every 5s", function(enabled)
    autoCollectCash = enabled
    if enabled then task.spawn(autoCollectCashLoop) end
end)

createSlider(automationTab, "Auto Upgrade Speed", "Select speed upgrade amount", 1, 10, 1, function(value)
    selectedSpeedAmount = value
end)

createToggle(automationTab, "Auto Upgrade Speed", "Automatically upgrades speed", function(enabled)
    autoUpgradeSpeed = enabled
    if enabled then task.spawn(autoUpgradeSpeedLoop) end
end)

createToggle(automationTab, "Auto Upgrade Carry", "Automatically upgrades carry capacity", function(enabled)
    autoUpgradeCarry = enabled
    if enabled then task.spawn(autoUpgradeCarryLoop) end
end)

createToggle(automationTab, "Auto Rebirth", "Automatically rebirths when possible", function(enabled)
    autoRebirth = enabled
    if enabled then task.spawn(autoRebirthLoop) end
end)

-- REMOVED: Auto Upgrade Base toggle (deleted as requested)

-- REMOVED: Auto Upgrade Brainrot dropdown and toggle (deleted as requested)

-- REMOVED: Auto Upgrade Selected Brainrot dropdown and toggle (deleted as requested)

createWorkingDropdown(automationTab, "Select Brainrot to Collect", function(brainrotInfo)
    selectedBrainrotToCollect = brainrotInfo
end)

-- MODIFIED: Longer proximity prompt hold for brainrot collection
createToggle(automationTab, "Auto Collect Selected Brainrot", "Collects selected brainrot (1.5s hold)", function(enabled)
    autoCollectSpecificBrainrot = enabled
    if enabled then
        if not selectedBrainrotToCollect then
            warn("Please select a brainrot first!")
            return
        end
        task.spawn(autoCollectSpecificBrainrotLoop)
    end
end)

-- REMOVED: Auto Spawn Machine toggle (deleted as requested)

-- FIXED: Auto Clicker with draggable button that auto-clicks continuously
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
    -- Update button text if active
    if autoClickerButton and autoClickerEnabled then
        local button = autoClickerButton:FindFirstChild("AutoClickerButton")
        if button then
            button.Text = "🖱️\nAUTO\nCLICK\nON\n" .. value .. " CPS"
        end
    end
    print("Clicker CPS set to:", value)
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
    print("Head size set to:", value)
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

-- FIXED: Player ESP with Skeleton and Distance - Better toggle handling
createToggle(combatTab, "Player ESP + Skeleton", "Shows skeleton, distance, boxes, names, health", function(enabled)
    espEnabled = enabled
    if enabled then
        task.spawn(espLoop)
    else
        -- Ensure cleanup when disabled
        for p, _ in pairs(espObjects) do
            removeESP(p)
        end
        for p, _ in pairs(skeletonESPObjects) do
            removeSkeletonESP(p)
        end
    end
end)

createToggle(combatTab, "Auto Hit", "Auto attacks enemies in range", function(enabled)
    autoHitEnabled = enabled
    if enabled then task.spawn(autoHitLoop) end
end)

-- ==================== EVENT TAB ====================
createToggle(eventTab, "Auto Collect Gold Bars", "Teleports gold bar models to you", function(enabled)
    autoCollectGoldBars = enabled
    if enabled then task.spawn(autoCollectGoldBarsLoop) end
end)

createToggle(eventTab, "Auto Complete Obby", "Auto completes all 3 obbies", function(enabled)
    autoCompleteObby = enabled
    if enabled then task.spawn(autoCompleteObbyLoop) end
end)

createToggle(eventTab, "Auto Spin Wheel", "Automatically spins the wheel when near", function(enabled)
    autoSpinWheel = enabled
    if enabled then task.spawn(autoSpinWheelLoop) end
end)

-- ==================== STAGES TAB ====================
createStageDropdown(stagesTab, "Select Stage/Rarity", function(stage)
    selectedStage = stage
end)

createButton(stagesTab, "Tween to Selected Stage (Sequential)", function()
    if not selectedStage then
        warn("Please select a stage first!")
        return
    end
    tweenToStageWallSequential(selectedStage)
end)

createToggle(stagesTab, "Auto Tween to Stage", "Automatically tweens to selected stage wall (sequential)", function(enabled)
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

local stageInfoLabel = Instance.new("TextLabel")
stageInfoLabel.Size = UDim2.new(1, -20, 0, 80)
stageInfoLabel.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
stageInfoLabel.BackgroundTransparency = 0.3
stageInfoLabel.Font = Enum.Font.Gotham
stageInfoLabel.Text = "ℹ️ Select a stage to teleport through all VIP walls sequentially.\nExample: Selecting Celestial will tween through Common → Uncommon → Rare → Epic → Legendary → Mythical → Cosmic → Secret → Celestial"
stageInfoLabel.TextColor3 = CONFIG.COLORS.Gray
stageInfoLabel.TextSize = 11
stageInfoLabel.TextWrapped = true
stageInfoLabel.Parent = stagesTab

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 12)
infoCorner.Parent = stageInfoLabel

-- ==================== SELL TAB ====================
createToggle(sellTab, "Auto Sell Inventory", "Sells all your brainrots automatically", function(enabled)
    autoSellInventory = enabled
    if enabled then task.spawn(autoSellInventoryLoop) end
end)

createButton(sellTab, "Sell Holding Brainrots", function()
    if SellToolFunction then
        SellToolFunction:InvokeServer()
        print("Sold holding brainrots!")
    else
        warn("SellTool remote not found!")
    end
end)

-- ==================== SETTINGS TAB ====================
-- MODIFIED: Wave Protection with longer stay time
createToggle(settingsTab, "Wave Protection (VIP Walls)", "Stays in VIP walls longer during waves (3s min)", function(enabled)
    waveProtectionEnabled = enabled
    if enabled then
        task.spawn(waveProtectionLoop)
    end
end)

createSlider(settingsTab, "Wave Detection Range", "How far to detect waves (100-150 recommended)", 50, 200, 125, function(value)
    waveProtectionRange = value
    print("Wave detection range:", value)
end)

-- NEW: Copy Discord Link button
createButton(settingsTab, "📋 Copy Discord Link", function()
    local discordLink = "https://discord.gg/nexus" -- Change this to your actual Discord link
    if setclipboard then
        setclipboard(discordLink)
        print("Discord link copied to clipboard!")
    else
        warn("Clipboard function not available")
        -- Fallback: print to console
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

-- Character respawn handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end)

print("Nexus|Escape Tsunami for Brainrots - MODIFIED EDITION Loaded!")
print("Changes: Longer proximity hold, Wave protection improved, Removed several toggles, Fixed ESP, Added Discord button!")
