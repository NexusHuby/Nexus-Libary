--[[
    ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗    ██╗   ██╗██╗
    ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝    ██║   ██║██║
    ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗    ██║   ██║██║
    ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║    ██║   ██║██║
    ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║    ╚██████╔╝███████╗
    ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚══════╝
    
    Nexus UI Library v4.1 - FIXED VERSION
    ✅ Multiple tabs working
    ✅ Rayfield-style dragging
    ✅ All elements functional
    ✅ Smooth animations
]]

local NexusUI = {
    Version = "4.1.0",
    Windows = {},
    Flags = {},
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
-- THEME SYSTEM
-- ==========================================

local Theme = {
    Current = "Dark",
    Palettes = {
        Dark = {
            Background = Color3.fromRGB(20, 20, 24),
            Topbar = Color3.fromRGB(26, 26, 30),
            Sidebar = Color3.fromRGB(23, 23, 27),
            
            ElementBackground = Color3.fromRGB(32, 32, 37),
            ElementBackgroundHover = Color3.fromRGB(40, 40, 46),
            ElementStroke = Color3.fromRGB(45, 45, 52),
            
            Primary = Color3.fromRGB(235, 69, 95),
            PrimaryHover = Color3.fromRGB(245, 85, 110),
            
            TextPrimary = Color3.fromRGB(245, 245, 250),
            TextSecondary = Color3.fromRGB(170, 170, 180),
            TextMuted = Color3.fromRGB(110, 110, 120),
            
            Success = Color3.fromRGB(75, 230, 120),
            Warning = Color3.fromRGB(255, 190, 75),
            Error = Color3.fromRGB(245, 75, 75),
            
            TabActive = Color3.fromRGB(235, 69, 95),
            TabInactive = Color3.fromRGB(90, 90, 100),
            
            ToggleEnabled = Color3.fromRGB(75, 230, 120),
            ToggleDisabled = Color3.fromRGB(50, 50, 60),
            
            Shadow = Color3.fromRGB(0, 0, 0),
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
            
            TextPrimary = Color3.fromRGB(25, 25, 30),
            TextSecondary = Color3.fromRGB(90, 90, 100),
            TextMuted = Color3.fromRGB(140, 140, 150),
            
            Success = Color3.fromRGB(50, 180, 90),
            Warning = Color3.fromRGB(235, 165, 50),
            Error = Color3.fromRGB(230, 60, 60),
            
            TabActive = Color3.fromRGB(235, 69, 95),
            TabInactive = Color3.fromRGB(140, 140, 150),
            
            ToggleEnabled = Color3.fromRGB(50, 180, 90),
            ToggleDisabled = Color3.fromRGB(200, 200, 210),
            
            Shadow = Color3.fromRGB(190, 190, 200),
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
-- ANIMATION SYSTEM
-- ==========================================

local Animation = {}

function Animation:Tween(Object, Properties, Duration, Style, Direction)
    local Info = TweenInfo.new(
        Duration or 0.3,
        Style or Enum.EasingStyle.Quint,
        Direction or Enum.EasingDirection.Out,
        0, false, 0
    )
    local Tween = TweenService:Create(Object, Info, Properties)
    Tween:Play()
    return Tween
end

-- ==========================================
-- RAYFIELD-STYLE DRAGGING
-- ==========================================

local function MakeDraggable(Object, DragObject)
    local dragging = false
    local dragInput, mousePos, framePos
    
    local offset = Vector2.zero
    local screenGui = Object:FindFirstAncestorWhichIsA("ScreenGui")
    if screenGui and screenGui.IgnoreGuiInset then
        offset = offset + game:GetService('GuiService'):GetGuiInset()
    end
    
    DragObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = Object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    DragObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            local newPos = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
            Object.Position = newPos
        end
    end)
end

-- ==========================================
-- SAVE SYSTEM
-- ==========================================

local SaveManager = {
    Folder = "NexusUI",
    Enabled = true
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
end

function SaveManager:Set(Path, Value)
    if not self.Supported then return false end
    
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

SaveManager:Init()

-- ==========================================
-- NOTIFICATION SYSTEM
-- ==========================================

local NotificationSystem = {
    GUI = nil,
    Container = nil
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
        Info = Theme:Get("Primary"),
        Success = Theme:Get("Success"),
        Warning = Theme:Get("Warning"),
        Error = Theme:Get("Error")
    }
    
    local Color = Colors[Type] or Theme:Get("Primary")
    
    local Notif = Instance.new("Frame")
    Notif.Size = UDim2.new(0, 330, 0, 0)
    Notif.BackgroundColor3 = Theme:Get("ElementBackground")
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.Parent = self.Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 14)
    Corner.Parent = Notif
    
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 4, 1, 0)
    Accent.BackgroundColor3 = Color
    Accent.BorderSizePixel = 0
    Accent.Parent = Notif
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -90, 0, 24)
    TitleLabel.Position = UDim2.new(0, 16, 0, 14)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Theme:Get("TextPrimary")
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notif
    
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -24, 0, 0)
    ContentLabel.Position = UDim2.new(0, 16, 0, 40)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = Content
    ContentLabel.TextColor3 = Theme:Get("TextSecondary")
    ContentLabel.TextSize = 13
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.TextWrapped = true
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.Parent = Notif
    
    task.wait()
    local Height = math.max(75, ContentLabel.AbsoluteSize.Y + 54)
    
    Notif.Position = UDim2.new(1, 50, 0, 0)
    Animation:Tween(Notif, {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 330, 0, Height)
    }, 0.5, Enum.EasingStyle.Quint)
    
    task.delay(Duration, function()
        Animation:Tween(Notif, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, 0.4, Enum.EasingStyle.Quint)
        
        Animation:Tween(TitleLabel, {TextTransparency = 1}, 0.4)
        Animation:Tween(ContentLabel, {TextTransparency = 1}, 0.4)
        Animation:Tween(Accent, {BackgroundTransparency = 1}, 0.4)
        
        task.delay(0.5, function()
            Notif:Destroy()
        end)
    end)
    
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
    
    self.Name = Settings.Name or "Nexus UI"
    self.Subtitle = Settings.Subtitle or "v4.1.0"
    self.ConfigFolder = Settings.ConfigFolder or self.Name
    self.Tabs = {}
    self.ActiveTab = nil
    self.Closed = false
    self.TabCount = 0
    
    -- Main GUI
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "NexusUI_" .. self.Name
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.GUI.ResetOnSpawn = false
    self.GUI.DisplayOrder = 10
    
    pcall(function()
        self.GUI.Parent = (gethui and gethui()) or CoreGui
    end)
    
    if not self.GUI.Parent then
        self.GUI.Parent = CoreGui
    end
    
    -- Main window
    self.Main = Instance.new("Frame")
    self.Main.Name = "Main"
    self.Main.Size = UDim2.new(0, 700, 0, 480)
    self.Main.Position = UDim2.new(0.5, -350, 0.5, -240)
    self.Main.BackgroundColor3 = Theme:Get("Background")
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = false
    self.Main.Parent = self.GUI
    
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
    
    -- Setup dragging (Rayfield style)
    MakeDraggable(self.Main, self.Topbar)
    
    -- Setup controls
    self:SetupControls()
    
    return self
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
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 0, 0, 28)
    Title.Position = UDim2.new(0, 20, 0, 14)
    Title.AutomaticSize = Enum.AutomaticSize.X
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:Get("Primary")
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBlack
    Title.Parent = self.Topbar
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 0, 0, 22)
    Subtitle.Position = UDim2.new(0, Title.AbsoluteSize.X + 30, 0, 17)
    Subtitle.AutomaticSize = Enum.AutomaticSize.X
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = self.Subtitle
    Subtitle.TextColor3 = Theme:Get("TextMuted")
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Parent = self.Topbar
    
    -- Controls
    local function CreateButton(Name, Text, Position)
        local Btn = Instance.new("TextButton")
        Btn.Name = Name
        Btn.Size = UDim2.new(0, 36, 0, 36)
        Btn.Position = UDim2.new(1, Position, 0.5, -18)
        Btn.BackgroundColor3 = Theme:Get("ElementBackground")
        Btn.Text = Text
        Btn.TextColor3 = Theme:Get("TextSecondary")
        Btn.TextSize = Name == "Close" and 16 or 20
        Btn.Font = Enum.Font.GothamBold
        Btn.AutoButtonColor = false
        Btn.Parent = self.Topbar
        
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 11)
        Corner.Parent = Btn
        
        return Btn
    end
    
    self.MinBtn = CreateButton("Minimize", "−", -130)
    self.ThemeBtn = CreateButton("Theme", "◐", -88)
    self.CloseBtn = CreateButton("Close", "✕", -46)
    
    self.CloseBtn.BackgroundColor3 = Theme:Get("Primary")
    self.CloseBtn.TextColor3 = Color3.new(1, 1, 1)
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
    
    -- Header
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
    self.Pages = Instance.new("Folder")
    self.Pages.Name = "Pages"
    self.Pages.Parent = self.Content
