getgenv().aioInfo = {ver = "2.5", build = "stable"}

local lib = loadstring(game:HttpGet('https://github.com/illumaware/c/blob/main/debug/BetterOrion.lua?raw=true'))()
local window = lib:MakeWindow({Name = "[Pet Catchers] AIO", HidePremium = true, SaveConfig = true, ConfigFolder = "AIO_VIP", IntroEnabled = false})

--[[ Home ]]--
local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local hmain = home:AddSection({ Name = "Main" })
local welcome = hmain:AddParagraph("Welcome to AIO", "v"..aioInfo.ver.." ["..aioInfo.build.."]")
local currentregion = hmain:AddLabel("🌍 Region: None")
local notifyevents = hmain:AddLabel("🎉 No current Events")
local newcodelabel = hmain:AddLabel("🏷️ Redeemed New Code: None")

--[[ Player ]]--
local player = window:MakeTab({ Name = "Player", Icon = "rbxassetid://7743875962" })
local main = player:AddSection({ Name = "Main" })
local teleports = player:AddSection({ Name = "Teleports" })
local powerups = player:AddSection({ Name = "Powerups" })

--[[ Automation ]]--
local auto = window:MakeTab({ Name = "Automation", Icon = "rbxassetid://7733942651" })
local autobuy = auto:AddSection({ Name = "Shops" })
local autoexchange = auto:AddSection({ Name = "Exchange" })

--[[ Farming ]]--
local autofarm = window:MakeTab({ Name = "Farming", Icon = "rbxassetid://7743872758" })
local afmobs = autofarm:AddSection({ Name = "Mobs" })
local enemycount = afmobs:AddLabel("⚔️ Enemies Killed: 0 [Total: 0]")
local afhypercore = autofarm:AddSection({ Name = "Hyper Core" })
local hypertimer = afhypercore:AddLabel("❤️ Hyper Core is not available")
local afkraken = autofarm:AddSection({ Name = "Kraken" })
local krakentimer = afkraken:AddLabel("🐙 Kraken is not available")
local afkingslime = autofarm:AddSection({ Name = "King Slime" })
local slimetimer = afkingslime:AddLabel("🦠 King Slime is not available")

--[[ Minigames ]]--
local minigames = window:MakeTab({ Name = "Minigames", Icon = "rbxassetid://7733799901" })
local ticketsMg = minigames:AddSection({ Name = "Main" })
local ticketslabel = ticketsMg:AddLabel("🎟️ Tickets: 0")
local fishing = minigames:AddSection({ Name = "Fishing" })

--[[ Crafting ]]--
local autocrafting = window:MakeTab({ Name = "Crafting", Icon = "rbxassetid://7743878358" })
local ACslot1 = autocrafting:AddSection({ Name = "Slot 1" })
local ACslot2 = autocrafting:AddSection({ Name = "Slot 2" })
local ACslot3 = autocrafting:AddSection({ Name = "Slot 3" })

--[[ Pets ]]--
local hatching = window:MakeTab({ Name = "Hatching", Icon = "rbxassetid://8997385940" })
local pets = hatching:AddSection({ Name = "Pets" })
local eggs = hatching:AddSection({ Name = "Eggs" })
local eggstats = eggs:AddLabel("🥚 Eggs Hatched: 0 [Total: 0]")

--[[ Misc ]]--
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })
local mgui = misc:AddSection({ Name = "Render" })
local mOther = misc:AddSection({ Name = "Other" })



--[[ VARIABLES ]]--
local vu = game:GetService("VirtualUser")
local rs = game:GetService("RunService")
local tp = game:GetService("TeleportService")
local http = game:GetService("HttpService")
local ws = game:GetService("Workspace")
local pfs = game:GetService("PathfindingService")
local rstorage = game:GetService("ReplicatedStorage")
local slp = game.Players.LocalPlayer
local sui = slp.PlayerGui.ScreenGui
local chr = slp.Character
local hum = chr.Humanoid
local humRootPart = chr.HumanoidRootPart
local remote = rstorage.Shared.Framework.Network.Remote
local hyperAFcooldown = ws.Bosses["hyper-core"].Display.SurfaceGui.BossDisplay.Cooldown
local slimeAFcooldown = ws.Bosses["king-slime"].Display.SurfaceGui.BossDisplay.Cooldown
local krakenAFcooldown = ws.Bosses["the-kraken"].Display.SurfaceGui.BossDisplay.Cooldown
local eventsModule = require(rstorage.Shared.Data.Events)
local shrinesModule = require(rstorage.Shared.Data.Shrines)
local codesModule = require(rstorage.Shared.Data.Codes)
local chestsModule = require(rstorage.Shared.Data.Chests)
local regionModule = require(rstorage.Client.Region)
local minigameModule = require(rstorage.Client.Minigame)
local localdata = require(rstorage.Client.Framework.Services.LocalData).Get()
local coins, gems, tokens, tickets = localdata.Coins, localdata.Gems, localdata.Tokens, localdata.GoldenTickets

