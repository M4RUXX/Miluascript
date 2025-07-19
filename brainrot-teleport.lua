--[[
YAHRM estilo script para MM2
Funciones:
- Auto Knife
- Auto Stab
- Kill Aura
- Speed Hack
- No Clip
- ESP
- Teleport al jugador más cercano
- Auto Get Gun
- Fling jugadores
- Kill All
- Y más
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables de control
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
    anim.AnimationId = "rbxassetid://5051539540" -- Ataque MM2
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
    hrp.Velocity = Vector3.new(0, 100, 0) -- Empuja hacia arriba
    hrp.RotVelocity = Vector3.new(100, 100, 100) -- Giro rápido
end

local function killAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= localPlayer then
            murderPlayer(p)
            wait(0.3)
        end
    end
end

-- Auto knife loop
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

-- Auto stab loop
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

-- ESP
local espLabels = {}

local function createESPForPlayer(player)
    if espLabels[player] or player == localPlayer then return end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end
    local billboard = Instance.new("BillboardGui", player.Character.Head)
    billboard.Name = "ESPLabel"
    billboard.Adornee = player.Character.Head
    billboard.Size = UDim2.new(0,100,0,40)
    billboard.AlwaysOnTop = true
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.new(0,0,0)
    label.TextColor3 = Color3.new(1,1,1)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 16
    label.Text = player.Name

    espLabels[player] = billboard
end

local function removeESPFromPlayer(player)
    if espLabels[player] then
        espLabels[player]:Destroy()
        espLabels[player] = nil
    end
end

local function toggleESP(enable)
    if enable then
        for _, p in pairs(Players:GetPlayers()) do
            createESPForPlayer(p)
        end
        Players.PlayerAdded:Connect(function(p)
            if esp then
                createESPForPlayer(p)
            end
        end)
        Players.PlayerRemoving:Connect(function(p)
            removeESPFromPlayer(p)
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do
            removeESPFromPlayer(p)
        end
    end
end

-- Auto Get Gun (equipa arma automáticamente al ser sheriff)
local function autoGetGunFunc()
    while autoGetGun do
        local gun = localPlayer.Backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")
        if not gun then
            -- Buscar y tomar arma (depende del servidor)
            -- Aquí un ejemplo simple: Teleportar al arma
            local knives = workspace:GetChildren()
            for _, item in pairs(knives) do
                if item.Name == "Knife" and item:IsA("Tool") then
                    item.Handle.CFrame = rootPart.CFrame * CFrame.new(0, 0, 3)
                    break
                end
            end
        end
        wait(3)
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "YAHRMCloneGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 420)
frame.Position = UDim2.new(0, 20, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "YAHRM Clone - MM2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local function createToggleButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

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

local y = 40
local step = 40

local autoKnifeBtn = createToggleButton("Auto Knife: OFF", UDim2.new(0, 10, 0, y), function()
    autoKnife = not autoKnife
    autoKnifeBtn.Text = "Auto Knife: " .. (autoKnife and "ON" or "OFF")
end)
y = y + step

local autoStabBtn = createToggleButton("Auto Stab: OFF", UDim2.new(0, 10, 0, y), function()
    autoStab = not autoStab
    autoStabBtn.Text = "Auto Stab: " .. (autoStab and "ON" or "OFF")
end)
y = y + step

local killAuraBtn = createToggleButton("Kill Aura: OFF", UDim2.new(0, 10, 0, y), function()
    killAura = not killAura
    killAuraBtn.Text = "Kill Aura: " .. (killAura and "ON" or "OFF")
end)
y = y + step

local speedBtn = createToggleButton("Speed Hack: OFF", UDim2.new(0, 10, 0, y), function()
    speedHack = not speedHack
    speedBtn.Text = "Speed Hack: " .. (speedHack and "ON" or "OFF")
end)
y = y + step

local noClipBtn = createToggleButton("No Clip: OFF", UDim2.new(0, 10, 0, y), function()
    noClip = not noClip
    noClipBtn.Text = "No Clip: " .. (noClip and "ON" or "OFF")
end)
y = y + step

local espBtn = createToggleButton("ESP: OFF", UDim2.new(0, 10, 0, y), function()
    esp = not esp
    espBtn.Text = "ESP: " .. (esp and "ON" or "OFF")
    toggleESP(esp)
end)
y = y + step

local autoGetGunBtn = createToggleButton("Auto Get Gun: OFF", UDim2.new(0, 10, 0, y), function()
    autoGetGun = not autoGetGun
    autoGetGunBtn.Text = "Auto Get Gun: " .. (autoGetGun and "ON" or "OFF")
    if autoGetGun then
        spawn(autoGetGunFunc)
    end
end)
y = y + step

createActionButton("Teleport al jugador más cercano", UDim2.new(0, 10, 0, y), function()
    local target = findClosestPlayer(100)
    if target then
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

-- Restaurar velocidad al reaparecer
localPlayer.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = defaultSpeed
end)

print("YAHRM Clone cargado con funciones completas.")
