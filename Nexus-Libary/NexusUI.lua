--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝███████╗
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚══════╝
    
    Nexus UI Library v4.0 - Enhanced Edition
    Massively improved with smoother animations, better visuals, and bug fixes
]]

local NexusUI = {
    Version = "4.0.0",
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
-- ENHANCED THEME SYSTEM
-- ==========================================

local Theme = {
    Current = "Dark",
    Palettes = {
        Dark = {
            -- Main backgrounds (darker, more refined)
            Background = Color3.fromRGB(20, 20, 24),
            Topbar = Color3.fromRGB(26, 26, 30),
            Sidebar = Color3.fromRGB(23, 23, 27),
            
            -- Elements (better contrast)
            ElementBackground = Color3.fromRGB(32, 32, 37),
            ElementBackgroundHover = Color3.fromRGB(40, 40, 46),
            ElementStroke = Color3.fromRGB(45, 45, 52),
            
            -- Primary (vibrant red like Aureus)
            Primary = Color3.fromRGB(235, 69, 95),
            PrimaryHover = Color3.fromRGB(245, 85, 110),
            PrimaryDark = Color3.fromRGB(200, 50, 75),
            
            -- Text (improved readability)
            TextPrimary = Color3.fromRGB(245, 245, 250),
            TextSecondary = Color3.fromRGB(170, 170, 180),
            TextMuted = Color3.fromRGB(110, 110, 120),
            TextDisabled = Color3.fromRGB(70, 70, 80),
            
            -- States
            Success = Color3.fromRGB(75, 230, 120),
            Warning = Color3.fromRGB(255, 190, 75),
            Error = Color3.fromRGB(245, 75, 75),
            Info = Color3.fromRGB(85, 170, 255),
            
            -- Tab system
            TabActive = Color3.fromRGB(235, 69, 95),
            TabInactive = Color3.fromRGB(90, 90, 100),
            TabHover = Color3.fromRGB(130, 130, 140),
            
            -- Toggle
            ToggleEnabled = Color3.fromRGB(75, 230, 120),
            ToggleDisabled = Color3.fromRGB(50, 50, 60),
            
            -- Effects
            Shadow = Color3.fromRGB(0, 0, 0),
            Glow = Color3.fromRGB(235, 69, 95),
            Overlay = Color3.fromRGB(15, 15, 18)
        },
        
        Light = {
            Background = Color3.fromRGB(248, 248, 252),
            Topbar = Color3.fromRGB(238, 238, 245),
            Sidebar = Color3.fromRGB(243, 243, 248),
            
            ElementBackground = Color3.fromRGB(255, 255, 255),
            ElementBackgroundHover = Color3.fromRGB(245, 245, 250),
            ElementStroke = Color3.fromRGB(220, 220, 230),
            
            Primary = Color3.fromRGB(235, 69, 95),
            PrimaryHover = Color3.fromRGB(245, 85, 110),
            PrimaryDark = Color3.fromRGB(200, 50, 75),
            
            TextPrimary = Color3.fromRGB(25, 25, 30),
            TextSecondary = Color3.fromRGB(90, 90, 100),
            TextMuted = Color3.fromRGB(140, 140, 150),
            TextDisabled = Color3.fromRGB(180, 180, 190),
            
            Success = Color3.fromRGB(50, 180, 90),
            Warning = Color3.fromRGB(235, 165, 50),
            Error = Color3.fromRGB(230, 60, 60),
            Info = Color3.fromRGB(70, 145, 230),
            
            TabActive = Color3.fromRGB(235, 69, 95),
            TabInactive = Color3.fromRGB(140, 140, 150),
            TabHover = Color3.fromRGB(100, 100, 110),
            
            ToggleEnabled = Color3.fromRGB(50, 180, 90),
            ToggleDisabled = Color3.fromRGB(200, 200, 210),
            
            Shadow = Color3.fromRGB(190, 190, 200),
            Glow = Color3.fromRGB(235, 69, 95),
            Overlay = Color3.fromRGB(230, 230, 240)
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
-- ADVANCED ANIMATION SYSTEM (ENHANCED)
-- ==========================================

local Animation = {}
Animation.ActiveTweens = {}

function Animation:Tween(Object, Properties, Duration, Style, Direction, Callback)
    -- Cancel existing tween on same object
    if self.ActiveTweens[Object] then
        self.ActiveTweens[Object]:Cancel()
    end
    
    local Info = TweenInfo.new(
        Duration or 0.3,
        Style or Enum.EasingStyle.Quint,
        Direction or Enum.EasingDirection.Out,
        0, false, 0
    )
    
    local Tween = TweenService:Create(Object, Info, Properties)
    self.ActiveTweens[Object] = Tween
    
    Tween.Completed:Connect(function()
        self.ActiveTweens[Object] = nil
        if Callback then
            Callback()
        end
    end)
    
    Tween:Play()
    return Tween
end

function Animation:Spring(Object, Property, Target, Speed, Damping)
    Speed = Speed or 25
    Damping = Damping or 0.8
    
    local Connection
    local Velocity = 0
    local Current = Object[Property]
    
    if typeof(Current) == "UDim2" then
        Current = Vector2.new(Current.X.Offset, Current.Y.Offset)
        Target = Vector2.new(Target.X.Offset, Target.Y.Offset)
        Velocity = Vector2.new(0, 0)
    end
    
    Connection = RunService.Heartbeat:Connect(function(Delta)
        if typeof(Current) == "Vector2" then
            local Displacement = Target - Current
            local Force = Displacement * Speed
            Velocity = Velocity * Damping + Force * Delta
            Current = Current + Velocity
            
            Object[Property] = UDim2.new(0, Current.X, 0, Current.Y)
            
            if Displacement.Magnitude < 0.5 and Velocity.Magnitude < 0.5 then
                Object[Property] = UDim2.new(0, Target.X, 0, Target.Y)
                Connection:Disconnect()
            end
        else
            local Displacement = Target - Current
            local Force = Displacement * Speed
            Velocity = Velocity * Damping + Force * Delta
            Current = Current + Velocity
            
            Object[Property] = Current
            
            if math.abs(Displacement) < 0.01 and math.abs(Velocity) < 0.01 then
                Object[Property] = Target
                Connection:Disconnect()
            end
        end
    end)
    
    return Connection
end

function Animation:FadeIn(Object, Duration)
    Object.Visible = true
    local OriginalTransparency = {}
    
    -- Store original transparencies
    for _, Descendant in ipairs(Object:GetDescendants()) do
        if Descendant:IsA("GuiObject") or Descendant:IsA("TextLabel") or Descendant:IsA("ImageLabel") then
            OriginalTransparency[Descendant] = {
                Background = Descendant.BackgroundTransparency,
                Text = Descendant:IsA("TextLabel") and Descendant.TextTransparency or nil
            }
            Descendant.BackgroundTransparency = 1
            if Descendant:IsA("TextLabel") or Descendant:IsA("TextButton") then
                Descendant.TextTransparency = 1
            end
        end
    end
    
    -- Fade in
    for Descendant, Transparency in pairs(OriginalTransparency) do
        self:Tween(Descendant, {BackgroundTransparency = Transparency.Background}, Duration or 0.4)
        if Transparency.Text then
            self:Tween(Descendant, {TextTransparency = Transparency.Text}, Duration or 0.4)
        end
    end
end

function Animation:Pop(Object, Intensity)
    Intensity = Intensity or 1.08
    local OriginalSize = Object.Size
    
    self:Tween(Object, {Size = UDim2.new(
        OriginalSize.X.Scale * Intensity, OriginalSize.X.Offset * Intensity,
        OriginalSize.Y.Scale * Intensity, OriginalSize.Y.Offset * Intensity
    )}, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out, function()
        self:Tween(Object, {Size = OriginalSize}, 0.25, Enum.EasingStyle.Quint)
    end)
end

function Animation:Ripple(Parent, Position)
    local Ripple = Instance.new("Frame")
    Ripple.Size = UDim2.new(0, 0, 0, 0)
    Ripple.Position = UDim2.new(0, Position.X, 0, Position.Y)
    Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    Ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    Ripple.BackgroundTransparency = 0.7
    Ripple.BorderSizePixel = 0
    Ripple.ZIndex = 100
    Ripple.Parent = Parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Ripple
    
    local Size = math.max(Parent.AbsoluteSize.X, Parent.AbsoluteSize.Y) * 2
    
    self:Tween(Ripple, {
        Size = UDim2.new(0, Size, 0, Size),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, function()
        Ripple:Destroy()
    end)
end

-- ==========================================
-- ENHANCED ICON SYSTEM
-- ==========================================

local Icons = {
    -- Navigation
    ["home"] = "rbxassetid://10723434711",
    ["user"] = "rbxassetid://10723407389",
    ["users"] = "rbxassetid://10723407389",
    ["settings"] = "rbxassetid://10734950309",
    ["menu"] = "rbxassetid://10747372992",
    
    -- Actions
    ["search"] = "rbxassetid://10734898355",
    ["plus"] = "rbxassetid://10734896206",
    ["minus"] = "rbxassetid://10734883356",
    ["check"] = "rbxassetid://10709813281",
    ["x"] = "rbxassetid://10747384394",
    ["refresh"] = "rbxassetid://10723407389",
    
    -- Code/Dev
    ["code"] = "rbxassetid://10723434711",
    ["terminal"] = "rbxassetid://10723434711",
    ["script"] = "rbxassetid://10723434711",
    
    -- Media
    ["play"] = "rbxassetid://10709814166",
    ["pause"] = "rbxassetid://10709818534",
    ["stop"] = "rbxassetid://10709818534",
    
    -- File system
    ["folder"] = "rbxassetid://10723434711",
    ["file"] = "rbxassetid://10723434711",
    ["save"] = "rbxassetid://10734931871",
    ["copy"] = "rbxassetid://10709818534",
    
    -- UI
    ["grid"] = "rbxassetid://10734896206",
    ["list"] = "rbxassetid://10747372992",
    ["sliders"] = "rbxassetid://10734950309",
    ["toggle"] = "rbxassetid://10734950309",
    
    -- Time
    ["clock"] = "rbxassetid://10723407389",
    ["calendar"] = "rbxassetid://10723434711",
    
    -- Communication
    ["bell"] = "rbxassetid://10734898355",
    ["mail"] = "rbxassetid://10723407389",
    ["message"] = "rbxassetid://10723407389",
    
    -- Status
    ["warning"] = "rbxassetid://10734896206",
    ["alert"] = "rbxassetid://10734896206",
    ["info"] = "rbxassetid://10709813281",
    ["help"] = "rbxassetid://10723407389",
    
    -- Misc
    ["star"] = "rbxassetid://10734931871",
    ["heart"] = "rbxassetid://10709813281",
    ["lock"] = "rbxassetid://10734950309",
    ["unlock"] = "rbxassetid://10734950309",
    ["target"] = "rbxassetid://10734896206",
    
    -- Default fallback
    ["default"] = "rbxassetid://10723434711"
}

-- Text-based icons as fallback
local TextIcons = {
    ["home"] = "🏠",
    ["user"] = "👤",
    ["users"] = "👥",
    ["settings"] = "⚙",
    ["search"] = "🔍",
    ["code"] = "</>",
    ["terminal"] = ">_",
    ["script"] = "📜",
    ["play"] = "▶",
    ["pause"] = "⏸",
    ["stop"] = "⏹",
    ["refresh"] = "↻",
    ["save"] = "💾",
    ["folder"] = "📁",
    ["file"] = "📄",
    ["plus"] = "+",
    ["minus"] = "−",
    ["check"] = "✓",
    ["x"] = "✕",
    ["menu"] = "☰",
    ["grid"] = "⊞",
    ["list"] = "☰",
    ["sliders"] = "⚒",
    ["toggle"] = "◐",
    ["bell"] = "🔔",
    ["star"] = "★",
    ["heart"] = "♥",
    ["lock"] = "🔒",
    ["unlock"] = "🔓",
    ["warning"] = "⚠",
    ["alert"] = "🚨",
    ["info"] = "ℹ",
    ["help"] = "?",
    ["clock"] = "🕐",
    ["calendar"] = "📅",
    ["mail"] = "✉",
    ["message"] = "💬",
    ["default"] = "•"
}

function Icons:Get(Name)
    return self[Name] or self["default"]
end

function Icons:GetText(Name)
    return TextIcons[Name] or TextIcons["default"]
end

-- ==========================================
-- ENHANCED SAVE SYSTEM
-- ==========================================

local SaveManager = {
    Data = {},
    Folder = "NexusUI",
    Enabled = true,
    AutoSave = true
}

function SaveManager:Init()
    self.Supported = pcall(function()
        if isfolder and makefolder and writefile and readfile and isfile then
            if not isfolder(self.Folder) then
                makefolder(self.Folder)
            end
            return true
        end
        return false
    end)
    
    if not self.Supported then
        warn("[NexusUI] File system functions not available - save/load disabled")
    end
end

function SaveManager:Set(Path, Value)
    if not self.Supported or not self.Enabled then return false end
    
    local Success = pcall(function()
        local Folder = Path:match("(.+)/")
        if Folder and not isfolder(self.Folder .. "/" .. Folder) then
            makefolder(self.Folder .. "/" .. Folder)
        end
        
        writefile(self.Folder .. "/" .. Path .. ".json", HttpService:JSONEncode(Value))
    end)
    
    return Success
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
    
    return (Success and Data) or Default
end

function SaveManager:Delete(Path)
    if not self.Supported then return false end
    
    local Success = pcall(function()
        local File = self.Folder .. "/" .. Path .. ".json"
        if isfile(File) then
            delfile(File)
        end
    end)
    
    return Success
end

SaveManager:Init()

-- ==========================================
-- ENHANCED NOTIFICATION SYSTEM
-- ==========================================

local NotificationSystem = {
    GUI = nil,
    Container = nil,
    Queue = {},
    MaxVisible = 5
}

function NotificationSystem:Init()
    if self.GUI then return end
    
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusNotifications"
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.DisplayOrder = 100
    self.GUI.Parent = CoreGui
    
    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(0, 350, 1, -40)
    self.Container.Position = UDim2.new(1, -370, 0, 20)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.GUI
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 10)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = self.Container
end

function NotificationSystem:Notify(Settings)
    self:Init()
    Settings = Settings or {}
    
    local Title = Settings.Title or "Notification"
    local Content = Settings.Content or ""
    local Duration = Settings.Duration or 4
    local Type = Settings.Type or "Info"
    
    local Colors = {
        Info = Theme:Get("Info"),
        Success = Theme:Get("Success"),
        Warning = Theme:Get("Warning"),
        Error = Theme:Get("Error")
    }
    
    local Color = Colors[Type] or Theme:Get("Primary")
    
    -- Create notification
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 330, 0, 0)
    Notif.BackgroundColor3 = Theme:Get("ElementBackground")
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.LayoutOrder = tick()
    Notif.Parent = self.Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 14)
    Corner.Parent = Notif
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.5
    Stroke.Parent = Notif
    
    -- Glow effect
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.Size = UDim2.new(1, 50, 1, 50)
    Glow.ZIndex = 0
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://6014261993"
    Glow.ImageColor3 = Color
    Glow.ImageTransparency = 0.85
    Glow.ScaleType = Enum.ScaleType.Slice
    Glow.SliceCenter = Rect.new(49, 49, 450, 450)
    Glow.Parent = Notif
    
    -- Accent bar
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 4, 1, 0)
    Accent.BackgroundColor3 = Color
    Accent.BorderSizePixel = 0
    Accent.ZIndex = 2
    Accent.Parent = Notif
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 14)
    AccentCorner.Parent = Accent
    
    -- Icon background
    local IconBG = Instance.new("Frame")
    IconBG.Size = UDim2.new(0, 36, 0, 36)
    IconBG.Position = UDim2.new(0, 18, 0, 16)
    IconBG.BackgroundColor3 = Color
    IconBG.BackgroundTransparency = 0.9
    IconBG.BorderSizePixel = 0
    IconBG.ZIndex = 2
    IconBG.Parent = Notif
    
    local IconBGCorner = Instance.new("UICorner")
    IconBGCorner.CornerRadius = UDim.new(0, 10)
    IconBGCorner.Parent = IconBG
    
    -- Icon
    local IconMap = {
        Info = "info",
        Success = "check",
        Warning = "warning",
        Error = "x"
    }
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(1, 0, 1, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = Icons:GetText(IconMap[Type] or "info")
    Icon.TextColor3 = Color
    Icon.TextSize = 18
    Icon.Font = Enum.Font.GothamBold
    Icon.ZIndex = 3
    Icon.Parent = IconBG
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -90, 0, 24)
    TitleLabel.Position = UDim2.new(0, 64, 0, 14)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme:Get("TextPrimary")
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TitleLabel.ZIndex = 2
    TitleLabel.Parent = Notif
    
    -- Content
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -74, 0, 0)
    ContentLabel.Position = UDim2.new(0, 64, 0, 40)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = Content
    ContentLabel.TextColor3 = Theme:Get("TextSecondary")
    ContentLabel.TextSize = 13
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.TextWrapped = true
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.ZIndex = 2
    ContentLabel.Parent = Notif
    
    -- Calculate height
    task.wait()
    local Height = math.max(75, ContentLabel.AbsoluteSize.Y + 54)
    
    -- Progress bar
    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new(1, -8, 0, 3)
    Progress.Position = UDim2.new(0, 4, 1, -7)
    Progress.BackgroundColor3 = Color
    Progress.BorderSizePixel = 0
    Progress.ZIndex = 2
    Progress.Parent = Notif
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = Progress
    
    -- Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -34, 0, 14)
    CloseBtn.BackgroundColor3 = Theme:Get("ElementBackground")
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Theme:Get("TextMuted")
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.ZIndex = 3
    CloseBtn.Parent = Notif
    
    local CloseBtnCorner = Instance.new("UICorner")
    CloseBtnCorner.CornerRadius = UDim.new(0, 8)
    CloseBtnCorner.Parent = CloseBtn
    
    -- Animations
    Notif.Position = UDim2.new(1, 50, 0, 0)
    Notif.Size = UDim2.new(0, 330, 0, Height)
    
    Animation:Tween(Notif, {
        Position = UDim2.new(0, 0, 0, 0)
    }, 0.5, Enum.EasingStyle.Quint)
    
    Animation:Tween(Progress, {
        Size = UDim2.new(0, 0, 0, 3)
    }, Duration, Enum.EasingStyle.Linear)
    
    -- Close function
    local function CloseNotif()
        Animation:Tween(Notif, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, 0.4, Enum.EasingStyle.Quint)
        
        Animation:Tween(Stroke, {Transparency = 1}, 0.4)
        Animation:Tween(TitleLabel, {TextTransparency = 1}, 0.4)
        Animation:Tween(ContentLabel, {TextTransparency = 1}, 0.4)
        Animation:Tween(Icon, {TextTransparency = 1}, 0.4)
        Animation:Tween(Accent, {BackgroundTransparency = 1}, 0.4)
        Animation:Tween(Progress, {BackgroundTransparency = 1}, 0.4)
        Animation:Tween(CloseBtn, {TextTransparency = 1, BackgroundTransparency = 1}, 0.4)
        
        task.delay(0.5, function()
            Notif:Destroy()
        end)
    end
    
    -- Auto close
    task.delay(Duration, CloseNotif)
    
    -- Manual close
    CloseBtn.MouseButton1Click:Connect(CloseNotif)
    
    CloseBtn.MouseEnter:Connect(function()
        Animation:Tween(CloseBtn, {
            BackgroundColor3 = Theme:Get("Error"),
            BackgroundTransparency = 0,
            TextColor3 = Color3.new(1, 1, 1)
        }, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Animation:Tween(CloseBtn, {
            BackgroundColor3 = Theme:Get("ElementBackground"),
            BackgroundTransparency = 0.5,
            TextColor3 = Theme:Get("TextMuted")
        }, 0.2)
    end)
    
    return Notif
end

-- ==========================================
-- ENHANCED WINDOW CLASS
-- ==========================================

local WindowClass = {}
WindowClass.__index = WindowClass

function WindowClass:Create(Settings)
    local self = setmetatable({}, WindowClass)
    Settings = Settings or {}
    
    self.Name = Settings.Name or "Nexus UI"
    self.Subtitle = Settings.Subtitle or "v4.0.0"
    self.LoadingEnabled = Settings.LoadingEnabled ~= false
    self.ConfigFolder = Settings.ConfigFolder or self.Name
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Closed = false
    self.TabCount = 0
    self.SaveManager = SaveManager
    
    -- Main GUI
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusUI_" .. self.Name
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.DisplayOrder = 10
    
    -- Protection
    local Success = pcall(function()
        syn.protect_gui(self.GUI)
    end)
    
    if not Success then
        pcall(function()
            self.GUI.Parent = (gethui and gethui()) or CoreGui
        end)
    end
    
    if not self.GUI.Parent then
        self.GUI.Parent = CoreGui
    end
    
    -- Loading screen (if enabled)
    if self.LoadingEnabled then
        self:CreateLoadingScreen()
    end
    
    -- Main window
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = Settings.Size or UDim2.new(0, 700, 0, 480)
    self.Main.Position = Settings.Position or UDim2.new(0.5, -350, 0.5, -240)
    self.Main.BackgroundColor3 = Theme:Get("Background")
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = false
    self.Main.AnchorPoint = Vector2.new(0, 0)
    self.Main.Parent = self.GUI
    
    if self.LoadingEnabled then
        self.Main.Visible = false
    end
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 18)
    MainCorner.Parent = self.Main
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 70, 1, 70)
    Shadow.ZIndex = -1
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Theme:Get("Shadow")
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = self.Main
    
    -- Topbar
    self:CreateTopbar()
    
    -- Sidebar
    self:CreateSidebar()
    
    -- Content area
    self:CreateContent()
    
    -- Setup dragging
    self:SetupDrag()
    
    -- Setup controls
    self:SetupControls()
    
    -- Show window after loading
    if self.LoadingEnabled then
        task.delay(2, function()
            self:ShowWindow()
        end)
    end
    
    return self
