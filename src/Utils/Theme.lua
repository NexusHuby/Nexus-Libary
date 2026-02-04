local Theme = {
    Current = "Dark",
    
    Palettes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 25),
            Secondary = Color3.fromRGB(35, 35, 35),
            Tertiary = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(88, 101, 242), -- Discord blurple
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(178, 178, 178),
            Border = Color3.fromRGB(55, 55, 55),
            Hover = Color3.fromRGB(60, 60, 60),
            Success = Color3.fromRGB(87, 242, 135),
            Warning = Color3.fromRGB(254, 231, 92),
            Error = Color3.fromRGB(237, 69, 69),
            Shadow = Color3.fromRGB(0, 0, 0)
        },
        
        Light = {
            Background = Color3.fromRGB(245, 245, 245),
            Secondary = Color3.fromRGB(255, 255, 255),
            Tertiary = Color3.fromRGB(235, 235, 235),
            Accent = Color3.fromRGB(88, 101, 242),
            Text = Color3.fromRGB(30, 30, 30),
            SubText = Color3.fromRGB(100, 100, 100),
            Border = Color3.fromRGB(200, 200, 200),
            Hover = Color3.fromRGB(220, 220, 220),
            Success = Color3.fromRGB(46, 204, 113),
            Warning = Color3.fromRGB(241, 196, 15),
            Error = Color3.fromRGB(231, 76, 60),
            Shadow = Color3.fromRGB(180, 180, 180)
        },
        
        Midnight = {
            Background = Color3.fromRGB(15, 15, 25),
            Secondary = Color3.fromRGB(25, 25, 40),
            Tertiary = Color3.fromRGB(35, 35, 55),
            Accent = Color3.fromRGB(114, 137, 218),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(150, 150, 170),
            Border = Color3.fromRGB(40, 40, 60),
            Hover = Color3.fromRGB(45, 45, 70),
            Success = Color3.fromRGB(87, 242, 135),
            Warning = Color3.fromRGB(254, 231, 92),
            Error = Color3.fromRGB(237, 69, 69),
            Shadow = Color3.fromRGB(0, 0, 10)
        },
        
        Ocean = {
            Background = Color3.fromRGB(20, 30, 40),
            Secondary = Color3.fromRGB(30, 45, 60),
            Tertiary = Color3.fromRGB(40, 60, 80),
            Accent = Color3.fromRGB(0, 200, 255),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(150, 180, 200),
            Border = Color3.fromRGB(50, 70, 90),
            Hover = Color3.fromRGB(50, 75, 100),
            Success = Color3.fromRGB(0, 255, 150),
            Warning = Color3.fromRGB(255, 200, 50),
            Error = Color3.fromRGB(255, 80, 80),
            Shadow = Color3.fromRGB(10, 15, 20)
        }
    }
}

function Theme:GetColor(Key)
    return self.Palettes[self.Current][Key] or self.Palettes["Dark"][Key]
end

function Theme:SetTheme(ThemeName)
    if self.Palettes[ThemeName] then
        self.Current = ThemeName
        return true
    end
    return false
end

function Theme:GetAllThemes()
    local Themes = {}
    for Name, _ in pairs(self.Palettes) do
        table.insert(Themes, Name)
    end
    return Themes
end

return Theme
