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
        local name, _, _, level, _, zone, _, _, isOnline, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)

        if guid and (level > 0) then
            self.guildMembers[guid] = CreateGuildMember(isOnline, name, level, zone, self:GenerateGoonStone(guid))
        end
    end

    self.rosterInitialized = true
end


function GoonTools:UpdateGuildRoster()
    --self:Print("UpdateGuildRoster")

    local numMembers, _ = GetNumGuildMembers()

    for i = 1, numMembers do
        local name, _, _, level, _, zone, _, _, isOnline, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)

        if self.db.global.zoneNames[zone] == nil and zone then
            self.db.global.zoneNames[zone] = {}
            self.db.global.zoneNames[zone].id = 0
            self.db.global.zoneNames[zone].temperature = 0
            self.db.global.zoneNames[zone].goons = 0
        end

        if guid and (level > 0) then
            if not self.guildMembers[guid] then
                --self:Print("NewMember!")
                -- A new guild member to be added!
                local goonStone = self:GenerateGoonStone(guid)
                --local goonStone = self:AugmentGoonStone(baseStone, level, zone)

                self.guildMembers[guid] = CreateGuildMember(isOnline, name, level, zone, goonStone)

                if not GoonTools:GetGratzGuild() then
                    return
                end

                -- TODO: Whisper a new member their GoonStone
                self:SendGoonStone(name, "new")
                -- NO SPAM IN GUILD CHAT :(
                --C_ChatInfo.SendChatMessage(self:RandomMessage("joined", { n = name }), "GUILD")
            else
                ---self:Print("OldMember!")
                -- Update guild member name/zone/isOnline
                if self.guildMembers[guid].name ~= name then
                    self.guildMembers[guid].name = name
                end

                if self.guildMembers[guid].zone ~= zone then
                    self.guildMembers[guid].zone = zone
                end

                if self.guildMembers[guid].online ~= isOnline then
                    self.guildMembers[guid].online = isOnline
                end
            end
        end
    end
end


function GoonTools:CheckLevelUp()
    --self:Print("CheckLevelUp")

    local numMembers = GetNumGuildMembers()

    for i = 1, numMembers do
        local name, _, _, level, _, zone, _, _, isOnline, _, _, _, _, _, _, _, guid = GetGuildRosterInfo(i)

        if isOnline then
            if guid and (level > 0) then
                local previousLevel = self.guildMembers[guid].level

                if level > previousLevel and level % 10 == 0 then
                    self.guildMembers[guid].level = level

                    if not GoonTools:GetGratzGuild() then
                        return
                    end

                    local goonStone = self:AugmentGoonStone(self.guildMembers[guid].goonStone, level, zone)

                    if guid == self.playerGUID then
                        C_ChatInfo.SendChatMessage("Ding, level " .. level .. "!", "GUILD")
                    else
                        C_ChatInfo.SendChatMessage(self:RandomMessage("levelUp", { n = name, l = level }), "GUILD")
                        C_ChatInfo.SendChatMessage("The light touched your stone and now it ranks a " .. goonStone, "WHISPER", nil, name)
                    end
                end
            end
        end
    end
end
