#SingleInstance force
#NoEnv
#include CvJoyInterface.ahk
SetBatchLines, -1
#ErrorStdOut
; 使用类似 Xbox 的键序

; 变量------------------------------------------------------------------------------------------
inifile := "Hotkeys.ini"
; Stick 控制相关变量
btn_press := 1
btn_free := 0

axis_low := 0
axis_ori := 16384
axis_over := 32768

r_axis_low := 0
r_axis_over := 32768
l_axis_low := 0
l_axis_over := 32768
l_lite := false
r_lite := false
; axis 值：0-16384-32768
;        上   恢复    下
;        左           右

; 键位的序号
L_stick_x := 1 ;y
L_stick_y := 2 ;y
R_stick_x := 3 ;y qe z
R_stick_y := 6 ;y nm rz
btn_A := 3	;y k
btn_B := 2	;y l
btn_X := 4	;y j
btn_Y := 1	;Y i
btn_L := 11	;y v
btn_R := 12 ;y
btn_LB := 7	;y r ps的bt是相反的
btn_LT := 5	;y y
btn_RB := 8	;y u ps的bt是相反的
btn_RT := 6 	;y o
btn_Lop := 9 ;Y c 左边的操作键
btn_Rop := 10 ;Y b 右边的操作键
btn_gui := 14  ;特色按键

L_up := 0x8
L_left := 0x4
L_down := 0x2
L_right := 0x1
R_up := 0x8
R_left := 0x4
R_down := 0x2
R_right := 0x1

whichbtnL := 0x0
whichbtnR := 0x0
logfile := "log.txt"

;POV Var
POV_Index = 1
u := 0 ;上/36000
ru := 4500
r := 9000
rd := 13500
d := 18000
ld := 22500
l := 27000
lu := 31500
D_up := 0x8 ;pov t
D_left := 0x4 ;pov f
D_down := 0x2 ;pov g
D_right := 0x1 ;pov h
whichbtnD := 0x0

hotkeyLabels := Object()
hotkeyLabels.Insert("左摇杆 上")
hotkeyLabels.Insert("左摇杆 下")
hotkeyLabels.Insert("左摇杆 左")
hotkeyLabels.Insert("左摇杆 右")
hotkeyLabels.Insert("L")
hotkeyLabels.Insert("R")
hotkeyLabels.Insert("A")
hotkeyLabels.Insert("B")
hotkeyLabels.Insert("X")
hotkeyLabels.Insert("Y")
hotkeyLabels.Insert("L-B")
hotkeyLabels.Insert("L-T")
hotkeyLabels.Insert("R-B")
hotkeyLabels.Insert("R-T")
hotkeyLabels.Insert("右摇杆 上")
hotkeyLabels.Insert("右摇杆 下")
hotkeyLabels.Insert("右摇杆 左")
hotkeyLabels.Insert("右摇杆 右")
hotkeyLabels.Insert("Start")
hotkeyLabels.Insert("Menu")
hotkeyLabels.Insert("方向键 上")
hotkeyLabels.Insert("方向键 下")
hotkeyLabels.Insert("方向键 左")
hotkeyLabels.Insert("方向键 右")
hotkeyLabels.Insert("西瓜键") ; 西瓜键或者ps板
hotkeyLabels.Insert("镜像 A")
hotkeyLabels.Insert("镜像 B")
hotkeyLabels.Insert("镜像 X")
hotkeyLabels.Insert("镜像 Y")
hotkeyLabels.Insert("镜像 L-B")
hotkeyLabels.Insert("镜像 L-T")
hotkeyLabels.Insert("镜像 R-B")
hotkeyLabels.Insert("镜像 R-T")
hotkeyLabels.Insert("L 摇杆 轻推")
hotkeyLabels.Insert("R 摇杆 轻推")

#ctrls = 35 ;Total number of Key's we will be binding

; 函数------------------------------------------------------------------------------------------
Menu, Tray, Click, 1
;Menu, Tray, NoStandard
Menu, Tray, Add, Edit Controls, ShowGui
Menu, Tray, Default, Edit Controls

