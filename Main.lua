--[[
    Main Script - Loaded after key verification
    This is your main GUI/script that loads after the key system
    Place this on your second GitHub repository
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main Script Configuration
local CONFIG = {
    TITLE = "PREMIUM HUB",
    SUBTITLE = "Welcome back, " .. player.Name,
    COLORS = {
        Background = Color3.fromRGB(25, 25, 30),
        Sidebar = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(87, 242, 135),
        Warning = Color3.fromRGB(255, 200, 100),
        White = Color3.fromRGB(255, 255, 255),
        Gray = Color3.fromRGB(180, 180, 180)
    }
}

-- Create Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumMainHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = CONFIG.COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Animated Gradient Background
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
})
bgGradient.Rotation = 45
bgGradient.Parent = mainFrame

-- Gradient Animation
spawn(function()
    while mainFrame and mainFrame.Parent do
        for i = 0, 360, 1 do
            if not bgGradient then break end
            bgGradient.Rotation = i
            task.wait(0.05)
        end
    end
end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = CONFIG.COLORS.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 12)
sidebarCorner.Parent = sidebar

-- Fix sidebar corners (only left side)
local sidebarFix = Instance.new("Frame")
sidebarFix.Name = "Fix"
sidebarFix.Size = UDim2.new(0, 20, 1, 0)
sidebarFix.Position = UDim2.new(1, -20, 0, 0)
sidebarFix.BackgroundColor3 = CONFIG.COLORS.Sidebar
sidebarFix.BorderSizePixel = 0
sidebarFix.Parent = sidebar

-- Logo/Title
local logoLabel = Instance.new("TextLabel")
logoLabel.Name = "Logo"
logoLabel.Size = UDim2.new(1, 0, 0, 60)
logoLabel.Position = UDim2.new(0, 0, 0, 20)
logoLabel.BackgroundTransparency = 1
logoLabel.Font = Enum.Font.GothamBold
logoLabel.Text = CONFIG.TITLE
logoLabel.TextColor3 = CONFIG.COLORS.Accent
logoLabel.TextSize = 24
logoLabel.Parent = sidebar

-- User Info
local userLabel = Instance.new("TextLabel")
userLabel.Name = "User"
userLabel.Size = UDim2.new(1, -20, 0, 40)
userLabel.Position = UDim2.new(0, 10, 0, 80)
userLabel.BackgroundTransparency = 1
userLabel.Font = Enum.Font.Gotham
userLabel.Text = player.Name
userLabel.TextColor3 = CONFIG.COLORS.White
userLabel.TextSize = 14
userLabel.TextTruncate = Enum.TextTruncate.AtEnd
userLabel.Parent = sidebar

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 115)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "✓ PREMIUM"
statusLabel.TextColor3 = CONFIG.COLORS.Success
statusLabel.TextSize = 12
statusLabel.Parent = sidebar

-- Tab Buttons Container
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 200)
tabContainer.Position = UDim2.new(0, 10, 0, 150)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = sidebar

local tabList = Instance.new("UIListLayout")
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 8)
tabList.Parent = tabContainer

-- Create Tab Function
local currentTab = nil
local function createTab(name, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 35)
    tabButton.BackgroundColor3 = CONFIG.COLORS.Background
    tabButton.BorderSizePixel = 0
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Text = "   " .. icon .. "  " .. name
    tabButton.TextColor3 = CONFIG.COLORS.Gray
    tabButton.TextSize = 13
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Parent = tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabButton
    
    -- Tab Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = name .. "Content"
    contentFrame.Size = UDim2.new(1, -170, 1, -40)
    contentFrame.Position = UDim2.new(0, 160, 0, 20)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = mainFrame
    
    -- Hover effect
    tabButton.MouseEnter:Connect(function()
        if currentTab ~= tabButton then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if currentTab ~= tabButton then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Background}):Play()
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        if currentTab == tabButton then return end
        
        -- Reset previous tab
        if currentTab then
            TweenService:Create(currentTab, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Background, TextColor3 = CONFIG.COLORS.Gray}):Play()
            local prevContent = mainFrame:FindFirstChild(currentTab.Name:gsub("Tab", "Content"))
            if prevContent then
                prevContent.Visible = false
            end
        end
        
        -- Activate new tab
        currentTab = tabButton
        TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Accent, TextColor3 = CONFIG.COLORS.White}):Play()
        contentFrame.Visible = true
    end)
    
    return contentFrame
end

-- Create Tabs
local homeTab = createTab("Home", "🏠")
local featuresTab = createTab("Features", "⚡")
local settingsTab = createTab("Settings", "⚙️")

-- Home Tab Content
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, -40, 0, 40)
welcomeLabel.Position = UDim2.new(0, 20, 0, 20)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.Text = "Welcome to " .. CONFIG.TITLE
welcomeLabel.TextColor3 = CONFIG.COLORS.White
welcomeLabel.TextSize = 24
welcomeLabel.Parent = homeTab

