--[[
    TODO:
    Auto Minigames
    Auto Catch pets
    Auto Orbs

    Fix Auto Fish

    Add walk and teleport farm type to auto kill
    Add teleports to npcs + quests + shops
]]--

repeat task.wait()until game:IsLoaded()
local lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/illumaware/c/main/debug/BetterOrion.lua')))()
local window = lib:MakeWindow({Name = "[Pet Catchers] AIO", HidePremium = true, SaveConfig = false, ConfigFolder = "AIO_PetCatchers"})


--[[ Home ]]--
local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local hmain = home:AddSection({ Name = "Main" })
local welcome = hmain:AddParagraph("Welcome to AIO", "v2.3 [stable]")
local notifyevents = hmain:AddLabel("🎉 No current Events")
local newcodelabel = hmain:AddLabel("🏷️ No new codes Available")
local sessStats = home:AddSection({ Name = "Session Stats" })
local enemycount = sessStats:AddLabel("⚔️ Enemies Killed: 0 [Total: 0]")
local eggstats = sessStats:AddLabel("🥚 Eggs Hatched: 0 [Total: 0]")

--[[ Player ]]--
local player = window:MakeTab({ Name = "Player", Icon = "rbxassetid://7743875962" })
local main = player:AddSection({ Name = "Main" })
local teleports = player:AddSection({ Name = "Teleports" })
local powerups = player:AddSection({ Name = "Powerups" })

--[[ Automation ]]--
local auto = window:MakeTab({ Name = "Automation", Icon = "rbxassetid://7733942651" })
local autobuy = auto:AddSection({ Name = "Shops" })
local autoshrines = auto:AddSection({ Name = "Shrines" })
local fishing = auto:AddSection({ Name = "Fishing" })
local quest = auto:AddSection({ Name = "Quests" })

--[[ Farming ]]--
local autofarm = window:MakeTab({ Name = "Farming", Icon = "rbxassetid://7733674079" })
local afmobs = autofarm:AddSection({ Name = "Mobs" })
local enemynames = afmobs:AddLabel("Enemy Name: None")
local enemynum = afmobs:AddLabel("No Enemies")
local afkraken = autofarm:AddSection({ Name = "Kraken" })
local krakentimer = afkraken:AddLabel("🐙 Kraken is not available")
local afkingslime = autofarm:AddSection({ Name = "King Slime" })
local slimetimer = afkingslime:AddLabel("🦠 King Slime is not available")

--[[ Crafting ]]--
local autocrafting = window:MakeTab({ Name = "Crafting", Icon = "rbxassetid://7743878358" })
local ACslot1 = autocrafting:AddSection({ Name = "Slot 1" })
local ACslot2 = autocrafting:AddSection({ Name = "Slot 2" })
local ACslot3 = autocrafting:AddSection({ Name = "Slot 3" })

--[[ Eggs ]]--
local autoeggs = window:MakeTab({ Name = "Eggs", Icon = "rbxassetid://8997385940" })
local agmain = autoeggs:AddSection({ Name = "Main" })

--[[ Misc ]]--
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })
local mgui = misc:AddSection({ Name = "Render" })
local mother = misc:AddSection({ Name = "Other" })



--[[ VARIABLES ]]--
local rstorage = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote
local all_events = {"Boss Rush", "Lucky", "Fortune", "Mob Rush", "Quick Fishing", "Treasure", "Shiny Hunt", "Master Chef", "Gamer"}
local shrinesModule = require(game:GetService("ReplicatedStorage").Shared.Data.Shrines)
local vu = game:GetService("VirtualUser")
local slp = game:GetService("Players").LocalPlayer
local ws = game:GetService("Workspace")
local sui = slp.PlayerGui.ScreenGui
local aio = sui.v if aio then aio.Text = "aio.vip" end
local lp = slp.Character.Humanoid
local quests = sui.Quests.List:GetChildren()
local sGuiHolder = slp.PlayerGui.ScreenGuiHolder
local function textToNumber(text) return tonumber(text:gsub(",", ""):match("%d+")) end
local totalNumberPath = sui.Debug.Stats.Frame.List.EnemiesDefeated.Total
local previousTotalNumber = textToNumber(totalNumberPath.Text)
local sessionCount, eggsSession = 0, 0
local eggsHatchedPath = slp.leaderstats["🥚 Hatched"]
local previouseggsHatchedNumber = eggsHatchedPath.Value
local codesModule = require(game:GetService("ReplicatedStorage").Shared.Data.Codes)

