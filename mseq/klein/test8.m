%load goodseed;
goodseed = m;
BITSPERPATCH = 32;
PATCHESPERRING = 2;
i1 = uint32([0 0 0]);
i2 = uint32([1 2 3]);
%i1 = uint32([0 0 0 0 0 0 0]);
%i2 = uint32([1 2 3 4 5 BITSPERPATCH BITSPERPATCH*PATCHESPERRING]);
i1l = length(i1);
tic; 
for i=1:length(goodseed)
   result2 = slowseqp(uint32(8), uint32(goodseed(i))); 
   searchv(1:i1l, i) = mexmseqfindprod(uint32(8), result2, i1, i2); 
   if (mod(i,100)==0)
      disp(['at seed number ' num2str(i)]);
   end; 
end;
toc;
sorted = sort(mod(double(searchv),32), 1);
spacing = diff(sorted, 1, 1);
minspacing = min(spacing, [], 1);
[maxminspacing, mmsindex] = max(minspacing, [], 2);
disp(sprintf('good seed = %d, min spacing = %d', double(goodseed(mmsindex)), maxminspacing));