local descLabel = Instance.new("TextLabel")
descLabel.Size = UDim2.new(1, -40, 0, 60)
descLabel.Position = UDim2.new(0, 20, 0, 70)
descLabel.BackgroundTransparency = 1
descLabel.Font = Enum.Font.Gotham
descLabel.Text = "Your key has been verified and saved. You won't need to enter it again on this device."
descLabel.TextColor3 = CONFIG.COLORS.Gray
descLabel.TextSize = 14
descLabel.TextWrapped = true
descLabel.Parent = homeTab

-- Stats Frame
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, -40, 0, 100)
statsFrame.Position = UDim2.new(0, 20, 0, 150)
statsFrame.BackgroundColor3 = CONFIG.COLORS.Sidebar
statsFrame.BorderSizePixel = 0
statsFrame.Parent = homeTab

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 10)
statsCorner.Parent = statsFrame

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, 0, 0, 30)
statsLabel.Position = UDim2.new(0, 0, 0, 10)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamBold
statsLabel.Text = "Account Status"
statsLabel.TextColor3 = CONFIG.COLORS.White
statsLabel.TextSize = 16
statsLabel.Parent = statsFrame

-- Feature Tab Content (Example Feature Buttons)
local feature1 = Instance.new("TextButton")
feature1.Size = UDim2.new(0, 200, 0, 40)
feature1.Position = UDim2.new(0, 20, 0, 20)
feature1.BackgroundColor3 = CONFIG.COLORS.Accent
feature1.BorderSizePixel = 0
feature1.Font = Enum.Font.GothamBold
feature1.Text = "Auto Farm"
feature1.TextColor3 = CONFIG.COLORS.White
feature1.TextSize = 14
feature1.Parent = featuresTab

local f1Corner = Instance.new("UICorner")
f1Corner.CornerRadius = UDim.new(0, 8)
f1Corner.Parent = feature1

-- Settings Tab (Reset Key)
local resetLabel = Instance.new("TextLabel")
resetLabel.Size = UDim2.new(1, -40, 0, 40)
resetLabel.Position = UDim2.new(0, 20, 0, 20)
resetLabel.BackgroundTransparency = 1
resetLabel.Font = Enum.Font.Gotham
resetLabel.Text = "Reset your saved key if you want to switch accounts"
resetLabel.TextColor3 = CONFIG.COLORS.Gray
resetLabel.TextSize = 14
resetLabel.TextWrapped = true
resetLabel.Parent = settingsTab

local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0, 150, 0, 35)
resetButton.Position = UDim2.new(0, 20, 0, 80)
resetButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
resetButton.BorderSizePixel = 0
resetButton.Font = Enum.Font.GothamBold
resetButton.Text = "Reset Key"
resetButton.TextColor3 = CONFIG.COLORS.White
resetButton.TextSize = 14
resetButton.Parent = settingsTab

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetButton

resetButton.MouseButton1Click:Connect(function()
    -- Clear key file
    pcall(function()
        if isfile("SystemCache_9821.dat") then delfile("SystemCache_9821.dat") end
        if isfile("SystemID_7392.dat") then delfile("SystemID_7392.dat") end
    end)
    
    resetButton.Text = "Reset! Restart required"
    task.wait(2)
    resetButton.Text = "Reset Key"
end)

-- Select Home tab by default
task.delay(0.1, function()
    homeTab.Visible = true
    currentTab = sidebar:FindFirstChild("HomeTab")
    if currentTab then
        TweenService:Create(currentTab, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Accent, TextColor3 = CONFIG.COLORS.White}):Play()
    end
end)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "Close"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.TextColor3 = CONFIG.COLORS.Gray
closeBtn.TextSize = 18
closeBtn.Parent = mainFrame

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    task.delay(0.4, function()
        screenGui:Destroy()
    end)
end)

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Name = "Minimize"
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -65, 0, 5)
minBtn.BackgroundTransparency = 1
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.TextColor3 = CONFIG.COLORS.Gray
minBtn.TextSize = 20
minBtn.Parent = mainFrame

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 40)}):Play()
        sidebar.Visible = false
        for _, child in ipairs(mainFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "Sidebar" and child ~= sidebarFix then
                child.Visible = false
            end
        end
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        task.delay(0.3, function()
            sidebar.Visible = true
            for _, child in ipairs(mainFrame:GetChildren()) do
                if child:IsA("Frame") and child.Name ~= "Sidebar" then
                    child.Visible = true
                end
            end
        end)
    end
end)

-- Entrance Animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200)
}):Play()

print("Main Script Loaded Successfully! Welcome " .. player.Name)
