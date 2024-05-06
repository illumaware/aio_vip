local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

ScreenGui.Name = "__s"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Name = "__f"
Frame.Parent = ScreenGui
Frame.BackgroundTransparency = 1
Frame.Position = UDim2.new(0, 8, 0, 947)
Frame.Size = UDim2.new(0, 300, 0, 20)

TextLabel.Name = "__t"
TextLabel.Parent = Frame
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(0, 300, 0, 20)
TextLabel.Font = Enum.Font.Code
TextLabel.Text = "Loading"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 15
TextLabel.TextXAlignment = "Left"

local stats = game:GetService("Stats")
local pname = game:GetService("Players").LocalPlayer.Name
local mcount = game.Players.MaxPlayers

game:GetService("RunService").RenderStepped:Connect(function()
	local pcount = #game.Players:GetPlayers()
	local elapsedSeconds = stats.Network.ServerStatsItem.ElapsedTime:GetValue()
	local hours = math.floor(elapsedSeconds / 3600)
	local minutes = math.floor((elapsedSeconds % 3600) / 60)
	local seconds = elapsedSeconds % 60
	local elapsed_time = string.format("%02d:%02d:%02d", hours, minutes, seconds)
	local fps = string.format("%.0f", stats.Workspace.Heartbeat:GetValue())
	local ping = string.format("%.1f", stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    TextLabel.Text = "👥 " ..pcount.. "/" ..mcount.. " 🕓 " ..elapsed_time.. " 🖥️ " ..fps.. " 📶 " ..ping
end)
