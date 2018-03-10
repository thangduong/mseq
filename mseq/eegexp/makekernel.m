% MAKEKERNEL    Make a fake kernel that looks cool (not very useful though)
%
%   Y = MAKEKERNEL(X, MU, SIGMA, PHASE, AMP) makes a kernel of the form
%
%       Y = NOFMPDF(X,MU, SIGMA) .* SIN(X+PHASE) * AMP

function y = makekernel(x, mu, sigma, phase, amp)


y = normpdf(x,mu,sigma) .* sin(x+phase)*amp;
%y = y .* [ones(1,(length(y)/2)) zeros(1,(length(y)/2))];

