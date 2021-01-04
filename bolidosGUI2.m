function varargout = bolidosGUI2(varargin)
% BOLIDOSGUI2 MATLAB code for bolidosGUI2.fig
%      BOLIDOSGUI2, by itself, creates a new BOLIDOSGUI2 or raises the existing
%      singleton*.
%
%      H = BOLIDOSGUI2 returns the handle to a new BOLIDOSGUI2 or the handle to
%      the existing singleton*.
%
%      BOLIDOSGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOLIDOSGUI2.M with the given input arguments.
%
%      BOLIDOSGUI2('Property','Value',...) creates a new BOLIDOSGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bolidosGUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bolidosGUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bolidosGUI2

% Last Modified by GUIDE v2.5 10-Apr-2020 17:40:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bolidosGUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @bolidosGUI2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bolidosGUI2 is made visible.
function bolidosGUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bolidosGUI2 (see VARARGIN)
global vid sGPS mascara resolucion 
% Choose default command line output for bolidosGUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bolidosGUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%% Create video object. Read station parameters.
try    
    
    info = imaqhwinfo;
    adaptors = info.InstalledAdaptors;
    set(handles.popupmenu1,'String',adaptors);
    
    str = get(handles.popupmenu1, 'String');
    val = get(handles.popupmenu1,'Value');
    
    h = imaqhwinfo(str{val});
    ids = h.DeviceIDs;
    
    while isempty(ids)
        val=val+1;
        h = imaqhwinfo(str{val});
        ids = h.DeviceIDs;
    end
    
    set(handles.popupmenu1, 'value',val);
    
    for i=1:length(ids)
        s{i}=num2str(ids{i});
    end
    
    set(handles.popupmenu5, 'String',s);
    str2 = get(handles.popupmenu5, 'String');
    val2 = get(handles.popupmenu5,'Value');
        
    h = imaqhwinfo(str{val},str2double(str2{val2}));
    
    formatos = h.SupportedFormats;
    set(handles.popupmenu6, 'String',formatos);    
    str3 = get(handles.popupmenu6, 'String');
    val3 = get(handles.popupmenu6,'Value');
    vid = videoinput(str{val},str2double(str2{val2}),str3{val3});
    
    set(handles.slider1,'Value',round(get(getselectedsource(vid),'Brightness')));
    set(handles.slider2,'Value',round(get(getselectedsource(vid),'Contrast')));
        
    vid.ReturnedColorSpace='grayscale';    
    vid.TriggerFrameDelay=5;             
    
    [thr,nThr,GPS,elSol,resolucion,stationID,thrNubes,thrFN,IP,usr,pass,stationSTR] = getParams();
    
    try
        sGPS=serial(strcat('COM',num2str(GPS,'%0.0f')));
        set(sGPS,'BaudRate',4800);
    catch err
        sGPS=[];
    end
        
    set(handles.edit1,'String',num2str(thr));
    set(handles.edit2,'String',num2str(nThr));
    
    set(handles.edit6,'String',num2str(thrNubes));
    set(handles.edit7,'String',num2str(thrFN));
    
    % FTP
    set(handles.edit8,'String',IP);
    set(handles.edit9,'String',usr);
    set(handles.edit10,'String',pass);
    
    switch elSol
        case -5
            set(handles.popupmenu7,'Value',1);
        case -10
            set(handles.popupmenu7,'Value',2);
        case -15
            set(handles.popupmenu7,'Value',3);
    end
    
    set(handles.popupmenu8,'Value',GPS);      
    
    % Station
    set(handles.popupmenu13,'Value',stationID);
    set(handles.edit12,'String',stationSTR);
    try
        [~,LAT,LON]=gpsRead(sGPS);
        set(handles.edit13,'String',num2str(-dms2degrees(LAT),'%08.4f'));
        set(handles.edit14,'String',num2str(-dms2degrees(LON),'%08.4f'));
    catch err
        set(handles.edit13,'String','-034.0000');
        set(handles.edit14,'String','-056.0000');
    end
    
    % Mask
    try
        m = load([pwd() 'Mask.mat']);
        mascara=m.BW;
    catch err
        mascara=ones(resolucion(1),resolucion(2));
    end   
    
    warning('off');
    
catch err
    disp(err.message)
end

try
    
    A=propinfo(getselectedsource(vid),'AnalogVideoFormat');
    set(handles.popupmenu9,'String',A.ConstraintValue);
    
