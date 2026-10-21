local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")


function GoonTools:DumpLevels(value)
    for guid, level in pairs(guildMembers) do
        local localizedClass, englishClass, localizedRace, englishRace, sex, name, realmName = GetPlayerInfoByGUID(guid)

        if name == value or value == nil then
            self:Print(name .. " " .. guid .. " " .. level)
        end
    end
end