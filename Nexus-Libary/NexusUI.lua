--[[
    NEXUS STANDALONE INTERFACE
    Features:
    - Polished Key System with Auto-Save
    - Draggable & Resizable Main Frame
    - Fluent/Rayfield Aesthetic (UIStrokes, Acrylic-feel)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

--// Configuration
local CONFIG = {
    Name = "NEXUS HUB",
    Key = "NEXUS-2026", -- Change this to your desired key
    KeyLink = "https://discord.gg/nexus",
    SavePath = "Nexus_SaveData.json",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(22, 22, 22)
}

--// Utility Functions
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function Tween(obj, props, t)
    TS:Create(obj, TweenInfo.new(t or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// UI Setup
local ScreenGui = Create("ScreenGui", {
    Name = "Nexus_Interface",
    Parent = (gethui and gethui()) or CoreGui,
    ResetOnSpawn = false
})

--// SAVE SYSTEM LOGIC
local function SaveKey(key)
    if writefile then
        writefile(CONFIG.SavePath, key)
    end
end

local function GetSavedKey()
    if isfile and isfile(CONFIG.SavePath) then
        return readfile(CONFIG.SavePath)
    end
    return nil
end

--// DRAGGING & RESIZING LOGIC
local function MakeWindow(frame)
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Resizing (Bottom Right Corner)
    local ResizeBtn = Create("Frame", {
        Parent = frame, Name = "Resize", Size = UDim2.new(0, 15, 0, 15),
        Position = UDim2.new(1, -15, 1, -15), BackgroundTransparency = 1, ZIndex = 10
    })
    
    local resizing = false
    local resizeStartSize, resizeStartPos
    
    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true; resizeStartSize = frame.Size; resizeStartPos = input.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStartPos
            frame.Size = UDim2.new(0, math.max(400, resizeStartSize.X.Offset + delta.X), 0, math.max(250, resizeStartSize.Y.Offset + delta.Y))
        end
    end)
end

--// MAIN HUB INTERFACE (The frame that opens after key)
local function OpenMainHub()
    local Main = Create("Frame", {
        Name = "MainHub", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        Size = UDim2.new(0, 500, 0, 300), Position = UDim2.new(0.5, -250, 0.5, -150),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(45, 45, 45), Thickness = 1.2})
    
    local TopBar = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = CONFIG.Secondary
    })
    Create("UICorner", {Parent = TopBar, CornerRadius = UDim.new(0, 8)})
    
    local Title = Create("TextLabel", {
        Parent = TopBar, Text = CONFIG.Name, Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(0, 200, 1, 0), TextXAlignment = 0
    })

    -- Add a nice accent line under top bar
    Create("Frame", {
        Parent = TopBar, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = CONFIG.Accent, BorderSizePixel = 0
    })

    MakeWindow(Main)
    
    -- Animation In
    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, {Size = UDim2.new(0, 500, 0, 300)})
end

--// KEY SYSTEM INTERFACE
local function InitKeySystem()
    if GetSavedKey() == CONFIG.Key then
        return OpenMainHub()
    end

    local KeyFrame = Create("Frame", {
        Name = "KeyFrame", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        Size = UDim2.new(0, 320, 0, 180), Position = UDim2.new(0.5, -160, 0.5, -90)
    })
    Create("UICorner", {Parent = KeyFrame, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = KeyFrame, Color = CONFIG.Accent, Thickness = 1.5})

    local Title = Create("TextLabel", {
        Parent = KeyFrame, Text = "AUTHENTICATION", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 16, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 20)
    })

    local Input = Create("TextBox", {
        Parent = KeyFrame, PlaceholderText = "Enter Access Key...", Text = "",
        BackgroundColor3 = CONFIG.Secondary, TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham, TextSize = 14, Size = UDim2.new(0, 260, 0, 35),
        Position = UDim2.new(0.5, -130, 0.45, 0)
    })
    Create("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = Input, Color = Color3.fromRGB(50, 50, 50)})

    local VerifyBtn = Create("TextButton", {
        Parent = KeyFrame, Text = "Verify", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = CONFIG.Accent,
        Size = UDim2.new(0, 125, 0, 35), Position = UDim2.new(0.5, -130, 0.75, 0)
    })
    Create("UICorner", {Parent = VerifyBtn, CornerRadius = UDim.new(0, 6)})

    local GetBtn = Create("TextButton", {
        Parent = KeyFrame, Text = "Get Key", Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Size = UDim2.new(0, 125, 0, 35), Position = UDim2.new(0.5, 5, 0.75, 0)
    })
    Create("UICorner", {Parent = GetBtn, CornerRadius = UDim.new(0, 6)})

    -- Logic
    VerifyBtn.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Key then
            SaveKey(Input.Text)
            Tween(KeyFrame, {BackgroundTransparency = 1})
            task.wait(0.2)
            KeyFrame:Destroy()
            OpenMainHub()
        else
            Input.Text = ""
            Input.PlaceholderText = "INVALID KEY!"
            Tween(Input, {TextColor3 = Color3.fromRGB(255, 50, 50)})
            task.wait(1)
            Input.PlaceholderText = "Enter Access Key..."
            Tween(Input, {TextColor3 = Color3.fromRGB(255, 255, 255)})
        end
    end)

    GetBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(CONFIG.KeyLink) end
        GetBtn.Text = "COPIED!"
        task.wait(1)
        GetBtn.Text = "Get Key"
    end)
end

-- Start
InitKeySystem()
