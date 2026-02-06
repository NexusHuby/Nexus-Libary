--[[
    Nexus|Escape Tsunami for Brainrots - Fixed Version
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for character properly
local character = player.Character
if not character then
    character = player.CharacterAdded:Wait()
end

local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

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
        Hover = Color3.fromRGB(55, 55, 65)
    }
}

-- State Variables
local autoCollectCash = false
local autoUpgradeSpeed = false
local selectedSpeedAmount = 1
local autoUpgradeCarry = false
local autoSellInventory = false
local autoUpgradeBrainrot = false
local selectedBrainrotSlot = nil

-- Get Player Base
local function getPlayerBase()
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then
        warn("Bases folder not found in Workspace")
        return nil
    end
    
    local closestBase = nil
    local closestDistance = math.huge
    
    for _, base in ipairs(bases:GetChildren()) do
        if base:IsA("Model") or base:IsA("Folder") then
            local slots = base:FindFirstChild("Slots")
            if slots then
                -- Try to find a part to measure distance
                local targetPart = nil
                
                -- Look for PrimaryPart first
                if base:IsA("Model") and base.PrimaryPart then
                    targetPart = base.PrimaryPart
                else
                    -- Find any BasePart
                    targetPart = base:FindFirstChildWhichIsA("BasePart", true)
                end
                
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
    
    if not base then 
        warn("No base found")
        return brainrots 
    end
    
    local slots = base:FindFirstChild("Slots")
    if not slots then 
        warn("No Slots folder found in base")
        return brainrots 
    end
    
    for i = 1, 40 do
        local slot = slots:FindFirstChild("Slot" .. i) or slots:FindFirstChild("slot" .. i)
        if slot then
            -- Look for brainrot model inside slot
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

-- Auto Collect Cash Function - FIXED
local function autoCollectCashLoop()
    while autoCollectCash do
        local success, err = pcall(function()
            local base = getPlayerBase()
            if base then
                local slots = base:FindFirstChild("Slots")
                if slots then
                    for i = 1, 40 do
                        if not autoCollectCash then break end
                        
                        local slot = slots:FindFirstChild("Slot" .. i) or slots:FindFirstChild("slot" .. i)
                        if slot then
                            local collectPart = slot:FindFirstChild("Collect")
                            if collectPart and collectPart:IsA("BasePart") then
                                -- Teleport collect part under player
                                collectPart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -5, 0)
                                
                                -- Fire remote event safely
                                if CollectMoneyEvent then
                                    CollectMoneyEvent:FireServer()
                                end
                                
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
        end)
        
        if not success then
            warn("Auto collect error:", err)
        end
        
        task.wait(0.1)
    end
end

-- Auto Upgrade Speed Loop - FIXED
local function autoUpgradeSpeedLoop()
    while autoUpgradeSpeed do
        if UpgradeSpeedFunction then
            local success, err = pcall(function()
                return UpgradeSpeedFunction:InvokeServer(selectedSpeedAmount)
            end)
            
            if not success then
                warn("Upgrade speed error:", err)
            end
        end
        task.wait(1)
    end
end

-- Auto Upgrade Carry Loop - FIXED
local function autoUpgradeCarryLoop()
    while autoUpgradeCarry do
        if UpgradeCarryFunction then
            local success, err = pcall(function()
                return UpgradeCarryFunction:InvokeServer()
            end)
            
            if not success then
                warn("Upgrade carry error:", err)
            end
        end
        task.wait(1)
    end
end

-- Auto Sell Inventory Loop - FIXED
local function autoSellInventoryLoop()
    while autoSellInventory do
        if SellAllFunction then
            local success, err = pcall(function()
                return SellAllFunction:InvokeServer()
            end)
            
            if not success then
                warn("Sell all error:", err)
            end
        end
        task.wait(2)
    end
end

-- Auto Upgrade Brainrot Loop - FIXED
local function autoUpgradeBrainrotLoop()
    while autoUpgradeBrainrot do
        if UpgradeBrainrotFunction and selectedBrainrotSlot then
            local success, err = pcall(function()
                return UpgradeBrainrotFunction:InvokeServer(selectedBrainrotSlot)
            end)
            
            if not success then
                warn("Upgrade brainrot error:", err)
            end
        end
        task.wait(1)
    end
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NexusBrainrotHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
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

