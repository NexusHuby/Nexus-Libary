--[[
   KEY SYSTEM GUI - Paste this ENTIRE script into a LocalScript in StarterPlayerScripts
   Roblox Lua Key System with Discord Promo, Draggable UI, and Minimize/Restore functionality
--]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
   DISCORD_LINK = "YOUR_DISCORD_INVITE_HERE", -- Replace with actual Discord invite
   VALID_KEY = "FREE-2024-KEY",
   THEME = {
       PRIMARY = Color3.fromRGB(88, 101, 242),    -- Discord blurple
       SECONDARY = Color3.fromRGB(47, 49, 54),     -- Dark gray
       ACCENT = Color3.fromRGB(237, 66, 69),       -- Red
       SUCCESS = Color3.fromRGB(59, 165, 93),      -- Green
       TEXT = Color3.fromRGB(255, 255, 255),
       TEXT_DIM = Color3.fromRGB(185, 187, 190),
       BACKGROUND = Color3.fromRGB(32, 34, 37)
   }
}

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemV2"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999

-- MAIN FRAME (Key System)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = CONFIG.THEME.BACKGROUND
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Rounded corners for main frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Image = "rbxassetid://6015897843"
Shadow.ImageColor3 = Color3.new(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = CONFIG.THEME.SECONDARY
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = CONFIG.THEME.SECONDARY
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔐 KEY SYSTEM"
Title.TextColor3 = CONFIG.THEME.TEXT
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -10, 0.5, 0)
CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
CloseBtn.BackgroundColor3 = CONFIG.THEME.ACCENT
CloseBtn.Text = "X"
CloseBtn.TextColor3 = CONFIG.THEME.TEXT
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Minimize Button (-)
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -45, 0.5, 0)
MinBtn.AnchorPoint = Vector2.new(1, 0.5)
MinBtn.BackgroundColor3 = CONFIG.THEME.PRIMARY
MinBtn.Text = "-"
MinBtn.TextColor3 = CONFIG.THEME.TEXT
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- CONTENT AREA
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -40, 1, -60)
Content.Position = UDim2.new(0, 20, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Discord Promo Section
local PromoFrame = Instance.new("Frame")
PromoFrame.Name = "PromoFrame"
PromoFrame.Size = UDim2.new(1, 0, 0, 80)
PromoFrame.BackgroundColor3 = CONFIG.THEME.PRIMARY
PromoFrame.BorderSizePixel = 0
PromoFrame.Parent = Content

local PromoCorner = Instance.new("UICorner")
PromoCorner.CornerRadius = UDim.new(0, 10)
PromoCorner.Parent = PromoFrame

local DiscordIcon = Instance.new("ImageLabel")
DiscordIcon.Name = "DiscordIcon"
DiscordIcon.Size = UDim2.new(0, 50, 0, 50)
DiscordIcon.Position = UDim2.new(0, 15, 0.5, 0)
DiscordIcon.AnchorPoint = Vector2.new(0, 0.5)
DiscordIcon.BackgroundTransparency = 1
DiscordIcon.Image = "rbxassetid://3926307971" -- Discord-like icon
DiscordIcon.ImageRectOffset = Vector2.new(724, 724)
DiscordIcon.ImageRectSize = Vector2.new(72, 72)
DiscordIcon.Parent = PromoFrame

local PromoText = Instance.new("TextLabel")
PromoText.Name = "PromoText"
PromoText.Size = UDim2.new(1, -80, 0, 20)
PromoText.Position = UDim2.new(0, 75, 0.3, 0)
PromoText.BackgroundTransparency = 1
PromoText.Text = "🎉 KEY IS 100% FREE!"
PromoText.TextColor3 = CONFIG.THEME.TEXT
PromoText.TextSize = 16
PromoText.Font = Enum.Font.GothamBold
PromoText.TextXAlignment = Enum.TextXAlignment.Left
PromoText.Parent = PromoFrame

local SubPromoText = Instance.new("TextLabel")
SubPromoText.Name = "SubPromoText"
SubPromoText.Size = UDim2.new(1, -80, 0, 20)
SubPromoText.Position = UDim2.new(0, 75, 0.6, 0)
SubPromoText.BackgroundTransparency = 1
SubPromoText.Text = "Get your key on our Discord server"
SubPromoText.TextColor3 = Color3.fromRGB(220, 221, 222)
SubPromoText.TextSize = 14
SubPromoText.Font = Enum.Font.Gotham
SubPromoText.TextXAlignment = Enum.TextXAlignment.Left
SubPromoText.Parent = PromoFrame

-- Key Input Section
local InputFrame = Instance.new("Frame")
InputFrame.Name = "InputFrame"
InputFrame.Size = UDim2.new(1, 0, 0, 100)
InputFrame.Position = UDim2.new(0, 0, 0, 95)
InputFrame.BackgroundTransparency = 1
InputFrame.Parent = Content

local KeyLabel = Instance.new("TextLabel")
KeyLabel.Name = "KeyLabel"
KeyLabel.Size = UDim2.new(1, 0, 0, 20)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "ENTER YOUR KEY"
KeyLabel.TextColor3 = CONFIG.THEME.TEXT_DIM
KeyLabel.TextSize = 12
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = InputFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Name = "KeyBox"
KeyBox.Size = UDim2.new(1, 0, 0, 45)
KeyBox.Position = UDim2.new(0, 0, 0, 25)
KeyBox.BackgroundColor3 = CONFIG.THEME.SECONDARY
KeyBox.Text = ""
KeyBox.PlaceholderText = "Paste key here..."
KeyBox.TextColor3 = CONFIG.THEME.TEXT
KeyBox.PlaceholderColor3 = CONFIG.THEME.TEXT_DIM
KeyBox.TextSize = 14
KeyBox.Font = Enum.Font.Gotham
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = InputFrame

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 8)
KeyCorner.Parent = KeyBox

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = CONFIG.THEME.PRIMARY
KeyStroke.Thickness = 1
KeyStroke.Transparency = 0.8
KeyStroke.Parent = KeyBox

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 75)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = CONFIG.THEME.ACCENT
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = InputFrame

