-- ⚡ ADVANCED ROBLOX GUI SCRIPT - PRODUCTION GRADE
-- Following professional UX/UI design patterns and best practices
-- Features: Key system, smooth animations, polished interactions, responsive design

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- 🎨 THEME & CONFIGURATION
-- ========================================
local THEME = {
    Colors = {
        -- Base colors
        Background = Color3.fromRGB(18, 18, 18),
        BackgroundLight = Color3.fromRGB(25, 25, 25),
        BackgroundDark = Color3.fromRGB(12, 12, 12),
        Surface = Color3.fromRGB(30, 30, 30),
        
        -- Accent colors
        Primary = Color3.fromRGB(59, 130, 246), -- Blue
        PrimaryHover = Color3.fromRGB(96, 165, 250),
        Success = Color3.fromRGB(34, 197, 94), -- Green
        SuccessHover = Color3.fromRGB(74, 222, 128),
        Danger = Color3.fromRGB(239, 68, 68), -- Red
        DangerHover = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36), -- Yellow
        Premium = Color3.fromRGB(168, 85, 247), -- Purple
        PremiumHover = Color3.fromRGB(192, 132, 252),
        
        -- Text colors
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(163, 163, 163),
        TextDisabled = Color3.fromRGB(82, 82, 82),
        
        -- Utility
        Border = Color3.fromRGB(38, 38, 38),
        Overlay = Color3.fromRGB(0, 0, 0),
    },
    
    -- Transparency values
    Transparency = {
        Solid = 0,
        Frame = 0.08,
        Overlay = 0.5,
        Hover = 0.3,
        Disabled = 0.6,
    },
    
    -- Sizing
    Size = {
        CornerRadius = 12,
        StrokeThickness = 2,
        Padding = 10,
        Margin = 15,
        IconSize = 24,
        ButtonHeight = 40,
        HeaderHeight = 50,
    },
    
    -- Animation settings
    Animation = {
        Fast = 0.15,
        Normal = 0.3,
        Slow = 0.5,
        Bounce = Enum.EasingStyle.Back,
        Smooth = Enum.EasingStyle.Quad,
        Elastic = Enum.EasingStyle.Elastic,
    },
}

local CONFIG = {
    CorrectKey = "ROBLOX2025",
    KeySaveFile = "AdvancedGUI_KeyV2",
    DiscordLink = "https://discord.gg/yourserver",
    Version = "v2.0.0",
    LastTab = "LastOpenedTab",
}

-- ========================================
-- 🛠️ UTILITY FUNCTIONS
-- ========================================

-- Tween helper with presets
local function tween(object, properties, duration, style, direction, callback)
    duration = duration or THEME.Animation.Normal
    style = style or THEME.Animation.Smooth
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(object, tweenInfo, properties)
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

-- Create rounded corners
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or THEME.Size.CornerRadius)
    corner.Parent = parent
    return corner
end

-- Create stroke
local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or THEME.Colors.Border
    stroke.Thickness = thickness or THEME.Size.StrokeThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Create padding
local function addPadding(parent, padding)
    local pad = Instance.new("UIPadding")
    local p = padding or THEME.Size.Padding
    pad.PaddingLeft = UDim.new(0, p)
    pad.PaddingRight = UDim.new(0, p)
    pad.PaddingTop = UDim.new(0, p)
    pad.PaddingBottom = UDim.new(0, p)
    pad.Parent = parent
    return pad
end

-- Show notification toast
local function showToast(message, toastType, duration)
    duration = duration or 3
    
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 300, 0, 60)
    toast.Position = UDim2.new(1, -320, 1, 100)
    toast.BackgroundColor3 = THEME.Colors.Surface
    toast.BackgroundTransparency = THEME.Transparency.Frame
    toast.Parent = screenGui
    toast.ZIndex = 1000
    addCorner(toast, 10)
    
    local color = THEME.Colors.Primary
    if toastType == "success" then color = THEME.Colors.Success
    elseif toastType == "error" then color = THEME.Colors.Danger
    elseif toastType == "warning" then color = THEME.Colors.Warning end
    
    addStroke(toast, color, 2)
    addPadding(toast, 15)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 0, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Text = toastType == "success" and "✓" or toastType == "error" and "✕" or "ℹ"
    icon.TextColor3 = color
    icon.TextSize = 20
    icon.Font = Enum.Font.GothamBold
    icon.Parent = toast
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = THEME.Colors.TextPrimary
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toast
    
    -- Slide in animation
    tween(toast, {Position = UDim2.new(1, -320, 1, -80)}, THEME.Animation.Normal, THEME.Animation.Bounce)
    
    -- Auto dismiss
    task.delay(duration, function()
        tween(toast, {
            Position = UDim2.new(1, -320, 1, 100),
            BackgroundTransparency = 1
        }, THEME.Animation.Fast, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
            toast:Destroy()
        end)
    end)
end

-- Make draggable with smooth motion
local function makeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            tween(frame, {Position = newPos}, 0.05, Enum.EasingStyle.Linear)
        end
    end)
end

-- Make resizable
local function makeResizable(frame, minWidth, minHeight)
    minWidth = minWidth or 300
    minHeight = minHeight or 200
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new(1, -16, 1, -16)
    handle.AnchorPoint = Vector2.new(1, 1)
    handle.BackgroundColor3 = THEME.Colors.Primary
    handle.BackgroundTransparency = THEME.Transparency.Hover
    handle.Parent = frame
    handle.ZIndex = frame.ZIndex + 1
    addCorner(handle, 4)
    
    local resizing = false
    local startSize, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            startSize = frame.Size
            startPos = UserInputService:GetMouseLocation()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if resizing then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - startPos
            frame.Size = UDim2.new(
                0, math.max(minWidth, startSize.X.Offset + delta.X),
                0, math.max(minHeight, startSize.Y.Offset + delta.Y)
            )
        end
    end)
    
    -- Hover feedback
    handle.MouseEnter:Connect(function()
        tween(handle, {BackgroundTransparency = 0.1}, THEME.Animation.Fast)
    end)
    
    handle.MouseLeave:Connect(function()
        tween(handle, {BackgroundTransparency = THEME.Transparency.Hover}, THEME.Animation.Fast)
    end)
end

-- Debounce helper
local function debounce(func, wait)
    local lastCall = 0
    return function(...)
        local now = tick()
        if now - lastCall >= wait then
            lastCall = now
            func(...)
        end
    end
end

-- Save data
local function saveData(key, value)
    pcall(function()
        writefile(key .. ".txt", value)
    end)
end

-- Load data
local function loadData(key)
    local success, data = pcall(function()
        return readfile(key .. ".txt")
    end)
    return success and data or nil
end

-- Delete data
local function deleteData(key)
    pcall(function()
        delfile(key .. ".txt")
    end)
end

