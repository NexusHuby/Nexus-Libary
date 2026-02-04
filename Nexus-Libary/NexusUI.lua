--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝███████╗
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚══════╝
    
    Nexus UI Library v1.0
    A modern, professional Roblox GUI library
    Inspired by Rayfield
]]

local NexusUI = {
    Version = "1.0.0",
    Windows = {},
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
-- UTILITY MODULES (Built-in)
-- ==========================================

-- Theme System
local Theme = {
    Current = "Dark",
    Palettes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 25),
            Secondary = Color3.fromRGB(35, 35, 35),
            Tertiary = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(88, 101, 242),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(178, 178, 178),
            Border = Color3.fromRGB(55, 55, 55),
            Hover = Color3.fromRGB(60, 60, 60),
            Success = Color3.fromRGB(87, 242, 135),
            Warning = Color3.fromRGB(254, 231, 92),
            Error = Color3.fromRGB(237, 69, 69)
        },
        Light = {
            Background = Color3.fromRGB(245, 245, 245),
            Secondary = Color3.fromRGB(255, 255, 255),
            Tertiary = Color3.fromRGB(235, 235, 235),
            Accent = Color3.fromRGB(88, 101, 242),
            Text = Color3.fromRGB(30, 30, 30),
            SubText = Color3.fromRGB(100, 100, 100),
            Border = Color3.fromRGB(200, 200, 200),
            Hover = Color3.fromRGB(220, 220, 220),
            Success = Color3.fromRGB(46, 204, 113),
            Warning = Color3.fromRGB(241, 196, 15),
            Error = Color3.fromRGB(231, 76, 60)
        },
        Midnight = {
            Background = Color3.fromRGB(15, 15, 25),
            Secondary = Color3.fromRGB(25, 25, 40),
            Tertiary = Color3.fromRGB(35, 35, 55),
            Accent = Color3.fromRGB(114, 137, 218),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(150, 150, 170),
            Border = Color3.fromRGB(40, 40, 60),
            Hover = Color3.fromRGB(45, 45, 70),
            Success = Color3.fromRGB(87, 242, 135),
            Warning = Color3.fromRGB(254, 231, 92),
            Error = Color3.fromRGB(237, 69, 69)
        },
        Ocean = {
            Background = Color3.fromRGB(20, 30, 40),
            Secondary = Color3.fromRGB(30, 45, 60),
            Tertiary = Color3.fromRGB(40, 60, 80),
            Accent = Color3.fromRGB(0, 200, 255),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(150, 180, 200),
            Border = Color3.fromRGB(50, 70, 90),
            Hover = Color3.fromRGB(50, 75, 100),
            Success = Color3.fromRGB(0, 255, 150),
            Warning = Color3.fromRGB(255, 200, 50),
            Error = Color3.fromRGB(255, 80, 80)
        }
    }
}

function Theme:GetColor(Key)
    return self.Palettes[self.Current][Key] or self.Palettes["Dark"][Key]
end

function Theme:SetTheme(Name)
    if self.Palettes[Name] then
        self.Current = Name
        return true
    end
    return false
end

-- Tween System
local Tween = {
    ActiveTweens = {}
}

function Tween:Create(Object, Properties, Duration, Style, Direction, Delay)
    local Info = TweenInfo.new(
        Duration or 0.3,
        Style or Enum.EasingStyle.Quart,
        Direction or Enum.EasingDirection.Out,
        0, false, Delay or 0
    )
    local TweenObj = TweenService:Create(Object, Info, Properties)
    TweenObj:Play()
    return TweenObj
end

function Tween:FadeIn(Object, Duration)
    Object.BackgroundTransparency = 1
    return self:Create(Object, {BackgroundTransparency = 0}, Duration or 0.3)
end

function Tween:FadeOut(Object, Duration, Callback)
    local TweenObj = self:Create(Object, {BackgroundTransparency = 1}, Duration or 0.3)
    if Callback then
        TweenObj.Completed:Connect(Callback)
    end
    return TweenObj
end

