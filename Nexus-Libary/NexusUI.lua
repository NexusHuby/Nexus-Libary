--[[ 
    APEX LIBRARY v1.0
    A comprehensive, single-script UI Library for Roblox.
    
    Features:
    - Draggable, Modern Windows
    - Tabs & Sections
    - Buttons, Toggles, Sliders, Dropdowns, Keybinds
    - Notification System
    - Zero external assets (uses vector UI)
    - Animations built-in
    
    How to use:
    1. Upload this code to GitHub as a raw file.
    2. Use loadstring(game:HttpGet("YOUR_RAW_GITHUB_LINK"))() in your script.
]]

local Apex = {}
Apex.__index = Apex

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--// Constants & Theming
local THEME = {
    Main = Color3.fromRGB(25, 25, 25),
    Header = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 120, 215), -- Blue Accent
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150),
    Element = Color3.fromRGB(35, 35, 35),
    ElementHover = Color3.fromRGB(45, 45, 45),
    Stroke = Color3.fromRGB(60, 60, 60)
}

--// Utility Functions
local function Create(class, properties)
    local instance = Instance.new(class)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function MakeDraggable(topbar, widget)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(widget, TweenInfo.new(0.15), {Position = targetPos}):Play()
    end
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = widget.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

--// Main Library Logic
function Apex.new()
    local self = setmetatable({}, Apex)
    
    -- Detect Parent (Safe for Game or Executor)
    local success, _ = pcall(function() return CoreGui.Name end)
    local parent = success and CoreGui or Players.LocalPlayer:WaitForChild("PlayerGui")
    
    self.ScreenGui = Create("ScreenGui", {
        Name = "ApexLibrary",
        Parent = parent,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    return self
end

function Apex:Window(options)
    local WindowName = options.Title or "Apex Library"
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = self.ScreenGui,
        BackgroundColor3 = THEME.Main,
        Position = UDim2.new(0.5, -250, 0.5, -175),
        Size = UDim2.new(0, 500, 0, 350),
        BorderSizePixel = 0
    })
    
    -- Styling
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = MainFrame, Color = THEME.Stroke, Thickness = 1})
    
    local Header = Create("Frame", {
        Name = "Header",
        Parent = MainFrame,
        BackgroundColor3 = THEME.Header,
        Size = UDim2.new(1, 0, 0, 40),
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Header, CornerRadius = UDim.new(0, 6)})
    
    -- Fix bottom corners of header
    local HeaderFix = Create("Frame", {
        Parent = Header,
        BackgroundColor3 = THEME.Header,
        BorderSizePixel = 0,
        Position = UDim2.new(0,0,1,-5),
        Size = UDim2.new(1,0,0,5)
    })
    
    local Title = Create("TextLabel", {
        Parent = Header,
        Text = WindowName,
        TextColor3 = THEME.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    MakeDraggable(Header, MainFrame)
    
    -- Container for Elements
    local Container = Create("Frame", {
        Name = "Container",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(1, 0, 1, -45)
    })
    
    local TabContainer = Create("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 130, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    Create("UIListLayout", {
        Parent = TabContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    Create("UIPadding", {Parent = TabContainer, PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10)})
    
    -- Divider
    local Divider = Create("Frame", {
        Parent = Container,
        BackgroundColor3 = THEME.Stroke,
        Size = UDim2.new(0, 1, 1, -20),
        Position = UDim2.new(0, 140, 0, 10)
    })
    
    -- Page Holder
    local PageHolder = Create("Frame", {
        Name = "PageHolder",
        Parent = Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 0),
        Size = UDim2.new(1, -160, 1, 0)
    })
    
    local WindowObj = {
        Tabs = {}
    }
    
    -- Window Methods
    function WindowObj:Tab(name)
        local Tab = {}
        
        -- Create Tab Button
        local TabBtn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = THEME.Element,
            Text = name,
            TextColor3 = THEME.TextDark,
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            Size = UDim2.new(1, -10, 0, 30),
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 4)})
        
        -- Create Page
        local Page = Create("ScrollingFrame", {
            Name = name.."_Page",
            Parent = PageHolder,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false, -- Hidden by default
            ScrollBarThickness = 2,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {
            Parent = Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
        
        -- Tab Activation Logic
        TabBtn.MouseButton1Click:Connect(function()
            -- Reset all tabs
            for _, t in pairs(TabContainer:GetChildren()) do
                if t:IsA("TextButton") then
                    TweenService:Create(t, TweenInfo.new(0.2), {TextColor3 = THEME.TextDark, BackgroundColor3 = THEME.Element}):Play()
                end
            end
            -- Hide all pages
            for _, p in pairs(PageHolder:GetChildren()) do
                if p:IsA("ScrollingFrame") then p.Visible = false end
            end
            
            -- Activate this tab
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = THEME.Text, BackgroundColor3 = THEME.Accent}):Play()
            Page.Visible = true
        end)
        
        -- If first tab, activate it
        if #WindowObj.Tabs == 0 then
            TabBtn.TextColor3 = THEME.Text
            TabBtn.BackgroundColor3 = THEME.Accent
            Page.Visible = true
        end
        table.insert(WindowObj.Tabs, Tab)
        
        --// ELEMENT FUNCTIONS //--
        
        function Tab:Section(text)
            local SectionLabel = Create("TextLabel", {
                Parent = Page,
                Text = text,
                TextColor3 = THEME.TextDark,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end
        
        function Tab:Button(text, callback)
            local Btn = Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Size = UDim2.new(1, 0, 0, 35),
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
            
            Btn.MouseButton1Click:Connect(function()
                local s, e = pcall(callback)
                if not s then warn("Button Callback Error: " .. e) end
                
                -- Click Animation
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = THEME.Accent}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Element}):Play()
            end)
        end
        
        function Tab:Toggle(text, default, callback)
            local Toggled = default or false
            
            local Frame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Size = UDim2.new(1, 0, 0, 35)
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 4)})
            
            local Label = Create("TextLabel", {
                Parent = Frame,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Indicator = Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Toggled and THEME.Accent or Color3.fromRGB(60,60,60),
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10)
            })
            Create("UICorner", {Parent = Indicator, CornerRadius = UDim.new(0, 4)})
            
            local Btn = Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            Btn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                local targetColor = Toggled and THEME.Accent or Color3.fromRGB(60,60,60)
                TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                pcall(callback, Toggled)
            end)
        end
        
        function Tab:Slider(text, min, max, default, callback)
            local Value = default or min
            
            local Frame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 4)})
            
            local Label = Create("TextLabel", {
                Parent = Frame,
                Text = text,
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 10, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValueLabel = Create("TextLabel", {
                Parent = Frame,
                Text = tostring(Value),
                TextColor3 = THEME.TextDark,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -60, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local SliderBar = Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 35)
            })
            Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})
            
            local Fill = Create("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = THEME.Accent,
                Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            
            local Trigger = Create("TextButton", {
                Parent = SliderBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local dragging = false
            
            local function update(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                Fill.Size = pos
                
                local sVal = math.floor(min + ((max - min) * pos.X.Scale))
                ValueLabel.Text = tostring(sVal)
                pcall(callback, sVal)
            end
            
            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
        end
        
        function Tab:Dropdown(text, options, callback)
            local Dropped = false
            local Selected = options[1]
            
            local Frame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = THEME.Element,
                Size = UDim2.new(1, 0, 0, 35),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 4)})
            
            local Label = Create("TextLabel", {
                Parent = Frame,
                Text = text .. ": " .. tostring(Selected),
                TextColor3 = THEME.Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -30, 0, 35),
                Position = UDim2.new(0, 10, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Arrow = Create("TextLabel", {
                Parent = Frame,
                Text = "V",
                TextColor3 = THEME.TextDark,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 30, 0, 35),
                Position = UDim2.new(1, -30, 0, 0)
            })
            
            local Trigger = Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                Text = ""
            })
            
            -- Dropdown List
            local List = Create("ScrollingFrame", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 40),
                Size = UDim2.new(1, 0, 0, 100),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2
            })
            Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder})
            
            local function RefreshOptions()
                for _, v in pairs(List:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                for _, opt in pairs(options) do
                    local Item = Create("TextButton", {
                        Parent = List,
                        BackgroundColor3 = THEME.Element,
                        Text = opt,
                        TextColor3 = THEME.TextDark,
                        Font = Enum.Font.Gotham,
                        TextSize = 14,
                        Size = UDim2.new(1, 0, 0, 30)
                    })
                    
                    Item.MouseButton1Click:Connect(function()
                        Selected = opt
                        Label.Text = text .. ": " .. tostring(Selected)
                        Dropped = false
                        Frame:TweenSize(UDim2.new(1, 0, 0, 35), "Out", "Quad", 0.2)
                        Arrow.Rotation = 0
                        pcall(callback, opt)
                    end)
                end
            end
            
            RefreshOptions()
            
            Trigger.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                if Dropped then
                    Frame:TweenSize(UDim2.new(1, 0, 0, 150), "Out", "Quad", 0.2)
                    Arrow.Rotation = 180
                else
                    Frame:TweenSize(UDim2.new(1, 0, 0, 35), "Out", "Quad", 0.2)
                    Arrow.Rotation = 0
                end
            end)
        end
        
        return Tab
    end
    
    function Apex:Notify(title, text, duration)
        local NotificationHolder = self.ScreenGui:FindFirstChild("NotificationHolder")
        if not NotificationHolder then
            NotificationHolder = Create("Frame", {
                Name = "NotificationHolder",
                Parent = self.ScreenGui,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -220, 1, -20),
                Size = UDim2.new(0, 200, 1, 0),
                AnchorPoint = Vector2.new(0, 1)
            })
            Create("UIListLayout", {
                Parent = NotificationHolder,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Padding = UDim.new(0, 5)
            })
        end
        
        local Notif = Create("Frame", {
            Parent = NotificationHolder,
            BackgroundColor3 = THEME.Header,
            Size = UDim2.new(1, 0, 0, 0), -- Start small
            ClipsDescendants = true
        })
        Create("UICorner", {Parent = Notif, CornerRadius = UDim.new(0, 4)})
        Create("UIStroke", {Parent = Notif, Color = THEME.Stroke, Thickness = 1})
        
        local NTitle = Create("TextLabel", {
            Parent = Notif,
            Text = title,
            TextColor3 = THEME.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 10, 0, 5),
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local NText = Create("TextLabel", {
            Parent = Notif,
            Text = text,
            TextColor3 = THEME.Text,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 10, 0, 25),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        
        -- Animate In
        TweenService:Create(Notif, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 60)}):Play()
        
        -- Cleanup
        task.delay(duration or 3, function()
            TweenService:Create(Notif, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            Notif:Destroy()
        end)
    end
    
    return WindowObj
end

return Apex
