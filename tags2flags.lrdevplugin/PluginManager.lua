--[[----------------------------------------------------------------------------

MIT License

Copyright (c) 2017 Matthew McDermott

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--------------------------------------------------------------------------------

PluginManager.lua
Read and Save Configuration information preserved across Lightroom Sessions.

This module is called by PluginInfoProvider.lua. creating the UI for the Plugin Manager.
[ ] ToDo : Check the Settings for exclusivity.
[ ] ToDo : Add a toggle for debugging
[ ] ToDo : Disable/Enable Controls

------------------------------------------------------------------------------]]
local LrView = import "LrView"
--local LrHttp = import "LrHttp"
local bind = import "LrBinding"
local app = import 'LrApplication'
local LrPrefs = import 'LrPrefs' -- Preferences manager
local LrLogger = import 'LrLogger' -- Import functions for logging and debugging
local logger = LrLogger( 'Tags2Flags' )
logger:enable( "print" ) -- or "logfile

PluginManager = {}

function PluginManager.sectionsForTopOfDialog( viewFactory, properties )
    local f = viewFactory;

    local f = LrView.osFactory();
    local bind = LrView.bind

    local prefs = LrPrefs.prefsForPlugin();
    logger:trace( "Prefs Loaded: UseColor : " .. tostring(prefs.UseColor) )
    properties.UseColor = prefs.UseColor;
    properties.ColorPick = prefs.ColorPick or "purple";
    properties.ColorPossible = prefs.ColorPossible or "green";
    properties.ColorReject = prefs.ColorReject or "red";
    properties.RatingPick = prefs.RatingPick or 5;
    properties.RatingPossible = prefs.RatingPossible or 3;
    properties.RatingReject = prefs.RatingReject or 1;
    properties.ResetRating = prefs.ResetRating;
    properties.ResetColor = prefs.ResetColor;

    return {
        -- section for the top of the dialog
        {
            title = LOC "$$$/Tags2Flags/Preferences/SettingsHeader=Tags to Flags Converter",
            bind_to_object = properties,
            f:row {
                spacing = f:control_spacing(),
                f:checkbox {
                    title = "Use Color",
                    value = bind "UseColor",
                },
            },
            f:row {
                f:group_box{ 
                    title = "Pick Color",
                    width = 100,
                    --size = regular,
                    f:radio_button {
                    title = "Red",
                    value = bind 'ColorPick', -- all of the buttons bound to the same key
                    checked_value = 'red',
                    },
                    f:radio_button {
                    title = "Yellow",
                    value = bind 'ColorPick',
                    checked_value = 'yellow',
                    },
                    f:radio_button {
                    title = "Green",
                    value = bind 'ColorPick',
                    checked_value = 'green',
                    },
                    f:radio_button {
                    title = "Blue",
                    value = bind 'ColorPick',
                    checked_value = 'blue',
                    },
                    f:radio_button {
                    title = "Purple",
                    value = bind 'ColorPick',
                    checked_value = 'purple',
                    },
                },
                f:group_box{ 
                    title = "Possible Color",
                    width = 100,
                    f:radio_button {
                    title = "Red",
                    value = bind 'ColorPossible', -- all of the buttons bound to the same key
                    checked_value = 'red',
                    },
                    f:radio_button {
                    title = "Yellow",
                    value = bind 'ColorPossible',
                    checked_value = 'yellow',
                    },
                    f:radio_button {
                    title = "Green",
                    value = bind 'ColorPossible',
                    checked_value = 'green',
                    },
                    f:radio_button {
                    title = "Blue",
                    value = bind 'ColorPossible',
                    checked_value = 'blue',
                    },
                    f:radio_button {
                    title = "Purple",
                    value = bind 'ColorPossible',
                    checked_value = 'purple',
                    },
                },
                f:group_box{ 
                    title = "Reject Color",
                    width = 100,
                    f:radio_button {
                    title = "Red",
                    value = bind 'ColorReject', -- all of the buttons bound to the same key
                    checked_value = 'red',
                    },
                    f:radio_button {
                    title = "Yellow",
                    value = bind 'ColorReject',
                    checked_value = 'yellow',
                    },
                    f:radio_button {
                    title = "Green",
                    value = bind 'ColorReject',
                    checked_value = 'green',
                    },
                    f:radio_button {
                    title = "Blue",
                    value = bind 'ColorReject',
                    checked_value = 'blue',
                    },
                    f:radio_button {
                    title = "Purple",
                    value = bind 'ColorReject',
                    checked_value = 'purple',
                    },
                },
            },
            f:row{
                spacing = f:control_spacing(),
                f:static_text {
                    fill_horizontal = 1,
                    title = 'Use Rating',
                },
            },
            f:row {
                f:group_box{ 
                    title = "Pick Rating",
                    width = 100,
                    --size = regular,
                    f:radio_button {
                    title = "5",
                    value = bind 'RatingPick', -- all of the buttons bound to the same key
                    checked_value = 5,
                    },
                    f:radio_button {
                    title = "4",
                    value = bind 'RatingPick',
                    checked_value = 4,
                    },
                    f:radio_button {
                    title = "3",
                    value = bind 'RatingPick',
                    checked_value = 3,
                    },
                    f:radio_button {
                    title = "2",
                    value = bind 'RatingPick',
                    checked_value = 2,
                    },
                    f:radio_button {
                    title = "1",
                    value = bind 'RatingPick',
                    checked_value = 1,
                    },
                },
                f:group_box{ 
                    title = "Possible Rating",
                    width = 100,
                    f:radio_button {
                    title = "5",
                    value = bind 'RatingPossible', -- all of the buttons bound to the same key
                    checked_value = 5,
                    },
                    f:radio_button {
                    title = "4",
                    value = bind 'RatingPossible',
                    checked_value = 4,
                    },
                    f:radio_button {
                    title = "3",
                    value = bind 'RatingPossible',
                    checked_value = 3,
                    },
                    f:radio_button {
                    title = "2",
                    value = bind 'RatingPossible',
                    checked_value = 2,
                    },
                    f:radio_button {
                    title = "1",
                    value = bind 'RatingPossible',
                    checked_value = 1,
                    },
                },
                f:group_box{ 
                    title = "Reject Rating",
                    width = 100,
                    enabled = bind 'UseColor',
                    f:radio_button {
                    title = "5",
                    value = bind 'RatingReject', -- all of the buttons bound to the same key
                    checked_value = 5,
                    },
                    f:radio_button {
                    title = "4",
                    value = bind 'RatingReject',
                    checked_value = 4,
                    },
                    f:radio_button {
                    title = "3",
                    value = bind 'RatingReject',
                    checked_value = 3,
                    },
                    f:radio_button {
                    title = "2",
                    value = bind 'RatingReject',
                    checked_value = 2,
                    },
                    f:radio_button {
                    title = "1",
                    value = bind 'RatingReject',
                    checked_value = 1,
                    },
                },
            },
            f:row{
                f:group_box{ 
                    title = "Reset Tags",
                    --width = 100,
                    --enabled = bind 'UseColor',
                    spacing = f:control_spacing(),
                    f:checkbox {
                        title = "Reset Color",
                        value = bind "ResetColor",
                    },
                    f:checkbox {
                        title = "Reset Rating",
                        value = bind "ResetRating",
                    },
                },
            },
            f:row {
                f:push_button {
                    width = 150,
                    title = 'Set to Defaults',
                    enabled = true,
                    action = function()
                        -- Save Prefs Here
                        properties.UseColor = true;
                        properties.ColorPick = "purple";
                        properties.ColorPossible = "green";
                        properties.ColorReject = "red";
                        properties.RatingPick = 5;
                        properties.RatingPossible = 3;
                        properties.RatingReject = 1;
                        properties.ResetRating = false
                        properties.ResetColor = false
                    end,
                },
            },
        },
    }
end

function PluginManager.endDialog(properties)
   local prefs = LrPrefs.prefsForPlugin();
    prefs.UseColor = properties.UseColor;
    logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.UseColor) )
    prefs.ColorPick = properties.ColorPick;
    logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.ColorPick) )
    prefs.ColorPossible = properties.ColorPossible;
    logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.ColorPossible) )
    prefs.ColorReject = properties.ColorReject;
    logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.ColorReject) )
    prefs.RatingPick = properties.RatingPick;
    logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.RatingPick) )
    prefs.RatingPossible = properties.RatingPossible;
    logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.RatingPossible) )
    prefs.RatingReject = properties.RatingReject;
    logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.RatingReject) )
    prefs.ResetColor = properties.ResetColor;
    logger:trace( "Prefs Saved: ResetColor : " .. tostring(properties.ResetColor) )
    prefs.ResetRating = properties.ResetRating;
    logger:trace( "Prefs Saved: ResetRating : " .. tostring(properties.ResetRating) )


end