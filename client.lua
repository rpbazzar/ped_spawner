-- ================================================================
-- PED SPAWNER (freecam) — AD-Placer style
--   /pedspawner -> freecam chalu
--   Mouse Scroll -> ped change | LMB -> spawn | RMB -> despawn
--   Arrow ←/→ -> rotate | WASD/QE + Mouse -> fly cam | Backspace -> exit
--   Har spawned ped ke sar ke uppar model naam.
--   Peds peds.lua me store hote hain (server) — restart/shared-proof.
-- ================================================================

local RES = GetCurrentResourceName()

-- Control IDs
local KEY_BACK        = 194   -- Backspace
local KEY_LMB         = 24    -- Left click (attack)
local KEY_RMB         = 25    -- Right click (aim)
local KEY_SHIFT       = 21
local KEY_W, KEY_S, KEY_A, KEY_D = 32, 33, 34, 35
local KEY_Q, KEY_E    = 44, 38
local KEY_ARROW_LEFT  = 174
local KEY_ARROW_RIGHT = 175
local SCROLL_UP       = 17    -- mouse wheel up
local SCROLL_DOWN     = 16    -- mouse wheel down

local active = false
local lastAim = nil   -- gizmo picker: aakhri aim ki vector4(x, y, z, heading)

-- Spawned peds ki list. Har entry: { model, x, y, z, w, ped }
local spawns = {}

-- ----------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------
local function norm(vec)
    local len = #vec
    if len == 0 then return vec end
    return vector3(vec.x / len, vec.y / len, vec.z / len)
end

-- Safe model load: crash ke bajaye timeout pe nil return karta hai.
-- (lib.requestModel timeout pe ERROR throw karta hai — isliye native use kiya)
local function loadModel(model)
    local hash = type(model) == 'number' and model or joaat(model)

    -- Model game/server me hai hi nahi -> turant skip (F8 me log)
    if not IsModelInCdimage(hash) or not IsModelValid(hash) then
        print(('^3[ped_spawner]^7 SKIP ^1invalid^7 ped: ^5%s^7 (hash %s) — game/server me nahi hai'):format(tostring(model), hash))
        return nil
    end

    RequestModel(hash)
    local maxTries = math.floor(Config.LoadTimeout / 10)
    local tries = 0
    while not HasModelLoaded(hash) do
        Wait(10)
        tries = tries + 1
        if tries > maxTries then
            -- cdimage me hai par stream nahi hua -> skip (F8 me log)
            print(('^3[ped_spawner]^7 SKIP ^1load-timeout^7 ped: ^5%s^7 (hash %s) — stream nahi hua'):format(tostring(model), hash))
            return nil
        end
    end
    return hash
end

local function drawTxt2D(x, y, scale, text)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 220)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

local function drawTxt3D(x, y, z, text)
    local onScreen, sx, sy = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    SetTextFont(4)
    SetTextScale(0.34, 0.34)
    SetTextColour(255, 255, 255, 230)
    SetTextCentre(true)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(sx, sy)
end

-- fly cam: WASD/QE + mouse look (controls is frame disabled hone chahiye)
local function handleFlyCam(cam)
    local camPos = GetCamCoord(cam)
    local camRot = GetCamRot(cam, 2)
    local mouseX = GetDisabledControlNormal(0, 1)
    local mouseY = GetDisabledControlNormal(0, 2)
    local rightVec, forwardVec = GetCamMatrix(cam)
    local upDir = vector3(0.0, 0.0, 1.0)
    local rightDir = norm(vector3(rightVec.x, rightVec.y, 0.0))
    local forwardDir = norm(vector3(forwardVec.x, forwardVec.y, 0.0))
    local ft = GetFrameTime()
    local didMove, didRot = false, false

    if IsDisabledControlPressed(0, KEY_W) then
        camPos = camPos + forwardDir * (Config.Cam.moveSpeed * ft); didMove = true
    elseif IsDisabledControlPressed(0, KEY_S) then
        camPos = camPos - forwardDir * (Config.Cam.moveSpeed * ft); didMove = true
    end
    if IsDisabledControlPressed(0, KEY_D) then
        camPos = camPos + rightDir * (Config.Cam.moveSpeed * ft); didMove = true
    elseif IsDisabledControlPressed(0, KEY_A) then
        camPos = camPos - rightDir * (Config.Cam.moveSpeed * ft); didMove = true
    end
    if IsDisabledControlPressed(0, KEY_Q) then
        camPos = camPos + upDir * (Config.Cam.climbSpeed * ft); didMove = true
    elseif IsDisabledControlPressed(0, KEY_E) then
        camPos = camPos - upDir * (Config.Cam.climbSpeed * ft); didMove = true
    end

    if mouseY ~= 0.0 then
        local pitch = math.max(-80.0, math.min(80.0, camRot.x - mouseY * Config.Cam.lookSpeed * ft))
        camRot = vector3(pitch, camRot.y, camRot.z)
        didRot = true
    end
    if mouseX ~= 0.0 then
        camRot = vector3(camRot.x, camRot.y, camRot.z - mouseX * Config.Cam.lookSpeed * ft)
        didRot = true
    end

    if didMove then
        SetCamCoord(cam, camPos)
        SetFocusPosAndVel(camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0)
    end
    if didRot then
        SetCamRot(cam, camRot, 2)
    end
