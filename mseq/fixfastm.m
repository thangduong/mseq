% FIXFASTM      Fixes the fastm result into a displayable form
%
%    [TRACEMEAN, FIXEDRESULT] = FIXEDFASTM(ORDER, FASTMRESULT) fixes the
%    result of FASTM into a viewable form.  There are several things that
%    needs to be done after a fast m-transform in able to get the data into
%    a viewable form:
%        a.  for n-samples per frame vectorized m-transform (*), each
%        resulting frame needs to be flipped.
%        b.  because of the way the m-transform matrix are generated (see
%        Sutter's SIAM paper), the kernels when t increases actually goes
%        backwards from intuition in the m-transform result.  That is, if
%        q(t) is the m-transform result and h(t)=q(t) (where h(t) is a kernel) for t=0, then
%        h(t1)=q(t1) for t1=0,...-T where T is the memory of kernel h(t).
%        This means that for data displaying on the screen to not look
%        backwards, we need to flip the array.
%        c.  because 0->1, 1->-1, the result gets inverted in the y-axis.
%        multiplying by -1 corrects this.
%        d.  there is a 1/(2^order-1) factor that needs to be corrected
%        for.
%  This function basically does (a), (b), (c), and (d).
%
%
%   n-samples per frame vectorized m-transform
%
% See also FASTM
%
% REVISION HISTORY
% Thang    1/20/2004    Seems to work.  Not very fast because it's not MEXed
% Thang    2/4/2004      Commented out the flipdim
%
function [tracemean, fixedresult] = fixfastm(order, fastmresult);

len = length(fastmresult);

samplesperframe = floor(len / (2^order));
if ((samplesperframe * (2^order)) ~= len)
    disp('invalid fastmresult.  length must be equal to k * 2^order.');
end

tracemean = fastmresult(1:samplesperframe) / (2^(order-1));
fixedresult = fastmresult((samplesperframe+1):len);

k = 1;
if (size(fixedresult,1) ~= 1)
    dim2flip = 1;
else
    dim2flip = 2;
end

for i=1:((2^order) - 1)
%    disp(num2str([k, k+samplesperframe-1]));
    fixedresult(k:(k+samplesperframe-1)) = flipdim(fixedresult(k:(k+samplesperframe-1)), dim2flip);
    k = k + samplesperframe;
end

fixedresult = rotatevector(fixedresult, samplesperframe);
if (size(fixedresult,1) ~= 1)
    dim2flip = 1;
else
    dim2flip = 2;
end
%fixedresult = -flipdim(fixedresult, dim2flip) / (2^(order-1));
fixedresult = -fixedresult / (2^(order-1));
