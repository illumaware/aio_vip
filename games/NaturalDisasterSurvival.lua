local lib = loadstring(game:HttpGet('https://github.com/illumaware/c/blob/main/debug/BetterOrion.lua?raw=true'))()
local window = lib:MakeWindow({Name = "[Natural Disaster Survival] AIO", HidePremium = true, SaveConfig = false, IntroEnabled = false})

local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local stats = home:AddSection({ Name = "Stats" })
local winslabel = stats:AddLabel("🏆 Wins: Not in Top 10")
local maplabel = stats:AddLabel("🌍 Map: None")
local disasterlabel = stats:AddLabel("⚠️ Disaster: None")
local main = home:AddSection({ Name = "Main" })

local visuals = window:MakeTab({ Name = "Visuals", Icon = "rbxassetid://7733954760" })
local plr = visuals:AddSection({ Name = "Player" })
local wrld = visuals:AddSection({ Name = "World" })

local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })


local slp = game:GetService("Players").LocalPlayer
local ws = game:GetService("Workspace")
local rs = game:GetService("RunService")

local function updLabels()
    local top = ws.BillboardTop10.Board.SurfaceGui.Clipframe
    while task.wait() do
        local currentMap = ws.ContentModel.Information
        local survivalTag = slp.Character:FindFirstChild("SurvivalTag")

        for _, label in ipairs(top:GetDescendants()) do
            if label:IsA("TextLabel") and label.Name:find(slp.Name) then
                local winsLabel = label:FindFirstChild("WinsLabel")
                if winsLabel then winslabel:Set("🏆 Wins: "..winsLabel.Text) end
            end
        end

        maplabel:Set("🌍 Map: " .. (currentMap and currentMap.Value or "None"))

        if survivalTag then
            local tagValue = survivalTag.Value
            local disasterText = "⚠️ Disaster: " .. tagValue
            if tagValue == "Blizzard" then
                local exposureTag = survivalTag:FindFirstChild("ExposureTag")
                if exposureTag then
                    if exposureTag.Value >= 6 then
                        disasterText = disasterText.." [Exposure: "..exposureTag.Value.." - ❌ Unsafe]"
                    else
                        disasterText = disasterText.." [Exposure: "..exposureTag.Value.." - ✅ Safe]"
                    end
                end
            elseif tagValue == "Deadly Virus" then
                local infectedTag = slp.Character:FindFirstChild("InfectedTag")
                disasterText = disasterText.." [Infected: "..(infectedTag and "✅" or "❌").."]"
            end
            disasterlabel:Set(disasterText)
        else
            disasterlabel:Set("⚠️ Disaster: None")
        end
    end
end task.spawn(updLabels)


main:AddButton({  -- Telekinesis
	Name = "🔮 Telekinesis",
	Callback = function()
        loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-telekinesis-4718'))()
    end
})
main:AddToggle({  -- Freeze
	Name = "🧊 Freeze",
	Default = false,
	Callback = function(Value)
        slp.Character.HumanoidRootPart.Anchored = Value
	end
})
main:AddToggle({  -- Walk on Water
	Name = "🌊 Walk on Water",
	Default = false,
	Callback = function(Value)
        ws.WaterLevel.Size = Value and Vector3.new(1000, 1, 1000) or Vector3.new(10, 1, 10)
        ws.WaterLevel.CanCollide = Value
	end
})
main:AddButton({  -- Infinite Yield
	Name = "📟 Infinite Yield",
	Callback = function()
        loadstring(game:HttpGet('https://github.com/EdgeIY/infiniteyield/blob/master/source?raw=true'))()
    end
})


plr:AddToggle({  -- Hide Survivors UI
	Name = "👥 Hide Survivors UI",
	Default = true,
	Callback = function(Value)
        slp.PlayerGui.UIs.survivorDisplay.frameContainer.Visible = not Value
	end
})
plr:AddToggle({  -- Hide Damage Flash
	Name = "💢 Hide Damage Flash",
	Default = false,
	Callback = function(Value)
        slp.PlayerGui["Damage Flash"]["Flash Image"].Visible = not Value
	end
})
plr:AddToggle({  -- Hide Disaster UIs
	Name = "⚠️ Hide Disaster UIs",
	Default = true,
	Callback = function(Value)
        getfenv().removeDUIs = (Value and true or false)
        rs.RenderStepped:Connect(function()
            local sandstormGUI = slp.PlayerGui:FindFirstChild("SandStormGui")
            local blizzardGUI = slp.PlayerGui:FindFirstChild("BlizzardGui")
            if removeDUIs then
                if sandstormGUI then
                    sandstormGUI:Destroy()
                end
                if blizzardGUI then
                    blizzardGUI:Destroy()
                end
            end
        end)
	end
})

wrld:AddButton({  -- Remove Ads
	Name = "📺 Remove Ads",
	Callback = function()
        ws.ForwardPortal:Destroy()
        ws.BillboardAd:Destroy()
        ws.BillboardApple:Destroy()
        ws.BillboardBalloon:Destroy()
  	end
})
local wc = wrld:AddColorpicker({  -- Water Color
	Name = "🌊 Set Water Color",
	Default = Color3.fromRGB(13, 105, 172),
	Callback = function(Value)
		ws.WaterLevel.Color = Value
	end
})
wrld:AddButton({  -- Reset Water Color
	Name = "🌊 Reset Water Color",
	Callback = function()
        wc:Set(Color3.fromRGB(13, 105, 172))
  	end
})


misc:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        loadstring(game:HttpGet("https://github.com/fdvll/pet-simulator-99/blob/main/cpuReducer.lua?raw=true"))() -- Credits: github.com/fdvll
  	end
})
misc:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
  	end
})
misc:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        loadstring(game:HttpGet("https://github.com/LeoKholYt/roblox/blob/main/lk_serverhop.lua?raw=true"))():Teleport(game.PlaceId) -- Credits: github.com/LeoKholYt
  	end
})
misc:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function() lib:Destroy() end
})
lib:Init()
