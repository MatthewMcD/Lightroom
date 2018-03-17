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

ExportMenuItem.lua
From the Hello Exif Tool sample plug-in. Displays a modal dialog and reads the ExifTool version info.

------------------------------------------------------------------------------]]

-- Access the Lightroom SDK namespaces.
local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'

--local LrMobdebug = import 'LrMobdebug'

require "ExifUtils"
--LrMobdebug.start()


-- Create the logger and enable the print function.
local myLogger = LrLogger( 'exportLogger' )
myLogger:enable( "print" ) -- Pass either a string or a table of actions.

--------------------------------------------------------------------------------
-- Write trace information to the logger.

local function outputToLog( message )
	myLogger:trace( message )
end

--------------------------------------------------------------------------------
-- Display a modal information dialog.
--TODO : Get the Version of ExifTools
local function showModalDialog()
  local catalog = LrApplication.activeCatalog()
  local targetPhoto = catalog:getTargetPhoto()

	outputToLog( "MyHWExportItem.showModalMessage function entered." )
	local exiftoolsVersion = ExifUtils.versionInfo(targetPhoto)
	LrDialogs.message( "ExifTools Version", exiftoolsVersion, "Info" );
	outputToLog( "MyHWExportItem.showModalMessage function exiting." )
	
end

--------------------------------------------------------------------------------
-- Display a dialog.
LrTasks.startAsyncTask(function() 
--  LrMobdebug.on()
  showModalDialog()
end)


