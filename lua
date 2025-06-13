local Library = loadstring(gameHttpGet(httpspastebin.comraw4iG9SKxs))()
local Window = LibraryWindow()

-- Game Configuration
local games = {
    [863266079] = Chdr3y.xyzar2,
}
getgenv().ConfigFolder = games[game.GameId] or Chdr3y.xyzuniversal

-- Combat Page
local combat = WindowPage({ Name = Combat })
local headExpander = combatSection({ Name = Head Expander })
local silentAim = combatSection({ Name = Silent Aim, Side = Right })
local spinningCrosshair = combatSection({ Name = Spinning CrossHair, Side = Left })
local gunMods = combatSection({ Name = Gun Mods, Side = Left })
local meleeSpeed = combatSection({ Name = Melee Speed, Side = Right })

local legit = WindowPage({ Name = Visuals })
local Test = legitSection({ Name = Visuals })
local worldSection = legitSection({ Name = world, Side = Right })
local SelfChamsSection = legitSection({ Name = Local Player, Side = Right })
local OtherEspSection = legitSection({ Name = OtherEsp, Side = Left })
local ClothUnlock = legitSection({ Name = Cloth Unlocker, Side = Right })


-- Settings for ESP (Visual Settings)
local Settings = {
    BoxEnabled = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    OutlineColor = Color3.fromRGB(0, 0, 0),
    NameEnabled = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    NameFont = 2,
    NameSize = 13,
    DistanceEnabled = false,
    DistanceColor = Color3.fromRGB(255, 255, 255),
    DistanceFont = 2,
    DistanceSize = 13,
    HealthBarEnabled = false,
    MaxDistance = 1000,
}

-- Box Drawing Toggle & Colorpicker
TestToggle({
    Name = Box,
    Flag = Box,
    Default = false,
    Callback = function(val) Settings.BoxEnabled = val end
})Colorpicker({
    Default = Settings.BoxColor,
    Flag = BoxColor,
    Callback = function(col) Settings.BoxColor = col end
})

-- Health Bar Toggle
TestToggle({
    Name = Health,
    Flag = HealthToggle,
    Default = false,
    Callback = function(val) Settings.HealthBarEnabled = val end
})

-- Name ESP Toggle & Colorpicker
TestToggle({
    Name = Name Player,
    Flag = NameESP,
    Default = false,
    Callback = function(val) Settings.NameEnabled = val end
})Colorpicker({
    Default = Settings.NameColor,
    Flag = NameColor,
    Callback = function(color) Settings.NameColor = color end
})

-- Distance ESP Toggle & Colorpicker
TestToggle({
    Name = Distance,
    Flag = DistanceESP,
    Default = false,
    Callback = function(val) Settings.DistanceEnabled = val end
})Colorpicker({
    Default = Settings.DistanceColor,
    Flag = DistanceColor,
    Callback = function(color) Settings.DistanceColor = color end
})

-- Table to store player highlights
local playerHighlights = {}

-- Function to create a highlight for a player
local function createHighlight(player)
    if playerHighlights[player] then return end -- Already highlighted

    local char = player.Character
    if not char then return end

    local highlight = Instance.new(Highlight)
    highlight.Name = PlayerHighlightESP
    highlight.Adornee = char
    highlight.FillColor = HighlightColor
    highlight.OutlineColor = HighlightColor
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = workspace

    playerHighlights[player] = highlight
end

-- Function to remove a player's highlight
local function removeHighlight(player)
    if playerHighlights[player] then
        playerHighlights[player]Destroy()
        playerHighlights[player] = nil
    end
end

-- Update highlight on player addedremoved
game.Players.PlayerAddedConnect(function(player)
    player.CharacterAddedConnect(function()
        if HighlightsEnabled then
            createHighlight(player)
        end
    end)
end)

game.Players.PlayerRemovingConnect(function(player)
    removeHighlight(player)
end)

