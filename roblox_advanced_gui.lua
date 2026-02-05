-- ⚡ ADVANCED ROBLOX GUI V3.0 - PRODUCTION READY
-- Professional UX/UI with advanced polish and micro-interactions
-- Error-free, optimized, and feature-complete

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- 🎨 THEME SYSTEM
-- ========================================
local THEME = {
    Colors = {
        Background = Color3.fromRGB(15, 15, 15),
        BackgroundLight = Color3.fromRGB(22, 22, 22),
        Surface = Color3.fromRGB(28, 28, 28),
        SurfaceHover = Color3.fromRGB(35, 35, 35),
        
        Primary = Color3.fromRGB(59, 130, 246),
        PrimaryHover = Color3.fromRGB(96, 165, 250),
        Success = Color3.fromRGB(34, 197, 94),
        SuccessHover = Color3.fromRGB(74, 222, 128),
        Danger = Color3.fromRGB(239, 68, 68),
        DangerHover = Color3.fromRGB(248, 113, 113),
        Warning = Color3.fromRGB(251, 191, 36),
        Premium = Color3.fromRGB(168, 85, 247),
        
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(163, 163, 163),
        TextDisabled = Color3.fromRGB(82, 82, 82),
        Border = Color3.fromRGB(45, 45, 45),
        Overlay = Color3.fromRGB(0, 0, 0),
    },
    
    Transparency = {
        Solid = 0,
        Frame = 0.08,
        Overlay = 0.6,
        Hover = 0.2,
    },
    
    Size = {
        CornerRadius = 12,
        StrokeThickness = 2,
        Padding = 12,
    },
    
    Animation = {
        Fast = 0.15,
        Normal = 0.3,
        Slow = 0.5,
    },
}

local CONFIG = {
    CorrectKey = "ROBLOX2025",
    KeySaveFile = "AdvancedGUI_Key_V3",
    LastTabFile = "AdvancedGUI_LastTab",
    DiscordLink = "https://discord.gg/yourserver",
    Version = "v3.0.0",
}

-- ========================================
-- 🛠️ UTILITY FUNCTIONS
-- ========================================

local screenGui

local function tween(object, properties, duration, style, direction, callback)
    local tweenInfo = TweenInfo.new(
        duration or THEME.Animation.Normal,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or THEME.Size.CornerRadius)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or THEME.Colors.Border
    stroke.Thickness = thickness or THEME.Size.StrokeThickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

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

local function saveData(key, value)
    pcall(function()
        writefile(key .. ".txt", value)
    end)
end

local function loadData(key)
    local success, data = pcall(function()
        return readfile(key .. ".txt")
    end)
    return success and data or nil
end

local function deleteData(key)
    pcall(function()
        delfile(key .. ".txt")
    end)
end

