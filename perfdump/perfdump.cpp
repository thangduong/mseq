#include <windows.h>
#include "mex.h"
#include "matrix.h"


BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    return TRUE;
}

////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	LARGE_INTEGER freq;
	printf("QueryPerformanceFrequency returns %d\n", QueryPerformanceFrequency(&freq));
	printf("Frequency = %d\n", freq.LowPart);
}