--[[ FUNCTIONS ]]--
slp.Idled:connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end)  -- AntiAFK

local function notify(name, content)  -- Notifications
    lib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://7733911828",
        Time = 5
    })
end

local function redeemNewCode()  -- Redeem New Codes
    local foundCgui = nil

    for _, surfaceGui in pairs(sGuiHolder:GetChildren()) do
        if surfaceGui:IsA("SurfaceGui") then
            local frame = surfaceGui:FindFirstChild("Frame")
            if frame then
                local code = frame:FindFirstChild("Code")
                if code and code:IsA("TextLabel") then
                    foundCgui = surfaceGui
                    break
                end
            end
        end
    end

    if foundCgui then
        local newcode = foundCgui.Frame.Code.Text
        local cleanednewcode = newcode:sub(2, -2)
        rstorage.Function:InvokeServer("RedeemCode", cleanednewcode)
        newcodelabel:Set("🏷️ Redeemed New Code: " ..cleanednewcode)
        notify("New Code", "Redeemed: " .. cleanednewcode)
    end
end
redeemNewCode()

local function updateEnemyCountLabel()  -- Enemy Count Label Updater
    local currentTotalNumber = textToNumber(totalNumberPath.Text)
    local enemiesKilledThisSession = currentTotalNumber - previousTotalNumber
    sessionCount = sessionCount + enemiesKilledThisSession
    local totalNumber = currentTotalNumber
    enemycount:Set("⚔️ Enemies Killed: " .. sessionCount .. " [Total: " .. totalNumber .. "]")
end
updateEnemyCountLabel()

local function updateEnemyCount()
    local currentTotalNumber = textToNumber(totalNumberPath.Text)
    if currentTotalNumber ~= previousTotalNumber then
        updateEnemyCountLabel()
        previousTotalNumber = currentTotalNumber
    end
end

local function updateEnemies()
    local enemies = ws.Rendered.Enemies:GetChildren()
    if #enemies > 0 then
        local numEnemies = #enemies
        local uniqueEnemyNames = {}
        for _, enemy in ipairs(enemies) do
            if enemy.Name ~= "Snowball" then
                uniqueEnemyNames[enemy.Name] = true
            end
        end

        local enemyNameString = "None"
        for enemyName, _ in pairs(uniqueEnemyNames) do
            if enemyNameString == "None" then
                enemyNameString = enemyName
            else
                enemyNameString = enemyNameString .. ", " .. enemyName
            end
        end

        enemynum:Set("Number of Enemies: " .. numEnemies)
        enemynames:Set("Enemy Name: " .. enemyNameString)
    else
        enemynum:Set("No Enemies")
        enemynames:Set("Enemy Name: None")
    end
end

local function updateEggsCountLabel()  -- Eggs Count Label Updater
    local currentEggsNumber = eggsHatchedPath.Value
    local eggsHatchedThisSession = currentEggsNumber - previouseggsHatchedNumber
    eggsSession = eggsSession + eggsHatchedThisSession
    local eggsTotalNumber = currentEggsNumber
    eggstats:Set("🥚 Eggs Hatched: " .. eggsSession .. " [Total: " .. eggsTotalNumber .. "]")
end
updateEggsCountLabel()

local function updateEggsCount()
    local currentEggsNumber = eggsHatchedPath.Value
    if currentEggsNumber ~= previouseggsHatchedNumber then
        updateEggsCountLabel()
        previouseggsHatchedNumber = currentEggsNumber
    end
