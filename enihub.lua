-- [[ ENI HUB V2 - RAYFIELD EDITION WITH SCRIPTBLOX ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eni Hub | V2",
    LoadingTitle = "Initializing Eni Hub...",
    LoadingSubtitle = "by Gaby",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "EniHub",
        FileName = "EniHubSave"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- ==========================================
-- || TABS
-- ==========================================
local TabNotes = Window:CreateTab("Patch Notes", 4483362458)
local TabLocal = Window:CreateTab("LocalPlayer", 4483362458)
local TabUniversal = Window:CreateTab("Universal", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483362458)
local TabScriptBlox = Window:CreateTab("ScriptBlox", 4483362458)
local TabCloud = Window:CreateTab("Cloud Scripts", 4483362458)

-- ==========================================
-- || 1. PATCH NOTES
-- ==========================================
TabNotes:CreateLabel("v2.4 - ScriptBlox Integration")
TabNotes:CreateParagraph({Title = "Changes:", Content = "- Added live ScriptBlox API search tab\n- Integrated automatic script execution from search results\n- Added required 'Powered by ScriptBlox.com' attribution"})

TabNotes:CreateLabel("v2.3 - Fly Direction Bug Fix")
TabNotes:CreateParagraph({Title = "Changes:", Content = "- Fixed 3D camera-relative flight vectoring\n- Pressing forward/backward/sides now correctly follows camera view on all layouts"})

-- ==========================================
-- || 2. LOCALPLAYER
-- ==========================================
local flySpeed = 50
local flying = false
local flyAttachment, linearVelocity, alignOrientation, flyConnection

-- Key tracking for smooth 3D flight
local keysDown = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LeftShift = false
}

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Z then keysDown.W = true end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Q then keysDown.A = true end
    if input.KeyCode == Enum.KeyCode.S then keysDown.S = true end
    if input.KeyCode == Enum.KeyCode.D then keysDown.D = true end
    if input.KeyCode == Enum.KeyCode.Space then keysDown.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then keysDown.LeftShift = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Z then keysDown.W = false end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Q then keysDown.A = false end
    if input.KeyCode == Enum.KeyCode.S then keysDown.S = false end
    if input.KeyCode == Enum.KeyCode.D then keysDown.D = false end
    if input.KeyCode == Enum.KeyCode.Space then keysDown.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then keysDown.LeftShift = false end
end)

TabLocal:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider_WalkSpeed",
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

TabLocal:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "Slider_JumpPower",
    Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.UseJumpPower = true
            player.Character.Humanoid.JumpPower = Value
        end
    end,
})

TabLocal:CreateToggle({
    Name = "Fly Mode",
    CurrentValue = false,
    Flag = "Toggle_Fly",
    Callback = function(Value)
        flying = Value
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end
        
        local rootPart = char.HumanoidRootPart
        local humanoid = char.Humanoid
        local camera = workspace.CurrentCamera

        if flying then
            humanoid.PlatformStand = true
            flyAttachment = Instance.new("Attachment", rootPart)
            
            linearVelocity = Instance.new("LinearVelocity", rootPart)
            linearVelocity.Attachment0 = flyAttachment
            linearVelocity.MaxForce = 1000000
            linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            
            alignOrientation = Instance.new("AlignOrientation", rootPart)
            alignOrientation.Attachment0 = flyAttachment
            alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
            alignOrientation.MaxTorque = 1000000
            alignOrientation.Responsiveness = 200

            flyConnection = RunService.RenderStepped:Connect(function()
                if not flying or not player.Character or not player.Character:FindFirstChild("Humanoid") then
                    if flyConnection then flyConnection:Disconnect() end
                    return
                end
                
                local moveVector = Vector3.new()
                local camCFrame = camera.CFrame

                if keysDown.W then moveVector = moveVector + camCFrame.LookVector end
                if keysDown.S then moveVector = moveVector - camCFrame.LookVector end
                if keysDown.A then moveVector = moveVector - camCFrame.RightVector end
                if keysDown.D then moveVector = moveVector + camCFrame.RightVector end
                if keysDown.Space then moveVector = moveVector + Vector3.new(0, 1, 0) end
                if keysDown.LeftShift then moveVector = moveVector - Vector3.new(0, 1, 0) end

                if moveVector.Magnitude > 0 then
                    linearVelocity.VectorVelocity = moveVector.Unit * flySpeed
                else
                    linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
                end
                
                alignOrientation.CFrame = camCFrame
            end)
        else
            humanoid.PlatformStand = false
            if flyConnection then flyConnection:Disconnect() end
            if linearVelocity then linearVelocity:Destroy() end
            if alignOrientation then alignOrientation:Destroy() end
            if flyAttachment then flyAttachment:Destroy() end
        end
    end,
})

