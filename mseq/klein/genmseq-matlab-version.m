% GENMSEQ	Generates an m-sequence given a seed
%   GENMSEQ(NBITS, SEED, [INITREG1]) generates an m-sequence with seed SEED of
%   NBITS long.
%
function mseq = genmseq(nbits, seed, initreg1)

% make sure parameters are right
if ((nargin ~= 2) & (nargin ~= 3))
   help getmseq;
   mseq = [];
   return;
end

if (nargin == 2)
   initreg1 = 1;
end


seed32 = uint32(seed);


if (nbits < 8)
	nelt = uint8(bitshift(1,nbits));
	np1bit = nelt;
   mseq = uint8(zeros([double(nelt),1]));
	reg1 = uint8(initreg1);
   reg2 = uint8(seed);
   mask = uint8((2^nbits)-1);
	else
   if (nbits < 16)
		nelt = uint16(bitshift(1,nbits));
		np1bit = nelt;
   	mseq = uint16(zeros([double(nelt),1]));
		reg1 = uint16(initreg1);
		reg2 = uint16(seed);
	   mask = uint16((2^nbits)-1);
   else
		nelt = uint32(bitshift(1,nbits));
		np1bit = nelt;
   	mseq = uint32(zeros([double(nelt),1]));
		reg1 = uint32(initreg1);
		reg2 = uint32(seed);
	   mask = uint32((2^nbits)-1);
   end
end

% loop and generate the sequence
mseq(1) = reg1;
i = 2;
while (i < nelt)
	reg1 = bitshift(reg1,1);
	if (bitand(reg1, np1bit) ~= 0)
      reg1 = bitxor(reg1, reg2);
   end
   mseq(i) = bitand(reg1,mask);
   i = i + 1;
end

%for i=1:double(nelt)
%   disp(num2str(bitget(double(mseq(i)), nbits:-1:1)))
%end
