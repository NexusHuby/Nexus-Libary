--[[
    NEXUS STANDALONE v9
    - Integrated Notification System
    - Lucide Icon Support (via Asset IDs)
    - Transparency: 0.08 with Acrylic Strokes
    - Enhanced Tab Switching with Glow
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
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(170, 170, 170)
}

--// Icon Map (Lucide-inspired Asset IDs)
local ICONS = {
    Home = "rbxassetid://10734705037",
    Combat = "rbxassetid://10734771039",
    Visuals = "rbxassetid://10723343391",
    Misc = "rbxassetid://10723346959",
    Settings = "rbxassetid://10723354435",
    Info = "rbxassetid://10723346158"
}

--// Utility
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function Tween(obj, props, t)
    local info = TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TS:Create(obj, info, props)
    tween:Play()
    return tween
end

--// UI Container
local ScreenGui = Create("ScreenGui", {
    Name = "Nexus_Interface",
    Parent = (gethui and gethui()) or CoreGui,
    ResetOnSpawn = false
})

--// NOTIFICATION SYSTEM
local NotifyHolder = Create("Frame", {
    Parent = ScreenGui, Size = UDim2.new(0, 250, 1, 0),
    Position = UDim2.new(1, -260, 0, 0), BackgroundTransparency = 1
})
local NotifyLayout = Create("UIListLayout", {
    Parent = NotifyHolder, VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 10)
})

local function Notify(title, desc)
    local Box = Create("Frame", {
        Parent = NotifyHolder, Size = UDim2.new(1, 0, 0, 0), -- Starts invisible for animation
        BackgroundColor3 = CONFIG.BG, BackgroundTransparency = 0.1, ClipsDescendants = true
    })
    Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Box, Color = CONFIG.Accent, Thickness = 1.2})

    local TLine = Create("Frame", {
        Parent = Box, Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = CONFIG.Accent
    })

    local TText = Create("TextLabel", {
        Parent = Box, Text = title, Font = Enum.Font.GothamBold, TextSize = 13,
        TextColor3 = CONFIG.Text, Position = UDim2.new(0, 12, 0, 8), BackgroundTransparency = 1
    })
    local DText = Create("TextLabel", {
        Parent = Box, Text = desc, Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = CONFIG.DarkText, Position = UDim2.new(0, 12, 0, 24), 
        Size = UDim2.new(1, -20, 0, 30), BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = 0
    })

    -- Animate In
    Tween(Box, {Size = UDim2.new(1, 0, 0, 65)})
    
    task.delay(5, function()
        Tween(Box, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1})
        task.wait(0.3)
        Box:Destroy()
    end)
end

--// GLOBAL DRAG & RESIZE
local function MakeWindow(frame)
    local dragging, dragStart, startPos
    local resizing, resizeStartSize, resizeStartPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)

    local ResizeHandle = Create("Frame", {
        Parent = frame, Name = "ResizeHandle",
        Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(1, -25, 1, -25),
        BackgroundTransparency = 1, ZIndex = 30
    })
    
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif resizing then
                local delta = input.Position - resizeStartPos
                frame.Size = UDim2.new(0, math.max(500, resizeStartSize.X.Offset + delta.X), 0, math.max(350, resizeStartSize.Y.Offset + delta.Y))
            end
        end
    end)

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; resizeStartPos = input.Position; resizeStartSize = frame.Size
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false; resizing = false
        end
    end)
end

--// MAIN HUB
local function OpenMainHub()
    local Main = Create("Frame", {
        Name = "MainHub", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        BackgroundTransparency = CONFIG.MainTransparency,
        Size = UDim2.new(0, 600, 0, 400), Position = UDim2.new(0.5, -300, 0.5, -200),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(50, 50, 50), Thickness = 1.2})
    
    local Sidebar = Create("Frame", {
        Name = "Sidebar", Parent = Main, BackgroundColor3 = CONFIG.SidebarColor,
        BackgroundTransparency = 0.1, Size = UDim2.new(0, 170, 1, 0)
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 10)})
    
    local Title = Create("TextLabel", {
        Parent = Sidebar, Text = CONFIG.Name, Font = Enum.Font.GothamBold, TextSize = 16,
        TextColor3 = CONFIG.Accent, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 30)
    })

    local TabScroll = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 70),
        Size = UDim2.new(1, -20, 1, -130), ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0), 
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    Create("UIListLayout", {Parent = TabScroll, Padding = UDim.new(0, 6)})

    local Pages = Create("Frame", {
        Name = "Pages", Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 185, 0, 20), Size = UDim2.new(1, -200, 1, -40)
    })

    -- TABS SYSTEM
    local Tabs = {}
    local FirstTab = nil

    function AddTab(name, icon)
        local Page = Create("ScrollingFrame", {
            Parent = Pages, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
            Visible = false, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 10)})

        local TabBtn = Create("TextButton", {
            Parent = TabScroll, Text = "      " .. name, Font = Enum.Font.GothamMedium, TextSize = 13,
            TextColor3 = CONFIG.DarkText, BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Size = UDim2.new(1, 0, 0, 36), TextXAlignment = Enum.TextXAlignment.Left
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
        local IconImg = Create("ImageLabel", {
            Parent = TabBtn, BackgroundTransparency = 1, Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 8, 0.5, -9), Image = icon or ICONS.Info, ImageColor3 = CONFIG.DarkText
        })

        local function Activate()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                Tween(t.Btn, {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = CONFIG.DarkText})
                Tween(t.Icon, {ImageColor3 = CONFIG.DarkText})
            end
            Page.Visible = true
            Tween(TabBtn, {BackgroundColor3 = CONFIG.Accent, TextColor3 = CONFIG.Text})
            Tween(IconImg, {ImageColor3 = CONFIG.Text})
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        Tabs[name] = {Page = Page, Btn = TabBtn, Icon = IconImg}
        if not FirstTab then FirstTab = Activate end
        return Page
    end

    -- POPULATE
    AddTab("Home", ICONS.Home)
    AddTab("Combat", ICONS.Combat)
    AddTab("Visuals", ICONS.Visuals)
    AddTab("Misc", ICONS.Misc)

    MakeWindow(Main)
    FirstTab()
    
    -- Final Load Sequence
    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, {Size = UDim2.new(0, 600, 0, 400)})
    
    -- NOTIFICATION ON LOAD
    task.wait(0.5)
    Notify("Nexus Hub Officially Loaded", "Nexus has loaded, ready to use.")
end

--// RUN (Check key then open)
local function Init()
    if isfile and isfile(CONFIG.SavePath) and readfile(CONFIG.SavePath) == CONFIG.Key then
        OpenMainHub()
    else
        -- Show Key System (Re-use v8 Key logic here)
        OpenMainHub() -- For now, skip to hub for testing
    end
end

Init()
