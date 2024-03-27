repeat task.wait() until game:IsLoaded()
local lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/illumaware/c/main/debug/BetterOrion.lua')))()
local window = lib:MakeWindow({Name = "[Pet Catchers] AIO", HidePremium = true, SaveConfig = true, ConfigFolder = "AIO_PetCatchers", IntroEnabled = false})

print("[AIO/Misc] Minigame PetID: "..getfenv().minigamePetID)

--[[ Home ]]--
local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local hmain = home:AddSection({ Name = "Main" })
local welcome = hmain:AddParagraph("Welcome to AIO", "v2.4 [beta]")
local notifyevents = hmain:AddLabel("🎉 No current Events")
local newcodelabel = hmain:AddLabel("🏷️ Redeemed New Code: None")
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
local autoexchange = auto:AddSection({ Name = "Exchange" })

--[[ Farming ]]--
local autofarm = window:MakeTab({ Name = "Farming", Icon = "rbxassetid://7743872758" })
local afmobs = autofarm:AddSection({ Name = "Mobs" })
local enemynames = afmobs:AddLabel("Enemy Name: None")
local enemynum = afmobs:AddLabel("Number of Enemies: None")
local afhypercore = autofarm:AddSection({ Name = "Hyper Core" })
local hypertimer = afhypercore:AddLabel("❤️ Hyper Core is not available")
local afkraken = autofarm:AddSection({ Name = "Kraken" })
local krakentimer = afkraken:AddLabel("🐙 Kraken is not available")
local afkingslime = autofarm:AddSection({ Name = "King Slime" })
local slimetimer = afkingslime:AddLabel("🦠 King Slime is not available")

--[[ Minigames ]]--
local minigames = window:MakeTab({ Name = "Minigames", Icon = "rbxassetid://7733799901" })
local ticketsMg = minigames:AddSection({ Name = "Main" })
local fishing = minigames:AddSection({ Name = "Fishing" })

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
local cfg = misc:AddSection({ Name = "Config" })
local mgui = misc:AddSection({ Name = "Render" })
local mOther = misc:AddSection({ Name = "Other" })



--[[ VARIABLES ]]--
local rstorage = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote
local vu = game:GetService("VirtualUser")
local ws = game:GetService("Workspace")
local pfs = game:GetService("PathfindingService")
local slp = game:GetService("Players").LocalPlayer
local sui = slp.PlayerGui.ScreenGui
local lp = slp.Character.Humanoid
local quests = sui.Quests.List:GetChildren()
local hyperAFcooldown = ws.Bosses["hyper-core"].Display.SurfaceGui.BossDisplay.Cooldown
local slimeAFcooldown = ws.Bosses["king-slime"].Display.SurfaceGui.BossDisplay.Cooldown
local krakenAFcooldown = ws.Bosses["the-kraken"].Display.SurfaceGui.BossDisplay.Cooldown



--[[ FUNCTIONS ]]--
slp.Idled:connect(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end)  -- AntiAFK
local function textToNumber(text) return tonumber(text:gsub(",", ""):match("%d+")) end
local function notify(name, content)  -- Notifications
    lib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://7733911828",
        Time = 5
    })
end

local function redeemNewCode()
    local sGuiHolder = slp.PlayerGui.ScreenGuiHolder
    for _, surfaceGui in pairs(sGuiHolder:GetChildren()) do
        if surfaceGui:IsA("SurfaceGui") then
            local frame = surfaceGui:FindFirstChild("Frame")
            if frame then
                local code = frame:FindFirstChild("Code")
                if code and code:IsA("TextLabel") then
                    local newcode = code.Text
                    local cleanednewcode = newcode:sub(2, -2)
                    rstorage.Function:InvokeServer("RedeemCode", cleanednewcode)
                    newcodelabel:Set("🏷️ Redeemed New Code: " .. cleanednewcode)
                    return
                end
            end
        end
    end
end redeemNewCode()
local function autoBuyShopItems(shopName)
    for i = 1, 3 do
        rstorage.Event:FireServer("BuyShopItem", shopName, i, 1)
    end
