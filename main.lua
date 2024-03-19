local placeId = game.PlaceId

if placeId == 16510724413 then
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/illumaware/c/main/games/PetCatchers.lua')))()
elseif placeId == 5991163185 then
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/illumaware/c/main/games/SprayPaint.lua')))()
elseif placeId == 8884433153 then
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/illumaware/c/main/games/CollectAllPets.lua')))()
else
    print("[AIO] No scripts found for "..placeId.." placeId")
end
