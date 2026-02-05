--[[
    NEXUS STANDALONE v8
    - Transparency: 0.08 (Glassmorphism Style)
    - Fully Functional Tab System
    - Polished UIStrokes & Hover Effects
    - Smooth Global Drag/Resize
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
    MainTransparency = 0.08, -- AS REQUESTED
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
    TS:Create(obj, TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// UI Container
local ScreenGui = Create("ScreenGui", {
    Name = "Nexus_Interface",
    Parent = (gethui and gethui()) or CoreGui,
    ResetOnSpawn = false
})

--// SAVE & RESET
local function SaveKey(key) if writefile then writefile(CONFIG.SavePath, key) end end
local function GetSavedKey() if isfile and isfile(CONFIG.SavePath) then return readfile(CONFIG.SavePath) end return nil end
local function ResetKey() if isfile and isfile(CONFIG.SavePath) then delfile(CONFIG.SavePath) ScreenGui:Destroy() end end

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
    
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; resizeStartPos = input.Position; resizeStartSize = frame.Size
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif resizing then
                local delta = input.Position - resizeStartPos
                frame.Size = UDim2.new(0, math.max(480, resizeStartSize.X.Offset + delta.X), 0, math.max(320, resizeStartSize.Y.Offset + delta.Y))
            end
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
        Size = UDim2.new(0, 580, 0, 380), Position = UDim2.new(0.5, -290, 0.5, -190),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 12)})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(60, 60, 60), Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    
    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar", Parent = Main, BackgroundColor3 = CONFIG.SidebarColor,
        BackgroundTransparency = 0.2, Size = UDim2.new(0, 160, 1, 0)
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 12)})
    
    local Title = Create("TextLabel", {
        Parent = Sidebar, Text = CONFIG.Name, Font = Enum.Font.GothamBold, TextSize = 18,
        TextColor3 = CONFIG.Accent, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 30)
    })

    local TabScroll = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 70),
        Size = UDim2.new(1, -20, 1, -120), ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0), 
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    Create("UIListLayout", {Parent = TabScroll, Padding = UDim.new(0, 8)})

    -- Pages Container
    local Pages = Create("Frame", {
        Name = "Pages", Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 20), Size = UDim2.new(1, -190, 1, -40)
    })

    -- RESET BUTTON
    local ResetBtn = Create("TextButton", {
        Parent = Sidebar, Text = "Reset Session", Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 80, 80), BackgroundColor3 = Color3.fromRGB(40, 20, 20),
        Size = UDim2.new(0, 130, 0, 32), Position = UDim2.new(0.5, -65, 1, -50)
    })
    Create("UICorner", {Parent = ResetBtn, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = ResetBtn, Color = Color3.fromRGB(100, 40, 40), Thickness = 1})
    ResetBtn.MouseButton1Click:Connect(ResetKey)

    --// TAB SYSTEM LOGIC
    local Tabs = {}
    local FirstTab = nil

    function AddTab(name)
        local Page = Create("ScrollingFrame", {
            Name = name .. "_Page", Parent = Pages, BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 0,
            CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 10)})

        local TabBtn = Create("TextButton", {
            Parent = TabScroll, Text = name, Font = Enum.Font.GothamMedium, TextSize = 13,
            TextColor3 = CONFIG.DarkText, BackgroundColor3 = CONFIG.Secondary,
            Size = UDim2.new(1, 0, 0, 34), AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})
        local TabStroke = Create("UIStroke", {Parent = TabBtn, Color = Color3.fromRGB(50, 50, 50), Thickness = 1})

        local function Activate()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                Tween(t.Btn, {BackgroundColor3 = CONFIG.Secondary, TextColor3 = CONFIG.DarkText})
                Tween(t.Stroke, {Color = Color3.fromRGB(50, 50, 50)})
            end
            Page.Visible = true
            Tween(TabBtn, {BackgroundColor3 = CONFIG.Accent, TextColor3 = CONFIG.Text})
            Tween(TabStroke, {Color = CONFIG.Text})
        end

        TabBtn.MouseButton1Click:Connect(Activate)
        TabBtn.MouseEnter:Connect(function() if not Page.Visible then Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}) end end)
        TabBtn.MouseLeave:Connect(function() if not Page.Visible then Tween(TabBtn, {BackgroundColor3 = CONFIG.Secondary}) end end)

        Tabs[name] = {Page = Page, Btn = TabBtn, Stroke = TabStroke}
        if not FirstTab then FirstTab = Activate end
        
        -- Helper to add buttons to pages
        local PageFuncs = {}
        function PageFuncs:CreateButton(text, callback)
            local b = Create("TextButton", {
                Parent = Page, Text = text, Font = Enum.Font.Gotham, TextSize = 13,
                TextColor3 = CONFIG.Text, BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                Size = UDim2.new(1, 0, 0, 38)
            })
            Create("UICorner", {Parent = b, CornerRadius = UDim.new(0, 8)})
            Create("UIStroke", {Parent = b, Color = Color3.fromRGB(55, 55, 55)})
            b.MouseButton1Click:Connect(callback)
        end
        return PageFuncs
    end

    -- POPULATE TABS
    local Home = AddTab("Home")
    Home:CreateButton("Welcome to Nexus!", function() print("Clicked") end)
    Home:CreateButton("Print Client Info", function() print(Player.Name) end)

    local Combat = AddTab("Combat")
    local Visuals = AddTab("Visuals")
    
    if FirstTab then FirstTab() end
    MakeWindow(Main)
    
    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, {Size = UDim2.new(0, 580, 0, 380)})
