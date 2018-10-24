////////////////////////////////////////////////////////////////////////////////
// REVISION HISTORY
//
// 12/12/2003	Thang		- Made this code compile in Linux by #ifdef-ing out
//								Windows specific code
////////////////////////////////////////////////////////////////////////////////
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
		mexEvalString("help slowseqp;");
	}
	else
	{
		uint32_t nbits;
		uint32_t* result;
		uint32_t seed;
		mwSize dim[2] = { 1, 1};

		// assume uint32_t input! (TODO: fix this!)
		nbits = maGetUINT32Element(prhs[0], 0); //*((uint32_t*)mxGetData(prhs[0]));
		seed  = maGetUINT32Element(prhs[1], 0); //*((uint32_t*)mxGetData(prhs[1]));

		// create result array
		dim[1] = (1<<nbits)-1;
		plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxUINT32_CLASS, mxREAL);

		result = (uint32_t*)mxGetData(plhs[0]);

		uint32_t reg1 = 1;
		uint32_t reg2 = seed;
		uint32_t np1bitmask = dim[1]+1;
		uint32_t outputmask = dim[1];

		// use Sutter's tap register method
		// see Sutter's section in (Marmarelis 1987, Vol I)
		for (int i = 0; i < dim[1]; i++)
		{
			(*result) = (reg1 & outputmask); result++;
			reg1 = (reg1 << 1);
			if (reg1 & np1bitmask)
				reg1 = (reg1 ^ reg2);
		}
	}
}