end

-- ----------------------------------------------------------------
-- Persistence: peds.lua (server) via events.
--   Save/Remove/Clear -> server file me likhta hai.
--   Read -> client khud peds.lua padh leta hai (LoadResourceFile).
-- ----------------------------------------------------------------
local function readPedsFile()
    local content = LoadResourceFile(RES, 'peds.lua')
    if not content or content == '' then return {} end
    local chunk = load(content)
    if not chunk then
        print('^1[ped_spawner]^7 peds.lua Lua error — file check karo.')
        return {}
    end
    local ok, t = pcall(chunk)
    return (ok and type(t) == 'table') and t or {}
end

-- ----------------------------------------------------------------
-- Ek SOLID (real) ped banata hai — spawn ke liye
-- ----------------------------------------------------------------
local function createRealPed(model, x, y, z, heading)
    local hash = loadModel(model)
    if not hash then
        -- loadModel ne F8 me reason log kar diya — bas skip
        return nil
    end

    local ped = CreatePed(4, hash, x, y, z, heading, false, true)
    SetModelAsNoLongerNeeded(hash)

    -- CreatePed fail (0) = ped pool full. F8 me log karke skip (crash nahi)
    if not ped or ped == 0 or not DoesEntityExist(ped) then
        print(('^3[ped_spawner]^7 CreatePed ^1FAIL^7: %s — ped pool full ho sakta hai (manager thodi der me retry karega)'):format(tostring(model)))
        return nil
    end

    -- GROUND: stored z = asli ground/surface level. CreatePed(z) khud hi feet
    -- ko ground par sahi rakhta hai (model-independent) — koi min.z override
    -- NAHI (wo high-heel/female peds ko float kara raha tha). heading CreatePed
    -- se already set hai.
    SetEntityAsMissionEntity(ped, true, true)
    SetPedDefaultComponentVariation(ped)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCanRagdoll(ped, false)

    if Config.FreezeSpawnedPeds then FreezeEntityPosition(ped, true) end
    if Config.InvinciblePeds    then SetEntityInvincible(ped, true) end

    return ped
end

-- Real ped spawn + save. Local list me turant add + ped bana dete hain
-- (instant feel), aur server ko bolte hain peds.lua me likh de.
local function spawnPedAt(model, pos, heading)
    spawns[#spawns + 1] = {
        model = model, x = pos.x, y = pos.y, z = pos.z, w = heading,
        ped = createRealPed(model, pos.x, pos.y, pos.z, heading),
    }
    TriggerServerEvent('pedspawner:save', model, pos.x, pos.y, pos.z, heading + 0.0)
    lib.notify({ type = 'success', description = ('Spawned: %s'):format(model) })
end

-- Di gayi position ke paas wala spawned ped despawn karo.
-- STORED coords se dhoondhte hain (ped door hone par bhi delete ho jaye).
local function despawnNearest(refPos)
    local bestIdx, bestDist = nil, Config.DespawnRadius
    for i = 1, #spawns do
        local s = spawns[i]
        local d = #(refPos - vector3(s.x, s.y, s.z))
        if d < bestDist then bestDist, bestIdx = d, i end
    end

    if not bestIdx then
        lib.notify({ type = 'error', description = ('Paas koi ped nahi (%.0fm).'):format(Config.DespawnRadius) })
        return
    end

    local s = spawns[bestIdx]
    if s.ped and DoesEntityExist(s.ped) then DeletePed(s.ped) end
    table.remove(spawns, bestIdx)
    -- server se bhi peds.lua me se hata do (usi jagah ka nearest)
    TriggerServerEvent('pedspawner:remove', s.x, s.y, s.z, Config.DespawnRadius)
    lib.notify({ type = 'success', description = ('Despawned: %s'):format(s.model) })
end

