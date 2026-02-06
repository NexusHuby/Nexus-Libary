--[[
    Nexus Main Hub - Fixed Version
    Fixed: Drag button, black bar, strokes, Discord button, white outline
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    TITLE = "NEXUS HUB",
    DISCORD_LINK = "https://discord.gg/yourlink", -- Replace with your Discord
    COLORS = {
        Background = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 0.08,
        Sidebar = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(88, 101, 242),
        White = Color3.fromRGB(255, 255, 255), -- White outline
        Success = Color3.fromRGB(87, 242, 135),
        Warning = Color3.fromRGB(255, 200, 100),
        Danger = Color3.fromRGB(255, 100, 100),
        Gray = Color3.fromRGB(180, 180, 180),
        DarkGray = Color3.fromRGB(100, 100, 100),
        Hover = Color3.fromRGB(55, 55, 65)
    }
}

-- Lucide Icons
local LucideIcons = {
    home = "⌂",
    zap = "⚡",
    gamepad = "🎮",
    code = "❮❯",
    settings = "⚙",
    user = "👤",
    shield = "🛡",
    check = "✓",
    x = "✕",
    minus = "−",
    menu = "☰",
    chevronRight = "❯",
    refresh = "↻",
    copy = "📋",
    externalLink = "↗",
    users = "👥",
    sparkles = "✨",
    message = "💬"
}

-- Create Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NexusMainHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Minimized State
local isMinimized = false
local dragButton = nil
local savedButtonPosition = nil

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

-- WHITE Stroke (not cyan)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = CONFIG.COLORS.White
mainStroke.Thickness = 1.2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

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

-- Gradient Animation
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
glossOverlay.Name = "GlossOverlay"
glossOverlay.Size = UDim2.new(1, 0, 0.6, 0)
glossOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glossOverlay.BackgroundTransparency = 0.95
glossOverlay.BorderSizePixel = 0
glossOverlay.Parent = mainFrame

local glossCorner = Instance.new("UICorner")
glossCorner.CornerRadius = UDim.new(0, 16)
glossCorner.Parent = glossOverlay

-- Drag Functionality for Main Frame
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
titleLabel.Text = LucideIcons.sparkles .. " " .. CONFIG.TITLE
titleLabel.TextColor3 = CONFIG.COLORS.White
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0.5, -16)
closeBtn.BackgroundTransparency = 1
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = LucideIcons.x
closeBtn.TextColor3 = CONFIG.COLORS.Danger
closeBtn.TextSize = 18
closeBtn.AutoButtonColor = false
closeBtn.Parent = topBar

local closeOutline = Instance.new("UIStroke")
closeOutline.Color = CONFIG.COLORS.Danger
closeOutline.Thickness = 0
closeOutline.Transparency = 0.5
closeOutline.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
    TweenService:Create(closeOutline, TweenInfo.new(0.2), {Thickness = 1.5}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Danger}):Play()
    TweenService:Create(closeOutline, TweenInfo.new(0.2), {Thickness = 0}):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
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
minBtn.BackgroundTransparency = 1
minBtn.BorderSizePixel = 0
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = LucideIcons.minus
minBtn.TextColor3 = CONFIG.COLORS.Gray
minBtn.TextSize = 20
minBtn.AutoButtonColor = false
minBtn.Parent = topBar

minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
end)

minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
end)

