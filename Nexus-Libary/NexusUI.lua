--[[
    NEXUS STANDALONE v14
    - FIXED: Master Reset button visibility (ZIndex 999)
    - ADDED: Master Reset button is now DRAGGABLE
    - STYLE: Main Hub Divider & 0.08 Glass Transparency
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
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936",
    Text = Color3.fromRGB(255, 255, 255)
}

--// UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_Final_v14"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.ResetOnSpawn = false

--// UTILITY: Enhanced Dragging
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

--// 1. MASTER RESET BUTTON (PERSISTENT & DRAGGABLE)
local MasterReset = Instance.new("TextButton")
MasterReset.Name = "MasterReset"
MasterReset.Parent = ScreenGui
MasterReset.Size = UDim2.new(0, 120, 0, 35)
MasterReset.Position = UDim2.new(0.5, -60, 0, 50) -- Top Center
MasterReset.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MasterReset.Text = "FORCE RESET"
MasterReset.Font = Enum.Font.GothamBold
MasterReset.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterReset.TextSize = 12
MasterReset.ZIndex = 999 -- Keeps it above everything
Instance.new("UICorner", MasterReset).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MasterReset).Color = Color3.fromRGB(255, 255, 255)

MakeDraggable(MasterReset)

MasterReset.MouseButton1Click:Connect(function()
    if isfile and isfile(CONFIG.SavePath) then
        delfile(CONFIG.SavePath)
    end
    ScreenGui:Destroy()
    print("Nexus: Data Cleared. Re-run script to see Key System.")
end)

--// 2. FLOATING TOGGLE ICON
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
ToggleBtn.ZIndex = 500
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Color = CONFIG.Accent; tStroke.Thickness = 2
MakeDraggable(ToggleBtn)

--// 3. MAIN HUB BUILDER
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local mStroke = Instance.new("UIStroke", Main)
    mStroke.Color = Color3.fromRGB(80, 80, 80); mStroke.Thickness = 1.5
    
    -- THE PERFECT DIVIDER
    local Divider = Instance.new("Frame", Main)
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 0, 48)
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
    Title.Position = UDim2.new(0, 25, 0, 18); Title.Size = UDim2.new(0, 200, 0, 20); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 80, 80); Close.Position = UDim2.new(1, -45, 0, 15); Close.Size = UDim2.new(0,30,0,30); Close.BackgroundTransparency = 1
    
    local Min = Instance.new("TextButton", Main)
    Min.Text = "-"; Min.TextColor3 = CONFIG.Text; Min.Position = UDim2.new(1, -80, 0, 15); Min.Size = UDim2.new(0,30,0,30); Min.BackgroundTransparency = 1

    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    MakeDraggable(Main)
end

--// 4. KEY SYSTEM BUILDER
local function InitKeySystem()
    if isfile and isfile(CONFIG.SavePath) and readfile(CONFIG.SavePath) == CONFIG.Key then return OpenMainHub() end

    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 360, 0, 260)
    KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -130)
    KeyFrame.BackgroundColor3 = CONFIG.BG
    KeyFrame.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
    local kStroke = Instance.new("UIStroke", KeyFrame)
    kStroke.Color = CONFIG.Accent; kStroke.Thickness = 1.5

    local kTitle = Instance.new("TextLabel", KeyFrame)
    kTitle.Text = "NEXUS AUTHENTICATION"; kTitle.Font = Enum.Font.GothamBold; kTitle.TextColor3 = CONFIG.Text; kTitle.Size = UDim2.new(1,0,0,60); kTitle.BackgroundTransparency = 1

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 280, 0, 45); Input.Position = UDim2.new(0.5, -140, 0.4, 0); Input.BackgroundColor3 = Color3.fromRGB(20,20,20); Input.TextColor3 = CONFIG.Text; Input.PlaceholderText = "Enter Key..."; Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 135, 0, 40); Verify.Position = UDim2.new(0.5, -140, 0.65, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.TextColor3 = CONFIG.Text; Verify.Text = "Verify"; Verify.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Verify)

    local Get = Instance.new("TextButton", KeyFrame)
    Get.Size = UDim2.new(0, 135, 0, 40); Get.Position = UDim2.new(0.5, 5, 0.65, 0); Get.BackgroundColor3 = Color3.fromRGB(30,30,30); Get.TextColor3 = CONFIG.Text; Get.Text = "Get Key"; Get.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Get)

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
