local lp = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
local txt = Instance.new("TextLabel", gui)
txt.Text = "UI Test - Funciona"
txt.Size = UDim2.new(0, 200, 0, 50)
txt.Position = UDim2.new(0, 20, 0, 50)
