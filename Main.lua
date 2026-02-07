--[[
    Nexus|Escape Tsunami for Brainrots - Complete Edition Fixed v2
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

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
local autoUpgradeBrainrot = false
local selectedBrainrotSlot = nil
local autoRebirth = false
local autoUpgradeBase = false

-- Combat Tab Variables
local hitboxExtenderEnabled = false
local autoHitEnabled = false
local hitboxVisualEnabled = false
local hitboxRange = 10
local hitboxVisualPart = nil
local espEnabled = false
local espObjects = {}

-- Event Tab Variables
local autoCollectGoldBars = false
local autoCompleteObby = false

-- Auto Collect Specific Brainrot Variables
local autoCollectSpecificBrainrot = false
local selectedBrainrotToCollect = nil
local isCollectingBrainrot = false
local positionBeforeCollecting = nil
local brainrotDropdownOpen = false

-- Settings Tab Variables - IMPROVED WAVE & GAP SYSTEM
local autoGapEnabled = false
local gapDetectionRange = 150
local isInGap = false
local currentGapTarget = nil
local positionBeforeGap = nil
local gapSafetyOffset = Vector3.new(0, -2, 0)
local waveCheckHeight = 100 -- Height to check for waves above map
local mapHeightThreshold = 10 -- Y position threshold for "under map" detection

-- NEW: Auto Upgrade Selected Brainrot Variables
local autoUpgradeSelectedBrainrot = false
local selectedBrainrotToUpgrade = nil
local brainrotUpgradeDropdownOpen = false

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

-- Get Player Base
local function getPlayerBase()
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then return nil end
    
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

-- Get All Brainrot Names from Base
local function getBrainrotNames()
    local brainrots = {}
    local base = getPlayerBase()
    if not base then return brainrots end
    
    local slots = base:FindFirstChild("Slots")
    if not slots then return brainrots end
    
    for i = 1, 40 do
        local slot = slots:FindFirstChild("Slot" .. i) or slots:FindFirstChild("slot" .. i)
        if slot then
            for _, child in ipairs(slot:GetChildren()) do
                if child:IsA("Model") and child.Name ~= "RootPart" and child.Name ~= "Collect" then
                    table.insert(brainrots, {name = child.Name, slot = i})
                    break
                end
            end
        end
    end
    return brainrots
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

-- Find specific brainrot in ActiveBrainrots - IMPROVED
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
                -- Check if this RenderedBrainrot contains our target brainrot
                for _, child in ipairs(renderedBrainrot:GetChildren()) do
                    if child:IsA("Model") and child.Name == brainrotName then
                        print("Found brainrot model inside RenderedBrainrot:", child.Name)
                        
                        -- Get the primary part or any BasePart for position
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
                        
                        if targetPart then
                            print("Found target part at position:", targetPart.Position)
                            return {
                                model = renderedBrainrot,
                                brainrotModel = child,
                                part = targetPart,
                                name = brainrotName,
                                rarity = folder.Name,
                                cframe = targetPart.CFrame
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

-- IMPROVED: Check if position is under the map or in wave path
local function isPositionUnderMapOrInWavePath(position)
    -- Check if under map (y position check)
    if position.Y < mapHeightThreshold then
        return true, "under_map"
    end
    
    -- Check if any wave is directly above this position
    local activeTsunamis = Workspace:FindFirstChild("ActiveTsunamis")
    if activeTsunamis then
        for _, wave in ipairs(activeTsunamis:GetChildren()) do
            local wavePart = nil
            if wave:IsA("BasePart") then
                wavePart = wave
            elseif wave:IsA("Model") then
                wavePart = wave.PrimaryPart or wave:FindFirstChildWhichIsA("BasePart")
            end
            
            if wavePart then
                local wavePos = wavePart.Position
                local horizontalDist = math.sqrt((position.X - wavePos.X)^2 + (position.Z - wavePos.Z)^2)
                
                -- If wave is above this position and close horizontally
                if wavePos.Y > position.Y and horizontalDist < 30 then
                    return true, "wave_above"
                end
            end
        end
    end
    
    return false, nil
end

-- IMPROVED: Safe tween with better wave avoidance
local function safeTweenToPosition(targetPosition, targetCFrame, useGapIfNeeded)
    useGapIfNeeded = useGapIfNeeded ~= false -- Default true
    
    -- First check if target position is safe
    local isUnsafe, reason = isPositionUnderMapOrInWavePath(targetPosition)
    if isUnsafe then
        warn("Target position is unsafe:", reason)
        -- Try to find safe position near target
        targetPosition = Vector3.new(targetPosition.X, math.max(targetPosition.Y, 20), targetPosition.Z)
        targetCFrame = CFrame.new(targetPosition)
    end
    
    local success = false
    
    -- Check if we need to use gap
    local activeTsunamis = Workspace:FindFirstChild("ActiveTsunamis")
    local shouldUseGap = false
    local nearestWave = nil
    local nearestWaveDist = math.huge
    
    if activeTsunamis and useGapIfNeeded then
        for _, wave in ipairs(activeTsunamis:GetChildren()) do
            local wavePart = nil
            if wave:IsA("BasePart") then
                wavePart = wave
            elseif wave:IsA("Model") then
                wavePart = wave.PrimaryPart or wave:FindFirstChildWhichIsA("BasePart")
            end
            
            if wavePart then
                local distToWave = (humanoidRootPart.Position - wavePart.Position).Magnitude
                local distToTarget = (targetPosition - wavePart.Position).Magnitude
                local velocity = wavePart.Velocity or Vector3.new(0, 0, 0)
                
                -- Check if wave is moving towards us or target
                local movingTowardsUs = (humanoidRootPart.Position - wavePart.Position):Dot(velocity) < 0
                local movingTowardsTarget = (targetPosition - wavePart.Position):Dot(velocity) < 0
                
                -- Use gap if wave is close to us OR close to target AND moving towards either
                if (distToWave < gapDetectionRange and movingTowardsUs) or 
                   (distToTarget < gapDetectionRange and movingTowardsTarget) or
                   (distToWave < gapDetectionRange * 0.5) then -- Always use gap if very close
                    shouldUseGap = true
                    if distToWave < nearestWaveDist then
                        nearestWaveDist = distToWave
                        nearestWave = wavePart
                    end
                end
            end
        end
    end
    
    if shouldUseGap then
        print("Wave detected! Using gap system...")
        local defaultMap = Workspace:FindFirstChild("DefaultMap_SharedInstances")
        if defaultMap then
            local gapsFolder = defaultMap:FindFirstChild("Gaps")
            if gapsFolder then
                -- Find best gap based on wave position and our position
                local bestGap = nil
                local bestScore = -math.huge
                
                for gapNum = 1, 9 do
                    local gap = gapsFolder:FindFirstChild("Gap" .. gapNum)
                    if gap then
                        local mud = gap:FindFirstChild("Mud")
                        if mud and mud:IsA("BasePart") then
                            local distToUs = (humanoidRootPart.Position - mud.Position).Magnitude
                            local distFromWave = nearestWave and (mud.Position - nearestWave.Position).Magnitude or 999
                            
                            -- Score: prefer closer gaps that are farther from wave
                            local score = (distFromWave * 2) - (distToUs * 0.5)
                            
                            -- Check if gap is safe (not under wave)
                            local gapUnsafe, _ = isPositionUnderMapOrInWavePath(mud.Position)
                            if not gapUnsafe then
                                if score > bestScore then
                                    bestScore = score
                                    bestGap = mud
                                end
                            end
                        end
                    end
                end
                
                if bestGap then
                    print("Moving to gap:", bestGap.Position)
                    
                    -- Tween to gap with multiple segments for safety
                    local gapPos = bestGap.Position
                    local currentPos = humanoidRootPart.Position
                    local midPoint = (currentPos + gapPos) / 2
                    midPoint = Vector3.new(midPoint.X, math.max(midPoint.Y, 20), midPoint.Z)
                    
                    -- First go up to safe height
                    local upTween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.3), {
                        CFrame = CFrame.new(Vector3.new(currentPos.X, math.max(currentPos.Y + 10, 25), currentPos.Z))
                    })
                    upTween:Play()
                    upTween.Completed:Wait()
                    
                    -- Then move to gap
                    local gapTween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.4), {
                        CFrame = bestGap.CFrame + gapSafetyOffset
                    })
                    gapTween:Play()
                    gapTween.Completed:Wait()
                    
                    -- Wait in gap until wave passes
                    local waitTime = 0
                    while waitTime < 3 do -- Max 3 seconds in gap
                        local waveStillThere = false
                        if activeTsunamis then
                            for _, wave in ipairs(activeTsunamis:GetChildren()) do
                                local wavePart = wave:IsA("BasePart") and wave or (wave.PrimaryPart or wave:FindFirstChildWhichIsA("BasePart"))
                                if wavePart then
                                    local dist = (humanoidRootPart.Position - wavePart.Position).Magnitude
                                    if dist < gapDetectionRange then
                                        waveStillThere = true
                                        break
                                    end
                                end
                            end
                        end
                        
                        if not waveStillThere then
                            print("Wave passed! Exiting gap...")
                            break
                        end
                        
                        task.wait(0.2)
                        waitTime = waitTime + 0.2
                        
                        -- Keep player in gap
                        humanoidRootPart.CFrame = bestGap.CFrame + gapSafetyOffset
                        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    task.wait(0.3)
                else
                    warn("No safe gap found!")
                end
            end
        end
    end
    
    -- Final tween to target with height check
    local finalPos = targetCFrame.Position
    finalPos = Vector3.new(finalPos.X, math.max(finalPos.Y, 15), finalPos.Z)
    local finalCFrame = CFrame.new(finalPos) * (targetCFrame - targetCFrame.Position)
    
    print("Tweening to final target:", finalPos)
    local finalTween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.8), {CFrame = finalCFrame})
    finalTween:Play()
    finalTween.Completed:Wait()
    success = true
    
    return success
