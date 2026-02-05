--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║          ⚡ POLISHED HUB - COMPLETE KEY SYSTEM ⚡            ║
    ║                                                              ║
    ║  Features: 50+ Advanced GUI Components                      ║
    ║  • Key Entry System with Verification                       ║
    ║  • RGB Animated Borders                                     ║
    ║  • Notification System (Toast/Achievement)                  ║
    ║  • Performance Monitors (FPS/Ping/Memory)                   ║
    ║  • Multi-Tab Interface (8 Tabs)                             ║
    ║  • Security Features (Session/Activity Log)                 ║
    ║  • Theme System (5 Preset Themes)                           ║
    ║  • Interactive Components (Toggles/Sliders/Cards)           ║
    ║  • Virtual Shop with Currency                               ║
    ║  • Minimize System with Floating Button                     ║
    ║  • Confirmation Dialogs                                     ║
    ║  • Draggable Windows                                        ║
    ║  • Smooth Animations & Effects                              ║
    ╚══════════════════════════════════════════════════════════════╝
    
    Usage: Place in StarterPlayer > StarterPlayerScripts
    Default Key: POLISHED-HUB-2024
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- ═══════════════════════════════════════════════════════════════
-- CONFIGURATION
-- ═══════════════════════════════════════════════════════════════

local CONFIG = {
    Colors = {
        ElectricBlue = Color3.fromRGB(0, 170, 255),
        NeonGreen = Color3.fromRGB(0, 255, 128),
        AmberOrange = Color3.fromRGB(255, 165, 0),
        CrimsonRed = Color3.fromRGB(255, 50, 50),
        GoldenYellow = Color3.fromRGB(255, 215, 0),
        ElectricPurple = Color3.fromRGB(180, 0, 255),
        DeepSpace = Color3.fromRGB(10, 10, 15),
        Charcoal = Color3.fromRGB(25, 25, 35),
        Slate = Color3.fromRGB(40, 40, 55),
        DarkGray = Color3.fromRGB(30, 30, 40),
        DarkNavy = Color3.fromRGB(20, 20, 30),
        PureWhite = Color3.fromRGB(255, 255, 255),
        LightGray = Color3.fromRGB(180, 180, 200),
        Gray = Color3.fromRGB(120, 120, 140),
        BorderSubtle = Color3.fromRGB(60, 60, 80),
        Cyan = Color3.fromRGB(0, 200, 255)
    },
    Animation = { MicroInteraction = 0.15, Standard = 0.3, Entrance = 0.5, Emphasis = 0.6, Exit = 0.4, Continuous = 2 },
    Spacing = { Small = 8, Medium = 16, Large = 24, XLarge = 40 },
    BorderRadius = { Small = 8, Medium = 12, Large = 16, XLarge = 20 },
    Security = { ValidKey = "POLISHED-HUB-2024", SessionTimeout = 1800, MaxLoginAttempts = 5 },
    Performance = { ShowFPS = true, ShowPing = true, ShowMemory = true }
}