-- ========================================
-- 🎯 UI COMPONENTS
-- ========================================

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedGUI_V2"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Button component with hover/press effects
local function createButton(config)
    local button = Instance.new("TextButton")
    button.Size = config.size or UDim2.new(0, 120, 0, THEME.Size.ButtonHeight)
    button.Position = config.position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = config.backgroundColor or THEME.Colors.Surface
    button.BackgroundTransparency = THEME.Transparency.Solid
    button.Text = config.text or "Button"
    button.TextColor3 = config.textColor or THEME.Colors.TextPrimary
    button.TextSize = config.textSize or 16
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.Parent = config.parent
    
    addCorner(button, config.cornerRadius or THEME.Size.CornerRadius)
    local stroke = addStroke(button, config.strokeColor or THEME.Colors.Primary, config.strokeThickness)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        if not button:GetAttribute("Disabled") then
            tween(button, {
                BackgroundColor3 = config.hoverColor or THEME.Colors.PrimaryHover,
                BackgroundTransparency = THEME.Transparency.Hover
            }, THEME.Animation.Fast)
            tween(button, {Size = button.Size + UDim2.new(0, 4, 0, 2)}, THEME.Animation.Fast)
        end
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {
            BackgroundColor3 = config.backgroundColor or THEME.Colors.Surface,
            BackgroundTransparency = THEME.Transparency.Solid
        }, THEME.Animation.Fast)
        tween(button, {Size = config.size or UDim2.new(0, 120, 0, THEME.Size.ButtonHeight)}, THEME.Animation.Fast)
    end)
    
    -- Press effect
    button.MouseButton1Down:Connect(function()
        if not button:GetAttribute("Disabled") then
            tween(button, {Size = (config.size or UDim2.new(0, 120, 0, THEME.Size.ButtonHeight)) - UDim2.new(0, 2, 0, 2)}, 0.05)
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        if not button:GetAttribute("Disabled") then
            tween(button, {Size = config.size or UDim2.new(0, 120, 0, THEME.Size.ButtonHeight)}, 0.05)
        end
    end)
    
    return button, stroke
end

-- Animated glow effect
local function createGlowEffect(parent, color, intensity)
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = color or THEME.Colors.Primary
    glowStroke.Thickness = intensity or 8
    glowStroke.Transparency = 0.7
    glowStroke.Parent = glow
    
    addCorner(glow, THEME.Size.CornerRadius + 4)
    
    -- Pulse animation
    local function pulse()
        while glow.Parent do
            tween(glowStroke, {Transparency = 0.4}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
            tween(glowStroke, {Transparency = 0.8}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
        end
    end
    
    task.spawn(pulse)
    
    return glow
end

-- ========================================
-- 🔐 KEY SYSTEM
-- ========================================

local function createKeySystem()
    -- Background overlay
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = THEME.Colors.Overlay
    overlay.BackgroundTransparency = THEME.Transparency.Overlay
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui
    overlay.ZIndex = 1
    
    -- Key frame
    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "KeyFrame"
    keyFrame.Size = UDim2.new(0, 420, 0, 280)
    keyFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
    keyFrame.BackgroundColor3 = THEME.Colors.Background
    keyFrame.BackgroundTransparency = THEME.Transparency.Frame
    keyFrame.Parent = screenGui
    keyFrame.ZIndex = 2
    addCorner(keyFrame, 16)
    addStroke(keyFrame, THEME.Colors.Primary, 3)
    
    -- Glow effect
    createGlowEffect(keyFrame, THEME.Colors.Primary, 12)
    
    -- Header section
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundTransparency = 1
    header.Parent = keyFrame
    header.ZIndex = 3
    
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Size = UDim2.new(0, 50, 0, 50)
    titleIcon.Position = UDim2.new(0.5, -25, 0, 15)
    titleIcon.BackgroundColor3 = THEME.Colors.Primary
    titleIcon.BackgroundTransparency = 0.2
    titleIcon.Text = "🔐"
    titleIcon.TextSize = 28
    titleIcon.Parent = header
    titleIcon.ZIndex = 4
    addCorner(titleIcon, 12)
    
    -- Floating animation for icon
    task.spawn(function()
        while titleIcon.Parent do
            tween(titleIcon, {Position = UDim2.new(0.5, -25, 0, 10)}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
            tween(titleIcon, {Position = UDim2.new(0.5, -25, 0, 20)}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
        end
    end)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 25)
    title.Position = UDim2.new(0, 20, 0, 55)
    title.BackgroundTransparency = 1
    title.Text = "KEY VERIFICATION"
    title.TextColor3 = THEME.Colors.TextPrimary
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = header
    title.ZIndex = 4
    
    -- Input section
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, -40, 0, 50)
    inputContainer.Position = UDim2.new(0, 20, 0, 95)
    inputContainer.BackgroundColor3 = THEME.Colors.BackgroundDark
    inputContainer.BackgroundTransparency = 0.3
    inputContainer.Parent = keyFrame
    inputContainer.ZIndex = 3
    addCorner(inputContainer, 10)
    addStroke(inputContainer, THEME.Colors.Border, 1)
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.PlaceholderColor3 = THEME.Colors.TextSecondary
    keyInput.Text = ""
    keyInput.TextColor3 = THEME.Colors.TextPrimary
    keyInput.TextSize = 16
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = inputContainer
    keyInput.ZIndex = 4
    
    -- Focus effect
    keyInput.Focused:Connect(function()
        tween(inputContainer:FindFirstChildOfClass("UIStroke"), 
            {Color = THEME.Colors.Primary, Thickness = 2}, 
            THEME.Animation.Fast)
    end)
    
    keyInput.FocusLost:Connect(function()
        tween(inputContainer:FindFirstChildOfClass("UIStroke"), 
            {Color = THEME.Colors.Border, Thickness = 1}, 
            THEME.Animation.Fast)
    end)
    
    -- Button container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -40, 0, 50)
    buttonContainer.Position = UDim2.new(0, 20, 0, 160)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = keyFrame
    buttonContainer.ZIndex = 3
    
    -- Verify button
    local verifyBtn = createButton({
        size = UDim2.new(0.48, 0, 0, 45),
        position = UDim2.new(0, 0, 0, 0),
        text = "✓ Verify",
        strokeColor = THEME.Colors.Success,
        hoverColor = THEME.Colors.Success,
        parent = buttonContainer
    })
    verifyBtn.ZIndex = 4
    
    -- Get Key button
    local getKeyBtn = createButton({
        size = UDim2.new(0.48, 0, 0, 45),
        position = UDim2.new(0.52, 0, 0, 0),
        text = "🔗 Get Key",
        strokeColor = THEME.Colors.Premium,
        hoverColor = THEME.Colors.Premium,
        parent = buttonContainer
    })
    getKeyBtn.ZIndex = 4
    
    -- Info label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 30)
    infoLabel.Position = UDim2.new(0, 20, 1, -40)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🎁 Key is 100% FREE in our Discord!"
    infoLabel.TextColor3 = THEME.Colors.Primary
    infoLabel.TextSize = 13
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.Parent = keyFrame
    infoLabel.ZIndex = 4
    
    -- Entrance animation
    keyFrame.Size = UDim2.new(0, 0, 0, 0)
    overlay.BackgroundTransparency = 1
    tween(overlay, {BackgroundTransparency = THEME.Transparency.Overlay}, THEME.Animation.Normal)
    tween(keyFrame, {Size = UDim2.new(0, 420, 0, 280)}, THEME.Animation.Slow, THEME.Animation.Bounce)
    
    return keyFrame, overlay, verifyBtn, getKeyBtn, keyInput, infoLabel
