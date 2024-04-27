local lib = loadstring(game:HttpGet('https://github.com/illumaware/c/blob/main/debug/BetterOrion.lua?raw=true'))()
local window = lib:MakeWindow({Name = "[RNG Gods] AIO", HidePremium = true, SaveConfig = false, IntroEnabled = false})

local home = window:MakeTab({ Name = "Home", Icon = "rbxassetid://7733960981" })
local roll = home:AddSection({ Name = "Roll" })
local wrld = home:AddSection({ Name = "World" })
local obbyLabel = wrld:AddLabel("⛰ Mountain Obby")

local upgrades = window:MakeTab({ Name = "Upgrades", Icon = "rbxassetid://7733942651" })
local crafting = window:MakeTab({ Name = "Crafting", Icon = "rbxassetid://7743878358" })
local misc = window:MakeTab({ Name = "Misc", Icon = "rbxassetid://7734053495" })
local mgui = misc:AddSection({ Name = "Render" })
local mOther = misc:AddSection({ Name = "Other" })

local function notify(name,content) lib:MakeNotification({ Name = name, Content = content, Image = "rbxassetid://7733911828", Time = 5 }) end  -- Notifications
local slp = game:GetService("Players").LocalPlayer
local sui = slp.PlayerGui.ScreenGui
local chr = slp.Character
local humRootPart = chr.HumanoidRootPart
local rstorage = game:GetService("ReplicatedStorage")
local ws = game:GetService("Workspace")
local rs = game:GetService("RunService")
local mObbytimer = ws.ObbyToucher.ObbyTouchPart.BillboardGui

local function updLabels()
    while task.wait() do
        if mObbytimer.Enabled then
            local timertext = ws.ObbyToucher.ObbyTouchPart.BillboardGui.TextLabel.Text
            obbyLabel:Set("⛰ Mountain Obby: ⏳ "..timertext)
        else
            obbyLabel:Set("⛰ Mountain Obby: ✅ Ready")
        end
    end
end task.spawn(updLabels)
sui.BotRight.UIGridLayout.CellSize = UDim2.new(0.06,0,0.06,0)
sui.BotRight.UIGridLayout.FillDirectionMaxCells = 6


roll:AddToggle({  -- Auto Roll
	Name = "🎲 Auto Roll",
	Default = false,
	Callback = function(Value)
        getfenv().autoRoll = Value
        if autoRoll then notify("Auto Roll", "Enabled Auto Roll") end
        while autoRoll do
            rstorage.Roll:FireServer()
            rstorage.Events.Claim:InvokeServer()
            wait(.1)
        end
	end
})
roll:AddToggle({  -- Hide Roll UI
	Name = "🎲 Hide Roll UI",
	Default = false,
	Callback = function(Value)
        getfenv().hideRollUI = Value
        if hideRollUI then
            HRUconnect = rs.RenderStepped:Connect(function()
                sui.Cover.Visible = false
                sui.center.Visible = false
                sui.BotButtons.Visible = true
            end)
        else
            if HRUconnect then
                HRUconnect:Disconnect()
            end
        end
	end
})

wrld:AddToggle({  -- Auto Complete Mountain Obby
	Name = "⛰ Auto Complete Mountain Obby",
	Default = false,
	Callback = function(Value)
        getfenv().autoObby = Value
        local obbyPos = ws.ObbyToucher.NeonPart.Position
        while autoObby do wait()
            local currentPos = chr and humRootPart.Position
            if not mObbytimer.Enabled then
                chr:MoveTo(obbyPos)
                notify("World", "Completed Obby [+30% Luck]")
                wait(1)
                chr:MoveTo(currentPos)
            end
        end
	end
})
wrld:AddToggle({  -- Auto Collect Drops
    Name = "🍀 Auto Collect Drops",
    Default = false,
    Callback = function(Value)
        getfenv().autoDrops = Value
        while autoDrops do wait()
            local dropTypes = {"Capsule", "Cinderberry", "Gloopberry", "Shockfruit"}
            for _, model in ipairs(ws:GetChildren()) do
                if table.find(dropTypes, model.Name) then
                    local partName = (model.Name == "Capsule") and "capsule" or "Fruit"
                    local part = model:FindFirstChild(partName)
                    if part then
                        local prompt = part:FindFirstChild("ProximityPrompt")
                        if prompt then
                            chr:MoveTo(part.Position)
                            wait(.5)    
                            fireproximityprompt(prompt, 1, true)
                            notify("World", "Collected "..model.Name)
                        end
                        wait(1)
                    end
                end
            end
        end
    end
})

upgrades:AddButton({  -- Show Upgrades UI
	Name = "⚡ Show Upgrades UI",
	Callback = function()
        sui.MidContainer.Upgrades.Visible = true
	end
})
upgrades:AddDropdown({  -- Choose Upgrade
	Name = "⚡ Choose Upgrade",
	Default = "",
	Options = {"Luck", "Roll Cooldown", "2X Luck Rolls", "5X Luck Rolls", "Fruit Duration"},
	Callback = function(Value)
		chosenUpgrade = Value
	end
})
upgrades:AddToggle({  -- Auto Upgrade
	Name = "⚡ Auto Upgrade",
	Default = false,
	Callback = function(Value)
        getfenv().autoUpgrade = Value
        while autoUpgrade do
            rstorage.Events.PurchaseUpgrade:InvokeServer(chosenUpgrade)
            wait(1)
        end
	end
})

crafting:AddButton({  -- Show Crafting UI
	Name = "🛠️ Show Crafting UI [Coming Soon]",
	Callback = function()
        sui.MidContainer.Crafting.Visible = true
	end
})

mgui:AddToggle({  -- Hide Notifications
	Name = "📺 Hide Notifications",
	Default = true,
	Callback = function(Value)
        sui.Notifications.notif.Visible = not Value
	end
})
mOther:AddButton({  -- FPS Booster
	Name = "🚀 FPS Booster",
	Callback = function()
        loadstring(game:HttpGet("https://github.com/fdvll/pet-simulator-99/blob/main/cpuReducer.lua?raw=true"))() -- Credits: github.com/fdvll
  	end
})
mOther:AddButton({  -- Rejoin
	Name = "🔄 Rejoin",
	Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
  	end
})
mOther:AddButton({  -- Server Hop
	Name = "⏩ Server Hop",
	Callback = function()
        loadstring(game:HttpGet("https://github.com/LeoKholYt/roblox/blob/main/lk_serverhop.lua?raw=true"))():Teleport(game.PlaceId) -- Credits: github.com/LeoKholYt
  	end
})
mOther:AddButton({  -- Destroy UI
	Name = "❌ Destroy UI",
	Callback = function() lib:Destroy() end
})
lib:Init()