catch err
end

try
    axes(handles.axes2);
    im=imread('peque.png');
    im=imresize(im,0.5);
    imshow(im);
catch err    
end

% --- Outputs from this function are returned to the command line.
function varargout = bolidosGUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function popupmenu10_Callback(hObject, eventdata, handles)
function popupmenu10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% REC
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid sGPS
try
    stationID = get(handles.popupmenu13,'Value');
    calidadAVI = get(handles.slider3,'Value');
    lista = (get(handles.popupmenu10,'String'));
    index = (get(handles.popupmenu10,'Value'));
    segundos = str2double(lista{index});
    fps = 30;
    set(vid,'FramesPerTrigger',floor(segundos*fps));
    set(handles.text12,'String','Grabando...');
    if strcmp(get(vid,'Previewing'),'on')
        stoppreview(vid);
    end
    freeze(handles,hObject);
    flushdata(vid);
    stop(vid);
    vid.LoggingMode = 'disk';
    try
        [HLU,~,~]=gpsRead(sGPS);
    catch err
        HLU=datevec(now);
    end
        
    directorio=strcat('Calibrations/',num2str(HLU(1)),'/',num2str(HLU(2),'%02.f'),'/',num2str(HLU(3),'%02.f'));
    mkdir(directorio);
    archivo=strcat('Calibration_',num2str(stationID),'_',datestr(HLU,'yyyy-mm-dd-HH-MM-SS'));
    logfile = VideoWriter(strcat(directorio,'/',archivo,'.avi'));
    logfile.Quality = calidadAVI;
    vid.DiskLogger = logfile;    
    start(vid);
    while strcmp(vid.Running,'on')
        pause(0.1);
    end
    stop(vid);
    flushdata(vid);
    vid.LoggingMode = 'memory';
    unfreeze(handles);
    preview(vid);
    set(handles.text12,'String','Listo!');
catch err
    set(handles.text12,'String',strcat('Error:',err.message));
end

%% Brightness slider
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vid
set(getselectedsource(vid),'Brightness',get(hObject,'Value'));
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Contrast slider
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global vid
set(getselectedsource(vid),'Contrast',get(hObject,'Value'));
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Acquisition devices popup menus
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global vid

str = get(handles.popupmenu1, 'String');
val = get(handles.popupmenu1,'Value');

h = imaqhwinfo(str{val});
ids = h.DeviceIDs;

if isempty(ids)
    set(handles.popupmenu5, 'value', 1);
    set(handles.popupmenu5, 'String','N/A');
    set(handles.popupmenu6, 'value', 1);
    set(handles.popupmenu6, 'String','N/A');
    vid = [];
else
    for i=1:length(ids)
        s{i}=num2str(ids{i});
    end
    set(handles.popupmenu5, 'String',s);
    str2 = get(handles.popupmenu5, 'String');
    val2 = get(handles.popupmenu5,'Value');
    h = imaqhwinfo(str{val},str2double(str2{val2}));
    
    formatos = h.SupportedFormats;
    set(handles.popupmenu6, 'String',formatos);
    str3 = get(handles.popupmenu6,'String');
    val3 = get(handles.popupmenu6,'Value');
    vid = videoinput(str{val},str2double(str2{val2}),str3{val3});
end
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Popupmenu for video resolution selection
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid

str = get(handles.popupmenu1, 'String');
val = get(handles.popupmenu1,'Value');
str2 = get(handles.popupmenu5, 'String');
val2 = get(handles.popupmenu5,'Value');
str3 = get(handles.popupmenu6, 'String');
val3 = get(handles.popupmenu6,'Value');
flagP = 0;
if ~strcmp(val2,'N/A')
    try
        if strcmp(get(vid,'Previewing'),'on')
            stoppreview(vid);
            flagP = 1;
        end
        stop(vid);
        delete(vid);
        vid = videoinput(str{val},str2double(str2{val2}),str3{val3});
        set(vid,'ReturnedColorSpace','gray');              
        if flagP
            preview(vid);
        end
    catch err
    end
else
    vid=[];
end
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Popupmenu for video system selection
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global vid
str = get(hObject, 'String');
val = get(hObject,'Value');
try
    s=getselectedsource(vid);
    s.AnalogVideoFormat = str{val};    
catch err
end

%% RUN/STOP button clicked
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid flagStop sGPS mascara resolucion
dummyFlag=1;

