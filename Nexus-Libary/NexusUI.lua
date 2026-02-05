--[[
    NEXUS STANDALONE v17
    - TABS: Player, Combat, Visuals, Home, Settings
    - STYLE: Reflective Gloss & 0.08 Glass Transparency
    - FIX: Persistent Force Reset & Tab Switching Logic
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CONFIG = {
    Name = "NEXUS HUB",
    Key = "NEXUS-2026",
    SavePath = "Nexus_SaveData.json",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(12, 12, 12),
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936"
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v17_Final"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.DisplayOrder = 999999
ScreenGui.ResetOnSpawn = false

--// Utilities
local function Tween(obj, props, t)
    TS:Create(obj, TweenInfo.new(t or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
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

--// 1. FORCE RESET BUTTON (Top Left - Offset)
local MasterReset = Instance.new("TextButton", ScreenGui)
MasterReset.Size = UDim2.new(0, 110, 0, 30)
MasterReset.Position = UDim2.new(0, 15, 0, 15)
MasterReset.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
MasterReset.Text = "FORCE RESET"
MasterReset.Font = Enum.Font.GothamBold
MasterReset.TextColor3 = Color3.fromRGB(255, 255, 255)
MasterReset.TextSize = 10
MasterReset.ZIndex = 1000
Instance.new("UICorner", MasterReset).CornerRadius = UDim.new(0, 8)
MasterReset.MouseButton1Click:Connect(function()
    if isfile and isfile(CONFIG.SavePath) then delfile(CONFIG.SavePath) end
    ScreenGui:Destroy()
end)
MakeDraggable(MasterReset)

--// 2. TOGGLE
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0, 55)
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = CONFIG.Accent
MakeDraggable(ToggleBtn)

--// 3. MAIN HUB
local function OpenMainHub()
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 620, 0, 420)
    Main.Position = UDim2.new(0.5, -310, 0.5, -210)
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(70, 70, 70)

    -- DIVIDER
    local Div = Instance.new("Frame", Main)
    Div.Size = UDim2.new(1, -40, 0, 1)
    Div.Position = UDim2.new(0, 20, 0, 50)
    Div.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    local g = Instance.new("UIGradient", Div)
    g.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(1,1)})

    local Title = Instance.new("TextLabel", Main)
    Title.Text = CONFIG.Name; Title.TextColor3 = CONFIG.Accent; Title.Font = Enum.Font.GothamBold; Title.Position = UDim2.new(0,25,0,15); Title.Size = UDim2.new(0,200,0,30); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 150, 1, -80); Sidebar.Position = UDim2.new(0, 15, 0, 65); Sidebar.BackgroundTransparency = 1
    Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 8)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -190, 1, -80); PageContainer.Position = UDim2.new(0, 175, 0, 65); PageContainer.BackgroundTransparency = 1

    local Tabs = {}
    local function CreateTab(name, active)
        local ContentPage = Instance.new("ScrollingFrame", PageContainer)
        ContentPage.Size = UDim2.new(1, 0, 1, 0); ContentPage.BackgroundTransparency = 1; ContentPage.Visible = active; ContentPage.ScrollBarThickness = 0
        Instance.new("UIListLayout", ContentPage).Padding = UDim.new(0, 10)

        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 38); TabBtn.BackgroundColor3 = active and CONFIG.Accent or Color3.fromRGB(30,30,30)
        TabBtn.Text = name; TabBtn.Font = Enum.Font.GothamMedium; TabBtn.TextColor3 = Color3.fromRGB(255,255,255); TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        
        -- Glossy Effect
        local Gloss = Instance.new("UIGradient", TabBtn)
        Gloss.Rotation = 90; Gloss.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(1, 0)})

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Tabs) do v.Page.Visible = false; v.Btn.BackgroundColor3 = Color3.fromRGB(30,30,30) end
            ContentPage.Visible = true; TabBtn.BackgroundColor3 = CONFIG.Accent
        end)
        Tabs[name] = {Page = ContentPage, Btn = TabBtn}
    end

    -- POPULATE TABS
    CreateTab("Home", true)
    CreateTab("Player", false)
    CreateTab("Combat", false)
    CreateTab("Visuals", false)
    CreateTab("Settings", false)

    -- CONTROLS
    local Min = Instance.new("TextButton", Main)
    Min.Text = "-"; Min.TextColor3 = Color3.fromRGB(255,255,255); Min.Position = UDim2.new(1,-75,0,15); Min.Size = UDim2.new(0,30,0,30); Min.BackgroundTransparency = 1
    Min.MouseButton1Click:Connect(function() Main.Visible = false; ToggleBtn.Visible = true end)
    
    local Close = Instance.new("TextButton", Main)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255,80,80); Close.Position = UDim2.new(1,-40,0,15); Close.Size = UDim2.new(0,30,0,30); Close.BackgroundTransparency = 1
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = true; ToggleBtn.Visible = false end)

    MakeDraggable(Main)
end

--// 4. KEY SYSTEM (Glossy)
local function InitKeySystem()
    if isfile and isfile(CONFIG.SavePath) and readfile(CONFIG.SavePath) == CONFIG.Key then return OpenMainHub() end
    local KeyFrame = Instance.new("Frame", ScreenGui)
    KeyFrame.Size = UDim2.new(0, 350, 0, 250); KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -125); KeyFrame.BackgroundColor3 = CONFIG.BG; KeyFrame.BackgroundTransparency = CONFIG.MainTransparency
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12); Instance.new("UIStroke", KeyFrame).Color = CONFIG.Accent
    
    local Input = Instance.new("TextBox", KeyFrame)
    Input.Size = UDim2.new(0, 260, 0, 40); Input.Position = UDim2.new(0.5, -130, 0.4, 0); Input.BackgroundColor3 = Color3.fromRGB(20,20,20); Input.TextColor3 = Color3.fromRGB(255,255,255); Input.PlaceholderText = "Key..."; Input.Text = ""
    Instance.new("UICorner", Input)

    local Verify = Instance.new("TextButton", KeyFrame)
    Verify.Size = UDim2.new(0, 260, 0, 40); Verify.Position = UDim2.new(0.5, -130, 0.65, 0); Verify.BackgroundColor3 = CONFIG.Accent; Verify.Text = "Verify Access"; Verify.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", Verify)
    
    Verify.MouseButton1Click:Connect(function()
        if Input.Text == CONFIG.Key then
            if writefile then writefile(CONFIG.SavePath, Input.Text) end
            KeyFrame:Destroy(); OpenMainHub()
        else
            Input.Text = "INVALID"; task.wait(1); Input.Text = ""
        end
    end)
end

InitKeySystem()
