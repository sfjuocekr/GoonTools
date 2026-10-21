local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")


function GoonTools:PLAYER_LOGIN()
    self:UnregisterEvent("PLAYER_LOGIN")

    if IsInGuild() then
        local numMembers = GetNumGuildMembers()

        for i = 1, numMembers do
            local name, _, _, level, _, _, _, _, _, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)
            guildMembers[guid].name = name
            guildMembers[guid].level = level
        end


        self:RegisterEvent("GUILD_ROSTER_UPDATE")
    end

    self:RegisterEvent("PARTY_INVITE_REQUEST")
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("PLAYER_LEVEL_UP")
end


function GoonTools:PLAYER_LEVEL_UP(_, level)
    if not GoonTools:GetDingScreenshot() then
        return
    end

    C_Timer.After(2, function()
        Screenshot()
    end)
end


function GoonTools:PARTY_INVITE_REQUEST(_, name, _, _, _, _, _, inviterGUID)
    if not GoonTools:GetPartyInvite() then
        return
    end

    if not IsGuildMember(inviterGUID) and self:GetGuildPartyInvite() then
        return
    end

    for i = 1, 4 do
        local popup = _G["StaticPopup" .. i]

        if popup and popup:IsShown() then
            if popup.which == "PARTY_INVITE" then
                _G["StaticPopup" .. i .. "Button1"]:Click()

                break
            end
        end
    end
end


function GoonTools:CHAT_MSG_WHISPER(_, text, playerName, _, _, _, _, _, _, _, _, _, guid)
    if issecretvalue(text) or issecretvalue(playerName) or issecretvalue(guid) or IsRestricted() then
        return
    end

    if not GoonTools:GetWhisperInvite() then
        return
    end

    if not IsGuildMember(guid) and self:GetGuildWhisperInvite() then
        return
    end


    if guid == playerGUID then
        return
    end


    for _, keyword in ipairs(inviteKeywords) do
        if keyword == GetKeyword(text) then
            C_PartyInfo.InviteUnit(playerName)

            break
        end
    end
end


function GoonTools:GUILD_ROSTER_UPDATE()
    if not GoonTools:GetGratzGuild() then
        return
    end

    local numMembers = GetNumGuildMembers()

    for i = 1, numMembers do
        local name, _, _, level, _, _, _, _, isOnline, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)
        local previousLevel = guildMembers[guid]

        if isOnline then
            if previousLevel then
                if level > previousLevel then
                    self:Print("Dinged: " .. name .. " " .. previousLevel .. " " .. level .. " " .. tostring(isOnline))

                    if not UnitIsPlayer(name) then
                        C_ChatInfo.SendChatMessage("Grats " .. name .. "!", "GUILD")
                    end

                    guildMembers[guid] = level
                end
            else
                self:Print("Adding: " .. name .. " " .. " " .. level .. " " .. tostring(isOnline))

                guildMembers[guid] = level
            end
        end
    end
end
