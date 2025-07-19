--[[
🔥 Brainrot Auto Teleporter (Exploit Script)
📌 Crea este archivo en GitHub si quieres (ej: brainrot-teleport.lua)
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

-- UI BUTTON
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 150, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0, 100)
ToggleBtn.Text = "TP Brainrot: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 20
ToggleBtn.BorderSizePixel = 0
ToggleBtn.AutoButtonColor = true

ToggleBtn.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    ToggleBtn.Text = "TP Brainrot: " .. (teleportEnabled and "ON" or "OFF")
    print("📡 Teleport:", teleportEnabled and "ACTIVADO" or "DESACTIVADO")
end)

print("✅ Brainrot auto-teleport con botón cargado.")
