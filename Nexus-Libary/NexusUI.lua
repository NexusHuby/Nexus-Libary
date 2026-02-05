--[[
    NEXUS STANDALONE v15
    - FIXED: Force Reset Visibility (DisplayOrder & Extreme ZIndex)
    - FIXED: Screen Clipping (Fixed Offset Positioning)
    - STYLE: 0.08 Transparency / Gradient Divider / Lucid Icons
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CONFIG = {
    Name = "NEXUS HUB",
    Key = "NEXUS-2026",
    KeyLink = "https://discord.gg/nexus",
    SavePath = "Nexus_SaveData.json",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(10, 10, 10),
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936"
}

--// UI Container (Forced to Top)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v15_Final"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999 -- FORCES TOP LAYER

--// UTILITY: Dragging
local function MakeDraggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

--// 1. PERSISTENT FORCE RESET (TOP LEFT - OFFSET BASED)
local MasterReset = Instance.new("TextButton")
MasterReset.Name = "Nexus_Force_Reset"
MasterReset.Parent = ScreenGui
MasterReset.Size = UDim2.new(0, 110, 0, 30)
MasterReset.Position = UDim2.new(0, 10, 0, 10) -- PINNED TO TOP LEFT
MasterReset.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
MasterReset.Text = "FORCE RESET"
MasterReset.Font = Enum.Font.GothamBold
MasterReset.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterReset.TextSize = 11
MasterReset.ZIndex = 1000 -- Absolute highest
MasterReset.BorderSizePixel = 0

Instance.new("UICorner", MasterReset).CornerRadius = UDim.new(0, 6)
local mStroke = Instance.new("UIStroke", MasterReset)
mStroke.Color = Color3.fromRGB(255, 255, 255); mStroke.Thickness = 1.5

print("[NEXUS] Force Reset Button Created at Top-Left.")

MasterReset.MouseButton1Click:Connect(function()
    if isfile and isfile(CONFIG.SavePath) then
        delfile(CONFIG.SavePath)
    end
    ScreenGui:Destroy()
    print("[NEXUS] System Reset. Re-execute script.")
end)

MakeDraggable(MasterReset)

--// 2. FLOATING TOGGLE
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 10, 0, 50) -- Just under reset button
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
ToggleBtn.ZIndex = 900
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(ToggleBtn)

--// 3. MAIN HUB
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Main.ZIndex = 50
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = Color3.fromRGB(80, 80, 80); mainStroke.Thickness = 1.5
    
    -- THE GRADIENT DIVIDER
    local Divider = Instance.new("Frame", Main)
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 0, 48)
    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 55
    local grad = Instance.new("UIGradient", Divider)
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    local Title = Instance.new("TextLabel", Main)
    Title.Text = CONFIG.Name; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = CONFIG.Accent
    Title.Position = UDim2.new(0, 25, 0, 18); Title.Size = UDim2.new(0, 200, 0, 20); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0; Title.ZIndex = 55

    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 80, 80); Close.Position = UDim2.new(1, -45, 0, 15); Close.Size = UDim2.new(0,30,0,30); Close.BackgroundTransparency = 1; Close.ZIndex = 55
    
    local Min = Instance.new("TextButton", Main)
    Min.Text = "-"; Min.TextColor3 = Color3.fromRGB(255,255,255); Min.Position = UDim2.new(1, -80, 0, 15); Min.Size = UDim2.new(0,30,0,30); Min.BackgroundTransparency = 1; Min.ZIndex = 55

    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    MakeDraggable(Main)
end

--// 4. KEY SYSTEM
local function InitKeySystem()
    if isfile and isfile(CONFIG.SavePath) and readfile(CONFIG.SavePath) == CONFIG.Key then return OpenMainHub() end

    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 350, 0, 250)
    KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
    KeyFrame.BackgroundColor3 = CONFIG.BG
    KeyFrame.BackgroundTransparency = CONFIG.MainTransparency
    KeyFrame.ZIndex = 100
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
    local kStroke = Instance.new("UIStroke", KeyFrame)
    kStroke.Color = CONFIG.Accent; kStroke.Thickness = 1.5

    local kTitle = Instance.new("TextLabel", KeyFrame)
    kTitle.Text = "NEXUS KEY SYSTEM"; kTitle.Font = Enum.Font.GothamBold; kTitle.TextColor3 = Color3.fromRGB(255,255,255); kTitle.Size = UDim2.new(1,0,0,50); kTitle.BackgroundTransparency = 1; kTitle.ZIndex = 105

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 280, 0, 40); Input.Position = UDim2.new(0.5, -140, 0.45, 0); Input.BackgroundColor3 = Color3.fromRGB(20,20,20); Input.TextColor3 = Color3.fromRGB(255,255,255); Input.PlaceholderText = "Key..."; Input.Text = ""; Input.ZIndex = 105
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 130, 0, 35); Verify.Position = UDim2.new(0.5, -135, 0.7, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.TextColor3 = Color3.fromRGB(255,255,255); Verify.Text = "Verify"; Verify.ZIndex = 105
    Instance.new("UICorner", Verify)

    Verify.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Key then
            if writefile then writefile(CONFIG.SavePath, Input.Text) end
            KeyFrame:Destroy()
            OpenMainHub()
        else
            Input.Text = "BAD KEY"; task.wait(1); Input.Text = ""
        end
    end)
end

InitKeySystem()
