## ctIconPicker Methods ##

    Init PROCEDURE(LONG nButtonsPerRow, LONG nButtonWidth, LONG nButtonHeight, LONG nButtonOffset, <STRING sLibraryName>),BOOL,PROC,VIRTUAL

----------

**Init** Initializes the ctIconPicker object. Always returns TRUE.

***nButtonsPerRow*** LONG - The number of buttons per row in the IconPicker window.

***nButtonWidth*** LONG - The width of each button in the IconPicker window.

***nButtonHeight*** LONG - The height of each button in the IconPicker window.

***nButtonOffset*** LONG - The horizontal and vertical margins between of each button in the IconPicker window.

***sLibraryName*** STRING - The name of the library (*.EXE, *.DLL) containing icons for selection.  If this parameter is omitted, the current executable is used.

**Return Data Type:** BOOL

----------

    Ask  PROCEDURE(),STRING,VIRTUAL


The **Ask** method initiates the event processing (ACCEPT loop) for the IconPicker class. This virtual method handles creating the IconPicker window and returns the *ResourceName* of the icon selected by the user.

**Return Data Type:** STRING

----------

    GetButtonsPerRow PROCEDURE(),LONG,VIRTUAL

The **GetButtonsPerRow** method retrieves the current number of buttons per row property.

**Return Data Type:** LONG

----------

    SetButtonsPerRow PROCEDURE(LONG nValue),VIRTUAL

The **SetButtonsPerRow** method sets the number of buttons per row property.

----------

    GetButtonWidth   PROCEDURE(),LONG,VIRTUAL

The **GetButtonWidth** method retrieves the current button width property.
 
**Return Data Type:** LONG

----------

    SetButtonWidth   PROCEDURE(LONG nValue),VIRTUAL

The **SetButtonWidth** method sets the button width property.

----------

    GetButtonHeight  PROCEDURE(),LONG,VIRTUAL

The **GetButtonHeight** method retrieves the current button height property.
 
**Return Data Type:** LONG

----------

    SetButtonHeight  PROCEDURE(LONG nValue),VIRTUAL

The **SetButtonHeight** method sets the button height property.

----------

    GetButtonOffset  PROCEDURE(),LONG,VIRTUAL

The **GetButtonOffset** method retrieves the current button offset (horizontal and vertical margin) property.
 
**Return Data Type:** LONG

----------

    SetButtonOffset  PROCEDURE(LONG nValue),VIRTUAL

The **SetButtonOffset** method sets the button offset (horizontal and vertical margin) property.

----------

    GetResourceName  PROCEDURE(),STRING,VIRTUAL

The **GetResourceName** method gets name of the currently selected image file.

**Return Data Type:** STRING

----------

    GetResourceIndex PROCEDURE(STRING ResourceName),LONG,VIRTUAL

**GetResourceIndex** Looks for *ResourceName* in the currently running application.  Returns the Index of *ResourceName* or -1 if not found.

***ResourceName*** STRING - The name of the resource to find. *ResourceName* must start with '~', e.g. '~MyIcon.ico'

**Return Data Type:** LONG

----------

    GetResourceIndex PROCEDURE(*CSTRING ResourceName),LONG,VIRTUAL

**GetResourceIndex** Looks for *ResourceName* in the currently running application.  Returns the Index of *ResourceName* or -1 if not found.

***ResourceName*** CSTRING - The name of the resource to find. *ResourceName* must start with '~', e.g. '~MyIcon.ico'

**Return Data Type:** LONG

----------

    FindResourceIndex PROCEDURE(STRING LibraryName, STRING ResourceName),LONG,VIRTUAL

**FindResourceIndex** Looks for *ResourceName* in *LibraryName*.  Returns the Index of *ResourceName* within *LibraryName* or -1 if not found.

***LibraryName*** STRING - The full path and name of the Clarion Library (*.EXE, *.DLL) to search. *ResourceName* must be an EXE or DLL compiled with Clarion for Windows.

***ResourceName*** STRING - The name of the resource to find. *ResourceName* must start with '~', e.g. '~MyIcon.ico'

**Return Data Type:** LONG


