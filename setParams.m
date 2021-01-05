function setParams(thr,nThr,GPS,elSol,resolucion,stationID,thrNubes,thrFN,IP,usr,pwd,stationSTR,stationUT)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fid = fopen('params.txt','w');
fprintf(fid,'%s\n','%Umbral brillo, detección de bólidos');
fprintf(fid,'%s\n','%Número pixeles, detección de bólidos');
fprintf(fid,'%s\n','%Puerto COM de receptor GPS');
fprintf(fid,'%s\n','%Elevación solar máxima');
fprintf(fid,'%s\n','%Resolución frames, alto');
fprintf(fid,'%s\n','%Resolución frames, ancho');
fprintf(fid,'%s\n','%ID de estación, número');
fprintf(fid,'%s\n','%Umbral detección nubes');
fprintf(fid,'%s\n','%Fracción de nubosidad máxima');
fprintf(fid,'%s\n','%Host IP');
fprintf(fid,'%s\n','%Usr');
fprintf(fid,'%s\n','%Pwd');
fprintf(fid,'%s\n','%Nombre de estación');
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
