--[[
    ★ ULTRA-POLISHED KEY SYSTEM GUI ★
    Premium Glassmorphism Design | Spring Animations | Neon Accents
    Paste into a LocalScript in StarterPlayerScripts
--]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Advanced Configuration
local CONFIG = {
    DISCORD_LINK = "discord.gg/yourserver",
    VALID_KEY = "PREMIUM-2024-X",
    COLORS = {
        -- Main Palette
        BG = Color3.fromRGB(15, 15, 20),
        GLASS = Color3.fromRGB(25, 25, 35),
        GLASS_LIGHT = Color3.fromRGB(35, 35, 50),
        ACCENT = Color3.fromRGB(0, 212, 255), -- Cyan neon
        ACCENT_DARK = Color3.fromRGB(0, 150, 200),
        SECONDARY = Color3.fromRGB(157, 0, 255), -- Purple neon
        SUCCESS = Color3.fromRGB(0, 255, 136),
        ERROR = Color3.fromRGB(255, 50, 80),
        WARNING = Color3.fromRGB(255, 200, 0),
        TEXT = Color3.fromRGB(255, 255, 255),
        TEXT_DIM = Color3.fromRGB(150, 150, 170),
        GLOW = Color3.fromRGB(0, 212, 255)
    },
    ANIMATION = {
        SPRING = TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
        SMOOTH = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        BOUNCE = TweenInfo.new(0.5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
    }
}

-- Create Blur Effect for Glassmorphism
local function createBlur()
    local blur = Instance.new("BlurEffect")
    blur.Size = 20
    return blur
end

-- Enhanced Tween Function
local function tween(obj, props, info)
    local tweenInfo = info or CONFIG.ANIMATION.SMOOTH
    TweenService:Create(obj, tweenInfo, props):Play()
end

-- Create Gradient
local function createGradient(color1, color2, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    grad.Rotation = rotation or 45
    return grad
end

-- Create Glow Effect
local function createGlow(parent, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    glow.Image = "rbxassetid://6015897843"
    glow.ImageColor3 = color or CONFIG.COLORS.GLOW
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(49, 49, 450, 450)
    glow.ZIndex = -1
    glow.Parent = parent
    return glow
end

-- Create Glass Panel
local function createGlassPanel(name, parent, size, pos, zIndex)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = pos or UDim2.new()
    frame.BackgroundColor3 = CONFIG.COLORS.GLASS
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.ZIndex = zIndex or 1
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.9
    stroke.Thickness = 1
    stroke.Parent = frame
    
    local grad = createGradient(CONFIG.COLORS.GLASS, CONFIG.COLORS.GLASS_LIGHT, 90)
    grad.Parent = frame
    
    return frame
end

-- Main GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumKeySystem"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- Animated Background
local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = CONFIG.COLORS.BG
Background.Parent = ScreenGui

-- Moving Gradient Orbs (Ambient Effect)
local Orbs = {}
for i = 1, 3 do
    local orb = Instance.new("Frame")
    orb.Size = UDim2.new(0, 400, 0, 400)
    orb.BackgroundColor3 = i == 1 and CONFIG.COLORS.ACCENT or i == 2 and CONFIG.COLORS.SECONDARY or CONFIG.COLORS.SUCCESS
    orb.BackgroundTransparency = 0.9
    orb.BorderSizePixel = 0
    orb.Parent = Background
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = orb
    
    local blur = Instance.new("BlurEffect")
    blur.Size = 100
    blur.Parent = orb
    
    table.insert(Orbs, {orb = orb, speed = 0.3 + (i * 0.1), offset = i * 2})
end

-- Animate Orbs
spawn(function()
    while true do
        local time = tick()
        for i, data in ipairs(Orbs) do
            local x = math.sin(time * data.speed + data.offset) * 0.4 + 0.5
            local y = math.cos(time * data.speed * 0.7 + data.offset) * 0.4 + 0.5
            data.orb.Position = UDim2.new(x, -200, y, -200)
        end
        RunService.Heartbeat:Wait()
    end
end)

-- MAIN KEY FRAME (Glassmorphism)
local MainFrame = createGlassPanel("MainFrame", ScreenGui, 
    UDim2.new(0, 480, 0, 420), 
    UDim2.new(0.5, -240, 0.5, -210), 
    10
)

-- Glow effect
createGlow(MainFrame, CONFIG.COLORS.ACCENT)

-- Top Bar with Glass Effect
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, -20, 0, 50)
TopBar.Position = UDim2.new(0, 10, 0, 10)
TopBar.BackgroundColor3 = CONFIG.COLORS.GLASS_LIGHT
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local TopGrad = createGradient(
    Color3.fromRGB(40, 40, 60),
    Color3.fromRGB(30, 30, 45),
    90
)
TopGrad.Parent = TopBar

-- Logo/Title
local LogoContainer = Instance.new("Frame")
LogoContainer.Size = UDim2.new(0, 40, 0, 40)
LogoContainer.Position = UDim2.new(0, 10, 0.5, 0)
LogoContainer.AnchorPoint = Vector2.new(0, 0.5)
LogoContainer.BackgroundColor3 = CONFIG.COLORS.ACCENT
LogoContainer.BorderSizePixel = 0
LogoContainer.Parent = TopBar

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 10)
LogoCorner.Parent = LogoContainer

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(1, 0, 1, 0)
LogoIcon.BackgroundTransparency = 1
LogoIcon.Text = "🔐"
LogoIcon.TextSize = 22
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.Parent = LogoContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 60, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "PREMIUM ACCESS"
Title.TextColor3 = CONFIG.COLORS.TEXT
Title.TextSize = 18
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Window Controls
local function createControlButton(name, pos, color, symbol)
    local btn = Instance.new("TextButton")
    btn.Name = name.."Btn"
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = symbol
    btn.TextColor3 = CONFIG.COLORS.TEXT
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = TopBar
    btn.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.3}, CONFIG.ANIMATION.FAST)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0}, CONFIG.ANIMATION.FAST)
    end)
    
    return btn