-- FIXED: Drag Button - Only drags when holding mouse button
local function createDragButton()
    local btn = Instance.new("ImageButton")
    btn.Name = "DragToggleBtn"
    btn.Size = UDim2.new(0, 50, 0, 50)
    
    if savedButtonPosition then
        btn.Position = savedButtonPosition
    else
        btn.Position = UDim2.new(0, 100, 0, 100)
    end
    
    btn.BackgroundColor3 = CONFIG.COLORS.Accent
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Image = "rbxassetid://3926305904"
    btn.ImageColor3 = CONFIG.COLORS.White
    btn.ImageTransparency = 0
    btn.ScaleType = Enum.ScaleType.Fit
    btn.Active = true
    btn.Visible = false
    btn.Parent = screenGui
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = CONFIG.COLORS.White -- White stroke
    btnStroke.Thickness = 2
    btnStroke.Parent = btn
    
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
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Font = Enum.Font.GothamBold
    icon.Text = LucideIcons.menu
    icon.TextColor3 = CONFIG.COLORS.White
    icon.TextSize = 20
    icon.Parent = btn
    
    -- FIXED: Proper drag logic - only drag when holding mouse button
    local isDragging = false
    local dragStartPos = nil
    local buttonStartPos = nil
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            dragStartPos = input.Position
            buttonStartPos = btn.Position
            
            -- Track mouse movement
            local moveConnection
            moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
                if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                    if (moveInput.Position - dragStartPos).Magnitude > 5 then
                        isDragging = true
                        local delta = moveInput.Position - dragStartPos
                        btn.Position = UDim2.new(
                            buttonStartPos.X.Scale, 
                            buttonStartPos.X.Offset + delta.X, 
                            buttonStartPos.Y.Scale, 
                            buttonStartPos.Y.Offset + delta.Y
                        )
                    end
                end
            end)
            
            -- Release tracking
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    moveConnection:Disconnect()
                    if not isDragging then
                        -- It was a click, toggle main frame
                        isMinimized = not isMinimized
                        if isMinimized then
                            mainFrame.Visible = false
                        else
                            mainFrame.Visible = true
                            mainFrame.Size = UDim2.new(0, 680, 0, 430)
                            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                                Size = UDim2.new(0, 700, 0, 450)
                            }):Play()
                        end
                    else
                        -- Save position after drag
                        savedButtonPosition = btn.Position
                    end
                end
            end)
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

-- Minimize functionality
minBtn.MouseButton1Click:Connect(function()
    if isMinimized then return end
    
    isMinimized = true
    mainFrame.Visible = false
    dragButton.Visible = true
    
    if not savedButtonPosition then
        dragButton.Position = UDim2.new(0, mainFrame.AbsolutePosition.X + 650, 0, mainFrame.AbsolutePosition.Y + 20)
    end
    
    dragButton.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(dragButton, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 50, 0, 50)
    }):Play()
end)

-- FIXED: Sidebar - No black bar, proper corners
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 180, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = CONFIG.COLORS.Sidebar
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

-- FIXED: Only round right corners of sidebar
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 16)
sidebarCorner.Parent = sidebar

-- Mask left corners to make them square (no black bar)
local leftMask = Instance.new("Frame")
leftMask.Name = "LeftMask"
leftMask.Size = UDim2.new(0, 20, 1, 0)
leftMask.Position = UDim2.new(0, 0, 0, 0)
leftMask.BackgroundColor3 = CONFIG.COLORS.Sidebar
leftMask.BackgroundTransparency = 0.3
leftMask.BorderSizePixel = 0
leftMask.ZIndex = 2
leftMask.Parent = sidebar

-- User Profile Button
local profileButton = Instance.new("TextButton")
profileButton.Name = "ProfileButton"
profileButton.Size = UDim2.new(1, -20, 0, 80)
profileButton.Position = UDim2.new(0, 10, 0, 10)
profileButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
profileButton.BackgroundTransparency = 0.5
profileButton.BorderSizePixel = 0
profileButton.AutoButtonColor = false
profileButton.Text = ""
profileButton.Parent = sidebar

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 12)
profileCorner.Parent = profileButton

-- Avatar Image
local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "Avatar"
avatarImage.Size = UDim2.new(0, 50, 0, 50)
avatarImage.Position = UDim2.new(0, 15, 0.5, -25)
avatarImage.BackgroundColor3 = CONFIG.COLORS.Accent
avatarImage.BackgroundTransparency = 0.3
avatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
avatarImage.Parent = profileButton

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImage

