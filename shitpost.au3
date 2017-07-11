#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#Include <FF.au3>
#include <File.au3>
#include <Array.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#RequireAdmin
opt ("WinTitleMatchMode",2)

;;;;;;;;;;; check for the browser ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
if ProcessExists("firefox.exe") <> 0 Then
	MsgBox (0,"","firefox exists, hooking!",5)
Else
	run(IniRead ("settings.ini","config","browserpath","C:\Program Files (x86)\Mozilla Firefox\") & "firefox.exe /repl /repl 4242")
	Winwait("Mozilla Firefox")
EndIf

If _FFConnect(Default, Default, 3000) Then
    if _FFTabExists("Steemit Chat") = 0 Then
	_FFOpenURL("https://steemit.chat/channel/general")
    Sleep(10000)
	Else
	EndIf
Else
    MsgBox(64, "", "Can't connect to FireFox!")
EndIf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;; GUI ;;;;;;;;;;;;;;

$form = GUICreate("Renzo's Shitpost spammer", 462, 220, 192, 124)
$Label1 = GUICtrlCreateLabel("Article URL", 200, 16, 58, 17)
$Label2 = GUICtrlCreateLabel("Channels sepparated by commas (postpromotion,mypostssucks,Idonwanttotype)", 32, 72, 380, 17)

$URL_GUI = GUICtrlCreateInput(iniread("settings.ini","config","text","not setup"), 8, 40, 441, 21)
$channels_GUI = GUICtrlCreateEdit(IniRead ("settings.ini","config","channels","not setup"), 8, 96, 441, 81, BitOR($ES_WANTRETURN,$WS_VSCROLL))
;~ GUICtrlSetData(-1, "")

$save_btn = GUICtrlCreateButton("Save and Run", 8, 184, 443, 25)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $save_btn
			save()
			GUIDelete($form)
			MsgBox (0,"How to","You can stop the program anytime you want by right clicking the icon in your traybar (next to your clock)")
			loop()
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
;;;;;;;;;;; GUI END ;;;;;;;;;;;;

;;;;;;;;;; functions ;;;;;;;;;;;
func send_text($text) ;;;;;;;;;;; This function sends the text, duh!
 Sleep (2000)
_FFSetValue($text,"msg","name") ;; sets the chat text
sleep (1000)
ControlSend("(•) Steemit Chat","","","{ENTER}")
EndFunc

func join_and_send($text,$channel)
_FFOpenURL("https://steemit.chat/channel/" & $channel)
sleep (5000) ; a small delay, allowing it to load the page scripts
_FFClick("button join", "class")
sleep (3000)
send_text($text)
EndFunc

Func loop()
	while 1
	$channels = StringSplit(iniread("settings.ini","config","channels","postpromotion"),",",2)
	For $vElement In $channels
	join_and_send(iniread ("settings.ini","config","text","I am a retard and didn't configure it"),$vElement)
	Next
	sleep (1200000) ;;;;; 20 minutes
	WEnd
EndFunc

Func save()
$ini = "settings.ini"
IniWrite ($ini,"config","text",GUICtrlRead($URL_GUI))
IniWrite ($ini,"config","channels",GUICtrlRead($channels_GUI))
EndFunc
