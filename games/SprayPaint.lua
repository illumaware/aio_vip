local lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/illumaware/c/main/debug/BetterOrion.lua')))()
local window = lib:MakeWindow({Name = "[Spray Paint] AIO", HidePremium = true, SaveConfig = false, IntroEnabled = false})
local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local status = home:AddLabel("Status: ⏳ Waiting")
local currentScore = home:AddLabel("Current Score: 0")
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })

local plr = game.Players.LocalPlayer.Name
local startBPath = workspace["Whac-A-Teddy"].PlayButton:FindFirstChildOfClass("ClickDetector")

local function updateScore()  -- Update Labels
    local wSGui = workspace["Whac-A-Teddy"].Screen.SurfaceGui
    local currentSPath = wSGui.Process
    local processTPath = wSGui.Process.Timer    
    while task.wait() do
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
end task.spawn(updateScore)

local function startGame()  -- Start Button Click
    fireclickdetector(startBPath)
end
local function clickOn(obj)  -- Click On Teddy
    local clickDetector = obj and obj:FindFirstChildOfClass("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
    end
end

home:AddToggle({  -- Auto Play Whac-A-Teddy
	Name = "🧸 Auto Play Whac-A-Teddy",
	Default = false,
	Callback = function(Value)
        getfenv().playing = (Value and true or false)
        while playing and task.wait() do
            startGame()
            for i = 1, 5 do
                spawn(function()
                    local hole = workspace["Whac-A-Teddy"].Holes["Hole" .. i]
                    if hole then
                        for _, teddy in ipairs(hole:GetChildren()) do
                            if teddy.Name == "Teddy" then
                                clickOn(teddy)
                            end
                        end
                    end
                end)
            end
        end    
	end
})

misc:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/cpuReducer.lua"))() -- Credits: github.com/fdvll
  	end
})
misc:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
  	end
})
misc:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        local serverhop = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")() -- Credits: github.com/LeoKholYt
        serverhop:Teleport(game.PlaceId)
  	end
})
misc:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function() lib:Destroy() end    
})
