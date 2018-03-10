function value = getmseqvalue(nbits, mseq, bitposition);

% NOTE: need serious work on when bitposition is towards the end
for i=1:length(bitposition)
	index1 = floor(bitposition(i) / nbits)+1;
	rightshiftnum = mod(bitposition(i), nbits);
	value1 = bitshift(mseq(index1), -rightshiftnum);
   if (rightshiftnum ~= 0)
      if (index1 == length(mseq))
			leftshiftnum = nbits - rightshiftnum;
			index2 = 1;
	      value2 = bitshift(mseq(index2), leftshiftnum);
      else
			leftshiftnum = nbits - rightshiftnum;
			index2 = index1+1;
  	      value2 = bitshift(mseq(index2), leftshiftnum);
      end
	else
	   value2 = 0;
	end
	value(i) = bitand(value1 + value2,(2^nbits)-1);
end
