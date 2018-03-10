% ROTATEVECTOR	Rotates a vector by a certain number of elements
%   
%   VOUT = ROTATEVECTOR(VIN, AMOUNT) rotates vector VIN by AMOUNT elements.  This function
%   is to facilitate doing an m-transform of a sequence that's been shifted.  Here is exactly
%   what this function does:
%        VOUT = ROTATEVECTOR(VIN, K) should give VIN and VOUT with the following properties
%     VOUT(j) = VIN(((K+j)%length(VIN)) + 1) where a%b is defined as the positive number x such
%     that a = b*k + x for an integer k.  This means that K can be negative.  When K is negative
%   this simply shifts everything in the opposite direction.  Here is an example:
%     VIN = [1 2 3 4 5]
%     ROTATEVECTOR(VIN, 1) = [2 3 4 5 1]
%     ROTATEVECTOR(VIN, -1) = [5 1 2 3 4]
%   This function is used to do an m-transform defined by an m-sequence that's shifted from the
%   standard tap-reg or gen-reg generating scheme.  For example, if the m-sequence is shifted 
%   forward by Z bit, then an m-transform of the data would be
%     fastm(order, seed, rotatevector(data, -Z)).
%   NOTE: VIN must be a 1-dim array.  Otherwise weird stuff happens.  Namely, 
%    it's the same as calling ROTATEVECTOR on the RESHAPEd version of the array
%    to a 1-dim array.
%
% EXAMPLE:
%   % collect data
%   fastm(3,3, rotatevector(data,-3));
%
