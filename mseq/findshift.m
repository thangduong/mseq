% FINDSHIFT     Finds the starting point of an m-sequence given the
%               sequence and the seed.
%
%   N = FINDSHIFT(ORDER, SEED, SEQ) finds the offset of sequence SEQ away
%   from the "cannonical" m-sequence created from seed SEED.  This function
%   simply does a search to look for the first ORDER pattern in the
%   cannonical m-sequence generated by SLOWSEQP.  This function DOES NOT
%   check for validity of SEQ.
%
% Example:
%
%   temp = slowseqp(16,873);
%   findshift(order, seed, rotatevector(temp,5))  T re
%
% See also SLOWSEQP.
function n = findshift(order, seed, seq);

ms = slowseqp(order,seed);
ms = bitget(ms,1);

length(ms);
length(seq);
n=-1;
for i=1:(65535-order-2)
   if (length(find((double(ms(i:(i+order-1)))-double(seq(1:order))) ~= 0)) == 0)
      n = i;
      break;
   end
end
