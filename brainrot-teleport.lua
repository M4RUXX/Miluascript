
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local speed = 60


local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FlyGui"

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 100, 0, 40)
Button.Position = UDim2.new(0, 20, 0, 100)
Button.Text = "🚀 Fly: OFF"
Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Button.TextColor3 = Color3.new(1,1,1)
Button.Parent = ScreenGui


local function setVelocity(v)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if flying then
        local vel = Instance.new("BodyVelocity")
        vel.Velocity = v
        vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        vel.Name = "FlyVelocity"
        vel.Parent = hrp
    else
        if hrp:FindFirstChild("FlyVelocity") then
            hrp.FlyVelocity:Destroy()
        end
    end
end


RunService.RenderStepped:Connect(function()
    if flying then
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + workspace.CurrentCamera.CFrame.UpVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - workspace.CurrentCamera.CFrame.UpVector end

        setVelocity(dir.Unit * speed)
    end
end)


Button.MouseButton1Click:Connect(function()
    flying = not flying
    Button.Text = flying and "🛑 Fly: ON" or "🚀 Fly: OFF"
    setVelocity(Vector3.zero)
end)

print("✅ Fly GUI script cargado.")
