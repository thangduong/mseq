% MAKEWALSH	Makes the Walsh transform kernel by using the recursive definition
% 
%   W = MAKEWALSH(ORDER) makes a Walsh transform kernel of dimension 2^(ORDER)
%   square.
%
function w = makewalsh(order)

if (order <= 1)
   w = [1 1; 1 -1];
else   
   wh = makewalsh(order-1);
   w = [wh wh; wh -wh];
end


