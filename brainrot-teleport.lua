-- Variables básicas y funciones (igual que antes, omitidas para brevedad)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local autoKnife = false
local autoStab = false
local killAura = false
local speedHack = false
local noClip = false
local esp = false
local autoGetGun = false

local defaultSpeed = 16
local hackSpeed = 30

-- Colores
local COLOR_ON = Color3.fromRGB(0, 170, 0)    -- Verde
local COLOR_OFF = Color3.fromRGB(170, 0, 0)   -- Rojo

-- GUI
local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "YAHRMCloneGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 420)
frame.Position = UDim2.new(0, 20, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true  -- Para poder recibir input de mouse
frame.Draggable = false -- deprecated pero lo dejamos false porque haremos drag manual

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "YAHRM Clone - MM2"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

-- Botón minimizar (icono)
local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 24
minimizeBtn.Text = "–"  -- símbolo menos para minimizar

-- Frame pequeño para cuando está minimizado
local minimizedFrame = Instance.new("Frame", screenGui)
minimizedFrame.Size = UDim2.new(0, 60, 0, 30)
minimizedFrame.Position = UDim2.new(0, 20, 0, 80)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Visible = false

local minimizedBtn = Instance.new("TextButton", minimizedFrame)
minimizedBtn.Size = UDim2.new(1, 0, 1, 0)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
minimizedBtn.TextColor3 = Color3.new(1,1,1)
minimizedBtn.Font = Enum.Font.SourceSansBold
minimizedBtn.TextSize = 20
minimizedBtn.Text = "YAHRM"
minimizedBtn.AutoButtonColor = false

-- Toggle función para mostrar/ocultar ventana
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

-- Función para crear botón toggle con cambio de color y texto
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
        if esp then
            -- activar ESP
            toggleESP(true)
        else
            toggleESP(false)
        end
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

-- Código para hacer el frame movible con mouse/touch
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
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- (Las demás funciones y loops como en el script anterior se mantienen, omito para no repetir)

print("Script actualizado con GUI movible, botones ON/verde y minimizable.")
