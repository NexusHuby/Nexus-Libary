--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝███████╗
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚══════╝
    
    Nexus UI Library v2.0
    Inspired by Rayfield - Enhanced & Optimized
    Features: Spring animations, HSV ColorPicker, Keybinds, Auto-save
]]

local NexusUI = {
    Version = "2.0.0",
    Windows = {},
    Flags = {},
    Theme = {}
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- THEME SYSTEM (Rayfield-inspired)
-- ==========================================

local Theme = {
    Current = "Default",
    Palettes = {
        Default = {
            TextFont = Enum.Font.Gotham,
            TextColor = Color3.fromRGB(240, 240, 240),
            
            Background = Color3.fromRGB(25, 25, 25),
            Topbar = Color3.fromRGB(34, 34, 34),
            Shadow = Color3.fromRGB(20, 20, 20),
            
            ElementBackground = Color3.fromRGB(35, 35, 35),
            ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
            ElementStroke = Color3.fromRGB(50, 50, 50),
            
            SecondaryElementBackground = Color3.fromRGB(30, 30, 30),
            SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
            
            TabBackground = Color3.fromRGB(80, 80, 80),
            TabStroke = Color3.fromRGB(85, 85, 85),
            TabBackgroundSelected = Color3.fromRGB(88, 101, 242),
            TabTextColor = Color3.fromRGB(240, 240, 240),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            
            ToggleBackground = Color3.fromRGB(30, 30, 30),
            ToggleEnabled = Color3.fromRGB(88, 101, 242),
            ToggleDisabled = Color3.fromRGB(100, 100, 100),
            ToggleEnabledStroke = Color3.fromRGB(120, 130, 255),
            ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
            
            SliderBackground = Color3.fromRGB(50, 50, 50),
            SliderProgress = Color3.fromRGB(88, 101, 242),
            SliderStroke = Color3.fromRGB(70, 70, 70),
            
            InputBackground = Color3.fromRGB(30, 30, 30),
            InputStroke = Color3.fromRGB(65, 65, 65),
            PlaceholderColor = Color3.fromRGB(178, 178, 178),
            
            Accent = Color3.fromRGB(88, 101, 242),
            Success = Color3.fromRGB(87, 242, 135),
            Warning = Color3.fromRGB(254, 231, 92),
            Error = Color3.fromRGB(237, 69, 69),
            
            NotificationBackground = Color3.fromRGB(30, 30, 30)
        },
        Light = {
            TextFont = Enum.Font.Gotham,
            TextColor = Color3.fromRGB(50, 50, 50),
            
            Background = Color3.fromRGB(245, 245, 245),
            Topbar = Color3.fromRGB(217, 217, 217),
            Shadow = Color3.fromRGB(200, 200, 200),
            
            ElementBackground = Color3.fromRGB(255, 255, 255),
            ElementBackgroundHover = Color3.fromRGB(235, 235, 235),
            ElementStroke = Color3.fromRGB(200, 200, 200),
            
            SecondaryElementBackground = Color3.fromRGB(240, 240, 240),
            SecondaryElementStroke = Color3.fromRGB(220, 220, 220),
            
            TabBackground = Color3.fromRGB(220, 220, 220),
            TabStroke = Color3.fromRGB(180, 180, 180),
            TabBackgroundSelected = Color3.fromRGB(88, 101, 242),
            TabTextColor = Color3.fromRGB(80, 80, 80),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            
            ToggleBackground = Color3.fromRGB(200, 200, 200),
            ToggleEnabled = Color3.fromRGB(88, 101, 242),
            ToggleDisabled = Color3.fromRGB(150, 150, 150),
            ToggleEnabledStroke = Color3.fromRGB(120, 130, 255),
            ToggleDisabledStroke = Color3.fromRGB(170, 170, 170),
            
            SliderBackground = Color3.fromRGB(220, 220, 220),
            SliderProgress = Color3.fromRGB(88, 101, 242),
            SliderStroke = Color3.fromRGB(200, 200, 200),
            
            InputBackground = Color3.fromRGB(230, 230, 230),
            InputStroke = Color3.fromRGB(200, 200, 200),
            PlaceholderColor = Color3.fromRGB(150, 150, 150),
            
            Accent = Color3.fromRGB(88, 101, 242),
            Success = Color3.fromRGB(46, 204, 113),
            Warning = Color3.fromRGB(241, 196, 15),
            Error = Color3.fromRGB(231, 76, 60),
            
            NotificationBackground = Color3.fromRGB(255, 255, 255)
        },
        Midnight = {
            TextFont = Enum.Font.Gotham,
            TextColor = Color3.fromRGB(255, 255, 255),
            
            Background = Color3.fromRGB(15, 15, 25),
            Topbar = Color3.fromRGB(25, 25, 40),
            Shadow = Color3.fromRGB(10, 10, 20),
            
            ElementBackground = Color3.fromRGB(30, 30, 45),
            ElementBackgroundHover = Color3.fromRGB(40, 40, 60),
            ElementStroke = Color3.fromRGB(50, 50, 70),
            
            SecondaryElementBackground = Color3.fromRGB(25, 25, 35),
            SecondaryElementStroke = Color3.fromRGB(40, 40, 50),
            
            TabBackground = Color3.fromRGB(50, 50, 70),
            TabStroke = Color3.fromRGB(60, 60, 80),
            TabBackgroundSelected = Color3.fromRGB(114, 137, 218),
            TabTextColor = Color3.fromRGB(200, 200, 200),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            
            ToggleBackground = Color3.fromRGB(35, 35, 50),
            ToggleEnabled = Color3.fromRGB(114, 137, 218),
            ToggleDisabled = Color3.fromRGB(80, 80, 100),
            ToggleEnabledStroke = Color3.fromRGB(150, 170, 230),
            ToggleDisabledStroke = Color3.fromRGB(100, 100, 120),
            
            SliderBackground = Color3.fromRGB(40, 40, 60),
            SliderProgress = Color3.fromRGB(114, 137, 218),
            SliderStroke = Color3.fromRGB(50, 50, 70),
            
            InputBackground = Color3.fromRGB(30, 30, 45),
            InputStroke = Color3.fromRGB(50, 50, 70),
            PlaceholderColor = Color3.fromRGB(150, 150, 170),
            
            Accent = Color3.fromRGB(114, 137, 218),
            Success = Color3.fromRGB(87, 242, 135),
            Warning = Color3.fromRGB(254, 231, 92),
            Error = Color3.fromRGB(237, 69, 69),
            
            NotificationBackground = Color3.fromRGB(25, 25, 35)
        },
        Ocean = {
            TextFont = Enum.Font.Gotham,
            TextColor = Color3.fromRGB(255, 255, 255),
            
            Background = Color3.fromRGB(20, 30, 40),
            Topbar = Color3.fromRGB(30, 45, 60),
            Shadow = Color3.fromRGB(15, 25, 35),
            
            ElementBackground = Color3.fromRGB(35, 50, 65),
            ElementBackgroundHover = Color3.fromRGB(45, 65, 85),
            ElementStroke = Color3.fromRGB(55, 75, 95),
            
            SecondaryElementBackground = Color3.fromRGB(30, 40, 55),
            SecondaryElementStroke = Color3.fromRGB(45, 60, 75),
            
            TabBackground = Color3.fromRGB(50, 70, 90),
            TabStroke = Color3.fromRGB(60, 80, 100),
            TabBackgroundSelected = Color3.fromRGB(0, 200, 255),
            TabTextColor = Color3.fromRGB(200, 220, 240),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            
            ToggleBackground = Color3.fromRGB(40, 55, 70),
            ToggleEnabled = Color3.fromRGB(0, 200, 255),
            ToggleDisabled = Color3.fromRGB(100, 120, 140),
            ToggleEnabledStroke = Color3.fromRGB(100, 230, 255),
            ToggleDisabledStroke = Color3.fromRGB(120, 140, 160),
            
            SliderBackground = Color3.fromRGB(50, 70, 90),
            SliderProgress = Color3.fromRGB(0, 200, 255),
            SliderStroke = Color3.fromRGB(60, 80, 100),
            
            InputBackground = Color3.fromRGB(35, 50, 65),
            InputStroke = Color3.fromRGB(55, 75, 95),
            PlaceholderColor = Color3.fromRGB(150, 170, 190),
            
            Accent = Color3.fromRGB(0, 200, 255),
            Success = Color3.fromRGB(0, 255, 150),
            Warning = Color3.fromRGB(255, 200, 50),
            Error = Color3.fromRGB(255, 80, 80),
            
            NotificationBackground = Color3.fromRGB(30, 45, 60)
        }
    }
}

function Theme:Get(Key)
    return self.Palettes[self.Current][Key] or self.Palettes["Default"][Key]
end

function Theme:SetTheme(Name)
    if self.Palettes[Name] then
        self.Current = Name
        return true
    end
    return false
end

-- ==========================================
-- ADVANCED TWEEN SYSTEM (Spring + Quint)
-- ==========================================

local Tween = {}

function Tween:Create(Object, Properties, Duration, Style, Direction, Delay)
    local Info = TweenInfo.new(
        Duration or 0.4,
        Style or Enum.EasingStyle.Quint,
        Direction or Enum.EasingDirection.Out,
        0, false, Delay or 0
    )
    local TweenObj = TweenService:Create(Object, Info, Properties)
    TweenObj:Play()
    return TweenObj
end

-- Spring physics for natural motion
function Tween:Spring(Object, TargetPosition, Speed, Damping)
    Speed = Speed or 50
    Damping = Damping or 0.8
    
    local Connection
    local Velocity = Vector2.new(0, 0)
    local Current = Vector2.new(Object.Position.X.Offset, Object.Position.Y.Offset)
    local Target = Vector2.new(TargetPosition.X.Offset, TargetPosition.Y.Offset)
    
    Connection = RunService.Heartbeat:Connect(function(Delta)
        local Displacement = Target - Current
        local SpringForce = Displacement * Speed * Delta
        local DampingForce = Velocity * Damping
        
        Velocity = Velocity + SpringForce - DampingForce
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

function Tween:FadeIn(Object, Duration)
    Object.BackgroundTransparency = 1
    return self:Create(Object, {BackgroundTransparency = 0}, Duration or 0.5)
end

function Tween:FadeOut(Object, Duration, Callback)
    local TweenObj = self:Create(Object, {BackgroundTransparency = 1}, Duration or 0.4)
    if Callback then
        TweenObj.Completed:Connect(Callback)
    end
    return TweenObj
end

function Tween:Pop(Object, Scale)
    Scale = Scale or 1.1
    local OriginalSize = Object.Size
    local OriginalPos = Object.Position
    
    Tween:Create(Object, {Size = UDim2.new(
        OriginalSize.X.Scale * Scale,
        OriginalSize.X.Offset * Scale,
        OriginalSize.Y.Scale * Scale,
        OriginalSize.Y.Offset * Scale
    )}, 0.1, Enum.EasingStyle.Back)
    
    task.delay(0.1, function()
        Tween:Create(Object, {Size = OriginalSize}, 0.2, Enum.EasingStyle.Quint)
    end)
end

-- ==========================================
-- ICON SYSTEM (Lucide-style emoji)
-- ==========================================

local Icons = {
    ["home"] = "🏠",
    ["settings"] = "⚙️",
    ["user"] = "👤",
    ["menu"] = "☰",
    ["x"] = "✕",
    ["check"] = "✓",
    ["chevron-down"] = "▼",
    ["chevron-up"] = "▲",
    ["chevron-left"] = "◀",
    ["chevron-right"] = "▶",
    ["plus"] = "＋",
    ["minus"] = "−",
    ["edit"] = "✎",
    ["trash"] = "🗑",
    ["search"] = "🔍",
    ["filter"] = "⫧",
    ["play"] = "▶",
    ["pause"] = "⏸",
    ["stop"] = "⏹",
    ["bell"] = "🔔",
    ["moon"] = "🌙",
    ["sun"] = "☀",
    ["star"] = "★",
    ["heart"] = "♥",
    ["alert-circle"] = "⚠",
    ["alert-triangle"] = "▲",
    ["info"] = "ℹ",
    ["help-circle"] = "?",
    ["sliders"] = "⚒",
    ["eye"] = "👁",
    ["eye-off"] = "🚫",
    ["lock"] = "🔒",
    ["unlock"] = "🔓",
    ["arrow-up"] = "↑",
    ["arrow-down"] = "↓",
    ["arrow-left"] = "←",
    ["arrow-right"] = "→",
    ["maximize"] = "□",
    ["minimize"] = "−",
    ["key"] = "🔑",
    ["color"] = "🎨",
    ["save"] = "💾",
    ["refresh"] = "↻",
    ["copy"] = "📋",
    ["folder"] = "📁",
    ["file"] = "📄",
    ["image"] = "🖼",
    ["layout"] = "⚏",
    ["grid"] = "⊞",
    ["list"] = "☰",
    ["default"] = "•"
}

function Icons:Get(Name)
    return self[Name] or self["default"]
end

-- ==========================================
-- SAVE MANAGER (Enhanced from Rayfield)
-- ==========================================

local SaveManager = {
    Data = {},
    Enabled = true,
    Folder = "NexusUI",
    Extension = ".nexus",
    AutoSaveInterval = 30
}

function SaveManager:Init()
    self.Supported = pcall(function()
        if isfolder and makefolder and writefile and readfile then
            if not isfolder(self.Folder) then
                makefolder(self.Folder)
            end
            if not isfolder(self.Folder .. "/Configs") then
                makefolder(self.Folder .. "/Configs")
            end
            return true
        end
        return false
    end)
    
    if self.Supported then
        -- Auto-save loop
        task.spawn(function()
            while self.Enabled do
                task.wait(self.AutoSaveInterval)
                self:SaveAll()
            end
        end)
    else
        warn("[NexusUI] File system not supported - configuration saving disabled")
    end
end

function SaveManager:Set(FolderName, FileName, Data)
    if not self.Supported or not self.Enabled then return end
    
    pcall(function()
        local Path = self.Folder .. "/Configs/" .. FolderName
        if not isfolder(Path) then
            makefolder(Path)
        end
        writefile(Path .. "/" .. FileName .. self.Extension, HttpService:JSONEncode(Data))
    end)
end

function SaveManager:Get(FolderName, FileName, Default)
    if not self.Supported or not self.Enabled then return Default end
    
    local Success, Data = pcall(function()
        local Path = self.Folder .. "/Configs/" .. FolderName .. "/" .. FileName .. self.Extension
        if isfile(Path) then
            return HttpService:JSONDecode(readfile(Path))
        end
        return nil
    end)
    
    return Success and Data or Default
end

function SaveManager:SaveAll()
    -- Implemented in window creation
end

SaveManager:Init()

-- ==========================================
-- NOTIFICATION SYSTEM (Rayfield-style)
-- ==========================================

local NotificationSystem = {
    GUI = nil,
    Container = nil,
    Active = {}
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
    Layout.Padding = UDim.new(0, 10)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    Layout.Parent = self.Container
end

function NotificationSystem:Notify(Data)
    self:Init()
    
    Data = Data or {}
    local Title = Data.Title or "Notification"
    local Content = Data.Content or ""
    local Duration = Data.Duration or 5
    local Type = Data.Type or "Info"
    local Actions = Data.Actions or nil
    
    local Colors = {
        Info = Theme:Get("Accent"),
        Success = Theme:Get("Success"),
        Warning = Theme:Get("Warning"),
        Error = Theme:Get("Error")
    }
    
    local Notif = Instance.new("Frame")
    Notif.Name = "Notification"
    Notif.Size = UDim2.new(0, 300, 0, Actions and 120 or 80)
    Notif.BackgroundColor3 = Theme:Get("NotificationBackground")
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.Parent = self.Container
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 60, 1, 60)
    Shadow.ZIndex = -1
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = Notif
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Notif
    
    -- Accent line
    local Accent = Instance.new("Frame")
    Accent.Name = "Accent"
    Accent.Size = UDim2.new(0, 4, 1, 0)
    Accent.BackgroundColor3 = Colors[Type]
    Accent.BorderSizePixel = 0
    Accent.Parent = Notif
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 12)
    AccentCorner.Parent = Accent
    
    -- Icon
    local IconMap = {
        Info = "ℹ",
        Success = "✓",
        Warning = "▲",
        Error = "✕"
    }
    
    local Icon = Instance.new("TextLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 28, 0, 28)
    Icon.Position = UDim2.new(0, 15, 0, 15)
    Icon.BackgroundTransparency = 1
    Icon.Text = IconMap[Type] or "•"
    Icon.TextColor3 = Colors[Type]
    Icon.TextSize = 22
    Icon.Font = Enum.Font.GothamBold
    Icon.Parent = Notif
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -70, 0, 22)
    TitleLabel.Position = UDim2.new(0, 50, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme:Get("TextColor")
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notif
    
    -- Content
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Name = "Content"
    ContentLabel.Size = UDim2.new(1, -70, 0, 40)
    ContentLabel.Position = UDim2.new(0, 50, 0, 36)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = Content
    ContentLabel.TextColor3 = Theme:Get("TextColor")
    ContentLabel.TextTransparency = 0.3
    ContentLabel.TextSize = 14
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.Parent = Notif
    
    -- Actions container
    if Actions then
        local ActionsFrame = Instance.new("Frame")
        ActionsFrame.Name = "Actions"
        ActionsFrame.Size = UDim2.new(1, -20, 0, 36)
        ActionsFrame.Position = UDim2.new(0, 10, 0, 78)
        ActionsFrame.BackgroundTransparency = 1
        ActionsFrame.Parent = Notif
        
        local ActionsLayout = Instance.new("UIListLayout")
        ActionsLayout.FillDirection = Enum.FillDirection.Horizontal
        ActionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        ActionsLayout.Padding = UDim.new(0, 8)
        ActionsLayout.Parent = ActionsFrame
        
        for _, Action in ipairs(Actions) do
            local ActionBtn = Instance.new("TextButton")
            ActionBtn.Name = Action.Name
            ActionBtn.Size = UDim2.new(0, 0, 1, 0)
            ActionBtn.AutomaticSize = Enum.AutomaticSize.X
            ActionBtn.BackgroundColor3 = Theme:Get("ElementBackground")
            ActionBtn.Text = Action.Name
            ActionBtn.TextColor3 = Theme:Get("TextColor")
            ActionBtn.TextSize = 13
            ActionBtn.Font = Enum.Font.GothamSemibold
            ActionBtn.Parent = ActionsFrame
            
            local BtnPadding = Instance.new("UIPadding")
            BtnPadding.PaddingLeft = UDim.new(0, 16)
            BtnPadding.PaddingRight = UDim.new(0, 16)
            BtnPadding.Parent = ActionBtn
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ActionBtn
            
            ActionBtn.MouseButton1Click:Connect(function()
                pcall(Action.Callback)
                Duration = 0.1 -- Close immediately
            end)
        end
    end
    
    -- Entrance animation
    Notif.Position = UDim2.new(1, 50, 0, 0)
    Tween:Create(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.6, Enum.EasingStyle.Quint)
    
    -- Progress bar
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new(1, -8, 0, 3)
    Progress.Position = UDim2.new(0, 4, 1, -6)
    Progress.BackgroundColor3 = Colors[Type]
    Progress.BorderSizePixel = 0
    Progress.Parent = Notif
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = Progress
    
    Tween:Create(Progress, {Size = UDim2.new(0, 0, 0, 3)}, Duration, Enum.EasingStyle.Linear)
    
    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -28, 0, 8)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Theme:Get("TextColor")
    CloseBtn.TextTransparency = 0.5
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Notif
    
    CloseBtn.MouseButton1Click:Connect(function()
        Duration = 0.1
    end)
    
    -- Auto close
    task.delay(Duration, function()
        -- Exit animation
        Tween:Create(Notif, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.5, Enum.EasingStyle.Quint).Completed:Connect(function()
            Notif:Destroy()
        end)
        Tween:Create(TitleLabel, {TextTransparency = 1}, 0.4)
        Tween:Create(ContentLabel, {TextTransparency = 1}, 0.4)
        Tween:Create(Icon, {TextTransparency = 1}, 0.4)
        Tween:Create(Accent, {BackgroundTransparency = 1}, 0.4)
    end)
    
    table.insert(self.Active, Notif)
    return Notif
end

-- ==========================================
-- WINDOW CLASS
-- ==========================================

local WindowClass = {}
WindowClass.__index = WindowClass

function WindowClass:Create(Settings)
    local self = setmetatable({}, WindowClass)
    Settings = Settings or {}
    
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Hidden = false
    self.Flags = {}
    self.FolderName = Settings.ConfigurationFolder or "Default"
    
    -- Create GUI
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusUI_" .. (Settings.Name or "Window")
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.Parent = CoreGui
    
    -- Main frame
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = Settings.Size or UDim2.new(0, 550, 0, 400)
    self.Main.Position = UDim2.new(0.5, -275, 0.5, -200)
    self.Main.BackgroundColor3 = Theme:Get("Background")
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = true
    self.Main.Parent = self.GUI
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
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
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = self.Main
    
    -- Topbar
    self.Topbar = Instance.new("Frame")
    self.Topbar.Name = "Topbar"
    self.Topbar.Size = UDim2.new(1, 0, 0, 45)
    self.Topbar.BackgroundColor3 = Theme:Get("Topbar")
    self.Topbar.BorderSizePixel = 0
    self.Topbar.Parent = self.Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 12)
    TopbarCorner.Parent = self.Topbar
    
    -- Fix bottom corners
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Name = "CornerFix"
    TopbarFix.Size = UDim2.new(1, 0, 0, 12)
    TopbarFix.Position = UDim2.new(0, 0, 1, -12)
    TopbarFix.BackgroundColor3 = Theme:Get("Topbar")
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Parent = self.Topbar
    
    -- Divider
    local Divider = Instance.new("Frame")
    Divider.Name = "Divider"
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 1, 0)
    Divider.BackgroundColor3 = Theme:Get("ElementStroke")
    Divider.BorderSizePixel = 0
    Divider.Parent = self.Topbar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -150, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Nexus UI"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Topbar
    
    -- Window controls
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 90, 1, 0)
    Controls.Position = UDim2.new(1, -95, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = self.Topbar
    
    -- Minimize button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "Minimize"
    MinBtn.Size = UDim2.new(0, 32, 0, 32)
    MinBtn.Position = UDim2.new(0, 0, 0.5, -16)
    MinBtn.BackgroundColor3 = Theme:Get("ElementBackground")
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Theme:Get("TextColor")
    MinBtn.TextSize = 18
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = Controls
    
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
    
    -- Theme button
    local ThemeBtn = Instance.new("TextButton")
    ThemeBtn.Name = "Theme"
    ThemeBtn.Size = UDim2.new(0, 32, 0, 32)
    ThemeBtn.Position = UDim2.new(0, 38, 0.5, -16)
    ThemeBtn.BackgroundColor3 = Theme:Get("ElementBackground")
    ThemeBtn.Text = "◐"
    ThemeBtn.TextColor3 = Theme:Get("TextColor")
    ThemeBtn.TextSize = 16
    ThemeBtn.Font = Enum.Font.GothamBold
    ThemeBtn.Parent = Controls
    
    Instance.new("UICorner", ThemeBtn).CornerRadius = UDim.new(0, 8)
    
    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(0, 76, 0.5, -16)
    CloseBtn.BackgroundColor3 = Theme:Get("Error")
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Controls
    
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)
    
    -- Sidebar (Tab list)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, 140, 1, -45)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 45)
    self.Sidebar.BackgroundColor3 = Theme:Get("Topbar")
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.Main
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = self.Sidebar
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Name = "CornerFix"
    SidebarFix.Size = UDim2.new(0, 12, 1, 0)
    SidebarFix.Position = UDim2.new(1, -12, 0, 0)
    SidebarFix.BackgroundColor3 = Theme:Get("Topbar")
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = self.Sidebar
    
    -- Tab list scrolling frame
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.Size = UDim2.new(1, -16, 1, -20)
    self.TabList.Position = UDim2.new(0, 8, 0, 10)
    self.TabList.BackgroundTransparency = 1
    self.TabList.ScrollBarThickness = 2
    self.TabList.ScrollBarImageColor3 = Theme:Get("Accent")
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.Parent = self.Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 8)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = self.TabList
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content area
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.Size = UDim2.new(1, -140, 1, -45)
    self.Content.Position = UDim2.new(0, 140, 0, 45)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main
    
    -- Pages (like Rayfield's UIPageLayout)
    self.Pages = Instance.new("Frame")
    self.Pages.Name = "Pages"
    self.Pages.Size = UDim2.new(1, 0, 1, 0)
    self.Pages.BackgroundTransparency = 1
    self.Pages.ClipsDescendants = true
    self.Pages.Parent = self.Content
    
    -- Dragging functionality (Rayfield-style)
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
            Tween:Create(self.Main, {
                Position = UDim2.new(
                    StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                    StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
                )
            }, 0.45, Enum.EasingStyle.Quint)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    -- Button events
    CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    MinBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    ThemeBtn.MouseButton1Click:Connect(function()
        local Themes = {"Default", "Light", "Midnight", "Ocean"}
        local CurrentIndex = table.find(Themes, Theme.Current) or 1
        local NextIndex = CurrentIndex % #Themes + 1
        self:SetTheme(Themes[NextIndex])
    end)
    
    -- Hover effects
    local function AddHover(Button, OriginalColor)
        Button.MouseEnter:Connect(function()
            Tween:Create(Button, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
        end)
        Button.MouseLeave:Connect(function()
            Tween:Create(Button, {BackgroundColor3 = OriginalColor}, 0.3)
        end)
    end
    
    AddHover(MinBtn, Theme:Get("ElementBackground"))
    AddHover(ThemeBtn, Theme:Get("ElementBackground"))
    
    -- Intro animation
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    Tween:Create(self.Main, {
        Size = Settings.Size or UDim2.new(0, 550, 0, 400)
    }, 0.8, Enum.EasingStyle.Back)
    
    return self
end

function WindowClass:SetTheme(ThemeName)
    if Theme:SetTheme(ThemeName) then
        -- Update all elements
        Tween:Create(self.Main, {BackgroundColor3 = Theme:Get("Background")}, 0.5)
        Tween:Create(self.Topbar, {BackgroundColor3 = Theme:Get("Topbar")}, 0.5)
        Tween:Create(self.Sidebar, {BackgroundColor3 = Theme:Get("Topbar")}, 0.5)
        
        NexusUI:Notify({
            Title = "Theme Changed",
            Content = "Switched to " .. ThemeName .. " theme",
            Type = "Success",
            Duration = 2
        })
    end
end

function WindowClass:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        Tween:Create(self.Main, {Size = UDim2.new(0, self.Main.Size.X.Offset, 0, 45)}, 0.5, Enum.EasingStyle.Quint)
        self.Sidebar.Visible = false
        self.Content.Visible = false
    else
        Tween:Create(self.Main, {Size = UDim2.new(0, 550, 0, 400)}, 0.5, Enum.EasingStyle.Quint)
        task.delay(0.3, function()
            self.Sidebar.Visible = true
            self.Content.Visible = true
        end)
    end
end

function WindowClass:CreateTab(Name, Icon)
    local Tab = {
        Name = Name,
        Sections = {},
        Elements = {},
        Window = self
    }
    
    -- Tab button
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Name .. "Tab"
    Tab.Button.Size = UDim2.new(1, 0, 0, 36)
    Tab.Button.BackgroundColor3 = Theme:Get("TabBackground")
    Tab.Button.Text = ""
    Tab.Button.AutoButtonColor = false
    Tab.Button.Parent = self.TabList
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Tab.Button
    
    -- Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Size = UDim2.new(0, 22, 0, 22)
    IconLabel.Position = UDim2.new(0, 10, 0.5, -11)
    IconLabel.BackgroundTransparency = 1
    IconLabel.Text = Icons:Get(Icon)
    IconLabel.TextColor3 = Theme:Get("TabTextColor")
    IconLabel.TextSize = 16
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.Parent = Tab.Button
    
    -- Tab name
    local TabName = Instance.new("TextLabel")
    TabName.Name = "Name"
    TabName.Size = UDim2.new(1, -42, 1, 0)
    TabName.Position = UDim2.new(0, 36, 0, 0)
    TabName.BackgroundTransparency = 1
    TabName.Text = Name
    TabName.TextColor3 = Theme:Get("TabTextColor")
    TabName.TextSize = 14
    TabName.Font = Enum.Font.GothamSemibold
    TabName.TextXAlignment = Enum.TextXAlignment.Left
    TabName.Parent = Tab.Button
    
    -- Page (content container)
    Tab.Page = Instance.new("ScrollingFrame")
    Tab.Page.Name = Name .. "Page"
    Tab.Page.Size = UDim2.new(1, 0, 1, 0)
    Tab.Page.BackgroundTransparency = 1
    Tab.Page.ScrollBarThickness = 3
    Tab.Page.ScrollBarImageColor3 = Theme:Get("Accent")
    Tab.Page.Visible = false
    Tab.Page.Parent = self.Pages
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 12)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Tab.Page
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Tab.Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
    end)
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)
    PagePadding.Parent = Tab.Page
    
    -- Click event
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    Tab.Button.MouseEnter:Connect(function()
        if self.ActiveTab ~= Tab then
            Tween:Create(Tab.Button, {BackgroundColor3 = Theme:Get("TabBackground")}, 0.3)
            Tween:Create(TabName, {TextTransparency = 0}, 0.3)
            Tween:Create(IconLabel, {TextTransparency = 0}, 0.3)
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if self.ActiveTab ~= Tab then
            Tween:Create(Tab.Button, {BackgroundTransparency = 0.7}, 0.3)
            Tween:Create(TabName, {TextTransparency = 0.2}, 0.3)
            Tween:Create(IconLabel, {TextTransparency = 0.2}, 0.3)
        end
    end)
    
    -- Element creation methods
    function Tab:CreateSection(SectionName)
        local Section = {}
        
        -- Section container
        Section.Container = Instance.new("Frame")
        Section.Container.Name = SectionName .. "Section"
        Section.Container.Size = UDim2.new(1, 0, 0, 40)
        Section.Container.BackgroundColor3 = Theme:Get("ElementBackground")
        Section.Container.BorderSizePixel = 0
        Section.Container.AutomaticSize = Enum.AutomaticSize.Y
        Section.Container.Parent = self.Page
        
        local ContainerCorner = Instance.new("UICorner")
        ContainerCorner.CornerRadius = UDim.new(0, 10)
        ContainerCorner.Parent = Section.Container
        
        local ContainerStroke = Instance.new("UIStroke")
        ContainerStroke.Color = Theme:Get("ElementStroke")
        ContainerStroke.Thickness = 1
        ContainerStroke.Parent = Section.Container
        
        -- Section title
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -20, 0, 24)
        Title.Position = UDim2.new(0, 12, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = SectionName
        Title.TextColor3 = Theme:Get("TextColor")
        Title.TextSize = 16
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Section.Container
        
        -- Elements container
        Section.Elements = Instance.new("Frame")
        Section.Elements.Name = "Elements"
        Section.Elements.Size = UDim2.new(1, -24, 0, 0)
        Section.Elements.Position = UDim2.new(0, 12, 0, 38)
        Section.Elements.BackgroundTransparency = 1
        Section.Elements.AutomaticSize = Enum.AutomaticSize.Y
        Section.Elements.Parent = Section.Container
        
        local ElementsLayout = Instance.new("UIListLayout")
        ElementsLayout.Padding = UDim.new(0, 10)
        ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ElementsLayout.Parent = Section.Elements
        
        -- Methods
        function Section:AddButton(ButtonSettings)
            return self.Window:CreateButton(self, ButtonSettings)
        end
        
        function Section:AddToggle(ToggleSettings)
            return self.Window:CreateToggle(self, ToggleSettings)
        end
        
        function Section:AddSlider(SliderSettings)
            return self.Window:CreateSlider(self, SliderSettings)
        end
        
        function Section:AddDropdown(DropdownSettings)
            return self.Window:CreateDropdown(self, DropdownSettings)
        end
        
        function Section:AddInput(InputSettings)
            return self.Window:CreateInput(self, InputSettings)
        end
        
        function Section:AddKeybind(KeybindSettings)
            return self.Window:CreateKeybind(self, KeybindSettings)
        end
        
        function Section:AddColorPicker(ColorPickerSettings)
            return self.Window:CreateColorPicker(self, ColorPickerSettings)
        end
        
        function Section:AddParagraph(ParagraphSettings)
            return self.Window:CreateParagraph(self, ParagraphSettings)
        end
        
        function Section:AddLabel(LabelText)
            return self.Window:CreateLabel(self, LabelText)
        end
        
        table.insert(self.Sections, Section)
        return Section
    end
    
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(Tab)
    else
        Tab.Button.BackgroundTransparency = 0.7
        TabName.TextTransparency = 0.2
        IconLabel.TextTransparency = 0.2
    end
    
    return Tab
end

function WindowClass:SelectTab(Tab)
    if self.ActiveTab == Tab then return end
    
    -- Deselect current
    if self.ActiveTab then
        self.ActiveTab.Page.Visible = false
        Tween:Create(self.ActiveTab.Button, {BackgroundColor3 = Theme:Get("TabBackground")}, 0.3)
        Tween:Create(self.ActiveTab.Button, {BackgroundTransparency = 0.7}, 0.3)
        Tween:Create(self.ActiveTab.Button.Name, {TextTransparency = 0.2}, 0.3)
        Tween:Create(self.ActiveTab.Button.Icon, {TextTransparency = 0.2}, 0.3)
    end
    
    -- Select new
    self.ActiveTab = Tab
    Tab.Page.Visible = true
    Tab.Page.Position = UDim2.new(0.02, 0, 0, 0)
    Tween:Create(Tab.Page, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quint)
    
    Tween:Create(Tab.Button, {BackgroundColor3 = Theme:Get("TabBackgroundSelected")}, 0.3)
    Tween:Create(Tab.Button, {BackgroundTransparency = 0}, 0.3)
    Tween:Create(Tab.Button.Name, {TextTransparency = 0}, 0.3)
    Tween:Create(Tab.Button.Icon, {TextTransparency = 0}, 0.3)
    Tab.Button.Name.TextColor3 = Theme:Get("SelectedTabTextColor")
    Tab.Button.Icon.TextColor3 = Theme:Get("SelectedTabTextColor")
end

-- ==========================================
-- ELEMENT CREATION (Rayfield-inspired)
-- ==========================================

function WindowClass:CreateButton(Section, Settings)
    Settings = Settings or {}
    
    local Button = Instance.new("TextButton")
    Button.Name = Settings.Name or "Button"
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = Theme:Get("SecondaryElementBackground")
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("SecondaryElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Button
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Button"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    -- Indicator
    local Indicator = Instance.new("TextLabel")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    Indicator.Position = UDim2.new(1, -28, 0.5, -10)
    Indicator.BackgroundTransparency = 1
    Indicator.Text = "→"
    Indicator.TextColor3 = Theme:Get("TextColor")
    Indicator.TextTransparency = 0.6
    Indicator.TextSize = 16
    Indicator.Font = Enum.Font.GothamBold
    Indicator.Parent = Button
    
    -- Hover & Click
    Button.MouseEnter:Connect(function()
        Tween:Create(Button, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
        Tween:Create(Indicator, {TextTransparency = 0.3}, 0.3)
    end)
    
    Button.MouseLeave:Connect(function()
        Tween:Create(Button, {BackgroundColor3 = Theme:Get("SecondaryElementBackground")}, 0.3)
        Tween:Create(Indicator, {TextTransparency = 0.6}, 0.3)
    end)
    
    Button.MouseButton1Click:Connect(function()
        Tween:Create(Button, {BackgroundColor3 = Theme:Get("Accent")}, 0.1).Completed:Connect(function()
            Tween:Create(Button, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
        end)
        
        if Settings.Callback then
            local Success, Error = pcall(Settings.Callback)
            if not Success then
                NexusUI:Notify({
                    Title = "Button Error",
                    Content = tostring(Error),
                    Type = "Error",
                    Duration = 5
                })
            end
        end
    end)
    
    return {
        Instance = Button,
        Set = function(NewName)
            Title.Text = NewName
            Button.Name = NewName
        end
    }
end

function WindowClass:CreateToggle(Section, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Toggle") .. "_Flag"
    local Value = SaveManager:Get(self.FolderName, Flag, Settings.CurrentValue or false)
    
    local Toggle = Instance.new("Frame")
    Toggle.Name = Settings.Name or "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 40)
    Toggle.BackgroundColor3 = Theme:Get("ElementBackground")
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Toggle
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Toggle
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Toggle"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Toggle
    
    -- Toggle switch container
    local Switch = Instance.new("Frame")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 44, 0, 24)
    Switch.Position = UDim2.new(1, -58, 0.5, -12)
    Switch.BackgroundColor3 = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
    Switch.BorderSizePixel = 0
    Switch.Parent = Toggle
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local SwitchStroke = Instance.new("UIStroke")
    SwitchStroke.Color = Value and Theme:Get("ToggleEnabledStroke") or Theme:Get("ToggleDisabledStroke")
    SwitchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SwitchStroke.Parent = Switch
    
    -- Toggle circle
    local Circle = Instance.new("Frame")
    Circle.Name = "Circle"
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    -- Shadow
    local CircleShadow = Instance.new("ImageLabel")
    CircleShadow.Name = "Shadow"
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
        SaveManager:Set(self.FolderName, Flag, Value)
        
        local TargetColor = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
        local TargetStroke = Value and Theme:Get("ToggleEnabledStroke") or Theme:Get("ToggleDisabledStroke")
        local TargetPos = Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        
        Tween:Create(Switch, {BackgroundColor3 = TargetColor}, 0.3)
        Tween:Create(SwitchStroke, {Color = TargetStroke}, 0.3)
        Tween:Create(Circle, {Position = TargetPos}, 0.3, Enum.EasingStyle.Quint)
        
        if Settings.Callback then
            local Success, Error = pcall(function()
                Settings.Callback(Value)
            end)
            if not Success then
                NexusUI:Notify({
                    Title = "Toggle Error",
                    Content = tostring(Error),
                    Type = "Error"
                })
            end
        end
    end
    
    -- Click area
    local ClickArea = Instance.new("TextButton")
    ClickArea.Name = "ClickArea"
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = Toggle
    
    ClickArea.MouseButton1Click:Connect(function()
        SetToggle(not Value)
    end)
    
    Toggle.MouseEnter:Connect(function()
        Tween:Create(Toggle, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Toggle.MouseLeave:Connect(function()
        Tween:Create(Toggle, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Toggle,
        Set = SetToggle,
        Get = function() return Value end
    }
end

function WindowClass:CreateSlider(Section, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Slider") .. "_Flag"
    local Range = Settings.Range or {0, 100}
    local Increment = Settings.Increment or 1
    local Suffix = Settings.Suffix or ""
    local Value = SaveManager:Get(self.FolderName, Flag, Settings.CurrentValue or Range[1])
    
    local Slider = Instance.new("Frame")
    Slider.Name = Settings.Name or "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 50)
    Slider.BackgroundColor3 = Theme:Get("ElementBackground")
    Slider.BorderSizePixel = 0
    Slider.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Slider
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Slider
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 0, 20)
    Title.Position = UDim2.new(0, 14, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Slider"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Slider
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "Value"
    ValueLabel.Size = UDim2.new(0, 80, 0, 20)
    ValueLabel.Position = UDim2.new(1, -90, 0, 8)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(Value) .. Suffix
    ValueLabel.TextColor3 = Theme:Get("TextColor")
    ValueLabel.TextTransparency = 0.4
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Slider
    
    -- Slider background
    local SliderBg = Instance.new("Frame")
    SliderBg.Name = "Background"
    SliderBg.Size = UDim2.new(1, -28, 0, 8)
    SliderBg.Position = UDim2.new(0, 14, 0, 32)
    SliderBg.BackgroundColor3 = Theme:Get("SliderBackground")
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Slider
    
    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(1, 0)
    BgCorner.Parent = SliderBg
    
    local BgStroke = Instance.new("UIStroke")
    BgStroke.Color = Theme:Get("SliderStroke")
    BgStroke.Thickness = 1
    BgStroke.Parent = SliderBg
    
    -- Progress
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)
    Progress.BackgroundColor3 = Theme:Get("SliderProgress")
    Progress.BorderSizePixel = 0
    Progress.Parent = SliderBg
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = Progress
    
    -- Drag handle
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
    HandleShadow.Name = "Shadow"
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
    
    local function UpdateSlider(Input)
        local SizeScale = math.clamp((Input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local NewValue = Range[1] + (Range[2] - Range[1]) * SizeScale
        
        -- Apply increment
        NewValue = math.floor(NewValue / Increment + 0.5) * Increment
        NewValue = math.clamp(NewValue, Range[1], Range[2])
        
        if NewValue ~= Value then
            Value = NewValue
            SaveManager:Set(self.FolderName, Flag, Value)
            ValueLabel.Text = tostring(Value) .. Suffix
            
            Tween:Create(Progress, {Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)}, 0.1)
            
            if Settings.Callback then
                pcall(Settings.Callback, Value)
            end
        end
    end
    
    SliderBg.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            UpdateSlider(Input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(Input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    
    Slider.MouseEnter:Connect(function()
        Tween:Create(Slider, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Slider.MouseLeave:Connect(function()
        Tween:Create(Slider, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Slider,
        Set = function(NewValue)
            NewValue = math.clamp(NewValue, Range[1], Range[2])
            Value = NewValue
            ValueLabel.Text = tostring(Value) .. Suffix
            Tween:Create(Progress, {Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)}, 0.2)
            if Settings.Callback then
                pcall(Settings.Callback, Value)
            end
        end,
        Get = function() return Value end
    }
end

function WindowClass:CreateDropdown(Section, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Dropdown") .. "_Flag"
    local Options = Settings.Options or {}
    local Multi = Settings.MultipleOptions or false
    local CurrentOption = SaveManager:Get(self.FolderName, Flag, Settings.CurrentOption or (Multi and {} or (Options[1] or "")))
    
    -- Ensure CurrentOption is table for multi
    if Multi and typeof(CurrentOption) ~= "table" then
        CurrentOption = {CurrentOption}
    end
    
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = Settings.Name or "Dropdown"
    Dropdown.Size = UDim2.new(1, 0, 0, 42)
    Dropdown.BackgroundColor3 = Theme:Get("ElementBackground")
    Dropdown.BorderSizePixel = 0
    Dropdown.ClipsDescendants = true
    Dropdown.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Dropdown
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Dropdown
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 14, 0, 11)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Dropdown"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Dropdown
    
    -- Selected value display
    local Selected = Instance.new("TextLabel")
    Selected.Name = "Selected"
    Selected.Size = UDim2.new(0, 120, 0, 20)
    Selected.Position = UDim2.new(1, -140, 0, 11)
    Selected.BackgroundTransparency = 1
    Selected.Text = Multi and (#CurrentOption == 0 and "None" or #CurrentOption == 1 and CurrentOption[1] or "Various") or tostring(CurrentOption)
    Selected.TextColor3 = Theme:Get("TextColor")
    Selected.TextTransparency = 0.4
    Selected.TextSize = 13
    Selected.Font = Enum.Font.Gotham
    Selected.TextXAlignment = Enum.TextXAlignment.Right
    Selected.Parent = Dropdown
    
    -- Arrow
    local Arrow = Instance.new("TextLabel")
    Arrow.Name = "Arrow"
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -30, 0, 11)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Theme:Get("TextColor")
    Arrow.TextTransparency = 0.4
    Arrow.TextSize = 12
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Dropdown
    
    -- Options container
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Name = "Options"
    OptionsFrame.Size = UDim2.new(1, -28, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 14, 0, 45)
    OptionsFrame.BackgroundColor3 = Theme:Get("SecondaryElementBackground")
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.Parent = Dropdown
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 8)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsStroke = Instance.new("UIStroke")
    OptionsStroke.Color = Theme:Get("SecondaryElementStroke")
    OptionsStroke.Thickness = 1
    OptionsStroke.Parent = OptionsFrame
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.Padding = UDim.new(0, 4)
    OptionsList.Parent = OptionsFrame
    
    local Open = false
    
    local function BuildOptions()
        for _, Child in ipairs(OptionsFrame:GetChildren()) do
            if Child:IsA("TextButton") then Child:Destroy() end
        end
        
        for _, Option in ipairs(Options) do
            local OptionBtn = Instance.new("TextButton")
            OptionBtn.Name = Option
            OptionBtn.Size = UDim2.new(1, 0, 0, 32)
            OptionBtn.BackgroundColor3 = Theme:Get("SecondaryElementBackground")
            OptionBtn.Text = ""
            OptionBtn.AutoButtonColor = false
            OptionBtn.Parent = OptionsFrame
            
            local IsSelected = Multi and table.find(CurrentOption, Option) or CurrentOption == Option
            
            if IsSelected then
                OptionBtn.BackgroundColor3 = Theme:Get("Accent")
            end
            
            local OptionCorner = Instance.new("UICorner")
            OptionCorner.CornerRadius = UDim.new(0, 6)
            OptionCorner.Parent = OptionBtn
            
            local OptionText = Instance.new("TextLabel")
            OptionText.Size = UDim2.new(1, -20, 1, 0)
            OptionText.Position = UDim2.new(0, 10, 0, 0)
            OptionText.BackgroundTransparency = 1
            OptionText.Text = Option
            OptionText.TextColor3 = IsSelected and Color3.new(1, 1, 1) or Theme:Get("TextColor")
            OptionText.TextSize = 13
            OptionText.Font = Enum.Font.Gotham
            OptionText.TextXAlignment = Enum.TextXAlignment.Left
            OptionText.Parent = OptionBtn
            
            OptionBtn.MouseEnter:Connect(function()
                if not IsSelected then
                    Tween:Create(OptionBtn, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
                end
            end)
            
            OptionBtn.MouseLeave:Connect(function()
                if not IsSelected then
                    Tween:Create(OptionBtn, {BackgroundColor3 = Theme:Get("SecondaryElementBackground")}, 0.2)
                end
            end)
            
            OptionBtn.MouseButton1Click:Connect(function()
                if Multi then
                    if table.find(CurrentOption, Option) then
                        table.remove(CurrentOption, table.find(CurrentOption, Option))
                    else
                        table.insert(CurrentOption, Option)
                    end
                else
                    CurrentOption = Option
                end
                
                SaveManager:Set(self.FolderName, Flag, CurrentOption)
                
                -- Update display
                if Multi then
                    Selected.Text = #CurrentOption == 0 and "None" or #CurrentOption == 1 and CurrentOption[1] or "Various"
                else
                    Selected.Text = tostring(CurrentOption)
                end
                
                BuildOptions()
                
                if not Multi then
                    -- Close dropdown
                    Tween:Create(Arrow, {Rotation = 0}, 0.3)
                    Tween:Create(Dropdown, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
                    task.delay(0.3, function()
                        OptionsFrame.Visible = false
                        Open = false
                    end)
                end
                
                if Settings.Callback then
                    pcall(Settings.Callback, Multi and CurrentOption or CurrentOption)
                end
            end)
        end
        
        local Height = math.min(#Options * 36, 150)
        OptionsFrame.Size = UDim2.new(1, -28, 0, Height)
    end
    
    -- Click area
    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 0, 42)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = Dropdown
    
    ClickArea.MouseButton1Click:Connect(function()
        Open = not Open
        
        if Open then
            OptionsFrame.Visible = true
            BuildOptions()
            Tween:Create(Arrow, {Rotation = 180}, 0.3)
            Tween:Create(Dropdown, {Size = UDim2.new(1, 0, 0, 55 + OptionsFrame.Size.Y.Offset)}, 0.3)
        else
            Tween:Create(Arrow, {Rotation = 0}, 0.3)
            Tween:Create(Dropdown, {Size = UDim2.new(1, 0, 0, 42)}, 0.3)
            task.delay(0.3, function()
                OptionsFrame.Visible = false
            end)
        end
    end)
    
    Dropdown.MouseEnter:Connect(function()
        Tween:Create(Dropdown, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Dropdown.MouseLeave:Connect(function()
        Tween:Create(Dropdown, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Dropdown,
        Set = function(NewOption)
            CurrentOption = NewOption
            SaveManager:Set(self.FolderName, Flag, CurrentOption)
            if Multi then
                Selected.Text = #CurrentOption == 0 and "None" or #CurrentOption == 1 and CurrentOption[1] or "Various"
            else
                Selected.Text = tostring(CurrentOption)
            end
            BuildOptions()
        end,
        Get = function() return CurrentOption end,
        Refresh = function(NewOptions)
            Options = NewOptions
            if Open then BuildOptions() end
        end
    }
end

function WindowClass:CreateInput(Section, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Input") .. "_Flag"
    local Value = SaveManager:Get(self.FolderName, Flag, Settings.CurrentValue or "")
    local Numeric = Settings.Numeric or false
    local Placeholder = Settings.PlaceholderText or "Enter text..."
    local Finished = Settings.RemoveTextAfterFocusLost or false
    
    local Input = Instance.new("Frame")
    Input.Name = Settings.Name or "Input"
    Input.Size = UDim2.new(1, 0, 0, 72)
    Input.BackgroundColor3 = Theme:Get("ElementBackground")
    Input.BorderSizePixel = 0
    Input.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Input
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Input
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 14, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Input"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Input
    
    -- Input box
    local InputBox = Instance.new("TextBox")
    InputBox.Name = "InputBox"
    InputBox.Size = UDim2.new(1, -28, 0, 30)
    InputBox.Position = UDim2.new(0, 14, 0, 36)
    InputBox.BackgroundColor3 = Theme:Get("InputBackground")
    InputBox.BorderSizePixel = 0
    InputBox.Text = tostring(Value)
    InputBox.PlaceholderText = Placeholder
    InputBox.PlaceholderColor3 = Theme:Get("PlaceholderColor")
    InputBox.TextColor3 = Theme:Get("TextColor")
    InputBox.TextSize = 13
    InputBox.Font = Enum.Font.Gotham
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = Input
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = InputBox
    
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = Theme:Get("InputStroke")
    BoxStroke.Thickness = 1
    BoxStroke.Parent = InputBox
    
    InputBox.FocusLost:Connect(function()
        local Text = InputBox.Text
        
        if Numeric then
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
        
        SaveManager:Set(self.FolderName, Flag, Value)
        
        if Settings.Callback then
            pcall(Settings.Callback, Value)
        end
        
        if Finished then
            InputBox.Text = ""
        end
    end)
    
    InputBox.Focused:Connect(function()
        Tween:Create(InputBox, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
    end)
    
    Input.MouseEnter:Connect(function()
        Tween:Create(Input, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Input.MouseLeave:Connect(function()
        Tween:Create(Input, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
        Tween:Create(InputBox, {BackgroundColor3 = Theme:Get("InputBackground")}, 0.2)
    end)
    
    return {
        Instance = Input,
        Set = function(NewValue)
            Value = NewValue
            InputBox.Text = tostring(Value)
            SaveManager:Set(self.FolderName, Flag, Value)
        end,
        Get = function() return Value end
    }
end

function WindowClass:CreateKeybind(Section, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Keybind") .. "_Flag"
    local CurrentKeybind = SaveManager:Get(self.FolderName, Flag, Settings.CurrentKeybind or "None")
    local HoldToInteract = Settings.HoldToInteract or false
    
    local Keybind = Instance.new("Frame")
    Keybind.Name = Settings.Name or "Keybind"
    Keybind.Size = UDim2.new(1, 0, 0, 40)
    Keybind.BackgroundColor3 = Theme:Get("ElementBackground")
    Keybind.BorderSizePixel = 0
    Keybind.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Keybind
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Keybind
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Keybind"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Keybind
    
    -- Key display
    local KeyBox = Instance.new("TextButton")
    KeyBox.Name = "KeyBox"
    KeyBox.Size = UDim2.new(0, 0, 0, 28)
    KeyBox.AutomaticSize = Enum.AutomaticSize.X
    KeyBox.Position = UDim2.new(1, -14, 0.5, -14)
    KeyBox.AnchorPoint = Vector2.new(1, 0)
    KeyBox.BackgroundColor3 = Theme:Get("InputBackground")
    KeyBox.Text = CurrentKeybind
    KeyBox.TextColor3 = Theme:Get("TextColor")
    KeyBox.TextSize = 12
    KeyBox.Font = Enum.Font.GothamBold
    KeyBox.Parent = Keybind
    
    local KeyPadding = Instance.new("UIPadding")
    KeyPadding.PaddingLeft = UDim.new(0, 12)
    KeyPadding.PaddingRight = UDim.new(0, 12)
    KeyPadding.Parent = KeyBox
    
    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 6)
    KeyCorner.Parent = KeyBox
    
    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Color = Theme:Get("InputStroke")
    KeyStroke.Thickness = 1
    KeyStroke.Parent = KeyBox
    
    local Listening = false
    
    KeyBox.MouseButton1Click:Connect(function()
        Listening = true
        KeyBox.Text = "..."
        Tween:Create(KeyBox, {BackgroundColor3 = Theme:Get("Accent")}, 0.2)
    end)
    
    UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if Listening then
            if Input.KeyCode ~= Enum.KeyCode.Unknown then
                local KeyName = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
                CurrentKeybind = KeyName
                KeyBox.Text = KeyName
                SaveManager:Set(self.FolderName, Flag, CurrentKeybind)
                Listening = false
                Tween:Create(KeyBox, {BackgroundColor3 = Theme:Get("InputBackground")}, 0.2)
            end
        elseif CurrentKeybind ~= "None" and Input.KeyCode == Enum.KeyCode[CurrentKeybind] and not GameProcessed then
            if Settings.Callback then
                if HoldToInteract then
                    local Held = true
                    local Connection
                    Connection = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Held = false
                            Connection:Disconnect()
                            pcall(Settings.Callback, false)
                        end
                    end)
                    pcall(Settings.Callback, true)
                else
                    pcall(Settings.Callback)
                end
            end
        end
    end)
    
    Keybind.MouseEnter:Connect(function()
        Tween:Create(Keybind, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    Keybind.MouseLeave:Connect(function()
        Tween:Create(Keybind, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = Keybind,
        Set = function(NewKey)
            CurrentKeybind = NewKey
            KeyBox.Text = NewKey
            SaveManager:Set(self.FolderName, Flag, CurrentKeybind)
        end,
        Get = function() return CurrentKeybind end
    }
end

function WindowClass:CreateColorPicker(Section, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "ColorPicker") .. "_Flag"
    local Color = SaveManager:Get(self.FolderName, Flag, Settings.Color or {R = 255, G = 255, B = 255})
    
    if typeof(Color) == "table" then
        Color = Color3.fromRGB(Color.R, Color.G, Color.B)
    end
    
    local H, S, V = Color:ToHSV()
    
    local ColorPicker = Instance.new("Frame")
    ColorPicker.Name = Settings.Name or "ColorPicker"
    ColorPicker.Size = UDim2.new(1, 0, 0, 42)
    ColorPicker.BackgroundColor3 = Theme:Get("ElementBackground")
    ColorPicker.BorderSizePixel = 0
    ColorPicker.ClipsDescendants = true
    ColorPicker.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = ColorPicker
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = ColorPicker
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 0, 20)
    Title.Position = UDim2.new(0, 14, 0, 11)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Color Picker"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = ColorPicker
    
    -- Color display
    local Display = Instance.new("TextButton")
    Display.Name = "Display"
    Display.Size = UDim2.new(0, 50, 0, 24)
    Display.Position = UDim2.new(1, -64, 0, 9)
    Display.BackgroundColor3 = Color
    Display.Text = ""
    Display.AutoButtonColor = false
    Display.Parent = ColorPicker
    
    local DisplayCorner = Instance.new("UICorner")
    DisplayCorner.CornerRadius = UDim.new(0, 6)
    DisplayCorner.Parent = Display
    
    local DisplayStroke = Instance.new("UIStroke")
    DisplayStroke.Color = Theme:Get("ElementStroke")
    DisplayStroke.Thickness = 1
    DisplayStroke.Parent = Display
    
    -- Picker panel (initially hidden)
    local PickerPanel = Instance.new("Frame")
    PickerPanel.Name = "PickerPanel"
    PickerPanel.Size = UDim2.new(1, -28, 0, 140)
    PickerPanel.Position = UDim2.new(0, 14, 0, 45)
    PickerPanel.BackgroundColor3 = Theme:Get("SecondaryElementBackground")
    PickerPanel.BorderSizePixel = 0
    PickerPanel.Visible = false
    PickerPanel.Parent = ColorPicker
    
    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 10)
    PanelCorner.Parent = PickerPanel
    
    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Color = Theme:Get("SecondaryElementStroke")
    PanelStroke.Thickness = 1
    PanelStroke.Parent = PickerPanel
    
    -- SV Map (Saturation/Value)
    local SVMap = Instance.new("ImageButton")
    SVMap.Name = "SVMap"
    SVMap.Size = UDim2.new(0, 130, 0, 100)
    SVMap.Position = UDim2.new(0, 10, 0, 10)
    SVMap.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
    SVMap.BorderSizePixel = 0
    SVMap.Image = "rbxassetid://11415645739" -- HSV gradient
    SVMap.AutoButtonColor = false
    SVMap.Parent = PickerPanel
    
    local SVCorner = Instance.new("UICorner")
    SVCorner.CornerRadius = UDim.new(0, 8)
    SVCorner.Parent = SVMap
    
    -- SV Cursor
    local SVCursor = Instance.new("Frame")
    SVCursor.Name = "Cursor"
    SVCursor.Size = UDim2.new(0, 12, 0, 12)
    SVCursor.Position = UDim2.new(S, -6, 1 - V, -6)
    SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    SVCursor.BorderSizePixel = 2
    SVCursor.BorderColor3 = Color3.new(0, 0, 0)
    SVCursor.Parent = SVMap
    
    local SVCCorner = Instance.new("UICorner")
    SVCCorner.CornerRadius = UDim.new(1, 0)
    SVCCorner.Parent = SVCursor
    
    -- Hue Slider
    local HueSlider = Instance.new("ImageButton")
    HueSlider.Name = "HueSlider"
    HueSlider.Size = UDim2.new(0, 20, 0, 100)
    HueSlider.Position = UDim2.new(0, 150, 0, 10)
    HueSlider.BackgroundColor3 = Color3.new(1, 1, 1)
    HueSlider.BorderSizePixel = 0
    HueSlider.Image = "rbxassetid://11415645890" -- Hue gradient
    HueSlider.AutoButtonColor = false
    HueSlider.Parent = PickerPanel
    
    local HueCorner = Instance.new("UICorner")
    HueCorner.CornerRadius = UDim.new(0, 8)
    HueCorner.Parent = HueSlider
    
    -- Hue Cursor
    local HueCursor = Instance.new("Frame")
    HueCursor.Name = "Cursor"
    HueCursor.Size = UDim2.new(1, 4, 0, 6)
    HueCursor.Position = UDim2.new(-0.1, 0, 1 - H, -3)
    HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    HueCursor.BorderSizePixel = 2
    HueCursor.BorderColor3 = Color3.new(0, 0, 0)
    HueCursor.Parent = HueSlider
    
    -- RGB Inputs
    local RGBFrame = Instance.new("Frame")
    RGBFrame.Name = "RGB"
    RGBFrame.Size = UDim2.new(0, 110, 0, 30)
    RGBFrame.Position = UDim2.new(0, 10, 0, 118)
    RGBFrame.BackgroundTransparency = 1
    RGBFrame.Parent = PickerPanel
    
    local RGBLayout = Instance.new("UIListLayout")
    RGBLayout.FillDirection = Enum.FillDirection.Horizontal
    RGBLayout.Padding = UDim.new(0, 6)
    RGBLayout.Parent = RGBFrame
    
    local function CreateRGBInput(Name, Value)
        local Box = Instance.new("TextBox")
        Box.Name = Name
        Box.Size = UDim2.new(0, 32, 0, 26)
        Box.BackgroundColor3 = Theme:Get("InputBackground")
        Box.Text = tostring(Value)
        Box.TextColor3 = Theme:Get("TextColor")
        Box.TextSize = 12
        Box.Font = Enum.Font.GothamBold
        Box.Parent = RGBFrame
        
        local BoxCorner = Instance.new("UICorner")
        BoxCorner.CornerRadius = UDim.new(0, 6)
        BoxCorner.Parent = Box
        
        return Box
    end
    
    local RInput = CreateRGBInput("R", math.floor(Color.R * 255))
    local GInput = CreateRGBInput("G", math.floor(Color.G * 255))
    local BInput = CreateRGBInput("B", math.floor(Color.B * 255))
    
    -- Hex input
    local HexBox = Instance.new("TextBox")
    HexBox.Name = "Hex"
    HexBox.Size = UDim2.new(0, 80, 0, 26)
    HexBox.Position = UDim2.new(0, 76, 0, 118)
    HexBox.BackgroundColor3 = Theme:Get("InputBackground")
    HexBox.Text = string.format("#%02X%02X%02X", Color.R * 255, Color.G * 255, Color.B * 255)
    HexBox.TextColor3 = Theme:Get("TextColor")
    HexBox.TextSize = 12
    HexBox.Font = Enum.Font.GothamBold
    HexBox.Parent = PickerPanel
    
    local HexCorner = Instance.new("UICorner")
    HexCorner.CornerRadius = UDim.new(0, 6)
    HexCorner.Parent = HexBox
    
    local Open = false
    local DraggingSV = false
    local DraggingHue = false
    
    local function UpdateColor()
        Color = Color3.fromHSV(H, S, V)
        Display.BackgroundColor3 = Color
        
        -- Save
        SaveManager:Set(self.FolderName, Flag, {R = math.floor(Color.R * 255), G = math.floor(Color.G * 255), B = math.floor(Color.B * 255)})
        
        -- Update UI
        SVCursor.Position = UDim2.new(S, -6, 1 - V, -6)
        HueCursor.Position = UDim2.new(-0.1, 0, 1 - H, -3)
        SVMap.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        
        RInput.Text = tostring(math.floor(Color.R * 255))
        GInput.Text = tostring(math.floor(Color.G * 255))
        BInput.Text = tostring(math.floor(Color.B * 255))
        HexBox.Text = string.format("#%02X%02X%02X", Color.R * 255, Color.G * 255, Color.B * 255)
        
        if Settings.Callback then
            pcall(Settings.Callback, Color)
        end
    end
    
    -- Input handling
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
            local Pos = Input.Position
            local RelativeX = math.clamp((Pos.X - SVMap.AbsolutePosition.X) / SVMap.AbsoluteSize.X, 0, 1)
            local RelativeY = math.clamp((Pos.Y - SVMap.AbsolutePosition.Y) / SVMap.AbsoluteSize.Y, 0, 1)
            S = RelativeX
            V = 1 - RelativeY
            UpdateColor()
        elseif DraggingHue and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Pos = Input.Position
            H = 1 - math.clamp((Pos.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
            UpdateColor()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            DraggingSV = false
            DraggingHue = false
        end
    end)
    
    -- RGB inputs
    local function HandleRGBInput(Box, Component)
        Box.FocusLost:Connect(function()
            local Num = tonumber(Box.Text)
            if Num then
                Num = math.clamp(math.floor(Num), 0, 255)
                local NewColor = Color3.fromRGB(
                    Component == "R" and Num or math.floor(Color.R * 255),
                    Component == "G" and Num or math.floor(Color.G * 255),
                    Component == "B" and Num or math.floor(Color.B * 255)
                )
                H, S, V = NewColor:ToHSV()
                UpdateColor()
            else
                Box.Text = tostring(math.floor(Color[Component] * 255))
            end
        end)
    end
    
    HandleRGBInput(RInput, "R")
    HandleRGBInput(GInput, "G")
    HandleRGBInput(BInput, "B")
    
    HexBox.FocusLost:Connect(function()
        local Hex = HexBox.Text:gsub("#", "")
        if #Hex == 6 then
            local R = tonumber(Hex:sub(1, 2), 16)
            local G = tonumber(Hex:sub(3, 4), 16)
            local B = tonumber(Hex:sub(5, 6), 16)
            if R and G and B then
                local NewColor = Color3.fromRGB(R, G, B)
                H, S, V = NewColor:ToHSV()
                UpdateColor()
                return
            end
        end
        HexBox.Text = string.format("#%02X%02X%02X", Color.R * 255, Color.G * 255, Color.B * 255)
    end)
    
    -- Toggle picker
    Display.MouseButton1Click:Connect(function()
        Open = not Open
        
        if Open then
            PickerPanel.Visible = true
            Tween:Create(ColorPicker, {Size = UDim2.new(1, 0, 0, 195)}, 0.4, Enum.EasingStyle.Quint)
        else
            Tween:Create(ColorPicker, {Size = UDim2.new(1, 0, 0, 42)}, 0.4, Enum.EasingStyle.Quint)
            task.delay(0.4, function()
                PickerPanel.Visible = false
            end)
        end
    end)
    
    ColorPicker.MouseEnter:Connect(function()
        Tween:Create(ColorPicker, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.3)
    end)
    
    ColorPicker.MouseLeave:Connect(function()
        Tween:Create(ColorPicker, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.3)
    end)
    
    return {
        Instance = ColorPicker,
        Set = function(NewColor)
            Color = NewColor
            H, S, V = Color:ToHSV()
            UpdateColor()
        end,
        Get = function() return Color end
    }
end

function WindowClass:CreateParagraph(Section, Settings)
    Settings = Settings or {}
    
    local Paragraph = Instance.new("Frame")
    Paragraph.Name = "Paragraph"
    Paragraph.Size = UDim2.new(1, 0, 0, 60)
    Paragraph.BackgroundColor3 = Theme:Get("SecondaryElementBackground")
    Paragraph.BorderSizePixel = 0
    Paragraph.AutomaticSize = Enum.AutomaticSize.Y
    Paragraph.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Paragraph
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("SecondaryElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Paragraph
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 12, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Title or "Paragraph"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Paragraph
    
    local Content = Instance.new("TextLabel")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 0, 0)
    Content.Position = UDim2.new(0, 12, 0, 32)
    Content.BackgroundTransparency = 1
    Content.Text = Settings.Content or ""
    Content.TextColor3 = Theme:Get("TextColor")
    Content.TextTransparency = 0.4
    Content.TextSize = 13
    Content.Font = Enum.Font.Gotham
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextWrapped = true
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.Parent = Paragraph
    
    -- Adjust paragraph size
    Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        Paragraph.Size = UDim2.new(1, 0, 0, Content.AbsoluteSize.Y + 45)
    end)
    
    return {
        Instance = Paragraph,
        Set = function(NewSettings)
            Title.Text = NewSettings.Title or Title.Text
            Content.Text = NewSettings.Content or Content.Text
        end
    }
end

function WindowClass:CreateLabel(Section, Text)
    local Label = Instance.new("Frame")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundColor3 = Theme:Get("SecondaryElementBackground")
    Label.BorderSizePixel = 0
    Label.Parent = Section.Elements
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Label
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("SecondaryElementStroke")
    Stroke.Thickness = 1
    Stroke.Parent = Label
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Text or "Label"
    Title.TextColor3 = Theme:Get("TextColor")
    Title.TextSize = 14
    Title.Font = Enum.Font.Gotham
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Label
    
    return {
        Instance = Label,
        Set = function(NewText)
            Title.Text = NewText
        end
    }
end

function WindowClass:Destroy()
    Tween:Create(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Back).Completed:Connect(function()
        self.GUI:Destroy()
    end)
end

-- ==========================================
-- LIBRARY FUNCTIONS
-- ==========================================

function NexusUI:CreateWindow(Settings)
    local Window = WindowClass:Create(Settings)
    table.insert(self.Windows, Window)
    return Window
end

function NexusUI:Notify(Settings)
    return NotificationSystem:Notify(Settings)
end

function NexusUI:SetTheme(ThemeName)
    return Theme:SetTheme(ThemeName)
end

function NexusUI:Destroy()
    for _, Window in ipairs(self.Windows) do
        if Window.GUI then
            Window.GUI:Destroy()
        end
    end
    self.Windows = {}
end

-- Toggle UI with RightShift
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.RightShift then
        for _, Window in ipairs(NexusUI.Windows) do
            Window.GUI.Enabled = not Window.GUI.Enabled
        end
    end
end)

return NexusUI
