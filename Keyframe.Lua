--[[
    Nexus Key System - Fixed Version
    Repo: https://github.com/NexusHuby/Nexus-Libary
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    KEY_LINK = "https://discord.gg/yourlink",
    local VALID_KEYS = {
    "NEXU-L76M-0HUD-DPR9",
    "NEXU-RWBC-VNU5-KFTW",
    "NEXU-C22P-1K4H-0MXC",
    "NEXU-BLIO-I0HQ-OO8O",
    "NEXU-29Q0-KSTP-ULOD",
    "NEXU-IJII-4B6L-URHH",
    "NEXU-75FA-XCYO-65XJ",
    "NEXU-R3EV-A4T0-5I6W",
    "NEXU-NNGX-QO04-5TEG",
    "NEXU-Y2KI-PKG6-NFOM",
}
    -- FIXED: Raw GitHub URL format
    MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/refs/heads/main/Main.lua",
    COLORS = {
        Background = Color3.fromRGB(30, 30, 35),
        InputBg = Color3.fromRGB(45, 45, 55),
        GetKeyStart = Color3.fromRGB(80, 80, 90),
        GetKeyEnd = Color3.fromRGB(50, 50, 60),
        VerifyStart = Color3.fromRGB(120, 130, 255),
        VerifyEnd = Color3.fromRGB(88, 101, 242),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(87, 242, 135),
        White = Color3.fromRGB(255, 255, 255),
        Stroke = Color3.fromRGB(70, 70, 80),
        InputStroke = Color3.fromRGB(90, 90, 100),
        CloseButton = Color3.fromRGB(200, 200, 200),
        CloseButtonHover = Color3.fromRGB(255, 100, 100)
    },
    GRADIENT_PRESETS = {
        {Color3.fromRGB(40, 40, 50), Color3.fromRGB(25, 25, 30), 45},
        {Color3.fromRGB(35, 35, 45), Color3.fromRGB(45, 40, 55), 90},
        {Color3.fromRGB(30, 35, 45), Color3.fromRGB(40, 35, 50), 135},
        {Color3.fromRGB(45, 40, 45), Color3.fromRGB(30, 30, 35), 180},
        {Color3.fromRGB(35, 40, 45), Color3.fromRGB(45, 45, 55), 225},
        {Color3.fromRGB(40, 35, 45), Color3.fromRGB(50, 45, 55), 270},
        {Color3.fromRGB(30, 40, 40), Color3.fromRGB(40, 45, 50), 315},
        {Color3.fromRGB(45, 45, 50), Color3.fromRGB(30, 30, 35), 360}
    }
}

-- File names for key storage
local KEY_FILE = "NexusCache_9821.dat"
local HWID_FILE = "NexusID_7392.dat"

-- Generate HWID
local function generateHWID()
    return tostring(game:GetService("HttpService"):GenerateGUID(false))
end

-- Save key
local function saveKey(key)
    local success = pcall(function()
        local hwid = generateHWID()
        local data = {
            key = key,
            hwid = hwid,
            timestamp = os.time()
        }
        writefile(KEY_FILE, HttpService:JSONEncode(data))
        writefile(HWID_FILE, hwid)
    end)
    return success
end

-- Load saved key
local function loadSavedKey()
    local success, result = pcall(function()
        if not isfile(KEY_FILE) or not isfile(HWID_FILE) then
            return nil
        end
        
        local data = HttpService:JSONDecode(readfile(KEY_FILE))
        local storedHWID = readfile(HWID_FILE)
        
        if data.hwid ~= storedHWID then
            return nil
        end
        
        for _, validKey in ipairs(CONFIG.VALID_KEYS) do
            if data.key:upper() == validKey:upper() then
                return data.key
            end
        end
        
        return nil
    end)
    
    return success and result or nil
end

-- FIXED: Load main script function (Line 121)
local function loadMainScript()
    local success, result = pcall(function()
        -- FIXED: Proper HTTP request and loadstring execution
        local response = game:HttpGet(CONFIG.MAIN_SCRIPT_URL)
        if response and #response > 0 then
            -- FIXED: Execute the loaded script properly
            local loadedFunction, loadError = loadstring(response)
            if loadedFunction then
                return loadedFunction()
            else
                error("Failed to load script: " .. tostring(loadError))
            end
        else
            error("Empty response from server")
        end
    end)
    
    if not success then
        warn("Failed to load main script: " .. tostring(result))
        -- Show error UI
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "ErrorGui"
        errorGui.Parent = playerGui
        
        local errorFrame = Instance.new("Frame")
        errorFrame.Size = UDim2.new(0, 300, 0, 100)
        errorFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
        errorFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        errorFrame.Parent = errorGui
        
        local errorCorner = Instance.new("UICorner")
        errorCorner.CornerRadius = UDim.new(0, 12)
        errorCorner.Parent = errorFrame
        
        local errorText = Instance.new("TextLabel")
        errorText.Size = UDim2.new(1, -20, 1, 0)
        errorText.Position = UDim2.new(0, 10, 0, 0)
        errorText.BackgroundTransparency = 1
        errorText.Font = Enum.Font.GothamBold
        errorText.Text = "Failed to load main script!\nCheck your internet connection."
        errorText.TextColor3 = Color3.fromRGB(255, 100, 100)
        errorText.TextSize = 14
        errorText.TextWrapped = true
        errorText.Parent = errorFrame
        
        task.delay(3, function()
            errorGui:Destroy()
        end)
    end
    
    return success
end

-- Check for saved key on startup
local savedKey = loadSavedKey()
if savedKey then
    print("Key found! Loading main script...")
    loadMainScript()
    return -- Exit key system script
end

-- If no saved key, show key system UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NexusKeySystem"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main container
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = CONFIG.COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Animated Background Gradient
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.GRADIENT_PRESETS[1][1]),
    ColorSequenceKeypoint.new(1, CONFIG.GRADIENT_PRESETS[1][2])
})
bgGradient.Rotation = CONFIG.GRADIENT_PRESETS[1][3]
bgGradient.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = CONFIG.COLORS.Stroke
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "X"
closeButton.TextColor3 = CONFIG.COLORS.CloseButton
closeButton.TextSize = 18
closeButton.ZIndex = 10
closeButton.Parent = mainFrame

