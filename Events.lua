local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")


function GoonTools:PLAYER_LOGIN()
    self:UnregisterEvent("PLAYER_LOGIN")

    self.playerGUID = UnitGUID("player")

    GoonTools:SetupGoonToolsEvents()

    --[[if IsInGuild() then
        local numMembers = GetNumGuildMembers()

        for i = 1, numMembers do
            local name, _, _, level, _, _, _, _, _, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)
            guildMembers[guid].name = name
            guildMembers[guid].level = level
        end
    end]]
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

    if guid == self.playerGUID then
        return
    end

    for _, keyword in ipairs(self.inviteKeywords) do
        if keyword == GetKeyword(text) then
            C_PartyInfo.InviteUnit(playerName)

            break
        end
    end
end


function GoonTools:PLAYER_GUILD_UPDATE()
    self:SetupGoonToolsEvents()
end


function GoonTools:GUILD_ROSTER_UPDATE()
    if IsRestricted() then
        return
    end

    if self.rosterInitialized then
        -- Check roster for changes, defer updating levels.
        self:UpdateGuildRoster()

        -- Check members if they leveled up
        self:CheckLevelUp()

        -- Broadcast registration
        self:SendCommMessage(
            "GT_REG",
            self.playerGUID,
            "GUILD"
        )
    else
        self:InitializeRoster()
    end
    
    --[[
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
    end]]
end


function GoonTools:SetupGoonToolsEvents()
    self:RegisterEvent("PLAYER_GUILD_UPDATE")
    self:RegisterEvent("PARTY_INVITE_REQUEST")
    self:RegisterEvent("CHAT_MSG_WHISPER")
    self:RegisterEvent("PLAYER_LEVEL_UP")

    if IsInGuild() then
        self:CreateEvents()
    else
        self:DestroyEvents()
    end
end


function GoonTools:CreateEvents()
    self:RegisterEvent("GUILD_ROSTER_UPDATE")
    self:RegisterComm("GT_REG", "OnGoonToolsRegister")
end


function GoonTools:DestroyEvents()
    self:UnregisterEvent("GUILD_ROSTER_UPDATE")
    self:UnegisterComm("GT_REG")
end


function GoonTools:OnCommReceived(...)
    self:Print("OnCommReceived")

    for i = 1, select("#", ...) do
        local value = select(i, ...)
        self:Print(i .. ": " .. tostring(value))
    end
end


function GoonTools:OnGoonToolsRegister(_, guid)
    if self.rosterInitialized then
        self.guildMembers[guid].addon = true
    end
end