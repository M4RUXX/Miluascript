local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

local teleportPoint = nil
local teleportEnabled = false

-- Función para detectar Brainrot
local function hasBrainrot()
    for _, item in ipairs(lp.Backpack:GetChildren()) do
        if item.Name:lower():find("brainrot") then
            return true
        end
    end
    if lp.Character then
        for _, item in ipairs(lp.Character:GetChildren()) do
            if item.Name:lower():find("brainrot") then
                return true
            end
        end
    end
    return false
end

-- Teletransporte automático
RunService.Heartbeat:Connect(function()
    if teleportEnabled and teleportPoint and hasBrainrot() then
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Teletransporta suavemente al punto
            hrp.CFrame = CFrame.new(teleportPoint + Vector3.new(0, 3, 0))
        else
            print("No se encontró HumanoidRootPart")
        end
    else
        if teleportEnabled then
            print("Se desactiva teletransporte (punto o brainrot faltante)")
            teleportEnabled = false
        end
    end
end)

-- Crear GUI y botones
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "TeleportGui"

local function createButton(text, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.Parent = gui
    return btn
end

local btnSetPoint = createButton("📍 Fijar punto", UDim2.new(0, 20, 0, 100))
local btnStartTP = createButton("▶️ Empezar TP", UDim2.new(0, 20, 0, 150))
local btnRemovePoint = createButton("✖ Quitar punto", UDim2.new(0, 20, 0, 200))

btnSetPoint.MouseButton1Click:Connect(function()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        teleportPoint = hrp.Position
        print("📍 Punto de teletransporte fijado en:", teleportPoint)
    else
        warn("No se pudo fijar el punto: no hay HumanoidRootPart")
    end
end)

btnStartTP.MouseButton1Click:Connect(function()
    if teleportPoint then
        if hasBrainrot() then
            teleportEnabled = true
            print("▶️ Teletransporte automático ACTIVADO")
        else
            warn("Necesitas tener el Brainrot para activar el teletransporte")
        end
    else
        warn("Primero fija un punto de teletransporte")
    end
end)

btnRemovePoint.MouseButton1Click:Connect(function()
    teleportEnabled = false
    teleportPoint = nil
    print("✖ Punto de teletransporte removido y teletransporte detenido")
end)
