-- Polished Roblox GUI with Key System (LocalScript)
-- Place this in StarterPlayer > StarterPlayerScripts or execute via your executor
-- Features: Key verification (free key via "Get Key" button), smooth animations, draggable + resizable main GUI,
-- tab system, minimize with draggable opener button, close confirmation, glowing effects, hover scaling

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PolishedGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local correctKey = "grok"  -- The "free" key (case-sensitive)

-- Check if already verified this session
if player:FindFirstChild("KeyVerified") then
    CreateMainGUI()
else
    CreateKeyGUI()
end

-- Reusable button creator with hover effect
local function CreateButton(parent, text, position, outlineColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.35, 0, 0, 50)
    btn.Position = position
    btn.BackgroundColor3 = Color3.new(0, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Parent = parent

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = outlineColor
    stroke.Thickness = 3

    local scale = Instance.new("UIScale", btn)
    scale.Scale = 1

    btn.MouseEnter:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2), {Scale = 1.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2), {Scale = 1}):Play()
    end)

    return btn
end

function CreateKeyGUI()
    local keyFrame = Instance.new("Frame")
    keyFrame.Name = "KeyFrame"
    keyFrame.Size = UDim2.new(0, 350, 0, 450)
    keyFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
    keyFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    keyFrame.BackgroundTransparency = 0.08
    keyFrame.Parent = screenGui

    local corner = Instance.new("UICorner", keyFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", keyFrame)
    stroke.Thickness = 4
    stroke.Color = Color3.fromRGB(0, 120, 255)

    -- Glowing loop effect
    RunService.Heartbeat:Connect(function()
        stroke.Transparency = 0.3 + 0.3 * math.sin(tick() * 3)
    end)

    local scale = Instance.new("UIScale", keyFrame)
    scale.Scale = 0
    TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.BackgroundTransparency = 1
    title.Text = "Verification"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.Parent = keyFrame

    -- Key input
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.8, 0, 0, 50)
    keyBox.Position = UDim2.new(0.1, 0, 0.25, 0)
    keyBox.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    keyBox.PlaceholderText = "Enter Key"
    keyBox.TextColor3 = Color3.new(1, 1, 1)
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 18
    keyBox.Parent = keyFrame

    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)
    local boxStroke = Instance.new("UIStroke", keyBox)
    boxStroke.Color = Color3.fromRGB(0, 120, 255)
    boxStroke.Thickness = 2

    -- Buttons
    local verifyBtn = CreateButton(keyFrame, "Verify", UDim2.new(0.1, 0, 0.5, 0), Color3.fromRGB(0, 255, 0))
    local getKeyBtn = CreateButton(keyFrame, "Get Key", UDim2.new(0.55, 0, 0.5, 0), Color3.fromRGB(180, 0, 255))

    -- Info text
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.8, 0, 0, 100)
    infoLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "The key is 100% free in the discord!\nClick 'Get Key' to receive it."
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.TextSize = 18
    infoLabel.TextWrapped = true
    infoLabel.Parent = keyFrame

    -- Get Key fills the correct key (simulating "getting from discord")
    getKeyBtn.MouseButton1Click:Connect(function()
        keyBox.Text = correctKey
    end)

    -- Verify
    verifyBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == correctKey then
            -- Save state for this session
            local verified = Instance.new("BoolValue")
            verified.Name = "KeyVerified"
            verified.Value = true
            verified.Parent = player

            -- Smooth exit animation
            TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0}):Play()
            task.wait(0.5)
            keyFrame:Destroy()
            CreateMainGUI()
        else
            -- Shake on wrong key
            local originalPos = keyFrame.Position
            TweenService:Create(keyFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = originalPos + UDim2.new(0, 15, 0, 0)}):Play()
            task.wait(0.1)
            TweenService:Create(keyFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = originalPos + UDim2.new(0, -15, 0, 0)}):Play()
            task.wait(0.1)
            TweenService:Create(keyFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = originalPos}):Play()
        end
    end)
end