end

function WindowClass:CreateLoadingScreen()
    local Loading = Instance.new("Frame")
    Loading.Name = "Loading"
    Loading.Size = UDim2.new(1, 0, 1, 0)
    Loading.BackgroundColor3 = Theme:Get("Overlay")
    Loading.BackgroundTransparency = 0.3
    Loading.BorderSizePixel = 0
    Loading.ZIndex = 1000
    Loading.Parent = self.GUI
    
    -- Blur effect (if supported)
    local Blur = Instance.new("BlurEffect")
    Blur.Size = 24
    Blur.Parent = game:GetService("Lighting")
    
    local LoadingContainer = Instance.new("Frame")
    LoadingContainer.Size = UDim2.new(0, 300, 0, 150)
    LoadingContainer.Position = UDim2.new(0.5, -150, 0.5, -75)
    LoadingContainer.BackgroundColor3 = Theme:Get("Background")
    LoadingContainer.BorderSizePixel = 0
    LoadingContainer.Parent = Loading
    
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 18)
    LoadingCorner.Parent = LoadingContainer
    
    local LoadingStroke = Instance.new("UIStroke")
    LoadingStroke.Color = Theme:Get("Primary")
    LoadingStroke.Thickness = 2
    LoadingStroke.Transparency = 0.5
    LoadingStroke.Parent = LoadingContainer
    
    -- Animated gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme:Get("Primary")),
        ColorSequenceKeypoint.new(0.5, Theme:Get("PrimaryHover")),
        ColorSequenceKeypoint.new(1, Theme:Get("Primary"))
    })
    Gradient.Rotation = 45
    Gradient.Parent = LoadingStroke
    
    -- Animate gradient
    RunService.Heartbeat:Connect(function()
        if Loading.Parent then
            Gradient.Rotation = (Gradient.Rotation + 2) % 360
        end
    end)
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Size = UDim2.new(1, -40, 0, 50)
    LoadingTitle.Position = UDim2.new(0, 20, 0, 20)
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Text = self.Name
    LoadingTitle.TextColor3 = Theme:Get("Primary")
    LoadingTitle.TextSize = 28
    LoadingTitle.Font = Enum.Font.GothamBlack
    LoadingTitle.Parent = LoadingContainer
    
    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.Size = UDim2.new(1, -40, 0, 25)
    LoadingSubtitle.Position = UDim2.new(0, 20, 0, 60)
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Text = "Initializing..."
    LoadingSubtitle.TextColor3 = Theme:Get("TextSecondary")
    LoadingSubtitle.TextSize = 14
    LoadingSubtitle.Font = Enum.Font.Gotham
    LoadingSubtitle.Parent = LoadingContainer
    
    local LoadingBarBG = Instance.new("Frame")
    LoadingBarBG.Size = UDim2.new(1, -40, 0, 6)
    LoadingBarBG.Position = UDim2.new(0, 20, 0, 100)
    LoadingBarBG.BackgroundColor3 = Theme:Get("ElementBackground")
    LoadingBarBG.BorderSizePixel = 0
    LoadingBarBG.Parent = LoadingContainer
    
    local LoadingBarBGCorner = Instance.new("UICorner")
    LoadingBarBGCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarBGCorner.Parent = LoadingBarBG
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 1, 0)
    LoadingBar.BackgroundColor3 = Theme:Get("Primary")
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = LoadingBarBG
    
    local LoadingBarCorner = Instance.new("UICorner")
    LoadingBarCorner.CornerRadius = UDim.new(1, 0)
    LoadingBarCorner.Parent = LoadingBar
    
    -- Progress animation
    Animation:Tween(LoadingBar, {Size = UDim2.new(1, 0, 1, 0)}, 1.8, Enum.EasingStyle.Quint)
    
    -- Store for cleanup
    self.LoadingScreen = Loading
    self.LoadingBlur = Blur
