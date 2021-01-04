clear all
clc

sGPS=serial('COM4');
set(sGPS,'BaudRate',4800);
fopen(sARD);
str = fscanf(sARD);
fclose(sARD);
C = strsplit(str,',');