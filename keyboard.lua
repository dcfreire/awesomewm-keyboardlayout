-------------------------------------------------
-- Keyboard Layout Widget for Awesome Window Manager
-- Requires xkblayout-state
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local QUERY = "xkblayout-state print \"%s\""
local SET = "xkblayout-state set +1"

local function worker(args)
    local args = args or {}
    local timeout = args.timeout or 1
    local font = args.font or 'Play 9'
    local layout = wibox.widget {
        markup = "",
        widget = wibox.widget.textbox,
        font = font
    }

    function layout.update(_, text, _, _)
        if layout:get_markup() ~= text then
            layout:set_markup(string.upper(text))
        end
    end

    watch(QUERY, timeout, layout.update, layout)

    layout:connect_signal("button::press", function(_, _, _, button)
        if (button == 1) then
            awful.spawn(SET, false)      -- left click
        end
        awful.spawn.easy_async(QUERY, function(stdout, stderr, exitreason, exitcode)
            layout.update(nil, stdout, nil, nil)
        end)
    end)

    return layout
end


return worker