end

-- Auto Collect Specific Brainrot Loop - IMPROVED
local function autoCollectSpecificBrainrotLoop()
    print("Auto Collect Specific Brainrot started for:", selectedBrainrotToCollect and selectedBrainrotToCollect.name or "None")
    
    while autoCollectSpecificBrainrot do
        local success, err = pcall(function()
            if not selectedBrainrotToCollect then
                warn("No brainrot selected!")
                task.wait(2)
                return
            end
            
            -- Look for the brainrot
            print("Searching for brainrot:", selectedBrainrotToCollect.name)
            local foundBrainrot = findBrainrotInActive(selectedBrainrotToCollect.name, selectedBrainrotToCollect.rarity)
            
            if foundBrainrot then
                print("FOUND brainrot:", foundBrainrot.name, "at position:", foundBrainrot.part.Position)
                isCollectingBrainrot = true
                
                -- Save current position
                positionBeforeCollecting = humanoidRootPart.CFrame
                print("Saved position before collecting:", positionBeforeCollecting.Position)
                
                -- Check if brainrot position is safe
                local brainrotPos = foundBrainrot.part.Position
                local isUnsafe, reason = isPositionUnderMapOrInWavePath(brainrotPos)
                
                if isUnsafe then
                    print("Brainrot is in unsafe position:", reason, "- waiting...")
                    task.wait(1)
                    isCollectingBrainrot = false
                    return
                end
                
                -- Tween to brainrot with wave avoidance
                local targetCFrame = foundBrainrot.cframe + Vector3.new(0, 5, 0)
                local tweenSuccess = safeTweenToPosition(foundBrainrot.part.Position, targetCFrame, true)
                
                if tweenSuccess then
                    print("Arrived at brainrot, collecting...")
                    
                    -- Collect the brainrot - try multiple methods
                    task.wait(0.5)
                    
                    -- Method 1: Fire remote
                    if UpdateCollectedBrainrots then
                        print("Firing UpdateCollectedBrainrots remote...")
                        UpdateCollectedBrainrots:FireServer(foundBrainrot.model)
                    end
                    
                    -- Method 2: Touch the part
                    print("Touching brainrot part...")
                    firetouchinterest(humanoidRootPart, foundBrainrot.part, 0)
                    task.wait(0.1)
                    firetouchinterest(humanoidRootPart, foundBrainrot.part, 1)
                    
                    -- Method 3: Touch the brainrot model itself
                    if foundBrainrot.brainrotModel then
                        local brainrotPart = foundBrainrot.brainrotModel:FindFirstChildWhichIsA("BasePart")
                        if brainrotPart then
                            firetouchinterest(humanoidRootPart, brainrotPart, 0)
                            task.wait(0.1)
                            firetouchinterest(humanoidRootPart, brainrotPart, 1)
                        end
                    end
                    
                    -- Wait for collection
                    task.wait(1.5)
                    
                    -- Return to base safely
                    print("Returning to base...")
                    local base = getPlayerBase()
                    if base then
                        local basePart = base:FindFirstChildWhichIsA("BasePart", true)
                        if basePart then
                            safeTweenToPosition(basePart.Position, basePart.CFrame + Vector3.new(0, 5, 0), true)
                        end
                    end
                    
                    print("Collection cycle complete!")
                else
                    warn("Failed to tween to brainrot")
                end
                
                isCollectingBrainrot = false
                positionBeforeCollecting = nil
                
                -- Wait before looking for next spawn
                task.wait(3)
            else
                -- Brainrot not found, wait and check again
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

-- IMPROVED SMART GAP SYSTEM
local function smartGapLoop()
    print("Improved Smart Auto Gap started")
    positionBeforeGap = nil
    
    while autoGapEnabled do
        local success, err = pcall(function()
            local activeTsunamis = Workspace:FindFirstChild("ActiveTsunamis")
            local defaultMap = Workspace:FindFirstChild("DefaultMap_SharedInstances")
            
            if not activeTsunamis or not defaultMap then return end
            
            local gapsFolder = defaultMap:FindFirstChild("Gaps")
            if not gapsFolder then return end
            
            local waves = {}
            for _, wave in ipairs(activeTsunamis:GetChildren()) do
                local wavePart = nil
                if wave:IsA("BasePart") then
                    wavePart = wave
                elseif wave:IsA("Model") then
                    wavePart = wave.PrimaryPart or wave:FindFirstChild("Wave") or wave:FindFirstChild("Tsunami") or wave:FindFirstChildWhichIsA("BasePart")
                end
                
                if wavePart and wavePart:IsA("BasePart") then
                    local distance = (humanoidRootPart.Position - wavePart.Position).Magnitude
                    local velocity = wavePart.Velocity or Vector3.new(0, 0, 0)
                    local speed = velocity.Magnitude
                    local isMovingTowards = (humanoidRootPart.Position - wavePart.Position):Dot(velocity) < 0
                    
                    -- Calculate threat based on distance, speed, and direction
                    local threatLevel = 0
                    if distance < gapDetectionRange then
                        threatLevel = threatLevel + (gapDetectionRange - distance)
                    end
                    threatLevel = threatLevel + (speed * 3)
                    if isMovingTowards then
                        threatLevel = threatLevel + 100
                    end
                    
                    -- Extra threat if wave is close to ground level (can hit us)
                    if wavePart.Position.Y < 50 then
                        threatLevel = threatLevel + 50
                    end
                    
                    table.insert(waves, {
                        part = wavePart,
                        distance = distance,
                        speed = speed,
                        isMovingTowards = isMovingTowards,
                        threatLevel = threatLevel,
                        velocity = velocity
                    })
                end
            end
            
            table.sort(waves, function(a, b) return a.threatLevel > b.threatLevel end)
            
            local nearestThreat = waves[1]
            local shouldBeInGap = false
            
            if nearestThreat then
                -- Enter gap if threat is high enough
                if nearestThreat.threatLevel > 50 then
                    shouldBeInGap = true
                end
                
                -- Emergency: wave very close
                if nearestThreat.distance < 30 then
                    shouldBeInGap = true
                end
            end
            
            -- Also check if we're currently under map (emergency)
            if humanoidRootPart.Position.Y < mapHeightThreshold then
                shouldBeInGap = true
                print("Emergency: Under map detected!")
            end
            
            if shouldBeInGap then
                if not isInGap and not positionBeforeGap then
                    positionBeforeGap = humanoidRootPart.CFrame
                    print("Saving position before gap:", positionBeforeGap.Position)
                end
                
                -- Find best gap
                local bestGap = nil
                local bestScore = -math.huge
                
                for gapNum = 1, 9 do
                    local gap = gapsFolder:FindFirstChild("Gap" .. gapNum)
                    if gap then
                        local mud = gap:FindFirstChild("Mud")
                        if mud and mud:IsA("BasePart") then
                            local distToGap = (humanoidRootPart.Position - mud.Position).Magnitude
                            local distFromWave = nearestThreat and (mud.Position - nearestThreat.part.Position).Magnitude or 999
                            
                            -- Check if gap is safe (not under map)
                            local gapUnsafe, _ = isPositionUnderMapOrInWavePath(mud.Position)
                            
                            if not gapUnsafe then
                                -- Score: prefer closer gaps that are far from wave
                                local score = (distFromWave * 1.5) - (distToGap * 0.3)
                                
                                if score > bestScore then
                                    bestScore = score
                                    bestGap = mud
                                end
                            end
                        end
                    end
                end
                
                if bestGap then
                    currentGapTarget = bestGap
                    isInGap = true
                    
                    local targetCFrame = bestGap.CFrame + gapSafetyOffset
                    local currentDist = (humanoidRootPart.Position - bestGap.Position).Magnitude
                    
                    -- Fast tween if far, slow if close
                    local tweenSpeed = math.clamp(currentDist / 50, 0.1, 0.5)
                    
                    if currentDist > 5 then
                        local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(tweenSpeed), {CFrame = targetCFrame})
                        tween:Play()
                    else
                        humanoidRootPart.CFrame = targetCFrame
                    end
                    
                    -- Keep velocity zero while in gap
                    humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    
                    -- Anchor if wave is extremely close
                    if nearestThreat and nearestThreat.distance < 15 then
                        humanoidRootPart.Anchored = true
                        task.wait(0.1)
                        humanoidRootPart.Anchored = false
                        humanoidRootPart.CFrame = targetCFrame
                    end
                else
                    -- No safe gap found, go up!
                    print("No safe gap! Going up...")
                    local upPos = humanoidRootPart.Position + Vector3.new(0, 20, 0)
                    humanoidRootPart.CFrame = CFrame.new(upPos)
                end
            else
                -- Safe to exit gap
                if isInGap and positionBeforeGap then
                    -- Check if path back is safe
                    local pathUnsafe, _ = isPositionUnderMapOrInWavePath(positionBeforeGap.Position)
                    
                    if not pathUnsafe then
                        local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = positionBeforeGap})
                        returnTween:Play()
                        returnTween.Completed:Wait()
                        
                        isInGap = false
                        currentGapTarget = nil
                        positionBeforeGap = nil
                        print("Returned to position after gap")
                    else
                        -- Position is still unsafe, wait longer
                        print("Position still unsafe, staying in gap...")
                    end
                else
                    isInGap = false
                    currentGapTarget = nil
                end
            end
        end)
        
        if not success then
            warn("Smart gap error:", err)
        end
        
        task.wait(isInGap and 0.05 or 0.15)
    end
    
    -- Cleanup when disabled
    if isInGap and positionBeforeGap then
        local pathUnsafe, _ = isPositionUnderMapOrInWavePath(positionBeforeGap.Position)
        if not pathUnsafe then
            local returnTween = TweenService:Create(humanoidRootPart, TweenInfo.new(1), {CFrame = positionBeforeGap})
            returnTween:Play()
        end
    end
    
    isInGap = false
    currentGapTarget = nil
    positionBeforeGap = nil
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

