function [UT,LAT,LON]=gpsRead(sGPS)

HLU=datevec(now);

fopen(sGPS);
str = fscanf(sGPS);
C = strsplit(str,',');
count=1;

while ~strcmp(C{1},'$GPRMC') && ~strcmp(C{1},'$GPGGA') && count<10 
    str = fscanf(sGPS);
    C = strsplit(str,',');  
    count=count+1;
end

hora=C{2};
UT=HLU;
UT(4)=floor(str2double(hora(1:2)));
UT(5)=floor(str2double(hora(3:4)));
UT(6)=floor(str2double(hora(5:6)));

if datenum(UT)-datenum(HLU)<0
   UT=datevec(datenum(UT)+1);
end
lat=str2double(C{4})/100;
LAT=degrees2dms(lat);
lon=str2double(C{6})/100;
LON=degrees2dms(lon);

fclose(sGPS);

