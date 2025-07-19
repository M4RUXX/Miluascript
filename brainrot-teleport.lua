-- brainrot-teleport.lua mejorado
if game.CoreGui:FindFirstChild("TPGui") then
    game.CoreGui.TPGui:Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local teleporting = false
local teleportPoint = nil

-- Función para crear punto visible
local function createVisualPoint(pos)
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 0.5, 2)
    part.Position = pos
    part.Anchored = true
    part.CanCollide = false
    part.BrickColor = BrickColor.Red()
    part.Material = Enum.Material.Neon
    part.Name = "TeleportPointMarker"
    part.Parent = workspace
    return part
end

-- Interfaz de usuario
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TPGui"

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 160, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Parent = ScreenGui
    button.MouseButton1Click:Connect(callback)
end

-- Botón: Fijar punto
createButton("📍 Fijar Punto", UDim2.new(0, 20, 0, 80), function()
    teleportPoint = hrp.Position - Vector3.new(0, hrp.Size.Y / 2 + 2, 0)
    if workspace:FindFirstChild("TeleportPointMarker") then
        workspace.TeleportPointMarker:Destroy()
    end
    createVisualPoint(teleportPoint)
end)

-- Botón: Iniciar TP
createButton("⚡ Iniciar TP", UDim2.new(0, 20, 0, 125), function()
    if teleportPoint then
        teleporting = true
    end
end)

-- Botón: Detener TP
createButton("⛔ Detener TP", UDim2.new(0, 20, 0, 170), function()
    teleporting = false
end)

-- Botón: Eliminar punto
createButton("🗑 Eliminar Punto", UDim2.new(0, 20, 0, 215), function()
    teleporting = false
    teleportPoint = nil
    if workspace:FindFirstChild("TeleportPointMarker") then
        workspace.TeleportPointMarker:Destroy()
    end
end)

-- Teletransporte loop
task.spawn(function()
    while true do
        if teleporting and teleportPoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
            player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPoint + Vector3.new(0, 3, 0))
        end
        task.wait(0.2)
    end
end)

-- Auto-reload al morir
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    hrp = char.HumanoidRootPart
end)

print("✅ Teleport script cargado correctamente.")