%% Get selected max solar elevation
sr=get(handles.popupmenu7,'String');
val=get(handles.popupmenu7,'Value');
sun_el_max=str2double(sr{val});

%% Get current status of app (running or stopped)
status = get(hObject,'String');

if strcmp(status,'RUN')    
    %% User clicked "RUN"
    
    % Get selected parameters
    thr = str2double(get(handles.edit1,'String'));
    nThr = str2double(get(handles.edit2,'String'));
    thrNubes = str2double(get(handles.edit6,'String'));
    thrFN = str2double(get(handles.edit7,'String'));
    GPS = get(handles.popupmenu8,'Value');
    IP = get(handles.edit8,'String');
    usr = get(handles.edit9,'String');
    pass = get(handles.edit10,'String');
    stationSTR = get(handles.edit12,'String');
    stationID = get(handles.popupmenu13,'Value');
    [~,~,~,~,resolucion,~,~,~,~,~,~,~] = getParams();
    
    % Write selected parameters to local file params.txt
    setParams(thr,nThr,GPS,sun_el_max,resolucion,stationID,thrNubes,thrFN,IP,usr,pass,stationSTR);
    
    % Copy params.txt to current date folder
    try
        [t00,~,~]=gpsRead(sGPS); % UT
    catch err
        t00=now; %CPU time
        t00=t00+3/24; %to UT
        t00=datevec(t00);
    end
    mjdn=floor(juliandate(datetime(t00)));
    id=floor(mjdn/100);
    resto=rem(mjdn,100);
    directorio = strcat('Events/',num2str(stationID),'/',num2str(id),'/',num2str(resto,'%02.f'));
    mkdir(directorio);
    copyfile('params.txt',strcat(directorio,'/params_',datestr(t00,'yyyy-mm-dd-HH-MM-SS'),'.txt'),'f');
    
    % Set previewing ON
    try
        if strcmp(get(vid,'Previewing'),'off')
            set(vid,'Timeout',Inf);
            %Preview
            preview(vid);            
        end
        
    catch err
        msgbox('Problemas con el dispositivo de captura.','Error de captura');
        dummyFlag=0;
    end
    
    if dummyFlag
        % Nothing wrong with capture device        
        
        % Read coordinates from GPS
        try
            [~,LAT,LON]=gpsRead(sGPS);
        catch err
            LAT=degrees2dms(-str2double(get(handles.edit13,'String')));
            LON=degrees2dms(-str2double(get(handles.edit14,'String')));
        end
        set(handles.edit13,'String',num2str(-dms2degrees(LAT),'%08.4f'));
        set(handles.edit14,'String',num2str(-dms2degrees(LON),'%08.4f'));
        
        set(hObject,'String','STOP');
        set(hObject,'BackgroundColor','r');
        set(handles.text12,'String','Running...');
        
        % Initialize loop         
        calidadAVI = round(get(handles.slider3,'Value'));        
        flagStop = 1;        
        t=clock;
        sun = getSun(t,LAT,LON);
        freeze(handles,hObject);
        count=0;
        vid.FramesPerTrigger=Inf;
        start(vid);
        
        while flagStop            
            if 90-sun.zenith<sun_el_max
               
               % Get current time, either from GPS or local PC 
               detection=0;
               gpsFlag='1';
               try
                [t00,~,~]=gpsRead(sGPS); % UT
               catch err
                   t00=now; %CPU time
                   t00=t00+3/24; %to UT
                   t00=datevec(t00);
                   gpsFlag='0';
               end
               
               % Create folder based on JD, if necessary.
               mjdn=floor(juliandate(datetime(t00)));
               id=floor(mjdn/100);
               resto=rem(mjdn,100);
               directorio = strcat('Events/',num2str(stationID),'/',num2str(id),'/',num2str(resto,'%02.f'));               
               mkdir(directorio);
               
               % Get two consecutive frames, separated by 0.1 s
               im1=getsnapshot(vid);
               im1=imresize(im1,resolucion);
               im1=im1.*uint8(mascara);
               pause(0.1);
               im2=getsnapshot(vid);
               
               % Estimate cloud fraction
               nNube=length(im1(im1>thrNubes));
               nTotal=length(im1(im1>0));
               FN=nNube/nTotal;
               
               if FN < thrFN
                   % Cloudless night
                   
                   % Compute image difference between acquired frames
                   im2=imresize(im2,resolucion);
                   im2=im2.*uint8(mascara);
                   dif=imabsdiff(im2,im1);
                   
                   % Get number of pixels in difference image, brighter
                   % than thr. Compute their centroid and the median 
                   % distance to centroid. Also, get number of available 
                   % frames in buffer.                   
                   nDif=length(find(dif>=thr));
                   nFr = vid.FramesAvailable;
                   [I,J]=find(dif>=thr);
                   iC=mean(I);
                   jC=mean(J);
                   rm=median(sqrt((I-iC).^2+(J-jC).^2));
                   
                   % While detection conditions are satisfied, compute
                   % image differences and continue with acquisition.
                   while nDif>=nThr && nFr<250 && rm<=30
                       detection=1;
                       im1=getsnapshot(vid);                       
                       pause(0.1);
                       im2=getsnapshot(vid);
                       im1=imresize(im1,resolucion);
                       im1=im1.*uint8(mascara);
                       im2=imresize(im2,resolucion);
                       im2=im2.*uint8(mascara);
                       dif=imabsdiff(im2,im1);
                       nDif=length(find(dif>=thr));                       
                       [I,J]=find(dif>=thr);
                       iC=mean(I);
                       jC=mean(J);
                       rm=median(sqrt((I-iC).^2+(J-jC).^2));
                       nFr = vid.FramesAvailable;
                   end
                   % Detection conditions no longer satisfied
                   if detection
                       % Acquire frames for one more second, then stop 
                       % acquisition.
                       pause(1); 
                       stop(vid);
                       % Get final time, either from GPS or PC
                       try
                           [t11,~,~]=gpsRead(sGPS); % UT
                       catch err
                           t11=now; %CPU time
                           t11=t11+3/24; %to UT
                           t11=datevec(t11);
                           gpsFlag='0';
                       end
                       try
                           % Get all frames from buffer, and corresponding
                           % metadata. Save files following pre-defined
                           % pattern. Video file is called after first
                           % AbsoluteTime in metadata, which corresponds 
                           % to first frame. It is NOT GPS time. GPS start
                           % and final time instants are saved in .mat
                           % file, along with metadata.
                           [frames,~,metadata]=getdata(vid); 
                           count=count+1;                           
                           filename=strcat(directorio,'/Event_',num2str(stationID),'_',datestr(metadata(1).AbsTime,'yyyy-mm-dd-HH-MM-SS'),'_',gpsFlag,'.mat');
                           t=[datenum(t00) datenum(t11)];
                           save(filename,'metadata','t');                       
                           aviobj = VideoWriter(strcat(directorio,'/Station_',num2str(stationID),'_',datestr(metadata(1).AbsTime,'yyyy-mm-dd-HH-MM-SS'),'.avi'));
                           aviobj.Quality = calidadAVI;
                           aviobj.FrameRate = 30;
                           open(aviobj);
                           for i=1:size(frames,4)
                               current=frames(:,:,1,i);                           
                               writeVideo(aviobj,imresize(current,resolucion));
                           end
                           close(aviobj);
                           set(handles.text12,'String',['Eventos detectados:' ' ' num2str(count)]);
                       catch err
                       end
                       start(vid);
                   else
                       try
                           [t11,~,~]=gpsRead(sGPS); % UT
                       catch err
                           t11=now; %CPU time
                           t11=t11+3/24; %to UT
                           t11=datevec(t11);
                       end
                   end              
               else
                   set(handles.text12,'String',['Fracción nubosidad:' ' ' num2str(FN*100,'%0.f') '%']);
                   try
                       [t11,~,~]=gpsRead(sGPS); % UT
                   catch err
                       t11=now; %CPU time
                       t11=t11+3/24; %to UT
                       t11=datevec(t11);
                   end
               end
               % Save this run in log file; t00, t11, cloud fraction and
               % event count.
               fid = fopen(strcat(directorio,'/Log_',strcat(num2str(id),num2str(rem(mjdn,100),'%02.f')),'.txt'),'a+');
               fprintf(fid,'%12.8f %12.8f %6.3f %6.1f\r\n',[datenum(t00) datenum(t11) FN count]);
               fclose(fid);
            else
                set(handles.text12,'String',['Elevación solar:' ' ' num2str(90-sun.zenith)]);
                count=0;
                if get(handles.radiobutton1,'Value')
                    if ~isempty(directorio)
                        %FTP enabled
                        f=ftp(IP,usr,pass);
                        try
                            ftpDay(f,directorio);
                        catch err
                            set(handles.text12,'String','Error FTP');
                        end
                    end
                end
            end
            t = clock;
            sun = getSun(t,LAT,LON);
            pause(0.05);            
            flushdata(vid);
        end
        unfreeze(handles);
        stop(vid);
        flushdata(vid);
    end
