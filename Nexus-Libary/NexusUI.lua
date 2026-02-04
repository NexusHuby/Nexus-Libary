--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝███████╗
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚══════╝
    
    Nexus UI Library v3.0 - Polished Edition
    Inspired by Rayfield & Aureus
    Features: Spring animations, polished visuals, intuitive API
]]

local NexusUI = {
    Version = "3.0.0",
    Windows = {},
    Flags = {},
    Theme = {},
    Icons = {}
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- THEME SYSTEM (Polished)
-- ==========================================

local Theme = {
    Current = "Dark",
    Palettes = {
        Dark = {
            -- Backgrounds
            Background = Color3.fromRGB(28, 28, 30),
            Topbar = Color3.fromRGB(35, 35, 38),
            Sidebar = Color3.fromRGB(32, 32, 35),
            
            -- Elements
            ElementBackground = Color3.fromRGB(40, 40, 44),
            ElementBackgroundHover = Color3.fromRGB(48, 48, 52),
            ElementStroke = Color3.fromRGB(55, 55, 60),
            
            -- Primary
            Primary = Color3.fromRGB(255, 85, 95), -- Red accent like Aureus
            PrimaryHover = Color3.fromRGB(255, 100, 110),
            
            -- Text
            TextPrimary = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 160, 165),
            TextMuted = Color3.fromRGB(100, 100, 105),
            
            -- States
            Success = Color3.fromRGB(85, 255, 127),
            Warning = Color3.fromRGB(255, 200, 87),
            Error = Color3.fromRGB(255, 85, 85),
            
            -- Special
            TabActive = Color3.fromRGB(255, 85, 95),
            TabInactive = Color3.fromRGB(80, 80, 85),
            ToggleEnabled = Color3.fromRGB(85, 255, 127),
            ToggleDisabled = Color3.fromRGB(60, 60, 65),
            
            -- Effects
            Shadow = Color3.fromRGB(0, 0, 0),
            Glow = Color3.fromRGB(255, 85, 95)
        },
        
        Light = {
            Background = Color3.fromRGB(245, 245, 247),
            Topbar = Color3.fromRGB(235, 235, 240),
            Sidebar = Color3.fromRGB(240, 240, 245),
            
            ElementBackground = Color3.fromRGB(255, 255, 255),
            ElementBackgroundHover = Color3.fromRGB(240, 240, 245),
            ElementStroke = Color3.fromRGB(200, 200, 210),
            
            Primary = Color3.fromRGB(255, 59, 48),
            PrimaryHover = Color3.fromRGB(255, 75, 65),
            
            TextPrimary = Color3.fromRGB(30, 30, 35),
            TextSecondary = Color3.fromRGB(100, 100, 110),
            TextMuted = Color3.fromRGB(150, 150, 160),
            
            Success = Color3.fromRGB(52, 199, 89),
            Warning = Color3.fromRGB(255, 204, 0),
            Error = Color3.fromRGB(255, 59, 48),
            
            TabActive = Color3.fromRGB(255, 59, 48),
            TabInactive = Color3.fromRGB(150, 150, 160),
            ToggleEnabled = Color3.fromRGB(52, 199, 89),
            ToggleDisabled = Color3.fromRGB(200, 200, 205),
            
            Shadow = Color3.fromRGB(180, 180, 190),
            Glow = Color3.fromRGB(255, 59, 48)
        },
        
        Midnight = {
            Background = Color3.fromRGB(18, 18, 25),
            Topbar = Color3.fromRGB(25, 25, 35),
            Sidebar = Color3.fromRGB(22, 22, 30),
            
            ElementBackground = Color3.fromRGB(35, 35, 48),
            ElementBackgroundHover = Color3.fromRGB(42, 42, 58),
            ElementStroke = Color3.fromRGB(50, 50, 70),
            
            Primary = Color3.fromRGB(114, 137, 218),
            PrimaryHover = Color3.fromRGB(130, 155, 235),
            
            TextPrimary = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(170, 170, 190),
            TextMuted = Color3.fromRGB(110, 110, 130),
            
            Success = Color3.fromRGB(105, 255, 150),
            Warning = Color3.fromRGB(255, 220, 100),
            Error = Color3.fromRGB(255, 95, 95),
            
            TabActive = Color3.fromRGB(114, 137, 218),
            TabInactive = Color3.fromRGB(100, 100, 130),
            ToggleEnabled = Color3.fromRGB(105, 255, 150),
            ToggleDisabled = Color3.fromRGB(50, 50, 65),
            
            Shadow = Color3.fromRGB(10, 10, 15),
            Glow = Color3.fromRGB(114, 137, 218)
        },
        
        Ocean = {
            Background = Color3.fromRGB(15, 23, 30),
            Topbar = Color3.fromRGB(20, 30, 40),
            Sidebar = Color3.fromRGB(18, 26, 35),
            
            ElementBackground = Color3.fromRGB(28, 40, 55),
            ElementBackgroundHover = Color3.fromRGB(35, 50, 70),
            ElementStroke = Color3.fromRGB(40, 58, 78),
            
            Primary = Color3.fromRGB(0, 200, 255),
            PrimaryHover = Color3.fromRGB(50, 215, 255),
            
            TextPrimary = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(160, 180, 200),
            TextMuted = Color3.fromRGB(100, 120, 140),
            
            Success = Color3.fromRGB(0, 255, 170),
            Warning = Color3.fromRGB(255, 200, 50),
            Error = Color3.fromRGB(255, 80, 80),
            
            TabActive = Color3.fromRGB(0, 200, 255),
            TabInactive = Color3.fromRGB(80, 100, 120),
            ToggleEnabled = Color3.fromRGB(0, 255, 170),
            ToggleDisabled = Color3.fromRGB(40, 55, 70),
            
            Shadow = Color3.fromRGB(8, 15, 20),
            Glow = Color3.fromRGB(0, 200, 255)
        }
    }
}

function Theme:Get(Key)
    return self.Palettes[self.Current][Key] or self.Palettes["Dark"][Key]
end

function Theme:SetTheme(Name)
    if self.Palettes[Name] then
        self.Current = Name
        return true
    end
    return false
end

-- ==========================================
-- ADVANCED ANIMATION SYSTEM
-- ==========================================

local Animation = {}

function Animation:Tween(Object, Properties, Duration, Style, Direction)
    local Info = TweenInfo.new(
        Duration or 0.4,
        Style or Enum.EasingStyle.Quint,
        Direction or Enum.EasingDirection.Out,
        0, false, 0
    )
    local Tween = TweenService:Create(Object, Info, Properties)
    Tween:Play()
    return Tween
end

function Animation:Spring(Object, TargetPosition, Speed, Damping)
    Speed = Speed or 60
    Damping = Damping or 0.85
    
    local Connection
    local Velocity = Vector2.new(0, 0)
    local Current = Vector2.new(Object.Position.X.Offset, Object.Position.Y.Offset)
    local Target = Vector2.new(TargetPosition.X.Offset, TargetPosition.Y.Offset)
    
    Connection = RunService.Heartbeat:Connect(function(Delta)
        local Displacement = Target - Current
        local Force = Displacement * Speed * Delta
        local Damp = Velocity * Damping
        
        Velocity = Velocity + Force - Damp
        Current = Current + Velocity * Delta
        
        Object.Position = UDim2.new(
            Object.Position.X.Scale, Current.X,
            Object.Position.Y.Scale, Current.Y
        )
        
        if Displacement.Magnitude < 0.5 and Velocity.Magnitude < 0.5 then
            Object.Position = TargetPosition
            Connection:Disconnect()
        end
    end)
    
    return Connection
end

function Animation:FadeIn(Object, Duration)
    Object.BackgroundTransparency = 1
    Object.Size = UDim2.new(Object.Size.X.Scale, Object.Size.X.Offset * 0.95, Object.Size.Y.Scale, Object.Size.Y.Offset * 0.95)
    Animation:Tween(Object, {
        BackgroundTransparency = 0,
        Size = UDim2.new(Object.Size.X.Scale, Object.Size.X.Offset / 0.95, Object.Size.Y.Scale, Object.Size.Y.Offset / 0.95)
    }, Duration or 0.5)
