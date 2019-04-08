function [bitStream, data, loss, info, u, iqtMatrix, T, m, n] = encoder(image)
[m, n]=size(image);
imageD = double(image);

qtMatrix = [
    1 1 1 1 1 1 0 0;
    1 1 1 1 1 0 0 0;
    1 1 1 1 0 0 0 0;
    1 1 1 0 0 0 0 0;
    1 1 0 0 0 0 0 0;
    1 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0];

iqtMatrix = qtMatrix;
T =dctmtx(8);

image1 =blkproc(imageD,[8 8],'P1*x*P2',T, T'); 
image2 =blkproc(image1,[8 8],'x.*P1',qtMatrix);

u = abs(min(min(image2)));
M =(image2./u)+1;
data = uint8(M);%Huffman����Ҫ��Ϊ�޷�����������
loss = M - double(data);  

[bitStream, info] = huffencode(data);



%{
% �������
imageD = im2double(image);
imageD = image;
T = dctmtx(8);

% DCT�仯������
imageP = blkproc(imageD,[8 8],'P1*x*P2',T,T');

% huffman����
%huffman�ֵ�
[h, w] = size(image);
p = zeros(1,256);
imageI = imageP(:);
valueSet = unique(imageI);
 %��ȡ�����ŵĸ��ʣ�
 for i = 0:255
     p(i + 1) = length(find(imageI == i))/(h * w);
 end
symbols = 0 : 255;
%p = [.5 .125 .125 .125 .0625 .0625];
dict = huffmandict(symbols, p);

bitStream = huffmanenco(uint8(imageP), dict);

    %}