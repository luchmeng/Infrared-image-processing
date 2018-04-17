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

WriterObj=VideoWriter('video_source.avi');% xxx.avi表示待合成的视频（不仅限于avi格式）的文件路径
writerObj.FrameRate = 25;
open(WriterObj);
for fe=501:1580 
    fseek(fg,(M*N*2*fe),-1);
    f0=fread(fg,[M,N],'int16');
    f0=round(f0);%F0元素变为整数
    f0=f0*255/max(max(f0));
    If=uint8(round(f0));
    frame=If;% 读取图像，放在变量frame中
    writeVideo(WriterObj,frame);% 将frame放到变量WriterObj中
end
close(WriterObj);