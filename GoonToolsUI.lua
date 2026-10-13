local GoonTools = GoonTools


local defaults = {
    profile = {
        dingScreenshot = true,
        gratzGuild = false,
        partyInvite = true,
        whisperInvite = true,
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
        inviteConfig = {
            type = "group",
            name = "Guild invites",
            inline = true,
            order = 2,
            args = {
                partyInvite = {
                    type = "toggle",
                    name = "Party / Raid invite",
                    desc = "Automagically accept party and raid invites sent by guild members.",
                    order = 1,

                    get = function()
                        return GoonTools:GetPartyInvite()
                    end,

                    set = function(_, value)
                        GoonTools:SetPartyInvite(value)
                    end,
                },
                whisperInvite = {
                    type = "toggle",
                    name = "Whisper invite",
                    desc = "Invite a guild member when they whisper a keyword.",
                    order = 2,
                    get = function()
                        return GoonTools:GetWhisperInvite()
                    end,

                    set = function(_, value)
                        GoonTools:SetWhisperInvite(value)
                    end,
                },
            },
        },
    },
}


function GoonTools:GetDingScreenshot()
    return self.db.profile.dingScreenshot
end

function GoonTools:SetDingScreenshot(value)
    self.db.profile.dingScreenshot = value
end


function GoonTools:GetGratzGuild()
    return self.db.profile.gratzGuild
end

function GoonTools:SetGratzGuild(value)
    self.db.profile.gratzGuild = value
end


function GoonTools:GetPartyInvite()
    return self.db.profile.partyInvite
end

function GoonTools:SetPartyInvite(value)
    self.db.profile.partyInvite = value
end


function GoonTools:GetWhisperInvite()
    return self.db.profile.whisperInvite
end

function GoonTools:SetWhisperInvite(value)
    self.db.profile.whisperInvite = value
end


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
end


function GoonTools:HandleSlashCommand(input)
    if input == "" then
        Settings.OpenToCategory(self.optionsFrame.name)

        return
    end
end


GoonTools:RegisterChatCommand("gt", "HandleSlashCommand")

GoonTools:RegisterChatCommand("ffa", function()
    C_PartyInfo.SetLootMethod(Enum.LootMethod.Freeforall)
end)

GoonTools:RegisterChatCommand("gl", function()
    C_PartyInfo.SetLootMethod(Enum.LootMethod.GroupLoot)
end)
