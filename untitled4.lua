-- ═══════════════════════════════════════════════════════════════
--  MIRAGE HUB - PROFESSIONAL GUI SYSTEM (SCALED DOWN & FLOATING)
--  Version: 2.0.1 (Further reduced for compact view)
--  Game: Untitled Boxing Game
--  Adjustments: Further reduced sizes, paddings and font sizes for compact GUI
-- ═══════════════════════════════════════════════════════════════

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════════
--  CONFIGURATION (COMPACT & STATES)
-- ═══════════════════════════════════════════════════════════════

local CONFIG = {
    Colors = {
        Background = Color3.fromRGB(18, 18, 22),
        Surface = Color3.fromRGB(25, 25, 30),
        SurfaceLight = Color3.fromRGB(32, 32, 37),
        Primary = Color3.fromRGB(88, 101, 242),
        Accent = Color3.fromRGB(114, 137, 218),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(142, 146, 151),
        Border = Color3.fromRGB(40, 40, 45),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Danger = Color3.fromRGB(237, 66, 69),
        MacRed = Color3.fromRGB(255, 95, 86),
        MacYellow = Color3.fromRGB(255, 189, 46),
        MacGreen = Color3.fromRGB(40, 201, 64)
    },
    Sizes = {
        -- Further reduced main sizes for compact display
        Normal = UDim2.new(0, 260, 0, 220),       -- was 300x260
        Floating = UDim2.new(0, 140, 0, 28),      -- was 180x34
        Fullscreen = UDim2.new(1, 0, 1, 0)
    },
    Positions = {
        Normal = UDim2.new(0.5, -130, 0.5, -110), -- adjusted to match Normal size
        Floating = UDim2.new(1, -180, 1, -90),
        Fullscreen = UDim2.new(0, 0, 0, 0)
    },
    Animation = {
        Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Normal = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Smooth = TweenInfo.new(0.30, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    }
}

-- ═══════════════════════════════════════════════════════════════
--  UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function applyCorner(parent, radius)
    return createInstance("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent
    })
end

local function applyStroke(parent, color, thickness)
    return createInstance("UIStroke", {
        Color = color,
        Thickness = thickness,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function tween(object, properties, tweenInfo)
    TweenService:Create(object, tweenInfo or CONFIG.Animation.Normal, properties):Play()
end

-- ═══════════════════════════════════════════════════════════════
--  MAIN SETUP
-- ═══════════════════════════════════════════════════════════════

local ScreenGui = createInstance("ScreenGui", {
    Name = "MirageHubPro",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true
})

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if ScreenGui.Parent ~= game:GetService("CoreGui") then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local currentState = "Normal"
local previousState = "Normal"
local isDragging = false

-- ═══════════════════════════════════════════════════════════════
--  MAIN FRAME
-- ═══════════════════════════════════════════════════════════════

local MainFrame = createInstance("Frame", {
    Name = "MainFrame",
    Size = CONFIG.Sizes.Normal,
    Position = CONFIG.Positions.Normal,
    BackgroundColor3 = CONFIG.Colors.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui
})

applyCorner(MainFrame, 6) -- smaller corner
applyStroke(MainFrame, CONFIG.Colors.Border, 1)

local Shadow = createInstance("ImageLabel", {
    Name = "Shadow",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, -6, 0, -6),
    Size = UDim2.new(1, 12, 1, 12),
    ZIndex = 0,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.55,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(100, 100, 100, 100),
    Parent = MainFrame
})

-- ═══════════════════════════════════════════════════════════════
--  TITLE BAR (smaller)
-- ═══════════════════════════════════════════════════════════════

local TitleBar = createInstance("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 22), -- reduced height
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = MainFrame
})

applyCorner(TitleBar, 6)

createInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 5),
    Position = UDim2.new(0, 0, 1, -5),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = TitleBar
})

