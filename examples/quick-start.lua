-- MacLib quick start
-- Copy this entire file or run the raw URL shown in the README.

local SOURCE_URL = "https://raw.githubusercontent.com/RedzZhub654/MacLib/main/maclib.txt"

local loaded, MacLib = pcall(function()
    return loadstring(game:HttpGet(SOURCE_URL))()
end)

if not loaded or type(MacLib) ~= "table" then
    warn("[MacLib] The library could not be loaded:", MacLib)
    return
end

local created, Window = pcall(function()
    return MacLib:Window({
        Title = "MacLib Quick Start",
        Subtitle = "Your first working window",
        Size = UDim2.fromOffset(900, 650),
        Keybind = Enum.KeyCode.RightControl,
        AcrylicBlur = true,
        AutoDPI = true,
        -- This touch control remains visible even while the window is open.
        MobileFloatButton = true,
        PlayerStatsEnabled = false,
    })
end)

if not created then
    warn("[MacLib] The window could not be created:", Window)
    return
end

local Tabs = Window:TabGroup()
local Home = Tabs:Tab({
    Name = "Home",
    Image = "rbxassetid://10723426393",
})

local Content = Home:Section({ Side = "Left" })
Content:Header({ Text = "MacLib is running" })
Content:Paragraph({
    Header = "Success",
    Body = "This window was created by examples/quick-start.lua.",
})

Content:Button({
    Name = "Show notification",
    Callback = function()
        Window:Notify({
            Title = "It works",
            Description = "Your callback is running correctly.",
            Lifetime = 3,
        })
    end,
})

Home:Select()
Window:Notify({
    Title = "MacLib loaded",
    Description = "Press RightControl to toggle this window.",
    Lifetime = 5,
})
