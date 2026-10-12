GoonTools = LibStub("AceAddon-3.0"):NewAddon(
    "GoonTools",
    "AceConsole-3.0",
    "AceEvent-3.0"
)


local inviteKeywords = {
    "inv",
    "invite",
}


function GoonTools:OnInitialize()
    self:RegisterEvent("PLAYER_LEVEL_UP", "OnPlayerLevelUp")
    self:RegisterEvent("PARTY_INVITE_REQUEST", "OnPartyInviteRequest")
    self:RegisterEvent("CHAT_MSG_WHISPER", "OnChatMsgWhisper")
end


function GoonTools:OnPlayerLevelUp(_, level)
    --SendChatMessage("DING LEVEL: " .. level, "GUILD")

    C_Timer.After(2, function()
        Screenshot()
    end)
end


function GoonTools:OnPartyInviteRequest(_, name, _, _, _, _, _, inviterGUID)
    --self:Print("Got invite: " .. name .. " " .. inviterGUID)

    if not IsGuildMember(inviterGUID) then
        return
    end

    for i = 1, 4 do
        local popup = _G["StaticPopup" .. i]

        if popup and popup:IsShown() then
            --self:Print("Popup " .. i .. ": " .. tostring(popup.which))

            if popup.which == "PARTY_INVITE" then
                _G["StaticPopup" .. i .. "Button1"]:Click()

                break
            end
        end
    end
end


--[[function GoonTools:OnChatMsgWhisper(_, text, playerName, _, _, _, _, _, _, _, _, _, guid)
    --self:Print("Got whisper: " .. playerName .. " " .. guid)

    if UnitName("player") == playerName then
        return
    end

    if not IsGuildMember(guid) then
        return
    end

    if text:lower():match("^%s*inv%s*$") then
        C_PartyInfo.InviteUnit(playerName)
    end
end]]--


function GoonTools:OnChatMsgWhisper(_, text, playerName, _, _, _, _, _, _, _, _, _, guid)
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

