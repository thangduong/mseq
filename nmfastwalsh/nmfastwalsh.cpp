// 11/13/2003	- Thang Duong	- Fixed bug: didn't work for INT32 before because I checked type of the wrong
//									argument
//
// 11/17/2003   - Thang Duong   - Converted the several fastwalsh functions to one template function
// 12/16/2003	- Thang Duong	- Converted fastwalsh to nmfastwalsh (did it before, but got lost)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fastwalsh.cpp
//
//   type help fastwalsh in matlab for more info
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Fast walsh functions.
//  The functions below do exactly the same thing for different data types.
//  Inputs are: vector (the vector to transform), and N (the order -- length of vector = 2^N)
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

template <class TYPE>
void nmfastwalsh(TYPE* vector, int N, int blocksize)
{
	// vector is a vector of 2^N elements
	int i, j, k;
	int stridebits = 1;
	TYPE* dummy = new TYPE[blocksize];
	memset(dummy, 0, sizeof(TYPE)*blocksize);
	while (stridebits <= N)
	{
		int stridelen = (1<<(stridebits-1));
		int nstrides = (1<<(N-stridebits));
		for (k = 0; k < blocksize; k++)
		{
			TYPE item1 = dummy[k]; //vector[(- 1)*blocksize+k];
			TYPE item2 = vector[(stridelen - 1)*blocksize+k];
//			vector[(- 1)*blocksize+k]
			dummy[k] = item1 + item2;
			vector[(stridelen - 1)*blocksize+k] = item1 - item2;
		}
		for (i = 1; i < stridelen; i++)
		{
			for (k = 0; k < blocksize; k++)
			{
				TYPE item1 = vector[(i - 1)*blocksize+k];
				TYPE item2 = vector[(i + stridelen - 1)*blocksize+k];
				vector[(i - 1)*blocksize+k] = item1 + item2;
				vector[(i + stridelen - 1)*blocksize+k] = item1 - item2;
			}
		}
		for (j = 1; j < nstrides; j++)
		{
			for (i = 0; i < stridelen; i++)
			{
				for (k = 0; k < blocksize; k++)
				{
					TYPE item1 = vector[(2 * j * stridelen + i - 1)*blocksize+k];
					TYPE item2 = vector[(2 * j * stridelen + i + stridelen - 1)*blocksize+k];
					vector[(2 * j * stridelen + i - 1)*blocksize+k] = item1 + item2;
					vector[(2 * j * stridelen + i + stridelen - 1)*blocksize+k] = item1 - item2;
				}
			}
		}
		stridebits++;
	}
	delete [] dummy;
}
////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs != 2)
	{
		mexEvalString("help nmfastwalsh;");
	}
	else
	{
		int N = maGetUINT32Element(prhs[0], 0);
		int dim[2] = { (1<<N)-1, 1};
		int blocksize = (mxGetNumberOfElements(prhs[1])) / dim[0];
	
		if (mxGetNumberOfElements(prhs[1]) != dim[0]*blocksize)
		{
			printf("your data array is of the wrong size!\n");
		}
		else
		{
			dim[0] = dim[0] * blocksize;
			// call a the appropriate C function depending on the type of the array we got
			// from matlab.
			switch(mxGetClassID(prhs[1]))
			{
			case mxDOUBLE_CLASS:
				plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxDOUBLE_CLASS, mxREAL);
				memcpy(mxGetData(plhs[0]), mxGetData(prhs[1]), dim[0] * sizeof(double));
				nmfastwalsh((double*)mxGetData(plhs[0]), N, blocksize);
				break;
			case mxINT16_CLASS:
				plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxINT16_CLASS, mxREAL);
				memcpy(mxGetData(plhs[0]), mxGetData(prhs[1]), dim[0] * sizeof(short));
				nmfastwalsh((short*)mxGetData(plhs[0]), N, blocksize);
				break;
			case mxINT32_CLASS:
				plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxINT32_CLASS, mxREAL);
				memcpy(mxGetData(plhs[0]), mxGetData(prhs[1]), dim[0] * sizeof(long));
				nmfastwalsh((long*)mxGetData(plhs[0]), N, blocksize);
				break;
			default:
				printf("you need to pass in an array of either double, int16, or int32\n");
				break;
			}
		}

		// if there's an error in the way, we still want to return something
		// so we don't get that annoying matlab error.
		if (plhs[0] == NULL)
		{
			// return a 1 item junk value if failed.
			dim[0] = dim[1] = 1;
			plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[1]), dim, mxDOUBLE_CLASS, mxREAL);
		}
	}
}