end

-- ========================================
-- 🏠 MAIN GUI
-- ========================================

local function createMainGUI()
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    mainFrame.BackgroundColor3 = THEME.Colors.Background
    mainFrame.BackgroundTransparency = THEME.Transparency.Frame
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    mainFrame.ZIndex = 10
    addCorner(mainFrame, 16)
    addStroke(mainFrame, THEME.Colors.Primary, 3)
    
    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, THEME.Size.HeaderHeight)
    topBar.BackgroundColor3 = THEME.Colors.BackgroundDark
    topBar.BackgroundTransparency = 0.2
    topBar.Parent = mainFrame
    topBar.ZIndex = 11
    addCorner(topBar, 16)
    
    -- Title with icon
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(0, 200, 1, 0)
    titleContainer.Position = UDim2.new(0, 15, 0, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.Parent = topBar
    titleContainer.ZIndex = 12
    
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Size = UDim2.new(0, 30, 0, 30)
    titleIcon.Position = UDim2.new(0, 0, 0.5, -15)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = "⚡"
    titleIcon.TextColor3 = THEME.Colors.Primary
    titleIcon.TextSize = 22
    titleIcon.Font = Enum.Font.GothamBold
    titleIcon.Parent = titleContainer
    titleIcon.ZIndex = 13
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -35, 1, 0)
    titleLabel.Position = UDim2.new(0, 35, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Advanced GUI"
    titleLabel.TextColor3 = THEME.Colors.TextPrimary
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleContainer
    titleLabel.ZIndex = 13
    
    -- Version badge
    local versionBadge = Instance.new("TextLabel")
    versionBadge.Size = UDim2.new(0, 50, 0, 20)
    versionBadge.Position = UDim2.new(0, 160, 0.5, -10)
    versionBadge.BackgroundColor3 = THEME.Colors.Primary
    versionBadge.BackgroundTransparency = 0.3
    versionBadge.Text = CONFIG.Version
    versionBadge.TextColor3 = THEME.Colors.TextPrimary
    versionBadge.TextSize = 10
    versionBadge.Font = Enum.Font.GothamBold
    versionBadge.Parent = topBar
    versionBadge.ZIndex = 13
    addCorner(versionBadge, 6)
    
    -- Control buttons
    local controlsContainer = Instance.new("Frame")
    controlsContainer.Size = UDim2.new(0, 75, 0, 35)
    controlsContainer.Position = UDim2.new(1, -85, 0.5, -17.5)
    controlsContainer.BackgroundTransparency = 1
    controlsContainer.Parent = topBar
    controlsContainer.ZIndex = 12
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
    minimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    minimizeBtn.BackgroundColor3 = THEME.Colors.Surface
    minimizeBtn.BackgroundTransparency = 0.3
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = THEME.Colors.Primary
    minimizeBtn.TextSize = 18
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = controlsContainer
    minimizeBtn.ZIndex = 13
    addCorner(minimizeBtn, 8)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(0, 40, 0, 0)
    closeBtn.BackgroundColor3 = THEME.Colors.Surface
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = THEME.Colors.Danger
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = controlsContainer
    closeBtn.ZIndex = 13
    addCorner(closeBtn, 8)
    
    -- Button hover effects
    for _, btn in pairs({minimizeBtn, closeBtn}) do
        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundTransparency = 0.1}, THEME.Animation.Fast)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundTransparency = 0.3}, THEME.Animation.Fast)
        end)
    end
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 140, 1, -THEME.Size.HeaderHeight - 10)
    sidebar.Position = UDim2.new(0, 10, 0, THEME.Size.HeaderHeight + 5)
    sidebar.BackgroundColor3 = THEME.Colors.BackgroundLight
    sidebar.BackgroundTransparency = 0.3
    sidebar.Parent = mainFrame
    sidebar.ZIndex = 11
    addCorner(sidebar, 12)
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -165, 1, -THEME.Size.HeaderHeight - 10)
    contentArea.Position = UDim2.new(0, 155, 0, THEME.Size.HeaderHeight + 5)
    contentArea.BackgroundColor3 = THEME.Colors.BackgroundLight
    contentArea.BackgroundTransparency = 0.3
    contentArea.Parent = mainFrame
    contentArea.ZIndex = 11
    addCorner(contentArea, 12)
    
    makeDraggable(mainFrame, topBar)
    makeResizable(mainFrame, 600, 400)
    
    return mainFrame, sidebar, contentArea, minimizeBtn, closeBtn
end

-- ========================================
-- 📑 TAB SYSTEM
-- ========================================

