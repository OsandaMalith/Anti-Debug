format pe gui 4.0
entry start

; »»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; Title: Checking if the process is being debugged by a ring3 debugger
;        using the PEB's NtGlobalFlag.
; 
; Website: http://osandamalith.wordpress.com
; Author: Osanda Malith Jayathissa (@OsandaMalith)
; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««


include 'win32a.inc'

;======================================
section '.data' data readable writeable
;======================================
 
Title    db     "Status",0
Found    db     "Debugger Found",0
NotFound db     "Debuger Not Found",0

; =======================================
section '.text' code readable executable
;========================================

start:
        mov           eax, [fs:0x18]      ; Pointer to TEB Structure
        mov           eax, [eax + 0x30]   ; Pointer to PEB Structure
        movzx         eax, byte [eax + 68h]; BeingDebugged bit
        cmp           eax, 70h
        je            found

        push          0x30
        push          Title
        push          NotFound
        push          0
        call          [MessageBox]
        jmp exit

found:
        push          0x10
        push          Title
        push          Found
        push          0
        call          [MessageBox]

exit:
        push          0
        call          [ExitProcess]

; ===============================================
section '.idata' import data readable
; ===============================================

library kernel32,'kernel32.dll',\
        User32,'user32.dll'

import  kernel32,\
        ExitProcess,'ExitProcess'

import  User32,\
        MessageBox,'MessageBoxA'
