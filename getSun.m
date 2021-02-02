function sun = getSun(t,LAT,LON,UTC)



%%%%%%%%%%%%%%%%OBTENER COORDENADAS (xs,ys) del SOL%%%%%%%%%%%%%%%%%%%%%%%%

%COORDENADAS OBS.
location.longitude = -(LON(1)+LON(2)/60+LON(3)/3600);
location.latitude = -(LAT(1)+LAT(2)/60+LAT(3)/3600);
location.altitude = 0;
%TIEMPO
time.year = t(1);
time.month = t(2); 
time.day = t(3);
time.hour = t(4);
time.min = t(5);
time.sec = t(6);
time.UTC = UTC;
%SOL
sun = sun_position(time,location);
    