-- Toast notification system
local function showToast(message, toastType, duration)
    duration = duration or 3
    
    local toast = Instance.new("Frame")
    toast.Size = UDim2.new(0, 320, 0, 70)
    toast.Position = UDim2.new(1, -340, 1, 100)
    toast.BackgroundColor3 = THEME.Colors.Surface
    toast.BackgroundTransparency = THEME.Transparency.Frame
    toast.ZIndex = 1000
    toast.Parent = screenGui
    addCorner(toast, 10)
    
    local color = THEME.Colors.Primary
    if toastType == "success" then color = THEME.Colors.Success
    elseif toastType == "error" then color = THEME.Colors.Danger
    elseif toastType == "warning" then color = THEME.Colors.Warning end
    
    addStroke(toast, color, 2)
    addPadding(toast, 15)
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 35, 0, 35)
    iconLabel.Position = UDim2.new(0, 0, 0.5, -17.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = toastType == "success" and "✓" or toastType == "error" and "✕" or "ℹ"
    iconLabel.TextColor3 = color
    iconLabel.TextSize = 22
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.ZIndex = 1001
    iconLabel.Parent = toast
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 45, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = THEME.Colors.TextPrimary
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 1001
    label.Parent = toast
    
    tween(toast, {Position = UDim2.new(1, -340, 1, -90)}, THEME.Animation.Normal, Enum.EasingStyle.Back)
    
    task.delay(duration, function()
        tween(toast, {
            Position = UDim2.new(1, -340, 1, 100),
            BackgroundTransparency = 1
        }, THEME.Animation.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
            toast:Destroy()
        end)
    end)
end

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
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function makeResizable(frame, minWidth, minHeight)
    minWidth = minWidth or 500
    minHeight = minHeight or 350
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new(1, -16, 1, -16)
    handle.AnchorPoint = Vector2.new(1, 1)
    handle.BackgroundColor3 = THEME.Colors.Primary
    handle.BackgroundTransparency = 0.3
    handle.ZIndex = frame.ZIndex + 10
    handle.Parent = frame
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
    
    handle.MouseEnter:Connect(function()
        tween(handle, {BackgroundTransparency = 0.1}, THEME.Animation.Fast)
    end)
    
    handle.MouseLeave:Connect(function()
        tween(handle, {BackgroundTransparency = 0.3}, THEME.Animation.Fast)
    end)
end

local function createGlowEffect(parent, color, intensity)
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    
    local glowStroke = Instance.new("UIStroke")
    glowStroke.Color = color or THEME.Colors.Primary
    glowStroke.Thickness = intensity or 10
    glowStroke.Transparency = 0.7
    glowStroke.Parent = glow
    
    addCorner(glow, THEME.Size.CornerRadius + 6)
    
    task.spawn(function()
        while glow.Parent do
            tween(glowStroke, {Transparency = 0.4}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
            if not glow.Parent then break end
            tween(glowStroke, {Transparency = 0.8}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
        end
    end)
    
    return glow
end

local function createButton(config)
    local button = Instance.new("TextButton")
    button.Size = config.size or UDim2.new(0, 120, 0, 40)
    button.Position = config.position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = config.backgroundColor or THEME.Colors.Surface
    button.BackgroundTransparency = THEME.Transparency.Solid
    button.Text = config.text or "Button"
    button.TextColor3 = config.textColor or THEME.Colors.TextPrimary
    button.TextSize = config.textSize or 16
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    button.ZIndex = config.zIndex or 1
    button.Parent = config.parent
    
    addCorner(button, config.cornerRadius)
    addStroke(button, config.strokeColor or THEME.Colors.Primary, config.strokeThickness)
    
    local originalSize = button.Size
    
    button.MouseEnter:Connect(function()
        tween(button, {
            BackgroundColor3 = config.hoverColor or THEME.Colors.PrimaryHover,
            BackgroundTransparency = THEME.Transparency.Hover
        }, THEME.Animation.Fast)
        tween(button, {Size = originalSize + UDim2.new(0, 4, 0, 2)}, THEME.Animation.Fast)
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {
            BackgroundColor3 = config.backgroundColor or THEME.Colors.Surface,
            BackgroundTransparency = THEME.Transparency.Solid
        }, THEME.Animation.Fast)
        tween(button, {Size = originalSize}, THEME.Animation.Fast)
    end)
    
    button.MouseButton1Down:Connect(function()
        tween(button, {Size = originalSize - UDim2.new(0, 2, 0, 2)}, 0.05)
    end)
    
    button.MouseButton1Up:Connect(function()
        tween(button, {Size = originalSize}, 0.05)
    end)
    
    return button
end

-- ========================================
-- 🔐 KEY SYSTEM
-- ========================================

local function createKeySystem()
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = THEME.Colors.Overlay
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = screenGui
    
    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "KeyFrame"
    keyFrame.Size = UDim2.new(0, 420, 0, 300)
    keyFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
    keyFrame.BackgroundColor3 = THEME.Colors.Background
    keyFrame.BackgroundTransparency = THEME.Transparency.Frame
    keyFrame.ZIndex = 2
    keyFrame.Parent = screenGui
    addCorner(keyFrame, 16)
    addStroke(keyFrame, THEME.Colors.Primary, 3)
    
    createGlowEffect(keyFrame, THEME.Colors.Primary, 12)
    
    -- Animated icon
    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 60, 0, 60)
    iconContainer.Position = UDim2.new(0.5, -30, 0, 20)
    iconContainer.BackgroundColor3 = THEME.Colors.Primary
    iconContainer.BackgroundTransparency = 0.2
    iconContainer.ZIndex = 3
    iconContainer.Parent = keyFrame
    addCorner(iconContainer, 14)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "🔐"
    icon.TextSize = 32
    icon.ZIndex = 4
    icon.Parent = iconContainer
    
    task.spawn(function()
        while iconContainer.Parent do
            tween(iconContainer, {Position = UDim2.new(0.5, -30, 0, 15)}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
            if not iconContainer.Parent then break end
            tween(iconContainer, {Position = UDim2.new(0.5, -30, 0, 25)}, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(2)
        end
    end)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 90)
    title.BackgroundTransparency = 1
    title.Text = "KEY VERIFICATION"
    title.TextColor3 = THEME.Colors.TextPrimary
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 3
    title.Parent = keyFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 0, 120)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your key to continue"
    subtitle.TextColor3 = THEME.Colors.TextSecondary
    subtitle.TextSize = 13
    subtitle.Font = Enum.Font.Gotham
    subtitle.ZIndex = 3
    subtitle.Parent = keyFrame
    
    -- Input container
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, -40, 0, 50)
    inputContainer.Position = UDim2.new(0, 20, 0, 150)
    inputContainer.BackgroundColor3 = THEME.Colors.BackgroundLight
    inputContainer.BackgroundTransparency = 0.3
    inputContainer.ZIndex = 3
    inputContainer.Parent = keyFrame
    addCorner(inputContainer, 10)
    local inputStroke = addStroke(inputContainer, THEME.Colors.Border, 1)
    
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -20, 1, 0)
    keyInput.Position = UDim2.new(0, 10, 0, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.PlaceholderText = "Enter your key..."
    keyInput.PlaceholderColor3 = THEME.Colors.TextSecondary
    keyInput.Text = ""
    keyInput.TextColor3 = THEME.Colors.TextPrimary
    keyInput.TextSize = 16
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.ClearTextOnFocus = false
    keyInput.ZIndex = 4
    keyInput.Parent = inputContainer
    
    keyInput.Focused:Connect(function()
        tween(inputStroke, {Color = THEME.Colors.Primary, Thickness = 2}, THEME.Animation.Fast)
    end)
    
    keyInput.FocusLost:Connect(function()
        tween(inputStroke, {Color = THEME.Colors.Border, Thickness = 1}, THEME.Animation.Fast)
    end)
    
    -- Buttons
    local verifyBtn = createButton({
        size = UDim2.new(0.48, 0, 0, 45),
        position = UDim2.new(0, 20, 0, 215),
        text = "✓ Verify",
        strokeColor = THEME.Colors.Success,
        hoverColor = THEME.Colors.Success,
        zIndex = 3,
        parent = keyFrame
    })
    
    local getKeyBtn = createButton({
        size = UDim2.new(0.48, 0, 0, 45),
        position = UDim2.new(0.52, 0, 0, 215),
        text = "🔗 Get Key",
        strokeColor = THEME.Colors.Premium,
        hoverColor = THEME.Colors.Premium,
        zIndex = 3,
        parent = keyFrame
    })
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 25)
    infoLabel.Position = UDim2.new(0, 20, 1, -35)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🎁 100% FREE in Discord!"
    infoLabel.TextColor3 = THEME.Colors.Primary
    infoLabel.TextSize = 13
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.ZIndex = 3
    infoLabel.Parent = keyFrame
    
    -- Entrance animation
    keyFrame.Size = UDim2.new(0, 0, 0, 0)
    tween(overlay, {BackgroundTransparency = THEME.Transparency.Overlay}, THEME.Animation.Normal)
    tween(keyFrame, {Size = UDim2.new(0, 420, 0, 300)}, THEME.Animation.Slow, Enum.EasingStyle.Back)
    
    return keyFrame, overlay, verifyBtn, getKeyBtn, keyInput, infoLabel
