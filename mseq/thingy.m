% THINGY    Thang's test code
%
function thingy(data, I, L, k)
if (nargin == 2)
   L=200; k = 2;
end

hold off; plot(data((I(k)-L):(I(k)+L),4));hold on; plot(data((I(k)-L):(I(k)+L),2), 'red');
plot(data((I(k)-L):(I(k)+L),1), 'green');