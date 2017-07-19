!ABCIncludeFile(ABC)
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

  OMIT('EndDefine',_ctIconPicker_)
_ctIconPicker_  EQUATE(1)

!************************************************************************
!
!  Module:         ctIconPicker.inc
!
!
!  Description:
!
!************************************************************************


!*
!* Includes
!*

  OMIT('EndOmit',_AI_API_)
      INCLUDE('svapi.inc'),ONCE
  !EndOmit

!*
!* Defines
!*

ctIconPicker    CLASS(),TYPE,MODULE('ctIconPicker.clw'),LINK('ctIconPicker.clw', _ABCLinkMode_),DLL(_ABCDllMode_)
m_rcParent           LIKE(_RECT_),PRIVATE
m_ResourceName       CSTRING(261),PRIVATE
m_ResourceIndex      LONG,PRIVATE
m_nButtonsPerRow     LONG,PRIVATE
m_nButtonWidth       LONG,PRIVATE
m_nButtonHeight      LONG,PRIVATE
m_nButtonOffset      LONG,PRIVATE

Construct            PROCEDURE
Destruct             PROCEDURE,VIRTUAL
Ask                  PROCEDURE(),STRING,VIRTUAL
Init                 PROCEDURE(LONG nButtonsPerRow, LONG nButtonWidth, LONG nButtonHeight, LONG nButtonOffset, <STRING sLibraryName>),BOOL,PROC,VIRTUAL
GetButtonsPerRow     PROCEDURE(),LONG,VIRTUAL
SetButtonsPerRow     PROCEDURE(LONG nValue),VIRTUAL
GetButtonWidth       PROCEDURE(),LONG,VIRTUAL
SetButtonWidth       PROCEDURE(LONG nValue),VIRTUAL
GetButtonHeight      PROCEDURE(),LONG,VIRTUAL
SetButtonHeight      PROCEDURE(LONG nValue),VIRTUAL
GetButtonOffset      PROCEDURE(),LONG,VIRTUAL
SetButtonOffset      PROCEDURE(LONG nValue),VIRTUAL
GetResourceName      PROCEDURE(),STRING,VIRTUAL
GetResourceIndex     PROCEDURE(STRING ResourceName),LONG,VIRTUAL
GetResourceIndex     PROCEDURE(*CSTRING ResourceName),LONG,VIRTUAL
FindResourceIndex    PROCEDURE(STRING LibraryName, STRING ResourceName),LONG,VIRTUAL

                END

!EndDefine

