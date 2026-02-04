local LucideIcons = {
    -- Lucide Icons converted to Roblox Image IDs or SVG data
    -- You can use actual Lucide icons via a CDN or local assets
    
    Icons = {
        -- Navigation
        ["home"] = "rbxassetid://7733960981",
        ["settings"] = "rbxassetid://7733964126",
        ["user"] = "rbxassetid://7733960915",
        ["menu"] = "rbxassetid://7733963885",
        ["x"] = "rbxassetid://7733964808",
        ["check"] = "rbxassetid://7733962673",
        ["chevron-down"] = "rbxassetid://7733962740",
        ["chevron-up"] = "rbxassetid://7733962846",
        ["chevron-left"] = "rbxassetid://7733962785",
        ["chevron-right"] = "rbxassetid://7733962829",
        
        -- Actions
        ["plus"] = "rbxassetid://7733963885",
        ["minus"] = "rbxassetid://7733963778",
        ["edit"] = "rbxassetid://7733962923",
        ["trash"] = "rbxassetid://7733964628",
        ["copy"] = "rbxassetid://7733962888",
        ["refresh"] = "rbxassetid://7733964016",
        ["search"] = "rbxassetid://7733964135",
        ["filter"] = "rbxassetid://7733963150",
        
        -- Media
        ["play"] = "rbxassetid://7733963902",
        ["pause"] = "rbxassetid://7733963832",
        ["volume"] = "rbxassetid://7733965100",
        ["image"] = "rbxassetid://7733963418",
        ["folder"] = "rbxassetid://7733963179",
        
        -- Status
        ["alert-circle"] = "rbxassetid://7733962519",
        ["alert-triangle"] = "rbxassetid://7733962558",
        ["info"] = "rbxassetid://7733963446",
        ["help-circle"] = "rbxassetid://7733963302",
        ["bell"] = "rbxassetid://7733962659",
        ["moon"] = "rbxassetid://7733963756",
        ["sun"] = "rbxassetid://7733964620",
        ["star"] = "rbxassetid://7733964536",
        ["heart"] = "rbxassetid://7733963356",
        
        -- Objects
        ["layout"] = "rbxassetid://7733963604",
        ["grid"] = "rbxassetid://7733963236",
        ["list"] = "rbxassetid://7733963724",
        ["sliders"] = "rbxassetid://7733964232",
        ["toggle-left"] = "rbxassetid://7733964691",
        ["toggle-right"] = "rbxassetid://7733964725",
        ["eye"] = "rbxassetid://7733963032",
        ["eye-off"] = "rbxassetid://rbxassetid://7733963071",
        ["lock"] = "rbxassetid://7733963736",
        ["unlock"] = "rbxassetid://7733964979",
        
        -- Arrows
        ["arrow-up"] = "rbxassetid://7733962494",
        ["arrow-down"] = "rbxassetid://7733962393",
        ["arrow-left"] = "rbxassetid://7733962422",
        ["arrow-right"] = "rbxassetid://rbxassetid://7733962460",
        ["maximize"] = "rbxassetid://7733963652",
        ["minimize"] = "rbxassetid://7733963750",
        
        -- Default fallback
        ["default"] = "rbxassetid://7733960981"
    }
}

function LucideIcons:Get(IconName)
    return self.Icons[IconName] or self.Icons["default"]
end

function LucideIcons:CreateIcon(IconName, Parent, Size, Color)
    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "Icon"
    IconImage.BackgroundTransparency = 1
    IconImage.Size = Size or UDim2.new(0, 16, 0, 16)
    IconImage.Image = self:Get(IconName)
    IconImage.ImageColor3 = Color or Color3.new(1, 1, 1)
    IconImage.ScaleType = Enum.ScaleType.Fit
    IconImage.Parent = Parent
    return IconImage
end

return LucideIcons
