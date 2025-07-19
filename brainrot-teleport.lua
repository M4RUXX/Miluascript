

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 60
local control = {F = 0, B = 0, L = 0, R = 0, U = 0, D = 
    
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