-- Glossy overlay
local glossOverlay = Instance.new("Frame")
glossOverlay.Name = "GlossOverlay"
glossOverlay.Size = UDim2.new(1, 0, 1, 0)
glossOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glossOverlay.BackgroundTransparency = 0.95
glossOverlay.BorderSizePixel = 0
glossOverlay.ZIndex = 2
glossOverlay.Parent = mainFrame

local glossCorner = Instance.new("UICorner")
glossCorner.CornerRadius = UDim.new(0, 16)
glossCorner.Parent = glossOverlay

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 5
contentContainer.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "KEY SYSTEM"
titleLabel.TextColor3 = CONFIG.COLORS.White
titleLabel.TextSize = 28
titleLabel.ZIndex = 5
titleLabel.Parent = contentContainer

-- Subtitle
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(1, 0, 0, 25)
subtitleLabel.Position = UDim2.new(0, 0, 0, 65)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Text = "Enter your access key to continue"
subtitleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitleLabel.TextSize = 14
subtitleLabel.ZIndex = 5
subtitleLabel.Parent = contentContainer

-- Key input frame
local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(0, 320, 0, 45)
inputFrame.Position = UDim2.new(0.5, -160, 0, 110)
inputFrame.BackgroundColor3 = CONFIG.COLORS.InputBg
inputFrame.BorderSizePixel = 0
inputFrame.ZIndex = 5
inputFrame.Parent = contentContainer

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputFrame

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = CONFIG.COLORS.InputStroke
inputStroke.Thickness = 1.2
inputStroke.Parent = inputFrame