end

function Animation:Pop(Object)
    local OriginalSize = Object.Size
    local Center = UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset, OriginalSize.Y.Scale, OriginalSize.Y.Offset)
    local Enlarged = UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset * 1.05, OriginalSize.Y.Scale, OriginalSize.Y.Offset * 1.05)
    
    Animation:Tween(Object, {Size = Enlarged}, 0.1)
    task.delay(0.1, function()
        Animation:Tween(Object, {Size = OriginalSize}, 0.3)
    end)
end

-- ==========================================
-- ICON SYSTEM (Lucide-style)
-- ==========================================

local Icons = {
    ["home"] = "🏠",
    ["user"] = "👤",
    ["users"] = "👥",
    ["settings"] = "⚙️",
    ["search"] = "🔍",
    ["code"] = "</>",
    ["terminal"] = ">$",
    ["script"] = "📜",
    ["play"] = "▶",
    ["pause"] = "⏸",
    ["stop"] = "⏹",
    ["refresh"] = "↻",
    ["save"] = "💾",
    ["folder"] = "📁",
    ["file"] = "📄",
    ["edit"] = "✎",
    ["trash"] = "🗑",
    ["copy"] = "📋",
    ["cut"] = "✂",
    ["paste"] = "📋",
    ["undo"] = "↶",
    ["redo"] = "↷",
    ["check"] = "✓",
    ["x"] = "✕",
    ["plus"] = "＋",
    ["minus"] = "−",
    ["menu"] = "☰",
    ["grid"] = "⊞",
    ["list"] = "☰",
    ["layout"] = "⚏",
    ["sliders"] = "⚒",
    ["toggle"] = "◐",
    ["moon"] = "🌙",
    ["sun"] = "☀",
    ["bell"] = "🔔",
    ["star"] = "★",
    ["heart"] = "♥",
    ["lock"] = "🔒",
    ["unlock"] = "🔓",
    ["key"] = "🔑",
    ["shield"] = "🛡",
    ["flag"] = "🚩",
    ["map"] = "🗺",
    ["location"] = "📍",
    ["compass"] = "🧭",
    ["clock"] = "🕐",
    ["calendar"] = "📅",
    ["mail"] = "✉",
    ["message"] = "💬",
    ["chat"] = "💭",
    ["phone"] = "📞",
    ["camera"] = "📷",
    ["image"] = "🖼",
    ["video"] = "🎥",
    ["music"] = "🎵",
    ["mic"] = "🎤",
    ["volume"] = "🔊",
    ["mute"] = "🔇",
    ["wifi"] = "📶",
    ["bluetooth"] = "🔷",
    ["battery"] = "🔋",
    ["plug"] = "🔌",
    ["zap"] = "⚡",
    ["flame"] = "🔥",
    ["snow"] = "❄",
    ["cloud"] = "☁",
    ["sunrise"] = "🌅",
    ["sunset"] = "🌇",
    ["moon_full"] = "🌕",
    ["star_empty"] = "☆",
    ["target"] = "◎",
    ["crosshair"] = "⊕",
    ["aim"] = "🎯",
    ["warning"] = "⚠",
    ["alert"] = "🚨",
    ["info"] = "ℹ",
    ["help"] = "?",
    ["question"] = "❓",
    ["exclamation"] = "❗",
    ["default"] = "•"
}

function Icons:Get(Name)
    return self[Name] or self["default"]
end

-- ==========================================
-- SAVE SYSTEM
-- ==========================================

local SaveManager = {
    Data = {},
    Folder = "NexusUI",
    Enabled = true
}

function SaveManager:Init()
    self.Supported = pcall(function()
        if isfolder and makefolder and writefile and readfile then
            if not isfolder(self.Folder) then
                makefolder(self.Folder)
            end
            return true
        end
        return false
    end)
end

function SaveManager:Set(Path, Value)
    if not self.Supported then return end
    local Folder = Path:match("(.+)/") or ""
    local File = Path:match("/(.+)$") or Path
    
    if Folder ~= "" and not isfolder(self.Folder .. "/" .. Folder) then
        makefolder(self.Folder .. "/" .. Folder)
    end
    
    pcall(function()
        writefile(self.Folder .. "/" .. Path .. ".json", HttpService:JSONEncode(Value))
    end)
end

function SaveManager:Get(Path, Default)
    if not self.Supported then return Default end
    
    local Success, Data = pcall(function()
        local File = self.Folder .. "/" .. Path .. ".json"
        if isfile(File) then
            return HttpService:JSONDecode(readfile(File))
        end
        return nil
    end)
    
    return Success and Data or Default
end

SaveManager:Init()

-- ==========================================
-- NOTIFICATION SYSTEM
-- ==========================================

local NotificationSystem = {
    GUI = nil,
    Container = nil,
    Queue = {},
    Active = false
}

function NotificationSystem:Init()
    if self.GUI then return end
    
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusNotifications"
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.Parent = CoreGui
    
    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(0, 320, 1, -40)
    self.Container.Position = UDim2.new(1, -340, 0, 20)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.GUI
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 12)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    Layout.Parent = self.Container
end

function NotificationSystem:Notify(Settings)
    self:Init()
    Settings = Settings or {}
    
    local Title = Settings.Title or "Notification"
    local Content = Settings.Content or ""
    local Duration = Settings.Duration or 5
    local Type = Settings.Type or "Info"
    
    local Colors = {
        Info = Theme:Get("Primary"),
        Success = Theme:Get("Success"),
        Warning = Theme:Get("Warning"),
        Error = Theme:Get("Error")
    }
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 300, 0, 0)
    Notif.BackgroundColor3 = Theme:Get("ElementBackground")
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.Parent = self.Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Notif
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Notif
    
    -- Glow effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.ZIndex = -1
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://6014261993"
    Glow.ImageColor3 = Colors[Type]
    Glow.ImageTransparency = 0.9
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(49, 49, 450, 450)
    Glow.Parent = Notif
    
    -- Accent bar
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 3, 1, 0)
    Accent.BackgroundColor3 = Colors[Type]
    Accent.BorderSizePixel = 0
    Accent.Parent = Notif
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 12)
    AccentCorner.Parent = Accent
    
    -- Icon
    local IconMap = {Info = "ℹ", Success = "✓", Warning = "▲", Error = "✕"}
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 26, 0, 26)
    Icon.Position = UDim2.new(0, 16, 0, 14)
    Icon.BackgroundTransparency = 1
    Icon.Text = IconMap[Type] or "•"
    Icon.TextColor3 = Colors[Type]
    Icon.TextSize = 20
    Icon.Font = Enum.Font.GothamBold
    Icon.Parent = Notif
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70, 0, 22)
    TitleLabel.Position = UDim2.new(0, 50, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme:Get("TextPrimary")
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notif
    
    -- Content
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -60, 0, 0)
    ContentLabel.Position = UDim2.new(0, 50, 0, 36)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = Content
    ContentLabel.TextColor3 = Theme:Get("TextSecondary")
    ContentLabel.TextSize = 13
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.Parent = Notif
    
    -- Calculate height
    local Height = math.max(80, ContentLabel.AbsoluteSize.Y + 50)
    Notif.Size = UDim2.new(0, 300, 0, Height)
    
    -- Progress bar
    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new(1, -6, 0, 3)
    Progress.Position = UDim2.new(0, 3, 1, -6)
    Progress.BackgroundColor3 = Colors[Type]
    Progress.BorderSizePixel = 0
    Progress.Parent = Notif
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = Progress
    
    -- Entrance
    Notif.Position = UDim2.new(1, 50, 0, 0)
    Animation:Tween(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.6, Enum.EasingStyle.Quint)
    
    -- Progress animation
    Animation:Tween(Progress, {Size = UDim2.new(0, 0, 0, 3)}, Duration, Enum.EasingStyle.Linear)
    
    -- Auto close
    task.delay(Duration, function()
        Animation:Tween(Notif, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, 0.5, Enum.EasingStyle.Quint).Completed:Connect(function()
            Notif:Destroy()
        end)
        
        Animation:Tween(TitleLabel, {TextTransparency = 1}, 0.4)
        Animation:Tween(ContentLabel, {TextTransparency = 1}, 0.4)
        Animation:Tween(Icon, {TextTransparency = 1}, 0.4)
        Animation:Tween(Accent, {BackgroundTransparency = 1}, 0.4)
    end)
    
    return Notif
