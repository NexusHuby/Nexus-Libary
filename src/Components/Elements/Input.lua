local InputElement = {}
InputElement.__index = InputElement

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Tween.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Theme.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/SaveManager.lua"))()

function InputElement:Create(Section, Config)
    local self = setmetatable({}, InputElement)
    
    Config = Config or {}
    self.Name = Config.Name or "Input"
    self.Default = Config.Default or ""
    self.Placeholder = Config.Placeholder or "Enter text..."
    self.Callback = Config.Callback or function() end
    self.Flag = Config.Flag or self.Name .. "_Input"
    self.Numeric = Config.Numeric or false
    self.MaxLength = Config.MaxLength or nil
    self.ClearOnFocus = Config.ClearOnFocus or false
    
    self.Value = SaveManager:GetValue(self.Flag, self.Default)
    
    -- Container
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name .. "Input"
    self.Instance.Size = UDim2.new(1, 0, 0, 70)
    self.Instance.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Instance.BorderSizePixel = 0
    self.Instance.Parent = Section.ElementContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Instance
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Instance
    
    -- Input Box
    self.InputBox = Instance.new("TextBox")
    self.InputBox.Name = "Input"
    self.InputBox.Size = UDim2.new(1, -20, 0, 30)
    self.InputBox.Position = UDim2.new(0, 10, 0, 35)
    self.InputBox.BackgroundColor3 = Theme:GetColor("Background")
    self.InputBox.BorderSizePixel = 0
    self.InputBox.Text = self.Value
    self.InputBox.PlaceholderText = self.Placeholder
    self.InputBox.PlaceholderColor3 = Theme:GetColor("SubText")
    self.InputBox.TextColor3 = Theme:GetColor("Text")
    self.InputBox.TextSize = 13
    self.InputBox.Font = Enum.Font.Gotham
    self.InputBox.ClearTextOnFocus = self.ClearOnFocus
    self.InputBox.Parent = self.Instance
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = self.InputBox
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.Parent = self.InputBox
    
    -- Focus Effects
    self.InputBox.Focused:Connect(function()
        Tween:Create(self.InputBox, {BackgroundColor3 = Theme:GetColor("Secondary")}, 0.2)
    end)
    
    self.InputBox.FocusLost:Connect(function()
        Tween:Create(self.InputBox, {BackgroundColor3 = Theme:GetColor("Background")}, 0.2)
        self:ValidateAndSave()
    end)
    
    self.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
        if self.MaxLength and #self.InputBox.Text > self.MaxLength then
            self.InputBox.Text = string.sub(self.InputBox.Text, 1, self.MaxLength)
        end
        
        if Config.RealtimeCallback then
            self:ValidateAndSave()
        end
    end)
    
    return self
end

function InputElement:ValidateAndSave()
    local Text = self.InputBox.Text
    
    if self.Numeric then
        local Num = tonumber(Text)
        if Num then
            self.Value = Num
            SaveManager:SetValue(self.Flag, Num)
            if self.Callback then
                task.spawn(self.Callback, Num)
            end
        else
            self.InputBox.Text = tostring(self.Value)
        end
    else
        self.Value = Text
        SaveManager:SetValue(self.Flag, Text)
        if self.Callback then
            task.spawn(self.Callback, Text)
        end
    end
end

function InputElement:SetValue(Value)
    self.Value = Value
    self.InputBox.Text = tostring(Value)
    SaveManager:SetValue(self.Flag, Value)
    
    if self.Callback then
        task.spawn(self.Callback, Value)
    end
end

function InputElement:GetValue()
    return self.Value
end

function InputElement:UpdateName(NewName)
    self.Instance.Title.Text = NewName
end

return InputElement
