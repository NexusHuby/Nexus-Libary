--[[ 
    NEXUS UI v3.2 (The "Everything Fix" Edition)
    - Fixed elements not appearing in multiple tabs
    - Fixed LayoutOrder overlap issues
    - Improved Scrollbar & Canvas logic
    - Added high-contrast UIStrokes for visibility
]]

local Nexus = {}
Nexus.__index = Nexus

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

--// Theming
local THEME = {
    Main = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 125, 255),
    Outline = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(160, 160, 160),
    Element = Color3.fromRGB(24, 24, 24),
    ElementHover = Color3.fromRGB(32, 32, 32)
}

--// Icon Loader
local Icons = {}
task.spawn(function()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/NexusHuby/Nexus-Libary/refs/heads/main/Nexus-Libary/NexusIcons.lua"))()
    end)
    if success and type(result) == "table" then Icons = result end
end)

--// Utility
local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function ApplyTween(obj, props, t)
    if not obj then return end
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Main Setup
function Nexus.new(config)
    local self = setmetatable({}, Nexus)
    config = config or {}
    self.Title = config.Name or "Nexus Library"
    
    local parent
    pcall(function() parent = CoreGui end)
    if not parent then parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    
    if parent:FindFirstChild("Nexus_v3") then parent.Nexus_v3:Destroy() end
    
    self.Gui = Create("ScreenGui", {Name = "Nexus_v3", Parent = parent, ResetOnSpawn = false})
    return self
end

