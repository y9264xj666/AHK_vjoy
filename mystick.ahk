#SingleInstance force
#NoEnv
#include CvJoyInterface.ahk
SetBatchLines, -1

; 我的配置文件，全局性的忽略配置文件
; 使用类似 Xbox 的键序
; Stick 控制相关变量
btn_press := 1
btn_free := 0
axis_low := 0
axis_ori := 16384
axis_over := 32768
; axis 值：0-16384-32768
;        上    恢复   下？
;

L_stick_x := 1 ;y 
L_stick_y := 2 ;y 
R_stick_x := 3 ;y qe z
R_stick_y := 6 ;y nm rz
btn_A := 3	;y k
btn_B := 2	;y l
btn_X := 4	;y j
btn_Y := 1	;Y i
btn_L := 11	;y v
btn_R := 12 ;
btn_LB := 7	;y r
btn_LT := 5	;y y
btn_RB := 8	;y u
btn_RT := 6 	;y o
btn_Lop := 9   ;Y c 左边的操作键
btn_Rop := 10   ;Y b 右边的操作键

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
D_pad_up := False ;pov t
D_pad_down := False ;pov g
D_pad_left := False ;pov f
D_pad_right := False ;pov h

hotkeyLabels := Object()
hotkeyLabels.Insert("L-Stick Up")
hotkeyLabels.Insert("L-Stick Down")
hotkeyLabels.Insert("L-Stick Left")
hotkeyLabels.Insert("L-Stick Right")
hotkeyLabels.Insert("L")
hotkeyLabels.Insert("R")
hotkeyLabels.Insert("Y")
hotkeyLabels.Insert("B")
hotkeyLabels.Insert("A")
hotkeyLabels.Insert("X")
hotkeyLabels.Insert("L-B")
hotkeyLabels.Insert("L-T")
hotkeyLabels.Insert("R-B")
hotkeyLabels.Insert("R-T")
hotkeyLabels.Insert("R-Stick Up")
hotkeyLabels.Insert("R-Stick Down")
hotkeyLabels.Insert("R-Stick Left")
hotkeyLabels.Insert("R-Stick Right")
hotkeyLabels.Insert("Start")
hotkeyLabels.Insert("Menu")
hotkeyLabels.Insert("D-pad Up")
hotkeyLabels.Insert("D-pad Down")
hotkeyLabels.Insert("D-pad Left")
hotkeyLabels.Insert("D-pad Right")

Menu, Tray, Click, 1
;Menu, Tray, NoStandard
Menu, Tray, Add, Edit Controls, ShowGui
Menu, Tray, Default, Edit Controls

#ctrls = 24  ;Total number of Key's we will be binding (excluding UP's)?

