local HttpService = game:GetService("HttpService")

local SaveManager = {
    Data = {},
    AutoSaveEnabled = true,
    SaveKey = "ModernUI_Save",
    SaveInterval = 30
}

-- Get correct path based on executor
function SaveManager:GetSavePath()
    local success, result = pcall(function()
        -- Try different paths for different executors
        if isfolder and makefolder then
            if not isfolder("ModernUI") then
                makefolder("ModernUI")
            end
            return "ModernUI/config.json"
        elseif writefile then
            return "ModernUI_Config.json"
        end
        return nil
    end)
    return success and result or nil
end

function SaveManager:Load()
    local Path = self:GetSavePath()
    if not Path then return {} end
    
    local success, Data = pcall(function()
        if readfile then
            local Content = readfile(Path)
            return HttpService:JSONDecode(Content)
        end
        return {}
    end)
    
    if success and Data then
        self.Data = Data
        return Data
    end
    return {}
end

function SaveManager:Save()
    local Path = self:GetSavePath()
    if not Path then return false end
    
    local success = pcall(function()
        if writefile then
            writefile(Path, HttpService:JSONEncode(self.Data))
        end
    end)
    
    return success
end

function SaveManager:SetValue(Key, Value)
    self.Data[Key] = Value
    if self.AutoSaveEnabled then
        self:Save()
    end
end

function SaveManager:GetValue(Key, Default)
    return self.Data[Key] ~= nil and self.Data[Key] or Default
end

function SaveManager:DeleteValue(Key)
    self.Data[Key] = nil
    if self.AutoSaveEnabled then
        self:Save()
    end
end

function SaveManager:Clear()
    self.Data = {}
    if self.AutoSaveEnabled then
        self:Save()
    end
end

-- Auto-save loop
task.spawn(function()
    while SaveManager.AutoSaveEnabled do
        task.wait(SaveManager.SaveInterval)
        SaveManager:Save()
    end
end)

return SaveManager
