% EEGFORWARD	EEGForward equation for single or multi-shell
%
%  V=EEGFORWARD(R, RQ, Q, [SIGMA], [LAMBDA], [MU]) computes the eeg forward
%  solution using either the single-shell model or berg-scherd's
%  multi-shell approximation.  Parameters are:
%      R = location of the sensor
%      RQ = location of the dipole
%      Q = moment of the dipole
%     [SIGMA] = [default to 1]
%     [LAMBDA] = berg-scherd lambda parameters
%     [MU] = berg-scherd mu parameters
%  If lambda and mu are given (as vectors), then the berg-scherd
%  approximation is used;  otherwise, single-shell model is assumed.
%  Lambda and mu are arrays.  The number of elements in lambda and mu must
%  be equal and equal to the number of shells.
%
% See also EEGKERNEL.
%
function v = EEGForward(r, rq, q, sigma, lambda, mu)	

% just dot the kernel with q.
if (nargin < 4)
   v = dot(EEGKernel(r,rq), q);   
else 
   if (nargin < 6)
      v = dot(EEGKernel(r,rq,sigma), q);
	else
   	v = dot(EEGKernel(r,rq,sigma,lambda,mu), q);
   end
end