end

local MinBtn = createControlButton("Min", UDim2.new(1, -80, 0.5, 0), CONFIG.COLORS.ACCENT, "−")
local CloseBtn = createControlButton("Close", UDim2.new(1, -40, 0.5, 0), CONFIG.COLORS.ERROR, "×")

MinBtn.AnchorPoint = Vector2.new(0, 0.5)
CloseBtn.AnchorPoint = Vector2.new(0, 0.5)

-- Content Container
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -40, 1, -80)
Content.Position = UDim2.new(0, 20, 0, 70)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Discord Promo Card (Neon Glass)
local PromoCard = createGlassPanel("PromoCard", Content,
    UDim2.new(1, 0, 0, 100),
    UDim2.new(0, 0, 0, 0),
    11
)

-- Animated gradient border
local PromoStroke = PromoCard:FindFirstChildOfClass("UIStroke")
PromoStroke.Color = CONFIG.COLORS.ACCENT
PromoStroke.Transparency = 0.7

local PromoGrad = createGradient(CONFIG.COLORS.ACCENT, CONFIG.COLORS.SECONDARY, 0)
PromoGrad.Parent = PromoCard

-- Discord Icon with Pulse Animation
local IconContainer = Instance.new("Frame")
IconContainer.Size = UDim2.new(0, 60, 0, 60)
IconContainer.Position = UDim2.new(0, 15, 0.5, 0)
IconContainer.AnchorPoint = Vector2.new(0, 0.5)
IconContainer.BackgroundColor3 = CONFIG.COLORS.ACCENT
IconContainer.BorderSizePixel = 0
IconContainer.Parent = PromoCard

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 16)
IconCorner.Parent = IconContainer

local IconGlow = createGlow(IconContainer, CONFIG.COLORS.ACCENT)
IconGlow.ImageTransparency = 0.6

local DiscordIcon = Instance.new("ImageLabel")
DiscordIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
DiscordIcon.Position = UDim2.new(0.2, 0, 0.2, 0)
DiscordIcon.BackgroundTransparency = 1
DiscordIcon.Image = "rbxassetid://3926305904"
DiscordIcon.ImageRectOffset = Vector2.new(4, 844)
DiscordIcon.ImageRectSize = Vector2.new(36, 36)
DiscordIcon.ImageColor3 = CONFIG.COLORS.TEXT
DiscordIcon.Parent = IconContainer

