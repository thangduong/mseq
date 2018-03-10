function merged = mergemultfiles(files)

START_STOP_CHANNEL = 1;
ITHRESHOLD = 700;              % threshold for detecting start-stop signal
DATA_CHANNELS = [5 6 7];
samplingrate = 1000;
% let's do all the calculations
nbit=16;                % bit length of m-sequence
mlength=2^nbit-1;       % length of m-sequence
npatch=9;               % Number of patch
delay=2^nbit/npatch;    % delay between patches 
framePerStates=1;       % frames per m-sequence states
displayFrameRate=60;    % Hz    
statesPerMin=displayFrameRate/framePerStates*60;
forwardLength=60;       % Prerun length in m-sequence states unit
segLength=statesPerMin;

nframesperseg = segLength + forwardLength;

samplespersegment = floor(nframesperseg * samplingrate / displayFrameRate);


nfiles = size(files,1);

minl = -1;
maxl = -1;
for i=1:nfiles
    file = deblank(files(i,:));
    disp(['working on file: ' file]);
    load(file);
    I = find(diff(data(:,START_STOP_CHANNEL))>ITHRESHOLD);
    segsize = I(2)-I(1);
    if (minl < 0)
        minl = segsize;
    else
        minl = min(minl, segsize);
    end
    if (maxl < 0)
        maxl = segsize+1;
    end
    seg_data(i,1:maxl,1:length(DATA_CHANNELS)) = data(I(1):(I(1)+maxl-1),DATA_CHANNELS);
end


lastsize = 65535-60*60*18;
discardlen = 1000;

marker = 1;
disp(['putting everything into one big segment']);
for i=1:(nfiles-1)
    merged(marker:(marker+minl-discardlen),1:length(DATA_CHANNELS)) = squeeze(seg_data(i,discardlen:minl,1:length(DATA_CHANNELS)));
    marker = marker+minl-discardlen+1;
end
merged(marker:(marker+lastsize),1:length(DATA_CHANNELS)) = squeeze(seg_data(nfiles,discardlen:(discardlen+lastsize),1:length(DATA_CHANNELS)));
