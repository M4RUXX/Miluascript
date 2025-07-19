

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60
local control = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 0}


local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FlyGUI"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 100, 0, 40)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.Text = "🚀 Fly: OFF"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.new(1,1,1)


local bg, bv

local function startFly()
    if flying then return end
    flying = true
    btn.Text = "🛑 Fly: ON"

    bg = Instance.new("BodyGyro", hrp)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = hrp.CFrame

    bv = Instance.new("BodyVelocity", hrp)
    bv.velocity = Vector3.zero
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    RunService.RenderStepped:Connect(function()
        if flying then
            bg.cframe = workspace.CurrentCamera.CFrame
            local dir = (control.F - control.B) * workspace.CurrentCamera.CFrame.LookVector +
                        (control.R - control.L) * workspace.CurrentCamera.CFrame.RightVector +
                        (control.U - control.D) * workspace.CurrentCamera.CFrame.UpVector
            bv.velocity = dir * speed
        end
    end)
end

local function stopFly()
    flying = false
    btn.Text = "🚀 Fly: OFF"
    if bg then bg:Destroy() end
    if bv then bv:Destroy() end
end


btn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)


UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then control.F = 1 end
        if input.KeyCode == Enum.KeyCode.S then control.B = 1 end
        if input.KeyCode == Enum.KeyCode.A then control.L = 1 end
        if input.KeyCode == Enum.KeyCode.D then control.R = 1 end
        if input.KeyCode == Enum.KeyCode.Space then control.U = 1 end
        if input.KeyCode == Enum.KeyCode.LeftShift then control.D = 1 end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then control.F = 0 end
        if input.KeyCode == Enum.KeyCode.S then control.B = 0 end
        if input.KeyCode == Enum.KeyCode.A then control.L = 0 end
        if input.KeyCode == Enum.KeyCode.D then control.R = 0 end
        if input.KeyCode == Enum.KeyCode.Space then control.U = 0 end
        if input.KeyCode == Enum.KeyCode.LeftShift then control.D = 0 end
    end
end)

print("✅ Fly estable con botón cargado.")
