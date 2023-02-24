# Awesome WM v4 Basic Volume Widget using pactl

## Background
After installing Awesome for my window manager, I was having trouble finding a volume control widget for Awesome version 4 that would use pactl, have mouse controls on the widget, and would update with the volume slider on my keyboard. This script addresses all of those issues. 

## Install
Add the volume_widget.lua file to your awesome config directory. It should be `~/.config/awesome`

### Determine the speaker you're using
Run the command `pactl list sinks` in a terminal and find the speaker device you are going to control. In my case it is "Built-in Audio Analog Stereo".
After determining the device, modify the grep command under the `update_volume_widget()` function in the volume_widge.lua. It should look like the following:

```lua
-- Update volume widget
local function update_volume_widget()
    -- Run "pactl list sinks" and determine the device you're using, then modify the line bellow with your device
    awful.spawn.easy_async_with_shell('pactl list sinks | grep -A 100 "Your Audio Device"', function(stdout)
```

### Modify the rc.lua file

Add near the top of the file:
```lua
-- Load the volume widget
local volume_widget = require('volume_widget')
```
Under the wibar section, add `setup_volume_widget(),`
```lua
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
```
Add the following key bindings. 
```lua
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

## Post-install
Now restart awesome, and there should be a widget in the top-right corner showing a percentage or "MUTE" if your speakers are muted. If this is not updating correctly, make sure to check the device that is being used in your volume_widget.lua file on line 8. `pactl list sinks | grep -A 100 "Built-in Audio Analog Stereo"` is what I use to find my speaker. The following lines of code search for the volume and check if the speaker is muted. 

## Usage
If everything is working correctly, you should now be able to hover the mouse over the volume widget in the top-right corner and use the mouse wheel to change the volume. Left click will mute. The keys you have mapped to XF86AudioRaiseVolume, XF86AudioLowerVolume, and XF86AudioMute on your keyboard should work as well. In my case, these are mapped to the volume wheel on my Razer Blackwidow Elite keyboard by default. 