Gui, Add, Text, section h15, 使用说明:
gui, add, Text, h15, 1.玩需要管理员权限的游戏请手动以管理员打开软件
gui, add, Text, h15, 2.按 Ctrl + Alt + R 或者 F6 可以刷新vjoy
gui, add, text, h15, 3.需要打字时,按功能键 Pause 或者 F7 可以暂停模拟,再次按可继续模拟`n

for index, element in hotkeyLabels{
	if ( index <= 18)
		Gui, Add, Text, y+18 x10 w100 right vLB%index%, %element%:
	else if index = 19
		gui, add, text, ym y137 x330 w100 right vLB%index%, %element%:
	else
		Gui, Add, Text, y+18 x330 w100 right vLB%index%, %element%:
	IniRead, savedHK%index%, %inifile%, Hotkeys, %index%, %A_Space%
	If savedHK%index% ;Check for saved hotkeys in INI file.
		Hotkey,% savedHK%index%, Label%index% ;Activate saved hotkeys if found.
	IniRead, savedHK%index%, Hotkeys.ini, Hotkeys, %index%, %A_Space%
	If savedHK%index% ;Check for saved hotkeys in INI file.
		Hotkey,% savedHK%index%, Label%index% ;Activate saved hotkeys if found.
	Hotkey,% savedHK%index% . " UP", Label%index%_UP ;Activate saved hotkeys if found.
	;TrayTip, MyStick, Label%index%_UP, 3, 0
	;TrayTip, MyStick, % savedHK%A_Index%, 3, 0
	;TrayTip, MyStick, % savedHK%index% . " UP", 3, 0
	checked := false
	if(!InStr(savedHK%index%, "~", false)){
		checked := true
	}
	StringReplace, noMods, savedHK%index%, ~ ;Remove tilde (~) and Win (#) modifiers...
	StringReplace, noMods, noMods, #,,UseErrorLevel ;They are incompatible with hotkey controls (cannot be shown).
	Gui, Add, Hotkey, x+5 vHK%index% gGuiLabel, %noMods% ;Add hotkey controls and show saved hotkeys.
	if(!checked)
		Gui, Add, CheckBox, x+5 h15 vCB%index% gGuiLabel, 按键独占 ;Add checkboxes to allow the Windows key (#) as a modifier..
	else
		Gui, Add, CheckBox, x+5 h15 vCB%index% Checked gGuiLabel, 按键独占 ;Add checkboxes to allow the Windows key (#) as a modifier..
} ;Check the box if Win modifier is used.

;----------Start Hotkey Handling-----------

; Create an object from vJoy Interface Class.
vJoyInterface := new CvJoyInterface()

; Was vJoy installed and the DLL Loaded?
if (!vJoyInterface.vJoyEnabled()){
	; Show log of what happened
	Msgbox % vJoyInterface.LoadLibraryLog
	ExitApp
}

myStick := vJoyInterface.Devices[1]

;Alert User that script has started
TrayTip, MyStick, Script Started, 3, 0

; stick 摇杆量模拟函数
stickemu(){

	Return
}

; 复位
stickreset(){
	global myStick
	Loop, 24 {
		myStick.SetBtn(0, A_Index)
	}
	Return
}

writelog(num){
	global logfile
	FileAppend, %num%`n, %logfile%
	return
}

stickD(){
	global
	if (whichbtnD = 8 or whichbtnD = 13){
		;w up
		myStick.SetContPov(u,POV_Index)
	}
	else if (whichbtnD = 4 or whichbtnD = 14){
		;a left
		myStick.SetContPov(l,POV_Index)
	}
	else if (whichbtnD = 1 or whichbtnD = 11){
		;d right
		myStick.SetContPov(r,POV_Index)
	}
	else if (whichbtnD = 2 or whichbtnD = 7){
		;s down
		myStick.SetContPov(d,POV_Index)
	}
	else if (whichbtnD = 12){
		;wa up left
		myStick.SetContPov(lu,POV_Index)
	}
	else if (whichbtnD = 9){
		;wd up right
		myStick.SetContPov(ru,POV_Index)
	}
	else if (whichbtnD = 6){
		;as left down
		myStick.SetContPov(ld,POV_Index)
	}
	else if (whichbtnD = 3){
		;sd down right
		myStick.SetContPov(rd,POV_Index)
	}
	else{
		; none
		myStick.ResetPovs()
	}
	Return
}

