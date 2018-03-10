#include "mex.h"
#include "matrix.h"
#include "matlabaux.h"

#ifdef _WIN32
#include <windows.h>

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    return TRUE;
}
#endif

////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
	{
		mexEvalString("help rotatevector;");
	}
	else
	{
		long amount = maGetINT32Element(prhs[1], 0);
		unsigned long elementsize = mxGetElementSize(prhs[0]);
		char* indata = (char*)mxGetData(prhs[0]);
		int elementcount = mxGetNumberOfElements(prhs[0]);

		// NOTE: this is not a good thing to do!  We don't need to copy twice!
		plhs[0] = mxDuplicateArray(prhs[0]);

		char* outdata = (char*)mxGetData(plhs[0]);


		// break this into two cases:  left rotate and right rotate
		if (amount < 0)
		{
			// this is left rotate -- split into two parts
			amount = (-amount)%elementcount;
			int leftover = elementsize * (elementcount - amount);
			memcpy(&outdata[elementsize * amount], indata,
				leftover);
			indata += leftover;
			memcpy(outdata, indata, elementsize * amount);
		}
		else if (amount > 0)
		{
			// this is right rotate -- split into two parts
			// unfortunately, the second part gets inverted, so
			// we need to use a loop.
			amount = amount%elementcount;
			int leftover = elementsize * (elementcount - amount);
			memcpy(outdata, &indata[elementsize * amount],
				leftover);
			outdata += leftover;
			for (long i = 0; i < amount; i++)
			{
				memcpy(outdata, indata, elementsize);
				outdata += elementsize;
				indata += elementsize;
			}
		}
	}
}

