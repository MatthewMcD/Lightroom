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
    properties.ColorPick = prefs.ColorPick or "red";
    properties.ColorPossible = prefs.ColorPossible or "blue";
    properties.ColorReject = prefs.ColorReject or "green";

    return {
        -- section for the top of the dialog
        {
            title = LOC "$$$/Tags2Flags/Preferences/SettingsHeader=Tags to Flags Converter",
            bind_to_object = properties,
            f:row {
                spacing = f:control_spacing(),
                f:static_text {
                    title = 'Use Color',
                    alignment = 'left',
                    fill_horizontal = 1,
                },
                f:checkbox {
                    title = "Use Color",
                    value = bind "UseColor",
                },
            },
            f:row {
                f:static_text {
                    title = 'Pick Color: ',
                    alignment = 'left',
                },
                f:static_text {
                    title = properties.ColorPick,
                    fill_horizontal = 1,
                },
            },
            f:row {
                f:static_text {
                    title = 'Possible Color: ',
                    alignment = 'left',
                },
                f:static_text {
                    title = properties.ColorPossible,
                    fill_horizontal = 1,
                },
            },
            f:row {
                f:static_text {
                    title = 'Pick Reject: ',
                    alignment = 'left',
                },
                f:static_text {
                    title = properties.ColorReject,
                    fill_horizontal = 1,
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
                        properties.ColorPick = "red";
                        properties.ColorPossible = "yellow";
                        properties.ColorReject = "green";
                    end,
                },
            },
        },
    }
end

function PluginManager.endDialog(properties)
   local prefs = LrPrefs.prefsForPlugin();
   logger:trace( "Prefs Saved: UseColor : " .. tostring(properties.UseColor) )
    prefs.UseColor = properties.UseColor;
    prefs.ColorPick = properties.ColorPick;
    prefs.ColorPossible = properties.ColorPossible;
    prefs.ColorReject = properties.ColorReject;

end