local pathwatcher = require "hs.pathwatcher"
local alert = require "hs.alert"

function autoReload()
    -- https://www.hammerspoon.org/go/#fancyreload
    function reloadConfig(files)
        doReload = false
        for _, file in pairs(files) do
            if file:sub(-4) == ".lua" then
                doReload = true
            end
        end
        if doReload then
            hs.reload()
        end
    end

    pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon", reloadConfig):start()
    alert.show("Hammerspoon Config Reloaded")
end

spoons_list = {"Archer", "Wind", "Bitwarden"}

for _, v in pairs(spoons_list) do
    hs.loadSpoon(v)
end

autoReload()
