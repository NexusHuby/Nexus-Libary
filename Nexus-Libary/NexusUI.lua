-- Advanced Roblox GUI Script with Key System
-- Features: Key verification, smooth animations, draggable windows, tab system

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    CorrectKey = "ROBLOX2025", -- Change this to your actual key
    KeySaveFile = "AdvancedGUI_Key",
    AnimationSpeed = 0.5,
    Colors = {
        Background = Color3.fromRGB(20, 20, 20),
        Blue = Color3.fromRGB(0, 150, 255),
        Green = Color3.fromRGB(0, 255, 100),
        Purple = Color3.fromRGB(150, 0, 255),
        Red = Color3.fromRGB(255, 50, 50),
    }
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Utility Functions
local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function tweenObject(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or CONFIG.AnimationSpeed,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos

    dragHandle = dragHandle or frame

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("RunService").Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - mousePos
            tweenObject(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1, Enum.EasingStyle.Linear)
        end
    end)
end

local function makeResizable(frame)
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.AnchorPoint = Vector2.new(1, 1)
    resizeHandle.BackgroundColor3 = CONFIG.Colors.Blue
    resizeHandle.Text = ""
    resizeHandle.Parent = frame
    createCorner(resizeHandle, 4)

    local resizing = false
    local startSize, startPos

    resizeHandle.MouseButton1Down:Connect(function()
        resizing = true
        startSize = frame.Size
        startPos = UserInputService:GetMouseLocation()
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    game:GetService("RunService").Heartbeat:Connect(function()
        if resizing then
            local currentPos = UserInputService:GetMouseLocation()
            local delta = currentPos - startPos
            local newSize = UDim2.new(
                0,
                math.max(300, startSize.X.Offset + delta.X),
                0,
                math.max(200, startSize.Y.Offset + delta.Y)
            )
            frame.Size = newSize
        end
    end)
end

-- Key System Frame
local function createKeySystem()
    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "KeyFrame"
    keyFrame.Size = UDim2.new(0, 400, 0, 250)
    keyFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    keyFrame.BackgroundColor3 = CONFIG.Colors.Background
    keyFrame.BackgroundTransparency = 0.08
    keyFrame.Parent = screenGui
    createStroke(keyFrame, CONFIG.Colors.Blue, 3)
    createCorner(keyFrame, 12)

    -- Animated glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    glow.ImageColor3 = CONFIG.Colors.Blue
    glow.ImageTransparency = 0.7
    glow.Parent = keyFrame

    -- Pulse animation for glow
    spawn(function()
        while keyFrame.Parent do
            tweenObject(glow, {ImageTransparency = 0.5}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1)
            tweenObject(glow, {ImageTransparency = 0.8}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            wait(1)
        end
    end)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "KEY VERIFICATION"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = keyFrame

    -- Key Input
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -60, 0, 40)
    keyInput.Position = UDim2.new(0, 30, 0, 80)
    keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    keyInput.BackgroundTransparency = 0.3
    keyInput.PlaceholderText = "Enter Key Here..."
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.TextSize = 16
    keyInput.Font = Enum.Font.Gotham
    keyInput.Parent = keyFrame
    createStroke(keyInput, CONFIG.Colors.Blue, 2)
    createCorner(keyInput, 8)

    -- Verify Button
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0, 160, 0, 40)
    verifyBtn.Position = UDim2.new(0, 30, 0, 140)
    verifyBtn.BackgroundColor3 = CONFIG.Colors.Background
    verifyBtn.Text = "Verify"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextSize = 18
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Parent = keyFrame
    createStroke(verifyBtn, CONFIG.Colors.Green, 2)
    createCorner(verifyBtn, 8)

    -- Get Key Button
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Size = UDim2.new(0, 160, 0, 40)
    getKeyBtn.Position = UDim2.new(1, -190, 0, 140)
    getKeyBtn.BackgroundColor3 = CONFIG.Colors.Background
    getKeyBtn.Text = "Get Key"
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.TextSize = 18
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.Parent = keyFrame
    createStroke(getKeyBtn, CONFIG.Colors.Purple, 2)
    createCorner(getKeyBtn, 8)

    -- Info Label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 30)
    infoLabel.Position = UDim2.new(0, 20, 1, -40)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "🔑 Key is 100% FREE in Discord!"
    infoLabel.TextColor3 = CONFIG.Colors.Blue
    infoLabel.TextSize = 14
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.Parent = keyFrame

    -- Button Hover Effects
    local function addButtonEffect(button, hoverColor)
        button.MouseEnter:Connect(function()
            tweenObject(button, {BackgroundTransparency = 0.3}, 0.2)
        end)
        button.MouseLeave:Connect(function()
            tweenObject(button, {BackgroundTransparency = 0}, 0.2)
        end)
    end

    addButtonEffect(verifyBtn, CONFIG.Colors.Green)
    addButtonEffect(getKeyBtn, CONFIG.Colors.Purple)

    -- Get Key Button Function
    getKeyBtn.MouseButton1Click:Connect(function()
        setclipboard("https://discord.gg/yourserver") -- Change to your Discord link
        infoLabel.Text = "📋 Discord Link Copied!"
        infoLabel.TextColor3 = CONFIG.Colors.Green
        wait(2)
        infoLabel.Text = "🔑 Key is 100% FREE in Discord!"
        infoLabel.TextColor3 = CONFIG.Colors.Blue
    end)

    return keyFrame, verifyBtn, keyInput
