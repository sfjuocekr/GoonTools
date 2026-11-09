local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")


function GoonTools:DumpNames()
    for k, v in pairs(self.guildMembers) do
        if v.online then
            self:Print(k .. " " .. tostring(v.name))
        end
    end
end


function GoonTools:DumpLevels(value)
    for k, v in pairs(self.guildMembers) do
        ---local localizedClass, englishClass, localizedRace, englishRace, sex, name, realmName = GetPlayerInfoByGUID(k)

        if v.name == value or (value == "" and v.online) then
            self:Print(v.name .. " " .. k .. " " .. v.level)
        end
    end
end


function GoonTools:DumpZones()
    for k, v in pairs(self.zoneNames) do
        self:Print(k .. " " .. v.id .. " " .. v.temperature .. " " .. v.goons)
    end
end


function GoonTools:DumpAddon()
    for k, v in pairs(self.guildMembers) do
        if v.addon then
            self:Print(k .. ": " .. tostring(v.addon))
        end
    end
end


function GoonTools:DumpZoneID(value)
    local maps = C_Map.GetMapChildrenInfo(
        value,
        Enum.UIMapType.Zone,
        true
    )

    for _, map in ipairs(maps) do
        self.zoneNames[map.name] = {}
        self.zoneNames[map.name].id = map.mapID
        self.zoneNames[map.name].temperature = 0
        self.zoneNames[map.name].goons = 0

        self:Print(map.name .. " " .. map.mapID)
    end
end


GoonTools:RegisterChatCommand("gtdn", "DumpNames")
GoonTools:RegisterChatCommand("gtdl", "DumpLevels")
GoonTools:RegisterChatCommand("gtdz", "DumpZones")
GoonTools:RegisterChatCommand("gtda", "DumpAddon")
GoonTools:RegisterChatCommand("gtdzn", "DumpZoneID")