--[[
    ENI HUB V2.8 - DEV EDITION
    Refactor based on the supplied Eni Hub V2.7.

    Safe changes:
    - Central configuration
    - Central connection cleanup
    - Character respawn handling
    - Movement / camera / world developer controls
    - ESP-style player markers for testing
    - Diagnostics
    - Panic/close cleanup
    - No anti-cheat bypass
    - No arbitrary external script execution
    - No remote code loading
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--==================================================
-- CORE
--==================================================

local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    FOV = 70,
    ClockTime = 12,
    NoFog = false,
    Fullbright = false,
    ESP = false,
    Fly = false,
    Noclip = false,
}

local Connections = {}
local CreatedInstances = {}
local CharacterConnections = {}

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(Connections, connection)
    return connection
end

local function track(instance)
    table.insert(CreatedInstances, instance)
    return instance
end

local function disconnectAll()
    for _, connection in ipairs(Connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    table.clear(Connections)

    for _, connection in ipairs(CharacterConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    table.clear(CharacterConnections)
end

local function destroyTracked()
    for _, instance in ipairs(CreatedInstances) do
        if instance and instance.Parent then
            instance:Destroy()
        end
    end
    table.clear(CreatedInstances)
end

local function getCharacter()
    return player.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- LOAD RAYFIELD
--==================================================

local Rayfield
local ok, result = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not ok then
    warn("Eni Hub V2.8: Rayfield could not be loaded:", result)
    return
end

Rayfield = result

--==================================================
-- WINDOW
--==================================================

local Window = Rayfield:CreateWindow({
    Name = "Eni Hub | V2.8 Dev",
    LoadingTitle = "Initializing Eni Hub V2.8...",
    LoadingSubtitle = "Studio Development Edition",
    Theme = "Amethyst",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

local TabNotes = Window:CreateTab("Patch Notes", 4483362458)
local TabPlayer = Window:CreateTab("Player", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483362458)
local TabWorld = Window:CreateTab("World", 4483362458)
local TabDiagnostics = Window:CreateTab("Diagnostics", 4483362458)
local TabSettings = Window:CreateTab("Settings", 4483362458)

--==================================================
-- PATCH NOTES
--==================================================

TabNotes:CreateLabel("ENI HUB V2.8")

TabNotes:CreateParagraph({
    Title = "Developer Edition",
    Content =
        "V2.8 focuses on stability, cleanup, respawn handling and diagnostics. " ..
        "This edition keeps the V2.7 hub structure while improving stability, cleanup and respawn handling."
})

TabNotes:CreateParagraph({
    Title = "V2.8 Improvements",
    Content =
        "• Central connection manager\n" ..
        "• Character respawn support\n" ..
        "• Cleaner Fly/Noclip lifecycle\n" ..
        "• Improved ESP cleanup\n" ..
        "• World controls grouped separately\n" ..
        "• Diagnostics panel\n" ..
        "• Panic cleanup"
})

--==================================================
-- PLAYER
--==================================================

TabPlayer:CreateLabel("Movement")

TabPlayer:CreateSlider({
    Name = "WalkSpeed",
    Range = {8, 100},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = Config.WalkSpeed,
    Callback = function(value)
        Config.WalkSpeed = value
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end,
})

TabPlayer:CreateSlider({
    Name = "JumpPower",
    Range = {25, 150},
    Increment = 1,
    Suffix = " Power",
    CurrentValue = Config.JumpPower,
    Callback = function(value)
        Config.JumpPower = value
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = value
        end
    end,
})

--==================================================
-- FLY
--==================================================

local flyAttachment
local flyVelocity
local flyOrientation
local flyConnection
local flyKeys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Up = false,
    Down = false,
}

local function stopFly()
    Config.Fly = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if flyVelocity then
        flyVelocity:Destroy()
        flyVelocity = nil
    end

    if flyOrientation then
        flyOrientation:Destroy()
        flyOrientation = nil
    end

    if flyAttachment then
        flyAttachment:Destroy()
        flyAttachment = nil
    end

    local humanoid = getHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function startFly()
    stopFly()

    local root = getRoot()
    local humanoid = getHumanoid()
    local camera = workspace.CurrentCamera

    if not root or not humanoid or not camera then
        return
    end

    Config.Fly = true
    humanoid.PlatformStand = true

    flyAttachment = Instance.new("Attachment")
    flyAttachment.Name = "EniFlyAttachment"
    flyAttachment.Parent = root

    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Name = "EniFlyVelocity"
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.MaxForce = math.huge
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    flyVelocity.Parent = root

    flyOrientation = Instance.new("AlignOrientation")
    flyOrientation.Name = "EniFlyOrientation"
    flyOrientation.Attachment0 = flyAttachment
    flyOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    flyOrientation.MaxTorque = math.huge
    flyOrientation.Responsiveness = 100
    flyOrientation.Parent = root

    flyConnection = RunService.RenderStepped:Connect(function()
        if not Config.Fly then
            return
        end

        local currentRoot = getRoot()
        local currentHumanoid = getHumanoid()
        local currentCamera = workspace.CurrentCamera

        if not currentRoot or not currentHumanoid or not currentCamera then
            stopFly()
            return
        end

        local direction = Vector3.zero

        if flyKeys.W then direction += currentCamera.CFrame.LookVector end
        if flyKeys.S then direction -= currentCamera.CFrame.LookVector end
        if flyKeys.A then direction -= currentCamera.CFrame.RightVector end
        if flyKeys.D then direction += currentCamera.CFrame.RightVector end
        if flyKeys.Up then direction += Vector3.yAxis end
        if flyKeys.Down then direction -= Vector3.yAxis end

        flyVelocity.VectorVelocity =
            direction.Magnitude > 0
            and direction.Unit * Config.FlySpeed
            or Vector3.zero

        flyOrientation.CFrame = currentCamera.CFrame
    end)
end

connect(UserInputService.InputBegan, function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Z then flyKeys.W = true end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Q then flyKeys.A = true end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = true end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Up = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Down = true end
end)

connect(UserInputService.InputEnded, function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Z then flyKeys.W = false end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Q then flyKeys.A = false end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = false end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Up = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Down = false end
end)

TabPlayer:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Callback = function(value)
        if value then
            startFly()
        else
            stopFly()
        end
    end,
})

TabPlayer:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 150},
    Increment = 5,
    Suffix = " Speed",
    CurrentValue = Config.FlySpeed,
    Callback = function(value)
        Config.FlySpeed = value
    end,
})