local function createMacCircle(color, position)
    local circle = createInstance("Frame", {
        Size = UDim2.new(0, 4, 0, 4), -- even smaller circles
        Position = position,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    applyCorner(circle, 3)
    return circle
end

createMacCircle(CONFIG.Colors.MacRed, UDim2.new(0, 6, 0, 9))
createMacCircle(CONFIG.Colors.MacYellow, UDim2.new(0, 14, 0, 9))
createMacCircle(CONFIG.Colors.MacGreen, UDim2.new(0, 22, 0, 9))

local TitleLabel = createInstance("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -80, 0, 12),
    Position = UDim2.new(0, 38, 0, 4),
    BackgroundTransparency = 1,
    Text = "Mirage Hub",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamBold,
    TextSize = 9, -- smaller
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar
})

local SubtitleLabel = createInstance("TextLabel", {
    Name = "Subtitle",
    Size = UDim2.new(1, -80, 0, 8),
    Position = UDim2.new(0, 38, 0, 16),
    BackgroundTransparency = 1,
    Text = "Untitled Boxing Game",
    TextColor3 = CONFIG.Colors.TextSecondary,
    Font = Enum.Font.Gotham,
    TextSize = 6, -- smaller
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar
})

local StatusIndicator = createInstance("Frame", {
    Name = "StatusIndicator",
    Size = UDim2.new(0, 6, 0, 6),
    Position = UDim2.new(1, -64, 0, 8), -- adjusted position for smaller frame
    BackgroundColor3 = CONFIG.Colors.Success,
    BorderSizePixel = 0,
    Parent = TitleBar
})

applyCorner(StatusIndicator, 3)

local pulseConnection
pulseConnection = RunService.RenderStepped:Connect(function()
    local time = tick()
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(
        math.floor(67 + math.sin(time * 2) * 12),
        math.floor(181 + math.sin(time * 2) * 12),
        math.floor(129 + math.sin(time * 2) * 12)
    )
end)

local function createControlButton(icon, name, position, hoverColor)
    local button = createInstance("TextButton", {
        Name = name,
        Size = UDim2.new(0, 16, 0, 16), -- smaller
        Position = position,
        BackgroundColor3 = CONFIG.Colors.SurfaceLight,
        BorderSizePixel = 0,
        Text = icon,
        TextColor3 = CONFIG.Colors.TextSecondary,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
        Parent = TitleBar
    })
    
    applyCorner(button, 5)
    
    button.MouseEnter:Connect(function()
        tween(button, {
            BackgroundColor3 = hoverColor or CONFIG.Colors.Border,
            TextColor3 = CONFIG.Colors.TextPrimary
        }, CONFIG.Animation.Fast)
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {
            BackgroundColor3 = CONFIG.Colors.SurfaceLight,
            TextColor3 = CONFIG.Colors.TextSecondary
        }, CONFIG.Animation.Fast)
    end)
    
    return button
end

local MinimizeBtn = createControlButton("—", "Minimize", UDim2.new(1, -64, 0, 3), CONFIG.Colors.Border)
local MaximizeBtn = createControlButton("⛶", "Maximize", UDim2.new(1, -44, 0, 3), CONFIG.Colors.Border)
local CloseBtn = createControlButton("✕", "Close", UDim2.new(1, -26, 0, 3), CONFIG.Colors.Danger)

-- ═══════════════════════════════════════════════════════════════
--  CONTENT CONTAINER (adjusted top offset)
-- ═══════════════════════════════════════════════════════════════

local ContentContainer = createInstance("Frame", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, -40), -- match smaller footer
    Position = UDim2.new(0, 0, 0, 22), -- moved down by title height
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- ═══════════════════════════════════════════════════════════════
--  SIDEBAR (narrower)
-- ═══════════════════════════════════════════════════════════════

local Sidebar = createInstance("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 80, 1, 0), -- reduced width
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = ContentContainer
})

