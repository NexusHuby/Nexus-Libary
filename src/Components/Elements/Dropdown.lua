local DropdownElement = {}
DropdownElement.__index = DropdownElement

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Tween.lua"))()
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/Theme.lua"))()
local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/LucideIcons.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/src/Utils/SaveManager.lua"))()

function DropdownElement:Create(Section, Config)
    local self = setmetatable({}, DropdownElement)
    
    Config = Config or {}
    self.Name = Config.Name or "Dropdown"
    self.Options = Config.Options or {}
    self.Default = Config.Default or (self.Options[1] or "")
    self.Callback = Config.Callback or function() end
    self.Flag = Config.Flag or self.Name .. "_Dropdown"
    self.Multi = Config.Multi or false -- Multi-select support
    self.MaxVisible = Config.MaxVisible or 5
    
    self.Selected = self.Multi and {} or self.Default
    self.Open = false
    
    -- Load saved
    local Saved = SaveManager:GetValue(self.Flag, self.Default)
    self.Selected = Saved or self.Default
    
    -- Container
    self.Instance = Instance.new("Frame")
    self.Instance.Name = self.Name .. "Dropdown"
    self.Instance.Size = UDim2.new(1, 0, 0, 40)
    self.Instance.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Instance.BorderSizePixel = 0
    self.Instance.ClipsDescendants = true
    self.Instance.Parent = Section.ElementContainer
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = self.Instance
    
    -- Header Button
    self.Header = Instance.new("TextButton")
    self.Header.Name = "Header"
    self.Header.Size = UDim2.new(1, 0, 0, 40)
    self.Header.BackgroundColor3 = Theme:GetColor("Tertiary")
    self.Header.BorderSizePixel = 0
    self.Header.Text = ""
    self.Header.AutoButtonColor = false
    self.Header.Parent = self.Instance
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = self.Name
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.Header
    
    -- Selected Text
    self.SelectedLabel = Instance.new("TextLabel")
    self.SelectedLabel.Name = "Selected"
    self.SelectedLabel.Size = UDim2.new(0, 100, 1, 0)
    self.SelectedLabel.Position = UDim2.new(1, -130, 0, 0)
    self.SelectedLabel.BackgroundTransparency = 1
    self.SelectedLabel.Text = self:GetDisplayText()
    self.SelectedLabel.TextColor3 = Theme:GetColor("SubText")
    self.SelectedLabel.TextSize = 12
    self.SelectedLabel.Font = Enum.Font.Gotham
    self.SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.SelectedLabel.Parent = self.Header
    
    -- Arrow Icon
    self.Arrow = LucideIcons:CreateIcon("chevron-down", self.Header, UDim2.new(0, 20, 0, 20), Theme:GetColor("SubText"))
    self.Arrow.Position = UDim2.new(1, -25, 0.5, -10)
    self.Arrow.Name = "Arrow"
    
    -- Options Container
    self.OptionsFrame = Instance.new("Frame")
    self.OptionsFrame.Name = "Options"
    self.OptionsFrame.Size = UDim2.new(1, -20, 0, 0)
    self.OptionsFrame.Position = UDim2.new(0, 10, 0, 45)
    self.OptionsFrame.BackgroundColor3 = Theme:GetColor("Background")
    self.OptionsFrame.BorderSizePixel = 0
    self.OptionsFrame.Visible = false
    self.OptionsFrame.Parent = self.Instance
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 6)
    OptionsCorner.Parent = self.OptionsFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = self.OptionsFrame
    
    -- Scroll Frame
    self.ScrollFrame = Instance.new("ScrollingFrame")
    self.ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ScrollFrame.BackgroundTransparency = 1
    self.ScrollFrame.ScrollBarThickness = 2
    self.ScrollFrame.ScrollBarImageColor3 = Theme:GetColor("Accent")
    self.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ScrollFrame.Parent = self.OptionsFrame
    
    local ScrollList = Instance.new("UIListLayout")
    ScrollList.Padding = UDim.new(0, 2)
    ScrollList.Parent = self.ScrollFrame
    
    ScrollList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollList.AbsoluteContentSize.Y)
    end)
    
    -- Click Event
    self.Header.MouseButton1Click:Connect(function()
        self:Toggle()
    end)
    
    -- Build Options
    self:BuildOptions()
    
    return self
