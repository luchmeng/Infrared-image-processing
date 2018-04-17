function varargout = untitled2(varargin)
%UNTITLED2 MATLAB code file for untitled2.fig
%      UNTITLED2, by itself, creates a new UNTITLED2 or raises the existing
%      singleton*.
%
%      H = UNTITLED2 returns the handle to a new UNTITLED2 or the handle to
%      the existing singleton*.
%
%      UNTITLED2('Property','Value',...) creates a new UNTITLED2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to untitled2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      UNTITLED2('CALLBACK') and UNTITLED2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in UNTITLED2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled2

% Last Modified by GUIDE v2.5 13-Jun-2016 17:09:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled2_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before untitled2 is made visible.
function untitled2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for untitled2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled2_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
Fr1=str2double(get(hObject,'String'));
Fr=round(Fr1);
set(handles.slider1,'value',Fr);
slider1_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Fr=get(handles.slider1,'Value');
Fr=round(Fr);
set(handles.edit1,'string',num2str(Fr));
M=384;
N=288;
TH=35;
TL=20;
HL_num=100;
flag1=1;
flag2=1;
limit=25;%优化直方图算法级别
ADC=14;%数据为14比特
fg=fopen('38CvData2000.dat','r');
% fseek(fg,(M*N*0),-1);
fseek(fg,(M*N*2*Fr),-1);
f0=fread(fg,[M,N],'int16');
fsour=f0*255/max(max(f0));%将灰度变为255
fsour=round(fsour);%F0元素变为整数

c7=get(handles.checkbox7,'value');



%%%%%%%%%%
if c7==0
    fgH=fopen('38CvData35.dat','r');%温度35度均匀辐照
    fgL=fopen('38CvData20.dat','r');%温度20度均匀辐照
    f00=fread(fgH,[M,N],'int16');

    f0H=zeros(M,N);
    f0L=zeros(M,N);

    fB=zeros(M,N);%B代表挡板

%得到前100帧的高／低温辐照的平均值
    fseek(fgH,2*M*N*0,-1);
    fseek(fgL,2*M*N*0,-1);
    for i=1:HL_num 
        f_temp=fread(fgH,[M,N],'int16');
        f0H=f0H+f_temp;
        f_temp=fread(fgL,[M,N],'int16');
        f0L=f0L+f_temp;
        fseek(fgH,2*M*N*i,-1);
        fseek(fgL,2*M*N*i,-1);
    end
    f0H=round(f0H/HL_num);
    f0L=round(f0L/HL_num);

%两点矫正算法，A为各像素响应系数
    [A,DeadPoint,DeadPoint_num]=Two_point(flag1,flag2,f0H,f0L,TH,TL,M,N);

%得到前100帧的挡板图像数据的平均值B
    fseek(fgL,2*M*N*0,-1);
    for i=1:HL_num
        f_temp=fread(fg,[M,N],'int16');
        fB=fB+f_temp;
        fseek(fg,2*M*N*i,-1);
    end
    B=(fB/HL_num)-200;

%第Fr帧减去挡板平均数据，去固定杂点
    f0=round(f0-B);

    fd=f0;
    fd=fd*255/max(max(fd));%将灰度变为255
    fd=round(fd);
%消除坏点
    [f0]=Dead_eliminate(M,N,f0,DeadPoint,DeadPoint_num);
    fdx=f0;
    fdx=fdx*255/max(max(fdx));%将灰度变为255
    fdx=round(fdx);
%各像素点的响应矫正：F0=A*(F0-B)
    for i=1:M
        for j=1:N
            f0(i,j)=f0(i,j)*A(i,j);
        end
    end

    I=f0*255/max(max(f0));%将灰度变为255
    f0=round(f0);
    I=round(I);
    fjy=I;
    axes(handles.axes1);
    imshow(fsour,[0,255]);
    
    c1=get(handles.checkbox1,'value');
    c2=get(handles.checkbox2,'value');
    c3=get(handles.checkbox3,'value');
    c4=get(handles.checkbox4,'value');
    c5=get(handles.checkbox5,'value');

    
    if c5==1
        %直方图拉伸=I2
        set(handles.checkbox4,'value',0);
        f2=Histeq_AGC_x(ADC,M,N,f0,limit);
        I2=f2*255/max(max(f2));
        axes(handles.axes2);
        imshow(I2,[0,255]);
    end
    
    if c4==1&&c5==0
         %直方图均衡化=I1
        I1=uint8(round(I));
        I1=histeq(I1,64);
        axes(handles.axes2);
        imshow(I1);
    end
        
    if c3==1&&c4==0&&c5==0
       axes(handles.axes2);
        imshow(fjy,[0,255]);
    end
    
    if c2==1&&c3==0&&c4==0&&c5==0
        axes(handles.axes2);
        imshow(fdx,[0,255]);
    end
    
    if c1==1&&c2==0&&c3==0&&c4==0&&c5==0
         axes(handles.axes2);
        imshow(fd,[0,255]);
    end
    
    if c1==0
        axes(handles.axes2);
        imshow(fsour,[0,255]);
    end
 
    