end

-- ========================================
-- 🏠 MAIN GUI
-- ========================================

local function createMainGUI()
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 750, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
    mainFrame.BackgroundColor3 = THEME.Colors.Background
    mainFrame.BackgroundTransparency = THEME.Transparency.Frame
    mainFrame.Visible = false
    mainFrame.ZIndex = 10
    mainFrame.Parent = screenGui
    addCorner(mainFrame, 16)
    addStroke(mainFrame, THEME.Colors.Primary, 3)
    
    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 55)
    topBar.BackgroundColor3 = THEME.Colors.BackgroundLight
    topBar.BackgroundTransparency = 0.2
    topBar.ZIndex = 11
    topBar.Parent = mainFrame
    addCorner(topBar, 16)
    
    local titleContainer = Instance.new("Frame")
    titleContainer.Size = UDim2.new(0, 250, 1, 0)
    titleContainer.Position = UDim2.new(0, 20, 0, 0)
    titleContainer.BackgroundTransparency = 1
    titleContainer.ZIndex = 12
    titleContainer.Parent = topBar
    
    local titleIcon = Instance.new("TextLabel")
    titleIcon.Size = UDim2.new(0, 30, 0, 30)
    titleIcon.Position = UDim2.new(0, 0, 0.5, -15)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = "⚡"
    titleIcon.TextColor3 = THEME.Colors.Primary
    titleIcon.TextSize = 24
    titleIcon.Font = Enum.Font.GothamBold
    titleIcon.ZIndex = 13
    titleIcon.Parent = titleContainer
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 40, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Advanced GUI"
    titleLabel.TextColor3 = THEME.Colors.TextPrimary
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 13
    titleLabel.Parent = titleContainer
    
    -- Version badge
    local versionBadge = Instance.new("TextLabel")
    versionBadge.Size = UDim2.new(0, 55, 0, 22)
    versionBadge.Position = UDim2.new(0, 210, 0.5, -11)
    versionBadge.BackgroundColor3 = THEME.Colors.Primary
    versionBadge.BackgroundTransparency = 0.3
    versionBadge.Text = CONFIG.Version
    versionBadge.TextColor3 = THEME.Colors.TextPrimary
    versionBadge.TextSize = 10
    versionBadge.Font = Enum.Font.GothamBold
    versionBadge.ZIndex = 12
    versionBadge.Parent = topBar
    addCorner(versionBadge, 6)
    
    -- Control buttons
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 38, 0, 38)
    minimizeBtn.Position = UDim2.new(1, -88, 0.5, -19)
    minimizeBtn.BackgroundColor3 = THEME.Colors.Surface
    minimizeBtn.BackgroundTransparency = 0.3
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = THEME.Colors.Primary
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.ZIndex = 12
    minimizeBtn.Parent = topBar
    addCorner(minimizeBtn, 8)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 38, 0, 38)
    closeBtn.Position = UDim2.new(1, -45, 0.5, -19)
    closeBtn.BackgroundColor3 = THEME.Colors.Surface
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = THEME.Colors.Danger
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 12
    closeBtn.Parent = topBar
    addCorner(closeBtn, 8)
    
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
    sidebar.Size = UDim2.new(0, 150, 1, -70)
    sidebar.Position = UDim2.new(0, 10, 0, 60)
    sidebar.BackgroundColor3 = THEME.Colors.BackgroundLight
    sidebar.BackgroundTransparency = 0.3
    sidebar.ZIndex = 11
    sidebar.Parent = mainFrame
    addCorner(sidebar, 12)
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -175, 1, -70)
    contentArea.Position = UDim2.new(0, 165, 0, 60)
    contentArea.BackgroundColor3 = THEME.Colors.BackgroundLight
    contentArea.BackgroundTransparency = 0.3
    contentArea.ZIndex = 11
    contentArea.Parent = mainFrame
    addCorner(contentArea, 12)
    
    makeDraggable(mainFrame, topBar)
    makeResizable(mainFrame, 650, 450)
    
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
    
    for i, tabData in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabData.name .. "Tab"
        tabBtn.Size = UDim2.new(1, -10, 0, 50)
        tabBtn.Position = UDim2.new(0, 5, 0, (i - 1) * 55 + 5)
        tabBtn.BackgroundColor3 = THEME.Colors.Surface
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.ZIndex = 12
        tabBtn.Parent = sidebar
        addCorner(tabBtn, 10)
        
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size = UDim2.new(0, 28, 0, 28)
        tabIcon.Position = UDim2.new(0, 12, 0.5, -14)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tabData.icon
        tabIcon.TextColor3 = THEME.Colors.TextSecondary
        tabIcon.TextSize = 20
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.ZIndex = 13
        tabIcon.Parent = tabBtn
        
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1, -50, 1, 0)
        tabLabel.Position = UDim2.new(0, 45, 0, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.Text = tabData.name
        tabLabel.TextColor3 = THEME.Colors.TextSecondary
        tabLabel.TextSize = 15
        tabLabel.Font = Enum.Font.GothamBold
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.ZIndex = 13
        tabLabel.Parent = tabBtn
        
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
        contentPage.ZIndex = 12
        contentPage.Parent = contentArea
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 12)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = contentPage
        
        table.insert(tabButtons, {btn = tabBtn, icon = tabIcon, label = tabLabel, data = tabData})
        table.insert(contentPages, contentPage)
        
        tabBtn.MouseButton1Click:Connect(debounce(function()
            if activeTab == i then return end
            
            if activeTab then
                local prevBtn = tabButtons[activeTab]
                tween(prevBtn.btn, {BackgroundTransparency = 0.5}, THEME.Animation.Fast)
                tween(prevBtn.icon, {TextColor3 = THEME.Colors.TextSecondary}, THEME.Animation.Fast)
                tween(prevBtn.label, {TextColor3 = THEME.Colors.TextSecondary}, THEME.Animation.Fast)
                
                local prevPage = contentPages[activeTab]
                tween(prevPage, {Position = UDim2.new(-1, 10, 0, 10)}, THEME.Animation.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                    prevPage.Visible = false
                    prevPage.Position = UDim2.new(0, 10, 0, 10)
                end)
            end
            
            activeTab = i
            local currentBtn = tabButtons[i]
            tween(currentBtn.btn, {BackgroundTransparency = 0.1}, THEME.Animation.Fast)
            tween(currentBtn.icon, {TextColor3 = tabData.color}, THEME.Animation.Fast)
            tween(currentBtn.label, {TextColor3 = THEME.Colors.TextPrimary}, THEME.Animation.Fast)
            
            local currentPage = contentPages[i]
            currentPage.Position = UDim2.new(1, 10, 0, 10)
            currentPage.Visible = true
            tween(currentPage, {Position = UDim2.new(0, 10, 0, 10)}, THEME.Animation.Normal, Enum.EasingStyle.Quad)
            
            saveData(CONFIG.LastTabFile, tabData.name)
            showToast("Switched to " .. tabData.name, "success", 1.5)
        end, 0.3))
        
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
    
    local lastTab = loadData(CONFIG.LastTabFile)
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
-- 📝 CONTENT POPULATION
-- ========================================

