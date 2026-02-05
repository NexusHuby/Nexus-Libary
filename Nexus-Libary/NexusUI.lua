--[[ 
    NEXUS UI v3.1 (Fixed & Expanded)
    - Fixed line 79 RunService/CoreGui error
    - Added Dropdowns
    - Added Keybinds
    - Improved Auto-Canvas scaling
]]

local Nexus = {}
Nexus.__index = Nexus

--// Services (Explicitly Defined)
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
    Outline = Color3.fromRGB(40, 40, 40),
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
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Main Setup
function Nexus.new(config)
    local self = setmetatable({}, Nexus)
    config = config or {}
    self.Title = config.Name or "Nexus Library"
    
    -- Fixed Parent Logic
    local parent
    local success = pcall(function() parent = CoreGui end)
    if not success or not parent then
        parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    if parent:FindFirstChild("Nexus_v3") then parent.Nexus_v3:Destroy() end
    
    self.Gui = Create("ScreenGui", {Name = "Nexus_v3", Parent = parent, ResetOnSpawn = false})
    return self
end

function Nexus:Window()
    local Win = {Pages = {}, TabButtons = {}}
    
    local Main = Create("Frame", {
        Name = "Main",
        Parent = self.Gui,
        BackgroundColor3 = THEME.Main,
        Position = UDim2.new(0.5, -275, 0.5, -175),
        Size = UDim2.new(0, 550, 0, 350)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
    Create("UIStroke", {Color = THEME.Outline, Thickness = 1.2, Parent = Main})

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = THEME.Sidebar,
        Size = UDim2.new(0, 150, 1, 0)
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sidebar})
    
    Create("TextLabel", {
        Parent = Sidebar, Text = self.Title, Font = Enum.Font.GothamBold, TextSize = 18,
        TextColor3 = THEME.Text, BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15), Size = UDim2.new(1, -20, 0, 30), TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabScroll = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 60),
        Size = UDim2.new(1, -10, 1, -70), ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    Create("UIListLayout", {Parent = TabScroll, Padding = UDim.new(0, 4)})

    local Content = Create("Frame", {
        Name = "Content", Parent = Main, BackgroundTransparency = 1,
        Position = UDim2.new(0, 160, 0, 10), Size = UDim2.new(1, -170, 1, -20)
    })

    -- Dragging
    local dragStart, startPos, dragging
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = i.Position; startPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    function Win:Tab(name, icon)
        local T = {}
        
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

        local Page = Create("ScrollingFrame", {
            Parent = Content, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = THEME.Accent,
            CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        Create("UIListLayout", {Parent = Page, Padding = UDim.new(0, 6)})

        function T:Activate()
            for _, v in pairs(Win.TabButtons) do 
                ApplyTween(v.btn, {BackgroundTransparency = 1, TextColor3 = THEME.DarkText})
                ApplyTween(v.ico, {ImageColor3 = THEME.DarkText})
            end
            for _, v in pairs(Win.Pages) do v.Visible = false end
            ApplyTween(TabBtn, {BackgroundTransparency = 0.8, TextColor3 = THEME.Text})
            ApplyTween(IcoImg, {ImageColor3 = THEME.Text})
            Page.Visible = true
        end

        TabBtn.MouseButton1Click:Connect(function() T:Activate() end)
        table.insert(Win.TabButtons, {btn = TabBtn, ico = IcoImg})
        table.insert(Win.Pages, Page)
        if #Win.Pages == 1 then T:Activate() end

        --// Button
        function T:Button(text, callback)
            local BtnFrame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = THEME.Element})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = BtnFrame})
            Create("UIStroke", {Color = THEME.Outline, Parent = BtnFrame})
            
            local B = Create("TextButton", {
                Parent = BtnFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text
            })
            B.MouseButton1Click:Connect(function() pcall(callback) end)
        end

        --// Toggle
        function T:Toggle(text, default, callback)
            local state = default or false
            local TFrame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = THEME.Element})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TFrame})
            
            Create("TextLabel", {
                Parent = TFrame, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text,
                BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -50, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
            })

            local Switch = Create("Frame", {
                Parent = TFrame, Size = UDim2.new(0, 30, 0, 16), Position = UDim2.new(1, -40, 0.5, -8),
                BackgroundColor3 = state and THEME.Accent or THEME.Outline
            })
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Switch})

            local B = Create("TextButton", {Parent = TFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
            B.MouseButton1Click:Connect(function()
                state = not state
                ApplyTween(Switch, {BackgroundColor3 = state and THEME.Accent or THEME.Outline})
                pcall(callback, state)
            end)
        end

        --// Dropdown
        function T:Dropdown(text, list, callback)
            local dropped = false
            local DFrame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = THEME.Element, ClipsDescendants = true})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = DFrame})
            
            local Label = Create("TextLabel", {
                Parent = DFrame, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text,
                BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -12, 0, 35), TextXAlignment = Enum.TextXAlignment.Left
            })

            local ItemHolder = Create("Frame", {Parent = DFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 35), Size = UDim2.new(1, 0, 0, #list * 30)})
            Create("UIListLayout", {Parent = ItemHolder})

            for _, val in pairs(list) do
                local Item = Create("TextButton", {
                    Parent = ItemHolder, Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
                    Text = tostring(val), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = THEME.DarkText
                })
                Item.MouseButton1Click:Connect(function()
                    Label.Text = text .. ": " .. tostring(val)
                    dropped = false
                    ApplyTween(DFrame, {Size = UDim2.new(1, 0, 0, 35)})
                    pcall(callback, val)
                end)
            end

            local Btn = Create("TextButton", {Parent = DFrame, Size = UDim2.new(1, 0, 0, 35), BackgroundTransparency = 1, Text = ""})
            Btn.MouseButton1Click:Connect(function()
                dropped = not dropped
                ApplyTween(DFrame, {Size = dropped and UDim2.new(1, 0, 0, 35 + (#list * 30)) or UDim2.new(1, 0, 0, 35)})
            end)
        end

        --// Keybind
        function T:Keybind(text, default, callback)
            local bind = default
            local KFrame = Create("Frame", {Parent = Page, Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = THEME.Element})
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KFrame})

            local Label = Create("TextLabel", {
                Parent = KFrame, Text = text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = THEME.Text,
                BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -12, 1, 0), TextXAlignment = Enum.TextXAlignment.Left
            })

            local BindLab = Create("TextLabel", {
                Parent = KFrame, Text = bind.Name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.Accent,
                BackgroundTransparency = 0.9, BackgroundColor3 = THEME.Text, Size = UDim2.new(0, 60, 0, 20), Position = UDim2.new(1, -70, 0.5, -10)
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = BindLab})

            local Btn = Create("TextButton", {Parent = KFrame, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
            Btn.MouseButton1Click:Connect(function()
                BindLab.Text = "..."
                local input = UserInputService.InputBegan:Wait()
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    bind = input.KeyCode
                    BindLab.Text = bind.Name
                end
            end)

            UserInputService.InputBegan:Connect(function(i, g)
                if not g and i.KeyCode == bind then pcall(callback) end
            end)
        end

        return T
    end

    function Win:Notify(title, msg)
        local NFrame = Create("Frame", {
            Parent = self.Gui, Size = UDim2.new(0, 250, 0, 60), 
            Position = UDim2.new(1, 10, 1, -70), BackgroundColor3 = THEME.Sidebar
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NFrame})
        Create("UIStroke", {Color = THEME.Accent, Parent = NFrame})
        ApplyTween(NFrame, {Position = UDim2.new(1, -260, 1, -70)})
        task.delay(3, function() ApplyTween(NFrame, {Position = UDim2.new(1, 10, 1, -70)}) end)
    end

    return Win
end

return Nexus