-- ----------------------------------------------------------------
-- peds.lua se DATA load karo (peds abhi nahi bante — proximity
-- manager paas aane par khud spawn karega -> ped limit safe)
-- ----------------------------------------------------------------
local function loadSaved()
    -- pehle jo live peds hain unhe hatao (reload ke liye)
    for i = 1, #spawns do
        if spawns[i].ped and DoesEntityExist(spawns[i].ped) then DeletePed(spawns[i].ped) end
    end
    spawns = {}

    local data = readPedsFile()
    for i = 1, #data do
        local e = data[i]
        local c = e.coords
        if c then
            spawns[#spawns + 1] = { model = e.model, x = c.x, y = c.y, z = c.z, w = c.w, ped = nil }
        end
    end
    print(('^2[ped_spawner]^7 %d peds peds.lua se load hue — paas jaao to spawn honge.'):format(#spawns))
end

-- Server bolta hai (dusre player ne change kiya / manual reload) -> file dobara padho
RegisterNetEvent('pedspawner:reload', function()
    loadSaved()
end)

-- ----------------------------------------------------------------
-- PROXIMITY MANAGER (rp-peds style)
--   Paas (Config.DistanceSpawn) -> ped exist kare | Door -> despawn (free slot).
--   Data hamesha `spawns` me safe rehta hai. Isse GTA ka ped-limit kabhi
--   hit nahi hota aur peds kabhi permanently gayab bhi nahi hote.
-- ----------------------------------------------------------------
CreateThread(function()
    local spawnR2 = Config.DistanceSpawn * Config.DistanceSpawn
    while true do
        -- Freecam me camera pos, warna player pos (dono ko cover karta hai)
        local ref = GetFinalRenderedCamCoord()
        local nearest2 = math.huge

        for i = 1, #spawns do
            local s = spawns[i]
            local dx, dy, dz = ref.x - s.x, ref.y - s.y, ref.z - s.z
            local dist2 = dx * dx + dy * dy + dz * dz
            if dist2 < nearest2 then nearest2 = dist2 end

            local exists = s.ped and DoesEntityExist(s.ped)
            if dist2 < spawnR2 and not exists then
                s.ped = createRealPed(s.model, s.x, s.y, s.z, s.w)  -- paas -> spawn
            elseif dist2 >= spawnR2 and exists then
                DeletePed(s.ped); s.ped = nil                        -- door -> despawn
            end
        end

        -- Adaptive wait: paas ho to fast check, door ho to slow (performance)
        Wait(nearest2 < spawnR2 * 4 and 400 or 1500)
    end
end)

-- ----------------------------------------------------------------
-- Name tag thread — har spawned ped ke sar ke uppar naam (jab paas ho)
-- (freecam ke bahar bhi chalta rehta hai)
-- ----------------------------------------------------------------
CreateThread(function()
    while true do
        local sleep = 800
        local camPos = GetFinalRenderedCamCoord()
        for i = 1, #spawns do
            local s = spawns[i]
            if s.ped and DoesEntityExist(s.ped) then
                local pc = GetEntityCoords(s.ped)
                if #(camPos - pc) < Config.NameTagDistance then
                    sleep = 0
                    drawTxt3D(pc.x, pc.y, pc.z + 1.0, s.model)
                end
            end
        end
        Wait(sleep)
    end
end)

-- ----------------------------------------------------------------
-- Freecam placement mode
-- ----------------------------------------------------------------
local function start()
    if active then return end
    active = true

    CreateThread(function()
        local ped     = PlayerPedId()
        local pedPos  = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)

        local cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA',
            pedPos.x, pedPos.y, pedPos.z + 2.0, -35.0, 0.0, heading, 50.0, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, false)

        local index       = 1
        local ghost       = nil
        local ghostHash   = nil
        local ghostPos    = pedPos      -- ghost ka ORIGIN (display ke liye, +offset)
        local ghostGroundZ = pedPos.z   -- asli GROUND/surface z (yahi SAVE hota hai)

        -- Ghost (transparent preview) banao current index ke model ka.
        -- Return: true agar bana, false agar model invalid/load-fail (F8 me log ho chuka)
        local function buildGhost()
            if ghost and DoesEntityExist(ghost) then DeleteEntity(ghost) end
            ghost, ghostHash = nil, nil

            local hash = loadModel(Config.Peds[index])
            if not hash then return false end   -- loadModel ne F8 me log kar diya

            ghostHash = hash
            ghost = CreatePed(4, hash, ghostPos.x, ghostPos.y, ghostPos.z, heading, false, true)
            SetModelAsNoLongerNeeded(hash)
            SetEntityAlpha(ghost, 160, false)
            SetEntityCollision(ghost, false, false)
            FreezeEntityPosition(ghost, true)
            SetBlockingOfNonTemporaryEvents(ghost, true)
            SetEntityInvincible(ghost, true)
            return true
        end

        -- Scroll helper: dir = +1 (up) ya -1 (down).
        -- STRICT single-step — config.lua ke EXACT order me chalta hai (aage-piche
        -- jump nahi). Agar koi model invalid ho to F8 me log ho jata hai aur us
        -- ek step pe ghost nahi banta (order phir bhi config jaisa hi rehta hai).
        local function scrollTo(dir)
            local n = #Config.Peds
            index = (index - 1 + dir) % n + 1
            buildGhost()
        end

        -- Pehla ghost (index 1 = list ka pehla ped)
        buildGhost()

        while active do
            Wait(0)
            DisableAllControlActions(0)
            DisableAllControlActions(1)
            local ft = GetFrameTime()

            handleFlyCam(cam)

            -- Scroll -> ped model change (config.lua order me, strict single-step)
            if IsDisabledControlJustPressed(0, SCROLL_UP) then
                scrollTo(1)
            elseif IsDisabledControlJustPressed(0, SCROLL_DOWN) then
                scrollTo(-1)
            end

            -- Arrow ←/→ -> rotate. degrees-per-SECOND (frame-rate independent).
            -- SHIFT hold = super-slow (precise align ke liye).
            local degPerSec = IsDisabledControlPressed(0, KEY_SHIFT) and Config.RotateStepFine or Config.RotateStep
            local rotStep = degPerSec * ft
            if IsDisabledControlPressed(0, KEY_ARROW_RIGHT) then
                heading = (heading + rotStep) % 360.0
            elseif IsDisabledControlPressed(0, KEY_ARROW_LEFT) then
                heading = (heading - rotStep) % 360.0
            end

            -- Cam ke saamne raycast -> ghost surface par (feet ground par)
            if ghost then
                local _, camForward, _, camPosition = GetCamMatrix(cam)
                local ray = StartExpensiveSynchronousShapeTestLosProbe(
                    camPosition.x, camPosition.y, camPosition.z,
                    camPosition.x + camForward.x * 150.0,
                    camPosition.y + camForward.y * 150.0,
                    camPosition.z + camForward.z * 150.0,
                    -1, ghost, 4)
                local _, hit, endCoords = GetShapeTestResult(ray)
                if hit then
                    ghostGroundZ = endCoords.z   -- asli surface z -> yahi save hoga
                    -- Display: ped origin pelvis par -> model ke bottom (min.z) jitna
                    -- upar utha do taake feet surface par baithein (offset SAVE nahi hota)
                    local minDim = GetModelDimensions(ghostHash)
                    ghostPos = endCoords + vector3(0.0, 0.0, -minDim.z)
                    SetEntityCoordsNoOffset(ghost, ghostPos.x, ghostPos.y, ghostPos.z, false, false, false)
                end
                SetEntityHeading(ghost, heading)
            end

            -- Aim point (ground) — spawn/despawn aur gizmo picker isi ko use karte hain
            local curGround = vector3(ghostPos.x, ghostPos.y, ghostGroundZ)
            lastAim = vector4(curGround.x, curGround.y, curGround.z, heading)

            -- 3-AXIS GIZMO (white line ke saath align karne ke liye)
            --   RED = forward (heading) | GREEN = right (perpendicular) | BLUE = up
            local grad = math.rad(heading)
            local fx, fy = -math.sin(grad), math.cos(grad)   -- forward (red)
            local rx, ry =  math.cos(grad), math.sin(grad)   -- right (green)
            local gx, gy, gz = curGround.x, curGround.y, curGround.z + 0.05
            local glen = Config.GizmoLength
            DrawLine(gx, gy, gz, gx + fx*glen, gy + fy*glen, gz,       255, 40, 40, 255)  -- RED forward
            DrawLine(gx, gy, gz, gx + rx*glen, gy + ry*glen, gz,       40, 255, 40, 255)  -- GREEN right
            DrawLine(gx, gy, gz, gx,           gy,           gz + 2.5, 40, 40, 255, 255)  -- BLUE up

            -- Ghost ke sar ke uppar current model naam
            drawTxt3D(ghostPos.x, ghostPos.y, ghostPos.z + 1.05, Config.Peds[index])

            -- HUD
            drawTxt2D(0.015, 0.30, 0.42, ('~g~PED SPAWNER~s~  [%d/%d]  %s'):format(index, #Config.Peds, Config.Peds[index]))
            drawTxt2D(0.015, 0.34, 0.35, 'WASD/QE - Camera | Mouse - Look')
            drawTxt2D(0.015, 0.37, 0.35, '~y~SCROLL~s~ - Ped change | Arrow ←/→ - Rotate (RED axis ko white line pe lao)')
            drawTxt2D(0.015, 0.40, 0.35, ('~g~LEFT CLICK~s~ - Spawn | ~o~RIGHT CLICK~s~ - Despawn | ~b~%s~s~ - Coord print (F8)'):format(Config.CoordKey))
            drawTxt2D(0.015, 0.43, 0.35, ('~r~BACKSPACE~s~ - Exit   |   Spawned total: ~g~%d'):format(#spawns))

            -- LEFT CLICK -> spawn (GROUND z save hota hai, origin offset nahi)
            if IsDisabledControlJustPressed(0, KEY_LMB) then
                spawnPedAt(Config.Peds[index], curGround, heading)
            end
            -- RIGHT CLICK -> nearest despawn
            if IsDisabledControlJustPressed(0, KEY_RMB) then
                despawnNearest(curGround)
            end
            -- BACKSPACE -> exit
            if IsDisabledControlJustPressed(0, KEY_BACK) then
                active = false
            end
        end

        -- cleanup
        if ghost and DoesEntityExist(ghost) then DeleteEntity(ghost) end
        EnableAllControlActions(0)
        EnableAllControlActions(1)
        SetCamActive(cam, false)
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam, false)
        ClearFocus()
        lib.notify({ type = 'inform', description = 'Ped Spawner band. Peds jahan the wahin hain.' })
    end)
end

-- ----------------------------------------------------------------
-- Command
-- ----------------------------------------------------------------
RegisterCommand(Config.Command, function()
    start()
end, false)

-- 3-AXIS GIZMO COORDINATE PICKER (Config.CoordKey, default 'G')
-- Freecam me aim + RED axis white line pe -> ye key -> coord + bearing F8 me.
RegisterCommand('pedspawner_getcoord', function()
    if not active or not lastAim then
        lib.notify({ type = 'error', description = 'Pehle /pedspawner khol ke aim karo' })
        return
    end
    local a = lastAim
    local v4 = ('vector4(%.3f, %.3f, %.3f, %.3f)'):format(a.x, a.y, a.z, a.w)
    print('^2================ [ped_spawner] COORD PICK ================^7')
    print('^2  '.. v4 ..'^7')
    print(('^2  generate_line.py:^7  START = (%.3f, %.3f, %.3f)   HEADING = %.2f'):format(a.x, a.y, a.z, a.w))
    print(('^2  line white line pe:^7  DIR_SOURCE = "bearing"   LINE_BEARING = %.2f'):format(a.w))
    print('^2=========================================================^7')
    TriggerEvent('chat:addMessage', { args = { 'PedSpawner', v4 } })
    lib.notify({ type = 'success', description = 'Coord F8 console + chat me print ho gaya' })
end, false)
RegisterKeyMapping('pedspawner_getcoord', 'Ped Spawner: aim coordinate print (gizmo)', 'keyboard', Config.CoordKey)

-- /pedspawner_clear -> saare spawned peds hatao (peds.lua bhi khaali)
RegisterCommand(Config.Command .. '_clear', function()
    for i = 1, #spawns do
        if spawns[i].ped and DoesEntityExist(spawns[i].ped) then DeletePed(spawns[i].ped) end
    end
    spawns = {}
    TriggerServerEvent('pedspawner:clear')
    lib.notify({ type = 'success', description = 'Saare spawned peds hata diye.' })
end, false)

-- /pedspawner_reload -> peds.lua dobara padho (haath se edit karne ke baad)
RegisterCommand(Config.Command .. '_reload', function()
    loadSaved()
    lib.notify({ type = 'inform', description = 'peds.lua reload ho gaya.' })
end, false)

-- ----------------------------------------------------------------
-- Resource start -> saved peds wapas laao
-- ----------------------------------------------------------------
AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    CreateThread(function()
        while not NetworkIsPlayerActive(PlayerId()) do Wait(500) end
        Wait(1000)
        loadSaved()
    end)
end)

-- Safety: resource stop pe camera/controls restore + live peds hatao
-- (data peds.lua me safe hai — restart pe manager wapas spawn kar dega)
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    active = false
    EnableAllControlActions(0)
    RenderScriptCams(false, false, 0, true, false)
    ClearFocus()
    for i = 1, #spawns do
        if spawns[i].ped and DoesEntityExist(spawns[i].ped) then DeletePed(spawns[i].ped) end
    end
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/' .. Config.Command,
        'Freecam Ped Spawner — scroll=change, LMB=spawn, RMB=despawn, Backspace=exit')
end)