end

function WindowClass:ShowWindow()
    if self.LoadingScreen then
        Animation:Tween(self.LoadingScreen, {BackgroundTransparency = 1}, 0.5)
        
        for _, Child in ipairs(self.LoadingScreen:GetDescendants()) do
            if Child:IsA("GuiObject") then
                Animation:Tween(Child, {BackgroundTransparency = 1}, 0.4)
            end
            if Child:IsA("TextLabel") then
                Animation:Tween(Child, {TextTransparency = 1}, 0.4)
            end
            if Child:IsA("UIStroke") then
                Animation:Tween(Child, {Transparency = 1}, 0.4)
            end
        end
        
        task.delay(0.6, function()
            if self.LoadingBlur then
                self.LoadingBlur:Destroy()
            end
            self.LoadingScreen:Destroy()
        end)
    end
    
    -- Show main window with animation
    self.Main.Visible = true
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    self.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    Animation:Tween(self.Main, {
        Size = UDim2.new(0, 700, 0, 480),
        Position = UDim2.new(0.5, -350, 0.5, -240)
    }, 0.7, Enum.EasingStyle.Quint)
end

function WindowClass:CreateTopbar()
    self.Topbar = Instance.new("Frame")
    self.Topbar.Name = "Topbar"
    self.Topbar.Size = UDim2.new(1, 0, 0, 55)
    self.Topbar.BackgroundColor3 = Theme:Get("Topbar")
    self.Topbar.BorderSizePixel = 0
    self.Topbar.Parent = self.Main
    
    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 18)
    TopbarCorner.Parent = self.Topbar
    
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Size = UDim2.new(1, 0, 0, 18)
    TopbarFix.Position = UDim2.new(0, 0, 1, -18)
    TopbarFix.BackgroundColor3 = Theme:Get("Topbar")
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Parent = self.Topbar
    
    -- Title section
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Size = UDim2.new(0, 400, 1, 0)
    TitleContainer.Position = UDim2.new(0, 20, 0, 0)
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Parent = self.Topbar
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 0, 0, 28)
    Title.Position = UDim2.new(0, 0, 0, 14)
    Title.AutomaticSize = Enum.AutomaticSize.X
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:Get("Primary")
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBlack
    Title.Parent = TitleContainer
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 0, 0, 22)
    Subtitle.Position = UDim2.new(0, Title.AbsoluteSize.X + 10, 0, 17)
    Subtitle.AutomaticSize = Enum.AutomaticSize.X
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = self.Subtitle
    Subtitle.TextColor3 = Theme:Get("TextMuted")
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = TitleContainer
    
    -- Window controls
    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 120, 1, 0)
    Controls.Position = UDim2.new(1, -130, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = self.Topbar
    
    -- Control buttons with improved styling
    local function CreateControlButton(Name, Text, Color, Position)
        local Btn = Instance.new("TextButton")
        Btn.Name = Name
        Btn.Size = UDim2.new(0, 36, 0, 36)
        Btn.Position = UDim2.new(0, Position, 0.5, -18)
        Btn.BackgroundColor3 = Theme:Get("ElementBackground")
        Btn.Text = Text
        Btn.TextColor3 = Color or Theme:Get("TextSecondary")
        Btn.TextSize = Name == "Close" and 16 or 20
        Btn.Font = Enum.Font.GothamBold
        Btn.AutoButtonColor = false
        Btn.Parent = Controls
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 11)
        Corner.Parent = Btn
        
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme:Get("ElementStroke")
        Stroke.Thickness = 1
        Stroke.Transparency = 0.7
        Stroke.Parent = Btn
        
        return Btn, Stroke
    end
    
    self.MinBtn, self.MinStroke = CreateControlButton("Minimize", "−", Theme:Get("TextSecondary"), 0)
    self.ThemeBtn, self.ThemeStroke = CreateControlButton("Theme", "◐", Theme:Get("TextSecondary"), 42)
    self.CloseBtn, self.CloseStroke = CreateControlButton("Close", "✕", Color3.new(1, 1, 1), 84)
    
    -- Close button special styling
    self.CloseBtn.BackgroundColor3 = Theme:Get("Primary")
    self.CloseStroke.Transparency = 1
