--[[
    NEXUS STANDALONE v6
    - Fixed Reset Button Visibility (Moved to Sidebar)
    - Added Sidebar Navigation
    - Improved Resizing Hitbox
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
    BG = Color3.fromRGB(15, 15, 15),
    SidebarColor = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(160, 160, 160)
}

--// Utility
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function Tween(obj, props, t)
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// UI Container
local ScreenGui = Create("ScreenGui", {
    Name = "Nexus_Interface",
    Parent = (gethui and gethui()) or CoreGui,
    ResetOnSpawn = false
})

--// SAVE & RESET LOGIC
local function SaveKey(key) if writefile then writefile(CONFIG.SavePath, key) end end
local function GetSavedKey() if isfile and isfile(CONFIG.SavePath) then return readfile(CONFIG.SavePath) end return nil end
local function ResetKey() 
    if isfile and isfile(CONFIG.SavePath) then 
        delfile(CONFIG.SavePath) 
        ScreenGui:Destroy()
    end 
end

--// DRAG & RESIZE ENGINE
local function MakeWindow(frame)
    local dragging, dragStart, startPos
    local resizing, resizeStartSize, resizeStartPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    local ResizeHandle = Create("Frame", {
        Parent = frame, Name = "ResizeHandle",
        Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -20, 1, -20),
        BackgroundTransparency = 1, ZIndex = 20
    })
    
    -- Small visual indicator for resize
    local ResizeIcon = Create("ImageLabel", {
        Parent = ResizeHandle, Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(0.5, -6, 0.5, -6),
        BackgroundTransparency = 1, Image = "rbxassetid://6031925612", ImageColor3 = CONFIG.DarkText
    })

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStartPos = input.Position
            resizeStartSize = frame.Size
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif resizing then
                local delta = input.Position - resizeStartPos
                frame.Size = UDim2.new(0, math.max(450, resizeStartSize.X.Offset + delta.X), 0, math.max(300, resizeStartSize.Y.Offset + delta.Y))
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            resizing = false
        end
    end)
end

--// MAIN HUB
local function OpenMainHub()
    local Main = Create("Frame", {
        Name = "MainHub", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        Size = UDim2.new(0, 550, 0, 350), Position = UDim2.new(0.5, -275, 0.5, -175),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(40, 40, 40), Thickness = 1.2})
    
    -- Sidebar Area
    local Sidebar = Create("Frame", {
        Name = "Sidebar", Parent = Main, BackgroundColor3 = CONFIG.SidebarColor,
        Size = UDim2.new(0, 140, 1, 0), Position = UDim2.new(0, 0, 0, 0)
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 10)})
    
    local Title = Create("TextLabel", {
        Parent = Sidebar, Text = CONFIG.Name, Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = CONFIG.Accent, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 15), Size = UDim2.new(1, 0, 0, 30)
    })

    -- CONTENT AREA
    local Content = Create("Frame", {
        Name = "Content", Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 15), Size = UDim2.new(1, -165, 1, -30)
    })

    -- THE RESET BUTTON (Now clearly visible in Sidebar)
    local ResetBtn = Create("TextButton", {
        Parent = Sidebar, Text = "Reset Key", Font = Enum.Font.GothamMedium,
        TextColor3 = Color3.fromRGB(255, 100, 100), BackgroundColor3 = Color3.fromRGB(35, 25, 25),
        Size = UDim2.new(0, 110, 0, 30), Position = UDim2.new(0.5, -55, 1, -45),
        ZIndex = 5
    })
    Create("UICorner", {Parent = ResetBtn, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = ResetBtn, Color = Color3.fromRGB(80, 40, 40), Thickness = 1})

    ResetBtn.MouseButton1Click:Connect(function()
        ResetKey()
        print("Key Reset. Re-execute script.")
    end)

    MakeWindow(Main)
    
    -- Open Animation
    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, {Size = UDim2.new(0, 550, 0, 350)})
end

--// KEY SYSTEM
local function InitKeySystem()
    if GetSavedKey() == CONFIG.Key then return OpenMainHub() end

    local KeyFrame = Create("Frame", {
        Name = "KeyFrame", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        Size = UDim2.new(0, 320, 0, 220), Position = UDim2.new(0.5, -160, 0.5, -110)
    })
    Create("UICorner", {Parent = KeyFrame, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = KeyFrame, Color = Color3.fromRGB(45, 45, 45), Thickness = 1.5})

    Create("TextLabel", {
        Parent = KeyFrame, Text = "AUTHENTICATION", Font = Enum.Font.GothamBold,
        TextColor3 = CONFIG.Text, TextSize = 16, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 20)
    })

    local Input = Create("TextBox", {
        Parent = KeyFrame, PlaceholderText = "Enter Key...", Text = "",
        BackgroundColor3 = CONFIG.Secondary, TextColor3 = CONFIG.Text,
        Font = Enum.Font.Gotham, TextSize = 14, Size = UDim2.new(0, 260, 0, 35),
        Position = UDim2.new(0.5, -130, 0.4, 0)
    })
    Create("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = Input, Color = Color3.fromRGB(50, 50, 50)})

    local VerifyBtn = Create("TextButton", {
        Parent = KeyFrame, Text = "Verify", Font = Enum.Font.GothamBold,
        TextColor3 = CONFIG.Text, BackgroundColor3 = CONFIG.Accent,
        Size = UDim2.new(0, 125, 0, 35), Position = UDim2.new(0.5, -130, 0.65, 0)
    })
    Create("UICorner", {Parent = VerifyBtn, CornerRadius = UDim.new(0, 6)})

    local GetBtn = Create("TextButton", {
        Parent = KeyFrame, Text = "Get Key", Font = Enum.Font.GothamBold,
        TextColor3 = CONFIG.Text, BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Size = UDim2.new(0, 125, 0, 35), Position = UDim2.new(0.5, 5, 0.65, 0)
    })
    Create("UICorner", {Parent = GetBtn, CornerRadius = UDim.new(0, 6)})

    Create("TextLabel", {
        Parent = KeyFrame, Text = "the key is 100% free on the Discord",
        Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = CONFIG.DarkText,
        BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0.85, 0),
        Size = UDim2.new(1, 0, 0, 20)
    })

    VerifyBtn.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Key then
            SaveKey(Input.Text)
            KeyFrame:Destroy()
            OpenMainHub()
        else
            Input.Text = ""
            Input.PlaceholderText = "INVALID KEY!"
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
