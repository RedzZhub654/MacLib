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
        -- The full window is draggable by default. Set DragStyle = 1 for icon-only dragging.
        AcrylicBlur = true,

        AutoDPI = true,
        AutoDPIMinScale = 0.35,
        AutoDPIMargin = 32,

        -- Customizable side-and-corner glow.
        WindowGlowColor = Color3.fromRGB(129, 103, 255),
        WindowGlowTransparency = 0.955,
        WindowGlowStrokeTransparency = 0.84,

        -- Fixed mobile button: tap it only to open or close the UI.
        MobileToggleButton = true,
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
    Body = "Drag the window from its surface. On touch devices, tap the fixed button to open or close the UI.",
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