end

-- Main GUI Frame
local function createMainGUI()
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = CONFIG.Colors.Background
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    createStroke(mainFrame, CONFIG.Colors.Blue, 3)
    createCorner(mainFrame, 12)

    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    topBar.BackgroundTransparency = 0.3
    topBar.Parent = mainFrame
    createCorner(topBar, 12)

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 200, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚡ Advanced GUI"
    titleLabel.TextColor3 = CONFIG.Colors.Blue
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar

    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -75, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = CONFIG.Colors.Blue
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = topBar
    createCorner(minimizeBtn, 6)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = CONFIG.Colors.Red
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = topBar
    createCorner(closeBtn, 6)

    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -50)
    tabContainer.Position = UDim2.new(0, 10, 0, 45)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabContainer.BackgroundTransparency = 0.3
    tabContainer.Parent = mainFrame
    createCorner(tabContainer, 8)

    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -145, 1, -50)
    contentContainer.Position = UDim2.new(0, 135, 0, 45)
    contentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    contentContainer.BackgroundTransparency = 0.3
    contentContainer.Parent = mainFrame
    createCorner(contentContainer, 8)

    -- Tab System
    local tabs = {"Home", "Scripts", "Player", "Settings"}
    local tabButtons = {}
    local contentPages = {}

    for i, tabName in ipairs(tabs) do
        -- Tab Button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -10, 0, 40)
        tabBtn.Position = UDim2.new(0, 5, 0, (i - 1) * 45 + 5)
        tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.TextSize = 14
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Parent = tabContainer
        createCorner(tabBtn, 6)
        table.insert(tabButtons, tabBtn)

        -- Content Page
        local contentPage = Instance.new("ScrollingFrame")
        contentPage.Name = tabName .. "Page"
        contentPage.Size = UDim2.new(1, -20, 1, -20)
        contentPage.Position = UDim2.new(0, 10, 0, 10)
        contentPage.BackgroundTransparency = 1
        contentPage.ScrollBarThickness = 6
        contentPage.ScrollBarImageColor3 = CONFIG.Colors.Blue
        contentPage.Visible = (i == 1)
        contentPage.Parent = contentContainer
        table.insert(contentPages, contentPage)

        -- Add sample content
        local sampleLabel = Instance.new("TextLabel")
        sampleLabel.Size = UDim2.new(1, -20, 0, 100)
        sampleLabel.Position = UDim2.new(0, 10, 0, 10)
        sampleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        sampleLabel.Text = "Welcome to " .. tabName .. " Tab!\n\nAdd your features here."
        sampleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sampleLabel.TextSize = 16
        sampleLabel.Font = Enum.Font.Gotham
        sampleLabel.TextWrapped = true
        sampleLabel.Parent = contentPage
        createCorner(sampleLabel, 8)

        -- Tab Button Click
        tabBtn.MouseButton1Click:Connect(function()
            for j, btn in ipairs(tabButtons) do
                if j == i then
                    tweenObject(btn, {BackgroundColor3 = CONFIG.Colors.Blue}, 0.2)
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    contentPages[j].Visible = true
                else
                    tweenObject(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
                    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    contentPages[j].Visible = false
                end
            end
        end)
    end

    -- Set default active tab
    tabButtons[1].BackgroundColor3 = CONFIG.Colors.Blue
    tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)

    makeDraggable(mainFrame, topBar)
    makeResizable(mainFrame)

    return mainFrame, minimizeBtn, closeBtn