-- Username (NO STROKE)
local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, -85, 0, 25)
userLabel.Position = UDim2.new(0, 75, 0, 10)
userLabel.BackgroundTransparency = 1
userLabel.Font = Enum.Font.GothamBold
userLabel.Text = player.Name
userLabel.TextColor3 = CONFIG.COLORS.White
userLabel.TextSize = 14
userLabel.TextTruncate = Enum.TextTruncate.AtEnd
userLabel.TextXAlignment = Enum.TextXAlignment.Left
userLabel.Parent = profileButton

-- Status (NO STROKE)
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -85, 0, 20)
statusLabel.Position = UDim2.new(0, 75, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = LucideIcons.shield .. " PREMIUM"
statusLabel.TextColor3 = CONFIG.COLORS.Success
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = profileButton

-- Discord Button - Cool styled button
local discordBtn = Instance.new("TextButton")
discordBtn.Name = "DiscordBtn"
discordBtn.Size = UDim2.new(1, -85, 0, 22)
discordBtn.Position = UDim2.new(0, 75, 0, 55)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord purple
discordBtn.BorderSizePixel = 0
discordBtn.Font = Enum.Font.GothamBold
discordBtn.Text = LucideIcons.message .. " Discord"
discordBtn.TextColor3 = CONFIG.COLORS.White
discordBtn.TextSize = 10
discordBtn.AutoButtonColor = false
discordBtn.Parent = profileButton

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 6)
discordCorner.Parent = discordBtn

-- Discord button gradient
local discordGradient = Instance.new("UIGradient")
discordGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 115, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242))
})
discordGradient.Rotation = 90
discordGradient.Parent = discordBtn

-- Discord button hover
discordBtn.MouseEnter:Connect(function()
    TweenService:Create(discordBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(120, 135, 255)
    }):Play()
end)

discordBtn.MouseLeave:Connect(function()
    TweenService:Create(discordBtn, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    }):Play()
end)

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(CONFIG.DISCORD_LINK)
        discordBtn.Text = LucideIcons.check .. " Copied!"
        task.delay(2, function()
            discordBtn.Text = LucideIcons.message .. " Discord"
        end)
    end
end)

-- Profile hover effect
profileButton.MouseEnter:Connect(function()
    TweenService:Create(profileButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(55, 55, 65),
        BackgroundTransparency = 0.3
    }):Play()
end)

profileButton.MouseLeave:Connect(function()
    TweenService:Create(profileButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(45, 45, 55),
        BackgroundTransparency = 0.5
    }):Play()
end)

-- Tab Container
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
local contentFrames = {}

