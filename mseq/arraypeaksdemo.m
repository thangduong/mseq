% ARRAYPEAKSDEMO	Cool little animation of the detection of peaks of the signal
%              recorded from the photodiode.
%
%   ARRAYPEAKSDEMO(DATA, ax, [SLEEPTIME]) is just a cool little useless animation 
%   of the signal recorded from the photodiode with detected peaks from 
%   DETECTPEAKS.  FILENAME is the name of the file containing the data.
%   The trace from the phodiode must by channel for and the variable
%   stored in the .mat file specified by FILENAME must be called 'data'.
%   SLEEPTIME is the amount of time (in seconds) to sleep between frames.
%   This is default to 0.2.  NOTE: this function calls 'close all', which
%   can be an annoyance.
%   NOTE: this is the same as PEAKSDEMO except that the data is taken from
%   parameter instead of a file.
%
% EXAMPLE:
%   arraypeaksdemo(data(:,4));
%
function peaksdemo(data, ax, sleeptime);

% if sleeptime hasn't been defined, define it to be 0.2
if (nargin < 3)
   sleeptime = .2;
end
if (nargin < 2)
    ax = [];
end

% load the file.  close off crap so it doesn't clutter up our screen.
close all; 
figure;

L = length(data);
for i=1:100:L
   M=i; N=min(i+400,L);
   hold off; 
%   if (length(ax))
%       axis([i/1000 (i+400)/1000 ax]);
%   end
%    hold on;   
   % detect the peaks
   p=detectpeaks(data(M:N)); 
   
   % plot the signal, then plot the peaks on top of the signal
   % in red (diamonds)
   plot((M:N)/1000, data(M:N)); 
   hold on; 
   plot((M+p(:,1))/1000, p(:,2), 'dred'); 
   
   % put some labels on (don't think this needs to be in the
   % loop, but who cares...)
   xlabel('time (sec)');
   ylabel('signal ');
   title('Signal with the Peaks Detected');
   
   
   pause(sleeptime); 
end 