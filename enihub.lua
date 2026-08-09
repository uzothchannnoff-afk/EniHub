-- [[ ENI HUB V2 - RAYFIELD EDITION ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- Language System (Default: English)
local currentLang = "en"

local translations = {
    en = {
        patchNotes = "Patch Notes",
        chatbot = "Chatbot",
        localPlayer = "LocalPlayer",
        universal = "Universal",
        visuals = "Visuals",
        teleport = "Teleport",
        cloud = "Cloud Scripts",
        xvchub = "XVCHUB",
        settings = "Settings",
        
        -- Chatbot
        chatbotTitle = "Eni Assistant v1.0",
        chatbotDesc = "Search for a keyword (e.g. fly, speed, esp, teleport, xvchub, noclip) to instantly find where features are located!",
        chatbotInput = "Search for a feature...",
        chatbotButton = "Ask Assistant",
        chatbotDefault = "Type a keyword below and click Search.",
        chatbotNotFound = "Sorry, no exact match found. Try words like: fly, speed, jump, noclip, esp, fov, rejoin, serverhop, cloud, xvchub, anti-afk, cursor.",
        chatbotEmpty = "Please enter a keyword in the text box above!",
        
        -- LocalPlayer
        walkSpeed = "WalkSpeed",
        jumpPower = "JumpPower",
        flyMode = "Fly Mode",
        flySpeed = "Fly Speed",
        infJump = "Infinite Jump",
        noclip = "Noclip",
        
        -- Universal
        antiAfk = "Anti-AFK",
        
        -- Visuals
        fullbright = "Enable Fullbright",
        fov = "Field of View (FOV)",
        esp = "Player ESP",
        
        -- Teleport
        rejoin = "Rejoin Server",
        serverHop = "Server Hop",
        notifyTeleport = "Teleport",
        notifyReconnecting = "Reconnecting to server...",
        notifySearching = "Searching for another server...",
        notifyNoServer = "No available server found.",
        
        -- Cloud
        execute = "Execute: ",
        cloudEngine = "Cloud Engine",
        fetching = "Fetching ",
        failed = "Failed",
        failLoad = "Check F9 console. Failed to load script.",
        
        -- XVCHUB
        execXvc = "Execute XVCHUB",
        xvcTitle = "XVCHUB",
        xvcLoading = "Loading script from Pastebin...",
        xvcSuccess = "XVCHUB loaded successfully!",
        
        -- Settings
        customCursor = "Custom Mouse Cursor",
        unload = "Unload Hub (Close completely)",
        langLabel = "Language / Idioma / Langue",
        langDesc = "Choose your preferred language",
        
        -- General
        success = "Success",
        done = "Operation completed!"
    },
    es = {
        patchNotes = "Notas de Versión",
        chatbot = "Asistente",
        localPlayer = "Jugador Local",
        universal = "Universal",
        visuals = "Visuales",
        teleport = "Teletransporte",
        cloud = "Scripts Cloud",
        xvchub = "XVCHUB",
        settings = "Ajustes",
        
        -- Chatbot
        chatbotTitle = "Asistente Eni v1.0",
        chatbotDesc = "¡Busca una palabra clave (ej: fly, speed, esp, teleport, xvchub, noclip) para encontrar dónde está la función!",
        chatbotInput = "Buscar una función...",
        chatbotButton = "Preguntar al Asistente",
        chatbotDefault = "¡Escribe una palabra clave abajo y haz clic en Buscar!",
        chatbotNotFound = "Lo siento, no encontré coincidencia. Prueba con: fly, speed, jump, noclip, esp, fov, rejoin, serverhop, cloud, xvchub, anti-afk, cursor.",
        chatbotEmpty = "¡Por favor ingresa una palabra clave en el cuadro de texto!",
        
        -- LocalPlayer
        walkSpeed = "Velocidad de Caminar",
        jumpPower = "Poder de Salto",
        flyMode = "Modo Vuelo",
        flySpeed = "Velocidad de Vuelo",
        infJump = "Salto Infinito",
        noclip = "Atravesar Paredes (Noclip)",
        
        -- Universal
        antiAfk = "Anti-AFK",
        
        -- Visuals
        fullbright = "Activar Brillo Total",
        fov = "Campo de Visión (FOV)",
        esp = "ESP de Jugadores",
        
        -- Teleport
        rejoin = "Reconectar al Servidor",
        serverHop = "Cambiar de Servidor",
        notifyTeleport = "Teletransporte",
        notifyReconnecting = "Reconectando al servidor...",
        notifySearching = "Buscando otro servidor...",
        notifyNoServer = "No se encontró ningún servidor disponible.",
        
        -- Cloud
        execute = "Ejecutar: ",
        cloudEngine = "Motor Cloud",
        fetching = "Obteniendo ",
        failed = "Fallido",
        failLoad = "Revisa la consola F9. Error al cargar el script.",
        
        -- XVCHUB
        execXvc = "Ejecutar XVCHUB",
        xvcTitle = "XVCHUB",
        xvcLoading = "Cargando script desde Pastebin...",
        xvcSuccess = "¡XVCHUB cargado con éxito!",
        
        -- Settings
        customCursor = "Cursor de Mouse Personalizado",
        unload = "Cerrar Hub por Completo",
        langLabel = "Idioma / Language / Langue",
        langDesc = "Elige tu idioma preferido",
        
        -- General
        success = "Éxito",
        done = "¡Operación completada!"
    },
    fr = {
        patchNotes = "Notes de Patch",
        chatbot = "Chatbot",
        localPlayer = "Joueur Local",
        universal = "Universel",
        visuals = "Visuels",
        teleport = "Téléportation",
        cloud = "Scripts Cloud",
        xvchub = "XVCHUB",
        settings = "Paramètres",
        
        -- Chatbot
        chatbotTitle = "Assistant Eni v1.0",
        chatbotDesc = "Cherche un mot-clé (ex: fly, speed, esp, teleport, xvchub, noclip) pour trouver instantanément où se trouve la fonctionnalité !",
        chatbotInput = "Rechercher une fonction...",
        chatbotButton = "Demander à l'assistant",
        chatbotDefault = "Tape un mot-clé ci-dessous et clique sur Rechercher.",
        chatbotNotFound = "Désolé, je n'ai pas trouvé de correspondance exacte. Essaie avec: fly, speed, jump, noclip, esp, fov, rejoin, serverhop, cloud, xvchub, anti-afk, cursor.",
        chatbotEmpty = "Veuillez entrer un mot-clé dans la zone de texte ci-dessus !",
        
        -- LocalPlayer
        walkSpeed = "Vitesse de marche",
        jumpPower = "Puissance de saut",
        flyMode = "Mode Vol",
        flySpeed = "Vitesse de vol",
        infJump = "Saut Infini",
        noclip = "Noclip (Traverser murs)",
        
        -- Universal
        antiAfk = "Anti-AFK",
        
        -- Visuals
        fullbright = "Activer Fullbright (Plein jour)",
        fov = "Champ de Vision (FOV)",
        esp = "ESP Joueurs",
        
        -- Teleport
        rejoin = "Rejoindre le serveur",
        serverHop = "Changer de serveur",
        notifyTeleport = "Téléportation",
        notifyReconnecting = "Reconnexion au serveur...",
        notifySearching = "Recherche d'un autre serveur...",
        notifyNoServer = "Aucun serveur disponible trouvé.",
        
        -- Cloud
        execute = "Exécuter : ",
        cloudEngine = "Moteur Cloud",
        fetching = "Récupération de ",
        failed = "Échec",
        failLoad = "Vérifie la console F9. Échec du chargement du script.",
        
        -- XVCHUB
        execXvc = "Exécuter XVCHUB",
        xvcTitle = "XVCHUB",
        xvcLoading = "Chargement du script depuis Pastebin...",
        xvcSuccess = "XVCHUB chargé avec succès !",
        
        -- Settings
        customCursor = "Curseurs Souris Personnalisé",
        unload = "Fermer complètement le Hub",
        langLabel = "Langue / Language / Idioma",
        langDesc = "Choisissez votre langue préférée",
        
        -- General
        success = "Succès",
        done = "Opération terminée !"
    }
}

local function L(key)
    if translations[currentLang] and translations[currentLang][key] then
        return translations[currentLang][key]
    elseif translations["en"][key] then
        return translations["en"][key]
    end
    return key
end

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eni Hub | V2",
    LoadingTitle = "Initializing Eni Hub...",
    LoadingSubtitle = "by Gaby",
    Theme = "Amethyst", -- Style violet moderne
    ConfigurationSaving = {
        Enabled = true,
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
local TabChatbot = Window:CreateTab("Chatbot", 4483362458)
local TabLocal = Window:CreateTab("LocalPlayer", 4483362458)
local TabUniversal = Window:CreateTab("Universal", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483362458)
local TabTeleport = Window:CreateTab("Teleport", 4483362458)
local TabCloud = Window:CreateTab("Cloud Scripts", 4483362458)
local TabCustom = Window:CreateTab("XVCHUB", 4483362458)
local TabSettings = Window:CreateTab("Settings", 4483362458)

-- ==========================================
-- || 1. PATCH NOTES (v2.4 & Secret Update)
-- ==========================================
TabNotes:CreateLabel("v2.4 - Secret Update & Eni Hub V3 Teaser")
TabNotes:CreateParagraph({
    Title = "🤫 SECRET UPDATE RELEASED", 
    Content = "A secret background patch has just been deployed! Includes deeper cursor locks fixes, internal script optimization, and exclusive hidden V3 teasers scattered across the entire hub interface. Can you find them all?"
})

TabNotes:CreateParagraph({
    Title = "v2.4 Complete Changes & Additions List:", 
    Content = "- [SECRET] Added hidden V3 teaser hints across various tabs and menus\n"..
              "- [FIX] Completely resolved mouse cursor locking issues during gameplay and fly mode\n"..
              "- Added Eni Chatbot tab to help find features, tabs, and scripts instantly within Eni Hub\n"..
              "- Added multi-language support (English, Spanish, French) inside Settings\n"..
              "- Added Custom Mouse Cursor toggle with smooth tracking\n"..
              "- Added Teleport tab featuring Server Hop and Rejoin options\n"..
              "- Added Cloud Scripts integration (Infinite Yield, Dark Dex V3, SimpleSpy, Orca Hub)\n"..
              "- Added XVCHUB external script launcher tab\n"..
              "- Added Visuals options: Fullbright, FOV slider, and Player ESP highlight\n"..
              "- Added LocalPlayer tools: WalkSpeed, JumpPower, 3D Camera-Relative Fly Mode, Infinite Jump, and Noclip\n"..
              "- Added Universal Anti-AFK feature\n"..
              "- Added Settings tab with Unload Hub option to completely shut down the interface"
})

-- ==========================================
-- || 2. CHATBOT ASSISTANT
-- ==========================================
TabChatbot:CreateLabel("Eni Assistant v1.0")
TabChatbot:CreateParagraph({Title = "Info", Content = "Search for a keyword (e.g. fly, speed, esp, teleport, xvchub, noclip) to instantly find features!"})
TabChatbot:CreateParagraph({Title = "🔮 V3 Teaser #1", Content = "Secret hint: The upcoming Eni Hub V3 will feature a fully integrated custom script executor and cloud theme store!"})

local chatbotSearchInput = ""
local chatbotResponseLabel = TabChatbot:CreateParagraph({Title = "Response:", Content = "Type a keyword below and click Search."})

TabChatbot:CreateInput({
    Name = "Search feature...",
    PlaceholderText = "ex: fly, esp, noclip...",
    RemoveTextAfterFocusLost = false,
    Flag = "Input_ChatbotQuery",
    Callback = function(Text)
        chatbotSearchInput = string.lower(Text)
    end,
})

TabChatbot:CreateButton({
    Name = "Ask Assistant",
    Callback = function()
        local query = chatbotSearchInput or ""
        local result = L("chatbotNotFound")

        if query == "" then
            result = L("chatbotEmpty")
        elseif string.find(query, "fly") or string.find(query, "voler") then
            result = "✈️ Fly Mode & Fly Speed -> **LocalPlayer**"
        elseif string.find(query, "speed") or string.find(query, "vitesse") or string.find(query, "walk") then
            result = "🏃 WalkSpeed -> **LocalPlayer**"
        elseif string.find(query, "jump") or string.find(query, "saut") then
            result = "🦘 JumpPower & Infinite Jump -> **LocalPlayer**"
        elseif string.find(query, "noclip") or string.find(query, "travers") then
            result = "👻 Noclip -> **LocalPlayer**"
        elseif string.find(query, "anti") or string.find(query, "afk") then
            result = "🛡️ Anti-AFK -> **Universal**"
        elseif string.find(query, "fullbright") or string.find(query, "lum") or string.find(query, "light") then
            result = "💡 Enable Fullbright -> **Visuals**"
        elseif string.find(query, "fov") or string.find(query, "camera") then
            result = "🎥 Field of View (FOV) -> **Visuals**"
        elseif string.find(query, "esp") or string.find(query, "player") or string.find(query, "wallhack") then
            result = "👁️ Player ESP -> **Visuals**"
        elseif string.find(query, "teleport") or string.find(query, "rejoin") or string.find(query, "hop") or string.find(query, "server") then
            result = "🚀 Rejoin Server & Server Hop -> **Teleport**"
        elseif string.find(query, "cloud") or string.find(query, "admin") or string.find(query, "dex") or string.find(query, "spy") or string.find(query, "orca") then
            result = "☁️ Cloud Scripts -> **Cloud Scripts**"
        elseif string.find(query, "xvc") or string.find(query, "pastebin") then
            result = "🔗 XVCHUB -> **XVCHUB**"
        elseif string.find(query, "cursor") or string.find(query, "souris") or string.find(query, "unload") or string.find(query, "fermer") then
            result = "⚙️ Custom Mouse Cursor & Unload -> **Settings**"
        end

        chatbotResponseLabel:Set({Title = "Response:", Content = result})
        Rayfield:Notify({Title = "Chatbot", Content = "Done!", Duration = 2, Image = 4483362458})
    end,
})

-- ==========================================
-- || 3. LOCALPLAYER
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

local noclipEnabled = false
TabLocal:CreateToggle({
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
-- || 4. UNIVERSAL
-- ==========================================
-- Anti-AFK
TabUniversal:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "Toggle_AntiAFK",
    Callback = function(Value)
        _G.AntiAFK = Value
        if _G.AntiAFK then
            local vu = game:GetService("VirtualUser")
            player.Idled:Connect(function()
                if _G.AntiAFK then
                    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end,
})

-- ==========================================
-- || 5. VISUALS
-- ==========================================
TabVisuals:CreateButton({
    Name = "Enable Fullbright",
    Callback = function()
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    end,
})

TabVisuals:CreateSlider({
    Name = "Field of View (FOV)",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "Slider_FOV",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
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
                    highlight.FillColor = Color3.fromRGB(180, 100, 255)
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
-- || 6. TELEPORT
-- ==========================================
TabTeleport:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        Rayfield:Notify({Title = L("notifyTeleport"), Content = L("notifyReconnecting"), Duration = 3, Image = 4483362458})
        if #Players:GetPlayers() <= 1 then
            player:Kick("\nReconnecting...")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, player)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
        end
    end,
})

TabTeleport:CreateButton({
    Name = "Server Hop",
    Callback = function()
        Rayfield:Notify({Title = L("notifyTeleport"), Content = L("notifySearching"), Duration = 3, Image = 4483362458})
        local suc, res = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/public?sortOrder=Asc&limit=100"))
        end)
        if suc and res and res.data then
            for _, s in ipairs(res.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                    return
                end
            end
        end
        Rayfield:Notify({Title = L("failed"), Content = L("notifyNoServer"), Duration = 3, Image = 4483362458})
    end,
})

-- ==========================================
-- || 7. CLOUD SCRIPTS
-- ==========================================
TabCloud:CreateParagraph({Title = "🔮 V3 Teaser #2", Content = "Secret hint: Cloud scripts will load 3x faster in V3 with native sandboxing protection."})

local CloudDatabase = {
    {Name = "Infinite Yield (Admin Engine)", Url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {Name = "Dark Dex V3 (Explorer)", Url = "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"},
    {Name = "SimpleSpy (Remote Logger)", Url = "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"},
    {Name = "Orca Hub (Universal)", Url = "https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"}
}

for _, scriptData in ipairs(CloudDatabase) do
    TabCloud:CreateButton({
        Name = L("execute") .. scriptData.Name,
        Callback = function()
            Rayfield:Notify({
                Title = L("cloudEngine"),
                Content = L("fetching") .. scriptData.Name .. "...",
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
                    Title = L("failed"),
                    Content = L("failLoad"),
                    Duration = 5,
                    Image = 4483362458,
                })
            end
        end,
    })
end

-- ==========================================
-- || 8. XVCHUB
-- ==========================================
TabCustom:CreateParagraph({Title = "🔮 V3 Teaser #3", Content = "Secret hint: Eni Hub V3 will introduce multi-hub cross-compatibility with XVCHUB extensions."})

TabCustom:CreateButton({
    Name = "Execute XVCHUB",
    Callback = function()
        Rayfield:Notify({
            Title = L("xvcTitle"),
            Content = L("xvcLoading"),
            Duration = 3,
            Image = 4483362458,
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://pastebin.com/raw/Piw5bqGq"))()
        end)
        
        if not success then
            warn("XVCHUB FETCH FAILED:\n" .. tostring(err))
            Rayfield:Notify({
                Title = L("failed"),
                Content = L("failLoad"),
                Duration = 5,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = L("success"),
                Content = L("xvcSuccess"),
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- ==========================================
-- || 9. SETTINGS & CUSTOM CURSOR
-- ==========================================
TabSettings:CreateParagraph({Title = "🔮 V3 Teaser #4", Content = "Secret hint: Direct profile synchronization and custom cursor packs are coming in the V3 update."})

local customCursorEnabled = false
local cursorGui, cursorImg

TabSettings:CreateDropdown({
    Name = "Language / Idioma / Langue",
    Options = {"English", "Español", "Français"},
    CurrentOption = "English",
    Flag = "Dropdown_Language",
    Callback = function(Option)
        if Option == "English" then
            currentLang = "en"
        elseif Option == "Español" then
            currentLang = "es"
        elseif Option == "Français" then
            currentLang = "fr"
        end
        Rayfield:Notify({Title = "Language", Content = "Language changed successfully!", Duration = 2, Image = 4483362458})
    end,
})

TabSettings:CreateToggle({
    Name = "Custom Mouse Cursor",
    CurrentValue = false,
    Flag = "Toggle_CustomCursor",
    Callback = function(Value)
        customCursorEnabled = Value
        if customCursorEnabled then
            if not cursorGui then
                cursorGui = Instance.new("ScreenGui")
                cursorGui.Name = "EniCustomCursor"
                cursorGui.IgnoreGuiInset = true
                cursorGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                cursorGui.Parent = CoreGui

                cursorImg = Instance.new("ImageLabel")
                cursorImg.Name = "Cursor"
                cursorImg.Size = UDim2.new(0, 32, 0, 32)
                cursorImg.BackgroundTransparency = 1
                cursorImg.Image = "rbxassetid://6031091004"
                cursorImg.ImageColor3 = Color3.fromRGB(200, 120, 255)
                cursorImg.Parent = cursorGui

                RunService.RenderStepped:Connect(function()
                    if customCursorEnabled and cursorImg then
                        local mousePos = UserInputService:GetMouseLocation()
                        cursorImg.Position = UDim2.new(0, mousePos.X - 16, 0, mousePos.Y - 16)
                    end
                end)
            end
            cursorGui.Enabled = true
            UserInputService.MouseIconEnabled = false
        else
            if cursorGui then
                cursorGui.Enabled = false
            end
            UserInputService.MouseIconEnabled = true
        end
    end,
})

TabSettings:CreateButton({
    Name = "Unload Hub (Fermer complètement)",
    Callback = function()
        if cursorGui then cursorGui:Destroy() end
        UserInputService.MouseIconEnabled = true
        Rayfield:Destroy()
    end,
})

-- Fix complet et continu pour le curseur/souris bloqué (Empêche le verrouillage intempestif de Rayfield sur la caméra)
RunService.RenderStepped:Connect(function()
    if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter and not flying and not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end)
