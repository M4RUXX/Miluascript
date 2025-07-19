-- Ugly Hub estilo Steal a Brainrot (simple y funcional)

-- Elimina GUI anterior si existe
if game.CoreGui:FindFirstChild("StealBrainrotHub") then
    game.CoreGui.StealBrainrotHub:Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealBrainrotHub"
ScreenGui.Parent = game.CoreGui

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.BorderSizePixel = 0
Title.Text = "Steal a Brainrot Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

-- Variables para toggles
local teleporting = false

-- Utilidades para encontrar objetos
local function findBase()
    local basesFolder = workspace:FindFirstChild("Bases")
    if not basesFolder then return nil end
    return basesFolder:FindFirstChild(player.Name)
end

local function findBrainrot()
    -- Busca brainrot en workspace, cambiar el nombre según tu juego
    for _, item in pairs(workspace:GetChildren()) do
        if item.Name:lower():find("brainrot") then
            return item
        end
    end
    return nil
end

-- Botones

local function createButton(text, pos, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 300, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Teleport a base
createButton("Teleport a mi Base", UDim2.new(0, 25, 0, 60), MainFrame, function()
    local base = findBase()
    if base and base:FindFirstChild("Entrance") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = base.Entrance.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- Teleport a brainrot
createButton("Teleport a Brainrot", UDim2.new(0, 25, 0, 110), MainFrame, function()
    local brainrot = findBrainrot()
    if brainrot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = brainrot.CFrame + Vector3.new(0, 3, 0)
    end
end)

-- Toggle auto teleport a brainrot
local autoTpBtn = createButton("Auto Teleport: OFF", UDim2.new(0, 25, 0, 160), MainFrame, function()
    teleporting = not teleporting
    autoTpBtn.Text = "Auto Teleport: " .. (teleporting and "ON" or "OFF")
end)

-- Loop para auto teleport
spawn(function()
    while true do
        if teleporting then
            local brainrot = findBrainrot()
            if brainrot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = brainrot.CFrame + Vector3.new(0, 3, 0)
            end
        end
        wait(0.5)
    end
end)

-- Botón para cerrar hub
createButton("Cerrar Hub", UDim2.new(0, 25, 0, 350), MainFrame, function()
    ScreenGui:Destroy()
end)