end

-- ==========================================
-- WINDOW CLASS (Polished)
-- ==========================================

local WindowClass = {}
WindowClass.__index = WindowClass

function WindowClass:Create(Settings)
    local self = setmetatable({}, WindowClass)
    Settings = Settings or {}
    
    self.Name = Settings.Name or "Nexus"
    self.Subtitle = Settings.Subtitle or "v1.0.0"
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.TabCount = 0
    
    -- Main GUI
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusUI"
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.Parent = CoreGui
    
    -- Loading screen
    local Loading = Instance.new("Frame")
    Loading.Size = UDim2.new(1, 0, 1, 0)
    Loading.BackgroundColor3 = Theme:Get("Background")
    Loading.ZIndex = 100
    Loading.Parent = self.GUI
    
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 16)
    LoadingCorner.Parent = Loading
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Size = UDim2.new(0, 200, 0, 40)
    LoadingTitle.Position = UDim2.new(0.5, -100, 0.5, -20)
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Text = self.Name
    LoadingTitle.TextColor3 = Theme:Get("Primary")
    LoadingTitle.TextSize = 32
    LoadingTitle.Font = Enum.Font.GothamBlack
    LoadingTitle.ZIndex = 101
    LoadingTitle.Parent = Loading
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 0, 4)
    LoadingBar.Position = UDim2.new(0.5, -100, 0.5, 30)
    LoadingBar.BackgroundColor3 = Theme:Get("Primary")
    LoadingBar.BorderSizePixel = 0
    LoadingBar.ZIndex = 101
    LoadingBar.Parent = Loading
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarCorner.Parent = LoadingBar
    
    -- Animate loading
    Animation:Tween(LoadingBar, {Size = UDim2.new(0, 200, 0, 4)}, 1.5, Enum.EasingStyle.Quint)
    
    task.delay(1.6, function()
        Animation:Tween(Loading, {BackgroundTransparency = 1}, 0.4)
        Animation:Tween(LoadingTitle, {TextTransparency = 1}, 0.4)
        Animation:Tween(LoadingBar, {BackgroundTransparency = 1}, 0.4)
        task.delay(0.5, function()
            Loading:Destroy()
        end)
    end)
    
    -- Main window
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = Settings.Size or UDim2.new(0, 650, 0, 450)
    self.Main.Position = Settings.Position or UDim2.new(0.5, -325, 0.5, -225)
    self.Main.BackgroundColor3 = Theme:Get("Background")
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = true
    self.Main.Parent = self.GUI
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = self.Main
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 60, 1, 60)
    Shadow.ZIndex = -1
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Theme:Get("Shadow")
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = self.Main
    
    -- Topbar
    self.Topbar = Instance.new("Frame")
    self.Topbar.Name = "Topbar"
    self.Topbar.Size = UDim2.new(1, 0, 0, 50)
    self.Topbar.BackgroundColor3 = Theme:Get("Topbar")
    self.Topbar.BorderSizePixel = 0
    self.Topbar.Parent = self.Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 16)
    TopbarCorner.Parent = self.Topbar
    
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Size = UDim2.new(1, 0, 0, 20)
    TopbarFix.Position = UDim2.new(0, 0, 1, -20)
    TopbarFix.BackgroundColor3 = Theme:Get("Topbar")
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Parent = self.Topbar
    
    -- Title
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Size = UDim2.new(0, 300, 1, 0)
    TitleContainer.Position = UDim2.new(0, 20, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = self.Topbar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 0, 0, 24)
    Title.Position = UDim2.new(0, 0, 0, 13)
    Title.AutomaticSize = Enum.AutomaticSize.X
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:Get("Primary")
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBlack
    Title.Parent = TitleContainer
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, Title.AbsoluteSize.X + 8, 0, 15)
    Subtitle.AutomaticSize = Enum.AutomaticSize.X
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = self.Subtitle
    Subtitle.TextColor3 = Theme:Get("TextMuted")
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = TitleContainer
    
    -- Window controls
    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 100, 1, 0)
    Controls.Position = UDim2.new(1, -110, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = self.Topbar
    
    -- Minimize button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "Minimize"
    MinBtn.Size = UDim2.new(0, 34, 0, 34)
    MinBtn.Position = UDim2.new(0, 0, 0.5, -17)
    MinBtn.BackgroundColor3 = Theme:Get("ElementBackground")
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Theme:Get("TextSecondary")
    MinBtn.TextSize = 20
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = Controls
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 10)
    MinCorner.Parent = MinBtn
    
    -- Theme button
    local ThemeBtn = Instance.new("TextButton")
    ThemeBtn.Name = "Theme"
    ThemeBtn.Size = UDim2.new(0, 34, 0, 34)
    ThemeBtn.Position = UDim2.new(0, 42, 0.5, -17)
    ThemeBtn.BackgroundColor3 = Theme:Get("ElementBackground")
    ThemeBtn.Text = "◐"
    ThemeBtn.TextColor3 = Theme:Get("TextSecondary")
    ThemeBtn.TextSize = 16
    ThemeBtn.Font = Enum.Font.GothamBold
    ThemeBtn.Parent = Controls
    
    local ThemeCorner = Instance.new("UICorner")
    ThemeCorner.CornerRadius = UDim.new(0, 10)
    ThemeCorner.Parent = ThemeBtn
    
    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 34, 0, 34)
    CloseBtn.Position = UDim2.new(0, 84, 0.5, -17)
    CloseBtn.BackgroundColor3 = Theme:Get("Primary")
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Controls
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseBtn
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, 180, 1, -50)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 50)
    self.Sidebar.BackgroundColor3 = Theme:Get("Sidebar")
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.Main
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 16)
    SidebarCorner.Parent = self.Sidebar
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Size = UDim2.new(0, 16, 1, 0)
    SidebarFix.Position = UDim2.new(1, -16, 0, 0)
    SidebarFix.BackgroundColor3 = Theme:Get("Sidebar")
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = self.Sidebar
    
    -- "PAGES" header
    local PagesHeader = Instance.new("TextLabel")
    PagesHeader.Name = "PagesHeader"
    PagesHeader.Size = UDim2.new(1, -20, 0, 20)
    PagesHeader.Position = UDim2.new(0, 20, 0, 20)
    PagesHeader.BackgroundTransparency = 1
    PagesHeader.Text = "PAGES"
    PagesHeader.TextColor3 = Theme:Get("TextMuted")
    PagesHeader.TextSize = 11
    PagesHeader.Font = Enum.Font.GothamBold
    PagesHeader.TextXAlignment = Enum.TextXAlignment.Left
    PagesHeader.Parent = self.Sidebar
    
    -- Tab list
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.Size = UDim2.new(1, 0, 1, -55)
    self.TabList.Position = UDim2.new(0, 0, 0, 50)
    self.TabList.BackgroundTransparency = 1
    self.TabList.ScrollBarThickness = 0
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.Parent = self.Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.Parent = self.TabList
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content area
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.Size = UDim2.new(1, -180, 1, -50)
    self.Content.Position = UDim2.new(0, 180, 0, 50)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main
    
    -- Pages container
    self.Pages = Instance.new("Frame")
    self.Pages.Name = "Pages"
    self.Pages.Size = UDim2.new(1, 0, 1, 0)
    self.Pages.BackgroundTransparency = 1
    self.Pages.Parent = self.Content
    
    -- Dragging
    local Dragging = false
    local DragStart, StartPos
    
    self.Topbar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = self.Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - DragStart
            local NewPos = UDim2.new(
                StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
            )
            Animation:Spring(self.Main, NewPos, 80, 0.85)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    -- Controls
    CloseBtn.MouseButton1Click:Connect(function()
        Animation:Tween(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back).Completed:Connect(function()
            self.GUI:Destroy()
        end)
    end)
    
    MinBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    ThemeBtn.MouseButton1Click:Connect(function()
        local Themes = {"Dark", "Light", "Midnight", "Ocean"}
        local Current = table.find(Themes, Theme.Current) or 1
        local Next = Current % #Themes + 1
        self:SetTheme(Themes[Next])
    end)
    
    -- Hover effects
    local function AddHover(Button, OriginalColor)
        Button.MouseEnter:Connect(function()
            Animation:Tween(Button, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
        end)
        Button.MouseLeave:Connect(function()
            Animation:Tween(Button, {BackgroundColor3 = OriginalColor}, 0.3)
        end)
    end
    
    AddHover(MinBtn, Theme:Get("ElementBackground"))
    AddHover(ThemeBtn, Theme:Get("ElementBackground"))
    
    CloseBtn.MouseEnter:Connect(function()
        Animation:Tween(CloseBtn, {BackgroundColor3 = Theme:Get("PrimaryHover")}, 0.3)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Animation:Tween(CloseBtn, {BackgroundColor3 = Theme:Get("Primary")}, 0.3)
    end)
    
    return self
end

function WindowClass:SetTheme(ThemeName)
    if not Theme:SetTheme(ThemeName) then return end
    
    -- Animate theme change
    Animation:Tween(self.Main, {BackgroundColor3 = Theme:Get("Background")}, 0.5)
    Animation:Tween(self.Topbar, {BackgroundColor3 = Theme:Get("Topbar")}, 0.5)
    Animation:Tween(self.Sidebar, {BackgroundColor3 = Theme:Get("Sidebar")}, 0.5)
    
    NexusUI:Notify({
        Title = "Theme Changed",
        Content = "Switched to " .. ThemeName .. " theme",
        Type = "Success",
        Duration = 2
    })
end

function WindowClass:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        Animation:Tween(self.Main, {Size = UDim2.new(0, self.Main.Size.X.Offset, 0, 50)}, 0.5, Enum.EasingStyle.Quint)
        self.Sidebar.Visible = false
        self.Content.Visible = false
    else
        Animation:Tween(self.Main, {Size = UDim2.new(0, 650, 0, 450)}, 0.5, Enum.EasingStyle.Quint)
        task.delay(0.3, function()
            self.Sidebar.Visible = true
            self.Content.Visible = true
        end)
    end
end

function WindowClass:CreateTab(Name, Icon)
    self.TabCount = self.TabCount + 1
    
    local Tab = {
        Name = Name,
        Icon = Icon,
        Index = self.TabCount,
        Sections = {},
        Elements = {},
        Window = self
    }
    
    -- Tab button
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Name .. "Tab"
    Tab.Button.Size = UDim2.new(1, -20, 0, 40)
    Tab.Button.Position = UDim2.new(0, 10, 0, 0)
    Tab.Button.BackgroundColor3 = Theme:Get("ElementBackground")
    Tab.Button.BackgroundTransparency = 1
    Tab.Button.Text = ""
    Tab.Button.AutoButtonColor = false
    Tab.Button.Parent = self.TabList
    
    -- Icon
    Tab.IconLabel = Instance.new("TextLabel")
    Tab.IconLabel.Name = "Icon"
    Tab.IconLabel.Size = UDim2.new(0, 22, 0, 22)
    Tab.IconLabel.Position = UDim2.new(0, 16, 0.5, -11)
    Tab.IconLabel.BackgroundTransparency = 1
    Tab.IconLabel.Text = Icons:Get(Icon)
    Tab.IconLabel.TextColor3 = Theme:Get("TabInactive")
    Tab.IconLabel.TextSize = 16
    Tab.IconLabel.Font = Enum.Font.GothamBold
    Tab.IconLabel.Parent = Tab.Button
    
    -- Name
    Tab.NameLabel = Instance.new("TextLabel")
    Tab.NameLabel.Name = "Name"
    Tab.NameLabel.Size = UDim2.new(1, -55, 1, 0)
    Tab.NameLabel.Position = UDim2.new(0, 48, 0, 0)
    Tab.NameLabel.BackgroundTransparency = 1
    Tab.NameLabel.Text = Name
    Tab.NameLabel.TextColor3 = Theme:Get("TextSecondary")
    Tab.NameLabel.TextSize = 14
    Tab.NameLabel.Font = Enum.Font.GothamSemibold
    Tab.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    Tab.NameLabel.Parent = Tab.Button
    
    -- Active indicator
    Tab.Indicator = Instance.new("Frame")
    Tab.Indicator.Name = "Indicator"
    Tab.Indicator.Size = UDim2.new(0, 3, 0, 0)
    Tab.Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Tab.Indicator.AnchorPoint = Vector2.new(0, 0.5)
    Tab.Indicator.BackgroundColor3 = Theme:Get("TabActive")
    Tab.Indicator.BorderSizePixel = 0
    Tab.Indicator.Parent = Tab.Button
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 2)
    IndicatorCorner.Parent = Tab.Indicator
    
    -- Page
    Tab.Page = Instance.new("ScrollingFrame")
    Tab.Page.Name = Name .. "Page"
    Tab.Page.Size = UDim2.new(1, 0, 1, 0)
    Tab.Page.BackgroundTransparency = 1
    Tab.Page.ScrollBarThickness = 4
    Tab.Page.ScrollBarImageColor3 = Theme:Get("Primary")
    Tab.Page.Visible = false
    Tab.Page.Parent = self.Pages
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 15)
    PageLayout.Parent = Tab.Page
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingLeft = UDim.new(0, 20)
    PagePadding.PaddingRight = UDim.new(0, 20)
    PagePadding.PaddingTop = UDim.new(0, 20)
    PagePadding.PaddingBottom = UDim.new(0, 20)
    PagePadding.Parent = Tab.Page
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Tab.Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 40)
    end)
    
    -- Click handler
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    Tab.Button.MouseEnter:Connect(function()
        if self.ActiveTab ~= Tab then
            Animation:Tween(Tab.Button, {BackgroundTransparency = 0.8}, 0.3)
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if self.ActiveTab ~= Tab then
            Animation:Tween(Tab.Button, {BackgroundTransparency = 1}, 0.3)
        end
    end)
    
    -- ELEMENT CREATION METHODS (Rayfield-style API)
    function Tab:Button(ButtonSettings)
        return self.Window:CreateButton(self, ButtonSettings)
    end
    
    function Tab:Toggle(ToggleSettings)
        return self.Window:CreateToggle(self, ToggleSettings)
    end
    
    function Tab:Slider(SliderSettings)
        return self.Window:CreateSlider(self, SliderSettings)
    end
    
    function Tab:Dropdown(DropdownSettings)
        return self.Window:CreateDropdown(self, DropdownSettings)
    end
    
    function Tab:Input(InputSettings)
        return self.Window:CreateInput(self, InputSettings)
    end
    
    function Tab:Keybind(KeybindSettings)
        return self.Window:CreateKeybind(self, KeybindSettings)
    end
    
    function Tab:ColorPicker(ColorPickerSettings)
        return self.Window:CreateColorPicker(self, ColorPickerSettings)
    end
    
    function Tab:Paragraph(ParagraphSettings)
        return self.Window:CreateParagraph(self, ParagraphSettings)
    end
    
    function Tab:Label(LabelText)
        return self.Window:CreateLabel(self, LabelText)
    end
    
    function Tab:Section(SectionName)
        return self.Window:CreateSection(self, SectionName)
    end
    
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(Tab)
    end
    
    return Tab
