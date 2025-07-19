local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local baseFolder = Workspace:FindFirstChild("Bases")
if not baseFolder then
    warn("❌ No se encontró carpeta workspace.Bases")
    return
end

local teleportEnabled = false

local function hasBrainrot()
    for _, item in ipairs(lp.Backpack:GetChildren()) do
        print("Revisando en backpack:", item.Name)
        if item.Name:lower():find("brainrot") then
            print("✅ Brainrot encontrado en backpack:", item.Name)
            return true
        end
    end
    if lp.Character then
        for _, item in ipairs(lp.Character:GetChildren()) do
            print("Revisando en character:", item.Name)
            if item.Name:lower():find("brainrot") then
                print("✅ Brainrot encontrado en character:", item.Name)
                return true
            end
        end
    end
    print("❌ No se encontró brainrot")
    return false
end

local function getEntrancePart()
    local base = baseFolder:FindFirstChild(lp.Name)
    if base then
        local entrance = base:FindFirstChild("Entrance")
        if entrance then
            print("✅ Entrada encontrada:", entrance:GetFullName())
            return entrance
        else
            warn("❌ No se encontró 'Entrance' en la base")
        end
    else
        warn("❌ No se encontró base para el jugador:", lp.Name)
    end
end

task.spawn(function()
    while true do
        if teleportEnabled and hasBrainrot() then
            local entrance = getEntrancePart()
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if entrance and hrp then
                print("➡️ Teletransportando a base...")
                hrp.CFrame = entrance.CFrame + Vector3.new(0, 3, 0)
            else
                warn("❌ Faltan hrp o entrance")
            end
        end
        task.wait(0.1)
    end
end)

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "BrainrotTPGui"

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0, 20, 0, 100)
button.Text = "🧠 Auto TP: OFF"
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.Gotham
button.TextSize = 18
button.AutoButtonColor = true
button.BorderSizePixel = 0

button.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    button.Text = teleportEnabled and "🧠 Auto TP: ON" or "🧠 Auto TP: OFF"
    print("📡 Teleport:", teleportEnabled and "ACTIVADO" or "DESACTIVADO")
end)

print("✅ Brainrot auto-teleport listo con debug. Usa el botón para activar o desactivar.")
