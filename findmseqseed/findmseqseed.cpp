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
	if (nrhs != 1)
	{
		mexEvalString("help findmseqseed;");
	}
	else
	{
		unsigned long nbits;
		mwSize dim[2] = { 1, 1};

		nbits = maGetUINT32Element(prhs[0], 0); //*((unsigned long*)mxGetData(prhs[0]));
		dim[0] = (1<<nbits);


		int cnt = 0;

		printf("searching for m-sequence seeds...\n");
		unsigned long nbitstat = nbits - 4;
	
		// # of seeds is less than half the possible choices (for sure, it's actually a lot less)
		// this saves some time because we won't have to dynamically allocate.
		// there is probably a formula to calculate the exact # of good seeds.
		unsigned long* seeds = new unsigned long[(1<<(nbits-1))];

		// this is just an exhaustive search
		for (int j = 1; j < (1<<nbits); j=j+2)
		{
			unsigned long reg1 = 1;
			unsigned long reg2 = j;
			unsigned long np1bitmask = dim[0];
			unsigned long outputmask = dim[0] - 1;
			int i;

			// using sutter's tap register method (when reg1 repeats, the sequence repeats)
			// see Sutter's section in (Marmarelis 1987 Vol I)
			for (i = 1; i < dim[0]; i++)
			{
				reg1 = (reg1 << 1);
				if (reg1 & np1bitmask)
					reg1 = (reg1 ^ reg2);
				if ((reg1 & outputmask) == 1)
					break;
			}
			i++;

			// if good seed, then save it
			if (i == dim[0])
			{
				seeds[cnt] = j;
				cnt++;
			}

			// output some status so the user doesn't freak out!
			if (((j >> nbitstat)<<nbitstat) == (j-1))
				printf("at seed %d out of %d\n", j, dim[0]);
		}

		// allocate matlab array to pass data back and copy data to array
		dim[0] = cnt;
		plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxUINT32_CLASS, mxREAL);
		unsigned long* result = (unsigned long*)mxGetData(plhs[0]);
		memcpy(result, seeds, cnt * sizeof(unsigned long));

		// finally free up temporary memory
		delete [] seeds;
	}
}

