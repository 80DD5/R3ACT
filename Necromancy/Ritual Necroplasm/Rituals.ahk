#SingleInstance Force
#Persistent
SetBatchLines, -1

DetectHiddenWindows, On
closeotherPULSE()

IniRead, lhk1, PULSE Config.ini, PULSE Hotkey, start
IniRead, lhk2, PULSE Config.ini, PULSE Hotkey, coord/pause
IniRead, lhk3, PULSE Config.ini, PULSE Hotkey, config/resume
IniRead, lhk4, PULSE Config.ini, PULSE Hotkey, exit
IniRead, value, PULSE Config.ini, Transparent, value

settimer, configcheck, 250
settimer, guicheck

scriptname := regexreplace(A_scriptname,"\..*","")

Hotkey %lhk1%, Start
Hotkey %lhk2%, coordb
Hotkey %lhk3%, Configb
Hotkey %lhk4%, exitb

Gui +LastFound +OwnDialogs +AlwaysOnTop
Gui, Font, s11
Gui, font, bold
Gui, Add, Button, x15 y5 w190 h25 gStart , Start %scriptname%
Gui, Add, Button, x15 y35 w90 h25 gCoordb , Coordinates
Gui, Add, Button, x115 y35 w90 h25 gConfigb , Hotkeys
Gui, Add, Button, x35 y140 w150 h25 gExitb , Exit PULSE
Gui, Add, Text, x135 y90 w100 h25 vCounter
Gui, Add, Text, x8 y90 w125 h25, Total Run Count
Gui, Add, Text, x8 y65 w125 h25, Run Count
Gui, Add, Text, x135 y65 w150 h25 vCounter2
Gui, Font, cGreen
Gui, Add, Text, x135 y115 w70 h25 vState1
Gui, Add, Text, x8 y115 w125 h25 vScriptGreen
Gui, Font, cBlue
Gui, Add, Text, x135 y115 w70 h25 vState3
Gui, Add, Text, x8 y115 w125 h25 vScriptBlue
Gui, Font, cRed
Gui, Add, Text, x135 y115 w70 h25 vState2
Gui, Add, Text, x8 y115 w125 h25 vScriptRed
GuiControl,,State2, ** OFF **
Gui, Add, Text, x8 y115 w125 h25, %scriptname%
Menu, Tray, Icon, %A_ScriptDir%\PULSE Logo.ico
WinSet, Transparent, %value%
Gui, Show,w220 h170, PULSE

IniRead, x, PULSE Config.ini, GUI POS, guix
IniRead, y, PULSE Config.ini, GUI POS, guiy
WinMove A, ,%X%, %y%

hIcon := DllCall("LoadImage", uint, 0, str, "PULSE Logo.ico"
   	, uint, 1, int, 0, int, 0, uint, 0x10)
SendMessage, 0x80, 0, hIcon
SendMessage, 0x80, 1, hIcon

coordcount = 0
frcount = 0

OnMessage(0x0201, "WM_LBUTTONDOWN")
WM_LBUTTONDOWN() {
	If (A_Gui)
		PostMessage, 0xA1, 2
}
return

