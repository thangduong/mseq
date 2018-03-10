//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// REVISION HISTORY
//
// 1/6/2004	Thang Duong		Made the result INT32 instead of UINT32 because option 2 returns -1 on some
//							elements.
//       
// 1/16/2004 Thang Duong    genmseq(x,x,2,10) crash fix
//                   
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

void MSeqGenRegOutput(unsigned long nbits, unsigned long seed, unsigned long size, unsigned long outputmask, mxArray* gen, unsigned long repeat)
{
	unsigned long* result;
	unsigned long i;
//	unsigned long outputmask = size - 1;	
	unsigned long reg1 = 1;
	unsigned long reg2;
	unsigned long j;
	//  generating register method
		
	result = (unsigned long*)mxGetData(gen);
	
	// bit counter! -- TODO: use permanent lookup table for this!
	unsigned long* newbit = new unsigned long[size];
	for (i = 0; i < size; i++)
	{
		unsigned long j;	
		newbit[i] = 0;
		for (j = 0; j < nbits; j++)
			newbit[i] += ((1<<j)&i) ? 1 : 0;
		newbit[i] = (newbit[i] % 2) << (nbits - 1);
	}
	
	// use Sutter's generating register method
	// see Sutter's section in (Marmarelis 1987, Vol I)
	for (i = 0; i < size-1; i++)
	{
		(*result) = (reg1 & outputmask); result++;
		for (j = 1; j < repeat; j++)
		{
			(*result) = result[-1]; result++;
		}
		reg2 = reg1 & seed;
		reg1 = (reg1 >> 1)+newbit[reg2];
	}

	delete [] newbit;
}
void MSeqTapRegOutput(unsigned long nbits, unsigned long seed, unsigned long size, unsigned long outputmask, mxArray* tap, unsigned long repeat)
{
	unsigned long* result;
	result = (unsigned long*)mxGetData(tap);
	
	unsigned long reg1 = 1;
	unsigned long reg2 = seed;
	unsigned long np1bitmask = size;
	unsigned long j;
//	unsigned long outputmask = size - 1;
	
	// use Sutter's tap register method
	// see Sutter's section in (Marmarelis 1987, Vol I)
	for (unsigned long i = 0; i < size-1; i++)
	{
		(*result) = (reg1 & outputmask); result++;
		for (j = 1; j < repeat; j++)
		{
			(*result) = result[-1]; result++;
		}
		reg1 = (reg1 << 1);
		if (reg1 & np1bitmask)
			reg1 = (reg1 ^ reg2);
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
		mexEvalString("help genmseq;");
	}
	else
	{
		unsigned long option = 0;
		unsigned long nbits;
		unsigned long seed;
		unsigned long repeat = 1;
		int dim[2] = { 1, 1};

		// assume unsigned long input! (TODO: fix this!)
		nbits = maGetUINT32Element(prhs[0], 0); //*((unsigned long*)mxGetData(prhs[0]));
		seed  = maGetUINT32Element(prhs[1], 0); //*((unsigned long*)mxGetData(prhs[1]));

		if (nrhs > 2)
			option = maGetUINT32Element(prhs[2], 0);
		if (nrhs > 3)
			repeat = maGetUINT32Element(prhs[3], 0);

		//  tap register method!

		// create result array
		dim[1] = ((1<<nbits)-1)*repeat;

		plhs[0] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxINT32_CLASS, mxREAL);
		if (plhs[0] == 0)
			printf("out of memory\n");
		else
		{
			switch(option)
			{
			case 0:
				plhs[1] = mxCreateNumericArray(sizeof(dim) / sizeof(dim[0]), dim, mxUINT32_CLASS, mxREAL);
				if (plhs[1] == 0)
					printf("out of memory\n");
				else
				{
					MSeqGenRegOutput(nbits, seed, (1<<nbits), dim[1], plhs[0], repeat);
					MSeqTapRegOutput(nbits, seed, (1<<nbits), dim[1], plhs[1], repeat);
				}
				break;
			case 1:
				MSeqGenRegOutput(nbits, seed, (1<<nbits), 1, plhs[0], repeat);
				break;
			case 2:
				MSeqGenRegOutput(nbits, seed, (1<<nbits), 1, plhs[0], repeat);
				{
					long* v = (long*)mxGetData(plhs[0]);
					for (unsigned long i = 0; i < dim[1]; i++)
					{
						(*v) = 1-(*v) * 2;
						v++;
					}
				}
				break;
			}
		}

	}
}