local function createTabSystem(sidebar, contentArea)
    local tabs = {
        {name = "Home", icon = "🏠", color = THEME.Colors.Primary},
        {name = "Scripts", icon = "📜", color = THEME.Colors.Success},
        {name = "Player", icon = "👤", color = THEME.Colors.Warning},
        {name = "Settings", icon = "⚙️", color = THEME.Colors.Premium},
    }
    
    local tabButtons = {}
    local contentPages = {}
    local activeTab = nil
    
    -- Create tabs
    for i, tabData in ipairs(tabs) do
        -- Tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabData.name .. "Tab"
        tabBtn.Size = UDim2.new(1, -10, 0, 45)
        tabBtn.Position = UDim2.new(0, 5, 0, (i - 1) * 50 + 5)
        tabBtn.BackgroundColor3 = THEME.Colors.Surface
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.Parent = sidebar
        tabBtn.ZIndex = 12
        addCorner(tabBtn, 10)
        
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size = UDim2.new(0, 25, 0, 25)
        tabIcon.Position = UDim2.new(0, 10, 0.5, -12.5)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tabData.icon
        tabIcon.TextColor3 = THEME.Colors.TextSecondary
        tabIcon.TextSize = 18
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.Parent = tabBtn
        tabIcon.ZIndex = 13
        
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -45, 1, 0)
        tabLabel.Position = UDim2.new(0, 40, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabData.name
        tabLabel.TextColor3 = THEME.Colors.TextSecondary
        tabLabel.TextSize = 14
        tabLabel.Font = Enum.Font.GothamBold
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.Parent = tabBtn
        tabLabel.ZIndex = 13
        
        -- Content page
        local contentPage = Instance.new("ScrollingFrame")
        contentPage.Name = tabData.name .. "Page"
        contentPage.Size = UDim2.new(1, -20, 1, -20)
        contentPage.Position = UDim2.new(0, 10, 0, 10)
        contentPage.BackgroundTransparency = 1
        contentPage.BorderSizePixel = 0
        contentPage.ScrollBarThickness = 6
        contentPage.ScrollBarImageColor3 = THEME.Colors.Primary
        contentPage.ScrollBarImageTransparency = 0.5
        contentPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        contentPage.Visible = false
        contentPage.Parent = contentArea
        contentPage.ZIndex = 12
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 10)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = contentPage
        
        table.insert(tabButtons, {btn = tabBtn, icon = tabIcon, label = tabLabel, data = tabData})
        table.insert(contentPages, contentPage)
        
        -- Tab click handler with debounce
        tabBtn.MouseButton1Click:Connect(debounce(function()
            if activeTab == i then return end
            
            -- Deactivate previous tab
            if activeTab then
                local prevBtn = tabButtons[activeTab]
                tween(prevBtn.btn, {BackgroundTransparency = 0.5}, THEME.Animation.Fast)
                tween(prevBtn.icon, {TextColor3 = THEME.Colors.TextSecondary}, THEME.Animation.Fast)
                tween(prevBtn.label, {TextColor3 = THEME.Colors.TextSecondary}, THEME.Animation.Fast)
                
                -- Slide out animation
                local prevPage = contentPages[activeTab]
                tween(prevPage, {Position = UDim2.new(-1, 10, 0, 10)}, THEME.Animation.Fast, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
                    prevPage.Visible = false
                    prevPage.Position = UDim2.new(0, 10, 0, 10)
                end)
            end
            
            -- Activate new tab
            activeTab = i
            local currentBtn = tabButtons[i]
            tween(currentBtn.btn, {BackgroundTransparency = 0.1}, THEME.Animation.Fast)
            tween(currentBtn.icon, {TextColor3 = tabData.color}, THEME.Animation.Fast)
            tween(currentBtn.label, {TextColor3 = THEME.Colors.TextPrimary}, THEME.Animation.Fast)
            
            -- Slide in animation
            local currentPage = contentPages[i]
            currentPage.Position = UDim2.new(1, 10, 0, 10)
            currentPage.Visible = true
            tween(currentPage, {Position = UDim2.new(0, 10, 0, 10)}, THEME.Animation.Normal, THEME.Animation.Smooth)
            
            -- Save last opened tab
            saveData(CONFIG.LastTab, tabData.name)
            
            showToast("Switched to " .. tabData.name, "success", 1.5)
        end, 0.3))
        
        -- Hover effects
        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= i then
                tween(tabBtn, {BackgroundTransparency = 0.3}, THEME.Animation.Fast)
            end
        end)
        
        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= i then
                tween(tabBtn, {BackgroundTransparency = 0.5}, THEME.Animation.Fast)
            end
        end)
    end
    
    -- Set initial tab (restore last opened or default to Home)
    local lastTab = loadData(CONFIG.LastTab)
    local initialTab = 1
    
    if lastTab then
        for i, tabData in ipairs(tabs) do
            if tabData.name == lastTab then
                initialTab = i
                break
            end
        end
    end
    
    task.wait(0.1)
    tabButtons[initialTab].btn.MouseButton1Click:Fire()
    
    return tabButtons, contentPages
end

-- ========================================
-- 📝 POPULATE CONTENT
-- ========================================