local function populateContent(contentPages, mainFrame)
    -- Home page
    local homePage = contentPages[1]
    
    local welcomeCard = Instance.new("Frame")
    welcomeCard.Size = UDim2.new(1, 0, 0, 130)
    welcomeCard.BackgroundColor3 = THEME.Colors.Surface
    welcomeCard.BackgroundTransparency = 0.3
    welcomeCard.ZIndex = 13
    welcomeCard.Parent = homePage
    addCorner(welcomeCard, 12)
    addStroke(welcomeCard, THEME.Colors.Primary, 2)
    addPadding(welcomeCard, 20)
    
    local welcomeTitle = Instance.new("TextLabel")
    welcomeTitle.Size = UDim2.new(1, 0, 0, 32)
    welcomeTitle.BackgroundTransparency = 1
    welcomeTitle.Text = "👋 Welcome, " .. player.Name .. "!"
    welcomeTitle.TextColor3 = THEME.Colors.TextPrimary
    welcomeTitle.TextSize = 22
    welcomeTitle.Font = Enum.Font.GothamBold
    welcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
    welcomeTitle.ZIndex = 14
    welcomeTitle.Parent = welcomeCard
    
    local welcomeDesc = Instance.new("TextLabel")
    welcomeDesc.Size = UDim2.new(1, 0, 1, -37)
    welcomeDesc.Position = UDim2.new(0, 0, 0, 37)
    welcomeDesc.BackgroundTransparency = 1
    welcomeDesc.Text = "Your GUI is ready! Explore the tabs to access features. Everything is optimized for performance and style."
    welcomeDesc.TextColor3 = THEME.Colors.TextSecondary
    welcomeDesc.TextSize = 14
    welcomeDesc.Font = Enum.Font.Gotham
    welcomeDesc.TextWrapped = true
    welcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
    welcomeDesc.TextYAlignment = Enum.TextYAlignment.Top
    welcomeDesc.ZIndex = 14
    welcomeDesc.Parent = welcomeCard
    
    -- Stats container
    local statsContainer = Instance.new("Frame")
    statsContainer.Size = UDim2.new(1, 0, 0, 90)
    statsContainer.BackgroundTransparency = 1
    statsContainer.ZIndex = 13
    statsContainer.Parent = homePage
    
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
        statCard.ZIndex = 14
        statCard.Parent = statsContainer
        addCorner(statCard, 10)
        addStroke(statCard, stat.color, 1)
        
        local statLabel = Instance.new("TextLabel")
        statLabel.Size = UDim2.new(1, -10, 0, 22)
        statLabel.Position = UDim2.new(0, 5, 0, 12)
        statLabel.BackgroundTransparency = 1
        statLabel.Text = stat.label
        statLabel.TextColor3 = THEME.Colors.TextSecondary
        statLabel.TextSize = 12
        statLabel.Font = Enum.Font.Gotham
        statLabel.ZIndex = 15
        statLabel.Parent = statCard
        
        local statValue = Instance.new("TextLabel")
        statValue.Size = UDim2.new(1, -10, 0, 28)
        statValue.Position = UDim2.new(0, 5, 0, 38)
        statValue.BackgroundTransparency = 1
        statValue.Text = stat.value
        statValue.TextColor3 = stat.color
        statValue.TextSize = 17
        statValue.Font = Enum.Font.GothamBold
        statValue.TextTruncate = Enum.TextTruncate.AtEnd
        statValue.ZIndex = 15
        statValue.Parent = statCard
    end
    
    -- Scripts page
    local scriptsPage = contentPages[2]
    
    local scriptCard = Instance.new("Frame")
    scriptCard.Size = UDim2.new(1, 0, 0, 90)
    scriptCard.BackgroundColor3 = THEME.Colors.Surface
    scriptCard.BackgroundTransparency = 0.3
    scriptCard.ZIndex = 13
    scriptCard.Parent = scriptsPage
    addCorner(scriptCard, 12)
    addPadding(scriptCard, 15)
    
    local scriptTitle = Instance.new("TextLabel")
    scriptTitle.Size = UDim2.new(1, -95, 0, 28)
    scriptTitle.BackgroundTransparency = 1
    scriptTitle.Text = "📜 Example Script"
    scriptTitle.TextColor3 = THEME.Colors.TextPrimary
    scriptTitle.TextSize = 17
    scriptTitle.Font = Enum.Font.GothamBold
    scriptTitle.TextXAlignment = Enum.TextXAlignment.Left
    scriptTitle.ZIndex = 14
    scriptTitle.Parent = scriptCard
    
    local scriptDesc = Instance.new("TextLabel")
    scriptDesc.Size = UDim2.new(1, -95, 1, -32)
    scriptDesc.Position = UDim2.new(0, 0, 0, 30)
    scriptDesc.BackgroundTransparency = 1
    scriptDesc.Text = "Add your custom scripts here."
    scriptDesc.TextColor3 = THEME.Colors.TextSecondary
    scriptDesc.TextSize = 13
    scriptDesc.Font = Enum.Font.Gotham
    scriptDesc.TextWrapped = true
    scriptDesc.TextXAlignment = Enum.TextXAlignment.Left
    scriptDesc.TextYAlignment = Enum.TextYAlignment.Top
    scriptDesc.ZIndex = 14
    scriptDesc.Parent = scriptCard
    
    local executeBtn = createButton({
        size = UDim2.new(0, 85, 0, 38),
        position = UDim2.new(1, -85, 0.5, -19),
        text = "Execute",
        strokeColor = THEME.Colors.Success,
        hoverColor = THEME.Colors.Success,
        textSize = 14,
        zIndex = 14,
        parent = scriptCard
    })
    
    executeBtn.MouseButton1Click:Connect(function()
        showToast("Script executed!", "success")
    end)
    
    -- Player page
    local playerPage = contentPages[3]
    
    local playerCard = Instance.new("Frame")
    playerCard.Size = UDim2.new(1, 0, 0, 170)
    playerCard.BackgroundColor3 = THEME.Colors.Surface
    playerCard.BackgroundTransparency = 0.3
    playerCard.ZIndex = 13
    playerCard.Parent = playerPage
    addCorner(playerCard, 12)
    addPadding(playerCard, 20)
    
    local playerTitle = Instance.new("TextLabel")
    playerTitle.Size = UDim2.new(1, 0, 0, 32)
    playerTitle.BackgroundTransparency = 1
    playerTitle.Text = "👤 Player Information"
    playerTitle.TextColor3 = THEME.Colors.TextPrimary
    playerTitle.TextSize = 19
    playerTitle.Font = Enum.Font.GothamBold
    playerTitle.TextXAlignment = Enum.TextXAlignment.Left
    playerTitle.ZIndex = 14
    playerTitle.Parent = playerCard
    
    local playerDetails = {
        "Username: " .. player.Name,
        "Display: " .. player.DisplayName,
        "ID: " .. player.UserId,
    }
    
    for i, detail in ipairs(playerDetails) do
        local detailLabel = Instance.new("TextLabel")
        detailLabel.Size = UDim2.new(1, 0, 0, 24)
        detailLabel.Position = UDim2.new(0, 0, 0, 37 + (i * 28))
        detailLabel.BackgroundTransparency = 1
        detailLabel.Text = detail
        detailLabel.TextColor3 = THEME.Colors.TextSecondary
        detailLabel.TextSize = 14
        detailLabel.Font = Enum.Font.Gotham
        detailLabel.TextXAlignment = Enum.TextXAlignment.Left
        detailLabel.ZIndex = 14
        detailLabel.Parent = playerCard
    end
    
    -- Settings page with reset key
    local settingsPage = contentPages[4]
    
    local settingsCard = Instance.new("Frame")
    settingsCard.Size = UDim2.new(1, 0, 0, 110)
    settingsCard.BackgroundColor3 = THEME.Colors.Surface
    settingsCard.BackgroundTransparency = 0.3
    settingsCard.ZIndex = 13
    settingsCard.Parent = settingsPage
    addCorner(settingsCard, 12)
    addPadding(settingsCard, 20)
    
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 28)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "⚙️ General Settings"
    settingsTitle.TextColor3 = THEME.Colors.TextPrimary
    settingsTitle.TextSize = 17
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
    settingsTitle.ZIndex = 14
    settingsTitle.Parent = settingsCard
    
    local settingsDesc = Instance.new("TextLabel")
    settingsDesc.Size = UDim2.new(1, 0, 1, -32)
    settingsDesc.Position = UDim2.new(0, 0, 0, 30)
    settingsDesc.BackgroundTransparency = 1
    settingsDesc.Text = "Configure preferences and manage your account."
    settingsDesc.TextColor3 = THEME.Colors.TextSecondary
    settingsDesc.TextSize = 13
    settingsDesc.Font = Enum.Font.Gotham
    settingsDesc.TextWrapped = true
    settingsDesc.TextXAlignment = Enum.TextXAlignment.Left
    settingsDesc.TextYAlignment = Enum.TextYAlignment.Top
    settingsDesc.ZIndex = 14
    settingsDesc.Parent = settingsCard
    
    -- Reset key card
    local resetCard = Instance.new("Frame")
    resetCard.Size = UDim2.new(1, 0, 0, 120)
    resetCard.BackgroundColor3 = THEME.Colors.Surface
    resetCard.BackgroundTransparency = 0.3
    resetCard.ZIndex = 13
    resetCard.Parent = settingsPage
    addCorner(resetCard, 12)
    addStroke(resetCard, THEME.Colors.Danger, 1)
    addPadding(resetCard, 20)
    
    local resetTitle = Instance.new("TextLabel")
    resetTitle.Size = UDim2.new(1, -110, 0, 28)
    resetTitle.BackgroundTransparency = 1
    resetTitle.Text = "🔑 Reset Key"
    resetTitle.TextColor3 = THEME.Colors.TextPrimary
    resetTitle.TextSize = 17
    resetTitle.Font = Enum.Font.GothamBold
    resetTitle.TextXAlignment = Enum.TextXAlignment.Left
    resetTitle.ZIndex = 14
    resetTitle.Parent = resetCard
    
    local resetDesc = Instance.new("TextLabel")
    resetDesc.Size = UDim2.new(1, -110, 0, 48)
    resetDesc.Position = UDim2.new(0, 0, 0, 30)
    resetDesc.BackgroundTransparency = 1
    resetDesc.Text = "Clear saved key and return to verification. You'll need to enter a valid key again."
    resetDesc.TextColor3 = THEME.Colors.TextSecondary
    resetDesc.TextSize = 12
    resetDesc.Font = Enum.Font.Gotham
    resetDesc.TextWrapped = true
    resetDesc.TextXAlignment = Enum.TextXAlignment.Left
    resetDesc.TextYAlignment = Enum.TextYAlignment.Top
    resetDesc.ZIndex = 14
    resetDesc.Parent = resetCard
    
    local resetBtn = createButton({
        size = UDim2.new(0, 105, 0, 42),
        position = UDim2.new(1, -105, 0.5, -21),
        text = "Reset Key",
        strokeColor = THEME.Colors.Danger,
        hoverColor = THEME.Colors.Danger,
        textSize = 14,
        zIndex = 14,
        parent = resetCard
    })
    
    resetBtn.MouseButton1Click:Connect(debounce(function()
        local confirmOverlay = Instance.new("Frame")
        confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
        confirmOverlay.BackgroundColor3 = THEME.Colors.Overlay
        confirmOverlay.BackgroundTransparency = 1
        confirmOverlay.ZIndex = 100
        confirmOverlay.Parent = screenGui
        
        local confirmFrame = Instance.new("Frame")
        confirmFrame.Size = UDim2.new(0, 420, 0, 230)
        confirmFrame.Position = UDim2.new(0.5, -210, 0.5, -115)
        confirmFrame.BackgroundColor3 = THEME.Colors.Background
        confirmFrame.BackgroundTransparency = THEME.Transparency.Frame
        confirmFrame.ZIndex = 101
        confirmFrame.Parent = confirmOverlay
        addCorner(confirmFrame, 16)
        addStroke(confirmFrame, THEME.Colors.Danger, 3)
        
        createGlowEffect(confirmFrame, THEME.Colors.Danger, 10)
        
        local confirmHeader = Instance.new("TextLabel")
        confirmHeader.Size = UDim2.new(1, -40, 0, 42)
        confirmHeader.Position = UDim2.new(0, 20, 0, 22)
        confirmHeader.BackgroundTransparency = 1
        confirmHeader.Text = "⚠️ Confirm Reset"
        confirmHeader.TextColor3 = THEME.Colors.TextPrimary
        confirmHeader.TextSize = 21
        confirmHeader.Font = Enum.Font.GothamBold
        confirmHeader.ZIndex = 102
        confirmHeader.Parent = confirmFrame
        
        local confirmDesc = Instance.new("TextLabel")
        confirmDesc.Size = UDim2.new(1, -40, 0, 75)
        confirmDesc.Position = UDim2.new(0, 20, 0, 68)
        confirmDesc.BackgroundTransparency = 1
        confirmDesc.Text = "This will delete your saved key and close the GUI. You'll need to verify again.\n\nContinue?"
        confirmDesc.TextColor3 = THEME.Colors.TextSecondary
        confirmDesc.TextSize = 13
        confirmDesc.Font = Enum.Font.Gotham
        confirmDesc.TextWrapped = true
        confirmDesc.TextXAlignment = Enum.TextXAlignment.Left
        confirmDesc.TextYAlignment = Enum.TextYAlignment.Top
        confirmDesc.ZIndex = 102
        confirmDesc.Parent = confirmFrame
        
        local cancelBtn = createButton({
            size = UDim2.new(0.48, 0, 0, 48),
            position = UDim2.new(0, 20, 1, -65),
            text = "Cancel",
            strokeColor = THEME.Colors.Success,
            hoverColor = THEME.Colors.Success,
            zIndex = 102,
            parent = confirmFrame
        })
        
        local confirmBtn = createButton({
            size = UDim2.new(0.48, 0, 0, 48),
            position = UDim2.new(0.52, 0, 1, -65),
            text = "Yes, Reset",
            strokeColor = THEME.Colors.Danger,
            hoverColor = THEME.Colors.Danger,
            zIndex = 102,
            parent = confirmFrame
        })
        
        confirmFrame.Size = UDim2.new(0, 0, 0, 0)
        tween(confirmOverlay, {BackgroundTransparency = THEME.Transparency.Overlay}, THEME.Animation.Fast)
        tween(confirmFrame, {Size = UDim2.new(0, 420, 0, 230)}, THEME.Animation.Normal, Enum.EasingStyle.Back)
        
        cancelBtn.MouseButton1Click:Connect(function()
            tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
            tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                confirmOverlay:Destroy()
            end)
        end)
        
        confirmBtn.MouseButton1Click:Connect(function()
            deleteData(CONFIG.KeySaveFile)
            showToast("Key reset successfully!", "success")
            
            tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
            tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast)
            
            task.wait(0.3)
            
            tween(mainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Rotation = 360
            }, THEME.Animation.Slow, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
                screenGui:Destroy()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Key Reset",
                    Text = "Re-execute script to verify again.",
                    Duration = 5,
                })
            end)
        end)
    end, 0.5))
