#NoEnv
#SingleInstance, Force
#Persistent

; ===== Tray Menu =====
TrayTip, Professor Piano Player, Script Active!, 5, 1
Menu, Tray, NoStandard
Menu, Tray, Tip, Professor Piano Player
Menu, Tray, Add, Info, Info
Menu, Tray, Add, Help, Help
Menu, Tray, Add, Reload Script, Reload
Menu, Tray, Add, Exit, GuiClose
Menu, Tray, Default, Exit

; ===== Default Values =====
Delay := 250
SheetMusicDefault := ""

; ===== GUI =====
Gui, Font, s10, Segoe UI
Gui, Add, Text, x10 y10, Delay:
Gui, Add, Edit, x60 y7 w280 vSettingDelay
Gui, Add, UpDown, Range-1-1000000,  %Delay%

Gui, Add, Text, x10 y40, TIP: Delay 1000 = 1 second.

Gui, Add, Text, x10 y70, Sheet Music:
Gui, Add, Edit, x10 y90 w330 h130 vSheetMusic, %SheetMusicDefault%

Gui, Add, Button, x5 y230 w55 gF5 section, Play
Gui, Add, Button, x65 y230 w55 gF6 section, Pause
Gui, Add, Button, x125 y230 w55 gF7 section, Stop
Gui, Add, Button, x185 y230 w50 gImportSheetMusic section, Import
Gui, Add, Button, x240 y230 w50 gInfo section, Info
Gui, Add, Button, x295 y230 w50 gHelp section, Help

Gui, Add, StatusBar,, Stopping... Press F5 to Start

Gui, Show, w350 h300, Professor Piano Player
Toggle:=0

F5::
{
	if(Toggle == 0)
	{
		Toggle:=1
		SoundBeep
		SB_SetText("Running... Press F7 to Stop/Press F6 to Pause")
		Gui, Submit, Nohide
		SheetMusic := StrReplace(SheetMusic, "`n")
		SheetMusic := StrReplace(SheetMusic, "`r")
		SheetMusic := StrReplace(SheetMusic, "/")
		SheetMusic := StrReplace(SheetMusic, "|")
		SheetMusic := StrReplace(SheetMusic,  "!", "{!}")
		SheetMusic := StrReplace(SheetMusic,  "^", "{^}")
	}
	
	if(Toggle == 1){
		Array := StrSplit(SheetMusic, "]")
		LastSheetMusic := Array.pop()
		ArrayLastSheetMusic := StrSplit(LastSheetMusic, "")
		LastSheetMusic := ""
		for index, element in ArrayLastSheetMusic
		{
			LastSheetMusic = %LastSheetMusic% %element%
		}
		stats := 0
		text := ""
		for index, element in Array
		{
			Loop, Parse, element, % "["
			{
				tempSheetMusic := A_LoopField
				if(stats == 0){
					stats := 1
					ArrayTempSheetMusic := StrSplit(tempSheetMusic, "")
					for indexArrayTempSheetMusic, elementArrayTempSheetMusic in ArrayTempSheetMusic
					{
						text = %text% %elementArrayTempSheetMusic%
					}
				}else{
					stats := 0
					text = %text% %tempSheetMusic%
				}
			}
		}
		text = %text% %LastSheetMusic%
		ArrayTwo := StrSplit(text, " ")
		for index, element in ArrayTwo
		{
			if(Toggle == 1)
			{
				Sleep %SettingDelay%
				SendInput % element
			}
		}
		Toggle:=0
		SoundBeep
		SB_SetText("Stopping... Press F5 Start")
	}
	return
}

F7::
{
	Toggle:=0
	SoundBeep
	SB_SetText("Stopping... Press F5 Start")
	return
}

PgUp::
{
	Delay:=Delay+50
	SoundBeep
	GuiControl, , SettingDelay,%Delay%
	Gui, Submit, Nohide
	return
}

PgDn::
{
	Delay:=Delay-50
	SoundBeep
	GuiControl, , SettingDelay,%Delay%
	Gui, Submit, Nohide
	return
}

F6::
Pause
return
	
	
; ============================
;         IMPORT FILE
; ============================
	
	ImportSheetMusic:
	FileSelectFile, SelectedFileSheetMusic, 3, , Open, Text Documents (*.txt)
	FileRead, FileSheetMusic, %SelectedFileSheetMusic%
	GuiControl, , SheetMusic,%FileSheetMusic%
	return
	
	Info:
	MsgBox, Made by Namida Kitsune`nModified by AZCrew
	return
	
	Help:
	MsgBox, Hotkey: `n-F5 to Start `n-F6 to Pause `n-F7 to Stop `n-PageUp to Increase delay +50 `n-PageDown to Decrease delay -50 `n-Delete to Exit Script
	return
	
	Reload:
	Reload
	Return
	
	GuiClose:
	ExitApp
	return