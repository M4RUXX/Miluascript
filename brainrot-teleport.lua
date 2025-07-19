-- GUI principal y funciones básicas
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- GUI principal
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "MM2_GUI"
screenGui.ResetOnSpawn = false

-- Marco principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- UICorner
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 10)
uicorner.Parent = mainFrame

-- Minimizar botón
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = mainFrame

-- Minimizado icono redondo
local minimizedFrame = Instance.new("Frame", screenGui)
minimizedFrame.Size = UDim2.new(0, 50, 0, 50)
minimizedFrame.Position = UDim2.new(0, 20, 0, 80)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Visible = false
minimizedFrame.Active = true

local uicornerFrame = Instance.new("UICorner")
uicornerFrame.CornerRadius = UDim.new(1, 0)
uicornerFrame.Parent = minimizedFrame

local minimizedBtn = Instance.new("TextButton", minimizedFrame)
minimizedBtn.Size = UDim2.new(1, 0, 1, 0)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
minimizedBtn.TextColor3 = Color3.new(1, 1, 1)
minimizedBtn.Font = Enum.Font.SourceSansBold
minimizedBtn.TextSize = 20
minimizedBtn.Text = "Y"
minimizedBtn.AutoButtonColor = false

local uicornerBtn = Instance.new("UICorner")
uicornerBtn.CornerRadius = UDim.new(1, 0)
uicornerBtn.Parent = minimizedBtn

-- Alternar minimizar
local function toggleMinimize()
    local isVisible = mainFrame.Visible
    mainFrame.Visible = not isVisible
    minimizedFrame.Visible = isVisible
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
minimizedBtn.MouseButton1Click:Connect(toggleMinimize)

-- Obtener el rol del jugador
local function getRole(player)
    local role = player:GetAttribute("Role")
    if role and role ~= "" then return role end
    local roleVal = player:FindFirstChild("Role")
    if roleVal and roleVal:IsA("StringValue") then return roleVal.Value end
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local lsRole = leaderstats:FindFirstChild("Role")
        if lsRole and lsRole:IsA("StringValue") then return lsRole.Value end
    end
    return "Innocent"
end

-- ESP toggle
local espEnabled = false

-- Botón ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 220, 0, 40)
espBtn.Position = UDim2.new(0, 15, 0, 60)
espBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 20
espBtn.Text = "ESP: OFF"
espBtn.Parent = mainFrame

local espUICorner = Instance.new("UICorner")
espUICorner.CornerRadius = UDim.new(0, 8)
espUICorner.Parent = espBtn

-- Lista de objetos creados por ESP
local espObjects = {}

-- Función para crear ESP
local function createESPForPlayer(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    if espObjects[player] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = player.Character:FindFirstChild("Head")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.TextColor3 = Color3.new(0, 1, 0)
    label.Text = player.Name
    label.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 1
    highlight.Parent = player.Character
    highlight.Adornee = player.Character

    espObjects[player] = {billboard = billboard, highlight = highlight, label = label}

    -- Actualizar color dinámicamente
    local function updateVisuals()
        local role = getRole(player)
        local color = role == "Murderer" and Color3.new(1, 0, 0)
            or role == "Sheriff" and Color3.new(0, 0, 1)
            or Color3.new(0, 1, 0)
        label.Text = player.Name .. "\n[" .. role .. "]"
        label.TextColor3 = color
        highlight.FillColor = color
    end

    updateVisuals()

    -- Listeners seguros
    pcall(function()
        player:GetAttributeChangedSignal("Role"):Connect(updateVisuals)
    end)
    local rv = player:FindFirstChild("Role")
    if rv and rv:IsA("StringValue") then
        rv.Changed:Connect(updateVisuals)
    end
    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local rls = ls:FindFirstChild("Role")
        if rls and rls:IsA("StringValue") then
            rls.Changed:Connect(updateVisuals)
        end
    end
end

-- Limpiar ESP
local function clearESP()
    for player, data in pairs(espObjects) do
        if data.billboard then data.billboard:Destroy() end
        if data.highlight then data.highlight:Destroy() end
    end
    espObjects = {}
end

-- Activar/desactivar ESP
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "ESP: ON"
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESPForPlayer(player)
            end
        end
    else
        espBtn.Text = "ESP: OFF"
        espBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        clearESP()
    end
end)

-- Nuevos jugadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            createESPForPlayer(player)
        end
    end)
end)


El script ha sido corregido para:

Mostrar correctamente los roles con colores (rojo = Murderer, azul = Sheriff, verde = inocente).

No fallar si falta información del jugador.

Incluir un icono redondo funcional al minimizar.

Hacer que los botones se actualicen visualmente (verde y texto "ON").


Ya debería ejecutarse correctamente. ¿Quieres que añada más funciones como fly, auto collect, etc.?

