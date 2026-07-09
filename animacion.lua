local LP = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local URL = "http://www.roblox.com/asset/?id="
local WebhookURL = "https://discord.com/api/webhooks/1495472863241572422/3E2RKRgoudX-2txH8bEati_32dKX8Qe680sYTpPEU4_4E8_5FnMnTsjwpmM8DlsUQn3q"

local function GetServerInfo()
    local info = {
        JobId = game.JobId or "Desconocido",
        GameId = tostring(game.GameId) or "Desconocido",
        PlaceId = tostring(game.PlaceId) or "Desconocido",
        PlaceVersion = tostring(game.PlaceVersion) or "Desconocido",
        Network = Stats:FindFirstChild("Network") and Stats.Network:GetValue() or "N/A"
    }
    return info
end

local function GetPlayerInfo()
    local info = {
        Name = LP.Name,
        DisplayName = LP.DisplayName,
        UserId = LP.UserId,
        AccountAge = LP.AccountAge or "Desconocido",
        MembershipType = tostring(LP.MembershipType) or "Desconocido",
    }
    return info
end

local function GetDeviceInfo()
    local success, result = pcall(function()
        return game:GetService("UserInputService"):GetPlatform()
    end)
    
    local info = {
        Platform = success and result or "Desconocido",
        TouchEnabled = tostring(game:GetService("UserInputService").TouchEnabled),
        KeyboardEnabled = tostring(game:GetService("UserInputService").KeyboardEnabled),
        MouseEnabled = tostring(game:GetService("UserInputService").MouseEnabled),
        GamepadEnabled = tostring(game:GetService("UserInputService").GamepadEnabled),
    }
    return info
end

local function GetGameInfo()
    local info = {
        Name = game.Name or "Desconocido",
        Creator = game.CreatorId and tostring(game.CreatorId) or "Desconocido",
        FPS = tostring(Stats:FindFirstChild("PerformanceStats") and Stats.PerformanceStats:GetValue() or "N/A"),
        Memory = tostring(Stats:FindFirstChild("MemoryStats") and Stats.MemoryStats:GetValue() or "N/A"),
        Ping = tostring(Stats:FindFirstChild("Network") and Stats.Network:GetValue() or "N/A")
    }
    return info
end

local function GetTimeInfo()
    local info = {
        Timestamp = os.date("!%Y-%m-%dT%H:%M:%S"),
        Date = os.date("%Y-%m-%d"),
        Time = os.date("%H:%M:%S"),
        Hour = tonumber(os.date("%H")),
        Minute = tonumber(os.date("%M")),
        Second = tonumber(os.date("%S"))
    }
    return info
end

local function SendWebhook(animacion, tipo, esPack)
    local color = esPack and 0x00FF00 or 0xFFA500
    local title = esPack and "📦 Pack Completo" or "🔀 Animación Individual"
    
    local serverInfo = GetServerInfo()
    local playerInfo = GetPlayerInfo()
    local deviceInfo = GetDeviceInfo()
    local gameInfo = GetGameInfo()
    local timeInfo = GetTimeInfo()
    
    local description = string.format([
**👤 USUARIO**
• Nombre: `%s`
• Nombre Mostrado: `%s`
• ID: `%d`
• Antigüedad Cuenta: `%s` días
• Tipo Membresía: `%s`

**🎮 ANIMACIÓN**
• Animación: `%s`
• Tipo: `%s`
• Pack Completo: `%s`

**🖥️ DISPOSITIVO**
• Plataforma: `%s`
• Pantalla Táctil: `%s`
• Teclado: `%s`
• Mouse: `%s`
• Gamepad: `%s`

**🌍 SERVIDOR**
• Job ID: `%s`
• Game ID: `%s`
• Place ID: `%s`
• Versión Place: `%s`

**📊 JUEGO**
• Nombre: `%s`
• Creador ID: `%s`
• FPS: `%s`
• Memoria: `%s`
• Ping: `%s`

**⏰ TIEMPO**
• Fecha: `%s`
• Hora: `%s`
• Timestamp: `%s`
]],
    playerInfo.Name,
    playerInfo.DisplayName,
    playerInfo.UserId,
    tostring(playerInfo.AccountAge),
    playerInfo.MembershipType,
    animacion,
    tipo,
    esPack and "Sí" or "No",
    deviceInfo.Platform,
    deviceInfo.TouchEnabled,
    deviceInfo.KeyboardEnabled,
    deviceInfo.MouseEnabled,
    deviceInfo.GamepadEnabled,
    serverInfo.JobId,
    serverInfo.GameId,
    serverInfo.PlaceId,
    serverInfo.PlaceVersion,
    gameInfo.Name,
    gameInfo.Creator,
    gameInfo.FPS,
    gameInfo.Memory,
    gameInfo.Ping,
    timeInfo.Date,
    timeInfo.Time,
    timeInfo.Timestamp
)
    
    local data = {
        username = "Animations Menu",
        avatar_url = "https://www.roblox.com/asset-thumbnail/image?assetId=616136790&width=420&height=420",
        embeds = {{
            title = title,
            description = description,
            color = color,
            footer = {text = string.format("Usuario ID: %d | Hora: %s", playerInfo.UserId, timeInfo.Time)},
            timestamp = timeInfo.Timestamp
        }}
    }
    
    local json = HttpService:JSONEncode(data)
    pcall(function()
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    end)
end

