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

Colors2Flags.lua
Code logic for the actual worker performing the set/unset flags based on the UseColors setting. 

Based on the settings chosen by the user, flags are set on every selected photo converting stars and colors to Flags like Picks, Possibles and Rejects.

------------------------------------------------------------------------------]]
local LrApplication = import 'LrApplication'   -- Import LR namespace which provides access to active catalog
local LrDialogs = import 'LrDialogs'   -- Import LR namespace for user dialog functions
local LrTasks = import 'LrTasks'       -- Import functions for starting async tasks
local LrPrefs = import 'LrPrefs' -- Preferences manager
local LrLogger = import 'LrLogger' -- Import functions for logging and debugging
-- local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module
--LrMobdebug.start()          

-- [ ] ToDo : Add Progress
-- [X] ToDo : Add specific UnDo Notation
-- [X] ToDo : Add option to "Reset Rating" or "Change Color" after conversion. 
-- [ ] ToDo : Convert to procedures for easier reading

-- Connect with the ZBS debugger server.
local logger = LrLogger( 'Tags2Flags' )
logger:enable( "print" ) -- or "logfile

local prefs = LrPrefs.prefsForPlugin()

LrTasks.startAsyncTask (function()          -- Certain functions in LR which access the catalog need to be wrapped in an asyncTask.
  -- LrMobdebug.on()                           -- Make this coroutine known to ZBS
   
  catalog = LrApplication.activeCatalog()   -- Get the active LR catalog. 
  
  local color = ""
  local flag = 0
  local rating = 0
  
  --Get all selected photos
  --loop thru them and check color label
  if catalog.targetPhoto then
	for ind, photo in ipairs(catalog.targetPhotos) do
		color = photo:getRawMetadata("colorNameForLabel") -- "red", "yellow", "green", "blue", "purple", "other", or "none"
        flag = photo:getRawMetadata("pickStatus") -- -1 = reject, 0 = none, 1 = pick
        rating = photo:getRawMetadata("rating") -- 0-5
		if rating == nil then
			rating = 0
		end
            	
		-- LrDialogs.message ("Color: " .. color .. " Flag " .. flag .. " Rating:" .. rating .. ".")
		outputToLog("Color=[" .. color .. "] Flag=[" .. flag .. "] Rating=[" .. rating .. "]")
		
		if prefs.UseColor then
			catalog:withWriteAccessDo("Convert Color to Flag", function( context ) 
				outputToLog("Using Color")
				if color == prefs.ColorPick then
				--set 
					--LrDialogs.message ("Color: Pick")
					outputToLog( "Before changing [" .. color .. "] to Pick" )
					photo:setRawMetadata("pickStatus",1)
				elseif color == prefs.ColorPossible then
				-- drop flag
					--LrDialogs.message ("Color: Possible")
					outputToLog( "Before changing [" .. color .. "] to Unflagged" )
					photo:setRawMetadata("pickStatus",0)
				elseif color == prefs.ColorReject then
				-- set reject
					--LrDialogs.message ("Color: Reject")
					outputToLog( "Before changing [" .. color .. "] to Reject" )
					photo:setRawMetadata("pickStatus",-1)
				end
				if prefs.ResetColor then
					outputToLog("Resetting Color")
					photo:setRawMetadata("colorNameForLabel","none")
				end
			end )
		else -- Use rating
			catalog:withWriteAccessDo("Convert Rating to Flag", function( context ) 
				outputToLog("Using Rating")
				if rating == prefs.RatingPick then
				--set 
					--LrDialogs.message ("Rating: Pick")
					photo:setRawMetadata("pickStatus",1)
				elseif rating == prefs.RatingPossible then
				-- drop flag
					--LrDialogs.message ("Rating: Possible")
					photo:setRawMetadata("pickStatus",0)
				elseif rating == prefs.RatingReject then
				-- set reject
					--LrDialogs.message ("Rating: Reject")
					photo:setRawMetadata("pickStatus",-1)
				end
				if prefs.ResetRating then
					outputToLog("Zero rating")
					photo:setRawMetadata("rating",nil)
				end
			end )
		end
     end
  end

end) -- end of startAsyncTask

function outputToLog( message )
	logger:trace( message )
end
