-- loadstring(game:HttpGet("https://raw.githubusercontent.com/illumaware/c/main/pc.lua"))()

--[[
    TODO:
    Auto-Craft
    Auto-Kraken
    Auto-Minigames
    Auto-Hatch Pets
]]--

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "[Pet Catchers] AIO", HidePremium = true, SaveConfig = false, ConfigFolder = "Orion"})

local player = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local main = player:AddSection({
	Name = "Main"
})
local elixrs = player:AddSection({
	Name = "Elixirs"
})

local auto = Window:MakeTab({
	Name = "Automation",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local autobuy = auto:AddSection({
	Name = "Shops"
})
local autoshrines = auto:AddSection({
	Name = "Shrines"
})
local fishing = auto:AddSection({
	Name = "Fishing"
})
local quest = auto:AddSection({
	Name = "Quests"
})

local autofarm = Window:MakeTab({
	Name = "AutoFarm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Estats = autofarm:AddSection({
	Name = "Enemy Stats"
})
local enemynames = Estats:AddLabel("Enemy Name: None")
local enemynum = Estats:AddLabel("No Enemies")
local afmain = autofarm:AddSection({
	Name = "Main"
})

local misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local rstorage = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote
local codes = {"runes", "lucky", "cherry", "cherries", "gravypet", "update1", "russoplays", "release", "void", "ilovefishing", "brite"}
local shrinenames = {"egg", "gem", "cube", "berry", "radioactive", "better-cube", "cherry", "ticket", "rune"}
local vu = game:GetService("VirtualUser")
local slp = game:GetService("Players").LocalPlayer
local sui = slp.PlayerGui.ScreenGui
local lp = game.Players.LocalPlayer.Character.Humanoid
local quests = sui.Quests.List:GetChildren()

slp.Idled:connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)


-- MAIN
local gm = main:AddToggle({  -- Godmode
	Name = "🛡️ Godmode",
	Default = false,
	Callback = function(Value)
        godmode = Value
        if godmode then
            lp.MaxHealth = math.huge
            lp.Health = math.huge
            warn("[Debug] ✅ Enabled Godmode")
            OrionLib:MakeNotification({
                Name = "Godmode",
                Content = "Enabled Godmode",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        else
            lp.MaxHealth = 800
            lp.Health = 800
        end        
    end
})
main:AddDropdown({  -- Teleport
	Name = "🚀 Teleport",
	Default = "",
	Options = {"The Blackmarket", "The Summit", "Magma Basin", "Gloomy Grotto", "Dusty Dunes", "Sunset Shores", "Frosty Peaks", "Auburn Woods", "Mellow Meadows", "Pet Park"},
	Callback = function(Value)
        if Value ~= "The Blackmarket" and Value ~= "The Summit" then
		    rstorage.Event:FireServer("TeleportBeacon", Value, "Spawn")
        else
            rstorage.Event:FireServer("TeleportBeacon", "Magma Basin", Value)
        end
        warn("[Debug] ✅ Teleported to " .. Value)
        OrionLib:MakeNotification({
            Name = "Teleport",
            Content = "Teleported to " .. Value,
            Image = "rbxassetid://4483345998",
            Time = 5
        })
	end
})


-- ELIXIRS
elixrs:AddToggle({  -- Auto-Use Elixir
	Name = "🧪 Auto-Use Elixir",
	Default = false,
	Callback = function(Value)
        AUElixir = Value
        if AUElixir then warn("[Debug] ✅ Enabled Auto-Use Elixir") end    
	end
})
elixrs:AddDropdown({  -- Choose Elixir
	Name = "🧪 Choose Elixir",
	Default = "",
	Options = {"Farm (Coin & XP)","Coin","XP","Lucky","Sea"},
	Callback = function(Value)
		chosenElx = Value
	end
})


-- FISHING
fishing:AddToggle({  -- Auto-Sell Fish
	Name = "🐟 Auto-Sell Fish",
	Default = false,
	Callback = function(Value)
        ASFish = Value
        if ASFish then warn("[Debug] ✅ Enabled Auto-Sell Fish") end
	end
})


-- AUTOBUY
autobuy:AddToggle({  -- Buy Auburn Shop
	Name = "💰 Auto-Buy Auburn Shop",
	Default = false,
	Callback = function(Value)
        ABAuburnShop = Value
        if ABAuburnShop then warn("[Debug] ✅ Enabled Auto-Buy Auburn Shop") end
	end
})
autobuy:AddToggle({  -- Buy Magic Shop
	Name = "💰 Auto-Buy Magic Shop",
	Default = false,
	Callback = function(Value)
        ABMagicShop = Value
        if ABMagicShop then warn("[Debug] ✅ Enabled Auto-Buy Magic Shop") end
    end
})
autobuy:AddToggle({  -- Buy Gem Trader
	Name = "💎 Auto-Buy Gem Trader",
	Default = false,
	Callback = function(Value)
        ABGemTrader = Value
        if ABGemTrader then warn("[Debug] ✅ Enabled Auto-Buy Gem Trader") end
	end    
})
autobuy:AddToggle({  -- Buy Blackmarket
	Name = "💎 Auto-Buy Blackmarket",
	Default = false,
	Callback = function(Value)
        ABBlackmarket = Value
        if ABBlackmarket then warn("[Debug] ✅ Enabled Auto-Buy Blackmarket") end
    end
})


-- SHRINES
autoshrines:AddToggle({  -- Auto-Collect Shrines
	Name = "⚱️ Auto-Collect Shrines",
	Default = false,
	Callback = function(Value)
        ACShrines = Value
        if ACShrines then warn("[Debug] ✅ Enabled Auto-Collect shrines") end
	end
})


-- QUESTS
quest:AddToggle({  -- Auto-Claim All Quests
	Name = "📜 Auto-Claim All Quests",
	Default = false,
	Callback = function(Value)
        AClaimQuest = Value
        if AClaimQuest then warn("[Debug] ✅ Enabled Auto-Claim All Quests") end
	end    
})


-- AUTOKILL
afmain:AddToggle({  -- Auto-Kill Enemies
	Name = "⚔️ Auto-Kill Enemies",
	Default = false,
	Callback = function(Value)
        AFkill = Value
        gm:Set(Value)
        if AFkill then
            warn("[Debug] ✅ Enabled Auto-Kill Enemies")
            OrionLib:MakeNotification({
                Name = "Auto-Kill",
                Content = "Enabled Auto-Kill Enemies",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
	end
})


-- MISC
misc:AddLabel("AntiAFK is enabled by default")
misc:AddButton({  -- Redeem All Codes
	Name = "🏷️ Redeem All Codes",
	Callback = function()
        for _, code in pairs(codes) do
            rstorage.Function:InvokeServer("RedeemCode", code)
            wait(.5)
        end
        warn("[Debug] ✅ Redeemed all codes")
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
        sh:Teleport(game.PlaceId)
  	end
})
misc:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function()
        OrionLib:Destroy()
  	end    
})


-- LOGIC
local shrinefix = true
local enemiesKilled = 0

while task.wait() do  -- Toggles Logic
    if AUElixir then
        local CoinDur = sui.Buffs.Treasure.Button.Time.Text
        local XPDur = sui.Buffs.Experienced.Button.Time.Text
        local LuckyDur = sui.Buffs["Feeling Lucky"].Button.Time.Text
        local SeaDur = sui.Buffs["Ocean's Blessing"].Button.Time.Text
        if chosenElx == "Farm (Coin & XP)" then
            if (CoinDur == "0s" or CoinDur == "11m 11s") and (XPDur == "0s" or XPDur == "11m 11s") then
                rstorage.Event:FireServer("UsePowerup", "Coin Elixir")
                rstorage.Event:FireServer("UsePowerup", "XP Elixir")
                warn("[Debug] ✅ Used Coin and XP elixirs")
            end
        elseif chosenElx == "Coin" then
            if CoinDur == "0s" or CoinDur == "11m 11s" then
                rstorage.Event:FireServer("UsePowerup", "Coin Elixir")
                warn("[Debug] ✅ Used Coin elixir")
            end
        elseif chosenElx == "XP" then
            if XPDur == "0s" or XPDur == "11m 11s" then
                rstorage.Event:FireServer("UsePowerup", "XP Elixir")
                warn("[Debug] ✅ Used XP elixir")
            end
        elseif chosenElx == "Lucky" then
            if LuckyDur == "0s" or LuckyDur == "11m 11s" then
                rstorage.Event:FireServer("UsePowerup", "Lucky Elixir")
                warn("[Debug] ✅ Used Lucky elixir")
            end
        elseif chosenElx == "Sea" then
            if SeaDur == "0s" or SeaDur == "11m 11s" then
                rstorage.Event:FireServer("UsePowerup", "Sea Elixir")
                warn("[Debug] ✅ Used Sea elixir")
            end
        end
        wait(1)
    end
    if ACShrines then
        for _, shrine in pairs(shrinenames) do
            local cdText = game:GetService("Workspace").Shrines[shrine].Action.BillboardGui.Cooldown.Text
            if cdText == "0s" or shrinefix then
                rstorage.Event:FireServer("UseShrine", shrine)
                warn("[Debug] ✅ Collected " .. shrine .. " shrine")
                if shrinefix == false then
                    OrionLib:MakeNotification({
                        Name = "Shrines",
                        Content = "Collected " .. shrine .. " shrine",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                end
                wait(1)
            end
        end
        shrinefix = false
    end
    if AClaimQuest then
        for _, questFolder in pairs(quests) do
            if questFolder.Name == "Template" then
                local tasks = questFolder.Tasks:GetChildren()
                local questnames = {"bruh-bounty", "sailor-treasure-hunt"}

                for _, taskFolder in pairs(tasks) do
                    if taskFolder.Name == "Template1" then
                        local titleText = taskFolder.Title.Text
                        if string.find(titleText, "Return") then
                            for _, quest in pairs(questnames) do
                                rstorage.Event:FireServer("FinishedQuestDialog", quest)
                                -- warn("[Debug] ✅ Completed a " .. quest .. " quest")
                                wait(.1)
                            end

                            for i = 1, 30 do
                                local omackaQ = "omacka-" .. i
                                rstorage.Event:FireServer("FinishedQuestDialog", omackaQ)
                                -- warn("[Debug] ✅ Tried to complete " .. omackaQ .. " quest")
                                wait(.1)
                            end
                        end
                    end
                end
            end
        end
        wait(5)
    end
    if ASFish then
        rstorage.Event:FireServer("SellFish")
        wait(.1)
    end
    if ABAuburnShop then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "auburn-shop", i)
            wait(.05)
        end
    end
    if ABMagicShop then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "magic-shop", i)
            wait(.05)
        end
    end
    if ABGemTrader then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "gem-trader", i)
            wait(.05)
        end
    end
    if ABBlackmarket then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "the-blackmarket", i)
            wait(.05)
        end
    end

    -- AUTOFARM
    local enemies = game:GetService("Workspace").Rendered.Enemies:GetChildren()
    if #enemies > 0 then
        local numEnemies = #enemies
        enemynum:Set("Number Of Enemies: " .. numEnemies)
        for _, enemy in ipairs(enemies) do
            enemynames:Set("Enemy Name: " .. enemy.Name)
        end
    else
        enemynum:Set("No Enemies")
        enemynames:Set("Enemy Name: None")
    end
    if AFkill then
        local foundEnemy = false
        for _, enemy in ipairs(enemies) do
            if enemy:FindFirstChild("Hitbox") then
                local hitbox = enemy.Hitbox
                local char = slp.Character
                local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and not foundEnemy then
                    foundEnemy = true
                    OrionLib:MakeNotification({
                        Name = "Auto-Kill",
                        Content = "Found ".. enemy.Name .." in range, teleporting",
                        Image = "rbxassetid://4483345998",
                        Time = 2
                    })
                    wait(1)
                    humanoidRootPart.CFrame = hitbox.CFrame
                    wait(2.5)
                    break
                end        
            end
        end
    end
end


OrionLib:Init()
