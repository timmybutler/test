-- Ultra-obfuscated print call in Roblox Luau
-- NO direct use of 'print' in code
-- Function virtualization, junk data, encrypted index access

-- Generate 500+ character junk table (only 5 are used)
local charTable = {}
local ascii = "abcdefghijklmnopqrstuvwxyz"
for i = 1, 520 do
    charTable[i] = ascii:sub(((i * 7) % #ascii) + 1, ((i * 7) % #ascii) + 1)
end

-- Embed real characters "p", "r", "i", "n", "t" at secret indexes
local keyIndexes = {93, 187, 241, 306, 419}  -- manually chosen, obscure
charTable[keyIndexes[1]] = "p"
charTable[keyIndexes[2]] = "r"
charTable[keyIndexes[3]] = "i"
charTable[keyIndexes[4]] = "n"
charTable[keyIndexes[5]] = "t"

-- Use bit32.bxor instead of Lua's '~' (not supported in Luau)
local bit = bit32

-- Indexes are encoded using XOR and math logic
local encodedIndexes = {
    (bit.bxor(keyIndexes[1], 0x2A)) + 1,
    (bit.bxor(keyIndexes[2], 0x2A)) + 2,
    (bit.bxor(keyIndexes[3], 0x2A)) + 3,
    (bit.bxor(keyIndexes[4], 0x2A)) + 4,
    (bit.bxor(keyIndexes[5], 0x2A)) + 5
}

-- Dead logic to confuse decompilers
local function deadNoise()
    for i = 1, 20 do
        local a = i * math.random(5, 15)
        if a % 2 == 0 then
            a = a ^ 2
        end
    end
end

-- Virtual function table with aliases
local virtualFuncs = {}
local env = getfenv(1)

-- Add garbage virtual handlers
for i = 1, 20 do
    virtualFuncs["v"..i] = function(...) return ... end
end

-- Function name builder (final logic)
local function reconstructKey()
    local realIndexes = {}
    for i, v in ipairs(encodedIndexes) do
        realIndexes[i] = bit.bxor((v - i), 0x2A)
    end
    local parts = {}
    for _, index in ipairs(realIndexes) do
        table.insert(parts, charTable[index])
    end
    return table.concat(parts)
end

-- Resolve function reference through environment
local function resolveFunction(key)
    local call = env[key]
    if type(call) == "function" then
        return call
    end
    return function(...) end -- fallback stub
end

-- Execute dead logic (not useful)
deadNoise()

-- Final call (fully dynamic)
local funcName = reconstructKey()
local realFunc = resolveFunction(funcName)

-- Fake branch to confuse static analyzers
if tostring(funcName):sub(1,1) == "p" then
    virtualFuncs["v13"]("this is junk")
    realFunc("✅ Ultra-obfuscated print executed")
end