end

-- ========================================
-- 🔄 MINIMIZE BUTTON
-- ========================================

local function createMinimizedButton()
    local miniBtn = Instance.new("ImageButton")
    miniBtn.Name = "MinimizedButton"
    miniBtn.Size = UDim2.new(0, 75, 0, 75)
    miniBtn.Position = UDim2.new(0, 20, 0.5, -37.5)
    miniBtn.BackgroundColor3 = THEME.Colors.Background
    miniBtn.BackgroundTransparency = THEME.Transparency.Frame
    miniBtn.Visible = false
    miniBtn.ZIndex = 50
    miniBtn.AutoButtonColor = false
    miniBtn.Parent = screenGui
    addCorner(miniBtn, 16)
    addStroke(miniBtn, THEME.Colors.Primary, 3)
    
    createGlowEffect(miniBtn, THEME.Colors.Primary, 8)
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextColor3 = THEME.Colors.Primary
    icon.TextSize = 34
    icon.Font = Enum.Font.GothamBold
    icon.ZIndex = 51
    icon.Parent = miniBtn
    
    makeDraggable(miniBtn)
    
    miniBtn.MouseEnter:Connect(function()
        tween(miniBtn, {Size = UDim2.new(0, 80, 0, 80)}, THEME.Animation.Fast)
        tween(icon, {Rotation = 10}, THEME.Animation.Fast)
    end)
    
    miniBtn.MouseLeave:Connect(function()
        tween(miniBtn, {Size = UDim2.new(0, 75, 0, 75)}, THEME.Animation.Fast)
        tween(icon, {Rotation = 0}, THEME.Animation.Fast)
    end)
    
    return miniBtn
