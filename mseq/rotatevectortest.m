% ROTATEVECTORTEST  Tests ROTATEVECTOR
%
v = slowseqp(16,45);
q = -2 * double(bitget(v,1)) + 1;
m = fastm(16,45,[1 rotatevector(q(1:(length(q)-1)),1000)]); plot(m);