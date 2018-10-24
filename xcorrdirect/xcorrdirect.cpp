//added by JMA to port from windows to linux





#include "mex.h"
#include "matrix.h"
#include "matlabaux.h"

#ifdef __linux
#include <algorithm>
using namespace std;
#endif

#ifdef _WIN32
#ifndef	max
#define	max(x,y)	((x<y)?y:x)
#endif
#ifndef COMPILE_IN_MATLAB
#include <windows.h>
BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    return TRUE;
}
#endif
#endif


template<class T1, class T2, class T3>
void CircularCrossCorrelation(T1* x1, T2* x2, T3* result, uint32_t N1, uint32_t N2, uint32_t N)
{
	// result = x1 cross x2
	// N1 = size of x1, N2 = size of x2, N = size of result
	//
	printf("cross correlating sequence of size %d and %d to a seq of size %d\n", N1, N2, N);
	uint32_t Nmax = max(N1, N2);
	for (int i = 0; i < N; i++)
	{
		T3 sum = 0;
		for (int j = 0; j < Nmax; j++)
		{
			int i2 = j-i;
			while (i2 < 0)
				i2 = i2 + N2;
			sum = sum + x1[j%N1] * x2[i2%N2];
		}

		result[i] = sum;
	}
}

////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs < 2)
	{
		mexEvalString("help xcorrdirect;");
	}
	else
	{
		mxClassID param0type = (mxGetClassID(prhs[0]));
		mxClassID param1type = (mxGetClassID(prhs[1]));
		if (param0type == param1type)
		{
			mwSize dim[2] = {1, max(mxGetNumberOfElements(prhs[0]), mxGetNumberOfElements(prhs[1])) };
			plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, param0type, mxREAL);
			switch(param0type)
			{
			case mxDOUBLE_CLASS:
				CircularCrossCorrelation((double*)mxGetData(prhs[0]),(double*)mxGetData(prhs[1]),
					(double*)mxGetData(plhs[0]), mxGetNumberOfElements(prhs[0]), 
					mxGetNumberOfElements(prhs[1]), mxGetNumberOfElements(plhs[0]));
				break;
			case mxINT16_CLASS:
				CircularCrossCorrelation((short*)mxGetData(prhs[0]),(short*)mxGetData(prhs[1]),
					(short*)mxGetData(plhs[0]), mxGetNumberOfElements(prhs[0]), 
					mxGetNumberOfElements(prhs[1]), mxGetNumberOfElements(plhs[0]));
				break;
			case mxINT32_CLASS:
				CircularCrossCorrelation((long*)mxGetData(prhs[0]),(long*)mxGetData(prhs[1]),
					(long*)mxGetData(plhs[0]), mxGetNumberOfElements(prhs[0]), 
					mxGetNumberOfElements(prhs[1]), mxGetNumberOfElements(plhs[0]));
				break;
			default:
				printf("you need to pass in an array of either double, int16, or int32\n");
				break;
			}			
		}
		else
		{
			printf("Please match the type of x1 and x2 in the parameter.\n");
			printf("This function currently doesn't work with x1 and x2 of different types.\n");
		}

	}
}
