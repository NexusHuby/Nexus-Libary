--[[
    NEXUS STANDALONE v20
    - HEADER: Bold & Large Title
    - TABS: Ultra-Compact (24px), 0.08 Transparency
    - STYLE: Unified Glassmorphism & Reflective Gloss
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CONFIG = {
    Name = "NEXUS HUB",
    Key = "NEXUS-2026",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(10, 10, 10),
    GlassTrans = 0.08, -- Unified Transparency
    ToggleImage = "rbxassetid://92090613790936"
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v20"
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
Instance.new("UICorner", MasterReset).CornerRadius = UDim.new(0, 6)
MasterReset.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MakeDraggable(MasterReset)

--// 2. TOGGLE BUTTON
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0, 55)
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = CONFIG.Accent
MakeDraggable(ToggleBtn)

--// 3. MAIN HUB
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 520, 0, 340)
    Main.Position = UDim2.new(0.5, -260, 0.5, -170)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.GlassTrans
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(100, 100, 100)
    MainStroke.Thickness = 1.2

    -- HEADER DIVIDER
    local Divider = Instance.new("Frame", Main)
    Divider.Size = UDim2.new(1, -30, 0, 1)
    Divider.Position = UDim2.new(0, 15, 0, 55) -- Moved down for larger text
    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Divider.BorderSizePixel = 0
    local grad = Instance.new("UIGradient", Divider)
    grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})

    -- BIG HEADER TITLE
    local Title = Instance.new("TextLabel", Main)
    Title.Text = CONFIG.Name
    Title.TextColor3 = CONFIG.Accent
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20 -- Increased from 14
    Title.Position = UDim2.new(0, 20, 0, 15)
    Title.Size = UDim2.new(0, 250, 0, 30)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = 0

    -- SIDEBAR (Compact Pill Layout)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 110, 1, -80); Sidebar.Position = UDim2.new(0, 15, 0, 70); Sidebar.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Sidebar); Layout.Padding = UDim.new(0, 5)

    -- PAGE AREA
    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -155, 1, -80); PageContainer.Position = UDim2.new(0, 140, 0, 70); PageContainer.BackgroundTransparency = 1

    local function CreateTab(name, active)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 24) -- Shrunk to 24px
        TabBtn.BackgroundColor3 = active and CONFIG.Accent or Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = active and 0 or 0.92 -- Matches 0.08 Transparency (1 - 0.92)
        TabBtn.Text = name; TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TabBtn.TextSize = 10
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
        
        -- Gloss Highlight
        local Gloss = Instance.new("Frame", TabBtn)
        Gloss.Size = UDim2.new(1, 0, 0.4, 0); Gloss.BackgroundTransparency = 0.8; Gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Gloss).CornerRadius = UDim.new(0, 4)
        local GlossGrad = Instance.new("UIGradient", Gloss)
        GlossGrad.Rotation = 90; GlossGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1; Page.Visible = active; Page.ScrollBarThickness = 0

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    v.BackgroundTransparency = 0.92 
                end 
            end
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            TabBtn.BackgroundColor3 = CONFIG.Accent
            TabBtn.BackgroundTransparency = 0
            Page.Visible = true
        end)
    end

    -- TABS
    CreateTab("Home", true)
    CreateTab("Player", false)
    CreateTab("Combat", false)
    CreateTab("Visuals", false)
    CreateTab("Settings", false)

    -- WINDOW CONTROLS
    local Min = Instance.new("TextButton", Main)
    Min.Text = "-"; Min.TextColor3 = Color3.fromRGB(255,255,255); Min.Position = UDim2.new(1,-70,0,15); Min.Size = UDim2.new(0,30,0,30); Min.BackgroundTransparency = 1; Min.TextSize = 18
    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    
    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255,80,80); Close.Position = UDim2.new(1,-40,0,15); Close.Size = UDim2.new(0,30,0,30); Close.BackgroundTransparency = 1; Close.TextSize = 14
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)

    MakeDraggable(Main)
end

--// 4. KEY SYSTEM
local function InitKey()
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 300, 0, 200); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -100); KeyFrame.BackgroundColor3 = CONFIG.BG; KeyFrame.BackgroundTransparency = CONFIG.GlassTrans
    Instance.new("UICorner", KeyFrame); Instance.new("UIStroke", KeyFrame).Color = CONFIG.Accent
    
    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 220, 0, 35); Input.Position = UDim2.new(0.5, -110, 0.4, 0); Input.BackgroundColor3 = Color3.fromRGB(255,255,255); Input.BackgroundTransparency = 0.9; Input.TextColor3 = Color3.fromRGB(255,255,255); Input.PlaceholderText = "Key..."; Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 220, 0, 35); Verify.Position = UDim2.new(0.5, -110, 0.65, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.Text = "VERIFY"; Verify.TextColor3 = Color3.fromRGB(255,255,255); Verify.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Verify)
    
    Verify.MouseButton1Click:Connect(function() if Input.Text == CONFIG.Key then KeyFrame:Destroy(); OpenMainHub() end end)
end

InitKey()
