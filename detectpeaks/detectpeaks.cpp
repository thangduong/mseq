//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// detectpeaks.cpp
//
//  This is written specifically for photodiode tests.
//
//   type help detectpeaks in matlab for more info
//
// REVISION HISTORY
//
//
// Thang	9/24/2003	Wrote this.  Seems to work fine.  The heuristics may need tweaking, but
//                      it looks pretty much done.
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Defintions to turn on some heuristics.  The best way is, of course, to curve fit the decay
// characteristics of the phosphorus, but that'll take too long, so some heuristics will have to do!
#define	REMOVE_DOUBLEPEAKS					// If this is defined, it tries to remove double peaks
											// by checking to see if two peaks are too close to each other
#define	MIN_PEAK_INTERVAL		10			// (i.e. close than MIN_PEAK_INTERVAL)

//#define AVERAGE_DOUBLEPEAK_LOCATIONS		// If this is defined, it averages the peak locations for
											// close peaks together.  Otherwise, it just takes the largest one.

#define THRESHOLD_VOLTAGE_LEVEL				// If this is defined, it makes sure the level of the peaks
											// have to be above a threshold to count the peak as valid.
#define VOLTAGE_THRESHOLD_VALUE	100			// this is actually in value output from the ADC

//#define _DEBUG									// turn debug messages on

//#define THRESHOLD_SECOND_ORDER_LEVEL			// if this is defined, it makes sure the level of the second order
											// finite difference is above a threshold to count the peak as valid
//#define SECOND_ORDER_THRESHOLD_VALUE	300		// this is the threshold value for definition above

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
#else
template<class TYPE>
TYPE max(TYPE x, TYPE y)
{
  if (x > y)
    return x;
  else
    return y;
}
#endif

