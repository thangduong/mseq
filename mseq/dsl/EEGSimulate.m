function data =  EEGSimulate(rq, q, time, sensors)

[M N] = size(sensors);
data = struct('nsensors', M, 'ntimepoints', length(time), 'sensorloc', sensors, 'data', []);
for i=1:M
    data.data(i,:)=EEGForward(sensors(i,:),rq,q)*time;
end