local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wall%20v3')))()
local w = library:CreateWindow("Jiggahub")
local f = w:CreateFolder("Main")
local rep = game:GetService("ReplicatedStorage")

f:Button("Test",function()
    print("Test")
end)

f:Toggle("AutoBuy Auburn Shop", function(bool)
    shared.toggle = bool
    ABAuburnShop = bool
    if ABAuburnShop == true then warn("[Debug] Enabled AutoBuy Auburn Shop") end
end)

f:Toggle("💎 AutoBuy Gem Trader", function(bool)
    shared.toggle = bool
    ABGemTrader = bool
    if ABGemTrader == true then warn("[Debug] Enabled AutoBuy Gem Trader") end
end)

f:Toggle("AutoBuy Magic Shop", function(bool)
    shared.toggle = bool
    ABMagicShop = bool
    if ABMagicShop == true then warn("[Debug] Enabled AutoBuy Magic Shop") end
end)

f:Toggle("💎 AutoBuy Blackmarket", function(bool)
    shared.toggle = bool
    ABBlackmarket = bool
    if ABBlackmarket == true then warn("[Debug] Enabled AutoBuy Blackmarket") end
end)

f:DestroyGui()

while task.wait() do
    if ABAuburnShop == true then
        for i = 1, 3 do
            rep.Shared.Framework.Network.Remote.Event:FireServer("BuyShopItem", "auburn-shop", i)
        end
        wait(0.1)
    end
    if ABGemTrader == true then
        for i = 1, 3 do
            rep.Shared.Framework.Network.Remote.Event:FireServer("BuyShopItem", "gem-trader", i)
        end
        wait(0.1)
    end
    if ABMagicShop == true then
        for i = 1, 3 do
            rep.Shared.Framework.Network.Remote.Event:FireServer("BuyShopItem", "magic-shop", i)
        end
        wait(0.1)
    end
    if ABBlackmarket == true then
        for i = 1, 3 do
            rep.Shared.Framework.Network.Remote.Event:FireServer("BuyShopItem", "the-blackmarket", i)
        end
        wait(0.1)
    end
end
