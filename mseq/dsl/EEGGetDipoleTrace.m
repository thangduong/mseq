% EEGGETDIPOLETRACE   Gets the EEG dipole temporal trace given dipole location and moment and recorded data
%
%   EEGGETDIPOLETRACE(DATA, RQ, Q, [SIGMA], [LAMBDA], [MU])
%
function [mavg, tavg, err] = EEGGetDipoleTrace(data, rq, q, sigma, lambda, mu)

% let's get m and t per sensor and just average them for now!
% TODO: fix this.  clearly better ways can be used

r=data.sensorloc(1,:);
if (nargin == 7)
    v(1) = EEGForward(r, rq, q, sigma, lambda, mu);
else
    v(1) = EEGForward(r, rq, q);
end

tavg = data.data(1,:)/v(1);
mavg = norm(tavg);
tavg = tavg / mavg;

for i=2:data.nsensors
    r=data.sensorloc(i,:);
    if (nargin == 7)
        v(i) = EEGForward(r, rq, q, sigma, lambda, mu);
    else
        v(i) = EEGForward(r, rq, q);        
    end
    t = data.data(i,:)/v(i);
    m = norm(t);
    t = t / m;

    mavg = mavg + m;
    tavg = tavg + t;
end

mavg = mavg / data.nsensors;
tavg = tavg / data.nsensors;

err = 0;
for i=1:data.nsensors
    err = err + sum(data.data(i,:) - v(i) * mavg * tavg);
end