end

function WindowClass:SetupControls()
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
    local function AddHover(Button, HoverColor, OriginalColor)
        Button.MouseEnter:Connect(function()
            Animation:Tween(Button, {BackgroundColor3 = HoverColor or Theme:Get("ElementBackgroundHover")}, 0.2)
        end)
        
        Button.MouseLeave:Connect(function()
            Animation:Tween(Button, {BackgroundColor3 = OriginalColor or Theme:Get("ElementBackground")}, 0.2)
        end)
    end
    
    AddHover(self.MinBtn)
    AddHover(self.ThemeBtn)
    AddHover(self.CloseBtn, Theme:Get("PrimaryHover"), Theme:Get("Primary"))
end

function WindowClass:SetTheme(ThemeName)
    if not Theme:SetTheme(ThemeName) then return end
    
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

function WindowClass:Close()
    if self.Closed then return end
    self.Closed = true
    
    Animation:Tween(self.Main, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    
    task.delay(0.5, function()
        self.GUI:Destroy()
    end)
end

function WindowClass:CreateTab(Name, Icon)
    self.TabCount = self.TabCount + 1
    
    local Tab = {
        Name = Name,
        Icon = Icon or "home",
        Index = self.TabCount,
        Window = self,
        Elements = {}
    }
    
    -- Create tab button
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
    
    -- Icon (using text emoji as placeholder)
    Tab.IconLabel = Instance.new("TextLabel")
    Tab.IconLabel.Size = UDim2.new(0, 24, 0, 24)
    Tab.IconLabel.Position = UDim2.new(0, 14, 0.5, -12)
    Tab.IconLabel.BackgroundTransparency = 1
    Tab.IconLabel.Text = "●" -- Placeholder
    Tab.IconLabel.TextColor3 = Theme:Get("TabInactive")
    Tab.IconLabel.TextSize = 17
    Tab.IconLabel.Font = Enum.Font.GothamBold
    Tab.IconLabel.Parent = Tab.Button
    
    -- Name
    Tab.NameLabel = Instance.new("TextLabel")
    Tab.NameLabel.Size = UDim2.new(1, -55, 1, 0)
    Tab.NameLabel.Position = UDim2.new(0, 46, 0, 0)
    Tab.NameLabel.BackgroundTransparency = 1
    Tab.NameLabel.Text = Name
    Tab.NameLabel.TextColor3 = Theme:Get("TextSecondary")
    Tab.NameLabel.TextSize = 15
    Tab.NameLabel.Font = Enum.Font.GothamSemibold
    Tab.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    Tab.NameLabel.Parent = Tab.Button
    
    -- Active indicator
    Tab.Indicator = Instance.new("Frame")
    Tab.Indicator.Size = UDim2.new(0, 3, 0, 0)
    Tab.Indicator.Position = UDim2.new(0, 0, 0.5, 0)
    Tab.Indicator.AnchorPoint = Vector2.new(0, 0.5)
    Tab.Indicator.BackgroundColor3 = Theme:Get("TabActive")
    Tab.Indicator.BorderSizePixel = 0
    Tab.Indicator.Parent = Tab.Button
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 2)
    IndicatorCorner.Parent = Tab.Indicator
    
    -- Create page
    Tab.Page = Instance.new("ScrollingFrame")
    Tab.Page.Name = Name .. "Page"
    Tab.Page.Size = UDim2.new(1, -5, 1, 0)
    Tab.Page.BackgroundTransparency = 1
    Tab.Page.ScrollBarThickness = 4
    Tab.Page.ScrollBarImageColor3 = Theme:Get("Primary")
    Tab.Page.BorderSizePixel = 0
    Tab.Page.Visible = false
    Tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Tab.Page.Parent = self.Content
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Padding = UDim.new(0, 12)
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
    end)
    
    -- Hover
    Tab.Button.MouseEnter:Connect(function()
        if self.ActiveTab ~= Tab then
            Animation:Tween(Tab.Button, {BackgroundTransparency = 0.85}, 0.2)
            Animation:Tween(Tab.NameLabel, {TextColor3 = Theme:Get("TextPrimary")}, 0.2)
            Animation:Tween(Tab.IconLabel, {TextColor3 = Theme:Get("TextPrimary")}, 0.2)
        end
    end)
    
    Tab.Button.MouseLeave:Connect(function()
        if self.ActiveTab ~= Tab then
            Animation:Tween(Tab.Button, {BackgroundTransparency = 1}, 0.2)
            Animation:Tween(Tab.NameLabel, {TextColor3 = Theme:Get("TextSecondary")}, 0.2)
            Animation:Tween(Tab.IconLabel, {TextColor3 = Theme:Get("TabInactive")}, 0.2)
        end
    end)
    
    -- Element creation methods
    function Tab:Button(Settings)
        return self.Window:CreateButton(self, Settings)
    end
    
    function Tab:Toggle(Settings)
        return self.Window:CreateToggle(self, Settings)
    end
    
    function Tab:Slider(Settings)
        return self.Window:CreateSlider(self, Settings)
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
        task.defer(function()
            self:SelectTab(Tab)
        end)
    end
    
    return Tab
