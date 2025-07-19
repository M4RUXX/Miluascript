-- YAHRM Clone avanzado para MM2 con GUI, ESP + Highlights de roles y detección dinámica

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables control
local autoKnife = false
local autoStab = false
local killAura = false
local speedHack = false
local noClip = false
local esp = false
local autoGetGun = false

local defaultSpeed = 16
local hackSpeed = 30

-- Utilidades

local function findClosestPlayer(maxDist)
    local closest, dist = nil, maxDist or math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local d = (p.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            if d < dist then
                closest, dist = p, d
            end
        end
    end
    return closest, dist
end

local function playAttackAnimation()
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://5051539540"
    local track = animator:LoadAnimation(anim)
    track:Play()
    wait(1)
    track:Stop()
end

local function murderPlayer(target)
    local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("MurderEvent")
    if remote and target then
        remote:FireServer(target)
    end
end

local function flingPlayer(target)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = target.Character.HumanoidRootPart
    hrp.Velocity = Vector3.new(0, 100, 0)
    hrp.RotVelocity = Vector3.new(100, 100, 100)
end

local function killAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            murderPlayer(p)
            wait(0.3)
        end
    end
end

-- Auto Knife loop
spawn(function()
    while true do
        if autoKnife then
            local target = findClosestPlayer(10)
            if target then
                playAttackAnimation()
                murderPlayer(target)
            end
        end
        wait(0.5)
    end
end)

-- Auto Stab loop
spawn(function()
    while true do
        if autoStab then
            playAttackAnimation()
        end
        wait(0.4)
    end
end)

-- Kill Aura loop
spawn(function()
    while true do
        if killAura then
            local target = findClosestPlayer(10)
            if target then
                playAttackAnimation()
                murderPlayer(target)
            end
        end
        wait(0.3)
    end
end)

-- Speed hack loop
spawn(function()
    while true do
        if speedHack then
            humanoid.WalkSpeed = hackSpeed
        else
            humanoid.WalkSpeed = defaultSpeed
        end
        wait(0.5)
    end
end)

-- No Clip loop
spawn(function()
    while true do
        if noClip then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        wait(0.1)
    end
end)

-- Auto Get Gun (intenta coger el cuchillo)
local function autoGetGunFunc()
    while autoGetGun do
        local gun = localPlayer.Backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")
        if not gun then
            for _, item in pairs(workspace:GetChildren()) do
                if item.Name == "Knife" and item:IsA("Tool") then
                    item.Handle.CFrame = rootPart.CFrame * CFrame.new(0, 0, 3)
                    break
                end
            end
        end
        wait(3)
    end
end

-- ESP con etiquetas y highlights

local espLabels = {}
local highlights = {}

-- Mejor función para obtener rol del jugador
local function getRole(player)
    local role = player:GetAttribute("Role")
    if role and role ~= "" then
        return role
    end

    local roleValue = player:FindFirstChild("Role")
    if roleValue and roleValue:IsA("StringValue") then
        return roleValue.Value
    end

    if player:FindFirstChild("leaderstats") then
        local lsRole = player.leaderstats:FindFirstChild("Role")
        if lsRole and lsRole:IsA("StringValue") then
            return lsRole.Value
        end
    end

    return "Innocent"
end

-- Actualiza texto y color segun rol
local function setupRoleListener(player, label, highlight)
    local function updateVisuals()
        local role = getRole(player)
        local color
        if role == "Murderer" or role == "Assassin" then
            color = Color3.new(1, 0, 0)
        elseif role == "Sheriff" then
            color = Color3.new(0, 0, 1)
        else
            color = Color3.new(0, 1, 0)
        end
        if label then
            label.Text = player.Name .. "\n[" .. role .. "]"
            label.TextColor3 = color
        end
        if highlight then
            highlight.FillColor = color
        end
    end

    updateVisuals()

    player:GetAttributeChangedSignal("Role"):Connect(updateVisuals)

    local roleVal = player:FindFirstChild("Role")
    if roleVal and roleVal:IsA("StringValue") then
        roleVal.Changed:Connect(updateVisuals)
    end

    if player:FindFirstChild("leaderstats") then
        local lsRole = player.leaderstats:FindFirstChild("Role")
        if lsRole and lsRole:IsA("StringValue") then
            lsRole.Changed:Connect(updateVisuals)
        end
    end
end

local function createESPForPlayer(player)
    if espLabels[player] or player == localPlayer then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPLabel"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,150,0,50)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 1.5, 0)
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.new(0,0,0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18
    label.Parent = billboard

    -- Configurar actualización dinámica de rol y color
    setupRoleListener(player, label, nil)

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not player.Parent then
            conn:Disconnect()
            if billboard and billboard.Parent then
                billboard:Destroy()
            end
            espLabels[player] = nil
        else
            -- Solo actualiza visibilidad según salud
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                label.Visible = true
            else
                label.Visible = false
            end
        end
    end)

    espLabels[player] = billboard
end

local function removeESPFromPlayer(player)
    if espLabels[player] then
        if espLabels[player].Parent then
            espLabels[player]:Destroy()
        end
        espLabels[player] = nil
    end
end

local function applyHighlight(player)
    if highlights[player] then return end
    if not player.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "RoleHighlight"
    highlight.Parent = player.Character
    highlight.OutlineColor = Color3.new(0,0,0)
    highlight.Enabled = true

    highlights[player] = highlight

    setupRoleListener(player, nil, highlight)
end

local function removeHighlight(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function updateHighlights(enable)
    if enable then
        for _, p in pairs(Players:GetPlayers()) do
            applyHighlight(p)
        end
        Players.PlayerAdded:Connect(function(p)
            if esp then
                applyHighlight(p)
            end
        end)
        Players.PlayerRemoving:Connect(function(p)
            removeHighlight(p)
        end)
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                if esp then
                    applyHighlight(p)
                end
            end)
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do
            removeHighlight(p)
        end
    end
end

function toggleESP(enable)
    if enable then
        for _, p in pairs(Players:GetPlayers()) do
            createESPForPlayer(p)
        end
        updateHighlights(true)
        Players.PlayerAdded:Connect(function(p)
            if esp then
                createESPForPlayer(p)
                applyHighlight(p)
            end
        end)
        Players.PlayerRemoving:Connect(function(p)
            removeESPFromPlayer(p)
            removeHighlight(p)
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do
            removeESPFromPlayer(p)
        end
        updateHighlights(false)
    end
end

-- GUI y colores ON/OFF

local COLOR_ON = Color3.fromRGB(0, 170, 0)
local COLOR_OFF = Color3.fromRGB(170, 0, 0)

local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "YAHRMCloneGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 420)
frame.Position = UDim2.new(0, 20, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "YAHRM Clone - MM2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 24
minimizeBtn.Text = "–"

-- Botón minimizado (icono redondo)
local minimizedFrame = Instance.new("Frame", screenGui)
minimizedFrame.Size = UDim2.new(0, 50, 0, 50)  -- tamaño cuadrado para círculo
minimizedFrame.Position = UDim2.new(0, 20, 0, 80)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Visible = false
minimizedFrame.Active = true

local uicornerFrame = Instance.new("UICorner")
uicornerFrame.CornerRadius = UDim.new(1, 0)  -- redondear completamente para círculo
uicornerFrame.Parent = minimizedFrame

local minimizedBtn = Instance.new("TextButton", minimizedFrame)
minimizedBtn.Size = UDim2.new(1, 0, 1, 0)  -- llena todo el frame circular
minimizedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
minimizedBtn.TextColor3 = Color3.new(1, 1, 1)
minimizedBtn.Font = Enum.Font.SourceSansBold
minimizedBtn.TextSize = 20
minimizedBtn.Text = "Y"
minimizedBtn.AutoButtonColor = false
minimizedBtn.TextStrokeTransparency = 0

local uicornerBtn = Instance.new("UICorner")
uicornerBtn.CornerRadius = UDim.new(1, 0)  -- también circular para el botón
uicornerBtn.Parent = minimizedBtn

local function toggleMinimize()
    if frame.Visible then
        frame.Visible = false
        minimizedFrame.Visible = true
    else
        frame.Visible = true
        minimizedFrame.Visible = false
    end
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
minimizedBtn.MouseButton1Click:Connect(toggleMinimize)

local function createToggleButton(text, pos, getState, setState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = pos
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = frame

    local function updateBtn()
        if getState() then
            btn.BackgroundColor3 = COLOR_ON
            btn.Text = text .. ": ON"
        else
            btn.BackgroundColor3 = COLOR_OFF
            btn.Text = text .. ": OFF"
        end
    end

    btn.MouseButton1Click:Connect(function()
        setState(not getState())
        updateBtn()
    end)

    updateBtn()
    return btn
end

local y = 40
local step = 40

local autoKnifeBtn = createToggleButton("Auto Knife", UDim2.new(0, 10, 0, y),
    function() return autoKnife end,
    function(val) autoKnife = val end)
y = y + step

local autoStabBtn = createToggleButton("Auto Stab", UDim2.new(0, 10, 0, y),
    function() return autoStab end,
    function(val) autoStab = val end)
y = y + step

local killAuraBtn = createToggleButton("Kill Aura", UDim2.new(0, 10, 0, y),
    function() return killAura end,
    function(val) killAura = val end)
y = y + step

local speedBtn = createToggleButton("Speed Hack", UDim2.new(0, 10, 0, y),
    function() return speedHack end,
    function(val) speedHack = val end)
y = y + step

local noClipBtn = createToggleButton("No Clip", UDim2.new(0, 10, 0, y),
    function() return noClip end,
    function(val) noClip = val end)
y = y + step

local espBtn = createToggleButton("ESP", UDim2.new(0, 10, 0, y),
    function() return esp end,
    function(val)
        esp = val
        toggleESP(esp)
    end)
y = y + step

local autoGetGunBtn = createToggleButton("Auto Get Gun", UDim2.new(0, 10, 0, y),
    function() return autoGetGun end,
    function(val)
        autoGetGun = val
        if autoGetGun then
            spawn(autoGetGunFunc)
        end
    end)
y = y + step

local function createActionButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Text = text
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

createActionButton("Teleport al jugador más cercano", UDim2.new(0, 10, 0, y), function()
    local target = findClosestPlayer(100)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        rootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
    end
end)
y = y + step

createActionButton("Fling jugador más cercano", UDim2.new(0, 10, 0, y), function()
    local target = findClosestPlayer(30)
    if target then
        flingPlayer(target)
    end
end)
y = y + step

createActionButton("Kill All", UDim2.new(0, 10, 0, y), function()
    killAll()
end)

-- Código para mover la ventana

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos
