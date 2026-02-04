local ButtonElement = {}
ButtonElement.__index = ButtonElement

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Tween.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Theme.lua"))()
local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/LucideIcons.lua"))()

function ButtonElement:Create(Section, Config)
    local self = setmetatable({}, ButtonElement)
    
    Config = Config or {}
    self.Name = Config.Name or "Button"
    self.Callback = Config.Callback or function() end
    self.Icon = Config.Icon
    
    -- Container
    self.Instance = Instance.new("TextButton")
    self.Instance.Name = self.Name .. "Button"
    self.Instance.Size = UDim2.new(1, 0, 0, 35)
    self.Instance.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Instance.BorderSizePixel = 0
    self.Instance.Text = ""
    self.Instance.AutoButtonColor = false
    self.Instance.Parent = Section.ElementContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Instance
    
    -- Icon
    if self.Icon then
        local Icon = LucideIcons:CreateIcon(self.Icon, self.Instance, UDim2.new(0, 16, 0, 16), Theme:GetColor("Text"))
        Icon.Position = UDim2.new(0, 10, 0.5, -8)
        Icon.Name = "Icon"
    end
    
    -- Text
    local Text = Instance.new("TextLabel")
    Text.Name = "Title"
    Text.Size = UDim2.new(1, self.Icon and -40 or -20, 1, 0)
    Text.Position = UDim2.new(0, self.Icon and 35 or 10, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = self.Name
    Text.TextColor3 = Theme:GetColor("Text")
    Text.TextSize = 14
    Text.Font = Enum.Font.GothamSemibold
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = self.Instance
    
    -- Hover & Click Effects
    self.Instance.MouseEnter:Connect(function()
        Tween:Create(self.Instance, {BackgroundColor3 = Theme:GetColor("Accent")}, 0.2)
    end)
    
    self.Instance.MouseLeave:Connect(function()
        Tween:Create(self.Instance, {BackgroundColor3 = Theme:GetColor("Tertiary")}, 0.2)
    end)
    
    self.Instance.MouseButton1Down:Connect(function()
        Tween:Create(self.Instance, {Size = UDim2.new(0.98, 0, 0, 33), Position = UDim2.new(0.01, 0, 0, 1)}, 0.1)
    end)
    
    self.Instance.MouseButton1Up:Connect(function()
        Tween:Create(self.Instance, {Size = UDim2.new(1, 0, 0, 35), Position = UDim2.new(0, 0, 0, 0)}, 0.1)
    end)
    
    self.Instance.MouseButton1Click:Connect(function()
        self:Click()
    end)
    
    return self
end

function ButtonElement:Click()
    -- Click animation
    local Original = self.Instance.BackgroundColor3
    Tween:Create(self.Instance, {BackgroundColor3 = Color3.new(1, 1, 1)}, 0.1).Completed:Connect(function()
        Tween:Create(self.Instance, {BackgroundColor3 = Original}, 0.2)
    end)
    
    if self.Callback then
        task.spawn(self.Callback)
    end
end

function ButtonElement:UpdateName(NewName)
    self.Name = NewName
    self.Instance.Title.Text = NewName
end

function ButtonElement:SetCallback(NewCallback)
    self.Callback = NewCallback
end

function ButtonElement:Destroy()
    self.Instance:Destroy()
end

return ButtonElement
