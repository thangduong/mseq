clear
m=16;mm=[1:m];
	lenm=2^m-1;
highbit=2 .^(m-1);ii=0;
mod1=zeros(1,lenm+1);
zero_one='01';
for xand=0:lenm;
	count=sum(bitget(xand,mm));
	mod1(xand+1)=(count-2*floor(count/2));
end
mod2=mod1*highbit;

tic
for seed=1:2:2^m, %this counts the length of a given cycle
%seed=5959;
%generating register
  i=0;stim=1;
  stim_cycle=[];
  while (stim>1) | (i==0) %& (i<lenm/2+2)
	i=i+1;
	stim=floor(stim/2) + mod2(bitand(stim,seed)+1);
%	stim_cycle=[stim_cycle zero_one(mod1(bitand(stim,seed)+1)+1)];
  end
  len=i;
  [seed i];
  if i==lenm, ii=ii+1;goodseed(ii)=seed;%good_cycle(ii,:)=stim_cycle;
     goodseed(ii)

%     return;
	  end

 if 1==1,
   %tap register
    stim=1;tap_reg(1)=stim;
    for i=1:len
	  isone=bitget(stim,m);
	  stim=bitshift(stim,1,m);
	  stim=bitxor(stim,seed*isone);
	  tap_reg(i+1)=stim;
    end
    tap_reg;
end

end
toc
goodseed
%the following checks out the multiplication on p. 198
P1=[1 0 0 0 0 0 0 0;0 1 0 0 0 0 0 0;0 0 0 1 0 0 0 0;0 0 0 0 0 0 0 1;...
    0 0 1 0 0 0 0 0;0 0 0 0 1 0 0 0;0 0 0 0 0 1 0 0;0 0 0 0 0 0 1 0];
P2=[1 0 0 0 0 0 0 0;0 1 0 0 0 0 0 0;0 0 1 0 0 0 0 0;0 0 0 0 1 0 0 0;...
    0 0 0 1 0 0 0 0;0 0 0 0 0 0 0 1;0 0 0 0 0 1 0 0;0 0 0 0 0 0 1 0];
WW=[1 1 1 1 1 1 1 1;1 0 1 0 1 0 1 0;1 1 0 0 1 1 0 0;1 0 0 1 1 0 0 1;...
    1 1 1 1 0 0 0 0;1 0 1 0 0 1 0 1;1 1 0 0 0 0 1 1;1 0 0 1 0 1 1 0];
WT=WW*2-1;
MT=P2'*WT*P1;
