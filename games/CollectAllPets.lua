local lib = loadstring(game:HttpGet(('https://github.com/illumaware/c/blob/main/debug/BetterOrion.lua?raw=true')))()
local window = lib:MakeWindow({Name = "[Collect All Pets] AIO", HidePremium = true, SaveConfig = false, IntroEnabled = false})
local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local upgrades = window:MakeTab({ Name = "Upgrades", Icon = "rbxassetid://7743875962" })
local autoeggs = window:MakeTab({ Name = "Eggs", Icon = "rbxassetid://8997385940" })
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })

local lp = game:GetService("Players").LocalPlayer
local sui = lp.PlayerGui.ScreenGui
local replicatedStorage = game:GetService("ReplicatedStorage")
local rRemote = game:GetService("ReplicatedStorage").Remotes
local playerScripts = lp.PlayerScripts
local dropsFolder = workspace.Drops


home:AddToggle({
	Name = "💰 Auto Collect Drops",
	Default = false,
	Callback = function(Value)
        ADrops = Value
        if ADrops then warn("[Debug] ✅ Enabled Auto Collect Drops") end    
	end
})
local areaMap = {
    ["The Meadow"] = 1,
    ["The Forest"] = 2,
    ["The Desert"] = 3,
    ["The Arctic"] = 4,
    ["The Beach"] = 5,
    ["The Mountains"] = 6,
    ["The Jungle"] = 7
}
home:AddDropdown({
    Name = "💎 Auto Farm Area",
    Default = "",
    Options = {"The Meadow", "The Forest", "The Desert", "The Arctic", "The Beach", "The Mountains", "The Jungle"},
    Callback = function(Value)
        chosenMap = areaMap[Value] or ""
        rRemote.OnAreaButton:FireServer(chosenMap)
    end
})
home:AddToggle({
	Name = "📜 Auto Claim Quests",
	Default = false,
	Callback = function(Value)
        AQRewards = Value
        if AQRewards then warn("[Debug] ✅ Enabled Auto Claim Quests") end    
	end
})
local badges = {
    "CrystalsDestroyed",
    "DropsCollected",
    "ExoticCrystalScore",
    "GiantScore",
    "GoldEarned",
    "MetallicScore",
    "PetScore",
    "QuestsCompleted",
    "Rebirths",
    "ShinyGiantScore",
    "ShinyScore"
}
home:AddToggle({
	Name = "🎖️ Auto Claim Badges",
	Default = false,
	Callback = function(Value)
        ABRewards = Value
        if ABRewards then warn("[Debug] ✅ Enabled Auto Claim Badges") end    
	end
})


upgrades:AddToggle({
	Name = "💥 Auto Upgrade Damage",
	Default = false,
	Callback = function(Value)
        ADmg = Value
        if ADmg then warn("[Debug] ✅ Enabled Auto Upgrade Damage") end    
	end
})
upgrades:AddToggle({
	Name = "⚡ Auto Upgrade Speed",
	Default = false,
	Callback = function(Value)
        ASpeed = Value
        if ASpeed then warn("[Debug] ✅ Enabled Auto Upgrade Speed") end    
	end
})
upgrades:AddToggle({
	Name = "🧲 Auto Upgrade Magnet Range",
	Default = false,
	Callback = function(Value)
        ARange = Value
        if ARange then warn("[Debug] ✅ Enabled Auto Upgrade Magnet Range") end    
	end
})
upgrades:AddToggle({
	Name = "💰 Auto Upgrade Drop Rate",
	Default = false,
	Callback = function(Value)
        ADropRate = Value
        if ADropRate then warn("[Debug] ✅ Enabled Auto Upgrade Drop Rate") end    
	end
})


local eggMap = {
    ["[7,500] Common"] = 1,
    ["[35,000] Uncommon"] = 2,
    ["[160,000] Rare"] = 3,
    ["[750,000] Epic"] = 4,
    ["[3,500,000] Legendary"] = 5,
    ["[12,000,000] Prodigious"] = 6
}
autoeggs:AddDropdown({
    Name = "🥚 Choose Egg",
    Default = "",
    Options = {"[7,500] Common", "[35,000] Uncommon", "[160,000] Rare", "[750,000] Epic", "[3,500,000] Legendary", "[12,000,000] Prodigious"},
    Callback = function(Value)
        chosenEgg = eggMap[Value] or ""
    end
})
autoeggs:AddToggle({
	Name = "🥚 Auto Hatch",
	Default = false,
	Callback = function(Value)
        AEggs = Value
        if AEggs then warn("[Debug] ✅ Enabled Auto Hatch") end    
	end
})
autoeggs:AddToggle({
	Name = "Auto Collect Daily Egg",
	Default = false,
	Callback = function(Value)
        ADEgg = Value
        if ADEgg then warn("[Debug] ✅ Enabled Auto Collect Daily Egg") end    
	end
})


misc:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        lib:MakeNotification({ Name = "FPS Booster", Content = "Credits: github.com/fdvll", Image = "rbxassetid://7733911828", Time = 5 })
        wait(1)
        loadstring(game:HttpGet("https://github.com/fdvll/pet-simulator-99/blob/main/cpuReducer.lua?raw=true"))()
  	end
})
misc:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
  	end
})
misc:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        lib:MakeNotification({ Name = "Server Hopping...", Content = "Credits: github.com/LeoKholYt", Image = "rbxassetid://7733911828", Time = 5 })
        wait(1)
        loadstring(game:HttpGet("https://github.com/LeoKholYt/roblox/blob/main/lk_serverhop.lua?raw=true"))():Teleport(game.PlaceId)
  	end
})
misc:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function()
        lib:Destroy()
  	end    
})


while task.wait() do
    if ADrops then
        local scripts = playerScripts:GetChildren()
        for _, script in ipairs(scripts) do
            if script.Name == "Drop" then
                local idValue = script:FindFirstChild("ID")
                local dropSize = script:FindFirstChild("DropSize")
                if idValue and idValue:IsA("IntValue") then
                    local droptable = {[dropSize.Value] = idValue.Value}
                    rRemote.Drop:FireServer(droptable)
                    coroutine.wrap(function() wait(0.1) end)()
                    script:Destroy()
                end
            end
        end
        coroutine.wrap(function() wait(1) end)()
        for _, child in ipairs(dropsFolder:GetChildren()) do
            child:Destroy()
        end    
    end
    if AEggs then
        rRemote.BuyEgg:FireServer(chosenEgg)
    end
    if ADEgg then
        rRemote.ClaimDailyEgg:FireServer()
    end
    if ADmg then
        rRemote.BuyStatIncrease:FireServer("Damage")
    end
    if ASpeed then
        rRemote.BuyStatIncrease:FireServer("Speed")
    end
    if ARange then
        rRemote.BuyStatIncrease:FireServer("DropCollectionRange")
    end
    if ADropRate then
        rRemote.BuyStatIncrease:FireServer("DropRate")
    end
    if AQRewards then
        local rew = sui.Main.Top.QuestFrame.Checkmark.Check
        if rew.Visible then
            rRemote.ClaimQuestReward:FireServer()
        end
    end
    if ABRewards then
        for _, badge in ipairs(badges) do
            rRemote.UnlockBadge:FireServer(badge)
        end
    end
end
lib:Init()
