--[[
    NEXUS STANDALONE v11
    - Conditional Dragging: Toggle button is only draggable when Main is hidden.
    - Header Divider: Stylish line separating Title from Controls.
    - Polish: Gradient accents and improved spacing.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local CONFIG = {
    Name = "NEXUS HUB",
    Accent = Color3.fromRGB(0, 140, 255),
    BG = Color3.fromRGB(10, 10, 10),
    SidebarColor = Color3.fromRGB(15, 15, 15),
    MainTransparency = 0.08,
    ToggleImage = "rbxassetid://92090613790936"
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Nexus_v11"
ScreenGui.Parent = (gethui and gethui()) or CoreGui
ScreenGui.ResetOnSpawn = false

--// UTILITY: Dragging Function
local function EnableDrag(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

--// TOGGLE BUTTON (Draggable)
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "NexusToggle"
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.Image = CONFIG.ToggleImage
ToggleBtn.BackgroundColor3 = CONFIG.BG
ToggleBtn.Visible = false
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = CONFIG.Accent
ToggleStroke.Thickness = 2

EnableDrag(ToggleBtn) -- Enabled as requested

--// MAIN HUB
local function BuildMain()
    local Main = Instance.new("Frame")
    Main.Name = "MainHub"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = CONFIG.BG
    Main.BackgroundTransparency = CONFIG.MainTransparency
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(60, 60, 60)
    MainStroke.Thickness = 1.2

    -- HEADER DIVIDER
    local HeaderLine = Instance.new("Frame")
    HeaderLine.Name = "HeaderDivider"
    HeaderLine.Parent = Main
    HeaderLine.Size = UDim2.new(1, -20, 0, 1)
    HeaderLine.Position = UDim2.new(0, 10, 0, 40)
    HeaderLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local Gradient = Instance.new("UIGradient", HeaderLine)
    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Text = CONFIG.Name
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.Size = UDim2.new(0, 200, 0, 20)
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- CONTROLS
    local Close = Instance.new("TextButton")
    Close.Parent = Main
    Close.Text = "X"
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -35, 0, 5)
    Close.BackgroundTransparency = 1
    Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.Font = Enum.Font.GothamBold

    local Min = Instance.new("TextButton")
    Min.Parent = Main
    Min.Text = "-"
    Min.Size = UDim2.new(0, 30, 0, 30)
    Min.Position = UDim2.new(1, -65, 0, 5)
    Min.BackgroundTransparency = 1
    Min.TextColor3 = Color3.fromRGB(255, 255, 255)
    Min.Font = Enum.Font.GothamBold

    -- LOGIC
    Min.MouseButton1Click:Connect(function()
        Main.Visible = false
        ToggleBtn.Visible = true
    end)

    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        ToggleBtn.Visible = false
    end)

    EnableDrag(Main)
end

BuildMain()
