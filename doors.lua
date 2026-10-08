-- XFIX DOORS Script v2.0 | User: dimkaels
-- Меню по центру, скрыто, открывается на Right Shift

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Настройки
local speedMult = 1
local baseSpeed = 16
local autoCollect = false
local espOn = false
local menuOpen = false

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XFIX_Doors"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Основной фрейм (по центру)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 380)
Frame.Position = UDim2.new(0.5, -150, 0.5, -190)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(200, 30, 30)
UIStroke.Thickness = 1.5
UIStroke.Parent = Frame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
Title.Text = "XFIX | DOORS PANEL  [RSHIFT]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.BorderSizePixel = 0
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- ===== Кнопки =====
local function makeButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = Frame
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- Ползунок скорости
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 22)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 52)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed Multiplier: 1.0x"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 13
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Frame

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.9, 0, 0, 12)
sliderBg.Position = UDim2.new(0.05, 0, 0, 78)
sliderBg.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = Frame
local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 6)
sbc.Parent = sliderBg

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg
local sfc = Instance.new("UICorner")
sfc.CornerRadius = UDim.new(0, 6)
sfc.Parent = sliderFill

local dragging = false

local function updateSlider(x)
    local rel = math.clamp((x - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
    sliderFill.Size = UDim2.new(rel, 0, 1, 0)
    speedMult = 1 + rel * 9
    SpeedLabel.Text = string.format("Speed Multiplier: %.1fx", speedMult)
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = baseSpeed * speedMult end
    end
end

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateSlider(input.Position.X)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input.Position.X)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Кнопки
makeButton("Auto-Collect Items: OFF", 105, function(self)
    autoCollect = not autoCollect
    self.Text = "Auto-Collect Items: " .. (autoCollect and "ON" or "OFF")
    self.BackgroundColor3 = autoCollect and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(38, 38, 48)
end)

makeButton("ESP Items: OFF", 145, function(self)
    espOn = not espOn
    self.Text = "ESP Items: " .. (espOn and "ON" or "OFF")
    self.BackgroundColor3 = espOn and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(38, 38, 48)
    if not espOn then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "XFIX_ESP" then obj:Destroy() end
        end
    end
end)

makeButton("Teleport to Nearest Item", 185, function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local closest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("key") or obj.Name:lower():find("coin") or obj.Name:lower():find("lamp") or obj.Name:lower():find("item") or obj.Name:lower():find("gold")) then
            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
            if root then
                local d = (root.Position - char.HumanoidRootPart.Position).Magnitude
                if d < dist then dist = d; closest = root end
            end
        end
    end
    if closest then char.HumanoidRootPart.CFrame = closest.CFrame + Vector3.new(0, 3, 0) end
end)

makeButton("Speed Reset (16)", 225, function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = 16 end
        speedMult = 1
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        SpeedLabel.Text = "Speed Multiplier: 1.0x"
    end
end)

makeButton("Toggle Menu (RSHIFT)", 265, function()
    menuOpen = not menuOpen
    Frame.Visible = menuOpen
end)

makeButton("Destroy GUI", 305, function()
    ScreenGui:Destroy()
end)

-- ===== Открытие / закрытие на Right Shift =====
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuOpen = not menuOpen
        Frame.Visible = menuOpen
    end
end)

-- ===== Основной цикл =====
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = baseSpeed * speedMult end

    if autoCollect and char:FindFirstChild("HumanoidRootPart") then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("key") or obj.Name:lower():find("coin") or obj.Name:lower():find("lamp") or obj.Name:lower():find("item") or obj.Name:lower():find("gold")) then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                if root then
                    local dist = (root.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist < 120 then
                        char.HumanoidRootPart.CFrame = root.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                local parent = obj.Parent
                if parent and parent:IsA("BasePart") then
                    local dist = (parent.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist < 8 then
                        pcall(function() fireproximityprompt(obj) end)
                    end
                end
            end
        end
    end

    if espOn then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and (obj.Name:lower():find("key") or obj.Name:lower():find("coin") or obj.Name:lower():find("lamp") or obj.Name:lower():find("item") or obj.Name:lower():find("gold")) then
                if not obj:FindFirstChild("XFIX_ESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "XFIX_ESP"
                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = obj
                end
            end
        end
    end
end)

print("[XFIX] DOORS v2.0 loaded. Press RSHIFT to toggle menu.")
