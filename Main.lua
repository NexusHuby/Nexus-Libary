--[[
    Premium Main Hub - Polished UI
    Features: Draggable, minimize to image button, cyan stroke, gradient animation, Lucide-style icons
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    TITLE = "PREMIUM HUB",
    COLORS = {
        Background = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 0.08,
        Sidebar = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(88, 101, 242),
        CyanStroke = Color3.fromRGB(100, 200, 255), -- Baby blue/Cyan
        Success = Color3.fromRGB(87, 242, 135),
        Warning = Color3.fromRGB(255, 200, 100),
        Danger = Color3.fromRGB(255, 100, 100), -- Red for X
        White = Color3.fromRGB(255, 255, 255),
        Gray = Color3.fromRGB(180, 180, 180),
        DarkGray = Color3.fromRGB(100, 100, 100),
        Hover = Color3.fromRGB(55, 55, 65)
    },
    -- Lucide-style icons using text symbols
    ICONS = {
        Home = "⌂",           -- House
        Features = "⚡",       -- Zap
        Settings = "⚙",       -- Settings/Cog
        User = "👤",          -- User
        Shield = "🛡",        -- Shield
        Gamepad = "🎮",       -- Gamepad
        Code = "❮❯",          -- Code brackets
        Search = "🔍",        -- Search
        Bell = "🔔",          -- Bell
        Menu = "☰",           -- Menu
        X = "✕",              -- X close
        Minus = "−",          -- Minus
        ChevronRight = "❯",   -- Chevron
        Check = "✓",          -- Check
        Sparkles = "✨"        -- Sparkles
    }
}

-- Create Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumMainHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Minimized State
local isMinimized = false
local dragButton = nil

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 450)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
mainFrame.BackgroundColor3 = CONFIG.COLORS.Background
mainFrame.BackgroundTransparency = CONFIG.COLORS.BackgroundTransparency
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Cyan Stroke (Baby Blue)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = CONFIG.COLORS.CyanStroke
mainStroke.Thickness = 1.2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- Rounded corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Animated Gradient Background
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 40, 55))
})
bgGradient.Rotation = 45
bgGradient.Parent = mainFrame

-- Gradient Animation Loop
spawn(function()
    while mainFrame and mainFrame.Parent do
        for i = 45, 405, 0.5 do
            if not bgGradient or not bgGradient.Parent then break end
            bgGradient.Rotation = i % 360
            task.wait(0.03)
        end
    end
end)

-- Glossy Overlay
local glossOverlay = Instance.new("Frame")
glossOverlay.Name = "Gloss"
glossOverlay.Size = UDim2.new(1, 0, 0.6, 0)
glossOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glossOverlay.BackgroundTransparency = 0.95
glossOverlay.BorderSizePixel = 0
glossOverlay.Parent = mainFrame

local glossCorner = Instance.new("UICorner")
glossCorner.CornerRadius = UDim.new(0, 16)
glossCorner.Parent = glossOverlay

-- Drag Functionality
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
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

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = CONFIG.ICONS.Sparkles .. " " .. CONFIG.TITLE
titleLabel.TextColor3 = CONFIG.COLORS.White
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Close Button (Red X with hover outline)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
closeBtn.BackgroundTransparency = 0.5
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = CONFIG.ICONS.X
closeBtn.TextColor3 = CONFIG.COLORS.Danger -- Red
closeBtn.TextSize = 16
closeBtn.AutoButtonColor = false
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Close button outline (appears on hover)
local closeOutline = Instance.new("UIStroke")
closeOutline.Color = CONFIG.COLORS.Danger
closeOutline.Thickness = 0 -- Start invisible
closeOutline.Transparency = 0.5
closeOutline.Parent = closeBtn

-- Close button hover effects
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(255, 100, 100),
        BackgroundTransparency = 0.3
    }):Play()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
    TweenService:Create(closeOutline, TweenInfo.new(0.2), {Thickness = 2}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5
    }):Play()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Danger}):Play()
    TweenService:Create(closeOutline, TweenInfo.new(0.2), {Thickness = 0}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    -- Close animation
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset + 350, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + 225),
        Rotation = -10
    }):Play()
    
    if dragButton then
        TweenService:Create(dragButton, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
    end
    
    task.delay(0.4, function()
        screenGui:Destroy()
    end)
end)

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -80, 0.5, -16)
minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
minBtn.BackgroundTransparency = 0.5
minBtn.BorderSizePixel = 0
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = CONFIG.ICONS.Minus
minBtn.TextColor3 = CONFIG.COLORS.Gray
minBtn.TextSize = 18
minBtn.AutoButtonColor = false
minBtn.Parent = topBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minBtn

