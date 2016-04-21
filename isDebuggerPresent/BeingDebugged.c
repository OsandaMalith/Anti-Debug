#include <Winternl.h>
#include <Windows.h>
#include <tchar.h>

/*
 * Author: Osanda Malith Jayathissa (@OsandaMalith)
 * Website: http://OsandaMalith.wordpress.com
 * Using ZwQueryInformationProcess we get the PEB Address and 
 * then we check the BeingDebugged bit to determine the process is being debugged or not.
 */

int main() {
	
	typedef unsigned long(__stdcall *pfnZwQueryInformationProcess)
	(
		IN  HANDLE,
		IN  unsigned int, 
		OUT PVOID, 
		IN  ULONG, 
		OUT PULONG
	);
	pfnZwQueryInformationProcess ZwQueryInfoProcess = NULL;
	
	HMODULE hNtDll = LoadLibrary(_T("ntdll.dll"));
	if (hNtDll == NULL) { }

	ZwQueryInfoProcess = (pfnZwQueryInformationProcess) GetProcAddress(hNtDll,
		"ZwQueryInformationProcess");
	if (ZwQueryInfoProcess == NULL) { }
	unsigned long status;

	DWORD pid = GetCurrentProcessId();
	HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, pid);
	PROCESS_BASIC_INFORMATION pbi;
	status = ZwQueryInfoProcess(hProcess,
                                ProcessBasicInformation,
                                &pbi,
                                sizeof(pbi),
                                NULL);
                                
	PPEB peb_addr = pbi.PebBaseAddress;
	DWORD ptr = pbi.PebBaseAddress;
	ptr|=0x2;
	DWORD *temp = ptr;
	MessageBox(0, *temp & 1 ? "Debugger found" : "Debugger not found","Status",0x30);
	
	return 0;
}
