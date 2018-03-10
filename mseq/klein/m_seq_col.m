function mseq = m_seq_col(n, gen_reg)


for m=1:length(gen_reg)

for i=1:2^n
   
   v = bitand(i,gen_reg(m));
   
   % make lookup table for this!
   bc = 0;
   for j=1:n
      if (	bitand(v,(2^(j-1))) ~= 0)
         bc = mod(bc+1,2);
      end
   end
   
   mseq(m,i) = xor(bc, mod(gen_reg(m),2));

end

end
disp(num2str(mseq));

