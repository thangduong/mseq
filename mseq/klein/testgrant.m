%load goodseed;
if (exist('goodseed') == 0)
    goodseed = findmseqseed(16);
end

BITSPERPATCH = 512;
PATCHESPERRING = 18;
L = BITSPERPATCH;
R = BITSPERPATCH * PATCHESPERRING;
i1 = uint32([0   0  0  0  0 0     0     0     0     0     0     0     0    ]);
i2 = uint32([1   2  3  L  R 1     1     2     2     1     1     2     2    ]);
i3 = uint32([ 0  0  0  0  0 L     (L-1) L     (L-2) R     (R-1) R     (R-2)]);
i4 = uint32([ 0  0  0  0  0 (L+1) L     (L+2) L     (R+1) R     (R+2) R    ]);

% even and odd
%i1 = uint32([0   0  0  0  0 0     0     0     0     0     0     0     0      0  0  0]);
%i2 = uint32([1   2  3  L  R 1     1     2     2     1     1     2     2      1  1  2]);
%i3 = uint32([ 0  0  0  0  0 L     (L-1) L     (L-2) R     (R-1) R     (R-2)  2  3  3]);
%i4 = uint32([ 0  0  0  0  0 (L+1) L     (L+2) L     (R+1) R     (R+2) R      0  0  0]);


i1l = length(i1);
tic; 
disp(['number of kernels to check = ' num2str(i1l+1)]);
for i=1:length(goodseed)
   result2 = slowseqp(16, goodseed(i)); 
   for j=1:i1l
      if (i3(j) == 0)
         searchv(j,i) = mexmseqfindprod(uint32(16), result2, i1(j), i2(j));
      else
         if (i4(j) == 0)
            v1 = mexmseqfindprod(uint32(16), result2, i1(j), i2(j));
            searchv(j,i) = mexmseqfindprod(uint32(16), result2, v1, i3(j));
         else
            v1 = mexmseqfindprod(uint32(16), result2, i1(j), i2(j));
            v2 = mexmseqfindprod(uint32(16), result2, i3(j), i4(j));
            searchv(j,i) = mexmseqfindprod(uint32(16), result2, v1, v2);
         end
      end
      %	   searchv(1:i1l, i) = mexmseqfindprod(uint32(16), result2, i1, i2); 
   end
   searchv(i1l+1,i) = 0;		% first order kernel location
   if (mod(i,100)==0)
      disp(['at seed number ' num2str(i)]);
   end; 
end;
toc;
sorted = sort(mod(double(searchv),512), 1);
spacing = diff(sorted, 1, 1);
minspacing = min(spacing, [], 1);
[maxminspacing, mmsindex] = max(minspacing, [], 2);
disp(sprintf('good seed = %d, min spacing = %d', goodseed(mmsindex), maxminspacing));