local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local w = library:CreateWindow("Chubsware")
local d = w:CreateFolder("Player")
local f = w:CreateFolder("Auto Buy")
local g = w:CreateFolder("Fishing")
local h = w:CreateFolder("Misc")

local rstorage = game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote
local codes = {"Release", "Cherry", "lucky", "brite", "ilovefishing", "russoplays", "gravypet"}
local vu = game:service'VirtualUser'

game:service'Players'.LocalPlayer.Idled:connect(function()
    vu:CaptureController()
    vu:ClickButton2(Vector2.new())
    warn("[Debug] ✅ AntiAFK is active")
end)

d:Toggle("Claim Bruh Bounty Quest", function(bool)
    shared.toggle = bool
    AClaimBquest = bool
    if AClaimBquest == true then warn("[Debug] ✅ Enabled AutoClaim Bruh Bounty Quest") end
end)

d:Toggle("Godmode", function(bool)
    shared.toggle = bool
    godmode = bool
    local lp = game.Players.LocalPlayer.Character.Humanoid
    if godmode == true then
        lp.MaxHealth = math.huge
        lp.Health = math.huge
        warn("[Debug] ✅ Enabled Godmode")
    else
        lp.MaxHealth = 800
        lp.Health = 800
        warn("[Debug] ❌ Disabled Godmode")
    end
end)

f:Toggle("💰 Buy Auburn Shop", function(bool)
    shared.toggle = bool
    ABAuburnShop = bool
    if ABAuburnShop == true then warn("[Debug] ✅ Enabled AutoBuy Auburn Shop") end
end)

f:Toggle("💰 Buy Magic Shop", function(bool)
    shared.toggle = bool
    ABMagicShop = bool
    if ABMagicShop == true then warn("[Debug] ✅ Enabled AutoBuy Magic Shop") end
end)

f:Toggle("💎 Buy Gem Trader", function(bool)
    shared.toggle = bool
    ABGemTrader = bool
    if ABGemTrader == true then warn("[Debug] ✅ Enabled AutoBuy Gem Trader") end
end)

f:Toggle("💎 Buy Blackmarket", function(bool)
    shared.toggle = bool
    ABBlackmarket = bool
    if ABBlackmarket == true then warn("[Debug] ✅ Enabled AutoBuy Blackmarket") end
end)

g:Toggle("🐟 Sell Fish", function(bool)
    shared.toggle = bool
    ASFish = bool
    if ASFish == true then warn("[Debug] ✅ Enabled AutoSell Fish") end
end)

h:Label("AntiAFK is enabled by default",{
    TextSize = 14;
    TextColor = Color3.fromRGB(255,255,255);
    BgColor = Color3.fromRGB(38,38,38);
}) 

h:Button("Redeem all codes",function()
    for _, code in pairs(codes) do
        rstorage.Function:InvokeServer("RedeemCode", code)
        warn("[Debug] ✅ Redeemed " .. code .. " code")
        wait(0.5)
    end
end)

h:DestroyGui()

while task.wait() do
    if AClaimBquest == true then
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("FinishedQuestDialog", "bruh-bounty")
        wait(5)
    end
    if ASFish == true then
        game:GetService("ReplicatedStorage").Shared.Framework.Network.Remote.Event:FireServer("SellFish")
        wait(0.1)
    end
    if ABAuburnShop == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "auburn-shop", i)
        end
        wait(0.1)
    end
    if ABMagicShop == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "magic-shop", i)
        end
        wait(0.1)
    end
    if ABGemTrader == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "gem-trader", i)
        end
        wait(0.1)
    end
    if ABBlackmarket == true then
        for i = 1, 3 do
            rstorage.Event:FireServer("BuyShopItem", "the-blackmarket", i)
        end
        wait(0.1)
    end
end
