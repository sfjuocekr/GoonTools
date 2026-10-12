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
    GoonTools:InitializeUI()

    self:RegisterEvent("PLAYER_LEVEL_UP", "OnPlayerLevelUp")
    self:RegisterEvent("PARTY_INVITE_REQUEST", "OnPartyInviteRequest")
    self:RegisterEvent("CHAT_MSG_WHISPER", "OnChatMsgWhisper")
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