ConfigError(){
	IniRead, x1, Config.ini, Pedestal - Pedestal, xmin
	IniRead, x2, Config.ini, Pedestal - Pedestal, xmax
	IniRead, y1, Config.ini, Pedestal - Pedestal, ymin
	IniRead, y2, Config.ini, Pedestal - Pedestal, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates for [Pedestal - Pedestal] in the config.
		reload
	}
	
	CoordMode, Mouse, Screen
	IniRead, x1, Config.ini, Pedestal - Platform, xmin
	IniRead, x2, Config.ini, Pedestal - Platform, xmax
	IniRead, y1, Config.ini, Pedestal - Platform, ymin
	IniRead, y2, Config.ini, Pedestal - Platform, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates for [Pedestal - Platform] in the config.
		reload
	}
	
	IniRead, x1, Config.ini, Ritual Type, xmin
	IniRead, x2, Config.ini, Ritual Type, xmax
	IniRead, y1, Config.ini, Ritual Type, ymin
	IniRead, y2, Config.ini, Ritual Type, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates for [Ritual Type] in the config.
		reload
	}
	
	IniRead, x1, Config.ini, Platform, xmin
	IniRead, x2, Config.ini, Platform, xmax
	IniRead, y1, Config.ini, Platform, ymin
	IniRead, y2, Config.ini, Platform, ymax
	if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
	{
		Run %A_ScriptDir%\Config.ini
		GuiControl,,ScriptRed, CONFIG		
		GuiControl,,State2, ERROR
		MsgBox, 4112, Config Error, Please enter valid coordinates for [Platform] in the config.
		reload
	}
	
	IniRead, option, PULSE Config.ini, Logout, option
	if option=true
	{
		IniRead, x1, PULSE Config.ini, Logout, xmin
		IniRead, x2, PULSE Config.ini, Logout, xmax
		IniRead, y1, PULSE Config.ini, Logout, ymin
		IniRead, y2, PULSE Config.ini, Logout, ymax
		if (x1 = "" or x2 = "" or y1 = "" or y2 = "")
		{
			Run %A_ScriptDir%\PULSE Config.ini
			GuiControl,,ScriptRed, CONFIG		
			GuiControl,,State2, ERROR
			MsgBox, 4112, Config Error, Please enter valid coordinates in the PULSE Config for Logout.
			reload
		}
	}
}

CheckPOS(){
	WinGetPos, GUIx, GUIy, GUIw, GUIh, PULSE
	xmin := GUIx
	xmax :=GUIw + GUIx
	ymin :=GUIy
	ymax :=GUIh + GUIy
	xadj :=A_ScreenWidth-GUIw
	yadj :=A_ScreenHeight-GUIh
	WinGetPos, X, Y,,, PULSE	
 	
	if (xmin<0)
	{
		WinMove, PULSE,,0
	}
	if (ymin<0)
	{
		WinMove, PULSE,,,0
	}
	if (xmax>A_ScreenWidth)
	{
		WinMove, PULSE,,xadj	
	}
	if (ymax>A_ScreenHeight)
	{
		WinMove, PULSE,,,yadj
	}
}

guicheck:
checkpos()
return

CloseOtherPULSE()
{
	WinGet, hWndList, List, PULSE
	
	Loop, %hWndList%
	{
		hWnd := hWndList%A_Index%
		WinClose, % "ahk_id " hWnd
	}
}

CoordB:
Gui 1: Hide
Gui 2: +LastFound +OwnDialogs +AlwaysOnTop
Gui 2: Font, s11 Bold

IniRead, allContents, Config.ini
excludedSections := "|Sleep Brief|Sleep Normal|Sleep Short|skillbar hotkey|bank preset|sleep walk|offset|sleep repair|sleep ritual|"

sectionList := " ***** Make a Selection ***** "

