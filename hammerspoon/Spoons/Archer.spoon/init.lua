local eventtap = require("hs.eventtap")
local keycodes = require("hs.keycodes")

local obj = {}
obj.__index = obj

obj.name = "Archer"
obj.version = "0.1.0"
obj.author = "Hanaasagi <ambiguous404@gmail.com>"

-- custom leader key
local leaderKey = 'alt'
-- custom event mapping
local eventMap = {
    -- newKeyEvent(mods, key, isDown)
    h = eventtap.event.newKeyEvent({}, "left", true),
    j = eventtap.event.newKeyEvent({}, "down", true),
    l = eventtap.event.newKeyEvent({}, "right", true),
    k = eventtap.event.newKeyEvent({}, "up", true)
}

function obj:init()
    local function listener(event)
        -- Get the keyboard modifiers of an event
        local flags = event:getFlags()
        -- Get the keycode name of the event
        local keyName = keycodes.map[event:getKeyCode()]

        if not flags:containExactly({leaderKey}) then
            return
        end

        local newEvent = eventMap[keyName]
        if not (newEvent == nil) then
            return true, {newEvent}
        end
    end
    fn_tapper = eventtap.new({hs.eventtap.event.types.keyDown}, listener):start()
end

return obj