local function createTab(name, iconKey, layoutOrder)
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
    
    -- Icon (NO STROKE)
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 12, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = LucideIcons[iconKey] or "•"
    iconLabel.TextColor3 = CONFIG.COLORS.Gray
    iconLabel.TextSize = 18
    iconLabel.Parent = tabButton
    
    -- Text (NO STROKE)
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
    
    -- Chevron (NO STROKE)
    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.new(0, 20, 1, 0)
    chevron.Position = UDim2.new(1, -25, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Font = Enum.Font.GothamBold
    chevron.Text = LucideIcons.chevronRight
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
        
        for _, frame in pairs(contentFrames) do
            frame.Visible = false
        end
        
        if currentTab then
            local prevData = tabs[currentTab]
            TweenService:Create(currentTab, TweenInfo.new(0.2), {
                BackgroundColor3 = CONFIG.COLORS.Background,
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(prevData.icon, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
            TweenService:Create(prevData.text, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
            TweenService:Create(prevData.chevron, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        end
        
        currentTab = tabButton
        TweenService:Create(tabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = CONFIG.COLORS.Accent,
            BackgroundTransparency = 0.2
        }):Play()
        TweenService:Create(iconLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.White}):Play()
        TweenService:Create(chevron, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        
        contentFrame.Visible = true
        contentFrame.CanvasPosition = Vector2.new(0, 0)
    end)
    
    tabs[tabButton] = {
        icon = iconLabel,
        text = textLabel,
        chevron = chevron,
        content = contentFrame
    }
    contentFrames[name] = contentFrame
    
    return contentFrame
end

-- Create Tabs
local featuresTab = createTab("Features", "zap", 1)
local gameTab = createTab("Game", "gamepad", 2)
local scriptsTab = createTab("Scripts", "code", 3)
local settingsTab = createTab("Settings", "settings", 4)

-- SERVER TAB (opens when clicking profile)
local serverFrame = Instance.new("ScrollingFrame")
serverFrame.Name = "ServerContent"
serverFrame.Size = UDim2.new(1, -200, 1, -70)
serverFrame.Position = UDim2.new(0, 190, 0, 60)
serverFrame.BackgroundTransparency = 1
serverFrame.BorderSizePixel = 0
serverFrame.ScrollBarThickness = 4
serverFrame.ScrollBarImageColor3 = CONFIG.COLORS.Accent
serverFrame.Visible = false
serverFrame.Parent = mainFrame

contentFrames["Server"] = serverFrame

-- Server Management UI
local serverTitle = Instance.new("TextLabel")
serverTitle.Size = UDim2.new(1, -20, 0, 30)
serverTitle.Position = UDim2.new(0, 10, 0, 10)
serverTitle.BackgroundTransparency = 1
serverTitle.Font = Enum.Font.GothamBold
serverTitle.Text = LucideIcons.users .. " Server Management"
serverTitle.TextColor3 = CONFIG.COLORS.White
serverTitle.TextSize = 20
serverTitle.Parent = serverFrame

-- Current Server Info Card
local serverInfoCard = Instance.new("Frame")
serverInfoCard.Size = UDim2.new(1, -20, 0, 140)
serverInfoCard.Position = UDim2.new(0, 10, 0, 50)
serverInfoCard.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
serverInfoCard.BackgroundTransparency = 0.3
serverInfoCard.BorderSizePixel = 0
serverInfoCard.Parent = serverFrame

local serverInfoCorner = Instance.new("UICorner")
serverInfoCorner.CornerRadius = UDim.new(0, 12)
serverInfoCorner.Parent = serverInfoCard

-- Job ID Display (NO STROKE)
local jobIdLabel = Instance.new("TextLabel")
jobIdLabel.Size = UDim2.new(1, -30, 0, 25)
jobIdLabel.Position = UDim2.new(0, 15, 0, 15)
jobIdLabel.BackgroundTransparency = 1
jobIdLabel.Font = Enum.Font.GothamBold
jobIdLabel.Text = "Current Job ID"
jobIdLabel.TextColor3 = CONFIG.COLORS.Gray
jobIdLabel.TextSize = 12
jobIdLabel.Parent = serverInfoCard

local jobIdValue = Instance.new("TextLabel")
jobIdValue.Size = UDim2.new(1, -30, 0, 30)
jobIdValue.Position = UDim2.new(0, 15, 0, 40)
jobIdValue.BackgroundTransparency = 1
jobIdValue.Font = Enum.Font.Gotham
jobIdValue.Text = game.JobId
jobIdValue.TextColor3 = CONFIG.COLORS.White
jobIdValue.TextSize = 14
jobIdValue.TextWrapped = true
jobIdValue.Parent = serverInfoCard

-- Copy Job ID Button
local copyJobIdBtn = Instance.new("TextButton")
copyJobIdBtn.Size = UDim2.new(0, 120, 0, 32)
copyJobIdBtn.Position = UDim2.new(0, 15, 0, 85)
copyJobIdBtn.BackgroundColor3 = CONFIG.COLORS.Accent
copyJobIdBtn.BorderSizePixel = 0
copyJobIdBtn.Font = Enum.Font.GothamBold
copyJobIdBtn.Text = LucideIcons.copy .. " Copy"
copyJobIdBtn.TextColor3 = CONFIG.COLORS.White
copyJobIdBtn.TextSize = 12
copyJobIdBtn.AutoButtonColor = false
copyJobIdBtn.Parent = serverInfoCard

local copyBtnCorner = Instance.new("UICorner")
copyBtnCorner.CornerRadius = UDim.new(0, 8)
copyBtnCorner.Parent = copyJobIdBtn

copyJobIdBtn.MouseEnter:Connect(function()
    TweenService:Create(copyJobIdBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(110, 123, 255)}):Play()
end)

copyJobIdBtn.MouseLeave:Connect(function()
    TweenService:Create(copyJobIdBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Accent}):Play()
end)

copyJobIdBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        copyJobIdBtn.Text = LucideIcons.check .. " Copied!"
        task.delay(2, function()
            copyJobIdBtn.Text = LucideIcons.copy .. " Copy"
        end)
    end
end)

-- Rejoin Button
local rejoinBtn = Instance.new("TextButton")
rejoinBtn.Size = UDim2.new(0, 100, 0, 32)
rejoinBtn.Position = UDim2.new(0, 145, 0, 85)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
rejoinBtn.BorderSizePixel = 0
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.Text = LucideIcons.refresh .. " Rejoin"
rejoinBtn.TextColor3 = CONFIG.COLORS.White
rejoinBtn.TextSize = 12
rejoinBtn.AutoButtonColor = false
rejoinBtn.Parent = serverInfoCard

local rejoinCorner = Instance.new("UICorner")
rejoinCorner.CornerRadius = UDim.new(0, 8)
rejoinCorner.Parent = rejoinBtn

rejoinBtn.MouseEnter:Connect(function()
    TweenService:Create(rejoinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
end)

rejoinBtn.MouseLeave:Connect(function()
    TweenService:Create(rejoinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
end)

rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, player)
end)

-- Server Hop Button
local serverHopBtn = Instance.new("TextButton")
serverHopBtn.Size = UDim2.new(0, 110, 0, 32)
serverHopBtn.Position = UDim2.new(0, 255, 0, 85)
serverHopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
serverHopBtn.BorderSizePixel = 0
serverHopBtn.Font = Enum.Font.GothamBold
serverHopBtn.Text = LucideIcons.externalLink .. " Server Hop"
serverHopBtn.TextColor3 = CONFIG.COLORS.White
serverHopBtn.TextSize = 12
serverHopBtn.AutoButtonColor = false
serverHopBtn.Parent = serverInfoCard

local hopCorner = Instance.new("UICorner")
hopCorner.CornerRadius = UDim.new(0, 8)
hopCorner.Parent = serverHopBtn

serverHopBtn.MouseEnter:Connect(function()
    TweenService:Create(serverHopBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 90)}):Play()