local inputGloss = Instance.new("Frame")
inputGloss.Name = "InputGloss"
inputGloss.Size = UDim2.new(1, 0, 0.5, 0)
inputGloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputGloss.BackgroundTransparency = 0.9
inputGloss.BorderSizePixel = 0
inputGloss.ZIndex = 6
inputGloss.Parent = inputFrame

local inputGlossCorner = Instance.new("UICorner")
inputGlossCorner.CornerRadius = UDim.new(0, 10)
inputGlossCorner.Parent = inputGloss

local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Size = UDim2.new(1, -20, 1, 0)
keyInput.Position = UDim2.new(0, 10, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.Font = Enum.Font.Gotham
keyInput.PlaceholderText = "Enter Key Here..."
keyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
keyInput.Text = ""
keyInput.TextColor3 = CONFIG.COLORS.White
keyInput.TextSize = 16
keyInput.ClearTextOnFocus = false
keyInput.ZIndex = 6
keyInput.Parent = inputFrame

-- Button container
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0, 320, 0, 45)
buttonContainer.Position = UDim2.new(0.5, -160, 0, 170)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ZIndex = 5
buttonContainer.Parent = contentContainer

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(0, 155, 1, 0)
getKeyButton.Position = UDim2.new(0, 0, 0, 0)
getKeyButton.BackgroundColor3 = CONFIG.COLORS.GetKeyStart
getKeyButton.BorderSizePixel = 0
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.Text = "Get Key"
getKeyButton.TextColor3 = CONFIG.COLORS.White
getKeyButton.TextSize = 14
getKeyButton.AutoButtonColor = false
getKeyButton.ZIndex = 6
getKeyButton.Parent = buttonContainer

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 10)
getKeyCorner.Parent = getKeyButton

local getKeyGradient = Instance.new("UIGradient")
getKeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.COLORS.GetKeyStart),
    ColorSequenceKeypoint.new(1, CONFIG.COLORS.GetKeyEnd)
})
getKeyGradient.Rotation = 90
getKeyGradient.Parent = getKeyButton

local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Color = Color3.fromRGB(100, 100, 110)
getKeyStroke.Thickness = 1
getKeyStroke.Parent = getKeyButton

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Name = "VerifyButton"
verifyButton.Size = UDim2.new(0, 155, 1, 0)
verifyButton.Position = UDim2.new(1, -155, 0, 0)
verifyButton.BackgroundColor3 = CONFIG.COLORS.VerifyStart
verifyButton.BorderSizePixel = 0
verifyButton.Font = Enum.Font.GothamBold
verifyButton.Text = "Verify"
verifyButton.TextColor3 = CONFIG.COLORS.White
verifyButton.TextSize = 14
verifyButton.AutoButtonColor = false
verifyButton.ZIndex = 6
verifyButton.Parent = buttonContainer

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 10)
verifyCorner.Parent = verifyButton

local verifyGradient = Instance.new("UIGradient")
verifyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.COLORS.VerifyStart),
    ColorSequenceKeypoint.new(1, CONFIG.COLORS.VerifyEnd)
})
verifyGradient.Rotation = 90
verifyGradient.Parent = verifyButton

local verifyStroke = Instance.new("UIStroke")
verifyStroke.Color = Color3.fromRGB(140, 150, 255)
verifyStroke.Thickness = 1
verifyStroke.Parent = verifyButton

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(0, 320, 0, 25)
statusLabel.Position = UDim2.new(0.5, -160, 0, 225)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 13
statusLabel.ZIndex = 5
statusLabel.Parent = contentContainer

-- Footer
local footerFrame = Instance.new("Frame")
footerFrame.Name = "Footer"
footerFrame.Size = UDim2.new(0, 320, 0, 40)
footerFrame.Position = UDim2.new(0.5, -160, 0, 255)
footerFrame.BackgroundTransparency = 1
footerFrame.ZIndex = 5
footerFrame.Parent = contentContainer

