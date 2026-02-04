local Tab = {}
Tab.__index = Tab

local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Theme.lua"))()
local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Tween.lua"))()
local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/LucideIcons.lua"))()
local SectionModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Section.lua"))()

function Tab:Create(Window, Name, IconName)
    local self = setmetatable({}, Tab)
    
    self.Window = Window
    self.Name = Name
    self.Sections = {}
    
    -- Tab Button
    self.Button = Instance.new("TextButton")
    self.Button.Name = Name .. "Tab"
    self.Button.Size = UDim2.new(1, 0, 0, 35)
    self.Button.BackgroundColor3 = Theme:GetColor("Secondary")
    self.Button.BorderSizePixel = 0
    self.Button.Text = ""
    self.Button.Parent = Window.TabList
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = self.Button
    
    -- Icon
    if IconName then
        local Icon = LucideIcons:CreateIcon(IconName, self.Button, UDim2.new(0, 18, 0, 18), Theme:GetColor("SubText"))
        Icon.Position = UDim2.new(0, 10, 0.5, -9)
        Icon.Name = "Icon"
    end
    
    -- Tab Name
    local TabText = Instance.new("TextLabel")
    TabText.Name = "Text"
    TabText.Size = UDim2.new(1, IconName and -40 or -20, 1, 0)
    TabText.Position = UDim2.new(0, IconName and 35 or 10, 0, 0)
    TabText.BackgroundTransparency = 1
    TabText.Text = Name
    TabText.TextColor3 = Theme:GetColor("SubText")
    TabText.TextSize = 14
    TabText.Font = Enum.Font.GothamSemibold
    TabText.TextXAlignment = Enum.TextXAlignment.Left
    TabText.Parent = self.Button
    
    -- Content Container
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Name = Name .. "Content"
    self.Container.Size = UDim2.new(1, -20, 1, -20)
    self.Container.Position = UDim2.new(0, 10, 0, 10)
    self.Container.BackgroundTransparency = 1
    self.Container.ScrollBarThickness = 3
    self.Container.ScrollBarImageColor3 = Theme:GetColor("Accent")
    self.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Container.Visible = false
    self.Container.Parent = Window.Content
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 10)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = self.Container
    
    -- Auto-resize canvas
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Click Event
    self.Button.MouseButton1Click:Connect(function()
        self:Select()
    end)
    
    -- Hover
    self.Button.MouseEnter:Connect(function()
        if self ~= Window.ActiveTab then
            Tween:Create(self.Button, {BackgroundColor3 = Theme:GetColor("Tertiary")}, 0.2)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if self ~= Window.ActiveTab then
            Tween:Create(self.Button, {BackgroundColor3 = Theme:GetColor("Secondary")}, 0.2)
        end
    end)
    
    return self
end

function Tab:Select()
    if self.Window.ActiveTab and self.Window.ActiveTab ~= self then
        self.Window.ActiveTab:Deselect()
    end
    
    self.Window.ActiveTab = self
    self.Container.Visible = true
    
    -- Animate button
    Tween:Create(self.Button, {BackgroundColor3 = Theme:GetColor("Accent")}, 0.2)
    self.Button.TextLabel.TextColor3 = Color3.new(1, 1, 1)
    
    -- Animate content
    self.Container.Position = UDim2.new(0, 20, 0, 10)
    Tween:Create(self.Container, {Position = UDim2.new(0, 10, 0, 10)}, 0.3)
    
    -- Animate icon
    local Icon = self.Button:FindFirstChild("Icon")
    if Icon then
        Tween:Create(Icon, {ImageColor3 = Color3.new(1, 1, 1)}, 0.2)
    end
end

function Tab:Deselect()
    self.Container.Visible = false
    Tween:Create(self.Button, {BackgroundColor3 = Theme:GetColor("Secondary")}, 0.2)
    self.Button.TextLabel.TextColor3 = Theme:GetColor("SubText")
    
    local Icon = self.Button:FindFirstChild("Icon")
    if Icon then
        Tween:Create(Icon, {ImageColor3 = Theme:GetColor("SubText")}, 0.2)
    end
end

function Tab:CreateSection(Title, Description)
    local Section = SectionModule:Create(self, Title, Description)
    table.insert(self.Sections, Section)
    return Section
end

function Tab:UpdateName(NewName)
    self.Name = NewName
    self.Button.TextLabel.Text = NewName
end

return Tab
