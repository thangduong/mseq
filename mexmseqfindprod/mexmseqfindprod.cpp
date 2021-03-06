#include "mex.h"
#include "matrix.h"

//01/12/04 JMA: added conditional compile for linux/windows
#ifdef __linux
#include <algorithm>
using namespace std;
#endif


#ifdef _WIN32
#ifndef max
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

////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs != 4)
	{
		mexEvalString("help mexmseqfindprod;");
	}
	else
	{
		uint32_t nbits;
		uint32_t* mseq = (uint32_t*)mxGetData(prhs[1]);
		nbits = *((uint32_t*)mxGetData(prhs[0]));

		uint32_t nelt = (1<<nbits);

		uint32_t nprods = max(mxGetM(prhs[2]), mxGetN(prhs[3]));

		int32_t* prod1 = (int32_t*)mxGetData(prhs[2]);
		int32_t* prod2 = (int32_t*)mxGetData(prhs[3]);

		uint32_t* prod1v = new uint32_t[nprods];
		uint32_t* prod2v = new uint32_t[nprods];
		uint32_t* searchv = new uint32_t[nprods];
		mwSize dim[2] = { nprods, 1};	
		plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxUINT32_CLASS, mxREAL);
		uint32_t* foundindex = (uint32_t*)mxGetData(plhs[0]);
		int i;

		// generate new starting points by XORing starting points of x(t+t1) and x(t+t2)
		for (i = 0; i < nprods; i++)
		{
			if (prod1[i] < 0)
				prod1[i] += (nelt - 1);
			if (prod2[i] < 0)
				prod2[i] += (nelt - 1);

			// bad idea -- probably erases cache! (prod1v and prod2v are not necessary);
			prod1v[i] = mseq[prod1[i]];
			prod2v[i] = mseq[prod2[i]];
			searchv[i] = prod1v[i] ^ prod2v[i];
		}


		// now search for the location of the new starting points!
		for (i = 0; i < nelt; i++)
		{
			int j;
			for (j = 0; j < nprods; j++)
			{
				if (mseq[i] == searchv[j])
					foundindex[j] = i;
			}
		}

		// free up temporary memory!
		delete [] searchv;
		delete [] prod1v;
		delete [] prod2v;
	}
}