end

function WindowClass:CreateSidebar()
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, 190, 1, -55)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 55)
    self.Sidebar.BackgroundColor3 = Theme:Get("Sidebar")
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.Main
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 18)
    SidebarCorner.Parent = self.Sidebar
    
    local SidebarFix1 = Instance.new("Frame")
    SidebarFix1.Size = UDim2.new(0, 18, 1, 0)
    SidebarFix1.Position = UDim2.new(1, -18, 0, 0)
    SidebarFix1.BackgroundColor3 = Theme:Get("Sidebar")
    SidebarFix1.BorderSizePixel = 0
    SidebarFix1.Parent = self.Sidebar
    
    local SidebarFix2 = Instance.new("Frame")
    SidebarFix2.Size = UDim2.new(1, 0, 0, 18)
    SidebarFix2.Position = UDim2.new(0, 0, 0, 0)
    SidebarFix2.BackgroundColor3 = Theme:Get("Sidebar")
    SidebarFix2.BorderSizePixel = 0
    SidebarFix2.Parent = self.Sidebar
    
    -- "PAGES" header
    local PagesHeader = Instance.new("TextLabel")
    PagesHeader.Name = "PagesHeader"
    PagesHeader.Size = UDim2.new(1, -30, 0, 22)
    PagesHeader.Position = UDim2.new(0, 20, 0, 18)
    PagesHeader.BackgroundTransparency = 1
    PagesHeader.Text = "NAVIGATION"
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
    self.TabList.ScrollBarThickness = 3
    self.TabList.ScrollBarImageColor3 = Theme:Get("Primary")
    self.TabList.BorderSizePixel = 0
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.Parent = self.Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = self.TabList
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 12)
    TabPadding.PaddingRight = UDim.new(0, 12)
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.Parent = self.TabList
    
    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 15)
    end)
