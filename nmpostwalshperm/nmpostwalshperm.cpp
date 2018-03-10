//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// postwalshperm.cpp
//
//   type help postwalsperm in matlab for more info
//
//
// REVISION HISTORY
//
// 1/6/2004	Thang	Fixed a bug.  The main loop didn't go to the last element before, so the last
//					element was always wrong, but it's corrected now.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

#define ERROR_CHECK


////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	// 
	// postwalshperm(order, seed, data);
	//

	if (nrhs < 3)
	{
		mexEvalString("help nmpostwalshperm;");
	}
	else
	{
		int order = maGetUINT32Element(prhs[0], 0);
		int seed = maGetUINT32Element(prhs[1], 0);
		int dim[2] = { (1<<order)-1, 1};
		int i;
		unsigned long datasize = mxGetM(prhs[2]) * mxGetN(prhs[2]);
		int elementsize;
		char* result;
		char* indata;
		elementsize = datasize / dim[0];

#ifdef ERROR_CHECK
		if (datasize != (unsigned long)(dim[0]*elementsize))
		{
			mexErrMsgTxt("invalid parameter.  data needs to have k*2^order elements for integer k.");
			return;
		}
#endif
		elementsize *= mxGetElementSize(prhs[2]);

		// NOTE: this is not a good thing to do.  we dont' need
		//  to copy twice, but this is fast (coding wise)
		plhs[0] = mxDuplicateArray(prhs[2]);
		result = (char*)mxGetData(plhs[0]);
		indata = (char*)mxGetData(prhs[2]);

		unsigned long reg1 = 1;
		unsigned long reg2 = seed;
		unsigned long np1bitmask = dim[0] + 1;
		unsigned long outputmask = dim[0];

		// the first element stays the same
//		memcpy(result, indata, elementsize);
//		result += elementsize;

		// use Sutter's tap register method
		// see Sutter's section in (Marmarelis 1987, Vol I)
		for (i = 1; i < np1bitmask; i++)
		{
			// i => (reg1 & outputmask); 
			memcpy(result, &indata[((reg1 & outputmask) - 1)*elementsize], elementsize);
			result += elementsize;
			reg1 = (reg1 << 1);
			if (reg1 & np1bitmask)
				reg1 = (reg1 ^ reg2);
		}

	}
}