mxArray* DetectPeaksDouble(const mxArray* pArray)
{
	// This function does the 1st and 2nd order finite difference
	// and detect the peaks.  The final array is returned as a
	// matlab array.  It should be ready to be returned to matlab.
	// This function assumes pArray is a 1 dimensional array
	// of doubles with length of at least 3 (otherwise it's senseless).
	// Passing anything else in can give unpredictable results!

	double* pData = (double*)mxGetData(pArray);
	uint32_t ulDataSize = (uint32_t)(mxGetM(pArray)*mxGetN(pArray));
	double FirstOrderDifference[2] = { 0, pData[1] - pData[0]};
	double SecondOrderDifference;
	double TimeStamp, PeakValue;
	double *pTempTimeStamps, *pTempPeaks;
	pTempTimeStamps = new double[ulDataSize / 2];
	pTempPeaks = new double[ulDataSize/2];
	uint32_t ulNumPeaks = 0;
#ifdef _DEBUG
	double dbgFOD[2];
	double dbgSOD;
#endif

	for (unsigned i = 2; i < ulDataSize; i++)
	{
		// NOTE: this is not optimized!
		FirstOrderDifference[0] = FirstOrderDifference[1];
		FirstOrderDifference[1] = pData[i] - pData[i-1];
		SecondOrderDifference = FirstOrderDifference[1] - FirstOrderDifference[0];
#ifdef _DEBUG
		memcpy(dbgFOD, FirstOrderDifference, sizeof(FirstOrderDifference));
		dbgSOD = SecondOrderDifference;
#endif

		// now, check if FirstOrderDifference[0] * FirstOrderDifference[1] <= 0,
		// if so, then zero is in the interval [FirstOrderDifference[0], FirstOrderDifference[1]]
		//  (via Intermediate Value Theorem?)

		if ((FirstOrderDifference[0] != 0) &&
			(((FirstOrderDifference[0] * FirstOrderDifference[1]) <= 0) &&
			(SecondOrderDifference < 0)))
		{
			// we have an approximate local maximum here!

			// we should note that the first order differences actually lie in between
			// sampling points, and the second order difference lies on the sampling point.

			if (FirstOrderDifference[1] == 0)
			{
				// this probably has higher probability of being true than the other cases
				TimeStamp = i - 0.5;
				PeakValue = max(pData[i], pData[i-1]);
	//			PeakValue = (pData[i] + pData[i-1]) / 2;
			}
			else
			{
				// do simple interp to approximate
				double FirstSegment = FirstOrderDifference[0]/(-SecondOrderDifference) - 0.5;
				TimeStamp = i - 1 + FirstSegment;
				if (FirstSegment < 0)
					PeakValue = max(pData[i-1], pData[i-2]);
//					PeakValue = (-pData[i-1] * FirstSegment + pData[i-2] * (1+FirstSegment));
				else
					PeakValue = max(pData[i], pData[i-1]);
//					PeakValue = (pData[i-1] * FirstSegment + pData[i] * (1-FirstSegment));
			}


#ifdef THRESHOLD_SECOND_ORDER_LEVEL
			if (SecondOrderDifference < -SECOND_ORDER_THRESHOLD_VALUE)
#endif
			{
#ifdef THRESHOLD_VOLTAGE_LEVEL
			if (PeakValue > VOLTAGE_THRESHOLD_VALUE)
#endif
			{
#ifdef REMOVE_DOUBLEPEAKS
			bool bShouldKeepPeak = true;
			if (ulNumPeaks > 0)
			{
				double NewInterval = (TimeStamp+1) - pTempTimeStamps[ulNumPeaks - 1];
				if (NewInterval < MIN_PEAK_INTERVAL)
				{
					bShouldKeepPeak = false;

#ifdef AVERAGE_DOUBLEPEAK_LOCATIONS
					pTempTimeStamps[ulNumPeaks - 1] += (TimeStamp + 1);
					pTempTimeStamps[ulNumPeaks - 1] /= 2;
					if (pTempPeaks[ulNumPeaks - 1] < PeakValue)
						pTempPeaks[ulNumPeaks - 1] = PeakValue;
#else
					if (pTempPeaks[ulNumPeaks - 1] < PeakValue)
					{
						pTempTimeStamps[ulNumPeaks - 1] = (TimeStamp + 1);
						pTempPeaks[ulNumPeaks - 1] = PeakValue;
#ifdef _DEBUG
			printf("**>(%d, %0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%d)\n", ulNumPeaks, TimeStamp+1, PeakValue,
				SecondOrderDifference, dbgSOD,
				dbgFOD[0],dbgFOD[1],
				pData[i], pData[i-1], i);
#endif
					}
#endif
				}
			}
			if (bShouldKeepPeak)
#endif
			{
				pTempTimeStamps[ulNumPeaks] = TimeStamp+1;
				pTempPeaks[ulNumPeaks] = PeakValue;
				ulNumPeaks++;
#ifdef _DEBUG
			printf("==>(%d, %0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%0.2f,%d)\n", ulNumPeaks, TimeStamp+1, PeakValue,
				SecondOrderDifference, dbgSOD,
				dbgFOD[0],dbgFOD[1],
				pData[i], pData[i-1], i);
#endif
			}
			}
			}
		}
	}

	// copy our temporary arrays over to Matlab's array, delete our temporary array,
	// and return.
	mwSize dim[2] = {ulNumPeaks, 2};
	mxArray* pResult = mxCreateNumericArray(sizeof(dim)/sizeof(dim[0]),dim,mxDOUBLE_CLASS,mxREAL);
	double* pResultData = (double*)mxGetData(pResult);
	memcpy(pResultData, pTempTimeStamps, ulNumPeaks * sizeof(double));
	memcpy(pResultData + ulNumPeaks, pTempPeaks, ulNumPeaks * sizeof(double));

	delete [] pTempTimeStamps;

	delete [] pTempPeaks;

	return pResult;
}

////////////////////////////////////////////////////////////////////////////////
// This is the core of the work
////////////////////////////////////////////////////////////////////////////////
void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
	if (nrhs < 1)
	{
		mexEvalString("help detectpeaks;");
	}
	else
	{
		double SamplingRate = 1;
		if (nrhs > 1)
			SamplingRate = maGetDoubleElement(prhs[1], 0);

		plhs[0] = DetectPeaksDouble(prhs[0]);
	}
}
