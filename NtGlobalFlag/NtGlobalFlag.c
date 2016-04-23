#include <Windows.h>
#include <tchar.h>
/*
 * Author: Osanda Malith Jayathissa (@OsandaMalith)
 * Website: http://OsandaMalith.wordpress.com
 * Using RtlGetNtGlobalFlags() kernel mode API we get the value of the NtGlobalFlag.
 */

typedef ULONG_PTR(__stdcall * _RtlGetNtGlobalFlags)();

int main() {

    _RtlGetNtGlobalFlags GetNtGlobalFlags = (_RtlGetNtGlobalFlags)(GetProcAddress(GetModuleHandle(_T("ntdll.dll")), "RtlGetNtGlobalFlags"));

    ULONG_PTR globalFlags = GetNtGlobalFlags();
	
    MessageBox(NULL, globalFlags ? "Debugger Detected!" : "No Debugger Found" , "Status", 0x30);
    
    return 0;

}
