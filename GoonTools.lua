local GoonTools = LibStub("AceAddon-3.0"):NewAddon(
    "GoonTools",
    "AceConsole-3.0",
    "AceEvent-3.0",
    "AceComm-3.0"
)


GoonTools.inviteKeywords = {
    "inv",
    "invite",
}


GoonTools.guildMessages = {
    joined = {
        "%n just joined the guild!",
        "%n has joined the guild!",
        "%n welcome to the guild!",
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


GoonTools.playerGUID = nil
GoonTools.guildMembers = {}
GoonTools.rosterInitialized = false


function GoonTools:OnInitialize()
    ---self:Print("OnInitialize")

    GoonTools:InitializeUI()

    self:RegisterEvent("PLAYER_LOGIN")
end


function GoonTools:HandleSlashCommand(input)
    -- Handle possible commands fed to /gt
    self:Print(input)
end


function GoonTools:RandomMessage(category, values)
    local options = self.guildMessages[category]

    if not options or #options == 0 then
        self.Print(category .. values)

        return ""
    end

    return FormatMessage(options[math.random(#options)], values)
end


function GoonTools:InitializeRoster()
    local numMembers, _ = GetNumGuildMembers()

    if numMembers == 0 then -- TODO: why does this happen at first login?
        return
    end

    for i = 1, numMembers do
        local entry = GetGuildRosterEntry(i)

        if entry.guid and entry.level > 0 then
            self.guildMembers[entry.guid] = CreateGuildMember(entry.online, entry.name, entry.level,
                entry.zone, self:GenerateGoonStone(entry.guid))
        end
    end

    self.rosterInitialized = true
end


function GoonTools:UpdateGuildRoster()
    --self:Print("UpdateGuildRoster")

    local numMembers, _ = GetNumGuildMembers()

    for i = 1, numMembers do
        local entry = GetGuildRosterEntry(i)

        if self.db.global.zoneNames[entry.zone] == nil and entry.zone then
            self.db.global.zoneNames[entry.zone] = {
                id = 0,
                temperature = 0,
                goons = 0
            }
        end

        if entry.guid and entry.level > 0 then
            if not self.guildMembers[entry.guid] then
                --self:Print("NewMember!")
                -- A new guild member to be added!
                local goonStone = self:GenerateGoonStone(entry.guid)
                --local goonStone = self:AugmentGoonStone(baseStone, level, zone)

                self.guildMembers[entry.guid] = CreateGuildMember(entry.online, entry.name, entry.level,
                    entry.zone, goonStone)

                if not GoonTools:GetGratzGuild() then
                    return
                end

                -- TODO: Whisper a new member their GoonStone
                self:SendGoonStone(entry.name, "new")
                -- NO SPAM IN GUILD CHAT :(
                --C_ChatInfo.SendChatMessage(self:RandomMessage("joined", { n = entry.name }), "GUILD")
            else
                ---self:Print("OldMember!")
                -- Update guild member name/zone/isOnline
                if self.guildMembers[entry.guid].name ~= entry.name then
                    self.guildMembers[entry.guid].name = entry.name
                end

                if self.guildMembers[entry.guid].zone ~= entry.zone then
                    self.guildMembers[entry.guid].zone = entry.zone
                end

                if self.guildMembers[entry.guid].online ~= entry.online then
                    self.guildMembers[entry.guid].online = entry.online
                end
            end
        end
    end
end


function GoonTools:CheckLevelUp()
    --self:Print("CheckLevelUp")

    local numMembers = GetNumGuildMembers()

    for i = 1, numMembers do
        local entry = GetGuildRosterEntry(i)

        if entry.online then
            if entry.guid and entry.level > 0 then
                local previousLevel = self.guildMembers[entry.guid].level

                if entry.level > previousLevel and entry.level % 10 == 0 then
                    self.guildMembers[entry.guid].level = entry.level

                    if not GoonTools:GetGratzGuild() then
                        return
                    end

                    local goonStone = self:AugmentGoonStone(self.guildMembers[entry.guid].goonStone,
                        entry.level, entry.zone)

                    if entry.guid == self.playerGUID then
                        C_ChatInfo.SendChatMessage("Ding, level " .. entry.level .. "!", "GUILD")
                    else
                        C_ChatInfo.SendChatMessage(self:RandomMessage("levelUp", { n = entry.name, l = entry.level }),
                            "GUILD")
                        C_ChatInfo.SendChatMessage("The light touched your stone and now it ranks a " .. goonStone,
                            "WHISPER", nil, entry.name)
                    end
                end
            end
        end
    end
end