end

--// KEY SYSTEM (Centered & Polished)
local function InitKeySystem()
    if GetSavedKey() == CONFIG.Key then return OpenMainHub() end

    local KeyFrame = Create("Frame", {
        Name = "KeyFrame", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        BackgroundTransparency = 0.05, Size = UDim2.new(0, 340, 0, 240), 
        Position = UDim2.new(0.5, -170, 0.5, -120)
    })
    Create("UICorner", {Parent = KeyFrame, CornerRadius = UDim.new(0, 12)})
    Create("UIStroke", {Parent = KeyFrame, Color = CONFIG.Accent, Thickness = 1.5})

    Create("TextLabel", {
        Parent = KeyFrame, Text = "NEXUS VERIFICATION", Font = Enum.Font.GothamBold,
        TextColor3 = CONFIG.Text, TextSize = 16, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 0, 20)
    })

    local Input = Create("TextBox", {
        Parent = KeyFrame, PlaceholderText = "Enter Access Key...", Text = "",
        BackgroundColor3 = CONFIG.Secondary, TextColor3 = CONFIG.Text,
        Font = Enum.Font.Gotham, TextSize = 14, Size = UDim2.new(0, 280, 0, 40),
        Position = UDim2.new(0.5, -140, 0.45, 0)
    })
    Create("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 8)})

    local VerifyBtn = Create("TextButton", {
        Parent = KeyFrame, Text = "Verify", Font = Enum.Font.GothamBold,
        TextColor3 = CONFIG.Text, BackgroundColor3 = CONFIG.Accent,
        Size = UDim2.new(0, 135, 0, 38), Position = UDim2.new(0.5, -140, 0.7, 5)
    })
    Create("UICorner", {Parent = VerifyBtn, CornerRadius = UDim.new(0, 8)})

    local GetBtn = Create("TextButton", {
        Parent = KeyFrame, Text = "Get Key", Font = Enum.Font.GothamBold,
        TextColor3 = CONFIG.Text, BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = UDim2.new(0, 135, 0, 38), Position = UDim2.new(0.5, 5, 0.7, 5)
    })
    Create("UICorner", {Parent = GetBtn, CornerRadius = UDim.new(0, 8)})

    Create("TextLabel", {
        Parent = KeyFrame, Text = "the key is 100% free on the Discord",
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = CONFIG.DarkText,
        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.9, -10),
        Size = UDim2.new(1, 0, 0, 20)
    })

    VerifyBtn.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Key then
            SaveKey(Input.Text)
            KeyFrame:Destroy()
            OpenMainHub()
        else
            Input.Text = ""
            Input.PlaceholderText = "WRONG KEY!"
            task.wait(1)
            Input.PlaceholderText = "Enter Access Key..."
        end
    end)

    GetBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(CONFIG.KeyLink) end
        GetBtn.Text = "COPIED!"
        task.wait(1)
        GetBtn.Text = "Get Key"
    end)
end

InitKeySystem()
