% DETECTPEAKS	Detects the peak of a trace of signal using simple 1st and 2nd derivative test
%
%    PEAKS = DETECTPEAKS(DATA, [SR]) detects the peaks of DATA by finding the zeros of the 1st order finite 
%    difference with negative 2nd order finite difference.  This is basically checking for
%    an extrema and then checking for convexity (discretized).  SR is the sampling rate of the data,
%    and it's default to 1.  DATA should be a 1 dimensional array,
%    and the return value PEAKS is a 2 dimensional array.  PEAKS(:,1) contains the time stamp of
%    the peaks in seconds (if SR is set appropriately) and PEAKS(:,2) contains the corresponding
%    amplitude of the peak.  NOTE: SR has not been implemented yet, so it's always assumed
%    to be 1!  Even if it's set to something else, the function will pretend it's 1.
%
% EXAMPLE:
%    PEAKS = DETECTPEAKS(DATA).