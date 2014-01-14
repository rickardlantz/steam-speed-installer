#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=SSI.ico
#AutoIt3Wrapper_Res_Comment=Steam Speed Installer is a simple application that allows the user to save copies of their steam game files for a later installation.
#AutoIt3Wrapper_Res_Description=Steam Speed Installer is a simple application that allows the user to save copies of their steam game files for a later installation.
#AutoIt3Wrapper_Res_Fileversion=0.2.0.0
#AutoIt3Wrapper_Res_Field=Made By|Rickard Lantz
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #AutoIt3Wrapper_Outfile=..\SSI.exe
;~ #AutoIt3Wrapper_Outfile_x64=..\SSI.exe
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         Rickard Lantz

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <String.au3>
#include <GuiListView.au3>
#include <File.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <ComboConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$sAppTitle = "Steam Speed Installer"
$sAppVersion = "0.2"
$sAppInformation = "Version " & $sAppVersion & @TAB & " by Rickard Lantz"

$sRegistryK_Steam = "HKEY_CURRENT_USER\Software\Valve\Steam"
$sRegistryV_Steam_Path = "SteamPath"

$sPath_DataDir = @ScriptDir & "\SSI_Data"
ConsoleWrite($sPath_DataDir & @LF)
$sPath_SteamInstallDir = ""
$sPath_SteamInstallDir = RegRead($sRegistryK_Steam, $sRegistryV_Steam_Path)
$sPath_SteamInstallDir = StringReplace($sPath_SteamInstallDir, "/", "\")
$sPath_SteamApps = "C:\Program Files (x86)\Steam\steamapps"
$sPath_StoredGames = $sPath_DataDir & "\Games"
$sPath_StoredGamesArbitrary = "\SSI_Data\Games"

$sPath_SteamIcons = $sPath_SteamInstallDir & "\steam\games"

$sFile_SteamConfig = $sPath_SteamInstallDir & "\config\config.vdf"
ConsoleWrite("Config expected at: " & $sFile_SteamConfig & @LF)
$sFile_ReadMe = $sPath_DataDir & "\readme.txt"
$sFile_GamesINI = $sPath_DataDir & "\Games.ini"
$sFile_SettingsINI = $sPath_DataDir & "\SSI.ini"

$sLocalListColumns = "Steam ID|Name|Currently Installed|Path|Size"
$sStoredListColumns = "Steam ID|Name|Timestamp|Comments|Path|Size"

_Setup()
;~ $sReadMe = "Read me!" & @CRLF & _
;~ "Steam Speed Installer is a simple application that allows the user to save copies of their steam game files for a later installation." & @CRLF &@CRLF & _
;~ "The copied game can be installed on the same computer or on another computer; this allows many users to install the same game without having to download it several times." & @CRLF &@CRLF & _
;~ "Your currently installed games will be listed in the “Local Games” list, click “Store Local Game” to save it. (The game will be saved to the folder “StoredGames” in the same directory as this file." & @CRLF &@CRLF & _
;~ "Your stored games will be listed in the “Stored Games” list, click “Install Stored Game” to install it. (Note that you will still have to install the game via Steam. However, steam should detect that all files are present, and skip downloading)."


$iLoopDelay = IniRead($sFile_SettingsINI, "Settings", "LoopPollingDelay", 100)
$sReadMe = FileRead($sFile_ReadMe)

$iListViewStyles = BitOR($LVS_REPORT, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS)
$iListViewExStyles = BitOR($LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES)

$iParentGuiStyles = BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX)
$iParentGuiExStyles = -1

$iChildGuiStyles = BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX)
$iChildGuiExStyles = -1

$iMiniGuiStyles = BitOR($GUI_SS_DEFAULT_GUI, 0)
$iMiniGuiExStyles = $WS_EX_TOPMOST

Global $hStatusForm




