### README.md

# SocialChannelHelper

## Description
**SocialChannelHelper** is a World of Warcraft addon targetting the 3.3.5a client designed to enhance social interaction on servers by promoting a new social chat channel and managing the visibility of the current WorldChat channel. The addon periodically advertises the new "Social" channel in the WorldChat to encourage players to join for casual conversations.

Reason for this addon existing: The current implementation of WorldChat is filled with spam for raids, folks selling stuff. It is impossible to have a conversation with anyone in this channel, as your message will disappear shortly after you wrote it due to the volume of messages coming into this channel. 

Solution: This addon will periodically send an advertisement message to WorldChat, promoting a new channel called "Social", where players can talk with one another without being spammed with LFG / LFR / Trade coming from WorldChat. 

The addon features the option to block incoming messages from WorldChat (while simultaneously still sending messages to that channel, advertising the Social channel). With this, you can promote the Social channel without being spammed by incoming messages coming from WorldChat. 

## Features
- **Advertisement**: Automatically sends an advertisement message to the WorldChat channel to promote the "Social" channel.
- **Visibility Control**: Allows users to hide or show messages from the WorldChat channel without leaving it (allowing for continued periodic advertisement messages sent to this channel).
- **User Commands**: Provides chat commands to control the addon's behavior, including setting the advertisement interval and toggling advertisement messages.

## Installation
1. Download the `SocialChannelHelper` addon.
2. Extract the downloaded file and place the `SocialChannelHelper` folder into your `Interface/AddOns` directory.
3. Restart World of Warcraft or reload the UI using the `/reload` command.

## Usage
Use the following commands in the chat window to control the addon's behavior:

### Commands
- **Show Incoming WorldChat Messages**:
  ```
  /sch -wc show
  ```
  Allows incoming WorldChat messages to be visible in the chat window. The advertisement for the Social channel will still be sent.

- **Hide Incoming WorldChat Messages**:
  ```
  /sch -wc hide
  ```
  Hides incoming WorldChat messages from the chat window. The advertisement for the Social channel will still be sent.

- **Enable Advertisement**:
  ```
  /sch -a on
  ```
  Enables sending advertisement messages for the Social channel to the WorldChat.

- **Disable Advertisement**:
  ```
  /sch -a off
  ```
  Disables sending advertisement messages for the Social channel to the WorldChat.

- **Set Advertisement Interval**:
  ```
  /sch -rate <seconds>
  ```
  Sets the interval for sending advertisement messages in seconds. Be considerate and avoid setting a spammy interval.

- **Help**:
  ```
  /sch -help
  ```
  Displays a list of available commands and their descriptions.

## Example
To hide incoming WorldChat messages and set the advertisement interval to 10 minutes, use the following commands:
```
/sch -wc hide
/sch -rate 600
```

## License
This project is licensed under the MIT License. See the LICENSE file for details.

---

Feel free to customize the `README.md` as needed to better suit your preferences.