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

Info.lua
Summary information for Hello ExifTool sample plug-in.

Adds menu items to Lightroom.

------------------------------------------------------------------------------]]

return {
	
	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 1.3, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'com.ableblue.lightroom.tags2flags',

	LrPluginName = LOC "$$$/helloexiftool/PluginName=Hello ExifTool Sample",
	
	-- Add the menu item to the File menu.
	--TODO : Get ExifTool Version
	LrExportMenuItems = {
		title = "Get ExifTool Version",
		file = "GetEXIFToolInfo.lua",
	},

	-- Add the menu item to the Library menu.
	
	LrLibraryMenuItems = {
	    {
			--TODO : Collect and Get Metadata
		    title = LOC "$$$/helloexiftool/CustomDialog=ExifTool Get Property Dialog",
		    file = "GetPropertyDialog.lua",
		},
	},
	VERSION = { major=1, minor=0, revision=0, build=0, },

}


	
