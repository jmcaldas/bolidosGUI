function setParams(thr,nThr,GPS,elSol,resolucion,stationID,thrNubes,thrFN,IP,usr,pwd,stationSTR,stationUT)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fid = fopen('params.txt','w');
fprintf(fid,'%s\n','%Umbral brillo, detecci�n de b�lidos');
fprintf(fid,'%s\n','%N�mero pixeles, detecci�n de b�lidos');
fprintf(fid,'%s\n','%Puerto COM de receptor GPS');
fprintf(fid,'%s\n','%Elevaci�n solar m�xima');
fprintf(fid,'%s\n','%Resoluci�n frames, alto');
fprintf(fid,'%s\n','%Resoluci�n frames, ancho');
fprintf(fid,'%s\n','%ID de estaci�n, n�mero');
fprintf(fid,'%s\n','%Umbral detecci�n nubes');
fprintf(fid,'%s\n','%Fracci�n de nubosidad m�xima');
fprintf(fid,'%s\n','%Host IP');
fprintf(fid,'%s\n','%Usr');
fprintf(fid,'%s\n','%Pwd');
fprintf(fid,'%s\n','%Nombre de estaci�n');
fprintf(fid,'%s\n','%UT');

fprintf(fid,'%0.0f\n',thr);
fprintf(fid,'%0.0f\n',nThr);
fprintf(fid,'%0.0f\n',GPS);
fprintf(fid,'%0.0f\n',elSol);
fprintf(fid,'%0.0f\n',resolucion(1));
fprintf(fid,'%0.0f\n',resolucion(2));
fprintf(fid,'%0.0f\n',stationID);
fprintf(fid,'%0.0f\n',thrNubes);
fprintf(fid,'%.1f\n',thrFN);
fprintf(fid,'%s\n',IP);
fprintf(fid,'%s\n',usr);
fprintf(fid,'%s\n',pwd);
fprintf(fid,'%s\n',stationSTR);
fprintf(fid,'%0.0f',stationUT);
fclose(fid);

end
