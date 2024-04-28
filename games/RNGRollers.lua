local lib = loadstring(game:HttpGet('https://github.com/illumaware/c/blob/main/debug/BetterOrion.lua?raw=true'))()
local window = lib:MakeWindow({Name = "[RNG Rollers] AIO", HidePremium = true, SaveConfig = false, IntroEnabled = false})

local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local main = home:AddSection({ Name = "Main" })

local upgrades = window:MakeTab({ Name = "Upgrades", Icon = "rbxassetid://7733673717" })
local upgradesT1 = upgrades:AddSection({ Name = "Tier 1" })
local upgradesT2 = upgrades:AddSection({ Name = "Tier 2" })
local upgradesT3 = upgrades:AddSection({ Name = "Tier 3" })

local potions = window:MakeTab({ Name = "Potions", Icon = "rbxassetid://7733674922" })
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })

local function notify(name,content) lib:MakeNotification({ Name = name, Content = content, Image = "rbxassetid://7733911828", Time = 5 }) end  -- Notifications
local slp = game:GetService("Players").LocalPlayer
local rstorage = game:GetService("ReplicatedStorage")
local remote = rstorage.Remotes

local potionsMap = {
    ["Basic Tier 1"] = 1,
    ["Basic Tier 2"] = 2,
    ["Basic Tier 3"] = 3,
    ["Crown Tier 1"] = 4,
    ["Crown Tier 2"] = 5,
    ["Crown Tier 3"] = 6
}
local potionEffects = {
    {["Multi"] = 2, ["Time"] = 180, ["Type"] = "Luck"},
    {["Multi"] = 2, ["Time"] = 270, ["Type"] = "Luck"},
    {["Multi"] = 2, ["Time"] = 360, ["Type"] = "Luck"},
    {["Multi"] = 2.25, ["Time"] = 180, ["Type"] = "Luck"},
    {["Multi"] = 2.25, ["Time"] = 270, ["Type"] = "Luck"},
    {["Multi"] = 2.25, ["Time"] = 360, ["Type"] = "Luck"},
    {["Multi"] = 2, ["Time"] = 180, ["Type"] = "Gold"},
    {["Multi"] = 2, ["Time"] = 270, ["Type"] = "Gold"},
    {["Multi"] = 2, ["Time"] = 360, ["Type"] = "Gold"},
    {["Multi"] = 2.25, ["Time"] = 180, ["Type"] = "Gold"},
    {["Multi"] = 2.25, ["Time"] = 270, ["Type"] = "Gold"},
    {["Multi"] = 2.25, ["Time"] = 360, ["Type"] = "Gold"},
    {["Multi"] = 1.45, ["Time"] = 180, ["Type"] = "Speed"},
    {["Multi"] = 1.45, ["Time"] = 270, ["Type"] = "Speed"},
    {["Multi"] = 1.45, ["Time"] = 360, ["Type"] = "Speed"},
    {["Multi"] = 1.5, ["Time"] = 180, ["Type"] = "Speed"},
    {["Multi"] = 1.5, ["Time"] = 270, ["Type"] = "Speed"},
    {["Multi"] = 1.5, ["Time"] = 360, ["Type"] = "Speed"}
}

local function luckShards() while task.wait() do remote.LuckShards.Collect:FireServer() end end task.spawn(luckShards)
local function autoUpgrade(tName, uType)
    return {
        Name = tName,
        Default = false,
        Callback = function(Value)
            getfenv()["auto" .. uType] = Value
            if getfenv()["auto" .. uType] then
                while getfenv()["auto" .. uType] do
                    remote.Upgrades.Buy:InvokeServer(uType)
                    wait(.5)
                end
            end
        end
    }
end


