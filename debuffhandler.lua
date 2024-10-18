-- GNU Licensed by mousseng's XITools repository [https://github.com/mousseng/xitools]
require('common');
require('helpers');
local buffTable = require('bufftable');

local debuffHandler = 
T{
    -- All enemies we have seen take a debuff
    enemies = T{};
};

-- TO DO: Audit these messages for which ones are actually useful
local statusOnMes = T{160, 164, 166, 186, 194, 203, 205, 230, 236, 266, 267, 268, 269, 237, 271, 272, 277, 278, 279, 280, 319, 320, 375, 412, 645, 754, 755, 804};
local statusOffMes = T{206, 64, 159, 168, 204, 206, 321, 322, 341, 342, 343, 344, 350, 378, 531, 647, 805, 806};
local deathMes = T{6, 20, 97, 113, 406, 605, 646};
local spellDamageMes = T{2, 252, 264, 265};

local function ApplyMessage(debuffs, action)

    if (action == nil) then
        return;
    end

    local now = os.time()

    for _, target in pairs(action.Targets) do
        for _, ability in pairs(target.Actions) do
            -- Set up our state
            local spell = action.Param
            local message = ability.Message
            if (debuffs[target.Id] == nil) then
                debuffs[target.Id] = T{};
            end
            
            -- Bio and Dia
            if action.Type == 4 and spellDamageMes:contains(message) then
                local expiry = nil

                if spell == 23 or spell == 33 or spell == 230 then
                    expiry = now + 60
                elseif spell == 24 or spell == 231 then
                    expiry = now + 120
                elseif spell == 25 or spell == 232 then
                    expiry = now + 150
                end

                if spell == 23 or spell == 24 or spell == 25 or spell == 33 then
                    debuffs[target.Id][134] = expiry
                    debuffs[target.Id][135] = nil
                elseif spell == 230 or spell == 231 or spell == 232 then
                    debuffs[target.Id][134] = nil
                    debuffs[target.Id][135] = expiry
                end

            elseif statusOnMes:contains(message) then
                -- Regular debuffs
                local buffId = ability.Param or (action.Type == 4 and buffTable.GetBuffIdBySpellId(spell) or nil);
                if (buffId == nil) then
                    return
                end

                if spell == 58 or spell == 80 then -- para/para2
                    debuffs[target.Id][buffId] = now + 120
                elseif spell == 56 or spell == 79 then -- slow/slow2
                    debuffs[target.Id][buffId] = now + 180
                elseif spell == 216 then -- gravity
                    debuffs[target.Id][buffId] = now + 120
                elseif spell == 254 or spell == 276 then -- blind/blind2
                    debuffs[target.Id][buffId] = now + 180
                elseif spell == 341 or spell == 344 or spell == 347 then -- ninjutsu debuffs: ichi
                    debuffs[target.Id][buffId] = now + 180
                elseif spell == 342 or spell == 345 or spell == 348 then -- ninjutsu debuffs: ni
                    debuffs[target.Id][buffId] = now + 300
                elseif spell == 23 then -- dia
                    debuffs[target.Id][buffId] = now + 60
                elseif spell == 24 then -- dia2
                    debuffs[target.Id][buffId] = now + 120
                elseif spell == 230 then -- bio
                    debuffs[target.Id][buffId] = now + 60
                elseif spell == 231 then -- bio2
                    debuffs[target.Id][buffId] = now + 120
                elseif spell == 59 or spell == 359 then -- silence/ga
                    debuffs[target.Id][buffId] = now + 120
                elseif spell == 253 or spell == 273 or spell == 363 then -- sleep/ga
                    debuffs[target.Id][buffId] = now + 60
                elseif spell == 259 or spell == 274 or spell == 364 then -- sleep2/ga2
                    debuffs[target.Id][buffId] = now + 90
                elseif spell == 376 or spell == 463 then -- foe/horde lullaby
                    debuffs[target.Id][buffId] = now + 36
                elseif spell == 258 or spell == 362 then -- bind
                    debuffs[target.Id][buffId] = now + 60
                elseif spell == 252 then -- stun
                    debuffs[target.Id][buffId] = now + 5
                elseif spell == 220 then -- poison
                    debuffs[target.Id][buffId] = now + 90
                elseif spell == 221 then -- poison2
                    debuffs[target.Id][buffId] = now + 120
                elseif spell >= 235 and spell <= 240 then -- elemental debuffs
                    debuffs[target.Id][buffId] = now + 120
                elseif spell >= 454 and spell <= 461 then -- threnodies
                    debuffs[target.Id][buffId] = now + 78
                elseif spell == 422 or spell == 421 then -- elegies
                    debuffs[target.Id][buffId] = now + 216
                else -- Handle unknown status effect @ 5 minutes
                    debuffs[target.Id][buffId] = now + 300;
                end
            end
        end
    end
end

local function ClearMessage(debuffs, basic)
    -- if we're tracking a mob that dies, reset its status
    if deathMes:contains(basic.message) and debuffs[basic.target] then
        debuffs[basic.target] = nil
    elseif statusOffMes:contains(basic.message) then
        if debuffs[basic.target] == nil then
            return
        end

        -- Clear the buffid that just wore off
        if (basic.param ~= nil) then
            debuffs[basic.target][basic.param] = nil;
        end
    end
end

debuffHandler.HandleActionPacket = function(e)
    ApplyMessage(debuffHandler.enemies, e);
end

debuffHandler.HandleZonePacket = function(e)
    debuffHandler.enemies = {};
end

debuffHandler.HandleMessagePacket = function(e)
    ClearMessage(debuffHandler.enemies, e)
end

debuffHandler.GetActiveDebuffs = function(serverId)

    if (debuffHandler.enemies[serverId] == nil) then
        return nil
    end
    local returnTable = {};
    local returnTable2 = {};
    for k,v in pairs(debuffHandler.enemies[serverId]) do
        if (v ~= 0 and v > os.time()) then
            table.insert(returnTable, k);
            table.insert(returnTable2, v - os.time());
        end
    end
    return returnTable, returnTable2;
end

return debuffHandler;