end

function DropdownElement:GetDisplayText()
    if self.Multi then
        local Count = 0
        for _ in pairs(self.Selected) do Count = Count + 1 end
        if Count == 0 then return "None" end
        if Count == 1 then
            for Key, _ in pairs(self.Selected) do return Key end
        end
        return Count .. " selected"
    else
        return tostring(self.Selected)
    end
end

function DropdownElement:BuildOptions()
    -- Clear existing
    for _, Child in ipairs(self.ScrollFrame:GetChildren()) do
        if Child:IsA("TextButton") then Child:Destroy() end
    end
    
    for _, Option in ipairs(self.Options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Name = Option
        OptionBtn.Size = UDim2.new(1, 0, 0, 30)
        OptionBtn.BackgroundColor3 = Theme:GetColor("Background")
        OptionBtn.BorderSizePixel = 0
        OptionBtn.Text = Option
        OptionBtn.TextColor3 = Theme:GetColor("Text")
        OptionBtn.TextSize = 13
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.Parent = self.ScrollFrame
        
        -- Checkmark for selected
        local IsSelected = self.Multi and self.Selected[Option] or (self.Selected == Option)
        
        if IsSelected then
            local Check = LucideIcons:CreateIcon("check", OptionBtn, UDim2.new(0, 16, 0, 16), Theme:GetColor("Accent"))
            Check.Position = UDim2.new(1, -25, 0.5, -8)
        end
        
        OptionBtn.MouseEnter:Connect(function()
            Tween:Create(OptionBtn, {BackgroundColor3 = Theme:GetColor("Tertiary")}, 0.15)
        end)
        
        OptionBtn.MouseLeave:Connect(function()
            Tween:Create(OptionBtn, {BackgroundColor3 = Theme:GetColor("Background")}, 0.15)
        end)
        
        OptionBtn.MouseButton1Click:Connect(function()
            self:Select(Option)
        end)
    end
    
    local TotalHeight = math.min(#self.Options * 32, self.MaxVisible * 32)
    self.OptionsFrame.Size = UDim2.new(1, -20, 0, TotalHeight)
end

function DropdownElement:Toggle()
    self.Open = not self.Open
    
    if self.Open then
        self.OptionsFrame.Visible = true
        Tween:Create(self.Arrow, {Rotation = 180}, 0.2)
        Tween:Create(self.Instance, {Size = UDim2.new(1, 0, 0, 50 + self.OptionsFrame.Size.Y.Offset)}, 0.2)
    else
        Tween:Create(self.Arrow, {Rotation = 0}, 0.2)
        Tween:Create(self.Instance, {Size = UDim2.new(1, 0, 0, 40)}, 0.2).Completed:Connect(function()
            self.OptionsFrame.Visible = false
        end)
    end
end

function DropdownElement:Select(Option)
    if self.Multi then
        if self.Selected[Option] then
            self.Selected[Option] = nil
        else
            self.Selected[Option] = true
        end
    else
        self.Selected = Option
        self:Toggle() -- Close on single select
    end
    
    SaveManager:SetValue(self.Flag, self.Selected)
    self.SelectedLabel.Text = self:GetDisplayText()
    self:BuildOptions()
    
    if self.Callback then
        task.spawn(self.Callback, self.Selected)
    end
end

function DropdownElement:AddOption(Option)
    table.insert(self.Options, Option)
    self:BuildOptions()
end

function DropdownElement:RemoveOption(Option)
    for i, v in ipairs(self.Options) do
        if v == Option then
            table.remove(self.Options, i)
            break
        end
    end
    self:BuildOptions()
end

function DropdownElement:SetOptions(NewOptions)
    self.Options = NewOptions
    self:BuildOptions()
end

function DropdownElement:UpdateName(NewName)
    self.Instance.Title.Text = NewName
end

return DropdownElement
