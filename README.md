# Awesome WM v4 Basic Volume Widget using pactl

## Background
I was having trouble finding a volume control widget for Awesome version 4 that would use pactl, have mouse controls on the widget, and would update with the volume slider on my keyboard. This script addresses all of those issues. 

## Install
Add the volume_widget.lua file to your awesome config directory. It should be `~/.config/awesome`

Add the following lines to your rc.lua file:
```lua
-- Add this near the top
-- Load the volume widget
local volume_widget = require('volume_widget')

...

-- {{{ Wibar
...
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            setup_volume_widget(),
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

...

-- {{{ Key bindings
globalkeys = gears.table.join(
...
    -- Volume Keys
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)
            awesome.emit_signal('volume_change')
        end,
        {description = "volume up", group = "audio"}),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)
            awesome.emit_signal('volume_change')
        end,
        {description = "volume down", group = "audio"}),
    awful.key({ }, "XF86AudioMute",
        function ()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)
            awesome.emit_signal('volume_change')
        end,
        {description = "toggle mute", group = "audio"}),
...
```