local function createSidebarButton(icon, text, position, isActive)
    local button = createInstance("TextButton", {
        Name = text .. "Button",
        Size = UDim2.new(1, -8, 0, 28), -- smaller height
        Position = position,
        BackgroundColor3 = isActive and CONFIG.Colors.SurfaceLight or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = isActive and 0 or 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        Parent = Sidebar
    })
    
    applyCorner(button, 6)
    
    if isActive then
        applyStroke(button, CONFIG.Colors.Primary, 1)
    end
    
    local iconLabel = createInstance("TextLabel", {
        Size = UDim2.new(0, 14, 0, 14), -- smaller icon
        Position = UDim2.new(0, 6, 0.5, -7),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = isActive and CONFIG.Colors.Primary or CONFIG.Colors.TextSecondary,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        Parent = button
    })
    
    local textLabel = createInstance("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = isActive and CONFIG.Colors.TextPrimary or CONFIG.Colors.TextSecondary,
        Font = isActive and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button
    })
    
    button.MouseEnter:Connect(function()
        if not isActive then
            tween(button, {BackgroundTransparency = 0, BackgroundColor3 = CONFIG.Colors.SurfaceLight}, CONFIG.Animation.Fast)
            tween(textLabel, {TextColor3 = CONFIG.Colors.TextPrimary}, CONFIG.Animation.Fast)
            tween(iconLabel, {TextColor3 = CONFIG.Colors.TextPrimary}, CONFIG.Animation.Fast)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isActive then
            tween(button, {BackgroundTransparency = 1}, CONFIG.Animation.Fast)
            tween(textLabel, {TextColor3 = CONFIG.Colors.TextSecondary}, CONFIG.Animation.Fast)
            tween(iconLabel, {TextColor3 = CONFIG.Colors.TextSecondary}, CONFIG.Animation.Fast)
        end
    end)
    
    return button
end

createSidebarButton("⚔️", "Combat", UDim2.new(0, 8, 0, 12), true)
createSidebarButton("👁️", "ESP", UDim2.new(0, 8, 0, 48), false)
createSidebarButton("🎮", "Game", UDim2.new(0, 8, 0, 84), false)
createSidebarButton("⚙️", "Settings", UDim2.new(0, 8, 0, 120), false)

-- ═══════════════════════════════════════════════════════════════
--  MAIN CONTENT (adjusted)
-- ═══════════════════════════════════════════════════════════════

local MainContent = createInstance("Frame", {
    Name = "MainContent",
    Size = UDim2.new(1, -80, 1, 0), -- reduced due to smaller sidebar
    Position = UDim2.new(0, 80, 0, 0),
    BackgroundTransparency = 1,
    Parent = ContentContainer
})

local ScrollFrame = createInstance("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = CONFIG.Colors.Border,
    CanvasSize = UDim2.new(0, 0, 0, 260), -- smaller canvas
    Parent = MainContent
})

local PageTitle = createInstance("TextLabel", {
    Size = UDim2.new(1, -20, 0, 18),
    Position = UDim2.new(0, 12, 0, 6),
    BackgroundTransparency = 1,
    Text = "Combat",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamBold,
    TextSize = 12, -- smaller
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScrollFrame
})

local PageDescription = createInstance("TextLabel", {
    Size = UDim2.new(1, -20, 0, 12),
    Position = UDim2.new(0, 12, 0, 26),
    BackgroundTransparency = 1,
    Text = "Configure combat system settings and automation",
    TextColor3 = CONFIG.Colors.TextSecondary,
    Font = Enum.Font.Gotham,
    TextSize = 7, -- smaller
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScrollFrame
})

-- ═══════════════════════════════════════════════════════════════
--  SECTION BUILDER (smaller paddings)
-- ═══════════════════════════════════════════════════════════════

local function createSection(title, description, position, width)
    local section = createInstance("Frame", {
        Name = title,
        Size = UDim2.new(width, -6, 0, 0),
        Position = position,
        BackgroundColor3 = CONFIG.Colors.Surface,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = ScrollFrame
    })
    
    applyCorner(section, 5)
    applyStroke(section, CONFIG.Colors.Border, 1)
    
    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        Parent = section
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section
    })
    
    if description then
        createInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 14),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = CONFIG.Colors.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 7,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = section
        })
    end
    
    local container = createInstance("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, description and 28 or 24),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = section
    })
    
    createInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container
    })
    
    return container
end