end




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end







% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2
c6=get(handles.togglebutton2,'value');
c1=get(handles.checkbox1,'value');
c2=get(handles.checkbox2,'value');
c3=get(handles.checkbox3,'value');
c4=get(handles.checkbox4,'value');
c5=get(handles.checkbox5,'value');
c7=get(handles.checkbox7,'value');
s1=get(handles.slider1,'value');

M=384;
N=288;
TH=35;
TL=20;
HL_num=100;
flag1=1;
flag2=1;
limit=25;%优化直方图算法级别
ADC=14;%数据为14比特

%%%%-------------读取图像----------------%%%
    fg=fopen('38CvData2000.dat','r');

%%%--------非均匀校正---------------%%%
fgH=fopen('38CvData35.dat','r');%温度35度均匀辐照
fgL=fopen('38CvData20.dat','r');%温度20度均匀辐照
f00=fread(fgH,[M,N],'int16');

f0H=zeros(M,N);
f0L=zeros(M,N);

fB=zeros(M,N);%B代表挡板

%得到前100帧的高／低温辐照的平均值
fseek(fgH,2*M*N*0,-1);
fseek(fgL,2*M*N*0,-1);
for i=1:HL_num 
    f_temp=fread(fgH,[M,N],'int16');
    f0H=f0H+f_temp;
    f_temp=fread(fgL,[M,N],'int16');
    f0L=f0L+f_temp;
    fseek(fgH,2*M*N*i,-1);
    fseek(fgL,2*M*N*i,-1);
end
f0H=round(f0H/HL_num);
f0L=round(f0L/HL_num);

%两点矫正算法，A为各像素响应系数
[A,DeadPoint,DeadPoint_num]=Two_point(flag1,flag2,f0H,f0L,TH,TL,M,N);

%得到前100帧的挡板图像数据的平均值B
fseek(fgL,2*M*N*0,-1);
for i=1:HL_num
    f_temp=fread(fg,[M,N],'int16');
    fB=fB+f_temp;
    fseek(fg,2*M*N*i,-1);
end
B=(fB/HL_num)-200;

if c7==1
%%%%
%%%%



%%%%
    %%开始循环
 Fr=round(s1);
    
    while c6==1 
    
    fseek(fg,(M*N*2*Fr),-1);
    f0=fread(fg,[M,N],'int16');
    %以16位读取读取图像文件
    
    fsour=f0*255/max(max(f0));
    fsour=uint8(round(fsour));
    
    %第Fr帧减去挡板平均数据，去固定杂点
    f0=round(f0-B);
    fd=f0;
    fd=fd*255/max(max(fd));%将灰度变为255
    fd=round(fd);
    
    %消除坏点
    [f0]=Dead_eliminate(M,N,f0,DeadPoint,DeadPoint_num);
    fdx=f0;
    fdx=fdx*255/max(max(fdx));%将灰度变为255
    fdx=round(fdx);
    
    %各像素点的响应矫正：F0=A*(F0-B)
    for i=1:M
        for j=1:N
            f0(i,j)=f0(i,j)*A(i,j);
        end
    end
    I=f0*255/max(max(f0));%将灰度变为255
    I=round(I);
    f0=round(f0);
    fjy=I;
    
    
    
    %%开始显示图像
    axes(handles.axes1);
    imshow(fsour,[0,255]);
    
    if c5==1
        %直方图拉伸=I2
        set(handles.checkbox4,'value',0);
        f2=Histeq_AGC_x(ADC,M,N,f0,limit);
        I2=f2*255/max(max(f2));
        axes(handles.axes2);
        imshow(I2,[0,255]);
    end
    
    if c4==1&&c5==0
         %直方图均衡化=I1
        I1=uint8(round(I));
        I1=histeq(I1,64);
        axes(handles.axes2);
        imshow(I1);
    end
        
    if c3==1&&c4==0&&c5==0
       axes(handles.axes2);
        imshow(fjy,[0,255]);
    end
    
    if c2==1&&c3==0&&c4==0&&c5==0
        axes(handles.axes2);
        imshow(fdx,[0,255]);
    end
    
    if c1==1&&c2==0&&c3==0&&c4==0&&c5==0
         axes(handles.axes2);
        imshow(fd,[0,255]);
    end
    if c1==0
        axes(handles.axes2);
        imshow(fsour,[0,255]);
    end
    pause(1/1000);
    c6=get(handles.togglebutton2,'value');
    c1=get(handles.checkbox1,'value');
    c2=get(handles.checkbox2,'value');
    c3=get(handles.checkbox3,'value');
    c4=get(handles.checkbox4,'value');
    c5=get(handles.checkbox5,'value');
    set(handles.slider1,'value',Fr);
    set(handles.edit1,'string',num2str(Fr));
    Fr=Fr+1;
    if Fr==1581
        set(handles.slider1,'value',501);
        set(handles.edit1,'string',num2str(501));
        break
    end
    
    end
   

end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7