local function populateContent(contentPages, mainFrame)
    -- Home page
    local homePage = contentPages[1]
    
    local welcomeCard = Instance.new("Frame")
    welcomeCard.Size = UDim2.new(1, 0, 0, 120)
    welcomeCard.BackgroundColor3 = THEME.Colors.Surface
    welcomeCard.BackgroundTransparency = 0.3
    welcomeCard.Parent = homePage
    welcomeCard.ZIndex = 13
    addCorner(welcomeCard, 12)
    addStroke(welcomeCard, THEME.Colors.Primary, 2)
    addPadding(welcomeCard, 20)
    
    local welcomeTitle = Instance.new("TextLabel")
    welcomeTitle.Size = UDim2.new(1, 0, 0, 30)
    welcomeTitle.BackgroundTransparency = 1
    welcomeTitle.Text = "👋 Welcome back, " .. player.Name .. "!"
    welcomeTitle.TextColor3 = THEME.Colors.TextPrimary
    welcomeTitle.TextSize = 20
    welcomeTitle.Font = Enum.Font.GothamBold
    welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
    welcomeTitle.Parent = welcomeCard
    welcomeTitle.ZIndex = 14
    
    local welcomeDesc = Instance.new("TextLabel")
    welcomeDesc.Size = UDim2.new(1, 0, 1, -35)
    welcomeDesc.Position = UDim2.new(0, 0, 0, 35)
    welcomeDesc.BackgroundTransparency = 1
    welcomeDesc.Text = "Your advanced GUI is ready! Explore the tabs to access all features. Everything is optimized for the best experience."
    welcomeDesc.TextColor3 = THEME.Colors.TextSecondary
    welcomeDesc.TextSize = 14
    welcomeDesc.Font = Enum.Font.Gotham
    welcomeDesc.TextWrapped = true
    welcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
    welcomeDesc.TextYAlignment = Enum.TextYAlignment.Top
    welcomeDesc.Parent = welcomeCard
    welcomeDesc.ZIndex = 14
    
    -- Quick stats
    local statsContainer = Instance.new("Frame")
    statsContainer.Size = UDim2.new(1, 0, 0, 80)
    statsContainer.BackgroundTransparency = 1
    statsContainer.Parent = homePage
    statsContainer.ZIndex = 13
    
    local stats = {
        {label = "Status", value = "🟢 Active", color = THEME.Colors.Success},
        {label = "Version", value = CONFIG.Version, color = THEME.Colors.Primary},
        {label = "User", value = player.Name, color = THEME.Colors.Warning},
    }
    
    for i, stat in ipairs(stats) do
        local statCard = Instance.new("Frame")
        statCard.Size = UDim2.new(0.32, -5, 1, 0)
        statCard.Position = UDim2.new((i-1) * 0.34, 0, 0, 0)
        statCard.BackgroundColor3 = THEME.Colors.Surface
        statCard.BackgroundTransparency = 0.3
        statCard.Parent = statsContainer
        statCard.ZIndex = 14
        addCorner(statCard, 10)
        addStroke(statCard, stat.color, 1)
        
        local statLabel = Instance.new("TextLabel")
        statLabel.Size = UDim2.new(1, -10, 0, 20)
        statLabel.Position = UDim2.new(0, 5, 0, 10)
        statLabel.BackgroundTransparency = 1
        statLabel.Text = stat.label
        statLabel.TextColor3 = THEME.Colors.TextSecondary
        statLabel.TextSize = 12
        statLabel.Font = Enum.Font.Gotham
        statLabel.Parent = statCard
        statLabel.ZIndex = 15
        
        local statValue = Instance.new("TextLabel")
        statValue.Size = UDim2.new(1, -10, 0, 25)
        statValue.Position = UDim2.new(0, 5, 0, 35)
        statValue.BackgroundTransparency = 1
        statValue.Text = stat.value
        statValue.TextColor3 = stat.color
        statValue.TextSize = 16
        statValue.Font = Enum.Font.GothamBold
        statValue.TextTruncate = Enum.TextTruncate.AtEnd
        statValue.Parent = statCard
        statValue.ZIndex = 15
    end
    
    -- Scripts page
    local scriptsPage = contentPages[2]
    
    local scriptExample = Instance.new("Frame")
    scriptExample.Size = UDim2.new(1, 0, 0, 80)
    scriptExample.BackgroundColor3 = THEME.Colors.Surface
    scriptExample.BackgroundTransparency = 0.3
    scriptExample.Parent = scriptsPage
    scriptExample.ZIndex = 13
    addCorner(scriptExample, 12)
    addPadding(scriptExample, 15)
    
    local scriptTitle = Instance.new("TextLabel")
    scriptTitle.Size = UDim2.new(1, -90, 0, 25)
    scriptTitle.BackgroundTransparency = 1
    scriptTitle.Text = "📜 Example Script"
    scriptTitle.TextColor3 = THEME.Colors.TextPrimary
    scriptTitle.TextSize = 16
    scriptTitle.Font = Enum.Font.GothamBold
    scriptTitle.TextXAlignment = Enum.TextXAlignment.Left
    scriptTitle.Parent = scriptExample
    scriptTitle.ZIndex = 14
    
    local scriptDesc = Instance.new("TextLabel")
    scriptDesc.Size = UDim2.new(1, -90, 1, -30)
    scriptDesc.Position = UDim2.new(0, 0, 0, 28)
    scriptDesc.BackgroundTransparency = 1
    scriptDesc.Text = "Add your custom scripts and features here."
    scriptDesc.TextColor3 = THEME.Colors.TextSecondary
    scriptDesc.TextSize = 12
    scriptDesc.Font = Enum.Font.Gotham
    scriptDesc.TextWrapped = true
    scriptDesc.TextXAlignment = Enum.TextXAlignment.Left
    scriptDesc.TextYAlignment = Enum.TextYAlignment.Top
    scriptDesc.Parent = scriptExample
    scriptDesc.ZIndex = 14
    
    local executeBtn = createButton({
        size = UDim2.new(0, 80, 0, 35),
        position = UDim2.new(1, -80, 0.5, -17.5),
        text = "Execute",
        strokeColor = THEME.Colors.Success,
        hoverColor = THEME.Colors.Success,
        textSize = 13,
        parent = scriptExample
    })
    executeBtn.ZIndex = 14
    
    executeBtn.MouseButton1Click:Connect(function()
        showToast("Script executed!", "success")
    end)
    
    -- Player page
    local playerPage = contentPages[3]
    
    local playerInfo = Instance.new("Frame")
    playerInfo.Size = UDim2.new(1, 0, 0, 150)
    playerInfo.BackgroundColor3 = THEME.Colors.Surface
    playerInfo.BackgroundTransparency = 0.3
    playerInfo.Parent = playerPage
    playerInfo.ZIndex = 13
    addCorner(playerInfo, 12)
    addPadding(playerInfo, 20)
    
    local playerTitle = Instance.new("TextLabel")
    playerTitle.Size = UDim2.new(1, 0, 0, 30)
    playerTitle.BackgroundTransparency = 1
    playerTitle.Text = "👤 Player Information"
    playerTitle.TextColor3 = THEME.Colors.TextPrimary
    playerTitle.TextSize = 18
    playerTitle.Font = Enum.Font.GothamBold
    playerTitle.TextXAlignment = Enum.TextXAlignment.Left
    playerTitle.Parent = playerInfo
    playerTitle.ZIndex = 14
    
    local playerDetails = {
        "Username: " .. player.Name,
        "Display Name: " .. player.DisplayName,
        "User ID: " .. player.UserId,
    }
    
    for i, detail in ipairs(playerDetails) do
        local detailLabel = Instance.new("TextLabel")
        detailLabel.Size = UDim2.new(1, 0, 0, 20)
        detailLabel.Position = UDim2.new(0, 0, 0, 35 + (i * 25))
        detailLabel.BackgroundTransparency = 1
        detailLabel.Text = detail
        detailLabel.TextColor3 = THEME.Colors.TextSecondary
        detailLabel.TextSize = 14
        detailLabel.Font = Enum.Font.Gotham
        detailLabel.TextXAlignment = Enum.TextXAlignment.Left
        detailLabel.Parent = playerInfo
        detailLabel.ZIndex = 14
    end
    
    -- Settings page with reset key
    local settingsPage = contentPages[4]
    
    local settingsCard = Instance.new("Frame")
    settingsCard.Size = UDim2.new(1, 0, 0, 100)
    settingsCard.BackgroundColor3 = THEME.Colors.Surface
    settingsCard.BackgroundTransparency = 0.3
    settingsCard.Parent = settingsPage
    settingsCard.ZIndex = 13
    addCorner(settingsCard, 12)
    addPadding(settingsCard, 20)
    
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 25)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "⚙️ General Settings"
    settingsTitle.TextColor3 = THEME.Colors.TextPrimary
    settingsTitle.TextSize = 16
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    settingsTitle.Parent = settingsCard
    settingsTitle.ZIndex = 14
    
    local settingsDesc = Instance.new("TextLabel")
    settingsDesc.Size = UDim2.new(1, 0, 1, -30)
    settingsDesc.Position = UDim2.new(0, 0, 0, 28)
    settingsDesc.BackgroundTransparency = 1
    settingsDesc.Text = "Configure your GUI preferences and manage your account."
    settingsDesc.TextColor3 = THEME.Colors.TextSecondary
    settingsDesc.TextSize = 13
    settingsDesc.Font = Enum.Font.Gotham
    settingsDesc.TextWrapped = true
    settingsDesc.TextXAlignment = Enum.TextXAlignment.Left
    settingsDesc.TextYAlignment = Enum.TextYAlignment.Top
    settingsDesc.Parent = settingsCard
    settingsDesc.ZIndex = 14
    
    -- Reset Key Section
    local resetKeyCard = Instance.new("Frame")
    resetKeyCard.Size = UDim2.new(1, 0, 0, 110)
    resetKeyCard.BackgroundColor3 = THEME.Colors.Surface
    resetKeyCard.BackgroundTransparency = 0.3
    resetKeyCard.Parent = settingsPage
    resetKeyCard.ZIndex = 13
    addCorner(resetKeyCard, 12)
    addStroke(resetKeyCard, THEME.Colors.Danger, 1)
    addPadding(resetKeyCard, 20)
    
    local resetTitle = Instance.new("TextLabel")
    resetTitle.Size = UDim2.new(1, -100, 0, 25)
    resetTitle.BackgroundTransparency = 1
    resetTitle.Text = "🔑 Reset Verification Key"
    resetTitle.TextColor3 = THEME.Colors.TextPrimary
    resetTitle.TextSize = 16
    resetTitle.Font = Enum.Font.GothamBold
    resetTitle.TextXAlignment = Enum.TextXAlignment.Left
    resetTitle.Parent = resetKeyCard
    resetTitle.ZIndex = 14
    
    local resetDesc = Instance.new("TextLabel")
    resetDesc.Size = UDim2.new(1, -100, 0, 40)
    resetDesc.Position = UDim2.new(0, 0, 0, 28)
    resetDesc.BackgroundTransparency = 1
    resetDesc.Text = "Clear your saved key and return to the verification screen. You'll need to enter a valid key again."
    resetDesc.TextColor3 = THEME.Colors.TextSecondary
    resetDesc.TextSize = 12
    resetDesc.Font = Enum.Font.Gotham
    resetDesc.TextWrapped = true
    resetDesc.TextXAlignment = Enum.TextXAlignment.Left
    resetDesc.TextYAlignment = Enum.TextYAlignment.Top
    resetDesc.Parent = resetKeyCard
    resetDesc.ZIndex = 14
    
    local resetKeyBtn = createButton({
        size = UDim2.new(0, 100, 0, 40),
        position = UDim2.new(1, -100, 0.5, -20),
        text = "Reset Key",
        strokeColor = THEME.Colors.Danger,
        hoverColor = THEME.Colors.Danger,
        textSize = 14,
        parent = resetKeyCard
    })
    resetKeyBtn.ZIndex = 14
    
    -- Reset key functionality
    resetKeyBtn.MouseButton1Click:Connect(debounce(function()
        -- Confirmation dialog
        local confirmOverlay = Instance.new("Frame")
        confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
        confirmOverlay.BackgroundColor3 = THEME.Colors.Overlay
        confirmOverlay.BackgroundTransparency = 1
        confirmOverlay.Parent = screenGui
        confirmOverlay.ZIndex = 100
        
        local confirmFrame = Instance.new("Frame")
        confirmFrame.Size = UDim2.new(0, 400, 0, 220)
        confirmFrame.Position = UDim2.new(0.5, -200, 0.5, -110)
        confirmFrame.BackgroundColor3 = THEME.Colors.Background
        confirmFrame.BackgroundTransparency = THEME.Transparency.Frame
        confirmFrame.Parent = confirmOverlay
        confirmFrame.ZIndex = 101
        addCorner(confirmFrame, 16)
        addStroke(confirmFrame, THEME.Colors.Danger, 3)
        
        createGlowEffect(confirmFrame, THEME.Colors.Danger, 10)
        
        local confirmHeader = Instance.new("TextLabel")
        confirmHeader.Size = UDim2.new(1, -40, 0, 40)
        confirmHeader.Position = UDim2.new(0, 20, 0, 20)
        confirmHeader.BackgroundTransparency = 1
        confirmHeader.Text = "⚠️ Confirm Key Reset"
        confirmHeader.TextColor3 = THEME.Colors.TextPrimary
        confirmHeader.TextSize = 20
        confirmHeader.Font = Enum.Font.GothamBold
        confirmHeader.Parent = confirmFrame
        confirmHeader.ZIndex = 102
        
        local confirmDesc = Instance.new("TextLabel")
        confirmDesc.Size = UDim2.new(1, -40, 0, 70)
        confirmDesc.Position = UDim2.new(0, 20, 0, 65)
        confirmDesc.BackgroundTransparency = 1
        confirmDesc.Text = "This will delete your saved key and close the GUI. You'll need to verify again when you re-execute the script.\n\nAre you sure you want to continue?"
        confirmDesc.TextColor3 = THEME.Colors.TextSecondary
        confirmDesc.TextSize = 13
        confirmDesc.Font = Enum.Font.Gotham
        confirmDesc.TextWrapped = true
        confirmDesc.TextXAlignment = Enum.TextXAlignment.Left
        confirmDesc.TextYAlignment = Enum.TextYAlignment.Top
        confirmDesc.Parent = confirmFrame
        confirmDesc.ZIndex = 102
        
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(1, -40, 0, 45)
        buttonContainer.Position = UDim2.new(0, 20, 1, -60)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = confirmFrame
        buttonContainer.ZIndex = 102
        
        local cancelBtn = createButton({
            size = UDim2.new(0.48, 0, 1, 0),
            position = UDim2.new(0, 0, 0, 0),
            text = "Cancel",
            strokeColor = THEME.Colors.Success,
            hoverColor = THEME.Colors.Success,
            parent = buttonContainer
        })
        cancelBtn.ZIndex = 103
        
        local confirmBtn = createButton({
            size = UDim2.new(0.48, 0, 1, 0),
            position = UDim2.new(0.52, 0, 0, 0),
            text = "Yes, Reset",
            strokeColor = THEME.Colors.Danger,
            hoverColor = THEME.Colors.Danger,
            parent = buttonContainer
        })
        confirmBtn.ZIndex = 103
        
        -- Animate in
        confirmFrame.Size = UDim2.new(0, 0, 0, 0)
        tween(confirmOverlay, {BackgroundTransparency = THEME.Transparency.Overlay}, THEME.Animation.Fast)
        tween(confirmFrame, {Size = UDim2.new(0, 400, 0, 220)}, THEME.Animation.Normal, THEME.Animation.Bounce)
        
        cancelBtn.MouseButton1Click:Connect(function()
            tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
            tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
                confirmOverlay:Destroy()
            end)
        end)
        
        confirmBtn.MouseButton1Click:Connect(function()
            deleteData(CONFIG.KeySaveFile)
            showToast("Key has been reset!", "success")
            
            tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
            tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast)
            
            task.wait(0.3)
            
            tween(mainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Rotation = 180
            }, THEME.Animation.Slow, THEME.Animation.Bounce, Enum.EasingDirection.In, function()
                screenGui:Destroy()
                
                -- Notify user
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Key Reset Complete",
                    Text = "Please re-execute the script to verify again.",
                    Duration = 5,
                })
            end)
        end)
    end, 0.5))
