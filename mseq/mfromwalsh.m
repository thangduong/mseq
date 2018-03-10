% MFROMWALSH	Gets the m-transform kernel from the Walsh transform kernel
%
%   [MK P1 P2] = MFROMWALSH(ORDER, SEED, OFFSET) generates the m-transform kernel from the Walsh
%   transform kernel.  This code doesn't do much.  It demonstrates that my permutation
%   idea is right.  MK = m transform kernel.  P1, P2 are permutation matrices so that
%   MK = P2 * W * P1 where W is the Walsh transform kernel.
%   OFFSET is for m-transform kernel with the m-sequence shifted over by OFFSET bits.
%
function [mk, P1, P2, P3] = mfromwalsh(order, seed, offset)

N = 2^order;
w = makewalsh(order);

% generate the stages via the tap and generating regs
[t g] = genmseq(order,seed);

% find the permutation matrices
P1(1,1)=1;
P2(1,1)=1;
P3(1,1)=1;
for i=2:(N)
   P3(i, mod(N-offset+i-3,N-1)+2)=1;
   P1(double(g(i-1))+1,i)=1;
   P2(i,double(t(i-1))+1)=1;
end

% multiply
mk = P2 * w * P1 * P3;