-- ═══════════════════════════════════════════════════════════════
--  TOGGLE COMPONENT (compact)
-- ═══════════════════════════════════════════════════════════════

local function createToggle(parent, text, description, defaultState)
    local container = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, description and 36 or 26),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0.68, 0, 0, 12),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    if description then
        createInstance("TextLabel", {
            Size = UDim2.new(0.68, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 12),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = CONFIG.Colors.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 7,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = container
        })
    end
    
    local toggleBg = createInstance("Frame", {
        Size = UDim2.new(0, 26, 0, 12), -- smaller
        Position = UDim2.new(1, -30, 0, description and 10 or 6),
        BackgroundColor3 = defaultState and CONFIG.Colors.Success or CONFIG.Colors.Border,
        BorderSizePixel = 0,
        Parent = container
    })
    
    applyCorner(toggleBg, 7)
    
    local toggleButton = createInstance("TextButton", {
        Size = UDim2.new(0, 12, 0, 12), -- smaller
        Position = defaultState and UDim2.new(0, 14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = toggleBg
    })
    
    applyCorner(toggleButton, 6)
    
    local enabled = defaultState or false
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        tween(toggleButton, {
            Position = enabled and UDim2.new(0, 14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }, CONFIG.Animation.Fast)
        tween(toggleBg, {
            BackgroundColor3 = enabled and CONFIG.Colors.Success or CONFIG.Colors.Border
        }, CONFIG.Animation.Fast)
    end)
    
    return container
end

-- ═══════════════════════════════════════════════════════════════
--  SLIDER COMPONENT (compact)
-- ═══════════════════════════════════════════════════════════════

local function createSlider(parent, text, description, min, max, default)
    local container = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, description and 42 or 30),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0.6, 0, 0, 12),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamMedium,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0, 34, 0, 12),
        Position = UDim2.new(1, -34, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default or 50),
        TextColor3 = CONFIG.Colors.Primary,
        Font = Enum.Font.GothamBold,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })
    
    if description then
        createInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 12),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = CONFIG.Colors.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 7,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = container
        })
    end
    
    local sliderBg = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 3), -- thinner bar
        Position = description and UDim2.new(0, 0, 1, -10) or UDim2.new(0, 0, 1, -6),
        BackgroundColor3 = CONFIG.Colors.Border,
        BorderSizePixel = 0,
        Parent = container
    })
    
    applyCorner(sliderBg, 2)
    
    local sliderFill = createInstance("Frame", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = CONFIG.Colors.Primary,
        BorderSizePixel = 0,
        Parent = sliderBg
    })
    
    applyCorner(sliderFill, 2)
    
    local sliderButton = createInstance("TextButton", {
        Size = UDim2.new(0, 8, 0, 8), -- smaller thumb
        Position = UDim2.new(0.5, -4, 0.5, -4),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = sliderBg
    })
    
    applyCorner(sliderButton, 5)
    applyStroke(sliderButton, CONFIG.Colors.Primary, 1)
    
    return container
end

-- ═══════════════════════════════════════════════════════════════
--  BUILD UI CONTENT
-- ═══════════════════════════════════════════════════════════════

local SystemSection = createSection("Combat System", "Enable and configure combat automation", UDim2.new(0, 10, 0, 64), 0.48)
local SettingsSection = createSection("Combat Settings", "Fine-tune combat behavior and timing", UDim2.new(0.52, 0, 0, 64), 0.48)

createToggle(SystemSection, "Enable Combat", "Activate automatic combat system", true)
createToggle(SystemSection, "Dodge Light Attacks", "Automatically dodge light punches", true)
createToggle(SystemSection, "Dodge Heavy Attacks", "Automatically dodge heavy punches", true)
createToggle(SystemSection, "Block Ultimate Attacks", "Block ultimate moves automatically", true)
createToggle(SystemSection, "Attack on Dash", "Counter-attack when enemy dashes", false)

