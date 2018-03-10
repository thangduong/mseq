% NMFASTWALSH	No Mean Fast Walsh-Hadamard transform
%
%   TRANS = NMFASTWALSH(ORDER, DATA) takes the Walsh-Hadamard transform of the
%   vector DATA using the fast walsh transform algorithm.  The length of DATA
%   has to be exactly (2^ORDER-1)*BLOCKSIZE.  Weird stuff can happen if this is not true.
%   (These two parameters are needed for possible future revisions.  It is
%   possible to just check for consistency of the two parameters, but
%   I am lazy).
%   NOTE: DATA must be an array of DOUBLE, INT16, or INT32 (the UNSIGNED
%   data types WILL NOT WORK).
%   This function is like fastwalsh only it assumes the first BLOCKSIZE
%   elements are zero.
%
% EXAMPLE:
%   walshdata = nmfastwalsh(16, mydata);
%