--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

--// SETTINGS
local CORRECT_KEY = "FREEKEY123" -- change if you want

--// SAVE SYSTEM
local SAVE_NAME = "KeyVerifiedV1"
local verified = false
pcall(function()
    verified = CoreGui:GetAttribute(SAVE_NAME)
end)

local function saveKey()
    pcall(function()
        CoreGui:SetAttribute(SAVE_NAME, true)
    end)
end

--// MAIN GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "PolishedHub"
Gui.ResetOnSpawn = false
Gui.Parent = CoreGui

--// UTILS
local function createStroke(parent, color)
    local s = Instance.new("UIStroke")
    s.Thickness = 2
    s.Color = color
    s.Parent = parent
    return s
end

local function round(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = parent
end

local function tween(obj, info, goal)
    TweenService:Create(obj, info, goal):Play()
end

--// ===================== KEY FRAME =====================
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.fromScale(0.35, 0.35)
KeyFrame.Position = UDim2.fromScale(0.5, 0.5)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
KeyFrame.BackgroundTransparency = 0.08
KeyFrame.Parent = Gui
round(KeyFrame, 16)
createStroke(KeyFrame, Color3.fromRGB(0,170,255))

-- Glow loop
task.spawn(function()
    while KeyFrame.Parent do
        tween(KeyFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.12})
        task.wait(1.5)
        tween(KeyFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.08})
        task.wait(1.5)
    end
end)

