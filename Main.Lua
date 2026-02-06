--[[
    Premium Key System UI - Updated Design
    Created by: Assistant
    Features: Gradient buttons, stroke effects, centered footer, no shadows
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    KEY_LINK = "https://discord.gg/yourlink",
    VALID_KEYS = {"FREEKEY2024", "DISCORD123", "SPECIALACCESS"},
    COLORS = {
        Background = Color3.fromRGB(30, 30, 35),
        InputBg = Color3.fromRGB(45, 45, 55),
        -- Gradient colors for Get Key button (Cool gray to slate)
        GetKeyStart = Color3.fromRGB(80, 80, 90),
        GetKeyEnd = Color3.fromRGB(50, 50, 60),
        -- Gradient colors for Verify button (Discord purple gradient)
        VerifyStart = Color3.fromRGB(120, 130, 255),
        VerifyEnd = Color3.fromRGB(88, 101, 242),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(87, 242, 135),
        White = Color3.fromRGB(255, 255, 255),
        Stroke = Color3.fromRGB(70, 70, 80),
        InputStroke = Color3.fromRGB(90, 90, 100)
    }
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumKeySystem"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main container (no shadow frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = CONFIG.COLORS.Background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Main corner radius
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

-- Main Frame Stroke
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = CONFIG.COLORS.Stroke
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Subtle gradient overlay for glossy effect
local gradientFrame = Instance.new("Frame")
gradientFrame.Name = "Gloss"
gradientFrame.Size = UDim2.new(1, 0, 0.5, 0)
gradientFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
gradientFrame.BackgroundTransparency = 0.95
gradientFrame.BorderSizePixel = 0
gradientFrame.Parent = mainFrame

local gradientCorner = Instance.new("UICorner")
gradientCorner.CornerRadius = UDim.new(0, 16)
gradientCorner.Parent = gradientFrame

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
titleLabel.Parent = mainFrame

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
subtitleLabel.Parent = mainFrame

-- Key input frame
local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(0, 320, 0, 45)
inputFrame.Position = UDim2.new(0.5, -160, 0, 110)
inputFrame.BackgroundColor3 = CONFIG.COLORS.InputBg
inputFrame.BorderSizePixel = 0
inputFrame.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputFrame

-- Input Stroke
local inputStroke = Instance.new("UIStroke")
inputStroke.Color = CONFIG.COLORS.InputStroke
inputStroke.Thickness = 1.2
inputStroke.Parent = inputFrame

-- Input gloss effect
local inputGloss = Instance.new("Frame")
inputGloss.Name = "InputGloss"
inputGloss.Size = UDim2.new(1, 0, 0.5, 0)
inputGloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
inputGloss.BackgroundTransparency = 0.9
inputGloss.BorderSizePixel = 0
inputGloss.Parent = inputFrame

local inputGlossCorner = Instance.new("UICorner")
inputGlossCorner.CornerRadius = UDim.new(0, 10)
inputGlossCorner.Parent = inputGloss

-- TextBox for key input
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
keyInput.Parent = inputFrame

-- Button container
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0, 320, 0, 45)
buttonContainer.Position = UDim2.new(0.5, -160, 0, 170)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- Get Key Button with Gradient
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
getKeyButton.Parent = buttonContainer

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 10)
getKeyCorner.Parent = getKeyButton

-- Get Key Gradient
local getKeyGradient = Instance.new("UIGradient")
getKeyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.COLORS.GetKeyStart),
    ColorSequenceKeypoint.new(1, CONFIG.COLORS.GetKeyEnd)
})
getKeyGradient.Rotation = 90
getKeyGradient.Parent = getKeyButton

-- Get Key Stroke
local getKeyStroke = Instance.new("UIStroke")
getKeyStroke.Color = Color3.fromRGB(100, 100, 110)
getKeyStroke.Thickness = 1
getKeyStroke.Parent = getKeyButton

-- Verify Button with Gradient
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
verifyButton.Parent = buttonContainer

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0, 10)
verifyCorner.Parent = verifyButton

-- Verify Gradient (Purple gradient)
local verifyGradient = Instance.new("UIGradient")
verifyGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, CONFIG.COLORS.VerifyStart),
    ColorSequenceKeypoint.new(1, CONFIG.COLORS.VerifyEnd)
})
verifyGradient.Rotation = 90
verifyGradient.Parent = verifyButton

-- Verify Stroke
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
statusLabel.Parent = mainFrame

-- Footer text - FIXED CENTERING
local footerFrame = Instance.new("Frame")
footerFrame.Name = "Footer"
footerFrame.Size = UDim2.new(0, 320, 0, 40)
footerFrame.Position = UDim2.new(0.5, -160, 0, 255)
footerFrame.BackgroundTransparency = 1
footerFrame.Parent = mainFrame

-- Calculate total width to center properly
-- "The Key is" (60) + space + "100% Free" (70) + space + "in the" (45) + space + "Discord" (55) = roughly 230 + spacing
-- We'll use a more precise centering approach with a single TextLabel using rich text or separate labels with proper positioning

-- Alternative: Use a single text label with styled segments using UIListLayout for perfect centering
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
footerList.Padding = UDim.new(0, 4) -- 4px spacing between elements
footerList.Parent = footerContainer

-- "The Key is" - White
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
text1.Parent = footerContainer

-- "100% Free" - Green
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
textFree.Parent = footerContainer

-- "in the" - White
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
text2.Parent = footerContainer