-- Minimize hover effects
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = CONFIG.COLORS.Accent,
        BackgroundTransparency = 0.3
    }):Play()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
end)

minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 50),
        BackgroundTransparency = 0.5
    }):Play()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
end)

-- Create Drag Button (Image Button for minimized state)
local function createDragButton()
    local btn = Instance.new("ImageButton")
    btn.Name = "DragToggleBtn"
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0, 100, 0, 100)
    btn.BackgroundColor3 = CONFIG.COLORS.Accent
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Image = "rbxassetid://3926305904" -- Circle icon (you can change this)
    btn.ImageColor3 = CONFIG.COLORS.White
    btn.ImageTransparency = 0
    btn.ScaleType = Enum.ScaleType.Fit
    btn.Active = true
    btn.Parent = screenGui
    
    -- Make it circular
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn
    
    -- Cyan stroke for drag button
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = CONFIG.COLORS.CyanStroke
    btnStroke.Thickness = 2
    btnStroke.Parent = btn
    
    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1.4, 0, 1.4, 0)
    glow.Position = UDim2.new(-0.2, 0, -0.2, 0)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://3926305904"
    glow.ImageColor3 = CONFIG.COLORS.Accent
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Fit
    glow.Parent = btn
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(1, 0)
    glowCorner.Parent = glow
    
    -- Icon inside
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.Text = CONFIG.ICONS.Menu
    icon.TextColor3 = CONFIG.COLORS.White
    icon.TextSize = 20
    icon.Parent = btn
    
    -- Drag functionality for button
    local btnDragging = false
    local btnDragInput, btnDragStart, btnStartPos
    
    local function updateBtnDrag(input)
        local delta = input.Position - btnDragStart
        btn.Position = UDim2.new(btnStartPos.X.Scale, btnStartPos.X.Offset + delta.X, btnStartPos.Y.Scale, btnStartPos.Y.Offset + delta.Y)
    end
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btnDragging = true
            btnDragStart = input.Position
            btnStartPos = btn.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    btnDragging = false
                    -- Toggle main frame on click release if not dragged
                    if not btnDragging then
                        isMinimized = not isMinimized
                        if isMinimized then
                            mainFrame.Visible = false
                        else
                            mainFrame.Visible = true
                            -- Pop animation
                            mainFrame.Size = UDim2.new(0, 680, 0, 430)
                            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                                Size = UDim2.new(0, 700, 0, 450)
                            }):Play()
                        end
                    end
                end
            end)
        end
    end)
    
    btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            btnDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == btnDragInput and btnDragging then
            updateBtnDrag(input)
        end
    end)
    
    -- Hover effects
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
    end)
    
    -- Pulse animation
    spawn(function()
        while btn and btn.Parent do
            TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.6
            }):Play()
            task.wait(1)
            TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.8
            }):Play()
            task.wait(1)
        end
    end)
    
    return btn
end

dragButton = createDragButton()
dragButton.Visible = false

-- Minimize functionality
minBtn.MouseButton1Click:Connect(function()
    isMinimized = true
    mainFrame.Visible = false
    dragButton.Visible = true
    dragButton.Position = UDim2.new(0, mainFrame.AbsolutePosition.X + 350 - 25, 0, mainFrame.AbsolutePosition.Y + 225 - 25)
    
    -- Pop in animation for drag button
    dragButton.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(dragButton, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 50, 0, 50)
    }):Play()
end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 180, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = CONFIG.COLORS.Sidebar
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 0)
sidebarCorner.Parent = sidebar

-- Fix sidebar (only left corners)
local sidebarFix = Instance.new("Frame")
sidebarFix.Name = "Fix"
sidebarFix.Size = UDim2.new(0, 20, 1, 0)
sidebarFix.Position = UDim2.new(1, -20, 0, 0)
sidebarFix.BackgroundColor3 = CONFIG.COLORS.Sidebar
sidebarFix.BackgroundTransparency = 0.3
sidebarFix.BorderSizePixel = 0
sidebarFix.Parent = sidebar

