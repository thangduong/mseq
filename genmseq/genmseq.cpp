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

void MSeqGenRegOutput(uint32_t nbits, uint32_t seed, uint32_t size, uint32_t outputmask, mxArray* gen, uint32_t repeat)
{
	uint32_t* result;
	uint32_t i;
//	uint32_t outputmask = size - 1;	
	uint32_t reg1 = 1;
	uint32_t reg2;
	uint32_t j;
	//  generating register method
		
	result = (uint32_t*)mxGetData(gen);
	
	// bit counter! -- TODO: use permanent lookup table for this!
	uint32_t* newbit = new uint32_t[size];
	for (i = 0; i < size; i++)
	{
		uint32_t j;	
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
void MSeqTapRegOutput(uint32_t nbits, uint32_t seed, uint32_t size, uint32_t outputmask, mxArray* tap, uint32_t repeat)
{
	uint32_t* result;
	result = (uint32_t*)mxGetData(tap);
	
	uint32_t reg1 = 1;
	uint32_t reg2 = seed;
	uint32_t np1bitmask = size;
	uint32_t j;
//	uint32_t outputmask = size - 1;
	
	// use Sutter's tap register method
	// see Sutter's section in (Marmarelis 1987, Vol I)
	for (uint32_t i = 0; i < size-1; i++)
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
		uint32_t option = 0;
		uint32_t nbits;
		uint32_t seed;
		uint32_t repeat = 1;
		mwSize dim[2] = { 1, 1};

		// assume uint32_t input! (TODO: fix this!)
		nbits = maGetUINT32Element(prhs[0], 0); //*((uint32_t*)mxGetData(prhs[0]));
		seed  = maGetUINT32Element(prhs[1], 0); //*((uint32_t*)mxGetData(prhs[1]));

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
					for (uint32_t i = 0; i < dim[1]; i++)
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

