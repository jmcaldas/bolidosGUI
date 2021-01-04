%%pruebaGPS
clear all
clc
resto=zeros(1,1000);
mjdn=zeros(1,1000);
id=floor(mjdn/100);
for i=1:1000
    try
        [t00,~,~]=gpsRead(sGPS); % UT
    catch err
        t00=now; %CPU time
        t00=t00+3/24; %to UT
        t00=datevec(t00);
    end
    mjdn(i)=floor(juliandate(datetime(t00)));
    id(i)=floor(mjdn(i)/100);
    resto(i)=rem(mjdn(i),100);
end

plot(resto);