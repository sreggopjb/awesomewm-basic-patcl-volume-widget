-- Volume widget
local wibox = require("wibox")
local awful = require("awful")

-- Update volume widget
local function update_volume_widget()
    awful.spawn.easy_async_with_shell('pactl list sinks | grep -A 100 "Built-in Audio Analog Stereo"', function(stdout)
        local volume = string.match(stdout, '(%d?%d?%d)%% /')
        local mute = string.match(stdout, 'Mute:%s+(%a+)')
        if mute == 'yes' then
            volume_widget:get_children_by_id('text')[1]:set_text('MUTE')
        else
            volume_widget:get_children_by_id('text')[1]:set_text(volume..'%')
        end
    end)
end

function setup_volume_widget()
    update_volume_widget()
    return volume_widget
end

volume_widget = wibox.widget {
    {
        {
            {
                id = 'text',
                widget = wibox.widget.textbox,
                text = '100%',
            },
            layout = wibox.layout.fixed.horizontal,
        },
        margins = 4,
        widget = wibox.container.margin,
    },
    bg = '#333333',
    widget = wibox.container.background,
}

-- Update volume widget when volume is changed
awesome.connect_signal('volume_change', function()
    update_volume_widget()
end)

-- Mouse bindings for volume widget
volume_widget:connect_signal('button::press', function(_, _, _, button)
    if button == 4 then -- Scroll up
        awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ +5%')
        awesome.emit_signal('volume_change')
    elseif button == 5 then -- Scroll down
        awful.spawn('pactl set-sink-volume @DEFAULT_SINK@ -5%')
        awesome.emit_signal('volume_change')
    elseif button == 1 then -- Left click
        awful.spawn('pactl set-sink-mute @DEFAULT_SINK@ toggle')
        awesome.emit_signal('volume_change')
    end
end)