local activations = {
    ["💰 Auburn Shop"] = ws.Activations["auburn-shop"].Root.Position,
    ["💰 Magic Shop"] = ws.Activations["magic-shop"].Root.Position,
    ["💎 Gem Trader"] = ws.Activations["gem-trader"].Root.Position,
    ["💎 Blackmarket"] = ws.Activations["the-blackmarket"].Root.Position,
    ["💎 Talents"] = ws.Activations.talents.Root.Position,
    ["👾 Prize Counter"] = ws.Activations["prize-counter"].Root.Position,
    ["💎 Traveling Merchant"] = ws.Activations["traveling-merchant"].Root.Position
}
local bosses = {
    ["❤️ Hyper Core"] = ws.Bosses["hyper-core"].Gate.Activation.Root.Position,
    ["🐙 Kraken"]     = ws.Bosses["the-kraken"].Gate.Activation.Root.Position,
    ["🦠 King Slime"] = ws.Bosses["king-slime"].Gate.Activation.Root.Position
}
local fishingMap = {
    ["Hyperwave Arcade"] = Vector3.new(1350, 2, -1546),
    ["Magma Basin"]      = Vector3.new(1285, 184, -447),
    ["Gloomy Grotto"]    = Vector3.new(1638, 50, -86),
    ["Dusty Dunes"]      = Vector3.new(1562, 50, 258),
    ["Sunset Shores"]    = Vector3.new(1343, 38, 643),
    ["Frosty Peaks"]     = Vector3.new(717, 70, 575),
    ["Auburn Woods"]     = Vector3.new(769, 22, 1273),
    ["Mellow Meadows"]   = Vector3.new(1036, 22, 1381),
    ["Pet Park"]         = Vector3.new(1189, 10, 1587)
}
local powerupsMap = {
    ["Gamer Elixir"] =       {sui.Buffs.Gamer, "Used Gamer Elixir"},
    ["Token Elixir"] =       {sui.Buffs.Token, "Used Token Elixir"},
    ["Coin Elixir"] =        {sui.Buffs.Treasure, "Used Coin Elixir"},
    ["XP Elixir"] =          {sui.Buffs.Experienced, "Used XP Elixir"},
    ["Lucky Elixir"] =       {sui.Buffs["Feeling Lucky"], "Used Lucky Elixir"},
    ["Super Lucky Elixir"] = {sui.Buffs["Super Lucky"], "Used Super Lucky Elixir"},
    ["Sea Elixir"] =         {sui.Buffs["Ocean's Blessing"], "Used Sea Elixir"},
    ["Timeful Tome"] =       {sui.Buffs.Stopwatch, "Used Timeful Tome"},
    ["Prismatic Sundae"] =   {sui.Buffs.Fortune, "Used Prismatic Sundae"},
    ["Prismatic Elixir"] =   {sui.Buffs["Ultra Lucky"], "Used Prismatic Elixir"}
}
local craftingMap = {
    ["Rare Cube"] = "rare-cube",
    ["Epic Cube"] = "epic-cube",
    ["Legendary Cube"] = "legendary-cube",
    ["Mystery Egg"] = "mystery-egg",
    ["Elite Mystery Egg"] = "elite-mystery-egg",
    ["Coin Elixir"] = "coin-elixir",
    ["XP Elixir"] = "xp-elixir",
    ["Sea Elixir"] = "sea-elixir",
    ["Token Elixir"] = "token-elixir"
}

--[[ FUNCTIONS ]]--
slp.Idled:connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end)  -- AntiAFK
local a=getrawmetatable(game)setreadonly(a,false)local b=a.__namecall;a.__namecall=newcclosure(function(self,...)  -- Godmode
    local c=getnamecallmethod()if c=='TakeDamage'and self:IsDescendantOf(chr)then return end;return b(self,...)
end)
local function notify(name,content) lib:MakeNotification({ Name = name, Content = content, Image = "rbxassetid://7733911828", Time = 5 }) end  -- Notifications
local function formatNumber(number)
    if number >= 1e12 then
        return tostring(math.floor(number/1e12)).."T"
    elseif number >= 1e9 then
        return tostring(math.floor(number/1e9)).."B"
    elseif number >= 1e6 then
        return tostring(math.floor(number/1e6)).."M"
    elseif number >= 1e3 then
        return tostring(math.floor(number/1e3)).."K"
    else
        return tostring(number)
    end
end
function sendEmbed(title)
    local data = {["embeds"] = {{
        ["title"] = "**"..title.."**",
        ["description"] = "**:coin: "..formatNumber(coins).."\n:space_invader: "..formatNumber(tokens).."\n:gem: "..formatNumber(gems).."\n:tickets: "..tickets.."**",
        ["color"] = 13800191, ["footer"] = {["text"] = "aio.vip"}}}}
    local response = request({Url = webURL,Method = "POST",Headers = {["Content-Type"] = "application/json"},Body = http:JSONEncode(data)})
