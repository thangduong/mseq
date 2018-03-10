function newi = mseqfindprod2(nbits, mseq, i1, i2)

i1v = mseq(i1+1)
i2v = mseq(i2+1);

newiv = double(bitxor(i1v,i2v));
newi = zeros([length(i1) 1]);
nfound = 0;
for i=0:((2^nbits)-1)
   value = double(mseq(i+1));
   [y, mini] = min(abs((newiv) - (value)));
   if (y == 0)
      newi(mini) = i;
      nfound = nfound+1;
      if (nfound == length(i1))
         break;
      end
%      disp(num2str([mini i]));
   end
   if (mod(i,5000) == 0)
	   disp(num2str([i value newiv y]));
   end
   
end