#region ### START Koda GUI section ### Form=F:\SteamSpeedInstaller\Form1.kxf
$hMainWindow = GUICreate($sAppTitle & " " & $sAppVersion, 1158, 760, Default, Default, $iParentGuiStyles, $iParentGuiExStyles)
GUISetBkColor(0x3A3B3D)
$Label1 = GUICtrlCreateLabel($sAppTitle, 8, 8, 279, 32)
GUICtrlSetFont(-1, 18, 800, 0, "American Typewriter")
GUICtrlSetColor(-1, 0xFFFFFF)
$hInformation = GUICtrlCreateEdit("", 8, 40, 281, 657, BitOR($WS_VSCROLL, $ES_READONLY))
GUICtrlSetBkColor(-1, 0x3A3B3D)
GUICtrlSetData(-1, $sReadMe)
GUICtrlSetFont(-1, 14, 400, 0, "Calibri")
GUICtrlSetColor(-1, 0xFFFFFF)
$Group1 = GUICtrlCreateGroup("Local Games", 304, 32, 841, 321)
GUICtrlSetFont(-1, 14, 800, 0, "Courier New")
GUICtrlSetColor(-1, 0xFFFFFF)
$hListLocal = GUICtrlCreateListView($sLocalListColumns, 320, 56, 810, 286, $iListViewStyles, $iListViewExStyles)
GUICtrlSetBkColor(-1, 0x3A3B3D)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Stored Games", 304, 384, 841, 313)
GUICtrlSetFont(-1, 14, 800, 0, "Courier New")
GUICtrlSetColor(-1, 0xFFFFFF)
$hListStored = GUICtrlCreateListView($sStoredListColumns, 320, 408, 810, 278, $iListViewStyles, $iListViewExStyles)
GUICtrlSetBkColor(-1, 0x3A3B3D)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$hInstallStored = GUICtrlCreateButton("Install Stored Game", 944, 360, 203, 25)
GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808080)
$hStoreLocal = GUICtrlCreateButton("Store Local Game", 736, 360, 203, 25)
GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808080)
$hChangeDescription = GUICtrlCreateButton("Change Description", 512, 360, 219, 25)
GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808080)
;~ $hRefresh = GUICtrlCreateButton("Refresh", 1016, 8, 131, 25)
;~ GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
;~ GUICtrlSetColor(-1, 0xFFFFFF)
;~ GUICtrlSetBkColor(-1, 0x808080)
$hDelete = GUICtrlCreateButton("Delete From Storage", 304, 360, 203, 25)
GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808080)
$hAppInformation = GUICtrlCreateLabel($sAppInformation, 304, 8, 400, 26)
GUICtrlSetFont(-1, 12, 800, 0, "Trebuchet MS")
GUICtrlSetColor(-1, 0x808080)
$hMultiThreadCopy = GUICtrlCreateCheckbox("Use multi-threaded copying", 920, 8, 843, 26)
GUICtrlSetTip(-1, "Multi-threaded copying can dramatically increase copying performance on multi-threaded platforms, especially when copying over network." & @CRLF & "Note that it can also cause some fragmentation on normal hard drives.", "About Multi-threaded copying", 1)
GUICtrlSetFont(-1, 12, 800, 0, "Trebuchet MS")
GUICtrlSetColor(-1, 0xFFFFFF)
$hMetaData = GUICtrlCreateLabel("", 8, 705, 1136, 26)
GUICtrlSetFont(-1, 12, 800, 0, "Trebuchet MS")
GUICtrlSetColor(-1, 0x808080)
GUISetState(@SW_SHOW)
;~ GUISetState(@SW_MAXIMIZE)
#endregion ### END Koda GUI section ###
;~ $aLibs = _ListSteamLibraries()
;~ 	For $i = 0 To UBound($aLibs)-1 Step 1
;~ 		ConsoleWrite($aLibs[$i] & @LF)
;~ 	Next
;~ _EnumerateStoredList()
;~ _ListAllGames2()

AdlibRegister("_UpdateStatusLabel", 500)


_PopulateStoredList()
_EnumerateLocalList()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
;~ 		Case $hListLocal
		Case $hChangeDescription
			_ChangeComments()
			_PopulateStoredList()
		Case $hDelete
			_DeleteSelected()
		Case $hStoreLocal
			_TransferGames(False)
		Case $hInstallStored
			_TransferGames(True)
	EndSwitch
;~ Sleep(100)

WEnd

Func _Setup()
	If Not FileExists($sPath_DataDir) Then
		DirCreate($sPath_DataDir)
	EndIf
	FileInstall("readme.txt", $sFile_ReadMe)
	FileInstall("SSI.ini", $sFile_SettingsINI)
EndFunc   ;==>_Setup

Func _DeleteSelected()
	$asGamesToDelete = _GetSelectedItems($hListStored)
	If UBound($asGamesToDelete) > 0 Then
		If MsgBox(4 + 262144 + 32, "Confirm", "Are you sure you want to delete the selected game(s)?") = 6 Then
			For $i = 0 To UBound($asGamesToDelete) - 1 Step 1
				$sPath = @ScriptDir & "" & IniRead($sFile_GamesINI, $asGamesToDelete[$i][0], "StorePath", "")
				ConsoleWrite("REMOVING " & $sPath & @TAB & DirRemove($sPath, 1) & @LF)
				IniDelete($sFile_GamesINI, $asGamesToDelete[$i][0])
				_PopulateStoredList()
			Next
		EndIf
	Else
		MsgBox(0, "Information", "Nothing was selected")
	EndIf
EndFunc   ;==>_DeleteSelected

Func _ChangeComments()
	$asSelectedItems = _GetSelectedItems($hListStored)
	If UBound($asSelectedItems) > 0 Then
		$sNewComment = InputBox("Enter new comment", "Enter a new comment to apply to the checked games")
		For $i = 0 To UBound($asSelectedItems) - 1 Step 1
			IniWrite($sFile_GamesINI, $asSelectedItems[$i][0], "Comment", $sNewComment)
		Next
	Else
		MsgBox(0, "Information", "Nothing was selected")
	EndIf
EndFunc   ;==>_ChangeComments