-- Icon System (Using Emoji - Reliable)
local Icons = {
    ["home"] = "🏠",
    ["settings"] = "⚙️",
    ["user"] = "👤",
    ["menu"] = "☰",
    ["x"] = "✕",
    ["check"] = "✓",
    ["chevron-down"] = "▼",
    ["chevron-up"] = "▲",
    ["plus"] = "+",
    ["minus"] = "-",
    ["edit"] = "✎",
    ["trash"] = "🗑",
    ["search"] = "🔍",
    ["filter"] = "⫧",
    ["play"] = "▶",
    ["pause"] = "⏸",
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
    ["lock"] = "🔒",
    ["unlock"] = "🔓",
    ["arrow-up"] = "↑",
    ["arrow-down"] = "↓",
    ["maximize"] = "□",
    ["minimize"] = "-",
    ["default"] = "•"
}

function Icons:Get(Name)
    return self[Name] or self["default"]
end

-- Save Manager
local SaveManager = {
    Data = {},
    AutoSave = true,
    SaveInterval = 30,
    Path = "NexusUI/Config.json"
}

function SaveManager:Init()
    -- Check file system support
    self.Supported = pcall(function()
        if isfolder and makefolder and writefile and readfile then
            if not isfolder("NexusUI") then
                makefolder("NexusUI")
            end
            return true
        end
        return false
    end)
    
    if self.Supported then
        self:Load()
        -- Auto-save loop
        task.spawn(function()
            while self.AutoSave do
                task.wait(self.SaveInterval)
                self:Save()
            end
        end)
    else
        warn("[NexusUI] File system not supported - settings won't persist")
    end
end

function SaveManager:Load()
    if not self.Supported then return end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(self.Path))
    end)
    if success then
        self.Data = data
    end
end

function SaveManager:Save()
    if not self.Supported then return end
    pcall(function()
        writefile(self.Path, HttpService:JSONEncode(self.Data))
    end)
end

function SaveManager:Set(Key, Value)
    self.Data[Key] = Value
    if self.AutoSave then
        self:Save()
    end
end

function SaveManager:Get(Key, Default)
    return self.Data[Key] ~= nil and self.Data[Key] or Default
end

SaveManager:Init()

-- ==========================================
-- COMPONENTS
-- ==========================================

-- Notification System
local NotificationSystem = {
    GUI = nil,
    Container = nil
}

function NotificationSystem:Init()
    if self.GUI then return end
    
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusNotifications"
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.Parent = CoreGui
    
    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(0, 300, 1, -20)
    self.Container.Position = UDim2.new(1, -320, 0, 10)
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
    local Duration = Data.Duration or 3
    local Type = Data.Type or "Info"
    
    local Colors = {
        Info = Theme:GetColor("Accent"),
        Success = Theme:GetColor("Success"),
        Warning = Theme:GetColor("Warning"),
        Error = Theme:GetColor("Error")
    }
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 280, 0, 80)
    Notif.BackgroundColor3 = Theme:GetColor("Secondary")
    Notif.BorderSizePixel = 0
    Notif.Parent = self.Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notif
    
    -- Accent bar
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0, 4, 1, 0)
    Bar.BackgroundColor3 = Colors[Type]
    Bar.BorderSizePixel = 0
    Bar.Parent = Notif
    
    -- Icon
    local IconMap = {Info = "ℹ", Success = "✓", Warning = "▲", Error = "⚠"}
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 24, 0, 24)
    Icon.Position = UDim2.new(0, 15, 0, 15)
    Icon.BackgroundTransparency = 1
    Icon.Text = IconMap[Type] or "•"
    Icon.TextColor3 = Colors[Type]
    Icon.TextSize = 20
    Icon.Font = Enum.Font.GothamBold
    Icon.Parent = Notif
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 0, 20)
    TitleLabel.Position = UDim2.new(0, 45, 0, 12)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme:GetColor("Text")
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notif
    
    -- Content
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -60, 0, 40)
    ContentLabel.Position = UDim2.new(0, 45, 0, 35)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = Content
    ContentLabel.TextColor3 = Theme:GetColor("SubText")
    ContentLabel.TextSize = 13
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.Parent = Notif
    
    -- Progress bar
    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new(1, 0, 0, 3)
    Progress.Position = UDim2.new(0, 0, 1, -3)
    Progress.BackgroundColor3 = Colors[Type]
    Progress.BorderSizePixel = 0
    Progress.Parent = Notif
    
    -- Animation
    Notif.Position = UDim2.new(1, 0, 0, 0)
    Tween:Create(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)
    Tween:Create(Progress, {Size = UDim2.new(0, 0, 0, 3)}, Duration)
    
    task.delay(Duration, function()
        Tween:Create(Notif, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3).Completed:Connect(function()
            Notif:Destroy()
        end)
    end)
