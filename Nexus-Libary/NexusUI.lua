--[[
    NEXUS STANDALONE v16
    - STYLE: Glossy / Glassmorphism / Acrylic
    - TABS: Vertical Pill Layout with Glow
    - EFFECTS: Reflective Sheen & Rim Lighting
    - RESET: Force Reset Button at Top-Left (ZIndex 10^9)
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
    BG = Color3.fromRGB(12, 12, 12),
    SidebarColor = Color3.fromRGB(18, 18, 18),
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936"
}

--// UI Container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v16_Glossy"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false

--// UTILITY: Tweening & Dragging
local function Tween(obj, props, t)
    TS:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

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

--// 1. FORCE RESET BUTTON (TOP LEFT)
local MasterReset = Instance.new("TextButton", ScreenGui)
MasterReset.Size = UDim2.new(0, 110, 0, 30)
MasterReset.Position = UDim2.new(0, 15, 0, 15)
MasterReset.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MasterReset.Text = "FORCE RESET"
MasterReset.Font = Enum.Font.GothamBold
MasterReset.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterReset.TextSize = 10
MasterReset.ZIndex = 1000
Instance.new("UICorner", MasterReset).CornerRadius = UDim.new(0, 8)
local rStroke = Instance.new("UIStroke", MasterReset)
rStroke.Color = Color3.fromRGB(255, 255, 255); rStroke.Thickness = 1.5

MasterReset.MouseButton1Click:Connect(function()
    if isfile and isfile(CONFIG.SavePath) then delfile(CONFIG.SavePath) end
    ScreenGui:Destroy()
end)
MakeDraggable(MasterReset)

--// 2. FLOATING TOGGLE
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0, 60)
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = CONFIG.Accent
MakeDraggable(ToggleBtn)

--// 3. MAIN HUB BUILDER
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 620, 0, 420)
    Main.Position = UDim2.new(0.5, -310, 0.5, -210)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    
    local mainStroke = Instance.new("UIStroke", Main)
    mainStroke.Color = Color3.fromRGB(60, 60, 60); mainStroke.Thickness = 1.5

    -- HEADER SEPARATOR
    local Divider = Instance.new("Frame", Main)
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 0, 50)
    Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local grad = Instance.new("UIGradient", Divider)
    grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(1,1)})

    local Title = Instance.new("TextLabel", Main)
    Title.Text = CONFIG.Name; Title.Font = Enum.Font.GothamBold; Title.TextColor3 = CONFIG.Accent; Title.TextSize = 16
    Title.Position = UDim2.new(0, 25, 0, 15); Title.Size = UDim2.new(0, 200, 0, 30); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    -- TAB SIDEBAR
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 160, 1, -70); Sidebar.Position = UDim2.new(0, 15, 0, 65); Sidebar.BackgroundTransparency = 1
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 10)

    -- CONTENT AREA
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1, -200, 1, -70); Content.Position = UDim2.new(0, 185, 0, 65); Content.BackgroundTransparency = 1

    -- BUTTON GLOSS MAKER
    local function ApplyGloss(btn)
        local Gloss = Instance.new("UIGradient", btn)
        Gloss.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(0.5, btn.BackgroundColor3),
            ColorSequenceKeypoint.new(1, btn.BackgroundColor3)
        })
        Gloss.Rotation = 90
        Gloss.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.8), -- Faint sheen at top
            NumberSequenceKeypoint.new(1, 0)
        })
    end

    local function CreateTab(name)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 40)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 10)
        
        local Stroke = Instance.new("UIStroke", TabBtn)
        Stroke.Color = Color3.fromRGB(45, 45, 45); Stroke.Thickness = 1
        
        ApplyGloss(TabBtn)

        TabBtn.MouseEnter:Connect(function() Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}) end)
        TabBtn.MouseLeave:Connect(function() Tween(TabBtn, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}) end)
    end

    CreateTab("Home")
    CreateTab("Combat")
    CreateTab("Visuals")
    CreateTab("Settings")

    -- CONTROLS
    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 80, 80); Close.Position = UDim2.new(1, -45, 0, 15); Close.Size = UDim2.new(0,30,0,30); Close.BackgroundTransparency = 1
    
    local Min = Instance.new("TextButton", Main)
    Min.Text = "-"; Min.TextColor3 = Color3.fromRGB(255,255,255); Min.Position = UDim2.new(1, -80, 0, 15); Min.Size = UDim2.new(0,30,0,30); Min.BackgroundTransparency = 1

    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    MakeDraggable(Main)
end

--// 4. KEY SYSTEM BUILDER (Glossy)
local function InitKeySystem()
    if isfile and isfile(CONFIG.SavePath) and readfile(CONFIG.SavePath) == CONFIG.Key then return OpenMainHub() end

    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 360, 0, 260)
    KeyFrame.Position = UDim2.new(0.5, -180, 0.5, -130)
    KeyFrame.BackgroundColor3 = CONFIG.BG
    KeyFrame.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", KeyFrame).Color = CONFIG.Accent

    local kTitle = Instance.new("TextLabel", KeyFrame)
    kTitle.Text = "NEXUS SECURE"; kTitle.Font = Enum.Font.GothamBold; kTitle.TextColor3 = Color3.fromRGB(255,255,255); kTitle.Size = UDim2.new(1,0,0,60); kTitle.BackgroundTransparency = 1

    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 280, 0, 45); Input.Position = UDim2.new(0.5, -140, 0.45, 0); Input.BackgroundColor3 = Color3.fromRGB(20,20,20); Input.TextColor3 = Color3.fromRGB(255,255,255); Input.PlaceholderText = "Key..."; Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 280, 0, 45); Verify.Position = UDim2.new(0.5, -140, 0.7, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.TextColor3 = Color3.fromRGB(255,255,255); Verify.Text = "Verify Access"
    Instance.new("UICorner", Verify).CornerRadius = UDim.new(0, 10)
    
    ApplyGloss(Verify) -- Adding the glossy effect to verify button

    Verify.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Key then
            if writefile then writefile(CONFIG.SavePath, Input.Text) end
            KeyFrame:Destroy()
            OpenMainHub()
        else
            Input.Text = "ACCESS DENIED"; task.wait(1); Input.Text = ""
        end
    end)
end

InitKeySystem()