Func _PopulateStoredList()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListStored))
	$asGameIDs = IniReadSectionNames($sFile_GamesINI)
	If Not @error Then
		If $asGameIDs[0] > 0 Then
			For $i = 1 To $asGameIDs[0] Step 1
				$sGameID = $asGameIDs[$i]
				$sGameName = IniRead($sFile_GamesINI, $sGameID, "Name", "-")
				$sTimeStamp = IniRead($sFile_GamesINI, $sGameID, "CopyStarted", "")
				$sComment = IniRead($sFile_GamesINI, $sGameID, "Comment", "")
				$sGamePath = IniRead($sFile_GamesINI, $sGameID, "StorePath", "")
				$sGameSize = IniRead($sFile_GamesINI, $sGameID, "SourceSize", "")
				$iIndex = _GUICtrlListView_AddItem(GUICtrlGetHandle($hListStored), $sGameID)
				_GUICtrlListView_AddSubItem(GUICtrlGetHandle($hListStored), $iIndex, $sGameName, 1)
				_GUICtrlListView_AddSubItem(GUICtrlGetHandle($hListStored), $iIndex, $sTimeStamp, 2)
				_GUICtrlListView_AddSubItem(GUICtrlGetHandle($hListStored), $iIndex, $sComment, 3)
				_GUICtrlListView_AddSubItem(GUICtrlGetHandle($hListStored), $iIndex, $sGamePath, 4)
				_GUICtrlListView_AddSubItem(GUICtrlGetHandle($hListStored), $iIndex, $sGameSize, 5)
			Next
			For $x = 0 To _GUICtrlListView_GetColumnCount(GUICtrlGetHandle($hListStored)) Step 1
				_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hListStored), $x, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
			Next
		EndIf
	EndIf
EndFunc   ;==>_PopulateStoredList

Func _TransferGames($bInstall = False)
;~ GUICtrlSetData($hJobProgress,50)
	Dim $asCopyJobs[1][3]
	$asLibraries = _ListSteamLibraries()
	If $bInstall Then
		$asGamesToInstall = _GetSelectedItems($hListStored)
		If UBound($asGamesToInstall) = 0 Then
			MsgBox(0, "Information", "Nothing was selected")
			Return
		EndIf
		ReDim $asCopyJobs[UBound($asGamesToInstall)][3]
		If UBound($asGamesToInstall) > 1 Then
			$bInstallAllAtSameLocation = (MsgBox(4 + 262144 + 32, "Different Folders?", "Do you want to install all of the games in the same folder?") = 6)
		Else
			$bInstallAllAtSameLocation = True
		EndIf
		If $bInstallAllAtSameLocation Then
			$sInstallDirectory = _MultiSelect("Please select where to install", $asLibraries, $hMainWindow)
			If $sInstallDirectory = -1 Then Return
		EndIf
		For $i = 0 To UBound($asGamesToInstall) - 1 Step 1
			$asCopyJobs[$i][0] = @ScriptDir & $asGamesToInstall[$i][4]
			If $bInstallAllAtSameLocation Then
				$asCopyJobs[$i][1] = $sInstallDirectory
			Else
				$asCopyJobs[$i][1] = _MultiSelect("Please select where to install", $asLibraries, $hMainWindow)
				If $asCopyJobs[$i][1] = -1 Then Return
				_ArrayAdd($asLibraries, $asCopyJobs[$i][1])
				$asLibraries = _ArrayUnique($asLibraries)
			EndIf
			$asCopyJobs[$i][1] = $asCopyJobs[$i][1] & "\common\" & IniRead($sFile_GamesINI, $asGamesToInstall[$i][0], "GameFolder", "")
			$asCopyJobs[$i][2] = $asGamesToInstall[$i][0]
			ConsoleWrite("Added CopyJob: " & '"' & $asCopyJobs[$i][0] & '" to "' & $asCopyJobs[$i][1] & '"' & @LF)
		Next

	Else
		$asGamesToStore = _GetSelectedItems($hListLocal)
		If UBound($asGamesToStore) = 0 Then
			MsgBox(0, "Information", "Nothing was selected")
			Return
		EndIf
		ReDim $asCopyJobs[UBound($asGamesToStore)][3]
		$sComment = InputBox($sAppTitle, "Please give a comment on the selected games (a timestamp is already included)")
		For $i = 0 To UBound($asGamesToStore) - 1 Step 1
			$sGameID = $asGamesToStore[$i][0]
			$sGameName = $asGamesToStore[$i][1]
