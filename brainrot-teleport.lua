-- Variables principales
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Esperar a que el personaje cargue
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MurderGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0.5, -75, 0.9, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 1, -10)
button.Position = UDim2.new(0, 5, 0, 5)
button.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "Asesinar"
button.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -10, 0, 20)
statusLabel.Position = UDim2.new(0, 5, 0, -25)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.Text = ""
statusLabel.Parent = frame

-- Función para reproducir animación
local function playAttackAnimation()
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        statusLabel.Text = "No se encontró Animator"
        return
    end
    
    local attackAnim = Instance.new("Animation")
    attackAnim.AnimationId = "rbxassetid://5051539540" -- animación de ataque MM2
    local track = animator:LoadAnimation(attackAnim)
    track:Play()
    
    -- Esperar duración animación (aprox 1 seg)
    wait(1)
    track:Stop()
end

-- Función para matar jugador cercano
local function murderClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        statusLabel.Text = "No se encontró HumanoidRootPart"
        return
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).magnitude
            if distance < 10 and distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end
    
    if closestPlayer then
        statusLabel.Text = "Atacando a " .. closestPlayer.Name
        playAttackAnimation()
        
        -- Intentar disparar evento remoto (depende del juego)
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("MurderEvent")
        if remote then
            remote:FireServer(closestPlayer)
            statusLabel.Text = "Asesinato enviado a " .. closestPlayer.Name
        else
            statusLabel.Text = "Remote MurderEvent no encontrado"
        end
    else
        statusLabel.Text = "No hay jugadores cerca"
    end
end

-- Evento para botón
button.MouseButton1Click:Connect(function()
    murderClosestPlayer()
end)
