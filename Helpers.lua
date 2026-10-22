local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")


function IsRestricted()
    local inInstance, instanceType = IsInInstance()
    local isPvP = inInstance and instanceType == "pvp"

    return IsEncounterInProgress() or isPvP
end


function GetKeyword(message)
    if message ~= nil then
        return message:lower():match("^%s*(.-)%s*$")
    end

    return nil
end


function MatchKeyword(keyword, message)
    if message ~= nil then
        if not (message:lower():match("^%s*" .. keyword .. "%s*$") == nil) then
            return true
        end
    end

    return nil
end


function CreateGuildMember(isOnline, name, level, zone)
    return {
        online = isOnline,
        name = name,
        level = level,
        zone = zone,
        addon = false,
    }
end


function FormatMessage(template, values)
    return (template:gsub("%%([a-z])", function(key)
        return tostring(values[key] or "%" .. key)
    end))
end


function RandomMessage(category, values)
    local options = guildMessages[category]

    if not options or #options == 0 then
        return nil
    end

    return self:FormatMessage(options[math.random(#options)], values)
end