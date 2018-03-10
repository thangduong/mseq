% SLICESEQ  Slices a sequence into pieces
%
%   SLICES = SLICESEQ(SEQ, PARAM, NUMADAPTELT, [OPTION]) slices the
%   sequence SEQ into pieces depending on PARAM and NUMAPTELT.  If OPTION =
%   0, then PARAM = number of elements per slice;  If OPTION = 1, then
%   PARAM = number of slices.  OPTION defaults to 0.
%
% Example:
%   sliceseq(seq,5,10,1);   % break into 5 slices
%
%
function [slices, sliceseqlen, lastlen] = sliceseq(seq, param, numadaptelt, option)

len = length(seq);

if (nargin < 4)
    option = 0;
end

if (option == 0)
    eltperslice = param;
    numslices = ceil(len / eltperslice);
else
    numslices = param;
    eltperslice = ceil(len / numslices);
end

% first element
slices(1,:) = [seq((len - numadaptelt + 1):len) seq(1:eltperslice)]; 
marker = eltperslice;

%disp(['sequence length  = ' num2str(len)]);
%disp(['number of slices = ' num2str(numslices)]);

for i=2:numslices
    v = (marker-numadaptelt+1):min((marker+eltperslice),len);
    slices(i,1:length(v)) = seq(v);
    marker = marker + eltperslice;
end

lastlen = length(v);
sliceseqlen = eltperslice + numadaptelt;