-- Title Bar
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

-- Close Button
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
    screenGui:Destroy()
end)

-- Sidebar
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

-- Tab Container
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

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -220, 1, -70)
contentContainer.Position = UDim2.new(0, 210, 0, 60)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local currentTab = nil

-- Create Tab Function
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

-- Create Tabs
local automationTab = createTab("Automation", "⚡")
local sellTab = createTab("Sell", "💰")

-- Helper: Create Toggle
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
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.Success
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 26, 0.5, -11)
            }):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -11)
            }):Play()
        end
    end)
    
    return frame
end

-- Helper: Create Dropdown
local function createDropdown(parent, name, options, callback)
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
    dropdownBtn.Text = options[1] or "Select..."
    dropdownBtn.TextColor3 = CONFIG.COLORS.Gray
    dropdownBtn.TextSize = 12
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = dropdownBtn
    
    local selectedIndex = 1
    
    dropdownBtn.MouseButton1Click:Connect(function()
        selectedIndex = selectedIndex % #options + 1
        dropdownBtn.Text = options[selectedIndex]
        callback(options[selectedIndex], selectedIndex)
    end)
    
    return frame
end

-- Helper: Create Button
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
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(110, 123, 255)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = CONFIG.COLORS.Accent
        }):Play()
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

-- Auto Collect Cash Toggle
createToggle(automationTab, "Auto Collect Cash", "Auto collects cash for you", function(enabled)
    autoCollectCash = enabled
    if enabled then
        task.spawn(autoCollectCashLoop)
    end
end)

-- Speed Upgrade Dropdown
createDropdown(automationTab, "Auto Upgrade Speed", {"+1 Speed", "+5 Speed", "+10 Speed"}, function(selection, index)
    if index == 1 then selectedSpeedAmount = 1
    elseif index == 2 then selectedSpeedAmount = 5
    elseif index == 3 then selectedSpeedAmount = 10 end
end)

-- Auto Upgrade Speed Toggle
createToggle(automationTab, "Auto Upgrade Speed", "Automatically upgrades speed", function(enabled)
    autoUpgradeSpeed = enabled
    if enabled then
        task.spawn(autoUpgradeSpeedLoop)
    end
end)

-- Auto Upgrade Carry Toggle
createToggle(automationTab, "Auto Upgrade Carry", "Automatically upgrades carry capacity", function(enabled)
    autoUpgradeCarry = enabled
    if enabled then
        task.spawn(autoUpgradeCarryLoop)
    end
end)

-- Brainrot Dropdown (Dynamic)
local brainrotOptions = {}
local brainrotData = getBrainrotNames()

if #brainrotData > 0 then
    for _, data in ipairs(brainrotData) do
        table.insert(brainrotOptions, data.name .. " (Slot " .. data.slot .. ")")
    end
else
    brainrotOptions = {"No brainrots found - Click to refresh"}
end

createDropdown(automationTab, "Select Brainrot to Upgrade", brainrotOptions, function(selection, index)
    if brainrotData[index] then
        selectedBrainrotSlot = brainrotData[index].slot
        print("Selected brainrot slot:", selectedBrainrotSlot)
    end
end)

-- Auto Upgrade Brainrot Toggle
createToggle(automationTab, "Auto Upgrade Brainrot", "Automatically upgrades selected brainrot", function(enabled)
    autoUpgradeBrainrot = enabled
    if enabled then
        task.spawn(autoUpgradeBrainrotLoop)
    end
end)

-- ==================== SELL TAB ====================

-- Auto Sell Inventory Toggle
createToggle(sellTab, "Auto Sell Inventory", "Sells all your brainrots automatically", function(enabled)
    autoSellInventory = enabled
    if enabled then
        task.spawn(autoSellInventoryLoop)
    end
end)

-- Sell Holding Brainrots Button
createButton(sellTab, "Sell Holding Brainrots", function()
    if SellToolFunction then
        SellToolFunction:InvokeServer()
        print("Sold holding brainrots!")
    else
        warn("SellTool remote not found!")
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
end)

print("Nexus|Escape Tsunami for Brainrots Loaded!")
