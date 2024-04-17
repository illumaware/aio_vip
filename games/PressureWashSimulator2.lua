local lib = loadstring(game:HttpGet('https://github.com/illumaware/c/blob/main/debug/BetterOrion.lua?raw=true'))()
local window = lib:MakeWindow({Name = "[Pressure Wash Simulator 2] AIO", HidePremium = true, SaveConfig = false, IntroEnabled = false})

local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local pets = window:MakeTab({ Name = "Pets", Icon = "rbxassetid://8997385940" })
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })

local vu = game:GetService("VirtualUser")
local remote = game:GetService("ReplicatedStorage").Remotes
local slp = game.Players.LocalPlayer
local lpname = slp.Name
local chr = slp.Character
local humRootPart = chr.HumanoidRootPart
local cashPos = workspace.Tycoons["1 Tycoon"].MoneyCollector.GroundCircle.Position
local diamondPos = workspace.Tycoons["1 Tycoon"].DiamondCollector.GroundCircle.Position
local refillPos = workspace.Tycoons["1 Tycoon"].WaterFountain.RefillZone.Position
local easyObbyPos = workspace.Obbys.EasyObby1.Finish.Position
local hardObbyPos = workspace.Obbys.HardObby1.Finish.Position
local multiBoost = slp.PlayerGui.UI.CurrencyHUD.Cash.RateFrame.Multipliers.Boosts.Multi

slp.Idled:connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end)  -- AntiAFK

home:AddSlider({  -- Set Walkspeed
	Name = "Set Walkspeed",
	Min = 16,
	Max = 100,
	Default = 16,
	Color = Color3.fromRGB(55,55,55),
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
        chr.Humanoid.WalkSpeed = tonumber(Value)
	end
})

home:AddButton({  -- Refill Tank
	Name = "💧 Refill Tank",
	Callback = function()
        local currentPos = chr and humRootPart.Position
        if currentPos then
            remote.RefillRemote:FireServer(false)
            remote.RefillRemote:FireServer(true)
            chr:MoveTo(refillPos)
            wait(6)
            chr:MoveTo(currentPos)
        end
  	end
})
home:AddButton({  -- Collect Cash
	Name = "💰💎 Collect Currency",
	Callback = function()
        local currentPos = chr and humRootPart.Position
        if currentPos then
            chr:MoveTo(cashPos)
            wait(1)
            chr:MoveTo(diamondPos)
            wait(1)
            chr:MoveTo(currentPos)
        end
  	end
})
home:AddToggle({  -- Auto Complete Obbies
	Name = "🏃‍♂️ Auto Complete Obbies",
    Default = false,
	Callback = function(Value)
        getfenv().autoObby = (Value and true or false)
        while autoObby and task.wait() do
            local currentPos = chr and humRootPart.Position
            local multiBoostTxt = multiBoost.Text
            if currentPos and multiBoostTxt ~= "+150%" then
                if multiBoostTxt == "+100%" then
                    chr:MoveTo(easyObbyPos)
                elseif multiBoostTxt == "+50%" then
                    chr:MoveTo(hardObbyPos)
                elseif multiBoostTxt == "+0%" then
                    chr:MoveTo(easyObbyPos)
                    wait(1)
                    chr:MoveTo(hardObbyPos)
                end
                wait(1)
                chr:MoveTo(currentPos)
            end
        end
	end
})

pets:AddDropdown({  -- Choose Egg
    Name = "🥚 Choose Egg",
    Default = "",
    Options = {"Cat Egg"},
    Callback = function(Value)
        chosenEgg = Value
    end
})
pets:AddToggle({  -- Auto Hatch Eggs
	Name = "🥚 Auto Hatch Eggs",
    Default = false,
	Callback = function(Value)
        getfenv().autohatch = (Value and true or false)
        while autohatch and chosenEgg do
            remote.PurchaseEgg:InvokeServer(chosenEgg, 1)
            wait(1)
        end
	end
})
pets:AddToggle({  -- Equip Best Pets
	Name = "🐾 Equip Best Pets",
    Default = false,
	Callback = function(Value)
        getfenv().equipBpets = (Value and true or false)
        while equipBpets do
            remote.EquipBestPets:InvokeServer()
            wait(3)
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
