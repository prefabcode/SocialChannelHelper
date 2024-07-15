local addonName = "SocialChannelHelper"
local socialChannelName = "Social"
local worldChatChannelName = "WorldChat"
local defaultAdvertisementInterval = 600 -- Default to 10 minutes in seconds
local advertisementMessage = "Tired of WTB/WTS/LFG/LFR spam and just want to chat with fellow frostmourne players? /join Social for friendly server-wide chat."
local showWorldChat = true
local advertise = true

-- Initialize saved variables
if not SocialChannelHelperDB then
    SocialChannelHelperDB = {}
end
SocialChannelHelperDB.advertisementInterval = SocialChannelHelperDB.advertisementInterval or defaultAdvertisementInterval
SocialChannelHelperDB.advertisementMessage = SocialChannelHelperDB.advertisementMessage or advertisementMessage

local timeSinceLastAdvert = 0

-- Function to send advertisement message to WorldChat
local function AdvertiseSocialChannel()
    if advertise then
        SendChatMessage(SocialChannelHelperDB.advertisementMessage, "CHANNEL", nil, GetChannelName(worldChatChannelName))
        if not showWorldChat then
            print("[" .. addonName .. "]: Automated advertisement message sent to WorldChat channel.")
        end
    end
    timeSinceLastAdvert = 0 -- Reset the timer
end

-- Function to toggle WorldChat visibility
local function ToggleWorldChatVisibility(show)
    showWorldChat = show
end

-- Chat filter function to block messages from WorldChat
local function ChatFilter(self, event, message, sender, language, channelString, target, flags, channelNumber, channelName, ...)
    if not showWorldChat and channelName == GetChannelName(worldChatChannelName) then
        return true -- Block the message
    end
    return nil
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
            print("[" .. addonName .. "]: WorldChat messages are now visible.")
        elseif arg == "hide" then
            ToggleWorldChatVisibility(false)
            print("[" .. addonName .. "]: WorldChat messages are now hidden.")
        end
    elseif command == "-a" then
        if arg == "on" then
            advertise = true
            print("[" .. addonName .. "]: Advertisement is now ON.")
        elseif arg == "off" then
            advertise = false
            print("[" .. addonName .. "]: Advertisement is now OFF.")
        end
    elseif command == "-rate" then
        local newRate = tonumber(arg)
        if newRate and newRate > 0 then
            SocialChannelHelperDB.advertisementInterval = newRate
            print("[" .. addonName .. "]: Advertisement interval set to " .. newRate .. " seconds.")
        end
    elseif command == "-m" then
        if arg and arg ~= "" then
            SocialChannelHelperDB.advertisementMessage = arg
            print("[" .. addonName .. "]: Advertisement message set to: " .. arg)
        else
            print("[" .. addonName .. "]: Invalid argument for '-m'. Please provide a message.")
        end
    elseif command == "-help" then
        print("[" .. addonName .. "] Commands:")
        print("/sch -wc show : Show incoming WorldChat messages (ad for social channel will still be sent)")
        print("/sch -wc hide : Hide incoming WorldChat messages (ad for social channel will still be sent)")
        print("/sch -a on : Enable sending Social channel advertisement messages to WorldChat")
        print("/sch -a off : Disable sending Social channel advertisement messages to WorldChat")
        print("/sch -rate <seconds> : Set advertisement interval in seconds (be kind to others, do not spam)")
        print("/sch -m <message> : Set the advertisement message to be sent to WorldChat")
    else
        print("[" .. addonName .. "]: Unknown command. Type '/sch -help' for help.")
    end
end

-- Register events and slash commands
local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_CHANNEL")
frame:SetScript("OnUpdate", OnUpdateHandler)

SLASH_SocialChannelHelper1 = "/socialchannelhelper"
SLASH_SocialChannelHelper2 = "/sch"
SlashCmdList["SocialChannelHelper"] = SlashCommandHandler

-- Add chat filter
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatFilter)

-- Print help message on login
print("[" .. addonName .. "]: Type '/sch -help' for a list of commands.")