-- Pulse animation for icon
spawn(function()
    while true do
        tween(IconContainer, {Size = UDim2.new(0, 65, 0, 65)}, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
        wait(1)
        tween(IconContainer, {Size = UDim2.new(0, 60, 0, 60)}, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
        wait(1)
    end
end)

local PromoTitle = Instance.new("TextLabel")
PromoTitle.Size = UDim2.new(1, -100, 0, 25)
PromoTitle.Position = UDim2.new(0, 90, 0.2, 0)
PromoTitle.BackgroundTransparency = 1
PromoTitle.Text = "100% FREE KEY"
PromoTitle.TextColor3 = CONFIG.COLORS.ACCENT
PromoTitle.TextSize = 20
PromoTitle.Font = Enum.Font.GothamBlack
PromoTitle.TextXAlignment = Enum.TextXAlignment.Left
PromoTitle.Parent = PromoCard

local PromoDesc = Instance.new("TextLabel")
PromoDesc.Size = UDim2.new(1, -100, 0, 40)
PromoDesc.Position = UDim2.new(0, 90, 0.5, 0)
PromoDesc.BackgroundTransparency = 1
PromoDesc.Text = "Get your premium access key from our Discord server. No payment required!"
PromoDesc.TextColor3 = CONFIG.COLORS.TEXT_DIM
PromoDesc.TextSize = 13
PromoDesc.Font = Enum.Font.Gotham
PromoDesc.TextXAlignment = Enum.TextXAlignment.Left
PromoDesc.TextWrapped = true
PromoDesc.Parent = PromoCard

-- Key Input Section
local InputSection = Instance.new("Frame")
InputSection.Size = UDim2.new(1, 0, 0, 120)
InputSection.Position = UDim2.new(0, 0, 0, 120)
InputSection.BackgroundTransparency = 1
InputSection.Parent = Content

local InputLabel = Instance.new("TextLabel")
InputLabel.Size = UDim2.new(1, 0, 0, 20)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "ENTER ACCESS KEY"
InputLabel.TextColor3 = CONFIG.COLORS.TEXT_DIM
InputLabel.TextSize = 11
InputLabel.Font = Enum.Font.GothamBold
InputLabel.TextXAlignment = Enum.TextXAlignment.Left
InputLabel.Parent = InputSection

-- Input Box with Neon Focus
local InputBox = Instance.new("TextBox")
InputBox.Name = "KeyInput"
InputBox.Size = UDim2.new(1, 0, 0, 55)
InputBox.Position = UDim2.new(0, 0, 0, 25)
InputBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
InputBox.BackgroundTransparency = 0.5
InputBox.Text = ""
InputBox.PlaceholderText = "XXXX-XXXX-XXXX"
InputBox.TextColor3 = CONFIG.COLORS.TEXT
InputBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 100)
InputBox.TextSize = 18
InputBox.Font = Enum.Font.GothamBold
InputBox.ClearTextOnFocus = false
InputBox.TextXAlignment = Enum.TextXAlignment.Center
InputBox.Parent = InputSection

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 12)
InputCorner.Parent = InputBox

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = CONFIG.COLORS.ACCENT
InputStroke.Transparency = 0.8
InputStroke.Thickness = 2
InputStroke.Parent = InputBox

-- Focus animation
InputBox.Focused:Connect(function()
    tween(InputStroke, {Transparency = 0}, CONFIG.ANIMATION.FAST)
    tween(InputBox, {BackgroundTransparency = 0.2}, CONFIG.ANIMATION.FAST)
end)

InputBox.FocusLost:Connect(function()
    tween(InputStroke, {Transparency = 0.8}, CONFIG.ANIMATION.FAST)
    tween(InputBox, {BackgroundTransparency = 0.5}, CONFIG.ANIMATION.FAST)
end)

-- Status Text
local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 85)
StatusText.BackgroundTransparency = 1
StatusText.Text = ""
StatusText.TextColor3 = CONFIG.COLORS.ERROR
StatusText.TextSize = 12
StatusText.Font = Enum.Font.GothamBold
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.Parent = InputSection

-- Button Container
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 55)
ButtonContainer.Position = UDim2.new(0, 0, 0, 260)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = Content

