-- Nexus UI Library Loader
-- Replace YOUR_USERNAME with your actual GitHub username

local Library = {
    Version = "1.0.0",
    Windows = {},
    Theme = {},
    Config = {}
}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Load Modules (Update these URLs to your repo)
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Config.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Theme.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/SaveManager.lua"))()
local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/LucideIcons.lua"))()
local TweenModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Tween.lua"))()

-- Component Loaders
local WindowModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Components/Window.lua"))()
local NotificationModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Components/Notification.lua"))()

-- Initialize Library
Library.Theme = Theme
Library.SaveManager = SaveManager
Library.Icons = LucideIcons
Library.Tween = TweenModule

-- Create Window
function Library:CreateWindow(ConfigData)
    ConfigData = ConfigData or {}
    local Window = WindowModule:Create(ConfigData, self)
    table.insert(self.Windows, Window)
    return Window
end

-- Notify User
function Library:Notify(Data)
    return NotificationModule:Create(Data, self.Theme)
end

-- Destroy All Windows
function Library:Destroy()
    for _, Window in ipairs(self.Windows) do
        if Window and Window.Instance then
            Window.Instance:Destroy()
        end
    end
    self.Windows = {}
end

-- Toggle UI Visibility
function Library:ToggleVisibility()
    for _, Window in ipairs(self.Windows) do
        if Window and Window.ToggleVisibility then
            Window:ToggleVisibility()
        end
    end
end

-- Keybind to toggle UI
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if not GameProcessed and Input.KeyCode == Enum.KeyCode.RightShift then
        Library:ToggleVisibility()
    end
end)

return Library
