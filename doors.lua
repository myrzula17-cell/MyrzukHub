local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local speedMult = 1
local baseSpeed = 16
local autoCollect = false
local espOn = false
local menuOpen = true

local BG        = Color3.fromRGB(14, 14, 18)
local SIDEBAR   = Color3.fromRGB(20, 20, 26)
local PANEL     = Color3.fromRGB(26, 26, 34)
local ITEM      = Color3.fromRGB(34, 34, 44)
local ACCENT    = Color3.fromRGB(140, 80, 255)
local ACCENT2   = Color3.fromRGB(180, 120, 255)
local TEXT      = Color3.fromRGB(235, 235, 245)
local TEXT_DIM  = Color3.fromRGB(150, 150, 165)

-- ===== GUI =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyrzukHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 620, 0, 400)
Frame.Position = UDim2.new(0.5, -310, 0.5, -200)
Frame.BackgroundColor3 = BG
Frame.BorderSizePixel = 0
Frame.Active = false          -- НЕ перетаскивать
Frame.Draggable = false       -- НЕ перетаскивать
Frame.Visible = true
Frame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = Frame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = ACCENT
FrameStroke.Thickness = 1
FrameStroke.Transparency = 0.5
FrameStroke.Parent = Frame

-- ===== Заголовок =====
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame
local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 8)
TitleBarCorner.Parent = TitleBar

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 200, 1, 0)
Logo.Position = UDim2.new(0, 16, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "MYRZUK HUB"
Logo.TextColor3 = ACCENT2
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 16
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TitleBar

local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(0, 200, 1, 0)
Hint.Position = UDim2.new(1, -216, 0, 0)
Hint.BackgroundTransparency = 1
Hint.Text = "RSHIFT — toggle"
Hint.TextColor3 = TEXT_DIM
Hint.Font = Enum.Font.Gotham
Hint.TextSize = 12
Hint.TextXAlignment = Enum.TextXAlignment.Right
Hint.Parent = TitleBar

-- ===== Сайдбар =====
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -48)
Sidebar.Position = UDim2.new(0, 4, 0, 44)
Sidebar.BackgroundColor3 = SIDEBAR
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame
local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 6)
SidebarCorner.Parent = Sidebar

local function makeTabBtn(text, icon, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 34)
    btn.Position = UDim2.new(0, 4, 0, yPos)
    btn.BackgroundColor3 = SIDEBAR
    btn.Text = "  " .. icon .. "   " .. text
    btn.TextColor3 = TEXT_DIM
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = Sidebar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn
    return btn
end

local btnInfo   = makeTabBtn("INFO",       "i",  10)
local btnGlobal = makeTabBtn("GLOBAL",     "*",  50)
local btnAuto   = makeTabBtn("AUTOMATION", "#",  90)

-- ===== Правая панель =====
local RightPane = Instance.new("Frame")
RightPane.Size = UDim2.new(1, -162, 1, -48)
RightPane.Position = UDim2.new(0, 158, 0, 44)
RightPane.BackgroundTransparency = 1
RightPane.Parent = Frame

local function makePage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = RightPane
    return p
end

local PageInfo   = makePage()
local PageGlobal = makePage()
local PageAuto   = makePage()

-- ===== Секция =====
local function makeSection(parent, title, yPos)
    local sec = Instance.new("Frame")
    sec.Size = UDim2.new(0.48, 0, 0, 30)
    sec.Position = UDim2.new(0, 0, 0, yPos)
    sec.BackgroundColor3 = PANEL
    sec.BorderSizePixel = 0
    sec.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = sec

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "▼  " .. title
    lbl.TextColor3 = TEXT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = sec
    return yPos + 36
end

-- ===== Тумблер =====
local function makeToggle(parent, text, yPos, col, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.48, 0, 0, 28)
    row.Position = UDim2.new(col, 0, 0, yPos)
    row.BackgroundColor3 = ITEM
    row.BorderSizePixel = 0
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 5)
    rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = TEXT
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 34, 0, 16)
    track.Position = UDim2.new(1, -42, 0.5, -8)
    track.BackgroundColor3 = default and ACCENT or Color3.fromRGB(60, 60, 70)
    track.BorderSizePixel = 0
    track.Parent = row
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = knob

    local state = default
    local function toggle()
        state = not state
        track.BackgroundColor3 = state and ACCENT or Color3.fromRGB(60, 60, 70)
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }):Play()
        if callback then callback(state) end
    end

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggle()
        end
    end)
    return {set = function(v) if v ~= state then toggle() end end, get = function() return state end}