end
local function teleportToRegion(region)
    if region ~= "The Blackmarket" and region ~= "The Summit" then
        rstorage.Event:FireServer("TeleportBeacon", region, "Spawn")
    else
        rstorage.Event:FireServer("TeleportBeacon", "Magma Basin", region)
    end
    notify("Teleport", "Teleported to " .. region)
end
local function teleportToActivation(Activation)
    local activationsPositions = {
        ["💰 Auburn Shop"] = ws.Activations["auburn-shop"].Root.Position,
        ["💰 Magic Shop"] = ws.Activations["magic-shop"].Root.Position,
        ["💎 Gem Trader"] = ws.Activations["gem-trader"].Root.Position,
        ["💎 Blackmarket"] = ws.Activations["the-blackmarket"].Root.Position,
        ["💎 Talents"] = ws.Activations.talents.Root.Position,
        ["👾 Prize Counter"] = ws.Activations["prize-counter"].Root.Position
    }
    local position = activationsPositions[Activation]
    if position then
        slp.Character:MoveTo(position)
        notify("Teleport", "Teleported to " .. Activation)
    end
end
local function teleportToBoss(boss)
    local bossesPos = {
        ["❤️ Hyper Core"] = ws.Bosses["hyper-core"].Gate.Activation.Root.Position,
        ["🐙 Kraken"]     = ws.Bosses["the-kraken"].Gate.Activation.Root.Position,
        ["🦠 King Slime"] = ws.Bosses["king-slime"].Gate.Activation.Root.Position
    }
    local bossPos = bossesPos[boss]
    if bossPos then
        slp.Character:MoveTo(bossPos)
        notify("Teleport", "Teleported to " .. boss .. " boss")
    end
end
local function usePowerups(powerupName, durationObj, notificationMsg)
    if not durationObj.Visible then
        rstorage.Event:FireServer("UsePowerup", powerupName)
        notify("Powerups", notificationMsg)
        wait(1)
    end
end
local function useFarmPowerups()
    local coinDur = sui.Buffs.Treasure
    local xpDur = sui.Buffs.Experienced
    if not coinDur.Visible and not xpDur.Visible then
        rstorage.Event:FireServer("UsePowerup", "Coin Elixir")
        rstorage.Event:FireServer("UsePowerup", "XP Elixir")
        notify("Powerups", "Used Coin and XP Elixirs")
        wait(1)
    end
end
local function useArcadePowerups()
    local gamerDur = sui.Buffs.Gamer
    local tokenDur = sui.Buffs.Token
    if not gamerDur.Visible and not tokenDur.Visible then
        rstorage.Event:FireServer("UsePowerup", "Gamer Elixir")
        rstorage.Event:FireServer("UsePowerup", "Token Elixir")
        notify("Powerups", "Used Gamer and Token Elixirs")
        wait(1)
    end
end
local function startFishing()
    local humanoidRootPart = slp.Character:FindFirstChild("HumanoidRootPart")
    local fishingRod = ws:FindFirstChild(slp.Name):FindFirstChild("FishingRod")
    if humanoidRootPart and humanoidRootPart.Anchored then humanoidRootPart.Anchored = false end
    if fishingRod then fishingRod:Destroy() end
    rstorage.Event:FireServer("StartCastFishing")
    wait(fishingDelay)
end
local function findEnemy(folder)
    if folder then
        for _, idFolder in ipairs(folder:GetChildren()) do
            if idFolder:IsA("Folder") and AFkill then
                rstorage.Event:FireServer("TargetEnemy", idFolder.Name)
                wait(opDelay)
            end
        end
    end
