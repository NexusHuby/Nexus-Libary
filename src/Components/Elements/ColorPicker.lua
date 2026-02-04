local ColorPickerElement = {}
ColorPickerElement.__index = ColorPickerElement

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Tween.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Theme.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/SaveManager.lua"))()
local UserInputService = game:GetService("UserInputService")

function ColorPickerElement:Create(Section, Config)
    local self = setmetatable({}, ColorPickerElement)
    
    Config = Config or {}
    self.Name = Config.Name or "ColorPicker"
    self.Default = Config.Default or Color3.fromRGB(255, 0, 0)
    self.Callback = Config.Callback or function() end
    self.Flag = Config.Flag or self.Name .. "_Color"
    
    self.Value = SaveManager:GetValue(self.Flag, {R = self.Default.R, G = self.Default.G, B = self.Default.B})
    self.Value = Color3.new(self.Value.R, self.Value.G, self.Value.B)
    self.Open = false
    
    -- Container
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name .. "ColorPicker"
    self.Instance.Size = UDim2.new(1, 0, 0, 40)
    self.Instance.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Instance.BorderSizePixel = 0
    self.Instance.ClipsDescendants = true
    self.Instance.Parent = Section.ElementContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Instance
    
    -- Header
    self.Header = Instance.new("TextButton")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 40)
    self.Header.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Header.BorderSizePixel = 0
    self.Header.Text = ""
    self.Header.AutoButtonColor = false
    self.Header.Parent = self.Instance
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Header
    
    -- Color Preview
    self.Preview = Instance.new("Frame")
    self.Preview.Name = "Preview"
    self.Preview.Size = UDim2.new(0, 30, 0, 20)
    self.Preview.Position = UDim2.new(1, -45, 0.5, -10)
    self.Preview.BackgroundColor3 = self.Value
    self.Preview.BorderSizePixel = 0
    self.Preview.Parent = self.Header
    
    local PreviewCorner = Instance.new("UICorner")
    PreviewCorner.CornerRadius = UDim.new(0, 4)
    PreviewCorner.Parent = self.Preview
    
    -- Picker Frame
    self.PickerFrame = Instance.new("Frame")
    self.PickerFrame.Name = "Picker"
    self.PickerFrame.Size = UDim2.new(1, -20, 0, 180)
    self.PickerFrame.Position = UDim2.new(0, 10, 0, 50)
    self.PickerFrame.BackgroundColor3 = Theme:GetColor("Background")
    self.PickerFrame.BorderSizePixel = 0
    self.PickerFrame.Visible = false
    self.PickerFrame.Parent = self.Instance
    
    local PickerCorner = Instance.new("UICorner")
    PickerCorner.CornerRadius = UDim.new(0, 6)
    PickerCorner.Parent = self.PickerFrame
    
    -- Saturation/Value Box
    self.SVFrame = Instance.new("Frame")
    self.SVFrame.Size = UDim2.new(0, 160, 0, 120)
    self.SVFrame.Position = UDim2.new(0, 10, 0, 10)
    self.SVFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    self.SVFrame.BorderSizePixel = 0
    self.SVFrame.Parent = self.PickerFrame
    
    local SVCorner = Instance.new("UICorner")
    SVCorner.CornerRadius = UDim.new(0, 4)
    SVCorner.Parent = self.SVFrame
    
    -- SV Gradient
    local SVGradient = Instance.new("UIGradient")
    SVGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    }
    SVGradient.Parent = self.SVFrame
    
    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.Parent = self.SVFrame
    
    local DarkGradient = Instance.new("UIGradient")
    DarkGradient.Rotation = 90
    DarkGradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    DarkGradient.Parent = DarkOverlay
    
    -- SV Cursor
    self.SVCursor = Instance.new("Frame")
    self.SVCursor.Size = UDim2.new(0, 10, 0, 10)
    self.SVCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    self.SVCursor.BorderSizePixel = 2
    self.SVCursor.BorderColor3 = Color3.new(0, 0, 0)
    self.SVCursor.Parent = self.SVFrame
    
    local SVCursorCorner = Instance.new("UICorner")
    SVCursorCorner.CornerRadius = UDim.new(1, 0)
    SVCursorCorner.Parent = self.SVCursor
    
    -- Hue Slider
    self.HueFrame = Instance.new("Frame")
    self.HueFrame.Size = UDim2.new(0, 20, 0, 120)
    self.HueFrame.Position = UDim2.new(0, 180, 0, 10)
    self.HueFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    self.HueFrame.BorderSizePixel = 0
    self.HueFrame.Parent = self.PickerFrame
    
    local HueCorner = Instance.new("UICorner")
    HueCorner.CornerRadius = UDim.new(0, 4)
    HueCorner.Parent = self.HueFrame
    
    local HueGradient = Instance.new("UIGradient")
    HueGradient.Rotation = 90
    HueGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    HueGradient.Parent = self.HueFrame
    
    -- Hue Cursor
    self.HueCursor = Instance.new("Frame")
    self.HueCursor.Size = UDim2.new(1, 4, 0, 6)
    self.HueCursor.Position = UDim2.new(0, -2, 0, 0)
    self.HueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
    self.HueCursor.BorderSizePixel = 2
    self.HueCursor.BorderColor3 = Color3.new(0, 0, 0)
    self.HueCursor.Parent = self.HueFrame
    
    -- RGB Inputs
    local InputY = 140
    for i, Channel in ipairs({"R", "G", "B"}) do
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 20, 0, 25)
        Label.Position = UDim2.new(0, 10 + (i-1) * 70, 0, InputY)
        Label.BackgroundTransparency = 1
        Label.Text = Channel
        Label.TextColor3 = Theme:GetColor("Text")
        Label.TextSize = 12
        Label.Font = Enum.Font.GothamBold
        Label.Parent = self.PickerFrame
        
        local Input = Instance.new("TextBox")
        Input.Name = Channel
        Input.Size = UDim2.new(0, 45, 0, 25)
        Input.Position = UDim2.new(0, 30 + (i-1) * 70, 0, InputY)
        Input.BackgroundColor3 = Theme:GetColor("Tertiary")
        Input.BorderSizePixel = 0
        Input.Text = "255"
        Input.TextColor3 = Theme:GetColor("Text")
        Input.TextSize = 12
        Input.Font = Enum.Font.Gotham
        Input.Parent = self.PickerFrame
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 4)
        InputCorner.Parent = Input
        
        Input.FocusLost:Connect(function()
            local Val = math.clamp(tonumber(Input.Text) or 0, 0, 255)
            local Current = self.Value
            local NewColor = Color3.new(
                Channel == "R" and Val/255 or Current.R,
                Channel == "G" and Val/255 or Current.G,
                Channel == "B" and Val/255 or Current.B
            )
            self:SetValue(NewColor)
        end)
    end
    
    -- Logic
    local H, S, V = self.Value:ToHSV()
    
    local function UpdateFromHSV()
        local Color = Color3.fromHSV(H, S, V)
        self.Value = Color
        self.Preview.BackgroundColor3 = Color
        
        -- Save
        SaveManager:SetValue(self.Flag, {R = Color.R, G = Color.G, B = Color.B})
        
        -- Update UI
        self.SVCursor.Position = UDim2.new(S, -5, 1-V, -5)
        self.HueCursor.Position = UDim2.new(-0.1, 0, 1-H, -3)
        
        -- Update SV gradient hue
        SVGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHSV(H, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
        }
        
        -- Update inputs
        for _, Child in ipairs(self.PickerFrame:GetChildren()) do
            if Child:IsA("TextBox") then
                if Child.Name == "R" then Child.Text = math.floor(Color.R * 255) end
                if Child.Name == "G" then Child.Text = math.floor(Color.G * 255) end
                if Child.Name == "B" then Child.Text = math.floor(Color.B * 255) end
            end
        end
        
        if self.Callback then
            task.spawn(self.Callback, Color)
        end
    end
    
    -- Dragging
    local DraggingSV = false
    local DraggingHue = false
    
    self.SVFrame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingSV = true
        end
    end)
    
    self.HueFrame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingHue = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            if DraggingSV then
                local Pos = Input.Position
                local AbsPos = self.SVFrame.AbsolutePosition
                local AbsSize = self.SVFrame.AbsoluteSize
                
                S = math.clamp((Pos.X - AbsPos.X) / AbsSize.X, 0, 1)
                V = 1 - math.clamp((Pos.Y - AbsPos.Y) / AbsSize.Y, 0, 1)
                UpdateFromHSV()
            elseif DraggingHue then
                local Pos = Input.Position
                local AbsPos = self.HueFrame.AbsolutePosition
                local AbsSize = self.HueFrame.AbsoluteSize
                
                H = 1 - math.clamp((Pos.Y - AbsPos.Y) / AbsSize.Y, 0, 1)
                UpdateFromHSV()
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingSV = false
            DraggingHue = false
        end
    end)
    
    -- Toggle
    self.Header.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    UpdateFromHSV()
    
    return self
end

function ColorPickerElement:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        self.PickerFrame.Visible = true
        Tween:Create(self.Instance, {Size = UDim2.new(1, 0, 0, 240)}, 0.2)
    else
        Tween:Create(self.Instance, {Size = UDim2.new(1, 0, 0, 40)}, 0.2).Completed:Connect(function()
            self.PickerFrame.Visible = false
        end)
    end
end

function ColorPickerElement:SetValue(Color)
    local H, S, V = Color:ToHSV()
    self.H = H
    self.S = S
    self.V = V
    self.Value = Color
    self.Preview.BackgroundColor3 = Color
    SaveManager:SetValue(self.Flag, {R = Color.R, G = Color.G, B = Color.B})
    
    if self.Callback then
        task.spawn(self.Callback, Color)
    end
end

function ColorPickerElement:UpdateName(NewName)
    self.Header.Title.Text = NewName
end

return ColorPickerElement