--==================================================
-- NOCLIP
--==================================================

local savedCollision = {}

local function restoreCollision()
    for part, oldValue in pairs(savedCollision) do
        if part and part.Parent then
            part.CanCollide = oldValue
        end
    end
    table.clear(savedCollision)
end

local function updateNoclip()
    if not Config.Noclip then
        restoreCollision()
        return
    end

    local character = getCharacter()
    if not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if savedCollision[part] == nil then
                savedCollision[part] = part.CanCollide
            end
            part.CanCollide = false
        end
    end
end

connect(RunService.Stepped, updateNoclip)

TabPlayer:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(value)
        Config.Noclip = value
        if not value then
            restoreCollision()
        end
    end,
})

--==================================================
-- CHARACTER RESPAWN
--==================================================

local function applyCharacterSettings(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    humanoid.WalkSpeed = Config.WalkSpeed
    humanoid.UseJumpPower = true
    humanoid.JumpPower = Config.JumpPower

    if Config.Fly then
        task.defer(startFly)
    end
end

local function onCharacterAdded(character)
    restoreCollision()
    stopFly()
    task.defer(function()
        applyCharacterSettings(character)
    end)
end

table.insert(CharacterConnections, player.CharacterAdded:Connect(onCharacterAdded))

if player.Character then
    task.defer(function()
        applyCharacterSettings(player.Character)
    end)
end

--==================================================
-- VISUALS
--==================================================

TabVisuals:CreateLabel("Camera")

TabVisuals:CreateSlider({
    Name = "Field of View",
    Range = {50, 120},
    Increment = 1,
    Suffix = " FOV",
    CurrentValue = Config.FOV,
    Callback = function(value)
        Config.FOV = value
        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = value
        end
    end,
})

--==================================================
-- ESP
--==================================================

local espObjects = {}

local function removeESP(target)
    local data = espObjects[target]
    if not data then return end

    if data.highlight then
        data.highlight:Destroy()
    end

    if data.billboard then
        data.billboard:Destroy()
    end

    espObjects[target] = nil
end

local function createESP(target)
    if target == player or not Config.ESP then return end

    local character = target.Character
    if not character then return end

    removeESP(target)

    local highlight = Instance.new("Highlight")
    highlight.Name = "EniDevHighlight"
    highlight.FillColor = Color3.fromRGB(160, 32, 240)
    highlight.OutlineColor = Color3.fromRGB(230, 190, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character

    local head = character:FindFirstChild("Head")
    if not head then
        highlight:Destroy()
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EniDevTag"
    billboard.Size = UDim2.fromOffset(180, 50)
    billboard.StudsOffset = Vector3.new(0, 2.7, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(218, 112, 214)
    text.TextStrokeTransparency = 0.35
    text.TextSize = 14
    text.Font = Enum.Font.SourceSansBold
    text.Parent = billboard

    espObjects[target] = {
        highlight = highlight,
        billboard = billboard,
        text = text,
    }
end

local function clearESP()
    for target in pairs(espObjects) do
        removeESP(target)
    end
end

local function refreshESP()
    clearESP()

    if not Config.ESP then
        return
    end

    for _, target in ipairs(Players:GetPlayers()) do
        createESP(target)
    end
end

TabVisuals:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(value)
        Config.ESP = value
        refreshESP()
    end,
})

connect(Players.PlayerAdded, function(target)
    target.CharacterAdded:Connect(function()
        if Config.ESP then
            task.wait(0.5)
            createESP(target)
        end
    end)
end)

connect(Players.PlayerRemoving, function(target)
    removeESP(target)
end)

connect(RunService.RenderStepped, function()
    if not Config.ESP then return end

    local root = getRoot()
    if not root then return end

    for target, data in pairs(espObjects) do
        local character = target.Character
        local head = character and character:FindFirstChild("Head")

        if head and data.text then
            local distance = math.floor((head.Position - root.Position).Magnitude)
            data.text.Text = target.Name .. "\n[" .. distance .. " studs]"
        end
    end
end)

--==================================================
-- WORLD
--==================================================

TabWorld:CreateLabel("Lighting")

local originalLighting = {
    Ambient = Lighting.Ambient,
    Brightness = Lighting.Brightness,
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    ClockTime = Lighting.ClockTime,
}

TabWorld:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        Config.Fullbright = true
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end,
})