end
local function updLabels()
    local enemies_session, eggs_session = 0, 0
    local enemies_start_total = 0 for _, count in pairs(localdata.Stats.EnemiesDefeated) do enemies_start_total = enemies_start_total + count end
    local eggs_num_path = slp.leaderstats["🥚 Hatched"]
    local eggs_start_total = eggs_num_path.Value
    local se = sui.HUD.Top.Event
    while task.wait() do
        --[[Home]]--
        local region = regionModule.CurrentRegion.Region
        if region then currentregion:Set("🌍 Region: ".. region) end

        local enemies_total, eggs_total = 0, eggs_num_path.Value
        for _, count in pairs(localdata.Stats.EnemiesDefeated) do enemies_total = enemies_total + count end
        if enemies_total and eggs_total then
            local e_k, e_h = enemies_total - enemies_start_total, eggs_total - eggs_start_total
            enemies_session, eggs_session = enemies_session + e_k, eggs_session + e_h
            enemycount:Set("⚔️ Enemies Killed: " .. enemies_session .. " [Total: " .. enemies_total .. "]")
            eggstats:Set("🥚 Eggs Hatched: " .. eggs_session .. " [Total: " .. eggs_total .. "]")
            enemies_start_total, eggs_start_total = enemies_total, eggs_total
        end

        for event, _ in pairs(eventsModule) do
            if se.Visible then if string.find(se.Title.Text, event) then notifyevents:Set("🎉 Current Event: "..event.." ["..se.Timer.Text.."]") end
            else notifyevents:Set("🎉 No current Events") end
        end

        --[[Farming]]--
        if hyperAFcooldown and hyperAFcooldown.Visible then hypertimer:Set("❤️ Hyper Core: " .. hyperAFcooldown.Title.Text) else hypertimer:Set("❤️ Hyper Core: ✅ Ready") end
        if slimeAFcooldown and slimeAFcooldown.Visible then slimetimer:Set("🦠 King Slime: " .. slimeAFcooldown.Title.Text) else slimetimer:Set("🦠 King Slime: ✅ Ready") end
        if krakenAFcooldown and krakenAFcooldown.Visible then krakentimer:Set("🐙 Kraken: " .. krakenAFcooldown.Title.Text) else krakentimer:Set("🐙 Kraken: ✅ Ready") end

        --[[Minigames]]--
        coins,gems,tokens,tickets = localdata.Coins,localdata.Gems,localdata.Tokens,localdata.GoldenTickets
        if tickets then ticketslabel:Set("🎟️ Tickets: "..tickets) end
    end
end task.spawn(updLabels)

local function redeem()
    local sGuiHolder = slp.PlayerGui.ScreenGuiHolder
    for _, surfaceGui in ipairs(sGuiHolder:GetChildren()) do
        if surfaceGui:IsA("SurfaceGui") then
            local frame = surfaceGui:FindFirstChild("Frame")
            local codeLabel = frame and frame:FindFirstChild("Code")
            if codeLabel and codeLabel:IsA("TextLabel") then
                local code = codeLabel.Text:sub(2, -2)
                remote.Function:InvokeServer("RedeemCode", code)
                newcodelabel:Set("🏷️ Redeemed New Code: " .. code)
            end
        end
    end
    for code, _ in pairs(codesModule) do
        remote.Function:InvokeServer("RedeemCode", code)
    end
    for chest, _ in pairs(chestsModule) do
        remote.Event:FireServer("OpenWorldChest", chest)
    end
end redeem()
local function autoBuyShopItems(shopName)
    for i = 1, 4 do
        remote.Event:FireServer("BuyShopItem", shopName, i, 1)
    end
end
local function teleportToRegion(region)
    if region ~= "The Blackmarket" and region ~= "The Summit" then
        remote.Event:FireServer("TeleportBeacon", region, "Spawn")
    else
        remote.Event:FireServer("TeleportBeacon", "Magma Basin", region)
    end
    notify("Teleport", "Teleported to " ..region)
end
local function teleportToActivation(Activation)
    local actPos = activations[Activation]
    if actPos then chr:MoveTo(actPos) notify("Teleport", "Teleported to " .. Activation) end
end
local function teleportToBoss(boss)
    local bossPos = bosses[boss]
    if bossPos then chr:MoveTo(bossPos) notify("Teleport", "Teleported to "..boss.." boss") end
end
local function usePowerups(pwr, dur, notif)
    if not dur.Visible then
        remote.Event:FireServer("UsePowerup", pwr)
        notify("Powerups", notif) wait(1)
    end
end
local function useFarmPowerups()
    local coinDur = sui.Buffs.Treasure
    local xpDur = sui.Buffs.Experienced
    if not coinDur.Visible and not xpDur.Visible then
        remote.Event:FireServer("UsePowerup", "Coin Elixir")
        remote.Event:FireServer("UsePowerup", "XP Elixir")
        notify("Powerups", "Used Coin and XP Elixirs") wait(1)
    end
