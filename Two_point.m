function[A,DeadPoint,DeadPoint_num]=Two_point(flag1,flag2,f0H,f0L,TH,TL,M,N)
A=ones(M,N);
DeadPoint=zeros(M,N);
DeadPoint_num=0;
if flag1==1 && flag2==1
    f0h=mean(mean(f0H));
    f0l=mean(mean(f0L));
    a=(f0h-f0l)/(TH-TL);
    A=a./((f0H-f0L)./(TH-TL)); 
    for i=1:M
        for j=1:N
            if A(i,j)>1.2 || A(i,j)<0.8 %Ìô³ö»µµã
                DeadPoint(i,j)=1;
                DeadPoint_num=DeadPoint_num+1;
                A(i,j)=1;
            end
        end
    end
end