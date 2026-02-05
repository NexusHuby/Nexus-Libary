## // Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

## // ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.DisplayOrder = 999999999
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

## // Utility: Draggable Function
local function MakeDraggable(Frame, DragPart)
    DragPart = DragPart or Frame
    local dragging = false
    local dragInput, dragStart, startPos

    DragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    DragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

## // Utility: Button Hover Tween
local function ApplyHoverTween(Button, NormalProps, HoverProps)
    local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
    local hoverTween

    Button.MouseEnter:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(Button, tweenInfo, HoverProps)
        hoverTween:Play()
    end)

    Button.MouseLeave:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(Button, tweenInfo, NormalProps)
        hoverTween:Play()
    end)
end

## // Stage One: Authentication Layer
local AuthFrame = Instance.new("Frame")
AuthFrame.Size = UDim2.fromOffset(320, 220)
AuthFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
AuthFrame.AnchorPoint = Vector2.new(0.5, 0.5)
AuthFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
AuthFrame.BackgroundTransparency = 0.08
AuthFrame.Visible = true
AuthFrame.Parent = ScreenGui

local AuthCorner = Instance.new("UICorner")
AuthCorner.CornerRadius = UDim.new(0, 12)
AuthCorner.Parent = AuthFrame

local AuthStroke = Instance.new("UIStroke")
AuthStroke.Thickness = 1.5
AuthStroke.Color = Color3.fromRGB(0, 140, 255)
AuthStroke.Parent = AuthFrame

local AuthTitle = Instance.new("TextLabel")
AuthTitle.Size = UDim2.new(1, 0, 0, 60)
AuthTitle.Position = UDim2.new(0, 0, 0, 10)
AuthTitle.BackgroundTransparency = 1
AuthTitle.Text = "AUTHENTICATION"
AuthTitle.Font = Enum.Font.GothamBold
AuthTitle.TextSize = 26
AuthTitle.TextColor3 = Color3.new(1, 1, 1)
AuthTitle.Parent = AuthFrame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
KeyBox.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
KeyBox.BackgroundTransparency = 0.08
KeyBox.PlaceholderText = "Enter License Key..."
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 16
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = AuthFrame

local KeyBoxCorner = Instance.new("UICorner")
KeyBoxCorner.CornerRadius = UDim.new(0, 8)
KeyBoxCorner.Parent = KeyBox

local KeyBoxStroke = Instance.new("UIStroke")
KeyBoxStroke.Thickness = 1
KeyBoxStroke.Color = Color3.new(1, 1, 1)
KeyBoxStroke.Parent = KeyBox

local VerifyButton = Instance.new("TextButton")
VerifyButton.Size = UDim2.new(0.8, 0, 0, 40)
VerifyButton.Position = UDim2.new(0.1, 0, 0.65, 0)
VerifyButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
VerifyButton.BackgroundTransparency = 0.08
VerifyButton.Text = "Verify Access"
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.TextSize = 16
VerifyButton.TextColor3 = Color3.new(1, 1, 1)
VerifyButton.AutoButtonColor = false
VerifyButton.Parent = AuthFrame

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 8)
VerifyCorner.Parent = VerifyButton

local VerifyStroke = Instance.new("UIStroke")
VerifyStroke.Thickness = 1.5
VerifyStroke.Color = Color3.fromRGB(0, 140, 255)
VerifyStroke.Parent = VerifyButton

local GlossSheen = Instance.new("Frame")
GlossSheen.Size = UDim2.new(1, 0, 1, 0)
GlossSheen.BackgroundColor3 = Color3.new(1, 1, 1)
GlossSheen.BackgroundTransparency = 0
GlossSheen.ZIndex = 0
GlossSheen.Parent = VerifyButton

local SheenGradient = Instance.new("UIGradient")
SheenGradient.Color = ColorSequence.new(Color3.new(1, 1, 1))
SheenGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(1, 1)
}
SheenGradient.Rotation = 90
SheenGradient.Parent = GlossSheen

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, 0, 0, 30)
StatusLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.Parent = AuthFrame

ApplyHoverTween(VerifyButton, {BackgroundTransparency = 0.08}, {BackgroundTransparency = 0.2})

## // Stage Two: Primary Command Hub
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(750, 500)
MainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(0, 140, 255)
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(0, 200, 1, 0)
HubTitle.Position = UDim2.new(0, 20, 0, 0)
HubTitle.BackgroundTransparency = 1
HubTitle.Text = "NEXUS HUB"
HubTitle.Font = Enum.Font.GothamBold
HubTitle.TextSize = 22
HubTitle.TextColor3 = Color3.fromRGB(0, 140, 255)
HubTitle.TextXAlignment = Enum.TextXAlignment.Left
HubTitle.Parent = Header

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 1, 0)
Divider.BackgroundColor3 = Color3.new(1, 1, 1)
Divider.Parent = Header

local DividerGradient = Instance.new("UIGradient")
DividerGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1)
}
DividerGradient.Parent = Divider

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(40, 30)
CloseButton.Position = UDim2.new(1, -50, 0, 12)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.Parent = Header

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.fromOffset(40, 30)
MinimizeButton.Position = UDim2.new(1, -100, 0, 12)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 24
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Parent = Header

