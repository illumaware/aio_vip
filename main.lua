repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
if getgenv().aioExec then return end getgenv().aioExec = true

local scripts = {
    [16510724413] = "PetCatchers",
    [5991163185]  = "SprayPaint",
    [8884433153]  = "CollectAllPets",
    [16524008257] = "AnimeRNG",
    [11572573905] = "PressureWashSimulator2",
    [189707]      = "NaturalDisasterSurvival",
    [16993380837] = "RNGGods",
    [16828215247] = "RNGRollers"
}

local sName = scripts[game.PlaceId]
if sName then
    warn("["..game.PlaceId.."] ✅ Supported game found, loading "..sName..".lua")
    loadstring(game:HttpGet("https://github.com/illumaware/c/blob/main/games/"..sName..".lua?raw=true"))()
else
    warn("["..game.PlaceId.."] ❌ This game is not supported yet")
end
