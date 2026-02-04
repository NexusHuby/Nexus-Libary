local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Window = {}
Window.__index = Window

-- Load dependencies
local Theme = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Theme.lua"))()
local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/Tween.lua"))()
local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Utils/LucideIcons.lua"))()
local TabModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_REPO/main/src/Components/Tab.lua"))()

function Window:Create(ConfigData, Library)
    local self = setmetatable({}, Window)
    
    self.Library = Library
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Visible = true
    self.Dragging = false
    self.DragStart = nil
    self.StartPos = nil
    
    -- ScreenGui
    self.Gui = Instance.new("ScreenGui")
    self.Gui.Name = ConfigData.Name or "ModernUI"
    self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.Gui.ResetOnSpawn = false
    self.Gui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    self.Main = Instance.new("Frame")
    self.Main.Name = "MainWindow"
    self.Main.Size = ConfigData.Size or UDim2.new(0, 600, 0, 400)
    self.Main.Position = ConfigData.Position or UDim2.new(0.5, -300, 0.5, -200)
    self.Main.BackgroundColor3 = Theme:GetColor("Background")
    self.Main.BorderSizePixel = 0
    self.Main.ClipsDescendants = true
    self.Main.Parent = self.Gui
    
    -- Corner Radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = self.Main
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 47, 1, 47)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Theme:GetColor("Shadow")
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = self.Main
    
    -- Top Bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 45)
    self.TopBar.BackgroundColor3 = Theme:GetColor("Secondary")
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.Main
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = self.TopBar
    
    -- Fix bottom corners of top bar
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.BackgroundColor3 = Theme:GetColor("Secondary")
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Parent = self.TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = ConfigData.Title or ConfigData.Name or "Modern UI"
    Title.TextColor3 = Theme:GetColor("Text")
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = self.TopBar
    
    -- Window Controls
    local Controls = Instance.new("Frame")
    Controls.Name = "Controls"
    Controls.Size = UDim2.new(0, 70, 1, 0)
    Controls.Position = UDim2.new(1, -75, 0, 0)
    Controls.BackgroundTransparency = 1
    Controls.Parent = self.TopBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "Minimize"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(0, 0, 0.5, -15)
    MinimizeBtn.BackgroundColor3 = Theme:GetColor("Tertiary")
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Theme:GetColor("Text")
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = Controls
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(0, 35, 0.5, -15)
    CloseBtn.BackgroundColor3 = Theme:GetColor("Error")
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Controls
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Sidebar (Tab Container)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, 160, 1, -45)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 45)
    self.Sidebar.BackgroundColor3 = Theme:GetColor("Secondary")
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.Main
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Size = UDim2.new(0, 10, 1, 0)
    SidebarFix.Position = UDim2.new(1, -10, 0, 0)
    SidebarFix.BackgroundColor3 = Theme:GetColor("Secondary")
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = self.Sidebar
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = self.Sidebar
    
    -- Tab Buttons Container
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Name = "TabList"
    self.TabList.Size = UDim2.new(1, -10, 1, -10)
    self.TabList.Position = UDim2.new(0, 5, 0, 5)
    self.TabList.BackgroundTransparency = 1
    self.TabList.ScrollBarThickness = 2
    self.TabList.ScrollBarImageColor3 = Theme:GetColor("Accent")
    self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.TabList.Parent = self.Sidebar
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Parent = self.TabList
    
    -- Content Area
    self.Content = Instance.new("Frame")
    self.Content.Name = "Content"
    self.Content.Size = UDim2.new(1, -160, 1, -45)
    self.Content.Position = UDim2.new(0, 160, 0, 45)
    self.Content.BackgroundColor3 = Theme:GetColor("Background")
    self.Content.BorderSizePixel = 0
    self.Content.Parent = self.Main
    
    -- Dragging Logic
    self.TopBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            self.DragStart = Input.Position
            self.StartPos = self.Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if self.Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - self.DragStart
            self.Main.Position = UDim2.new(
                self.StartPos.X.Scale,
                self.StartPos.X.Offset + Delta.X,
                self.StartPos.Y.Scale,
                self.StartPos.Y.Offset + Delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
    
    -- Button Events
    MinimizeBtn.MouseButton1Click:Connect(function()
        self:Minimize()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Hover Effects
    local function AddHoverEffect(Button, OriginalColor, HoverColor)
        Button.MouseEnter:Connect(function()
            Tween:Create(Button, {BackgroundColor3 = HoverColor}, 0.2)
        end)
        Button.MouseLeave:Connect(function()
            Tween:Create(Button, {BackgroundColor3 = OriginalColor}, 0.2)
        end)
    end
    
    AddHoverEffect(MinimizeBtn, Theme:GetColor("Tertiary"), Theme:GetColor("Hover"))
    AddHoverEffect(CloseBtn, Theme:GetColor("Error"), Color3.fromRGB(255, 100, 100))
    
    -- Intro Animation
    self.Main.Size = UDim2.new(0, 0, 0, 0)
    Tween:Create(self.Main, {
        Size = ConfigData.Size or UDim2.new(0, 600, 0, 400),
        Position = ConfigData.Position or UDim2.new(0.5, -300, 0.5, -200)
    }, 0.5, Enum.EasingStyle.Back)
    
    self.Instance = self.Gui
    return self
end

function Window:CreateTab(Name, Icon)
    local Tab = TabModule:Create(self, Name, Icon)
    table.insert(self.Tabs, Tab)
    
    if #self.Tabs == 1 then
        Tab:Select()
    end
    
    return Tab
end

function Window:Minimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        Tween:Create(self.Main, {Size = UDim2.new(0, self.Main.Size.X.Offset, 0, 45)}, 0.3)
        self.Content.Visible = false
        self.Sidebar.Visible = false
    else
        Tween:Create(self.Main, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
        task.delay(0.3, function()
            self.Content.Visible = true
            self.Sidebar.Visible = true
        end)
    end
end

function Window:ToggleVisibility()
    self.Visible = not self.Visible
    self.Main.Visible = self.Visible
end

function Window:Destroy()
    if self.Instance then
        local TweenObj = Tween:Create(self.Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        TweenObj.Completed:Connect(function()
            self.Instance:Destroy()
        end)
    end
end

return Window