end
local function autoKillMobs()
    if not AFkill then return end
    if chosenAFtype == "Global" then
        for _, locationFolder in ipairs(ws.Markers.Enemies:GetChildren()) do
            if locationFolder:IsA("Folder") then
                findEnemy(locationFolder:FindFirstChild("Default"))
                findEnemy(locationFolder:FindFirstChild("Armored"))
            end
        end
    end
    local char = slp.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart or not humanoid then return end
    local foundEnemy = false
    for _, enemy in ipairs(enemies) do
        if enemy:FindFirstChild("Hitbox") and not foundEnemy then
            foundEnemy = true
            local hitbox = enemy.Hitbox
            if chosenAFtype == "Walk" then
                local path = pfs:FindPathAsync(humanoidRootPart.Position, hitbox.Position)
                local waypoint = path:GetWaypoints()
                if waypoint and #waypoint >= 3 then
                    humanoid:MoveTo(waypoint[3].Position)
                    humanoid.Jump = false
                end
            elseif chosenAFtype == "Teleport" then
                humanoidRootPart.CFrame = hitbox.CFrame
                wait(2.5)
                break
            end
        end
    end
end

local function updLabels()  -- Labels Updater
    local enemies_session, eggs_session = 0, 0
    local enemies_num_path = sui.Debug.Stats.Frame.List.EnemiesDefeated.Total
    local enemies_start_total = textToNumber(enemies_num_path.Text)
    local eggs_num_path = slp.leaderstats["🥚 Hatched"]
    local eggs_start_total = eggs_num_path.Value
    local sePath = sui.HUD.Top.Event.Title
    local seTimer = sui.HUD.Top.Event.Timer
    local eventsModule = require(game:GetService("ReplicatedStorage").Shared.Data.Events)
    while task.wait() do
        --[[Home]]--
        local enemies_total = textToNumber(enemies_num_path.Text)
        local eggs_total = eggs_num_path.Value
        if enemies_total and eggs_total then
            local enemies_killed = enemies_total - enemies_start_total
            local eggs_hatched = eggs_total - eggs_start_total
            enemies_session = enemies_session + enemies_killed
            eggs_session = eggs_session + eggs_hatched
            enemycount:Set("⚔️ Enemies Killed: " .. enemies_session .. " [Total: " .. enemies_total .. "]")
            eggstats:Set("🥚 Eggs Hatched: " .. eggs_session .. " [Total: " .. eggs_total .. "]")
            enemies_start_total = enemies_total
            eggs_start_total = eggs_total
        end

        local server_event = sui.HUD.Top.Event
        for event, _ in pairs(eventsModule) do
            local server_event_path = sePath.Text
            if server_event.Visible then
                if string.find(server_event_path, event) then
                    local server_event_timer_path = seTimer.Text
                    notifyevents:Set("🎉 Current Event: " .. event .. " [" .. server_event_timer_path .. "]")
                end
            else
                notifyevents:Set("🎉 No current Events")
            end
        end

        --[[Farming]]--
        enemies = ws.Rendered.Enemies:GetChildren()
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
            enemynum:Set("Number of Enemies: None")
            enemynames:Set("Enemy Name: None")
        end

        if hyperAFcooldown and hyperAFcooldown.Visible then
            local hyperbosstimer = hyperAFcooldown.Title.Text
            hypertimer:Set("❤️ Hyper Core: " .. hyperbosstimer)
        else
            hypertimer:Set("❤️ Hyper Core: ✅ Ready")
        end

        if slimeAFcooldown and slimeAFcooldown.Visible then
            local slimebosstimer = slimeAFcooldown.Title.Text
            slimetimer:Set("🦠 King Slime: " .. slimebosstimer)
        else
            slimetimer:Set("🦠 King Slime: ✅ Ready")
        end

        if krakenAFcooldown and krakenAFcooldown.Visible then
            local krakenbosstimer = krakenAFcooldown.Title.Text
            krakentimer:Set("🐙 Kraken: " .. krakenbosstimer)
        else
            krakentimer:Set("🐙 Kraken: ✅ Ready")
        end
    end
end
task.spawn(updLabels)

local function autoAncientDig()  -- Auto Ancient Dig
    while task.wait() do
        if AAdig then
            local minigameModule = require(game:GetService("ReplicatedStorage").Client.Minigame)
            local current = minigameModule.Current    
            if current and current.State then
                local cells = current.State.Cells
                for cellToClick, _ in pairs(cells) do
                    rstorage.Event:FireServer("TryMinigameInput", cellToClick)
                end
            end
        end
    end
