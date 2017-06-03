local LrApplication = import 'LrApplication'   -- Import LR namespace which provides access to active catalog
local LrDialogs = import 'LrDialogs'   -- Import LR namespace for user dialog functions
local LrTasks = import 'LrTasks'       -- Import functions for starting async tasks
local LrPrefs = import 'LrPrefs' -- Preferences manager
local LrLogger = import 'LrLogger' -- Import functions for logging and debugging
-- local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module
--LrMobdebug.start()          

-- [X] ToDo : Settings Page
-- [X] ToDo : Store settings
-- [ ] ToDo : Add Progress
-- [X] ToDo : Add Optional Debugging
-- [X] ToDo : Add to GitHub
-- [ ] ToDo : Add specific UnDo Notation
-- [X] ToDo : Add Deprecated Calls check
-- [X] ToDo : Available only when PhotosSelected
-- [X] ToDo : Add Clear Settings Button
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
		catalog:withWriteAccessDo("Convert Color to Flag", function( context ) 
			if prefs.UseColor then
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
			else -- Use rating
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
			end
		end )
     end
  end

end) -- end of startAsyncTask

function outputToLog( message )
	logger:trace( message )
end