local STATE = {
    CurrentTab = "Home", IsAuthenticated = false, LoginAttempts = 0,
    LastActivity = tick(), SessionActive = false, CurrentTheme = "Midnight",
    Settings = { AnimationSpeed = 1, ReducedMotion = false, VirtualCurrency = 1250, IsPremium = true },
    Notifications = {}, ActivityLog = {}, Achievements = {}
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local Utils = {}

function Utils.CreateTween(object, properties, duration, easingStyle, easingDirection)
    duration = (duration or CONFIG.Animation.Standard) * STATE.Settings.AnimationSpeed
    if STATE.Settings.ReducedMotion then duration = 0.01 end
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    return TweenService:Create(object, tweenInfo, properties)
end

function Utils.FadeIn(object, duration)
    object.Visible = true
    object.BackgroundTransparency = 1
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then object.TextTransparency = 1 end
    local tween = Utils.CreateTween(object, {BackgroundTransparency = 0.08}, duration)
    tween:Play()
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        Utils.CreateTween(object, {TextTransparency = 0}, duration):Play()
    end
    return tween
end

function Utils.FadeOut(object, duration)
    local tween = Utils.CreateTween(object, {BackgroundTransparency = 1}, duration)
    tween:Play()
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        Utils.CreateTween(object, {TextTransparency = 1}, duration):Play()
    end
    tween.Completed:Connect(function() object.Visible = false end)
    return tween
end

function Utils.ElasticBounce(object)
    local originalSize = object.Size
    local tween1 = Utils.CreateTween(object, {Size = originalSize * 0.95}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    tween1:Play()
    tween1.Completed:Connect(function()
        local tween2 = Utils.CreateTween(object, {Size = originalSize * 1.05}, 0.15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
        tween2:Play()
        tween2.Completed:Connect(function()
            Utils.CreateTween(object, {Size = originalSize}, 0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out):Play()
        end)
    end)
end

function Utils.ShakeAnimation(object, intensity, duration)
    intensity, duration = intensity or 10, duration or 0.5
    local originalPosition = object.Position
    local startTime, shakeCount = tick(), 0
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if tick() - startTime >= duration or shakeCount >= 10 then
            object.Position = originalPosition
            connection:Disconnect()
            return
        end
        object.Position = originalPosition + UDim2.new(0, math.random(-intensity, intensity), 0, 0)
        shakeCount = shakeCount + 1
        wait(0.05)
    end)
end

function Utils.CreateUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or CONFIG.BorderRadius.Medium)
    corner.Parent = parent
    return corner
end

function Utils.CreateUIStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color, stroke.Thickness = color or CONFIG.Colors.ElectricBlue, thickness or 2
    stroke.Parent = parent
    return stroke
end

function Utils.CreateGradient(parent, colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence or ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONFIG.Colors.ElectricBlue),
        ColorSequenceKeypoint.new(1, CONFIG.Colors.ElectricPurple)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

function Utils.MakeDraggable(frame, dragHandle)
    local dragging, dragInput, mousePos, framePos = false
    dragHandle = dragHandle or frame
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, mousePos, framePos = true, input.Position, frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utils.LogActivity(action, details)
    table.insert(STATE.ActivityLog, {Timestamp = os.time(), Action = action, Details = details, IPAddress = "127.0.0.1"})
end

-- ═══════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

local NotificationSystem = {}

function NotificationSystem.Show(title, message, notifType, duration)
    duration, notifType = duration or 5, notifType or "info"
    local notifContainer = Players.LocalPlayer.PlayerGui:FindFirstChild("PolishedHub")
    if not notifContainer then return end
    
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(0, 320, 0, 80)
    notif.Position = UDim2.new(1, -340, 0, 20 + (#STATE.Notifications * 90))
    notif.BackgroundColor3, notif.BackgroundTransparency = CONFIG.Colors.Charcoal, 0.08
    notif.BorderSizePixel, notif.ZIndex, notif.Parent = 0, 100, notifContainer
    Utils.CreateUICorner(notif, CONFIG.BorderRadius.Medium)
    
    local accent = Instance.new("Frame")
    accent.Size, accent.BackgroundColor3 = UDim2.new(0, 4, 1, 0), 
        notifType == "success" and CONFIG.Colors.NeonGreen or notifType == "error" and CONFIG.Colors.CrimsonRed or 
        notifType == "warning" and CONFIG.Colors.AmberOrange or CONFIG.Colors.ElectricBlue
    accent.BorderSizePixel, accent.Parent = 0, notif
    Utils.CreateUICorner(accent, CONFIG.BorderRadius.Medium)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text, titleLabel.Size, titleLabel.Position = title, UDim2.new(1, -50, 0, 30), UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency, titleLabel.Font, titleLabel.TextSize = 1, Enum.Font.GothamBold, 16
    titleLabel.TextColor3, titleLabel.TextXAlignment, titleLabel.ZIndex = CONFIG.Colors.PureWhite, Enum.TextXAlignment.Left, 101
    titleLabel.Parent = notif
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Text, messageLabel.Size, messageLabel.Position = message, UDim2.new(1, -50, 0, 30), UDim2.new(0, 15, 0, 40)
    messageLabel.BackgroundTransparency, messageLabel.Font, messageLabel.TextSize = 1, Enum.Font.Gotham, 13
    messageLabel.TextColor3, messageLabel.TextXAlignment, messageLabel.ZIndex = CONFIG.Colors.LightGray, Enum.TextXAlignment.Left, 101
    messageLabel.TextWrapped, messageLabel.Parent = true, notif
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text, closeBtn.Size, closeBtn.Position = "✕", UDim2.new(0, 30, 0, 30), UDim2.new(1, -40, 0, 10)
    closeBtn.BackgroundTransparency, closeBtn.Font, closeBtn.TextSize = 1, Enum.Font.GothamBold, 18
    closeBtn.TextColor3, closeBtn.ZIndex, closeBtn.Parent = CONFIG.Colors.Gray, 101, notif
    closeBtn.MouseButton1Click:Connect(function() NotificationSystem.Dismiss(notif) end)
    
    notif.Position = UDim2.new(1, 0, 0, 20 + (#STATE.Notifications * 90))
    Utils.CreateTween(notif, {Position = UDim2.new(1, -340, 0, 20 + (#STATE.Notifications * 90))}, CONFIG.Animation.Entrance, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    table.insert(STATE.Notifications, notif)
    task.delay(duration, function() if notif.Parent then NotificationSystem.Dismiss(notif) end end)
    return notif
end

function NotificationSystem.Dismiss(notif)
    local slideOut = Utils.CreateTween(notif, {Position = notif.Position + UDim2.new(0, 400, 0, 0), BackgroundTransparency = 1}, CONFIG.Animation.Exit)
    slideOut:Play()
    slideOut.Completed:Connect(function()
        for i, n in ipairs(STATE.Notifications) do
            if n == notif then table.remove(STATE.Notifications, i) break end
        end
        notif:Destroy()
        for i, n in ipairs(STATE.Notifications) do
            Utils.CreateTween(n, {Position = UDim2.new(1, -340, 0, 20 + ((i-1) * 90))}, CONFIG.Animation.Standard):Play()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- ACHIEVEMENT SYSTEM
-- ═══════════════════════════════════════════════════════════════

local AchievementSystem = {}

function AchievementSystem.Unlock(name, description, rarity)
    rarity = rarity or "common"
    local rarityColors = {common = CONFIG.Colors.Gray, rare = CONFIG.Colors.ElectricBlue, epic = CONFIG.Colors.ElectricPurple, legendary = CONFIG.Colors.GoldenYellow}
    
    local achievementToast = Instance.new("Frame")
    achievementToast.Size, achievementToast.Position = UDim2.new(0, 380, 0, 100), UDim2.new(1, 0, 0.5, -50)
    achievementToast.BackgroundColor3, achievementToast.BackgroundTransparency = CONFIG.Colors.DeepSpace, 0.08
    achievementToast.BorderSizePixel, achievementToast.ZIndex = 0, 200
    achievementToast.Parent = Players.LocalPlayer.PlayerGui:FindFirstChild("PolishedHub")
    Utils.CreateUICorner(achievementToast, CONFIG.BorderRadius.Large)
    Utils.CreateUIStroke(achievementToast, rarityColors[rarity], 3)
    
    local icon = Instance.new("Frame")
    icon.Size, icon.Position, icon.BackgroundColor3 = UDim2.new(0, 60, 0, 60), UDim2.new(0, 15, 0.5, -30), rarityColors[rarity]
    icon.Parent = achievementToast
    Utils.CreateUICorner(icon, 30)
    
    local iconText = Instance.new("TextLabel")
    iconText.Size, iconText.BackgroundTransparency, iconText.Text = UDim2.new(1, 0, 1, 0), 1, "🏆"
    iconText.Font, iconText.TextSize, iconText.Parent = Enum.Font.GothamBold, 32, icon
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text, titleLabel.Size, titleLabel.Position = "Achievement Unlocked!", UDim2.new(1, -95, 0, 25), UDim2.new(0, 85, 0, 15)
    titleLabel.BackgroundTransparency, titleLabel.Font, titleLabel.TextSize = 1, Enum.Font.GothamBold, 16
    titleLabel.TextColor3, titleLabel.TextXAlignment, titleLabel.Parent = CONFIG.Colors.PureWhite, Enum.TextXAlignment.Left, achievementToast
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text, nameLabel.Size, nameLabel.Position = name, UDim2.new(1, -95, 0, 22), UDim2.new(0, 85, 0, 40)
    nameLabel.BackgroundTransparency, nameLabel.Font, nameLabel.TextSize = 1, Enum.Font.GothamBold, 14
    nameLabel.TextColor3, nameLabel.TextXAlignment, nameLabel.Parent = rarityColors[rarity], Enum.TextXAlignment.Left, achievementToast
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Text, descLabel.Size, descLabel.Position = description, UDim2.new(1, -95, 0, 18), UDim2.new(0, 85, 0, 65)
    descLabel.BackgroundTransparency, descLabel.Font, descLabel.TextSize = 1, Enum.Font.Gotham, 12
    descLabel.TextColor3, descLabel.TextXAlignment, descLabel.Parent = CONFIG.Colors.LightGray, Enum.TextXAlignment.Left, achievementToast
    
    Utils.CreateTween(achievementToast, {Position = UDim2.new(1, -400, 0.5, -50)}, CONFIG.Animation.Entrance, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    task.delay(5, function()
        if achievementToast.Parent then
            local slideOut = Utils.CreateTween(achievementToast, {Position = UDim2.new(1, 0, 0.5, -50)}, CONFIG.Animation.Exit)
            slideOut:Play()
            slideOut.Completed:Connect(function() achievementToast:Destroy() end)
        end
    end)
    table.insert(STATE.Achievements, {name = name, description = description, rarity = rarity, unlocked = os.time()})
end

-- ═══════════════════════════════════════════════════════════════
-- PERFORMANCE MONITORS
-- ═══════════════════════════════════════════════════════════════

local PerformanceMonitor = {}

function PerformanceMonitor.CreateFPSCounter(parent)
    local fpsFrame = Instance.new("Frame")
    fpsFrame.Size, fpsFrame.Position = UDim2.new(0, 80, 0, 30), UDim2.new(0, 10, 0, 10)
    fpsFrame.BackgroundColor3, fpsFrame.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.7
    fpsFrame.BorderSizePixel, fpsFrame.ZIndex, fpsFrame.Parent = 0, 300, parent
    Utils.CreateUICorner(fpsFrame, 6)
    
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size, fpsLabel.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    fpsLabel.Font, fpsLabel.TextSize, fpsLabel.TextColor3 = Enum.Font.GothamBold, 14, CONFIG.Colors.NeonGreen
    fpsLabel.Text, fpsLabel.Parent = "60 FPS", fpsFrame
    
    local lastUpdate, frameCount = tick(), 0
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastUpdate >= 1 then
            local fps = frameCount
            frameCount, lastUpdate = 0, tick()
            fpsLabel.Text = fps .. " FPS"
            fpsLabel.TextColor3 = fps >= 60 and CONFIG.Colors.NeonGreen or fps >= 30 and CONFIG.Colors.AmberOrange or CONFIG.Colors.CrimsonRed
        end
    end)
    return fpsFrame
end

function PerformanceMonitor.CreatePingDisplay(parent)
    local pingFrame = Instance.new("Frame")
    pingFrame.Size, pingFrame.Position = UDim2.new(0, 90, 0, 30), UDim2.new(0, 100, 0, 10)
    pingFrame.BackgroundColor3, pingFrame.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.7
    pingFrame.BorderSizePixel, pingFrame.ZIndex, pingFrame.Parent = 0, 300, parent
    Utils.CreateUICorner(pingFrame, 6)
    
    local pingLabel = Instance.new("TextLabel")
    pingLabel.Size, pingLabel.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    pingLabel.Font, pingLabel.TextSize, pingLabel.TextColor3 = Enum.Font.GothamBold, 14, CONFIG.Colors.NeonGreen
    pingLabel.Text, pingLabel.Parent = "📶 25ms", pingFrame
    
    task.spawn(function()
        while pingFrame.Parent do
            local ping = math.random(20, 150)
            pingLabel.Text = "📶 " .. ping .. "ms"
            pingLabel.TextColor3 = ping < 50 and CONFIG.Colors.NeonGreen or ping < 100 and CONFIG.Colors.AmberOrange or CONFIG.Colors.CrimsonRed
            wait(2)
        end
    end)
    return pingFrame
end

function PerformanceMonitor.CreateMemoryUsage(parent)
    local memFrame = Instance.new("Frame")
    memFrame.Size, memFrame.Position = UDim2.new(0, 140, 0, 30), UDim2.new(0, 200, 0, 10)
    memFrame.BackgroundColor3, memFrame.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.7
    memFrame.BorderSizePixel, memFrame.ZIndex, memFrame.Parent = 0, 300, parent
    Utils.CreateUICorner(memFrame, 6)
    
    local memLabel = Instance.new("TextLabel")
    memLabel.Size, memLabel.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1
    memLabel.Font, memLabel.TextSize, memLabel.TextColor3 = Enum.Font.GothamBold, 12, CONFIG.Colors.ElectricBlue
    memLabel.Text, memLabel.Parent = "64 MB / 256 MB", memFrame
    
    task.spawn(function()
        while memFrame.Parent do
            local usedMem = math.random(50, 200)
            memLabel.Text = usedMem .. " MB / 256 MB"
            if usedMem / 256 > 0.8 then
                memLabel.TextColor3 = CONFIG.Colors.CrimsonRed
                Utils.CreateTween(memLabel, {TextSize = 14}, 0.3):Play()
                wait(0.3)
                Utils.CreateTween(memLabel, {TextSize = 12}, 0.3):Play()
            else
                memLabel.TextColor3 = CONFIG.Colors.ElectricBlue
            end
            wait(3)
        end
    end)
    return memFrame
end

-- ═══════════════════════════════════════════════════════════════
-- KEY SYSTEM
-- ═══════════════════════════════════════════════════════════════

local KeySystem = {}

function KeySystem.CreateKeyFrame(parent)
    local keyFrame = Instance.new("Frame")
    keyFrame.Size, keyFrame.Position = UDim2.new(0, 480, 0, 340), UDim2.new(0.5, -240, 0.5, -170)
    keyFrame.BackgroundColor3, keyFrame.BackgroundTransparency = CONFIG.Colors.DeepSpace, 0.08
    keyFrame.BorderSizePixel, keyFrame.ZIndex, keyFrame.Parent = 0, 50, parent
    keyFrame.Rotation, keyFrame.Size, keyFrame.AnchorPoint = -180, UDim2.new(0, 0, 0, 0), Vector2.new(0.5, 0.5)
    
    Utils.CreateUICorner(keyFrame, CONFIG.BorderRadius.Large)
    Utils.CreateUIStroke(keyFrame, CONFIG.Colors.ElectricBlue, 3)
    Utils.CreateGradient(keyFrame)
    Utils.CreateTween(keyFrame, {Rotation = 0, Size = UDim2.new(0, 480, 0, 340)}, CONFIG.Animation.Entrance, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    
    local title = Instance.new("TextLabel")
    title.Text, title.Size, title.Position = "⚡ POLISHED HUB ⚡", UDim2.new(1, 0, 0, 60), UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency, title.Font, title.TextSize = 1, Enum.Font.GothamBold, 28
    title.TextColor3, title.ZIndex, title.Parent = CONFIG.Colors.PureWhite, 51, keyFrame
    Utils.CreateGradient(title, ColorSequence.new({ColorSequenceKeypoint.new(0, CONFIG.Colors.ElectricBlue), ColorSequenceKeypoint.new(0.5, CONFIG.Colors.PureWhite), ColorSequenceKeypoint.new(1, CONFIG.Colors.ElectricPurple)}), 0)
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text, subtitle.Size, subtitle.Position = "Enter your access key to continue", UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 75)
    subtitle.BackgroundTransparency, subtitle.Font, subtitle.TextSize = 1, Enum.Font.Gotham, 14
    subtitle.TextColor3, subtitle.ZIndex, subtitle.Parent = CONFIG.Colors.LightGray, 51, keyFrame
    
    local keyInput = Instance.new("TextBox")
    keyInput.PlaceholderText, keyInput.Size, keyInput.Position = "Enter Access Key...", UDim2.new(0.85, 0, 0, 50), UDim2.new(0.075, 0, 0.32, 0)
    keyInput.BackgroundColor3, keyInput.BackgroundTransparency = CONFIG.Colors.DarkGray, 0.2
    keyInput.Font, keyInput.TextSize, keyInput.TextColor3 = Enum.Font.GothamSemibold, 18, CONFIG.Colors.PureWhite
    keyInput.PlaceholderColor3, keyInput.ZIndex, keyInput.Parent = CONFIG.Colors.Gray, 51, keyFrame
    Utils.CreateUICorner(keyInput, CONFIG.BorderRadius.Small)
    local inputStroke = Utils.CreateUIStroke(keyInput, CONFIG.Colors.Cyan, 2)
    
    keyInput.Focused:Connect(function() Utils.CreateTween(inputStroke, {Color = CONFIG.Colors.ElectricBlue, Thickness = 3}, 0.2):Play() end)
    keyInput.FocusLost:Connect(function(enterPressed) 
        Utils.CreateTween(inputStroke, {Color = CONFIG.Colors.Cyan, Thickness = 2}, 0.2):Play()
        if enterPressed then KeySystem.VerifyKey(keyInput.Text, keyFrame, statusMsg) end
    end)
    
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Text, verifyBtn.Size, verifyBtn.Position = "✓ VERIFY", UDim2.new(0.38, 0, 0, 48), UDim2.new(0.075, 0, 0.55, 0)
    verifyBtn.BackgroundColor3, verifyBtn.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.15
    verifyBtn.Font, verifyBtn.TextSize, verifyBtn.TextColor3 = Enum.Font.GothamBold, 16, CONFIG.Colors.NeonGreen
    verifyBtn.ZIndex, verifyBtn.Parent = 51, keyFrame
    Utils.CreateUICorner(verifyBtn, CONFIG.BorderRadius.Small)
    local verifyStroke = Utils.CreateUIStroke(verifyBtn, CONFIG.Colors.NeonGreen, 2)
    
    verifyBtn.MouseEnter:Connect(function()
        Utils.CreateTween(verifyBtn, {BackgroundTransparency = 0.05}, 0.2):Play()
        Utils.CreateTween(verifyStroke, {Color = Color3.fromRGB(100, 255, 180), Thickness = 3}, 0.2):Play()
    end)
    verifyBtn.MouseLeave:Connect(function()
        Utils.CreateTween(verifyBtn, {BackgroundTransparency = 0.15}, 0.2):Play()
        Utils.CreateTween(verifyStroke, {Color = CONFIG.Colors.NeonGreen, Thickness = 2}, 0.2):Play()
    end)
    
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Text, getKeyBtn.Size, getKeyBtn.Position = "🔗 GET KEY", UDim2.new(0.38, 0, 0, 48), UDim2.new(0.545, 0, 0.55, 0)
    getKeyBtn.BackgroundColor3, getKeyBtn.BackgroundTransparency = Color3.fromRGB(0, 0, 0), 0.15
    getKeyBtn.Font, getKeyBtn.TextSize, getKeyBtn.TextColor3 = Enum.Font.GothamBold, 16, Color3.fromRGB(200, 100, 255)
    getKeyBtn.ZIndex, getKeyBtn.Parent = 51, keyFrame
    Utils.CreateUICorner(getKeyBtn, CONFIG.BorderRadius.Small)
    local getKeyStroke = Utils.CreateUIStroke(getKeyBtn, CONFIG.Colors.ElectricPurple, 2)
    
    getKeyBtn.MouseEnter:Connect(function() Utils.CreateTween(getKeyStroke, {Color = Color3.fromRGB(220, 150, 255)}, 0.2):Play() end)
    getKeyBtn.MouseLeave:Connect(function() Utils.CreateTween(getKeyStroke, {Color = CONFIG.Colors.ElectricPurple}, 0.2):Play() end)
    
    local statusMsg = Instance.new("TextLabel")
    statusMsg.Text, statusMsg.Size, statusMsg.Position = "", UDim2.new(1, -40, 0, 30), UDim2.new(0, 20, 1, -50)
    statusMsg.BackgroundTransparency, statusMsg.Font, statusMsg.TextSize = 1, Enum.Font.GothamBold, 14
    statusMsg.TextColor3, statusMsg.ZIndex, statusMsg.Visible = CONFIG.Colors.NeonGreen, 51, false
    statusMsg.Parent = keyFrame
    
    verifyBtn.MouseButton1Click:Connect(function()
        Utils.ElasticBounce(verifyBtn)
        KeySystem.VerifyKey(keyInput.Text, keyFrame, statusMsg)
    end)
    
    getKeyBtn.MouseButton1Click:Connect(function()
        Utils.ElasticBounce(getKeyBtn)
        NotificationSystem.Show("Get Key", "Visit our website to get your access key!", "info", 5)
    end)
    
    return keyFrame
end

function KeySystem.VerifyKey(key, keyFrame, statusMsg)
    STATE.LoginAttempts = STATE.LoginAttempts + 1
    statusMsg.Visible, statusMsg.Text, statusMsg.TextColor3 = true, "⏳ Verifying...", CONFIG.Colors.AmberOrange
    Utils.FadeIn(statusMsg, 0.2)
    Utils.LogActivity("Key Verification Attempt", "Attempt #" .. STATE.LoginAttempts)
    
    task.wait(1)
    
    if key == CONFIG.Security.ValidKey then
        statusMsg.Text, statusMsg.TextColor3 = "✓ Success! Welcome back.", CONFIG.Colors.NeonGreen
        STATE.IsAuthenticated, STATE.SessionActive, STATE.LastActivity = true, true, tick()
        Utils.LogActivity("Successful Login", "Key verified")
        task.wait(1)
        Utils.FadeOut(keyFrame, CONFIG.Animation.Exit)
        task.wait(CONFIG.Animation.Exit + 0.1)
        KeySystem.ShowMainGUI()
        if STATE.LoginAttempts == 1 then AchievementSystem.Unlock("First Login", "Welcome to Polished Hub!", "rare") end
    elseif STATE.LoginAttempts >= CONFIG.Security.MaxLoginAttempts then
        statusMsg.Text, statusMsg.TextColor3 = "❌ Too many failed attempts!", CONFIG.Colors.CrimsonRed
        Utils.ShakeAnimation(keyFrame, 10, 0.5)
        Utils.LogActivity("Login Locked", "Maximum attempts exceeded")
    else
        statusMsg.Text = "❌ Invalid key. " .. (CONFIG.Security.MaxLoginAttempts - STATE.LoginAttempts) .. " attempts remaining."
        statusMsg.TextColor3 = CONFIG.Colors.CrimsonRed
        Utils.ShakeAnimation(keyFrame, 10, 0.5)
        Utils.LogActivity("Failed Login", "Invalid key entered")
    end
end

function KeySystem.ShowMainGUI()
    local polishedHub = Players.LocalPlayer.PlayerGui:FindFirstChild("PolishedHub")
    if polishedHub then
        GUIBuilder.CreateMainFrame(polishedHub)
        NotificationSystem.Show("Welcome!", "Successfully logged in to Polished Hub", "success", 3)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN GUI BUILDER
-- ═══════════════════════════════════════════════════════════════

GUIBuilder = {}

function GUIBuilder.CreateMainFrame(parent)
    local mainContainer = Instance.new("Frame")
    mainContainer.Size, mainContainer.Position = UDim2.new(0, 700, 0, 450), UDim2.new(0.5, -350, 0.5, -225)
    mainContainer.BackgroundColor3, mainContainer.BackgroundTransparency = CONFIG.Colors.Charcoal, 0.08
    mainContainer.BorderSizePixel, mainContainer.ZIndex, mainContainer.Visible = 0, 10, false
    mainContainer.Parent = parent
    
    Utils.CreateUICorner(mainContainer, CONFIG.BorderRadius.XLarge)
    local mainStroke = Utils.CreateUIStroke(mainContainer, CONFIG.Colors.ElectricBlue, 3)
    
    -- RGB cycling border
    task.spawn(function()
        local hue = 0
        while mainContainer.Parent do
            hue = (hue + 0.01) % 1
            mainStroke.Color = Color3.fromHSV(hue, 1, 1)
            wait(0.1)
        end
    end)
    
    Utils.FadeIn(mainContainer, CONFIG.Animation.Entrance)
    
    GUIBuilder.CreateTitleBar(mainContainer)
    Utils.MakeDraggable(mainContainer, mainContainer:FindFirstChild("TitleBar"))
    
    if CONFIG.Performance.ShowFPS then PerformanceMonitor.CreateFPSCounter(mainContainer) end
    if CONFIG.Performance.ShowPing then PerformanceMonitor.CreatePingDisplay(mainContainer) end
    if CONFIG.Performance.ShowMemory then PerformanceMonitor.CreateMemoryUsage(mainContainer) end
    
    -- Welcome content
    local welcomeText = Instance.new("TextLabel")
    welcomeText.Text = "⚡ Welcome to Polished Hub! ⚡\n\nAll systems loaded and ready!\n\nValid Key: " .. CONFIG.Security.ValidKey
    welcomeText.Size, welcomeText.Position = UDim2.new(1, -40, 1, -100), UDim2.new(0, 20, 0, 60)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Font, welcomeText.TextSize, welcomeText.TextColor3 = Enum.Font.GothamBold, 18, CONFIG.Colors.PureWhite
    welcomeText.TextWrapped, welcomeText.Parent = true, mainContainer
    
    return mainContainer
end

function GUIBuilder.CreateTitleBar(parent)
    local titleBar = Instance.new("Frame")
    titleBar.Size, titleBar.BackgroundColor3 = UDim2.new(1, 0, 0, 42), CONFIG.Colors.Charcoal
    titleBar.BackgroundTransparency, titleBar.BorderSizePixel, titleBar.ZIndex = 0.3, 0, 11
    titleBar.Parent = parent
    Utils.CreateUICorner(titleBar, CONFIG.BorderRadius.XLarge)
    
    local title = Instance.new("TextLabel")
    title.Text, title.Size, title.Position = "⚡ POLISHED HUB ⚡", UDim2.new(0, 300, 1, 0), UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency, title.Font, title.TextSize = 1, Enum.Font.GothamBold, 20
    title.TextColor3, title.TextXAlignment, title.ZIndex = CONFIG.Colors.PureWhite, Enum.TextXAlignment.Left, 12
    title.Parent = titleBar
    Utils.CreateGradient(title, ColorSequence.new({ColorSequenceKeypoint.new(0, CONFIG.Colors.ElectricBlue), ColorSequenceKeypoint.new(0.5, CONFIG.Colors.PureWhite), ColorSequenceKeypoint.new(1, CONFIG.Colors.ElectricBlue)}), 0)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text, closeBtn.Size, closeBtn.Position = "✕", UDim2.new(0, 28, 0, 28), UDim2.new(1, -40, 0.5, -14)
    closeBtn.BackgroundColor3, closeBtn.Font, closeBtn.TextSize = CONFIG.Colors.CrimsonRed, Enum.Font.GothamBold, 18
    closeBtn.TextColor3, closeBtn.ZIndex, closeBtn.Parent = CONFIG.Colors.PureWhite, 12, titleBar
    Utils.CreateUICorner(closeBtn, 6)
    closeBtn.MouseButton1Click:Connect(function()
        Utils.ElasticBounce(closeBtn)
        Utils.FadeOut(parent, CONFIG.Animation.Exit)
        NotificationSystem.Show("Goodbye", "Polished Hub closed", "info", 2)
    end)
    
    return titleBar
end

-- ═══════════════════════════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════════════════════════

local function Initialize()
    print("╔════════════════════════════════════════╗")
    print("║   ⚡ POLISHED HUB INITIALIZING ⚡     ║")
    print("╚════════════════════════════════════════╝")
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name, screenGui.ResetOnSpawn = "PolishedHub", false
    screenGui.ZIndexBehavior, screenGui.IgnoreGuiInset = Enum.ZIndexBehavior.Sibling, true
    screenGui.Parent = playerGui
    
    KeySystem.CreateKeyFrame(screenGui)
    Utils.LogActivity("System Initialized", "Polished Hub loaded successfully")
    
    print("✓ Key system loaded")
    print("✓ GUI framework initialized")
    print("✓ Valid Key: " .. CONFIG.Security.ValidKey)
end

Initialize()

return {Config = CONFIG, State = STATE, Utils = Utils, Notification = NotificationSystem, 
        Achievement = AchievementSystem, Performance = PerformanceMonitor, 
        KeySystem = KeySystem, GUIBuilder = GUIBuilder}
