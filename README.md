# MacLib

> A macOS-inspired Roblox UI library with responsive windows, configurable controls, a mobile recovery button, and a floating live player-stats bar.

![MacLib interface preview](assets/maclib-docs/welcome-2-5cc22d84.png)

MacLib ships as a single Lua file and is designed to make feature-rich Roblox interfaces quick to assemble. It supports organized tabs and sections, configuration-aware controls, notifications, dialogs, a mobile-friendly floating window toggle, and a live overlay that displays the local player’s avatar, ping, FPS, and server population.

| Project resource | Link |
|---|---|
| **Repository** | [RedzZhub654/MacLib](https://github.com/RedzZhub654/MacLib) |
| **Library source** | [`maclib.txt`](./maclib.txt) |
| **Ready-to-run test UI** | [`examples/test.lua`](./examples/test.lua) |
| **Local visual assets** | [`assets/maclib-docs`](./assets/maclib-docs) |
| **Image-source manifest** | [`assets/maclib-docs/SOURCES.md`](./assets/maclib-docs/SOURCES.md) |
| **Original documentation** | [MacLib UI Library][1] |
| **Original project** | [biggaboy212/Maclib][2] |

## Guide map

| Start here | Build features | Reference |
|---|---|---|
| [Load MacLib](#load-maclib) | [Create a window](#create-a-window) | [Window options](#window-options) |
| [Run the test UI](#run-the-test-ui) | [Build a layout](#build-a-layout) | [Controls](#controls) |
| [Use mobile support](#mobile-window-toggle) | [Show feedback](#notifications-and-dialogs) | [Window and configuration methods](#window-and-configuration-methods) |
| [Use player stats](#floating-player-stats-bar) | [Customize themes](#theme-customization) | [Credits and sources](#credits-and-sources) |

## Load MacLib

MacLib is published in this repository as [`maclib.txt`](./maclib.txt). The following loader points to this repository’s main branch. For production use, review the code you run and consider pinning the URL to a specific commit so that your build stays reproducible.

```lua
local MacLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RedzZhub654/MacLib/main/maclib.txt"
))()
```

> **Loading alone is intentionally silent.** The loader returns the `MacLib` table; it does not create a window by itself. Call `MacLib:Demo()`, create a window with `MacLib:Window({...})`, or run the complete test script below.

### Quick visual check

```lua
local MacLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RedzZhub654/MacLib/main/maclib.txt"
))()

MacLib:Demo()
```

## Run the test UI

The fastest way to confirm a working installation is to run [`examples/test.lua`](./examples/test.lua). It opens a complete test interface with a floating player-stats bar, mobile recovery button, global setting, notification, dialog, toggle, slider, input, dropdown, color picker, keybind, and action buttons.

```lua
loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/RedzZhub654/MacLib/main/examples/test.lua"
))()
```

> **What the test script proves:** it validates the main window lifecycle, interactive callbacks, visible state changes, player-stats updates, and desktop or touch dragging. Use it as a known-good starting point, then replace the callbacks with your own application logic.

| Test area | Included behavior |
|---|---|
| Core window | Title, subtitle, keybind, drag behavior, acrylic blur, and close flow. |
| Mobile support | A floating circular button restores a minimized window on touch-only devices. |
| Player stats | Local avatar, display name, ping, FPS, player count, badge, and drag support. |
| Inputs | Toggle, slider, text input, dropdown, color picker, and keybind callbacks. |
| Feedback | Notification and confirmation-dialog examples. |

## Create a window

A window is the root of every MacLib interface. Configure only the options your project needs; omitted options use the library’s defaults.

```lua
local Window = MacLib:Window({
    Title = "My Project",
    Subtitle = "Interface ready",
    Size = UDim2.fromOffset(900, 650),
    DragStyle = 1,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.RightControl,
    AcrylicBlur = true,

    MobileFloatButton = true,
    PlayerStatsEnabled = true,
    PlayerStatsBadge = "BETA",
})
```

### Window options

| Option | Type | Default behavior | Purpose |
|---|---|---|---|
| `Title` | `string` | Required display text | Sets the main title. |
| `Subtitle` | `string` | Optional | Adds supporting text below the title. |
| `Size` | `UDim2` | `UDim2.fromOffset(868, 650)` | Sets the initial window dimensions. |
| `DragStyle` | `number` | `1` | Uses the move icon (`1`) or full UI surface (`2`) for dragging. |
| `DisabledWindowControls` | `table` | `{}` | Disables named controls such as `"Exit"` or `"Minimize"`. |
| `ShowUserInfo` | `boolean` | `true` | Shows the local-player block in the window sidebar. |
| `Keybind` | `Enum.KeyCode` | `RightControl` | Toggles the window’s visible state. |
| `AcrylicBlur` | `boolean` | `true` | Enables the blur treatment behind the interface. |
| `MobileFloatButton` | `boolean` | Auto-enabled on touch-only devices | Controls the minimized-window recovery button. |
| `MobileFloatButtonPosition` | `UDim2` | Bottom-right | Sets the floating recovery button’s initial position. |
| `PlayerStatsEnabled` | `boolean` | `true` | Creates the independent floating player-stats bar. |
| `PlayerStatsBadge` | `string` or `false` | `"BETA"` | Sets the badge next to the display name, or removes it with `false`. |
| `PlayerStatsPosition` | `UDim2` | Top-center | Sets the stats bar’s initial position. |
| `PlayerStatsDraggable` | `boolean` | `true` | Enables touch and mouse dragging for the stats bar. |
| `PlayerStatsAvatar` | `string` | Local player’s Roblox avatar | Overrides the automatically retrieved avatar thumbnail. |

## Build a layout

MacLib uses a predictable hierarchy: **Window → Tab Group → Tab → Section → Control**. Tab groups organize navigation; tabs define pages; sections place controls in the left or right column. [3] [4] [5]

```lua
local TabGroup = Window:TabGroup()

local MainTab = TabGroup:Tab({
    Name = "Main",
    Image = "rbxassetid://10723426393",
})

local Left = MainTab:Section({ Side = "Left" })
local Right = MainTab:Section({ Side = "Right" })

Left:Header({ Text = "Controls" })
Left:Paragraph({
    Header = "Welcome",
    Body = "Place your controls below this text.",
})

MainTab:Select()
```

| Tab layout | Section layout |
|---|---|
| ![Tab layout reference](assets/maclib-docs/adding_tabs-1-0ef57fa5.png) | ![Section layout reference](assets/maclib-docs/adding_sections-1-4cb01cdc.png) |

## Mobile window toggle

When a MacLib window is minimized on a touch-only device, the library can display a circular floating menu button. A tap restores the window; dragging moves the button to a comfortable on-screen position. The control is hidden while the main UI is open and is cleaned up when `Window:Unload()` runs.

```lua
local Window = MacLib:Window({
    Title = "Mobile-ready UI",
    Size = UDim2.fromOffset(868, 650),
    MobileFloatButton = true,
    MobileFloatButtonPosition = UDim2.new(1, -24, 1, -24),
})
```

## Floating player-stats bar

The player-stats bar is a separate overlay, so it remains available even when the main window is minimized. It uses the local player’s **Roblox avatar** and **display name** rather than a hard-coded username, and refreshes ping, FPS, and player count at a short interval. The user, signal, gauge, and users icons are sourced from the icon set supplied with this project.

```lua
local Window = MacLib:Window({
    Title = "Status overlay demo",
    Size = UDim2.fromOffset(868, 650),

    PlayerStatsEnabled = true,
    PlayerStatsBadge = "TEST",
    PlayerStatsPosition = UDim2.new(0.5, 0, 0, 16),
    PlayerStatsDraggable = true,

    -- Optional custom profile image:
    -- PlayerStatsAvatar = "rbxassetid://YOUR_IMAGE_ID",
})
```

| Live value | Source | Display behavior |
|---|---|---|
| Avatar and name | Local Roblox player | Automatically fetched avatar thumbnail and display name; an image asset can override the avatar. |
| Ping | Roblox `Stats` service | Displayed in milliseconds; falls back safely when unavailable. |
| FPS | Render-step measurement | Calculated from rendered frames over the refresh interval. |
| Players | `Players:GetPlayers()` | Shows the current population of the active server. |

## Theme customization

A practical theme workflow keeps your color decisions in a single palette table and passes those tokens into your own callbacks, custom instances, and MacLib color controls. The included [`examples/test.lua`](./examples/test.lua) now contains four ready-to-test palettes: **Sunset**, **Ocean**, **Forest**, and **Lavender**. Choosing a palette updates the example’s accent color picker and palette description so you can verify the selected values immediately.

> **Scope:** MacLib currently keeps its core window styling internally consistent. Palette tokens are intended for the visual behavior you add around MacLib—such as feature highlights, custom instances, notifications you manage, and color-picker defaults—rather than a global runtime restyle of every built-in component.

```lua
local Palettes = {
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
}

local ActivePalette = Palettes.Ocean

Section:Colorpicker({
    Name = "Accent color",
    Default = ActivePalette.Accent,
    Alpha = 0,
    Callback = function(color)
        -- Apply `color` to the custom visuals in your own feature.
        print("New accent:", color)
    end,
})
```

| Palette | Accent | Background | Surface | Text |
|---|---:|---:|---:|---:|
| **Sunset** | `244, 101, 92` | `30, 24, 28` | `58, 37, 43` | `255, 240, 239` |
| **Ocean** | `74, 166, 255` | `19, 30, 46` | `31, 60, 88` | `235, 247, 255` |
| **Forest** | `105, 196, 132` | `22, 34, 27` | `39, 71, 49` | `238, 255, 241` |
| **Lavender** | `173, 134, 255` | `33, 27, 47` | `63, 48, 91` | `247, 242, 255` |

The test script’s `ApplyPalette` function is a compact pattern for palette selection. It updates the accent picker, refreshes the on-screen palette details, and exposes the active `Background`, `Surface`, and `Text` tokens for use in your own UI behavior.

## Controls

Interactive controls can receive an optional **flag** as their second argument. Flags allow values to participate in MacLib’s configuration system. The original API reference documents the complete option fields and object methods. [6]

| Control | Typical use | Key capabilities |
|---|---|---|
| `Section:Button` | Run an action | Invokes a callback. |
| `Section:Toggle` | Store a boolean state | Get or update the state. |
| `Section:Slider` | Choose a number in a range | Get or update the value; customize formatting and precision. |
| `Section:Input` | Capture text | Read or replace text; use built-in or custom filters. |
| `Section:Dropdown` | Choose one or many values | Search, require a selection, and update options dynamically. |
| `Section:Keybind` | Bind a Roblox input | Bind, unbind, and retrieve the active input. |
| `Section:Colorpicker` | Choose a color and alpha | Update color or transparency programmatically. |
| `Section:Header` | Add a section heading | Update text or visibility. |
| `Section:Paragraph` | Add explanatory content | Update its header and body text. |
| `Section:Label` / `SubLabel` | Add lightweight text | Update text or visibility. |
| `Section:Divider` / `Spacer` | Separate controls | Hide or remove the divider, or create spacing. |

```lua
local Enabled = Left:Toggle({
    Name = "Enable feature",
    Default = false,
    Callback = function(value)
        print("Feature enabled:", value)
    end,
}, "FeatureEnabled")

local Amount = Left:Slider({
    Name = "Amount",
    Default = 50,
    Minimum = 0,
    Maximum = 100,
    DisplayMethod = "Percent",
    Precision = 0,
    Callback = function(value)
        print("Amount:", value)
    end,
}, "Amount")

Left:Button({
    Name = "Show values",
    Callback = function()
        print(Enabled:GetState(), Amount:GetValue())
    end,
})
```

## Notifications and dialogs

Use notifications for transient feedback and dialogs when the user must make a choice. Both return objects that can be updated or canceled after creation. [7] [8]

```lua
Window:Notify({
    Title = "Saved",
    Description = "Your settings were saved successfully.",
    Lifetime = 3,
})

Window:Dialog({
    Title = "Reset settings?",
    Description = "This example shows a confirmation flow.",
    Buttons = {
        {
            Name = "Confirm",
            Callback = function()
                print("Confirmed")
            end,
        },
        { Name = "Cancel" },
    },
})
```

## Window and configuration methods

| Method | Purpose |
|---|---|
| `Window:SetState(boolean)` | Shows or hides the main window. |
| `Window:GetState()` | Returns whether the main window is visible. |
| `Window:SetNotificationsState(boolean)` | Shows or hides the notification area. |
| `Window:GetNotificationsState()` | Returns notification visibility. |
| `Window:SetAcrylicBlurState(boolean)` | Enables or disables acrylic blur. |
| `Window:GetAcrylicBlurState()` | Returns the blur state. |
| `Window:SetUserInfoState(boolean)` | Shows or redacts sidebar user information. |
| `Window:SetSize(UDim2)` / `Window:GetSize()` | Updates or retrieves the window size. |
| `Window:SetScale(number)` / `Window:GetScale()` | Updates or retrieves UI scale. |
| `Window:UpdateTitle(string)` / `Window:UpdateSubtitle(string)` | Changes window text after creation. |
| `Window:Unload()` | Cleans up the entire interface, including floating overlays. |
| `MacLib:SetFolder(string)` | Chooses the configuration folder. |
| `MacLib:SaveConfig(string)` / `MacLib:LoadConfig(string)` | Saves or restores flagged control values. |
| `MacLib:RefreshConfigList()` | Lists available configuration names. |
| `MacLib:LoadAutoLoadConfig()` | Loads the selected automatic configuration. |
| `MacLib:Demo()` | Opens the built-in library demonstration. |

## Visual reference

All visual references are stored locally under [`assets/maclib-docs`](./assets/maclib-docs), and the image provenance is recorded in [`SOURCES.md`](./assets/maclib-docs/SOURCES.md). The gallery below keeps the primary component examples in the repository so this guide does not depend on the external documentation site.

| Global setting | Notification | Dialog |
|---|---|---|
| ![Global setting reference](assets/maclib-docs/adding_a_global_setting-1-482cfbda.png) | ![Notification reference](assets/maclib-docs/displaying_a_notification-1-8c82c17d.png) | ![Dialog reference](assets/maclib-docs/prompting_a_dialog-1-8304c37f.png) |

| Button | Input | Slider |
|---|---|---|
| ![Button reference](assets/maclib-docs/button-1-6dc62d2c.png) | ![Input reference](assets/maclib-docs/input-1-19e0d685.png) | ![Slider reference](assets/maclib-docs/slider-1-00e710d0.png) |

| Toggle | Keybind | Color picker |
|---|---|---|
| ![Toggle reference](assets/maclib-docs/toggle-1-fd8ca6fc.png) | ![Keybind reference](assets/maclib-docs/keybind-1-2221ef8e.png) | ![Color picker reference](assets/maclib-docs/colorpicker-1-bfbe5ee5.png) |

| Dropdown | Header | Paragraph |
|---|---|---|
| ![Dropdown reference](assets/maclib-docs/dropdown-1-a4b2b6cb.png) | ![Header reference](assets/maclib-docs/header-1-d83ad2ef.png) | ![Paragraph reference](assets/maclib-docs/paragraph-1-08a4734f.png) |

| Label | Sub-label | Divider |
|---|---|---|
| ![Label reference](assets/maclib-docs/label-1-a995812a.png) | ![Sub-label reference](assets/maclib-docs/sub_label-1-91f9255e.png) | ![Divider reference](assets/maclib-docs/divider-1-fbe76a72.png) |

## Credits and sources

This README is an original repository guide and retains attribution to the original MacLib project. The public documentation credits **biggaboy212** as UI designer, lead developer, and programmer. [9]

[1]: https://brady-xyz.gitbook.io/maclib-ui-library "MacLib UI Library documentation"
[2]: https://github.com/biggaboy212/Maclib/tree/main "Original MacLib repository"
[3]: https://brady-xyz.gitbook.io/maclib-ui-library/getting-started/loading-maclib/creating-a-window/creating-a-tab-group "Creating a tab group"
[4]: https://brady-xyz.gitbook.io/maclib-ui-library/getting-started/loading-maclib/creating-a-window/creating-a-tab-group/adding-tabs "Adding tabs"
[5]: https://brady-xyz.gitbook.io/maclib-ui-library/getting-started/loading-maclib/creating-a-window/creating-a-tab-group/adding-tabs/adding-sections "Adding sections"
[6]: https://brady-xyz.gitbook.io/maclib-ui-library/llms.txt "MacLib documentation index"
[7]: https://brady-xyz.gitbook.io/maclib-ui-library/getting-started/loading-maclib/creating-a-window/displaying-a-notification "Displaying a notification"
[8]: https://brady-xyz.gitbook.io/maclib-ui-library/getting-started/loading-maclib/creating-a-window/prompting-a-dialog "Prompting a dialog"
[9]: https://brady-xyz.gitbook.io/maclib-ui-library/information/miscellaneous "MacLib credits and links"