createSlider(SettingsSection, "Normal Dodge Delay", "Reaction time for normal dodges (ms)", 0, 500, 150)
createSlider(SettingsSection, "Heavy Dodge Delay", "Reaction time for heavy dodges (ms)", 0, 500, 200)
createSlider(SettingsSection, "Activation Range", "Maximum distance to activate (studs)", 0, 100, 25)
createToggle(SettingsSection, "No Stun", "Prevent stun effects on player", false)
createToggle(SettingsSection, "No Reverse Input", "Disable input reversal effects", false)

-- ═══════════════════════════════════════════════════════════════
--  FOOTER (smaller)
-- ═══════════════════════════════════════════════════════════════

local Footer = createInstance("Frame", {
    Name = "Footer",
    Size = UDim2.new(1, 0, 0, 16), -- reduced height
    Position = UDim2.new(0, 0, 1, -16),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = MainFrame
})

createInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = CONFIG.Colors.Border,
    BorderSizePixel = 0,
    Parent = Footer
})

createInstance("TextLabel", {
    Size = UDim2.new(0, 120, 1, 0),
    Position = UDim2.new(0, 6, 0, 0),
    BackgroundTransparency = 1,
    Text = "v2.0.1 • Professional Edition",
    TextColor3 = CONFIG.Colors.TextSecondary,
    Font = Enum.Font.Gotham,
    TextSize = 6,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Footer
})

createInstance("TextLabel", {
    Size = UDim2.new(0, 120, 1, 0),
    Position = UDim2.new(1, -120, 0, 0),
    BackgroundTransparency = 1,
    Text = "● Connected",
    TextColor3 = CONFIG.Colors.Success,
    Font = Enum.Font.GothamMedium,
    TextSize = 6,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = Footer
})

-- ═══════════════════════════════════════════════════════════════
--  NOTIFICATION SYSTEM (compact)
-- ═══════════════════════════════════════════════════════════════

local NotificationContainer = createInstance("Frame", {
    Name = "NotificationContainer",
    Size = UDim2.new(0, 160, 1, -16),
    Position = UDim2.new(1, -170, 0, 8),
    BackgroundTransparency = 1,
    Parent = ScreenGui
})

createInstance("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Parent = NotificationContainer
})

local function createNotification(title, message, duration, notifType)
    local notif = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = CONFIG.Colors.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotificationContainer
    })
    
    applyCorner(notif, 6)
    applyStroke(notif, CONFIG.Colors.Border, 1)
    
    createInstance("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = notifType == "success" and CONFIG.Colors.Success or 
                           notifType == "warning" and CONFIG.Colors.Warning or
                           notifType == "error" and CONFIG.Colors.Danger or CONFIG.Colors.Primary,
        BorderSizePixel = 0,
        Parent = notif
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(0, 8, 0, 10),
        BackgroundTransparency = 1,
        Text = notifType == "success" and "✓" or notifType == "warning" and "⚠" or notifType == "error" and "✕" or "ℹ",
        TextColor3 = notifType == "success" and CONFIG.Colors.Success or 
                     notifType == "warning" and CONFIG.Colors.Warning or
                     notifType == "error" and CONFIG.Colors.Danger or CONFIG.Colors.Primary,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = notif
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(1, -40, 0, 12),
        Position = UDim2.new(0, 36, 0, 6),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(1, -40, 0, 28),
        Position = UDim2.new(0, 36, 0, 18),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = CONFIG.Colors.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 7,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    notif.Size = UDim2.new(1, 0, 0, 0)
    tween(notif, {Size = UDim2.new(1, 0, 0, 48)}, CONFIG.Animation.Normal)
    
    task.delay(duration or 3, function()
        tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, CONFIG.Animation.Normal)
        task.wait(0.22)
        notif:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
--  WINDOW CONTROLS (floating minimize, fullscreen toggle)
-- ═══════════════════════════════════════════════════════════════

local function applyState(state)
    if state == "Floating" then
        tween(MainFrame, {Size = CONFIG.Sizes.Floating, Position = CONFIG.Positions.Floating}, CONFIG.Animation.Fast)
        ContentContainer.Visible = false
        Footer.Visible = false
        MainFrame.Visible = true
    elseif state == "Fullscreen" then
        tween(MainFrame, {Size = CONFIG.Sizes.Fullscreen, Position = CONFIG.Positions.Fullscreen}, CONFIG.Animation.Smooth)
        ContentContainer.Visible = true
        Footer.Visible = true
        MainFrame.Visible = true
    elseif state == "Normal" then
        tween(MainFrame, {Size = CONFIG.Sizes.Normal, Position = CONFIG.Positions.Normal}, CONFIG.Animation.Normal)
        ContentContainer.Visible = true
        Footer.Visible = true
        MainFrame.Visible = true
    end
    currentState = state
end

CloseBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In))
    task.wait(0.22)
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if currentState ~= "Floating" then
        previousState = currentState
        applyState("Floating")
    else
        applyState(previousState == "Floating" and "Normal" or previousState or "Normal")
    end