-- Neon Button Creator
local function createNeonButton(name, text, color, pos, size)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = size or UDim2.new(0.48, 0, 1, 0)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = CONFIG.COLORS.TEXT
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBlack
    btn.AutoButtonColor = false
    btn.Parent = ButtonContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    
    local glow = createGlow(btn, color)
    glow.ImageTransparency = 0.9
    
    -- Gradient overlay
    local grad = createGradient(
        Color3.new(1, 1, 1),
        Color3.new(1, 1, 1),
        90
    )
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 1)
    })
    grad.Parent = btn
    
    -- Hover effects
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}, CONFIG.ANIMATION.FAST)
        tween(glow, {ImageTransparency = 0.6}, CONFIG.ANIMATION.FAST)
        tween(btn, {Size = UDim2.new(btn.Size.X.Scale, 5, 1, 5)}, CONFIG.ANIMATION.FAST)
    end)
    
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = color}, CONFIG.ANIMATION.FAST)
        tween(glow, {ImageTransparency = 0.9}, CONFIG.ANIMATION.FAST)
        tween(btn, {Size = size or UDim2.new(0.48, 0, 1, 0)}, CONFIG.ANIMATION.FAST)
    end)
    
    btn.MouseButton1Down:Connect(function()
        tween(btn, {Size = UDim2.new(btn.Size.X.Scale, -3, 1, -3)}, TweenInfo.new(0.1))
    end)
    
    btn.MouseButton1Up:Connect(function()
        tween(btn, {Size = UDim2.new(btn.Size.X.Scale, 5, 1, 5)}, TweenInfo.new(0.1))
    end)
    
    return btn
end

local GetKeyBtn = createNeonButton("GetKeyBtn", "📋 GET KEY", CONFIG.COLORS.SECONDARY, UDim2.new(0, 0, 0, 0))
local VerifyBtn = createNeonButton("VerifyBtn", "VERIFY →", CONFIG.COLORS.SUCCESS, UDim2.new(0.52, 0, 0, 0))

-- Minimized Floating Button (Premium Style)
local MinimizedBtn = Instance.new("TextButton")
MinimizedBtn.Name = "MinimizedBtn"
MinimizedBtn.Size = UDim2.new(0, 60, 0, 60)
MinimizedBtn.Position = UDim2.new(0, 30, 0.5, 0)
MinimizedBtn.BackgroundColor3 = CONFIG.COLORS.ACCENT
MinimizedBtn.Text = "🔐"
MinimizedBtn.TextSize = 28
MinimizedBtn.Font = Enum.Font.GothamBold
MinimizedBtn.Visible = false
MinimizedBtn.Parent = ScreenGui

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizedBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Color = CONFIG.COLORS.TEXT
MinStroke.Thickness = 3
MinStroke.Transparency = 0.8
MinStroke.Parent = MinimizedBtn

local MinGlow = createGlow(MinimizedBtn, CONFIG.COLORS.ACCENT)
MinGlow.Size = UDim2.new(2, 0, 2, 0)

