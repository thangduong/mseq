function EEGAnimateData(data);

for i=1:data.ntimepoints
    scatter3(data.sensorloc(:,1),data.sensorloc(:,2),data.sensorloc(:,3),10,data.data(:,i), 'filled');
end
