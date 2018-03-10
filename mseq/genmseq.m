% GENMSEQ   Generate an m-sequence
%
%   [MSEQ1 {MSEQ2}] = GENMSEQ(ORDER, SEED, [OPTION], [REPEAT]) Generates an m-sequence
%   and return one of the following, depending on the OPTION:
%       OPTION = 0:  MSEQ1 is the generating register output, MSEQ2 is the
%       tap register output.
%       OPTION = 1:  MSEQ1 is an array of m-sequence bits.  MSEQ2 is not
%       used.
%       OPTION = 2:  MSEQ1 is an array of m-sequence values where bit 1
%       gets mapped to -1, and bit 0 gets mapped to 1.  MSEQ2 is not used.
%    REPEAT specifies how many times a single element in the m-sequence
%    gets repeated.  It defaults to 1. 
%
% Example:
%    genmseq(3,3,1,2)
%           gives 1 1 0 0 0 0 1 1 0 0 1 1 1 1
%
% REVISION HISTORY
%
