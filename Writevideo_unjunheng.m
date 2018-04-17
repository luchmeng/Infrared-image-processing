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

   %%%--------�Ǿ���У��---------------%%%
fgH=fopen('38CvData35.dat','r');%�¶�35�Ⱦ��ȷ���
fgL=fopen('38CvData20.dat','r');%�¶�20�Ⱦ��ȷ���
f00=fread(fgH,[M,N],'int16');
f0H=zeros(M,N);
f0L=zeros(M,N);
fB=zeros(M,N);%B������
    
%�õ�ǰ100֡�ĸߣ����·��յ�ƽ��ֵ
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

%��������㷨��AΪ��������Ӧϵ��
[A,DeadPoint,DeadPoint_num]=Two_point(flag1,flag2,f0H,f0L,TH,TL,M,N);

%�õ�ǰ100֡�ĵ���ͼ�����ݵ�ƽ��ֵB
fseek(fgL,2*M*N*0,-1);
for i=1:HL_num
    f_temp=fread(fg,[M,N],'int16');
    fB=fB+f_temp;
    fseek(fg,2*M*N*i,-1);
end
B=(fB/HL_num)-200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
WriterObj=VideoWriter('video_unjunheng.avi');% xxx.avi��ʾ���ϳɵ���Ƶ
writerObj.FrameRate = 25;
open(WriterObj);
for fe=501:1580 
    fseek(fg,(M*N*2*fe),-1);
    f0=fread(fg,[M,N],'int16');
    
%��Fr֡��ȥ����ƽ�����ݣ�ȥ�̶��ӵ�
    f0=round(f0-B);


%��������
    [f0]=Dead_eliminate(M,N,f0,DeadPoint,DeadPoint_num);

%�����ص����Ӧ������F0=A*(F0-B)
    for i=1:M
     for j=1:N
        f0(i,j)=f0(i,j)*A(i,j);
     end
    end

    I=f0*255/max(max(f0));%���Ҷȱ�Ϊ255
    f0=round(f0);%F0Ԫ�ر�Ϊ����
    If=uint8(round(I));

    frame=If;% ��ȡͼ�񣬷��ڱ���frame��
    writeVideo(WriterObj,frame);% ��frame�ŵ�����WriterObj��
end
close(WriterObj);