local GoonTools = LibStub("AceAddon-3.0"):GetAddon("GoonTools")


local defaults = {
    profile = {
        dingScreenshot = true,
        gratzGuild = false,
        partyInvite = true,
        guildPartyInvite = true,
        whisperInvite = true,
        guildWhisperInvite = true,
    },
    global = {
        zoneNames = {},
    },
}


local options = {
    type = "group",
    name = "GoonTools Configuration",
    args = {
        featuresConfig = {
            type = "group",
            name = "Features",
            inline = true,
            order = 1,
            args = {
                dingScreenshot = {
                    type = "toggle",
                    name = "Ding Screenshot",
                    desc = "Make a screenshot whenever the player reaches the next level.",
                    order = 1,

                    get = function()
                        return GoonTools:GetDingScreenshot()
                    end,

                    set = function(_, value)
                        GoonTools:SetDingScreenshot(value)
                    end,
                },
                gratzGuild = {
                    type = "toggle",
                    name = "Gratz!",
                    desc = "Congratulate a guild member reaching the next level.",
                    order = 2,

                    get = function()
                        return GoonTools:GetGratzGuild()
                    end,

                    set = function(_, value)
                        GoonTools:SetGratzGuild(value)
                    end,
                },
            },
        },
        partyInviteConfig = {
            type = "group",
            name = "Party/raid invites",
            inline = true,
            order = 2,
            args = {
                partyInvite = {
                    type = "toggle",
                    name = "Party / Raid invite",
                    desc = "Automagically accept party and raid invites.",
                    order = 1,

                    get = function()
                        return GoonTools:GetPartyInvite()
                    end,

                    set = function(_, value)
                        GoonTools:SetPartyInvite(value)
                    end,
                },
                guildPartyInvite = {
                    type = "toggle",
                    name = "Guild Only",
                    desc = "Automagically accept party and raid invites sent by guild members.",
                    order = 2,

                    get = function()
                        return GoonTools:GetGuildPartyInvite()
                    end,

                    set = function(_, value)
                        GoonTools:SetGuildPartyInvite(value)
                    end,
                },
            },
        },
        whisperInviteConfig = {
            type = "group",
            name = "Whisper invites",
            inline = true,
            order = 3,
            args = {
                whisperInvite = {
                    type = "toggle",
                    name = "Whisper invite",
                    desc = "Invite when someone whisper a magic keyword.",
                    order = 1,
                    get = function()
                        return GoonTools:GetWhisperInvite()
                    end,

                    set = function(_, value)
                        GoonTools:SetWhisperInvite(value)
                    end,
                },
                guildWhisperInvite = {
                    type = "toggle",
                    name = "Guild Only",
                    desc = "Invite a guild member when they whisper a magic keyword.",
                    order = 2,
                    get = function()
                        return GoonTools:GetGuildWhisperInvite()
                    end,

                    set = function(_, value)
                        GoonTools:SetGuildWhisperInvite(value)
                    end,
                },
            },
        },
    },
}


local DEFAULT_PROFILE_KEYS = {
    "dingScreenshot",
    "gratzGuild",
    "partyInvite",
    "guildPartyInvite",
    "whisperInvite",
    "guildWhisperInvite",
}


function GoonTools:InitializeUI()
    self.db = LibStub("AceDB-3.0"):New(
        "GoonToolsDB",
        defaults
    )

    local AceConfig = LibStub("AceConfig-3.0")
    local AceConfigDialog = LibStub("AceConfigDialog-3.0")

    AceConfig:RegisterOptionsTable(
        "GoonTools Configuration",
        options,
	    {"gtc"}
    )

    self.optionsFrame = AceConfigDialog:AddToBlizOptions(
        "GoonTools Configuration",
        "GoonTools"
    )

    for _, name in ipairs(DEFAULT_PROFILE_KEYS) do
        AddGetSetters(GoonTools, name)
    end

    --self.zoneNames = self.db.global.zoneNames
end


GoonTools:RegisterChatCommand("gt", function(input)
    if input == "" then
        Settings.OpenToCategory(GoonTools.optionsFrame.name)

        return
    else
        GoonTools:HandleSlashCommand(input)
    end
end)

GoonTools:RegisterChatCommand("ffa", function()
    C_PartyInfo.SetLootMethod(Enum.LootMethod.Freeforall)
end)

GoonTools:RegisterChatCommand("gl", function()
    C_PartyInfo.SetLootMethod(Enum.LootMethod.GroupLoot)
end)

GoonTools:RegisterChatCommand("pl", function()
    C_PartyInfo.LeaveParty()
end)
