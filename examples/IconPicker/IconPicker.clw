  PROGRAM
! ================================================================================================
!                                    DEVUNA - Icon Picker Class
! ================================================================================================
! Author:  Randy Rogers (KCR) <rrogers@devuna.com>
! Notice : Copyright (C) 2017, Devuna
!          Distributed under the MIT License (https://opensource.org/licenses/MIT)
! ================================================================================================
!    This file is part of Devuna-ctIconPicker (https://github.com/Devuna/Devuna-ctIconPicker 
!
!    Devuna-ctIconPicker is free software: you can redistribute it and/or modify
!    it under the terms of the MIT License as published by
!    the Open Source Initiative.
!
!    Devuna-ctIconPicker is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    MIT License for more details.
!
!    You should have received a copy of the MIT License
!    along with Devuna-ctIconPicker.  If not, see <https://opensource.org/licenses/MIT>.
! ================================================================================================

   MAP
      MODULE('Advapi')
         kcr_RegCloseKey(UNSIGNED),LONG,RAW,PASCAL,NAME('RegCloseKey'),PROC
         kcr_RegOpenKeyEx(UNSIGNED,*CSTRING,ULONG,ULONG,*ULONG),LONG,RAW,PASCAL,NAME('RegOpenKeyExA'),PROC
         kcr_RegQueryValueEx(UNSIGNED,*CSTRING,ULONG,*ULONG,ULONG,*ULONG),LONG,RAW,PASCAL,NAME('RegQueryValueExA'),PROC
      END
      Test()
      GetRoot(*CSTRING szSubKey),STRING
   END
  
   INCLUDE('ctIconPicker.inc'),ONCE
   
   CODE
      Test()
      RETURN
      
Test  PROCEDURE      
thisIconPicker    ctIconPicker
szResourceLibrary CSTRING(261)
szResourceName    CSTRING(261)
szResourceCopy    CSTRING(261)
szVersion         CSTRING(21)
  
Window WINDOW('ctIconPicker Test'),AT(,,360,280),CENTER,GRAY,SYSTEM
      PROMPT('Resource Name'),AT(10,10),USE(?ResourceNamePrompt)
      ENTRY(@S255),AT(65,9,240),USE(szResourceName),DISABLE,FLAT
      BUTTON('Select Icon ...'),AT(140,26,80,32),USE(?ExampleButton),LEFT
   END

  CODE
    OPEN(Window)
    ACCEPT
       CASE EVENT()
         OF EVENT:OpenWindow
            !Find out where Clarion is installed so the example button icon
            !can be set to the same icon as our window which uses the run-time library default         
            szVersion = 'Clarion10'
            szResourceLibrary = GetRoot(szVersion) & '\bin\ClaRUN.dll'
       
            !Initialize the class 
            !Init(Number of buttons in a row, button Width, button Height, horiz/vert spacing, resource file)
            !the resource library can be omitted in which case the class will use the runnung application
            thisIconPicker.Init(8, 32, 32, 5, szResourceLibrary)

            szResourceName = szResourceLibrary & '[11]'   !icon index in ClaRUN.dll
            DISPLAY(?szResourceName)
            ?ExampleButton{PROP:Icon} = szResourceName
            
         OF EVENT:CloseWindow
            CLOSE(Window)
            BREAK
            
         OF EVENT:Accepted   
            szResourceCopy = thisIconPicker.Ask()
            IF szResourceCopy
               IF szResourceCopy = szResourceLibrary
                  szResourceCopy = szResourceCopy & '[11]'
               END
               szResourceName = szResourceCopy
               DISPLAY(?szResourceName)
               Window{PROP:Icon} = szResourceName
               ?ExampleButton{PROP:Icon} = szResourceName
               szResourceCopy = ''
            END   
       END     
    END
    RETURN
    
GetRoot  PROCEDURE(*CSTRING pszVersion)
HKEY_LOCAL_MACHINE   EQUATE(080000002h)
KEY_QUERY_VALUE      EQUATE(00001h)
cc                   LONG
szSubKey             CSTRING(256)
szValueName          CSTRING('root')
phkResult            ULONG
szRoot               CSTRING(256)
dwData               ULONG
dwType               ULONG

   CODE
     szSubKey = 'SOFTWARE\SoftVelocity\' & pszVersion
     cc = kcr_RegOpenKeyEx(HKEY_LOCAL_MACHINE,szSubKey,0,KEY_QUERY_VALUE,phkResult)
     IF ~cc
        dwData = SIZE(szRoot)
        dwType = REG_SZ
        cc = kcr_RegQueryValueEx(phkResult,szValueName,0,dwType,ADDRESS(szRoot),dwData)
        kcr_RegCloseKey(phkResult)               
     END
     RETURN szRoot   