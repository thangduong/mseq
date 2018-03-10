//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// digdetectedges.cpp
//
//  This is written specifically for photodiode tests.
//
//   type help digdetectedges in matlab for more info
//
// REVISION HISTORY
//
//
// Thang	10/3/2003	Wrote this.  Seems to work fine.  The heuristics may need tweaking, but
//                      it looks pretty much done.
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

mxArray* DigDetectEdgesDouble(const mxArray* pArray)
{
	
	return pResult;
}

////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs < 1)
	{
		mexEvalString("help digdetectedges;");
	}
	else
	{
		double SamplingRate = 1;
		if (nrhs > 1)
			SamplingRate = maGetDoubleElement(prhs[1], 0);

		plhs[0] = DetectPeaksDouble(prhs[0]);
	}
}