end

-- ==========================================
-- WINDOW CLASS
-- ==========================================

local Window = {}
Window.__index = Window

function Window:Create(Config)
    local self = setmetatable({}, Window)
    Config = Config or {}
    
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Visible = true
    
    -- GUI Setup
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusUI_" .. (Config.Name or "Window")
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.Parent = CoreGui
    
    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = Config.Size or UDim2.new(0, 600, 0, 400)
    self.Main.Position = Config.Position or UDim2.new(0.5, -300, 0.5, -200)
    self.Main.BackgroundColor3 = Theme:GetColor("Background")
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = true
    self.Main.Parent = self.GUI
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = self.Main
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 47, 1, 47)
    Shadow.ZIndex = -1
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = self.Main
    
    -- Top Bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 45)
    self.TopBar.BackgroundColor3 = Theme:GetColor("Secondary")
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.Main
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = self.TopBar
    
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.BackgroundColor3 = Theme:GetColor("Secondary")
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = self.TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Title or "Nexus UI"
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.TopBar
    
    -- Controls
    local Controls = Instance.new("Frame")
    Controls.Size = UDim2.new(0, 70, 1, 0)
    Controls.Position = UDim2.new(1, -75, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = self.TopBar
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(0, 0, 0.5, -15)
    MinBtn.BackgroundColor3 = Theme:GetColor("Tertiary")
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Theme:GetColor("Text")
    MinBtn.TextSize = 20
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = Controls
    
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(0, 35, 0.5, -15)
    CloseBtn.BackgroundColor3 = Theme:GetColor("Error")
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Controls
    
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 160, 1, -45)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 45)
    self.Sidebar.BackgroundColor3 = Theme:GetColor("Secondary")
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.Main
    
    Instance.new("UICorner", self.Sidebar).CornerRadius = UDim.new(0, 8)
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Size = UDim2.new(0, 10, 1, 0)
    SidebarFix.Position = UDim2.new(1, -10, 0, 0)
    SidebarFix.BackgroundColor3 = Theme:GetColor("Secondary")
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = self.Sidebar
    
    -- Tab List
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Size = UDim2.new(1, -10, 1, -10)
    self.TabList.Position = UDim2.new(0, 5, 0, 5)
    self.TabList.BackgroundTransparency = 1
    self.TabList.ScrollBarThickness = 2
    self.TabList.ScrollBarImageColor3 = Theme:GetColor("Accent")
    self.TabList.Parent = self.Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = self.TabList
    
    -- Content Area
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, -160, 1, -45)
    self.Content.Position = UDim2.new(0, 160, 0, 45)
    self.Content.BackgroundColor3 = Theme:GetColor("Background")
    self.Content.BorderSizePixel = 0
    self.Content.Parent = self.Main
    
    -- Dragging
    local Dragging = false
    local DragStart = nil
    local StartPos = nil
    
    self.TopBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = self.Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - DragStart
            self.Main.Position = UDim2.new(
                StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    -- Button Events
    MinBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Hover Effects
    MinBtn.MouseEnter:Connect(function()
        Tween:Create(MinBtn, {BackgroundColor3 = Theme:GetColor("Hover")}, 0.2)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween:Create(MinBtn, {BackgroundColor3 = Theme:GetColor("Tertiary")}, 0.2)
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween:Create(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.2)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween:Create(CloseBtn, {BackgroundColor3 = Theme:GetColor("Error")}, 0.2)
    end)
    
    -- Intro Animation
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    Tween:Create(self.Main, {
        Size = Config.Size or UDim2.new(0, 600, 0, 400),
        Position = Config.Position or UDim2.new(0.5, -300, 0.5, -200)
    }, 0.5, Enum.EasingStyle.Back)
    
    return self
end

function Window:CreateTab(Name, Icon)
    local Tab = {
        Name = Name,
        Sections = {},
        Window = self
    }
    
    -- Tab Button
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Size = UDim2.new(1, 0, 0, 35)
    Tab.Button.BackgroundColor3 = Theme:GetColor("Secondary")
    Tab.Button.Text = ""
    Tab.Button.AutoButtonColor = false
    Tab.Button.Parent = self.TabList
    
    Instance.new("UICorner", Tab.Button).CornerRadius = UDim.new(0, 6)
    
    -- Icon
    if Icon then
        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 20, 0, 20)
        IconLabel.Position = UDim2.new(0, 10, 0.5, -10)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = Icons:Get(Icon)
        IconLabel.TextColor3 = Theme:GetColor("SubText")
        IconLabel.TextSize = 14
        IconLabel.Font = Enum.Font.GothamBold
        IconLabel.Parent = Tab.Button
    end
    
    -- Tab Name
    local TabText = Instance.new("TextLabel")
    TabText.Size = UDim2.new(1, Icon and -40 or -20, 1, 0)
    TabText.Position = UDim2.new(0, Icon and 35 or 10, 0, 0)
    TabText.BackgroundTransparency = 1
    TabText.Text = Name
    TabText.TextColor3 = Theme:GetColor("SubText")
    TabText.TextSize = 14
    TabText.Font = Enum.Font.GothamSemibold
    TabText.TextXAlignment = Enum.TextXAlignment.Left
    TabText.Parent = Tab.Button
    
    -- Content Container
    Tab.Container = Instance.new("ScrollingFrame")
    Tab.Container.Size = UDim2.new(1, -20, 1, -20)
    Tab.Container.Position = UDim2.new(0, 10, 0, 10)
    Tab.Container.BackgroundTransparency = 1
    Tab.Container.ScrollBarThickness = 3
    Tab.Container.ScrollBarImageColor3 = Theme:GetColor("Accent")
    Tab.Container.Visible = false
    Tab.Container.Parent = self.Content
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.Parent = Tab.Container
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Tab.Container.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Click Event
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    Tab.Button.MouseEnter:Connect(function()
        if self.ActiveTab ~= Tab then
            Tween:Create(Tab.Button, {BackgroundColor3 = Theme:GetColor("Tertiary")}, 0.2)
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if self.ActiveTab ~= Tab then
            Tween:Create(Tab.Button, {BackgroundColor3 = Theme:GetColor("Secondary")}, 0.2)
        end
    end)
    
    -- Section Creation
    function Tab:CreateSection(Title, Description)
        return self.Window:CreateSection(self, Title, Description)
    end
    
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        self:SelectTab(Tab)
    end
    
    return Tab