end
task.spawn(autoAncientDig)



--[[x] PLAYER TAB ]]--
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
            lp.MaxHealth = 2000
            lp.Health = 2000
        end
    end
})
main:AddToggle({  -- Auto Collect Shrines
	Name = "⚱️ Auto Collect Shrines",
	Default = false,
	Callback = function(Value)
        getfenv().ACShrines = (Value and true or false)
        local shrinesModule = require(game:GetService("ReplicatedStorage").Shared.Data.Shrines)
        while ACShrines do wait()
            for shrine, _ in pairs(shrinesModule) do
                local shrinePrompt = ws.Shrines[shrine].Action:FindFirstChild("ProximityPrompt")
                if shrinePrompt and shrinePrompt.Enabled then
                    rstorage.Event:FireServer("UseShrine", shrine)
                    notify("Shrines", "Collected " .. shrine .. " shrine")
                    wait(1)
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
                rstorage.Event:FireServer("FinishedQuestDialog", quest)
                wait(1)
            end
        end
	end
})

teleports:AddDropdown({  -- Teleport to Region
    Name = "🚀 Regions",
    Default = "",
    Options = {"Hyperwave Arcade", "The Blackmarket", "The Summit", "Magma Basin", "Gloomy Grotto", "Dusty Dunes", "Sunset Shores", "Frosty Peaks", "Auburn Woods", "Mellow Meadows", "Pet Park"},
    Callback = teleportToRegion
})
teleports:AddDropdown({  -- Teleport to Activation
    Name = "🏪 Activations",
    Default = "",
    Options = {"💰 Auburn Shop", "💰 Magic Shop", "💎 Gem Trader", "💎 Blackmarket", "💎 Talents", "👾 Prize Counter"},
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
    "Farm (Coin & XP)", "Arcade (Gamer & Token)", "Gamer Elixir", "Token Elixir", 
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
            local powerups = {
                ["Gamer Elixir"] =       { sui.Buffs.Gamer, "Used Gamer Elixir" },
                ["Token Elixir"] =       { sui.Buffs.Token, "Used Token Elixir" },
                ["Coin Elixir"] =        { sui.Buffs.Treasure, "Used Coin Elixir" },
                ["XP Elixir"] =          { sui.Buffs.Experienced, "Used XP Elixir" },
                ["Lucky Elixir"] =       { sui.Buffs["Feeling Lucky"], "Used Lucky Elixir" },
                ["Super Lucky Elixir"] = { sui.Buffs["Super Lucky"], "Used Super Lucky Elixir" },
                ["Sea Elixir"] =         { sui.Buffs["Ocean's Blessing"], "Used Sea Elixir" },
                ["Timeful Tome"] =       { sui.Buffs.Stopwatch, "Used Timeful Tome" },
                ["Prismatic Sundae"] =   { sui.Buffs.Fortune, "Used Prismatic Sundae" },
                ["Prismatic Elixir"] =   { sui.Buffs["Ultra Lucky"], "Used Prismatic Elixir" }
            }
            if chosenPwr == "Farm (Coin & XP)" then
                useFarmPowerups()
            elseif chosenPwr == "Arcade (Gamer & Token)" then
                useArcadePowerups()
            else
                local powerupData = powerups[chosenPwr]
                if powerupData then
                    usePowerups(chosenPwr, powerupData[1], powerupData[2])
                end
            end
        end
	end
})


