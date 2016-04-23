#include <Windows.h>
#include <tchar.h>
/*
 * Author: Osanda Malith Jayathissa (@OsandaMalith)
 * Website: http://OsandaMalith.wordpress.com
 * Using ZwQueryInformationProcess we get the PEB Address and 
 * then we check the NtGlobalFlag bit to determine the process is being debugged or not.
 */

typedef ULONG_PTR(__stdcall * _RtlGetNtGlobalFlags)();

int main() {

    _RtlGetNtGlobalFlags GetNtGlobalFlags = (_RtlGetNtGlobalFlags)(GetProcAddress(GetModuleHandle(_T("ntdll.dll")), "RtlGetNtGlobalFlags"));

    ULONG_PTR globalFlags = GetNtGlobalFlags();
	
    MessageBox(NULL, globalFlags ? "Debugger Detected!" : "No Debugger Found" , "Status", 0x30);
    
    return 0;

}