-- User Profile Section
local profileFrame = Instance.new("Frame")
profileFrame.Name = "Profile"
profileFrame.Size = UDim2.new(1, -20, 0, 80)
profileFrame.Position = UDim2.new(0, 10, 0, 10)
profileFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
profileFrame.BackgroundTransparency = 0.5
profileFrame.BorderSizePixel = 0
profileFrame.Parent = sidebar

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 12)
profileCorner.Parent = profileFrame

-- Avatar placeholder
local avatar = Instance.new("TextLabel")
avatar.Size = UDim2.new(0, 40, 0, 40)
avatar.Position = UDim2.new(0, 15, 0.5, -20)
avatar.BackgroundColor3 = CONFIG.COLORS.Accent
avatar.BackgroundTransparency = 0.3
avatar.Font = Enum.Font.GothamBold
avatar.Text = CONFIG.ICONS.User
avatar.TextColor3 = CONFIG.COLORS.White
avatar.TextSize = 20
avatar.Parent = profileFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatar

-- Username
local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, -75, 0, 25)
userLabel.Position = UDim2.new(0, 65, 0, 15)
userLabel.BackgroundTransparency = 1
userLabel.Font = Enum.Font.GothamBold
userLabel.Text = player.Name
userLabel.TextColor3 = CONFIG.COLORS.White
userLabel.TextSize = 14
userLabel.TextTruncate = Enum.TextTruncate.AtEnd
userLabel.Parent = profileFrame

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -75, 0, 20)
statusLabel.Position = UDim2.new(0, 65, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = CONFIG.ICONS.Shield .. " PREMIUM"
statusLabel.TextColor3 = CONFIG.COLORS.Success
statusLabel.TextSize = 11
statusLabel.Parent = profileFrame

-- Tab Container (Vertical Layout)
local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 1, -110)
tabContainer.Position = UDim2.new(0, 10, 0, 100)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = sidebar

local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Padding = UDim.new(0, 6)
tabList.Parent = tabContainer

-- Tab Management
local currentTab = nil
local tabs = {}