-- Enviar webhook cuando se abre el menú
local function SendOpenMenuWebhook()
    local playerInfo = GetPlayerInfo()
    local timeInfo = GetTimeInfo()
    local gameInfo = GetGameInfo()
    
    local data = {
        username = "Animations Menu",
        avatar_url = "https://www.roblox.com/asset-thumbnail/image?assetId=616136790&width=420&height=420",
        embeds = {{
            title = "🎮 Menú Abierto",
            description = string.format("**Usuario:** `%s` (ID: %d)\n**Juego:** `%s`\n**Place ID:** `%s`\n**Hora:** `%s`", 
                playerInfo.Name, playerInfo.UserId, gameInfo.Name, gameInfo.PlaceId, timeInfo.Time),
            color = 0x3498DB,
            timestamp = timeInfo.Timestamp
        }}
    }
    
    local json = HttpService:JSONEncode(data)
    pcall(function()
        request({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    end)
end

local Animations = {
    Stylish        = {Idle=616136790,  Idle2=616138447,  Idle3=886888594,  Walk=616146177,  Run=616140816,  Jump=616139451,  Climb=616133594,  Fall=616134815,  Swim=616143378,  SwimIdle=616144772,  Weight=9, Weight2=1},
    Zombie         = {Idle=616158929,  Idle2=616160636,  Idle3=885545458,  Walk=616168032,  Run=616163682,  Jump=616161997,  Climb=616156119,  Fall=616157476,  Swim=616165109,  SwimIdle=616166655,  Weight=9, Weight2=1},
    Robot          = {Idle=616088211,  Idle2=616089559,  Idle3=885531463,  Walk=616095330,  Run=616091570,  Jump=616090535,  Climb=616086039,  Fall=616087089,  Swim=616092998,  SwimIdle=616094091,  Weight=9, Weight2=1},
    Toy            = {Idle=782841498,  Idle2=782845736,  Idle3=980952228,  Walk=782843345,  Run=782842708,  Jump=782847020,  Climb=782843869,  Fall=782846423,  Swim=782844582,  SwimIdle=782845186,  Weight=9, Weight2=1},
    Cartoony       = {Idle=742637544,  Idle2=742638445,  Idle3=885477856,  Walk=742640026,  Run=742638842,  Jump=742637942,  Climb=742636889,  Fall=742637151,  Swim=742639220,  SwimIdle=742639812,  Weight=9, Weight2=1},
    Superhero      = {Idle=616111295,  Idle2=616113536,  Idle3=885535855,  Walk=616122287,  Run=616117076,  Jump=616115533,  Climb=616104706,  Fall=616108001,  Swim=616119360,  SwimIdle=616120861,  Weight=9, Weight2=1},
    Mage           = {Idle=707742142,  Idle2=707855907,  Idle3=885508740,  Walk=707897309,  Run=707861613,  Jump=707853694,  Climb=707826056,  Fall=707829716,  Swim=707876443,  SwimIdle=707894699,  Weight=9, Weight2=1},
    Levitation     = {Idle=616006778,  Idle2=616008087,  Idle3=886862142,  Walk=616013216,  Run=616010382,  Jump=616008936,  Climb=616003713,  Fall=616005863,  Swim=616011509,  SwimIdle=616012453,  Weight=9, Weight2=1},
    Vampire        = {Idle=1083445855, Idle2=1083450166, Idle3=1088037547, Walk=1083473930, Run=1083462077, Jump=1083455352, Climb=1083439238, Fall=1083443587, Swim=1083464683, SwimIdle=1083467779, Weight=9, Weight2=1},
    Elder          = {Idle=845397899,  Idle2=845400520,  Idle3=901160519,  Walk=845403856,  Run=845386501,  Jump=845398858,  Climb=845392038,  Fall=845396048,  Swim=845401742,  SwimIdle=845403127,  Weight=9, Weight2=1},
    Werewolf       = {Idle=1083195517, Idle2=1083214717, Idle3=1099492820, Walk=1083178339, Run=1083216690, Jump=1083218792, Climb=1083182000, Fall=1083189019, Swim=1083222527, SwimIdle=1083225406, Weight=9, Weight2=1},
    Knight         = {Idle=657595757,  Idle2=657568135,  Idle3=885499184,  Walk=657552124,  Run=657564596,  Jump=658409194,  Climb=658360781,  Fall=657600338,  Swim=657560551,  SwimIdle=657557095,  Weight=9, Weight2=1},
    Bold           = {Idle=16738333868,Idle2=16738334710,Idle3=16738335517,Walk=16738340646,Run=16738337225,Jump=16738336650,Climb=16738332169,Fall=16738333171,Swim=16738339158, SwimIdle=16738339817,Weight=9, Weight2=1},
    Astronaut      = {Idle=891621366,  Idle2=891633237,  Idle3=1047759695, Walk=891667138,  Run=891636393,  Jump=891627522,  Climb=891609353,  Fall=891617961,  Swim=891639666,  SwimIdle=891663592,  Weight=9, Weight2=1},
    Bubbly         = {Idle=910004836,  Idle2=910009958,  Idle3=1018536639, Walk=910034870,  Run=910025107,  Jump=910016857,  Climb=909997997,  Fall=910001910,  Swim=910028158,  SwimIdle=910030921,  Weight=9, Weight2=1},
    Pirate         = {Idle=750781874,  Idle2=750782770,  Idle3=885515365,  Walk=750785693,  Run=750783738,  Jump=750782230,  Climb=750779899,  Fall=750780242,  Swim=750784579,  SwimIdle=750785176,  Weight=9, Weight2=1},
    Rthro          = {Idle=2510196951, Idle2=2510197257, Idle3=3711062489, Walk=2510202577, Run=2510198475, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
    Ninja          = {Idle=656117400,  Idle2=656118341,  Idle3=886742569,  Walk=656121766,  Run=656118852,  Jump=656117878,  Climb=656114359,  Fall=656115606,  Swim=656119721,  SwimIdle=656121397,  Weight=9, Weight2=1},
    Oldschool      = {Idle=5319828216, Idle2=5319831086, Idle3=5392107832, Walk=5319847204, Run=5319844329, Jump=5319841935, Climb=5319816685, Fall=5319839762, Swim=5319850266, SwimIdle=5319852613, Weight=9, Weight2=1},
    Realistic      = {Idle=17172918855,Idle2=17173014241,Idle3=17173014241,Walk=11600249883,Run=11600211410,Jump=11600210487,Climb=11600205519,Fall=11600206437,Swim=11600212676, SwimIdle=11600213505,Weight=9, Weight2=1},
    ['No Boundaries']    = {Idle=18747067405,Idle2=18747063918,Idle3=18747063918,Walk=18747074203,Run=18747070484,Jump=18747069148,Climb=18747060903,Fall=18747062535,Swim=18747073181,SwimIdle=18747071682,Weight=9,Weight2=1},
    ['NFL Animation']    = {Idle=92080889861410,Idle2=74451233229259,Idle3=80884010501210,Walk=110358958299415,Run=117333533048078,Jump=119846112151352,Climb=134630013742019,Fall=129773241321032,Swim=132697394189921,SwimIdle=79090109939093,Weight=9,Weight2=1},
    ['Adidas Aura']      = {Idle=110211186840347,Idle2=114191137265065,Idle3=99129837931148,Walk=83842218823011,Run=118320322718866,Jump=109996626521204,Climb=97824616490448,Fall=95603166884636,Swim=134530128383903,SwimIdle=94922130551805,Weight=9,Weight2=1},
    ['Adidas Sports']    = {Idle=18537376492,Idle2=18537371272,Idle3=18537374150,Walk=18537392113,Run=18537384940,Jump=18537380791,Climb=18537363391,Fall=18537367238,Swim=18537389531,SwimIdle=18537387180,Weight=9,Weight2=1},
    ['Adidas Community'] = {Idle=122257458498464,Idle2=102357151005774,Idle3=89262795687364,Walk=122150855457006,Run=82598234841035,Jump=75290611992385,Climb=88763136693023,Fall=98600215928904,Swim=133308483266208,SwimIdle=109346520324160,Weight=9,Weight2=1},
    ['Wickled Popular']  = {Idle=118832222982049,Idle2=76049494037641,Idle3=138255200176080,Walk=92072849924640,Run=72301599441680,Jump=104325245285198,Climb=131326830509784,Fall=121152442762481,Swim=99384245425157,SwimIdle=113199415118199,Weight=9,Weight2=1},
    ['Catwalk Glam']     = {Idle=133806214992291,Idle2=94970088341563,Idle3=87105332133518,Walk=109168724482748,Run=81024476153754,Jump=116936326516985,Climb=119377220967554,Fall=92294537340807,Swim=134591743181628,SwimIdle=98854111361360,Weight=9,Weight2=1},
    Princess       = {Idle=941003647,  Idle2=941013098,  Idle3=1159195712, Walk=941028902,  Run=941015281,  Jump=941008832,  Climb=940996062,  Fall=941000007,  Swim=941018893,  SwimIdle=941025398,  Weight=9, Weight2=1},
    Confident      = {Idle=1069977950, Idle2=1069987858, Idle3=1116160740, Walk=1070017263, Run=1070001516, Jump=1069984524, Climb=1069946257, Fall=1069973677, Swim=1070009914, SwimIdle=1070012133, Weight=9, Weight2=1},
    Popstar        = {Idle=1212900985, Idle2=1150842221, Idle3=1239733474, Walk=1212980338, Run=1212980348, Jump=1212954642, Climb=1213044953, Fall=1212900995, Swim=1212852603, SwimIdle=1070012133, Weight=9, Weight2=1},
    Patrol         = {Idle=1149612882, Idle2=1150842221, Idle3=1159573567, Walk=1151231493, Run=1150967949, Jump=1150944216, Climb=1148811837, Fall=1148863382, Swim=1151204998, SwimIdle=1151221899, Weight=9, Weight2=1},
    Sneaky         = {Idle=1132473842, Idle2=1132477671, Idle3="None",     Walk=1132510133, Run=1132494274, Jump=1132489853, Climb=1132461372, Fall=1132469004, Swim=1132500520, SwimIdle=1132506407, Weight=9, Weight2=1},
    Cowboy         = {Idle=1014390418, Idle2=1014398616, Idle3=1159487651, Walk=1014421541, Run=1014401683, Jump=1014394726, Climb=1014380606, Fall=1014384571, Swim=1014406523, SwimIdle=1014411816, Weight=9, Weight2=1},
    Ghost          = {Idle=616006778,  Idle2=616008087,  Idle3=616008087,  Walk=616013216,  Run=616013216,  Jump=616008936,  Climb=0,          Fall=616005863,  Swim=616011509,  SwimIdle=616012453,  Weight=9, Weight2=1},
    ['Ghost 2']    = {Idle=1151221899, Idle2=1151221899, Idle3="None",     Walk=1151221899, Run=1151221899, Jump=1151221899, Climb=0,          Fall=1151221899, Swim=16738339158,SwimIdle=1151221899, Weight=9, Weight2=1},
    ['Mr. Toilet'] = {Idle=4417977954, Idle2=4417978624, Idle3=4441285342, Walk=2510202577, Run=4417979645, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
    Udzal          = {Idle=3303162274, Idle2=3303162549, Idle3=3710161342, Walk=3303162967, Run=3236836670, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
    ['Oinan Thickhoof']  = {Idle=657595757,Idle2=657568135,Idle3=885499184,Walk=2510202577,Run=3236836670,Jump=2510197830,Climb=2510192778,Fall=2510195892,Swim=2510199791,SwimIdle=2510201162,Weight=9,Weight2=1},
    Borock         = {Idle=3293641938, Idle2=3293642554, Idle3=3710131919, Walk=2510202577, Run=3236836670, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
    ['Blocky Mech']      = {Idle=4417977954,Idle2=4417978624,Idle3=4441285342,Walk=2510202577,Run=4417979645,Jump=2510197830,Climb=2510192778,Fall=2510195892,Swim=2510199791,SwimIdle=2510201162,Weight=9,Weight2=1},
    ['Stylized Female']  = {Idle=4708191566,Idle2=4708192150,Idle3=121221,Walk=4708193840,Run=4708192705,Jump=4708188025,Climb=4708184253,Fall=4708186162,Swim=4708189360,SwimIdle=4708190607,Weight=9,Weight2=1},
    R15            = {Idle=4211217646, Idle2=4211218409, Idle3="None",     Walk=4211223236, Run=4211220381, Jump=4211219390, Climb=4211214992, Fall=4211216152, Swim=4211221314, SwimIdle=4374694239, Weight=9,Weight2=1},
    Mocap          = {Idle=913367814,  Idle2=913373430,  Idle3="None",     Walk=913402848,  Run=913376220,  Jump=913370268,  Climb=913362637,  Fall=913365531,  Swim=913384386,  SwimIdle=913389285,  Weight=9, Weight2=1},
    ['Wicked "Dancing Through Life"'] = {Idle=92849173543269,Idle2=132238900951109,Idle3=87867222929430,Walk=73718308412641,Run=135515454877967,Jump=78508480717326,Climb=129447497744818,Fall=78147885297412,Swim=110657013921774,SwimIdle=129183123083281,Weight=9,Weight2=1},
    Unboxed        = {Idle=98281136301627,Idle2=138183121662404,Idle3=133117300343405,Walk=90478085024465,Run=134824450619865,Jump=121454505477205,Climb=121145883950231,Fall=94788218468396,Swim=105962919001086,SwimIdle=129126268464847,Weight=9,Weight2=1},
    ['Wicked Popular']   = {Idle=118832222982049,Idle2=76049494037641,Idle3=138255200176080,Walk=92072849924640,Run=72301599441680,Jump=104325245285198,Climb=131326830509784,Fall=121152442762481,Swim=99384245425157,SwimIdle=113199415118199,Weight=9,Weight2=1},
}

local currentAnimationData = nil
local currentMixedAnims = nil
local MixedAnim = {
    Idle     = nil,
    Run      = nil,
    Jump     = nil,
    Walk     = nil,
    Climb    = nil,
    Fall     = nil,
    Swim     = nil,
    SwimIdle = nil,
}

local function ApplySingleType(animType, animId, animName)
    MixedAnim[animType] = animId
    currentMixedAnims = {}
    for k, v in pairs(MixedAnim) do
        if v then
            currentMixedAnims[k] = v
        end
    end
    
    SendWebhook(animName, animType, false)
    
    local character = LP.Character
    if not character then return end
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    
    pcall(function()
        animate.Disabled = true
        task.wait(0.05)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do v:Stop() end
        end
        local slots = {
            Idle     = function()
                if animate:FindFirstChild("idle") then
                    if animate.idle:FindFirstChild("Animation1") then 
                        animate.idle.Animation1.AnimationId = URL .. animId 
                        animate.idle.Animation1.Weight.Value = "9"
                    end
                    if animate.idle:FindFirstChild("Animation2") then 
                        animate.idle.Animation2.AnimationId = URL .. animId 
                        animate.idle.Animation2.Weight.Value = "1"
                    end
                end
            end,
            Walk     = function()
                if animate:FindFirstChild("walk") then
                    local a = animate.walk:FindFirstChildOfClass("Animation")
                    if a then a.AnimationId = URL .. animId end
                end
            end,
            Run      = function()
                if animate:FindFirstChild("run") then
                    local a = animate.run:FindFirstChildOfClass("Animation")
                    if a then a.AnimationId = URL .. animId end
                end
            end,
            Jump     = function()
                if animate:FindFirstChild("jump") then
                    local a = animate.jump:FindFirstChildOfClass("Animation")
                    if a then a.AnimationId = URL .. animId end
                end
            end,
            Climb    = function()
                if animate:FindFirstChild("climb") then
                    local a = animate.climb:FindFirstChildOfClass("Animation")
                    if a then a.AnimationId = URL .. animId end
                end
            end,
            Fall     = function()
                if animate:FindFirstChild("fall") then
                    local a = animate.fall:FindFirstChildOfClass("Animation")
                    if a then a.AnimationId = URL .. animId end
                end
            end,
            Swim     = function()
                if animate:FindFirstChild("swim") then
                    local a = animate.swim:FindFirstChildOfClass("Animation")
                    if a then a.AnimationId = URL .. animId end
                end
            end,
            SwimIdle = function()
                if animate:FindFirstChild("swimidle") then
                    local a = animate.swimidle:FindFirstChildOfClass("Animation")
                    if a then a.AnimationId = URL .. animId end
                end
            end,
        }
        if slots[animType] then slots[animType]() end
        task.wait(0.05)
        animate.Disabled = false
    end)
end

local function RestoreMixedAnims(character)
    if not currentMixedAnims or not character then return end
    
    local animate = character:FindFirstChild("Animate")
    if not animate then return end
    
    pcall(function()
        animate.Disabled = true
        task.wait(0.05)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do v:Stop() end
        end
        
        for animType, animId in pairs(currentMixedAnims) do
            if animId then
                local slots = {
                    Idle     = function()
                        if animate:FindFirstChild("idle") then
                            if animate.idle:FindFirstChild("Animation1") then 
                                animate.idle.Animation1.AnimationId = URL .. animId 
                                animate.idle.Animation1.Weight.Value = "9"
                            end
                            if animate.idle:FindFirstChild("Animation2") then 
                                animate.idle.Animation2.AnimationId = URL .. animId 
                                animate.idle.Animation2.Weight.Value = "1"
                            end
                        end
                    end,
                    Walk     = function()
                        if animate:FindFirstChild("walk") then
                            local a = animate.walk:FindFirstChildOfClass("Animation")
                            if a then a.AnimationId = URL .. animId end
                        end
                    end,
                    Run      = function()
                        if animate:FindFirstChild("run") then
                            local a = animate.run:FindFirstChildOfClass("Animation")
                            if a then a.AnimationId = URL .. animId end
                        end
                    end,
                    Jump     = function()
                        if animate:FindFirstChild("jump") then
                            local a = animate.jump:FindFirstChildOfClass("Animation")
                            if a then a.AnimationId = URL .. animId end
                        end
                    end,
                    Climb    = function()
                        if animate:FindFirstChild("climb") then
                            local a = animate.climb:FindFirstChildOfClass("Animation")
                            if a then a.AnimationId = URL .. animId end
                        end
                    end,
                    Fall     = function()
                        if animate:FindFirstChild("fall") then
                            local a = animate.fall:FindFirstChildOfClass("Animation")
                            if a then a.AnimationId = URL .. animId end
                        end
                    end,
                    Swim     = function()
                        if animate:FindFirstChild("swim") then
                            local a = animate.swim:FindFirstChildOfClass("Animation")
                            if a then a.AnimationId = URL .. animId end
                        end
                    end,
                    SwimIdle = function()
                        if animate:FindFirstChild("swimidle") then
                            local a = animate.swimidle:FindFirstChildOfClass("Animation")
                            if a then a.AnimationId = URL .. animId end
                        end
                    end,
                }
                if slots[animType] then slots[animType]() end
            end
        end
        
        task.wait(0.05)
        animate.Disabled = false
    end)
end

local function ApplyAnimationToCharacter(character, data)
    if not character or not data then return false end
    local animate = character:FindFirstChild("Animate")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not animate or not humanoid then return false end
    pcall(function()
        animate.Disabled = true
        task.wait(0.05)
        for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
            v:Stop()
        end
        if animate:FindFirstChild("idle") then
            if animate.idle:FindFirstChild("Animation1") then
                animate.idle.Animation1.AnimationId = URL .. data.Idle
                animate.idle.Animation1.Weight.Value = tostring(data.Weight or 9)
            end
            if animate.idle:FindFirstChild("Animation2") then
                animate.idle.Animation2.AnimationId = URL .. data.Idle2
                animate.idle.Animation2.Weight.Value = tostring(data.Weight2 or 1)
            end
        end
        if data.Idle3 and data.Idle3 ~= "None" and animate:FindFirstChild("pose") then
            local poseAnim = animate.pose:FindFirstChildOfClass("Animation")
            if poseAnim then poseAnim.AnimationId = URL .. data.Idle3 end
        end
        if animate:FindFirstChild("walk") then
            local a = animate.walk:FindFirstChildOfClass("Animation")
            if a then a.AnimationId = URL .. data.Walk end
        end
        if animate:FindFirstChild("run") then
            local a = animate.run:FindFirstChildOfClass("Animation")
            if a then a.AnimationId = URL .. data.Run end
        end
        if animate:FindFirstChild("jump") then
            local a = animate.jump:FindFirstChildOfClass("Animation")
            if a then a.AnimationId = URL .. data.Jump end
        end
        if animate:FindFirstChild("climb") then
            local a = animate.climb:FindFirstChildOfClass("Animation")
            if a then a.AnimationId = URL .. data.Climb end
        end
        if animate:FindFirstChild("fall") then
            local a = animate.fall:FindFirstChildOfClass("Animation")
            if a then a.AnimationId = URL .. data.Fall end
        end
        if animate:FindFirstChild("swim") then
            local a = animate.swim:FindFirstChildOfClass("Animation")
            if a then a.AnimationId = URL .. data.Swim end
        end
        if animate:FindFirstChild("swimidle") then
            local a = animate.swimidle:FindFirstChildOfClass("Animation")
            if a then a.AnimationId = URL .. data.SwimIdle end
        end
        task.wait(0.05)
        animate.Disabled = false
    end)
    return true
end

local function SetAnimation(animData, animName)
    currentAnimationData = animData
    currentMixedAnims = nil
    SendWebhook(animName, "Pack Completo", true)
    local character = LP.Character
    if character then
        ApplyAnimationToCharacter(character, animData)
    end
end

local function SetupAntiReset()
    LP.CharacterAdded:Connect(function(newChar)
        repeat task.wait() until newChar and newChar.Parent and newChar:FindFirstChild("Humanoid")
        task.wait(0.15)
        
        if currentAnimationData then
            ApplyAnimationToCharacter(newChar, currentAnimationData)
            task.wait(0.3)
            if currentAnimationData then ApplyAnimationToCharacter(newChar, currentAnimationData) end
            task.wait(0.6)
            if currentAnimationData then ApplyAnimationToCharacter(newChar, currentAnimationData) end
        elseif currentMixedAnims then
            RestoreMixedAnims(newChar)
            task.wait(0.3)
            if currentMixedAnims then RestoreMixedAnims(newChar) end
            task.wait(0.6)
            if currentMixedAnims then RestoreMixedAnims(newChar) end
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local TOPBAR_H = 36
local SEARCH_H = 28
local PAD      = 6
local GAP      = 4

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0.4, 0, 0.48, 0)
Main.Position = UDim2.new(0.05, 0, 0.25, 0)
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, TOPBAR_H)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 18)
Title.Position = UDim2.new(0, 10, 0, 4)
Title.BackgroundTransparency = 1
Title.Text = "✦ Animaciones"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Author = Instance.new("TextLabel")
Author.Size = UDim2.new(1, -80, 0, 10)
Author.Position = UDim2.new(0, 10, 0, 22)
Author.BackgroundTransparency = 1
Author.Text = "by kontumama"
Author.TextColor3 = Color3.fromRGB(130, 130, 160)
Author.TextSize = 9
Author.Font = Enum.Font.Gotham
Author.TextXAlignment = Enum.TextXAlignment.Left
Author.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 26)
MinBtn.Position = UDim2.new(1, -62, 0.5, -13)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
MinBtn.TextSize = 13
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, 0, 0, 28)
TabBar.Position = UDim2.new(0, 0, 0, TOPBAR_H)
TabBar.BackgroundColor3 = Color3.fromRGB(245, 246, 252)
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local TabPack = Instance.new("TextButton")
TabPack.Size = UDim2.new(0.5, -2, 1, -4)
TabPack.Position = UDim2.new(0, 2, 0, 2)
TabPack.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
TabPack.BorderSizePixel = 0
TabPack.Text = "🎭 Pack Completo"
TabPack.TextColor3 = Color3.fromRGB(255,255,255)
TabPack.TextSize = 11
TabPack.Font = Enum.Font.GothamBold
TabPack.Parent = TabBar
Instance.new("UICorner", TabPack).CornerRadius = UDim.new(0, 7)

local TabMix = Instance.new("TextButton")
TabMix.Size = UDim2.new(0.5, -2, 1, -4)
TabMix.Position = UDim2.new(0.5, 0, 0, 2)
TabMix.BackgroundColor3 = Color3.fromRGB(220, 222, 235)
TabMix.BorderSizePixel = 0
TabMix.Text = "🔀 Por Tipo"
TabMix.TextColor3 = Color3.fromRGB(50, 50, 70)
TabMix.TextSize = 11
TabMix.Font = Enum.Font.GothamBold
TabMix.Parent = TabBar
Instance.new("UICorner", TabMix).CornerRadius = UDim.new(0, 7)

local ContentOffset = TOPBAR_H + 28

local PagePack = Instance.new("Frame")
PagePack.Size = UDim2.new(1, 0, 1, -ContentOffset)
PagePack.Position = UDim2.new(0, 0, 0, ContentOffset)
PagePack.BackgroundTransparency = 1
PagePack.Parent = Main

local PageMix = Instance.new("Frame")
PageMix.Size = UDim2.new(1, 0, 1, -ContentOffset)
PageMix.Position = UDim2.new(0, 0, 0, ContentOffset)
PageMix.BackgroundTransparency = 1
PageMix.Visible = false
PageMix.Parent = Main

local function SetTab(tab)
    if tab == "pack" then
        PagePack.Visible = true
        PageMix.Visible = false
        TabPack.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
        TabPack.TextColor3 = Color3.fromRGB(255,255,255)
        TabMix.BackgroundColor3 = Color3.fromRGB(220, 222, 235)
        TabMix.TextColor3 = Color3.fromRGB(50,50,70)
    else
        PagePack.Visible = false
        PageMix.Visible = true
        TabMix.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
        TabMix.TextColor3 = Color3.fromRGB(255,255,255)
        TabPack.BackgroundColor3 = Color3.fromRGB(220, 222, 235)
        TabPack.TextColor3 = Color3.fromRGB(50,50,70)
    end
end

TabPack.MouseButton1Click:Connect(function() SetTab("pack") end)
TabMix.MouseButton1Click:Connect(function() SetTab("mix") end)

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -PAD*2, 0, SEARCH_H)
SearchBox.Position = UDim2.new(0, PAD, 0, PAD)
SearchBox.BackgroundColor3 = Color3.fromRGB(240, 242, 250)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "🔍 Buscar animación..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(35, 45, 70)
SearchBox.PlaceholderColor3 = Color3.fromRGB(160, 170, 195)
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = PagePack
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 10)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -PAD*2, 1, -(SEARCH_H + PAD*2 + GAP))
Scroll.Position = UDim2.new(0, PAD, 0, SEARCH_H + PAD + GAP)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = PagePack

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = Scroll

