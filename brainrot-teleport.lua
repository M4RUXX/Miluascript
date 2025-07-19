local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local espLabels = {}
local highlights = {}

local function getRole(player)
    -- Intentamos varias formas para sacar el rol
    local success, role = pcall(function()
        return player:GetAttribute("Role")
    end)
    if success and type(role) == "string" and role ~= "" then
        return role
    end

    local sv = player:FindFirstChild("Role")
    if sv and sv:IsA("StringValue") then
        return sv.Value
    end

    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local rls = ls:FindFirstChild("Role")
        if rls and rls:IsA("StringValue") then
            return rls.Value
        end
    end

    return "Innocent"
end

local function createESPForPlayer(player)
    if espLabels[player] or player == localPlayer then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui", head)
    billboard.Name = "ESPLabel"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 1.5, 0)

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 0.5
    label.BackgroundColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 18

    local highlight = Instance.new("Highlight", char)
    highlight.Name = "RoleHighlight"
    highlight.OutlineTransparency = 1
    highlight.Enabled = true

    local function update()
        local role = getRole(player)
        local color = Color3.new(0, 1, 0) -- Innocent por defecto
        if role == "Murderer" or role == "Assassin" then
            color = Color3.new(1, 0, 0)
        elseif role == "Sheriff" then
            color = Color3.new(0, 0, 1)
        end
        label.Text = player.Name .. "\n[" .. role .. "]"
        label.TextColor3 = color
        highlight.FillColor = color
    end

    update()

    espLabels[player] = billboard
    highlights[player] = highlight

    -- Actualiza en cada frame para reflejar cambios en rol o estado
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not player.Parent or not player.Character then
            conn:Disconnect()
            if billboard and billboard.Parent then
                billboard:Destroy()
            end
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
            espLabels[player] = nil
            highlights[player] = nil
            return
        end
        update()
    end)
end

local function removeESPForPlayer(player)
    if espLabels[player] then
        espLabels[player]:Destroy()
        espLabels[player] = nil
    end
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function toggleESP(enable)
    if enable then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character and p.Character:FindFirstChild("Head") then
                createESPForPlayer(p)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                if enable then
                    createESPForPlayer(p)
                end
            end)
        end)
        Players.PlayerRemoving:Connect(removeESPForPlayer)
    else
        for _, p in pairs(Players:GetPlayers()) do
            removeESPForPlayer(p)
        end
    end
end