-- Buttons Container
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Name = "ButtonFrame"
ButtonFrame.Size = UDim2.new(1, 0, 0, 50)
ButtonFrame.Position = UDim2.new(0, 0, 0, 210)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = Content

-- Get Key Button
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Name = "GetKeyBtn"
GetKeyBtn.Size = UDim2.new(0.48, 0, 1, 0)
GetKeyBtn.BackgroundColor3 = CONFIG.THEME.SECONDARY
GetKeyBtn.Text = "📋 Get Key"
GetKeyBtn.TextColor3 = CONFIG.THEME.TEXT
GetKeyBtn.TextSize = 14
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Parent = ButtonFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 8)
GetKeyCorner.Parent = GetKeyBtn

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = CONFIG.THEME.TEXT_DIM
GetKeyStroke.Thickness = 1
GetKeyStroke.Transparency = 0.5
GetKeyStroke.Parent = GetKeyBtn

-- Verify Button
local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Name = "VerifyBtn"
VerifyBtn.Size = UDim2.new(0.48, 0, 1, 0)
VerifyBtn.Position = UDim2.new(0.52, 0, 0, 0)
VerifyBtn.BackgroundColor3 = CONFIG.THEME.SUCCESS
VerifyBtn.Text = "✓ Verify"
VerifyBtn.TextColor3 = CONFIG.THEME.TEXT
VerifyBtn.TextSize = 14
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Parent = ButtonFrame

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 8)
VerifyCorner.Parent = VerifyBtn

-- Minimized Button (Floating Toggle)
local MinimizedBtn = Instance.new("TextButton")
MinimizedBtn.Name = "MinimizedBtn"
MinimizedBtn.Size = UDim2.new(0, 50, 0, 50)
MinimizedBtn.Position = UDim2.new(0, 20, 0.5, 0)
MinimizedBtn.BackgroundColor3 = CONFIG.THEME.PRIMARY
MinimizedBtn.Text = "🔐"
MinimizedBtn.TextSize = 24
MinimizedBtn.Font = Enum.Font.GothamBold
MinimizedBtn.Visible = false
MinimizedBtn.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(1, 0) -- Circle
MinimizedCorner.Parent = MinimizedBtn

local MinimizedStroke = Instance.new("UIStroke")
MinimizedStroke.Color = CONFIG.THEME.TEXT
MinimizedStroke.Thickness = 2
MinimizedStroke.Parent = MinimizedBtn