;~ 		If $sGameName = "" Then $sGameName = $sGamePath
			$sGamePath = $asGamesToStore[$i][3]
			$sGameSize = $asGamesToStore[$i][4]
			$asGameFolder = _StringBetween($sGamePath, "steamapps\common\", "")
			$sGameFolder = $asGameFolder[0]
			IniWrite($sFile_GamesINI, $sGameID, "Name", $sGameName)
			IniWrite($sFile_GamesINI, $sGameID, "Comment", $sComment)
			IniWrite($sFile_GamesINI, $sGameID, "CopyStarted", @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
			IniWrite($sFile_GamesINI, $sGameID, "SourcePath", $sGamePath)
			IniWrite($sFile_GamesINI, $sGameID, "SourceSize", $sGameSize)
			IniWrite($sFile_GamesINI, $sGameID, "GameFolder", $sGameFolder)
			IniWrite($sFile_GamesINI, $sGameID, "SourceComputer", @ComputerName)
			IniWrite($sFile_GamesINI, $sGameID, "StorePath", $sPath_StoredGamesArbitrary & "\" & $sGameFolder)

			$asCopyJobs[$i][0] = $sGamePath
			$asCopyJobs[$i][1] = $sPath_StoredGames & "\" & $sGameFolder
			$asCopyJobs[$i][2] = $sGameID

		Next
	EndIf

;~ 	_ArrayDisplay($asCopyJobs)

	#region ### START Koda GUI section ### Form=F:\SteamSpeedInstaller\Source\form2.kxf
	$hStatusForm = GUICreate($sAppTitle & " - Copying", 1163, 720, Default, Default, $iChildGuiStyles, $iChildGuiExStyles, $hMainWindow)
	GUISetBkColor(0x3A3B3D)

	$hStatusTitle = GUICtrlCreateLabel($sAppTitle & " - Copying", 8, 8, 1100, 32)
	GUICtrlSetFont(-1, 18, 800, 0, "American Typewriter")
	GUICtrlSetColor(-1, 0xFFFFFF)


	$Group1 = GUICtrlCreateGroup("Robocopy progress", 8, 40, 777, 585)
	GUICtrlSetFont(-1, 14, 800, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)

	$hRobocopySTDOUT = GUICtrlCreateEdit("", 16, 64, 761, 553, BitOR($WS_VSCROLL, $ES_READONLY))
	_GUICtrlEdit_SetLimitText(GUICtrlGetHandle($hRobocopySTDOUT), 3200000)
	GUICtrlSetBkColor(-1, 0x3A3B3D)
;~ 	GUICtrlSetData(-1, $sReadMe)
	GUICtrlSetFont(-1, 8, 400, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)


	$Group2 = GUICtrlCreateGroup("Status", 792, 40, 361, 297)
	GUICtrlSetFont(-1, 10, 800, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)

	$hStatus = GUICtrlCreateEdit("", 800, 64, 345, 265, BitOR($WS_VSCROLL, $ES_READONLY))
	GUICtrlSetBkColor(-1, 0x3A3B3D)
;~ 	GUICtrlSetData(-1, $sReadMe)
	GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)


	$Group4 = GUICtrlCreateGroup("Robocopy Errors", 792, 344, 361, 281)
	GUICtrlSetFont(-1, 10, 800, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)

	$hRobocopySTDERR = GUICtrlCreateEdit("", 800, 368, 345, 249, BitOR($WS_VSCROLL, $ES_READONLY))
	GUICtrlSetBkColor(-1, 0x3A3B3D)
;~ 	GUICtrlSetData(-1, $sReadMe)
	GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)

	$Label2 = GUICtrlCreateLabel("Whole Job", 16, 664 - 30, 94, 22)
	GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)

	$Label4 = GUICtrlCreateLabel("Current Game", 16, 696 - 30, 124, 22)
	GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)

	$hJobProgress = GUICtrlCreateProgress(144, 664 - 30, 798, 17);, $PBS_SMOOTH)
	GUICtrlSetColor(-1, 0x3A3B3D)
	GUICtrlSetBkColor(-1, 0x696969)

	$hJobStatus = GUICtrlCreateLabel("", 952, 664 - 30, 350, 22)
	GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
	GUICtrlSetColor(-1, 0xFFFFFF)

	$hGameProgress = GUICtrlCreateProgress(144, 696 - 30, 798, 17, $PBS_SMOOTH)
	GUICtrlSetColor(-1, 0x3A3B3D)
	GUICtrlSetBkColor(-1, 0x696969)

	$hGameStatus = GUICtrlCreateLabel("", 952, 696 - 30, 350, 22)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISetState(@SW_SHOW)
	GUISetState(@SW_MAXIMIZE)
	#endregion ### END Koda GUI section ###

	_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Created GUI" & @CRLF)
	_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Preparing to copy" & UBound($asCopyJobs) & " games" & @CRLF)
	_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Meassuring total bytes to be moved. . ." & @CRLF)
	$iTotalSize = 0
	$iTotalAmountFiles = 0
	$iTotalAmountFolders = 0
	For $i = 0 To UBound($asCopyJobs) - 1 Step 1
		If FileExists($asCopyJobs[$i][0]) Then
		Else
			ConsoleWrite("!>" & $asCopyJobs[$i][0] & " does not exist!" & @LF)
		EndIf
		$aSizeInfo = DirGetSize($asCopyJobs[$i][0], 1)
		$iTotalSize += $aSizeInfo[0]
		$iTotalAmountFiles += $aSizeInfo[1]
		$iTotalAmountFolders += $aSizeInfo[2]
	Next
	_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), $iTotalAmountFiles & " files in " & $iTotalAmountFolders & " folders for a total of " & _FormatSize($iTotalSize, 2) & " are to be copied" & @CRLF)
	For $i = 0 To UBound($asCopyJobs) - 1 Step 1
		$iAlreadyCopied = 0
		For $j = 0 To $i - 1 Step 1
			$iAlreadyCopied += DirGetSize($asCopyJobs[$j][0])
		Next
		$sSourceDir = $asCopyJobs[$i][0]
		$sDestDir = $asCopyJobs[$i][1]
		$sGameName = IniRead($sFile_GamesINI, $asCopyJobs[$i][2], "Name", "Unknown")
		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Starting copy of game " & $sGameName & @CRLF)
		$iSourceSize = DirGetSize($sSourceDir)
		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Game size: " & _FormatSize($iSourceSize, 2) & "(" & Round(($iSourceSize / $iTotalSize) * 100, 2) & "% of total)" & @CRLF)
		$sRobocopyCMD = "robocopy " & '"' & $sSourceDir & '"' & " " & '"' & $sDestDir & '"' & " /E"
		If GUICtrlRead($hMultiThreadCopy) = $GUI_CHECKED Then
			_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Multi-threaded copy is selected! " & @CRLF)
			$sRobocopyCMD &= " /MT"
		Else
		EndIf
		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Starting robocopy with following arguments " & @CRLF & $sRobocopyCMD & @CRLF)
		ConsoleWrite("Executing robocopy with command line: " & $sRobocopyCMD & @LF)
		$hPID = Run($sRobocopyCMD, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "_Waiting for robocopy to finish. . ." & @CRLF)
		While (ProcessExists($hPID)) ;Robocopy is running
			$iDestSize = DirGetSize($sDestDir)
			$iTotalPercentage = (($iAlreadyCopied + $iDestSize) / $iTotalSize) * 100
			$iGamePercentage = ($iDestSize / $iSourceSize) * 100
			GUICtrlSetData($hJobProgress, $iTotalPercentage)
			GUICtrlSetData($hJobStatus, _FormatSize($iAlreadyCopied + $iDestSize, 2) & " of " & _FormatSize($iTotalSize, 2))
			GUICtrlSetData($hGameProgress, $iGamePercentage)
			GUICtrlSetData($hGameStatus, _FormatSize($iDestSize, 2) & " of " & _FormatSize($iSourceSize, 2))

