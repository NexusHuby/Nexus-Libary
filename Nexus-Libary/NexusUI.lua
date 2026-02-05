local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local VALID_KEY = "FREE_KEY_2026"
local SAVE_FILE = "MyScriptConfig.json"

-- Create Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PolishedUI_System"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Utility: Rounded Corners & Stroke
local function addStyling(obj, color, thickness)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = obj
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj
    return stroke
end

-- Utility: Dragging Function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

----------------------------------------------------------------
-- 1. KEY SYSTEM FRAME
----------------------------------------------------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 350, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
KeyFrame.BackgroundTransparency = 0.08
KeyFrame.Parent = ScreenGui
addStyling(KeyFrame, Color3.fromRGB(0, 170, 255), 2)

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.2, 0)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Parent = KeyFrame
addStyling(KeyInput, Color3.fromRGB(50, 50, 50), 1)

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Text = "Verify"
VerifyBtn.Size = UDim2.new(0.35, 0, 0, 40)
VerifyBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
VerifyBtn.BackgroundColor3 = Color3.new(0,0,0)
VerifyBtn.TextColor3 = Color3.new(1,1,1)
VerifyBtn.Parent = KeyFrame
addStyling(VerifyBtn, Color3.fromRGB(0, 255, 100), 2)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Text = "Get Key"
GetKeyBtn.Size = UDim2.new(0.35, 0, 0, 40)
GetKeyBtn.Position = UDim2.new(0.55, 0, 0.5, 0)
GetKeyBtn.BackgroundColor3 = Color3.new(0,0,0)
GetKeyBtn.TextColor3 = Color3.new(1,1,1)
GetKeyBtn.Parent = KeyFrame
addStyling(GetKeyBtn, Color3.fromRGB(150, 0, 255), 2)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Text = "The key is 100% free in the discord"
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0.8, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
InfoLabel.Parent = KeyFrame

----------------------------------------------------------------
-- 2. MAIN HUB FRAME (Hidden initially)
----------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
addStyling(MainFrame, Color3.fromRGB(0, 170, 255), 2)
makeDraggable(MainFrame)

-- Tab Layout
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 120, 1, 0)
TabBar.BackgroundTransparency = 0.9
TabBar.Parent = MainFrame

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Parent = MainFrame
addStyling(CloseBtn, Color3.new(1,1,1), 1)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Parent = MainFrame
addStyling(MinBtn, Color3.new(1,1,1), 1)

----------------------------------------------------------------
-- 3. CONFIRMATION PROMPT
----------------------------------------------------------------
local ConfirmFrame = Instance.new("Frame")
ConfirmFrame.Size = UDim2.new(0, 250, 0, 150)
ConfirmFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
ConfirmFrame.BackgroundColor3 = Color3.new(0,0,0)
ConfirmFrame.BackgroundTransparency = 0.08
ConfirmFrame.Visible = false
ConfirmFrame.Parent = ScreenGui
addStyling(ConfirmFrame, Color3.new(1, 0, 0), 2)

local Header = Instance.new("TextLabel")
Header.Text = "Are you sure?"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.TextColor3 = Color3.new(1,1,1)
Header.BackgroundTransparency = 1
Header.Parent = ConfirmFrame

local Desc = Instance.new("TextLabel")
Desc.Text = "Press Close to exit or No to stay"
Desc.Size = UDim2.new(1, 0, 0, 40)
Desc.Position = UDim2.new(0, 0, 0.3, 0)
Desc.TextColor3 = Color3.new(0.7,0.7,0.7)
Desc.BackgroundTransparency = 1
Desc.Parent = ConfirmFrame

local RealClose = Instance.new("TextButton")
RealClose.Text = "Close"
RealClose.Size = UDim2.new(0.4, 0, 0, 30)
RealClose.Position = UDim2.new(0.05, 0, 0.7, 0)
RealClose.BackgroundColor3 = Color3.new(0,0,0)
RealClose.TextColor3 = Color3.new(1,1,1)
RealClose.Parent = ConfirmFrame
addStyling(RealClose, Color3.new(1,0,0), 1)

local NoBtn = Instance.new("TextButton")
NoBtn.Text = "No"
NoBtn.Size = UDim2.new(0.4, 0, 0, 30)
NoBtn.Position = UDim2.new(0.55, 0, 0.7, 0)
NoBtn.BackgroundColor3 = Color3.new(0,0,0)
NoBtn.TextColor3 = Color3.new(1,1,1)
NoBtn.Parent = ConfirmFrame
addStyling(NoBtn, Color3.new(0,1,0), 1)

----------------------------------------------------------------
-- 4. MINIMIZE BUTTON (Floating)
----------------------------------------------------------------
local FloatBtn = Instance.new("ImageButton")
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
FloatBtn.Visible = false
FloatBtn.BackgroundColor3 = Color3.new(0,0,0)
FloatBtn.Parent = ScreenGui
addStyling(FloatBtn, Color3.fromRGB(0, 170, 255), 2)
makeDraggable(FloatBtn)

----------------------------------------------------------------
-- LOGIC & ANIMATIONS
----------------------------------------------------------------

local function OpenMainHub()
    KeyFrame:TweenPosition(UDim2.new(0.5, -175, 1.2, 0), "Out", "Back", 0.5)
    task.wait(0.5)
    KeyFrame.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame:TweenSize(UDim2.new(0, 500, 0, 350), "Out", "Quart", 0.5)
end

-- Key Verification
VerifyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == VALID_KEY then
        -- Save State (Compatible with most executors)
        pcall(function() writefile(SAVE_FILE, "verified") end)
        OpenMainHub()
    else
        VerifyBtn.Text = "Wrong Key!"
        task.wait(1)
        VerifyBtn.Text = "Verify"
    end
end)

-- Minimize Logic
MinBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenSize(UDim2.new(0,0,0,0), "In", "Quart", 0.3, true, function()
        MainFrame.Visible = false
        FloatBtn.Visible = true
    end)
end)

FloatBtn.MouseButton1Click:Connect(function()
    FloatBtn.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 500, 0, 350), "Out", "Quart", 0.3)
end)

-- Close Logic
CloseBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = true end)
NoBtn.MouseButton1Click:Connect(function() ConfirmFrame.Visible = false end)
RealClose.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Auto-Login Check
local status, err = pcall(function()
    if readfile(SAVE_FILE) == "verified" then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    end
end)
