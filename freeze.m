function freeze(handles,hObject)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

set(handles.popupmenu1,'Enable','off');
set(handles.popupmenu6,'Enable','off');
set(handles.popupmenu5,'Enable','off');
set(handles.popupmenu9,'Enable','off');
set(handles.popupmenu7,'Enable','off');
set(handles.popupmenu8,'Enable','off');
set(handles.popupmenu10,'Enable','off');

set(handles.edit1,'Enable','off');
set(handles.edit2,'Enable','off');

set(handles.slider1,'Enable','off');
set(handles.slider2,'Enable','off');
set(handles.slider3,'Enable','off');
set(handles.slider4,'Enable','off');

set(handles.pushbutton4,'Enable','off');
set(handles.pushbutton6,'Enable','off');
set(handles.pushbutton5,'Enable','off');
set(handles.pushbutton2,'Enable','off');
set(handles.pushbutton8,'Enable','off');
set(handles.pushbutton9,'Enable','off');
set(handles.pushbutton10,'Enable','off');
set(handles.pushbutton11,'Enable','off');

if strcmp(get(hObject,'String'),'REC')
    set(handles.pushbutton3,'Enable','off');
end
end

