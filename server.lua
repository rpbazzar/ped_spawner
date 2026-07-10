-- ================================================================
-- PED SPAWNER — server
--   Client se aaye spawn/despawn ko peds.lua me likhta hai (persist).
--   Client file likh nahi sakta — isliye SaveResourceFile server pe.
--   Baaki players ko live sync ke liye reload bhejta hai (placer ko
--   chhodkar — taake uske screen pe flicker na ho).
-- ================================================================

local FILE = 'peds.lua'

-- Saaf number formatting (3 decimal)
local function num(n)
    return string.format('%.3f', tonumber(n) or 0.0)
end

-- peds.lua padho -> Lua table
local function loadEntries()
    local content = LoadResourceFile(GetCurrentResourceName(), FILE)
    if not content or content == '' then return {} end
    local chunk = load(content)
    if not chunk then
        print('^1[ped_spawner]^7 peds.lua me Lua syntax error — reset nahi kiya, check karo.')
        return {}
    end
    local ok, t = pcall(chunk)
    return (ok and type(t) == 'table') and t or {}
end

-- Lua table -> peds.lua (readable format)
local function serialize(entries)
    local lines = {
        '-- ================================================================',
        '-- PED SPAWNER — SAVED PEDS  (auto-saved; haath se bhi edit kar sakti ho)',
        '--   { model = "name", coords = vector4(x, y, z, heading) },',
        '--   edit ke baad in-game: /pedspawner_reload',
        '-- ================================================================',
        'return {',
    }
    for _, e in ipairs(entries) do
        local c = e.coords
        if c then
            lines[#lines + 1] = string.format(
                '    { model = %q, coords = vector4(%s, %s, %s, %s) },',
                tostring(e.model or 'unknown'), num(c.x), num(c.y), num(c.z), num(c.w))
        end
    end
    lines[#lines + 1] = '}'
    lines[#lines + 1] = ''
    return table.concat(lines, '\n')
end

local function save(entries)
    SaveResourceFile(GetCurrentResourceName(), FILE, serialize(entries), -1)
end

-- Placer ke alawa baaki sabko reload bhejo (live sync, no self-flicker)
local function syncOthers(exceptSrc)
    for _, pid in ipairs(GetPlayers()) do
        if tonumber(pid) ~= exceptSrc then
            TriggerClientEvent('pedspawner:reload', pid)
        end
    end
end

-- ----------------------------------------------------------------
-- Ek ped save karo
-- ----------------------------------------------------------------
RegisterNetEvent('pedspawner:save', function(model, x, y, z, w)
    local src = source
    if type(model) ~= 'string' or model == '' then return end
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then return end

    local entries = loadEntries()
    entries[#entries + 1] = { model = model, coords = vector4(x, y, z, w or 0.0) }
    save(entries)
    print(('^2[ped_spawner]^7 saved: %s  (total %d)'):format(model, #entries))
    syncOthers(src)
end)

-- ----------------------------------------------------------------
-- Di gayi position ke paas wala ped remove karo
-- ----------------------------------------------------------------
RegisterNetEvent('pedspawner:remove', function(x, y, z, radius)
    local src = source
    if type(x) ~= 'number' or type(y) ~= 'number' or type(z) ~= 'number' then return end

    local entries = loadEntries()
    local bestIdx, bestD = nil, (tonumber(radius) or 4.0) ^ 2
    for i, e in ipairs(entries) do
        local c = e.coords
        if c then
            local dx, dy, dz = c.x - x, c.y - y, c.z - z
            local d = dx * dx + dy * dy + dz * dz
            if d < bestD then bestD, bestIdx = d, i end
        end
    end

    if bestIdx then
        local removed = entries[bestIdx]
        table.remove(entries, bestIdx)
        save(entries)
        print(('^3[ped_spawner]^7 removed: %s  (total %d)'):format(tostring(removed.model), #entries))
        syncOthers(src)
    end
end)

-- ----------------------------------------------------------------
-- Saare peds clear
-- ----------------------------------------------------------------
RegisterNetEvent('pedspawner:clear', function()
    local src = source
    save({})
    print('^3[ped_spawner]^7 all peds cleared.')
    syncOthers(src)
end)