local MinimizedShadow = Instance.new("ImageLabel")
MinimizedShadow.Name = "Shadow"
MinimizedShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MinimizedShadow.BackgroundTransparency = 1
MinimizedShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
MinimizedShadow.Size = UDim2.new(1, 20, 1, 20)
MinimizedShadow.Image = "rbxassetid://6015897843"
MinimizedShadow.ImageColor3 = Color3.new(0, 0, 0)
MinimizedShadow.ImageTransparency = 0.6
MinimizedShadow.ScaleType = Enum.ScaleType.Slice
MinimizedShadow.SliceCenter = Rect.new(49, 49, 450, 450)
MinimizedShadow.ZIndex = -1
MinimizedShadow.Parent = MinimizedBtn

-- MAIN PANEL (After verification - Design this however you want!)
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 600, 0, 400)
MainPanel.Position = UDim2.new(0.5, -300, 0.5, -200)
MainPanel.BackgroundColor3 = CONFIG.THEME.BACKGROUND
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 16)
PanelCorner.Parent = MainPanel

local PanelShadow = Instance.new("ImageLabel")
PanelShadow.Name = "Shadow"
PanelShadow.AnchorPoint = Vector2.new(0.5, 0.5)
PanelShadow.BackgroundTransparency = 1
PanelShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
PanelShadow.Size = UDim2.new(1, 40, 1, 40)
PanelShadow.Image = "rbxassetid://6015897843"
PanelShadow.ImageColor3 = Color3.new(0, 0, 0)
PanelShadow.ImageTransparency = 0.4
PanelShadow.ScaleType = Enum.ScaleType.Slice
PanelShadow.SliceCenter = Rect.new(49, 49, 450, 450)
PanelShadow.ZIndex = -1
PanelShadow.Parent = MainPanel

-- Panel Top Bar
local PanelTopBar = Instance.new("Frame")
PanelTopBar.Name = "TopBar"
PanelTopBar.Size = UDim2.new(1, 0, 0, 50)
PanelTopBar.BackgroundColor3 = CONFIG.THEME.PRIMARY
PanelTopBar.BorderSizePixel = 0
PanelTopBar.Parent = MainPanel

local PanelTopCorner = Instance.new("UICorner")
PanelTopCorner.CornerRadius = UDim.new(0, 16)
PanelTopCorner.Parent = PanelTopBar

local PanelTopFix = Instance.new("Frame")
PanelTopFix.Size = UDim2.new(1, 0, 0, 15)
PanelTopFix.Position = UDim2.new(0, 0, 1, -15)
PanelTopFix.BackgroundColor3 = CONFIG.THEME.PRIMARY
PanelTopFix.BorderSizePixel = 0
PanelTopFix.Parent = PanelTopBar

local PanelTitle = Instance.new("TextLabel")
PanelTitle.Size = UDim2.new(0, 300, 1, 0)
PanelTitle.Position = UDim2.new(0, 20, 0, 0)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Text = "✨ PREMIUM HUB"
PanelTitle.TextColor3 = CONFIG.THEME.TEXT
PanelTitle.TextSize = 22
PanelTitle.Font = Enum.Font.GothamBlack
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.Parent = PanelTopBar

local PanelClose = Instance.new("TextButton")
PanelClose.Size = UDim2.new(0, 35, 0, 35)
PanelClose.Position = UDim2.new(1, -15, 0.5, 0)
PanelClose.AnchorPoint = Vector2.new(1, 0.5)
PanelClose.BackgroundColor3 = CONFIG.THEME.ACCENT
PanelClose.Text = "×"
PanelClose.TextColor3 = CONFIG.THEME.TEXT
PanelClose.TextSize = 24
PanelClose.Font = Enum.Font.GothamBold
PanelClose.Parent = PanelTopBar

local PanelCloseCorner = Instance.new("UICorner")
PanelCloseCorner.CornerRadius = UDim.new(0, 8)
PanelCloseCorner.Parent = PanelClose

local PanelMin = Instance.new("TextButton")
PanelMin.Size = UDim2.new(0, 35, 0, 35)
PanelMin.Position = UDim2.new(1, -55, 0.5, 0)
PanelMin.AnchorPoint = Vector2.new(1, 0.5)
PanelMin.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
PanelMin.Text = "−"
PanelMin.TextColor3 = CONFIG.THEME.TEXT
PanelMin.TextSize = 24
PanelMin.Font = Enum.Font.GothamBold
PanelMin.Parent = PanelTopBar

