local lib = loadstring(game:HttpGet('https://github.com/illumaware/c/blob/main/debug/BetterOrion.lua?raw=true'))()
local window = lib:MakeWindow({Name = "[Anime RNG] AIO", HidePremium = true, SaveConfig = false, IntroEnabled = false})

local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local freestuff = home:AddSection({ Name = "Freebies" })
local roll = home:AddSection({ Name = "Roll" })
local potions = home:AddSection({ Name = "Potions" })
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })


local remote = game:GetService("ReplicatedStorage").Remotes
local vu = game:GetService("VirtualUser")
local slp = game.Players.LocalPlayer
local promptsFolder = workspace.Prompts

slp.Idled:connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end)  -- AntiAFK
for _, prompt in ipairs(promptsFolder:GetDescendants()) do if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end end


freestuff:AddTextbox({  -- Get Cash Amount
    Name = "💰 Get Cash Amount",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        remote.Settings:FireServer("Cash", tonumber(Value))
    end
})
freestuff:AddTextbox({  -- Get Super Rolls Amount
    Name = "🎲 Get Super Rolls Amount",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        remote.Settings:FireServer("SuperRolls", tonumber(Value))
    end
})

roll:AddDropdown({  -- Choose Roll
	Name = "🎲 Choose Roll",
	Default = "",
	Options = {"Super", "Normal"},
	Callback = function(Value)
		chosenRoll = Value
	end
})
roll:AddToggle({  -- Auto Roll
	Name = "🎲 Auto Roll",
	Default = false,
	Callback = function(Value)
        getfenv().autoRoll = Value
        while autoRoll and chosenRoll ~= nil do
            if chosenRoll == "Normal" then
                remote.Roll:FireServer()
            else
                remote.Roll:FireServer(true)
            end
            remote.RollDebounce:FireServer()
            wait(0.05)
        end
	end
})
roll:AddToggle({  -- Auto Roll
	Name = "🎲 Hide Roll Animation",
	Default = false,
	Callback = function(Value)
        slp.PlayerGui.RollUI.Background.Visible = not Value
	end
})

potions:AddDropdown({  -- Choose Potion
	Name = "🧪 Choose Potion",
	Default = "",
	Options = {"Lightspeed Potion", "Light Potion", "Medium Potion"},
	Callback = function(Value)
		chosenPotion = Value
	end
})
potions:AddToggle({  -- Auto Purchase Potion
	Name = "🧪 Auto Purchase Potion",
	Default = false,
	Callback = function(Value)
        getfenv().autoPpotion = Value
        while autoPpotion and chosenPotion ~= nil and task.wait() do
            remote.PurchasePotion:FireServer(chosenPotion)
        end
	end
})
potions:AddToggle({  -- Auto Use Potion
	Name = "🧪 Auto Use Potion",
	Default = false,
	Callback = function(Value)
        getfenv().autoUpotion = Value
        while autoUpotion and chosenPotion ~= nil and task.wait() do
            remote.UsePotion:FireServer(chosenPotion)
        end
	end
})

misc:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        loadstring(game:HttpGet("https://github.com/fdvll/pet-simulator-99/blob/main/cpuReducer.lua?raw=true"))() -- Credits: github.com/fdvll
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
        loadstring(game:HttpGet("https://github.com/LeoKholYt/roblox/blob/main/lk_serverhop.lua?raw=true"))():Teleport(game.PlaceId) -- Credits: github.com/LeoKholYt
  	end
})
misc:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function() lib:Destroy() end    
})
lib:Init()