else
    try
        flagStop = 0;
        stop(vid);
        flushdata(vid);
        unfreeze(handles);
    catch err
    end
    set(hObject,'String','RUN');
    set(hObject,'BackgroundColor','g');
    set(handles.text12,'String',['Detenido a las:' ' ' datestr(clock)]);
end

%% Calibrate detection
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid mascara resolucion
try
    set(handles.text12,'String','Calibrando... espere por favor');    
    freeze(handles, hObject); 
    thr=zeros(1,149);
    vid.FramesPerTrigger=150;    
    start(vid);
    wait(vid);
    [frames,~,metadata]=getdata(vid);
    im1=frames(:,:,1,1);
    im1=imresize(im1,resolucion);
    im1=im1.*uint8(mascara);
    
    for i=2:150        
        im2=frames(:,:,1,i);
        im2=imresize(im2,resolucion);
        im2=im2.*uint8(mascara);
        
        diff=imabsdiff(im1,im2);
        thr(i)=max(diff(:));
        
        im1=im2;
    end
    figure; plot(thr); xlabel('# Frame');ylabel('Max pixel intensity');title('Número máximo de cuentas en imagen diferencia');
    figure; hist(double(diff(:)));title('Histograma de número máximo de cuentas en imagen diferencia');
    unfreeze(handles);    
    set(handles.edit1,'String',num2str(mean(thr),'%.0f'));
    set(handles.text12,'String','Listo!');