ApplyHoverTween(CloseButton, {TextColor3 = Color3.fromRGB(255, 100, 100)}, {TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Color3.fromRGB(255, 50, 50), BackgroundTransparency = 0.7})
ApplyHoverTween(MinimizeButton, {TextColor3 = Color3.new(1, 1, 1)}, {TextColor3 = Color3.fromRGB(0, 140, 255)})

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundTransparency = 0.08
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 8)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.VerticalAlignment = Enum.VerticalAlignment.Top
SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
SidebarList.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 15)
SidebarPadding.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -110, 1, -55)
ContentArea.Position = UDim2.new(0, 110, 0, 55)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

## // Modular Tab Creation
local Tabs = {"Home", "Player", "Combat", "Visuals", "Settings"}
local ContentFrames = {}
local CurrentTabButton = nil

local function CreateTab(Name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, -20, 0, 24)
    TabButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    TabButton.BackgroundTransparency = 0.08
    TabButton.Text = Name
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 14
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.AutoButtonColor = false
    TabButton.Parent = Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 12)
    TabCorner.Parent = TabButton

    local TabGloss = Instance.new("Frame")
    TabGloss.Size = UDim2.new(1, 0, 0.4, 0)
    TabGloss.BackgroundColor3 = Color3.new(1, 1, 1)
    TabGloss.BackgroundTransparency = 0.8
    TabGloss.Parent = TabButton

    local NormalProps = {BackgroundTransparency = 0.08}
    local HoverProps = {BackgroundTransparency = 0.25}
    local ActiveProps = {BackgroundTransparency = 0.15}
    TabGloss.NormalTrans = 0.8
    TabGloss.ActiveTrans = 0.5

    ApplyHoverTween(TabButton, NormalProps, HoverProps)

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Visible = false
    ContentFrame.Parent = ContentArea

    local Placeholder = Instance.new("TextLabel")
    Placeholder.Size = UDim2.new(1, 0, 1, 0)
    Placeholder.BackgroundTransparency = 1
    Placeholder.Text = Name .. " Section\n\n(Placeholder - Add your features here)"
    Placeholder.Font = Enum.Font.Gotham
    Placeholder.TextSize = 20
    Placeholder.TextColor3 = Color3.fromRGB(180, 180, 180)
    Placeholder.Parent = ContentFrame

    ContentFrames[Name] = ContentFrame

    TabButton.MouseButton1Click:Connect(function()
        if CurrentTabButton == TabButton then return end

        if CurrentTabButton then
            TweenService:Create(CurrentTabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.08}):Play()
            local oldGloss = CurrentTabButton:FindFirstChild("Frame")
            if oldGloss then
                TweenService:Create(oldGloss, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.8}):Play()
            end
            ContentFrames[CurrentTabButton.Text].Visible = false
        end

        TweenService:Create(TabButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), ActiveProps):Play()
        TweenService:Create(TabGloss, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = TabGloss.ActiveTrans}):Play()
        ContentFrames[Name].Visible = true
        CurrentTabButton = TabButton
    end)

    return TabButton
end

for _, TabName in ipairs(Tabs) do
    CreateTab(TabName)
end

-- Default to Home
if #Sidebar:GetChildren() > 0 then
    Sidebar:GetChildren()[3].MouseButton1Click:Fire() -- First tab (Home)
end

## // Toggle Button (Minimized State)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.fromOffset(45, 45)
ToggleButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
ToggleButton.BackgroundTransparency = 0.08
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1.5
ToggleStroke.Color = Color3.fromRGB(0, 140, 255)
ToggleStroke.Parent = ToggleButton

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(1, 0, 1, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "N"
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextSize = 24
ToggleLabel.TextColor3 = Color3.fromRGB(0, 140, 255)
ToggleLabel.Parent = ToggleButton

## // Dragging Setup
MakeDraggable(MainFrame, Header)
MakeDraggable(ToggleButton, ToggleButton)

## // Minimize / Restore Logic
MinimizeButton.MouseButton1Click:Connect(function()
    ToggleButton.Position = MainFrame.Position
    MainFrame.Visible = false
    ToggleButton.Visible = true
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Position = ToggleButton.Position
    MainFrame.Visible = true
    ToggleButton.Visible = false
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

## // Force Reset Button
local ResetButton = Instance.new("TextButton")
ResetButton.Size = UDim2.fromOffset(120, 30)
ResetButton.Position = UDim2.fromOffset(10, 10)
ResetButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ResetButton.BackgroundTransparency = 0.3
ResetButton.Text = "Force Reset"
ResetButton.Font = Enum.Font.GothamBold
ResetButton.TextSize = 14
ResetButton.TextColor3 = Color3.new(1, 1, 1)
ResetButton.Parent = ScreenGui

ResetButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

## // Authentication Logic
VerifyButton.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text

    if enteredKey == "NEXUS" then  -- Change this to your desired key
        StatusLabel.Text = "Access Granted"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

        task.wait(0.8)
        AuthFrame.Visible = false
        MainFrame.Visible = true
    else
        StatusLabel.Text = "Invalid Key"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