end

-- Minimized Button
local function createMinimizedButton()
    local miniBtn = Instance.new("ImageButton")
    miniBtn.Name = "MinimizedButton"
    miniBtn.Size = UDim2.new(0, 60, 0, 60)
    miniBtn.Position = UDim2.new(0, 20, 0.5, -30)
    miniBtn.BackgroundColor3 = CONFIG.Colors.Background
    miniBtn.BackgroundTransparency = 0.08
    miniBtn.Visible = false
    miniBtn.Parent = screenGui
    createStroke(miniBtn, CONFIG.Colors.Blue, 3)
    createCorner(miniBtn, 12)

    -- Icon (you can replace with actual image)
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "⚡"
    icon.TextColor3 = CONFIG.Colors.Blue
    icon.TextSize = 30
    icon.Font = Enum.Font.GothamBold
    icon.Parent = miniBtn

    makeDraggable(miniBtn)

    return miniBtn
end

-- Confirmation Dialog
local function createConfirmDialog(onConfirm)
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Name = "ConfirmFrame"
    confirmFrame.Size = UDim2.new(0, 350, 0, 180)
    confirmFrame.Position = UDim2.new(0.5, -175, 0.5, -90)
    confirmFrame.BackgroundColor3 = CONFIG.Colors.Background
    confirmFrame.BackgroundTransparency = 0.08
    confirmFrame.Parent = screenGui
    createStroke(confirmFrame, CONFIG.Colors.Red, 3)
    createCorner(confirmFrame, 12)

    -- Header
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -40, 0, 40)
    header.Position = UDim2.new(0, 20, 0, 15)
    header.BackgroundTransparency = 1
    header.Text = "⚠️ Are you sure?"
    header.TextColor3 = Color3.fromRGB(255, 255, 255)
    header.TextSize = 20
    header.Font = Enum.Font.GothamBold
    header.Parent = confirmFrame

    -- Description
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -40, 0, 50)
    description.Position = UDim2.new(0, 20, 0, 55)
    description.BackgroundTransparency = 1
    description.Text = "Press Close to close the frame\nor No to cancel."
    description.TextColor3 = Color3.fromRGB(200, 200, 200)
    description.TextSize = 14
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.Parent = confirmFrame

    -- Close Button
    local closeConfirmBtn = Instance.new("TextButton")
    closeConfirmBtn.Size = UDim2.new(0, 140, 0, 40)
    closeConfirmBtn.Position = UDim2.new(0, 20, 1, -55)
    closeConfirmBtn.BackgroundColor3 = CONFIG.Colors.Background
    closeConfirmBtn.Text = "Close"
    closeConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeConfirmBtn.TextSize = 16
    closeConfirmBtn.Font = Enum.Font.GothamBold
    closeConfirmBtn.Parent = confirmFrame
    createStroke(closeConfirmBtn, CONFIG.Colors.Red, 2)
    createCorner(closeConfirmBtn, 8)

    -- No Button
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 140, 0, 40)
    noBtn.Position = UDim2.new(1, -160, 1, -55)
    noBtn.BackgroundColor3 = CONFIG.Colors.Background
    noBtn.Text = "No"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.TextSize = 16
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Parent = confirmFrame
    createStroke(noBtn, CONFIG.Colors.Green, 2)
    createCorner(noBtn, 8)

    -- Animate in
    confirmFrame.Size = UDim2.new(0, 0, 0, 0)
    tweenObject(confirmFrame, {Size = UDim2.new(0, 350, 0, 180)}, 0.3, Enum.EasingStyle.Back)

    closeConfirmBtn.MouseButton1Click:Connect(function()
        tweenObject(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2).Completed:Connect(function()
            confirmFrame:Destroy()
            if onConfirm then onConfirm() end
        end)
    end)

    noBtn.MouseButton1Click:Connect(function()
        tweenObject(confirmFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2).Completed:Connect(function()
            confirmFrame:Destroy()
        end)
    end)
