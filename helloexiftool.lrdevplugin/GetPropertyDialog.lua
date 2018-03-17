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

GetPropertyDialog.lua
From the Hello ExifTools sample plug-in. Displays a custom dialog and reads ExifProperty info.

------------------------------------------------------------------------------]]

-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
local LrView = import 'LrView'
local LrApplication = import 'LrApplication'
local LrTasks = import 'LrTasks'

local LrMobdebug = import 'LrMobdebug'

require "ExifUtils"

--[[
	Demonstrates a custom dialog with a simple binding. The dialog displays a
	checkbox and a text field.  When the check box is selected the text field becomes
	enabled, if the checkbox is unchecked then the text field is disabled.
	
	The check_box.value and the edit_field.enabled are bound to the same value in an
	observable table.  When the check_box is checked/unchecked the changes are reflected
	in the bound property 'isChecked'.  Because the edit_field.enabled value is also bound then
	it reflects whatever value 'isChecked' has.
]]
local function showCustomDialog()

	LrFunctionContext.callWithContext( "showCustomDialog", function( context )
	
	    local f = LrView.osFactory()
      local catalog = LrApplication.activeCatalog()
      local targetPhoto = catalog:getTargetPhoto()
      local errorMsg = nil
      local overlay = nil
      local dialogScope = nil
      
	    -- Create a bindable table.  Whenever a field in this table changes
	    -- then notifications will be sent.
	    local props = LrBinding.makePropertyTable( context )
	    props.PropertyName = "Copyright"

	    -- Create the contents for the dialog.
	    local c = f:row {
	
		    -- Bind the table to the view.  This enables controls to be bound
		    -- to the named field of the 'props' table.
		    
		    bind_to_object = props,
				
		    -- Add a checkbox and an edit_field.
		    
		    --f:checkbox {
			  --  title = "Enable",
			  --  value = LrView.bind( "isChecked" ),
		    --},
        f:static_text {
          title = "Property Name:",
          alignment = 'right',
        },
		    f:edit_field {
          title = "PropertyName",
			    value = LrView.bind( "PropertyName" ),
			    enabled = true
		    }
	    }    
      
	    dialogScope = LrDialogs.presentModalDialog {
			    title = "Get EXIF Property",
			    contents = c
		    }

    if (errorMsg ~= nil) then
      LrDialogs.message(errorMsg, nil, nil)
      return
    end
    
    if (dialogScope=="ok") then
      --LrDialogs.message("OK By User")
       	LrMobdebug.start()
        local metadata = ExifUtils.readMetaDataAsTable(targetPhoto)
        
        --LrDialogs.message(props.PropertyName)
        
        local propertyVal = ExifUtils.findFirstMatchingValue(metadata, {props.PropertyName})
        LrDialogs.message(propertyVal)
  
      return
    end
    
    if (dialogScope=="cancel") then
      return
    end
	end) -- end main function

end


-- Now display the dialogs.
LrTasks.startAsyncTask(function()
  showCustomDialog()
end)
