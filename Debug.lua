local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")


function GoonTools:DumpLevels(value)
    for k, v in pairs(self.guildMembers) do
        local localizedClass, englishClass, localizedRace, englishRace, sex, name, realmName = GetPlayerInfoByGUID(k)

        if name == value or (value == "" and v.online) then
            self:Print(name .. " " .. k .. " " .. v.level)
        end
    end
end


function GoonTools:DumpZones()
    for k, v in pairs(self.zoneNames) do
        self:Print(k .. " " .. v)
    end
end


function GoonTools:DumpAddon()
    for k, v in pairs(self.guildMembers) do
        if v.addon then
            self:Print(k .. ": " .. tostring(v.addon))
        end
    end
end


GoonTools:RegisterChatCommand("gtdl", "DumpLevels")
GoonTools:RegisterChatCommand("gtdz", "DumpZones")
GoonTools:RegisterChatCommand("gtda", "DumpAddon")