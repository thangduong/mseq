#ifndef MATLABAUX_H
#define MATLABAUX_H


#include "mex.h"
#include "matrix.h"
#include <memory.h>

typedef int int32_t;
typedef unsigned int uint32_t;

// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the MATLABAUX_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// MATLABAUX_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.
#ifndef COMPILE_IN_MATLAB
#ifdef MATLABAUX_EXPORTS
#define MATLABAUX_API __declspec(dllexport)
#else
#define MATLABAUX_API __declspec(dllimport)
#endif
#else
#define	MATLABAUX_API	
#endif



MATLABAUX_API uint32_t maGetUINT32Element(const mxArray* pArray, uint32_t index);
MATLABAUX_API double maGetDoubleElement(const mxArray* pArray, uint32_t index);
MATLABAUX_API int32_t maGetINT32Element(const mxArray* pArray, int32_t index);


#endif
