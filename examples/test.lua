-- MacLib end-to-end test example
-- Load the same revision you intend to test in your project.

local MacLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RedzZhub654/MacLib/main/maclib.txt"
))()

-- Keep visual decisions in one table so your own UI callbacks can reuse them.
local Palettes = {
    Sunset = {
        Accent = Color3.fromRGB(244, 101, 92),
        Background = Color3.fromRGB(30, 24, 28),
        Surface = Color3.fromRGB(58, 37, 43),
        Text = Color3.fromRGB(255, 240, 239),
    },
    Ocean = {
        Accent = Color3.fromRGB(74, 166, 255),
        Background = Color3.fromRGB(19, 30, 46),
        Surface = Color3.fromRGB(31, 60, 88),
        Text = Color3.fromRGB(235, 247, 255),
    },
    Forest = {
        Accent = Color3.fromRGB(105, 196, 132),
        Background = Color3.fromRGB(22, 34, 27),
        Surface = Color3.fromRGB(39, 71, 49),
        Text = Color3.fromRGB(238, 255, 241),
    },
    Lavender = {
        Accent = Color3.fromRGB(173, 134, 255),
        Background = Color3.fromRGB(33, 27, 47),
        Surface = Color3.fromRGB(63, 48, 91),
        Text = Color3.fromRGB(247, 242, 255),
    },
}

local ActivePaletteName = "Sunset"
local ActivePalette = Palettes[ActivePaletteName]

local Window = MacLib:Window({
    Title = "MacLib Test Lab",
    Subtitle = "Interactive component showcase",
    -- Default hub logo: rbxassetid://137471163061841
    -- Set HubLogo to a different image asset to override it, or false to hide it.
    Size = UDim2.fromOffset(900, 650),
    DragStyle = 1,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,

    -- Automatic DPI-aware viewport scaling
    AutoDPI = true,
    AutoDPIMinScale = 0.35,
    AutoDPIMargin = 32,

    -- Mobile accessibility
    -- The mobile float remains visible while the UI is open or minimized.
    MobileFloatButton = true,
    MobileFloatButtonPosition = UDim2.new(1, -24, 1, -24),

    -- Floating player status bar; it now resizes independently of main-window DPI.
    PlayerStatsEnabled = true,
    PlayerStatsAutoDPI = true,
    PlayerStatsMargin = 16,
    PlayerStatsBadge = "THEME",
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

local DiscordInvite = MainTab:CreateDiscordInvite({
    Title = "Discord Developers",
    Description = "Official Discord community for people building with Discord APIs.",
    Link = "https://discord.gg/discord-developers",
    Button = "Copy Invite",
    Side = 2,
    RefreshInterval = 5,
    OnCopy = function(link, copied)
        print("Discord invite copy requested:", link, "Copied:", copied)
    end,
})

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

MainRight:Header({ Text = "Theme playground" })

local PaletteInfo = MainRight:Paragraph({
    Header = "Sunset palette",
    Body = "Choose a palette to update the accent preview and inspect reusable color tokens.",
})

local AccentColor = MainRight:Colorpicker({
    Name = "Accent color",
    Default = ActivePalette.Accent,
    Alpha = 0,
    Callback = function(color, alpha)
        print("Custom accent:", color, "Alpha:", alpha)
    end,
}, "AccentColor")

local function ApplyPalette(name)
    local palette = Palettes[name]
    if not palette then return end

    ActivePaletteName = name
    ActivePalette = palette
    AccentColor:SetColor(palette.Accent)
    AccentColor:SetAlpha(0)
    PaletteInfo:UpdateHeader(name .. " palette")
    PaletteInfo:UpdateBody(string.format(
        "Accent: %d, %d, %d | Reuse Background, Surface, and Text tokens in your own callbacks.",
        math.floor(palette.Accent.R * 255),
        math.floor(palette.Accent.G * 255),
        math.floor(palette.Accent.B * 255)
    ))

    Window:Notify({
        Title = "Palette applied",
        Description = name .. " is now the active test palette.",
        Lifetime = 3,
    })
end

MainRight:Dropdown({
    Name = "Color palette",
    Search = true,
    Multi = false,
    Required = true,
    Options = { "Sunset", "Ocean", "Forest", "Lavender" },
    Default = 1,
    Callback = ApplyPalette,
}, "ColorPalette")

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
SettingsLeft:Toggle({
    Name = "Automatic DPI",
    Default = Window:GetAutoDPI(),
    Callback = function(enabled)
        Window:SetAutoDPI(enabled)
        Window:Notify({
            Title = "Automatic DPI",
            Description = enabled and "Viewport scaling enabled." or "Viewport scaling disabled.",
            Lifetime = 3,
        })
    end,
}, "AutomaticDPI")

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