end

local function checkEvents()  -- Events Label Updater
    local server_event_path = sui.HUD.Top.Event.Title.Text
    local server_event_timer_path = sui.HUD.Top.Event.Timer.Text
    local event_found = false

    for _, event in pairs(all_events) do
        if string.find(server_event_path, event) and server_event_timer_path ~= "Ends in 0 seconds" then
            notifyevents:Set("🎉 Current Event: " .. event .. " [" .. server_event_timer_path .. "]")
            event_found = true
            break
        end
    end

    if not event_found then
        notifyevents:Set("🎉 No current Events")
    end
end
checkEvents()

local function checkKrakenBoss()  -- Kraken Boss Updater
    local krakencooldown = ws.Bosses["the-kraken"].Display.SurfaceGui.BossDisplay.Cooldown
    if krakencooldown and krakencooldown.Visible then
        local krakenbosstimer = krakencooldown.Title.Text
        krakentimer:Set("🐙 Kraken: " .. krakenbosstimer)
    else
        krakentimer:Set("🐙 Kraken: ✅ Ready")
    end
end
checkKrakenBoss()

local function checkSlimeBoss()  -- Slime Boss Updater
    local slimecooldown = ws.Bosses["king-slime"].Display.SurfaceGui.BossDisplay.Cooldown
    if slimecooldown and slimecooldown.Visible then
        local slimebosstimer = slimecooldown.Title.Text
        slimetimer:Set("🦠 King Slime: " .. slimebosstimer)
    else
        slimetimer:Set("🦠 King Slime: ✅ Ready")
    end
end
checkSlimeBoss()

local function redeemAllCodes()  -- Redeem All Codes
    for code, _ in pairs(codesModule) do
        rstorage.Function:InvokeServer("RedeemCode", code)
        wait(0.5)
    end
    notify("Codes", "Redeemed All Codes")
end

local function autoBuyShopItems(shopName)  -- Auto Buy Shops
    for i = 1, 3 do
        rstorage.Event:FireServer("BuyShopItem", shopName, i)
    end
end



--[[ PLAYER TAB ]]--
local gm = main:AddToggle({  -- Godmode
	Name = "🛡️ Godmode",
	Default = false,
	Callback = function(Value)
        godmode = Value
        if godmode then
            lp.MaxHealth = math.huge
            lp.Health = math.huge
            warn("[Debug] ✅ Enabled Godmode")
            notify("Godmode", "Enabled Godmode")
        else
            lp.MaxHealth = 800
            lp.Health = 800
        end
    end
})
teleports:AddDropdown({  -- Regions Teleport
	Name = "🚀 Regions",
	Default = "",
	Options = {"The Blackmarket", "The Summit", "Magma Basin", "Gloomy Grotto", "Dusty Dunes", "Sunset Shores", "Frosty Peaks", "Auburn Woods", "Mellow Meadows", "Pet Park"},
	Callback = function(Value)
        if Value ~= "The Blackmarket" and Value ~= "The Summit" then
		    rstorage.Event:FireServer("TeleportBeacon", Value, "Spawn")
        else
            rstorage.Event:FireServer("TeleportBeacon", "Magma Basin", Value)
        end
        warn("[Debug] ✅ Teleported to " .. Value)
        notify("Teleport", "Teleported to " .. Value)
	end
})
teleports:AddDropdown({  -- Shops Teleport
    Name = "🏪 Shops",
    Default = "",
    Options = {"💰 Auburn Shop", "💰 Magic Shop", "💎 Gem Trader", "💎 Blackmarket"},
    Callback = function(Value)
        if Value == "💰 Auburn Shop" then
            slp.Character:MoveTo(game.Workspace.Activations["auburn-shop"].Root.Position)
        elseif Value == "💰 Magic Shop" then
            slp.Character:MoveTo(game.Workspace.Activations["magic-shop"].Root.Position)
        elseif Value == "💎 Gem Trader" then
            slp.Character:MoveTo(game.Workspace.Activations["gem-trader"].Root.Position)
        elseif Value == "💎 Blackmarket" then
            slp.Character:MoveTo(game.Workspace.Activations["the-blackmarket"].Root.Position)
        end
        warn("[Debug] ✅ Teleported to " .. Value .. " shop")
        notify("Teleport", "Teleported to " .. Value .. " shop")
    end
})
teleports:AddDropdown({  -- Bosses Teleport
    Name = "⚔️ Bosses",
    Default = "",
    Options = {"🐙 Kraken", "🦠 King Slime"},
    Callback = function(Value)
        if Value == "🐙 Kraken" then
            slp.Character:MoveTo(game.Workspace.Bosses["the-kraken"].Gate.Activation.Root)
        elseif Value == "🦠 King Slime" then
            slp.Character:MoveTo(game.Workspace.Bosses["king-slime"].Gate.Activation.Root)
        end
        warn("[Debug] ✅ Teleported to " .. Value .. " boss")
        notify("Teleport", "Teleported to " .. Value .. " boss")
    end
})