for index, element in hotkeyLabels{
 Gui, Add, Text, xm vLB%index%, %element% Hotkey:
 IniRead, savedHK%index%, Hotkeys.ini, Hotkeys, %index%, %A_Space%
 If savedHK%index%                                       ;Check for saved hotkeys in INI file.
  Hotkey,% savedHK%index%, Label%index%                 ;Activate saved hotkeys if found.
  Hotkey,% savedHK%index% . " UP", Label%index%_UP                 ;Activate saved hotkeys if found.
  ;TrayTip, MyStick, Label%index%_UP, 3, 0
  ;TrayTip, MyStick, % savedHK%A_Index%, 3, 0
  ;TrayTip, MyStick, % savedHK%index% . " UP", 3, 0
 checked := false
 if(!InStr(savedHK%index%, "~", false)){
  checked := true
 }
 StringReplace, noMods, savedHK%index%, ~                  ;Remove tilde (~) and Win (#) modifiers...
 StringReplace, noMods, noMods, #,,UseErrorLevel              ;They are incompatible with hotkey controls (cannot be shown).
 Gui, Add, Hotkey, x+5 vHK%index% gGuiLabel, %noMods%        ;Add hotkey controls and show saved hotkeys.
 if(!checked)
  Gui, Add, CheckBox, x+5 vCB%index% gGuiLabel, Prevent Default Behavior  ;Add checkboxes to allow the Windows key (#) as a modifier..
 else
  Gui, Add, CheckBox, x+5 vCB%index% Checked gGuiLabel, Prevent Default Behavior  ;Add checkboxes to allow the Windows key (#) as a modifier..
}                                                               ;Check the box if Win modifier is used.


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



; stick 摇杆模拟函数
stickemu(){

Return
}

stickreset(){
    global myStick
    myStick.ResetButtons()
	; Loop, 8{
	; 	myStick.SetAxisByIndex(axis_ori,A_Index)
    ;     MsgBox, Iteration number is %A_Index%.
    ;     Sleep, 100
	; }
    myStick.SetAxisByIndex(axis_ori,1)
    myStick.SetAxisByIndex(axis_ori,2)
    myStick.SetAxisByIndex(axis_ori,3)
    myStick.SetAxisByIndex(axis_ori,4)
    myStick.SetAxisByIndex(axis_ori,5)
    myStick.SetAxisByIndex(axis_ori,6)
    myStick.SetAxisByIndex(axis_ori,7)
    myStick.SetAxisByIndex(axis_ori,8)
    myStick.ResetPovs()
    Return
}

; Gives stick input based on stick variables
; {x:0x30, y:0x31, z:0x32, rx:0x33, ry:0x34, rz: 0x35, sl1:0x36, sl2:0x37} ; Name (eg "x", "y", "z", "sl1") to HID Descriptor
; 1:l-stick-x  2:l-stick-y 3: ... 4:r-stick-x  5:r-stick-y  6: ...

validateHK(GuiControl) {
 global lastHK
 Gui, Submit, NoHide
 lastHK := %GuiControl%                     ;Backup the hotkey, in case it needs to be reshown.
 num := SubStr(GuiControl,3)                ;Get the index number of the hotkey control.
 If (HK%num% != "") {                       ;If the hotkey is not blank...
  StringReplace, HK%num%, HK%num%, SC15D, AppsKey      ;Use friendlier names,
  StringReplace, HK%num%, HK%num%, SC154, PrintScreen  ;  instead of these scan codes.
  ;If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
   ;HK%num% := "#" HK%num%
  If (!CB%num% && !RegExMatch(HK%num%,"[#!\^\+]"))       ;  If the new hotkey has no modifiers, add the (~) modifier.
   HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
  checkDuplicateHK(num)
 }
 If (savedHK%num% || HK%num%)               ;Unless both are empty,
  setHK(num, savedHK%num%, HK%num%)         ;  update INI/GUI
}

checkDuplicateHK(num) {
 global #ctrls
 Loop,% #ctrls
  If (HK%num% = savedHK%A_Index%) {
   dup := A_Index
   TrayTip, MyStick, Hotkey Already Taken, 3, 0
   Loop,6 {
    GuiControl,% "Disable" b:=!b, HK%dup%   ;Flash the original hotkey to alert the user.
    Sleep,200
   }
   GuiControl,,HK%num%,% HK%num% :=""       ;Delete the hotkey and clear the control.
   break
  }
}

setHK(num,INI,GUI) {
 If INI{                          ;If previous hotkey exists,
  Hotkey, %INI%, Label%num%, Off  ;  disable it.
  Hotkey, %INI% UP, Label%num%_UP, Off  ;  disable it.
}
 If GUI{                           ;If new hotkey exists,
  Hotkey, %GUI%, Label%num%, On   ;  enable it.
  Hotkey, %GUI% UP, Label%num%_UP, On   ;  enable it.
}
 IniWrite,% GUI ? GUI:null, Hotkeys.ini, Hotkeys, %num%
 savedHK%num%  := HK%num%
 ;TrayTip, Label%num%,% !INI ? GUI " ON":!GUI ? INI " OFF":GUI " ON`n" INI " OFF"
}

#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
 *AppsKey::                       ;Add support for these special keys,
 *BackSpace::                     ;  which the hotkey control does not normally allow.
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
  Gui, Submit, NoHide             ;If BackSpace is the first key press, Gui has never been submitted.
  If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)   ;If the control has text but no modifiers held,
   GuiControl,,%ctrl%                                       ;  allow BackSpace to clear that text.
  Else                                                     ;Otherwise,
   GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2)  ;  show the hotkey.
  validateHK(ctrl)
 return
#If

HotkeyCtrlHasFocus() {
 GuiControlGet, ctrl, Focus       ;ClassNN
 If InStr(ctrl,"hotkey") {
  GuiControlGet, ctrl, FocusV     ;Associated variable
  Return, ctrl
 }
}


;----------------------------Labels

;Show GUI from tray Icon
ShowGui:
    Gui, show,, Dynamic Hotkeys
    GuiControl, Focus, LB1 ; this puts the windows "focus" on the checkbox, that way it isn't immediately waiting for input on the 1st input box
return

GuiLabel:
 If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
  return
 If InStr(%A_GuiControl%,"vk07")            ;vk07 = MenuMaskKey (see below)
  GuiControl,,%A_GuiControl%, % lastHK      ;Reshow the hotkey, because MenuMaskKey clears it.
 Else
  validateHK(A_GuiControl)
return

;-------macros

Pause::Suspend
;^!r:: Reload
;^!p:: stickreset()
^!r:: stickreset()
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
;---- L-Stick UP ----
Label1:
	myStick.SetAxisByIndex(axis_low,L_stick_y)
	return

Label1_UP:
	myStick.SetAxisByIndex(axis_ori,L_stick_y)
	return
  
;---- L-Stick Downn ----
Label2:
	myStick.SetAxisByIndex(axis_over,L_stick_y)
	return

Label2_UP:
	myStick.SetAxisByIndex(axis_ori,L_stick_y)
	return

;---- L-Stick left ----
Label3:
	myStick.SetAxisByIndex(axis_low,L_stick_x)
	return
	
Label3_UP:
	myStick.SetAxisByIndex(axis_ori,L_stick_x)
	return
  
;---- L-Stick RIGHT ----
Label4:
	myStick.SetAxisByIndex(axis_over,L_stick_x)
	return

Label4_UP:
	myStick.SetAxisByIndex(axis_ori,L_stick_x)
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
;---- Y ---- 
Label7:
	myStick.SetBtn(btn_press,btn_Y)
	Return

Label7_UP:
	myStick.SetBtn(btn_free,btn_Y)
	Return

;---- B ---- 
Label8:
	myStick.SetBtn(btn_press,btn_B)
	Return

Label8_UP:
	myStick.SetBtn(btn_free,btn_B)
	Return

;---- A ---- 
Label9:
	myStick.SetBtn(btn_press,btn_A)
	Return

Label9_UP:
	myStick.SetBtn(btn_free,btn_A)
	Return

;---- X ---- 
Label10:
	myStick.SetBtn(btn_press,btn_X)
	Return

Label10_UP:
	myStick.SetBtn(btn_free,btn_X)
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
	myStick.SetAxisByIndex(axis_low,R_stick_y)
	Return

Label15_UP:
	myStick.SetAxisByIndex(axis_ori,R_stick_y)
	Return

;---- R-Stick Down ---- 
Label16:
	myStick.SetAxisByIndex(axis_over,R_stick_y)
	Return
  
Label16_UP:
	myStick.SetAxisByIndex(axis_ori,R_stick_y)
	Return
  
;---- R-Stick left ---- 
Label17:
	myStick.SetAxisByIndex(axis_low,R_stick_x)
	Return

Label17_UP:
	myStick.SetAxisByIndex(axis_ori,R_stick_x)
	Return

;---- R-Stick Right ---- 
Label18:
	myStick.SetAxisByIndex(axis_over,R_stick_x)
	Return

Label18_UP:
	myStick.SetAxisByIndex(axis_ori,R_stick_x)
	Return
  
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
	D_pad_up := True
	if D_pad_left{
		myStick.SetContPov(lu,POV_Index)
	}
	else if D_pad_right{
		myStick.SetContPov(ru,POV_Index)
	}
    else if D_pad_down{
        myStick.ResetPovs()
    }
	else{
		myStick.SetContPov(u,POV_Index)
	}
	Return

Label21_UP:
	D_pad_up := False
	if D_pad_left{
		myStick.SetContPov(l,POV_Index)
	}
	Else if D_pad_right{
		myStick.SetContPov(r,POV_Index)
	}
    else if D_pad_down{
        myStick.SetContPov(d,POV_Index)
    }
	Else{
		myStick.ResetPovs()
	}
	; myStick.SetBtn(btn_free,D_pad_up)
	Return
  
;---- DPAD DOWN ---- 
Label22:
	D_pad_down := True
	If D_pad_left{
		myStick.SetContPov(ld,POV_Index)

	}
	else if D_pad_right{
		myStick.SetContPov(rd,POV_Index)
	}
    else if D_pad_up{
        myStick.ResetPovs()
    }
	else {
		myStick.SetContPov(d,POV_Index)
	}
	; myStick.SetBtn(btn_press,D_pad_down)
	Return

Label22_UP:
	; myStick.SetBtn(btn_free,D_pad_down)
	D_pad_down := False
	If D_pad_left{
		myStick.SetContPov(l,POV_Index)

	}
	else if D_pad_right{
		myStick.SetContPov(r,POV_Index)
	}
    else if D_pad_up{
        myStick.SetContPov(u,POV_Index)
    }
	else {		
        myStick.ResetPovs()
	}
	Return  
;---- DPAD Left ---- 
Label23:
	; myStick.SetBtn(btn_press,D_pad_left)
	D_pad_left := True
	if D_pad_up{
		myStick.SetContPov(lu,POV_Index)
	}
	else if D_pad_down {
		myStick.SetContPov(ld,POV_Index)
	}
    else if D_pad_right{
        myStick.ResetPovs()
    }
	else{
		myStick.SetContPov(l,POV_Index)
	}
	Return

Label23_UP:
	; myStick.SetBtn(btn_free,D_pad_left)
	D_pad_left := False
	if D_pad_up{
		myStick.SetContPov(u,POV_Index)

	}
	else if D_pad_down {
		myStick.SetContPov(d,POV_Index)
	}
    else if D_pad_right{
        myStick.SetContPov(r,POV_Index)
    }
	else{
		myStick.ResetPovs()
	}
	Return  
;---- DPAD Right ---- 
Label24:
	; myStick.SetBtn(btn_press,D_pad_right)
	D_pad_right := True
	if D_pad_up {
		myStick.SetContPov(ru,POV_Index)

	}
	else if D_pad_down{
		myStick.SetContPov(rd,POV_Index)
	}
    else if D_pad_left{
        myStick.ResetPovs()
    }
	else{
		myStick.SetContPov(r,POV_Index)
	}
	Return

Label24_UP:
	; myStick.SetBtn(btn_free,D_pad_right)
	D_pad_right := False
	if D_pad_up {
		myStick.SetContPov(u,POV_Index)

	}
	else if D_pad_down{
		myStick.SetContPov(d,POV_Index)
	}
    else if D_pad_left{
        myStick.SetContPov(l,POV_Index)
    }
	else{
		myStick.ResetPovs()
	}
	Return  

F6::
    ; MsgBox, Iteration number
    myStick.SetAxisByIndex(axis_ori,3)
    myStick.SetAxisByIndex(axis_ori,6)
    myStick.SetAxisByIndex(axis_ori,7)
    myStick.SetAxisByIndex(axis_ori,8)
Return
; F7::
;     ; MsgBox, Iteration number
;     myStick.SetAxisByIndex(1384,3) ; R 的高左低右
;     myStick.SetAxisByIndex(30000,6) ; R 的上下，高上低下 
;     myStick.SetAxisByIndex(12000,7)
;     myStick.SetAxisByIndex(21000,8)
; Return
;----------------------------end macros