-- MacLib single working example
-- Run this file directly, or use the one-line loader in the README.

local SOURCE_URL = "https://raw.githubusercontent.com/RedzZhub654/MacLib/main/maclib.txt"

local loaded, MacLib = pcall(function()
    return loadstring(game:HttpGet(SOURCE_URL))()
end)

if not loaded or type(MacLib) ~= "table" then
    warn("[MacLib] Load failed:", MacLib)
    return
end

local created, Window = pcall(function()
    return MacLib:Window({
        Title = "MacLib",
        Subtitle = "Single working example",
        Size = UDim2.fromOffset(900, 650),
        Keybind = Enum.KeyCode.RightControl,
        AcrylicBlur = true,

        AutoDPI = true,
        AutoDPIMinScale = 0.35,
        AutoDPIMargin = 32,

        -- Remains visible while the window is open or minimized on touch devices.
        MobileFloatButton = true,

        -- Resizes independently on small screens.
        PlayerStatsEnabled = true,
        PlayerStatsAutoDPI = true,
        PlayerStatsMargin = 16,
        PlayerStatsBadge = "LIVE",
    })
end)

if not created then
    warn("[MacLib] Window creation failed:", Window)
    return
end

local Tabs = Window:TabGroup()
local Home = Tabs:Tab({
    Name = "Home",
    Image = "rbxassetid://10723426393",
})

local Main = Home:Section({ Side = "Left" })
Main:Header({ Text = "MacLib is running" })
Main:Paragraph({
    Header = "Success",
    Body = "This is the repository's only example.lua. The window, mobile float, and player stats are active.",
})

Main:Toggle({
    Name = "Example toggle",
    Default = false,
    Callback = function(enabled)
        print("[MacLib] Toggle value:", enabled)
    end,
})

Main:Button({
    Name = "Show notification",
    Callback = function()
        Window:Notify({
            Title = "MacLib works",
            Description = "The example button callback ran successfully.",
            Lifetime = 3,
        })
    end,
})

Home:Select()
Window:Notify({
    Title = "MacLib loaded",
    Description = "Press RightControl to toggle the window.",
    Lifetime = 5,
})