main:AddToggle({  -- Auto Roll
	Name = "🎲 Auto Roll",
	Default = false,
	Callback = function(Value)
        getfenv().autoRoll = Value
        if autoRoll then
            notify("Main", "Enabled Auto Roll")
            while autoRoll and task.wait() do
                remote.Dice.Roll:InvokeServer()
            end
        end
	end
})
main:AddToggle({  -- Auto Rebirth
	Name = "🔮 Auto Rebirth",
	Default = false,
	Callback = function(Value)
        getfenv().autoRebirth = Value
        if autoRebirth then
            notify("Main", "Enabled Auto Rebirth")
            while autoRebirth do
                remote.Upgrades.Buy:InvokeServer("Rebirth")
                wait(.1)
            end
        end
	end
})
main:AddToggle({  -- Auto Ascend
	Name = "🔮 Auto Ascend",
	Default = false,
	Callback = function(Value)
        getfenv().autoAscend = Value
        if autoAscend then
            notify("Main", "Enabled Auto Ascend")
            while autoAscend do
                remote.Upgrades.Buy:InvokeServer("Ascend")
                wait(.5)
            end
        end
	end
})
main:AddToggle({  -- Auto Transcend
	Name = "🌀 Auto Transcend",
	Default = false,
	Callback = function(Value)
        getfenv().autoTranscend = Value
        if autoTranscend then
            notify("Main", "Enabled Auto Transcend")
            while autoTranscend do
                remote.Upgrades.Buy:InvokeServer("Transcend")
                wait(.5)
            end
        end
	end
})

--[[ Upgrades ]]--
upgradesT1:AddToggle(autoUpgrade("🍀 Auto Upgrade Luck Multiplier", "LuckMulti"))
upgradesT1:AddToggle(autoUpgrade("🎲 Auto Upgrade Roll Cooldown", "RollCooldown"))
upgradesT1:AddToggle(autoUpgrade("💰 Auto Upgrade Gold Multiplier", "GoldMulti"))
upgradesT2:AddToggle(autoUpgrade("🎲 Auto Upgrade Bulk Roll", "BulkRoll"))
upgradesT2:AddToggle(autoUpgrade("💰 Auto Upgrade Lost Gold Per Rebirth", "LostGoldPerRebirth"))
upgradesT2:AddToggle(autoUpgrade("🏃‍♂️ Auto Upgrade Walk Speed", "WalkSpeed"))
upgradesT3:AddToggle(autoUpgrade("🍀 Auto Upgrade Luck Multiplier 2", "LuckMulti2"))
upgradesT3:AddToggle(autoUpgrade("💰 Auto Upgrade Gold Multiplier 2", "GoldMulti2"))
upgradesT3:AddToggle(autoUpgrade("💰 Auto Upgrade Lost Gold Per Ascend", "LostGoldPerAscend"))

potions:AddDropdown({  -- Choose Potion
    Name = "🧪 Choose Potion",
    Default = "",
    Options = {"Basic Tier 1", "Basic Tier 2", "Basic Tier 3", "Crown Tier 1", "Crown Tier 2", "Crown Tier 3"},
    Callback = function(Value)
        chosenPotion = Value
    end
})
potions:AddToggle({  -- Auto Buy Potions
    Name = "🧪 Auto Buy Potions",
    Default = false,
    Callback = function(Value)
        getfenv().autoBuyPotions = Value
        while autoBuyPotions and chosenPotion ~= nil do
            local potion = potionsMap[chosenPotion]
            if potion then
                remote.Potions.Buy:InvokeServer(potion, 1)
            end
            wait(.5)
        end
    end
})
potions:AddToggle({  -- Hide Opening UI
    Name = "🧪 Hide Opening UI",
    Default = true,
    Callback = function(Value)
        slp.PlayerGui.PotionOpening.Enabled = not Value
    end
})
potions:AddToggle({  -- Auto Delete Bad Potions
    Name = "🧪 Auto Delete Bad Potions",
    Default = false,
    Callback = function(Value)
        getfenv().autoDeletePotions = Value
        while autoDeletePotions do wait(.1)
            for _, effect in ipairs(potionEffects) do
                remote.Potions.Delete:InvokeServer(effect)
            end
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
