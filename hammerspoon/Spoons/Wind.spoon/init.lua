local hotkey = require("hs.hotkey")
local alert = require("hs.alert")
local window = require("hs.window")
local layout = require("hs.layout")
local timer = require("hs.timer")
local canvas = require("hs.canvas")
local screen = require("hs.screen")
local hints = require("hs.hints")

local obj = {}
obj.__index = obj

obj.name = "Wind"
obj.version = "0.1.0"
obj.author = "Hanaasagi <ambiguous404@gmail.com>"
obj.lastOperatedAt = os.time(os.date("!*t"))

function enum(names)
    local _table = {}
    local length = 0

    for id, name in pairs(names) do
        length = length + 1

        local obj = {name = name, value = id}
        _table[name], _table[id] = obj, obj
    end

    return _table
end

local options = enum({
    "center", "fullscreen", "halfleft", "halfright", "halftop", "halfbottom",
    "northeast", "northwest", "southeast", "southwest"

})

local directions = enum({"left", "right", "up", "down"})

function obj:updateOperatedAt()
    obj.lastOperatedAt = os.time(os.date("!*t"))
end

function obj:showStatus()
    if self.statusInfo == nil then
        statusInfo = canvas.new({x = 0, y = 0, w = 0, h = 0})
        statusInfo:insertElement({
            type = "text",
            text = "wMode",
            textFont = "Impact",
            textSize = 128,
            textColor = {hex = "#1891C3"},
            textAlignment = "center"
        })

        local mainScreen = screen.mainScreen()
        local mainRes = mainScreen:fullFrame()
        statusInfo:frame({
            x = (mainRes.w - 512) / 2,
            y = (mainRes.h - 256) / 2,
            w = 512,
            h = 256
        })

        self.statusInfo = statusInfo
    end

    self.statusInfo:show()
end

function obj:hideStatus()
    if self.statusInfo == nil then
        return
    end
    self.statusInfo:hide()
end

function obj:moveAndResize(option)
    obj:updateOperatedAt()

    local cwin = window.focusedWindow()
    if not cwin then
        alert.show("No focused window")
        return
    end

    if option == options.center then
        cwin:centerOnScreen()
    elseif option == options.fullscreen then
        cwin:toggleFullScreen()
    elseif option == options.halfleft then
        cwin:moveToUnit(layout.left50)
    elseif option == options.halfright then
        cwin:moveToUnit(layout.right50)
    elseif option == options.halftop then
        cwin:moveToUnit('[0,0,100,50]')
    elseif option == options.halfbottom then
        cwin:moveToUnit('[0,50,100,100]')
    elseif option == options.northwest then
        cwin:moveToUnit('[0,0,50,50]')
    elseif option == options.northeast then
        cwin:moveToUnit('[50,0,100,50]')
    elseif option == options.southwest then
        cwin:moveToUnit('[0,50,50,100]')
    elseif option == options.southeast then
        cwin:moveToUnit('[50,50,100,100]')
    end
end

function obj:panning(direction)
    obj:updateOperatedAt()

    local cwin = window.focusedWindow()

    if not cwin then
        alert.show("No focused window")
        return
    end

    local cscreen = cwin:screen()
    local cres = cscreen:fullFrame()
    local wtopleft = cwin:topLeft()
    local stepw = cres.w / 30
    local steph = cres.h / 30

    if direction == directions.left then
        cwin:setTopLeft({x = wtopleft.x - stepw, y = wtopleft.y})
    elseif direction == directions.right then
        cwin:setTopLeft({x = wtopleft.x + stepw, y = wtopleft.y})
    elseif direction == directions.up then
        cwin:setTopLeft({x = wtopleft.x, y = wtopleft.y - steph})
    elseif direction == directions.down then
        cwin:setTopLeft({x = wtopleft.x, y = wtopleft.y + steph})
    end
end

local checker = timer.new(0.5, function()
    local currentTime = os.time(os.date("!*t"))
    if (currentTime - obj.lastOperatedAt) >= 2 then
        k:exit()
    end
end)

function obj:init()
    k = hotkey.modal.new('alt', 'w')

    function k:entered()
        obj:showStatus()

        if not checker:running() then
            checker:start()
        end
    end

    function k:exited()
        obj:hideStatus()
        if checker:running() then
            checker:stop()
        end
    end

    k:bind('', 'escape', function()
        k:exit()
    end)
    k:bind('', 'q', function()
        k:exit()
    end)

    k:bind('', 'h', function()
        obj:moveAndResize(options.halfleft)
    end)
    k:bind('', 'l', function()
        obj:moveAndResize(options.halfright)
    end)
    k:bind('', 'k', function()
        obj:moveAndResize(options.halftop)
    end)
    k:bind('', 'j', function()
        obj:moveAndResize(options.halfbottom)
    end)
    k:bind('', 'f', function()
        obj:moveAndResize(options.fullscreen)
    end)
    k:bind('', 'c', function()
        obj:moveAndResize(options.center)
    end)
    k:bind('', 'y', function()
        obj:moveAndResize(options.northwest)
    end)
    k:bind('', 'u', function()
        obj:moveAndResize(options.southwest)
    end)
    k:bind('', 'i', function()
        obj:moveAndResize(options.northeast)
    end)
    k:bind('', 'o', function()
        obj:moveAndResize(options.southeast)
    end)

    k:bind('shift', 'h', function()
        obj:panning(directions.left)
    end)
    k:bind('shift', 'j', function()
        obj:panning(directions.down)
    end)
    k:bind('shift', 'k', function()
        obj:panning(directions.up)
    end)
    k:bind('shift', 'l', function()
        obj:panning(directions.right)
    end)

    hotkey.bind("alt", 'a', function()
        hints.windowHints()
    end)
end

return obj
