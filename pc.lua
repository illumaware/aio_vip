-- loadstring(game:HttpGet("https://raw.githubusercontent.com/illumaware/c/main/pc.lua"))()

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
	Name = "Autobuy"
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

local misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local rstorage = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote
local codes = {"runes", "lucky", "cherry", "cherries", "gravypet", "update1", "russoplays", "release", "void", "ilovefishing", "brite"}
local shrines = {"egg", "gem", "cube", "berry", "radioactive", "better-cube", "cherry", "ticket", "rune"}
local vu = game:service'VirtualUser'
local slp = game:GetService("Players").LocalPlayer
local sui = slp.PlayerGui.ScreenGui
local lp = game.Players.LocalPlayer.Character.Humanoid
local quests = sui.Quests.List:GetChildren()

game:service'Players'.LocalPlayer.Idled:connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
end)


-- MAIN
main:AddToggle({  -- Godmode
	Name = "🛡️ Godmode",
	Default = false,
	Callback = function(Value)
        godmode = Value
        if godmode then
            lp.MaxHealth = math.huge
            lp.Health = math.huge
            warn("[Debug] ✅ Enabled Godmode")
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
            warn("[Debug] ✅ Teleported to " .. Value)
        else
            rstorage.Event:FireServer("TeleportBeacon", "Magma Basin", Value)
            warn("[Debug] ✅ Teleported to " .. Value)
        end
	end
})


-- ELIXIRS
elixrs:AddToggle({  -- Auto-Use Elixir
	Name = "🧪 Auto-Use Elixir",
	Default = false,
	Callback = function(Value)
        AUElixir = Value
        if AUElixir == true then warn("[Debug] ✅ Enabled Auto-Use Elixir") end    
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
        if ASFish == true then warn("[Debug] ✅ Enabled Auto-Sell Fish") end
	end    
})


-- AUTOBUY
autobuy:AddToggle({  -- Buy Auburn Shop
	Name = "💰 Buy Auburn Shop",
	Default = false,
	Callback = function(Value)
        ABAuburnShop = Value
        if ABAuburnShop == true then warn("[Debug] ✅ Enabled Auto-Buy Auburn Shop") end
	end    
})
autobuy:AddToggle({  -- Buy Magic Shop
	Name = "💰 Buy Magic Shop",
	Default = false,
	Callback = function(Value)
        ABMagicShop = Value
        if ABMagicShop == true then warn("[Debug] ✅ Enabled Auto-Buy Magic Shop") end
    end
})
autobuy:AddToggle({  -- Buy Gem Trader
	Name = "💎 Buy Gem Trader",
	Default = false,
	Callback = function(Value)
        ABGemTrader = Value
        if ABGemTrader == true then warn("[Debug] ✅ Enabled Auto-Buy Gem Trader") end
	end    
})
autobuy:AddToggle({  -- Buy Blackmarket
	Name = "💎 Buy Blackmarket",
	Default = false,
	Callback = function(Value)
        ABBlackmarket = Value
        if ABBlackmarket == true then warn("[Debug] ✅ Enabled Auto-Buy Blackmarket") end
    end
})


-- SHRINES
autoshrines:AddToggle({  -- Auto-Collect Shrines
	Name = "⚱️ Auto-Collect Shrines",
	Default = false,
	Callback = function(Value)
        ACShrines = Value
        if ACShrines == true then warn("[Debug] ✅ Enabled Auto-Collect shrines") end
	end
})


-- QUESTS
quest:AddToggle({  -- Auto-Claim All Quests
	Name = "📜 Auto-Claim All Quests",
	Default = false,
	Callback = function(Value)
        AClaimQuest = Value
        if AClaimQuest == true then warn("[Debug] ✅ Enabled Auto-Claim All Quests") end
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
misc:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function()
        OrionLib:Destroy()
  	end    
})


-- LOGIC
while task.wait() do  -- Toggles Logic
    if AUElixir == true then
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
    if ACShrines == true then
        for _, shrine in pairs(shrines) do
            local cdText = game:GetService("Workspace").Shrines[shrine].Action.BillboardGui.Cooldown.Text
            if cdText == "0s" then
                rstorage.Event:FireServer("UseShrine", shrine)
                warn("[Debug] ✅ Collected " .. shrine .. " shrine")
                wait(1)
            end
        end
    end
    if AClaimQuest == true then
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
    if ASFish == true then
        rstorage.Event:FireServer("SellFish")
        wait(.1)
    end
    if ABAuburnShop == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "auburn-shop", i)
        end
        wait(.05)
    end
    if ABMagicShop == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "magic-shop", i)
        end
        wait(.05)
    end
    if ABGemTrader == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "gem-trader", i)
        end
        wait(.05)
    end
    if ABBlackmarket == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "the-blackmarket", i)
        end
        wait(.05)
    end
end


OrionLib:Init()