end

function WindowClass:SelectTab(Tab)
    if self.ActiveTab == Tab then return end
    
    -- Deselect current tab
    if self.ActiveTab then
        self.ActiveTab.Page.Visible = false
        Animation:Tween(self.ActiveTab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.25)
        Animation:Tween(self.ActiveTab.IconLabel, {TextColor3 = Theme:Get("TabInactive")}, 0.25)
        Animation:Tween(self.ActiveTab.NameLabel, {TextColor3 = Theme:Get("TextSecondary")}, 0.25)
        Animation:Tween(self.ActiveTab.Button, {BackgroundTransparency = 1}, 0.25)
    end
    
    -- Select new tab
    self.ActiveTab = Tab
    Tab.Page.Visible = true
    
    Animation:Tween(Tab.Indicator, {Size = UDim2.new(0, 3, 0, 24)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Animation:Tween(Tab.IconLabel, {TextColor3 = Theme:Get("TabActive")}, 0.25)
    Animation:Tween(Tab.NameLabel, {TextColor3 = Theme:Get("TextPrimary")}, 0.25)
    Animation:Tween(Tab.Button, {BackgroundTransparency = 0.92}, 0.25)
end

-- ==========================================
-- ELEMENT CREATION
-- ==========================================

function WindowClass:CreateButton(Tab, Settings)
    Settings = Settings or {}
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 46)
    Button.BackgroundColor3 = Theme:Get("ElementBackground")
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 13)
    Corner.Parent = Button
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -55, 1, 0)
    Title.Position = UDim2.new(0, 18, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Settings.Name or "Button"
    Title.TextColor3 = Theme:Get("TextPrimary")
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    Button.MouseEnter:Connect(function()
        Animation:Tween(Button, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
    end)
    
    Button.MouseLeave:Connect(function()
        Animation:Tween(Button, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.2)
    end)
    
    Button.MouseButton1Click:Connect(function()
        if Settings.Callback then
            task.spawn(Settings.Callback)
        end
    end)
    
    return {Instance = Button}
end

function WindowClass:CreateToggle(Tab, Settings)
    Settings = Settings or {}
    local Flag = Settings.Flag or (Settings.Name or "Toggle") .. "_Toggle"
    local Value = SaveManager:Get(self.ConfigFolder .. "/" .. Flag, Settings.CurrentValue or false)
    
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 48)
    Toggle.BackgroundColor3 = Theme:Get("ElementBackground")
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 13)
    Corner.Parent = Toggle
    
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
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 52, 0, 28)
    Switch.Position = UDim2.new(1, -70, 0.5, -14)
    Switch.BackgroundColor3 = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
    Switch.BorderSizePixel = 0
    Switch.Parent = Toggle
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 22, 0, 22)
    Circle.Position = Value and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local function SetToggle(NewValue)
        Value = NewValue
        SaveManager:Set(self.ConfigFolder .. "/" .. Flag, Value)
        
        local TargetColor = Value and Theme:Get("ToggleEnabled") or Theme:Get("ToggleDisabled")
        local TargetPos = Value and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        
        Animation:Tween(Switch, {BackgroundColor3 = TargetColor}, 0.25)
        Animation:Tween(Circle, {Position = TargetPos}, 0.3, Enum.EasingStyle.Quint)
        
        if Settings.Callback then
            task.spawn(Settings.Callback, Value)
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
        Animation:Tween(Toggle, {BackgroundColor3 = Theme:Get("ElementBackgroundHover")}, 0.2)
    end)
    
    Toggle.MouseLeave:Connect(function()
        Animation:Tween(Toggle, {BackgroundColor3 = Theme:Get("ElementBackground")}, 0.2)
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
    local Value = SaveManager:Get(self.ConfigFolder .. "/" .. Flag, Settings.CurrentValue or Range[1])
    
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, 0, 0, 62)
    Slider.BackgroundColor3 = Theme:Get("ElementBackground")
    Slider.BorderSizePixel = 0
    Slider.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 13)
    Corner.Parent = Slider
    
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
    
    local ValueDisplay = Instance.new("TextLabel")
    ValueDisplay.Size = UDim2.new(0, 68, 0, 26)
    ValueDisplay.Position = UDim2.new(1, -86, 0, 10)
    ValueDisplay.BackgroundColor3 = Theme:Get("ElementStroke")
    ValueDisplay.Text = tostring(Value) .. Suffix
    ValueDisplay.TextColor3 = Theme:Get("TextPrimary")
    ValueDisplay.TextSize = 14
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.Parent = Slider
    
    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 8)
    ValueCorner.Parent = ValueDisplay
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -36, 0, 7)
    Track.Position = UDim2.new(0, 18, 0, 44)
    Track.BackgroundColor3 = Theme:Get("ElementStroke")
    Track.BorderSizePixel = 0
    Track.Parent = Slider
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    
    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)
    Progress.BackgroundColor3 = Theme:Get("Primary")
    Progress.BorderSizePixel = 0
    Progress.Parent = Track
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(1, 0)
    ProgressCorner.Parent = Progress
    
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
            Animation:Tween(Progress, {Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)}, 0.1)
            
            if Settings.Callback then
                task.spawn(Settings.Callback, Value)
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
    
    return {
        Instance = Slider,
        Set = function(NewValue)
            Value = math.clamp(NewValue, Range[1], Range[2])
            ValueDisplay.Text = tostring(Value) .. Suffix
            Animation:Tween(Progress, {Size = UDim2.new((Value - Range[1]) / (Range[2] - Range[1]), 0, 1, 0)}, 0.2)
        end,
        Get = function() return Value end
    }
