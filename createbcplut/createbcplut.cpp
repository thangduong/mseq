////////////////////////////////////////////////////////////////////////////////////////////////////
// createbcplut.cpp
//
//    implements the matlab function createbcplut that creates the bitcount parity table.
//    type 'help createbcplut' at the matlab prompt for more info.
////////////////////////////////////////////////////////////////////////////////////////////////////
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
	//
	// here is the basic usage:
	//    lut = createbcplut(order); where order is the order of the m-sequence
	// output lut is an array of 2^order UINT32.
	//
	if (nrhs != 1)
	{
		mexEvalString("help createbcplut;");
	}
	else
	{
		unsigned long order;
		order = maGetUINT32Element(prhs[0], 0); //*((unsigned long*)mxGetData(prhs[0]));
		int dim[2] = { 1<<order, 1};
		plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxUINT32_CLASS, mxREAL);
		unsigned long* newbit = (unsigned long*)mxGetData(plhs[0]);

		// create the bit count parity table
		for (int i = 0; i < dim[0]; i++)
		{
			unsigned j;	
			newbit[i] = 0;
			for (j = 0; j < order; j++)
				newbit[i] += ((1<<j)&i) ? 1 : 0;
			newbit[i] = (newbit[i] % 2) << (order - 1);
		}

	}
}