;~ 			ProgressSet($iDestSize / $iSourceSize, _FormatSize($iDestSize, 2) & " of " & _FormatSize($iSourceSize, 2) & " bytes")
			$sSTDOUT = StdoutRead($hPID)
			$sSTDERR = StderrRead($hPID)
			_GUICtrlEdit_AppendText(GUICtrlGetHandle($hRobocopySTDOUT), $sSTDOUT)
			_GUICtrlEdit_AppendText(GUICtrlGetHandle($hRobocopySTDERR), $sSTDERR)
			Sleep($iLoopDelay)
		WEnd
		$sSTDOUT = StdoutRead($hPID)
		$sSTDERR = StderrRead($hPID)
		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hRobocopySTDOUT), $sSTDOUT)
		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hRobocopySTDERR), $sSTDERR)

		IniWrite($sFile_GamesINI, $asCopyJobs[$i][2], "CopyEnd", @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Copy complete!" & @CRLF)
		GUICtrlSetData($hGameProgress, 100)
	Next
	_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Job complete!" & @CRLF & "You can now close this window" & @CRLF)
	GUICtrlSetData($hJobProgress, 100)
	GUISetBkColor(0x005500)
	GUICtrlSetData($hStatusTitle, $sAppTitle & " - Copy Complete!")
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				ExitLoop
		EndSwitch
	WEnd
	_PopulateStoredList()
	_EnumerateLocalList()
EndFunc   ;==>_TransferGames

Func _MultiSelect($sTitle, $aList, $hParent)

	#region ### START Koda GUI section ### Form=
	$hMultiSelect = GUICreate($sTitle, 900, 80, Default, Default, $iMiniGuiStyles, $iMiniGuiExStyles, $hParent)
	GUISetBkColor(0x3A3B3D)
	$sComboData = _ArrayToString($aList)
	$hComboList = GUICtrlCreateCombo("", 8, 8, 800, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hComboList, $sComboData, $aList[0])
	GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
	GUICtrlSetBkColor(-1, 0x3A3B3D)
	GUICtrlSetColor(-1, 0xFFFFFF)
	$hBrowseButton = GUICtrlCreateButton("Browse", 8 + 8 + 800, 8, 70, 25)
	GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
	GUICtrlSetBkColor(-1, 0x696969)
	GUICtrlSetColor(-1, 0xFFFFFF)
	$hSelectButton = GUICtrlCreateButton("Select", 8, 8 + 8 + 25, 878, 25)
	GUICtrlSetFont(-1, 12, 800, 0, "Courier New")
	GUICtrlSetBkColor(-1, 0x696969)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUISetState(@SW_SHOW)
	#endregion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($hMultiSelect)
				Return -1
			Case $hSelectButton
				$sReturn = GUICtrlRead($hComboList)
				ConsoleWrite("Combo read: " & $sReturn & @LF)
				If FileExists($sReturn) Then
					GUIDelete($hMultiSelect)
					Return $sReturn
				Else
					MsgBox(0, "Error", "Path does not exist")
				EndIf
			Case $hBrowseButton
				$sFolder = FileSelectFolder("Please select the folder " & '"\steamapps"' & " where you want to install the game", "", 4, "", $hMultiSelect)
				GUICtrlSetData($hComboList, $sFolder, $sFolder)
		EndSwitch
	WEnd

EndFunc   ;==>_MultiSelect

Func _CopyDirectories($sSourceDir, $sDestDir)




;~ 	$sRobocopyCMD = "robocopy " & '"' & $sSourceDir & '"' & " " & '"' & $sDestDir & '"' & " /E"
;~ 	_GUICtrlEdit_AppendText(GUICtrlGetHandle($hStatus), "Starting robocopy with following arguments " & @CRLF & $sRobocopyCMD)
;~ 	ConsoleWrite("Executing robocopy with command line: " & $sRobocopyCMD & @LF)
;~ 	$hPID = Run($sRobocopyCMD, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
;~ 	$iSourceSize = DirGetSize($sSourceDir)
;~ 	ProgressOn($sAppTitle, "Copying" & @CRLF & $sSourceDir & "to" & @CRLF & $sDestDir)
;~ 	While (ProcessExists($hPID)) ;Robocopy is running
;~ 		$iDestSize = DirGetSize($sDestDir)
;~ 		ProgressSet($iDestSize / $iSourceSize, _FormatSize($iDestSize, 2) & " of " & _FormatSize($iSourceSize, 2) & " bytes")
;~ 		$sSTDOUT = StdoutRead($hPID)
;~ 		_GUICtrlEdit_AppendText(GUICtrlGetHandle($hInformation), $sSTDOUT)
;~ 		Sleep(100)
;~ 	WEnd
;~ 	ProgressOff()

EndFunc   ;==>_CopyDirectories


Func _GetSelectedItems($hListView)
	$iRows = _GUICtrlListView_GetItemCount(GUICtrlGetHandle($hListView))
	$iColumns = _GUICtrlListView_GetColumnCount(GUICtrlGetHandle($hListView))
	Dim $asReturnArray[1][$iColumns]
	$iIndex = 0
	For $i = 0 To $iRows Step 1
		If _GUICtrlListView_GetItemChecked(GUICtrlGetHandle($hListView), $i) Then
			$asItemText = _GUICtrlListView_GetItemTextArray(GUICtrlGetHandle($hListView), $i)
			ReDim $asReturnArray[$iIndex + 1][$iColumns]
			For $c = 0 To UBound($asReturnArray, 2) - 1 Step 1
				$asReturnArray[$iIndex][$c] = $asItemText[$c + 1]
			Next
			$iIndex += 1
		EndIf
	Next
	If $iIndex = 0 Then _ArrayDelete($asReturnArray, 0)
	Return $asReturnArray
EndFunc   ;==>_GetSelectedItems

Func _UpdateStatusLabel()
	$iLocalSize = 0
	$iStoredSize = 0
	$asLocal = _GetSelectedItems($hListLocal)
	For $i = 0 To UBound($asLocal) - 1 Step 1
		$iLocalSize += _FormatedSizeToBytes($asLocal[$i][4])
	Next

	$asStored = _GetSelectedItems($hListStored)
	For $i = 0 To UBound($asStored) - 1 Step 1
		$iStoredSize += _FormatedSizeToBytes($asStored[$i][5])
	Next

	GUICtrlSetData($hMetaData, UBound($asLocal) & " games selected for storage (" & _FormatSize($iLocalSize, 4) & ")" & "          " & UBound($asStored) & " games selected for installation (" & _FormatSize($iStoredSize, 4) & ")")
EndFunc   ;==>_UpdateStatusLabel

Func _EnumerateLocalList()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListLocal))
	$asGames = _ListAllGames2()
