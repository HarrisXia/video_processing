% Input
%   img : The image for which we want to transform using 2D-IDCT method
% Ouput
%   imgDCT : The image data after transforming using 2D-IDCT method
function img=mydct2Inverse(imgDCT)
%----------------------------------------------------------
% 逆DCT，图象重建
%----------------------------------------------------------
%----------------------------------------------------------
% 生成变换矩阵以及量化表，输入必须是8*8的矩阵
%----------------------------------------------------------
N=8;
T=zeros(8);
for i=0:N-1
    for j=0:N-1
        if i==0
            a=sqrt(1/N);
        else
            a=sqrt(2/N);
        end
        T(i+1,j+1)=a*cos(pi*(j+0.5)*i/N); %生成变换矩阵
    end
end

W=[16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];

for k=1:3
    
    B=double(imgDCT(:,:,k));
    s=size(B);
    C=zeros(s);    
    for m=1:s(1)
        if rem(m,8)==0
            for n=1:s(2)
                if rem(n,8)==0
                    Y=B((m-8+1):m,(n-8+1):n);
                    BLOCK=Y.*W; %反量化
                    C((m-8+1):m,(n-8+1):n)=T'*BLOCK*T;  %DCT反变换恢复的矩阵
                end
            end
        end
    end
    D(:,:,k)=C;
end
img = D;

