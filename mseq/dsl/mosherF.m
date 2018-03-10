% MOSHERF	Function F defined in Mosher, Leahy, and Lewis's paper used to simply expressions
%
%   F = MOSHERF(R,RQ) calculates the function F defined in 
%
%       Mosher, Leahy, and Lewis.  "Matrix Kernels for the Forward Problem in EEG and MEG". 
%       LA-UR-97-3812
%
%   as
%
%       F(R,RQ) = ||r - rq|| (||r|| ||r - rq|| + ||r||^2 - dot(rq,r));
%
%   That is use to simplify the analytic forward equation (EEGKERNEL).  This function is used
%   in EEGKERNEL and nowhere else.  R = location of the electrode, RQ = location of the dipole.
%
% See also EEGKERNEL.
%
function F = mosherF(r,rq)

% here is the definition again:
% F(R,RQ) = ||r - rq|| (||r|| ||r - rq|| + ||r||^2 - dot(rq,r));
d = r - rq;
nd = norm(d);
nr = norm(r);
F = nd*(nr*nd + nr*nr - dot(rq,r));