local PanelMinCorner = Instance.new("UICorner")
PanelMinCorner.CornerRadius = UDim.new(0, 8)
PanelMinCorner.Parent = PanelMin

-- COOL PANEL CONTENT - Add your features here!
local PanelContent = Instance.new("Frame")
PanelContent.Name = "Content"
PanelContent.Size = UDim2.new(1, -40, 1, -70)
PanelContent.Position = UDim2.new(0, 20, 0, 60)
PanelContent.BackgroundTransparency = 1
PanelContent.Parent = MainPanel

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = CONFIG.THEME.SECONDARY
Sidebar.BorderSizePixel = 0
Sidebar.Parent = PanelContent

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

-- Feature Buttons
local features = {
   {name = "Auto Farm", icon = "💰", color = CONFIG.THEME.SUCCESS},
   {name = "ESP", icon = "👁", color = Color3.fromRGB(255, 170, 0)},
   {name = "Speed", icon = "⚡", color = Color3.fromRGB(0, 170, 255)},
   {name = "Fly", icon = "🕊", color = Color3.fromRGB(170, 0, 255)},
   {name = "Misc", icon = "⚙", color = CONFIG.THEME.TEXT_DIM}
}

for i, feature in ipairs(features) do
   local Btn = Instance.new("TextButton")
   Btn.Name = feature.name.."Btn"
   Btn.Size = UDim2.new(1, -20, 0, 45)
   Btn.Position = UDim2.new(0, 10, 0, 10 + (i-1) * 55)
   Btn.BackgroundColor3 = CONFIG.THEME.BACKGROUND
   Btn.Text = " "..feature.icon.."  "..feature.name
   Btn.TextColor3 = CONFIG.THEME.TEXT
   Btn.TextSize = 14
   Btn.Font = Enum.Font.GothamBold
   Btn.TextXAlignment = Enum.TextXAlignment.Left
   Btn.Parent = Sidebar
   
   local BtnCorner = Instance.new("UICorner")
   BtnCorner.CornerRadius = UDim.new(0, 8)
   BtnCorner.Parent = Btn
   
   -- Hover effect
   Btn.MouseEnter:Connect(function()
       TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = feature.color}):Play()
   end)
   Btn.MouseLeave:Connect(function()
       TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.THEME.BACKGROUND}):Play()
   end)
end

-- Main Display Area
local DisplayArea = Instance.new("Frame")
DisplayArea.Name = "Display"
DisplayArea.Size = UDim2.new(1, -170, 1, 0)
DisplayArea.Position = UDim2.new(0, 170, 0, 0)
DisplayArea.BackgroundColor3 = CONFIG.THEME.SECONDARY
DisplayArea.BorderSizePixel = 0
DisplayArea.Parent = PanelContent

local DisplayCorner = Instance.new("UICorner")
DisplayCorner.CornerRadius = UDim.new(0, 12)
DisplayCorner.Parent = DisplayArea

local WelcomeText = Instance.new("TextLabel")
WelcomeText.Size = UDim2.new(1, -40, 0, 50)
WelcomeText.Position = UDim2.new(0, 20, 0, 20)
WelcomeText.BackgroundTransparency = 1
WelcomeText.Text = "Welcome to Premium Hub!"
WelcomeText.TextColor3 = CONFIG.THEME.TEXT
WelcomeText.TextSize = 24
WelcomeText.Font = Enum.Font.GothamBlack
WelcomeText.TextWrapped = true
WelcomeText.Parent = DisplayArea

local DescText = Instance.new("TextLabel")
DescText.Size = UDim2.new(1, -40, 0, 60)
DescText.Position = UDim2.new(0, 20, 0, 80)
DescText.BackgroundTransparency = 1
DescText.Text = "Select a feature from the sidebar to get started. This GUI is fully draggable and customizable!"
DescText.TextColor3 = CONFIG.THEME.TEXT_DIM
DescText.TextSize = 14
DescText.Font = Enum.Font.Gotham
DescText.TextWrapped = true
DescText.Parent = DisplayArea

