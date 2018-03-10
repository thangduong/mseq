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
		unsigned long nbits;
		unsigned long* mseq = (unsigned long*)mxGetData(prhs[1]);
		nbits = maGetUINT32Element(prhs[0], 0);

		unsigned long nelt = (1<<nbits);
		
	}
}