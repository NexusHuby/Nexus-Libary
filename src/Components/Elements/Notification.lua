local NotificationModule = {}
NotificationModule.__index = NotificationModule

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Tween.lua"))()
local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/LucideIcons.lua"))()

local Notifications = {}
local NotificationGui = nil

function NotificationModule:Init()
    if NotificationGui then return end
    
    NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "Notifications"
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationGui.Parent = game:GetService("CoreGui")
    
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(0, 300, 1, -20)
    self.Container.Position = UDim2.new(1, -320, 0, 10)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = NotificationGui
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ListLayout.Parent = self.Container
end

function NotificationModule:Create(Data, Theme)
    self:Init()
    
    Data = Data or {}
    local Title = Data.Title or "Notification"
    local Content = Data.Content or ""
    local Duration = Data.Duration or 3
    local Type = Data.Type or "Info" -- Info, Success, Warning, Error
    
    local Colors = {
        Info = Theme:GetColor("Accent"),
        Success = Theme:GetColor("Success"),
        Warning = Theme:GetColor("Warning"),
        Error = Theme:GetColor("Error")
    }
    
    local Icons = {
        Info = "info",
        Success = "check",
        Warning = "alert-triangle",
        Error = "alert-circle"
    }
    
    -- Container
    local Notif = Instance.new("Frame")
    Notif.Name = "Notification"
    Notif.Size = UDim2.new(0, 280, 0, 80)
    Notif.BackgroundColor3 = Theme:GetColor("Secondary")
    Notif.BorderSizePixel = 0
    Notif.ClipsDescendants = true
    Notif.Parent = self.Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notif
    
    -- Accent Bar
    local Bar = Instance.new("Frame")
    Bar.Name = "Accent"
    Bar.Size = UDim2.new(0, 4, 1, 0)
    Bar.BackgroundColor3 = Colors[Type]
    Bar.BorderSizePixel = 0
    Bar.Parent = Notif
    
    -- Icon
    local Icon = LucideIcons:CreateIcon(Icons[Type], Notif, UDim2.new(0, 24, 0, 24), Colors[Type])
    Icon.Position = UDim2.new(0, 15, 0, 15)
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
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
    ContentLabel.Name = "Content"
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
    
    -- Progress Bar
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new(1, 0, 0, 3)
    Progress.Position = UDim2.new(0, 0, 1, -3)
    Progress.BackgroundColor3 = Colors[Type]
    Progress.BorderSizePixel = 0
    Progress.Parent = Notif
    
    -- Entrance Animation
    Notif.Position = UDim2.new(1, 0, 0, 0)
    Tween:Create(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Quart)
    
    -- Progress Animation
    Tween:Create(Progress, {Size = UDim2.new(0, 0, 0, 3)}, Duration, Enum.EasingStyle.Linear)
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -25, 0, 10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Theme:GetColor("SubText")
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Notif
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:Close(Notif)
    end)
    
    -- Auto close
    task.delay(Duration, function()
        if Notif and Notif.Parent then
            self:Close(Notif)
        end
    end)
    
    return Notif
end

function NotificationModule:Close(Notif)
    Tween:Create(Notif, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.3).Completed:Connect(function()
        Notif:Destroy()
    end)
end

return NotificationModule
