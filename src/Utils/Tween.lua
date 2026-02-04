local TweenService = game:GetService("TweenService")

local Tween = {
    ActiveTweens = {}
}

function Tween:Create(Object, Properties, Duration, EasingStyle, EasingDirection, Delay)
    local TweenInfo = TweenInfo.new(
        Duration or 0.3,
        EasingStyle or Enum.EasingStyle.Quart,
        EasingDirection or Enum.EasingDirection.Out,
        0,
        false,
        Delay or 0
    )
    
    local TweenObj = TweenService:Create(Object, TweenInfo, Properties)
    TweenObj:Play()
    return TweenObj
end

function Tween:FadeIn(Object, Duration)
    Object.BackgroundTransparency = 1
    return self:Create(Object, {BackgroundTransparency = 0}, Duration or 0.3)
end

function Tween:FadeOut(Object, Duration, Callback)
    local TweenObj = self:Create(Object, {BackgroundTransparency = 1}, Duration or 0.3)
    if Callback then
        TweenObj.Completed:Connect(Callback)
    end
    return TweenObj
end

function Tween:Scale(Object, Scale, Duration)
    return self:Create(Object, {Size = Scale}, Duration or 0.3, Enum.EasingStyle.Back)
end

function Tween:Slide(Object, Position, Duration)
    return self:Create(Object, {Position = Position}, Duration or 0.3)
end

function Tween:Rotate(Object, Rotation, Duration)
    return self:Create(Object, {Rotation = Rotation}, Duration or 0.3)
end

function Tween:Color(Object, Color, Duration)
    if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
        return self:Create(Object, {ImageColor3 = Color}, Duration or 0.3)
    else
        return self:Create(Object, {BackgroundColor3 = Color}, Duration or 0.3)
    end
end

function Tween:Spring(Object, Target, Speed, Damping)
    -- Custom spring physics simulation
    Speed = Speed or 50
    Damping = Damping or 0.8
    
    local Connection
    local Velocity = 0
    local Current = Object.Position.X.Offset
    
    Connection = game:GetService("RunService").Heartbeat:Connect(function(Delta)
        local Distance = Target - Current
        local SpringForce = Distance * Speed * Delta
        local DampingForce = Velocity * Damping
        
        Velocity = Velocity + SpringForce - DampingForce
        Current = Current + Velocity * Delta
        
        Object.Position = UDim2.new(Object.Position.X.Scale, Current, Object.Position.Y.Scale, Object.Position.Y.Offset)
        
        if math.abs(Distance) < 0.5 and math.abs(Velocity) < 0.5 then
            Object.Position = UDim2.new(Object.Position.X.Scale, Target, Object.Position.Y.Scale, Object.Position.Y.Offset)
            Connection:Disconnect()
        end
    end)
    
    return Connection
end

return Tween
