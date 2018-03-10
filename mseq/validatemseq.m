% VALIDATEMSEQ  Validates m-sequence segments
%
%    [PATCHLOC, MSEQ] = VALIDATEMSEQ(ORDER, SEED) looks for the directory
%    with the name ORDER_SEED and checks to make sure all the segments in
%    that directory are valid.  NOTE: this function is VERY SLOW because I
%    used matlab to do searching.  There is now new MEX code (findlocation)
%    that can do this search fast.  TODO: fix this code so it uses the new
%    faster MEX code.  The return values PATCHLOC = location of the
%    patches.  If there are N patches, PATCHLOC is an array of N elements.
%    MSEQ contains the actual m-sequence starting with the canonical
%    beginning of 1 0 0 0 ....
%
%    If there is an error, this code should display "patch <patchnum> is
%    problematic" or other messages.  If all is successful, this
%    code displays what files it loaded, the number of patches, and, for
%    each patch, it's location in the sequence and if there's any problem
%    with the actual bits on that patch.  "ndiff" in the output is the
%    number of bits that are wrong in the patch data.
%
% Example:
%
%     makeseg(15,1711,1:72);  % create segments
%     validatemseq(15,1711);    % validate it
%
% See also MAKESEG.
%
function [patchloc, mseq] = validatemseq(order,seed)
%order = 16; seed = 873;

framerate = 60; % frames per second
displayFrameRate = framerate;
framePerStates = 1;
slicesize = 60; % number of seconds per slice
framesperslice = framerate * slicesize;
adapttime = 1;  % adaptation time in seconds
adaptframes = adapttime * framerate;
forwardLength = adaptframes;

seq = genmseq(order, seed, 1);
nseg = ceil(length(seq)/framesperslice);

marker = 1;
for i=1:nseg
    filename = [num2str(order) '_' num2str(seed) '/seg' num2str(order) '_' num2str(seed) '_' sprintf('%.02d', i) '.mat'];
    load(filename);
    disp(['loading ' filename]);
    [r c] = size(seg);
    c = c - forwardLength - 2;
    mseq(:,marker:(marker+c-1))=seg(:,(forwardLength+1):(forwardLength+c));
    marker = marker+c;
end

origcorrectseq = genmseq(order, seed, 1);
correctseq = [origcorrectseq origcorrectseq(1:order)];

[r c] = size(mseq);
if (c ~= ((2^(order)) - 1))
    disp(sprintf('it seems there are only %d elements in the sequence?', c));
    return;
end

disp(sprintf('number of patches = %d', r));

%valuesold = [47 48; 49 50; 51 52; 83 84; 85 86; 87 88; 119 120; 121 122; 123 124; 141 142; 139 140; 137 138; 105 106; 103 104; 101 102; 69 70; 67 68; 65 66];
%values = valuesold(:,2)/2;
values = 1:r;
for k=1:length(values)
    j = values(k);
%1:r
    tosearch = double(mseq(j,1:order));
    patchloc(j)=-1;
    for i=1:(length(correctseq)-order-1)
        tocompare = double(correctseq(i:(i+order-1)));
        difference = tosearch - tocompare;
        if (length(find(difference ~= 0)) == 0)
%           disp(num2str(tosearch));
%           disp(num2str(tocompare));
           patchloc(j) = i;
           break;
        end
    end
    if (patchloc(j) == -1)
        disp(sprintf('patch %d is problematic', j));
    else
        temp = rotatevector(origcorrectseq, (patchloc(j)-1));
        difference = double(temp) - double(mseq(j,:));
        ndiff = length(find(difference ~= 0));
        disp(sprintf('patch = %d location = %d ndiff = %d', j, i, ndiff));
    end
end
