--[[
    NEXUS STANDALONE v18
    - FIX: High-contrast tabs (Distinct from background)
    - FIX: Compact Sidebar (Smaller, cleaner buttons)
    - STYLE: Reflective Glossy Sheen + Header Divider
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CONFIG = {
    Name = "NEXUS HUB",
    Key = "NEXUS-2026",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(12, 12, 12),
    TabBG = Color3.fromRGB(30, 30, 30), -- Lighter than BG for visibility
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936"
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v18"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false

--// Utilities
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

--// 1. PERSISTENT RESET (Top Left)
local MasterReset = Instance.new("TextButton", ScreenGui)
MasterReset.Size = UDim2.new(0, 100, 0, 25)
MasterReset.Position = UDim2.new(0, 15, 0, 15)
MasterReset.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MasterReset.Text = "FORCE RESET"
MasterReset.Font = Enum.Font.GothamBold
MasterReset.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterReset.TextSize = 10
MasterReset.ZIndex = 1000
Instance.new("UICorner", MasterReset).CornerRadius = UDim.new(0, 6)
MasterReset.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MakeDraggable(MasterReset)

--// 2. TOGGLE BUTTON
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0, 50)
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = CONFIG.Accent
MakeDraggable(ToggleBtn)

--// 3. MAIN HUB
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 550, 0, 350) -- Shrunk for better layout
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(80, 80, 80)

    -- HEADER DIVIDER (Pinned under text)
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
    Title.Text = CONFIG.Name; Title.TextColor3 = CONFIG.Accent; Title.Font = Enum.Font.GothamBold
    Title.Position = UDim2.new(0, 20, 0, 12); Title.Size = UDim2.new(0, 200, 0, 25); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    -- SIDEBAR (Compact)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 130, 1, -70); Sidebar.Position = UDim2.new(0, 15, 0, 60); Sidebar.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Sidebar); Layout.Padding = UDim.new(0, 6)

    -- PAGE AREA
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -170, 1, -70); PageContainer.Position = UDim2.new(0, 155, 0, 60); PageContainer.BackgroundTransparency = 1

    local function CreateTab(name, active)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 32) -- Smaller height
        TabBtn.BackgroundColor3 = active and CONFIG.Accent or CONFIG.TabBG
        TabBtn.Text = name; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn.TextSize = 12
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        -- GLOSSY EFFECT (The highlight)
        local Gloss = Instance.new("Frame", TabBtn)
        Gloss.Size = UDim2.new(1, 0, 0.5, 0); Gloss.BackgroundTransparency = 0.85; Gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Gloss).CornerRadius = UDim.new(0, 6)
        Instance.new("UIGradient", Gloss).Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = active; Page.ScrollBarThickness = 0

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.BackgroundColor3 = CONFIG.TabBG end end
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            TabBtn.BackgroundColor3 = CONFIG.Accent
            Page.Visible = true
        end)
    end

    -- POPULATING
    CreateTab("Home", true)
    CreateTab("Player", false)
    CreateTab("Combat", false)
    CreateTab("Visuals", false)
    CreateTab("Settings", false)

    -- WINDOW CONTROLS
    local Min = Instance.new("TextButton", Main)
    Min.Text = "-"; Min.TextColor3 = Color3.fromRGB(255,255,255); Min.Position = UDim2.new(1,-70,0,10); Min.Size = UDim2.new(0,30,0,30); Min.BackgroundTransparency = 1
    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    
    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255,80,80); Close.Position = UDim2.new(1,-35,0,10); Close.Size = UDim2.new(0,30,0,30); Close.BackgroundTransparency = 1
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)

    MakeDraggable(Main)
end

--// 4. KEY SYSTEM (Visible)
local function InitKey()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 320, 0, 220); KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -110); KeyFrame.BackgroundColor3 = CONFIG.BG; KeyFrame.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", KeyFrame); Instance.new("UIStroke", KeyFrame).Color = CONFIG.Accent
    
    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 240, 0, 35); Input.Position = UDim2.new(0.5, -120, 0.4, 0); Input.BackgroundColor3 = CONFIG.TabBG; Input.TextColor3 = Color3.fromRGB(255,255,255); Input.PlaceholderText = "Key..."; Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 240, 0, 35); Verify.Position = UDim2.new(0.5, -120, 0.65, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.Text = "VERIFY"; Verify.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", Verify)
    
    Verify.MouseButton1Click:Connect(function() if Input.Text == CONFIG.Key then KeyFrame:Destroy(); OpenMainHub() end end)
end

InitKey()
