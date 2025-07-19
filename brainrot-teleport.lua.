--[[
🔥 Brainrot Auto Teleporter (Exploit Script)
📌 Crea este archivo en GitHub si quieres (ej: brainrot-tp.lua)
⚠️ Úsalo solo para pruebas en tus propios juegos.
]]

-- CONFIGURA TU NOMBRE DE BASE
local baseFolder = workspace:FindFirstChild("Bases")
if not baseFolder then
    warn("No se encontró workspace.Bases")
    return
end

-- UTILS
local lp = game.Players.LocalPlayer
local hrp = lp.Character and lp.Character:WaitForChild("HumanoidRootPart")

-- FLAGS
local teleportEnabled = false

-- FUNCIONES
local function hasBrainrot()
    for _, item in ipairs(lp.Backpack:GetChildren()) do
        if item.Name:lower():find("brainrot") then
            return true
        end
    end
    for _, item in ipairs(lp.Character:GetChildren()) do
        if item.Name:lower():find("brainrot") then
            return true
        end
    end
    return false
end

local function getEntrancePart()
    local base = baseFolder:FindFirstChild(lp.Name)
    if base then
        return base:FindFirstChild("Entrance")
    end
end

-- Crear GUI botón
local playerGui = lp:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotTeleportGUI"
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 22
button.Text = "Activar Teleport"
button.Parent = screenGui

button.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    button.Text = teleportEnabled and "Desactivar Teleport" or "Activar Teleport"
end)

-- TELEPORT LOOP
task.spawn(function()
    while true do
        if teleportEnabled and hasBrainrot() then
            local entrance = getEntrancePart()
            if entrance and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = entrance.CFrame + Vector3.new(0, 3, 0)
            end
        end
        task.wait(0.1)
    end
end)

print("✅ Brainrot auto-teleport cargado. Usa el botón para activar o desactivar el teletransporte.")