end

-- ========================================
-- 🔄 MINIMIZE SYSTEM
-- ========================================

local function createMinimizedButton()
    local miniBtn = Instance.new("ImageButton")
    miniBtn.Name = "MinimizedButton"
    miniBtn.Size = UDim2.new(0, 70, 0, 70)
    miniBtn.Position = UDim2.new(0, 20, 0.5, -35)
    miniBtn.BackgroundColor3 = THEME.Colors.Background
    miniBtn.BackgroundTransparency = THEME.Transparency.Frame
    miniBtn.Visible = false
    miniBtn.Parent = screenGui
    miniBtn.ZIndex = 50
    miniBtn.AutoButtonColor = false
    addCorner(miniBtn, 16)
    addStroke(miniBtn, THEME.Colors.Primary, 3)
    
    createGlowEffect(miniBtn, THEME.Colors.Primary, 8)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextColor3 = THEME.Colors.Primary
    icon.TextSize = 32
    icon.Font = Enum.Font.GothamBold
    icon.Parent = miniBtn
    icon.ZIndex = 51
    
    makeDraggable(miniBtn)
    
    -- Hover effect
    miniBtn.MouseEnter:Connect(function()
        tween(miniBtn, {Size = UDim2.new(0, 75, 0, 75)}, THEME.Animation.Fast)
        tween(icon, {Rotation = 10}, THEME.Animation.Fast)
    end)
    
    miniBtn.MouseLeave:Connect(function()
        tween(miniBtn, {Size = UDim2.new(0, 70, 0, 70)}, THEME.Animation.Fast)
        tween(icon, {Rotation = 0}, THEME.Animation.Fast)
    end)
    
    return miniBtn
end

-- ========================================
-- 🎬 MAIN INITIALIZATION
-- ========================================