catch err
    set(handles.text12,'String',strcat('Error:',err.message));
end

%% Take photo
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid sGPS resolucion
calidadJPG = get(handles.slider4,'Value');
try
    try
        [UTC,~,~]=gpsRead(sGPS);
        HLU=datevec(datenum(UTC)-3/24);
    catch err
        HLU=datevec(now);
    end
    
    directorio=strcat('Snapshots/',num2str(HLU(1)),'/',num2str(HLU(2),'%02.f'),'/',num2str(HLU(3),'%02.f'));
    mkdir(directorio);
    d=datestr(HLU,'yyyy-mm-dd-HH-MM-SS');
    archivo=strcat('Snapshot1','-',d,'.jpg');
    try
        s = getsnapshot(vid);
        s=imresize(s,resolucion);
        imwrite(s,strcat(directorio,'/',archivo),'jpeg','Quality',calidadJPG);
        img=imread(strcat(directorio,'/',archivo));
        figure;imshow(img);
        set(handles.text12,'String',['Imagen obtenida' ' ' d]);
    catch err1
        msgbox('Problemas con el dispositivo de captura.','Error de captura');
        dummyFlag=0;
    end
    
catch err
    set(handles.text12,'String',strcat('Error:',err.message));
end

%% Preview
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid 

try
    if strcmp(get(vid,'Previewing'),'off')        
        set(vid,'Timeout',Inf);
        %Preview                
        preview(vid);
        set(handles.text12,'String','Previsualizando...');
    end
catch err
    set(handles.text12,'String',strcat('Error:',err.message));
end
function popupmenu5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Popupmenu for device ID selection
function popupmenu5_Callback(hObject, eventdata, handles)
global vid

str = get(handles.popupmenu1, 'String');
val = get(handles.popupmenu1,'Value');

h = imaqhwinfo(str{val});
ids = h.DeviceIDs;

if ~isempty(ids)
    
    str2 = get(handles.popupmenu5, 'String');
    val2 = get(handles.popupmenu5,'Value');
    h = imaqhwinfo(str{val},str2double(str2{val2}));
    
    formatos = h.SupportedFormats;
    set(handles.popupmenu6, 'String',formatos);
    str3 = get(handles.popupmenu6, 'String');
    val3 = get(handles.popupmenu6,'Value');
    vid = videoinput(str{val},str2double(str2{val2}),str3{val3});
    
else
    vid = [];
end

%% Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid
try
    stop(vid);
    delete(vid);
    clear vid;