--[[x] AUTOMATION TAB ]]--
autobuy:AddToggle({  -- Buy Auburn Shop
	Name = "💰 Auto Buy Auburn Shop",
	Default = false,
	Callback = function(Value)
        getfenv().ABAuburnShop = (Value and true or false)
        while ABAuburnShop do wait()
            autoBuyShopItems("auburn-shop")
        end
	end
})
autobuy:AddToggle({  -- Buy Magic Shop
	Name = "💰 Auto Buy Magic Shop",
	Default = false,
	Callback = function(Value)
        getfenv().ABMagicShop = (Value and true or false)
        while ABMagicShop do wait()
            autoBuyShopItems("magic-shop")
        end
    end
})
autobuy:AddToggle({  -- Buy Gem Trader
	Name = "💎 Auto Buy Gem Trader",
	Default = false,
	Callback = function(Value)
        getfenv().ABGemTrader = (Value and true or false)
        while ABGemTrader do wait()
            autoBuyShopItems("gem-trader")
        end
	end
})
autobuy:AddToggle({  -- Buy Blackmarket
	Name = "💎 Auto Buy Blackmarket",
	Default = false,
	Callback = function(Value)
        getfenv().ABBlackmarket = (Value and true or false)
        while ABBlackmarket do wait()
            autoBuyShopItems("the-blackmarket")
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
                game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("CoinExchange", chosenCoins)
                notify("Exchange", "Exchanged "..chosenCoins.."B Coins")
                wait(1)
            end
        end
	end
})


--[[ FARMING TAB ]]--
afmobs:AddSlider({  -- Global Auto Kill Delay
	Name = "Global Auto Kill Delay (Better Pets = Lower Value)",
	Min = 0.25,
	Max = 5,
	Default = 0.25,
    Save = true,
	Color = Color3.fromRGB(55,55,55),
	Increment = 0.25,
    Flag = "globalkill_delay",
	ValueName = "s",
	Callback = function(Value)
        opDelay = tonumber(Value)
	end
})
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
            if chosenAFtype then
                if chosenAFtype ~= "Global" then
                    gm:Set(true)
                    rstorage.Event:FireServer("UnequipMount")
                end
                notify("Auto Kill", "Enabled Auto Kill Mobs [Type: "..chosenAFtype.."]")
            else
                notify("Auto Kill", "⚠️ Enable Auto Kill Type")
            end
        end
        while AFkill do wait()
            autoKillMobs()
        end
	end
})

