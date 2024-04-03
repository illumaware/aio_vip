repeat task.wait() until game:IsLoaded()
local scripts = {
    [16510724413] = "PetCatchers",
    [5991163185]  = "SprayPaint",
    [8884433153]  = "CollectAllPets"
}

local name = scripts[game.PlaceId]
if name then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/illumaware/c/main/games/"..name..".lua"))()
else
    warn("[AIO] PlaceId "..game.PlaceId.." is not supported")
end