local footerContainer = Instance.new("Frame")
footerContainer.Name = "FooterContainer"
footerContainer.Size = UDim2.new(1, 0, 1, 0)
footerContainer.BackgroundTransparency = 1
footerContainer.Parent = footerFrame

local footerList = Instance.new("UIListLayout")
footerList.FillDirection = Enum.FillDirection.Horizontal
footerList.HorizontalAlignment = Enum.HorizontalAlignment.Center
footerList.VerticalAlignment = Enum.VerticalAlignment.Center
footerList.SortOrder = Enum.SortOrder.LayoutOrder
footerList.Padding = UDim.new(0, 4)
footerList.Parent = footerContainer

local text1 = Instance.new("TextLabel")
text1.Name = "Text1"
text1.Size = UDim2.new(0, 0, 1, 0)
text1.AutomaticSize = Enum.AutomaticSize.X
text1.BackgroundTransparency = 1
text1.Font = Enum.Font.Gotham
text1.Text = "The Key is"
text1.TextColor3 = CONFIG.COLORS.White
text1.TextSize = 14
text1.LayoutOrder = 1
text1.ZIndex = 5
text1.Parent = footerContainer

local textFree = Instance.new("TextLabel")
textFree.Name = "TextFree"
textFree.Size = UDim2.new(0, 0, 1, 0)
textFree.AutomaticSize = Enum.AutomaticSize.X
textFree.BackgroundTransparency = 1
textFree.Font = Enum.Font.GothamBold
textFree.Text = "100% Free"
textFree.TextColor3 = CONFIG.COLORS.Success
textFree.TextSize = 14
textFree.LayoutOrder = 2
textFree.ZIndex = 5
textFree.Parent = footerContainer

local text2 = Instance.new("TextLabel")
text2.Name = "Text2"
text2.Size = UDim2.new(0, 0, 1, 0)
text2.AutomaticSize = Enum.AutomaticSize.X
text2.BackgroundTransparency = 1
text2.Font = Enum.Font.Gotham
text2.Text = "in the"
text2.TextColor3 = CONFIG.COLORS.White
text2.TextSize = 14
text2.LayoutOrder = 3
text2.ZIndex = 5
text2.Parent = footerContainer

local textDiscord = Instance.new("TextLabel")
textDiscord.Name = "TextDiscord"
textDiscord.Size = UDim2.new(0, 0, 1, 0)
textDiscord.AutomaticSize = Enum.AutomaticSize.X
textDiscord.BackgroundTransparency = 1
textDiscord.Font = Enum.Font.GothamBold
textDiscord.Text = "Discord"
textDiscord.TextColor3 = CONFIG.COLORS.Accent
textDiscord.TextSize = 14
textDiscord.LayoutOrder = 4
textDiscord.ZIndex = 5
textDiscord.Parent = footerContainer

-- Animations
local TWEEN_INFO = {
    Hover = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Click = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Float = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    GradientShift = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
    Fade = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Close = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
}

-- Floating animation
TweenService:Create(mainFrame, TWEEN_INFO.Float, {
    Position = UDim2.new(0.5, -200, 0.5, -145)
}):Play()

-- Gradient Animation
local currentGradientIndex = 1
local isGradientAnimating = false

local function animateToNextGradient()
    if isGradientAnimating then return end
    isGradientAnimating = true
    
    currentGradientIndex = currentGradientIndex + 1
    if currentGradientIndex > #CONFIG.GRADIENT_PRESETS then
        currentGradientIndex = 1
    end
    
    local preset = CONFIG.GRADIENT_PRESETS[currentGradientIndex]
    local color1, color2, rotation = preset[1], preset[2], preset[3]
    
    local colorTween = TweenService:Create(bgGradient, TWEEN_INFO.GradientShift, {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }),
        Rotation = rotation
    })
    
    colorTween.Completed:Connect(function()
        isGradientAnimating = false
        task.delay(2, animateToNextGradient)
    end)
    
    colorTween:Play()
