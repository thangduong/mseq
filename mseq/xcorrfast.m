% XCORRFAST     Fast circular cross correlation using fastm
%   K = XCORRFAST(ORDER, S1, S2)
%
function k = xcorrfast(order, s1, s2);

seq1 = genmseq(order, s1, 2);
k = fastm(order, s2, [0 seq1]);
k = k(2:length(k));