end

function Window:SelectTab(Tab)
    if self.ActiveTab and self.ActiveTab ~= Tab then
        self.ActiveTab.Container.Visible = false
        Tween:Create(self.ActiveTab.Button, {BackgroundColor3 = Theme:GetColor("Secondary")}, 0.2)
        self.ActiveTab.Button.TextLabel.TextColor3 = Theme:GetColor("SubText")
    end
    
    self.ActiveTab = Tab
    Tab.Container.Visible = true
    Tween:Create(Tab.Button, {BackgroundColor3 = Theme:GetColor("Accent")}, 0.2)
    Tab.Button.TextLabel.TextColor3 = Color3.new(1, 1, 1)
    
    Tab.Container.Position = UDim2.new(0, 20, 0, 10)
    Tween:Create(Tab.Container, {Position = UDim2.new(0, 10, 0, 10)}, 0.3)
end

function Window:CreateSection(Tab, Title, Description)
    local Section = {
        Elements = {}
    }
    
    -- Container
    Section.Instance = Instance.new("Frame")
    Section.Instance.Size = UDim2.new(1, 0, 0, 50)
    Section.Instance.BackgroundColor3 = Theme:GetColor("Secondary")
    Section.Instance.BorderSizePixel = 0
    Section.Instance.AutomaticSize = Enum.AutomaticSize.Y
    Section.Instance.Parent = Tab.Container
    
    Instance.new("UICorner", Section.Instance).CornerRadius = UDim.new(0, 8)
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.PaddingRight = UDim.new(0, 15)
    Padding.PaddingTop = UDim.new(0, 15)
    Padding.PaddingBottom = UDim.new(0, 15)
    Padding.Parent = Section.Instance
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, Description and 40 or 25)
    Header.BackgroundTransparency = 1
    Header.Parent = Section.Instance
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 20)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme:GetColor("Text")
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header
    
    -- Description
    if Description then
        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, 0, 0, 15)
        DescLabel.Position = UDim2.new(0, 0, 0, 22)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = Description
        DescLabel.TextColor3 = Theme:GetColor("SubText")
        DescLabel.TextSize = 12
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = Header
    end
    
    -- Elements Container
    Section.ElementContainer = Instance.new("Frame")
    Section.ElementContainer.Size = UDim2.new(1, 0, 0, 0)
    Section.ElementContainer.Position = UDim2.new(0, 0, 0, Header.Size.Y.Offset + 10)
    Section.ElementContainer.BackgroundTransparency = 1
    Section.ElementContainer.AutomaticSize = Enum.AutomaticSize.Y
    Section.ElementContainer.Parent = Section.Instance
    
    local ElementList = Instance.new("UIListLayout")
    ElementList.Padding = UDim.new(0, 8)
    ElementList.Parent = Section.ElementContainer
    
    ElementList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.ElementContainer.Size = UDim2.new(1, 0, 0, ElementList.AbsoluteContentSize.Y)
    end)
    
    -- Element Methods
    function Section:AddButton(Config)
        return self.Window:CreateButton(self, Config)
    end
    
    function Section:AddToggle(Config)
        return self.Window:CreateToggle(self, Config)
    end
    
    function Section:AddSlider(Config)
        return self.Window:CreateSlider(self, Config)
    end
    
    function Section:AddDropdown(Config)
        return self.Window:CreateDropdown(self, Config)
    end
    
    function Section:AddColorPicker(Config)
        return self.Window:CreateColorPicker(self, Config)
    end
    
    function Section:AddInput(Config)
        return self.Window:CreateInput(self, Config)
    end
    
    function Section:AddDivider()
        return self.Window:CreateDivider(self)
    end
    
    Tween:FadeIn(Section.Instance, 0.3)
    table.insert(Tab.Sections, Section)
    
    return Section
