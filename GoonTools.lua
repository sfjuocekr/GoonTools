GoonTools = LibStub("AceAddon-3.0"):NewAddon(
    "GoonTools",
    "AceConsole-3.0",
    "AceEvent-3.0"
)


local inviteKeywords = {
    "inv",
    "invite",
}


local guildLevels = {}


function GoonTools:OnInitialize()
    self:RegisterEvent("PLAYER_LOGIN", "OnPlayerLogin")
end

function GoonTools:OnPlayerLogin()
    if IsInGuild() then
        GoonTools:InitializeUI()

        local numMembers = GetNumGuildMembers()

        for i = 1, numMembers do
            local name, _, _, level, _, _, _, _, _, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)
            guildLevels[guid] = level
        end

        self:RegisterEvent("PLAYER_LEVEL_UP", "OnPlayerLevelUp")
        self:RegisterEvent("PARTY_INVITE_REQUEST", "OnPartyInviteRequest")
        self:RegisterEvent("CHAT_MSG_WHISPER", "OnChatMsgWhisper")
        self:RegisterEvent("GUILD_ROSTER_UPDATE", "OnGuildRosterUpdate")
    end

    self:UnregisterEvent("PLAYER_LOGIN")
end


function GoonTools:OnPlayerLevelUp(_, level)
    if not GoonTools:GetDingScreenshot() then
        return
    end

    C_Timer.After(2, function()
        Screenshot()
    end)
end


function GoonTools:OnPartyInviteRequest(_, name, _, _, _, _, _, inviterGUID)
    if not GoonTools:GetPartyInvite() then
        return
    end

    if not IsGuildMember(inviterGUID) then
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


function GoonTools:OnChatMsgWhisper(_, text, playerName, _, _, _, _, _, _, _, _, _, guid)
    if not GoonTools:GetWhisperInvite() then
        return
    end

    if UnitName("player") == playerName then
        return
    end

    if not IsGuildMember(guid) then
        return
    end

    text = text:lower():match("^%s*(.-)%s*$")

    for _, keyword in ipairs(inviteKeywords) do
        if keyword == text then
            C_PartyInfo.InviteUnit(playerName)

            break
        end
    end
end


function GoonTools:OnGuildRosterUpdate()
    if not GoonTools:GetGratzGuild() then
        return
    end

    local numMembers = GetNumGuildMembers()

    for i = 1, numMembers do
        local name, _, _, level, _, _, _, _, isOnline, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)
        local previousLevel = guildLevels[guid]

        if isOnline then
            if previousLevel then
                if level > previousLevel then
                    self:Print("Dinged: " .. name .. " " .. previousLevel .. " " .. level .. " " .. tostring(isOnline))

                    if not UnitIsPlayer(name) then
                        C_ChatInfo.SendChatMessage("Grats " .. name .. "!", "GUILD")
                    end

                    guildLevels[guid] = level
                end
            else
                self:Print("Adding: " .. name .. " " .. " " .. level .. " " .. tostring(isOnline))

                guildLevels[guid] = level
            end
        end
    end
end


function GoonTools:DumpLevels(value)
    for guid, level in pairs(guildLevels) do
        local localizedClass, englishClass, localizedRace, englishRace, sex, name, realmName = GetPlayerInfoByGUID(guid)

        if name == value or value == nil then
            self:Print(name .. " " .. guid .. " " .. level)
        end
    end
end