end)

serverHopBtn.MouseLeave:Connect(function()
    TweenService:Create(serverHopBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
end)

serverHopBtn.MouseButton1Click:Connect(function()
    local servers = {}
    local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(req)
    
    for _, server in ipairs(data.data) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            table.insert(servers, server.id)
        end
    end
    
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], player)
    end
end)

-- Join Job ID Section
local joinJobCard = Instance.new("Frame")
joinJobCard.Size = UDim2.new(1, -20, 0, 120)
joinJobCard.Position = UDim2.new(0, 10, 0, 200)
joinJobCard.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
joinJobCard.BackgroundTransparency = 0.3
joinJobCard.BorderSizePixel = 0
joinJobCard.Parent = serverFrame

local joinJobCorner = Instance.new("UICorner")
joinJobCorner.CornerRadius = UDim.new(0, 12)
joinJobCorner.Parent = joinJobCard

local joinTitle = Instance.new("TextLabel")
joinTitle.Size = UDim2.new(1, -30, 0, 25)
joinTitle.Position = UDim2.new(0, 15, 0, 15)
joinTitle.BackgroundTransparency = 1
joinTitle.Font = Enum.Font.GothamBold
joinTitle.Text = "Join Specific Server"
joinTitle.TextColor3 = CONFIG.COLORS.Gray
joinTitle.TextSize = 12
joinTitle.Parent = joinJobCard

