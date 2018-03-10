% NMPOSTWALSHPERM	This function is to supplement m-transform by doing a permutation
%
%    WALSHDATA = NMPOSTWALSHPERM(ORDER, SEED, MDATA) performs the permutation
%    to the set of data.  This permutation corresponds with the permutation that
%    would be done after the walsh transform to get an m-transform.  Recall
%    that an m transform kernel M is equivalent to P2 * W * P1 where W is the walsh
%    transform and P1 and P2 are permutation matrices.  This function is equivalent
%    to applying the matrix P2 to the set of data specified by MDATA.  The parameters
%    are as follows:
%       ORDER = order of the sequence 
%       SEED  = seed of the m transform (or sequence used as stimulus)
%       MDATA = data collected (MUST be of length k * 2^order for integer k)
%    return value WALSHDATA can then be passed to FASTWALSH and POSTWALSHPERM
%    to get the m-transform of MDATA.
%
%    NOTE: this is similar to POSTWALSHPERM but without the mean element
%
%    EXAMPLE:
%      lut = createbcplut(3);
%      data = nmprewalshperm(3, 3, data, lut);
%      data = nmfastwalsh(3, data);
%      data = nmpostwalshperm(3, 3, data);
%      % here data is the m-transform of the initial 
%      % data array for m sequence seed 3 of order 3.
%  
% See also CREATEBCPLUT, NMPREWALSHPERM, NMFASTWALSH.
%