end
local function useArcadePowerups()
    local gamerDur = sui.Buffs.Gamer
    local tokenDur = sui.Buffs.Token
    local luckyDur = sui.Buffs["Feeling Lucky"]
    if not gamerDur.Visible and not tokenDur.Visible and not luckyDur.Visible then
        remote.Event:FireServer("UsePowerup", "Gamer Elixir")
        remote.Event:FireServer("UsePowerup", "Token Elixir")
        remote.Event:FireServer("UsePowerup", "Lucky Elixir")
        notify("Powerups", "Used Gamer, Token and Lucky Elixirs") wait(1)
    end
end
local function startFishing()
    local fishingRod = ws:FindFirstChild(slp.Name):FindFirstChild("FishingRod")
    if humRootPart and humRootPart.Anchored then humRootPart.Anchored = false end
    if fishingRod then fishingRod:Destroy() end
    local rodLevel = localdata.PurchasedRods[1]
    local fdelay = (rodLevel == 6 and 2.48) or (rodLevel == 5 and 2.7) or (rodLevel == 4 and 3) or (rodLevel == 3 and 3.5)
    if fdelay then
        remote.Event:FireServer("StartCastFishing") wait(fdelay)
    end
end
local function findEnemy(folder)
    if not folder or not AFkill then return end
    for _, idFolder in ipairs(folder:GetChildren()) do
        if idFolder:IsA("Folder") then
            remote.Event:FireServer("TargetEnemy", idFolder.Name)
            wait(.1)
        end
    end
end
local function autoKillMobs()
    if not AFkill or not chr then return end
    if chosenAFtype == "Global" then
        for _, locationFolder in ipairs(ws.Markers.Enemies:GetChildren()) do
            if locationFolder:IsA("Folder") then
                findEnemy(locationFolder:FindFirstChild("Default"))
                findEnemy(locationFolder:FindFirstChild("Armored"))
            end
        end
    end
    local enemies = ws.Rendered.Enemies:GetChildren()
    local foundEnemy = false
    for _, enemy in ipairs(enemies) do
        if foundEnemy then break end
        if enemy:FindFirstChild("Hitbox") then
            foundEnemy = true
            local hitbox = enemy.Hitbox
            if chosenAFtype == "Walk" then
                local path = pfs:FindPathAsync(humRootPart.Position, hitbox.Position)
                local waypoint = path:GetWaypoints()
                if waypoint and #waypoint >= 3 then
                    hum:MoveTo(waypoint[3].Position)
                end
            elseif chosenAFtype == "Teleport" then
                humRootPart.CFrame = hitbox.CFrame
                wait(2.5)
                break
            end
        end
    end
end
local function getPetStars(pet)
    local stars = 0
    local descendants = pet:GetDescendants()
    for i = 1, #descendants do
        local v = descendants[i]
        if v.Name == "Stars" then
            local children = v:GetChildren()
            for j = 1, #children do
                local b = children[j]
                if b.ClassName == "ImageLabel" and b.Visible then
                    stars = stars + 1
                end
            end
            break
        end
    end
    return stars
end



--[[x] PLAYER TAB ]]--
main:AddToggle({  -- Auto Collect Shrines
	Name = "⚱️ Auto Collect Shrines",
	Default = false,
	Callback = function(Value)
        getfenv().ACShrines = (Value and true or false)
        while ACShrines do wait()
            for shrine, _ in pairs(shrinesModule) do
                local shrinePrompt = ws.Shrines[shrine].Action:FindFirstChild("ProximityPrompt")
                if shrinePrompt and shrinePrompt.Enabled then
                    if shrine == "ticket" and tickets < 10 then
                        remote.Event:FireServer("UseShrine", shrine)
                        notify("Shrines", "Collected "..shrine.." shrine")
                        wait(1)
                    elseif shrine ~= "ticket" then
                        remote.Event:FireServer("UseShrine", shrine)
                        notify("Shrines", "Collected "..shrine.." shrine")
                        wait(1)
                    end
                end
            end
        end
	end
})
main:AddToggle({  -- Auto Claim Quests
	Name = "📜 Auto Claim Quests",
	Default = false,
	Callback = function(Value)
        getfenv().AClaimQuest = (Value and true or false)
        while AClaimQuest do wait()
            local questnames = {"bruh-bounty", "sailor-treasure-hunt"}
            for _, quest in pairs(questnames) do
                remote.Event:FireServer("FinishedQuestDialog", quest)
                wait(1)
            end
        end
	end
})

teleports:AddDropdown({  -- Teleport to Region
    Name = "🚀 Regions",
    Default = "",
    Options = {"Atlantis", "Hyperwave Arcade", "The Blackmarket", "The Summit", "Magma Basin", "Gloomy Grotto", "Dusty Dunes", "Sunset Shores", "Frosty Peaks", "Auburn Woods", "Mellow Meadows", "Pet Park"},
    Callback = teleportToRegion
})
teleports:AddDropdown({  -- Teleport to Activation
    Name = "🏪 Activations",
    Default = "",
    Options = {"💰 Auburn Shop", "💰 Magic Shop", "💎 Gem Trader", "💎 Blackmarket", "💎 Talents", "👾 Prize Counter", "💎 Traveling Merchant"},
    Callback = teleportToActivation
})
teleports:AddDropdown({  -- Teleport to Boss
    Name = "⚔️ Bosses",
    Default = "",
    Options = {"❤️ Hyper Core", "🐙 Kraken", "🦠 King Slime"},
    Callback = teleportToBoss
})