stick(stickname){
	global
	if (stickname = "L"){
		_whichbtn := whichbtnL
		_axis_low := l_axis_low
		_axis_over := l_axis_over
		_stick_x := L_stick_x
		_stick_y := L_stick_y
	}
	else if (stickname = "R"){
		_whichbtn := whichbtnR
		_axis_low := r_axis_low
		_axis_over := r_axis_over
		_stick_x := R_stick_x
		_stick_y := R_stick_y
	}
	Else {
		Return
	}
	; writelog(_whichbtn)
	if (_whichbtn = 8 or _whichbtn = 13){
		;w up
		;up;up
		myStick.SetAxisByIndex(_axis_low,_stick_y)
		;none r l
		myStick.SetAxisByIndex(axis_ori,_stick_x)
	}
	else if (_whichbtn = 4 or _whichbtn = 14){
		;a left
		; left
		myStick.SetAxisByIndex(_axis_low,_stick_x)
		;nono up down
		myStick.SetAxisByIndex(axis_ori,_stick_y)
	}
	else if (_whichbtn = 1 or _whichbtn = 11){
		;d right
		;right
		myStick.SetAxisByIndex(_axis_over,_stick_x)
		;nono up down
		myStick.SetAxisByIndex(axis_ori,_stick_y)
	}
	else if (_whichbtn = 2 or _whichbtn = 7){
		;s down
		;down
		myStick.SetAxisByIndex(_axis_over,_stick_y)
		;none r l
		myStick.SetAxisByIndex(axis_ori,_stick_x)
	}
	else if (_whichbtn = 12){
		;wa up left
		; left
		myStick.SetAxisByIndex(_axis_low,_stick_x)
		;up;up
		myStick.SetAxisByIndex(_axis_low,_stick_y)
	}
	else if (_whichbtn = 9){
		;wd up right
		;up;up
		myStick.SetAxisByIndex(_axis_low,_stick_y)
		;right
		myStick.SetAxisByIndex(_axis_over,_stick_x)
	}
	else if (_whichbtn = 6){
		;as left down
		; left
		myStick.SetAxisByIndex(_axis_low,_stick_x)
		;down
		myStick.SetAxisByIndex(_axis_over,_stick_y)
	}
	else if (_whichbtn = 3){
		;sd down right
		;down
		myStick.SetAxisByIndex(_axis_over,_stick_y)
		;right
		myStick.SetAxisByIndex(_axis_over,_stick_x)
	}
	else{
		; none
		myStick.SetAxisByIndex(axis_ori,_stick_x)
		myStick.SetAxisByIndex(axis_ori,_stick_y)
	}
	Return
}

validateHK(GuiControl) {
	global lastHK
	Gui, Submit, NoHide
	lastHK := %GuiControl% ;Backup the hotkey, in case it needs to be reshown.
	num := SubStr(GuiControl,3) ;Get the index number of the hotkey control.
	If (HK%num% != "") { ;If the hotkey is not blank...
		StringReplace, HK%num%, HK%num%, SC15D, AppsKey ;Use friendlier names,
		StringReplace, HK%num%, HK%num%, SC154, PrintScreen ;  instead of these scan codes.
		;If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
		;HK%num% := "#" HK%num%
		If (!CB%num% && !RegExMatch(HK%num%,"[#!\^\+]")) ;  If the new hotkey has no modifiers, add the (~) modifier.
			HK%num% := "~" HK%num% ;    This prevents any key from being blocked.
		checkDuplicateHK(num)
	}
	If (savedHK%num% || HK%num%) ;Unless both are empty,
		setHK(num, savedHK%num%, HK%num%) ;  update INI/GUI
}

