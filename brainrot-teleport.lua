local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local teleportPoint = nil
local teleportEnabled = false
local markerPart = nil

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

RunService.Heartbeat:Connect(function()
    if teleportEnabled and teleportPoint and hasBrainrot() then
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (hrp.Position - teleportPoint).Magnitude
            if dist > 1 then -- solo teletransporta si estás a más de 1 stud para evitar problemas
                hrp.CFrame = CFrame.new(teleportPoint + Vector3.new(0, 3, 0))
                print("🔄 Teletransportando al punto")
            end
        else
            warn("No se encontró HumanoidRootPart")
        end
    elseif teleportEnabled then
        print("🛑 Teletransporte desactivado porque no tienes Brainrot o punto no válido")
        teleportEnabled = false
    end
end)

local function createMarker(position)
    if markerPart then
        markerPart:Destroy()
    end
    markerPart = Instance.new("Part")
    markerPart.Size = Vector3.new(2, 0.2, 2)
    markerPart.Anchored = true
    markerPart.CanCollide = false
    markerPart.Transparency = 0.5
    markerPart.Color = Color3.fromRGB(255, 0, 0)
    markerPart.Material = Enum.Material.Neon
    markerPart.Position = position + Vector3.new(0, 1, 0)
    markerPart.Name = "TeleportMarker"
    markerPart.Parent = Workspace
end

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
        print("📍 Punto fijado en:", teleportPoint)
        createMarker(teleportPoint)
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
    if markerPart then
        markerPart:Destroy()
        markerPart = nil
    end
    print("✖ Punto eliminado y teletransporte detenido")
end)
