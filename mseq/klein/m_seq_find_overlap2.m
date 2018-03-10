%For x(t) x(t-t1) = x(t-t2) find t2 given t1.
%clear
m=16;mm=[1:m];
if m==8,seedm=[29 43 45 77 95 99 101 105 113 135 141 169 195 207 231 245];
elseif m==9, seedm=[17 27 33 45 51 89 95 105 111 119 125 135 149 163 165 175 183 189 207 209 219 245 249 275 ...
  277 287 291 305 315 335 347 353 363 365 371 383 389 399 437 441 455 459 461 469 473 483 489 507];
elseif m==16, seedm=goodseed;
elseif m==3,seedm=3;
end
nseed=length(seedm); 			%number of bits in shift register
highbit=2 .^(m-1);				%specifies the value of high bit
lenm=2^m -1;					%length of maximum sequence
ND=20 %20	%ND=1000			%number intervals between patches
NR=4*ND %NR=4*ND or 12ND;		%number of patches in a ring
t1=[1 2 3 ND NR] 				%the delays
count=zeros(1,lenm+1);
for i=0:lenm;count(i+1)=sum(bitget(i,mm));end
mod2=(count-2*floor(count/2))*highbit;
newstim=bitget(count,1)*highbit;

%generating register
for iseed=1:nseed;				%specifies the m-sequence
  seed=seedm(iseed);
  stim=1; 						%starting point of sequence
  itime=1;
  for i=1:NR;
	stim=floor(stim/2) + mod2(bitand(stim,seed)+1);
	if t1(itime)==i;x1(itime)=stim;itime=itime+1;end
  end
  x2=bitxor(x1,1); %this is xor between x(t) and x(t-t1)

  i=1;stim=1;  %now find where x2 is located. Its delay is t2.
  for i=1:lenm
	xand=bitand(stim,seed);
	stim=floor(stim/2)+newstim(xand+1);
	[minval,imin]=min(abs(x2-stim));%to get location of other kernels
	if minval==0,loc_kernel(imin)=i+1; end
  end
  loc_kernel;
  overlap(iseed,:)=[seed mod(loc_kernel,ND)];
  disp(num2str(overlap(iseed,:)));
end

%for example, suppose t1=2 then x(t)x(t-2) = [0 0 1]xor[0 1 0]=[0 1 1] this is the
%7th element of the generating register.  Note that the 7th element of the tap register
%is 101, corresponding to 2nd slice of 2nd order kernel. So it works out. 