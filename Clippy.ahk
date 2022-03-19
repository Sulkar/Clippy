;Richard Scheglmann - unsere-schule.org
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

clippyVisible := True
savedHotkeyList := []


;Menu Tray Controls
;https://www.autohotkey.com/docs/commands/Menu.htm
Menu, Tray, Icon, %A_ScriptDir%\favicon.ico
Menu, Tray, NoStandard
Menu, Tray, Add, Clippy anzeigen, ClippyShowHide
Menu, Tray, Default, Clippy anzeigen
Menu, Tray, Click, 1 ;how many clicks to activate gui

;normal GUI
;https://www.autohotkey.com/docs/commands/Gui.htm
Gui -MinimizeBox
Gui Font, s9, Segoe UI

;positions
Gui Add, GroupBox, x8 y0 w245 h145, zu kopierender Inhalt
Gui Add, Text, x15 y20 w105 h23 +0x200 , TOP
Gui Add, Text, x15 y45 w105 h23 +0x200 , JUNGLE
Gui Add, Text, x15 y70 w105 h23 +0x200 , MID
Gui Add, Text, x15 y95 w105 h23 +0x200 , SUPP
Gui Add, Text, x15 y120 w105 h23 +0x200 , BOT
;text to copy input
Gui Add, Edit, vClippy1 x70 y20 w178 h21, Hello World
Gui Add, Edit, vClippy2 x70 y45 w178 h21, 
Gui Add, Edit, vClippy3 x70 y70 w178 h21, 
Gui Add, Edit, vClippy4 x70 y95 w178 h21, 
Gui Add, Edit, vClippy5 x70 y120 w178 h21, 
;hotkeys
Gui Add, GroupBox, x250 y0 w69 h145, Hotkey
Gui Add, Edit, vClippyKey1 x254 y20 w62 h21, F12
Gui Add, Edit, vClippyKey2 x254 y45 w62 h21, 
Gui Add, Edit, vClippyKey3 x254 y70 w62 h21,
Gui Add, Edit, vClippyKey4 x254 y95 w62 h21,
Gui Add, Edit, vClippyKey5 x254 y120 w62 h21,
;functions
Gui Add, GroupBox, x320 y0 w69 h145, Funktion
Gui Add, Edit, vClippyFunction1 x324 y20 w62 h21, {Enter}
Gui Add, Edit, vClippyFunction2 x324 y45 w62 h21, 
Gui Add, Edit, vClippyFunction3 x324 y70 w62 h21, 
Gui Add, Edit, vClippyFunction4 x324 y95 w62 h21, 
Gui Add, Edit, vClippyFunction5 x324 y120 w62 h21, 
;button übernehmen
Gui Add, Button, gRegisterHotkeys x285 y150 w100 h23, übernehmen
;link
Gui Add, Link, x15 y155 w120 h23, <a href="https://unsere-schule.org/programmieren/autohotkey/programme/clippy-clipboard-manager/">Hilfe und Anleitung</a>

;laod data
ReadDataINI()

Gui Show, w395 h180, Clippy V1.0.0
Return

WriteDataINI(){
    Loop, 5{
        dataClippy := dataClippy%A_Index%
        GuiControlGet, dataClippy, ,Clippy%A_Index%
        IniWrite, %dataClippy%, %A_ScriptDir%\config.ini, clippy%A_Index%, Clippy%A_Index%txt
        dataClippyKey := dataClippyKey%A_Index%
        GuiControlGet, dataClippyKey, ,ClippyKey%A_Index%
        IniWrite, %dataClippyKey%, %A_ScriptDir%\config.ini, clippy%A_Index%, ClippyKey%A_Index%txt
        dataClippyFunction := dataClippyFunction%A_Index%
        GuiControlGet, dataClippyFunction, ,ClippyFunction%A_Index%
        IniWrite, %dataClippyFunction%, %A_ScriptDir%\config.ini, clippy%A_Index%, ClippyFunction%A_Index%txt
    }        
}
ReadDataINI(){
    Loop, 5{
        IniRead, dataClippy%A_Index%, %A_ScriptDir%\config.ini, clippy%A_Index%, Clippy%A_Index%txt
        dataClippy := dataClippy%A_Index%
        if(dataClippy != "ERROR")
            GuiControl, text, Clippy%A_Index%, %dataClippy%
        IniRead, dataClippyKey%A_Index%, %A_ScriptDir%\config.ini, clippy%A_Index%, ClippyKey%A_Index%txt
        dataClippyKey := dataClippyKey%A_Index%
        if(dataClippyKey != "ERROR")
        GuiControl, text, ClippyKey%A_Index%, %dataClippyKey%
        IniRead, dataClippyFunction%A_Index%, %A_ScriptDir%\config.ini, clippy%A_Index%, ClippyFunction%A_Index%txt
        dataClippyFunction := dataClippyFunction%A_Index%
        if(dataClippyFunction != "ERROR")
        GuiControl, text, ClippyFunction%A_Index%, %dataClippyFunction%
    }
}

RegisterHotkeys() {
    global savedHotkeyList
    UnregisterHotkeys()
            
    Loop, 5{
        GuiControlGet, currentClippyKey%A_Index%, ,ClippyKey%A_Index%        
        ;https://www.autohotkey.com/docs/objects/Func.htm
        fn := Func("SendTextClippy").Bind(A_Index) ;to use function with parameters
        if(currentClippyKey%A_Index% != ""){
            Hotkey % currentClippyKey%A_Index%, % fn, on             
        }                
        savedHotkeyList.Push(currentClippyKey%A_Index%)
    }  
    ;save data
    WriteDataINI()
    ClippyShowHide()
}

UnregisterHotkeys(){
    global savedHotkeyList    
    ;turn off all previously activated hotkeys
    for index, element in savedHotkeyList{
        If (element) {
            Hotkey, %element%, , Off
        }
    }
    ;reset list
    savedHotkeyList := []
}

SendTextClippy(clippyNr){
    GuiControlGet, currentTextClippy%clippyNr%, ,Clippy%clippyNr%
    GuiControlGet, currentClippyFunction%clippyNr%, ,ClippyFunction%clippyNr%   
    ;save current clipboard value
    ClipboardSaved := ClipboardAll
    clipboard := currentTextClippy%clippyNr%
    functionCode := currentClippyFunction%clippyNr%
    Send, ^v%functionCode%
    ;restore old clipboard value
    Clipboard := ClipboardSaved
    ClipboardSaved := ""
}

GuiClose(){
    ExitApp
}

ClippyShowHide(){    
    global clippyVisible
    
    If(clippyVisible){
        Gui, Hide
    }else{
        Gui, Show
    }
    clippyVisible := !clippyVisible
}





