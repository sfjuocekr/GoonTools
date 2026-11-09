local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")

local goonSecret = 420


-- PeckerRNG creates a deterministic hash: the same GUID and secret produce the same result.
function GoonTools:GenerateGoonStone(guid)
    if not guid then
        return nil
    end

    local hash = goonSecret
    local modulus = 2147483647

    -- Hash every byte of the GUID.
    for i = 1, #guid do
        hash = (hash * 31 + string.byte(guid, i)) % modulus
    end

    -- Base score: 1-15.
    return 15 - (hash % 15)
end


function GoonTools:HandleZoneTemperature(zone)
    -- TODO: Manually decide what temperature a zone is?
    -- -1 cold, 0 = normal and 1 = warm?

    if not zone or zone == "" then
        return 0
    end

    if self.zoneNames[zone].temperature == nil then
        self:Print("Zone temperature not set: " .. zone)

        return 0
    end

    return self.zoneNames[zone].temperature
end


function GoonTools:HandleZoneGoons(zone)
    -- TODO: parse guildMembers and count goons in a zone

    if not zone or zone == "" then
        return 0
    end

    if self.zoneNames[zone].goons == nil then
        self:Print("Zone goons not set: " .. zone)

        return 0
    end

    return self.zoneNames[zone].goons
end


function GoonTools:AugmentGoonStone(goonStone, level, zone)
    local levelBonus = math.min(math.floor((level) / 10), 6)
    local temperature = self:HandleZoneTemperature(zone)

    return goonStone + temperature + levelBonus
end


function GoonTools:HandleGuildMessage(text, playerName)
    if not MatchKeyword("!goonstone", text) then
        return
    end

    self:SendGoonStone(playerName)
end

function GoonTools:SendGoonStone(playerName)
    for guid, member in pairs(self.guildMembers) do
        if member.name == playerName then
            local goonStone = self:AugmentGoonStone(member.goonStone, member.level, member.zone)

            if guid == self.playerGUID then
                self:Print(goonStone)
                --C_ChatInfo.SendChatMessage("My pecker is size " .. pecker .. "!", "GUILD")
            else
                C_ChatInfo.SendChatMessage("The council has rated your stone: " .. goonStone, "WHISPER", nil, playerName)
                --C_ChatInfo.SendChatMessage(self:RandomMessage("pecker", {n = member.name, p = pecker}), "GUILD")
            end

            return
        end
    end
end