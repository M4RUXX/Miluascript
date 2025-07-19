local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local teleportPoint = nil
local teleportEnabled = false
local markerPart = nil

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

btnSetPoint.MouseButton1Click:Connect(function()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        teleportPoint = hrp.Position
        createMarker(teleportPoint)
        teleportEnabled = true -- se activa automáticamente al fijar el punto
        print("Punto fijado y teletransporte activado en:", teleportPoint)
    else
        warn("No se encontró HumanoidRootPart para fijar punto")
    end
end)

RunService.Heartbeat:Connect(function()
    if teleportEnabled and teleportPoint then
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(teleportPoint + Vector3.new(0, 3, 0))
        else
            warn("No se encontró HumanoidRootPart para teletransportar")
        end
    end
end)
