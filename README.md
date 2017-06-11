# ctIconPicker
## Icon Picker Class written in and for Clarion for Windows

## License ##
Distributed under [GPL 3.0](http://www.gnu.org/licenses/gpl-3.0.txt "GPL 3.0")

## ctIconPicker Overview ##
### ctIconPicker Source Files ###

The ctIconPicker source code should be installed to the Clarion \accessory\libsrc\win folder. The ctIconPicker source code and its respective components are contained in:

 
 ctIconPicker.inc
 ctIconPicker declarations
 
 ctIconPicker.clw
 ctIconPicker method definitions
 

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


## ctIconPicker Methods ##


    Init PROCEDURE(LONG nButtonsPerRow, LONG nButtonWidth, LONG nButtonHeight, LONG nButtonOffset, <STRING sLibraryName>),BOOL,PROC,VIRTUAL

----------
**Init** Initializes the ctIconPicker object.

 Parameter | Description |

 ------------ | -----------: |

*nButtonsPerRow* | The number of buttons per row in the IconPicker window. |

*nButtonWidth* | The width of each button in the IconPicker window. |

*nButtonHeight* | The height of each button in the IconPicker window. |

*nButtonOffset* | The horizontal and vertical margins between of each button in the IconPicker window. |

*sLibraryName* | The name of the library (*.EXE, *.DLL) containing icons for selection.  If this parameter is omitted, the current executable is used. |

----------
    Ask  PROCEDURE(),STRING,VIRTUAL

----------


The **Ask** method initiates the event processing (ACCEPT loop) for the IconPicker class. This virtual method handles creating the IconPicker window and returns the *ResourceName* of the icon selected by the user.

----------
    GetButtonsPerRow PROCEDURE(),LONG,VIRTUAL

----------
    SetButtonsPerRow PROCEDURE(LONG nValue),VIRTUAL

----------
    GetButtonWidth   PROCEDURE(),LONG,VIRTUAL

----------
    SetButtonWidth   PROCEDURE(LONG nValue),VIRTUAL

----------
    GetButtonHeight  PROCEDURE(),LONG,VIRTUAL

----------
    SetButtonHeight  PROCEDURE(LONG nValue),VIRTUAL

----------
    GetButtonOffset  PROCEDURE(),LONG,VIRTUAL

----------
    SetButtonOffset  PROCEDURE(LONG nValue),VIRTUAL

----------
    GetResourceName  PROCEDURE(),STRING,VIRTUAL

----------
    GetResourceIndex PROCEDURE(STRING ResourceName),LONG,VIRTUAL

----------
    GetResourceIndex PROCEDURE(*CSTRING ResourceName),LONG,VIRTUAL

----------
    FindResourceIndex PROCEDURE(STRING LibraryName, STRING ResourceName),LONG,VIRTUAL

----------
## Release Notes ##
### ctIconPicker Initial Public Release - June 10th 2017 ###

