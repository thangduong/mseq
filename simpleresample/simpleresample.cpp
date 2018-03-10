//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// simpleresample.cpp
//
//  This is written specifically for photodiode tests.
//
//   type help simpleresample in matlab for more info
//
// REVISION HISTORY
//
//
// Thang	10/3/2003	Wrote this.  Seems to work fine.  The heuristics may need tweaking, but
//                      it looks pretty much done.
//
// Thang	12/18/2003	Added interpolation
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


#include "mex.h"
#include "matrix.h"
#include "matlabaux.h"
#include <math.h>
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
	if (nrhs < 2)
	{
		mexEvalString("help simpleresample;");
	}
	else
	{
		unsigned long newlength = maGetUINT32Element(prhs[1], 0);
		double* indata = (double*)mxGetData(prhs[0]);
		unsigned long cnt = mxGetNumberOfElements(prhs[0]);

		int dim[2] = {newlength, 1};
		plhs[0] = mxCreateNumericArray(2, dim, mxDOUBLE_CLASS, mxREAL);
		double* outdata = (double*)mxGetData(plhs[0]);

//		printf("cnt = %d newlength = %d\n", cnt, newlength);
		// no interpolation
		for (int i = 0; i < newlength; i++)
		{
			double pos = (double)i * (double)(cnt-1) / (double)(newlength-1);
			int bef = (int)floor(pos);
			int aft = (int)ceil(pos);
//			printf("i = %d pos = %0.2f bef = %d aft = %d indata[bef] = %.02f indata[aft] = %0.2f\n", 
//				i,pos, bef,aft,indata[bef],indata[aft]);
			if (bef == aft)
				outdata[i] = indata[bef];
			else
				outdata[i] = ((double)aft - (double)pos)*indata[bef]+indata[aft]*((double)pos - (double)bef);
		}
	}
}
