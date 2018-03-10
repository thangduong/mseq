% SLOWSEQP	Generates m-sequence using tap-register scheme
%
%   SEQ=SLOWSEQP(ORDER, SEED) generates a sequence of length 2^ORDER
%   with seed SEED (tap-register configuration).  The initial value
%   is always set to 1 for this version.  There may be additional
%   parameters later on to change the initial configuration, but for
%   now, it's 1.
%
% EXAMPLE:
%   seq = slowseqp(16,45);
%
