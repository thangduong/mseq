% FASTM	Fast m-transform as given in Sutter's SIAM paper
%
%   RESULT = FASTM(ORDER, SEED, DATA, [LUT]) is a fast m transform
%   of DATA of order ORDER and seed SEED.  [LUT] is the look up table
%   from CREATEBCPLUT.  This function automatically calls CREATEBCPLUT
%   if [LUT] is not given.  This function calls 
%      PREWALSHPERM, FASTWALSH, and POSTWALSHPERM in that order.
%
%   Note: DATA has to be of length k*2^ORDER for integer k.
%
% EXAMPLE:
%   result = fastm(3,3,rand(8,1));
%
% See also CREATEBCPLUT, PREWALSHPERM, FASTWALSH, POSTWALSHPERM.
%
function result = fastm(order, seed, data, lut)

if (nargin < 3)
    help fastm;
    return;
end

if (exist('lut') == 0)
   lut = createbcplut(order);
end

result = postwalshperm(order,seed,fastwalsh(order,prewalshperm(order,seed,data,lut)));