function CreateMainGUI()
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.08
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local corner = Instance.new("UICorner", mainFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Thickness = 4
    stroke.Color = Color3.fromRGB(0, 120, 255)

    RunService.Heartbeat:Connect(function()
        stroke.Transparency = 0.3 + 0.3 * math.sin(tick() * 3)
    end)

    local scale = Instance.new("UIScale", mainFrame)
    scale.Scale = 0
    TweenService:Create(scale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

    -- Top bar (draggable)
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    topBar.BackgroundTransparency = 0.3
    topBar.Parent = mainFrame

    local topCorner = Instance.new("UICorner", topBar)
    topCorner.CornerRadius = UDim.new(0, 12)

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Polished GUI"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.Parent = topBar

    -- Minimize & Close buttons
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 30
    minimizeBtn.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 22
    closeBtn.Parent = topBar

    -- Tab system
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 50)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = mainFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabContainer

    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, 0, 1, -90)
    contentContainer.Position = UDim2.new(0, 0, 0, 90)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    local tabs = {}
    local contents = {}

    local function AddTab(name, welcomeText)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 150, 1, 0)
        tabBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        tabBtn.Text = name
        tabBtn.TextColor3 = Color3.new(1, 1, 1)
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Parent = tabContainer

        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

        local tabStroke = Instance.new("UIStroke", tabBtn)
        tabStroke.Color = Color3.fromRGB(0, 120, 255)
        tabStroke.Transparency = 1
        tabStroke.Thickness = 3

        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.Visible = false
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Parent = contentContainer

        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -20, 0, 200)
        contentLabel.Position = UDim2.new(0, 10, 0, 10)
        contentLabel.BackgroundTransparency = 1
        contentLabel.Text = welcomeText or ("Welcome to the " .. name .. " tab!")
        contentLabel.TextColor3 = Color3.new(1, 1, 1)
        contentLabel.TextWrapped = true
        contentLabel.TextSize = 20
        contentLabel.Parent = content

        tabBtn.MouseButton1Click:Connect(function()
            for _, c in contents do c.Visible = false end
            for _, t in tabs do t.stroke.Transparency = 1 end
            content.Visible = true
            tabStroke.Transparency = 0
        end)

        table.insert(tabs, {btn = tabBtn, stroke = tabStroke})
        table.insert(contents, content)
    end

    AddTab("Home", "Welcome to your polished GUI!\nEnjoy the features.")
    AddTab("Scripts", "Script hub section\n(Execute scripts here)")
    AddTab("Settings", "GUI settings\n(Coming soon)")

    -- Default tab
    contents[1].Visible = true
    tabs[1].stroke.Transparency = 0

    -- Draggable (top bar)
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            updateDrag(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Resizable (bottom-right handle)
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    resizeHandle.Parent = mainFrame
    Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 5)

    local resizing, resizeStart, startSize
    local function updateResize(input)
        local delta = input.Position - resizeStart
        local newX = math.max(500, startSize.X.Offset + delta.X)
        local newY = math.max(400, startSize.Y.Offset + delta.Y)
        mainFrame.Size = UDim2.new(0, newX, 0, newY)
    end
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = mainFrame.Size
        end
    end)
    resizeHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input == dragInput then
            updateResize(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)

    -- Minimize
    local minimized = false
    local openBtn
    minimizeBtn.MouseButton1Click:Connect(function()
        if not minimized then
            TweenService:Create(scale, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Scale = 0}):Play()
            task.wait(0.4)
            mainFrame.Visible = false
            minimized = true

            -- Draggable opener button (empty ImageButton with blue stroke)
            openBtn = Instance.new("ImageButton")
            openBtn.Size = UDim2.new(0, 60, 0, 60)
            openBtn.Position = UDim2.new(0, 50, 0.5, -30)
            openBtn.BackgroundColor3 = Color3.new(0, 0, 0)
            openBtn.BackgroundTransparency = 0.3
            openBtn.Image = ""
            openBtn.Parent = screenGui

            Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1, 0)

            local openStroke = Instance.new("UIStroke", openBtn)
            openStroke.Color = Color3.fromRGB(0, 120, 255)
            openStroke.Thickness = 4
            RunService.Heartbeat:Connect(function()
                openStroke.Transparency = 0.2 + 0.3 * math.sin(tick() * 4)
            end)

            -- Make opener draggable
            local oDragging, oDragInput, oDragStart, oStartPos = false
            local function oUpdate(input)
                local delta = input.Position - oDragStart
                openBtn.Position = UDim2.new(oStartPos.X.Scale, oStartPos.X.Offset + delta.X, oStartPos.Y.Scale, oStartPos.Y.Offset + delta.Y)
            end
            openBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    oDragging = true
                    oDragStart = input.Position
                    oStartPos = openBtn.Position
                end
            end)
            openBtn.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    oDragInput = input
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if oDragging and input == oDragInput then
                    oUpdate(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    oDragging = false
                end
            end)

            openBtn.MouseButton1Click:Connect(function()
                mainFrame.Visible = true
                TweenService:Create(scale, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Scale = 1}):Play()
                openBtn:Destroy()
                minimized = false
            end)
        end
    end)

    -- Close with confirmation
    closeBtn.MouseButton1Click:Connect(function()
        local confFrame = Instance.new("Frame")
        confFrame.Size = UDim2.new(0, 350, 0, 200)
        confFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
        confFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        confFrame.BackgroundTransparency = 0.08
        confFrame.Parent = screenGui

        local cScale = Instance.new("UIScale", confFrame)
        cScale.Scale = 0
        TweenService:Create(cScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

        Instance.new("UICorner", confFrame).CornerRadius = UDim.new(0, 12)

        local cStroke = Instance.new("UIStroke", confFrame)
        cStroke.Color = Color3.fromRGB(255, 0, 0)
        cStroke.Thickness = 4

        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, 0, 0, 60)
        header.BackgroundTransparency = 1
        header.Text = "Are you sure?"
        header.TextColor3 = Color3.new(1, 1, 1)
        header.Font = Enum.Font.GothamBold
        header.TextSize = 26
        header.Parent = confFrame

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(0.9, 0, 0, 60)
        desc.Position = UDim2.new(0.05, 0, 0.3, 0)
        desc.BackgroundTransparency = 1
        desc.Text = "Press Close to close the GUI or No to cancel."
        desc.TextColor3 = Color3.new(1, 1, 1)
        desc.TextWrapped = true
        desc.TextSize = 18
        desc.Parent = confFrame

        local closeConf = CreateButton(confFrame, "Close", UDim2.new(0.1, 0, 0.65, 0), Color3.fromRGB(255, 0, 0))
        local noConf = CreateButton(confFrame, "No", UDim2.new(0.55, 0, 0.65, 0), Color3.fromRGB(0, 255, 0))

        closeConf.MouseButton1Click:Connect(function()
            TweenService:Create(cScale, TweenInfo.new(0.3), {Scale = 0}):Play()
            task.wait(0.3)
            screenGui:Destroy()
        end)

        noConf.MouseButton1Click:Connect(function()
            TweenService:Create(cScale, TweenInfo.new(0.3), {Scale = 0}):Play()
            task.wait(0.3)
            confFrame:Destroy()
        end)
    end)
end
