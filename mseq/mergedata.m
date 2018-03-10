% MERGEDATA	Merges segments of the m-sequence into one
%
%
%   function mergedseq = mergedata(data);

close all;
START_STOP_CHANNEL = 2;
DATA_CHANNEL = 4;


samplingrate = 1000;
% let's do all the calculations
nbit=15;                % bit length of m-sequence
mlength=2^nbit-1;       % length of m-sequence
npatch=64;               % Number of patch
delay=2^nbit/npatch;    % delay between patches 
framePerStates=1;       % frames per m-sequence states
displayFrameRate=60;    % Hz
statesPerMin=displayFrameRate/framePerStates*60;
nSeg=ceil(mlength/statesPerMin);
forwardLength=60;       % Prerun length in m-sequence states unit
segLength=ceil(mlength/nSeg);

% find the indices for the start and stop signal
ITHRESHOLD = 1000;
I = find(diff(data(:,START_STOP_CHANNEL))>1000);

i = 0;
nframesperseg = segLength + forwardLength;

samplespersegment = floor(nframesperseg * samplingrate / displayFrameRate);
for i=1:(length(I)/2 - 1)
   % loop through all segments
   seg_data(1:(samplespersegment),i) = data(I(2*i-1):(I(2*i-1)+samplespersegment-1),DATA_CHANNEL);
   seg_data2(1:(samplespersegment),i) = data(I(2*i-1):(I(2*i-1)+samplespersegment-1),1);
   
end

lastSegLength = mlength - ((nSeg-1) * segLength) + forwardLength;
samplespersegment = floor(lastSegLength * samplingrate / displayFrameRate);
seg_data(1:(samplespersegment),length(I)/2) = data(I(length(I)-1):(I(length(I)-1)+samplespersegment-1),DATA_CHANNEL);
seg_data2(1:(samplespersegment),length(I)/2) = data(I(length(I)-1):(I(length(I)-1)+samplespersegment-1),1);
   
% now for the actual merging

% the last sequence segment is SPECIAL!! ooooo...
samplesperframe = ceil(samplingrate/displayFrameRate);
newlength = ceil(samplingrate/displayFrameRate)*nframesperseg;
samplesperseg = segLength * ceil(samplingrate/displayFrameRate);
forwardsamplesperseq = forwardLength * ceil(samplingrate/displayFrameRate);
k = 1;
npeaks = 0;

%   temp = simpleresample(seg_data(:,1), newlength);
%   mergedseq(k:(k+samplesperseg))=temp(1:(samplesperseg+1));
%   peaks = detectpeaks(mergedseq(k:(k+samplesperseg)));%seg_data(:,i));
%   k = k + samplesperseg;
%   pa(1) = length(peaks);
%   npeaks = npeaks + length(peaks);
%   disp(num2str(length(peaks)));
for i=1:((length(I)/2)-1)
   % resample data
   temp = simpleresample(seg_data(:,i), newlength);
%   figure;
%   plot(temp(1:(17*16))); %seg_data(1:(17*16),i));
   mergedseq(k:(k+samplesperseg))=temp(forwardsamplesperseq:newlength);
   peaks = detectpeaks(mergedseq(k:(k+samplesperseg)));%seg_data(:,i));
   k = k + samplesperseg;
   pa(i) = length(peaks);
   npeaks = npeaks + length(peaks);
   disp(['segment ' num2str(i) ' has ' num2str(length(peaks)) ' frames']);
end

% now for the last one...
lastSegLength = mlength - ((nSeg-1) * segLength);
nframesperseg = lastSegLength + forwardLength;
newlength = ceil(samplingrate/displayFrameRate)*nframesperseg;
samplesperseg = lastSegLength * ceil(samplingrate/displayFrameRate);
forwardsamplesperseq = forwardLength * ceil(samplingrate/displayFrameRate);

temp = simpleresample(seg_data(:,length(I)/2), newlength);
mergedseq(k:(k+samplesperseg-1))=temp(forwardsamplesperseq:(newlength-1));
peaks = detectpeaks(mergedseq(k:(k+samplesperseg-1)));%seg_data(:,length(I)/2));
k = k + samplesperseg;
npeaks = npeaks + length(peaks);
pa(length(I)/2) = length(peaks);
length(mergedseq);
disp(['segment ' num2str(length(I)/2) ' has ' num2str(length(peaks)) ' frames']);
%disp(num2str(length(peaks)));
disp(['total of ' num2str(npeaks) ' frames']);

