local Config = {
    -- Default Settings
    Name = "Modern UI",
    Theme = "Dark", -- Dark, Light, Midnight, Ocean
    
    -- Window Settings
    Size = UDim2.new(0, 600, 0, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200),
    MinSize = Vector2.new(400, 300),
    
    -- Auto Save
    AutoSave = true,
    SaveKey = "ModernUI_Config",
    SaveInterval = 30, -- seconds
    
    -- Animation Settings
    AnimationSpeed = 0.3,
    EasingStyle = Enum.EasingStyle.Quart,
    EasingDirection = Enum.EasingDirection.Out,
    
    -- Keybinds
    ToggleKey = Enum.KeyCode.RightShift,
    
    -- Features
    ShowNotifications = true,
    SoundEffects = true,
    BlurBackground = false,
    
    -- Custom Theme Colors (optional)
    CustomColors = nil
}

return Config