checkDuplicateHK(num) {
	global #ctrls
	Loop,% #ctrls
		If (HK%num% = savedHK%A_Index%) {
			dup := A_Index
			TrayTip, MyStick, Hotkey Already Taken, 3, 0
			Loop,6 {
				GuiControl,% "Disable" b:=!b, HK%dup% ;Flash the original hotkey to alert the user.
				Sleep,200
			}
			GuiControl,,HK%num%,% HK%num% :="" ;Delete the hotkey and clear the control.
			break
		}
	}

	setHK(num,INI,GUI) {
		If INI{ ;If previous hotkey exists,
			Hotkey, %INI%, Label%num%, Off ;  disable it.
			Hotkey, %INI% UP, Label%num%_UP, Off ;  disable it.
		}
		If GUI{ ;If new hotkey exists,
			Hotkey, %GUI%, Label%num%, On ;  enable it.
			Hotkey, %GUI% UP, Label%num%_UP, On ;  enable it.
		}
		IniWrite,% GUI ? GUI:null, Hotkeys.ini, Hotkeys, %num%
		savedHK%num% := HK%num%
		;TrayTip, Label%num%,% !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
	}

	#MenuMaskKey vk07 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
	*AppsKey:: ;Add support for these special keys,
	*BackSpace:: ;  which the hotkey control does not normally allow.
	*Delete::
	*Enter::
	*Escape::
	*Pause::
	*PrintScreen::
	*Space::
	*Tab::
		modifier := ""
		If GetKeyState("Shift","P")
			modifier .= "+"
		If GetKeyState("Ctrl","P")
			modifier .= "^"
		If GetKeyState("Alt","P")
			modifier .= "!"
		Gui, Submit, NoHide ;If BackSpace is the first key press, Gui has never been submitted.
		If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier) ;If the control has text but no modifiers held,
			GuiControl,,%ctrl% ;  allow BackSpace to clear that text.
		Else ;Otherwise,
			GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2) ;  show the hotkey.
		validateHK(ctrl)
	return
#If

HotkeyCtrlHasFocus() {
	GuiControlGet, ctrl, Focus ;ClassNN
	If InStr(ctrl,"hotkey") {
		GuiControlGet, ctrl, FocusV ;Associated variable
		Return, ctrl
	}
}

; GUI------------------------------------------------------------------------------------------

;Show GUI from tray Icon
ShowGui:
	Gui, show,h730, MyStick Xbox 键序
	GuiControl, Focus, LB1 ; this puts the windows "focus" on the checkbox, that way it isn't immediately waiting for input on the 1st input box
return

GuiLabel:
	If %A_GuiControl% in +,^,!,+^,+!,^!,+^! ;If the hotkey contains only modifiers, return to wait for a key.
		return
	If InStr(%A_GuiControl%,"vk07") ;vk07 = MenuMaskKey (see below)
		GuiControl,,%A_GuiControl%, % lastHK ;Reshow the hotkey, because MenuMaskKey clears it.
	Else
		validateHK(A_GuiControl)
return

;-------macros

Pause::Suspend
F7::Suspend
^!r::
	stickreset()
	myStick.SetAxisByIndex(axis_ori,1)
	myStick.SetAxisByIndex(axis_ori,2)
	myStick.SetAxisByIndex(axis_ori,3)
	myStick.SetAxisByIndex(axis_ori,4)
	myStick.SetAxisByIndex(axis_ori,5)
	myStick.SetAxisByIndex(axis_ori,6)
	myStick.SetAxisByIndex(axis_ori,7)
	myStick.SetAxisByIndex(axis_ori,8)
Return
SetKeyDelay, 0
#MaxHotkeysPerInterval 200

^!s::
	Suspend
	If A_IsSuspended
		TrayTip, MyStick, Hotkeys Disabled, 3, 0
	Else
		TrayTip, MyStick, Hotkeys Enabled, 3, 0
Return

