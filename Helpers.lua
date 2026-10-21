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