Loop, Parse, allContents, `n
{
    currentSection := A_LoopField

    if !InStr(excludedSections, "|" currentSection "|")
        sectionList .= "|" currentSection
}

Gui, 2: Add, DropDownList, w230 vSectionList Choose1 gDropDownChanged, % sectionList
Gui, 2: Add, Button, w230 gClose, Close

Gui, 2: Show, w250 h45 Center, Coordinates
Gui 2: -Caption
Menu, Tray, Icon, %A_ScriptDir%\PULSE Logo.ico
WinSet, Transparent, %value%
return

Close:
Gui 2: Destroy
Gui 1: Show
return

DropDownChanged:
GuiControlGet, selectedSection,, SectionList

if (selectedSection != " ***** Make a Selection ***** ")
	GoSub, ButtonClicked

return

ButtonClicked:
Gui, 2: Hide

WinActivate, RuneScape

ClickCount := 0
xmin := ""
ymin := ""
xmax := ""
ymax := ""

ButtonText := selectedSection

SetTimer, CheckClicks, 10
settimer, coordtt1, 10
return

CheckClicks:
if GetKeyState("RButton", "P")
{
    MouseGetPos, MouseX, MouseY
    settimer, coordtt1, off
    settimer, coordtt2, 10
    ClickCount++
    if (ClickCount = 1)
    {
        xmin := MouseX
        ymin := MouseY
    }
    else if (ClickCount = 2)
    {
        xmax := MouseX
        ymax := MouseY
        SetTimer, CheckClicks, Off
        
        IniWrite, %xmin%, Config.ini, %ButtonText%, xmin
        IniWrite, %xmax%, Config.ini, %ButtonText%, xmax
        IniWrite, %ymin%, Config.ini, %ButtonText%, ymin
        IniWrite, %ymax%, Config.ini, %ButtonText%, ymax
        
        Gui, 2: Destroy
        Gui, 1: Show
        
        Loop, 100
        {
            MouseGetPos, xm, ym
            settimer, coordtt2, off
            Tooltip, Coordinates have been updated in the config., %xm%+15, %ym%+15, 1
            Sleep, 25
        }
        Tooltip
    }
    
    Sleep, 250
}
return

coordtt1:
mousegetpos xn, yn
ToolTip,Right-click the top-left of the item you need the coordinates for., (xn+7), (yn+7),1
return

coordtt2:
mousegetpos xn, yn
ToolTip,Right-click the bottom-right of the item you need the coordinates for., (xn+7), (yn+7),1
return

configB:
Gui 1: Hide
Gui 3: +LastFound +OwnDialogs +AlwaysOnTop
Gui 3: Font, s11 Bold

IniRead, allContents, Config.ini
excludedSections := "|Sleep Brief|Sleep Normal|Sleep Short|sleep repair|sleep ritual|pedestal - pedestal|pedestal - platform|platform|ritual type|input|input scroll|offset|sleep walk|"

sectionList := " ***** Make a Selection ***** "

Loop, Parse, allContents, `n
{
    currentSection := A_LoopField

    if !InStr(excludedSections, "|" currentSection "|")
        sectionList .= "|" currentSection
}

Gui, 3: Add, DropDownList, w230 vSectionList Choose1 gDropDownChanged2, % sectionList
Gui, 3: Add, Text, w230 vHotkeysText, Hotkeys will be displayed here
Gui, 3: Add, Hotkey, x100 y60 w75 vChosenHotkey gHotkeyChanged Center, ** NONE **
Gui, 3: Add, Button, x10 y90 w230 gClose2, Close

Gui, 3: Show, w250 h100 Center, Hotkeys
Gui 3: -Caption
Menu, Tray, Icon, %A_ScriptDir%\PULSE Logo.ico
WinSet, Transparent, %value%
return

Close2:
Gui 3: Destroy
Gui 1: Show
return

DropDownChanged2:
GuiControlGet, selectedSection,, SectionList

if (selectedSection != " ***** Make a Selection ***** ") {
    GoSub, ButtonClicked2
}

return

ButtonClicked2:
GuiControl,, HotkeysText, Enter new hotkey
GuiControl, Focus, ChosenHotkey
return

HotkeyChanged:
IniWrite, %ChosenHotkey%, Config.ini, %selectedSection%, Hotkey
Gui, 3: Destroy
Gui, 1: Show
Loop, 100
{
	MouseGetPos, xm, ym
	Tooltip, Hotkey has been updated in the config file., %xm%+15, %ym%+15, 1
	Sleep, 25
}
Tooltip
return

ResumeB:
GuiControl,,State3, Running
GuiControl,,ScriptBlue, %scriptname%
Pause
Return

PauseB:
GuiControl,,State2, Paused
GuiControl,,ScriptRed, %scriptname%
Pause
Return

Configcheck:
{
	IniRead, lhk1, PULSE Config.ini, PULSE Hotkey, start
	IniRead, lhk2, PULSE Config.ini, PULSE Hotkey, coord/pause
	IniRead, lhk3, PULSE Config.ini, PULSE Hotkey, config/resume
	IniRead, lhk4, PULSE Config.ini, PULSE Hotkey, exit
}
return

UpdateCountdown:
RemainingTime := EndTime - A_TickCount
if (RemainingTime > 0) {
	GuiControl,, State3, % RandomSleepAmountToMinutesSeconds(RemainingTime)
}
return

RandomSleepAmountToMinutesSeconds(time) {
	minutes := Floor(time / 60000)
	seconds := Mod(Floor(time / 1000), 60)
	return minutes . "m " . seconds . "s"
}
return

DisableButton(disable := true) {
	Control, Disable,, start
	
	IniRead, lhk1, PULSE Config.ini, PULSE Hotkey, start
	Hotkey, %lhk1%, off
}

