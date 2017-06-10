  MEMBER
! ================================================================================================
!                                    DEVUNA - Icon Picker Class
! ================================================================================================
! Author:  Randy Rogers (KCR) <rrogers@devuna.com>
! Notice:  Copyright (C) 2017, Devuna
!          Distributed under LGPLv3 (http://www.gnu.org/licenses/lgpl.html) 
! ================================================================================================
!    This file is part of Devuna-ctIconPicker (https://github.com/Devuna/Devuna-ctIconPicker)         
! 
!    ctIconPicker is free software: you can redistribute it and/or modify 
!    it under the terms of the GNU General Public License as published by 
!    the Free Software Foundation, either version 3 of the License, or 
!    (at your option) any later version. 
! 
!    ctIconPicker is distributed in the hope that it will be useful, 
!    but WITHOUT ANY WARRANTY; without even the implied warranty of 
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
!    GNU General Public License for more details. 
! 
!    You should have received a copy of the GNU General Public License 
!    along with ctIconPicker.  If not, see <http://www.gnu.org/licenses/>. 
! ================================================================================================

!**********************************************************************
!
!   Module:         ctIconPicker.clw
!
!**********************************************************************

!========================================================!
!*  Includes
!========================================================!
      INCLUDE('ctIconPicker.inc'),ONCE

!========================================================!
!*  Equates
!========================================================!
!  LoadLibraryEx Flags
DONT_RESOLVE_DLL_REFERENCES            EQUATE(000000001h)
LOAD_LIBRARY_AS_DATAFILE               EQUATE(000000002h)
LOAD_WITH_ALTERED_SEARCH_PATH          EQUATE(000000008h)
GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS EQUATE(000000004h)

DWORD                                  EQUATE(LONG)
HANDLE                                 EQUATE(LONG)
HINSTANCE                              EQUATE(HANDLE)
HMODULE                                EQUATE(HANDLE)

!========================================================!
!*  Declarations
!========================================================!
hInstance            HINSTANCE,THREAD
hKernel              HMODULE,THREAD
szApplicationName    CSTRING(261),THREAD
szLibraryName        CSTRING(261),THREAD
ResourceNamesQueue   QUEUE,PRE(ResourceNamesQueue),THREAD
ResourceName            CSTRING(261)
feq                     LONG
                     END

!========================================================!
!*  Function Prototypes
!========================================================!
   MAP
      MODULE('PROCTYPES')
        ENUMRESNAMEPROC(HMODULE hModule, ULONG lpType, ULONG lpName, LONG lParam),BOOL,PASCAL,TYPE
      END
      MODULE('kernel32')
         kcr_EnumResourceNames(HINSTANCE,ULONG,ENUMRESNAMEPROC,LONG),BOOL,PASCAL,RAW,NAME('EnumResourceNamesA'),PROC
         kcr_FreeLibrary(HINSTANCE hInst),BOOL,PASCAL,PROC,NAME('FreeLibrary')
         kcr_GetModuleFileName(HMODULE hModule, *CSTRING lpFilename, DWORD nSize),DWORD,PASCAL,RAW,NAME('GetModuleFileNameA'),PROC
         kcr_GetModuleHandleEx(DWORD dwFlags, LONG lpModuleName, *HMODULE phModule),BOOL,PASCAL,RAW,PROC,DLL(__GetModuleHandleEx)
         kcr_GetProcAddress(HMODULE hModule, *CSTRING lpProcName),LONG,PASCAL,RAW,NAME('GetProcAddress')
         kcr_GetSystemMetrics(SIGNED),SIGNED,PASCAL,NAME('GetSystemMetrics')
         kcr_GetWindowRect(HWND hWnd,*_RECT_ lpRect),RAW,PASCAL,PROC,NAME('GetWindowRect')
         kcr_LoadLibraryEx(*CSTRING lpszLibraryName, HANDLE hReserved, DWORD dwFlags),HINSTANCE,PASCAL,RAW,NAME('LoadLibraryExA')
         kcr_SetWindowPos(HWND hWnd, HWND hwndInsertAfter, ULONG x, ULONG y, ULONG cx, ULONG cy, USHORT uFlags),RAW,PASCAL,NAME('SetWindowPos')
      END
      EnumResourceNamesFunc(HMODULE hModule, ULONG lpType, ULONG lpName, LONG lParam),BOOL,PASCAL
   END

__GetModuleHandleEx   LONG,AUTO,NAME('kcr_GetModuleHandleEx')

!========================================================!
! ctIconPicker implementation                             !
!========================================================!
ctIconPicker.Construct             PROCEDURE()
szProcName     CSTRING('GetModuleHandleExA')
szKernel       CSTRING('Kernel32.dll')
hModule        HANDLE
   CODE
      hInstance = SYSTEM{PROP:AppInstance}

      hKernel = kcr_LoadLibraryEx(szKernel, 0, 0)  !LOAD_LIBRARY_AS_DATAFILE)
      IF hKernel <> 0
         __GetModuleHandleEx = kcr_GetProcAddress(hKernel, szProcName)
      END
      RETURN

ctIconPicker.Destruct              PROCEDURE()   !,VIRTUAL
   CODE
      IF hKernel <> 0
         kcr_FreeLibrary(hKernel)
         __GetModuleHandleEx = 0
      END
      RETURN

ctIconPicker.Init                  PROCEDURE(LONG nButtonsPerRow, LONG nButtonWidth, LONG nButtonHeight, LONG nButtonOffset)   !,BOOL   !,VIRTUAL
   CODE
      SELF.m_ResourceName = ''
      SELF.SetButtonsPerRow(nButtonsPerRow)
      SELF.SetButtonWidth(nButtonWidth)
      SELF.SetButtonHeight(nButtonHeight)
      SELF.SetButtonOffset(nButtonOffset)
      RETURN TRUE

ctIconPicker.Ask                   PROCEDURE()   !,VIRTUAL
hModule              HANDLE
hIcon                ULONG

Window WINDOW('Select Icon...'),AT(,,320,240),CENTER,VSCROLL,GRAY,SYSTEM !,DOCK(DOCK:float),DOCKED(DOCK:float),TOOLBOX,
       MENUBAR
         MENU('&File'),USE(?File)
           ITEM('&Open...'),USE(?FileOpen)
           ITEM,SEPARATOR
           ITEM('&Close'),USE(?FileClose),STD(STD:Close)
         END
       END
     END

   CODE
      kcr_GetWindowRect(0{PROP:Handle},SELF.m_rcParent)

      kcr_GetModuleFileName(hInstance, szApplicationName, SIZE(szApplicationName))

      FREE(ResourceNamesQueue)

      IF szLibraryName <> '' AND UPPER(SUB(szLibraryName,LEN(szLibraryName)-2,3)) <> 'ICO'
         hModule = kcr_LoadLibraryEx(szLibraryName, 0, LOAD_LIBRARY_AS_DATAFILE)
         IF hModule <> 0
            kcr_EnumResourceNames(hModule,RT_GROUP_ICON,EnumResourceNamesFunc,0)
            kcr_FreeLibrary(hModule)
         END
      ELSIF __GetModuleHandleEx <> 0      !GetModuleHandleEx is available [not available on win 98]
         kcr_GetModuleHandleEx(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS,ADDRESS(EnumResourceNamesFunc),hModule)
         IF hModule <> 0
            kcr_GetModuleFileName(hModule, szLibraryName, SIZE(szLibraryName))
            kcr_EnumResourceNames(hModule,RT_GROUP_ICON,EnumResourceNamesFunc,0)
         END
      END
      IF hModule = 0
         hModule = hInstance
         kcr_EnumResourceNames(hModule,RT_GROUP_ICON,EnumResourceNamesFunc,0)
      END

      OPEN(Window)
      Window{PROP:Hide} = TRUE
      
      ACCEPT
         CASE EVENT()
           OF EVENT:OpenWindow
              DO CreateButtons
           OF EVENT:CloseWindow
              DO DestroyButtons
           OF EVENT:Accepted
              CASE ACCEPTED()
                OF ?FileOpen
                   IF FILEDIALOG(,szLibraryName,'Library (*.dll,*.exe)|*.dll;*.exe|Icon (*.ico)|*.ico',FILE:KeepDir+FILE:LongName)
                      DO DestroyButtons
                      IF UPPER(SUB(szLibraryName,LEN(szLibraryName)-2,3)) = 'ICO'
                         ResourceNamesQueue.ResourceName = szLibraryName
                         SELF.m_ResourceName = ResourceNamesQueue.ResourceName
                         POST(EVENT:CloseWindow)
                      ELSE
                         hModule = kcr_LoadLibraryEx(szLibraryName, 0, LOAD_LIBRARY_AS_DATAFILE)
                         kcr_EnumResourceNames(hModule,RT_GROUP_ICON,EnumResourceNamesFunc,0)
                         IF hModule <> 0
                            DO CreateButtons
                            kcr_FreeLibrary(hModule)
                            hModule = 0
                         END
                      END
                   END
              ELSE
                 ResourceNamesQueue.feq = ACCEPTED()
                 GET(ResourceNamesQueue,+ResourceNamesQueue.feq)
                 IF ~ERRORCODE()
                    SELF.m_ResourceIndex = POINTER(ResourceNamesQueue) - 1
                    IF ResourceNamesQueue.ResourceName[1] = '~'
                       SELF.m_ResourceName = ResourceNamesQueue.ResourceName
                    ELSE
                       SELF.m_ResourceName = LONGPATH(ResourceNamesQueue.ResourceName)
                    END
                    POST(EVENT:CloseWindow)
                 ELSE
                 END
              END
         END
      END
      RETURN SELF.m_ResourceName

CreateButtons  ROUTINE
   DATA
I              LONG,AUTO
J              LONG,AUTO
nRow           LONG(1)
nCol           LONG(1)
nColMax        LONG(8)
x              LONG
y              LONG
w              LONG(20)
h              LONG(20)
z              LONG(2)
pixelWidth     LONG
pixelHeight    LONG
maxPixelWidth  LONG
maxPixelHeight LONG

   CODE
      nColMax = SELF.GetButtonsPerRow()
      w       = SELF.GetButtonWidth()
      h       = SELF.GetButtonHeight()
      z       = SELF.GetButtonOffset()
      J       = RECORDS(ResourceNamesQueue)

      !------------------------------------------------------------------------
      !  resize and center the window
      !------------------------------------------------------------------------
      maxPixelWidth  = (SELF.m_rcParent.Right  - SELF.m_rcParent.Left) - 40
      maxPixelHeight = (SELF.m_rcParent.Bottom - SELF.m_rcParent.Top) - 40

      Window{PROP:Width}  = (nColMax * ( w + z)) + z
      Window{PROP:Pixels} = TRUE
      pixelWidth = Window{PROP:Width}
      Window{PROP:Pixels} = FALSE
      IF pixelWidth > maxPixelWidth
         nColMax = INT((Window{PROP:Width} - z) / ( w + z))
         Window{PROP:Width}  = (nColMax * ( w + z)) + z
      END

      IF J % nColMax > 0
         Window{PROP:Height} = ((INT(J / nColMax) + 1) * (h + z)) + z
      ELSE
         Window{PROP:Height} = ((J / nColMax) * (h + z)) + z
      END

      Window{PROP:Pixels} = TRUE
      pixelHeight = Window{PROP:Height}
      IF pixelHeight > maxPixelHeight
         Window{PROP:Height} = maxPixelHeight
         Window{PROP:Width}  = Window{PROP:Width} + kcr_GetSystemMetrics(SM_CXVSCROLL)
      END
      Window{PROP:Pixels} = FALSE

      Window{PROP:Pixels} = TRUE
      x = ((SELF.m_rcParent.Right  - SELF.m_rcParent.Left) - Window{PROP:Width} ) / 2
      y = ((SELF.m_rcParent.Bottom - SELF.m_rcParent.Top)  - Window{PROP:Height}) / 2
      Window{PROP:Pixels} = FALSE

      kcr_SetWindowPos(Window{PROP:Handle},0,SELF.m_rcParent.Left + x,SELF.m_rcParent.Top + y,0,0,SWP_NOSIZE+SWP_NOZORDER)
      Window{PROP:Hide} = FALSE
      !------------------------------------------------------------------------


      !------------------------------------------------------------------------
      !  Create buttons with icons
      !------------------------------------------------------------------------
      LOOP I = 1 TO J
         GET(ResourceNamesQueue,I)
         ResourceNamesQueue.feq = CREATE(0,CREATE:BUTTON)
         PUT(ResourceNamesQueue)

         IF ResourceNamesQueue.ResourceName[1] = '~' AND szApplicationName <> szLibraryName
            ResourceNamesQueue.feq{PROP:Icon} = szApplicationName & '[' & I-1 & ']'
         ELSE
            ResourceNamesQueue.feq{PROP:Icon} = ResourceNamesQueue.ResourceName
         END
         ResourceNamesQueue.feq{PROP:Tip} = ResourceNamesQueue.ResourceName
         ResourceNamesQueue.feq{PROP:Scroll} = TRUE

         IF nCol > nColMax
            nCol = 1
            nRow += 1
         END
         x = z + ((w + z) * (nCol - 1))
         y = z + ((h + z) * (nRow - 1))
         SETPOSITION(ResourceNamesQueue.feq,x,y,w,h)

         UNHIDE(ResourceNamesQueue.feq)

         nCol += 1
      END
   EXIT

DestroyButtons ROUTINE
   DATA
I     LONG,AUTO
J     LONG,AUTO

   CODE
      J = RECORDS(ResourceNamesQueue)
      LOOP I = 1 TO J
         GET(ResourceNamesQueue,I)
         DESTROY(ResourceNamesQueue.feq)
         ResourceNamesQueue.feq = 0
         PUT(ResourceNamesQueue)
      END
      FREE(ResourceNamesQueue)
      EXIT

!========================================================!
! Property Accessors                                     !
!========================================================!
ctIconPicker.GetButtonsPerRow     PROCEDURE() !,LONG
   CODE
      RETURN SELF.m_nButtonsPerRow

ctIconPicker.SetButtonsPerRow     PROCEDURE(LONG nValue)
   CODE
      SELF.m_nButtonsPerRow = nValue
      RETURN

ctIconPicker.GetButtonWidth       PROCEDURE() !,LONG
   CODE
      RETURN SELF.m_nButtonWidth

ctIconPicker.SetButtonWidth       PROCEDURE(LONG nValue)
   CODE
      SELF.m_nButtonWidth = nValue
      RETURN

ctIconPicker.GetButtonHeight      PROCEDURE() !,LONG
   CODE
      RETURN SELF.m_nButtonHeight

ctIconPicker.SetButtonHeight      PROCEDURE(LONG nValue)
   CODE
      SELF.m_nButtonHeight = nValue
      RETURN

ctIconPicker.GetButtonOffset      PROCEDURE() !,LONG
   CODE
      RETURN SELF.m_nButtonOffset

ctIconPicker.SetButtonOffset      PROCEDURE(LONG nValue)
   CODE
      SELF.m_nButtonOffset = nValue
      RETURN

ctIconPicker.GetResourceName      PROCEDURE() !,STRING,VIRTUAL
   CODE
      RETURN SELF.m_ResourceName


ctIconPicker.GetResourceIndex     PROCEDURE(STRING ResourceName) !,LONG,VIRTUAL
I                 LONG
szResourceName    &CSTRING
   CODE
     szResourceName &= NEW CSTRING(SIZE(ResourceName)+1)
     szResourceName = ResourceName
     I = SELF.GetResourceIndex(szResourceName)
     DISPOSE(szResourceName)
     RETURN I

ctIconPicker.GetResourceIndex     PROCEDURE(*CSTRING ResourceName) !,LONG,VIRTUAL
I     LONG
J     LONG
   CODE
      IF ResourceName[1] = '~'
         FREE(ResourceNamesQueue)
         kcr_EnumResourceNames(SYSTEM{PROP:AppInstance},RT_GROUP_ICON,EnumResourceNamesFunc,0)
         J = RECORDS(ResourceNamesQueue)
         LOOP I = 1 TO J
            GET(ResourceNamesQueue,I)
            IF ResourceNamesQueue.ResourceName = UPPER(ResourceName)
               BREAK
            END
         END
         IF I > J
            RETURN -1
         ELSE
            RETURN I - 1
         END
      ELSE
         RETURN -1
      END

ctIconPicker.FindResourceIndex     PROCEDURE(STRING LibraryName, STRING ResourceName) !,LONG,VIRTUAL
I              LONG
hModule        HANDLE
   CODE
      IF ResourceName[1] = '~'
         szLibraryName = LibraryName
         hModule = kcr_LoadLibraryEx(szLibraryName, 0, LOAD_LIBRARY_AS_DATAFILE)
         hInstance = hModule
         FREE(ResourceNamesQueue)
         kcr_EnumResourceNames(hModule,RT_GROUP_ICON,EnumResourceNamesFunc,0)
         LOOP I = 1 TO RECORDS(ResourceNamesQueue)
            GET(ResourceNamesQueue,I)
            IF ResourceNamesQueue.ResourceName = UPPER(ResourceName)
               BREAK
            END
         END
         IF I > RECORDS(ResourceNamesQueue)
            I = -1   !not found
         ELSE
            I -= 1   !base 0
         END
         kcr_FreeLibrary(hModule)
         hInstance = SYSTEM{PROP:AppInstance}
         RETURN I
      ELSE
         RETURN -1
      END

!========================================================!
! Utility functions                                      !
!========================================================!
EnumResourceNamesFunc   PROCEDURE(HMODULE hModule, ULONG lpType, ULONG lpName, LONG lParam)  !,BOOL,PASCAL
szResource           &CSTRING
n        long
   CODE
      IF lpName > 0FFFFh
         szResource &= (lpName)
         n = len(clip(szResource))
         IF hModule = hInstance AND LEN(CLIP(szResource)) > 3
            ResourceNamesQueue.ResourceName = '~' & szResource
            ResourceNamesQueue.ResourceName[LEN(ResourceNamesQueue.ResourceName)-3] = '.'
         ELSE
            ResourceNamesQueue.ResourceName = szLibraryName & '[' & RECORDS(ResourceNamesQueue) & ']'
         END
      ELSE
         IF hModule = hInstance
            MESSAGE('OOPS')
         ELSE
            ResourceNamesQueue.ResourceName = szLibraryName & '[' & RECORDS(ResourceNamesQueue) & ']'
         END
      END
      ADD(ResourceNamesQueue)
      RETURN TRUE

