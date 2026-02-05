--[[
    NEXUS STANDALONE v5
    - Added "Reset Key" button (Deletes Save Data)
    - Further Smoothed Resizing & Dragging
    - Added Constraints to prevent UI from disappearing
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
    SavePath = "Nexus_SaveData.json", -- The file saved in your executor's 'workspace' folder
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(22, 22, 22),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(160, 160, 160)
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
        ScreenGui:Destroy() -- Close UI after resetting
        print("Nexus: Key data cleared. Please re-execute.")
    end 
end

--// DRAG & RESIZE ENGINE
local function MakeWindow(frame)
    local dragging, dragStart, startPos
    local resizing, resizeStartSize, resizeStartPos

    -- TopBar Dragging
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    -- Resize Handle
    local ResizeHandle = Create("ImageLabel", {
        Parent = frame, Name = "ResizeHandle",
        Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -18, 1, -18),
        BackgroundTransparency = 1, Image = "rbxassetid://6031925612",
        ImageColor3 = CONFIG.DarkText, ZIndex = 10
    })

    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStartPos = input.Position
            resizeStartSize = frame.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then resizing = false end
            end)
        end
    end)

    -- Global Listener
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif resizing then
                local delta = input.Position - resizeStartPos
                local newX = math.max(400, resizeStartSize.X.Offset + delta.X)
                local newY = math.max(250, resizeStartSize.Y.Offset + delta.Y)
                frame.Size = UDim2.new(0, newX, 0, newY)
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
        Size = UDim2.new(0, 500, 0, 300), Position = UDim2.new(0.5, -250, 0.5, -150),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Main, Color = Color3.fromRGB(45, 45, 45), Thickness = 1.2})
    
    local TopBar = Create("Frame", {
        Parent = Main, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = CONFIG.Secondary
    })
    Create("UICorner", {Parent = TopBar, CornerRadius = UDim.new(0, 8)})
    
    Create("TextLabel", {
        Parent = TopBar, Text = CONFIG.Name, Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = CONFIG.Text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0), Size = UDim2.new(0, 200, 1, 0), TextXAlignment = 0
    })

    -- RESET KEY BUTTON (Inside Main Hub)
    local ResetBtn = Create("TextButton", {
        Parent = Main, Text = "Reset Key / Logout", Font = Enum.Font.GothamMedium,
        TextColor3 = Color3.fromRGB(255, 100, 100), BackgroundColor3 = Color3.fromRGB(30, 20, 20),
        Size = UDim2.new(0, 140, 0, 30), Position = UDim2.new(1, -150, 0, 45)
    })
    Create("UICorner", {Parent = ResetBtn, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = ResetBtn, Color = Color3.fromRGB(60, 30, 30)})

    ResetBtn.MouseButton1Click:Connect(function()
        ResetKey()
    end)

    MakeWindow(Main)
    
    -- Animation In
    Main.Size = UDim2.new(0, 0, 0, 0)
    Tween(Main, {Size = UDim2.new(0, 500, 0, 300)})
end

--// KEY SYSTEM
local function InitKeySystem()
    -- Check for save first
    if GetSavedKey() == CONFIG.Key then return OpenMainHub() end

    local KeyFrame = Create("Frame", {
        Name = "KeyFrame", Parent = ScreenGui, BackgroundColor3 = CONFIG.BG,
        Size = UDim2.new(0, 320, 0, 220), Position = UDim2.new(0.5, -160, 0.5, -110)
    })
    Create("UICorner", {Parent = KeyFrame, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = KeyFrame, Color = Color3.fromRGB(40,40,40), Thickness = 1.5})

    Create("TextLabel", {
        Parent = KeyFrame, Text = "AUTHENTICATION", Font = Enum.Font.GothamBold,
        TextColor3 = CONFIG.Text, TextSize = 16, BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 20)
    })

    local Input = Create("TextBox", {
        Parent = KeyFrame, PlaceholderText = "Enter Access Key...", Text = "",
        BackgroundColor3 = CONFIG.Secondary, TextColor3 = CONFIG.Text,
        Font = Enum.Font.Gotham, TextSize = 14, Size = UDim2.new(0, 260, 0, 35),
        Position = UDim2.new(0.5, -130, 0.4, 0)
    })
    Create("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 6)})

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

    -- REQUESTED TEXT
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
