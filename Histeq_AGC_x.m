function[f1]=Histeq_AGC_x(ADC,M,N,f0,limit)
%---���ھ����[0,255]ȫ��Χӳ������
f1=zeros(M,N);
n_len=2^ADC;
n=zeros(1,n_len);
distance1=4;
distance2=50;
for i=1:M            %---ȫֱ��ͼͳ��,�����Ҷ�ֵ������
    for j=1:N
        if f0(i,j)<0
            f0(i,j)=abs(f0(i,j));
        end
        n(f0(i,j)+1)=n(f0(i,j)+1)+1;
    end
end
%--------------------------------%%
%%--����hx������----------%%
x=zeros(1,n_len);%n=zeros(1,n_len)
k=0;
for i=1:n_len
    if n(i)>limit%ֱ��ͼ�����������������߶ȣ�����������limitΪֹ
        k=i;
        x(i)=1;%%�ؼ���ֱ��ͼ�лҶ�ֵk����ĸ߶ȶ�������
        break;%%%%%�ܹؼ�������forѭ����
    end
end
j=k;%�Ҷ�ֵС��k�ĻҶȶ���limit��

for i=k+1:n_len
    if n(i)>limit%
       if i-j<distance1
            x(i)=x(i-1)+1;
%  %           display('1')
        elseif (i-j)>=distance1 && (i-j)<=distance2
            x(i)=x(i-1)+1;
%             display('2')
        else 
            x(i)=x(i-1)+1;
%             display('3')
        end
        j=i;
    else
        x(i)=x(i-1);
    end
end

T=uint8(255*x/x(n_len));


for i=1:M
    for j=1:N
        f1(i,j)=T(f0(i,j)+1);
    end
end