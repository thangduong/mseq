% PREWALSHPERM	This function is to supplement m-transform by doing a permutation
%
%    WALSHDATA = PREWALSHPERM(ORDER, SEED, MDATA, [LUT]) performs the permutation
%    to the set of data.  This permutation corresponds with the permutation that
%    would be done prior to the walsh transform to get an m-transform.  Recall
%    that an m transform kernel M is equivalent to P2 * W * P1 where W is the walsh
%    transform and P1 and P2 are permutation matrices.  This function is equivalent
%    to applying the matrix P1 to the set of data specified by MDATA.  The parameters
%    are as follows:
%       ORDER = order of the sequence 
%       SEED  = seed of the m transform (or sequence used as stimulus)
%       MDATA = data collected (MUST be of length k * 2^order for integer k)
%       [LUT] = optional look up table returned by CREATECPLUT.  PREWALSHPERM
%               runs a little slower if this is not given because it
%               has to generate this table.
%    return value WALSHDATA can then be passed to FASTWALSH and POSTWALSHPERM
%    to get the m-transform of MDATA.
%
%    EXAMPLE:
%      lut = createbcplut(3);
%      data = prewalshperm(3, 3, data, lut);
%      data = fastwalsh(3, data);
%      data = postwalshperm(3, 3, data);
%      % here data is the m-transform of the initial 
%      % data array for m sequence seed 3 of order 3.
%  
% See also CREATEBCPLUT, POSTWALSHPERM, FASTWALSH.
%

