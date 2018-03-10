% GENKERNELSET  Generates a bunch of random test kernels
%
%   Y = GENKERNELSET(X, N) generates N kernels with X as the x-axis vector.
%   The results are stored in Y as Y(j,:), so, for example, the first
%   kernel would be at Y(1,:).
%
function y = genkernelset(x, N);

if (nargin < 2)
    help genkernelset;
    return;
end

% just call makekernel with random parameters
for i=1:N
    y(i,:) = makekernel(x,12+2*rand(1,1),4+3*rand(1,1),5+4*rand(1,1),1);
end