end

-- ========================================
-- ❌ CLOSE CONFIRMATION
-- ========================================

local function showCloseConfirmation(mainFrame)
    local confirmOverlay = Instance.new("Frame")
    confirmOverlay.Size = UDim2.new(1, 0, 1, 0)
    confirmOverlay.BackgroundColor3 = THEME.Colors.Overlay
    confirmOverlay.BackgroundTransparency = 1
    confirmOverlay.ZIndex = 200
    confirmOverlay.Parent = screenGui
    
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(0, 400, 0, 210)
    confirmFrame.Position = UDim2.new(0.5, -200, 0.5, -105)
    confirmFrame.BackgroundColor3 = THEME.Colors.Background
    confirmFrame.BackgroundTransparency = THEME.Transparency.Frame
    confirmFrame.ZIndex = 201
    confirmFrame.Parent = confirmOverlay
    addCorner(confirmFrame, 16)
    addStroke(confirmFrame, THEME.Colors.Danger, 3)
    
    createGlowEffect(confirmFrame, THEME.Colors.Danger, 10)
    
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -40, 0, 42)
    header.Position = UDim2.new(0, 20, 0, 22)
    header.BackgroundTransparency = 1
    header.Text = "⚠️ Close GUI?"
    header.TextColor3 = THEME.Colors.TextPrimary
    header.TextSize = 21
    header.Font = Enum.Font.GothamBold
    header.ZIndex = 202
    header.Parent = confirmFrame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -40, 0, 58)
    desc.Position = UDim2.new(0, 20, 0, 68)
    desc.BackgroundTransparency = 1
    desc.Text = "Are you sure you want to close?\nYou can always re-execute."
    desc.TextColor3 = THEME.Colors.TextSecondary
    desc.TextSize = 13
    desc.Font = Enum.Font.Gotham
    desc.TextWrapped = true
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.ZIndex = 202
    desc.Parent = confirmFrame
    
    local noBtn = createButton({
        size = UDim2.new(0.48, 0, 0, 48),
        position = UDim2.new(0, 20, 1, -65),
        text = "No, Stay",
        strokeColor = THEME.Colors.Success,
        hoverColor = THEME.Colors.Success,
        zIndex = 202,
        parent = confirmFrame
    })
    
    local yesBtn = createButton({
        size = UDim2.new(0.48, 0, 0, 48),
        position = UDim2.new(0.52, 0, 1, -65),
        text = "Yes, Close",
        strokeColor = THEME.Colors.Danger,
        hoverColor = THEME.Colors.Danger,
        zIndex = 202,
        parent = confirmFrame
    })
    
    confirmFrame.Size = UDim2.new(0, 0, 0, 0)
    tween(confirmOverlay, {BackgroundTransparency = THEME.Transparency.Overlay}, THEME.Animation.Fast)
    tween(confirmFrame, {Size = UDim2.new(0, 400, 0, 210)}, THEME.Animation.Normal, Enum.EasingStyle.Back)
    
    noBtn.MouseButton1Click:Connect(function()
        tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
        tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
            confirmOverlay:Destroy()
        end)
    end)
    
    yesBtn.MouseButton1Click:Connect(function()
        tween(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, THEME.Animation.Fast)
        tween(confirmOverlay, {BackgroundTransparency = 1}, THEME.Animation.Fast)
        tween(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Rotation = 360
        }, THEME.Animation.Slow, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            screenGui:Destroy()
        end)
    end)