end

function WindowClass:CreateContent()
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.Size = UDim2.new(1, -190, 1, -55)
    self.Content.Position = UDim2.new(0, 190, 0, 55)
    self.Content.BackgroundTransparency = 1
    self.Content.Parent = self.Main
    
    -- Pages container
    self.Pages = Instance.new("Frame")
    self.Pages.Name = "Pages"
    self.Pages.Size = UDim2.new(1, 0, 1, 0)
    self.Pages.BackgroundTransparency = 1
    self.Pages.ClipsDescendants = true
    self.Pages.Parent = self.Content
end

function WindowClass:SetupDrag()
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
            
            -- Smooth drag with spring
            Animation:Spring(self.Main, "Position", NewPos, 50, 0.9)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

function WindowClass:SetupControls()
    -- Minimize
    self.MinBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Theme toggle
    self.ThemeBtn.MouseButton1Click:Connect(function()
        local Themes = {"Dark", "Light"}
        local Current = table.find(Themes, Theme.Current) or 1
        local Next = Current % #Themes + 1
        self:SetTheme(Themes[Next])
    end)
    
    -- Close
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- Hover effects
    local function AddHoverEffect(Button, Stroke, HoverColor, OriginalColor)
        Button.MouseEnter:Connect(function()
            Animation:Tween(Button, {BackgroundColor3 = HoverColor or Theme:Get("ElementBackgroundHover")}, 0.2)
            if Stroke then
                Animation:Tween(Stroke, {Transparency = 0.4}, 0.2)
            end
        end)
        
        Button.MouseLeave:Connect(function()
            Animation:Tween(Button, {BackgroundColor3 = OriginalColor or Theme:Get("ElementBackground")}, 0.2)
            if Stroke then
                Animation:Tween(Stroke, {Transparency = 0.7}, 0.2)
            end
        end)
    end
    
    AddHoverEffect(self.MinBtn, self.MinStroke)
    AddHoverEffect(self.ThemeBtn, self.ThemeStroke)
    AddHoverEffect(self.CloseBtn, nil, Theme:Get("PrimaryHover"), Theme:Get("Primary"))
end

