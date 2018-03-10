   result2 = slowseqp(uint32(16), uint32(goodseed(1))); 
   searchv(1:10, 1) = mexmseqfindprod(uint32(16), result2, int32([0 0 0 0 0 0 0 0 0 0]), int32([-5 -4 -3 -2 -1 1 2 3 4 5])); 