-- ESP SYSTEM
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
        
        RunService.RenderStepped:Connect(function()
            if not espEnabled or not tracer.Parent then return end
            if not targetPlayer.Character or not hrp.Parent then return end
            
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

local function espLoop()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            createESP(p)
        end
    end
    
    Players.PlayerAdded:Connect(function(p)
        if espEnabled then
            createESP(p)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(p)
        removeESP(p)
    end)
    
    while espEnabled do
        task.wait(1)
    end
    
    for p, _ in pairs(espObjects) do
        removeESP(p)
    end
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

-- Auto Upgrade Base using SurfaceGui button
local function autoUpgradeBaseLoop()
    while autoUpgradeBase do
        local success, err = pcall(function()
            local base = getPlayerBase()
            if not base then return end
            
            local upgradeBaseModel = base:FindFirstChild("UpgradeBase") or base:FindFirstChild("Upgrade") or base:FindFirstChild("BaseUpgrade")
            
            if upgradeBaseModel then
                local sign = upgradeBaseModel:FindFirstChild("Sign")
                if sign then
                    local surfaceGui = sign:FindFirstChild("SurfaceGui")
                    if surfaceGui then
                        local button = surfaceGui:FindFirstChild("Button")
                        if button and (button:IsA("ImageButton") or button:IsA("TextButton")) then
                            button.MouseButton1Click:Fire()
                        else
                            for _, child in ipairs(surfaceGui:GetDescendants()) do
                                if child:IsA("ImageButton") or child:IsA("TextButton") then
                                    child.MouseButton1Click:Fire()
                                    break
                                end
                            end
                        end
                    else
                        for _, child in ipairs(sign:GetDescendants()) do
                            if child:IsA("SurfaceGui") then
                                for _, btn in ipairs(child:GetDescendants()) do
                                    if btn:IsA("ImageButton") or btn:IsA("TextButton") then
                                        btn.MouseButton1Click:Fire()
                                        break
                                    end
                                end
                                break
                            end
                        end
                    end
                else
                    for _, child in ipairs(upgradeBaseModel:GetDescendants()) do
                        if child:IsA("ClickDetector") then
                            fireclickdetector(child)
                            break
                        elseif child:IsA("ProximityPrompt") then
                            fireproximityprompt(child)
                            break
                        end
                    end
                end
            end
        end)
        
        task.wait(2)
    end
end

local function autoCollectCashLoop()
    local resetTimer = 0
    
    while autoCollectCash do
        local success, err = pcall(function()
            local base = getPlayerBase()
            if base then
                local slots = base:FindFirstChild("Slots")
                if slots then
                    if humanoidRootPart and not autoCollectCashTweened then
                        autoCollectCashTweened = true
                        local upPosition = humanoidRootPart.Position + Vector3.new(0, 3, 0)
                        TweenService:Create(humanoidRootPart, TweenInfo.new(0.3), {CFrame = CFrame.new(upPosition)}):Play()
                    end
                    
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
                                task.wait(0.1)
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
                        -- TELEPORT GOLD BAR TO PLAYER instead of tweening to it
                        mainPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                        
                        -- Try to collect
                        firetouchinterest(humanoidRootPart, mainPart, 0)
                        task.wait(0.1)
                        firetouchinterest(humanoidRootPart, mainPart, 1)
                        
                        task.wait(0.2)
                    end
                end
            end
        end)
        
        task.wait(0.3)
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

local function autoUpgradeBrainrotLoop()
    while autoUpgradeBrainrot do
        if UpgradeBrainrotFunction and selectedBrainrotSlot then
            pcall(function()
                UpgradeBrainrotFunction:InvokeServer(selectedBrainrotSlot)
            end)
        end
        task.wait(0.5)
    end
end

-- NEW: Auto Upgrade Selected Brainrot Loop
local function autoUpgradeSelectedBrainrotLoop()
    print("Auto Upgrade Selected Brainrot started for:", selectedBrainrotToUpgrade and selectedBrainrotToUpgrade.name or "None")
    
    while autoUpgradeSelectedBrainrot do
        local success, err = pcall(function()
            if not selectedBrainrotToUpgrade then
                warn("No brainrot selected for upgrade!")
                task.wait(2)
                return
            end
            
            -- Find the brainrot in base slots
            local base = getPlayerBase()
            if not base then
                warn("No base found!")
                task.wait(2)
                return
            end
            
            local slots = base:FindFirstChild("Slots")
            if not slots then
                warn("No slots found in base!")
                task.wait(2)
                return
            end
            
            -- Find which slot has the selected brainrot
            local targetSlot = nil
            for i = 1, 40 do
                local slot = slots:FindFirstChild("Slot" .. i) or slots:FindFirstChild("slot" .. i)
                if slot then
                    for _, child in ipairs(slot:GetChildren()) do
                        if child:IsA("Model") and child.Name == selectedBrainrotToUpgrade.name then
                            targetSlot = i
                            break
                        end
                    end
                    if targetSlot then break end
                end
            end
            
            if targetSlot then
                print("Upgrading brainrot:", selectedBrainrotToUpgrade.name, "in slot:", targetSlot)
                if UpgradeBrainrotFunction then
                    UpgradeBrainrotFunction:InvokeServer(targetSlot)
                else
                    warn("UpgradeBrainrot remote not found!")
                end
            else
                print("Selected brainrot not found in any slot")
            end
        end)
        
        if not success then
            warn("Auto upgrade selected brainrot error:", err)
        end
        
        task.wait(1) -- Wait between upgrades
    end
    
    print("Auto Upgrade Selected Brainrot stopped")
end

local function autoCompleteObbyLoop()
    while autoCompleteObby do
        local success, err = pcall(function()
            local moneyMap = Workspace:FindFirstChild("MoneyMap_SharedInstances")
            if not moneyMap then return end
            
            for obbyNum = 1, 3 do
                if not autoCompleteObby then break end
                local startPart = moneyMap:FindFirstChild("MoneyObbyStart" .. obbyNum)
                local endPart = moneyMap:FindFirstChild("MoneyObby" .. obbyNum .. "End")
                local safetyPart = moneyMap:FindFirstChild("MoneyObbySaftey" .. obbyNum)
                
                if startPart and endPart then
                    if startPart:IsA("BasePart") then
                        humanoidRootPart.CFrame = startPart.CFrame
                        task.wait(0.2)
                    end
                    if endPart:IsA("BasePart") then
                        local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(0.8), {CFrame = endPart.CFrame})
                        tween:Play()
                        tween.Completed:Wait()
                        if safetyPart and safetyPart:IsA("BasePart") then
                            firetouchinterest(humanoidRootPart, safetyPart, 0)
                            task.wait(0.1)
                            firetouchinterest(humanoidRootPart, safetyPart, 1)
                        end
                        task.wait(0.3)
                    end
                end
            end
        end)
        task.wait(1)
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
    autoGapEnabled = false
    autoCollectSpecificBrainrot = false
    autoUpgradeSelectedBrainrot = false
    espEnabled = false
    for p, _ in pairs(espObjects) do
        removeESP(p)
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
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = CONFIG.COLORS.Accent
    contentFrame.Visible = false
    contentFrame.Parent = contentContainer
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = contentFrame
    
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

