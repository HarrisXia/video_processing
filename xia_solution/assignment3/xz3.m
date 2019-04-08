%%
%% XiaHan 2017229025
%%
clear all;
clc;
close all;
I_rgb=imread('test.jpg');
I = rgb2gray(I_rgb);
%I = imresize(I, [256,256]);

I=im2double(I);                 %ת��ͼ�����Ϊ˫�����͡�
T=dctmtx(8);  %������άDCT�任����

% DCT�任
B=blkproc(I,[8,8],'P1*x*P2',T,T'); %��ֵ��ģ������ѹ��DCTϵ����ֻ����DCTϵ�������Ͻǵ�10��
mask=[1 1 1 1 0 0 0 0
      1 1 1 0 0 0 0 0
      1 1 0 0 0 0 0 0
      1 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0 ];
  %mask = ones(8,8);
I2=blkproc(B,[8 8],'P1.*x',mask)  ;                            

% ����
u = abs(min(I2(:)));
M =(I2./u)+1;
data = uint8(M);                                  %Huffman����Ҫ��Ϊ�޷�����������
loss = M - double(data);  
% Huffman����
[bitStream, info] = huffencode(data);

%Huffman����
decodedStream = huffdecode(bitStream, info, data);     
k=1;  
for i=1:256
    for j=1:256    
        decodedImage(i,j)=decodedStream(k);    
        k=k+1;     
    end
end
decodedImage= decodedImage';

decodedImage = (double(decodedImage) - 1 + loss).*u;     

B2 = blkproc(decodedImage,[8 8],'x.*P1',mask); %������ 
I3 = blkproc(B2,[8 8],'P1*x*P2',T',T);

%�ع�ͼ��
figure
imshow(I)
title('ԭʼͼ��');
figure
imshow(I3);
title('ѹ��ͼ��');

B=8;                %����һ�������ö��ٶ�����λ
MAX=1;          %ͼ���ж��ٻҶȼ�
MES=sum(sum((I-I3).^2))/(256*256);     %������
PSNR=20*log10(MAX/sqrt(MES));           %��ֵ�����