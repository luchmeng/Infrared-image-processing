%生成未均衡化的清晰图像%
clear;
clc;
close all;
M=384;
N=288;
Fr=290;%Fr＝frame=第几帧
TH=35;
TL=20;
HL_num=100;
flag1=1;
flag2=1;
limit=5;%优化直方图算法级别
medfilt_grade=3;%中值滤波级别
ADC=14;%数据为14比特

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
WriterObj=VideoWriter('video_unjunheng.avi');% xxx.avi表示待合成的视频
writerObj.FrameRate = 25;
open(WriterObj);
for fe=501:1580 
    fseek(fg,(M*N*2*fe),-1);
    f0=fread(fg,[M,N],'int16');
    
%第Fr帧减去挡板平均数据，去固定杂点
    f0=round(f0-B);


%消除坏点
    [f0]=Dead_eliminate(M,N,f0,DeadPoint,DeadPoint_num);

%各像素点的响应矫正：F0=A*(F0-B)
    for i=1:M
     for j=1:N
        f0(i,j)=f0(i,j)*A(i,j);
     end
    end

    I=f0*255/max(max(f0));%将灰度变为255
    f0=round(f0);%F0元素变为整数
    If=uint8(round(I));

    frame=If;% 读取图像，放在变量frame中
    writeVideo(WriterObj,frame);% 将frame放到变量WriterObj中
end
close(WriterObj);