function WindowClass:SetTheme(ThemeName)
    if not Theme:SetTheme(ThemeName) then return end
    
    -- Animate all theme changes
    Animation:Tween(self.Main, {BackgroundColor3 = Theme:Get("Background")}, 0.4)
    Animation:Tween(self.Topbar, {BackgroundColor3 = Theme:Get("Topbar")}, 0.4)
    Animation:Tween(self.Sidebar, {BackgroundColor3 = Theme:Get("Sidebar")}, 0.4)
    
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
        Animation:Tween(self.Main, {
            Size = UDim2.new(0, self.Main.Size.X.Offset, 0, 55)
        }, 0.4, Enum.EasingStyle.Quint)
        
        task.delay(0.2, function()
            self.Sidebar.Visible = false
            self.Content.Visible = false
        end)
    else
        self.Sidebar.Visible = true
        self.Content.Visible = true
        
        Animation:Tween(self.Main, {
            Size = UDim2.new(0, 700, 0, 480)
        }, 0.4, Enum.EasingStyle.Quint)
    end
end

function WindowClass:Close()
    if self.Closed then return end
    self.Closed = true
    
    Animation:Tween(self.Main, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In, function()
        self.GUI:Destroy()
    end)
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
    
    -- Tab button (improved design)
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = Name .. "Tab"
    Tab.Button.Size = UDim2.new(1, -8, 0, 44)
    Tab.Button.BackgroundColor3 = Theme:Get("ElementBackground")
    Tab.Button.BackgroundTransparency = 1
    Tab.Button.Text = ""
    Tab.Button.AutoButtonColor = false
    Tab.Button.Parent = self.TabList
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = Tab.Button
    
    -- Icon
    Tab.IconLabel = Instance.new("TextLabel")
    Tab.IconLabel.Name = "Icon"
    Tab.IconLabel.Size = UDim2.new(0, 24, 0, 24)
    Tab.IconLabel.Position = UDim2.new(0, 14, 0.5, -12)
    Tab.IconLabel.BackgroundTransparency = 1
    Tab.IconLabel.Text = Icons:GetText(Icon)
    Tab.IconLabel.TextColor3 = Theme:Get("TabInactive")
    Tab.IconLabel.TextSize = 17
    Tab.IconLabel.Font = Enum.Font.GothamBold
    Tab.IconLabel.Parent = Tab.Button
    
    -- Name
    Tab.NameLabel = Instance.new("TextLabel")
    Tab.NameLabel.Name = "Name"
    Tab.NameLabel.Size = UDim2.new(1, -55, 1, 0)
    Tab.NameLabel.Position = UDim2.new(0, 46, 0, 0)
    Tab.NameLabel.BackgroundTransparency = 1
    Tab.NameLabel.Text = Name
    Tab.NameLabel.TextColor3 = Theme:Get("TextSecondary")
    Tab.NameLabel.TextSize = 15
    Tab.NameLabel.Font = Enum.Font.GothamSemibold
    Tab.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    Tab.NameLabel.Parent = Tab.Button
    
    -- Active indicator (improved)
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
    Tab.Page.Size = UDim2.new(1, -5, 1, 0)
    Tab.Page.BackgroundTransparency = 1
    Tab.Page.ScrollBarThickness = 4
    Tab.Page.ScrollBarImageColor3 = Theme:Get("Primary")
    Tab.Page.BorderSizePixel = 0
    Tab.Page.Visible = false
    Tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.Page.Parent = self.Pages
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 12)
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Parent = Tab.Page
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingLeft = UDim.new(0, 20)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.PaddingTop = UDim.new(0, 18)
    PagePadding.PaddingBottom = UDim.new(0, 18)
    PagePadding.Parent = Tab.Page
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Tab.Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 40)
    end)
    
    -- Click handler
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
        Animation:Pop(Tab.Button, 1.04)
    end)
    
    -- Hover effect
    Tab.Button.MouseEnter:Connect(function()
        if self.ActiveTab ~= Tab then
            Animation:Tween(Tab.Button, {BackgroundTransparency = 0.85}, 0.2)
            Animation:Tween(Tab.NameLabel, {TextColor3 = Theme:Get("TabHover")}, 0.2)
            Animation:Tween(Tab.IconLabel, {TextColor3 = Theme:Get("TabHover")}, 0.2)
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if self.ActiveTab ~= Tab then
            Animation:Tween(Tab.Button, {BackgroundTransparency = 1}, 0.2)
            Animation:Tween(Tab.NameLabel, {TextColor3 = Theme:Get("TextSecondary")}, 0.2)
            Animation:Tween(Tab.IconLabel, {TextColor3 = Theme:Get("TabInactive")}, 0.2)
        end
    end)
    
    -- Add element creation methods
    function Tab:Button(Settings)
        return self.Window:CreateButton(self, Settings)
    end
    
    function Tab:Toggle(Settings)
        return self.Window:CreateToggle(self, Settings)
    end
    
    function Tab:Slider(Settings)
        return self.Window:CreateSlider(self, Settings)
    end
    
    function Tab:Dropdown(Settings)
        return self.Window:CreateDropdown(self, Settings)
    end
    
    function Tab:Input(Settings)
        return self.Window:CreateInput(self, Settings)
    end
    
    function Tab:Keybind(Settings)
        return self.Window:CreateKeybind(self, Settings)
    end
    
    function Tab:ColorPicker(Settings)
        return self.Window:CreateColorPicker(self, Settings)
    end
    
    function Tab:Paragraph(Settings)
        return self.Window:CreateParagraph(self, Settings)
    end
    
    function Tab:Label(Text)
        return self.Window:CreateLabel(self, Text)
    end
    
    function Tab:Section(Name)
        return self.Window:CreateSection(self, Name)
    end
    
    table.insert(self.Tabs, Tab)
    
    -- Auto-select first tab
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
        Animation:Tween(self.ActiveTab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
        Animation:Tween(self.ActiveTab.IconLabel, {TextColor3 = Theme:Get("TabInactive")}, 0.25)
        Animation:Tween(self.ActiveTab.NameLabel, {TextColor3 = Theme:Get("TextSecondary")}, 0.25)
        Animation:Tween(self.ActiveTab.Button, {BackgroundTransparency = 1}, 0.25)
    end
    
    -- Select new
    self.ActiveTab = Tab
    Tab.Page.Visible = true
    
    Animation:Tween(Tab.Indicator, {Size = UDim2.new(0, 3, 0, 24)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Animation:Tween(Tab.IconLabel, {TextColor3 = Theme:Get("TabActive")}, 0.25)
    Animation:Tween(Tab.NameLabel, {TextColor3 = Theme:Get("TextPrimary")}, 0.25)
    Animation:Tween(Tab.Button, {BackgroundTransparency = 0.92}, 0.25)
    
    -- Page entrance animation
    Tab.Page.Position = UDim2.new(0.03, 0, 0, 0)
    Animation:Tween(Tab.Page, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quint)
end

-- ==========================================
-- ELEMENT CREATION (Enhanced & Bug-Fixed)
-- ==========================================

function WindowClass:CreateButton(Tab, Settings)
    Settings = Settings or {}
    
    local Button = Instance.new("TextButton")
    Button.Name = Settings.Name or "Button"
    Button.Size = UDim2.new(1, 0, 0, 46)
    Button.BackgroundColor3 = Theme:Get("ElementBackground")
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.ClipsDescendants = true
    Button.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 13)
    Corner.Parent = Button
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.5
    Stroke.Parent = Button
    
    -- Icon (if provided)
    if Settings.Icon then
        local Icon = Instance.new("TextLabel")
        Icon.Size = UDim2.new(0, 26, 0, 26)
        Icon.Position = UDim2.new(0, 16, 0.5, -13)
        Icon.BackgroundTransparency = 1
        Icon.Text = Icons:GetText(Settings.Icon)
        Icon.TextColor3 = Theme:Get("Primary")
        Icon.TextSize = 19
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = Button
    end
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, Settings.Icon and -70 or -55, 1, 0)
    Title.Position = UDim2.new(0, Settings.Icon and 48 or 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Button"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    -- Arrow indicator
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 22, 0, 22)
    Arrow.Position = UDim2.new(1, -34, 0.5, -11)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "→"
    Arrow.TextColor3 = Theme:Get("TextMuted")
    Arrow.TextSize = 18
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Button
    
    -- Interactions
    Button.MouseEnter:Connect(function()
        Animation:Tween(Button, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
        Animation:Tween(Stroke, {Transparency = 0.3}, 0.2)
        Animation:Tween(Arrow, {
            TextColor3 = Theme:Get("Primary"),
            Position = UDim2.new(1, -30, 0.5, -11)
        }, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Animation:Tween(Button, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.2)
        Animation:Tween(Stroke, {Transparency = 0.5}, 0.2)
        Animation:Tween(Arrow, {
            TextColor3 = Theme:Get("TextMuted"),
            Position = UDim2.new(1, -34, 0.5, -11)
        }, 0.2)
    end)
    
    Button.MouseButton1Down:Connect(function()
        Animation:Tween(Button, {Size = UDim2.new(1, -4, 0, 44)}, 0.1)
    end)
    
    Button.MouseButton1Up:Connect(function()
        Animation:Tween(Button, {Size = UDim2.new(1, 0, 0, 46)}, 0.15)
    end)
    
    Button.MouseButton1Click:Connect(function()
        local MousePos = UserInputService:GetMouseLocation()
        local RelativePos = Vector2.new(
            MousePos.X - Button.AbsolutePosition.X,
            MousePos.Y - Button.AbsolutePosition.Y
        )
        Animation:Ripple(Button, RelativePos)
        
        if Settings.Callback then
            task.spawn(Settings.Callback)
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
    local Value = SaveManager:Get(self.ConfigFolder .. "/" .. Flag, Settings.CurrentValue or false)
    
    local Toggle = Instance.new("Frame")
    Toggle.Name = Settings.Name or "Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 48)
    Toggle.BackgroundColor3 = Theme:Get("ElementBackground")
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 13)
    Corner.Parent = Toggle
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.5
    Stroke.Parent = Toggle
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Toggle"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Toggle
    
    -- Toggle switch (improved design)
    local Switch = Instance.new("Frame")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 52, 0, 28)
    Switch.Position = UDim2.new(1, -70, 0.5, -14)
    Switch.BackgroundColor3 = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
    Switch.BorderSizePixel = 0
    Switch.Parent = Toggle
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    -- Inner glow
    local Glow = Instance.new("Frame")
    Glow.Size = UDim2.new(1, -6, 1, -6)
    Glow.Position = UDim2.new(0, 3, 0, 3)
    Glow.BackgroundColor3 = Value and Theme:Get("Success") or Theme:Get("ElementBackground")
    Glow.BackgroundTransparency = Value and 0.7 or 0.3
    Glow.BorderSizePixel = 0
    Glow.Parent = Switch
    
    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(1, 0)
    GlowCorner.Parent = Glow
    
    -- Circle
    local Circle = Instance.new("Frame")
    Circle.Name = "Circle"
    Circle.Size = UDim2.new(0, 22, 0, 22)
    Circle.Position = Value and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    -- Circle shadow
    local CircleShadow = Instance.new("ImageLabel")
    CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    CircleShadow.Size = UDim2.new(1, 10, 1, 10)
    CircleShadow.ZIndex = 0
    CircleShadow.BackgroundTransparency = 1
    CircleShadow.Image = "rbxassetid://6014261993"
    CircleShadow.ImageColor3 = Color3.new(0, 0, 0)
    CircleShadow.ImageTransparency = 0.6
    CircleShadow.ScaleType = Enum.ScaleType.Slice
    CircleShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    CircleShadow.Parent = Circle
    
    -- Set function
    local function SetToggle(NewValue, SkipCallback)
        Value = NewValue
        SaveManager:Set(self.ConfigFolder .. "/" .. Flag, Value)
        
        local TargetColor = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
        local TargetPos = Value and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        local GlowColor = Value and Theme:Get("Success") or Theme:Get("ElementBackground")
        local GlowTrans = Value and 0.7 or 0.3
        
        Animation:Tween(Switch, {BackgroundColor3 = TargetColor}, 0.25)
        Animation:Tween(Circle, {Position = TargetPos}, 0.3, Enum.EasingStyle.Quint)
        Animation:Tween(Glow, {
            BackgroundColor3 = GlowColor,
            BackgroundTransparency = GlowTrans
        }, 0.25)
        
        if Value then
            Animation:Pop(Circle, 1.15)
        end
        
        if Settings.Callback and not SkipCallback then
            task.spawn(Settings.Callback, Value)
        end
    end
    
    -- Click area
    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = Toggle
    
    ClickArea.MouseButton1Click:Connect(function()
        SetToggle(not Value)
        Animation:Ripple(Toggle, Vector2.new(Toggle.AbsoluteSize.X / 2, Toggle.AbsoluteSize.Y / 2))
    end)
    
    -- Hover effect
    Toggle.MouseEnter:Connect(function()
        Animation:Tween(Toggle, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
        Animation:Tween(Stroke, {Transparency = 0.3}, 0.2)
    end)
    
    Toggle.MouseLeave:Connect(function()
        Animation:Tween(Toggle, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.2)
        Animation:Tween(Stroke, {Transparency = 0.5}, 0.2)
    end)
    
    return {
        Instance = Toggle,
        Set = function(NewValue, SkipCallback)
            SetToggle(NewValue, SkipCallback)
        end,
        Get = function()
            return Value
        end
    }
end

function WindowClass:CreateSlider(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Slider") .. "_Slider"
    local Range = Settings.Range or {0, 100}
    local Increment = Settings.Increment or 1
    local Suffix = Settings.Suffix or ""
    local Value = SaveManager:Get(self.ConfigFolder .. "/" .. Flag, Settings.CurrentValue or Range[1])
    
    local Slider = Instance.new("Frame")
    Slider.Name = Settings.Name or "Slider"
    Slider.Size = UDim2.new(1, 0, 0, 62)
    Slider.BackgroundColor3 = Theme:Get("ElementBackground")
    Slider.BorderSizePixel = 0
    Slider.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 13)
    Corner.Parent = Slider
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme:Get("ElementStroke")
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.5
    Stroke.Parent = Slider
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -105, 0, 22)
    Title.Position = UDim2.new(0, 18, 0, 12)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Slider"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Slider
    
    -- Value display
    local ValueDisplay = Instance.new("TextBox")
    ValueDisplay.Size = UDim2.new(0, 68, 0, 26)
    ValueDisplay.Position = UDim2.new(1, -86, 0, 10)
    ValueDisplay.BackgroundColor3 = Theme:Get("Background")
    ValueDisplay.Text = tostring(Value) .. Suffix
    ValueDisplay.TextColor3 = Theme:Get("TextPrimary")
    ValueDisplay.TextSize = 14
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.ClearTextOnFocus = false
    ValueDisplay.Parent = Slider
    
    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 8)
    ValueCorner.Parent = ValueDisplay
    
    local ValueStroke = Instance.new("UIStroke")
    ValueStroke.Color = Theme:Get("ElementStroke")
    ValueStroke.Thickness = 1
    ValueStroke.Transparency = 0.6
    ValueStroke.Parent = ValueDisplay
    
    -- Slider track
    local Track = Instance.new("Frame")
    Track.Name = "Track"
    Track.Size = UDim2.new(1, -36, 0, 7)
    Track.Position = UDim2.new(0, 18, 0, 44)
    Track.BackgroundColor3 = Theme:Get("ElementStroke")
    Track.BackgroundTransparency = 0.3
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
    
    -- Progress glow
    local ProgressGlow = Instance.new("Frame")
    ProgressGlow.Size = UDim2.new(1, 0, 1, 0)
    ProgressGlow.BackgroundColor3 = Color3.new(1, 1, 1)
    ProgressGlow.BackgroundTransparency = 0.7
    ProgressGlow.BorderSizePixel = 0
    ProgressGlow.Parent = Progress
    
    local ProgressGlowCorner = Instance.new("UICorner")
    ProgressGlowCorner.CornerRadius = UDim.new(1, 0)
    ProgressGlowCorner.Parent = ProgressGlow
    
    -- Handle
    local Handle = Instance.new("Frame")
    Handle.Name = "Handle"
    Handle.Size = UDim2.new(0, 18, 0, 18)
    Handle.Position = UDim2.new(1, -9, 0.5, -9)
    Handle.BackgroundColor3 = Color3.new(1, 1, 1)
    Handle.BorderSizePixel = 0
    Handle.Parent = Progress
    
    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(1, 0)
    HandleCorner.Parent = Handle
    
    local HandleShadow = Instance.new("ImageLabel")
    HandleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    HandleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    HandleShadow.Size = UDim2.new(1, 12, 1, 12)
    HandleShadow.ZIndex = 0
    HandleShadow.BackgroundTransparency = 1
    HandleShadow.Image = "rbxassetid://6014261993"
    HandleShadow.ImageColor3 = Color3.new(0, 0, 0)
    HandleShadow.ImageTransparency = 0.5
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
            SaveManager:Set(self.ConfigFolder .. "/" .. Flag, Value)
            ValueDisplay.Text = tostring(Value) .. Suffix
            
            local ProgressScale = (Value - Range[1]) / (Range[2] - Range[1])
            Animation:Tween(Progress, {Size = UDim2.new(ProgressScale, 0, 1, 0)}, 0.1)
            
            if Settings.Callback then
                task.spawn(Settings.Callback, Value)
            end
        end
    end
    
    Track.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            Update(Input)
            Animation:Tween(Handle, {Size = UDim2.new(0, 22, 0, 22)}, 0.2, Enum.EasingStyle.Quint)
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
            Animation:Tween(Handle, {Size = UDim2.new(0, 18, 0, 18)}, 0.2, Enum.EasingStyle.Quint)
        end
    end)
    
    ValueDisplay.FocusLost:Connect(function()
        local Text = ValueDisplay.Text:gsub(Suffix, "")
        local Num = tonumber(Text)
        if Num then
            Num = math.clamp(Num, Range[1], Range[2])
            Value = Num
            SaveManager:Set(self.ConfigFolder .. "/" .. Flag, Value)
            ValueDisplay.Text = tostring(Value) .. Suffix
            
            local ProgressScale = (Value - Range[1]) / (Range[2] - Range[1])
            Animation:Tween(Progress, {Size = UDim2.new(ProgressScale, 0, 1, 0)}, 0.2)
            
            if Settings.Callback then
                task.spawn(Settings.Callback, Value)
            end
        else
            ValueDisplay.Text = tostring(Value) .. Suffix
        end
    end)
    
    -- Hover effect
    Slider.MouseEnter:Connect(function()
        Animation:Tween(Slider, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
        Animation:Tween(Stroke, {Transparency = 0.3}, 0.2)
    end)
    
    Slider.MouseLeave:Connect(function()
        Animation:Tween(Slider, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.2)
        Animation:Tween(Stroke, {Transparency = 0.5}, 0.2)
    end)
    
    return {
        Instance = Slider,
        Set = function(NewValue)
            Value = math.clamp(NewValue, Range[1], Range[2])
            SaveManager:Set(self.ConfigFolder .. "/" .. Flag, Value)
            ValueDisplay.Text = tostring(Value) .. Suffix
            
            local ProgressScale = (Value - Range[1]) / (Range[2] - Range[1])
            Animation:Tween(Progress, {Size = UDim2.new(ProgressScale, 0, 1, 0)}, 0.2)
            
            if Settings.Callback then
                task.spawn(Settings.Callback, Value)
            end
        end,
        Get = function()
            return Value
        end
    }
end

-- CONTINUED: Dropdown, Input, Keybind, ColorPicker, Section, Paragraph, Label...
-- (Due to character limit, I'll create a second file with the remaining elements)

-- ==========================================
-- LIBRARY FUNCTIONS
-- ==========================================

function NexusUI:CreateWindow(Settings)
    local Window = WindowClass:Create(Settings)
    table.insert(self.Windows, Window)
    
    return {
        Main = Window,
        Tabs = {},
        
        CreateTab = function(_, Name, Icon)
            local Tab = Window:CreateTab(Name, Icon)
            return Tab
        end,
        
        Destroy = function()
            if Window.GUI then
                Window.GUI:Destroy()
            end
        end
    }
end

function NexusUI:Notify(Settings)
    return NotificationSystem:Notify(Settings)
end

function NexusUI:SetTheme(ThemeName)
    return Theme:SetTheme(ThemeName)
end

function NexusUI:DestroyAll()
    for _, Window in ipairs(self.Windows) do
        if Window.GUI then
            Window.GUI:Destroy()
        end
    end
    self.Windows = {}
end

-- Global toggle (RightShift to toggle all windows)
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.RightShift then
        for _, Window in ipairs(NexusUI.Windows) do
            if Window.GUI then
                Window.GUI.Enabled = not Window.GUI.Enabled
            end
        end
    end
end)

-- Welcome message
NexusUI:Notify({
    Title = "Nexus UI Loaded!",
    Content = "Enhanced version 4.0 initialized successfully",
    Type = "Success",
    Duration = 3
})

return NexusUI
