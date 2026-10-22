local GoonTools = LibStub("AceAddon-3.0"):NewAddon(
    "GoonTools",
    "AceConsole-3.0",
    "AceEvent-3.0",
    "AceComm-3.0"
)


local inviteKeywords = {
    "inv",
    "invite",
}


local guildMessages = {
    joined = {
        "%n just joined the guild!",
        "%n has joined the guild",
        "%n weclome to the guild!",
        "Welcome to the guild %n!",
        "Everyone say hello to our newest member %n!",
    },

    levelUp = {
        "Gratz %n on level %l!",
        "%n just reached level %l!",
        "Congratulations to %n for reaching level %l!",
        "A warm applause for %n who just leveled up to %l!",
        "A small celebration for %n who just dinged %l!",
    },
}


GoonTools.guildMembers = {}
GoonTools.rosterInitialized = false
GoonTools.zoneNames = nil
GoonTools.playerGUID = nil


function GoonTools:OnInitialize()
    GoonTools:InitializeUI()

    self:RegisterEvent("PLAYER_LOGIN")
end


function GoonTools:HandleZoneNames(zone)
    if not zone or zone == "" then
        return 0
    end

    if self.zoneNames[zone] == nil then
        self.zoneNames[zone] = 0
    end

    return self.zoneNames[zone]
end


function GoonTools:InitializeRoster()
    local numMembers = GetNumGuildMembers()

    for i = 1, numMembers do
        local name, _, _, level, _, zone, _, _, isOnline, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)

        -- TODO: this just collects, unknown, zone names for now.
        if zone then
            self:HandleZoneNames(zone)
        end

        if guid and (level > 0) then
            self.guildMembers[guid] = CreateGuildMember(isOnline, name, level, zone)
        end
    end

    self.rosterInitialized = true
end


function GoonTools:UpdateGuildRoster()
end


function GoonTools:CheckLevelUp()
end