powerups:AddDropdown({  -- Choose Powerup
	Name = "⚡ Choose Powerup",
	Default = "",
	Options = {"Farm (Coin & XP)", "Coin Elixir", "XP Elixir", "Lucky Elixir", "Super Lucky Elixir", "Sea Elixir", "Timeful Tome"},
	Callback = function(Value)
		chosenPwr = Value
	end
})
powerups:AddToggle({  -- Auto Use Powerups
	Name = "⚡ Auto Use Powerups",
	Default = false,
	Callback = function(Value)
        AUPowerups = Value
        if AUPowerups then warn("[Debug] ✅ Enabled Auto Use Powerups") end
	end
})


--[[ AUTOMATION TAB ]]--
autobuy:AddToggle({  -- Buy Auburn Shop
	Name = "💰 Auto Buy Auburn Shop",
	Default = false,
	Callback = function(Value)
        ABAuburnShop = Value
        if ABAuburnShop then warn("[Debug] ✅ Enabled Auto Buy Auburn Shop") end
	end
})
autobuy:AddToggle({  -- Buy Magic Shop
	Name = "💰 Auto Buy Magic Shop",
	Default = false,
	Callback = function(Value)
        ABMagicShop = Value
        if ABMagicShop then warn("[Debug] ✅ Enabled Auto Buy Magic Shop") end
    end
})
autobuy:AddToggle({  -- Buy Gem Trader
	Name = "💎 Auto Buy Gem Trader",
	Default = false,
	Callback = function(Value)
        ABGemTrader = Value
        if ABGemTrader then warn("[Debug] ✅ Enabled Auto Buy Gem Trader") end
	end
})
autobuy:AddToggle({  -- Buy Blackmarket
	Name = "💎 Auto Buy Blackmarket",
	Default = false,
	Callback = function(Value)
        ABBlackmarket = Value
        if ABBlackmarket then warn("[Debug] ✅ Enabled Auto Buy Blackmarket") end
    end
})

autoshrines:AddToggle({  -- Auto Collect Shrines
	Name = "⚱️ Auto Collect Shrines",
	Default = false,
	Callback = function(Value)
        ACShrines = Value
        if ACShrines then warn("[Debug] ✅ Enabled Auto Collect shrines") end
	end
})

fishing:AddSlider({  -- Auto Fish Delay
	Name = "Casting Delay (Stable = 2.7)",
	Min = 2.68,
	Max = 2.75,
	Default = 2.70,
	Color = Color3.fromRGB(55,55,55),
	Increment = 0.01,
	ValueName = "s",
	Callback = function(Value)
        fishingDelay = tonumber(Value)
	end
})
fishing:AddToggle({  -- Auto Fish
	Name = "🐟 Auto Fish",
	Default = false,
	Callback = function(Value)
        AFish = Value
        if AFish then warn("[Debug] ✅ Enabled Auto Fish") end
	end
})
fishing:AddToggle({  -- Auto Sell Fish
	Name = "🐟 Auto Sell Fish",
	Default = false,
	Callback = function(Value)
        ASFish = Value
        if ASFish then warn("[Debug] ✅ Enabled Auto Sell Fish") end
	end
})

