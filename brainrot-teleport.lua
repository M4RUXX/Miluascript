-- Simplified, Safe ESP Script with Roles

local Players = game:GetService("Players") local localPlayer = Players.LocalPlayer local esp = false local espLabels = {} local highlights = {}

-- Obtener rol seguro (inocente por defecto) local function getRole(player) local ok, role = pcall(function() return player:GetAttribute("Role") end) if ok and type(role) == "string" and role ~= "" then return role end local sv = player:FindFirstChild("Role") if sv and sv:IsA("StringValue") then return sv.Value end local ls = player:FindFirstChild("leaderstats") if ls then local rls = ls:FindFirstChild("Role") if rls and rls:IsA("StringValue") then return rls.Value end end return "Innocent" end

-- Crea ESP + highlight de rol sin listeners local function createESPForPlayer(player) local char = player.Character if not player or not char then return end local head = char:FindFirstChild("Head") if not head then return end

-- Etiqueta
local bill = Instance.new("BillboardGui", head)
bill.Name = "ESPLabel"
bill.Adornee = head
bill.Size = UDim2.new(0,150,0,50)
bill.AlwaysOnTop = true
bill.StudsOffset = Vector3.new(0,1.5,0)

local nameLabel = Instance.new("TextLabel", bill)
nameLabel.Size = UDim2.new(1,0,1,0)
nameLabel.BackgroundTransparency = 1
nameLabel.TextStrokeTransparency = 0
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextSize = 18

-- Highlight
local hl = Instance.new("Highlight", char)
hl.Name = "RoleHighlight"
hl.OutlineTransparency = 1

-- Actualiza rol y color
local function upd()
    local role = getRole(player)
    local col = (role == "Murderer" or role == "Assassin") and Color3.new(1,0,0)
                or role == "Sheriff" and Color3.new(0,0,1)
                or Color3.new(0,1,0)
    nameLabel.Text = player.Name.."\n["..role.."]"
    nameLabel.TextColor3 = col
    hl.FillColor = col
end

upd()

espLabels[player] = bill
highlights[player] = hl

end

-- Limpieza de ESP local function removeESPForPlayer(player) if espLabels[player] then espLabels[player]:Destroy() espLabels[player] = nil end if highlights[player] then highlights[player]:Destroy() highlights[player] = nil end end

-- toggleESP más fiable function toggleESP(on) esp = on for _, p in pairs(Players:GetPlayers()) do removeESPForPlayer(p) if on and p ~= localPlayer then if p.Character and p.Character:FindFirstChild("Head") then createESPForPlayer(p) end end end end

