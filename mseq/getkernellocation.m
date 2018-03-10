% GETKERNELLOCATION     Gets the location of a kernel in an m-sequence
%
%      LOCATION = GETKERNELLOCATION(ORDER, SEED, KERNELDESC) returns the
%      location of the kernel described by KERNELDESC for m-sequence
%      described by ORDER and SEED.  KERNELDESC is an array of t's ([t1 t2
%      ... tn]) such that the kernel is described by
%      x(t-t1)x(t-t2)...x(t-tn).  If x(t) is an m-sequence of order ORDER
%      and seed SEED, then LOCATION is such that,
%      x(t-LOCATION)=x(t-t1)x(t-t2)...x(t-tn) where [t1 ... tn] =
%      KERNELDESC.
%
% EXAMPLE:
%
%     location = getkernellocation(8,29,[0 1]); % first off-diagional slice
%                                               % of 2nd order kernel
%
% REVISION HISTORY
% Thang     1/20/2004   Finished.   Not yet throughly tested.