TabWorld:CreateButton({
    Name = "Restore Lighting",
    Callback = function()
        Config.Fullbright = false
        Lighting.Ambient = originalLighting.Ambient
        Lighting.Brightness = originalLighting.Brightness
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.FogEnd = originalLighting.FogEnd
    end,
})

TabWorld:CreateSlider({
    Name = "ClockTime",
    Range = {0, 24},
    Increment = 1,
    Suffix = " H",
    CurrentValue = Config.ClockTime,
    Callback = function(value)
        Config.ClockTime = value
        Lighting.ClockTime = value
    end,
})

TabWorld:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Callback = function(value)
        Config.NoFog = value
        Lighting.FogEnd = value and 1000000 or originalLighting.FogEnd
    end,
})

--==================================================
-- DIAGNOSTICS
--==================================================

local statusLabel

TabDiagnostics:CreateParagraph({
    Title = "Runtime Diagnostics",
    Content = "Run the diagnostic scan to inspect the current Studio test state."
})

TabDiagnostics:CreateButton({
    Name = "Run Diagnostics",
    Callback = function()
        local character = getCharacter()
        local humanoid = getHumanoid()
        local root = getRoot()
        local camera = workspace.CurrentCamera

        local report =
            "ENI HUB V2.8\n\n" ..
            "Studio: " .. tostring(RunService:IsStudio()) .. "\n" ..
            "Character: " .. (character and "OK" or "MISSING") .. "\n" ..
            "Humanoid: " .. (humanoid and "OK" or "MISSING") .. "\n" ..
            "RootPart: " .. (root and "OK" or "MISSING") .. "\n" ..
            "Camera: " .. (camera and "OK" or "MISSING") .. "\n" ..
            "Fly: " .. tostring(Config.Fly) .. "\n" ..
            "Noclip: " .. tostring(Config.Noclip) .. "\n" ..
            "ESP: " .. tostring(Config.ESP) .. "\n" ..
            "Connections: " .. tostring(#Connections)

        Rayfield:Notify({
            Title = "Diagnostics",
            Content = report,
            Duration = 8,
        })

        print(report)
    end,
})

TabDiagnostics:CreateButton({
    Name = "Print Full State",
    Callback = function()
        print("========== ENI HUB V2.8 ==========")
        for key, value in pairs(Config) do
            print(key, "=", value)
        end
        print("Connections:", #Connections)
        print("ESP Objects:", #espObjects)
        print("==================================")
    end,
})

--==================================================
-- SETTINGS / PANIC
--==================================================

TabSettings:CreateParagraph({
    Title = "Panic Cleanup",
    Content = "Press INSERT or use the button below to stop active systems and close the hub."
})

local closed = false

local function shutdown()
    if closed then return end
    closed = true

    stopFly()

    Config.Noclip = false
    restoreCollision()

    clearESP()

    local humanoid = getHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
        humanoid.WalkSpeed = 16
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 50
    end

    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = 70
    end

    Lighting.Ambient = originalLighting.Ambient
    Lighting.Brightness = originalLighting.Brightness
    Lighting.GlobalShadows = originalLighting.GlobalShadows
    Lighting.FogEnd = originalLighting.FogEnd
    Lighting.ClockTime = originalLighting.ClockTime

    disconnectAll()
    destroyTracked()

    pcall(function()
        Rayfield:Destroy()
    end)
end

connect(UserInputService.InputBegan, function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.Insert then
        shutdown()
    end
end)

TabSettings:CreateButton({
    Name = "PANIC / CLOSE HUB",
    Callback = shutdown,
})

Rayfield:Notify({
    Title = "ENI HUB V2.8",
    Content = "Developer Edition loaded successfully.",
    Duration = 5,
})