quest:AddToggle({  -- Auto Claim All Quests
	Name = "📜 Auto Claim All Quests",
	Default = false,
	Callback = function(Value)
        AClaimQuest = Value
        if AClaimQuest then warn("[Debug] ✅ Enabled Auto Claim All Quests") end
	end
})


--[[ FARMING TAB ]]--
afmobs:AddToggle({  -- Auto Kill Mobs
	Name = "⚔️ Auto Kill Mobs",
	Default = false,
	Callback = function(Value)
        AFkill = Value
        if AFkill then
            gm:Set(true)
            warn("[Debug] ✅ Enabled Auto Kill Mobs")
            notify("Auto Kill", "Enabled Auto Kill Mobs")
        end
	end
})

afkraken:AddTextbox({  -- Kraken LVL
	Name = "🐙 Kraken Level (0 = Max)",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
		chosenkrakenlvl = tonumber(Value)
	end
})
afkraken:AddToggle({  -- Auto Kill Kraken
	Name = "🐙 Auto Kill Kraken",
	Default = false,
	Callback = function(Value)
        AFkraken = Value
        if AFkraken then
            warn("[Debug] ✅ Enabled Auto Kill Kraken")
            notify("Auto Kill", "Enabled Auto Kill Kraken")
        end
	end
})
afkraken:AddToggle({  -- Auto Use Tome For Kraken
	Name = "Use Respawn Tome",
	Default = false,
	Callback = function(Value)
        AURTkraken = Value
        if AURTkraken then
            warn("[Debug] ✅ Enabled Use Respawn Tome For Kraken")
        end
	end
})

afkingslime:AddTextbox({  -- King Slime LVL
	Name = "🦠 King Slime Level (0 = Max)",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
		chosenslimelvl = tonumber(Value)
	end
})
afkingslime:AddToggle({  -- Auto Kill King Slime
	Name = "🦠 Auto Kill King Slime",
	Default = false,
	Callback = function(Value)
        AFslime = Value
        if AFslime then
            warn("[Debug] ✅ Enabled Auto Kill King Slime")
            notify("Auto Kill", "Enabled Auto Kill King Slime")
        end
	end
})
afkingslime:AddToggle({  -- Auto Use Tome For King Slime
	Name = "Use Respawn Tome",
	Default = false,
	Callback = function(Value)
        AURTkingslime = Value
        if AURTkingslime then
            warn("[Debug] ✅ Enabled Use Respawn Tome For King Slime")
        end
	end
})