-- Minimized button animation
spawn(function()
    while true do
        if MinimizedBtn.Visible then
            tween(MinStroke, {Transparency = 0.4}, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
            wait(1)
            tween(MinStroke, {Transparency = 0.8}, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
            wait(1)
        else
            wait(0.5)
        end
    end
end)

-- PREMIUM MAIN PANEL (After Verification)
local MainPanel = createGlassPanel("MainPanel", ScreenGui,
    UDim2.new(0, 700, 0, 500),
    UDim2.new(0.5, -350, 0.5, -250),
    20
)
MainPanel.Visible = false

local PanelGlow = createGlow(MainPanel, CONFIG.COLORS.SECONDARY)
PanelGlow.Size = UDim2.new(1.3, 0, 1.3, 0)

-- Panel Header with Tabs
local PanelHeader = Instance.new("Frame")
PanelHeader.Size = UDim2.new(1, -30, 0, 60)
PanelHeader.Position = UDim2.new(0, 15, 0, 15)
PanelHeader.BackgroundColor3 = CONFIG.COLORS.GLASS_LIGHT
PanelHeader.BackgroundTransparency = 0.3
PanelHeader.BorderSizePixel = 0
PanelHeader.Parent = MainPanel

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = PanelHeader

local HeaderGrad = createGradient(
    Color3.fromRGB(50, 50, 70),
    Color3.fromRGB(35, 35, 55),
    90
)
HeaderGrad.Parent = PanelHeader

-- Panel Title
local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(0, 300, 1, 0)
PanelTitle.Position = UDim2.new(0, 20, 0, 0)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "✨ PREMIUM HUB"
PanelTitle.TextColor3 = CONFIG.COLORS.TEXT
PanelTitle.TextSize = 22
PanelTitle.Font = Enum.Font.GothamBlack
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.Parent = PanelHeader

-- Panel Controls
local PanelMin = createControlButton("PanelMin", UDim2.new(1, -80, 0.5, 0), CONFIG.COLORS.ACCENT, "−")
local PanelClose = createControlButton("PanelClose", UDim2.new(1, -40, 0.5, 0), CONFIG.COLORS.ERROR, "×")
PanelMin.Parent = PanelHeader
PanelClose.Parent = PanelHeader

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -30, 0, 45)
TabContainer.Position = UDim2.new(0, 15, 0, 85)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainPanel

local tabs = {"Auto Farm", "Combat", "Visuals", "Misc", "Settings"}
local TabButtons = {}

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.18, -8, 1, 0)
    tabBtn.Position = UDim2.new(0.2 * (i-1), 0, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and CONFIG.COLORS.ACCENT or CONFIG.COLORS.GLASS
    tabBtn.BackgroundTransparency = i == 1 and 0.2 or 0.5
    tabBtn.Text = tabName
    tabBtn.TextColor3 = CONFIG.COLORS.TEXT
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tabBtn
    
    if i == 1 then
        createGlow(tabBtn, CONFIG.COLORS.ACCENT)
    end
    
    tabBtn.MouseEnter:Connect(function()
        if tabBtn.BackgroundTransparency > 0.3 then
            tween(tabBtn, {BackgroundTransparency = 0.3}, CONFIG.ANIMATION.FAST)
        end
    end)
    
    tabBtn.MouseLeave:Connect(function()
        if tabBtn.BackgroundTransparency < 0.5 and tabBtn ~= TabButtons[1] then
            tween(tabBtn, {BackgroundTransparency = 0.5}, CONFIG.ANIMATION.FAST)
        end
    end)
    
    table.insert(TabButtons, tabBtn)
end

-- Content Area with Glass Cards
local PanelContent = Instance.new("Frame")
PanelContent.Size = UDim2.new(1, -30, 1, -150)
PanelContent.Position = UDim2.new(0, 15, 0, 140)
PanelContent.BackgroundTransparency = 1
PanelContent.Parent = MainPanel

-- Feature Grid
local features = {
    {name = "Auto Clicker", desc = "Automated clicking", icon = "⚡", color = CONFIG.COLORS.WARNING},
    {name = "ESP Boxes", desc = "See through walls", icon = "👁", color = CONFIG.COLORS.ERROR},
    {name = "Speed Boost", desc = "2x movement speed", icon = "💨", color = CONFIG.COLORS.SUCCESS},
    {name = "Auto Loot", desc = "Collect items", icon = "💰", color = CONFIG.COLORS.ACCENT},
    {name = "Aimbot", desc = "Precision targeting", icon = "🎯", color = CONFIG.COLORS.SECONDARY},
    {name = "Fly Mode", desc = "Ascend freely", icon = "🕊", color = Color3.fromRGB(255, 100, 200)}
}

for i, feature in ipairs(features) do
    local row = math.floor((i-1) / 3)
    local col = (i-1) % 3
    
    local card = createGlassPanel(feature.name.."Card", PanelContent,
        UDim2.new(0.32, -10, 0, 140),
        UDim2.new(0.34 * col, 5, 0, row * 155),
        21
    )
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0.5, 0, 0, 15)
    icon.AnchorPoint = Vector2.new(0.5, 0)
    icon.BackgroundColor3 = feature.color
    icon.BackgroundTransparency = 0.8
    icon.Text = feature.icon
    icon.TextSize = 28
    icon.Font = Enum.Font.GothamBold
    icon.Parent = card
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 12)
    iconCorner.Parent = icon
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 75)
    title.BackgroundTransparency = 1
    title.Text = feature.name
    title.TextColor3 = CONFIG.COLORS.TEXT
    title.TextSize = 14
    title.Font = Enum.Font.GothamBlack
    title.Parent = card
    
    -- Desc
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 30)
    desc.Position = UDim2.new(0, 10, 0, 100)
    desc.BackgroundTransparency = 1
    desc.Text = feature.desc
    desc.TextColor3 = CONFIG.COLORS.TEXT_DIM
    desc.TextSize = 11
    desc.Font = Enum.Font.Gotham
    desc.TextWrapped = true
    desc.Parent = card
    
    -- Toggle Button
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.8, 0, 0, 30)
    toggle.Position = UDim2.new(0.1, 0, 1, -40)
    toggle.BackgroundColor3 = CONFIG.COLORS.SUCCESS
    toggle.Text = "ENABLE"
    toggle.TextColor3 = CONFIG.COLORS.TEXT
    toggle.TextSize = 11
    toggle.Font = Enum.Font.GothamBold
    toggle.AutoButtonColor = false
    toggle.Parent = card
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggle
    
    -- Card hover
    card.MouseEnter:Connect(function()
        tween(card, {BackgroundTransparency = 0.1}, CONFIG.ANIMATION.FAST)
        tween(icon, {BackgroundTransparency = 0.3}, CONFIG.ANIMATION.FAST)
    end)
    
    card.MouseLeave:Connect(function()
        tween(card, {BackgroundTransparency = 0.3}, CONFIG.ANIMATION.FAST)
        tween(icon, {BackgroundTransparency = 0.8}, CONFIG.ANIMATION.FAST)
    end)
    
    -- Toggle functionality
    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        tween(toggle, {Size = UDim2.new(0.7, 0, 0, 30)}, TweenInfo.new(0.1))
        wait(0.1)
        tween(toggle, {Size = UDim2.new(0.8, 0, 0, 30)}, TweenInfo.new(0.1))
        
        if enabled then
            toggle.Text = "DISABLE"
            toggle.BackgroundColor3 = CONFIG.COLORS.ERROR
        else
            toggle.Text = "ENABLE"
            toggle.BackgroundColor3 = CONFIG.COLORS.SUCCESS
        end
    end)
