--[[
    NEXUS STANDALONE v19
    - FIX: High-Visibility Buttons (Slate Grey vs Deep Black)
    - FIX: Compact Layout (shrunk heights and widths)
    - STYLE: Professional Glossy "Glass" Overlays
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
    TabBG = Color3.fromRGB(60, 60, 60), -- MUCH LIGHTER for visibility
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936"
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v19"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false

--// Dragging Utility
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

--// 1. FORCE RESET (Top Left)
local MasterReset = Instance.new("TextButton", ScreenGui)
MasterReset.Size = UDim2.new(0, 100, 0, 25)
MasterReset.Position = UDim2.new(0, 15, 0, 15)
MasterReset.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
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
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 15, 0, 50)
ToggleBtn.BackgroundColor3 = CONFIG.TabBG
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = CONFIG.Accent
MakeDraggable(ToggleBtn)

--// 3. MAIN HUB
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 500, 0, 320) -- Compact professional sizing
    Main.Position = UDim2.new(0.5, -250, 0.5, -160)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(100, 100, 100)
    MainStroke.Thickness = 1.2

    -- HEADER DIVIDER
    local Divider = Instance.new("Frame", Main)
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 40)
    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Divider.BorderSizePixel = 0
    local grad = Instance.new("UIGradient", Divider)
    grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})

    local Title = Instance.new("TextLabel", Main)
    Title.Text = CONFIG.Name; Title.TextColor3 = CONFIG.Accent; Title.Font = Enum.Font.GothamBold
    Title.Position = UDim2.new(0, 18, 0, 10); Title.Size = UDim2.new(0, 200, 0, 25); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    -- SIDEBAR (Slim & Compact)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 110, 1, -60); Sidebar.Position = UDim2.new(0, 15, 0, 50); Sidebar.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Sidebar); Layout.Padding = UDim.new(0, 5)

    -- PAGE AREA
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -150, 1, -60); PageContainer.Position = UDim2.new(0, 135, 0, 50); PageContainer.BackgroundTransparency = 1

    local function CreateTab(name, active)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 28) -- Slim height
        TabBtn.BackgroundColor3 = active and CONFIG.Accent or CONFIG.TabBG
        TabBtn.Text = name; TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        
        -- VISIBLE GLOSS OVERLAY
        local Gloss = Instance.new("Frame", TabBtn)
        Gloss.Size = UDim2.new(1, 0, 0.4, 0); Gloss.Position = UDim2.new(0,0,0,0)
        Gloss.BackgroundTransparency = 0.7; Gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Gloss).CornerRadius = UDim.new(0, 4)
        local GlossGrad = Instance.new("UIGradient", Gloss)
        GlossGrad.Rotation = 90; GlossGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})

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
    Min.Text = "-"; Min.TextColor3 = Color3.fromRGB(255,255,255); Min.Position = UDim2.new(1,-65,0,8); Min.Size = UDim2.new(0,25,0,25); Min.BackgroundTransparency = 1
    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    
    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255,80,80); Close.Position = UDim2.new(1,-35,0,8); Close.Size = UDim2.new(0,25,0,25); Close.BackgroundTransparency = 1
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)

    MakeDraggable(Main)
end

--// 4. KEY SYSTEM (High Visibility)
local function InitKey()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 300, 0, 200); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100); KeyFrame.BackgroundColor3 = CONFIG.BG; KeyFrame.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", KeyFrame); Instance.new("UIStroke", KeyFrame).Color = CONFIG.Accent
    
    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 220, 0, 35); Input.Position = UDim2.new(0.5, -110, 0.4, 0); Input.BackgroundColor3 = CONFIG.TabBG; Input.TextColor3 = Color3.fromRGB(255,255,255); Input.PlaceholderText = "Key..."; Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 220, 0, 35); Verify.Position = UDim2.new(0.5, -110, 0.65, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.Text = "VERIFY"; Verify.TextColor3 = Color3.fromRGB(255,255,255); Verify.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Verify)
    
    Verify.MouseButton1Click:Connect(function() if Input.Text == CONFIG.Key then KeyFrame:Destroy(); OpenMainHub() end end)
end

InitKey()
