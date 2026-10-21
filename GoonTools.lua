GoonTools = LibStub("AceAddon-3.0"):NewAddon(
    "GoonTools",
    "AceConsole-3.0",
    "AceEvent-3.0"
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


local guildMembers = {}
local playerGUID = UnitGUID("player")


function GoonTools:OnInitialize()
    GoonTools:InitializeUI()

    self:RegisterEvent("PLAYER_LOGIN")
end