catch err    
    clear vid;
end

%% Define mask
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mascara resolucion

[file,path]=uigetfile('*.jpg','Abra una imagen...');
try
    img=imread(strcat(path,file));
    if size(img,1)==resolucion(1) && size(img,2)==resolucion(2)
        figure;
        imshow(img);
        waitfor(msgbox('Defina máscara haciendo click en sus vértices. Finalice con doble click. Espacio, ESC o DEL para cancelar.'));
        [~,BW]=roifill(img);
        img2=img.*uint8(BW);
        imshow(img2);
        save([pwd() 'Mask.mat'],'BW');
        mascara=BW;
    else
        waitfor(msgbox('Resolución de imagen no válida.'));
    end
catch err
    set(handles.text12,'String',strcat('Error:',err.message));
end

%% See mask
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mascara resolucion

[file,path]=uigetfile('*.jpg','Abra una imagen...');

try
    img=imread(strcat(path,file));
    if size(img,1)==resolucion(1) && size(img,2)==resolucion(2)
        img2=img.*uint8(mascara);
        figure;
        imshow(img2);
    else
        waitfor(msgbox('Resolución de imagen no válida.'));
    end
catch err
    set(handles.text12,'String',strcat('Error:',err.message));
end

%% Check GPS button
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sGPS
try
    [~,LAT,LON]=gpsRead(sGPS);
    set(handles.text12,'String',strcat('GPS ok! LAT=-',num2str(dms2degrees(LAT),6),'. LON=-',num2str(dms2degrees(LON),6)));
    set(handles.edit13,'String',num2str(-dms2degrees(LAT),'%08.4f'));
    set(handles.edit14,'String',num2str(-dms2degrees(LON),'%08.4f'));
catch err
    set(handles.text12,'String',strcat('Error:',err.message));
    fclose(sGPS);
end

%% Popupmenu for GPS COM port selection
function popupmenu8_Callback(hObject, eventdata, handles)

global sGPS
str = get(hObject, 'String');
val = get(hObject,'Value');
try
    sGPS=serial(str{val});
    set(sGPS,'BaudRate',4800);
catch err
    msgbox('Parece haber un problema con el receptor GPS.');
end
function popupmenu8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Calibrate cloud detection button
function pushbutton11_Callback(hObject, eventdata, handles)

global vid mascara resolucion
try
    set(handles.text12,'String','Calibrando... Espere por favor');    
    freeze(handles, hObject); 
    vid.FramesPerTrigger=150;    
    start(vid);
    wait(vid);
    [frames,~,~]=getdata(vid);
    promediada=uint16(zeros(resolucion));    
    
    for i=1:150        
        im2=frames(:,:,1,i);
        im2=imresize(im2,resolucion);
        im2=im2.*uint8(mascara);
        promediada=promediada+uint16(im2);                
    end
    
    p=double(promediada)./150;
    p=p(p>0);
    m=mean(mean(p));
    s=std(p(:));
    thrNube = m+3*s;
    figure; histogram(p);title('Histograma de imagen promedio de cielo despejado');
    unfreeze(handles);
    
    set(handles.edit6,'String',num2str(thrNube,'%.0f'));
    set(handles.text12,'String','Listo!');
    
catch err
    set(handles.text12,'String',strcat('Error:',err.message));  
end

%% Other GUI objects
function edit6_Callback(hObject, eventdata, handles)
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit7_Callback(hObject, eventdata, handles)
function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit8_Callback(hObject, eventdata, handles)
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit9_Callback(hObject, eventdata, handles)
function edit9_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit10_Callback(hObject, eventdata, handles)
function edit10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function radiobutton1_Callback(hObject, eventdata, handles)
function edit12_Callback(hObject, eventdata, handles)
function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit13_Callback(hObject, eventdata, handles)
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit14_Callback(hObject, eventdata, handles)
function edit14_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu13_Callback(hObject, eventdata, handles)
function popupmenu13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function pushbutton14_Callback(hObject, eventdata, handles)
function popupmenu7_Callback(hObject, eventdata, handles)
function popupmenu7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit1_Callback(hObject, eventdata, handles)
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_Callback(hObject, eventdata, handles)
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu2_Callback(hObject, eventdata, handles)
function popupmenu2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function slider3_Callback(hObject, eventdata, handles)
function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function slider4_Callback(hObject, eventdata, handles)
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
