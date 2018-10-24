#include <windows.h>
#include "mex.h"
#include "matrix.h"
#include "matlabaux.h"


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
	if (nrhs != 4)
	{
		mexEvalString("help mseqmult;");
	}
	else
	{
		uint32_t nbits;
		uint32_t* mseq = (uint32_t*)mxGetData(prhs[1]);
		nbits = maGetUINT32Element(prhs[0], 0);

		uint32_t nelt = (1<<nbits);
		
	}
}