-- Toggle Highlight ESP with colorpicker
TestToggle({
    Name = Highlight,
    Flag = Highlight,
    Default = false,
    Callback = function(val)
        HighlightsEnabled = val
        for _, player in pairs(game.PlayersGetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                if val then
                    createHighlight(player)
                else
                    removeHighlight(player)
                end
            end
        end
    end
})Colorpicker({
    Default = HighlightColor,
    Flag = HighlightColor,
    Callback = function(color)
        HighlightColor = color
        -- Update color for all active highlights
        for _, highlight in pairs(playerHighlights) do
            highlight.FillColor = HighlightColor
            highlight.OutlineColor = HighlightColor
        end
    end
})

local Players = gameGetService(Players)
local RunService = gameGetService(RunService)
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- We'll store connection and lines for cleanup
local ESPConnections = {}

-- Modified DrawESP to return cleanup function (disconnect + remove lines)
local function DrawESP(plr)
    repeat wait() until plr.Character and plr.CharacterFindFirstChild(Humanoid)
    
    local limbs = {}
    local isR15 = (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15)

    local function DrawLine()
        local line = Drawing.new(Line)
        line.Visible = false
        line.From = Vector2.new(0, 0)
        line.To = Vector2.new(1, 1)
        line.Color = Color3.fromRGB(255, 0, 0)
        line.Thickness = 1
        line.Transparency = 1
        return line
    end

    if isR15 then
        limbs = {
            Head_UpperTorso = DrawLine(),
            UpperTorso_LowerTorso = DrawLine(),
            UpperTorso_LeftUpperArm = DrawLine(),
            LeftUpperArm_LeftLowerArm = DrawLine(),
            LeftLowerArm_LeftHand = DrawLine(),
            UpperTorso_RightUpperArm = DrawLine(),
            RightUpperArm_RightLowerArm = DrawLine(),
            RightLowerArm_RightHand = DrawLine(),
            LowerTorso_LeftUpperLeg = DrawLine(),
            LeftUpperLeg_LeftLowerLeg = DrawLine(),
            LeftLowerLeg_LeftFoot = DrawLine(),
            LowerTorso_RightUpperLeg = DrawLine(),
            RightUpperLeg_RightLowerLeg = DrawLine(),
            RightLowerLeg_RightFoot = DrawLine(),
        }
    else
        limbs = {
            Head_Spine = DrawLine(),
            Spine = DrawLine(),
            LeftArm = DrawLine(),
            LeftArm_UpperTorso = DrawLine(),
            RightArm = DrawLine(),
            RightArm_UpperTorso = DrawLine(),
            LeftLeg = DrawLine(),
            LeftLeg_LowerTorso = DrawLine(),
            RightLeg = DrawLine(),
            RightLeg_LowerTorso = DrawLine()
        }
    end

    local function SetVisibility(state)
        for _, line in pairs(limbs) do
            line.Visible = state
        end
    end

    local function RemoveLines()
        for _, line in pairs(limbs) do
            lineRemove()
        end
    end

    local connection
    if isR15 then
        connection = RunService.RenderSteppedConnect(function()
            local char = plr.Character
            if char and charFindFirstChild(Humanoid) and charFindFirstChild(HumanoidRootPart) and char.Humanoid.Health  0 then
                local _, onScreen = CameraWorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local H = CameraWorldToViewportPoint(char.Head.Position)
                    local UT = CameraWorldToViewportPoint(char.UpperTorso.Position)
                    local LT = CameraWorldToViewportPoint(char.LowerTorso.Position)
                    local LUA = CameraWorldToViewportPoint(char.LeftUpperArm.Position)
                    local LLA = CameraWorldToViewportPoint(char.LeftLowerArm.Position)
                    local LH = CameraWorldToViewportPoint(char.LeftHand.Position)
                    local RUA = CameraWorldToViewportPoint(char.RightUpperArm.Position)
                    local RLA = CameraWorldToViewportPoint(char.RightLowerArm.Position)
                    local RH = CameraWorldToViewportPoint(char.RightHand.Position)
                    local LUL = CameraWorldToViewportPoint(char.LeftUpperLeg.Position)
                    local LLL = CameraWorldToViewportPoint(char.LeftLowerLeg.Position)
                    local LF = CameraWorldToViewportPoint(char.LeftFoot.Position)
                    local RUL = CameraWorldToViewportPoint(char.RightUpperLeg.Position)
                    local RLL = CameraWorldToViewportPoint(char.RightLowerLeg.Position)
                    local RF = CameraWorldToViewportPoint(char.RightFoot.Position)

                    limbs.Head_UpperTorso.From = Vector2.new(H.X, H.Y)
                    limbs.Head_UpperTorso.To = Vector2.new(UT.X, UT.Y)

                    limbs.UpperTorso_LowerTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_LowerTorso.To = Vector2.new(LT.X, LT.Y)

                    limbs.UpperTorso_LeftUpperArm.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_LeftUpperArm.To = Vector2.new(LUA.X, LUA.Y)

                    limbs.LeftUpperArm_LeftLowerArm.From = Vector2.new(LUA.X, LUA.Y)
                    limbs.LeftUpperArm_LeftLowerArm.To = Vector2.new(LLA.X, LLA.Y)

                    limbs.LeftLowerArm_LeftHand.From = Vector2.new(LLA.X, LLA.Y)
                    limbs.LeftLowerArm_LeftHand.To = Vector2.new(LH.X, LH.Y)

                    limbs.UpperTorso_RightUpperArm.From = Vector2.new(UT.X, UT.Y)
                    limbs.UpperTorso_RightUpperArm.To = Vector2.new(RUA.X, RUA.Y)

                    limbs.RightUpperArm_RightLowerArm.From = Vector2.new(RUA.X, RUA.Y)
                    limbs.RightUpperArm_RightLowerArm.To = Vector2.new(RLA.X, RLA.Y)

                    limbs.RightLowerArm_RightHand.From = Vector2.new(RLA.X, RLA.Y)
                    limbs.RightLowerArm_RightHand.To = Vector2.new(RH.X, RH.Y)

                    limbs.LowerTorso_LeftUpperLeg.From = Vector2.new(LT.X, LT.Y)
                    limbs.LowerTorso_LeftUpperLeg.To = Vector2.new(LUL.X, LUL.Y)

                    limbs.LeftUpperLeg_LeftLowerLeg.From = Vector2.new(LUL.X, LUL.Y)
                    limbs.LeftUpperLeg_LeftLowerLeg.To = Vector2.new(LLL.X, LLL.Y)

                    limbs.LeftLowerLeg_LeftFoot.From = Vector2.new(LLL.X, LLL.Y)
                    limbs.LeftLowerLeg_LeftFoot.To = Vector2.new(LF.X, LF.Y)

                    limbs.LowerTorso_RightUpperLeg.From = Vector2.new(LT.X, LT.Y)
                    limbs.LowerTorso_RightUpperLeg.To = Vector2.new(RUL.X, RUL.Y)

                    limbs.RightUpperLeg_RightLowerLeg.From = Vector2.new(RUL.X, RUL.Y)
                    limbs.RightUpperLeg_RightLowerLeg.To = Vector2.new(RLL.X, RLL.Y)

                    limbs.RightLowerLeg_RightFoot.From = Vector2.new(RLL.X, RLL.Y)
                    limbs.RightLowerLeg_RightFoot.To = Vector2.new(RF.X, RF.Y)

                    if not limbs.Head_UpperTorso.Visible then
                        SetVisibility(true)
                    end
                else
                    if limbs.Head_UpperTorso.Visible then
                        SetVisibility(false)
                    end
                end
            else
                if limbs.Head_UpperTorso.Visible then
                    SetVisibility(false)
                end
                if not PlayersFindFirstChild(plr.Name) then
                    RemoveLines()
                    connectionDisconnect()
                end
            end
        end)
    else
        connection = RunService.RenderSteppedConnect(function()
            local char = plr.Character
            if char and charFindFirstChild(Humanoid) and charFindFirstChild(HumanoidRootPart) and char.Humanoid.Health  0 then
                local _, onScreen = CameraWorldToViewportPoint(char.HumanoidRootPart.Position)
                if onScreen then
                    local H = CameraWorldToViewportPoint(char.Head.Position)
                    local torso = char.Torso or char.UpperTorso
                    local T_Height = torso.Size.Y2 - 0.2
                    local UT = CameraWorldToViewportPoint((torso.CFrame  CFrame.new(0, T_Height, 0)).p)
                    local LT = CameraWorldToViewportPoint((torso.CFrame  CFrame.new(0, -T_Height, 0)).p)

                    local LA = char[Left Arm]
                    local LA_Height = LA.Size.Y2 - 0.2
                    local LUA = CameraWorldToViewportPoint((LA.CFrame  CFrame.new(0, LA_Height, 0)).p)
                    local LLA = CameraWorldToViewportPoint((LA.CFrame  CFrame.new(0, -LA_Height, 0)).p)

                    local RA = char[Right Arm]
                    local RA_Height = RA.Size.Y2 - 0.2
                    local RUA = CameraWorldToViewportPoint((RA.CFrame  CFrame.new(0, RA_Height, 0)).p)
                    local RLA = CameraWorldToViewportPoint((RA.CFrame  CFrame.new(0, -RA_Height, 0)).p)

                    local LL = char[Left Leg]
                    local LL_Height = LL.Size.Y2 - 0.2
                    local LUL = CameraWorldToViewportPoint((LL.CFrame  CFrame.new(0, LL_Height, 0)).p)
                    local LLL = CameraWorldToViewportPoint((LL.CFrame  CFrame.new(0, -LL_Height, 0)).p)

                    local RL = char[Right Leg]
                    local RL_Height = RL.Size.Y2 - 0.2
                    local RUL = CameraWorldToViewportPoint((RL.CFrame  CFrame.new(0, RL_Height, 0)).p)
                    local RLL = CameraWorldToViewportPoint((RL.CFrame  CFrame.new(0, -RL_Height, 0)).p)

                    limbs.Head_Spine.From = Vector2.new(H.X, H.Y)
                    limbs.Head_Spine.To = Vector2.new(UT.X, UT.Y)

                    limbs.Spine.From = Vector2.new(UT.X, UT.Y)
                    limbs.Spine.To = Vector2.new(LT.X, LT.Y)

                    limbs.LeftArm.From = Vector2.new(LUA.X, LUA.Y)
                    limbs.LeftArm.To = Vector2.new(LLA.X, LLA.Y)

                    limbs.LeftArm_UpperTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.LeftArm_UpperTorso.To = Vector2.new(LUA.X, LUA.Y)

                    limbs.RightArm.From = Vector2.new(RUA.X, RUA.Y)
                    limbs.RightArm.To = Vector2.new(RLA.X, RLA.Y)

                    limbs.RightArm_UpperTorso.From = Vector2.new(UT.X, UT.Y)
                    limbs.RightArm_UpperTorso.To = Vector2.new(RUA.X, RUA.Y)

                    limbs.LeftLeg.From = Vector2.new(LUL.X, LUL.Y)
                    limbs.LeftLeg.To = Vector2.new(LLL.X, LLL.Y)

                    limbs.LeftLeg_LowerTorso.From = Vector2.new(LT.X, LT.Y)
                    limbs.LeftLeg_LowerTorso.To = Vector2.new(LUL.X, LUL.Y)

                    limbs.RightLeg.From = Vector2.new(RUL.X, RUL.Y)
                    limbs.RightLeg.To = Vector2.new(RLL.X, RLL.Y)

                    limbs.RightLeg_LowerTorso.From = Vector2.new(LT.X, LT.Y)
                    limbs.RightLeg_LowerTorso.To = Vector2.new(RUL.X, RUL.Y)

                    if not limbs.Head_Spine.Visible then
                        SetVisibility(true)
                    end
                else
                    if limbs.Head_Spine.Visible then
                        SetVisibility(false)
                    end
                end
            else
                if limbs.Head_Spine.Visible then
                    SetVisibility(false)
                end
                if not PlayersFindFirstChild(plr.Name) then
                    RemoveLines()
                    connectionDisconnect()
                end
            end
        end)
    end

    -- Return a cleanup function
    return function()
        connectionDisconnect()
        RemoveLines()
    end
end

local skeletonColor = Color3.fromRGB(255, 255, 255)

TestToggle({
    Name = Skeleton,
    Flag = SkeletonToggle,
    Default = false,
    Callback = function(enabled)
        skeletonEnabled = enabled

        if enabled then
            for _, player in pairs(PlayersGetPlayers()) do
                if player ~= LocalPlayer then
                    if not ESPConnections[player.Name] then
                        ESPConnections[player.Name] = DrawESP(player, skeletonColor)
                    end
                end
            end

            if not PlayerAddedConn then
                PlayerAddedConn = Players.PlayerAddedConnect(function(newPlayer)
                    if newPlayer ~= LocalPlayer and skeletonEnabled then
                        if not ESPConnections[newPlayer.Name] then
                            ESPConnections[newPlayer.Name] = DrawESP(newPlayer, skeletonColor)
                        end
                    end
                end)
            end

            if not PlayerRemovingConn then
                PlayerRemovingConn = Players.PlayerRemovingConnect(function(leavingPlayer)
                    if ESPConnections[leavingPlayer.Name] then
                        ESPConnections[leavingPlayer.Name]()
                        ESPConnections[leavingPlayer.Name] = nil
                    end
                end)
            end
        else
            for playerName, cleanupFunc in pairs(ESPConnections) do
                cleanupFunc()
                ESPConnections[playerName] = nil
            end

            if PlayerAddedConn then
                PlayerAddedConnDisconnect()
                PlayerAddedConn = nil
            end

            if PlayerRemovingConn then
                PlayerRemovingConnDisconnect()
                PlayerRemovingConn = nil
            end
        end
    end
})

-- Max Distance Slider
TestSlider({
    Name = Max Distance,
    Flag = MaxDistance,
    Min = 1000,
    Max = 10000,
    Default = Settings.MaxDistance,
    Rounding = 0,
    Callback = function(value)
        Settings.MaxDistance = value
        
    end
})

-- Map ESP Button
TestButton({
    Name = Map Esp,
    Callback = function()
        local Interface
        for _, v in pairs(getgc(true)) do
            if typeof(v) == table and rawget(v, Get) and typeof(v.Get) == function then
                local ok, map = pcall(function() return vGet(Map) end)
                if ok and type(map) == table and rawget(map, EnableGodview) then
                    Interface = v
                    break
                end
            end
        end
        if Interface then
            InterfaceGet(Map)EnableGodview()
            
        else
            
        end
    end
})

-- Box ESP Drawing for other players
local boxDrawings = {}
local outlineDrawings = {}

local function createBoxESP(player)
    if boxDrawings[player] or outlineDrawings[player] then return end -- prevent duplicates

    local box = Drawing.new(Square)
    local outline = Drawing.new(Square)

    box.Thickness, box.ZIndex, box.Visible = 1, 2, false
    outline.Thickness, outline.ZIndex, outline.Visible = 1, 1, false

    boxDrawings[player] = box
    outlineDrawings[player] = outline

    gameGetService(RunService).RenderSteppedConnect(function()
        local char = player.Character
        if not char then
            box.Visible = false
            outline.Visible = false
            return
        end
        local hrp = charFindFirstChild(HumanoidRootPart)
        local hum = charFindFirstChild(Humanoid)
        if hrp and hum then
            local camera = workspace.CurrentCamera
            local charPos = hrp.Position
            local cameraPos = camera.CFrame.Position
            local distance = (cameraPos - charPos).Magnitude
            local pos, onScreen = cameraWorldToViewportPoint(charPos)

            if Settings.BoxEnabled and hum.Health  0 and onScreen and distance = Settings.MaxDistance then
                local scale = 1  (pos.Z  math.tan(math.rad(camera.FieldOfView  2))  2)  100
                local w, h = 40  scale, 60  scale
                local x, y = pos.X - w  2, pos.Y - h  2

                box.Size = Vector2.new(w, h)
                box.Position = Vector2.new(x, y)
                box.Color = Settings.BoxColor
                box.Visible = true

                outline.Size = Vector2.new(w + 2, h + 2)
                outline.Position = Vector2.new(x - 1, y - 1)
                outline.Color = Settings.OutlineColor
                outline.Visible = true
            else
                box.Visible = false
                outline.Visible = false
            end
        else
            box.Visible = false
            outline.Visible = false
        end
    end)
end

-- Health Bar ESP
local function CreateHealthESP(player)
    local segments, bars = 10, {}
    local outline = Drawing.new(Square)
    outline.Thickness = 1
    outline.Color = Color3.new(0, 0, 0)
    outline.Filled = false
    outline.Visible = false

    for i = 1, segments do
        local seg = Drawing.new(Square)
        seg.Filled = true
        seg.Visible = false
        table.insert(bars, seg)
    end

    gameGetService(RunService).RenderSteppedConnect(function()
        if not player.Character or not player.CharacterFindFirstChild(HumanoidRootPart) then
            for _, s in ipairs(bars) do s.Visible = false end
            outline.Visible = false
            return
        end

        local hum = player.CharacterFindFirstChild(Humanoid)
        if not hum or not Settings.HealthBarEnabled then
            for _, s in ipairs(bars) do s.Visible = false end
            outline.Visible = false
            return
        end

        local camera = workspace.CurrentCamera
        local pos, vis = cameraWorldToViewportPoint(player.Character.HumanoidRootPart.Position)
        local distance = (camera.CFrame.Position - player.Character.HumanoidRootPart.Position).Magnitude

        if vis and hum.Health  0 and distance = Settings.MaxDistance then
            local scale = 1  (pos.Z  math.tan(math.rad(camera.FieldOfView  2))  2)  100
            local h = math.floor(60  scale)
            local x, y = math.floor(pos.X - 20  scale - 8), math.floor(pos.Y - h  2)

            outline.Size = Vector2.new(4, h)
            outline.Position = Vector2.new(x - 1, y - 1)
            outline.Visible = true

            local hpPerc = math.clamp(hum.Health  hum.MaxHealth, 0, 1)
            local barFill = math.floor(h  hpPerc)
            local segH = barFill  segments

            for i = 1, segments do
                local seg = bars[i]
                local t = i  segments
                local r = t  0.5 and 42 + (255 - 42)  (t  0.5) or 255 + (232 - 255)  ((t - 0.5)  0.5)
                local g = t  0.5 and 227 + (218 - 227)  (t  0.5) or 218 + (27 - 218)  ((t - 0.5)  0.5)
                seg.Color = Color3.fromRGB(r, g, 5)
                seg.Size = Vector2.new(2, segH)
                seg.Position = Vector2.new(x, y + h - segH  (segments - i + 1))
                seg.Visible = true
            end
        else
            for _, s in ipairs(bars) do s.Visible = false end
            outline.Visible = false
        end
    end)
end

-- Name ESP
local function CreateNameESP(player)
    local name = Drawing.new(Text)
    name.Center, name.Outline, name.Visible = true, true, false
    name.Font, name.Size, name.Color = Settings.NameFont, Settings.NameSize, Settings.NameColor

    gameGetService(RunService).RenderSteppedConnect(function()
        if Settings.NameEnabled and player.Character and player.CharacterFindFirstChild(Head) then
            local camera = workspace.CurrentCamera
            local pos, visible = cameraWorldToViewportPoint(player.Character.Head.Position + Vector3.new(0, 2, 0))
            local distance = (camera.CFrame.Position - player.Character.Head.Position).Magnitude
            if visible and distance = Settings.MaxDistance then
                name.Text = player.Name
                name.Position = Vector2.new(pos.X, pos.Y)
                name.Visible = true
            else
                name.Visible = false
            end
        else
            name.Visible = false
        end
    end)
end

-- Distance ESP
local function CreateDistanceESP(player)
    local dist = Drawing.new(Text)
    dist.Center, dist.Outline, dist.Visible = true, true, false
    dist.Font, dist.Size, dist.Color = Settings.DistanceFont, Settings.DistanceSize, Settings.DistanceColor

    gameGetService(RunService).RenderSteppedConnect(function()
        if player.Character and player.CharacterFindFirstChild(HumanoidRootPart) and Settings.DistanceEnabled then
            local camera = workspace.CurrentCamera
            local pos, visible = cameraWorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local distanceValue = (camera.CFrame.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if visible and distanceValue = Settings.MaxDistance then
                dist.Text = tostring(math.floor(distanceValue)) .. m
                dist.Position = Vector2.new(pos.X, pos.Y + 30)
                dist.Visible = true
            else
                dist.Visible = false
            end
        else
            dist.Visible = false
        end
    end)
end

-- Function to create full ESP for a player
local function CreateFullESP(player)
    if player == game.Players.LocalPlayer then return end
    createBoxESP(player)
    CreateHealthESP(player)
    CreateNameESP(player)
    CreateDistanceESP(player)
end

-- Initialize ESP for all existing players
for _, player in ipairs(game.PlayersGetPlayers()) do
    CreateFullESP(player)
    player.CharacterAddedConnect(function()
        wait(1)
        CreateFullESP(player)
    end)
end

-- Initialize ESP for players who join after the script runs
game.Players.PlayerAddedConnect(function(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAddedConnect(function()
            wait(1)
            CreateFullESP(player)
        end)
        -- Also create ESP immediately if they already have a character
        if player.Character then
            wait(1)
            CreateFullESP(player)
        end
    end
end)

local ReplicatedFirst = cloneref(game:GetService("ReplicatedFirst"))
local Bullets = require(ReplicatedFirst:WaitForChild("Framework")).Libraries.Bullets

local GetFireImpulse = getupvalue(Bullets.Fire, 6)


local noRecoilEnabled = false
local recoilScale = 0.1


setupvalue(Bullets.Fire, 6, function(...)
    local impulse = {GetFireImpulse(...)}

    if noRecoilEnabled then
        for i = 1, #impulse do
            impulse[i] = impulse[i] * recoilScale
        end
    end

    return unpack(impulse)
end)

gunMods:Toggle({
    Name = "No Recoil",
    Flag = "No Recoil",
    Callback = function(state)
        noRecoilEnabled = state
    end
})

gunMods:Slider({
    Name = "Recoil Control",
    Flag = "Recoil",
    Min = 0,
    Max = 100,
    Default = 100,
    Decimals = 1,
    Callback = function(value)
        recoilScale = value / 100
    end
})

-- Silent Aim Settings
local SilentAimEnabled = false
local MaxDistance = 1000 -- default for silent aim distance

-- Silent Aim Logic
local function get_closest_player()
    local closest_distance = MaxDistance
    local closest_player = nil

    for _, player in pairs(game.PlayersGetPlayers()) do
        local character = player.Character
        if player == game.Players.LocalPlayer or not character or not characterFindFirstChild(Head) then
            continue
        end

        local pos, on_screen = workspace.CurrentCameraWorldToViewportPoint(character.Head.Position)
        if not on_screen then
            continue
        end

        local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X  2, workspace.CurrentCamera.ViewportSize.Y  2)
        local distance = (center - Vector2.new(pos.X, pos.Y)).Magnitude

        if distance  closest_distance then
            closest_player = character
            closest_distance = distance
        end
    end
    return closest_player
end

-- Silent Aim function (hook example)
local old_fire
local function silent_aim()
    local replicated_first = gameGetService(ReplicatedFirst)
    local framework
    -- Safely try to get framework
    for _, v in pairs(getgc(true)) do
        if typeof(v) == table and rawget(v, Fire) and typeof(v.Fire) == function then
            framework = v
            break
        end
    end

    if not framework then
        warn(Silent Aim framework not found)
        return
    end

    old_fire = hookfunction(framework.Fire, function(weapon_data, character_data, _, gun_data, origin, direction, ...)
        if SilentAimEnabled then
            local closest_character = get_closest_player()
            if closest_character and closest_characterFindFirstChild(Head) then
                direction = (closest_character.Head.Position - origin).Unit
            end
        end
        return old_fire(weapon_data, character_data, _, gun_data, origin, direction, ...)
    end)
end

silent_aim()

silentAimToggle({
    Name = Silent Aim,
    Flag = SilentAim,
    Default = false,
    Callback = function(value)
        SilentAimEnabled = value
    end
})

silentAimSlider({
    Name = Max Distance,
    Flag = SilentAimDistance,
    Min = 100,
    Max = 5000,
    Default = MaxDistance,
    Callback = function(value)
        MaxDistance = value
    end
})

meleeSpeedToggle({
    Name = Melee Speed,
    Flag = MeleeSpeedToggle,
    Default = false,
    Callback = function(state) MeleeSpeedEnabled = state end
})

meleeSpeedSlider({
    Name = Melee Speed,
    Flag = MeleeSpeedSlider,
    Min = 1,
    Max = 5,
    Default = MeleeSpeedValue,
    Callback = function(val) MeleeSpeedValue = val end
})

task.spawn(function()
    local Framework = require(gameGetService(ReplicatedFirst).Framework)
    local Animators = Framework.require(Classes, Animators)
    local oldAnim; oldAnim = hookfunction(Animators.PlayAnimation, function(self, anim, ...)
        local track = oldAnim(self, anim, ...)
        if MeleeSpeedEnabled and tostring(anim)match(Melees) then
            selfSetAnimationSpeed(anim, MeleeSpeedValue)
        end
        return track
    end)
end)

local SelfChamsEnabled = false
local SelfChamsColor = Color3.fromRGB(0, 255, 0)

local function applyChams(char)
    task.wait(0)
    for _, part in ipairs(charGetDescendants()) do
        if partIsA(BasePart) and part.Name ~= HumanoidRootPart then
            part.Color = SelfChamsColor
            part.Material = Enum.Material.ForceField
        end
    end
end

local Vis = SelfChamsSectionToggle({
    Name = Self Chams,
    Flag = SelfChams,
    Default = false,
    Callback = function(state)
        SelfChamsEnabled = state
        if LocalPlayer.Character then applyChams(LocalPlayer.Character) end
    end
})

VisColorpicker({
    Name = Self Chams Color,
    Flag = ChamsColor,
    Default = SelfChamsColor,
    Callback = function(color)
        SelfChamsColor = color
        if SelfChamsEnabled and LocalPlayer.Character then
            applyChams(LocalPlayer.Character)
        end
    end
})

LocalPlayer.CharacterAddedConnect(function(char)
    if SelfChamsEnabled then applyChams(char) end
end)

LocalPlayer.CharacterAddedConnect(function(char)
    if SelfChamsEnabled then
        applyChams(char)
    end
end)

local RunService = gameGetService(RunService)
local UserInputService = gameGetService(UserInputService)

local fovCircle = Drawing.new(Circle)
local fovColor = Color3.fromRGB(0, 255, 0) -- Default FOV color
local fovThickness = 2 -- Default thickness
local fovRadius = 100
local fovEnabled = true
local fovFilled = false -- Default not filled

fovCircle.Color = fovColor
fovCircle.Thickness = fovThickness
fovCircle.Filled = fovFilled
fovCircle.Transparency = 1
fovCircle.Visible = true
fovCircle.Radius = fovRadius

silentAimToggle({
    Name = Show FOV,
    Flag = ShowFOV,
    Default = true,
    Callback = function(state)
        fovEnabled = state
        fovCircle.Visible = state
    end
})

silentAimToggle({
    Name = Filled,
    Flag = FOVFilled,
    Default = false,
    Callback = function(state)
        fovFilled = state
        fovCircle.Filled = fovFilled
    end
})

silentAimSlider({
    Name = Size,
    Flag = FOVSize,
    Min = 50,
    Max = 300,
    Default = 120,
    Callback = function(value)
        fovRadius = value
        fovCircle.Radius = fovRadius
    end
})

silentAimSlider({
    Name = Thickness,
    Flag = FOVThickness,
    Min = 1,
    Max = 5,
    Default = fovThickness,
    Callback = function(value)
        fovThickness = value
        fovCircle.Thickness = fovThickness
    end
})

silentAimColorpicker({
    Name = Color,
    Flag = FOVColor,
    Default = fovColor,
    Callback = function(color)
        fovColor = color
        fovCircle.Color = fovColor
    end
})

RunService.RenderSteppedConnect(function()
    local mousePos = UserInputServiceGetMouseLocation()
    fovCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    fovCircle.Visible = fovEnabled
end)

local Players = gameGetService(Players)
local RunService = gameGetService(RunService)

-- Settings
local headExpanderEnabled = false
local headSizeValue = 1.15
local headTransparencyValue = 0

-- Apply head changes
local function ApplyHeadChanges(player)
    if player == Players.LocalPlayer then return end

    local function apply()
        local char = player.Character
        if not char then return end
        local head = charFindFirstChild(Head)
        if head and headIsA(Part) then
            head.Size = Vector3.new(headSizeValue, headSizeValue, headSizeValue)
            head.Transparency = headTransparencyValue
        end
    end

    apply()

    player.CharacterAddedConnect(function()
        task.wait(1)
        if headExpanderEnabled then
            apply()
        end
    end)
end

local ReplicatedStorage = gameGetService(ReplicatedStorage)
local ReplicatedFirst = gameGetService(ReplicatedFirst)

local Mannequin = workspaceFindFirstChild(Mannequin)

local HeadExpandEnabled = false
local HeadSizeValue = 1.15

headExpanderToggle({
    Name = Head Expander,
    Flag = AR2HeadExpander,
    Default = false,
    Callback = function(enabled)
        headExpanderEnabled = enabled

        if enabled then
            for _, player in ipairs(PlayersGetPlayers()) do
                ApplyHeadChanges(player)
            end
            Players.PlayerAddedConnect(ApplyHeadChanges)
        end
    end
})


headExpanderSlider({
    Name = Head Size,
    Flag = AR2HeadExpanderSize,
    Min = 1,
    Max = 50,
    Default = headSizeValue,
    Decimals = 1,
    Suffix = x,
    Callback = function(value)
        headSizeValue = value
        if headExpanderEnabled then
            for _, player in ipairs(PlayersGetPlayers()) do
                ApplyHeadChanges(player)
            end
        end
    end
})

-- Transparency Slider
headExpanderSlider({
    Name = Head Transparency,
    Flag = AR2HeadTransparency,
    Min = 0,
    Max = 0.5,
    Default = headTransparencyValue,
    Decimals = 2,
    Suffix = ,
    Callback = function(value)
        headTransparencyValue = value
        if headExpanderEnabled then
            for _, player in ipairs(PlayersGetPlayers()) do
                ApplyHeadChanges(player)
            end
        end
    end
})

local OldIndex, OldNamecall = nil, nil
OldIndex = hookmetamethod(game, __index, function(Self, Index)
    if Window.Flags[AR2HeadExpander] and tostring(Self) == Head and Index == Size then
        return Vector3.one  1.15
    end

    return OldIndex(Self, Index)
end)

local RunService = gameGetService(RunService)

-- Configurable values
local CrosshairEnabled = false
local SpinSpeed = 300 -- degrees per second
local CrosshairRadius = 50
local LineCount = 4
local LineLength = 30

-- Drawing Setup
local lines = {}
local currentAngle = 0

-- Create initial lines
local function CreateCrosshairLines()
    for _, line in ipairs(lines) do
        lineRemove()
    end
    lines = {}
    for i = 1, LineCount do
        local line = Drawing.new(Line)
        line.Thickness = 2
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Transparency = 1
        line.Visible = false
        table.insert(lines, line)
    end
end

CreateCrosshairLines()

-- Render loop
RunService.RenderSteppedConnect(function(dt)
    if not CrosshairEnabled then
        for _, line in ipairs(lines) do
            line.Visible = false
        end
        return
    end

    local camera = workspace.CurrentCamera
    local centerX, centerY = camera.ViewportSize.X  2, camera.ViewportSize.Y  2
    local anglePerLine = 360  LineCount

    currentAngle = (currentAngle + SpinSpeed  dt) % 360

    for i, line in ipairs(lines) do
        local angle = math.rad(currentAngle + anglePerLine  (i - 1))
        local startX = centerX + math.cos(angle)  CrosshairRadius
        local startY = centerY + math.sin(angle)  CrosshairRadius
        local endX = centerX + math.cos(angle)  (CrosshairRadius + LineLength)
        local endY = centerY + math.sin(angle)  (CrosshairRadius + LineLength)

        line.From = Vector2.new(startX, startY)
        line.To = Vector2.new(endX, endY)
        line.Visible = true
    end
end)

-- UI Toggles and Sliders
spinningCrosshairToggle({
    Name = Spinning Crosshair,
    Flag = SpinningCrosshair,
    Default = false,
    Callback = function(val)
        CrosshairEnabled = val
        
    end
})

spinningCrosshairSlider({
    Name = Spin Speed,
    Flag = SpinSpeed,
    Min = 0,
    Max = 1000,
    Default = 300,
    Increment = 1,
    Callback = function(value)
        SpinSpeed = value
        
    end
})

spinningCrosshairSlider({
    Name = Radius,
    Flag = CrosshairRadius,
    Min = 0,
    Max = 300,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        CrosshairRadius = value
        
    end
})

spinningCrosshairSlider({
    Name = Lines,
    Flag = LineCount,
    Min = 1,
    Max = 12,
    Default = 4,
    Increment = 1,
    Callback = function(value)
        LineCount = value
        CreateCrosshairLines()
        
    end
})

-- Made by Blissful#4992

local DistFromCenter = 80
local TriangleHeight = 16
local TriangleWidth = 16
local TriangleFilled = true
local TriangleTransparency = 0
local TriangleThickness = 1
local TriangleColor = Color3.fromRGB(255, 255, 255)
local AntiAliasing = false

local Players = gameGetService(Players)
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = gameGetService(RunService)

local V3 = Vector3.new
local V2 = Vector2.new
local CF = CFrame.new
local COS = math.cos
local SIN = math.sin
local RAD = math.rad
local DRAWING = Drawing.new
local CWRAP = coroutine.wrap
local ROUND = math.round

local activeArrows = {} -- Store arrows and connections
local arrowsEnabled = false

-- Get relative vector from player to target position (XZ plane)
local function GetRelative(pos, char)
    if not char then return V2(0,0) end

    local rootP = char.PrimaryPart.Position
    local camP = Camera.CFrame.Position
    local relative = CF(V3(rootP.X, camP.Y, rootP.Z), camP)PointToObjectSpace(pos)

    return V2(relative.X, relative.Z)
end

-- Converts a relative position to screen center offset
local function RelativeToCenter(v)
    return Camera.ViewportSize2 - v
end

-- Rotate vector v by angle a (degrees)
local function RotateVect(v, a)
    a = RAD(a)
    local x = v.x  COS(a) - v.y  SIN(a)
    local y = v.x  SIN(a) + v.y  COS(a)

    return V2(x, y)
end

-- Create a triangle Drawing object with given color
local function DrawTriangle(color)
    local triangle = DRAWING(Triangle)
    triangle.Visible = false
    triangle.Color = color
    triangle.Filled = TriangleFilled
    triangle.Thickness = TriangleThickness
    triangle.Transparency = 1 - TriangleTransparency
    return triangle
end

-- Optionally rounds vector coordinates for anti-aliasing
local function AntiA(v)
    if not AntiAliasing then return v end
    return V2(ROUND(v.x), ROUND(v.y))
end

-- Show arrow pointing towards a player when offscreen
local function ShowArrow(PLAYER)
    if not arrowsEnabled then return end -- Do nothing if toggle off

    local Arrow = DrawTriangle(TriangleColor)
    local connection

    connection = RunService.RenderSteppedConnect(function()
        if not arrowsEnabled then
            -- Clean up if toggle is off
            ArrowRemove()
            connectionDisconnect()
            activeArrows[PLAYER] = nil
            return
        end

        if PLAYER and PLAYER.Character then
            local CHAR = PLAYER.Character
            local HUM = CHARFindFirstChildOfClass(Humanoid)

            if HUM and CHAR.PrimaryPart and HUM.Health  0 then
                local _, visible = CameraWorldToViewportPoint(CHAR.PrimaryPart.Position)
                if visible == false then
                    local rel = GetRelative(CHAR.PrimaryPart.Position, Player.Character)
                    if rel.Magnitude == 0 then -- Prevent error on zero length
                        Arrow.Visible = false
                        return
                    end
                    local direction = rel.Unit

                    local base  = direction  DistFromCenter
                    local sideLength = TriangleWidth  2
                    local baseL = base + RotateVect(direction, 90)  sideLength
                    local baseR = base + RotateVect(direction, -90)  sideLength
                    local tip = direction  (DistFromCenter + TriangleHeight)

                    Arrow.PointA = AntiA(RelativeToCenter(baseL))
                    Arrow.PointB = AntiA(RelativeToCenter(baseR))
                    Arrow.PointC = AntiA(RelativeToCenter(tip))

                    Arrow.Visible = true
                else
                    Arrow.Visible = false
                end
            else
                Arrow.Visible = false
            end
        else
            Arrow.Visible = false
            if not PLAYER or not PLAYER.Parent then
                ArrowRemove()
                connectionDisconnect()
                activeArrows[PLAYER] = nil
            end
        end
    end)

    activeArrows[PLAYER] = {Arrow = Arrow, Connection = connection}
end

-- Clear all arrows
local function ClearArrows()
    for player, data in pairs(activeArrows) do
        data.ArrowRemove()
        data.ConnectionDisconnect()
        activeArrows[player] = nil
    end
end

-- Initialize arrows for existing players
local function InitializeArrows()
    for _, v in pairs(PlayersGetPlayers()) do
        if v ~= Player then
            ShowArrow(v)
        end
    end
end

-- Player added handler
Players.PlayerAddedConnect(function(player)
    if player ~= Player and arrowsEnabled then
        ShowArrow(player)
    end
end)

-- Player removing handler
Players.PlayerRemovingConnect(function(player)
    if activeArrows[player] then
        activeArrows[player].ArrowRemove()
        activeArrows[player].ConnectionDisconnect()
        activeArrows[player] = nil
    end
end)

local Vis = OtherEspSectionToggle({
    Name = OffScreen Arrows,
    Flag = ArrowToggle,
    Default = false,
    Callback = function(enabled)
        arrowsEnabled = enabled
        if enabled then
            InitializeArrows()
        else
            ClearArrows()
        end
    end
})


local Players = gameGetService(Players)
local RunService = gameGetService(RunService)
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local radarRadius = 100    -- Radar circle radius in pixels
local radarSize = 150      -- Radar UI size
local radarCenter = Vector2.new(radarSize2 + 20, radarSize2 + 20) -- Radar position on screen

local radarCircle = Drawing.new(Circle)
local radarBorder = Drawing.new(Circle)
local playerDots = {}

-- Create radar UI function
local function createRadarUI()
    radarCircle.Position = radarCenter
    radarCircle.Radius = radarRadius
    radarCircle.Color = Color3.fromRGB(50, 50, 50)
    radarCircle.Filled = true
    radarCircle.Transparency = 0.3
    radarCircle.Visible = true
    radarCircle.Thickness = 1

    radarBorder.Position = radarCenter
    radarBorder.Radius = radarRadius
    radarBorder.Color = Color3.fromRGB(255, 255, 255)
    radarBorder.Filled = false
    radarBorder.Transparency = 0.6
    radarBorder.Visible = true
    radarBorder.Thickness = 2
end

-- Create a dot for a player
local function createDot()
    local dot = Drawing.new(Circle)
    dot.Radius = 4
    dot.Color = Color3.new(1, 0, 0) -- Red
    dot.Filled = true
    dot.Visible = true
    return dot
end

local radarEnabled = false
local updateConnection = nil

-- Update radar every frame
local function updateRadar()
    if not LocalPlayer.Character or not LocalPlayer.CharacterFindFirstChild(HumanoidRootPart) then return end
    local localHRP = LocalPlayer.Character.HumanoidRootPart
    local localPos = localHRP.Position
    local localLookVector = Camera.CFrame.LookVector

    local playerList = PlayersGetPlayers()

    -- Hide dots for players no longer in game or dead
    for player, dot in pairs(playerDots) do
        if not table.find(playerList, player) or not player.Character or not player.CharacterFindFirstChild(HumanoidRootPart) then
            dot.Visible = false
            playerDots[player] = nil
        end
    end

    for _, player in pairs(playerList) do
        if player ~= LocalPlayer and player.Character and player.CharacterFindFirstChild(HumanoidRootPart) then
            local targetHRP = player.Character.HumanoidRootPart
            local direction = targetHRP.Position - localPos

            local relativePos = Vector3.new(direction.X, 0, direction.Z)

            local angle = math.atan2(relativePos.Z, relativePos.X) - math.atan2(localLookVector.Z, localLookVector.X)

            local distance = relativePos.Magnitude
            local maxDistance = 2000
            if distance  maxDistance then
                distance = maxDistance
            end

            local radarX = radarCenter.X + math.cos(angle)  (distance  maxDistance)  radarRadius
            local radarY = radarCenter.Y + math.sin(angle)  (distance  maxDistance)  radarRadius

            local dot = playerDots[player]
            if not dot then
                dot = createDot()
                playerDots[player] = dot
            end
            dot.Position = Vector2.new(radarX, radarY)
            dot.Visible = true
        end
    end
end

-- Toggle function for radar
local Vis = OtherEspSectionToggle({
    Name = Radar,
    Flag = RadarToggle,
    Default = false,
    Callback = function(enabled)
        radarEnabled = enabled

        if enabled then
            -- Show radar UI
            createRadarUI()

            -- Connect update loop
            if not updateConnection then
                updateConnection = RunService.RenderSteppedConnect(updateRadar)
            end
        else
            -- Hide radar UI
            radarCircle.Visible = false
            radarBorder.Visible = false

            -- Hide all player dots and clear
            for _, dot in pairs(playerDots) do
                dot.Visible = false
            end
            playerDots = {}

            -- Disconnect update loop
            if updateConnection then
                updateConnectionDisconnect()
                updateConnection = nil
            end
        end
    end
})

local Lighting = gameGetService(Lighting)

local Socolo = {}

function applySkybox(theme)
    -- Reset to default textures initially
    Socolo.SkyboxBk = rbxassettexturesskysky512_bk.tex
    Socolo.SkyboxDn = rbxassettexturesskysky512_dn.tex
    Socolo.SkyboxFt = rbxassettexturesskysky512_ft.tex
    Socolo.SkyboxLf = rbxassettexturesskysky512_lf.tex
    Socolo.SkyboxRt = rbxassettexturesskysky512_rt.tex
    Socolo.SkyboxUp = rbxassettexturesskysky512_up.tex
    Socolo.StarCount = nil

    if theme == Sponge Bob then
        Socolo.SkyboxBk = httpwww.roblox.comassetid=7633178166
        Socolo.SkyboxDn = httpwww.roblox.comassetid=7633178166
        Socolo.SkyboxFt = httpwww.roblox.comassetid=7633178166
        Socolo.SkyboxLf = httpwww.roblox.comassetid=7633178166
        Socolo.SkyboxRt = httpwww.roblox.comassetid=7633178166
        Socolo.SkyboxUp = httpwww.roblox.comassetid=7633178166

    elseif theme == Vaporwave then
        Socolo.SkyboxBk = rbxassetid1417494030
        Socolo.SkyboxDn = rbxassetid1417494146
        Socolo.SkyboxFt = rbxassetid1417494253
        Socolo.SkyboxLf = rbxassetid1417494402
        Socolo.SkyboxRt = rbxassetid1417494499
        Socolo.SkyboxUp = rbxassetid1417494643

    elseif theme == Clouds then
        Socolo.SkyboxBk = rbxassetid570557514
        Socolo.SkyboxDn = rbxassetid570557775
        Socolo.SkyboxFt = rbxassetid570557559
        Socolo.SkyboxLf = rbxassetid570557620
        Socolo.SkyboxRt = rbxassetid570557672
        Socolo.SkyboxUp = rbxassetid570557727

    elseif theme == Twilight then
        Socolo.SkyboxBk = rbxassetid264908339
        Socolo.SkyboxDn = rbxassetid264907909
        Socolo.SkyboxFt = rbxassetid264909420
        Socolo.SkyboxLf = rbxassetid264909758
        Socolo.SkyboxRt = rbxassetid264908886
        Socolo.SkyboxUp = rbxassetid264907379

    elseif theme == Chill then
        Socolo.SkyboxBk = rbxassetid5084575798
        Socolo.SkyboxDn = rbxassetid5084575916
        Socolo.SkyboxFt = rbxassetid5103949679
        Socolo.SkyboxLf = rbxassetid5103948542
        Socolo.SkyboxRt = rbxassetid5103948784
        Socolo.SkyboxUp = rbxassetid5084576400

    elseif theme == Minecraft then
        Socolo.SkyboxBk = rbxassetid1876545003
        Socolo.SkyboxDn = rbxassetid1876544331
        Socolo.SkyboxFt = rbxassetid1876542941
        Socolo.SkyboxLf = rbxassetid1876543392
        Socolo.SkyboxRt = rbxassetid1876543764
        Socolo.SkyboxUp = rbxassetid1876544642

    elseif theme == Among Us then
        Socolo.SkyboxBk = rbxassetid5752463190
        Socolo.SkyboxDn = rbxassetid5872485020
        Socolo.SkyboxFt = rbxassetid5752463190
        Socolo.SkyboxLf = rbxassetid5752463190
        Socolo.SkyboxRt = rbxassetid5752463190
        Socolo.SkyboxUp = rbxassetid5752463190

    elseif theme == Redshift then
        Socolo.SkyboxBk = rbxassetid401664839
        Socolo.SkyboxDn = rbxassetid401664862
        Socolo.SkyboxFt = rbxassetid401664960
        Socolo.SkyboxLf = rbxassetid401664881
        Socolo.SkyboxRt = rbxassetid401664901
        Socolo.SkyboxUp = rbxassetid401664936

    elseif theme == Aesthetic Night then
        Socolo.SkyboxBk = rbxassetid1045964490
        Socolo.SkyboxDn = rbxassetid1045964368
        Socolo.SkyboxFt = rbxassetid1045964655
        Socolo.SkyboxLf = rbxassetid1045964655
        Socolo.SkyboxRt = rbxassetid1045964655
        Socolo.SkyboxUp = rbxassetid1045962969

    elseif theme == Neptune then
        Socolo.SkyboxBk = rbxassetid218955819
        Socolo.SkyboxDn = rbxassetid218953419
        Socolo.SkyboxFt = rbxassetid218954524
        Socolo.SkyboxLf = rbxassetid218958493
        Socolo.SkyboxRt = rbxassetid218957134
        Socolo.SkyboxUp = rbxassetid218950090
        Socolo.StarCount = 5000

    elseif theme == Galaxy then
        Socolo.SkyboxBk = httpwww.roblox.comassetid=159454299
        Socolo.SkyboxDn = httpwww.roblox.comassetid=159454296
        Socolo.SkyboxFt = httpwww.roblox.comassetid=159454293
        Socolo.SkyboxLf = httpwww.roblox.comassetid=159454286
        Socolo.SkyboxRt = httpwww.roblox.comassetid=159454300
        Socolo.SkyboxUp = httpwww.roblox.comassetid=159454288
        Socolo.StarCount = 5000
    end

    -- Remove existing Sky instance if present
    local oldSky = LightingFindFirstChildOfClass(Sky)
    if oldSky then
        oldSkyDestroy()
    end

    -- Create new Sky instance
    local sky = Instance.new(Sky)
    sky.Name = CustomSkybox
    sky.SkyboxBk = Socolo.SkyboxBk
    sky.SkyboxDn = Socolo.SkyboxDn
    sky.SkyboxFt = Socolo.SkyboxFt
    sky.SkyboxLf = Socolo.SkyboxLf
    sky.SkyboxRt = Socolo.SkyboxRt
    sky.SkyboxUp = Socolo.SkyboxUp
    sky.Parent = Lighting
end


local worldToggle = worldSectionToggle({
    Name = Custom Sky,
    Flag = CustomSkyEnabled,
    Callback = function(enabled)
        if enabled then
            local selectedTheme = Library.Flags[CustomSkyTheme] or Default
            applySkybox(selectedTheme)
        else
            applySkybox(Default) -- reset to default skybox
        end
    end
})

worldSectionToggle({
    Name = Full Bright,
    Flag = FullBrightToggle,
    Callback = function(enabled)
        _G.FullBrightEnabled = enabled
        if not _G.FullBrightExecuted then
            _G.FullBrightEnabled = enabled
            _G.FullBrightExecuted = true

            local Lighting = gameGetService(Lighting)

            _G.NormalLightingSettings = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient
            }

            local function watch(prop, expected, setFunc)
                LightingGetPropertyChangedSignal(prop)Connect(function()
                    if Lighting[prop] ~= expected and Lighting[prop] ~= _G.NormalLightingSettings[prop] then
                        _G.NormalLightingSettings[prop] = Lighting[prop]
                        if not _G.FullBrightEnabled then
                            repeat task.wait() until _G.FullBrightEnabled
                        end
                        setFunc()
                    end
                end)
            end

            watch(Brightness, 1, function() Lighting.Brightness = 1 end)
            watch(ClockTime, 12, function() Lighting.ClockTime = 12 end)
            watch(FogEnd, 786543, function() Lighting.FogEnd = 786543 end)
            watch(GlobalShadows, false, function() Lighting.GlobalShadows = false end)
            watch(Ambient, Color3.fromRGB(178, 178, 178), function() Lighting.Ambient = Color3.fromRGB(178, 178, 178) end)

            -- Set initial full bright
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 786543
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)

            -- Monitor for toggle changes
            local latest = true
            task.spawn(function()
                repeat task.wait() until _G.FullBrightEnabled
                while task.wait() do
                    if _G.FullBrightEnabled ~= latest then
                        if not _G.FullBrightEnabled then
                            for k, v in pairs(_G.NormalLightingSettings) do
                                Lighting[k] = v
                            end
                        else
                            Lighting.Brightness = 1
                            Lighting.ClockTime = 12
                            Lighting.FogEnd = 786543
                            Lighting.GlobalShadows = false
                            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
                        end
                        latest = _G.FullBrightEnabled
                    end
                end
            end)
        end
    end
})

worldSectionDropdown({
    Name = Select Sky,
    Flag = CustomSkyTheme,
    Options = {
        Default,
        Sponge Bob,
        Vaporwave,
        Clouds,
        Twilight,
        Chill,
        Minecraft,
        Among Us,
        Redshift,
        Aesthetic Night,
        Neptune,
        Galaxy,
    },
    Default = Default,
    Callback = function(value)
        if Library.Flags[CustomSkyEnabled] then
            applySkybox(value)
        end
    end
})

ClothUnlockButton({
    Name = Clothing Unlocker,  -- Button name
    Callback = function()
        -- Get the ReplicatedFirst and Framework services
        local ReplicatedFirst = gameGetService(ReplicatedFirst)
        local Framework = require(ReplicatedFirst.Framework)
        local Discovery = Framework.require(Libraries, Discovery)

        -- Hook the Discovery.IsDiscovered function to always return true (unlock all clothing)
        hookfunction(Discovery.IsDiscovered, function(...)
            return true  -- Always return true, meaning everything is discoveredunlocked
        end)

        
    end
})

LibraryLoadConfigTab(Window)
