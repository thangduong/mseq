% MAKEMSEQ  Old make m-sequence code
%
% See MAKE99MSEQ for more info!
%
function makemseq(order, seed, framerate);
%order = 16;
%seed = 45;

if (exist('framerate') == 0)
	framerate = 60;
end

if (exist('framesperstate') == 0)
   framesperstate = 1;
end

if (exist('npatch') == 0)
   npatch = 64;
end

secperseg = 60;                                % number of seconds per segment (not including adaptation)
adaptationtime = 1;									  % number of seconds for adaptation
seqlength = (2^order) - 1;
spacing = floor(seqlength / npatch);

mseq = uint8(bitget(slowseqp(order,seed),1));

newstatesperseg = floor(secperseg * framerate / framesperstate);
numadaptationstates = floor(adaptationtime * framerate / framesperstate);
statesperseg = newstatesperseg + numadaptationstates

nseg = ceil(seqlength / newstatesperseg);

% these variables are needed for the file!
framePerState = framesperstate;
forwardLength = numadaptationstates;
displayFrameRate = framerate;
delay = spacing;
% npatch as well!


for i=1:(nseg-1)
   for p=1:npatch
      start = (i-1) * newstatesperseg + p * spacing - numadaptationstates;
      stop = start + statesperseg - 1;
      seg(p,1:statesperseg) = mseq(mod((start:stop), seqlength)+1);
   end
   fname = sprintf('seg%d_%d_%.02d.mat', order, seed, i);
   save(fname, 'framePerState', 'forwardLength', 'displayFrameRate', 'delay', 'npatch', 'seg');
   disp(['seg ' num2str(i) ' done']);
end

clear seg;
newstatesperseg = seqlength - (nseg-1)*newstatesperseg;
for p=1:npatch
   start = (nseg-1) * newstatesperseg + p * spacing - numadaptationstates;
   stop = start + newstatesperseg + numadaptationstates - 1;
   seg(p,1:(newstatesperseg + numadaptationstates)) = mseq(mod((start:stop), seqlength)+1);
end 
fname = sprintf('seg%d_%d_%.02d.mat', order, seed, nseg-1);
save(fname, 'framePerState', 'forwardLength', 'displayFrameRate', 'delay', 'npatch', 'seg');