-- Animated particles in display area
for i = 1, 5 do
   local Particle = Instance.new("Frame")
   Particle.Size = UDim2.new(0, 4, 0, 4)
   Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
   Particle.BackgroundColor3 = CONFIG.THEME.PRIMARY
   Particle.BorderSizePixel = 0
   Particle.Parent = DisplayArea
   
   local PCorner = Instance.new("UICorner")
   PCorner.CornerRadius = UDim.new(1, 0)
   PCorner.Parent = Particle
   
   -- Animate
   spawn(function()
       while wait(math.random(1, 3)) do
           local newPos = UDim2.new(math.random(), 0, math.random(), 0)
           TweenService:Create(Particle, TweenInfo.new(math.random(2, 4)), {Position = newPos}):Play()
       end
   end)
end

-- FUNCTIONS & LOGIC

-- Dragging Function
local function makeDraggable(frame, handle)
   handle = handle or frame
   local dragging = false
   local dragInput, mousePos, framePos

   handle.InputBegan:Connect(function(input)
       if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
           dragging = true
           mousePos = input.Position
           framePos = frame.Position
           
           input.Changed:Connect(function()
               if input.UserInputState == Enum.UserInputState.End then
                   dragging = false
               end
           end)
       end
   end)

   handle.InputChanged:Connect(function(input)
       if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
           dragInput = input
       end
   end)

   UIS.InputChanged:Connect(function(input)
       if input == dragInput and dragging then
           local delta = input.Position - mousePos
           frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
       end
   end)
end

-- Make frames draggable
makeDraggable(MainFrame, TopBar)
makeDraggable(MainPanel, PanelTopBar)
makeDraggable(MinimizedBtn)

-- Animations
local function tween(object, properties, duration)
   TweenService:Create(object, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties):Play()
end

-- Button Hover Effects
local function setupHover(button, normalColor, hoverColor)
   button.MouseEnter:Connect(function()
       tween(button, {BackgroundColor3 = hoverColor}, 0.2)
   end)
   button.MouseLeave:Connect(function()
       tween(button, {BackgroundColor3 = normalColor}, 0.2)
   end)
end

setupHover(CloseBtn, CONFIG.THEME.ACCENT, Color3.fromRGB(255, 100, 100))
setupHover(MinBtn, CONFIG.THEME.PRIMARY, Color3.fromRGB(110, 123, 255))
setupHover(GetKeyBtn, CONFIG.THEME.SECONDARY, Color3.fromRGB(60, 60, 60))
setupHover(VerifyBtn, CONFIG.THEME.SUCCESS, Color3.fromRGB(80, 200, 100))
setupHover(MinimizedBtn, CONFIG.THEME.PRIMARY, Color3.fromRGB(110, 123, 255))

-- Key Box Focus Effect
KeyBox.Focused:Connect(function()
   tween(KeyStroke, {Transparency = 0}, 0.2)
end)
KeyBox.FocusLost:Connect(function()
   tween(KeyStroke, {Transparency = 0.8}, 0.2)
end)

-- Copy Discord Link
GetKeyBtn.MouseButton1Click:Connect(function()
   if setclipboard then
       setclipboard(CONFIG.DISCORD_LINK)
       StatusLabel.Text = "✓ Discord link copied to clipboard!"
       StatusLabel.TextColor3 = CONFIG.THEME.SUCCESS
   else
       StatusLabel.Text = "⚠ Please join: "..CONFIG.DISCORD_LINK
       StatusLabel.TextColor3 = CONFIG.THEME.ACCENT
   end
   tween(GetKeyBtn, {Size = UDim2.new(0.46, 0, 0.95, 0)}, 0.1)
   wait(0.1)
   tween(GetKeyBtn, {Size = UDim2.new(0.48, 0, 1, 0)}, 0.1)
end)

