repeat task.wait()until game:IsLoaded()
local lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/illumaware/c/main/debug/BetterOrion.lua')))()
local window = lib:MakeWindow({Name = "[Spray Paint] AIO", HidePremium = true, SaveConfig = false, ConfigFolder = ""})
local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local status = home:AddLabel("Status: ⏳ Waiting")
local highestScore = home:AddLabel("Highest Score: None")
local currentScore = home:AddLabel("Current Score: 0")
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })
local playing = false

local plr = game.Players.LocalPlayer.Name
local wSGui = workspace["Whac-A-Teddy"].Screen.SurfaceGui
local startBPath = workspace["Whac-A-Teddy"].PlayButton:FindFirstChildOfClass("ClickDetector")
local homePath = wSGui.Home
local highestSPath = wSGui.HighScores.Scores[plr].Score
local currentSPath = wSGui.Process
local processTPath = wSGui.Process.Timer

home:AddToggle({  -- Auto Play Whac-A-Teddy
	Name = "🧸 Auto Play Whac-A-Teddy",
	Default = false,
	Callback = function(Value)
        playing = Value
        if playing then warn("[Debug] ✅ Enabled Auto Play Whac-A-Teddy") end    
	end
})

misc:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        lib:MakeNotification({ Name = "FPS Booster", Content = "Credits: github.com/fdvll", Image = "rbxassetid://7733911828", Time = 5 })
        wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/cpuReducer.lua"))()
  	end
})
misc:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, slp)
  	end
})
misc:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        local sh = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()
        lib:MakeNotification({ Name = "Server Hopping...", Content = "Credits: github.com/LeoKholYt", Image = "rbxassetid://7733911828", Time = 5 })
        wait(1)
        sh:Teleport(game.PlaceId)
  	end
})
misc:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function()
        lib:Destroy()
  	end    
})

local function updateScore()  -- Update Labels
    if highestSPath then
        local highestS = highestSPath.Text
        highestScore:Set("Highest Score: " .. highestS)
    end
    if currentSPath then
        local currentS = currentSPath.Score.Text
        currentScore:Set("Current Score: " .. currentS)
        if currentSPath.Visible and playing then
            local timer = processTPath.Text
            status:Set("Status: 🎮 Playing [Left: " .. timer .. "]")
        else
            status:Set("Status: ⏳ Waiting")
        end
    end
end
local function startGame()  -- Start Button Click
    fireclickdetector(startBPath)
end
local function clickOnTeddy(teddyBear)  -- Click On Teddy
    local clickDetector = teddyBear and teddyBear:FindFirstChildOfClass("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
    end
end

while task.wait() do
    if playing then
        startGame()
        for i = 1, 5 do
            spawn(function()
                local hole = workspace["Whac-A-Teddy"].Holes["Hole" .. i]
                if hole then
                    for _, object in ipairs(hole:GetChildren()) do
                        if object.Name == "Teddy" then
                            clickOnTeddy(object)
                        end
                    end
                end
            end)
        end
    end
    updateScore()
end