end

-- ==========================================
-- ELEMENT CREATION METHODS
-- ==========================================

function Window:CreateButton(Section, Config)
    Config = Config or {}
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Theme:GetColor("Tertiary")
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Section.ElementContainer
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
    
    -- Icon
    if Config.Icon then
        local Icon = Instance.new("TextLabel")
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 10, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Text = Icons:Get(Config.Icon)
        Icon.TextColor3 = Theme:GetColor("Text")
        Icon.TextSize = 14
        Icon.Font = Enum.Font.GothamBold
        Icon.Parent = Button
    end
    
    -- Text
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, Config.Icon and -40 or -20, 1, 0)
    Text.Position = UDim2.new(0, Config.Icon and 35 or 10, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = Config.Name or "Button"
    Text.TextColor3 = Theme:GetColor("Text")
    Text.TextSize = 14
    Text.Font = Enum.Font.GothamSemibold
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Button
    
    -- Events
    Button.MouseEnter:Connect(function()
        Tween:Create(Button, {BackgroundColor3 = Theme:GetColor("Accent")}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Tween:Create(Button, {BackgroundColor3 = Theme:GetColor("Tertiary")}, 0.2)
    end)
    
    Button.MouseButton1Down:Connect(function()
        Tween:Create(Button, {Size = UDim2.new(0.98, 0, 0, 33), Position = UDim2.new(0.01, 0, 0, 1)}, 0.1)
    end)
    
    Button.MouseButton1Up:Connect(function()
        Tween:Create(Button, {Size = UDim2.new(1, 0, 0, 35), Position = UDim2.new(0, 0, 0, 0)}, 0.1)
    end)
    
    Button.MouseButton1Click:Connect(function()
        if Config.Callback then
            task.spawn(Config.Callback)
        end
    end)
    
    return {
        Instance = Button,
        SetName = function(NewName) Text.Text = NewName end
    }
end

function Window:CreateToggle(Section, Config)
    Config = Config or {}
    local Flag = Config.Flag or (Config.Name or "Toggle") .. "_State"
    local Value = SaveManager:Get(Flag, Config.Default or false)
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Theme:GetColor("Tertiary")
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = Section.ElementContainer
    
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Name or "Toggle"
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = ToggleFrame
    
    -- Toggle Button
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -54, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Value and Theme:GetColor("Accent") or Theme:GetColor("Border")
    ToggleBtn.Text = ""
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Parent = ToggleFrame
    
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    -- Circle
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Circle.BorderSizePixel = 0
    Circle.Parent = ToggleBtn
    
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    local function SetToggle(NewValue)
        Value = NewValue
        SaveManager:Set(Flag, Value)
        
        local Color = Value and Theme:GetColor("Accent") or Theme:GetColor("Border")
        local Pos = Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        
        Tween:Create(ToggleBtn, {BackgroundColor3 = Color}, 0.2)
        Tween:Create(Circle, {Position = Pos}, 0.2)
        
        if Config.Callback then
            task.spawn(Config.Callback, Value)
        end
    end
    
    ToggleBtn.MouseButton1Click:Connect(function()
        SetToggle(not Value)
    end)
    
    return {
        Instance = ToggleFrame,
        SetValue = SetToggle,
        GetValue = function() return Value end
    }
end

function Window:CreateSlider(Section, Config)
    Config = Config or {}
    local Flag = Config.Flag or (Config.Name or "Slider") .. "_Value"
    local Min = Config.Min or 0
    local Max = Config.Max or 100
    local Value = SaveManager:Get(Flag, Config.Default or Min)
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Theme:GetColor("Tertiary")
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = Section.ElementContainer
    
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
    
    -- Title & Value
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Name or "Slider"
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = SliderFrame
    
    local ValueBox = Instance.new("TextBox")
    ValueBox.Size = UDim2.new(0, 50, 0, 20)
    ValueBox.Position = UDim2.new(1, -60, 0, 5)
    ValueBox.BackgroundColor3 = Theme:GetColor("Background")
    ValueBox.BorderSizePixel = 0
    ValueBox.Text = tostring(Value)
    ValueBox.TextColor3 = Theme:GetColor("Text")
    ValueBox.TextSize = 12
    ValueBox.Font = Enum.Font.GothamBold
    ValueBox.Parent = SliderFrame
    
    Instance.new("UICorner", ValueBox).CornerRadius = UDim.new(0, 4)
    
    -- Slider Background
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -20, 0, 8)
    SliderBg.Position = UDim2.new(0, 10, 0, 32)
    SliderBg.BackgroundColor3 = Theme:GetColor("Background")
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = SliderFrame
    
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)
    
    -- Fill
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme:GetColor("Accent")
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg
    
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    
    -- Knob
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(1, -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.BorderSizePixel = 0
    Knob.Parent = Fill
    
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local Dragging = false
    
    local function UpdateSlider(Input)
        local Scale = math.clamp((Input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
        local NewValue = Min + (Max - Min) * Scale
        
        if Config.Increment then
            NewValue = math.floor(NewValue / Config.Increment + 0.5) * Config.Increment
        end
        
        NewValue = math.clamp(NewValue, Min, Max)
        Value = NewValue
        
        SaveManager:Set(Flag, Value)
        ValueBox.Text = tostring(math.floor(Value * 100) / 100) .. (Config.Suffix or "")
        Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
        
        if Config.Callback then
            task.spawn(Config.Callback, Value)
        end
    end
    
    SliderBg.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            UpdateSlider(Input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(Input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    ValueBox.FocusLost:Connect(function()
        local Num = tonumber(ValueBox.Text)
        if Num then
            Value = math.clamp(Num, Min, Max)
            SaveManager:Set(Flag, Value)
            ValueBox.Text = tostring(Value)
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            if Config.Callback then
                task.spawn(Config.Callback, Value)
            end
        end
    end)
    
    return {
        Instance = SliderFrame,
        SetValue = function(NewValue)
            Value = math.clamp(NewValue, Min, Max)
            SaveManager:Set(Flag, Value)
            ValueBox.Text = tostring(Value)
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            if Config.Callback then
                task.spawn(Config.Callback, Value)
            end
        end,
        GetValue = function() return Value end
    }
end

function Window:CreateDropdown(Section, Config)
    Config = Config or {}
    local Flag = Config.Flag or (Config.Name or "Dropdown") .. "_Value"
    local Options = Config.Options or {}
    local Selected = SaveManager:Get(Flag, Config.Default or (Options[1] or ""))
    local Open = false
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    DropdownFrame.BackgroundColor3 = Theme:GetColor("Tertiary")
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = Section.ElementContainer
    
    Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)
    
    -- Header
    local Header = Instance.new("TextButton")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Theme:GetColor("Tertiary")
    Header.Text = ""
    Header.AutoButtonColor = false
    Header.Parent = DropdownFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Name or "Dropdown"
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local SelectedLabel = Instance.new("TextLabel")
    SelectedLabel.Size = UDim2.new(0, 80, 1, 0)
    SelectedLabel.Position = UDim2.new(1, -100, 0, 0)
    SelectedLabel.BackgroundTransparency = 1
    SelectedLabel.Text = tostring(Selected)
    SelectedLabel.TextColor3 = Theme:GetColor("SubText")
    SelectedLabel.TextSize = 12
    SelectedLabel.Font = Enum.Font.Gotham
    SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    SelectedLabel.Parent = Header
    
    -- Arrow
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 0, 20)
    Arrow.Position = UDim2.new(1, -25, 0.5, -10)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Theme:GetColor("SubText")
    Arrow.TextSize = 14
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = Header
    
    -- Options Frame
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1, -20, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 10, 0, 45)
    OptionsFrame.BackgroundColor3 = Theme:GetColor("Background")
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.Parent = DropdownFrame
    
    Instance.new("UICorner", OptionsFrame).CornerRadius = UDim.new(0, 6)
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.Padding = UDim.new(0, 2)
    OptionsList.Parent = OptionsFrame
    
    local function BuildOptions()
        for _, Child in ipairs(OptionsFrame:GetChildren()) do
            if Child:IsA("TextButton") then Child:Destroy() end
        end
        
        for _, Option in ipairs(Options) do
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 30)
            Btn.BackgroundColor3 = Theme:GetColor("Background")
            Btn.Text = Option
            Btn.TextColor3 = Theme:GetColor("Text")
            Btn.TextSize = 13
            Btn.Font = Enum.Font.Gotham
            Btn.Parent = OptionsFrame
            
            if Option == Selected then
                Btn.TextColor3 = Theme:GetColor("Accent")
                local Check = Instance.new("TextLabel")
                Check.Size = UDim2.new(0, 20, 0, 20)
                Check.Position = UDim2.new(1, -25, 0.5, -10)
                Check.BackgroundTransparency = 1
                Check.Text = "✓"
                Check.TextColor3 = Theme:GetColor("Accent")
                Check.TextSize = 14
                Check.Font = Enum.Font.GothamBold
                Check.Parent = Btn
            end
            
            Btn.MouseEnter:Connect(function()
                Tween:Create(Btn, {BackgroundColor3 = Theme:GetColor("Tertiary")}, 0.15)
            end)
            
            Btn.MouseLeave:Connect(function()
                Tween:Create(Btn, {BackgroundColor3 = Theme:GetColor("Background")}, 0.15)
            end)
            
            Btn.MouseButton1Click:Connect(function()
                Selected = Option
                SaveManager:Set(Flag, Selected)
                SelectedLabel.Text = tostring(Selected)
                ToggleDropdown()
                if Config.Callback then
                    task.spawn(Config.Callback, Selected)
                end
            end)
        end
        
        local Height = math.min(#Options * 32, 150)
        OptionsFrame.Size = UDim2.new(1, -20, 0, Height)
    end
    
    local function ToggleDropdown()
        Open = not Open
        if Open then
            OptionsFrame.Visible = true
            BuildOptions()
            Tween:Create(Arrow, {Rotation = 180}, 0.2)
            Tween:Create(DropdownFrame, {Size = UDim2.new(1, 0, 0, 50 + OptionsFrame.Size.Y.Offset)}, 0.2)
        else
            Tween:Create(Arrow, {Rotation = 0}, 0.2)
            Tween:Create(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2).Completed:Connect(function()
                OptionsFrame.Visible = false
            end)
        end
    end
    
    Header.MouseButton1Click:Connect(ToggleDropdown)
    
    return {
        Instance = DropdownFrame,
        SetOptions = function(NewOptions)
            Options = NewOptions
            if Open then BuildOptions() end
        end
    }
end

function Window:CreateInput(Section, Config)
    Config = Config or {}
    local Flag = Config.Flag or (Config.Name or "Input") .. "_Value"
    local Value = SaveManager:Get(Flag, Config.Default or "")
    
    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(1, 0, 0, 65)
    InputFrame.BackgroundColor3 = Theme:GetColor("Tertiary")
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = Section.ElementContainer
    
    Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 6)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = Config.Name or "Input"
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = InputFrame
    
    -- Input Box
    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(1, -20, 0, 28)
    InputBox.Position = UDim2.new(0, 10, 0, 32)
    InputBox.BackgroundColor3 = Theme:GetColor("Background")
    InputBox.BorderSizePixel = 0
    InputBox.Text = tostring(Value)
    InputBox.PlaceholderText = Config.Placeholder or "Enter text..."
    InputBox.PlaceholderColor3 = Theme:GetColor("SubText")
    InputBox.TextColor3 = Theme:GetColor("Text")
    InputBox.TextSize = 13
    InputBox.Font = Enum.Font.Gotham
    InputBox.ClearTextOnFocus = false
    InputBox.Parent = InputFrame
    
    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.Parent = InputBox
    
    InputBox.Focused:Connect(function()
        Tween:Create(InputBox, {BackgroundColor3 = Theme:GetColor("Secondary")}, 0.2)
    end)
    
    InputBox.FocusLost:Connect(function()
        Tween:Create(InputBox, {BackgroundColor3 = Theme:GetColor("Background")}, 0.2)
        
        local Text = InputBox.Text
        if Config.Numeric then
            local Num = tonumber(Text)
            if Num then
                Value = Num
                SaveManager:Set(Flag, Value)
                if Config.Callback then task.spawn(Config.Callback, Value) end
            else
                InputBox.Text = tostring(Value)
            end
        else
            Value = Text
            SaveManager:Set(Flag, Value)
            if Config.Callback then task.spawn(Config.Callback, Value) end
        end
    end)
    
    return {
        Instance = InputFrame,
        SetValue = function(NewValue)
            Value = NewValue
            InputBox.Text = tostring(Value)
            SaveManager:Set(Flag, Value)
            if Config.Callback then task.spawn(Config.Callback, Value) end
        end,
        GetValue = function() return Value end
    }
end

function Window:CreateDivider(Section)
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -20, 0, 2)
    Divider.Position = UDim2.new(0, 10, 0, 0)
    Divider.BackgroundColor3 = Theme:GetColor("Border")
    Divider.BorderSizePixel = 0
    Divider.Parent = Section.ElementContainer
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    Gradient.Parent = Divider
    
    return {Instance = Divider}
end

function Window:Minimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        Tween:Create(self.Main, {Size = UDim2.new(0, self.Main.Size.X.Offset, 0, 45)}, 0.3)
        self.Content.Visible = false
        self.Sidebar.Visible = false
    else
        Tween:Create(self.Main, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
        task.delay(0.3, function()
            self.Content.Visible = true
            self.Sidebar.Visible = true
        end)
    end
end

function Window:Destroy()
    Tween:Create(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3).Completed:Connect(function()
        self.GUI:Destroy()
    end)
end

-- ==========================================
-- LIBRARY FUNCTIONS
-- ==========================================

function NexusUI:CreateWindow(Config)
    local Window = Window:Create(Config)
    table.insert(self.Windows, Window)
    return Window
end

function NexusUI:Notify(Data)
    NotificationSystem:Notify(Data)
end

function NexusUI:Destroy()
    for _, Window in ipairs(self.Windows) do
        if Window.GUI then
            Window.GUI:Destroy()
        end
    end
    self.Windows = {}
end

function NexusUI:SetTheme(ThemeName)
    return Theme:SetTheme(ThemeName)
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
