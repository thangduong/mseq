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
		unsigned long nbits;
		unsigned long* mseq = (unsigned long*)mxGetData(prhs[1]);
		nbits = *((unsigned long*)mxGetData(prhs[0]));

		unsigned long nelt = (1<<nbits);

		unsigned long nprods = max(mxGetM(prhs[2]), mxGetN(prhs[3]));

		long* prod1 = (long*)mxGetData(prhs[2]);
		long* prod2 = (long*)mxGetData(prhs[3]);

		unsigned long* prod1v = new unsigned long[nprods];
		unsigned long* prod2v = new unsigned long[nprods];
		unsigned long* searchv = new unsigned long[nprods];
		int dim[2] = { nprods, 1};	
		plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxUINT32_CLASS, mxREAL);
		unsigned long* foundindex = (unsigned long*)mxGetData(plhs[0]);
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