powerups:AddDropdown({  -- Choose Powerup
	Name = "⚡ Choose Powerup",
	Default = "",
    Save = true,
    Flag = "powerup",
	Options = {
    "Farm (Coin + XP)", "Arcade (Gamer + Token + Lucky)", "Gamer Elixir", "Token Elixir", 
    "Coin Elixir", "XP Elixir", "Lucky Elixir", "Super Lucky Elixir",
    "Sea Elixir", "Timeful Tome", "Prismatic Sundae", "Prismatic Elixir"
    },
	Callback = function(Value)
		chosenPwr = Value
	end
})
powerups:AddToggle({  -- Auto Use Powerups
	Name = "⚡ Auto Use Powerups",
	Default = false,
	Callback = function(Value)
        getfenv().AUPowerups = (Value and true or false)
        while AUPowerups and chosenPwr ~= nil do wait()
            if chosenPwr == "Farm (Coin + XP)" then
                useFarmPowerups()
            elseif chosenPwr == "Arcade (Gamer + Token + Lucky)" then
                useArcadePowerups()
            else
                local powerupData = powerupsMap[chosenPwr]
                if powerupData then
                    usePowerups(chosenPwr, powerupData[1], powerupData[2])
                end
            end
        end
	end
})


--[[x] AUTOMATION TAB ]]--
autobuy:AddToggle({  -- Auto Buy Auburn Shop
	Name = "💰 Auto Buy Auburn Shop",
	Default = false,
	Callback = function(Value)
        getfenv().ABAuburnShop = (Value and true or false)
        while ABAuburnShop do wait()
            autoBuyShopItems("auburn-shop")
        end
	end
})
autobuy:AddToggle({  -- Auto Buy Magic Shop
	Name = "💰 Auto Buy Magic Shop",
	Default = false,
	Callback = function(Value)
        getfenv().ABMagicShop = (Value and true or false)
        while ABMagicShop do wait()
            autoBuyShopItems("magic-shop")
        end
    end
})
autobuy:AddToggle({  -- Auto Buy Gem Trader
	Name = "💎 Auto Buy Gem Trader",
	Default = false,
	Callback = function(Value)
        getfenv().ABGemTrader = (Value and true or false)
        while ABGemTrader do wait()
            autoBuyShopItems("gem-trader")
        end
	end
})
autobuy:AddToggle({  -- Auto Buy Blackmarket
	Name = "💎 Auto Buy Blackmarket",
	Default = false,
	Callback = function(Value)
        getfenv().ABBlackmarket = (Value and true or false)
        while ABBlackmarket do wait()
            autoBuyShopItems("the-blackmarket")
        end
    end
})
autobuy:AddToggle({  -- Auto Buy Traveling Merchant
	Name = "💎 Auto Buy Traveling Merchant",
	Default = false,
	Callback = function(Value)
        getfenv().ABTravelingMerchant = (Value and true or false)
        while ABTravelingMerchant do wait()
            autoBuyShopItems("traveling-merchant")
        end
	end
})

autoexchange:AddSlider({  -- Coins Amount
	Name = "💰 Coins Amount",
	Min = 1,
	Max = 99,
	Default = 1,
    Save = true,
	Color = Color3.fromRGB(55,55,55),
	Increment = 1,
    Flag = "exchange_amount",
	ValueName = "B",
	Callback = function(Value)
        chosenCoins = tonumber(Value)
	end
})
autoexchange:AddToggle({  -- Auto Exchange Coins
	Name = "💰 > 💎 Auto Exchange Coins",
	Default = false,
	Callback = function(Value)
        getfenv().AEcoins = (Value and true or false)
        while AEcoins do wait()
            local exchangeCooldown = ws.Map["Hyperwave Arcade"].Machines.Exchange.Timer.BillboardGui
            if not exchangeCooldown.Enabled then
                remote.Event:FireServer("CoinExchange", chosenCoins)
                notify("Exchange", "Exchanged "..chosenCoins.."B Coins for "..(chosenCoins * 100).." Gems")
                wait(1)
            end
        end
	end
})