local function createTab(name, icon, layoutOrder)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Tab"
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.BackgroundColor3 = CONFIG.COLORS.Background
    tabButton.BackgroundTransparency = 0.5
    tabButton.BorderSizePixel = 0
    tabButton.LayoutOrder = layoutOrder
    tabButton.AutoButtonColor = false
    tabButton.Parent = tabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabButton
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 12, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon
    iconLabel.TextColor3 = CONFIG.COLORS.Gray
    iconLabel.TextSize = 18
    iconLabel.Parent = tabButton
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -52, 1, 0)
    textLabel.Position = UDim2.new(0, 45, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = name
    textLabel.TextColor3 = CONFIG.COLORS.Gray
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = tabButton
    
    -- Chevron
    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.new(0, 20, 1, 0)
    chevron.Position = UDim2.new(1, -25, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Font = Enum.Font.GothamBold
    chevron.Text = CONFIG.ICONS.ChevronRight
    chevron.TextColor3 = CONFIG.COLORS.DarkGray
    chevron.TextSize = 12
    chevron.Parent = tabButton
    
    -- Content Frame
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = name .. "Content"
    contentFrame.Size = UDim2.new(1, -200, 1, -70)
    contentFrame.Position = UDim2.new(0, 190, 0, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = CONFIG.COLORS.Accent
    contentFrame.Visible = false
    contentFrame.Parent = mainFrame
    
    -- Hover & Click Effects
    tabButton.MouseEnter:Connect(function()
        if currentTab ~= tabButton then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.Hover,
                BackgroundTransparency = 0.3
            }):Play()
            TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
            TweenService:Create(textLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if currentTab ~= tabButton then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.Background,
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
            TweenService:Create(textLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        if currentTab == tabButton then return end
        
        -- Deactivate previous
        if currentTab then
            local prevData = tabs[currentTab]
            TweenService:Create(currentTab, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.Background,
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(prevData.icon, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
            TweenService:Create(prevData.text, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
            TweenService:Create(prevData.chevron, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
            prevData.content.Visible = false
        end
        
        -- Activate new
        currentTab = tabButton
        TweenService:Create(tabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = CONFIG.COLORS.Accent,
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
        TweenService:Create(chevron, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        
        -- Fade in content
        contentFrame.Visible = true
        contentFrame.ScrollBarImageTransparency = 1
        TweenService:Create(contentFrame, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0}):Play()
    end)
    
    tabs[tabButton] = {
        icon = iconLabel,
        text = textLabel,
        chevron = chevron,
        content = contentFrame
    }
    
    return contentFrame
end

-- Create Tabs
local homeTab = createTab("Dashboard", CONFIG.ICONS.Home, 1)
local featuresTab = createTab("Features", CONFIG.ICONS.Features, 2)
local gameTab = createTab("Game", CONFIG.ICONS.Gamepad, 3)
local codeTab = createTab("Scripts", CONFIG.ICONS.Code, 4)
local settingsTab = createTab("Settings", CONFIG.ICONS.Settings, 5)

-- Populate Home Tab
local welcomeCard = Instance.new("Frame")
welcomeCard.Size = UDim2.new(1, -20, 0, 120)
welcomeCard.Position = UDim2.new(0, 10, 0, 10)
welcomeCard.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
welcomeCard.BackgroundTransparency = 0.3
welcomeCard.BorderSizePixel = 0
welcomeCard.Parent = homeTab

local cardCorner = Instance.new("UICorner")
cardCorner.CornerRadius = UDim.new(0, 12)
cardCorner.Parent = welcomeCard

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, -30, 0, 30)
welcomeTitle.Position = UDim2.new(0, 15, 0, 15)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Font = Enum.Font.GothamBold
welcomeTitle.Text = "Welcome back, " .. player.Name .. "!"
welcomeTitle.TextColor3 = CONFIG.COLORS.White
welcomeTitle.TextSize = 18
welcomeTitle.Parent = welcomeCard

local welcomeDesc = Instance.new("TextLabel")
welcomeDesc.Size = UDim2.new(1, -30, 0, 50)
welcomeDesc.Position = UDim2.new(0, 15, 0, 50)
welcomeDesc.BackgroundTransparency = 1
welcomeDesc.Font = Enum.Font.Gotham
welcomeDesc.Text = "Your key has been verified and saved. All premium features are now available for your account."
welcomeDesc.TextColor3 = CONFIG.COLORS.Gray
welcomeDesc.TextSize = 13
welcomeDesc.TextWrapped = true
welcomeDesc.Parent = welcomeCard

-- Stats Grid
local statsGrid = Instance.new("Frame")
statsGrid.Size = UDim2.new(1, -20, 0, 100)
statsGrid.Position = UDim2.new(0, 10, 0, 140)
statsGrid.BackgroundTransparency = 1
statsGrid.Parent = homeTab

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0.48, 0, 0, 45)
gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 10)
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = statsGrid

local function createStatCard(title, value, icon, color)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    card.BackgroundTransparency = 0.4
    card.BorderSizePixel = 0
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 10, 0.5, -15)
    iconLabel.BackgroundColor3 = color
    iconLabel.BackgroundTransparency = 0.8
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = icon
    iconLabel.TextColor3 = color
    iconLabel.TextSize = 16
    iconLabel.Parent = card
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 8)
    iconCorner.Parent = iconLabel
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -55, 0, 20)
    titleLabel.Position = UDim2.new(0, 50, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.Text = title
    titleLabel.TextColor3 = CONFIG.COLORS.Gray
    titleLabel.TextSize = 11
    titleLabel.Parent = card
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, -55, 0, 25)
    valueLabel.Position = UDim2.new(0, 50, 0, 22)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = value
    valueLabel.TextColor3 = CONFIG.COLORS.White
    valueLabel.TextSize = 16
    valueLabel.Parent = card
    
    -- Hover effect
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
    end)
    
    return card
end

createStatCard("Status", "Active", CONFIG.ICONS.Check, CONFIG.COLORS.Success).Parent = statsGrid
createStatCard("Version", "v2.0", CONFIG.ICONS.Code, CONFIG.COLORS.Accent).Parent = statsGrid
createStatCard("Features", "25+", CONFIG.ICONS.Sparkles, CONFIG.COLORS.Warning).Parent = statsGrid
createStatCard("Security", "HWID", CONFIG.ICONS.Shield, CONFIG.COLORS.CyanStroke).Parent = statsGrid

-- Populate Features Tab with example buttons
local featureLayout = Instance.new("UIListLayout")
featureLayout.Padding = UDim.new(0, 10)
featureLayout.Parent = featuresTab

local function createFeatureButton(name, description)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 60)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = CONFIG.COLORS.White
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = btn
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 20)
    desc.Position = UDim2.new(0, 15, 0, 32)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.Text = description
    desc.TextColor3 = CONFIG.COLORS.Gray
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = btn
    
    -- Toggle indicator
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -55, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggle.BorderSizePixel = 0
    toggle.Parent = btn
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 2, 0.5, -9)
    knob.BackgroundColor3 = CONFIG.COLORS.White
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local enabled = false
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Success}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 20, 0.5, -9)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
        end
    end)
    
    return btn
