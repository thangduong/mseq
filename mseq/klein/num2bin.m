% NOTE: use num2str(bitget(num, 1:nbits))
function res = num2bin(num, nbits)

num = uint32(num);
if (exist('nbits') == 0)
   i = 0;
   temp = num;
   while (temp)
      temp = bitshift(temp,-1);
      i=i+1;
   end
end

res = char(ones([1 nbits]) * ' ');   

for i=1:nbits
   if (bitget(num, i) ~= 0)
      
end
