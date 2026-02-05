--[[ 
    NEXUS LIBRARY v2 (Rayfield x Fluent Inspired)
    Hosted at: https://github.com/NexusHuby/Nexus-Libary
]]

local Nexus = {}
Nexus.__index = Nexus

--// Configuration
local ICON_URL = "https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/main/Nexus-Libary/NexusIcons.lua"
local DEFAULT_ICONS = { ["home"] = "rbxassetid://10709782497", ["settings"] = "rbxassetid://10734950309" }

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

--// Theme (Fluent/Rayfield Hybrid)
local THEME = {
    Background = Color3.fromRGB(20, 20, 20),      -- Darker background
    Sidebar = Color3.fromRGB(25, 25, 25),         -- Slightly lighter sidebar
    Element = Color3.fromRGB(32, 32, 32),         -- Element background
    ElementHover = Color3.fromRGB(40, 40, 40),    -- Hover state
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Accent = Color3.fromRGB(0, 120, 215),         -- Default Blue (Configurable)
    Stroke = Color3.fromRGB(50, 50, 50),          -- Subtle outlines
    Success = Color3.fromRGB(60, 200, 100),
    Error = Color3.fromRGB(200, 60, 60)
}

--// Icon Loader (Automatic)
local IconData = DEFAULT_ICONS
spawn(function()
    local success, result = pcall(function()
        return loadstring(game:HttpGet(ICON_URL))()
    end)
    if success and type(result) == "table" then
        IconData = result
    end
end)

