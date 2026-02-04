local ToggleElement = {}
ToggleElement.__index = ToggleElement

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Tween.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Theme.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/SaveManager.lua"))()

function ToggleElement:Create(Section, Config)
    local self = setmetatable({}, ToggleElement)
    
    Config = Config or {}
    self.Name = Config.Name or "Toggle"
    self.Default = Config.Default or false
    self.Callback = Config.Callback or function() end
    self.Flag = Config.Flag or self.Name .. "_Toggle"
    self.Description = Config.Description
    
    -- Load saved state
    self.Value = SaveManager:GetValue(self.Flag, self.Default)
    
    -- Container
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name .. "Toggle"
    self.Instance.Size = UDim2.new(1, 0, 0, self.Description and 50 or 35)
    self.Instance.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Instance.BorderSizePixel = 0
    self.Instance.Parent = Section.ElementContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Instance
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -70, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, self.Description and 5 or 7)
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Instance
    
    -- Description
    if self.Description then
        local Desc = Instance.new("TextLabel")
        Desc.Name = "Description"
        Desc.Size = UDim2.new(1, -70, 0, 15)
        Desc.Position = UDim2.new(0, 10, 0, 28)
        Desc.BackgroundTransparency = 1
        Desc.Text = self.Description
        Desc.TextColor3 = Theme:GetColor("SubText")
        Desc.TextSize = 11
        Desc.Font = Enum.Font.Gotham
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.Parent = self.Instance
    end
    
    -- Toggle Button
    self.ToggleBtn = Instance.new("TextButton")
    self.ToggleBtn.Name = "Toggle"
    self.ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
    self.ToggleBtn.Position = UDim2.new(1, -54, 0.5, -12)
    self.ToggleBtn.BackgroundColor3 = self.Value and Theme:GetColor("Accent") or Theme:GetColor("Border")
    self.ToggleBtn.BorderSizePixel = 0
    self.ToggleBtn.Text = ""
    self.ToggleBtn.AutoButtonColor = false
    self.ToggleBtn.Parent = self.Instance
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = self.ToggleBtn
    
    -- Toggle Circle
    self.Circle = Instance.new("Frame")
    self.Circle.Name = "Circle"
    self.Circle.Size = UDim2.new(0, 18, 0, 18)
    self.Circle.Position = self.Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    self.Circle.BackgroundColor3 = Color3.new(1, 1, 1)
    self.Circle.BorderSizePixel = 0
    self.Circle.Parent = self.ToggleBtn
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = self.Circle
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, -10, 0.5, -10)
    Shadow.Size = UDim2.new(1, 20, 1, 20)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.Parent = self.Circle
    
    -- Click Event
    self.ToggleBtn.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
    
    -- Initialize
    if self.Value then
        self:SetValue(true, true)
    end
    
    return self
end

function ToggleElement:SetValue(Value, NoAnimation)
    self.Value = Value
    
    -- Save to file
    SaveManager:SetValue(self.Flag, Value)
    
    -- Animate
    local ToggleColor = Value and Theme:GetColor("Accent") or Theme:GetColor("Border")
    local CirclePos = Value and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    
    if NoAnimation then
        self.ToggleBtn.BackgroundColor3 = ToggleColor
        self.Circle.Position = CirclePos
    else
        Tween:Create(self.ToggleBtn, {BackgroundColor3 = ToggleColor}, 0.2)
        Tween:Create(self.Circle, {Position = CirclePos}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    end
    
    -- Callback
    if self.Callback then
        task.spawn(self.Callback, Value)
    end
end

function ToggleElement:UpdateName(NewName)
    self.Instance.Title.Text = NewName
end

function ToggleElement:GetValue()
    return self.Value
end

return ToggleElement