;           //// STICK ////
; 按键------------------------------------------------------------------------------------------
;---- L-Stick UP ----
Label1:
	whichbtnL := whichbtnL | L_up
	stick("L")
return

Label1_UP:
	whichbtnL := whichbtnL &~ L_up
	stick("L")
return

;---- L-Stick Downn ----
Label2:
	whichbtnL := whichbtnL | L_down
	stick("L")
return

Label2_UP:
	whichbtnL := whichbtnL &~ L_down
	stick("L")
return

;---- L-Stick left ----
Label3:
	whichbtnL := whichbtnL | L_left
	stick("L")
return

Label3_UP:
	whichbtnL := whichbtnL &~ L_left
	stick("L")
return

;---- L-Stick RIGHT ----
Label4:
	whichbtnL := whichbtnL | L_right
	stick("L")
return

Label4_UP:
	whichbtnL := whichbtnL &~ L_right
	stick("L")
return

;---- L-Stick ----
Label5:
	myStick.SetBtn(btn_press,btn_L)
return

Label5_UP:
	myStick.SetBtn(btn_free,btn_L)
return

;---- R-Stick ----
Label6:
	myStick.SetBtn(btn_press,btn_R)
return
Label6_UP:
	myStick.SetBtn(btn_free,btn_R)
return

;           //// BUTTONS ////
;---- A ----
Label7:
	myStick.SetBtn(btn_press,btn_A)
Return

Label7_UP:
	myStick.SetBtn(btn_free,btn_A)
Return

;---- B ----
Label8:
	myStick.SetBtn(btn_press,btn_B)
Return

Label8_UP:
	myStick.SetBtn(btn_free,btn_B)
Return

;---- X ----
Label9:
	myStick.SetBtn(btn_press,btn_X)
Return

Label9_UP:
	myStick.SetBtn(btn_free,btn_X)
Return

;---- Y ----
Label10:
	myStick.SetBtn(btn_press,btn_Y)
Return

Label10_UP:
	myStick.SetBtn(btn_free,btn_Y)
Return

;---- L-B ----
Label11:
	myStick.SetBtn(btn_press,btn_LB)
Return

Label11_UP:
	myStick.SetBtn(btn_free,btn_LB)
Return

;---- L-T ----
Label12:
	myStick.SetBtn(btn_press,btn_LT)
Return

Label12_UP:
	myStick.SetBtn(btn_free,btn_LT)
Return

;---- R-B ----
Label13:
	myStick.SetBtn(btn_press,btn_RB)
Return

Label13_UP:
	myStick.SetBtn(btn_free,btn_RB)
Return

;           //// C-STICK ////
;---- R-T ----
Label14:
	myStick.SetBtn(btn_press,btn_RT)
Return

Label14_UP:
	myStick.SetBtn(btn_free,btn_RT)
Return

;---- R-Stick UP ----
Label15:
	whichbtnR := whichbtnR | R_up
	stick("R")
Return

Label15_UP:
	whichbtnR := whichbtnR &~ R_up
	stick("R")
return

;---- R-Stick Down ----
Label16:
	whichbtnR := whichbtnR | R_down
	stick("R")
return

Label16_UP:
	whichbtnR := whichbtnR &~ R_down
	stick("R")
return

;---- R-Stick left ----
Label17:
	whichbtnR := whichbtnR | R_left
	stick("R")
return

Label17_UP:
	whichbtnR := whichbtnR &~ R_left
	stick("R")
return

;---- R-Stick Right ----
Label18:
	whichbtnR := whichbtnR | R_right
	stick("R")
return

Label18_UP:
	whichbtnR := whichbtnR &~ R_right
	stick("R")
return

;           //// OTHER BUTTONS ////
;---- Start ----
Label19:
	myStick.SetBtn(btn_press,btn_Lop)
Return

Label19_UP:
	myStick.SetBtn(btn_free,btn_Lop)
Return

;---- Menu ----
Label20:
	myStick.SetBtn(btn_press,btn_Rop)
Return

Label20_UP:
	myStick.SetBtn(btn_free,btn_Rop)