-- Verify Key
VerifyBtn.MouseButton1Click:Connect(function()
   local enteredKey = KeyBox.Text:gsub("%s+", "")
   
   tween(VerifyBtn, {Size = UDim2.new(0.46, 0, 0.95, 0)}, 0.1)
   wait(0.1)
   tween(VerifyBtn, {Size = UDim2.new(0.48, 0, 1, 0)}, 0.1)
   
   if enteredKey == CONFIG.VALID_KEY then
       StatusLabel.Text = "✓ Access granted! Loading..."
       StatusLabel.TextColor3 = CONFIG.THEME.SUCCESS
       
       wait(0.5)
       
       -- Success animation
       tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.5)
       wait(0.3)
       MainFrame.Visible = false
       MinimizedBtn.Visible = false
       
       -- Show main panel
       MainPanel.Visible = true
       MainPanel.Size = UDim2.new(0, 0, 0, 0)
       tween(MainPanel, {Size = UDim2.new(0, 600, 0, 400)}, 0.5)
       
       -- Welcome notification
       local Notif = Instance.new("Frame")
       Notif.Size = UDim2.new(0, 300, 0, 60)
       Notif.Position = UDim2.new(0.5, -150, 0, -80)
       Notif.BackgroundColor3 = CONFIG.THEME.SUCCESS
       Notif.BorderSizePixel = 0
       Notif.Parent = ScreenGui
       
       local NotifCorner = Instance.new("UICorner")
       NotifCorner.CornerRadius = UDim.new(0, 12)
       NotifCorner.Parent = Notif
       
       local NotifText = Instance.new("TextLabel")
       NotifText.Size = UDim2.new(1, -20, 1, 0)
       NotifText.Position = UDim2.new(0, 10, 0, 0)
       NotifText.BackgroundTransparency = 1
       NotifText.Text = "🎉 Welcome! You now have access to all features!"
       NotifText.TextColor3 = CONFIG.THEME.TEXT
       NotifText.TextSize = 14
       NotifText.Font = Enum.Font.GothamBold
       NotifText.TextWrapped = true
       NotifText.Parent = Notif
       
       tween(Notif, {Position = UDim2.new(0.5, -150, 0, 20)}, 0.5)
       wait(3)
       tween(Notif, {Position = UDim2.new(0.5, -150, 0, -80)}, 0.5)
       wait(0.5)
       Notif:Destroy()
       
   else
       StatusLabel.Text = "✗ Invalid key! Get it from Discord."
       StatusLabel.TextColor3 = CONFIG.THEME.ACCENT
       KeyBox.Text = ""
       
       -- Shake animation
       for i = 1, 5 do
           KeyBox.Position = UDim2.new(0, 5, 0, 25)
           wait(0.05)
           KeyBox.Position = UDim2.new(0, -5, 0, 25)
           wait(0.05)
       end
       KeyBox.Position = UDim2.new(0, 0, 0, 25)
   end
end)

-- Minimize Key System
MinBtn.MouseButton1Click:Connect(function()
   tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4)
   wait(0.4)
   MainFrame.Visible = false
   MinimizedBtn.Visible = true
   tween(MinimizedBtn, {Size = UDim2.new(0, 60, 0, 60)}, 0.3)
end)

-- Restore from minimized
MinimizedBtn.MouseButton1Click:Connect(function()
   MainFrame.Visible = true
   tween(MinimizedBtn, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
   wait(0.2)
   MinimizedBtn.Visible = false
   tween(MainFrame, {Size = UDim2.new(0, 450, 0, 350), Position = UDim2.new(0.5, -225, 0.5, -175)}, 0.4)
end)

-- Close Key System
CloseBtn.MouseButton1Click:Connect(function()
   tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4)
   wait(0.4)
   MainFrame.Visible = false
   MinimizedBtn.Visible = true
   tween(MinimizedBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
end)

-- Panel Controls
PanelMin.MouseButton1Click:Connect(function()
   MainPanel.Visible = false
   MinimizedBtn.Visible = true
   MinimizedBtn.Position = UDim2.new(0, 20, 0.5, 0)
   tween(MinimizedBtn, {Size = UDim2.new(0, 60, 0, 60)}, 0.3)
end)

PanelClose.MouseButton1Click:Connect(function()
   tween(MainPanel, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.4)
   wait(0.4)
   MainPanel.Visible = false
   MinimizedBtn.Visible = true
   tween(MinimizedBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
end)

-- Minimized button restores correct frame
MinimizedBtn.MouseButton1Click:Connect(function()
   if MainPanel.Visible == false and MainFrame.Visible == false then
       -- Restore whichever was last open (default to main panel if verified)
       if MainPanel.Size == UDim2.new(0, 600, 0, 400) then
           MainPanel.Visible = true
       else
           MainFrame.Visible = true
       end
       tween(MinimizedBtn, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
       wait(0.2)
       MinimizedBtn.Visible = false
   end
end)

-- Opening Animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
tween(MainFrame, {Size = UDim2.new(0, 450, 0, 350)}, 0.5)

print("✓ Key System GUI Loaded Successfully!")
