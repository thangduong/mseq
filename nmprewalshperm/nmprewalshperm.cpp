//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// prewalsperm.cpp
//
//   type help prewalshperm in matlab for more info
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
	// prewalshperm(order, seed, data, [lookuptable]);
	//

	if (nrhs < 3)
	{
		mexEvalString("help nmprewalshperm;");
	}
	else
	{
		int order = maGetUINT32Element(prhs[0], 0);
		int seed = maGetUINT32Element(prhs[1], 0);
		mwSize dim[2] = { (1<<order)-1, 1};
		int i;
		unsigned long reg1 = 1;
		unsigned long reg2;
		unsigned long datasize = mxGetM(prhs[2]) * mxGetN(prhs[2]);
		int elementsize;
		char* result;
		char* indata;
		elementsize = datasize / dim[0];
#ifdef ERROR_CHECK
		if (datasize != (unsigned long)(dim[0]*elementsize))
		{
			mexErrMsgTxt("invalid parameter.  data needs to have k*2^order - 1 elements for integer k.");
			return;
		}
#endif
		elementsize *= mxGetElementSize(prhs[2]);

		// NOTE: this is not a good thing to do.  we dont' need
		//  to copy twice, but this is fast (coding wise)
		plhs[0] = mxDuplicateArray(prhs[2]);
		result = (char*)mxGetData(plhs[0]);
		indata = (char*)mxGetData(prhs[2]);

		unsigned long* newbit = NULL;

		// if look up table is available in parameter, then use it
		if (nrhs >= 4)
			newbit = (unsigned long*)mxGetData(prhs[3]);
		else // if not available, then create it
		{
			newbit = new unsigned long[dim[0]];
			for (i = 0; i < dim[0]; i++)
			{
				int j;	
				newbit[i] = 0;
				for (j = 0; j < order; j++)
					newbit[i] += ((1<<j)&i) ? 1 : 0;
				newbit[i] = (newbit[i] % 2) << (order - 1);
			}
		}

		// use Sutter's generating register method
		// see Sutter's section in (Marmarelis 1987, Vol I)
		// then do the pre walsh transform permutation as
		// specified in Sutter's SIAM paper.
		reg1 = 1;
		unsigned long outputmask = dim[0];

		// the first element stays the same
//		memcpy(result, indata, elementsize);
//		indata += elementsize;

		// for the rest, use the sequences in the generating register
		// scheme to create the permutation!
		for (i = 0; i < dim[0]; i++)
		{
			// i => (reg1 & outputmask); 
			memcpy(&result[((reg1 & outputmask)-1)*elementsize], indata, elementsize);
			indata += elementsize;
			reg2 = reg1 & seed;
			reg1 = (reg1 >> 1)+newbit[reg2];
		}

		// finally, if newbit is not passed in, then free it
		if (nrhs < 4)
			delete [] newbit;
	}
}

