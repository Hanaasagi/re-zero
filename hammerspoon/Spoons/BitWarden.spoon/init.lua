local alert = require("hs.alert")
local dialog = require("hs.dialog")
local timer = require("hs.timer")
local application = require("hs.application")
local window = require("hs.window")
local eventtap = require("hs.eventtap")
local hotkey = require("hs.hotkey")

local obj = {}
obj.__index = obj

obj.name = "Bitwarden"
obj.version = "0.1.0"
obj.author = "Hanaasagi <ambiguous404@gmail.com>"

local logger = hs.logger.new("Bitwarden", "info")
local bitwarden = {}

function bitwarden:lock()
    hs.execute([[ /usr/local/bin/bw lock ]], true)
end

function bitwarden:unlock(password)
    local output, status = hs.execute(string.format(
                                          [[ /usr/local/bin/bw unlock '%s']],
                                          password), true)
    if not status then
        alert.show("Login Failed")
        logger:e(string.format("Login Failed, the bw cli returns: %s", output))
        return false, ""
    end

    -- A trick way: grep the bitwarden cli output
    local sessionKey = string.match(output, '%"[%w%p]+%"') -- with quotes
    if not sessionKey then
        alert.show("Could not find the session text from the bw command output")
        logger:e(string.format(
                     "session key grep failed, the bw cli returns: %s", output))
        return false, ""
    end

    return true, sessionKey
end

function bitwarden:getPassword(itemName, sessionKey)
    output, status = hs.execute(string.format(
                                    [[ /usr/local/bin/bw get password "%s" --session %s]],
                                    itemName, sessionKey), true)
    if not status then
        alert.show("Get Item Password Failed")
        logger:e(
            string.format("get item failed, the bw cli returns: %s", output))
        return false, ""
    end

    return true, output
end

function askBwPassword()
    local app = application.frontmostApplication()
    local win = window.focusedWindow()

    -- Firstly, we unlock the bitwarden vault.
    hs.focus() -- need manually focus: https://github.com/Hammerspoon/hammerspoon/issues/1561
    local button, password = dialog.textPrompt("Your Bitwarden password", "",
                                               "", "OK", "Cancel", true)
    if button == "Cancel" then
        return
    end

    local status, sessionKey = bitwarden:unlock(password)
    if not status then
        return
    end

    -- Secondly, we ask for the item.
    local button, itemName = dialog.textPrompt("Which Item", "", "", "OK",
                                               "Cancel", false)
    if button == "Cancel" then
        bitwarden:lock()
        return
    end

    local status, itemPassword = bitwarden:getPassword(itemName, sessionKey)
    if not status then
        bitwarden:lock()
        return
    end

    bitwarden:lock()
    -- Thirdly, send the keyboard events to the app and focus the window.
    eventtap.keyStrokes(itemPassword, app)
    -- hs.pasteboard.setContents(itemPassword)
    win:focus()
end

function obj:init()
    hotkey.bind({"alt"}, 'p', askBwPassword)
end

return obj