local allButtons = {}

local function LoadAnimations()
    for _, v in pairs(Scroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    allButtons = {}
    local names = {}
    for k in pairs(Animations) do table.insert(names, k) end
    table.sort(names, function(a,b) return a:lower() < b:lower() end)
    for _, name in ipairs(names) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Color3.fromRGB(245, 247, 255)
        btn.BorderSizePixel = 0
        btn.Text = "🎭 " .. name
        btn.TextColor3 = Color3.fromRGB(30, 40, 65)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = Scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 10)
        pad.Parent = btn
        btn.MouseButton1Click:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(100, 120, 220)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            task.delay(0.15, function()
                if btn and btn.Parent then
                    btn.BackgroundColor3 = Color3.fromRGB(245, 247, 255)
                    btn.TextColor3 = Color3.fromRGB(30, 40, 65)
                end
            end)
            SetAnimation(Animations[name], name)
        end)
        table.insert(allButtons, {btn=btn, label=name:lower()})
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower()
    for _, item in ipairs(allButtons) do
        item.btn.Visible = (q == "") or (item.label:find(q, 1, true) ~= nil)
    end
end)

local AnimTypes = {
    {key="Idle",     label="😐 Idle (parado)"},
    {key="Walk",     label="🚶 Caminar"},
    {key="Run",      label="🏃 Correr"},
    {key="Jump",     label="🦘 Saltar"},
    {key="Fall",     label="🪂 Caer"},
    {key="Climb",    label="🧗 Escalar"},
    {key="Swim",     label="🏊 Nadar"},
    {key="SwimIdle", label="🌊 Nadar (parado)"},
}