end

-- ===== Слайдер =====
local function makeSlider(parent, text, yPos, col, minV, maxV, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(0.48, 0, 0, 42)
    row.Position = UDim2.new(col, 0, 0, yPos)
    row.BackgroundColor3 = ITEM
    row.BorderSizePixel = 0
    row.Parent = parent
    local rc = Instance.new("UICorner")
    rc.CornerRadius = UDim.new(0, 5)
    rc.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 18)
    lbl.Position = UDim2.new(0, 8, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = TEXT
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -16, 0, 8)
    bar.Position = UDim2.new(0, 8, 0, 24)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
    bar.BorderSizePixel = 0
    bar.Parent = row
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 4)
    bc.Parent = bar

    local fill = Instance.new("Frame")
    local initRel = (default - minV) / (maxV - minV)
    fill.Size = UDim2.new(initRel, 0, 1, 0)
    fill.BackgroundColor3 = ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = bar
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 4)
    fc.Parent = fill

    local drag = false
    local function update(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        local val = minV + rel * (maxV - minV)
        lbl.Text = text .. ": " .. string.format("%.0f", val)
        if callback then callback(val) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            update(input.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

-- ===== INFO =====
local av = Instance.new("ImageLabel")
av.Size = UDim2.new(0, 80, 0, 80)
av.Position = UDim2.new(0, 8, 0, 8)
av.BackgroundColor3 = ITEM
av.BorderSizePixel = 0
av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
av.Parent = PageInfo
local avc = Instance.new("UICorner")
avc.CornerRadius = UDim.new(1, 0)
avc.Parent = av

local nick = Instance.new("TextLabel")
nick.Size = UDim2.new(0, 220, 0, 22)
nick.Position = UDim2.new(0, 100, 0, 12)
nick.BackgroundTransparency = 1
nick.Text = player.Name
nick.TextColor3 = TEXT
nick.Font = Enum.Font.GothamBold
nick.TextSize = 16
nick.TextXAlignment = Enum.TextXAlignment.Left
nick.Parent = PageInfo

local disp = Instance.new("TextLabel")
disp.Size = UDim2.new(0, 220, 0, 18)
disp.Position = UDim2.new(0, 100, 0, 36)
disp.BackgroundTransparency = 1
disp.Text = "@" .. player.DisplayName
disp.TextColor3 = TEXT_DIM
disp.Font = Enum.Font.Gotham
disp.TextSize = 12
disp.TextXAlignment = Enum.TextXAlignment.Left
disp.Parent = PageInfo

local idl = Instance.new("TextLabel")
idl.Size = UDim2.new(0, 220, 0, 18)
idl.Position = UDim2.new(0, 100, 0, 56)
idl.BackgroundTransparency = 1
idl.Text = "ID: " .. player.UserId
idl.TextColor3 = TEXT_DIM
idl.Font = Enum.Font.Gotham
idl.TextSize = 12
idl.TextXAlignment = Enum.TextXAlignment.Left
idl.Parent = PageInfo

local statusBox = Instance.new("Frame")
statusBox.Size = UDim2.new(1, -16, 0, 60)
statusBox.Position = UDim2.new(0, 8, 0, 100)
statusBox.BackgroundColor3 = PANEL
statusBox.BorderSizePixel = 0
statusBox.Parent = PageInfo
local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 6)
sbc.Parent = statusBox

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -16, 1, 0)
statusLbl.Position = UDim2.new(0, 8, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Executor: Solara\nStatus: Injected  ✓\nBuild: MyrzukHub v1.1"
statusLbl.TextColor3 = ACCENT2
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 13
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.TextYAlignment = Enum.TextYAlignment.Center
statusLbl.Parent = statusBox

-- ===== GLOBAL =====
local yG = 8
yG = makeSection(PageGlobal, "CHARACTER", yG)
makeSlider(PageGlobal, "Speed Boost", yG, 0, 16, 200, 40, function(v)
    speedMult = v / baseSpeed
end)
yG = yG + 48

makeToggle(PageGlobal, "Enable Speed Boost", yG, 0, true, function(s)
    if not s then speedMult = 1 end
end)
makeToggle(PageGlobal, "Infinite Jump", yG, 0.52, false, function(s)
    _G.infjump = s
end)
yG = yG + 34

yG = makeSection(PageGlobal, "MOVEMENT", yG)
makeToggle(PageGlobal, "Noclip", yG, 0, false, function(s)
    _G.noclip = s
end)
makeToggle(PageGlobal, "Remove Closet Delay", yG, 0.52, false, nil)
yG = yG + 34
makeToggle(PageGlobal, "Remove Acceleration", yG, 0, false, nil)
makeToggle(PageGlobal, "Instant Prompts", yG, 0.52, false, nil)

-- ===== AUTOMATION =====
local yA = 8
yA = makeSection(PageAuto, "AUTOMATION", yA)
makeToggle(PageAuto, "Auto Breaker Box", yA, 0, false, nil)
makeToggle(PageAuto, "Auto Solve Anchors", yA, 0.52, false, nil)
yA = yA + 34
makeToggle(PageAuto, "Auto Unlock Padlock", yA, 0, false, nil)
makeToggle(PageAuto, "Guess Library Code", yA, 0.52, false, nil)
yA = yA + 34

yA = makeSection(PageAuto, "ITEMS", yA)
makeToggle(PageAuto, "Auto Collect Items", yA, 0, false, function(s)
    autoCollect = s
end)
makeToggle(PageAuto, "ESP Items", yA, 0.52, false, function(s)
    espOn = s
    if not s then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Myrzuk_ESP" then obj:Destroy() end
        end
    end
end)
yA = yA + 34
makeToggle(PageAuto, "Auto Closet", yA, 0, false, nil)
makeToggle(PageAuto, "Spectate Entity", yA, 0.52, false, nil)

-- Кнопка телепорта
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.48, 0, 0, 30)
tpBtn.Position = UDim2.new(0, 0, 0, yA + 40)
tpBtn.BackgroundColor3 = ACCENT
tpBtn.Text = "Teleport to Nearest Item"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 12
tpBtn.BorderSizePixel = 0
tpBtn.Parent = PageAuto
local tpc = Instance.new("UICorner")
tpc.CornerRadius = UDim.new(0, 5)
tpc.Parent = tpBtn
tpBtn.MouseButton1Click:Connect(function()
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

local tabs = {
    {btn = btnInfo, page = PageInfo},
    {btn = btnGlobal, page = PageGlobal},
    {btn = btnAuto, page = PageAuto},
}

local function showTab(tabBtn, page)
    for _, t in pairs(tabs) do
        t.btn.BackgroundColor3 = SIDEBAR
        t.btn.TextColor3 = TEXT_DIM
        t.page.Visible = false
    end
    tabBtn.BackgroundColor3 = PANEL
    tabBtn.TextColor3 = ACCENT2
    page.Visible = true
end

btnInfo.MouseButton1Click:Connect(function() showTab(btnInfo, PageInfo) end)
btnGlobal.MouseButton1Click:Connect(function() showTab(btnGlobal, PageGlobal) end)
btnAuto.MouseButton1Click:Connect(function() showTab(btnAuto, PageAuto) end)

showTab(btnGlobal, PageGlobal)

local function updateCursor()
    if menuOpen then
        UIS.MouseIconEnabled = true
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    else
        UIS.MouseIconEnabled = false
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuOpen = not menuOpen
        Frame.Visible = menuOpen
        updateCursor()
    end
end)

updateCursor()

RunService.RenderStepped:Connect(function()
    if menuOpen then
        UIS.MouseIconEnabled = true
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = baseSpeed * speedMult end

    if _G.infjump then
        if hum and hum:GetState() == Enum.HumanoidStateType.Freefall then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    if _G.noclip and char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end

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
                if not obj:FindFirstChild("Myrzuk_ESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "Myrzuk_ESP"
                    hl.FillColor = ACCENT
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = obj
                end
            end
        end
    end
end)

print("[MyrzukHub] v1.1 loaded. RSHIFT toggles menu. Cursor visible when open.")