local function initialize()
    local savedKey = loadData(CONFIG.KeySaveFile)
    
    if savedKey == CONFIG.CorrectKey then
        -- Key already verified
        showToast("Welcome back! Loading GUI...", "success")
        
        task.wait(0.5)
        
        local mainFrame, sidebar, contentArea, minimizeBtn, closeBtn = createMainGUI()
        local miniBtn = createMinimizedButton()
        local tabButtons, contentPages = createTabSystem(sidebar, contentArea)
        populateContent(contentPages, mainFrame)
        
        -- Show animation
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Visible = true
        tween(mainFrame, {Size = UDim2.new(0, 700, 0, 450)}, THEME.Animation.Slow, THEME.Animation.Bounce)
        
        -- Minimize functionality
        minimizeBtn.MouseButton1Click:Connect(debounce(function()
            showToast("GUI minimized", "success", 1.5)
            tween(mainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Rotation = -180
            }, THEME.Animation.Normal, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
                mainFrame.Visible = false
                mainFrame.Rotation = 0
                miniBtn.Visible = true
                tween(miniBtn, {Size = UDim2.new(0, 70, 0, 70)}, THEME.Animation.Fast)
            end)
        end, 0.5))
        
        -- Restore from minimize
        miniBtn.MouseButton1Click:Connect(debounce(function()
            miniBtn.Visible = false
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            tween(mainFrame, {Size = UDim2.new(0, 700, 0, 450)}, THEME.Animation.Normal, THEME.Animation.Bounce)
            showToast("Welcome back!", "success", 1.5)
        end, 0.5))
        
        -- Close functionality with confirmation
        closeBtn.MouseButton1Click:Connect(debounce(function()
            local confirmOverlay = Instance.new("Frame")
            confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
            confirmOverlay.BackgroundColor3 = THEME.Colors.Overlay
            confirmOverlay.BackgroundTransparency = 1
            confirmOverlay.Parent = screenGui
            confirmOverlay.ZIndex = 200
            
            local confirmFrame = Instance.new("Frame")
            confirmFrame.Size = UDim2.new(0, 380, 0, 200)
            confirmFrame.Position = UDim2.new(0.5, -190, 0.5, -100)
            confirmFrame.BackgroundColor3 = THEME.Colors.Background
            confirmFrame.BackgroundTransparency = THEME.Transparency.Frame
            confirmFrame.Parent = confirmOverlay
            confirmFrame.ZIndex = 201
            addCorner(confirmFrame, 16)
            addStroke(confirmFrame, THEME.Colors.Danger, 3)
            
            createGlowEffect(confirmFrame, THEME.Colors.Danger, 10)
            
            local header = Instance.new("TextLabel")
            header.Size = UDim2.new(1, -40, 0, 40)
            header.Position = UDim2.new(0, 20, 0, 20)
            header.BackgroundTransparency = 1
            header.Text = "⚠️ Close GUI?"
            header.TextColor3 = THEME.Colors.TextPrimary
            header.TextSize = 20
            header.Font = Enum.Font.GothamBold
            header.Parent = confirmFrame
            header.ZIndex = 202
            
            local desc = Instance.new("TextLabel")
            desc.Size = UDim2.new(1, -40, 0, 50)
            desc.Position = UDim2.new(0, 20, 0, 65)
            desc.BackgroundTransparency = 1
            desc.Text = "Are you sure you want to close the GUI?\nYou can always re-execute the script."
            desc.TextColor3 = THEME.Colors.TextSecondary
            desc.TextSize = 13
            desc.Font = Enum.Font.Gotham
            desc.TextWrapped = true
            desc.TextXAlignment = Enum.TextXAlignment.Left
            desc.TextYAlignment = Enum.TextYAlignment.Top
            desc.Parent = confirmFrame
            desc.ZIndex = 202
            
            local buttonContainer = Instance.new("Frame")
            buttonContainer.Size = UDim2.new(1, -40, 0, 45)
            buttonContainer.Position = UDim2.new(0, 20, 1, -60)
            buttonContainer.BackgroundTransparency = 1
            buttonContainer.Parent = confirmFrame
            buttonContainer.ZIndex = 202
            
            local noBtn = createButton({
                size = UDim2.new(0.48, 0, 1, 0),
                position = UDim2.new(0, 0, 0, 0),
                text = "No, Stay",
                strokeColor = THEME.Colors.Success,
                hoverColor = THEME.Colors.Success,
                parent = buttonContainer
            })
            noBtn.ZIndex = 203
            
            local yesBtn = createButton({
                size = UDim2.new(0.48, 0, 1, 0),
                position = UDim2.new(0.52, 0, 0, 0),
                text = "Yes, Close",
                strokeColor = THEME.Colors.Danger,
                hoverColor = THEME.Colors.Danger,
                parent = buttonContainer
            })
            yesBtn.ZIndex = 203
            
            -- Animate in
            confirmFrame.Size = UDim2.new(0, 0, 0, 0)
            tween(confirmOverlay, {BackgroundTransparency = THEME.Transparency.Overlay}, THEME.Animation.Fast)
            tween(confirmFrame, {Size = UDim2.new(0, 380, 0, 200)}, THEME.Animation.Normal, THEME.Animation.Bounce)
            
            noBtn.MouseButton1Click:Connect(function()
                tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
                tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
                    confirmOverlay:Destroy()
                end)
            end)
            
            yesBtn.MouseButton1Click:Connect(function()
                tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
                tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast)
                tween(mainFrame, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Rotation = 360
                }, THEME.Animation.Slow, THEME.Animation.Bounce, Enum.EasingDirection.In, function()
                    screenGui:Destroy()
                    showToast("GUI closed. Thanks for using!", "success")
                end)
            end)
        end, 0.5))
        
    else
        -- Show key system
        local keyFrame, overlay, verifyBtn, getKeyBtn, keyInput, infoLabel = createKeySystem()
        
        -- Get key functionality
        getKeyBtn.MouseButton1Click:Connect(debounce(function()
            setclipboard(CONFIG.DiscordLink)
            infoLabel.Text = "✅ Discord link copied to clipboard!"
            infoLabel.TextColor3 = THEME.Colors.Success
            showToast("Discord link copied!", "success")
            
            task.wait(3)
            infoLabel.Text = "🎁 Key is 100% FREE in our Discord!"
            infoLabel.TextColor3 = THEME.Colors.Primary
        end, 1))
        
        -- Verify key functionality
        verifyBtn.MouseButton1Click:Connect(debounce(function()
            local enteredKey = keyInput.Text
            
            if enteredKey == CONFIG.CorrectKey then
                -- Success
                saveData(CONFIG.KeySaveFile, CONFIG.CorrectKey)
                showToast("Key verified successfully!", "success")
                
                -- Success animation
                tween(keyFrame, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Rotation = 360
                }, THEME.Animation.Slow, THEME.Animation.Bounce, Enum.EasingDirection.In)
                
                tween(overlay, {BackgroundTransparency = 1}, THEME.Animation.Slow, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
                    overlay:Destroy()
                    keyFrame:Destroy()
                    
                    task.wait(0.3)
                    
                    -- Load main GUI
                    local mainFrame, sidebar, contentArea, minimizeBtn, closeBtn = createMainGUI()
                    local miniBtn = createMinimizedButton()
                    local tabButtons, contentPages = createTabSystem(sidebar, contentArea)
                    populateContent(contentPages, mainFrame)
                    
                    mainFrame.Size = UDim2.new(0, 0, 0, 0)
                    mainFrame.Visible = true
                    tween(mainFrame, {Size = UDim2.new(0, 700, 0, 450)}, THEME.Animation.Slow, THEME.Animation.Bounce)
                    
                    -- Minimize functionality
                    minimizeBtn.MouseButton1Click:Connect(debounce(function()
                        showToast("GUI minimized", "success", 1.5)
                        tween(mainFrame, {
                            Size = UDim2.new(0, 0, 0, 0),
                            Rotation = -180
                        }, THEME.Animation.Normal, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
                            mainFrame.Visible = false
                            mainFrame.Rotation = 0
                            miniBtn.Visible = true
                            tween(miniBtn, {Size = UDim2.new(0, 70, 0, 70)}, THEME.Animation.Fast)
                        end)
                    end, 0.5))
                    
                    miniBtn.MouseButton1Click:Connect(debounce(function()
                        miniBtn.Visible = false
                        mainFrame.Visible = true
                        mainFrame.Size = UDim2.new(0, 0, 0, 0)
                        tween(mainFrame, {Size = UDim2.new(0, 700, 0, 450)}, THEME.Animation.Normal, THEME.Animation.Bounce)
                        showToast("Welcome back!", "success", 1.5)
                    end, 0.5))
                    
                    -- Close with confirmation (same as above)
                    closeBtn.MouseButton1Click:Connect(debounce(function()
                        local confirmOverlay = Instance.new("Frame")
                        confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
                        confirmOverlay.BackgroundColor3 = THEME.Colors.Overlay
                        confirmOverlay.BackgroundTransparency = 1
                        confirmOverlay.Parent = screenGui
                        confirmOverlay.ZIndex = 200
                        
                        local confirmFrame = Instance.new("Frame")
                        confirmFrame.Size = UDim2.new(0, 380, 0, 200)
                        confirmFrame.Position = UDim2.new(0.5, -190, 0.5, -100)
                        confirmFrame.BackgroundColor3 = THEME.Colors.Background
                        confirmFrame.BackgroundTransparency = THEME.Transparency.Frame
                        confirmFrame.Parent = confirmOverlay
                        confirmFrame.ZIndex = 201
                        addCorner(confirmFrame, 16)
                        addStroke(confirmFrame, THEME.Colors.Danger, 3)
                        
                        createGlowEffect(confirmFrame, THEME.Colors.Danger, 10)
                        
                        local header = Instance.new("TextLabel")
                        header.Size = UDim2.new(1, -40, 0, 40)
                        header.Position = UDim2.new(0, 20, 0, 20)
                        header.BackgroundTransparency = 1
                        header.Text = "⚠️ Close GUI?"
                        header.TextColor3 = THEME.Colors.TextPrimary
                        header.TextSize = 20
                        header.Font = Enum.Font.GothamBold
                        header.Parent = confirmFrame
                        header.ZIndex = 202
                        
                        local desc = Instance.new("TextLabel")
                        desc.Size = UDim2.new(1, -40, 0, 50)
                        desc.Position = UDim2.new(0, 20, 0, 65)
                        desc.BackgroundTransparency = 1
                        desc.Text = "Are you sure you want to close the GUI?\nYou can always re-execute the script."
                        desc.TextColor3 = THEME.Colors.TextSecondary
                        desc.TextSize = 13
                        desc.Font = Enum.Font.Gotham
                        desc.TextWrapped = true
                        desc.TextXAlignment = Enum.TextXAlignment.Left
                        desc.TextYAlignment = Enum.TextYAlignment.Top
                        desc.Parent = confirmFrame
                        desc.ZIndex = 202
                        
                        local buttonContainer = Instance.new("Frame")
                        buttonContainer.Size = UDim2.new(1, -40, 0, 45)
                        buttonContainer.Position = UDim2.new(0, 20, 1, -60)
                        buttonContainer.BackgroundTransparency = 1
                        buttonContainer.Parent = confirmFrame
                        buttonContainer.ZIndex = 202
                        
                        local noBtn = createButton({
                            size = UDim2.new(0.48, 0, 1, 0),
                            position = UDim2.new(0, 0, 0, 0),
                            text = "No, Stay",
                            strokeColor = THEME.Colors.Success,
                            hoverColor = THEME.Colors.Success,
                            parent = buttonContainer
                        })
                        noBtn.ZIndex = 203
                        
                        local yesBtn = createButton({
                            size = UDim2.new(0.48, 0, 1, 0),
                            position = UDim2.new(0.52, 0, 0, 0),
                            text = "Yes, Close",
                            strokeColor = THEME.Colors.Danger,
                            hoverColor = THEME.Colors.Danger,
                            parent = buttonContainer
                        })
                        yesBtn.ZIndex = 203
                        
                        confirmFrame.Size = UDim2.new(0, 0, 0, 0)
                        tween(confirmOverlay, {BackgroundTransparency = THEME.Transparency.Overlay}, THEME.Animation.Fast)
                        tween(confirmFrame, {Size = UDim2.new(0, 380, 0, 200)}, THEME.Animation.Normal, THEME.Animation.Bounce)
                        
                        noBtn.MouseButton1Click:Connect(function()
                            tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
                            tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast, THEME.Animation.Smooth, Enum.EasingDirection.In, function()
                                confirmOverlay:Destroy()
                            end)
                        end)
                        
                        yesBtn.MouseButton1Click:Connect(function()
                            tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
                            tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast)
                            tween(mainFrame, {
                                Size = UDim2.new(0, 0, 0, 0),
                                Rotation = 360
                            }, THEME.Animation.Slow, THEME.Animation.Bounce, Enum.EasingDirection.In, function()
                                screenGui:Destroy()
                            end)
                        end)
                    end, 0.5))
                end)
                
            else
                -- Wrong key
                showToast("Invalid key! Please try again.", "error")
                keyInput.Text = ""
                keyInput.PlaceholderText = "❌ Wrong key! Try again..."
                
                -- Shake animation
                local originalPos = keyFrame.Position
                for i = 1, 4 do
                    tween(keyFrame, {Position = originalPos + UDim2.new(0, 10, 0, 0)}, 0.05, Enum.EasingStyle.Linear)
                    task.wait(0.05)
                    tween(keyFrame, {Position = originalPos - UDim2.new(0, 10, 0, 0)}, 0.05, Enum.EasingStyle.Linear)
                    task.wait(0.05)
                end
                tween(keyFrame, {Position = originalPos}, 0.1)
                
                task.wait(2)
                keyInput.PlaceholderText = "Enter your key here..."
            end
        end, 0.5))
    end
end

-- Start the GUI
initialize()

print("✅ Advanced Roblox GUI v2.0.0 loaded successfully!")
print("📌 Created with professional UX/UI standards")
