# ctIconPicker
## Icon Picker Class written in and for Clarion for Windows

## License ##
Distributed under [GPL 3.0](http://www.gnu.org/licenses/gpl-3.0.txt "GPL 3.0")

## ctIconPicker Overview ##

In some of our applications we allowed the user to create 'user-defined' buttons to call their favorite programs, WORD.EXE e.g.  ctIconPicker is a class we developed to allow the user to associate an icon resources with their buttons.

The class provides an example of using PROCTYPE and the Windows [EnumResourceNames](https://msdn.microsoft.com/en-us/library/windows/desktop/ms648037(v=vs.85).aspx "EnumResourceNames function") function which takes a FUNCTION as one of its parameters.

### ctIconPicker Screen Shot ###

![Screen Capture](https://github.com/Devuna/Devuna-ctIconPicker/images/ctIconPicker.png)

### ctIconPicker Source Files ###

The ctIconPicker source code should be installed to the Clarion \accessory\libsrc\win folder. The ctIconPicker source code and its respective components are contained in:

 
 **ctIconPicker.inc** ctIconPicker declarations
 
 **ctIconPicker.clw** ctIconPicker method definitions
 
### ctIconPicker Conceptual Example ###

Please see the IconPicker project for an example that  shows a typical sequence of statements to declare, instantiate, initialize, use, and terminate a ctIconPicker object.

## ctIconPicker Properties ##

### ButtonsPerRow ###

	m_nButtonsPerRow     LONG,PRIVATE

The number of buttons per row in the IconPicker window.

See [Get/Set]ButtonsPerRow methods.

### ButtonWidth ###

	m_nButtonWidth       LONG,PRIVATE

The width of each button in the IconPicker window.

See [Get/Set]ButtonWidth methods.

### ButtonHeight ###

	m_nButtonHeight      LONG,PRIVATE

The height of each button in the IconPicker window.

See [Get/Set]ButtonHeight methods.

### ButtonOffset ###

	m_nButtonOffset      LONG,PRIVATE

The horizontal and vertical margins between of each button in the IconPicker window.

See [Get/Set]ButtonOffset methods.

### ResourceName ###

    m_ResourceName   CSTRING(261),PRIVATE

The name of the currently selected image file.

See the GetResourceName method.

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

----------
## Release Notes ##
1. June 11, 2017 - README.md updated 
2. June 10, 2017 - ctIconPicker Initial Public Release 