--[[x] FARMING TAB ]]--
afmobs:AddDropdown({  -- Auto Kill Type
    Name = "⚔️ Choose Type",
    Default = "",
    Save = true,
    Flag = "autokill_type",
    Options = {"Global", "Walk", "Teleport"},
    Callback = function(Value)
        chosenAFtype = Value
    end
})
afmobs:AddToggle({  -- Auto Kill Mobs
	Name = "⚔️ Auto Kill Mobs",
	Default = false,
	Callback = function(Value)
        getfenv().AFkill = (Value and true or false)
        if AFkill then
            if chosenAFtype ~= "Global" and localdata.MountEquipped then remote.Event:FireServer("UnequipMount") end
            notify("Auto Kill", "Enabled Auto Kill Mobs [Type: "..chosenAFtype.."]")
        end
        while AFkill and task.wait() do
            autoKillMobs()
        end
	end
})

afhypercore:AddSlider({  -- Hyper Core LVL
	Name = "❤️ Hyper Core Level (0 = Max)",
	Min = 0,
	Max = 100,
	Default = 25,
    Save = true,
	Color = Color3.fromRGB(55,55,55),
	Increment = 1,
    Flag = "hypercore_lvl",
	ValueName = "",
	Callback = function(Value)
        chosenhyperlvl = tonumber(Value)
	end
})
afhypercore:AddToggle({  -- Auto Kill Hyper Core
	Name = "❤️ Auto Kill Hyper Core",
	Default = false,
	Callback = function(Value)
        getfenv().AFhyper = (Value and true or false)
        if AFhyper then notify("Auto Kill", "Enabled Auto Kill Hyper Core") end
        while AFhyper do wait()
            local currentPos = chr and humRootPart.Position
            if not hyperAFcooldown.Visible then
                local hyperLVL = chosenhyperlvl == 0 and localdata.BossRecords["hyper-core"] + 1 or chosenhyperlvl
                remote.Function:InvokeServer("BossRequest", "hyper-core", hyperLVL)
                notify("Auto Kill", "Spawned Hyper Core [Level: "..hyperLVL.."]")
                if currentPos then wait(1.5) chr:MoveTo(currentPos) end
                notify("Auto Kill", "Hyper Core Battle Started")
                repeat wait() until hyperAFcooldown.Visible
                notify("Auto Kill", "Defeated Hyper Core")
                if webURL then sendEmbed("Defeated Hyper Core [Level: "..hyperLVL.."]") end
                wait(3)
            end
            if AURThyper then wait(1) remote.Event:FireServer("RespawnBoss", "hyper-core") end
        end
	end
})
afhypercore:AddToggle({  -- Auto Use Tome For Hyper Core
	Name = "💫 Use Respawn Tome",
	Default = false,
	Callback = function(Value)
        AURThyper = Value
	end
})

afkraken:AddSlider({  -- Kraken LVL
	Name = "🐙 Kraken Level (0 = Max)",
	Min = 0,
	Max = 100,
	Default = 25,
    Save = true,
	Color = Color3.fromRGB(55,55,55),
	Increment = 1,
    Flag = "kraken_lvl",
	ValueName = "",
	Callback = function(Value)
        chosenkrakenlvl = tonumber(Value)
	end
})
afkraken:AddToggle({  -- Auto Kill Kraken
	Name = "🐙 Auto Kill Kraken",
	Default = false,
	Callback = function(Value)
        getfenv().AFkraken = (Value and true or false)
        if AFkraken then notify("Auto Kill", "Enabled Auto Kill Kraken") end
        while AFkraken do wait()
            local currentPos = chr and humRootPart.Position
            if not krakenAFcooldown.Visible then
                local krakenLVL = chosenkrakenlvl == 0 and localdata.BossRecords["the-kraken"] + 1 or chosenkrakenlvl
                remote.Function:InvokeServer("BossRequest", "the-kraken", krakenLVL)
                notify("Auto Kill", "Spawned Kraken [Level: "..krakenLVL.."]")
                if currentPos then wait(1.5) chr:MoveTo(currentPos) end
                notify("Auto Kill", "Kraken Battle Started")
                repeat wait() until krakenAFcooldown.Visible
                notify("Auto Kill", "Defeated Kraken")
                if webURL then sendEmbed("Defeated Kraken [Level: "..krakenLVL.."]") end
                wait(3)
            end
            if AURTkraken then wait(1) remote.Event:FireServer("RespawnBoss", "the-kraken") end
        end
	end
})
afkraken:AddToggle({  -- Auto Use Tome For Kraken
	Name = "💫 Use Respawn Tome",
	Default = false,
	Callback = function(Value)
        AURTkraken = Value
	end
})

