local Section = {}
Section.__index = Section

local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Theme.lua"))()
local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Tween.lua"))()

-- Element Modules
local ButtonModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Elements/Button.lua"))()
local ToggleModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Elements/Toggle.lua"))()
local SliderModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Elements/Slider.lua"))()
local DropdownModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Elements/Dropdown.lua"))()
local ColorPickerModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Elements/ColorPicker.lua"))()
local InputModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Elements/Input.lua"))()
local DividerModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Elements/Divider.lua"))()

function Section:Create(Tab, Title, Description)
    local self = setmetatable({}, Section)
    
    self.Tab = Tab
    self.Elements = {}
    
    -- Main Container
    self.Container = Instance.new("Frame")
    self.Container.Name = Title .. "Section"
    self.Container.Size = UDim2.new(1, 0, 0, 50)
    self.Container.BackgroundColor3 = Theme:GetColor("Secondary")
    self.Container.BorderSizePixel = 0
    self.Container.AutomaticSize = Enum.AutomaticSize.Y
    self.Container.Parent = Tab.Container
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 8)
    ContainerCorner.Parent = self.Container
    
    local ContainerPadding = Instance.new("UIPadding")
    ContainerPadding.PaddingLeft = UDim.new(0, 15)
    ContainerPadding.PaddingRight = UDim.new(0, 15)
    ContainerPadding.PaddingTop = UDim.new(0, 15)
    ContainerPadding.PaddingBottom = UDim.new(0, 15)
    ContainerPadding.Parent = self.Container
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 25)
    Header.BackgroundTransparency = 1
    Header.Parent = self.Container
    
    -- Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 20)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = Title
    self.TitleLabel.TextColor3 = Theme:GetColor("Text")
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = Header
    
    -- Description
    if Description then
        self.DescLabel = Instance.new("TextLabel")
        self.DescLabel.Name = "Description"
        self.DescLabel.Size = UDim2.new(1, 0, 0, 15)
        self.DescLabel.Position = UDim2.new(0, 0, 0, 22)
        self.DescLabel.BackgroundTransparency = 1
        self.DescLabel.Text = Description
        self.DescLabel.TextColor3 = Theme:GetColor("SubText")
        self.DescLabel.TextSize = 12
        self.DescLabel.Font = Enum.Font.Gotham
        self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.DescLabel.Parent = Header
        Header.Size = UDim2.new(1, 0, 0, 40)
    end
    
    -- Elements Container
    self.ElementContainer = Instance.new("Frame")
    self.ElementContainer.Name = "Elements"
    self.ElementContainer.Size = UDim2.new(1, 0, 0, 0)
    self.ElementContainer.Position = UDim2.new(0, 0, 0, Header.Size.Y.Offset + 10)
    self.ElementContainer.BackgroundTransparency = 1
    self.ElementContainer.AutomaticSize = Enum.AutomaticSize.Y
    self.ElementContainer.Parent = self.Container
    
    local ElementList = Instance.new("UIListLayout")
    ElementList.Padding = UDim.new(0, 8)
    ElementList.SortOrder = Enum.SortOrder.LayoutOrder
    ElementList.Parent = self.ElementContainer
    
    -- Update container size
    ElementList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ElementContainer.Size = UDim2.new(1, 0, 0, ElementList.AbsoluteContentSize.Y)
    end)
    
    -- Animation
    self.Container.BackgroundTransparency = 1
    Tween:Create(self.Container, {BackgroundTransparency = 0}, 0.3)
    
    return self
end

function Section:AddButton(Config)
    return ButtonModule:Create(self, Config)
end

function Section:AddToggle(Config)
    return ToggleModule:Create(self, Config)
end

function Section:AddSlider(Config)
    return SliderModule:Create(self, Config)
end

function Section:AddDropdown(Config)
    return DropdownModule:Create(self, Config)
end

function Section:AddColorPicker(Config)
    return ColorPickerModule:Create(self, Config)
end

function Section:AddInput(Config)
    return InputModule:Create(self, Config)
end

function Section:AddDivider()
    return DividerModule:Create(self)
end

function Section:UpdateTitle(NewTitle)
    self.TitleLabel.Text = NewTitle
end

function Section:UpdateDescription(NewDesc)
    if self.DescLabel then
        self.DescLabel.Text = NewDesc
    end
end

function Section:SetVisible(Visible)
    self.Container.Visible = Visible
end

function Section:Destroy()
    self.Container:Destroy()
end

return Section
