-- Ugly Hub básico para Roblox (estilo hub con pestañas y botones)

-- Elimina GUI previa si existe
if game.CoreGui:FindFirstChild("UglyHub") then
    game.CoreGui.UglyHub:Destroy()
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Crear GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UglyHub"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BorderSizePixel = 0
Title.Text = "Ugly Hub - Steal a Brainrot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

-- Contenedor de contenido
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

-- Panel de pestañas (izquierda)
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0, 100, 1, 0)
TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = ContentFrame

-- Contenedor de páginas (derecha)
local PagesFrame = Instance.new("Frame")
PagesFrame.Size = UDim2.new(1, -110, 1, 0)
PagesFrame.Position = UDim2.new(0, 110, 0, 0)
PagesFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PagesFrame.BorderSizePixel = 0
PagesFrame.Parent = ContentFrame

-- Función para crear botón de pestaña
local function createTabButton(name, position, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 18
    btn.Parent = parent
    return btn
end

-- Función para crear botón funcional
local function createButton(name, position, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Crear páginas (Frames)
local pages = {}

local function createPage(name)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = PagesFrame
    pages[name] = page
    return page
end

-- Crear pestañas
local tabNames = {"Teleport", "Auto", "Info"}

for i, tabName in ipairs(tabNames) do
    local tabBtn = createTabButton(tabName, UDim2.new(0, 0, 0, 40*(i-1)), TabsFrame)
    local page = createPage(tabName)
    
    tabBtn.MouseButton1Click:Connect(function()
        -- Mostrar sólo la página seleccionada
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
    end)
    
    if i == 1 then
        tabBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        page.Visible = true
    end
end

-- FUNCIONALIDADES por pestaña

-- Teleport page
local teleportPage = pages["Teleport"]

createButton("Teleport a mi Base", UDim2.new(0, 10, 0, 10), teleportPage, function()
    local basesFolder = workspace:FindFirstChild("Bases")
    if basesFolder then
        local base = basesFolder:FindFirstChild(player.Name)
        if base and base:FindFirstChild("Entrance") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = base.Entrance.CFrame + Vector3.new(0,3,0)
        else
            warn("No se encontró base o entrada")
        end
    else
        warn("No se encontró carpeta Bases")
    end
end)

createButton("Teleport a Brainrot", UDim2.new(0, 10, 0, 60), teleportPage, function()
    local brainrot
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("brainrot") then
            brainrot = obj
            break
        end
    end
    if brainrot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = brainrot.CFrame + Vector3.new(0,3,0)
    else
        warn("No se encontró brainrot o HumanoidRootPart")
    end
end)

-- Auto page
local autoPage = pages["Auto"]
local teleporting = false
local autoTpBtn

autoTpBtn = createButton("Auto Teleport: OFF", UDim2.new(0, 10, 0, 10), autoPage, function()
    teleporting = not teleporting
    autoTpBtn.Text = "Auto Teleport: " .. (teleporting and "ON" or "OFF")
end)

-- Loop auto teleport
task.spawn(function()
    while true do
        if teleporting and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local brainrot
            for _, obj in pairs(workspace:GetChildren()) do
                if obj.Name:lower():find("brainrot") then
                    brainrot = obj
                    break
                end
            end
            if brainrot then
                player.Character.HumanoidRootPart.CFrame = brainrot.CFrame + Vector3.new(0,3,0)
            end
        end
        task.wait(0.3)
    end
end)

-- Info page
local infoPage = pages["Info"]

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -20)
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1,1,1)
infoLabel.TextWrapped = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 16
infoLabel.Text = [[
Ugly Hub básico
Creado para Steal a Brainrot

Funciones:
- Teletransportarte a base
- Teletransportarte al brainrot
- Auto teleport
]]
infoLabel.Parent = infoPage

print("✅ Ugly Hub básico cargado")
