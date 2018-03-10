% MAKEMKERNEL	This function makes an m-transform kernel given a seed and order
%
%   MK = MAKEMKERNEL(ORDER, SEED) makes an m-transform of order ORDER with seed
%   SEED.
%
function mk = makemkernel(order, seed);

% make the sequence
mseq = slowseqp(order, seed);

L = length(mseq);
mk = ones(L);

% shift appropriately!
for i=2:L
   mk(i,2:(L-i+2)) = (-1).^(double(bitget(mseq((i-1):(L-1)), 1)));
%   i
%   -2*ones(1,i-2)
%   mk(i,(L-i+3):L)
   mk(i,(L-i+3):L) = (-1).^(double(bitget(mseq(1:(i-2)), 1)));
end