afkingslime:AddSlider({  -- King Slime LVL
	Name = "🦠 King Slime Level (0 = Max)",
	Min = 0,
	Max = 100,
	Default = 25,
    Save = true,
	Color = Color3.fromRGB(55,55,55),
	Increment = 1,
    Flag = "kingslime_lvl",
	ValueName = "",
	Callback = function(Value)
        chosenslimelvl = tonumber(Value)
	end
})
afkingslime:AddToggle({  -- Auto Kill King Slime
	Name = "🦠 Auto Kill King Slime",
	Default = false,
	Callback = function(Value)
        getfenv().AFslime = (Value and true or false)
        if AFslime then notify("Auto Kill", "Enabled Auto Kill King Slime") end
        while AFslime do wait()
            local currentPos = chr and humRootPart.Position
            if not slimeAFcooldown.Visible then
                local slimeLVL = chosenslimelvl == 0 and localdata.BossRecords["king-slime"] + 1 or chosenslimelvl
                remote.Function:InvokeServer("BossRequest", "king-slime", slimeLVL)
                notify("Auto Kill", "Spawned King Slime [Level: "..slimeLVL.."]")
                if currentPos then wait(1.5) chr:MoveTo(currentPos) end
                notify("Auto Kill", "King Slime Battle Started")
                repeat wait() until slimeAFcooldown.Visible
                notify("Auto Kill", "Defeated King Slime")
                if webURL then sendEmbed("Defeated King Slime [Level: "..slimeLVL.."]") end
                wait(3)
            end
            if AURTkingslime then wait(1) remote.Event:FireServer("RespawnBoss", "king-slime") end
        end
	end
})
afkingslime:AddToggle({  -- Auto Use Tome For King Slime
	Name = "💫 Use Respawn Tome",
	Default = false,
	Callback = function(Value)
        AURTkingslime = Value
	end
})


--[[ MINIGAMES TAB ]]--
local petID
for _, pet in ipairs(localdata.Pets) do  -- Get Gamer Charm Pet
    if pet.Charms then
        for _, charm in ipairs(pet.Charms) do
            if charm.Name == "Gamer" and charm.Level >= 2 then
                petID = pet.Id
            end
        end
    end
end

--[[
ticketsMg:AddToggle({
	Name = "🦴 Auto Ancient Dig [WIP]",
	Default = false,
	Callback = function(Value)
        getfenv().AAdig = (Value and true or false)
        if AAdig then notify("Minigames", "Enabled Auto Ancient Dig") end
        while AAdig do wait()
            local current = minigameModule.Current    
            if current and current.State then
                local cells = current.State.Cells
                for cellToClick, _ in pairs(cells) do
                    remote.Event:FireServer("TryMinigameInput", cellToClick)
                end
            end
        end    
	end
})
ticketsMg:AddToggle({
	Name = "🎶 Auto Dance Off [WIP]",
	Default = false,
	Callback = function(Value)
        ADoff = Value
        if ADoff then
            warn("[Debug] ✅ Enabled Auto Dance Off")
            notify("Minigames", "Enabled Auto Dance Off")
        end
	end
})
]]--

ticketsMg:AddToggle({  -- Auto Robot Claw
	Name = "🕹️ Auto Robot Claw",
	Default = false,
	Callback = function(Value)
        getfenv().ARclaw = (Value and true or false)
        if ARclaw then
            remote.Function:InvokeServer("LoadRegion", "Hyperwave Arcade")
            notify("Minigames", "Enabled Auto Robot Claw")
        end
        while ARclaw do wait()
            if tickets >= 1 then
                remote.Function:InvokeServer("MinigameRequest", "robot-claw", petID)
                wait(2.5)
                warn("[Debug] 🕹️✅ Robot Claw Game Started")
                notify("Minigames", "Robot Claw Game Started")
                local endTime = os.time() + 60
                repeat
                    remote.Event:FireServer("TryMinigameInput", true)
                    wait(.05)
                until os.time() >= endTime
                warn("[Debug] 🕹️🏆 Robot Claw Game Ended")
                notify("Minigames", "Robot Claw Game Ended")
                wait(5)
            end
        end
    end
})
ticketsMg:AddToggle({  -- Auto Cube Drop
	Name = "🎲 Auto Cube Drop",
	Default = false,
	Callback = function(Value)
        getfenv().ACdrop = (Value and true or false)
        if ACdrop then
            remote.Function:InvokeServer("LoadRegion", "Hyperwave Arcade")
            notify("Minigames", "Enabled Auto Cube Drop")
        end
        while ACdrop do wait(.1)
            remote.Function:InvokeServer("PlayCubeDrop")
        end
	end
})

fishing:AddDropdown({  -- Fish Region
    Name = "🐟 Choose Region",
    Default = "",
    Save = true,
    Flag = "autofish_region",
    Options = {"Hyperwave Arcade", "Magma Basin", "Gloomy Grotto", "Dusty Dunes", "Sunset Shores", "Frosty Peaks", "Auburn Woods", "Mellow Meadows", "Pet Park"},
    Callback = function(Value)
        fishingRegion = Value
        fishingVec = fishingMap[Value]
    end
})
fishing:AddToggle({  -- Auto Fish
    Name = "🐟 Auto Fish",
    Default = false,
    Callback = function(Value)
        AFish = Value
        if AFish and fishingRegion ~= nil then
            remote.Event:FireServer("StartFishing", fishingRegion, fishingVec)
            notify("Auto Fish", "Started Fishing in "..fishingRegion)
            while AFish and fishingRegion ~= nil do
                startFishing()
            end
        else
            remote.Event:FireServer("StopFishing")
        end
    end
})
fishing:AddToggle({  -- Auto Sell Fish
	Name = "🐟 > 💰 Auto Sell Fish",
	Default = false,
	Callback = function(Value)
        getfenv().ASFish = (Value and true or false)
        while ASFish do wait(.1)
            remote.Event:FireServer("SellFish")
        end
	end
})