function Nexus:Window()
    local Win = {Pages = {}, TabButtons = {}, CurrentTab = nil}
    
    -- Main Frame
    local Main = Create("Frame", {
        Name = "Main",
        Parent = self.Gui,
        BackgroundColor3 = THEME.Main,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
    Create("UIStroke", {Color = THEME.Outline, Thickness = 1.2, Parent = Main})

    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = THEME.Sidebar,
        Size = UDim2.new(0, 150, 1, 0)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sidebar})
    
    Create("TextLabel", {
        Parent = Sidebar, Text = self.Title, Font = Enum.Font.GothamBold, TextSize = 16,
        TextColor3 = THEME.Text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15), Size = UDim2.new(1, -20, 0, 30), TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabScroll = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 60),
        Size = UDim2.new(1, -10, 1, -70), ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    Create("UIListLayout", {Parent = TabScroll, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder})

    local Content = Create("Frame", {
        Name = "Content", Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 10), Size = UDim2.new(1, -170, 1, -20)
    })

    -- Dragging Logic
    local dragStart, startPos, dragging
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    function Win:Tab(name, icon)
        local T = { ElementCount = 0 }
        
        -- Tab Button
        local TabBtn = Create("TextButton", {
            Parent = TabScroll, Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = THEME.Accent,
            BackgroundTransparency = 1, Text = "       " .. name, Font = Enum.Font.GothamMedium,
            TextSize = 13, TextColor3 = THEME.DarkText, AutoButtonColor = false, TextXAlignment = Enum.TextXAlignment.Left
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        local IcoImg = Create("ImageLabel", {
            Parent = TabBtn, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16), Image = Icons[icon] or "rbxassetid://10709782497", ImageColor3 = THEME.DarkText
        })

        -- Tab Content Page
        local Page = Create("ScrollingFrame", {
            Name = name .. "_Page",
            Parent = Content, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = THEME.Accent,
            CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
        Create("UIPadding", {Parent = Page, PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 5)})

        function T:Activate()
            for _, v in pairs(Win.TabButtons) do 
                ApplyTween(v.btn, {BackgroundTransparency = 1, TextColor3 = THEME.DarkText})
                ApplyTween(v.ico, {ImageColor3 = THEME.DarkText})
            end
            for _, v in pairs(Win.Pages) do v.Visible = false end
            ApplyTween(TabBtn, {BackgroundTransparency = 0.85, TextColor3 = THEME.Text})
            ApplyTween(IcoImg, {ImageColor3 = THEME.Text})
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(function() T:Activate() end)
        table.insert(Win.TabButtons, {btn = TabBtn, ico = IcoImg})
        table.insert(Win.Pages, Page)
        if #Win.Pages == 1 then T:Activate() end

        --// Element Creator Helper
        local function NewElement(height)
            T.ElementCount = T.ElementCount + 1
            local Frame = Create("Frame", {
                Parent = Page, 
                Size = UDim2.new(1, 0, 0, height or 35), 
                BackgroundColor3 = THEME.Element,
                LayoutOrder = T.ElementCount
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Frame})
            Create("UIStroke", {Color = THEME.Outline, Parent = Frame})
            return Frame
        end

        --// Button
        function T:Button(text, callback)
            local F = NewElement(35)
            local B = Create("TextButton", {
                Parent = F, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text
            })
            B.MouseButton1Click:Connect(function() 
                ApplyTween(F, {BackgroundColor3 = THEME.Accent}, 0.1)
                task.wait(0.1)
                ApplyTween(F, {BackgroundColor3 = THEME.Element}, 0.2)
                pcall(callback) 
            end)
        end

        --// Toggle
        function T:Toggle(text, default, callback)
            local state = default or false
            local F = NewElement(35)
            
            local L = Create("TextLabel", {
                Parent = F, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text,
                BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -50, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
            })

            local SwitchBG = Create("Frame", {
                Parent = F, Size = UDim2.new(0, 32, 0, 18), Position = UDim2.new(1, -42, 0.5, -9),
                BackgroundColor3 = state and THEME.Accent or THEME.Outline
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SwitchBG})

            local Dot = Create("Frame", {
                Parent = SwitchBG, Size = UDim2.new(0, 12, 0, 12),
                Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
                BackgroundColor3 = THEME.Text
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Dot})

            local B = Create("TextButton", {Parent = F, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
            B.MouseButton1Click:Connect(function()
                state = not state
                ApplyTween(SwitchBG, {BackgroundColor3 = state and THEME.Accent or THEME.Outline})
                ApplyTween(Dot, {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
                pcall(callback, state)
            end)
        end

        --// Slider
        function T:Slider(text, min, max, default, callback)
            local F = NewElement(45)
            local L = Create("TextLabel", {
                Parent = F, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text,
                BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 15), TextXAlignment = Enum.TextXAlignment.Left
            })
            local ValL = Create("TextLabel", {
                Parent = F, Text = tostring(default), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = THEME.Accent,
                BackgroundTransparency = 1, Position = UDim2.new(1, -62, 0, 8), Size = UDim2.new(0, 50, 0, 15), TextXAlignment = Enum.TextXAlignment.Right
            })
            local BarBG = Create("Frame", {
                Parent = F, Size = UDim2.new(1, -24, 0, 4), Position = UDim2.new(0, 12, 0, 32), BackgroundColor3 = THEME.Outline
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BarBG})
            local Fill = Create("Frame", {
                Parent = BarBG, Size = UDim2.new((default-min)/(max-min), 0, 1, 0), BackgroundColor3 = THEME.Accent
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Fill})

            local function Update(input)
                local perc = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * perc)
                Fill.Size = UDim2.new(perc, 0, 1, 0)
                ValL.Text = tostring(val)
                pcall(callback, val)
            end

            local sliding = false
            F.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; Update(i) end end)
            UserInputService.InputChanged:Connect(function(i) if sliding and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
        end

        --// Dropdown
        function T:Dropdown(text, list, callback)
            local F = NewElement(35)
            F.ClipsDescendants = true
            local dropped = false
            
            local L = Create("TextLabel", {
                Parent = F, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text,
                BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -12, 0, 35), TextXAlignment = Enum.TextXAlignment.Left
            })

            local Holder = Create("Frame", {Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 35), Size = UDim2.new(1, 0, 0, #list * 30)})
            Create("UIListLayout", {Parent = Holder})

            for _, val in pairs(list) do
                local Item = Create("TextButton", {
                    Parent = Holder, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
                    Text = tostring(val), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = THEME.DarkText
                })
                Item.MouseButton1Click:Connect(function()
                    L.Text = text .. ": " .. tostring(val)
                    dropped = false
                    ApplyTween(F, {Size = UDim2.new(1, 0, 0, 35)})
                    pcall(callback, val)
                end)
            end

            local B = Create("TextButton", {Parent = F, Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Text = ""})
            B.MouseButton1Click:Connect(function()
                dropped = not dropped
                ApplyTween(F, {Size = dropped and UDim2.new(1, 0, 0, 35 + (#list * 30)) or UDim2.new(1, 0, 0, 35)})
            end)
        end

        return T
    end

    function Win:Notify(title, msg)
        local N = Create("Frame", {
            Parent = self.Gui, Size = UDim2.new(0, 220, 0, 60), 
            Position = UDim2.new(1, 10, 1, -70), BackgroundColor3 = THEME.Sidebar
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = N})
        Create("UIStroke", {Color = THEME.Accent, Thickness = 1.5, Parent = N})
        Create("TextLabel", {Parent = N, Text = title, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = THEME.Accent, Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1})
        Create("TextLabel", {Parent = N, Text = msg, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = THEME.Text, Position = UDim2.new(0, 10, 0, 25), Size = UDim2.new(1, -20, 0, 30), TextXAlignment = 0, BackgroundTransparency = 1, TextWrapped = true})

        ApplyTween(N, {Position = UDim2.new(1, -230, 1, -70)})
        task.delay(4, function() ApplyTween(N, {Position = UDim2.new(1, 10, 1, -70)}) task.wait(0.3) N:Destroy() end)
    end

    return Win
end

return Nexus