Return

;---- DPAD UP ----
Label21:
	whichbtnD := whichbtnD | D_up
	stickD()
Return

Label21_UP:
	whichbtnD := whichbtnD &~ D_up
	stickD()
Return

;---- DPAD DOWN ----
Label22:
	whichbtnD := whichbtnD | D_down
	stickD()
Return

Label22_UP:
	whichbtnD := whichbtnD &~ D_down
	stickD()
Return
;---- DPAD Left ----
Label23:
	whichbtnD := whichbtnD | D_left
	stickD()
Return

Label23_UP:
	whichbtnD := whichbtnD &~ D_left
	stickD()
Return
;---- DPAD Right ----
Label24:
	whichbtnD := whichbtnD | D_right
	stickD()
Return

Label24_UP:
	whichbtnD := whichbtnD &~ D_right
	stickD()
Return
;---- Guide ----
Label25:
	myStick.SetBtn(btn_press,btn_gui)
Return

Label25_UP:
	myStick.SetBtn(btn_free,btn_gui)
Return

;---- A ----
Label26:
	myStick.SetBtn(btn_press,btn_A)
Return

Label26_UP:
	myStick.SetBtn(btn_free,btn_A)
Return
;---- B ----
Label27:
	myStick.SetBtn(btn_press,btn_B)
Return

Label27_UP:
	myStick.SetBtn(btn_free,btn_B)
Return
;---- X ----
Label28:
	myStick.SetBtn(btn_press,btn_X)
Return

Label28_UP:
	myStick.SetBtn(btn_free,btn_X)
Return
;---- Y ----
Label29:
	myStick.SetBtn(btn_press,btn_Y)
Return

Label29_UP:
	myStick.SetBtn(btn_free,btn_Y)
Return
;---- LB ----
Label30:
	myStick.SetBtn(btn_press,btn_LB)
Return

Label30_UP:
	myStick.SetBtn(btn_free,btn_LB)
Return
;---- LT ----
Label31:
	myStick.SetBtn(btn_press,btn_LT)
Return

Label31_UP:
	myStick.SetBtn(btn_free,btn_LT)
Return
;---- RB ----
Label32:
	myStick.SetBtn(btn_press,btn_RB)
Return

Label32_UP:
	myStick.SetBtn(btn_free,btn_RB)
Return
;---- RT ----
Label33:
	myStick.SetBtn(btn_press,btn_RT)
Return

Label33_UP:
	myStick.SetBtn(btn_free,btn_RT)
Return

;---- L 轻 ----
Label34:
	; l_lite := true
	if l_lite{ ;如果已开
		l_lite := False	; close and reset
		l_axis_low := axis_low
		l_axis_over := axis_over
		Sleep, 500
	}
	else if !l_lite
	{
		l_lite := true
		l_axis_low := axis_ori - axis_ori//3
		l_axis_over := axis_ori + axis_ori//3
		Sleep, 500
	}
Return

Label34_UP:
	Sleep, 10
Return
;---- R 轻 ----
Label35:
	if r_lite{ ;如果已开
		r_lite := False	; close and reset
		r_axis_low := axis_low
		r_axis_over := axis_over
	}
	else if !r_lite
	{
		r_lite := true
		r_axis_low := axis_ori - axis_ori//3
		r_axis_over := axis_ori + axis_ori//3
	}
Return

Label35_UP:
	; myStick.SetBtn(btn_free,btn_B)
	Sleep, 10
Return

F6::
	; MsgBox, Iteration number
	myStick.SetAxisByIndex(axis_ori,1)
	myStick.SetAxisByIndex(axis_ori,2)
	myStick.SetAxisByIndex(axis_ori,3)
	myStick.SetAxisByIndex(axis_ori,4)
	myStick.SetAxisByIndex(axis_ori,5)
	myStick.SetAxisByIndex(axis_ori,6)
	myStick.SetAxisByIndex(axis_ori,7)
	myStick.SetAxisByIndex(axis_ori,8)
Return

