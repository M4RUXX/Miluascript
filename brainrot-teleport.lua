
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")


local baseFolder = Workspace:FindFirstChild("Bases")
if not baseFolder then
    warn("❌ No se encontró carpeta workspace.Bases")
    return
end

local function getEntrancePart()
    local base = baseFolder:FindFirstChild(lp.Name)
    if base then
        return base:FindFirstChild("Entrance")
    end
end


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


local teleportEnabled = false

task.spawn(function()
    while true do
        if teleportEnabled and hasBrainrot() then
            local entrance = getEntrancePart()
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            if entrance and hrp then
                hrp.CFrame = entrance.CFrame + Vector3.new(0, 3, 0)
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
end)

print("✅ Brainrot auto-teleport listo. Usa el botón para activar o desactivar.")