EnableButton(enable := true) {
	Control, Enable,, start
	
	IniRead, lhk1, PULSE Config.ini, PULSE Hotkey, start
	Hotkey, %lhk1%, On
}

ExitB:
guiclose:
exitapp

Start:
ConfigError()
If (frcount = 0)
{
	IniRead, lhk1, PULSE Config.ini, PULSE Hotkey, start
	IniRead, lhk2, PULSE Config.ini, PULSE Hotkey, coord/pause
	IniRead, lhk3, PULSE Config.ini, PULSE Hotkey, config/resume
	IniRead, lhk4, PULSE Config.ini, PULSE Hotkey, exit
	IniRead, value, PULSE Config.ini, Transparent, value
	
	Hotkey %lhk1%, Start
	Hotkey %lhk2%, pauseb
	Hotkey %lhk3%, resumeb
	Hotkey %lhk4%, exitb
	
	WinGetPos, X, Y,,, PULSE
	Gui destroy
	Gui +LastFound +OwnDialogs +AlwaysOnTop
	Gui, Font, s11
	Gui, font, bold
	Gui, Add, Button, x15 y5 w190 h25 gStart , Start %scriptname%
	Gui, Add, Button, x15 y35 w90 h25 gPauseb , Pause
	Gui, Add, Button, x115 y35 w90 h25 gResumeb , Resume
	Gui, Add, Button, x35 y140 w150 h25 gExitb , Exit PULSE
	Gui, Add, Text, x135 y90 w65 h25 center vCounter
	Gui, Add, Text, x8 y90 w125 h25, Total Run Count
	Gui, Add, Text, x8 y65 w125 h25, Run Count
	Gui, Add, Text, x135 y65 w150 h25 vCounter2
	Gui, Font, cGreen
	Gui, Add, Text, x135 y115 w70 h25 vState1
	Gui, Add, Text, x8 y115 w125 h25 vScriptGreen
	Gui, Font, cBlue
	Gui, Add, Text, x135 y115 w70 h25 vState3
	Gui, Add, Text, x8 y115 w125 h25 vScriptBlue
	Gui, Font, cRed
	Gui, Add, Text, x135 y115 w70 h25 vState2
	Gui, Add, Text, x8 y115 w125 h25 vScriptRed
	GuiControl,,State2, ** OFF **
	Gui, Add, Text, x8 y115 w125 h25, %scriptname%
	Menu, Tray, Icon, %A_ScriptDir%\PULSE Logo.ico
	WinSet, Transparent, %value%
	Gui, Show,w220 h170, PULSE
	WinMove, PULSE,, X, Y,
	
	count = 0
	++frcount
}

else
	
sleep 250

InputBox, runcount, Run How Many Times?,,,250, 100
if (runcount = "" or runcount = 0)
{
	MsgBox, 48, Invalid Input, Please enter a valid number greater than 0.
	return
}

sleep 250

GuiControl,,ScriptBlue, %scriptname% 
GuiControl,,State3, Running

runcount3 = %runcount%
count2 = 0
StartTime := A_TickCount
StartTimeStamp = %A_Hour%:%A_Min%:%A_Sec%
sleepcount = 0
totalSleepTime := 0
firstrun = 0

