--[[
    Nexus|Escape Tsunami for Brainrots - Fixed GUI Edition
    Fixes: GUI not appearing, character loading issues, better initialization
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

-- [All your functions remain the same - GetPlayerBase, FindBrainrotInActive, etc.]

-- CRITICAL: Create GUI with error handling wrapped in pcall
local function createGUI()
    local success, err = pcall(function()
        print("Creating GUI...")
        
        -- Create ScreenGui FIRST
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "NexusBrainrotHub"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui
        
        print("ScreenGui created")

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
            -- Disable all features
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
                if espObjects[p] then
                    espObjects[p]:Destroy()
                    espObjects[p] = nil
                end
            end
            for p, _ in pairs(skeletonESPObjects) do
                if skeletonESPObjects[p] then
                    skeletonESPObjects[p]:Destroy()
                    skeletonESPObjects[p] = nil
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

        -- Helper function to create tabs
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
        local eventTab = createTab("Event", "🎉")
        local stagesTab = createTab("Stages", "🏆")
        local sellTab = createTab("Sell", "💰")
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
                for p, _ in pairs(skeletonESPObjects) do
                    if skeletonESPObjects[p] then
                        skeletonESPObjects[p]:Destroy()
                        skeletonESPObjects[p] = nil
                    end
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
        createToggle(settingsTab, "Wave Protection (VIP Walls)", "Stays in VIP walls until wave passes", function(enabled)
            waveProtectionEnabled = enabled
            if enabled then
                task.spawn(waveProtectionLoop)
            end
        end)

        createSlider(settingsTab, "Wave Detection Range", "How far to detect waves", 50, 200, 125, function(value)
            waveProtectionRange = value
        end)

        createButton(settingsTab, "📋 Copy Discord Link", function()
            local discordLink = "https://discord.gg/nexus"
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
        -- Create error GUI
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
end)

-- CRITICAL: Delay GUI creation to ensure everything is loaded
task.delay(2, function()
    print("Creating GUI after delay...")
    createGUI()
end)

print("Script loaded, waiting to create GUI...")
