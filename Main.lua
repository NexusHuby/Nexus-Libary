--[[
    Nexus Main Hub - Fixed Minimize Button
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
    DISCORD_LINK = "https://discord.gg/yourlink",
    COLORS = {
        Background = Color3.fromRGB(25, 25, 30),
        BackgroundTransparency = 0.08,
        Sidebar = Color3.fromRGB(35, 35, 40),
        Accent = Color3.fromRGB(88, 101, 242),
        White = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(87, 242, 135),
        Warning = Color3.fromRGB(255, 200, 100),
        Danger = Color3.fromRGB(255, 100, 100),
        Gray = Color3.fromRGB(180, 180, 180),
        DarkGray = Color3.fromRGB(100, 100, 100),
        Hover = Color3.fromRGB(55, 55, 65)
    }
}

local LucideIcons = {
    home = "⌂", zap = "⚡", gamepad = "🎮", code = "❮❯", settings = "⚙",
    user = "👤", shield = "🛡", check = "✓", x = "✕", minus = "−",
    menu = "☰", chevronRight = "❯", refresh = "↻", copy = "📋",
    externalLink = "↗", users = "👥", sparkles = "✨", message = "💬"
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NexusMainHub"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local isMinimized = false
local dragButton = nil
local savedButtonPosition = nil
local dragButtonDragging = false -- Track if drag button is being dragged

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

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = CONFIG.COLORS.White
mainStroke.Thickness = 1.2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Background Gradient
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 40, 55))
})
bgGradient.Rotation = 45
bgGradient.Parent = mainFrame

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

-- Drag Main Frame
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

-- FIXED: Drag Button - Proper click detection, no global click issues
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
    btnStroke.Color = CONFIG.COLORS.White
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
    
    -- FIXED: Proper drag and click handling
    local isHolding = false
    local startHoldPos = nil
    local startButtonPos = nil
    local hasMoved = false
    local inputChangedConnection = nil
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isHolding = true
            hasMoved = false
            startHoldPos = input.Position
            startButtonPos = btn.Position
            dragButtonDragging = true -- Set global flag
            
            -- Track movement
            inputChangedConnection = UserInputService.InputChanged:Connect(function(changedInput)
                if not isHolding then return end
                if changedInput.UserInputType == Enum.UserInputType.MouseMovement or changedInput.UserInputType == Enum.UserInputType.Touch then
                    local distance = (changedInput.Position - startHoldPos).Magnitude
                    if distance > 5 then
                        hasMoved = true
                        local delta = changedInput.Position - startHoldPos
                        btn.Position = UDim2.new(
                            startButtonPos.X.Scale,
                            startButtonPos.X.Offset + delta.X,
                            startButtonPos.Y.Scale,
                            startButtonPos.Y.Offset + delta.Y
                        )
                    end
                end
            end)
            
            -- Handle release
            local releaseConnection
            releaseConnection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isHolding = false
                    dragButtonDragging = false -- Clear global flag
                    
                    if inputChangedConnection then
                        inputChangedConnection:Disconnect()
                        inputChangedConnection = nil
                    end
                    releaseConnection:Disconnect()
                    
                    if not hasMoved then
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
                        -- Was a drag, save position
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

-- FIXED: Minimize button only works when not dragging
minBtn.MouseButton1Click:Connect(function()
    if isMinimized or dragButtonDragging then return end
    
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

-- Sidebar (rest of the code remains the same...)
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 180, 1, -50)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = CONFIG.COLORS.Sidebar
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 16)
sidebarCorner.Parent = sidebar

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

-- Discord Button
local discordBtn = Instance.new("TextButton")
discordBtn.Name = "DiscordBtn"
discordBtn.Size = UDim2.new(1, -85, 0, 22)
discordBtn.Position = UDim2.new(0, 75, 0, 55)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
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

local discordGradient = Instance.new("UIGradient")
discordGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 115, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 101, 242))
})
discordGradient.Rotation = 90
discordGradient.Parent = discordBtn

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
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 12, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = LucideIcons[iconKey] or "•"
    iconLabel.TextColor3 = CONFIG.COLORS.Gray
    iconLabel.TextSize = 18
    iconLabel.Parent = tabButton
    
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
    
    local chevron = Instance.new("TextLabel")
    chevron.Size = UDim2.new(0, 20, 1, 0)
    chevron.Position = UDim2.new(1, -25, 0, 0)
    chevron.BackgroundTransparency = 1
    chevron.Font = Enum.Font.GothamBold
    chevron.Text = LucideIcons.chevronRight
    chevron.TextColor3 = CONFIG.COLORS.DarkGray
    chevron.TextSize = 12
    chevron.Parent = tabButton
    
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

local featuresTab = createTab("Features", "zap", 1)
local gameTab = createTab("Game", "gamepad", 2)
local scriptsTab = createTab("Scripts", "code", 3)
local settingsTab = createTab("Settings", "settings", 4)

-- Server Frame
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

-- Server UI (simplified for brevity)
local serverTitle = Instance.new("TextLabel")
serverTitle.Size = UDim2.new(1, -20, 0, 30)
serverTitle.Position = UDim2.new(0, 10, 0, 10)
serverTitle.BackgroundTransparency = 1
serverTitle.Font = Enum.Font.GothamBold
serverTitle.Text = LucideIcons.users .. " Server Management"
serverTitle.TextColor3 = CONFIG.COLORS.White
serverTitle.TextSize = 20
serverTitle.Parent = serverFrame

-- Profile Button opens Server tab
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