--[[x] CRAFTING TAB ]]--
local function craftingSlot(slot, index)  -- Auto Craft
    slot:AddDropdown({
        Name = "🛠️ Choose Item",
        Default = "",
        Options = {"Rare Cube", "Epic Cube", "Legendary Cube", "Mystery Egg", "Elite Mystery Egg", "Coin Elixir", "XP Elixir", "Sea Elixir", "Token Elixir"},
        Callback = function(Value)
            getfenv()["chosenACItem"..index] = craftingMap[Value] or ""
        end
    })
    slot:AddTextbox({
        Name = "🛠️ Amount To Craft",
        Default = "",
        TextDisappear = false,
        Callback = function(Value)
            getfenv()["chosenACAmount"..index] = tonumber(Value)
        end
    })
    slot:AddToggle({
        Name = "🛠️ Auto Craft",
        Default = false,
        Callback = function(Value)
            getfenv()["activeslot"..index] = Value
            local claim = sui.Crafting.Frame.Body["Slot"..index].Content.Claim
            while getfenv()["activeslot"..index] do
                wait(0.1)
                if claim.Visible then
                    remote.Event:FireServer("ClaimCrafting", index)
                else
                    remote.Event:FireServer("StartCrafting", index, getfenv()["chosenACItem"..index], getfenv()["chosenACAmount"..index])
                end
            end
        end
    })
end
craftingSlot(ACslot1, 1) craftingSlot(ACslot2, 2) craftingSlot(ACslot3, 3)


--[[x] PETS TAB ]]--
pets:AddToggle({  -- Auto Catch Pets
	Name = "🐾 Auto Catch Pets",
    Default = false,
	Callback = function(Value)
        getfenv().autocatch = (Value and true or false)
        while autocatch do wait()
            pcall(function()
                for i,v in pairs(ws.Rendered.Pets.World:GetChildren()) do
                    if not autocatch then break end
                    if v.ClassName == "Model" and getPetStars(v) >= 4 then
                        remote.Function:InvokeServer("CapturePet", v.Name, "Legendary")
                    elseif v.ClassName == "Model" and getPetStars(v) <= 4 then
                        remote.Function:InvokeServer("CapturePet", v.Name, "Epic")
                    end
                end
            end)
        end
	end
})

eggs:AddDropdown({  -- Choose Egg
    Name = "🥚 Choose Egg",
    Default = "Elite Mystery Egg",
    Save = true,
    Flag = "autohatch_egg",
    Options = {"Prismatic Mystery Egg", "Elite Mystery Egg", "Mystery Egg"},
    Callback = function(Value)
        chosenEgg = Value
    end
})
eggs:AddToggle({  -- Auto Hatch Eggs
	Name = "🥚 Auto Hatch Eggs",
    Default = false,
	Callback = function(Value)
        getfenv().autohatch = (Value and true or false)
        while autohatch and chosenEgg do wait(.1)
            remote.Function:InvokeServer("TryHatchEgg", chosenEgg)
        end
	end
})


--[[x] MISC TAB ]]--
mgui:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        notify("FPS Booster", "Credits: github.com/fdvll")
        loadstring(game:HttpGet("https://github.com/fdvll/pet-simulator-99/blob/main/cpuReducer.lua?raw=true"))()
  	end
})
mgui:AddToggle({  -- Always Show Tokens
	Name = "👾 Always Show Tokens",
	Default = false,
	Callback = function(Value)
        getfenv().showTokens = (Value and true or false)
        rs.RenderStepped:Connect(function()
            local tokens = sui.HUD.Left.Currency.Tokens
            if showTokens and not tokens.Visible then
                tokens.Visible = true
            end
        end)
	end
})
mgui:AddToggle({  -- Hide Quests
	Name = "📜 Hide Quests",
	Default = false,
	Callback = function(Value)
        sui.Quests.Visible = not Value
	end
})
mgui:AddToggle({  -- Disable Snow
	Name = "❄️ Disable Snow",
	Default = false,
	Callback = function(Value)
        ws.Rendered.Snow.ParticleEmitter.Enabled = not Value
	end
})

mOther:AddTextbox({  -- Set Discord Webhook
    Name = "🔗 Set Discord Webhook",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        webURL = Value
    end
})
mOther:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        notify("Rejoin", "Rejoining...")
        tp:Teleport(game.PlaceId, slp)
  	end
})
mOther:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        notify("Server Hopping...", "Credits: github.com/LeoKholYt")
        loadstring(game:HttpGet("https://github.com/LeoKholYt/roblox/blob/main/lk_serverhop.lua?raw=true"))():Teleport(game.PlaceId)
  	end
})
mOther:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function() lib:Destroy() end
})
lib:Init()