loop % runcount
{ 	
	If firstrun = 0
	{
		winactivate, RuneScape	
		
		++count
		++count2
		++firstrun
		
		GuiControl,,Counter, %count%
		GuiControl,,Counter2, %count2% / %runcount3%
		GuiControl,,ScriptBlue, %scriptname%
		GuiControl,,State3, Running
		DisableButton()
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Pedestal - Pedestal, xmin
		IniRead, x2, Config.ini, Pedestal - Pedestal, xmax
		IniRead, y1, Config.ini, Pedestal - Pedestal, ymin
		IniRead, y2, Config.ini, Pedestal - Pedestal, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
		
		IniRead, sa1, Config.ini, Sleep Short, min
		IniRead, sa2, Config.ini, Sleep Short, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Ritual Type, xmin
		IniRead, x2, Config.ini, Ritual Type, xmax
		IniRead, y1, Config.ini, Ritual Type, ymin
		IniRead, y2, Config.ini, Ritual Type, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
		
		IniRead, sa1, Config.ini, Sleep Short, min
		IniRead, sa2, Config.ini, Sleep Short, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		send {space}
		
		IniRead, sa1, Config.ini, Sleep Normal, min
		IniRead, sa2, Config.ini, Sleep Normal, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Pedestal - Pedestal, xmin
		IniRead, x2, Config.ini, Pedestal - Pedestal, xmax
		IniRead, y1, Config.ini, Pedestal - Pedestal, ymin
		IniRead, y2, Config.ini, Pedestal - Pedestal, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		MouseClick, r, %x%, %y%
		
		IniRead, sa1, Config.ini, Sleep Short, min
		IniRead, sa2, Config.ini, Sleep Short, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		IniRead, minx, Config.ini, Offset, minx
		IniRead, maxx, Config.ini, Offset, maxx
		IniRead, miny, Config.ini, Offset, miny
		IniRead, maxy, Config.ini, Offset, maxy
		
		MouseGetPos, RightClickX, RightClickY
		
		Random, XOffset, %minx%, %maxx%
		Random, YOffset, %miny%, %maxy%
		
		TargetX := RightClickX + XOffset
		TargetY := RightClickY + YOffset
		
		MouseClick, left, %TargetX%, %TargetY%
		
		IniRead, sa1, Config.ini, Sleep Repair, min
		IniRead, sa2, Config.ini, Sleep Repair, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Platform, xmin
		IniRead, x2, Config.ini, Platform, xmax
		IniRead, y1, Config.ini, Platform, ymin
		IniRead, y2, Config.ini, Platform, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
		
		IniRead, sa1, Config.ini, Sleep Walk, min
		IniRead, sa2, Config.ini, Sleep Walk, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		IniRead, sa1, Config.ini, Sleep Ritual, min
		IniRead, sa2, Config.ini, Sleep Ritual, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
	}
	If firstrun = 1
	{
		++count
		++count2
		firstrun=0
		
		winactivate, RuneScape	
		
		GuiControl,,Counter, %count%
		GuiControl,,Counter2, %count2% / %runcount3%
		GuiControl,,ScriptBlue, %scriptname%
		GuiControl,,State3, Running
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Pedestal - Platform, xmin
		IniRead, x2, Config.ini, Pedestal - Platform, xmax
		IniRead, y1, Config.ini, Pedestal - Platform, ymin
		IniRead, y2, Config.ini, Pedestal - Platform, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		MouseClick, r, %x%, %y%
		
		IniRead, sa1, Config.ini, Sleep Short, min
		IniRead, sa2, Config.ini, Sleep Short, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		IniRead, minx, Config.ini, Offset, minx
		IniRead, maxx, Config.ini, Offset, maxx
		IniRead, miny, Config.ini, Offset, miny
		IniRead, maxy, Config.ini, Offset, maxy
		
		MouseGetPos, RightClickX, RightClickY
		
		Random, XOffset, %minx%, %maxx%
		Random, YOffset, %miny%, %maxy%
		
		TargetX := RightClickX + XOffset
		TargetY := RightClickY + YOffset
		
		MouseClick, left, %TargetX%, %TargetY%
		
		IniRead, sa1, Config.ini, Sleep Walk, min
		IniRead, sa2, Config.ini, Sleep Walk, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		IniRead, option, PULSE Config.ini, Random Sleep, option
		if option = true
		{
			IniRead, chance, PULSE Config.ini, Random Sleep, chance
			Random, RandomNumber, 1, 100
			
			if % RandomNumber <= chance
			{
				
				++sleepcount
				GuiControl,, ScriptBlue, Random Sleep
				GuiControl,, State3, % RandomSleepAmountToMinutesSeconds(RandomSleepAmount)
				
				IniRead, rs1, PULSE Config.ini, Random Sleep, min
				IniRead, rs2, PULSE Config.ini, Random Sleep, max
				Random, RandomSleepAmount, %rs1%, %rs2%
				
				SetTimer, UpdateCountdown, 1000
				EndTime := A_TickCount + RandomSleepAmount
				totalSleepTime += RandomSleepAmount
				Sleep, RandomSleepAmount
				SetTimer, UpdateCountdown, Off
				
				GuiControl,,ScriptBlue, %scriptname%
				GuiControl,,State3, Running
			}
		}
		
		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Platform, xmin
		IniRead, x2, Config.ini, Platform, xmax
		IniRead, y1, Config.ini, Platform, ymin
		IniRead, y2, Config.ini, Platform, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
	}
	If firstrun = 0
	{
		++firstrun
		
		IniRead, sa1, Config.ini, Sleep Walk, min
		IniRead, sa2, Config.ini, Sleep Walk, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
		
		IniRead, sa1, Config.ini, Sleep Ritual, min
		IniRead, sa2, Config.ini, Sleep Ritual, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%
	}	
}

		CoordMode, Mouse, Screen
		IniRead, x1, Config.ini, Pedestal - Platform, xmin
		IniRead, x2, Config.ini, Pedestal - Platform, xmax
		IniRead, y1, Config.ini, Pedestal - Platform, ymin
		IniRead, y2, Config.ini, Pedestal - Platform, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%

