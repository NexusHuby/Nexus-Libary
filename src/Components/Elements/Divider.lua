local DividerElement = {}
DividerElement.__index = DividerElement

local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Theme.lua"))()

function DividerElement:Create(Section)
    local self = setmetatable({}, DividerElement)
    
    self.Instance = Instance.new("Frame")
    self.Instance.Name = "Divider"
    self.Instance.Size = UDim2.new(1, -20, 0, 2)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.BackgroundColor3 = Theme:GetColor("Border")
    self.Instance.BorderSizePixel = 0
    self.Instance.Parent = Section.ElementContainer
    
    -- Optional gradient effect
    local Gradient = Instance.new("UIGradient")
    Gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    }
    Gradient.Parent = self.Instance
    
    return self
end

function DividerElement:UpdateColor(Color)
    self.Instance.BackgroundColor3 = Color
end

function DividerElement:SetThickness(Thickness)
    self.Instance.Size = UDim2.new(self.Instance.Size.X.Scale, self.Instance.Size.X.Offset, 0, Thickness)
end

function DividerElement:Destroy()
    self.Instance:Destroy()
end

return DividerElement
