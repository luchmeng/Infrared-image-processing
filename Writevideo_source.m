%����δ���⻯������ͼ��%
clear;
clc;
close all;
M=384;
N=288;
Fr=290;%Fr��frame=�ڼ�֡
TH=35;
TL=20;
HL_num=100;
flag1=1;
flag2=1;
limit=5;%�Ż�ֱ��ͼ�㷨����
medfilt_grade=3;%��ֵ�˲�����
ADC=14;%����Ϊ14����

fg=fopen('38CvData2000.dat','r');

WriterObj=VideoWriter('video_source.avi');% xxx.avi��ʾ���ϳɵ���Ƶ����������avi��ʽ�����ļ�·��
writerObj.FrameRate = 25;
open(WriterObj);
for fe=501:1580 
    fseek(fg,(M*N*2*fe),-1);
    f0=fread(fg,[M,N],'int16');
    f0=round(f0);%F0Ԫ�ر�Ϊ����
    f0=f0*255/max(max(f0));
    If=uint8(round(f0));
    frame=If;% ��ȡͼ�񣬷��ڱ���frame��
    writeVideo(WriterObj,frame);% ��frame�ŵ�����WriterObj��
end
close(WriterObj);