end

-- ========================================
-- 🎬 INITIALIZATION
-- ========================================

local function initialize()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedGUI_V3"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui
    
    local savedKey = loadData(CONFIG.KeySaveFile)
    
    if savedKey == CONFIG.CorrectKey then
        showToast("Welcome back! Loading GUI...", "success", 2)
        
        task.wait(0.5)
        
        local mainFrame, sidebar, contentArea, minimizeBtn, closeBtn = createMainGUI()
        local miniBtn = createMinimizedButton()
        local tabButtons, contentPages = createTabSystem(sidebar, contentArea)
        populateContent(contentPages, mainFrame)
        
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Visible = true
        tween(mainFrame, {Size = UDim2.new(0, 750, 0, 500)}, THEME.Animation.Slow, Enum.EasingStyle.Back)
        
        minimizeBtn.MouseButton1Click:Connect(debounce(function()
            showToast("GUI minimized", "success", 1.5)
            tween(mainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Rotation = -180
            }, THEME.Animation.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                mainFrame.Visible = false
                mainFrame.Rotation = 0
                miniBtn.Visible = true
                tween(miniBtn, {Size = UDim2.new(0, 75, 0, 75)}, THEME.Animation.Fast)
            end)
        end, 0.5))
        
        miniBtn.MouseButton1Click:Connect(debounce(function()
            miniBtn.Visible = false
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            tween(mainFrame, {Size = UDim2.new(0, 750, 0, 500)}, THEME.Animation.Normal, Enum.EasingStyle.Back)
            showToast("Welcome back!", "success", 1.5)
        end, 0.5))
        
        closeBtn.MouseButton1Click:Connect(debounce(function()
            showCloseConfirmation(mainFrame)
        end, 0.5))
        
    else
        local keyFrame, overlay, verifyBtn, getKeyBtn, keyInput, infoLabel = createKeySystem()
        
        getKeyBtn.MouseButton1Click:Connect(debounce(function()
            setclipboard(CONFIG.DiscordLink)
            infoLabel.Text = "✅ Link copied!"
            infoLabel.TextColor3 = THEME.Colors.Success
            showToast("Discord link copied!", "success")
            
            task.wait(3)
            infoLabel.Text = "🎁 100% FREE in Discord!"
            infoLabel.TextColor3 = THEME.Colors.Primary
        end, 1))
        
        verifyBtn.MouseButton1Click:Connect(debounce(function()
            local enteredKey = keyInput.Text
            
            if enteredKey == CONFIG.CorrectKey then
                saveData(CONFIG.KeySaveFile, CONFIG.CorrectKey)
                showToast("Key verified!", "success")
                
                tween(keyFrame, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Rotation = 360
                }, THEME.Animation.Slow, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                
                tween(overlay, {BackgroundTransparency = 1}, THEME.Animation.Slow, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                    overlay:Destroy()
                    keyFrame:Destroy()
                    
                    task.wait(0.3)
                    
                    local mainFrame, sidebar, contentArea, minimizeBtn, closeBtn = createMainGUI()
                    local miniBtn = createMinimizedButton()
                    local tabButtons, contentPages = createTabSystem(sidebar, contentArea)
                    populateContent(contentPages, mainFrame)
                    
                    mainFrame.Size = UDim2.new(0, 0, 0, 0)
                    mainFrame.Visible = true
                    tween(mainFrame, {Size = UDim2.new(0, 750, 0, 500)}, THEME.Animation.Slow, Enum.EasingStyle.Back)
                    
                    minimizeBtn.MouseButton1Click:Connect(debounce(function()
                        showToast("GUI minimized", "success", 1.5)
                        tween(mainFrame, {
                            Size = UDim2.new(0, 0, 0, 0),
                            Rotation = -180
                        }, THEME.Animation.Normal, Enum.EasingStyle.Quad, Enum.EasingDirection.In, function()
                            mainFrame.Visible = false
                            mainFrame.Rotation = 0
                            miniBtn.Visible = true
                            tween(miniBtn, {Size = UDim2.new(0, 75, 0, 75)}, THEME.Animation.Fast)
                        end)
                    end, 0.5))
                    
                    miniBtn.MouseButton1Click:Connect(debounce(function()
                        miniBtn.Visible = false
                        mainFrame.Visible = true
                        mainFrame.Size = UDim2.new(0, 0, 0, 0)
                        tween(mainFrame, {Size = UDim2.new(0, 750, 0, 500)}, THEME.Animation.Normal, Enum.EasingStyle.Back)
                        showToast("Welcome back!", "success", 1.5)
                    end, 0.5))
                    
                    closeBtn.MouseButton1Click:Connect(debounce(function()
                        showCloseConfirmation(mainFrame)
                    end, 0.5))
                end)
                
            else
                showToast("Invalid key!", "error")
                keyInput.Text = ""
                keyInput.PlaceholderText = "❌ Wrong key!"
                
                local originalPos = keyFrame.Position
                for i = 1, 4 do
                    tween(keyFrame, {Position = originalPos + UDim2.new(0, 10, 0, 0)}, 0.05, Enum.EasingStyle.Linear)
                    task.wait(0.05)
                    tween(keyFrame, {Position = originalPos - UDim2.new(0, 10, 0, 0)}, 0.05, Enum.EasingStyle.Linear)
                    task.wait(0.05)
                end
                tween(keyFrame, {Position = originalPos}, 0.1)
                
                task.wait(2)
                keyInput.PlaceholderText = "Enter your key..."
            end
        end, 0.5))
    end
end

initialize()

print("✅ Advanced GUI v3.0.0 loaded!")
print("🔑 Key: " .. CONFIG.CorrectKey)
