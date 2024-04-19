local a = getconnections or get_signal_cons
if a then
    for b, c in pairs(a(game:GetService("Players").LocalPlayer.Idled)) do
        if c["Disable"] then
            c["Disable"](c)
        elseif c["Disconnect"] then
            c["Disconnect"](c)
        end
    end
else
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        local d = game:GetService("VirtualUser")
        d:CaptureController()
        d:ClickButton2(Vector2.new())
    end)
end