-- Job ID Input
local jobIdInput = Instance.new("TextBox")
jobIdInput.Size = UDim2.new(1, -140, 0, 35)
jobIdInput.Position = UDim2.new(0, 15, 0, 45)
jobIdInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
jobIdInput.BorderSizePixel = 0
jobIdInput.Font = Enum.Font.Gotham
jobIdInput.PlaceholderText = "Paste Job ID here..."
jobIdInput.PlaceholderColor3 = CONFIG.COLORS.DarkGray
jobIdInput.Text = ""
jobIdInput.TextColor3 = CONFIG.COLORS.White
jobIdInput.TextSize = 13
jobIdInput.Parent = joinJobCard

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = jobIdInput

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = CONFIG.COLORS.DarkGray
inputStroke.Thickness = 1
inputStroke.Parent = jobIdInput

jobIdInput.Focused:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.Accent}):Play()
end)

jobIdInput.FocusLost:Connect(function()
    TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = CONFIG.COLORS.DarkGray}):Play()
end)

-- Join Button
local joinBtn = Instance.new("TextButton")
joinBtn.Size = UDim2.new(0, 100, 0, 35)
joinBtn.Position = UDim2.new(1, -115, 0, 45)
joinBtn.BackgroundColor3 = CONFIG.COLORS.Success
joinBtn.BorderSizePixel = 0
joinBtn.Font = Enum.Font.GothamBold
joinBtn.Text = "Join"
joinBtn.TextColor3 = CONFIG.COLORS.White
joinBtn.TextSize = 13
joinBtn.AutoButtonColor = false
joinBtn.Parent = joinJobCard

local joinBtnCorner = Instance.new("UICorner")
joinBtnCorner.CornerRadius = UDim.new(0, 8)
joinBtnCorner.Parent = joinBtn

joinBtn.MouseEnter:Connect(function()
    TweenService:Create(joinBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(107, 255, 155)}):Play()
end)

joinBtn.MouseLeave:Connect(function()
    TweenService:Create(joinBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.COLORS.Success}):Play()
end)

joinBtn.MouseButton1Click:Connect(function()
    local jobId = jobIdInput.Text:gsub("%s+", "")
    if jobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
    else
        jobIdInput.PlaceholderText = "Please enter a Job ID!"
        task.delay(2, function()
            jobIdInput.PlaceholderText = "Paste Job ID here..."
        end)
    end
end)

-- Player List Section
local playersTitle = Instance.new("TextLabel")
playersTitle.Size = UDim2.new(1, -20, 0, 30)
playersTitle.Position = UDim2.new(0, 10, 0, 330)
playersTitle.BackgroundTransparency = 1
playersTitle.Font = Enum.Font.GothamBold
playersTitle.Text = LucideIcons.users .. " Players in Server (" .. #Players:GetPlayers() .. ")"
playersTitle.TextColor3 = CONFIG.COLORS.White
playersTitle.TextSize = 16
playersTitle.Parent = serverFrame

local playersContainer = Instance.new("Frame")
playersContainer.Size = UDim2.new(1, -20, 0, 0)
playersContainer.Position = UDim2.new(0, 10, 0, 365)
playersContainer.BackgroundTransparency = 1
playersContainer.Parent = serverFrame

local playersList = Instance.new("UIListLayout")
playersList.Padding = UDim.new(0, 5)
playersList.Parent = playersContainer

