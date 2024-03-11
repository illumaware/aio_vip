-- loadstring(game:HttpGet("https://raw.githubusercontent.com/illumaware/c/main/pc.lua"))()

--[[
    TODO:
    Auto Kraken & Slime
    Auto Minigames
    Auto Hatch pets
    Add walk and teleport farm type to auto kill
    Add coins count to stats + speed per minute
    Add teleports to npcs + quests + shops
]]--

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "[Pet Catchers] AIO", HidePremium = true, SaveConfig = false, ConfigFolder = "Orion"})


local home = Window:MakeTab({
	Name = "Home",
	Icon = "rbxassetid://7733960981",
	PremiumOnly = false
})
local hmain = home:AddSection({ Name = "Main" })
hmain:AddParagraph("Welcome to AIO", "v2.2 [debug]")
local notifyevents = hmain:AddLabel("🎉 No Current Events")
local newcodelabel = hmain:AddLabel("🏷️ No New Codes Are Available")
local sessStats = home:AddSection({ Name = "Session Stats" })
local enemycount = sessStats:AddLabel("⚔️ Enemies Killed This Session: 0 [Total: 0]")
local eggstats = sessStats:AddLabel("🥚 Eggs Hatched This Session: 0 [Total: 0]")


local player = Window:MakeTab({
	Name = "Player",
	Icon = "rbxassetid://7743875962",
	PremiumOnly = false
})
local main = player:AddSection({ Name = "Main" })
local teleports = player:AddSection({ Name = "Teleports" })
local elixrs = player:AddSection({ Name = "Elixirs" })


local auto = Window:MakeTab({
	Name = "Automation",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local autobuy = auto:AddSection({ Name = "Shops" })
local autoshrines = auto:AddSection({ Name = "Shrines" })
local fishing = auto:AddSection({ Name = "Fishing" })
local quest = auto:AddSection({ Name = "Quests" })


local autofarm = Window:MakeTab({
	Name = "Mob Farming",
	Icon = "rbxassetid://7733674079",
	PremiumOnly = false
})
local Estats = autofarm:AddSection({ Name = "Stats" })
local enemynames = Estats:AddLabel("Enemy Name: None")
local enemynum = Estats:AddLabel("No Enemies")
local afmain = autofarm:AddSection({ Name = "Main" })


local autocrafting = Window:MakeTab({
	Name = "Crafting",
	Icon = "rbxassetid://7743878358",
	PremiumOnly = false
})
local ACslot1 = autocrafting:AddSection({ Name = "Slot 1" })
local ACslot2 = autocrafting:AddSection({ Name = "Slot 2" })
local ACslot3 = autocrafting:AddSection({ Name = "Slot 3" })


local autoeggs = Window:MakeTab({
	Name = "Eggs",
	Icon = "rbxassetid://8997385940",
	PremiumOnly = false
})
local agmain = autoeggs:AddSection({ Name = "Main" })


local misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://7734053495",
	PremiumOnly = false
})
local mgui = misc:AddSection({ Name = "Render" })
local mother = misc:AddSection({ Name = "Other" })


--[[ VARIABLES ]]--
local rstorage = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote
local codes = {"runes", "lucky", "cherry", "cherries", "gravypet", "update1", "russoplays", "release", "void", "ilovefishing", "brite"}
local all_events = {"Boss Rush", "Lucky", "Fortune", "Mob Rush", "Quick Fishing", "Treasure", "Shiny Hunt", "Master Chef", "Gamer"}
local shrinenames = {"egg", "gem", "cube", "berry", "radioactive", "better-cube", "cherry", "ticket", "rune"}
local vu = game:GetService("VirtualUser")
local slp = game:GetService("Players").LocalPlayer
local ws = game:GetService("Workspace")
local sui = slp.PlayerGui.ScreenGui
local lp = game.Players.LocalPlayer.Character.Humanoid
local quests = sui.Quests.List:GetChildren()
local sGuiHolder = slp.PlayerGui.ScreenGuiHolder
local function textToNumber(text) return tonumber(text:gsub(",", ""):match("%d+")) end
local enemiesKilled = 0
local totalNumberPath = sui.Debug.Stats.Frame.List.EnemiesDefeated.Total
local previousTotalNumber = textToNumber(totalNumberPath.Text)
local sessionCount = 0

local eggsHatchedPath = slp.leaderstats["🥚 Hatched"]
local previouseggsHatchedNumber = eggsHatchedPath.Value
local eggsSession = 0


--[[ FUNCTIONS ]]--
slp.Idled:connect(function()  -- AntiAFK
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)

local function notify(name, content)  -- Notifications
    OrionLib:MakeNotification({
        Name = name,
        Content = content,
        Image = "rbxassetid://7733911828",
        Time = 5
    })
end