-- Title
local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.fromScale(1, 0.25)
Title.Text = "KEY SYSTEM"
Title.TextColor3 = Color3.fromRGB(0,170,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true

-- Input
local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Size = UDim2.fromScale(0.8, 0.18)
KeyBox.Position = UDim2.fromScale(0.1, 0.3)
KeyBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
KeyBox.TextColor3 = Color3.new(1,1,1)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextScaled = true
round(KeyBox, 10)
createStroke(KeyBox, Color3.fromRGB(0,170,255))

-- Buttons
local Verify = Instance.new("TextButton", KeyFrame)
Verify.Text = "Verify"
Verify.Size = UDim2.fromScale(0.35, 0.18)
Verify.Position = UDim2.fromScale(0.1, 0.55)
Verify.BackgroundColor3 = Color3.fromRGB(0,0,0)
Verify.TextColor3 = Color3.new(1,1,1)
Verify.Font = Enum.Font.GothamBold
Verify.TextScaled = true
round(Verify, 10)
createStroke(Verify, Color3.fromRGB(0,255,0))

local GetKey = Instance.new("TextButton", KeyFrame)
GetKey.Text = "Get Key"
GetKey.Size = UDim2.fromScale(0.35, 0.18)
GetKey.Position = UDim2.fromScale(0.55, 0.55)
GetKey.BackgroundColor3 = Color3.fromRGB(0,0,0)
GetKey.TextColor3 = Color3.new(1,1,1)
GetKey.Font = Enum.Font.GothamBold
GetKey.TextScaled = true
round(GetKey, 10)
createStroke(GetKey, Color3.fromRGB(170,0,255))

local Info = Instance.new("TextLabel", KeyFrame)
Info.Text = "The key is 100% free in the Discord"
Info.Size = UDim2.fromScale(1, 0.15)
Info.Position = UDim2.fromScale(0, 0.8)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.fromRGB(200,200,200)
Info.Font = Enum.Font.Gotham
Info.TextScaled = true

--// ===================== MAIN HUB =====================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromScale(0.45, 0.5)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Visible = false
MainFrame.Parent = Gui
round(MainFrame, 16)
createStroke(MainFrame, Color3.fromRGB(0,170,255))
MainFrame.Active = true
MainFrame.Draggable = true

-- Header
local Header = Instance.new("TextLabel", MainFrame)
Header.Text = "POLISHED HUB"
Header.Size = UDim2.fromScale(1, 0.12)
Header.BackgroundTransparency = 1
Header.TextColor3 = Color3.fromRGB(0,170,255)
Header.Font = Enum.Font.GothamBold
Header.TextScaled = true

-- Minimize
local Minimize = Instance.new("TextButton", MainFrame)
Minimize.Text = "-"
Minimize.Size = UDim2.fromScale(0.08, 0.1)
Minimize.Position = UDim2.fromScale(0.85, 0.02)
Minimize.BackgroundColor3 = Color3.fromRGB(0,0,0)
Minimize.TextColor3 = Color3.new(1,1,1)
round(Minimize, 8)
createStroke(Minimize, Color3.fromRGB(0,170,255))

-- Close
local Close = Instance.new("TextButton", MainFrame)
Close.Text = "X"
Close.Size = UDim2.fromScale(0.08, 0.1)
Close.Position = UDim2.fromScale(0.93, 0.02)
Close.BackgroundColor3 = Color3.fromRGB(0,0,0)
Close.TextColor3 = Color3.fromRGB(255,80,80)
round(Close, 8)
createStroke(Close, Color3.fromRGB(255,0,0))

-- Floating Button
local Float = Instance.new("ImageButton", Gui)
Float.Size = UDim2.fromScale(0.06, 0.1)
Float.Position = UDim2.fromScale(0.02, 0.4)
Float.BackgroundColor3 = Color3.fromRGB(0,0,0)
Float.Visible = false
Float.AutoButtonColor = false
round(Float, 14)
createStroke(Float, Color3.fromRGB(0,170,255))
Float.Active = true
Float.Draggable = true

--// CONFIRM CLOSE
local Confirm = Instance.new("Frame", Gui)
Confirm.Size = UDim2.fromScale(0.3, 0.25)
Confirm.Position = UDim2.fromScale(0.5, 0.5)
Confirm.AnchorPoint = Vector2.new(0.5, 0.5)
Confirm.BackgroundColor3 = Color3.fromRGB(0,0,0)
Confirm.BackgroundTransparency = 0.08
Confirm.Visible = false
round(Confirm, 16)
createStroke(Confirm, Color3.fromRGB(255,0,0))

local CH = Instance.new("TextLabel", Confirm)
CH.Text = "Are you sure?"
CH.Size = UDim2.fromScale(1, 0.3)
CH.BackgroundTransparency = 1
CH.TextColor3 = Color3.fromRGB(255,80,80)
CH.Font = Enum.Font.GothamBold
CH.TextScaled = true

local CD = Instance.new("TextLabel", Confirm)
CD.Text = "Press Close to close the frame\nor No to keep it open"
CD.Size = UDim2.fromScale(1, 0.3)
CD.Position = UDim2.fromScale(0, 0.3)
CD.BackgroundTransparency = 1
CD.TextColor3 = Color3.fromRGB(200,200,200)
CD.Font = Enum.Font.Gotham
CD.TextScaled = true

local Yes = Instance.new("TextButton", Confirm)
Yes.Text = "Close"
Yes.Size = UDim2.fromScale(0.4, 0.2)
Yes.Position = UDim2.fromScale(0.1, 0.65)
Yes.BackgroundColor3 = Color3.fromRGB(0,0,0)
round(Yes, 10)
createStroke(Yes, Color3.fromRGB(255,0,0))
Yes.TextColor3 = Color3.new(1,1,1)

local No = Instance.new("TextButton", Confirm)
No.Text = "No"
No.Size = UDim2.fromScale(0.4, 0.2)
No.Position = UDim2.fromScale(0.5, 0.65)
No.BackgroundColor3 = Color3.fromRGB(0,0,0)
round(No, 10)
createStroke(No, Color3.fromRGB(0,255,0))
No.TextColor3 = Color3.new(1,1,1)

--// LOGIC
Verify.MouseButton1Click:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        saveKey()
        tween(KeyFrame, TweenInfo.new(0.5), {Size = UDim2.fromScale(0,0)})
        task.wait(0.5)
        KeyFrame.Visible = false
        MainFrame.Visible = true
        tween(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Size = UDim2.fromScale(0.45, 0.5)})
    end
end)

Minimize.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    Float.Visible = true
end)

Float.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    Float.Visible = false
end)

Close.MouseButton1Click:Connect(function()
    Confirm.Visible = true
end)

Yes.MouseButton1Click:Connect(function()
    Gui:Destroy()
end)

No.MouseButton1Click:Connect(function()
    Confirm.Visible = false
end)

-- Auto skip key
if verified then
    KeyFrame.Visible = false
    MainFrame.Visible = true
end