end

function WindowClass:SelectTab(Tab)
    if self.ActiveTab == Tab then return end
    
    -- Deselect current
    if self.ActiveTab then
        self.ActiveTab.Page.Visible = false
        Animation:Tween(self.ActiveTab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.3)
        Animation:Tween(self.ActiveTab.IconLabel, {TextColor3 = Theme:Get("TabInactive")}, 0.3)
        Animation:Tween(self.ActiveTab.NameLabel, {TextColor3 = Theme:Get("TextSecondary")}, 0.3)
        Animation:Tween(self.ActiveTab.Button, {BackgroundTransparency = 1}, 0.3)
    end
    
    -- Select new
    self.ActiveTab = Tab
    Tab.Page.Visible = true
    
    Animation:Tween(Tab.Indicator, {Size = UDim2.new(0, 3, 0, 20)}, 0.4, Enum.EasingStyle.Back)
    Animation:Tween(Tab.IconLabel, {TextColor3 = Theme:Get("TabActive")}, 0.3)
    Animation:Tween(Tab.NameLabel, {TextColor3 = Theme:Get("TextPrimary")}, 0.3)
    Animation:Tween(Tab.Button, {BackgroundTransparency = 0.9}, 0.3)
    
    -- Page animation
    Tab.Page.Position = UDim2.new(0.02, 0, 0, 0)
    Animation:Tween(Tab.Page, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Quint)