local function redeemNewCode()  -- Redeem New Codes
    local findsGui = nil

    for _, surfaceGui in pairs(sGuiHolder:GetChildren()) do
        if surfaceGui:IsA("SurfaceGui") then
            local frame = surfaceGui:FindFirstChild("Frame")
            if frame then
                local code = frame:FindFirstChild("Code")
                if code and code:IsA("TextLabel") then
                    findsGui = surfaceGui
                    break
                end
            end
        end
    end

    if findsGui then
        local newcode = findsGui.Frame.Code.Text
        local cleanednewcode = newcode:sub(2, -2)
        rstorage.Function:InvokeServer("RedeemCode", cleanednewcode)
        newcodelabel:Set("🏷️ Redeemed New Code: " ..cleanednewcode)
        notify("New Code", "Redeemed: " .. cleanednewcode)
    end
end

local function updateEnemyCountLabel()  -- Enemy Count Label Updater
    local currentTotalNumber = textToNumber(totalNumberPath.Text)
    local enemiesKilledThisSession = currentTotalNumber - previousTotalNumber
    sessionCount = sessionCount + enemiesKilledThisSession
    local totalNumber = currentTotalNumber
    enemycount:Set("⚔️ Enemies Killed This Session: " .. sessionCount .. " [Total: " .. totalNumber .. "]")
end

local function updateEggsCountLabel()  -- Eggs Count Label Updater
    local currentEggsNumber = eggsHatchedPath.Value
    local eggsHatchedThisSession = currentEggsNumber - previouseggsHatchedNumber
    eggsSession = eggsSession + eggsHatchedThisSession
    local eggsTotalNumber = currentEggsNumber
    eggstats:Set("🥚 Eggs Hatched This Session: " .. eggsSession .. " [Total: " .. eggsTotalNumber .. "]")
end

local function checkEvents()  -- Check Events Label Updater
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
        notifyevents:Set("🎉 No Current Events")
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
teleports:AddDropdown({  -- Regions Teleport
	Name = "🏪 Shops",
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

elixrs:AddDropdown({  -- Choose Elixir
	Name = "🧪 Choose Elixir",
	Default = "",
	Options = {"Farm (Coin & XP)","Coin","XP","Lucky","Sea"},
	Callback = function(Value)
		chosenElx = Value
	end
})
elixrs:AddToggle({  -- Auto Use Elixir
	Name = "🧪 Auto Use Elixir",
	Default = false,
	Callback = function(Value)
        AUElixir = Value
        if AUElixir then warn("[Debug] ✅ Enabled Auto Use Elixir") end    
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

local shrinefix = true
autoshrines:AddToggle({  -- Auto Collect Shrines
	Name = "⚱️ Auto Collect Shrines",
	Default = false,
	Callback = function(Value)
        ACShrines = Value
        if ACShrines then warn("[Debug] ✅ Enabled Auto Collect shrines") end
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


--[[ MOB FARMING TAB ]]--
afmain:AddToggle({  -- Auto Kill Enemies
	Name = "⚔️ Auto Kill Enemies",
	Default = false,
	Callback = function(Value)
        AFkill = Value
        if AFkill then
            gm:Set(true)
            warn("[Debug] ✅ Enabled Auto Kill Enemies")
            notify("Auto Kill", "Enabled Auto Kill Enemies")
        end
	end
})
updateEnemyCountLabel()


--[[ CRAFTING TAB ]]--
local CraftItemMap = {
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
        chosenACItem1 = CraftItemMap[Value] or ""
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
        chosenACItem2 = CraftItemMap[Value] or ""
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
        chosenACItem3 = CraftItemMap[Value] or ""
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
updateEggsCountLabel()

--[[ MISC TAB ]]--
redeemNewCode()
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
	Callback = function()
        for _, code in pairs(codes) do
            rstorage.Function:InvokeServer("RedeemCode", code)
            wait(.5)
        end
        notify("Codes", "Redeemed All Codes")
  	end    
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
        notify("Server Hop", "Server Hopping...")
        wait(1)
        sh:Teleport(game.PlaceId)
  	end
})
mother:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function()
        OrionLib:Destroy()
  	end    
})



-- LOGIC
while task.wait() do
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
            local cdText = ws.Shrines[shrine].Action.BillboardGui.Cooldown.Text
            if cdText == "0s" or shrinefix then
                rstorage.Event:FireServer("UseShrine", shrine)
                if shrinefix == false then
                    notify("Shrines", "Collected " .. shrine .. " shrine")
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
                                wait(1)
                            end

                            for i = 1, 30 do
                                local omackaQ = "omacka-" .. i
                                rstorage.Event:FireServer("FinishedQuestDialog", omackaQ)
                                wait(1)
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
    
        enemynum:Set("Number Of Enemies: " .. numEnemies)
        enemynames:Set("Enemy Name: " .. enemyNameString)
    else
        enemynum:Set("No Enemies")
        enemynames:Set("Enemy Name: None")
    end
    
    local currentEggsNumber = eggsHatchedPath.Value
    if currentEggsNumber ~= previouseggsHatchedNumber then
        updateEggsCountLabel()
        previouseggsHatchedNumber = currentEggsNumber
    end

    local currentTotalNumber = textToNumber(totalNumberPath.Text)
    if currentTotalNumber ~= previousTotalNumber then
        updateEnemyCountLabel()
        previousTotalNumber = currentTotalNumber
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
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Function:InvokeServer("TryHatchEgg", chosenEgg)
        wait(.01)
    end

    checkEvents()
end

OrionLib:Init()