local function updatePlayerList()
    for _, child in ipairs(playersContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        local plrCard = Instance.new("Frame")
        plrCard.Size = UDim2.new(1, 0, 0, 45)
        plrCard.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
        plrCard.BackgroundTransparency = 0.4
        plrCard.BorderSizePixel = 0
        plrCard.Parent = playersContainer
        
        local plrCorner = Instance.new("UICorner")
        plrCorner.CornerRadius = UDim.new(0, 8)
        plrCorner.Parent = plrCard
        
        local plrAvatar = Instance.new("ImageLabel")
        plrAvatar.Size = UDim2.new(0, 32, 0, 32)
        plrAvatar.Position = UDim2.new(0, 8, 0.5, -16)
        plrAvatar.BackgroundColor3 = CONFIG.COLORS.DarkGray
        plrAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. plr.UserId .. "&w=150&h=150"
        plrAvatar.Parent = plrCard
        
        local plrAvatarCorner = Instance.new("UICorner")
        plrAvatarCorner.CornerRadius = UDim.new(1, 0)
        plrAvatarCorner.Parent = plrAvatar
        
        local plrName = Instance.new("TextLabel")
        plrName.Size = UDim2.new(1, -55, 1, 0)
        plrName.Position = UDim2.new(0, 50, 0, 0)
        plrName.BackgroundTransparency = 1
        plrName.Font = Enum.Font.GothamBold
        plrName.Text = plr.Name .. (plr == player and " (You)" or "")
        plrName.TextColor3 = plr == player and CONFIG.COLORS.Accent or CONFIG.COLORS.White
        plrName.TextSize = 13
        plrName.TextXAlignment = Enum.TextXAlignment.Left
        plrName.Parent = plrCard
        
        plrCard.MouseEnter:Connect(function()
            TweenService:Create(plrCard, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        
        plrCard.MouseLeave:Connect(function()
            TweenService:Create(plrCard, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
        end)
    end
    
    playersTitle.Text = LucideIcons.users .. " Players in Server (" .. #Players:GetPlayers() .. ")"
    playersContainer.Size = UDim2.new(1, -20, 0, #Players:GetPlayers() * 50)
    serverFrame.CanvasSize = UDim2.new(0, 0, 0, 365 + (#Players:GetPlayers() * 50) + 20)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Profile Button Click - Show Server Tab
profileButton.MouseButton1Click:Connect(function()
    for _, frame in pairs(contentFrames) do
        frame.Visible = false
    end
    
    for btn, data in pairs(tabs) do
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = CONFIG.COLORS.Background,
            BackgroundTransparency = 0.5
        }):Play()
        TweenService:Create(data.icon, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
        TweenService:Create(data.text, TweenInfo.new(0.2), {TextColor3 = CONFIG.COLORS.Gray}):Play()
        TweenService:Create(data.chevron, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    end
    
    currentTab = nil
    serverFrame.Visible = true
end)

-- Populate Features Tab
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
    title.Size = UDim2.new(1, -80, 0, 25)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = name
    title.TextColor3 = CONFIG.COLORS.White
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = btn
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -80, 0, 20)
    desc.Position = UDim2.new(0, 15, 0, 32)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.Text = description
    desc.TextColor3 = CONFIG.COLORS.Gray
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = btn
    
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 44, 0, 24)
    toggle.Position = UDim2.new(1, -59, 0.5, -12)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggle.BorderSizePixel = 0
    toggle.Parent = btn
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new(0, 2, 0.5, -10)
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
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -10)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
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
        if isfile("NexusCache_9821.dat") then delfile("NexusCache_9821.dat") end
        if isfile("NexusID_7392.dat") then delfile("NexusID_7392.dat") end
    end)
    resetBtn.Text = "Reset!"
    task.delay(1, function()
        resetBtn.Text = "Reset Key"
    end)
end)

-- Select Features tab by default
task.delay(0.3, function()
    local featuresTabBtn = sidebar:FindFirstChild("FeaturesTab")
    if featuresTabBtn then
        featuresTabBtn.MouseButton1Click:Fire()
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

print("Nexus Main Hub Loaded Successfully! Welcome " .. player.Name)
