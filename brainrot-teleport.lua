-- Limpia GUI anterior
if game.CoreGui:FindFirstChild("SimpleTPGui") then
    game.CoreGui.SimpleTPGui:Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local teleportPoint = nil
local teleporting = false

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleTPGui"
ScreenGui.Parent = game.CoreGui

local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    button.Text = text
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = ScreenGui
    button.MouseButton1Click:Connect(callback)
    return button
end

createButton("📍 Fijar Punto", UDim2.new(0, 20, 0, 50), function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        teleportPoint = player.Character.HumanoidRootPart.Position
        print("Punto fijado en: ", teleportPoint)
    else
        print("No se encontró HumanoidRootPart para fijar punto")
    end
end)

createButton("⚡ Empezar TP", UDim2.new(0, 20, 0, 90), function()
    if teleportPoint then
        teleporting = true
        print("Teletransporte iniciado")
    else
        print("No hay punto fijado para teletransportar")
    end
end)

createButton("⛔ Detener TP", UDim2.new(0, 20, 0, 130), function()
    teleporting = false
    print("Teletransporte detenido")
end)

createButton("🗑 Borrar Punto", UDim2.new(0, 20, 0, 170), function()
    teleporting = false
    teleportPoint = nil
    print("Punto borrado")
end)

-- Teletransporte loop
task.spawn(function()
    while true do
        if teleporting and teleportPoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPoint + Vector3.new(0,3,0))
        end
        task.wait(0.3)
    end
end)

-- Actualiza hrp al reaparecer
player.CharacterAdded:Connect(function(char)
    hrp = char:WaitForChild("HumanoidRootPart")
end)

print("✅ Script de teletransporte simple cargado")
