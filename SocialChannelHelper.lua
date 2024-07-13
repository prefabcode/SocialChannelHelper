local addonName = "SocialChannelHelper"
local socialChannelName = "Social"
local worldChatChannelName = "WorldChat"
local defaultAdvertisementInterval = 600 -- Default to 10 minutes in seconds
local advertisementMessage = "Join the '" .. socialChannelName .. "' channel for social conversations! Type /join " .. socialChannelName .. " to participate."
local showWorldChat = true
local advertise = true

-- Initialize saved variables
if not SocialChannelHelperDB then
    SocialChannelHelperDB = {}
end
SocialChannelHelperDB.advertisementInterval = SocialChannelHelperDB.advertisementInterval or defaultAdvertisementInterval

local timeSinceLastAdvert = 0

-- Function to send advertisement message to WorldChat
local function AdvertiseSocialChannel()
    if advertise then
        SendChatMessage(advertisementMessage, "CHANNEL", nil, GetChannelName(worldChatChannelName))
    end
    timeSinceLastAdvert = 0 -- Reset the timer
end

-- Function to toggle WorldChat visibility
local function ToggleWorldChatVisibility(show)
    showWorldChat = show
end

-- Event handler for incoming chat messages
local function OnChatMessage(event, message, sender, ...)
    if not showWorldChat and select(9, ...) == GetChannelName(worldChatChannelName) then
        return true -- Block the message
    end
end

-- OnUpdate handler for custom timer
local function OnUpdateHandler(self, elapsed)
    timeSinceLastAdvert = timeSinceLastAdvert + elapsed
    if timeSinceLastAdvert >= SocialChannelHelperDB.advertisementInterval then
        AdvertiseSocialChannel()
    end
end

-- Slash command handler
local function SlashCommandHandler(msg)
    local command, arg = msg:match("^(%-?%S*)%s*(.-)$")
    
    if command == "-wc" then
        if arg == "show" then
            ToggleWorldChatVisibility(true)
        elseif arg == "hide" then
            ToggleWorldChatVisibility(false)
        end
    elseif command == "-a" then
        if arg == "on" then
            advertise = true
        elseif arg == "off" then
            advertise = false
        end
    elseif command == "-rate" then
        local newRate = tonumber(arg)
        if newRate and newRate > 0 then
            SocialChannelHelperDB.advertisementInterval = newRate
        end
    elseif command == "-help" then
        print("[" .. addonName .. "] Commands:")
        print("/sch -wc show : Show incoming WorldChat messages (ad for social channel will still be sent)")
        print("/sch -wc hide : Hide incoming WorldChat messages (ad for social channel will still be sent)")
        print("/sch -a on : Enable sending Social channel advertisement messages to WorldChat")
        print("/sch -a off : Disable sending Social channel advertisement messages to WorldChat")
        print("/sch -rate <seconds> : Set advertisement interval in seconds (be kind to others, do not spam)")
    else
        print("[" .. addonName .. "]: Unknown command. Type '/sch -help' for help.")
    end
end

-- Register events and slash commands
local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_CHANNEL")
frame:SetScript("OnEvent", OnChatMessage)
frame:SetScript("OnUpdate", OnUpdateHandler)

SLASH_SocialChannelHelper1 = "/socialchannelhelper"
SLASH_SocialChannelHelper2 = "/sch"
SlashCmdList["SocialChannelHelper"] = SlashCommandHandler

-- Print help message on login
print("[" .. addonName .. "]: Type '/sch -help' for a list of commands.")