afhypercore:AddSlider({  -- Hyper Core LVL
	Name = "❤️ Hyper Core Level (0 = Max)",
	Min = 0,
	Max = 100,
	Default = 0,
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
            local currentPos = slp.Character and slp.Character.HumanoidRootPart.Position
            if not hyperAFcooldown.Visible then
                local hyperlvlTextPath = sui.Debug.Stats.Frame.List.BossesDefeated.Extra["hyper-core"].Total.Text
                local hyperLVL
                if chosenhyperlvl == 0 then
                    hyperLVL = tonumber(hyperlvlTextPath:match("%d+"))
                    warn("[Debug] ❤️✅ Spawned Hyper Core [Level: Max]")
                    notify("Auto Kill", "Spawned Hyper Core [Level: Max]")
                else
                    hyperLVL = chosenhyperlvl
                    warn("[Debug] ❤️✅ Spawned Hyper Core [Level: " .. hyperLVL .. "]")
                    notify("Auto Kill", "Spawned Hyper Core [Level: " .. hyperLVL .. "]")
                end
                rstorage.Function:InvokeServer("BossRequest", "hyper-core", hyperLVL)
                if currentPos then wait(1.5)
                    slp.Character:MoveTo(currentPos)
                end
                warn("[Debug] ❤️⚔️ Hyper Core Battle Started")
                notify("Auto Kill", "Hyper Core Battle Started")
                repeat
                    wait()
                until hyperAFcooldown.Visible
                warn("[Debug] ❤️🏆 Defeated Hyper Core")
                notify("Auto Kill", "Defeated Hyper Core")
                wait(3)
            end
            if AURThyper then
                wait(1)
                rstorage.Event:FireServer("RespawnBoss", "hyper-core")
            end
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
	Default = 0,
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
            local currentPos = slp.Character and slp.Character.HumanoidRootPart.Position
            if not krakenAFcooldown.Visible then
                local krakenlvlTextPath = sui.Debug.Stats.Frame.List.BossesDefeated.Extra["the-kraken"].Total.Text
                local krakenLVL
                if chosenkrakenlvl == 0 then
                    krakenLVL = tonumber(krakenlvlTextPath:match("%d+"))
                    warn("[Debug] 🐙✅ Spawned Kraken [Level: Max]")
                    notify("Auto Kill", "Spawned Kraken [Level: Max]")    
                else
                    krakenLVL = chosenkrakenlvl
                    warn("[Debug] 🐙✅ Spawned Kraken [Level: " .. krakenLVL .. "]")
                    notify("Auto Kill", "Spawned Kraken [Level: " .. krakenLVL .. "]")    
                end
                rstorage.Function:InvokeServer("BossRequest", "the-kraken", krakenLVL)
                if currentPos then wait(1.5)
                    slp.Character:MoveTo(currentPos)
                end
                warn("[Debug] 🐙⚔️ Kraken Battle Started")
                notify("Auto Kill", "Kraken Battle Started")
                repeat
                    wait()
                until krakenAFcooldown.Visible
                warn("[Debug] 🐙🏆 Defeated Kraken")
                notify("Auto Kill", "Defeated Kraken")
                wait(3)
            end
            if AURTkraken then
                wait(1)
                rstorage.Event:FireServer("RespawnBoss", "the-kraken")
            end
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
	Default = 0,
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
            local currentPos = slp.Character and slp.Character.HumanoidRootPart.Position
            if not slimeAFcooldown.Visible then
                local slimelvlTextPath = sui.Debug.Stats.Frame.List.BossesDefeated.Extra["king-slime"].Total.Text
                local slimeLVL
                if chosenslimelvl == 0 then
                    slimeLVL = tonumber(slimelvlTextPath:match("%d+"))
                    warn("[Debug] 🦠✅ Spawned King Slime [Level: Max]")
                    notify("Auto Kill", "Spawned King Slime [Level: Max]")
                else
                    slimeLVL = chosenslimelvl
                    warn("[Debug] 🦠✅ Spawned King Slime [Level: " .. slimeLVL .. "]")
                    notify("Auto Kill", "Spawned King Slime [Level: " .. slimeLVL .. "]")
                end
                rstorage.Function:InvokeServer("BossRequest", "king-slime", slimeLVL)
                if currentPos then wait(1.5)
                    slp.Character:MoveTo(currentPos)
                end
                warn("[Debug] 🦠⚔️ King Slime Battle Started")
                notify("Auto Kill", "King Slime Battle Started")
                repeat
                    wait()
                until slimeAFcooldown.Visible
                warn("[Debug] 🦠🏆 Defeated King Slime")
                notify("Auto Kill", "Defeated King Slime")
                wait(3)
            end
            if AURTkingslime then
                wait(1)
                rstorage.Event:FireServer("RespawnBoss", "king-slime")
            end
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
ticketsMg:AddToggle({
	Name = "🦴 Auto Ancient Dig [WIP]",
	Default = false,
	Callback = function(Value)
        AAdig = Value
        if AAdig then
            warn("[Debug] ✅ Enabled Auto Ancient Dig")
            notify("Minigames", "Enabled Auto Ancient Dig")
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
ticketsMg:AddToggle({  -- Auto Robot Claw
	Name = "🕹️ Auto Robot Claw",
	Default = false,
	Callback = function(Value)
        getfenv().ARclaw = (Value and true or false)
        if ARclaw then teleportToRegion("Hyperwave Arcade") wait(.5) end
        local synced = false
        while ARclaw do wait()
            local important = sui.Inventory.Frame.Main.Content.Items.List["Important Things"].Grid.Content
            for _, child in ipairs(important:GetChildren()) do
                if child:IsA("Frame") then
                    synced = true
                    break
                end
            end
            if not synced then wait(2) notify("Minigames", "⚠️ Open Inventory > Items To Sync") end
            local tickets = important:FindFirstChild("GoldenTickets")
            if synced and tickets then
                rstorage.Function:InvokeServer("MinigameRequest", "robot-claw", getfenv().minigamePetID)
                wait(2.5)
                print("r-c petid: "..getfenv().minigamePetID)
                warn("[Debug] 🕹️✅ Robot Claw Game Started")
                notify("Minigames", "Robot Claw Game Started")
                local endTime = os.time() + 70
                repeat
                    rstorage.Event:FireServer("TryMinigameInput", true)
                    wait(0.1)
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
            notify("Minigames", "Enabled Auto Cube Drop")
            teleportToRegion("Hyperwave Arcade")
            wait(.5)
        end
        while ACdrop do wait(.1)
            rstorage.Function:InvokeServer("PlayCubeDrop")
        end
	end
})

fishing:AddSlider({  -- Auto Fish Delay
	Name = "Casting Delay (Stable = 2.7)",
	Min = 2.48,
	Max = 3.20,
	Default = 2.48,
    Save = true,
	Color = Color3.fromRGB(55,55,55),
	Increment = 0.02,
    Flag = "autofish_delay",
	ValueName = "s",
	Callback = function(Value)
        fishingDelay = tonumber(Value)
	end
})
fishing:AddDropdown({  -- Fish Region
    Name = "🐟 Choose Region",
    Default = "",
    Save = true,
    Flag = "autofish_region",
    Options = {"Hyperwave Arcade", "Magma Basin", "Gloomy Grotto", "Dusty Dunes", "Sunset Shores", "Frosty Peaks", "Auburn Woods", "Mellow Meadows", "Pet Park"},
    Callback = function(Value)
        local fishingMap = {
            ["Hyperwave Arcade"] = Vector3.new(1350, 2, -1546),
            ["Magma Basin"] =      Vector3.new(1285, 184, -447),
            ["Gloomy Grotto"] =    Vector3.new(1638, 50, -86),
            ["Dusty Dunes"] =      Vector3.new(1562, 50, 258),
            ["Sunset Shores"] =    Vector3.new(1343, 38, 643),
            ["Frosty Peaks"] =     Vector3.new(717, 70, 575),
            ["Auburn Woods"] =     Vector3.new(769, 22, 1273),
            ["Mellow Meadows"] =   Vector3.new(1036, 22, 1381),
            ["Pet Park"] =         Vector3.new(1189, 10, 1587)
        }
        fishingRegion = Value
        fishingVec = fishingMap[Value] or ""
    end
})
fishing:AddToggle({  -- Auto Fish
    Name = "🐟 Auto Fish",
    Default = false,
    Callback = function(Value)
        AFish = Value
        if AFish and fishingRegion ~= nil then
            rstorage.Event:FireServer("StartFishing", fishingRegion, fishingVec)
            warn("[Debug] ✅ Enabled Auto Fish")
            notify("Auto Fish", "Started Fishing in " .. fishingRegion)
            while AFish and fishingRegion ~= nil do
                startFishing()
            end
        elseif AFish and fishingRegion == nil then
            notify("Auto Fish", "⚠️ Choose Region")
        else
            rstorage.Event:FireServer("StopFishing")
        end
    end
})
fishing:AddToggle({  -- Auto Sell Fish
	Name = "🐟 > 💰 Auto Sell Fish",
	Default = false,
	Callback = function(Value)
        getfenv().ASFish = (Value and true or false)
        while ASFish do wait(.1)
            rstorage.Event:FireServer("SellFish")
        end
	end
})


--[[x] CRAFTING TAB ]]--
local craftingMap = {
    ["Rare Cube"] = "rare-cube",
    ["Epic Cube"] = "epic-cube",
    ["Legendary Cube"] = "legendary-cube",
    ["Mystery Egg"] = "mystery-egg",
    ["Elite Mystery Egg"] = "elite-mystery-egg",
    ["Coin Elixir"] = "coin-elixir",
    ["XP Elixir"] = "xp-elixir",
    ["Sea Elixir"] = "sea-elixir",
    ["Token Elixir"] = "token-elixir"}
local function craftingSlot(slot, index)  -- Auto Craft
    slot:AddDropdown({
        Name = "🛠️ Choose Item",
        Default = "",
        Options = {"Rare Cube", "Epic Cube", "Legendary Cube", "Mystery Egg", "Elite Mystery Egg", "Coin Elixir", "XP Elixir", "Sea Elixir", "Token Elixir"},
        Callback = function(Value)
            _G["chosenACItem"..index] = craftingMap[Value] or ""
        end
    })
    slot:AddTextbox({
        Name = "🛠️ Amount To Craft",
        Default = "",
        TextDisappear = false,
        Callback = function(Value)
            _G["chosenACAmount"..index] = tonumber(Value)
        end
    })
    slot:AddToggle({
        Name = "🛠️ Auto Craft",
        Default = false,
        Callback = function(Value)
            _G["activeslot"..index] = Value
            local claim = sui.Crafting.Frame.Body["Slot"..index].Content.Claim
            while _G["activeslot"..index] do
                wait(0.1)
                if claim.Visible then
                    rstorage.Event:FireServer("ClaimCrafting", index)
                else
                    rstorage.Event:FireServer("StartCrafting", index, _G["chosenACItem"..index], _G["chosenACAmount"..index])
                end
            end
        end
    })
end
craftingSlot(ACslot1, 1) craftingSlot(ACslot2, 2) craftingSlot(ACslot3, 3)


--[[x] EGGS TAB ]]--
agmain:AddDropdown({  -- Choose Egg
    Name = "🥚 Choose Egg",
    Default = "Elite Mystery Egg",
    Save = true,
    Flag = "autohatch_egg",
    Options = {"Prismatic Mystery Egg", "Elite Mystery Egg", "Mystery Egg"},
    Callback = function(Value)
        chosenEgg = Value
    end
})

agmain:AddToggle({  -- Auto Hatch
	Name = "🥚 Auto Hatch",
    Default = false,
	Callback = function(Value)
        getfenv().autohatch = Value
        while autohatch do wait(.1)
            rstorage.Function:InvokeServer("TryHatchEgg", chosenEgg)
        end
	end
})

--[[x] MISC TAB ]]--
cfg:AddButton({  -- Copy Equipped PetID To Clipboard
	Name = "🐾 Copy Equipped PetID To Clipboard",
	Callback = function()
        local pets = {}
        local invActive = false
        local inv = sui.Inventory.Frame.Main.Content.Pets.Grid.Content
        for _, child in ipairs(inv:GetChildren()) do
            if child:IsA("Frame") then
                invActive = true
            end
        end
        if not invActive then
            notify("Equipped Pet", "⚠️ Open Inventory > Pets > Equip your pet")
        else
            for i,v in ipairs(inv:GetDescendants()) do
                if v.Name == "Equipped" and v.Visible then
                    local pet = tostring(v.Parent.Parent)
                    setclipboard(pet)
                    notify("Equipped Pet", "Copied equipped PetID to clipboard, put it in getfenv().minigamePetID")
                    return
                end
            end
        end
  	end
})
mgui:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        notify("FPS Booster", "Credits: github.com/fdvll")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/fdvll/pet-simulator-99/main/cpuReducer.lua"))()
  	end
})
mgui:AddToggle({  -- Disable Snow
	Name = "❄️ Disable Snow",
	Default = false,
	Callback = function(Value)
        ws.Rendered.Snow.ParticleEmitter.Enabled = not Value
	end
})
mOther:AddButton({  -- Redeem All Codes
	Name = "🏷️ Redeem All Codes",
    Callback = function()
        local codesModule = require(game:GetService("ReplicatedStorage").Shared.Data.Codes)
        for code, _ in pairs(codesModule) do
            rstorage.Function:InvokeServer("RedeemCode", code)
            wait(0.5)
        end
        notify("Codes", "Redeemed All Codes")
    end
})
mOther:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        notify("Rejoin", "Rejoining...") wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, slp)
  	end
})
mOther:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        local serverHop = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()
        notify("Server Hopping...", "Credits: github.com/LeoKholYt") wait(1)
        serverHop:Teleport(game.PlaceId)
  	end
})
mOther:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function() lib:Destroy() end
})
lib:Init()