end

-- DRAGGING SYSTEM (Smooth)
local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            -- Scale effect
            tween(frame, {Size = frame.Size + UDim2.new(0, 10, 0, 10)}, CONFIG.ANIMATION.FAST)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    handle.InputEnded:Connect(function()
        if dragging then
            dragging = false
            tween(frame, {Size = frame.Size - UDim2.new(0, 10, 0, 10)}, CONFIG.ANIMATION.FAST)
        end
    end)
end

makeDraggable(MainFrame, TopBar)
makeDraggable(MainPanel, PanelHeader)
makeDraggable(MinimizedBtn)

-- BUTTON FUNCTIONALITY

-- Copy Discord Link
GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(CONFIG.DISCORD_LINK)
        StatusText.TextColor3 = CONFIG.COLORS.SUCCESS
        StatusText.Text = "✓ Discord link copied to clipboard!"
    else
        StatusText.TextColor3 = CONFIG.COLORS.WARNING
        StatusText.Text = "⚠ Manual copy: "..CONFIG.DISCORD_LINK
    end
    
    -- Button press effect
    tween(GetKeyBtn, {Position = UDim2.new(0, 2, 0, 2)}, TweenInfo.new(0.05))
    wait(0.05)
    tween(GetKeyBtn, {Position = UDim2.new(0, 0, 0, 0)}, TweenInfo.new(0.05))
    
    wait(3)
    StatusText.Text = ""
end)