-- IMPROVED: Better Dropdown Menu for Brainrots
local function createImprovedBrainrotDropdown(parent, name, callback, storeVar)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 85)
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
    
    -- Search box
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -30, 0, 28)
    searchBox.Position = UDim2.new(0, 15, 0, 40)
    searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    searchBox.BorderSizePixel = 0
    searchBox.Font = Enum.Font.Gotham
    searchBox.Text = "🔍 Search brainrot..."
    searchBox.TextColor3 = CONFIG.COLORS.Gray
    searchBox.TextSize = 12
    searchBox.ClearTextOnFocus = true
    searchBox.Parent = frame
    
    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchBox
    
    -- Dropdown arrow button
    local dropdownArrow = Instance.new("TextButton")
    dropdownArrow.Size = UDim2.new(0, 28, 0, 28)
    dropdownArrow.Position = UDim2.new(1, -43, 0, 40)
    dropdownArrow.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dropdownArrow.BorderSizePixel = 0
    dropdownArrow.Font = Enum.Font.GothamBold
    dropdownArrow.Text = "▼"
    dropdownArrow.TextColor3 = CONFIG.COLORS.White
    dropdownArrow.TextSize = 12
    dropdownArrow.Parent = frame
    
    local arrowCorner = Instance.new("UICorner")
    arrowCorner.CornerRadius = UDim.new(0, 6)
    arrowCorner.Parent = dropdownArrow
    
    -- Dropdown menu frame
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "DropdownMenu"
    dropdownMenu.Size = UDim2.new(1, -30, 0, 0)
    dropdownMenu.Position = UDim2.new(0, 15, 0, 75)
    dropdownMenu.BackgroundColor3 = CONFIG.COLORS.DropdownBg
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.Visible = false
    dropdownMenu.ZIndex = 100
    dropdownMenu.Parent = frame
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 10)
    menuCorner.Parent = dropdownMenu
    
    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color = CONFIG.COLORS.Accent
    menuStroke.Thickness = 1.5
    menuStroke.Parent = dropdownMenu
    
    -- Shadow effect
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- Shadow image
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = 99
    shadow.Visible = false
    shadow.Parent = dropdownMenu
    
    -- Scrolling frame for options
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -16, 1, -16)
    scrollingFrame.Position = UDim2.new(0, 8, 0, 8)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.ScrollBarImageColor3 = CONFIG.COLORS.Accent
    scrollingFrame.ZIndex = 101
    scrollingFrame.Parent = dropdownMenu
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = scrollingFrame
    
    local allBrainrots = getAllBrainrotsFromStorage()
    local filteredBrainrots = allBrainrots
    local selectedBrainrot = nil
    local isOpen = false
    
    local function updateOptions(filterText)
        -- Clear existing
        for _, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Filter brainrots
        filteredBrainrots = {}
        local searchLower = filterText:lower()
        for _, brainrot in ipairs(allBrainrots) do
            if brainrot.fullName:lower():find(searchLower) or searchLower == "" or searchLower == "search brainrot..." then
                table.insert(filteredBrainrots, brainrot)
            end
        end
        
        -- Create option buttons
        for _, brainrotInfo in ipairs(filteredBrainrots) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Size = UDim2.new(1, 0, 0, 32)
            optionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            optionBtn.BorderSizePixel = 0
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.Text = "  " .. brainrotInfo.fullName
            optionBtn.TextColor3 = CONFIG.COLORS.White
            optionBtn.TextSize = 11
            optionBtn.TextXAlignment = Enum.TextXAlignment.Left
            optionBtn.ZIndex = 102
            optionBtn.Parent = scrollingFrame
            
            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, 6)
            optionCorner.Parent = optionBtn
            
            -- Rarity color indicator
            local rarityIndicator = Instance.new("Frame")
            rarityIndicator.Size = UDim2.new(0, 4, 0, 20)
            rarityIndicator.Position = UDim2.new(0, 6, 0.5, -10)
            rarityIndicator.BackgroundColor3 = CONFIG.COLORS.Accent
            rarityIndicator.BorderSizePixel = 0
            rarityIndicator.ZIndex = 103
            rarityIndicator.Parent = optionBtn
            
            local indicatorCorner = Instance.new("UICorner")
            indicatorCorner.CornerRadius = UDim.new(1, 0)
            indicatorCorner.Parent = rarityIndicator
            
            -- Set color based on rarity
            if brainrotInfo.rarity == "Common" then
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(169, 169, 169)
            elseif brainrotInfo.rarity == "Uncommon" then
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif brainrotInfo.rarity == "Rare" then
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            elseif brainrotInfo.rarity == "Epic" then
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
            elseif brainrotInfo.rarity == "Legendary" then
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            elseif brainrotInfo.rarity == "Mythical" then
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
            elseif brainrotInfo.rarity == "Secret" then
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            else
                rarityIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            optionBtn.MouseEnter:Connect(function()
                TweenService:Create(optionBtn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COLORS.DropdownHover}):Play()
            end)
            
            optionBtn.MouseLeave:Connect(function()
                if selectedBrainrot ~= brainrotInfo then
                    TweenService:Create(optionBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
                end
            end)
            
            optionBtn.MouseButton1Click:Connect(function()
                selectedBrainrot = brainrotInfo
                searchBox.Text = brainrotInfo.fullName
                searchBox.TextColor3 = CONFIG.COLORS.White
                
                -- Update visual selection
                for _, child in ipairs(scrollingFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        TweenService:Create(child, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
                    end
                end
                TweenService:Create(optionBtn, TweenInfo.new(0.15), {BackgroundColor3 = CONFIG.COLORS.DropdownSelected}):Play()
                
                -- Close dropdown with animation
                isOpen = false
                TweenService:Create(dropdownMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 0)}):Play()
                TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                shadow.Visible = false
                task.delay(0.2, function()
                    if not isOpen then
                        dropdownMenu.Visible = false
                    end
                end)
                
                -- Callback
                callback(brainrotInfo)
                print("Selected:", brainrotInfo.fullName)
            end)
        end
        
        -- Update canvas size
        local totalHeight = #filteredBrainrots * 36
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, 100))
    end
    
    -- Initial population
    updateOptions("")
    
    -- Toggle dropdown
    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            dropdownMenu.Visible = true
            shadow.Visible = true
            TweenService:Create(dropdownMenu, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -30, 0, math.min(250, math.max(100, #filteredBrainrots * 36 + 16)))
            }):Play()
            TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
            searchBox:CaptureFocus()
        else
            TweenService:Create(dropdownMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 0)}):Play()
            TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            shadow.Visible = false
            task.delay(0.2, function()
                if not isOpen then
                    dropdownMenu.Visible = false
                end
            end)
        end
    end
    
    dropdownArrow.MouseButton1Click:Connect(toggleDropdown)
    searchBox.Focused:Connect(function()
        if not isOpen then
            toggleDropdown()
        end
    end)
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateOptions(searchBox.Text)
        if not isOpen then
            toggleDropdown()
        end
    end)
    
    -- Close when clicking outside
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = frame.AbsolutePosition
            local frameSize = frame.AbsoluteSize
            
            -- Check if click is outside frame
            if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or
               mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y + (isOpen and 250 or 0) then
                if isOpen then
                    isOpen = false
                    TweenService:Create(dropdownMenu, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 0)}):Play()
                    TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    shadow.Visible = false
                    task.delay(0.2, function()
                        if not isOpen then
                            dropdownMenu.Visible = false
                        end
                    end)
                end
            end
        end
    end)
    
    -- Cleanup on destroy
    frame.Destroying:Connect(function()
        if connection then
            connection:Disconnect()
        end
    end)
    
    return frame