local MixScroll = Instance.new("ScrollingFrame")
MixScroll.Size = UDim2.new(1, -PAD*2, 1, -PAD*2)
MixScroll.Position = UDim2.new(0, PAD, 0, PAD)
MixScroll.BackgroundTransparency = 1
MixScroll.BorderSizePixel = 0
MixScroll.ScrollBarThickness = 4
MixScroll.CanvasSize = UDim2.new(0,0,0,0)
MixScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
MixScroll.Parent = PageMix

local MixLayout = Instance.new("UIListLayout")
MixLayout.SortOrder = Enum.SortOrder.LayoutOrder
MixLayout.Padding = UDim.new(0, 8)
MixLayout.Parent = MixScroll

for _, atype in ipairs(AnimTypes) do
    local Block = Instance.new("Frame")
    Block.Size = UDim2.new(1, 0, 0, 0)
    Block.AutomaticSize = Enum.AutomaticSize.Y
    Block.BackgroundColor3 = Color3.fromRGB(245, 247, 255)
    Block.BorderSizePixel = 0
    Block.Parent = MixScroll
    Instance.new("UICorner", Block).CornerRadius = UDim.new(0, 8)
    
    local BLayout = Instance.new("UIListLayout")
    BLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BLayout.Padding = UDim.new(0, 2)
    BLayout.Parent = Block
    
    local BPad = Instance.new("UIPadding")
    BPad.PaddingTop = UDim.new(0, 4)
    BPad.PaddingBottom = UDim.new(0, 4)
    BPad.PaddingLeft = UDim.new(0, 6)
    BPad.PaddingRight = UDim.new(0, 6)
    BPad.Parent = Block
    
    local TypeLabel = Instance.new("TextLabel")
    TypeLabel.Size = UDim2.new(1, 0, 0, 20)
    TypeLabel.BackgroundTransparency = 1
    TypeLabel.Text = atype.label
    TypeLabel.TextColor3 = Color3.fromRGB(30, 30, 50)
    TypeLabel.TextSize = 12
    TypeLabel.Font = Enum.Font.GothamBold
    TypeLabel.TextXAlignment = Enum.TextXAlignment.Left
    TypeLabel.Parent = Block
    
    local SelectBtn = Instance.new("TextButton")
    SelectBtn.Size = UDim2.new(1, 0, 0, 26)
    SelectBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
    SelectBtn.BorderSizePixel = 0
    SelectBtn.Text = "— Sin selección —"
    SelectBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
    SelectBtn.TextSize = 11
    SelectBtn.Font = Enum.Font.Gotham
    SelectBtn.TextXAlignment = Enum.TextXAlignment.Center
    SelectBtn.Parent = Block
    Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 7)
    
    local SubScroll = Instance.new("ScrollingFrame")
    SubScroll.Size = UDim2.new(1, 0, 0, 0)
    SubScroll.BackgroundColor3 = Color3.fromRGB(235, 237, 250)
    SubScroll.BorderSizePixel = 0
    SubScroll.ScrollBarThickness = 3
    SubScroll.CanvasSize = UDim2.new(0,0,0,0)
    SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SubScroll.Visible = false
    SubScroll.Parent = Block
    Instance.new("UICorner", SubScroll).CornerRadius = UDim.new(0, 6)
    
    local SubLayout = Instance.new("UIListLayout")
    SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SubLayout.Padding = UDim.new(0, 2)
    SubLayout.Parent = SubScroll
    
    local sortedNames = {}
    for k in pairs(Animations) do table.insert(sortedNames, k) end
    table.sort(sortedNames, function(a,b) return a:lower() < b:lower() end)
    
    for _, animName in ipairs(sortedNames) do
        local animData = Animations[animName]
        local animId = animData[atype.key]
        if animId and animId ~= "None" and animId ~= 0 then
            local opt = Instance.new("TextButton")
            opt.Size = UDim2.new(1, 0, 0, 24)
            opt.BackgroundTransparency = 1
            opt.Text = "  " .. animName
            opt.TextColor3 = Color3.fromRGB(40, 50, 80)
            opt.TextSize = 11
            opt.Font = Enum.Font.Gotham
            opt.TextXAlignment = Enum.TextXAlignment.Left
            opt.Parent = SubScroll
            
            local capturedKey  = atype.key
            local capturedName = animName
            local capturedId   = animId
            
            opt.MouseButton1Click:Connect(function()
                MixedAnim[capturedKey] = capturedId
                SelectBtn.Text = capturedName
                SelectBtn.TextColor3 = Color3.fromRGB(120, 200, 120)
                SubScroll.Visible = false
                SubScroll.Size = UDim2.new(1, 0, 0, 0)
                ApplySingleType(capturedKey, capturedId, capturedName)
            end)
        end
    end
    
    local open = false
    SelectBtn.MouseButton1Click:Connect(function()
        open = not open
        SubScroll.Visible = open
        if open then
            SubScroll.Size = UDim2.new(1, 0, 0, math.min(120, SubLayout.AbsoluteContentSize.Y + 4))
        else
            SubScroll.Size = UDim2.new(1, 0, 0, 0)
        end
    end)
end

local minimized = false
local fullSize  = Main.Size
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    PagePack.Visible = not minimized and (not PageMix.Visible)
    PageMix.Visible  = not minimized and PageMix.Visible
    TabBar.Visible   = not minimized
    if minimized then
        Main.Size = UDim2.new(0, 120, 0, TOPBAR_H)
        Main.Position = UDim2.new(0.5, -60, 0.93, -18)
        MinBtn.Text = "▲"
    else
        Main.Size = fullSize
        Main.Position = UDim2.new(0.05, 0, 0.25, 0)
        MinBtn.Text = "—"
        SetTab("pack")
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

SetupAntiReset()
LoadAnimations()
SetTab("pack")

SendOpenMenuWebhook()