-- "Discord" - Purple
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
textDiscord.Parent = footerContainer

-- Animation Setup
local TWEEN_INFO = {
    Hover = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Click = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Float = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    Pulse = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    Fade = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Floating animation for main frame
local floatTween = TweenService:Create(mainFrame, TWEEN_INFO.Float, {
    Position = UDim2.new(0.5, -200, 0.5, -145)
})
floatTween:Play()

-- Pulse animation for gloss effects
local glossTween = TweenService:Create(gradientFrame, TWEEN_INFO.Pulse, {
    BackgroundTransparency = 0.92
})
glossTween:Play()

-- Button hover effects with gradient animation
local function setupGradientButtonHover(button, gradient, originalStart, originalEnd, hoverStart, hoverEnd, stroke)
    button.MouseEnter:Connect(function()
        -- Animate gradient colors
        TweenService:Create(gradient, TWEEN_INFO.Hover, {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, hoverStart),
                ColorSequenceKeypoint.new(1, hoverEnd)
            })
        }):Play()
        
        -- Scale up slightly
        TweenService:Create(button, TWEEN_INFO.Hover, {
            Size = UDim2.new(0, 159, 0, 49),
            Position = button.Position + UDim2.new(0, -2, 0, -2)
        }):Play()
        
        -- Brighten stroke
        if stroke then
            TweenService:Create(stroke, TWEEN_INFO.Hover, {
                Transparency = 0.5
            }):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        -- Revert gradient
        TweenService:Create(gradient, TWEEN_INFO.Hover, {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, originalStart),
                ColorSequenceKeypoint.new(1, originalEnd)
            })
        }):Play()
        
        -- Scale down
        TweenService:Create(button, TWEEN_INFO.Hover, {
            Size = UDim2.new(0, 155, 0, 45),
            Position = button.Position + UDim2.new(0, 2, 0, 2)
        }):Play()
        
        -- Reset stroke
        if stroke then
            TweenService:Create(stroke, TWEEN_INFO.Hover, {
                Transparency = 0
            }):Play()
        end
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TWEEN_INFO.Click, {
            Size = UDim2.new(0, 151, 0, 41)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TWEEN_INFO.Click, {
            Size = UDim2.new(0, 159, 0, 49)
        }):Play()
    end)
end

-- Setup hovers for gradient buttons
setupGradientButtonHover(
    getKeyButton, 
    getKeyGradient, 
    CONFIG.COLORS.GetKeyStart, 
    CONFIG.COLORS.GetKeyEnd,
    Color3.fromRGB(100, 100, 110), -- Lighter on hover
    Color3.fromRGB(70, 70, 80),
    getKeyStroke
)

setupGradientButtonHover(
    verifyButton, 
    verifyGradient, 
    CONFIG.COLORS.VerifyStart, 
    CONFIG.COLORS.VerifyEnd,
    Color3.fromRGB(150, 160, 255), -- Brighter purple on hover
    Color3.fromRGB(110, 123, 255),
    verifyStroke
)

-- Input field focus effect with stroke animation
keyInput.Focused:Connect(function()
    TweenService:Create(inputFrame, TWEEN_INFO.Hover, {
        BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    }):Play()
    TweenService:Create(inputStroke, TWEEN_INFO.Hover, {
        Color = Color3.fromRGB(120, 120, 140),
        Thickness = 1.8
    }):Play()
end)

keyInput.FocusLost:Connect(function()
    TweenService:Create(inputFrame, TWEEN_INFO.Hover, {
        BackgroundColor3 = CONFIG.COLORS.InputBg
    }):Play()
    TweenService:Create(inputStroke, TWEEN_INFO.Hover, {
        Color = CONFIG.COLORS.InputStroke,
        Thickness = 1.2
    }):Play()
end)

-- Get Key functionality
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

-- Verify functionality
verifyButton.MouseButton1Click:Connect(function()
    local enteredKey = keyInput.Text:gsub("%s+", "")
    
    if enteredKey == "" then
        statusLabel.Text = "Please enter a key!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Shake animation
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
        statusLabel.Text = "Key verified successfully! Loading..."
        statusLabel.TextColor3 = CONFIG.COLORS.Success
        
        TweenService:Create(mainFrame, TWEEN_INFO.Fade, {
            BackgroundTransparency = 1
        }):Play()
        
        for _, child in ipairs(mainFrame:GetDescendants()) do
            if child:IsA("GuiObject") and child ~= mainFrame then
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    TweenService:Create(child, TWEEN_INFO.Fade, {
                        TextTransparency = 1
                    }):Play()
                end
                if child:IsA("Frame") then
                    TweenService:Create(child, TWEEN_INFO.Fade, {
                        BackgroundTransparency = 1
                    }):Play()
                end
                if child:IsA("UIStroke") then
                    TweenService:Create(child, TWEEN_INFO.Fade, {
                        Transparency = 1
                    }):Play()
                end
            end
        end
        
        task.delay(0.6, function()
            screenGui:Destroy()
            print("Key verified! Load your script here.")
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

-- Animate in
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
            if child:IsA("Frame") and child.Name ~= "Gloss" and child.Name ~= "InputGloss" then
                local originalTransparency = 0
                if child.Name == "InputFrame" or child.Name == "GetKeyButton" or child.Name == "VerifyButton" then
                    originalTransparency = 0
                else
                    originalTransparency = 1
                end
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

print("Premium Key System Loaded Successfully!")
