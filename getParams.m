function [thr,nThr,GPS,elSol,resolucion,stationID,thrNubes,thrFN,IP,usr,pass,stationSTR] = getParams()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fid = fopen([pwd() '\params.txt']);
C = textscan(fid, '%s','Headerlines',13);
fclose(fid);
A=C{1};

thr=str2double(A(1));
nThr=str2double(A(2));
GPS=str2double(A(3));
elSol=str2double(A(4));
resolucion=[str2double(A(5)) str2double(A(6))];
stationID=str2double(A(7));
thrNubes=str2double(A(8));
thrFN=str2double(A(9));
IP=A(10);IP=IP{1};
usr=A(11);usr=usr{1};
pass=A(12);pass=pass{1};
stationSTR=A(13);stationSTR=stationSTR{1};
end

