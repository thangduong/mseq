// matlabaux.cpp : Defines the entry point for the DLL application.
//

#include "matlabaux.h"

#ifdef _WIN32
#ifndef COMPILE_IN_MATLAB
#include <windows.h>

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    switch (ul_reason_for_call)
	{
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
    }
    return TRUE;
}
#endif
#else
#define	__int64 int32_t
#endif

MATLABAUX_API uint32_t maGetUINT32Element(const mxArray* pArray, uint32_t index)
{
	uint32_t result;
	switch(mxGetClassID(pArray))
	{
	case mxDOUBLE_CLASS: 
		result = (uint32_t)(((double*)mxGetData(pArray))[index]);
		break;
	case mxSINGLE_CLASS: 
		result = (uint32_t)(((float*)mxGetData(pArray))[index]);
		break;
	case mxINT8_CLASS: 
		result = (uint32_t)(((char*)mxGetData(pArray))[index]);
		break;
	case mxUINT8_CLASS: 
		result = (uint32_t)(((unsigned char*)mxGetData(pArray))[index]);
		break;
	case mxINT16_CLASS: 
		result = (uint32_t)(((short*)mxGetData(pArray))[index]);
		break;
	case mxUINT16_CLASS: 
		result = (uint32_t)(((unsigned short*)mxGetData(pArray))[index]);
		break;
	case mxINT32_CLASS: 
		result = (uint32_t)(((int32_t*)mxGetData(pArray))[index]);
		break;
	case mxUINT32_CLASS: 
		result = (uint32_t)(((uint32_t*)mxGetData(pArray))[index]);
		break;
	case mxINT64_CLASS: 
		result = (uint32_t)(((__int64*)mxGetData(pArray))[index]);
		break;
	case mxUINT64_CLASS: 
		result = (uint32_t)(((unsigned __int64*)mxGetData(pArray))[index]);
		break;
	default:
		result = (uint32_t)-1;
		break;
	}
	return result;
}

MATLABAUX_API int32_t maGetINT32Element(const mxArray* pArray, int32_t index)
{
	int32_t result;
	switch(mxGetClassID(pArray))
	{
	case mxDOUBLE_CLASS: 
		result = (int32_t)(((double*)mxGetData(pArray))[index]);
		break;
	case mxSINGLE_CLASS: 
		result = (int32_t)(((float*)mxGetData(pArray))[index]);
		break;
	case mxINT8_CLASS: 
		result = (int32_t)(((char*)mxGetData(pArray))[index]);
		break;
	case mxUINT8_CLASS: 
		result = (int32_t)(((unsigned char*)mxGetData(pArray))[index]);
		break;
	case mxINT16_CLASS: 
		result = (int32_t)(((short*)mxGetData(pArray))[index]);
		break;
	case mxUINT16_CLASS: 
		result = (int32_t)(((unsigned short*)mxGetData(pArray))[index]);
		break;
	case mxINT32_CLASS: 
		result = (int32_t)(((int32_t*)mxGetData(pArray))[index]);
		break;
	case mxUINT32_CLASS: 
		result = (int32_t)(((uint32_t*)mxGetData(pArray))[index]);
		break;
	case mxINT64_CLASS: 
		result = (int32_t)(((__int64*)mxGetData(pArray))[index]);
		break;
	case mxUINT64_CLASS: 
		result = (int32_t)(((unsigned __int64*)mxGetData(pArray))[index]);
		break;
	default:
		result = (uint32_t)-1;
		break;
	}
	return result;
}

MATLABAUX_API double maGetDoubleElement(const mxArray* pArray, uint32_t index)
{
	double result;
	switch(mxGetClassID(pArray))
	{
	case mxDOUBLE_CLASS: 
		result = (double)(((double*)mxGetData(pArray))[index]);
		break;
	case mxSINGLE_CLASS: 
		result = (double)(((float*)mxGetData(pArray))[index]);
		break;
	case mxINT8_CLASS: 
		result = (double)(((char*)mxGetData(pArray))[index]);
		break;
	case mxUINT8_CLASS: 
		result = (double)(((unsigned char*)mxGetData(pArray))[index]);
		break;
	case mxINT16_CLASS: 
		result = (double)(((short*)mxGetData(pArray))[index]);
		break;
	case mxUINT16_CLASS: 
		result = (double)(((unsigned short*)mxGetData(pArray))[index]);
		break;
	case mxINT32_CLASS: 
		result = (double)(((int32_t*)mxGetData(pArray))[index]);
		break;
	case mxUINT32_CLASS: 
		result = (double)(((uint32_t*)mxGetData(pArray))[index]);
		break;
	case mxINT64_CLASS: 
		result = (double)(((__int64*)mxGetData(pArray))[index]);
		break;
	case mxUINT64_CLASS: 
		result = (double)((uint32_t)(((unsigned __int64*)mxGetData(pArray))[index]));
		break;
	default:
		result = (uint32_t)-1;
		break;
	}
	return result;
}
