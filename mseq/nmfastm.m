% NMFASTM	No Mean Fast m-transform as given in Sutter's SIAM paper
%
%   RESULT = NMFASTM(ORDER, SEED, DATA, [LUT]) is a fast m transform
%   of DATA of order ORDER and seed SEED.  [LUT] is the look up table
%   from CREATEBCPLUT.  This function automatically calls CREATEBCPLUT
%   if [LUT] is not given.  This function calls 
%      PREWALSHPERM, FASTWALSH, and POSTWALSHPERM in that order.
%
%   Note: DATA has to be of length k*(2^ORDER-1) for integer k.
%   Note 2: this is the same as FASTM without the mean element. 
%
% EXAMPLE:
%   result = nmfastm(3,3,rand(8,1));
%
% See also CREATEBCPLUT, NMPREWALSHPERM, NMFASTWALSH, NMPOSTWALSHPERM.
%
function result = fastm(order, seed, data, lut)

if (nargin < 3)
    help fastm;
    return;
end

if (exist('lut') == 0)
   lut = createbcplut(order);
end

result = nmpostwalshperm(order,seed,nmfastwalsh(order,nmprewalshperm(order,seed,data,lut)));