end)

MaximizeBtn.MouseButton1Click:Connect(function()
    if currentState ~= "Fullscreen" then
        previousState = currentState
        applyState("Fullscreen")
    else
        applyState("Normal")
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  DRAG SYSTEM (allow drag in Normal and Floating states)
-- ═══════════════════════════════════════════════════════════════

local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and (currentState == "Normal" or currentState == "Floating") then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  KEYBIND SYSTEM (RightShift toggles visibility)
-- ═══════════════════════════════════════════════════════════════

local isGuiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        isGuiVisible = not isGuiVisible
        
        if isGuiVisible then
            MainFrame.Visible = true
            local targetPos = currentState == "Normal" and CONFIG.Positions.Normal or
                              currentState == "Floating" and CONFIG.Positions.Floating or
                              CONFIG.Positions.Fullscreen
            tween(MainFrame, {Position = targetPos}, CONFIG.Animation.Normal)
            createNotification("GUI Shown", "Press Right Shift to hide", 2, "info")
        else
            tween(MainFrame, {Position = UDim2.new(0.5, 0, -0.5, 0)}, CONFIG.Animation.Normal)
            task.wait(0.22)
            MainFrame.Visible = false
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  PERFORMANCE MONITOR (compact)
-- ═══════════════════════════════════════════════════════════════

local PerformanceFrame = createInstance("Frame", {
    Name = "Performance",
    Size = UDim2.new(0, 62, 0, 28),
    Position = UDim2.new(0, 6, 1, -44),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    Visible = false,
    Parent = Sidebar
})

applyCorner(PerformanceFrame, 5)

local FPSLabel = createInstance("TextLabel", {
    Size = UDim2.new(1, -6, 0, 12),
    Position = UDim2.new(0, 3, 0, 3),
    BackgroundTransparency = 1,
    Text = "FPS: 60",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamMedium,
    TextSize = 7,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = PerformanceFrame
})

local PingLabel = createInstance("TextLabel", {
    Size = UDim2.new(1, -6, 0, 12),
    Position = UDim2.new(0, 3, 0, 16),
    BackgroundTransparency = 1,
    Text = "Ping: 0ms",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamMedium,
    TextSize = 7,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = PerformanceFrame
})

local lastFrameTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastFrameTime >= 1 then
        local fps = frameCount
        FPSLabel.Text = "FPS: " .. tostring(fps)
        FPSLabel.TextColor3 = fps >= 55 and CONFIG.Colors.Success or fps >= 30 and CONFIG.Colors.Warning or CONFIG.Colors.Danger
        frameCount = 0
        lastFrameTime = tick()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  INITIALIZATION (notification adjusted)
-- ═══════════════════════════════════════════════════════════════

task.wait(0.4)
createNotification(
    "Mirage Hub Loaded",
    "Professional Edition v2.0.1 • Press Right Shift to toggle",
    3.5,
    "success"
)

print("Mirage Hub: Loaded (compact UI for default GUI size)")

ScreenGui.Destroying:Connect(function()
    if pulseConnection then
        pulseConnection:Disconnect()
    end
    print("Mirage Hub: Unloaded successfully")
end)

-- ═══════════════════════════════════════════════════════════════
--  END OF SCRIPT
-- ═══════════════════════════════════════════════════════════════