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

//
// This function does all the work.  Parameters kernelSize and stimSize are sizes of
// kernel and stimulus in NUMBER OF SAMPLES (not number of bytes).  Response is assumed
// to be of the same size as stimulus.
//
template<class TYPE>
void fastSimResponse(TYPE* kernel, long kernelSize, TYPE* stimulus, long stimSize,
					 TYPE* response)
{
	int i,j;
	int index;
	index = 0;
	response[0] = 0;
	for (i = 0; i < stimSize; i++)
	{
		index = i;
		response[i] = 0;
		for (j = 0; j < kernelSize; j++)
		{
			response[i] += kernel[j] * stimulus[index];
			index--;
			if (index < 0)
				index = stimSize - 1;
		}
	}
}

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
	{
		mexEvalString("help fastsimresponse;");
	}
	else
	{
		if (mxGetClassID(prhs[0]) != mxGetClassID(prhs[1]))
		{
			printf("Please make the type of kernel to be the same as stimulus\n");
		}
		else
		{
			int dim[2] = { mxGetNumberOfElements(prhs[1]), 1};
			// call a the appropriate C function depending on the type of the array we got
			// from matlab.
			switch(mxGetClassID(prhs[0]))
			{
			case mxDOUBLE_CLASS:
				plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxDOUBLE_CLASS, mxREAL);
				fastSimResponse((double*)mxGetData(prhs[0]), mxGetNumberOfElements(prhs[0]), 
					(double*)mxGetData(prhs[1]), mxGetNumberOfElements(prhs[1]), 
					(double*)mxGetData(plhs[0]));
				break;
			case mxINT16_CLASS:
				plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxINT16_CLASS, mxREAL);
				fastSimResponse((short*)mxGetData(prhs[0]), mxGetNumberOfElements(prhs[0]), 
					(short*)mxGetData(prhs[1]), mxGetNumberOfElements(prhs[1]), 
					(short*)mxGetData(plhs[0]));
				break;
			case mxINT32_CLASS:
				plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxINT32_CLASS, mxREAL);
				fastSimResponse((long*)mxGetData(prhs[0]), mxGetNumberOfElements(prhs[0]), 
					(long*)mxGetData(prhs[1]), mxGetNumberOfElements(prhs[1]), 
					(long*)mxGetData(plhs[0]));
				break;
			default:
				printf("you need to pass in an array of either double, int16, or int32\n");
				break;
			}
		}
	}
	
}