end

-- Check if key is saved
local function checkSavedKey()
    local success, savedKey = pcall(function()
        return readfile(CONFIG.KeySaveFile .. ".txt")
    end)
    return success and savedKey == CONFIG.CorrectKey
end

-- Save key
local function saveKey()
    pcall(function()
        writefile(CONFIG.KeySaveFile .. ".txt", CONFIG.CorrectKey)
    end)
end

-- Main Initialization
local function init()
    if checkSavedKey() then
        -- Key already verified, show main GUI
        local mainFrame, minimizeBtn, closeBtn = createMainGUI()
        local miniBtn = createMinimizedButton()
        
        -- Animate main frame in
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        mainFrame.Visible = true
        tweenObject(mainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.5, Enum.EasingStyle.Back)

        -- Minimize functionality
        minimizeBtn.MouseButton1Click:Connect(function()
            tweenObject(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3).Completed:Connect(function()
                mainFrame.Visible = false
                miniBtn.Visible = true
                tweenObject(miniBtn, {BackgroundTransparency = 0.08}, 0.2)
            end)
        end)

        miniBtn.MouseButton1Click:Connect(function()
            miniBtn.Visible = false
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            tweenObject(mainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3, Enum.EasingStyle.Back)
        end)

        -- Close functionality
        closeBtn.MouseButton1Click:Connect(function()
            createConfirmDialog(function()
                screenGui:Destroy()
            end)
        end)
    else
        -- Show key system
        local keyFrame, verifyBtn, keyInput = createKeySystem()
        
        -- Animate in
        keyFrame.Size = UDim2.new(0, 0, 0, 0)
        tweenObject(keyFrame, {Size = UDim2.new(0, 400, 0, 250)}, 0.5, Enum.EasingStyle.Back)

        verifyBtn.MouseButton1Click:Connect(function()
            if keyInput.Text == CONFIG.CorrectKey then
                saveKey()
                
                -- Success animation
                tweenObject(keyFrame, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Rotation = 180
                }, 0.5, Enum.EasingStyle.Back).Completed:Connect(function()
                    keyFrame:Destroy()
                    
                    -- Show main GUI
                    local mainFrame, minimizeBtn, closeBtn = createMainGUI()
                    local miniBtn = createMinimizedButton()
                    
                    mainFrame.Size = UDim2.new(0, 0, 0, 0)
                    mainFrame.Visible = true
                    tweenObject(mainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.5, Enum.EasingStyle.Back)

                    -- Minimize functionality
                    minimizeBtn.MouseButton1Click:Connect(function()
                        tweenObject(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3).Completed:Connect(function()
                            mainFrame.Visible = false
                            miniBtn.Visible = true
                            tweenObject(miniBtn, {BackgroundTransparency = 0.08}, 0.2)
                        end)
                    end)

                    miniBtn.MouseButton1Click:Connect(function()
                        miniBtn.Visible = false
                        mainFrame.Visible = true
                        mainFrame.Size = UDim2.new(0, 0, 0, 0)
                        tweenObject(mainFrame, {Size = UDim2.new(0, 600, 0, 400)}, 0.3, Enum.EasingStyle.Back)
                    end)

                    -- Close functionality
                    closeBtn.MouseButton1Click:Connect(function()
                        createConfirmDialog(function()
                            screenGui:Destroy()
                        end)
                    end)
                end)
            else
                -- Wrong key animation
                keyInput.Text = ""
                keyInput.PlaceholderText = "❌ Wrong Key! Try Again..."
                keyInput.PlaceholderColor3 = CONFIG.Colors.Red
                
                for i = 1, 3 do
                    tweenObject(keyFrame, {Position = UDim2.new(0.5, -210, 0.5, -125)}, 0.05)
                    wait(0.05)
                    tweenObject(keyFrame, {Position = UDim2.new(0.5, -190, 0.5, -125)}, 0.05)
                    wait(0.05)
                end
                tweenObject(keyFrame, {Position = UDim2.new(0.5, -200, 0.5, -125)}, 0.1)
                
                wait(1)
                keyInput.PlaceholderText = "Enter Key Here..."
                keyInput.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
            end
        end)
    end
end

-- Run the script
init()

print("Advanced GUI loaded successfully!")
