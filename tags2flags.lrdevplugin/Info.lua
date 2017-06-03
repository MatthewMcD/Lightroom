--[[----------------------------------------------------------------------------

Matthew McDermott
 Copyright 2014 Matthew McDermott
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

--------------------------------------------------------------------------------

Info.lua
Summary information for Photo Mechanic Conversion plug-in.

Aid in converting stars and colors to Flags like Picks, Possibles and Rejects.

------------------------------------------------------------------------------]]

return {
	
	LrSdkVersion = 6.0,
	LrSdkMinimumVersion = 6.0, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'com.ableblue.lightroom.tags2flags',

	LrPluginName = LOC "$$$/Tags2Flags/PluginName=Tags to Flags Converter",
	
	LrInitPlugin = 'PluginInit.lua',

	-- Add the menu item to the Library menu.
	
	LrLibraryMenuItems = {
	    {
		    title = LOC "$$$/Tags2Flags/FileMenuItem=Convert Colors to F&lags",
		    file = "Colors2Flags.lua",
			enabledWhen = "photosSelected",
		},
	
	},
	VERSION = { major=0, minor=3, revision=0, build=0, },
	LrPluginInfoUrl = 'http://www.github.com/MatthewMcD/Lightroom',
	LrPluginInfoProvider = 'PluginInfoProvider.lua',
}


	
