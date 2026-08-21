-- MacLib end-to-end test example
-- Load the same revision you intend to test in your project.

local MacLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RedzZhub654/MacLib/main/maclib.txt"
))()

local Window = MacLib:Window({
    Title = "MacLib Test Lab",
    Subtitle = "Interactive component showcase",
    Size = UDim2.fromOffset(900, 650),
    DragStyle = 1,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,

    -- Mobile accessibility
    MobileFloatButton = true,
    MobileFloatButtonPosition = UDim2.new(1, -24, 1, -24),

    -- Floating player status bar
    PlayerStatsEnabled = true,
    PlayerStatsBadge = "TEST",
    PlayerStatsPosition = UDim2.new(0.5, 0, 0, 16),
    PlayerStatsDraggable = true,
})

Window:GlobalSetting({
    Name = "Acrylic Blur",
    Default = Window:GetAcrylicBlurState(),
    Callback = function(enabled)
        Window:SetAcrylicBlurState(enabled)
    end,
})

local TabGroup = Window:TabGroup()
local MainTab = TabGroup:Tab({
    Name = "Main",
    Image = "rbxassetid://10723426393", -- line-chart icon
})
local SettingsTab = TabGroup:Tab({
    Name = "Settings",
    Image = "rbxassetid://10709810948", -- cog icon
})

local MainLeft = MainTab:Section({ Side = "Left" })
local MainRight = MainTab:Section({ Side = "Right" })
local SettingsLeft = SettingsTab:Section({ Side = "Left" })

MainLeft:Header({ Text = "Interactive controls" })
MainLeft:Paragraph({
    Header = "Test Lab",
    Body = "Use these controls to verify callbacks, values, and live UI updates.",
})

local enabled = MainLeft:Toggle({
    Name = "Enable feature",
    Default = false,
    Callback = function(value)
        Window:Notify({
            Title = "Feature state",
            Description = value and "Feature enabled." or "Feature disabled.",
            Lifetime = 3,
        })
    end,
}, "FeatureEnabled")

local strength = MainLeft:Slider({
    Name = "Strength",
    Default = 50,
    Minimum = 0,
    Maximum = 100,
    DisplayMethod = "Percent",
    Precision = 0,
    Callback = function(value)
        print("Strength changed to", value)
    end,
}, "Strength")

MainLeft:Input({
    Name = "Message",
    Placeholder = "Type something...",
    AcceptedCharacters = "All",
    Callback = function(text)
        Window:Notify({
            Title = "Input received",
            Description = text == "" and "No message entered." or text,
            Lifetime = 3,
        })
    end,
}, "Message")

MainLeft:Button({
    Name = "Show current values",
    Callback = function()
        Window:Notify({
            Title = "Current values",
            Description = string.format(
                "Feature: %s | Strength: %s",
                enabled:GetState() and "on" or "off",
                tostring(strength:GetValue())
            ),
            Lifetime = 4,
        })
    end,
})

MainRight:Header({ Text = "Selections" })
MainRight:Dropdown({
    Name = "Theme",
    Search = true,
    Multi = false,
    Required = true,
    Options = { "Dark", "Light", "System" },
    Default = 1,
    Callback = function(value)
        print("Selected theme:", value)
    end,
}, "Theme")

MainRight:Colorpicker({
    Name = "Accent color",
    Default = Color3.fromRGB(244, 101, 92),
    Alpha = 0,
    Callback = function(color, alpha)
        print("Accent color:", color, "Alpha:", alpha)
    end,
}, "AccentColor")

MainRight:Keybind({
    Name = "Quick notification",
    Default = Enum.KeyCode.P,
    Callback = function()
        Window:Notify({
            Title = "Keybind test",
            Description = "The keybind callback is working.",
            Lifetime = 3,
        })
    end,
}, "QuickNotification")

SettingsLeft:Header({ Text = "Window actions" })
SettingsLeft:Button({
    Name = "Open confirmation dialog",
    Callback = function()
        Window:Dialog({
            Title = "Test dialog",
            Description = "This confirms that the dialog component is working.",
            Buttons = {
                {
                    Name = "Confirm",
                    Callback = function()
                        Window:Notify({
                            Title = "Confirmed",
                            Description = "Dialog callback completed successfully.",
                            Lifetime = 3,
                        })
                    end,
                },
                { Name = "Cancel" },
            },
        })
    end,
})

SettingsLeft:Button({
    Name = "Toggle window",
    Callback = function()
        Window:SetState(not Window:GetState())
    end,
})

MainTab:Select()
Window:Notify({
    Title = "MacLib Test Lab",
    Description = "The test UI loaded successfully. Try the controls and drag the player-stats bar.",
    Lifetime = 5,
})
