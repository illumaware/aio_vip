local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/2.0.4/bundle.lua"))().Init(game.CoreGui)
local HttpGet = game.HttpGet

local scripts = {
    ModuleDecompiler = "https://rawscripts.net/raw/Universal-Script-Simple-Module-Script-Decompiler-9958",
    Dex = "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua",
    Hydroxide = {owner = "Upbolt", branch = "revision", files = {"init", "ui/main"}}
}

local function webImport(file)
    return loadstring(HttpGet(game, ("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(scripts.Hydroxide.owner, scripts.Hydroxide.branch, file)))()
end

local buttons = {
    {name = "Module Decompiler", action = function() loadstring(HttpGet(game, scripts.ModuleDecompiler))() end},
    {name = "Hydroxide", action = function() for _, file in ipairs(scripts.Hydroxide.files) do webImport(file) end end},
    {name = "BetterDex", action = function() loadstring(HttpGet(game, scripts.Dex))() end},
    {name = "Rejoin", action = function() game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer) end}
}

Iris:Connect(function()
    local windowSize = Iris.State(Vector2.new(200, 150))

    Iris.Window({"Debug menu"}, {size = windowSize})
        for _, button in ipairs(buttons) do
            if Iris.Button({button.name}).clicked() then
                button.action()
            end
        end
    Iris.End()
end)
