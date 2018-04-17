function[f1]=Histeq_AGC_x(ADC,M,N,f0,limit)
%---基于距离的[0,255]全范围映射拉伸
f1=zeros(M,N);
n_len=2^ADC;
n=zeros(1,n_len);
distance1=4;
distance2=50;
for i=1:M            %---全直方图统计,各个灰度值的数量
    for j=1:N
        if f0(i,j)<0
            f0(i,j)=abs(f0(i,j));
        end
        n(f0(i,j)+1)=n(f0(i,j)+1)+1;
    end
end
%--------------------------------%%
%%--基于hx的拉伸----------%%
x=zeros(1,n_len);%n=zeros(1,n_len)
k=0;
for i=1:n_len
    if n(i)>limit%直方图从左向右数，数到高度（数量）大于limit为止
        k=i;
        x(i)=1;%%关键；直方图中灰度值k以左的高度都被清零
        break;%%%%%很关键，挑出for循环。
    end
end
j=k;%灰度值小于k的灰度都被limit掉

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