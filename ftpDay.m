function ftpDay(f,directorio)

% function ftpDay:
% Ultima revision: 30/07/2020, M. Caldas (mcaldas@fisica.edu.uy)
% Copia todos los archivos de directorio local
% 'Events/stationId/jjjjj/dd, donde jjjjjdd es una fecha juliana, a una 
% ubicación idéntica en servidor FTP especificado en objeto FTP "f" 

%% Crear en servidor FTP carpeta /Events/stationId/jjjjj/dd
mkdir(f,'Events');
cd(f,'Events');
indices=find(directorio=='/');
mkdir(f,directorio(indices(1)+1:indices(2)-1));
cd(f,directorio(indices(1)+1:indices(2)-1));
mkdir(f,directorio(indices(2)+1:indices(3)-1));
cd(f,directorio(indices(2)+1:indices(3)-1));
mkdir(f,directorio(indices(3)+1:end));

%% Acceder a carpeta /Events/stationId/jjjjj/dd
cd(f,directorio(indices(3)+1:end));

%% Entrar en modo pasivo
sf=struct(f); sf.jobject.enterLocalPassiveMode();

%% Obtener listado de archivos AVI,TXT,MAT
listingAVI=dir(strcat(directorio,'/*.avi'));
listingTXT=dir(strcat(directorio,'/*.txt'));
listingMAT=dir(strcat(directorio,'/*.mat'));

%% Subir todos los AVI. 
% Renombrar archivo subido "xxx" en carpeta local a "xxx_F"
for i=1:length(listingAVI)
    archivo=listingAVI(i).name;
    if ~strcmp(archivo(max(end-4,1)),'F')
        try
            mput(f,strcat(directorio,'/',strcat(archivo)));
            flagFTP=1;
        catch err
            flagFTP=0;
        end
        if flagFTP
            [~,~,~] = movefile(strcat(directorio,'/',archivo),strcat(directorio,'/',archivo(1:end-4),'_F',archivo(end-3:end)),'f');
        end
    end
end
%% Subir todos los TXT. 
% Renombrar archivo subido "xxx" en carpeta local a "xxx_F"
for i=1:length(listingTXT)
    archivo=listingTXT(i).name;
     if ~strcmp(archivo(max(end-4,1)),'F')
        try
            mput(f,strcat(directorio,'/',strcat(archivo)));
            flagFTP=1;
        catch err
            flagFTP=0;
        end
        if flagFTP
            [~,~,~] = movefile(strcat(directorio,'/',archivo),strcat(directorio,'/',archivo(1:end-4),'_F',archivo(end-3:end)),'f');
        end
    end
end
%% Subir todos los MAT. 
% Renombrar archivo subido "xxx" en carpeta local a "xxx_F"
for i=1:length(listingMAT)
    archivo=listingMAT(i).name;
     if ~strcmp(archivo(max(end-4,1)),'F')
        try
            mput(f,strcat(directorio,'/',strcat(archivo)));
            flagFTP=1;
        catch err
            flagFTP=0;
        end
        if flagFTP
            [~,~,~] = movefile(strcat(directorio,'/',archivo),strcat(directorio,'/',archivo(1:end-4),'_F',archivo(end-3:end)),'f');
        end
    end
end
close(f);

end