--[[ CRAFTING TAB ]]--
local craftingMap = {
    ["Sea Elixir"] = "sea-elixir",
    ["Legendary Cube"] = "legendary-cube",
    ["Elite Mystery Egg"] = "elite-mystery-egg",
    ["XP Elixir"] = "xp-elixir",
    ["Epic Cube"] = "epic-cube",
    ["Coin Elixir"] = "coin-elixir",
    ["Mystery Egg"] = "mystery-egg",
    ["Rare Cube"] = "rare-cube"
}
local activeslot1 = false local activeslot2 = false local activeslot3 = false
ACslot1:AddDropdown({  -- [Slot 1] Choose Item
    Name = "Choose Item",
    Default = "",
    Options = {"Sea Elixir", "Coin Elixir", "XP Elixir", "Legendary Cube", "Epic Cube", "Elite Mystery Egg", "Mystery Egg", "Rare Cube"},
    Callback = function(Value)
        chosenACItem1 = craftingMap[Value] or ""
    end
})
ACslot1:AddTextbox({  -- [Slot 1] Amount
	Name = "Amount",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
		chosenACAmount1 = tonumber(Value)
	end
})
ACslot1:AddToggle({  -- [Slot 1] Auto Craft
	Name = "🛠️ Auto Craft",
	Default = false,
	Callback = function(Value)
        activeslot1 = Value
        if activeslot1 then warn("[Debug] ✅ Enabled Auto Craft [Slot 1]") end
	end
})
ACslot2:AddDropdown({  -- [Slot 2] Choose Item To Craft
    Name = "Choose Item",
    Default = "",
    Options = {"Sea Elixir", "Coin Elixir", "XP Elixir", "Legendary Cube", "Epic Cube", "Elite Mystery Egg", "Mystery Egg", "Rare Cube"},
    Callback = function(Value)
        chosenACItem2 = craftingMap[Value] or ""
    end
})
ACslot2:AddTextbox({  -- [Slot 2] Amount
	Name = "Amount",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
		chosenACAmount2 = tonumber(Value)
	end
})
ACslot2:AddToggle({  -- [Slot 2] Auto Craft
	Name = "🛠️ Auto Craft",
	Default = false,
	Callback = function(Value)
        activeslot2 = Value
        if activeslot2 then warn("[Debug] ✅ Enabled Auto Craft [Slot 2]") end
	end
})
ACslot3:AddDropdown({  -- [Slot 3] Choose Item To Craft
    Name = "Choose Item",
    Default = "",
    Options = {"Sea Elixir", "Coin Elixir", "XP Elixir", "Legendary Cube", "Epic Cube", "Elite Mystery Egg", "Mystery Egg", "Rare Cube"},
    Callback = function(Value)
        chosenACItem3 = craftingMap[Value] or ""
    end
})
ACslot3:AddTextbox({  -- [Slot 3] Amount
	Name = "Amount",
	Default = "",
	TextDisappear = false,
	Callback = function(Value)
		chosenACAmount3 = tonumber(Value)
	end
})
ACslot3:AddToggle({  -- [Slot 3] Auto Craft
	Name = "🛠️ Auto Craft",
	Default = false,
	Callback = function(Value)
        activeslot3 = Value
        if activeslot3 then warn("[Debug] ✅ Enabled Auto Craft [Slot 3]") end
	end
})


--[[ EGGS TAB ]]--
agmain:AddDropdown({  -- Choose Egg
    Name = "🥚 Choose Egg",
    Default = "Elite Mystery Egg",
    Options = {"Elite Mystery Egg", "Mystery Egg"},
    Callback = function(Value)
        chosenEgg = Value
    end
})
agmain:AddToggle({  -- Auto Hatch
	Name = "🥚 Auto Hatch",
	Default = false,
	Callback = function(Value)
        autohatch = Value
        if autohatch then warn("[Debug] ✅ Enabled Auto Hatch") end
	end
})


--[[ MISC TAB ]]--
mgui:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        notify("FPS Booster", "Credits: github.com/fdvll")
        wait(1)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/cpuReducer.lua"))()
  	end
})
mgui:AddToggle({  -- Disable Snow
	Name = "❄️ Disable Snow",
	Default = false,
	Callback = function(Value)
        snowStatus = Value
        if snowStatus then
            ws.Rendered.Snow.ParticleEmitter.Enabled = false
        else
            ws.Rendered.Snow.ParticleEmitter.Enabled = true
        end
	end
})
mother:AddButton({  -- Redeem All Codes
	Name = "🏷️ Redeem All Codes",
	Callback = redeemAllCodes
})
mother:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        notify("Rejoin", "Rejoining...")
        wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, slp)
  	end
})
mother:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        local sh = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()
        notify("Server Hopping...", "Credits: github.com/LeoKholYt")
        wait(1)
        sh:Teleport(game.PlaceId)
  	end
})
mother:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function()
        lib:Destroy()
  	end
})