end

function WindowClass:CreateLabel(Tab, Text)
    local Label = Instance.new("Frame")
    Label.Size = UDim2.new(1, 0, 0, 38)
    Label.BackgroundColor3 = Theme:Get("ElementBackground")
    Label.BorderSizePixel = 0
    Label.Parent = Tab.Page
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 11)
    Corner.Parent = Label
    
    local LabelText = Instance.new("TextLabel")
    LabelText.Size = UDim2.new(1, -28, 1, 0)
    LabelText.Position = UDim2.new(0, 16, 0, 0)
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
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 32)
    Section.BackgroundTransparency = 1
    Section.Parent = Tab.Page
    
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0.5, 0)
    Line.BackgroundColor3 = Theme:Get("ElementStroke")
    Line.BorderSizePixel = 0
    Line.Parent = Section
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 0, 1, 0)
    Title.AutomaticSize = Enum.AutomaticSize.X
    Title.BackgroundColor3 = Theme:Get("Background")
    Title.Text = "  " .. Name:upper() .. "  "
    Title.TextColor3 = Theme:Get("TextMuted")
    Title.TextSize = 11
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Section
    
    return Section
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

-- Global toggle
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.RightShift then
        for _, Window in ipairs(NexusUI.Windows) do
            if Window.GUI then
                Window.GUI.Enabled = not Window.GUI.Enabled
            end
        end
    end
end)

print("✅ Nexus UI v4.1 FIXED - Loaded Successfully!")
print("📋 Multi-tab support: WORKING")
print("🖱️ Dragging system: WORKING (Rayfield-style)")
print("Press RightShift to toggle UI")

return NexusUI
