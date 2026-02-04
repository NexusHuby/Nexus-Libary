local SliderElement = {}
SliderElement.__index = SliderElement

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Tween.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Theme.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/SaveManager.lua"))()
local UserInputService = game:GetService("UserInputService")

function SliderElement:Create(Section, Config)
    local self = setmetatable({}, SliderElement)
    
    Config = Config or {}
    self.Name = Config.Name or "Slider"
    self.Min = Config.Min or 0
    self.Max = Config.Max or 100
    self.Default = Config.Default or self.Min
    self.Increment = Config.Increment or 1
    self.ValueSuffix = Config.Suffix or ""
    self.Callback = Config.Callback or function() end
    self.Flag = Config.Flag or self.Name .. "_Slider"
    
    -- Load saved value
    self.Value = SaveManager:GetValue(self.Flag, self.Default)
    
    -- Container
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name .. "Slider"
    self.Instance.Size = UDim2.new(1, 0, 0, 55)
    self.Instance.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Instance.BorderSizePixel = 0
    self.Instance.Parent = Section.ElementContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Instance
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Instance
    
    -- Value Display
    self.ValueLabel = Instance.new("TextBox")
    self.ValueLabel.Name = "Value"
    self.ValueLabel.Size = UDim2.new(0, 60, 0, 20)
    self.ValueLabel.Position = UDim2.new(1, -70, 0, 8)
    self.ValueLabel.BackgroundColor3 = Theme:GetColor("Background")
    self.ValueLabel.BorderSizePixel = 0
    self.ValueLabel.Text = tostring(self.Value) .. self.ValueSuffix
    self.ValueLabel.TextColor3 = Theme:GetColor("Text")
    self.ValueLabel.TextSize = 12
    self.ValueLabel.Font = Enum.Font.GothamBold
    self.ValueLabel.ClearTextOnFocus = false
    self.ValueLabel.Parent = self.Instance
    
    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 4)
    ValueCorner.Parent = self.ValueLabel
    
    -- Slider Background
    self.SliderBg = Instance.new("Frame")
    self.SliderBg.Name = "SliderBg"
    self.SliderBg.Size = UDim2.new(1, -20, 0, 8)
    self.SliderBg.Position = UDim2.new(0, 10, 0, 35)
    self.SliderBg.BackgroundColor3 = Theme:GetColor("Background")
    self.SliderBg.BorderSizePixel = 0
    self.SliderBg.Parent = self.Instance
    
    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(1, 0)
    BgCorner.Parent = self.SliderBg
    
    -- Slider Fill
    self.SliderFill = Instance.new("Frame")
    self.SliderFill.Name = "Fill"
    self.SliderFill.Size = UDim2.new(0, 0, 1, 0)
    self.SliderFill.BackgroundColor3 = Theme:GetColor("Accent")
    self.SliderFill.BorderSizePixel = 0
    self.SliderFill.Parent = self.SliderBg
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = self.SliderFill
    
    -- Slider Knob
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "Knob"
    self.Knob.Size = UDim2.new(0, 16, 0, 16)
    self.Knob.Position = UDim2.new(0, -8, 0.5, -8)
    self.Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    self.Knob.BorderSizePixel = 0
    self.Knob.Parent = self.SliderFill
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = self.Knob
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, -15, 0.5, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.Parent = self.Knob
    
    -- Dragging Logic
    local Dragging = false
    
    local function UpdateSlider(Input)
        local SizeScale = math.clamp((Input.Position.X - self.SliderBg.AbsolutePosition.X) / self.SliderBg.AbsoluteSize.X, 0, 1)
        local Value = self.Min + ((self.Max - self.Min) * SizeScale)
        
        -- Round to increment
        Value = math.floor(Value / self.Increment + 0.5) * self.Increment
        Value = math.clamp(Value, self.Min, self.Max)
        
        self:SetValue(Value)
    end
    
    self.SliderBg.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            UpdateSlider(Input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(Input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    -- Value Box
    self.ValueLabel.FocusLost:Connect(function()
        local Num = tonumber(self.ValueLabel.Text:gsub("[^%d.-]", ""))
        if Num then
            self:SetValue(math.clamp(Num, self.Min, self.Max))
        else
            self.ValueLabel.Text = tostring(self.Value) .. self.ValueSuffix
        end
    end)
    
    -- Initialize
    self:SetValue(self.Value, true)
    
    return self
end

function SliderElement:SetValue(Value, NoTween)
    self.Value = Value
    SaveManager:SetValue(self.Flag, Value)
    
    local Scale = (Value - self.Min) / (self.Max - self.Min)
    
    if NoTween then
        self.SliderFill.Size = UDim2.new(Scale, 0, 1, 0)
    else
        Tween:Create(self.SliderFill, {Size = UDim2.new(Scale, 0, 1, 0)}, 0.1)
    end
    
    self.ValueLabel.Text = tostring(Value) .. self.ValueSuffix
    
    if self.Callback then
        task.spawn(self.Callback, Value)
    end
end

function SliderElement:UpdateName(NewName)
    self.Instance.Title.Text = NewName
end

function SliderElement:GetValue()
    return self.Value
end

return SliderElement