-- LOGIC
while task.wait() do
    if AUPowerups then
        local CoinDur = sui.Buffs.Treasure
        local XPDur = sui.Buffs.Experienced
        local LuckyDur = sui.Buffs["Feeling Lucky"]
        local SuperLuckyDur = sui.Buffs["Super Lucky"]
        local SeaDur = sui.Buffs["Ocean's Blessing"]
        local TimefulDur = sui.Buffs.Stopwatch
        if chosenPwr == "Farm (Coin & XP)" then
            if not CoinDur.Visible and not XPDur.Visible then
                rstorage.Event:FireServer("UsePowerup", "Coin Elixir")
                rstorage.Event:FireServer("UsePowerup", "XP Elixir")
                notify("Powerups", "Used Coin and XP Elixirs")
            end
        elseif chosenPwr == "Coin Elixir" then
            if not CoinDur.Visible then
                rstorage.Event:FireServer("UsePowerup", "Coin Elixir")
                notify("Powerups", "Used Coin Elixir")
            end
        elseif chosenPwr == "XP Elixir" then
            if not XPDur.Visible then
                rstorage.Event:FireServer("UsePowerup", "XP Elixir")
                notify("Powerups", "Used XP Elixir")
            end
        elseif chosenPwr == "Lucky Elixir" then
            if not LuckyDur.Visible then
                rstorage.Event:FireServer("UsePowerup", "Lucky Elixir")
                notify("Powerups", "Used Lucky Elixir")
            end
        elseif chosenPwr == "Super Lucky Elixir" then
            if not SuperLuckyDur.Visible then
                rstorage.Event:FireServer("UsePowerup", "Super Lucky Elixir")
                notify("Powerups", "Used Super Lucky Elixir")
            end
        elseif chosenPwr == "Sea Elixir" then
            if not SeaDur.Visible then
                rstorage.Event:FireServer("UsePowerup", "Sea Elixir")
                notify("Powerups", "Used Sea Elixir")
            end
        elseif chosenPwr == "Timeful Tome" then
            if not TimefulDur.Visible then
                rstorage.Event:FireServer("UsePowerup", "Timeful Tome")
                notify("Powerups", "Used Timeful Tome")
            end
        end
        wait(1)
    end
    if ACShrines then
        for shrine, _ in pairs(shrinesModule) do
            local shrinePrompt = ws.Shrines[shrine].Action:FindFirstChild("ProximityPrompt")
            if shrinePrompt and shrinePrompt.Enabled then
                rstorage.Event:FireServer("UseShrine", shrine)
                notify("Shrines", "Collected " .. shrine .. " shrine")
                wait(1)
            end
        end
    end
    if AClaimQuest then
        local questnames = {"bruh-bounty", "sailor-treasure-hunt"}
        for _, quest in pairs(questnames) do
            rstorage.Event:FireServer("FinishedQuestDialog", quest)
            wait(1)
        end
    end
    if AFish then
        if slp then
            rstorage.Event:FireServer("StartCastFishing")
            wait(fishingDelay)
        end
    end
    if ASFish then
        rstorage.Event:FireServer("SellFish")
        wait(.1)
    end

    checkKrakenBoss()
    if AFkraken then
        local krakenAFcooldown = ws.Bosses["the-kraken"].Display.SurfaceGui.BossDisplay.Cooldown
        local player = game.Players.LocalPlayer
        local currentPos = player.Character and player.Character.HumanoidRootPart.Position
        if not krakenAFcooldown.Visible then
            local krakenlvlTextPath = sui.Debug.Stats.Frame.List.BossesDefeated.Extra["the-kraken"].Total.Text
            local krakenLVL
            if chosenkrakenlvl == 0 then
                krakenLVL = tonumber(krakenlvlTextPath:match("%d+"))
            else
                krakenLVL = chosenkrakenlvl
            end
            wait(1)
            rstorage.Function:InvokeServer("BossRequest", "the-kraken", krakenLVL)
            warn("[Debug] ✅🐙 Spawned Kraken [Level: " .. krakenLVL .. "]")
            notify("Auto Kill", "Spawned Kraken [Level: " .. krakenLVL .. "]")
            if currentPos then
                wait(2)
                player.Character:MoveTo(currentPos)
            end
            warn("[Debug] ⚔️🐙 Kraken Battle Started")
            repeat
                wait(1)
            until krakenAFcooldown.Visible
            warn("[Debug] 🏆🐙 Defeated Kraken")
            notify("Auto Kill", "Defeated Kraken")
            wait(3)
        end
        wait(1)
        if AURTkraken then
            rstorage.Event:FireServer("RespawnBoss", "the-kraken")
        end
        wait(3)
    end

    checkSlimeBoss()
    if AFslime then
        local slimeAFcooldown = ws.Bosses["king-slime"].Display.SurfaceGui.BossDisplay.Cooldown
        local player = game.Players.LocalPlayer
        local currentPos = player.Character and player.Character.HumanoidRootPart.Position
        if not slimeAFcooldown.Visible then
            local slimelvlTextPath = sui.Debug.Stats.Frame.List.BossesDefeated.Extra["king-slime"].Total.Text
            local slimeLVL
            if chosenslimelvl == 0 then
                slimeLVL = tonumber(slimelvlTextPath:match("%d+"))
            else
                slimeLVL = chosenslimelvl
            end
            wait(1)
            rstorage.Function:InvokeServer("BossRequest", "king-slime", slimeLVL)
            warn("[Debug] ✅🦠 Spawned King Slime [Level: " .. slimeLVL .. "]")
            notify("Auto Kill", "Spawned King Slime [Level: " .. slimeLVL .. "]")
            if currentPos then
                wait(2)
                player.Character:MoveTo(currentPos)
            end
            warn("[Debug] ⚔️🦠 King Slime Battle Started")
            repeat
                wait(1)
            until slimeAFcooldown.Visible
            warn("[Debug] 🏆🦠 Defeated King Slime")
            notify("Auto Kill", "Defeated King Slime")
        end
        wait(1)
        if AURTkingslime then
            rstorage.Event:FireServer("RespawnBoss", "king-slime")
        end
        wait(3)
    end

    if ABAuburnShop then
        autoBuyShopItems("auburn-shop")
    end
    if ABMagicShop then
        autoBuyShopItems("magic-shop")
    end
    if ABGemTrader then
        autoBuyShopItems("gem-trader")
    end
    if ABBlackmarket then
        autoBuyShopItems("the-blackmarket")
    end

    updateEnemies()
    updateEggsCount()
    updateEnemyCount()

    if AFkill then
        local foundEnemy = false
        for _, enemy in ipairs(enemies) do
            if enemy:FindFirstChild("Hitbox") then
                local hitbox = enemy.Hitbox
                local char = slp.Character
                local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and not foundEnemy then
                    foundEnemy = true
                    notify("Auto Kill", "Found ".. enemy.Name .." in range, teleporting")
                    wait(1)
                    humanoidRootPart.CFrame = hitbox.CFrame
                    wait(2.5)
                    break
                end
            end
        end
    end

    if activeslot1 then
        rstorage.Event:FireServer("StartCrafting", 1, chosenACItem1, chosenACAmount1)
        wait(1)
        rstorage.Event:FireServer("ClaimCrafting", 1)
    end
    if activeslot2 then
        rstorage.Event:FireServer("StartCrafting", 2, chosenACItem2, chosenACAmount2)
        wait(1)
        rstorage.Event:FireServer("ClaimCrafting", 2)
    end
    if activeslot3 then
        rstorage.Event:FireServer("StartCrafting", 3, chosenACItem3, chosenACAmount3)
        wait(1)
        rstorage.Event:FireServer("ClaimCrafting", 3)
    end

    if autohatch then
        rstorage.Function:InvokeServer("TryHatchEgg", chosenEgg)
        wait(.01)
    end

    checkEvents()
end

lib:Init()
