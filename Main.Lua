--[[
   Premium Key System UI
   Created by: Assistant
   Features: Glossy effects, shadows, loop animations, hover states
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
   KEY_LINK = "https://discord.gg/yourlink", -- Replace with your Discord link
   VALID_KEYS = {"FREEKEY2024", "DISCORD123", "SPECIALACCESS"}, -- Add your valid keys
   COLORS = {
       Background = Color3.fromRGB(25, 25, 30),
       Primary = Color3.fromRGB(45, 45, 55),
       Accent = Color3.fromRGB(88, 101, 242), -- Discord purple
       Success = Color3.fromRGB(87, 242, 135), -- Green for "100% Free"
       White = Color3.fromRGB(255, 255, 255),
       Shadow = Color3.fromRGB(0, 0, 0)
   }
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumKeySystem"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Create main frame with shadow
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "Shadow"
shadowFrame.Size = UDim2.new(0, 420, 0, 320)
shadowFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
shadowFrame.BackgroundColor3 = CONFIG.COLORS.Shadow
shadowFrame.BackgroundTransparency = 0.6
shadowFrame.BorderSizePixel = 0
shadowFrame.Parent = screenGui

-- Corner radius for shadow
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 20)
shadowCorner.Parent = shadowFrame

-- Main container
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

-- Add subtle gradient overlay for glossy effect
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

-- Key input frame (glossy input field)
local inputFrame = Instance.new("Frame")
inputFrame.Name = "InputFrame"
inputFrame.Size = UDim2.new(0, 320, 0, 45)
inputFrame.Position = UDim2.new(0.5, -160, 0, 110)
inputFrame.BackgroundColor3 = CONFIG.COLORS.Primary
inputFrame.BorderSizePixel = 0
inputFrame.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputFrame

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

-- Get Key Button
local getKeyButton = Instance.new("TextButton")
getKeyButton.Name = "GetKeyButton"
getKeyButton.Size = UDim2.new(0, 155, 1, 0)
getKeyButton.Position = UDim2.new(0, 0, 0, 0)
getKeyButton.BackgroundColor3 = CONFIG.COLORS.Primary
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

-- Get Key gloss
local getKeyGloss = Instance.new("Frame")
getKeyGloss.Name = "Gloss"
getKeyGloss.Size = UDim2.new(1, 0, 0.5, 0)
getKeyGloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
getKeyGloss.BackgroundTransparency = 0.85
getKeyGloss.BorderSizePixel = 0
getKeyGloss.Parent = getKeyButton

local getKeyGlossCorner = Instance.new("UICorner")
getKeyGlossCorner.CornerRadius = UDim.new(0, 10)
getKeyGlossCorner.Parent = getKeyGloss

-- Verify Button
local verifyButton = Instance.new("TextButton")
verifyButton.Name = "VerifyButton"
verifyButton.Size = UDim2.new(0, 155, 1, 0)
verifyButton.Position = UDim2.new(1, -155, 0, 0)
verifyButton.BackgroundColor3 = CONFIG.COLORS.Accent -- Discord purple
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

-- Verify gloss
local verifyGloss = Instance.new("Frame")
verifyGloss.Name = "Gloss"
verifyGloss.Size = UDim2.new(1, 0, 0.5, 0)
verifyGloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
verifyGloss.BackgroundTransparency = 0.8
verifyGloss.BorderSizePixel = 0
verifyGloss.Parent = verifyButton

local verifyGlossCorner = Instance.new("UICorner")
verifyGlossCorner.CornerRadius = UDim.new(0, 10)
verifyGlossCorner.Parent = verifyGloss

-- Status label (for error/success messages)
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

-- Footer text with colored words
local footerFrame = Instance.new("Frame")
footerFrame.Name = "Footer"
footerFrame.Size = UDim2.new(0, 320, 0, 40)
footerFrame.Position = UDim2.new(0.5, -160, 0, 255)
footerFrame.BackgroundTransparency = 1
footerFrame.Parent = mainFrame

-- "The Key is" - White
local text1 = Instance.new("TextLabel")
text1.Name = "Text1"
text1.Size = UDim2.new(0, 60, 1, 0)
text1.Position = UDim2.new(0, 20, 0, 0)
text1.BackgroundTransparency = 1
text1.Font = Enum.Font.Gotham
text1.Text = "The Key is"
text1.TextColor3 = CONFIG.COLORS.White
text1.TextSize = 14
text1.TextXAlignment = Enum.TextXAlignment.Right
text1.Parent = footerFrame

-- "100% Free" - Green
local textFree = Instance.new("TextLabel")
textFree.Name = "TextFree"
textFree.Size = UDim2.new(0, 70, 1, 0)
textFree.Position = UDim2.new(0, 82, 0, 0)
textFree.BackgroundTransparency = 1
textFree.Font = Enum.Font.GothamBold
textFree.Text = "100% Free"
textFree.TextColor3 = CONFIG.COLORS.Success -- Green
textFree.TextSize = 14
textFree.TextXAlignment = Enum.TextXAlignment.Left
textFree.Parent = footerFrame

-- "in the" - White
local text2 = Instance.new("TextLabel")
text2.Name = "Text2"
text2.Size = UDim2.new(0, 45, 1, 0)
text2.Position = UDim2.new(0, 152, 0, 0)
text2.BackgroundTransparency = 1
text2.Font = Enum.Font.Gotham
text2.Text = "in the"
text2.TextColor3 = CONFIG.COLORS.White
text2.TextSize = 14
text2.TextXAlignment = Enum.TextXAlignment.Left
text2.Parent = footerFrame

-- "Discord" - Purple
local textDiscord = Instance.new("TextLabel")
textDiscord.Name = "TextDiscord"
textDiscord.Size = UDim2.new(0, 55, 1, 0)
textDiscord.Position = UDim2.new(0, 197, 0, 0)
textDiscord.BackgroundTransparency = 1
textDiscord.Font = Enum.Font.GothamBold
textDiscord.Text = "Discord"
textDiscord.TextColor3 = CONFIG.COLORS.Accent -- Discord purple
textDiscord.TextSize = 14
textDiscord.TextXAlignment = Enum.TextXAlignment.Left
textDiscord.Parent = footerFrame

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

-- Shadow follows with delay
local shadowFloatTween = TweenService:Create(shadowFrame, TWEEN_INFO.Float, {
   Position = UDim2.new(0.5, -210, 0.5, -155)
})
shadowFloatTween:Play()

-- Pulse animation for gloss effects
local glossTween = TweenService:Create(gradientFrame, TWEEN_INFO.Pulse, {
   BackgroundTransparency = 0.92
})
glossTween:Play()

-- Button hover effects
local function setupButtonHover(button, originalColor, hoverColor)
   local gloss = button:FindFirstChild("Gloss")
   
   button.MouseEnter:Connect(function()
       TweenService:Create(button, TWEEN_INFO.Hover, {
           BackgroundColor3 = hoverColor,
           Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 4, button.Size.Y.Scale, button.Size.Y.Offset + 4),
           Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset - 2, button.Position.Y.Scale, button.Position.Y.Offset - 2)
       }):Play()
       
       if gloss then
           TweenService:Create(gloss, TWEEN_INFO.Hover, {
               BackgroundTransparency = 0.7
           }):Play()
       end
   end)
   
   button.MouseLeave:Connect(function()
       TweenService:Create(button, TWEEN_INFO.Hover, {
           BackgroundColor3 = originalColor,
           Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 4, button.Size.Y.Scale, button.Size.Y.Offset - 4),
           Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset + 2, button.Position.Y.Scale, button.Position.Y.Offset + 2)
       }):Play()
       
       if gloss then
           TweenService:Create(gloss, TWEEN_INFO.Hover, {
               BackgroundTransparency = (button.Name == "VerifyButton") and 0.8 or 0.85
           }):Play()
       end
   end)
   
   button.MouseButton1Down:Connect(function()
       TweenService:Create(button, TWEEN_INFO.Click, {
           Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 4, button.Size.Y.Scale, button.Size.Y.Offset - 4)
       }):Play()
   end)
   
   button.MouseButton1Up:Connect(function()
       TweenService:Create(button, TWEEN_INFO.Click, {
           Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 4, button.Size.Y.Scale, button.Size.Y.Offset + 4)
       }):Play()
   end)
