.586
.model flat, stdcall
option casemap :none   

; ¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤÷¤
; Author : Osanda Malith Jayathissa (@OsandaMalith)
; Title: Test if process is being debugged if PPID != explorer.exe
; Website: http://osandamalith.wordpress.com
; ¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤=÷=¤

include    windows.inc
include    user32.inc
include    kernel32.inc
includelib user32.lib
includelib kernel32.lib

.data
exp			db 	"explorer.exe",0
AppName		db 	"Status",0
errSnapshot    	db 	"CreateToolhelp32Snapshot failed.",0
errProcFirst    	db 	"Process32First failed.",0
errExolorer 	db 	"Explorer.exe Not Found!"
expfound 		db 	"Explorer.exe Found",0
dbgFound 	db 	"Debugger Found!", 0
dbgNotFound	db 	"Debugger Not Found!", 0
exp_pid 		dd 	0
pid		 	dd 	0 

.data?
hSnapshot   HANDLE 		       ?
ProcEnt       PROCESSENTRY32 <?>

.code
start:
    lea esi, offset ProcEnt
    assume esi:ptr PROCESSENTRY32
    mov [esi].dwSize, sizeof PROCESSENTRY32
    invoke GetCurrentProcessId
    mov pid, eax
    invoke CreateToolhelp32Snapshot, TH32CS_SNAPPROCESS, NULL
    .IF (eax != INVALID_HANDLE_VALUE)
        mov hSnapshot, eax
        invoke Process32First, hSnapshot, ADDR ProcEnt
        .IF (eax)
        @@:
           invoke lstrcmpi, ADDR exp , ADDR [ProcEnt.szExeFile]
            .IF (eax == 0)
                  lea ebx, [esi].th32ProcessID
	         push [ebx]
	         pop exp_pid
	         jmp nextLoop
	   .ELSE
            .ENDIF
            invoke Process32Next, hSnapshot, ADDR ProcEnt
            test eax,eax
            jnz @B
        .ELSE
            invoke MessageBox, NULL, ADDR errProcFirst, ADDR AppName, MB_OK or MB_ICONERROR
        .ENDIF
        invoke CloseHandle, hSnapshot
     .ELSE
         invoke MessageBox, NULL, ADDR errSnapshot, ADDR AppName, MB_OK or MB_ICONERROR
    .ENDIF

nextLoop:    
    invoke CreateToolhelp32Snapshot, TH32CS_SNAPPROCESS, NULL
    .IF (eax != INVALID_HANDLE_VALUE)
        mov hSnapshot, eax
        invoke Process32First, hSnapshot, ADDR ProcEnt
        .IF (eax)
        @@:
	         mov ebx, pid
	         .IF ( ebx == [esi].th32ProcessID )
 			mov ebx,  [exp_pid]       	
         		.if ( ebx == [esi].th32ParentProcessID )
         			  invoke MessageBox, NULL, ADDR dbgNotFound, ADDR AppName, MB_OK or MB_ICONINFORMATION
         		.else
         			 invoke MessageBox, NULL, ADDR dbgFound, ADDR AppName, MB_OK or MB_ICONERROR
         		.endif
	         .ELSE
            	.ENDIF
            invoke Process32Next, hSnapshot, ADDR ProcEnt
            test eax,eax
            jnz @B
        .ELSE
            invoke MessageBox, NULL, ADDR errProcFirst, ADDR AppName, MB_OK or MB_ICONERROR
        .ENDIF
        invoke CloseHandle, hSnapshot
     .ELSE
         invoke MessageBox, NULL, ADDR errSnapshot, ADDR AppName, MB_OK or MB_ICONERROR
    .ENDIF
    
     invoke ExitProcess, NULL
end start
