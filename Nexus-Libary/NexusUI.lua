--[[
    NEXUS STANDALONE v12
    - Fixed: Toggle Button Draggable logic.
    - Added: "Glass Style" Professional Key System.
    - Added: Visible Header Divider with Gradient.
    - Style: 0.08 Transparency / Acrylic Strokes.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

--// Configuration
local CONFIG = {
    Name = "NEXUS HUB",
    Key = "NEXUS-2026",
    KeyLink = "https://discord.gg/nexus",
    SavePath = "Nexus_SaveData.json",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(10, 10, 10),
    SidebarColor = Color3.fromRGB(15, 15, 15),
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936",
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(170, 170, 170)
}

--// UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v12"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.ResetOnSpawn = false

--// UTILITY: Dragging (Rewritten for stability)
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = obj.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

--// FLOATING TOGGLE
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 30, 0.5, -27)
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = CONFIG.Accent; tStroke.Thickness = 2
MakeDraggable(ToggleBtn)

--// NOTIFICATION
local function Notify(title, desc)
    local Box = Instance.new("Frame", ScreenGui) -- Simplified for this version
    Box.Size = UDim2.new(0, 250, 0, 60)
    Box.Position = UDim2.new(1, -260, 1, 100)
    Box.BackgroundColor3 = CONFIG.BG
    Box.BackgroundTransparency = 0.1
    Instance.new("UICorner", Box)
    local l = Instance.new("TextLabel", Box)
    l.Text = title.."\n"..desc; l.Size = UDim2.new(1,0,1,0); l.TextColor3 = CONFIG.Text; l.BackgroundTransparency = 1
    TS:Create(Box, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 1, -70)}):Play()
    task.delay(4, function() TS:Create(Box, TweenInfo.new(0.5), {Position = UDim2.new(1, -260, 1, 100)}):Play() end)
end

--// MAIN HUB BUILDER
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local mStroke = Instance.new("UIStroke", Main)
    mStroke.Color = Color3.fromRGB(60, 60, 60); mStroke.Thickness = 1.2
    
    -- THE COOL DIVIDER
    local Divider = Instance.new("Frame", Main)
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 45)
    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Divider.BorderSizePixel = 0
    local grad = Instance.new("UIGradient", Divider)
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    local Title = Instance.new("TextLabel", Main)
    Title.Text = CONFIG.Name; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = CONFIG.Accent
    Title.Position = UDim2.new(0, 20, 0, 15); Title.Size = UDim2.new(0, 200, 0, 20); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 80, 80); Close.Position = UDim2.new(1, -40, 0, 10); Close.Size = UDim2.new(0,30,0,30); Close.BackgroundTransparency = 1
    
    local Min = Instance.new("TextButton", Main)
    Min.Text = "-"; Min.TextColor3 = CONFIG.Text; Min.Position = UDim2.new(1, -75, 0, 10); Min.Size = UDim2.new(0,30,0,30); Min.BackgroundTransparency = 1

    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    MakeDraggable(Main)
    Notify("Nexus Loaded", "Ready for use!")
end

--// PROFESSIONAL KEY SYSTEM
local function InitKeySystem()
    if isfile and isfile(CONFIG.SavePath) and readfile(CONFIG.SavePath) == CONFIG.Key then return OpenMainHub() end

    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 350, 0, 250)
    KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    KeyFrame.BackgroundColor3 = CONFIG.BG
    KeyFrame.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
    local kStroke = Instance.new("UIStroke", KeyFrame)
    kStroke.Color = CONFIG.Accent; kStroke.Thickness = 1.5

    -- Key Header Divider (Consistency)
    local kDiv = Instance.new("Frame", KeyFrame)
    kDiv.Size = UDim2.new(1, -40, 0, 1); kDiv.Position = UDim2.new(0, 20, 0, 50); kDiv.BackgroundColor3 = Color3.fromRGB(255,255,255)
    local kg = Instance.new("UIGradient", kDiv); kg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(1,1)})

    local kTitle = Instance.new("TextLabel", KeyFrame)
    kTitle.Text = "AUTHENTICATION"; kTitle.Font = Enum.Font.GothamBold; kTitle.TextColor3 = CONFIG.Text; kTitle.Size = UDim2.new(1,0,0,50); kTitle.BackgroundTransparency = 1

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 280, 0, 45); Input.Position = UDim2.new(0.5, -140, 0.4, 0); Input.BackgroundColor3 = CONFIG.SidebarColor; Input.TextColor3 = CONFIG.Text; Input.PlaceholderText = "Enter Key..."; Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 135, 0, 40); Verify.Position = UDim2.new(0.5, -140, 0.65, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.TextColor3 = CONFIG.Text; Verify.Text = "Verify"
    Instance.new("UICorner", Verify)

    local Get = Instance.new("TextButton", KeyFrame)
    Get.Size = UDim2.new(0, 135, 0, 40); Get.Position = UDim2.new(0.5, 5, 0.65, 0); Get.BackgroundColor3 = Color3.fromRGB(30,30,30); Get.TextColor3 = CONFIG.Text; Get.Text = "Get Key"
    Instance.new("UICorner", Get)

    local Disc = Instance.new("TextLabel", KeyFrame)
    Disc.Text = "the key is 100% free on the Discord"; Disc.Size = UDim2.new(1,0,0,30); Disc.Position = UDim2.new(0,0,0.85,0); Disc.TextColor3 = CONFIG.DarkText; Disc.BackgroundTransparency = 1; Disc.TextSize = 11

    Verify.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Key then
            if writefile then writefile(CONFIG.SavePath, Input.Text) end
            KeyFrame:Destroy()
            OpenMainHub()
        else
            Input.Text = "INVALID KEY"
            task.wait(1)
            Input.Text = ""
        end
    end)
    
    Get.MouseButton1Click:Connect(function() setclipboard(CONFIG.KeyLink) Get.Text = "Copied!" task.wait(1) Get.Text = "Get Key" end)
end

InitKeySystem()
