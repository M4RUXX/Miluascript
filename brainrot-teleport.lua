local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local teleportPoint = nil
local teleportEnabled = false
local markerPart = nil
local gui = nil

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

local function setupGui()
    if gui then gui:Destroy() end
    gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
    gui.Name = "TeleportGui"

    local btnSetPoint = createButton("📍 Fijar punto", UDim2.new(0, 20, 0, 100))
    local btnStartTP = createButton("▶️ Empezar TP", UDim2.new(0, 20, 0, 150))
    local btnRemovePoint = createButton("✖ Quitar punto", UDim2.new(0, 20, 0, 200))

    btnSetPoint.MouseButton1Click:Connect(function()
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            teleportPoint = hrp.Position
            createMarker(teleportPoint)
            print("Punto fijado en:", teleportPoint)
        else
            warn("No se encontró HumanoidRootPart para fijar punto")
        end
    end)

    btnStartTP.MouseButton1Click:Connect(function()
        if teleportPoint then
            teleportEnabled = true
            print("Teletransporte activado")
        else
            warn("Primero debes fijar un punto")
        end
    end)

    btnRemovePoint.MouseButton1Click:Connect(function()
        teleportEnabled = false
        teleportPoint = nil
        if markerPart then
            markerPart:Destroy()
            markerPart = nil
        end
        print("Punto eliminado y teletransporte detenido")
    end)
end

RunService.Heartbeat:Connect(function()
    if teleportEnabled and teleportPoint then
        local character = lp.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if humanoid and humanoid.Health > 0 and hrp then
            local rayOrigin = teleportPoint + Vector3.new(0, 50, 0)
            local rayDirection = Vector3.new(0, -100, 0)
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

            local targetPosition
            if raycastResult and raycastResult.Position then
                targetPosition = raycastResult.Position + Vector3.new(0, 3, 0) -- 3 studs arriba del suelo
            else
                targetPosition = teleportPoint + Vector3.new(0, 5, 0)
            end

            humanoid.PlatformStand = true
            hrp.CFrame = CFrame.new(targetPosition)
            task.delay(0.2, function()
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end)
        end
    end
end)

local function onCharacterAdded()
    teleportEnabled = false
    teleportPoint = nil
    if markerPart then
        markerPart:Destroy()
        markerPart = nil
    end
    setupGui()
end

lp.CharacterAdded:Connect(onCharacterAdded)

if lp.Character then
    onCharacterAdded()
end