end

task.delay(2, animateToNextGradient)

-- Close Button
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TWEEN_INFO.Hover, {
        TextColor3 = CONFIG.COLORS.CloseButtonHover,
        TextSize = 20
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TWEEN_INFO.Hover, {
        TextColor3 = CONFIG.COLORS.CloseButton,
        TextSize = 18
    }):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TWEEN_INFO.Close, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Rotation = 10
    }):Play()
    
    for _, child in ipairs(mainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                TweenService:Create(child, TWEEN_INFO.Close, {TextTransparency = 1}):Play()
            end
            if child:IsA("Frame") then
                TweenService:Create(child, TWEEN_INFO.Close, {BackgroundTransparency = 1}):Play()
            end
            if child:IsA("UIStroke") then
                TweenService:Create(child, TWEEN_INFO.Close, {Transparency = 1}):Play()
            end
        end
    end
    
    task.delay(0.4, function()
        screenGui:Destroy()
    end)
end)

-- Button hover effects
local function setupGradientButtonHover(button, gradient, originalStart, originalEnd, hoverStart, hoverEnd, stroke)
    button.MouseEnter:Connect(function()
        TweenService:Create(gradient, TWEEN_INFO.Hover, {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, hoverStart),
                ColorSequenceKeypoint.new(1, hoverEnd)
            })
        }):Play()
        
        TweenService:Create(button, TWEEN_INFO.Hover, {
            Size = UDim2.new(0, 159, 0, 49),
            Position = button.Position + UDim2.new(0, -2, 0, -2)
        }):Play()
        
        if stroke then
            TweenService:Create(stroke, TWEEN_INFO.Hover, {Transparency = 0.5}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(gradient, TWEEN_INFO.Hover, {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, originalStart),
                ColorSequenceKeypoint.new(1, originalEnd)
            })
        }):Play()
        
        TweenService:Create(button, TWEEN_INFO.Hover, {
            Size = UDim2.new(0, 155, 0, 45),
            Position = button.Position + UDim2.new(0, 2, 0, 2)
        }):Play()
        
        if stroke then
            TweenService:Create(stroke, TWEEN_INFO.Hover, {Transparency = 0}):Play()
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TWEEN_INFO.Click, {Size = UDim2.new(0, 151, 0, 41)}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TWEEN_INFO.Click, {Size = UDim2.new(0, 159, 0, 49)}):Play()
    end)
end

setupGradientButtonHover(
    getKeyButton, 
    getKeyGradient, 
    CONFIG.COLORS.GetKeyStart, 
    CONFIG.COLORS.GetKeyEnd,
    Color3.fromRGB(100, 100, 110),
    Color3.fromRGB(70, 70, 80),
    getKeyStroke
)

setupGradientButtonHover(
    verifyButton, 
    verifyGradient, 
    CONFIG.COLORS.VerifyStart, 
    CONFIG.COLORS.VerifyEnd,
    Color3.fromRGB(150, 160, 255),
    Color3.fromRGB(110, 123, 255),
    verifyStroke
)

-- Input effects
keyInput.Focused:Connect(function()
    TweenService:Create(inputFrame, TWEEN_INFO.Hover, {BackgroundColor3 = Color3.fromRGB(55, 55, 65)}):Play()
    TweenService:Create(inputStroke, TWEEN_INFO.Hover, {Color = Color3.fromRGB(120, 120, 140), Thickness = 1.8}):Play()
end)

keyInput.FocusLost:Connect(function()
    TweenService:Create(inputFrame, TWEEN_INFO.Hover, {BackgroundColor3 = CONFIG.COLORS.InputBg}):Play()
    TweenService:Create(inputStroke, TWEEN_INFO.Hover, {Color = CONFIG.COLORS.InputStroke, Thickness = 1.2}):Play()
end)