TabLocal:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "Slider_FlySpeed",
    Callback = function(Value)
        flySpeed = Value
    end,
})

TabLocal:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "Toggle_InfJump",
    Callback = function(Value)
        _G.InfJump = Value
    end,
})

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==========================================
-- || 3. UNIVERSAL
-- ==========================================
local noclipEnabled = false
TabUniversal:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Toggle_Noclip",
    Callback = function(Value)
        noclipEnabled = Value
    end,
})

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ==========================================
-- || 4. VISUALS
-- ==========================================
TabVisuals:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end,
})

local espEnabled = false
TabVisuals:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "Toggle_ESP",
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("EniHighlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "EniHighlight"
                    highlight.FillColor = Color3.fromRGB(200, 200, 200)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = p.Character
                end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("EniHighlight") then
                    p.Character.EniHighlight:Destroy()
                end
            end
        end
    end,
})

-- ==========================================
-- || 5. SCRIPTBLOX API
-- ==========================================
TabScriptBlox:CreateLabel("Powered by ScriptBlox.com")

local searchQuery = ""

TabScriptBlox:CreateInput({
    Name = "Search Scripts",
    PlaceholderText = "Ex: Arsenal, Doors, Hub...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        searchQuery = Text
    end,
})

TabScriptBlox:CreateButton({
    Name = "Search & Load First Result",
    Callback = function()
        if searchQuery == "" then return end
        
        Rayfield:Notify({
            Title = "ScriptBlox",
            Content = "Recherche en cours pour: " .. searchQuery,
            Duration = 3,
            Image = 4483362458,
        })
        
        local success, response = pcall(function()
            local url = "https://scriptblox.com/api/script/search?q=" .. HttpService:UrlEncode(searchQuery)
            return game:HttpGet(url)
        end)
        
        if success then
            local data = HttpService:JSONDecode(response)
            if data and data.result and data.result.scripts then
                local scriptsList = data.result.scripts
                if #scriptsList > 0 then
                    local firstScriptCode = scriptsList[1].script
                    
                    Rayfield:Notify({
                        Title = "Script Trouvé !",
                        Content = "Exécution de: " .. tostring(scriptsList[1].title),
                        Duration = 3,
                        Image = 4483362458,
                    })
                    
                    local runSuccess, runErr = pcall(function()
                        loadstring(firstScriptCode)()
                    end)
                    
                    if not runSuccess then
                        warn("Erreur d'exécution: " .. tostring(runErr))
                        Rayfield:Notify({
                            Title = "Erreur",
                            Content = "Impossible d'exécuter le script (voir console F9).",
                            Duration = 4,
                            Image = 4483362458,
                        })
                    end
                else
                    Rayfield:Notify({
                        Title = "Aucun résultat",
                        Content = "Aucun script trouvé pour cette recherche.",
                        Duration = 3,
                        Image = 4483362458,
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "Erreur API",
                Content = "Impossible de contacter ScriptBlox.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- ==========================================
-- || 6. CLOUD SCRIPTS
-- ==========================================
local CloudDatabase = {
    {Name = "Infinite Yield (Admin Engine)", Url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {Name = "Dark Dex V3 (Explorer)", Url = "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"},
    {Name = "SimpleSpy (Remote Logger)", Url = "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"},
    {Name = "Orca Hub (Universal)", Url = "https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"}
}

for _, scriptData in ipairs(CloudDatabase) do
    TabCloud:CreateButton({
        Name = "Execute: " .. scriptData.Name,
        Callback = function()
            Rayfield:Notify({
                Title = "Cloud Engine",
                Content = "Fetching " .. scriptData.Name .. "...",
                Duration = 3,
                Image = 4483362458,
            })
            
            local success, err = pcall(function()
                local scriptContent = game:HttpGet(scriptData.Url)
                local executable, loadErr = loadstring(scriptContent)
                if executable then executable() else error(tostring(loadErr)) end
            end)
            
            if not success then
                warn("ENI HUB - CLOUD FETCH FAILED:\n" .. tostring(err))
                Rayfield:Notify({
                    Title = "Failed",
                    Content = "Check F9 console. Failed to load script.",
                    Duration = 5,
                    Image = 4483362458,
                })
            end
        end,
    })
end
