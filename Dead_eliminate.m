function [f1]=Dead_eliminate(M,N,f0,DeadPoint,DeadPoint_num)
if DeadPoint_num>0
    
    f1=f0;
    d0=DeadPoint;
%�Ľ�
    if d0(1,1)==1
     f1(1,1)=(f1(2,2)+f1(1,2)+f1(2,1))/3;
    end
    if d0(1,N)==1
    f1(1,N)=(f1(2,N-1)+f1(2,N)+f1(1,N-1))/3;
    end
    if d0(M,1)==1
    f1(M,1)=(f1(M,2)+f1(M-1,1)+f1(M-1,2))/3;
    end
    if d0(M,N)==1
    f1(M,N)=(f1(M,N-1)+f1(M-1,N)+f1(M-1,N-1))/3;
    end

%�ı�
    for i=2:(M-1) %���
        if d0(i,1)==1
        f1(i,1)=(f1(i,2)+f1(i-1,2)+f1(i-1,1)+f1(i+1,1)+f1(i+1,2))/5;
        end
    end
    for i=2:(N-1)%�ϱ�
     if d0(1,i)==1
         f1(1,i)=(f1(1,i+1)+f1(1,i-1)+f1(2,i)+f1(2,i+1)+f1(2,i-1))/5;
     end
    end
    for i=2:(M-1)%�ұ�
        if d0(i,N)==1
        f1(i,N)=(f1(i,N-1)+f1(i-1,N)+f1(i-1,N-1)+f1(i+1,N)+f1(i+1,N-1))/5;
        end
    end
    for i=2:(N-1)%�±�
      if d0(M,i)==1
        f1(M,i)=(f1(M-1,i)+f1(M,i-1)+f1(M-1,i-1)+f1(M,i+1)+f1(M-1,i+1))/5;
      end
    end

%�м䲿��
    for i=2:(M-1)
        for j=2:(N-1)
            if d0(i,j)==1
            f1(i,j)=(f1(i+1,j+1)+f1(i-1,j-1)+f1(i,j+1)+f1(i,j-1)+f1(i+1,j)+f1(i-1,j)+f1(i-1,j+1)+f1(i+1,j-1))/8;
            end
        end
    end
end
f1=round(f1);
