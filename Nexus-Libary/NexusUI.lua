--[[
    NEXUS STANDALONE v10
    - Top-Bar Controls (Minimize & Close)
    - Floating Image Toggle (ID: 92090613790936)
    - Enhanced Glassmorphism & Lucide Icons
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

--// Configuration
local CONFIG = {
    Name = "NEXUS HUB",
    Key = "NEXUS-2026",
    KeyLink = "https://discord.gg/nexus",
    SavePath = "Nexus_SaveData.json",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(10, 10, 10),
    SidebarColor = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(30, 30, 30),
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936",
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(170, 170, 170)
}

--// Utility
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function Tween(obj, props, t)
    local info = TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TS:Create(obj, info, props):Play()
end

--// UI Container
local ScreenGui = Create("ScreenGui", {
    Name = "Nexus_Interface",
    Parent = (gethui and gethui()) or CoreGui,
    ResetOnSpawn = false
})

--// FLOATING TOGGLE BUTTON
local ToggleButton = Create("ImageButton", {
    Parent = ScreenGui, Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.05, 0, 0.5, -25), BackgroundColor3 = CONFIG.BG,
    Image = CONFIG.ToggleImage, Visible = false, BackgroundTransparency = 0.2,
    ZIndex = 100
})
Create("UICorner", {Parent = ToggleButton, CornerRadius = UDim.new(1, 0)})
Create("UIStroke", {Parent = ToggleButton, Color = CONFIG.Accent, Thickness = 2})

--// NOTIFICATION SYSTEM
local NotifyHolder = Create("Frame", {
    Parent = ScreenGui, Size = UDim2.new(0, 250, 1, 0),
    Position = UDim2.new(1, -260, 0, 0), BackgroundTransparency = 1
})
Create("UIListLayout", {Parent = NotifyHolder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 10)})

local function Notify(title, desc)
    local Box = Create("Frame", {Parent = NotifyHolder, Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = CONFIG.BG, BackgroundTransparency = 0.1, ClipsDescendants = true})
    Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Box, Color = CONFIG.Accent, Thickness = 1.2})
    Create("TextLabel", {Parent = Box, Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = CONFIG.Text, Position = UDim2.new(0, 12, 0, 8), BackgroundTransparency = 1})
    Create("TextLabel", {Parent = Box, Text = desc, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = CONFIG.DarkText, Position = UDim2.new(0, 12, 0, 24), Size = UDim2.new(1, -20, 0, 30), BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = 0})
    Tween(Box, {Size = UDim2.new(1, 0, 0, 65)})
    task.delay(5, function() Tween(Box, {Size = UDim2.new(1, 0, 0, 0)}) task.wait(0.3) Box:Destroy() end)
end

--// MAIN HUB SETUP
local function OpenMainHub()
    local Main = Create("Frame", {
        Name = "MainHub", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        BackgroundTransparency = CONFIG.MainTransparency, Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200), ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(60, 60, 60), Thickness = 1.2})
    
    -- TOP BAR BUTTONS (Minimize & Close)
    local Controls = Create("Frame", {
        Parent = Main, Size = UDim2.new(0, 70, 0, 30), 
        Position = UDim2.new(1, -75, 0, 5), BackgroundTransparency = 1, ZIndex = 10
    })
    
    local CloseBtn = Create("TextButton", {
        Parent = Controls, Text = "X", Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 80, 80), BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(0.5, 0, 0, 0)
    })

    local MinBtn = Create("TextButton", {
        Parent = Controls, Text = "-", Font = Enum.Font.GothamBold, TextSize = 20,
        TextColor3 = CONFIG.Text, BackgroundTransparency = 1,
        Size = UDim2.new(0, 30, 1, 0), Position = UDim2.new(0, 0, 0, 0)
    })

    -- Logic for Buttons
    local function ToggleUI(state)
        if state == false then
            Tween(Main, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
            Main.Visible = false
            ToggleButton.Visible = true
            Tween(ToggleButton, {ImageTransparency = 0, BackgroundTransparency = 0.2})
        else
            Main.Visible = true
            ToggleButton.Visible = false
            Tween(Main, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = CONFIG.MainTransparency}, 0.3)
        end
    end

    MinBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    ToggleButton.MouseButton1Click:Connect(function() ToggleUI(true) end)

    -- SIDEBAR & CONTENT (Standard v9 Logic)
    local Sidebar = Create("Frame", {Parent = Main, BackgroundColor3 = CONFIG.SidebarColor, BackgroundTransparency = 0.1, Size = UDim2.new(0, 170, 1, 0)})
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 10)})
    
    local Title = Create("TextLabel", {Parent = Sidebar, Text = CONFIG.Name, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = CONFIG.Accent, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 30)})

    -- [Rest of the Sidebar / Tab Logic from v9 goes here]

    -- Final Setup
    local function MakeDraggable(frame)
        local drag, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = true; dragStart = input.Position; startPos = frame.Position end end)
        UIS.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and drag then local delta = input.Position - dragStart; frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
        UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
    end
    
    MakeDraggable(Main)
    Notify("Nexus Hub Officially Loaded", "Nexus is ready. Press '-' to minimize.")
end

-- Start
OpenMainHub()