IniRead, sa1, Config.ini, Sleep Walk, min
IniRead, sa2, Config.ini, Sleep Walk, max
Random, SleepAmount, %sa1%, %sa2%
Sleep, %SleepAmount%

send {esc}

IniRead, sa1, Config.ini, Sleep Brief, min
IniRead, sa2, Config.ini, Sleep Brief, max
Random, SleepAmount, %sa1%, %sa2%
Sleep, %SleepAmount%	

IniRead, option, PULSE Config.ini, Logout, option
if option=true
{
		send {esc}	
		
		IniRead, sa1, Config.ini, Sleep Short, min
		IniRead, sa2, Config.ini, Sleep Short, max
		Random, SleepAmount, %sa1%, %sa2%
		Sleep, %SleepAmount%	
		
		CoordMode, Mouse, Screen
		IniRead, x1, PULSE Config.ini, Logout, xmin
		IniRead, x2, PULSE Config.ini, Logout, xmax
		IniRead, y1, PULSE Config.ini, Logout, ymin
		IniRead, y2, PULSE Config.ini, Logout, ymax
		Random, x, %x1%, %x2%
		Random, y, %y1%, %y2%
		Click, %x%, %y%
}

GuiControl,,ScriptGreen, %scriptname%
GuiControl,,State1, Finished

EndTimeStamp = %A_Hour%:%A_Min%:%A_Sec%
EndTime := A_TickCount
TotalTime := (EndTime - StartTime) / 1000
AverageTime := TotalTime / runcount3

TotalTimeHours := Floor(TotalTime / 3600)
TotalTimeMinutes := Mod(Floor(TotalTime / 60), 60)
TotalTimeSeconds := Mod(TotalTime, 60)

AverageTimeMinutes := Floor(AverageTime / 60)
AverageTimeSeconds := Mod(AverageTime, 60)

TotalTimeHours := Round(TotalTimeHours)
TotalTimeMinutes := Round(TotalTimeMinutes)
TotalTimeSeconds := Round(TotalTimeSeconds)
AverageTimeMinutes := Round(AverageTimeMinutes)
AverageTimeSeconds := Round(AverageTimeSeconds)

percentage := Round((sleepcount / runcount) * 100)

totalSleepTimeSeconds := Floor(totalSleepTime / 1000)
TotalSleepHours := Floor(totalSleepTimeSeconds / 3600)
TotalSleepMinutes := Floor(Mod(totalSleepTimeSeconds, 3600) / 60)
TotalSleepSeconds := Mod(totalSleepTimeSeconds, 60)

SoundPlay, C:\Windows\Media\Ring06.wav, 1
IniRead, chance, PULSE Config.ini, Random Sleep, chance
MsgBox, 64, PULSE Run Info, %scriptname% has completed %runcount3% runs`n`nTotal time: %TotalTimeHours%h : %TotalTimeMinutes%m : %TotalTimeSeconds%s`nAverage loop: %AverageTimeMinutes%m : %AverageTimeSeconds%s`n`nStart time: %starttimestamp%`nEnd time: %endtimestamp%`n`nSet chance: %chance%`%`nActual chance: %percentage%`%`nTotal random sleeps: %sleepcount%`nTotal time slept: %TotalSleepHours%h : %TotalSleepMinutes%m : %TotalSleepSeconds%s

EnableButton()
return