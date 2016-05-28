#include <windows.h>
#include <stdio.h>
#include <tchar.h>
#include "tlhelp32.h"
/* Title: Determining debugger present using the Parent Process detection.
 * Author: Osanda Malith Jayathissa (@OsandaMalith)
 * Website: http://osandamalith.wordpress.com
 */
int main(int argc, char *argv[]) {
    int pid = 0;
    int exp_pid = 0;
    HANDLE handle = INVALID_HANDLE_VALUE;
    PROCESSENTRY32 pe = {0};
    
    pe.dwSize = sizeof(PROCESSENTRY32);
    pid = GetCurrentProcessId();
    handle = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	
    if (handle == INVALID_HANDLE_VALUE) 
		fprintf(stderr, "Cannot get a snapshot. Error: %x\n", GetLastError());
		    
    if(Process32First(handle, &pe)) {
    	do 
    	    if (!_tcsicmp(pe.szExeFile, _T("explorer.exe")))
    	        exp_pid = pe.th32ProcessID;
    	while(Process32Next(handle, &pe));
    }
    
    if (exp_pid == -1)
        fprintf(stderr, "Cannot get PID of explorer. Error: %x\n", GetLastError());
		
    if(Process32First(handle, &pe)) {
    	do if (pe.th32ProcessID == pid) 
    	    MessageBoxA(NULL, pe.th32ParentProcessID == exp_pid ? "Debugger NOT Present\n" : "Debugger Present\n","Status", pe.th32ParentProcessID == exp_pid ? 0x40 : 0x30);
    	while(Process32Next(handle, &pe));
    }
    
    CloseHandle(handle);
    
    return 0;
}