--// Utility Functions
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Main Library
function Nexus.new(config)
    local self = setmetatable({}, Nexus)
    self.Name = config and config.Name or "Nexus Hub"
    self.Accent = config and config.Accent or THEME.Accent
    
    -- Parent Selection
    local success, _ = pcall(function() return CoreGui.Name end)
    local parent = success and CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    if parent:FindFirstChild("NexusLib_v2") then parent.NexusLib_v2:Destroy() end
    
    self.Gui = Create("ScreenGui", {
        Name = "NexusLib_v2",
        Parent = parent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    return self
end

function Nexus:Window(options)
    local WindowName = options.Name or "Nexus Library"
    local Subtitle = options.Subtitle or "v2.0"
    
    -- Main Window Frame (Fluent Style)
    local Main = Create("Frame", {
        Name = "Main",
        Parent = self.Gui,
        BackgroundColor3 = THEME.Background,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 600, 0, 400),
        BorderSizePixel = 0,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Main, Color = THEME.Stroke, Thickness = 1})
    
    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Tween(Main, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    -- Sidebar (Rayfield Style)
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = THEME.Sidebar,
        Size = UDim2.new(0, 160, 1, 0),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 8)})
    -- Fix right corners to be square for seamless join
    local SidebarFix = Create("Frame", {Parent = Sidebar, BackgroundColor3 = THEME.Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BorderSizePixel = 0})

    -- Title Area
    local TitleLabel = Create("TextLabel", {
        Parent = Sidebar,
        Text = WindowName,
        TextColor3 = THEME.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 15, 0, 15),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    local SubLabel = Create("TextLabel", {
        Parent = Sidebar,
        Text = Subtitle,
        TextColor3 = self.Accent,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 15),
        Position = UDim2.new(0, 15, 0, 40),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Tab Button Container
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 70),
        Size = UDim2.new(1, 0, 1, -80),
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)})

    -- Content Area
    local Content = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 10),
        Size = UDim2.new(1, -180, 1, -20),
        ClipsDescendants = true
    })

    local WindowObj = {Tabs = {}}

    function WindowObj:Tab(name, icon)
        local Tab = {}
        
        -- Tab Button
        local Btn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = THEME.Sidebar,
            BackgroundTransparency = 1,
            Text = "      " .. name,
            TextColor3 = THEME.SubText,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            Size = UDim2.new(1, -20, 0, 35),
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
        
        -- Selection Indicator
        local Indicator = Create("Frame", {
            Parent = Btn,
            BackgroundColor3 = self.Accent,
            Size = UDim2.new(0, 3, 0, 18),
            Position = UDim2.new(0, 0, 0.5, -9),
            Visible = false
        })
        Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(0, 2)})

        -- Icon Logic
        if icon and IconData[icon] then
            local Ico = Create("ImageLabel", {
                Parent = Btn,
                BackgroundTransparency = 1,
                Image = IconData[icon],
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, 10, 0.5, -9),
                ImageColor3 = THEME.SubText
            })
            Btn.Text = "          " .. name -- More padding
            
            Btn:GetPropertyChangedSignal("TextColor3"):Connect(function()
                Tween(Ico, {ImageColor3 = Btn.TextColor3})
            end)
        end

        -- Page
        local Page = Create("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0,0,0,0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})
        
        -- Select Tab Logic
        Btn.MouseButton1Click:Connect(function()
            -- Deselect all
            for _, t in pairs(TabContainer:GetChildren()) do
                if t:IsA("TextButton") then
                    Tween(t, {BackgroundTransparency = 1, TextColor3 = THEME.SubText})
                    if t:FindFirstChild("Frame") then t.Frame.Visible = false end
                end
            end
            for _, p in pairs(Content:GetChildren()) do
                if p:IsA("ScrollingFrame") then p.Visible = false end
            end
            
            -- Select Current
            Tween(Btn, {BackgroundTransparency = 0.95, TextColor3 = self.Accent}) -- Subtle glow
            Indicator.Visible = true
            Page.Visible = true
        end)
        
        -- Auto select first
        if #WindowObj.Tabs == 0 then
             Tween(Btn, {BackgroundTransparency = 0.95, TextColor3 = self.Accent})
             Indicator.Visible = true
             Page.Visible = true
        end
        table.insert(WindowObj.Tabs, Tab)

        --// UI ELEMENTS //--
        
        function Tab:Section(text)
            local S = Create("TextLabel", {
                Parent = Page,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("UIPadding", {Parent = S, PaddingLeft = UDim.new(0, 2)})
        end

        function Tab:Button(text, callback)
            local Container = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Size = UDim2.new(1, 0, 0, 38)
            })
            Create("UICorner", {Parent = Container, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Container, Color = THEME.Stroke, Thickness = 1})
            
            local Btn = Create("TextButton", {
                Parent = Container,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1
            })
            
            local Hover = Create("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.new(1,1,1),
                BackgroundTransparency = 1,
                Size = UDim2.new(1,0,1,0),
                ZIndex = 2
            })
            Create("UICorner", {Parent = Hover, CornerRadius = UDim.new(0, 6)})
            
            Btn.MouseEnter:Connect(function() Tween(Hover, {BackgroundTransparency = 0.95}) end)
            Btn.MouseLeave:Connect(function() Tween(Hover, {BackgroundTransparency = 1}) end)
            
            Btn.MouseButton1Click:Connect(function()
                Tween(Container, {BackgroundColor3 = self.Accent}, 0.1)
                task.wait(0.1)
                Tween(Container, {BackgroundColor3 = THEME.Element}, 0.2)
                pcall(callback)
            end)
        end

        function Tab:Toggle(text, default, callback)
            local Toggled = default or false
            
            local Container = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Size = UDim2.new(1, 0, 0, 38)
            })
            Create("UICorner", {Parent = Container, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Container, Color = THEME.Stroke, Thickness = 1})
            
            local Label = Create("TextLabel", {
                Parent = Container,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Create("Frame", {
                Parent = Container,
                BackgroundColor3 = Toggled and self.Accent or Color3.fromRGB(50,50,50),
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10)
            })
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            
            local Circle = Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Size = UDim2.new(0, 16, 0, 16),
                Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            })
            Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
            
            local Btn = Create("TextButton", {Parent = Container, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""})
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local TargetPos = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local TargetColor = Toggled and self.Accent or Color3.fromRGB(50,50,50)
                
                Tween(Circle, {Position = TargetPos})
                Tween(Switch, {BackgroundColor3 = TargetColor})
                pcall(callback, Toggled)
            end)
        end

        function Tab:Slider(text, min, max, default, callback)
            local Value = default or min
            
            local Container = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", {Parent = Container, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Container, Color = THEME.Stroke, Thickness = 1})
            
            local Label = Create("TextLabel", {
                Parent = Container,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 12, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValLabel = Create("TextLabel", {
                Parent = Container,
                Text = tostring(Value),
                TextColor3 = THEME.SubText,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -60, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SliderBG = Create("Frame", {
                Parent = Container,
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.new(0, 12, 0, 35)
            })
            Create("UICorner", {Parent = SliderBG, CornerRadius = UDim.new(1, 0)})
            
            local Fill = Create("Frame", {
                Parent = SliderBG,
                BackgroundColor3 = self.Accent,
                Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            
            local Trigger = Create("TextButton", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = ""})
            
            local dragging = false
            local function update(input)
                local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                local newVal = math.floor(min + ((max - min) * pos))
                Tween(Fill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                ValLabel.Text = tostring(newVal)
                pcall(callback, newVal)
            end
            
            Trigger.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
        end
        
        function Tab:Input(text, placeholder, callback)
            local Container = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Size = UDim2.new(1, 0, 0, 38)
            })
            Create("UICorner", {Parent = Container, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Container, Color = THEME.Stroke, Thickness = 1})
            
            local Label = Create("TextLabel", {
                Parent = Container,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Box = Create("TextBox", {
                Parent = Container,
                Text = "",
                PlaceholderText = placeholder or "Type here...",
                TextColor3 = THEME.Accent,
                PlaceholderColor3 = THEME.SubText,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 150, 1, 0),
                Position = UDim2.new(1, -160, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            Box.FocusLost:Connect(function(enter)
                if enter then
                    pcall(callback, Box.Text)
                end
            end)
        end
        
        -- Notification System
        function Nexus:Notify(title, content, duration)
            local Holder = self.Gui:FindFirstChild("Notifications")
            if not Holder then
                Holder = Create("Frame", {
                    Name = "Notifications",
                    Parent = self.Gui,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 300, 1, -20),
                    Position = UDim2.new(1, -320, 0, 10)
                })
                Create("UIListLayout", {Parent = Holder, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 6)})
            end
            
            local Toast = Create("Frame", {
                Parent = Holder,
                BackgroundColor3 = THEME.Background,
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundTransparency = 1 -- Start invisible
            })
            Create("UICorner", {Parent = Toast, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = Toast, Color = THEME.Stroke, Thickness = 1})
            
            local TTitle = Create("TextLabel", {
                Parent = Toast, Text = title, TextColor3 = self.Accent, Font = Enum.Font.GothamBold, TextSize = 14,
                Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
            })
            local TContent = Create("TextLabel", {
                Parent = Toast, Text = content, TextColor3 = THEME.Text, Font = Enum.Font.Gotham, TextSize = 13,
                Size = UDim2.new(1, -10, 0, 30), Position = UDim2.new(0, 10, 0, 25), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true
            })
            
            Tween(Toast, {BackgroundTransparency = 0.1})
            task.delay(duration or 3, function()
                Tween(Toast, {BackgroundTransparency = 1})
                Tween(TTitle, {TextTransparency = 1})
                Tween(TContent, {TextTransparency = 1})
                task.wait(0.2)
                Toast:Destroy()
            end)
        end

        return Tab
    end
    
    return WindowObj
end

return Nexus
