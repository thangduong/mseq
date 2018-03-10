function seq = gencompactmseq(nbits, seed, initreg1)

nmseqbits = (2^nbits);
nelt = ceil(nmseqbits/nbits);

if (0)
if (nbits <= 8)
   seq = uint8(zeros([nelt,1]));
	else
   if (nbits <= 16)
   	seq = uint16(zeros([nelt,1]));
   else
   	seq = uint32(zeros([nelt,1]));
   end
end
end
seq = zeros([nelt, 1]);

factor = zeros([nbits 1]);
for i=1:nbits
   factor(i) = 2^(i-1);
end

reg1 = initreg1;
reg2 = seed;
seqindex = 1;
value = 0;
curbit = 2;
np1bit = nmseqbits;
for i=1:nmseqbits   
   value = value + factor(curbit) * bitget(reg1, 1);
   curbit = curbit + 1;
   if (curbit > nbits)
      seq(seqindex) = value;
      seqindex = seqindex+1;
      curbit = 1;
      value = 0;
   end
	reg1 = bitshift(reg1,1);
	if (bitand(reg1, np1bit) ~= 0)
      reg1 = bitxor(reg1, reg2);
   end
end
