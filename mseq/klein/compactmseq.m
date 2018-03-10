function seq = compactmseq(nbits, mseq, seqnum);

nelt = ceil((2^nbits)/nbits);

if (nbits <= 8)
   seq = uint8(zeros([elt,1]));
	else
   if (nbits <= 16)
   	seq = uint16(zeros([nelt,1]));
   else
   	seq = uint32(zeros([nelt,1]));
   end
end

factor = zeros([nbits 1]);
for i=1:nbits
   factor(i) = 2^(i-1);
end

seqindex = 0;
value = 0;
compactseqindex = 0;
for i=[length(mseq) 1:(length(mseq)-1)]
   modulo = mod(seqindex,nbits);
   if (modulo == 0)
      if (compactseqindex > 0)
         seq(compactseqindex) = value;
      end
      compactseqindex = compactseqindex+1;
      value = 0;
   end
   value = value + bitget(double(mseq(i)),seqnum) * factor(modulo+1);
   seqindex = seqindex + 1;
end
if (value ~= 0)
   seq(compactseqindex) = value;
end