;~ 	_GUICtrlListView_AddArray(GUICtrlGetHandle($hListLocal), $asGames)
	For $y = 0 To UBound($asGames) - 1 Step 1
		ConsoleWrite($asGames[$y][4] & @LF)
		If $asGames[$y][4] <> "-1 B" Then
			$iIndex = _GUICtrlListView_AddItem(GUICtrlGetHandle($hListLocal), $asGames[$y][0])
			For $x = 1 To UBound($asGames, 2) - 1 Step 1
				_GUICtrlListView_AddSubItem(GUICtrlGetHandle($hListLocal), $iIndex, $asGames[$y][$x], $x)
			Next
		EndIf
	Next
	For $x = 0 To _GUICtrlListView_GetColumnCount(GUICtrlGetHandle($hListLocal)) Step 1
		_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hListLocal), $x, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	Next
EndFunc   ;==>_EnumerateLocalList

Func _EnumerateStoredList()
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($hListStored))
	$asInstalledGames = _ListAllGames()
	_GUICtrlListView_AddArray(GUICtrlGetHandle($hListStored), $asInstalledGames)
	For $x = 0 To _GUICtrlListView_GetColumnCount(GUICtrlGetHandle($hListStored)) Step 1
		_GUICtrlListView_SetColumnWidth(GUICtrlGetHandle($hListStored), $x, BitAND($LVSCW_AUTOSIZE, $LVSCW_AUTOSIZE_USEHEADER))
	Next
EndFunc   ;==>_EnumerateStoredList