end

local function createDropdown(parent, name, getOptionsFunc, callback)
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
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, -30, 0, 30)
    dropdownBtn.Position = UDim2.new(0, 15, 0, 40)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Text = "Select..."
    dropdownBtn.TextColor3 = CONFIG.COLORS.Gray
    dropdownBtn.TextSize = 12
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = dropdownBtn
    
    local selectedIndex = 1
    local currentOptions = {}
    local currentData = {}
    
    local function refreshOptions()
        local optionsData = getOptionsFunc()
        currentOptions = {}
        currentData = optionsData
        
        if #optionsData > 0 then
            for _, data in ipairs(optionsData) do
                table.insert(currentOptions, data.name .. " (Slot " .. data.slot .. ")")
            end
            selectedIndex = 1
            dropdownBtn.Text = currentOptions[1]
        else
            currentOptions = {"No brainrots found - Click to refresh"}
            selectedIndex = 1
            dropdownBtn.Text = currentOptions[1]
        end
    end
    
    refreshOptions()
    
    dropdownBtn.MouseButton1Click:Connect(function()
        if #currentOptions == 1 and string.find(currentOptions[1]:lower(), "no brainrots") then
            refreshOptions()
            return
        end
        
        selectedIndex = selectedIndex % #currentOptions + 1
        dropdownBtn.Text = currentOptions[selectedIndex]
        
        if currentData[selectedIndex] then
            callback(currentData[selectedIndex], selectedIndex)
        end
    end)
    
    return frame, refreshOptions
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
createToggle(automationTab, "Auto Collect Cash", "Resets char every 5 sec + collects cash", function(enabled)
    autoCollectCash = enabled
    if enabled then task.spawn(autoCollectCashLoop) end
end)

