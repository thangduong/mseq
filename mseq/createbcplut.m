% CREATEBCPLUT	Creates a Bit Count Parity Look Up Table
%
%   LUT = CREATEBCPLUT(ORDER) creates a bit count parity look up table
%   that can be used to generate an m-sequence via the generating
%   register method.  The bit count parity look up table (BCPLUT) is
%   a table of values indicating the parity of the bit count of 
%   its index.  More precisely,
%
%      LUT(j) = 0 if j has an even number of 1 in its binary representation
%             = 2^(order-1) if j has an odd number of 1 in its binary rep 
%
%   This table is used by other functions to speed up execution time.
%
% EXAMPLE:
%
%   lut = createbcplut(3);
%   data = prewalshperm(3, 3, data, lut);
%   data = fastwalsh(3, data);
%   data = postwalshperm(3, 3, data);
%   % here data is the m-transform of the initial 
%   % data array for m sequence seed 3 of order 3.
%
% See also PREWALSHPERM, GENREGMSEQ.
%