Func _ListSteamLibraries()
	$asAllGAmes = _ListAllGames()
	Dim $asSteamLibraries[1]
	For $i = 0 To UBound($asAllGAmes) - 1 Step 1
		$asPath = _StringBetween($asAllGAmes[$i][3], "", "steamapps\")
		If IsArray($asPath) Then
			$sPath = $asPath[0] & "steamapps"
			_ArrayAdd($asSteamLibraries, $sPath)
		EndIf
	Next
	$asRetArray = _ArrayUnique($asSteamLibraries, 1, 0, 0)
	_ArrayDelete($asRetArray, 0)
	_ArrayDelete($asRetArray, 0)
	Return $asRetArray
EndFunc   ;==>_ListSteamLibraries

Func _ListInstalledSteamGames($sPath)
	ConsoleWrite("Listing apps in " & $sPath & @LF)
	$asInstalledApps = _FileListToArray($sPath, "appmanifest_*.acf", 1)
	Dim $asReturnArray[$asInstalledApps[0]][4]
	For $x = 1 To UBound($asReturnArray) - 1 Step 1
		$sFilePath = $sPath & "\" & $asInstalledApps[$x]
		$hFileHandle = FileOpen($sFilePath, 0)
		$sFileContents = FileRead($hFileHandle)
		FileClose($hFileHandle)
		ConsoleWrite("Parsing " & $sFilePath & @LF)
;~ 		ConsoleWrite("Read" & @CRLF & $sFileContents & @LF)
		$sRegex = '[\S\s]*\"appID"\s*\"(?<appID>\d*)\"[\S\s]*?\"name"\s*\"(?<name>.*)\"[\S\s]*?\"Installed\"\s*\"(?<installed>\d)\"[\S\s]*?\"appinstalldir\"\s*\"(?<dir>.*)\"'
		$asAppData = StringRegExp($sFileContents, $sRegex, 3)
;~ 		ConsoleWrite("err: " & @error & ", ext: " & @extended & ", size: " & UBound($asAppData) & ", 0=" & $asAppData[0] & @LF)
		If UBound($asAppData) = 4 Then
			$sAppData_ID = $asAppData[0]
			$sAppData_Name = $asAppData[1]
			$sAppData_Installed = $asAppData[2]
			If $sAppData_Installed Then
				$sAppData_Installed = "Yes"
			Else
				$sAppData_Installed = "No"
			EndIf
			$sAppData_Path = _RemoveEscapedBackslash($asAppData[3])
			$asReturnArray[$x - 1][0] = $sAppData_ID
			$asReturnArray[$x - 1][1] = $sAppData_Name
			$asReturnArray[$x - 1][2] = $sAppData_Installed
			$asReturnArray[$x - 1][3] = $sAppData_Path
;~ 			ConsoleWrite("app " & $sAppData_ID & " installed: " & $sAppData_Installed & " is called " & $sAppData_Name & @TAB & "DIR: " & $sAppData_Path & @LF)
		EndIf
	Next


	Return $asReturnArray
EndFunc   ;==>_ListInstalledSteamGames


Func _RemoveEscapedBackslash($sString)
	Return StringReplace($sString, "\\", "\")
EndFunc   ;==>_RemoveEscapedBackslash

Func _ListAllGames()
	ConsoleWrite($sPath_SteamIcons & @LF)

	$sConfigFile = FileRead($sFile_SteamConfig)

	$asConfigApps = _StringBetween($sConfigFile, '"apps"', '"depots"')
	$sConfigApps = $asConfigApps[0]
	$sConfigApps = StringStripWS($sConfigApps, 4 + 2 + 1)
	$sConfigApps = StringTrimLeft(StringTrimRight($sConfigApps, 1), 1)
	$asFoundDir = StringRegExp($sConfigApps, '\"(\d+)\"\n\{[\S\s]*?\"installdir\"\s*\"(.*)\"', 3)
	ConsoleWrite("Found" & UBound($asFoundDir) & @LF)

	Dim $asReturnArray[UBound($asFoundDir) / 2][4]
	For $x = 0 To UBound($asFoundDir) - 1 Step 2
		$sAppData_ID = $asFoundDir[$x]
		$sAppData_Path = _RemoveEscapedBackslash($asFoundDir[$x + 1])
		$asReturnArray[$x / 2][0] = $sAppData_ID
		$asReturnArray[$x / 2][3] = $sAppData_Path
		ConsoleWrite("Application ID: " & $sAppData_ID & @TAB & "Installed at: " & @TAB & $sAppData_Path & @LF)
	Next
	Return $asReturnArray
EndFunc   ;==>_ListAllGames

Func _ListAllGames2()
	ConsoleWrite($sPath_SteamIcons & @LF)

	$sConfigFile = FileRead($sFile_SteamConfig)

	$asConfigApps = _StringBetween($sConfigFile, '"apps"', '"depots"')
	If Not IsArray($asConfigApps) Then
		$asConfigApps = _StringBetween($sConfigFile, '"apps"', '"Rate"')
	EndIf
	If Not IsArray($asConfigApps) Then
		MsgBox(0,"Could not read games list","Try to log in into steam and run this app again, steam does not keep the game list for offline use, but rather downloads it at login")
	EndIf

	$sConfigApps = $asConfigApps[0]
	$sConfigApps = StringStripWS($sConfigApps, 4 + 2 + 1)
	$sConfigApps = StringTrimLeft(StringTrimRight($sConfigApps, 1), 1)
	$asFoundDir = StringRegExp($sConfigApps, '\"(\d+)\"\n\{[\S\s]*?\"installdir\"\s*\"(.*)\"', 3)
	ConsoleWrite("Found" & UBound($asFoundDir) & @LF)

	Dim $asReturnArray[UBound($asFoundDir) / 2][5]
	For $x = 0 To UBound($asFoundDir) - 1 Step 2
		$sAppData_ID = $asFoundDir[$x]
		$sAppData_Path = _RemoveEscapedBackslash($asFoundDir[$x + 1])
		$asReturnArray[$x / 2][0] = $sAppData_ID
		$asReturnArray[$x / 2][3] = $sAppData_Path
		$asReturnArray[$x / 2][4] = _FormatSize(DirGetSize($sAppData_Path), 2)
		ConsoleWrite("Application ID: " & $sAppData_ID & @TAB & "Installed at: " & @TAB & $sAppData_Path & @LF)
	Next


	For $i = 0 To UBound($asReturnArray) - 1 Step 1
		$asPath = _StringBetween($asReturnArray[$i][3], "", "steamapps\")
		If IsArray($asPath) Then
			$sPath = $asPath[0] & "steamapps"
			$sFilePath = $sPath & "\appmanifest_" & $asReturnArray[$i][0] & ".acf"
			If (FileExists($sFilePath)) Then

				$hFileHandle = FileOpen($sFilePath, 0)
				$sFileContents = FileRead($hFileHandle)
				FileClose($hFileHandle)
				ConsoleWrite("Parsing " & $sFilePath & @LF)
;~ 		ConsoleWrite("Read" & @CRLF & $sFileContents & @LF)
				$sRegex = '[\S\s]*\"appID"\s*\"(?<appID>\d*)\"[\S\s]*?\"name"\s*\"(?<name>.*)\"[\S\s]*?\"Installed\"\s*\"(?<installed>\d)\"[\S\s]*?\"appinstalldir\"\s*\"(?<dir>.*)\"'
				$asAppData = StringRegExp($sFileContents, $sRegex, 3)
;~ 		ConsoleWrite("err: " & @error & ", ext: " & @extended & ", size: " & UBound($asAppData) & ", 0=" & $asAppData[0] & @LF)
				If UBound($asAppData) = 4 Then
					$sAppData_ID = $asAppData[0]
					$sAppData_Name = $asAppData[1]
					$sAppData_Installed = $asAppData[2]
					If $sAppData_Installed Then
						$sAppData_Installed = "Yes"
					Else
						$sAppData_Installed = "No"
					EndIf
					$sAppData_Path = _RemoveEscapedBackslash($asAppData[3])
					$asReturnArray[$i][0] = $sAppData_ID
					$asReturnArray[$i][1] = $sAppData_Name
					$asReturnArray[$i][2] = $sAppData_Installed
					$asReturnArray[$i][3] = $sAppData_Path
					ConsoleWrite("app " & $sAppData_ID & " installed: " & $sAppData_Installed & " is called " & $sAppData_Name & @TAB & "DIR: " & $sAppData_Path & @LF)
				EndIf
			EndIf
		EndIf
	Next
	Return $asReturnArray
EndFunc   ;==>_ListAllGames2

Func _FormatSize($iBytes, $iDecimals)
	$sPrefixes = "kMGTPEZY"
	$iNewSize = $iBytes
	$iPrefixIndex = 0
	While (($iNewSize > 1024) And ($iPrefixIndex < 8))
		$iNewSize = $iNewSize / 1024
		$iPrefixIndex += 1
	WEnd
	Return Round($iNewSize, $iDecimals) & " " & StringMid($sPrefixes, $iPrefixIndex, 1) & "B"
EndFunc   ;==>_FormatSize

Func _FormatedSizeToBytes($sString)
;~ 	ConsoleWrite("Parsing " & '"' &$sString& '"' & @LF)
	$sPrefixes = "kMGTPEZY"
	$sString = StringTrimRight($sString, 1)
	$aParts = StringSplit($sString, " ", 3)
	If Not @error Then
		$iPrefixIndex = StringInStr($sPrefixes, $aParts[1])
;~ 	ConsoleWrite($iPrefixIndex & @LF)
		Return $aParts[0] * (1024 ^ $iPrefixIndex)
	EndIf
EndFunc   ;==>_FormatedSizeToBytes
#CS
	;~ ConsoleWrite($sConfigApps & @LF)

	;~ 	$asFoundIDs = StringRegExp($sConfigApps,'\"(?<ID>\d+)"\n\{',3)
	;~ 	$asFoundDir = StringRegExp($sConfigApps,'\"installdir\"\s*\"(?<InstallDir>.*)\"',3)

	;~ $sConfigApps_entries = _StringBetween($sConfigApps,'{','}')
	;~ $sConfigApps_entries = _StringBetween($sConfigApps,'"','"')
	;~ $sConfigApps_ID = _StringBetween($sConfigApps,'}','{')

	$asConfigAppsLines = StringSplit($sConfigApps,@LF,2)

	For $l = 0 To UBound($asConfigAppsLines)-2 Step 1
	$sCurrentLine = $asConfigAppsLines[$l]
	Next

	.*\"installdir\"\s*\"(?<InstallDir>.*)\"

	For $i = 1 To UBound($sConfigApps_entries)-1 Step 1
	ConsoleWrite($i &"------->"&$sConfigApps_ID[$i-1]& "=" & $sConfigApps_entries[$i]& @LF)
	Next
	;~ ConsoleWrite($sConfigApps & @LF)
#CE





