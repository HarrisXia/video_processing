%%
%% XiaHan 2017229025
%%
clear all;
clc;
close all;
I_rgb=imread('test.jpg');
I = rgb2gray(I_rgb);
%I = imresize(I, [256,256]);

I=im2double(I);                 %转换图像矩阵为双精度型。
T=dctmtx(8);  %产生二维DCT变换矩阵

% DCT变换
B=blkproc(I,[8,8],'P1*x*P2',T,T'); %二值掩模，用来压缩DCT系数，只留下DCT系数中左上角的10个
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

% 量化
u = abs(min(I2(:)));
M =(I2./u)+1;
data = uint8(M);                                  %Huffman编码要求为无符号整形数组
loss = M - double(data);  
% Huffman编码
[bitStream, info] = huffencode(data);

%Huffman解码
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

B2 = blkproc(decodedImage,[8 8],'x.*P1',mask); %反量化 
I3 = blkproc(B2,[8 8],'P1*x*P2',T',T);

%重构图像
figure
imshow(I)
title('原始图像');
figure
imshow(I3);
title('压缩图像');

B=8;                %编码一个像素用多少二进制位
MAX=1;          %图像有多少灰度级
MES=sum(sum((I-I3).^2))/(256*256);     %均方差
PSNR=20*log10(MAX/sqrt(MES));           %峰值信噪比