createDropdown(automationTab, "Auto Upgrade Speed", function() 
    return {{name = "+1 Speed", slot = 1}, {name = "+5 Speed", slot = 5}, {name = "+10 Speed", slot = 10}}
end, function(selection, index)
    selectedSpeedAmount = selection.slot
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

createToggle(automationTab, "Auto Upgrade Base", "Clicks the base upgrade button", function(enabled)
    autoUpgradeBase = enabled
    if enabled then task.spawn(autoUpgradeBaseLoop) end
end)

local brainrotDropdown, refreshBrainrotDropdown = createDropdown(automationTab, "Select Brainrot to Upgrade", getBrainrotNames, function(data, index)
    selectedBrainrotSlot = data.slot
    print("Selected brainrot slot:", selectedBrainrotSlot)
end)

createToggle(automationTab, "Auto Upgrade Brainrot", "Automatically upgrades selected brainrot", function(enabled)
    autoUpgradeBrainrot = enabled
    if enabled then
        if refreshBrainrotDropdown then refreshBrainrotDropdown() end
        task.spawn(autoUpgradeBrainrotLoop)
    end
end)

-- NEW: Improved Brainrot Collection Dropdown
createImprovedBrainrotDropdown(automationTab, "Select Brainrot to Collect", function(brainrotInfo)
    selectedBrainrotToCollect = brainrotInfo
end)

createToggle(automationTab, "Auto Collect Selected Brainrot", "Tween to brainrot, avoid waves, return to base", function(enabled)
    autoCollectSpecificBrainrot = enabled
    if enabled then
        if not selectedBrainrotToCollect then
            warn("Please select a brainrot first!")
            return
        end
        task.spawn(autoCollectSpecificBrainrotLoop)
    end
end)

-- NEW: Auto Upgrade Selected Brainrot Dropdown
createImprovedBrainrotDropdown(automationTab, "Select Brainrot to Auto-Upgrade", function(brainrotInfo)
    selectedBrainrotToUpgrade = brainrotInfo
end)

createToggle(automationTab, "Auto Upgrade Selected Brainrot", "Automatically upgrades specific brainrot when in base", function(enabled)
    autoUpgradeSelectedBrainrot = enabled
    if enabled then
        if not selectedBrainrotToUpgrade then
            warn("Please select a brainrot to upgrade first!")
            return
        end
        task.spawn(autoUpgradeSelectedBrainrotLoop)
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

createToggle(combatTab, "Player ESP", "Shows boxes, names, health, tracers", function(enabled)
    espEnabled = enabled
    if enabled then
        task.spawn(espLoop)
    else
        for p, _ in pairs(espObjects) do
            removeESP(p)
        end
    end
end)

createToggle(combatTab, "Auto Hit", "Auto attacks enemies in range", function(enabled)
    autoHitEnabled = enabled
    if enabled then task.spawn(autoHitLoop) end
end)

-- ==================== EVENT TAB (REMOVED AUTO COLLECT BRAINROT) ====================
-- REMOVED: Auto Collect Selected Brainrot from Event tab (now only in Automation)

createToggle(eventTab, "Auto Collect Gold Bars", "Teleports gold bars to you", function(enabled)
    autoCollectGoldBars = enabled
    if enabled then task.spawn(autoCollectGoldBarsLoop) end
end)

createToggle(eventTab, "Auto Complete Obby", "Auto completes all 3 obbies", function(enabled)
    autoCompleteObby = enabled
    if enabled then task.spawn(autoCompleteObbyLoop) end
end)

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
createToggle(settingsTab, "Smart Auto Gap", "Returns to position after wave", function(enabled)
    autoGapEnabled = enabled
    if enabled then
        task.spawn(smartGapLoop)
    end
end)

createSlider(settingsTab, "Wave Detection Range", "How far to detect waves", 50, 300, 150, function(value)
    gapDetectionRange = value
    print("Detection range:", value)
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

print("Nexus|Escape Tsunami for Brainrots - COMPLETE EDITION v2 Loaded!")
print("Features: Improved wave detection, better gap system, smoother dropdowns!")
