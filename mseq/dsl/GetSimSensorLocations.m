% GETSIMSENSORLOCATIONS Get sensor locations for simulation in cartesian coordinates
%
%   GETSIMSENSORLOCATIONS(R, THETA0, THETAF, PHI0, PHIF, N) gets sensor
%   locations at spherical coordinates from THETA0 to THETAF and from PHI0
%   to PHIF where each dimension gets N steps.  Radius is given by R.
%   Default R=1, THETA0=0, THETAF=2*pi, PHI0=0, PHIF=2*pi, N=15.  Return
%   value is a bunch of coordinates in cartesian coordinates.
%
function sensorloc = GetSimSensorLocations(r, theta0, thetaf, phi0, phif, N);

% Set variables to default if they're not defined
if (exist('R') == 0)
    r = 1;
end
if (exist('theta0') == 0)
    theta0 = 0;
end
if (exist('thetaf') == 0)
    thetaf = 2*pi;
end
if (exist('phi0') == 0)
    phi0 = 0;
end
if (exist('phif') == 0)
    phif = 2*pi;
end
if (exist('N') == 0)
    N = 15;
end

% create the sampling coordinates
theta = linspace(theta0,thetaf,N);
theta = theta(1:length(theta)-1);
phi = linspace(phi0,phif,N);
phi = phi(1:length(phi)-1);

% convert to (x,y,z)
index = 1;
for i=1:length(phi)
    for j=1:length(phi)
        sensorloc(index,:) = [r*cos(theta(i))*cos(phi(j)) r*sin(theta(i))*cos(phi(j)) r*sin(phi(j))];
        index = index+1;
    end
end