-- Get Key
getKeyButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "Link copied to clipboard!"
    statusLabel.TextColor3 = CONFIG.COLORS.Success
    
    keyInput.Text = CONFIG.KEY_LINK
    keyInput:CaptureFocus()
    keyInput:SelectAll()
    
    task.delay(3, function()
        if statusLabel.Text == "Link copied to clipboard!" then
            statusLabel.Text = ""
        end
    end)
end)

-- Verify and Load Main Script
verifyButton.MouseButton1Click:Connect(function()
    local enteredKey = keyInput.Text:gsub("%s+", "")
    
    if enteredKey == "" then
        statusLabel.Text = "Please enter a key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        local originalPos = inputFrame.Position
        for i = 1, 5 do
            inputFrame.Position = originalPos + UDim2.new(0, (i % 2 == 0 and 5 or -5), 0, 0)
            task.wait(0.05)
        end
        inputFrame.Position = originalPos
        return
    end
    
    local isValid = false
    for _, validKey in ipairs(CONFIG.VALID_KEYS) do
        if enteredKey:upper() == validKey:upper() then
            isValid = true
            break
        end
    end
    
    if isValid then
        local saved = saveKey(enteredKey)
        if saved then
            print("Key saved successfully!")
        else
            warn("Failed to save key (executor may not support file system)")
        end
        
        statusLabel.Text = "Success! Loading main script..."
        statusLabel.TextColor3 = CONFIG.COLORS.Success
        
        TweenService:Create(mainFrame, TWEEN_INFO.Fade, {BackgroundTransparency = 1}):Play()
        
        for _, child in ipairs(mainFrame:GetDescendants()) do
            if child:IsA("GuiObject") and child ~= mainFrame then
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    TweenService:Create(child, TWEEN_INFO.Fade, {TextTransparency = 1}):Play()
                end
                if child:IsA("Frame") then
                    TweenService:Create(child, TWEEN_INFO.Fade, {BackgroundTransparency = 1}):Play()
                end
                if child:IsA("UIStroke") then
                    TweenService:Create(child, TWEEN_INFO.Fade, {Transparency = 1}):Play()
                end
            end
        end
        
        task.delay(0.6, function()
            screenGui:Destroy()
            loadMainScript()
        end)
    else
        statusLabel.Text = "Invalid key! Please try again."
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        local originalPos = inputFrame.Position
        for i = 1, 5 do
            inputFrame.Position = originalPos + UDim2.new(0, (i % 2 == 0 and 5 or -5), 0, 0)
            task.wait(0.05)
        end
        inputFrame.Position = originalPos
        
        keyInput.Text = ""
    end
end)

-- Entrance animation
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
mainFrame.BackgroundTransparency = 1

for _, child in ipairs(mainFrame:GetDescendants()) do
    if child:IsA("GuiObject") then
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
            child.TextTransparency = 1
        end
        if child:IsA("Frame") then
            child.BackgroundTransparency = 1
        end
        if child:IsA("UIStroke") then
            child.Transparency = 1
        end
    end
end

task.wait(0.1)
TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -200, 0.5, -150),
    BackgroundTransparency = 0
}):Play()

task.delay(0.2, function()
    for _, child in ipairs(mainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0
                }):Play()
            end
            if child:IsA("Frame") and child.Name ~= "GlossOverlay" and child.Name ~= "InputGloss" then
                local originalTransparency = (child.Name == "InputFrame" or child.Name == "GetKeyButton" or child.Name == "VerifyButton") and 0 or 1
                TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = originalTransparency
                }):Play()
            end
            if child:IsA("UIStroke") then
                TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 0
                }):Play()
            end
        end
    end
end)

print("Nexus Key System Loaded Successfully!")