-- Verify Key
VerifyBtn.MouseButton1Click:Connect(function()
    local key = InputBox.Text:gsub("%s+", "")
    
    -- Loading animation
    local originalText = VerifyBtn.Text
    VerifyBtn.Text = "..."
    tween(VerifyBtn, {BackgroundColor3 = CONFIG.COLORS.WARNING}, CONFIG.ANIMATION.FAST)
    
    wait(0.8)
    
    if key == CONFIG.VALID_KEY then
        -- Success sequence
        StatusText.TextColor3 = CONFIG.COLORS.SUCCESS
        StatusText.Text = "✓ Access granted! Welcome."
        
        tween(VerifyBtn, {BackgroundColor3 = CONFIG.COLORS.SUCCESS}, CONFIG.ANIMATION.FAST)
        VerifyBtn.Text = originalText
        
        wait(0.5)
        
        -- Transition to main panel
        tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In))
        
        wait(0.5)
        MainFrame.Visible = false
        MinimizedBtn.Visible = false
        
        MainPanel.Visible = true
        MainPanel.Size = UDim2.new(0, 0, 0, 0)
        tween(MainPanel, {Size = UDim2.new(0, 700, 0, 500)}, CONFIG.ANIMATION.SPRING)
        
        -- Success notification
        local notif = createGlassPanel("Notification", ScreenGui,
            UDim2.new(0, 350, 0, 70),
            UDim2.new(0.5, -175, 0, -100),
            100
        )
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, -30, 1, 0)
        notifText.Position = UDim2.new(0, 15, 0, 0)
        notifText.BackgroundTransparency = 1
        notifText.Text = "🎉 Premium Access Activated!\nEnjoy all features."
        notifText.TextColor3 = CONFIG.COLORS.TEXT
        notifText.TextSize = 14
        notifText.Font = Enum.Font.GothamBold
        notifText.TextWrapped = true
        notifText.Parent = notif
        
        notif.BackgroundColor3 = CONFIG.COLORS.SUCCESS
        
        tween(notif, {Position = UDim2.new(0.5, -175, 0, 30)}, CONFIG.ANIMATION.BOUNCE)
        wait(4)
        tween(notif, {Position = UDim2.new(0.5, -175, 0, -100)}, CONFIG.ANIMATION.SMOOTH)
        wait(0.5)
        notif:Destroy()
        
    else
        -- Error animation
        tween(VerifyBtn, {BackgroundColor3 = CONFIG.COLORS.ERROR}, CONFIG.ANIMATION.FAST)
        VerifyBtn.Text = originalText
        
        StatusText.TextColor3 = CONFIG.COLORS.ERROR
        StatusText.Text = "✗ Invalid key! Try again."
        InputBox.Text = ""
        
        -- Shake effect
        for i = 1, 6 do
            InputBox.Position = UDim2.new(0, math.random(-8, 8), 0, 25)
            wait(0.05)
        end
        InputBox.Position = UDim2.new(0, 0, 0, 25)
        
        wait(0.5)
        tween(VerifyBtn, {BackgroundColor3 = CONFIG.COLORS.SUCCESS}, CONFIG.ANIMATION.FAST)
    end
end)

-- Minimize Key Frame
MinBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In))
    wait(0.4)
    MainFrame.Visible = false
    MinimizedBtn.Visible = true
    tween(MinimizedBtn, {Size = UDim2.new(0, 65, 0, 65)}, CONFIG.ANIMATION.BOUNCE)
end)

-- Close Key Frame
CloseBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In))
    wait(0.4)
    MainFrame.Visible = false
    MinimizedBtn.Visible = true
    tween(MinimizedBtn, {Size = UDim2.new(0, 60, 0, 60)}, CONFIG.ANIMATION.BOUNCE)
end)

-- Restore from Minimized
MinimizedBtn.MouseButton1Click:Connect(function()
    if MainPanel.Visible then
        tween(MainPanel, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In))
        wait(0.3)
        MainPanel.Visible = false
    end
    
    MainFrame.Visible = true
    tween(MinimizedBtn, {Size = UDim2.new(0, 0, 0, 0)}, CONFIG.ANIMATION.FAST)
    wait(0.2)
    MinimizedBtn.Visible = false
    
    tween(MainFrame, {Size = UDim2.new(0, 480, 0, 420), Position = UDim2.new(0.5, -240, 0.5, -210)}, 
        CONFIG.ANIMATION.SPRING)
end)

-- Panel Controls
PanelMin.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
    MinimizedBtn.Visible = true
    tween(MinimizedBtn, {Size = UDim2.new(0, 65, 0, 65)}, CONFIG.ANIMATION.BOUNCE)
end)

PanelClose.MouseButton1Click:Connect(function()
    tween(MainPanel, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In))
    wait(0.4)
    MainPanel.Visible = false
    MinimizedBtn.Visible = true
    tween(MinimizedBtn, {Size = UDim2.new(0, 60, 0, 60)}, CONFIG.ANIMATION.BOUNCE)
end)

-- OPENING ANIMATION
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1

wait(0.5)

tween(MainFrame, {Size = UDim2.new(0, 480, 0, 420)}, CONFIG.ANIMATION.SPRING)
tween(MainFrame, {BackgroundTransparency = 0.3}, TweenInfo.new(0.5))

print("✓ Premium Key System Loaded Successfully!")