end

createFeatureButton("Auto Farm", "Automatically farm resources").Parent = featuresTab
createFeatureButton("ESP", "See players through walls").Parent = featuresTab
createFeatureButton("Speed Boost", "Increase walk speed").Parent = featuresTab
createFeatureButton("Auto Collect", "Collect items automatically").Parent = featuresTab

-- Settings Tab
local resetCard = Instance.new("Frame")
resetCard.Size = UDim2.new(1, -20, 0, 150)
resetCard.Position = UDim2.new(0, 10, 0, 10)
resetCard.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
resetCard.BackgroundTransparency = 0.4
resetCard.BorderSizePixel = 0
resetCard.Parent = settingsTab

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 12)
resetCorner.Parent = resetCard

local resetTitle = Instance.new("TextLabel")
resetTitle.Size = UDim2.new(1, -30, 0, 25)
resetTitle.Position = UDim2.new(0, 15, 0, 15)
resetTitle.BackgroundTransparency = 1
resetTitle.Font = Enum.Font.GothamBold
resetTitle.Text = "Reset Key"
resetTitle.TextColor3 = CONFIG.COLORS.White
resetTitle.TextSize = 16
resetTitle.Parent = resetCard

local resetDesc = Instance.new("TextLabel")
resetDesc.Size = UDim2.new(1, -30, 0, 40)
resetDesc.Position = UDim2.new(0, 15, 0, 45)
resetDesc.BackgroundTransparency = 1
resetDesc.Font = Enum.Font.Gotham
resetDesc.Text = "Clear your saved key if you want to switch accounts or troubleshoot issues."
resetDesc.TextColor3 = CONFIG.COLORS.Gray
resetDesc.TextSize = 13
resetDesc.TextWrapped = true
resetDesc.Parent = resetCard

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 120, 0, 35)
resetBtn.Position = UDim2.new(0, 15, 0, 100)
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
resetBtn.BorderSizePixel = 0
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Text = "Reset Key"
resetBtn.TextColor3 = CONFIG.COLORS.White
resetBtn.TextSize = 13
resetBtn.AutoButtonColor = false
resetBtn.Parent = resetCard

local resetBtnCorner = Instance.new("UICorner")
resetBtnCorner.CornerRadius = UDim.new(0, 8)
resetBtnCorner.Parent = resetBtn

resetBtn.MouseEnter:Connect(function()
    TweenService:Create(resetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 100, 100)}):Play()
end)

resetBtn.MouseLeave:Connect(function()
    TweenService:Create(resetBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 80, 80)}):Play()
end)

resetBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if isfile("SystemCache_9821.dat") then delfile("SystemCache_9821.dat") end
        if isfile("SystemID_7392.dat") then delfile("SystemID_7392.dat") end
    end)
    resetBtn.Text = "Reset!"
    task.wait(1)
    resetBtn.Text = "Reset Key"
end)

-- Select Home tab by default
task.delay(0.3, function()
    local homeTabBtn = sidebar:FindFirstChild("DashboardTab")
    if homeTabBtn then
        homeTabBtn.MouseButton1Click:Fire()
    end
end)

-- Entrance Animation
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Rotation = -5

TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 700, 0, 450),
    Position = UDim2.new(0.5, -350, 0.5, -225),
    Rotation = 0
}):Play()

print("Premium Main Hub Loaded Successfully! Welcome " .. player.Name)
