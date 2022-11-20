#SingleInstance force
#NoEnv
#include CvJoyInterface.ahk
SetBatchLines, -1

; 我的配置文件，全局性的忽略配置文件
; 使用类似 Xbox 的键序
; Stick 控制相关变量
btn_press := 1
btn_free := 0
; axis 值：0-16384-32768
;        上    恢复   下？
;

L_stick_x := 1
L_stick_y := 2
R_stick_x := 4
R_stick_y := 5
D_pad_up := 13
D_pad_down := 14
D_pad_left := 15
D_pad_right := 16
btn_A := 1 
btn_B := 2
btn_X := 3
btn_Y := 4
btn_L := 5
btn_R := 6
btn_LB := 7
btn_LT := 8
btn_RB := 9
btn_RT := 10 
btn_Lop := 11   ; 左边的操作键
btn_Rop := 12   ; 右边的操作键

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
^!r:: Reload
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
	myStick.SetAxisByIndex(32768,L_stick_y)
	return

Label1_UP:
	myStick.SetAxisByIndex(16384,L_stick_y)
	return
  
;---- L-Stick Downn ----
Label2:
	myStick.SetAxisByIndex(32768,L_stick_y)
	return

Label2_UP:
	myStick.SetAxisByIndex(16384,L_stick_y)
	return

;---- L-Stick left ----
Label3:
	myStick.SetAxisByIndex(0,L_stick_x)
	return
	
Label3_UP:
	myStick.SetAxisByIndex(16384,L_stick_x)
	return
  
;---- L-Stick RIGHT ----
Label4:
	myStick.SetAxisByIndex(32768,L_stick_x)
	return

Label4_UP:
	myStick.SetAxisByIndex(16384,L_stick_x)
	return  

;---- L-Stick ----
Label5:
	myStick.SetBtn(1,btn_L)
	return

Label5_UP:
	myStick.SetBtn(0,btn_L)
	return

;---- R-Stick ----  
Label6:
	myStick.SetBtn(0,btn_R)
	return
Label6_UP:
	myStick.SetBtn(0,btn_R)
	return  

;           //// BUTTONS ////
;---- Y ---- 
Label7:
	myStick.SetBtn(1,btn_Y)
	Return

Label7_UP:
	myStick.SetBtn(0,btn_Y)
	Return

;---- B ---- 
Label8:
	myStick.SetBtn(1,btn_B)
	Return

Label8_UP:
	myStick.SetBtn(0,btn_B)
	Return

;---- A ---- 
Label9:
	myStick.SetBtn(1,btn_A)
	Return

Label9_UP:
	myStick.SetBtn(0,btn_A)
	Return

;---- X ---- 
Label10:
	myStick.SetBtn(1,btn_X)
	Return

Label10_UP:
	myStick.SetBtn(0,btn_X)
	Return

;---- L-B ---- 
Label11:
	myStick.SetBtn(1,btn_LB)
	Return

Label11_UP:
	myStick.SetBtn(0,btn_LB)
	Return

;---- L-T ---- 
Label12:
	myStick.SetBtn(1,btn_LT)
	Return

Label12_UP:
	myStick.SetBtn(0,btn_LT)
	Return

;---- R-B ---- 
Label13:
	myStick.SetBtn(1,btn_RB)
	Return

Label13_UP:
	myStick.SetBtn(0,btn_RB)
	Return
  
;           //// C-STICK ////  
;---- R-T ---- 
Label14:
	myStick.SetBtn(0,btn_RT)
	Return

Label14_UP:
	myStick.SetBtn(0,btn_RT)
	Return
  
;---- R-Stick UP ---- 
Label15:
	myStick.SetAxisByIndex(0,R_stick_y)
	Return

Label15_UP:
	myStick.SetAxisByIndex(16384,R_stick_y)
	Return

;---- R-Stick Down ---- 
Label16:
	myStick.SetAxisByIndex(32768,R_stick_y)
	Return
  
Label16_UP:
	myStick.SetAxisByIndex(16384,R_stick_y)
	Return
  
;---- R-Stick left ---- 
Label17:
	myStick.SetAxisByIndex(32768,R_stick_x)
	Return

Label17_UP:
	myStick.SetAxisByIndex(16384,R_stick_x)
	Return

;---- R-Stick Right ---- 
Label18:
	myStick.SetAxisByIndex(0,R_stick_x)
	Return

Label18_UP:
	myStick.SetAxisByIndex(16384,R_stick_x)
	Return
  
;           //// OTHER BUTTONS ////  
;---- Start ---- 
Label19:
	myStick.SetBtn(1,btn_Lop)
	Return

Label19_UP:
	myStick.SetBtn(0,btn_Lop)
	Return
  
;---- Menu ---- 
Label20:
	myStick.SetBtn(1,btn_Rop)
	Return

Label20_UP:
	myStick.SetBtn(0,btn_Rop)
	Return 

;---- DPAD UP ---- 
Label21:
	myStick.SetBtn(1,D_pad_up)
	Return

Label21_UP:
	myStick.SetBtn(0,D_pad_up)
	Return
  
;---- DPAD DOWN ---- 
Label22:
	myStick.SetBtn(1,D_pad_down)
	Return

Label22_UP:
	myStick.SetBtn(0,D_pad_down)
	Return  
;---- DPAD Left ---- 
Label23:
	myStick.SetBtn(1,D_pad_left)
	Return

Label23_UP:
	myStick.SetBtn(0,D_pad_left)
	Return  
;---- DPAD Right ---- 
Label24:
	myStick.SetBtn(1,D_pad_right)
	Return

Label24_UP:
	myStick.SetBtn(0,D_pad_right)
	Return  
	
;----------------------------end macros