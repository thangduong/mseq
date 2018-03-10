% MAKESEG   Makes m-sequence segments for use by stimulator
%
%   MAKESEG(ORDER, SEED, PATCHES) makes m-sequence segments and stores it
%   on the directory ORDER_SEED.  PATCHES gives the ID of the patches.
%
% Example:
%
%   makeseg(15,1711,1:72)  % make 15-bit mseq seed 1711 for 72 patch stim
%
% See also GENMSEQ
%
% REVISION HISTORY
%   Thang          12/04/2003          - Fixed a minor bug (forgot to index an array; ok, it's not so minor)
%                                                   - Added 2 extra frames at the end
%                                                   - Made the last slice smaller (instead of padding with 0s)
%   Thang          12/18/2003          - Copied make99mseq to this file.
%                                                       modified for big mseq -- big stimulus
%
%   Thang          1/30/2003           - Renamed this from make_big_mseq to
%                                                        makeseg
function makeseg(order, seed, values)
%order = 16;
%seed = 50615;
%seed = 873;
%order=15;seed=1711;
%order=16;seed=50615;
%valuesold = [
    %47 48; 49 50; 51 52; 83 84; 85 86; 87 88; 119 120; 121 122; 123 124; 141 142; 139 140; 137 138; 105 106; 103 104; 101 102; 69 70; 67 68; 65 66];
%values = valuesold(:,2)/2;
%values = 1:72;
NPATCHES = length(values);
%216/2;
npatch = NPATCHES;
nvalidpatches = length(values);
%values = [47 48; 49 50; 51 52; 83 84; 85 86; 87 88; 119 120; 121 122; 123 124; 141 142; 139 140; 137 138; 105 106; 103 104; 101 102; 69 70; 67 68; 65 66];

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

segall = zeros(NPATCHES, framesperslice+adaptframes,nseg);
rotatelen = floor(length(seq)/length(values));

disp(['seq len = ' num2str(length(seq)) ' npatch = ' num2str(npatch) ' number of displacements = ' num2str(rotatelen)]);
r = length(values);
    for j=1:r
        [slices sliceseqlen lastlength] = sliceseq(seq, framesperslice, adaptframes);
        seq = rotatevector(seq, rotatelen);
        for i=1:nseg
            segall(values(j),:,i) = slices(i,:);
        end
 %	disp(['last length = ' num2str(lastlength)]);
 %       seg(values(j, 2),:) = not(slices(j,:));
    end

% save the output segments into segment files so WinVis can read it
mkdir([num2str(order) '_' num2str(seed)]);
[a b c] = size(segall);

for i=1:c-1
    seg = reshape(segall(:,:,i), [a b]);

    % pad 2 frames to seg
    [sr sc] = size(seg);
    seg(:,(sc+1):(sc+2)) = 0;
    filename = [num2str(order) '_' num2str(seed) '/seg' num2str(order) '_' num2str(seed) '_' sprintf('%.02d', i) '.mat'];
    save(filename, 'seg', 'npatch', 'displayFrameRate', 'framePerStates', 'forwardLength');
    disp(sprintf('wrote segment %d', i));
end

% save the last segment
i=c;
seg = reshape(segall(:,1:lastlength,i), [a lastlength]);
[sr sc] = size(seg);
seg(:,(sc+1):(sc+2)) = 0;
filename = [num2str(order) '_' num2str(seed) '/seg' num2str(order) '_' num2str(seed) '_' sprintf('%.02d', i) '.mat'];
save(filename, 'seg', 'npatch', 'displayFrameRate', 'framePerStates', 'forwardLength');

disp(sprintf('wrote segment %d', i));
disp(sprintf('npatches = %d nsegs = %d framesperslice = %d', NPATCHES, nseg, framesperslice));
disp(sprintf(' seglength = %d lastlength = %d', sliceseqlen, lastlength));