end

-- ==========================================
-- ELEMENT CREATION (Polished)
-- ==========================================

function WindowClass:CreateButton(Tab, Settings)
    Settings = Settings or {}
    
    local Button = Instance.new("TextButton")
    Button.Name = Settings.Name or "Button"
    Button.Size = UDim2.new(1, 0, 0, 42)
    Button.BackgroundColor3 = Theme:Get("ElementBackground")
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Button
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Button
    
    -- Icon
    if Settings.Icon then
        local Icon = Instance.new("TextLabel")
        Icon.Size = UDim2.new(0, 24, 0, 24)
        Icon.Position = UDim2.new(0, 14, 0.5, -12)
        Icon.BackgroundTransparency = 1
        Icon.Text = Icons:Get(Settings.Icon)
        Icon.TextColor3 = Theme:Get("Primary")
        Icon.TextSize = 18
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = Button
    end
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, Settings.Icon and -60 or -50, 1, 0)
    Title.Position = UDim2.new(0, Settings.Icon and 44 or 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Button"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    -- Arrow indicator
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -30, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "→"
    Arrow.TextColor3 = Theme:Get("TextMuted")
    Arrow.TextSize = 16
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Button
    
    -- Hover & Click
    Button.MouseEnter:Connect(function()
        Animation:Tween(Button, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
        Animation:Tween(Arrow, {TextColor3 = Theme:Get("Primary"), Position = UDim2.new(1, -26, 0.5, -10)}, 0.3)
    end)
    
    Button.MouseLeave:Connect(function()
        Animation:Tween(Button, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
        Animation:Tween(Arrow, {TextColor3 = Theme:Get("TextMuted"), Position = UDim2.new(1, -30, 0.5, -10)}, 0.3)
    end)
    
    Button.MouseButton1Down:Connect(function()
        Animation:Tween(Button, {Size = UDim2.new(1, -4, 0, 40), Position = UDim2.new(0, 2, 0, 1)}, 0.1)
    end)
    
    Button.MouseButton1Up:Connect(function()
        Animation:Tween(Button, {Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 0, 0, 0)}, 0.2)
    end)
    
    Button.MouseButton1Click:Connect(function()
        Animation:Pop(Button)
        if Settings.Callback then
            pcall(Settings.Callback)
        end
    end)
    
    return {
        Instance = Button,
        Set = function(NewName)
            Title.Text = NewName
        end
    }
end

function WindowClass:CreateToggle(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Toggle") .. "_Toggle"
    local Value = SaveManager:Get(self.Name .. "/" .. Flag, Settings.CurrentValue or false)
    
    local Toggle = Instance.new("Frame")
    Toggle.Name = Settings.Name or "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 44)
    Toggle.BackgroundColor3 = Theme:Get("ElementBackground")
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Toggle
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Toggle
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Toggle"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Toggle
    
    -- Toggle switch
    local Switch = Instance.new("Frame")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 50, 0, 26)
    Switch.Position = UDim2.new(1, -66, 0.5, -13)
    Switch.BackgroundColor3 = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
    Switch.BorderSizePixel = 0
    Switch.Parent = Toggle
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    -- Circle
    local Circle = Instance.new("Frame")
    Circle.Name = "Circle"
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = Value and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    -- Shadow
    local CircleShadow = Instance.new("ImageLabel")
    CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    CircleShadow.Size = UDim2.new(1, 8, 1, 8)
    CircleShadow.ZIndex = -1
    CircleShadow.BackgroundTransparency = 1
    CircleShadow.Image = "rbxassetid://6014261993"
    CircleShadow.ImageColor3 = Color3.new(0, 0, 0)
    CircleShadow.ImageTransparency = 0.7
    CircleShadow.ScaleType = Enum.ScaleType.Slice
    CircleShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    CircleShadow.Parent = Circle
    
    local function SetToggle(NewValue)
        Value = NewValue
        SaveManager:Set(self.Name .. "/" .. Flag, Value)
        
        local TargetColor = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
        local TargetPos = Value and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 4, 0.5, -10)
        
        Animation:Tween(Switch, {BackgroundColor3 = TargetColor}, 0.3)
        Animation:Tween(Circle, {Position = TargetPos}, 0.3, Enum.EasingStyle.Quint)
        
        if Settings.Callback then
            pcall(Settings.Callback, Value)
        end
    end
    
    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = Toggle
    
    ClickArea.MouseButton1Click:Connect(function()
        SetToggle(not Value)
    end)
    
    Toggle.MouseEnter:Connect(function()
        Animation:Tween(Toggle, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Toggle.MouseLeave:Connect(function()
        Animation:Tween(Toggle, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Toggle,
        Set = SetToggle,
        Get = function() return Value end
    }
end

function WindowClass:CreateSlider(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Slider") .. "_Slider"
    local Range = Settings.Range or {0, 100}
    local Increment = Settings.Increment or 1
    local Suffix = Settings.Suffix or ""
    local Value = SaveManager:Get(self.Name .. "/" .. Flag, Settings.CurrentValue or Range[1])
    
    local Slider = Instance.new("Frame")
    Slider.Name = Settings.Name or "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 56)
    Slider.BackgroundColor3 = Theme:Get("ElementBackground")
    Slider.BorderSizePixel = 0
    Slider.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Slider
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Slider
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 0, 20)
    Title.Position = UDim2.new(0, 18, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Slider"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Slider
    
    local ValueDisplay = Instance.new("TextBox")
    ValueDisplay.Size = UDim2.new(0, 60, 0, 22)
    ValueDisplay.Position = UDim2.new(1, -78, 0, 9)
    ValueDisplay.BackgroundColor3 = Theme:Get("Background")
    ValueDisplay.Text = tostring(Value) .. Suffix
    ValueDisplay.TextColor3 = Theme:Get("TextPrimary")
    ValueDisplay.TextSize = 13
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.Parent = Slider
    
    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 6)
    ValueCorner.Parent = ValueDisplay
    
    -- Slider track
    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(1, -36, 0, 6)
    Track.Position = UDim2.new(0, 18, 0, 38)
    Track.BackgroundColor3 = Theme:Get("ElementStroke")
    Track.BorderSizePixel = 0
    Track.Parent = Slider
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    
    -- Progress
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)
    Progress.BackgroundColor3 = Theme:Get("Primary")
    Progress.BorderSizePixel = 0
    Progress.Parent = Track
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = Progress
    
    -- Handle
    local Handle = Instance.new("Frame")
    Handle.Name = "Handle"
    Handle.Size = UDim2.new(0, 16, 0, 16)
    Handle.Position = UDim2.new(1, -8, 0.5, -8)
    Handle.BackgroundColor3 = Color3.new(1, 1, 1)
    Handle.BorderSizePixel = 0
    Handle.Parent = Progress
    
    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(1, 0)
    HandleCorner.Parent = Handle
    
    local HandleShadow = Instance.new("ImageLabel")
    HandleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    HandleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    HandleShadow.Size = UDim2.new(1, 10, 1, 10)
    HandleShadow.ZIndex = -1
    HandleShadow.BackgroundTransparency = 1
    HandleShadow.Image = "rbxassetid://6014261993"
    HandleShadow.ImageColor3 = Color3.new(0, 0, 0)
    HandleShadow.ImageTransparency = 0.6
    HandleShadow.ScaleType = Enum.ScaleType.Slice
    HandleShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    HandleShadow.Parent = Handle
    
    local Dragging = false
    
    local function Update(Input)
        local Scale = math.clamp((Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local NewValue = Range[1] + (Range[2] - Range[1]) * Scale
        NewValue = math.floor(NewValue / Increment + 0.5) * Increment
        NewValue = math.clamp(NewValue, Range[1], Range[2])
        
        if NewValue ~= Value then
            Value = NewValue
            SaveManager:Set(self.Name .. "/" .. Flag, Value)
            ValueDisplay.Text = tostring(Value) .. Suffix
            Animation:Tween(Progress, {Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)}, 0.1)
            
            if Settings.Callback then
                pcall(Settings.Callback, Value)
            end
        end
    end
    
    Track.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            Update(Input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            Update(Input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    ValueDisplay.FocusLost:Connect(function()
        local Num = tonumber(ValueDisplay.Text:gsub(Suffix, ""))
        if Num then
            Num = math.clamp(Num, Range[1], Range[2])
            Value = Num
            ValueDisplay.Text = tostring(Value) .. Suffix
            Animation:Tween(Progress, {Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)}, 0.2)
            if Settings.Callback then
                pcall(Settings.Callback, Value)
            end
        end
    end)
    
    Slider.MouseEnter:Connect(function()
        Animation:Tween(Slider, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Slider.MouseLeave:Connect(function()
        Animation:Tween(Slider, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Slider,
        Set = function(NewValue)
            Value = math.clamp(NewValue, Range[1], Range[2])
            ValueDisplay.Text = tostring(Value) .. Suffix
            Animation:Tween(Progress, {Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)}, 0.2)
            if Settings.Callback then
                pcall(Settings.Callback, Value)
            end
        end,
        Get = function() return Value end
    }
end

function WindowClass:CreateDropdown(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Dropdown") .. "_Dropdown"
    local Options = Settings.Options or {}
    local CurrentOption = SaveManager:Get(self.Name .. "/" .. Flag, Settings.CurrentOption or (Options[1] or ""))
    
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = Settings.Name or "Dropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 44)
    Dropdown.BackgroundColor3 = Theme:Get("ElementBackground")
    Dropdown.BorderSizePixel = 0
    Dropdown.ClipsDescendants = true
    Dropdown.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Dropdown
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Dropdown
    
    local Header = Instance.new("TextButton")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 44)
    Header.BackgroundColor3 = Theme:Get("ElementBackground")
    Header.Text = ""
    Header.AutoButtonColor = false
    Header.Parent = Dropdown
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -130, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Dropdown"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local Selected = Instance.new("TextLabel")
    Selected.Name = "Selected"
    Selected.Size = UDim2.new(0, 100, 1, 0)
    Selected.Position = UDim2.new(1, -130, 0, 0)
    Selected.BackgroundTransparency = 1
    Selected.Text = tostring(CurrentOption)
    Selected.TextColor3 = Theme:Get("TextSecondary")
    Selected.TextSize = 13
    Selected.Font = Enum.Font.Gotham
    Selected.TextXAlignment = Enum.TextXAlignment.Right
    Selected.Parent = Header
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -28, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Theme:Get("TextMuted")
    Arrow.TextSize = 12
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Header
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "Options"
    OptionsFrame.Size = UDim2.new(1, -28, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 14, 0, 50)
    OptionsFrame.BackgroundColor3 = Theme:Get("Background")
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.Parent = Dropdown
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 10)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.Padding = UDim.new(0, 4)
    OptionsList.Parent = OptionsFrame
    
    local Open = false
    
    local function BuildOptions()
        for _, Child in ipairs(OptionsFrame:GetChildren()) do
            if Child:IsA("TextButton") then Child:Destroy() end
        end
        
        for _, Option in ipairs(Options) do
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundColor3 = Option == CurrentOption and Theme:Get("Primary") or Theme:Get("ElementBackground")
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Btn.Parent = OptionsFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Btn
            
            local BtnText = Instance.new("TextLabel")
            BtnText.Size = UDim2.new(1, -20, 1, 0)
            BtnText.Position = UDim2.new(0, 12, 0, 0)
            BtnText.BackgroundTransparency = 1
            BtnText.Text = Option
            BtnText.TextColor3 = Option == CurrentOption and Color3.new(1, 1, 1) or Theme:Get("TextPrimary")
            BtnText.TextSize = 13
            BtnText.Font = Enum.Font.Gotham
            BtnText.TextXAlignment = Enum.TextXAlignment.Left
            BtnText.Parent = Btn
            
            Btn.MouseEnter:Connect(function()
                if Option ~= CurrentOption then
                    Animation:Tween(Btn, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
                end
            end)
            
            Btn.MouseLeave:Connect(function()
                if Option ~= CurrentOption then
                    Animation:Tween(Btn, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.2)
                end
            end)
            
            Btn.MouseButton1Click:Connect(function()
                CurrentOption = Option
                SaveManager:Set(self.Name .. "/" .. Flag, CurrentOption)
                Selected.Text = tostring(CurrentOption)
                
                -- Close dropdown
                Open = false
                Animation:Tween(Arrow, {Rotation = 0}, 0.3)
                Animation:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 44)}, 0.3)
                task.delay(0.3, function()
                    OptionsFrame.Visible = false
                end)
                
                BuildOptions()
                
                if Settings.Callback then
                    pcall(Settings.Callback, CurrentOption)
                end
            end)
        end
        
        local Height = math.min(#Options * 38, 200)
        OptionsFrame.Size = UDim2.new(1, -28, 0, Height)
    end
    
    Header.MouseButton1Click:Connect(function()
        Open = not Open
        
        if Open then
            OptionsFrame.Visible = true
            BuildOptions()
            Animation:Tween(Arrow, {Rotation = 180}, 0.3)
            Animation:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 54 + OptionsFrame.Size.Y.Offset)}, 0.3)
        else
            Animation:Tween(Arrow, {Rotation = 0}, 0.3)
            Animation:Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 44)}, 0.3)
            task.delay(0.3, function()
                OptionsFrame.Visible = false
            end)
        end
    end)
    
    Header.MouseEnter:Connect(function()
        Animation:Tween(Header, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Header.MouseLeave:Connect(function()
        Animation:Tween(Header, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Dropdown,
        Set = function(Option)
            CurrentOption = Option
            Selected.Text = tostring(CurrentOption)
            SaveManager:Set(self.Name .. "/" .. Flag, CurrentOption)
            BuildOptions()
        end,
        Get = function() return CurrentOption end,
        Refresh = function(NewOptions)
            Options = NewOptions
            if Open then BuildOptions() end
        end
    }
end

function WindowClass:CreateInput(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Input") .. "_Input"
    local Value = SaveManager:Get(self.Name .. "/" .. Flag, Settings.CurrentValue or "")
    local Placeholder = Settings.Placeholder or "Enter text..."
    
    local Input = Instance.new("Frame")
    Input.Name = Settings.Name or "Input"
    Input.Size = UDim2.new(1, 0, 0, 76)
    Input.BackgroundColor3 = Theme:Get("ElementBackground")
    Input.BorderSizePixel = 0
    Input.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Input
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Input
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 18, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Input"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Input
    
    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(1, -36, 0, 32)
    InputBox.Position = UDim2.new(0, 18, 0, 38)
    InputBox.BackgroundColor3 = Theme:Get("Background")
    InputBox.Text = tostring(Value)
    InputBox.PlaceholderText = Placeholder
    InputBox.PlaceholderColor3 = Theme:Get("TextMuted")
    InputBox.TextColor3 = Theme:Get("TextPrimary")
    InputBox.TextSize = 14
    InputBox.Font = Enum.Font.Gotham
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = Input
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 10)
    BoxCorner.Parent = InputBox
    
    InputBox.FocusLost:Connect(function()
        local Text = InputBox.Text
        if Settings.Numeric then
            local Num = tonumber(Text)
            if Num then
                Value = Num
            else
                InputBox.Text = tostring(Value)
                return
            end
        else
            Value = Text
        end
        
        SaveManager:Set(self.Name .. "/" .. Flag, Value)
        if Settings.Callback then
            pcall(Settings.Callback, Value)
        end
        
        if Settings.Finished then
            InputBox.Text = ""
        end
    end)
    
    Input.MouseEnter:Connect(function()
        Animation:Tween(Input, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Input.MouseLeave:Connect(function()
        Animation:Tween(Input, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Input,
        Set = function(NewValue)
            Value = NewValue
            InputBox.Text = tostring(Value)
            SaveManager:Set(self.Name .. "/" .. Flag, Value)
        end,
        Get = function() return Value end
    }
end

function WindowClass:CreateKeybind(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Keybind") .. "_Keybind"
    local Keybind = SaveManager:Get(self.Name .. "/" .. Flag, Settings.CurrentKeybind or "None")
    local Hold = Settings.HoldToInteract or false
    
    local KeybindFrame = Instance.new("Frame")
    KeybindFrame.Name = Settings.Name or "Keybind"
    KeybindFrame.Size = UDim2.new(1, 0, 0, 44)
    KeybindFrame.BackgroundColor3 = Theme:Get("ElementBackground")
    KeybindFrame.BorderSizePixel = 0
    KeybindFrame.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = KeybindFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = KeybindFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Keybind"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = KeybindFrame
    
    local KeyBox = Instance.new("TextButton")
    KeyBox.Size = UDim2.new(0, 0, 0, 30)
    KeyBox.AutomaticSize = Enum.AutomaticSize.X
    KeyBox.Position = UDim2.new(1, -18, 0.5, -15)
    KeyBox.AnchorPoint = Vector2.new(1, 0)
    KeyBox.BackgroundColor3 = Theme:Get("Background")
    KeyBox.Text = Keybind
    KeyBox.TextColor3 = Theme:Get("TextPrimary")
    KeyBox.TextSize = 13
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.Parent = KeybindFrame
    
    local KeyPadding = Instance.new("UIPadding")
    KeyPadding.PaddingLeft = UDim.new(0, 14)
    KeyPadding.PaddingRight = UDim.new(0, 14)
    KeyPadding.Parent = KeyBox
    
    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 8)
    KeyCorner.Parent = KeyBox
    
    local Listening = false
    
    KeyBox.MouseButton1Click:Connect(function()
        Listening = true
        KeyBox.Text = "..."
        Animation:Tween(KeyBox, {BackgroundColor3 = Theme:Get("Primary")}, 0.2)
    end)
    
    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if Listening and Input.KeyCode ~= Enum.KeyCode.Unknown then
            local Key = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
            Keybind = Key
            KeyBox.Text = Key
            SaveManager:Set(self.Name .. "/" .. Flag, Keybind)
            Listening = false
            Animation:Tween(KeyBox, {BackgroundColor3 = Theme:Get("Background")}, 0.2)
        elseif Keybind ~= "None" and Input.KeyCode == Enum.KeyCode[Keybind] and not GameProcessed then
            if Settings.Callback then
                if Hold then
                    pcall(Settings.Callback, true)
                    local Connection
                    Connection = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            pcall(Settings.Callback, false)
                            Connection:Disconnect()
                        end
                    end)
                else
                    pcall(Settings.Callback)
                end
            end
        end
    end)
    
    KeybindFrame.MouseEnter:Connect(function()
        Animation:Tween(KeybindFrame, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    KeybindFrame.MouseLeave:Connect(function()
        Animation:Tween(KeybindFrame, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = KeybindFrame,
        Set = function(Key)
            Keybind = Key
            KeyBox.Text = Key
            SaveManager:Set(self.Name .. "/" .. Flag, Keybind)
        end,
        Get = function() return Keybind end
    }
end

function WindowClass:CreateColorPicker(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "ColorPicker") .. "_Color"
    local Color = SaveManager:Get(self.Name .. "/" .. Flag, Settings.Color or {R = 255, G = 255, B = 255})
    
    if typeof(Color) == "table" then
        Color = Color3.fromRGB(Color.R, Color.G, Color.B)
    end
    
    local H, S, V = Color:ToHSV()
    local Open = false
    
    local Picker = Instance.new("Frame")
    Picker.Name = Settings.Name or "ColorPicker"
    Picker.Size = UDim2.new(1, 0, 0, 44)
    Picker.BackgroundColor3 = Theme:Get("ElementBackground")
    Picker.BorderSizePixel = 0
    Picker.ClipsDescendants = true
    Picker.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Picker
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Picker
    
    local Header = Instance.new("TextButton")
    Header.Size = UDim2.new(1, 0, 0, 44)
    Header.BackgroundTransparency = 1
    Header.Text = ""
    Header.Parent = Picker
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Color Picker"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local Display = Instance.new("Frame")
    Display.Size = UDim2.new(0, 50, 0, 26)
    Display.Position = UDim2.new(1, -70, 0.5, -13)
    Display.BackgroundColor3 = Color
    Display.BorderSizePixel = 0
    Display.Parent = Header
    
    local DisplayCorner = Instance.new("UICorner")
    DisplayCorner.CornerRadius = UDim.new(0, 8)
    DisplayCorner.Parent = Display
    
    local DisplayStroke = Instance.new("UIStroke")
    DisplayStroke.Color = Theme:Get("ElementStroke")
    DisplayStroke.Thickness = 1
    DisplayStroke.Parent = Display
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -28, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Theme:Get("TextMuted")
    Arrow.TextSize = 12
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Header
    
    -- Picker panel
    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(1, -28, 0, 160)
    Panel.Position = UDim2.new(0, 14, 0, 52)
    Panel.BackgroundColor3 = Theme:Get("Background")
    Panel.BorderSizePixel = 0
    Panel.Visible = false
    Panel.Parent = Picker
    
    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 12)
    PanelCorner.Parent = Panel
    
    -- SV Map
    local SVMap = Instance.new("ImageButton")
    SVMap.Size = UDim2.new(0, 130, 0, 110)
    SVMap.Position = UDim2.new(0, 10, 0, 10)
    SVMap.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
    SVMap.BorderSizePixel = 0
    SVMap.Image = "rbxassetid://11415645739"
    SVMap.AutoButtonColor = false
    SVMap.Parent = Panel
    
    local SVCorner = Instance.new("UICorner")
    SVCorner.CornerRadius = UDim.new(0, 10)
    SVCorner.Parent = SVMap
    
    local SVCursor = Instance.new("Frame")
    SVCursor.Size = UDim2.new(0, 12, 0, 12)
    SVCursor.Position = UDim2.new(S, -6, 1 - V, -6)
    SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    SVCursor.BorderSizePixel = 2
    SVCursor.BorderColor3 = Color3.new(0, 0, 0)
    SVCursor.Parent = SVMap
    
    Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)
    
    -- Hue slider
    local HueSlider = Instance.new("ImageButton")
    HueSlider.Size = UDim2.new(0, 22, 0, 110)
    HueSlider.Position = UDim2.new(0, 150, 0, 10)
    HueSlider.BackgroundColor3 = Color3.new(1, 1, 1)
    HueSlider.BorderSizePixel = 0
    HueSlider.Image = "rbxassetid://11415645890"
    HueSlider.AutoButtonColor = false
    HueSlider.Parent = Panel
    
    Instance.new("UICorner", HueSlider).CornerRadius = UDim.new(0, 10)
    
    local HueCursor = Instance.new("Frame")
    HueCursor.Size = UDim2.new(1, 4, 0, 6)
    HueCursor.Position = UDim2.new(-0.1, 0, 1 - H, -3)
    HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    HueCursor.BorderSizePixel = 2
    HueCursor.BorderColor3 = Color3.new(0, 0, 0)
    HueCursor.Parent = HueSlider
    
    -- RGB values
    local RGBFrame = Instance.new("Frame")
    RGBFrame.Size = UDim2.new(0, 130, 0, 24)
    RGBFrame.Position = UDim2.new(0, 10, 0, 128)
    RGBFrame.BackgroundTransparency = 1
    RGBFrame.Parent = Panel
    
    local function CreateRGBBox(Name, Value, X)
        local Box = Instance.new("TextBox")
        Box.Name = Name
        Box.Size = UDim2.new(0, 40, 1, 0)
        Box.Position = UDim2.new(0, X, 0, 0)
        Box.BackgroundColor3 = Theme:Get("ElementBackground")
        Box.Text = tostring(Value)
        Box.TextColor3 = Theme:Get("TextPrimary")
        Box.TextSize = 12
        Box.Font = Enum.Font.GothamBold
        Box.Parent = RGBFrame
        
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
        
        return Box
    end
    
    local RBox = CreateRGBBox("R", math.floor(Color.R * 255), 0)
    local GBox = CreateRGBBox("G", math.floor(Color.G * 255), 45)
    local BBox = CreateRGBBox("B", math.floor(Color.B * 255), 90)
    
    local DraggingSV = false
    local DraggingHue = false
    
    local function UpdateColor()
        Color = Color3.fromHSV(H, S, V)
        Display.BackgroundColor3 = Color
        
        SaveManager:Set(self.Name .. "/" .. Flag, {
            R = math.floor(Color.R * 255),
            G = math.floor(Color.G * 255),
            B = math.floor(Color.B * 255)
        })
        
        SVCursor.Position = UDim2.new(S, -6, 1 - V, -6)
        HueCursor.Position = UDim2.new(-0.1, 0, 1 - H, -3)
        SVMap.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        
        RBox.Text = tostring(math.floor(Color.R * 255))
        GBox.Text = tostring(math.floor(Color.G * 255))
        BBox.Text = tostring(math.floor(Color.B * 255))
        
        if Settings.Callback then
            pcall(Settings.Callback, Color)
        end
    end
    
    SVMap.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DraggingSV = true
        end
    end)
    
    HueSlider.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DraggingHue = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if DraggingSV and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local X = math.clamp((Input.Position.X - SVMap.AbsolutePosition.X) / SVMap.AbsoluteSize.X, 0, 1)
            local Y = math.clamp((Input.Position.Y - SVMap.AbsolutePosition.Y) / SVMap.AbsoluteSize.Y, 0, 1)
            S = X
            V = 1 - Y
            UpdateColor()
        elseif DraggingHue and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            H = 1 - math.clamp((Input.Position.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
            UpdateColor()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DraggingSV = false
            DraggingHue = false
        end
    end)
    
    Header.MouseButton1Click:Connect(function()
        Open = not Open
        
        if Open then
            Panel.Visible = true
            Animation:Tween(Arrow, {Rotation = 180}, 0.3)
            Animation:Tween(Picker, {Size = UDim2.new(1, 0, 0, 220)}, 0.4)
        else
            Animation:Tween(Arrow, {Rotation = 0}, 0.3)
            Animation:Tween(Picker, {Size = UDim2.new(1, 0, 0, 44)}, 0.4)
            task.delay(0.4, function()
                Panel.Visible = false
            end)
        end
    end)
    
    return {
        Instance = Picker,
        Set = function(NewColor)
            Color = NewColor
            H, S, V = Color:ToHSV()
            UpdateColor()
        end,
        Get = function() return Color end
    }
end

function WindowClass:CreateParagraph(Tab, Settings)
    Settings = Settings or {}
    
    local Paragraph = Instance.new("Frame")
    Paragraph.Name = "Paragraph"
    Paragraph.Size = UDim2.new(1, 0, 0, 60)
    Paragraph.BackgroundColor3 = Theme:Get("ElementBackground")
    Paragraph.BorderSizePixel = 0
    Paragraph.AutomaticSize = Enum.AutomaticSize.Y
    Paragraph.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Paragraph
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Paragraph
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -28, 0, 22)
    Title.Position = UDim2.new(0, 14, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Title or "Paragraph"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Paragraph
    
    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -28, 0, 0)
    Content.Position = UDim2.new(0, 14, 0, 36)
    Content.BackgroundTransparency = 1
    Content.Text = Settings.Content or ""
    Content.TextColor3 = Theme:Get("TextSecondary")
    Content.TextSize = 13
    Content.Font = Enum.Font.Gotham
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextWrapped = true
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.Parent = Paragraph
    
    Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        Paragraph.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 50)
    end)
    
    return {
        Instance = Paragraph,
        Set = function(NewSettings)
            Title.Text = NewSettings.Title or Title.Text
            Content.Text = NewSettings.Content or Content.Text
        end
    }
end

function WindowClass:CreateLabel(Tab, Text)
    local Label = Instance.new("Frame")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 36)
    Label.BackgroundColor3 = Theme:Get("ElementBackground")
    Label.BorderSizePixel = 0
    Label.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Label
    
    local LabelText = Instance.new("TextLabel")
    LabelText.Size = UDim2.new(1, -24, 1, 0)
    LabelText.Position = UDim2.new(0, 14, 0, 0)
    LabelText.BackgroundTransparency = 1
    LabelText.Text = Text or "Label"
    LabelText.TextColor3 = Theme:Get("TextSecondary")
    LabelText.TextSize = 14
    LabelText.Font = Enum.Font.Gotham
    LabelText.TextXAlignment = Enum.TextXAlignment.Left
    LabelText.Parent = Label
    
    return {
        Instance = Label,
        Set = function(NewText)
            LabelText.Text = NewText
        end
    }
end

function WindowClass:CreateSection(Tab, Name)
    local Section = {
        Name = Name,
        Tab = Tab
    }
    
    -- Section header
    local Header = Instance.new("Frame")
    Header.Name = Name .. "Section"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1
    Header.Parent = Tab.Page
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name:upper()
    Title.TextColor3 = Theme:Get("TextMuted")
    Title.TextSize = 11
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    return Section
end

-- ==========================================
-- LIBRARY FUNCTIONS
-- ==========================================

function NexusUI:CreateWindow(Settings)
    local Window = WindowClass:Create(Settings)
    table.insert(self.Windows, Window)
    
    -- Return window with tab creation
    return {
        Main = Window,
        Tabs = {},
        
        CreateTab = function(_, Name, Icon)
            local Tab = Window:CreateTab(Name, Icon)
            Window.Tabs[Name] = Tab
            return Tab
        end,
        
        Destroy = function()
            Window:Destroy()
        end
    }
end

function NexusUI:Notify(Settings)
    return NotificationSystem:Notify(Settings)
end

function NexusUI:SetTheme(ThemeName)
    return Theme:SetTheme(ThemeName)
end

-- Global toggle
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.RightShift then
        for _, Window in ipairs(NexusUI.Windows) do
            Window.GUI.Enabled = not Window.GUI.Enabled
        end
    end
end)

return NexusUI
