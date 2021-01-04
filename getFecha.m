function time = getFecha(nombreArchivo,TimeZone)

% time.year = str2double(strcat('20',nombreArchivo(9:10)));
% time.month = str2double(nombreArchivo(12:13));
% time.day = str2double(nombreArchivo(15:16));
% time.hour = str2double(nombreArchivo(18:19));
% time.min = str2double(nombreArchivo(21:22));
% time.sec = str2double(nombreArchivo(24:25));
% time.UTC = TimeZone;

%Formato: 2015-05-03-12-00-00.jpg

t = datevec(nombreArchivo(1:end-4),'yyyy-mm-dd-HH-MM-SS');
time.year = t(1);
time.month = t(2);
time.day = t(3);
time.hour = t(4);
time.min = t(5);
time.sec = t(6);
time.UTC = TimeZone;