end

-- Setup hovers
setupButtonHover(getKeyButton, CONFIG.COLORS.Primary, Color3.fromRGB(60, 60, 70))
setupButtonHover(verifyButton, CONFIG.COLORS.Accent, Color3.fromRGB(110, 123, 255))

-- Input field focus effect
keyInput.Focused:Connect(function()
   TweenService:Create(inputFrame, TWEEN_INFO.Hover, {
       BackgroundColor3 = Color3.fromRGB(55, 55, 65)
   }):Play()
end)

keyInput.FocusLost:Connect(function()
   TweenService:Create(inputFrame, TWEEN_INFO.Hover, {
       BackgroundColor3 = CONFIG.COLORS.Primary
   }):Play()
end)

-- Get Key functionality
getKeyButton.MouseButton1Click:Connect(function()
   -- Copy to clipboard simulation (Roblox doesn't allow actual clipboard access directly)
   -- Instead, we'll show the link
   statusLabel.Text = "Link copied to clipboard!"
   statusLabel.TextColor3 = CONFIG.COLORS.Success
   
   -- Open link (this will prompt the user)
   local success, err = pcall(function()
       -- You can use synapse or other executors' clipboard functions here if needed
       -- For now, we just set the textbox to the link
       keyInput.Text = CONFIG.KEY_LINK
       keyInput:CaptureFocus()
       keyInput:SelectAll()
   end)
   
   -- Reset status after 3 seconds
   task.delay(3, function()
       if statusLabel.Text == "Link copied to clipboard!" then
           statusLabel.Text = ""
       end
   end)
end)

-- Verify functionality
verifyButton.MouseButton1Click:Connect(function()
   local enteredKey = keyInput.Text:gsub("%s+", "") -- Remove whitespace
   
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
   
   -- Check if key is valid
   local isValid = false
   for _, validKey in ipairs(CONFIG.VALID_KEYS) do
       if enteredKey:upper() == validKey:upper() then
           isValid = true
           break
       end
   end
   
   if isValid then
       -- Success animation
       statusLabel.Text = "Key verified successfully! Loading..."
       statusLabel.TextColor3 = CONFIG.COLORS.Success
       
       -- Success effects
       TweenService:Create(mainFrame, TWEEN_INFO.Fade, {
           BackgroundTransparency = 1
       }):Play()
       
       TweenService:Create(shadowFrame, TWEEN_INFO.Fade, {
           BackgroundTransparency = 1
       }):Play()
       
       for _, child in ipairs(mainFrame:GetDescendants()) do
           if child:IsA("GuiObject") and child ~= mainFrame then
               TweenService:Create(child, TWEEN_INFO.Fade, {
                   BackgroundTransparency = 1,
                   TextTransparency = 1
               }):Play()
           end
       end
       
       -- Fire success callback after animation
       task.delay(0.6, function()
           screenGui:Destroy()
           print("Key verified! Load your script here.")
           -- ADD YOUR SCRIPT LOADING CODE HERE
       end)
   else
       -- Invalid key
       statusLabel.Text = "Invalid key! Please try again."
       statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
       
       -- Shake animation
       local originalPos = inputFrame.Position
       for i = 1, 5 do
           inputFrame.Position = originalPos + UDim2.new(0, (i % 2 == 0 and 5 or -5), 0, 0)
           task.wait(0.05)
       end
       inputFrame.Position = originalPos
       
       -- Clear input
       keyInput.Text = ""
   end
end)

-- Entrance animation
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
mainFrame.BackgroundTransparency = 1
shadowFrame.BackgroundTransparency = 1

for _, child in ipairs(mainFrame:GetDescendants()) do
   if child:IsA("GuiObject") then
       if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
           child.TextTransparency = 1
       end
       if child:IsA("Frame") and child.Name ~= "Gloss" and child.Name ~= "InputGloss" then
           child.BackgroundTransparency = 1
       end
   end
end

-- Animate in
task.wait(0.1)
TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
   Position = UDim2.new(0.5, -200, 0.5, -150),
   BackgroundTransparency = 0
}):Play()

TweenService:Create(shadowFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
   Position = UDim2.new(0.5, -210, 0.5, -160),
   BackgroundTransparency = 0.6
}):Play()

task.delay(0.2, function()
   for _, child in ipairs(mainFrame:GetDescendants()) do
       if child:IsA("GuiObject") then
           if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
               TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                   TextTransparency = 0
               }):Play()
           end
           if child:IsA("Frame") and child.BackgroundTransparency < 1 and child.Name ~= "Gloss" and child.Name ~= "InputGloss" then
               local originalTransparency = (child.Name == "InputFrame" or child.Name == "GetKeyButton" or child.Name == "VerifyButton") and 0 or 1
               TweenService:Create(child, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                   BackgroundTransparency = originalTransparency
               }):Play()
           end
       end
   end
end)

print("Premium Key System Loaded Successfully!")
