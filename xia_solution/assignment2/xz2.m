%%
%% XiaHan 2017229025
%%
clear all;
clc;
width=352/2;
height=288/2;
imgSize=width*height;
numFrame=90;
fileID=fopen('suzie_90frames.qcif','r');

for i=1:numFrame
    frameSize=1.5*imgSize;
    fseek(fileID, (i - 1) * frameSize, 'bof');
    % read Y component
    buf = fread(fileID, width * height, 'uchar');
    Y = reshape(buf, width, height).'; % reshape
    % read U component
    buf = fread(fileID, width / 2 * height / 2, 'uchar');
    U = reshape(buf, width / 2, height / 2).';
    % read V component
    buf = fread(fileID, width / 2 * height / 2, 'uchar');
    V = reshape(buf, width / 2, height / 2).';
    % convert YUV to RGB
    RGB=yuv420torgb(Y,U,V);
    mov(i) = im2frame(RGB);
end
fclose(fileID);

mbSize = 16;
p = 7;
tmp = zeros(height,width);
for i = 1:length(mov)-1
    imgINumber = i;
    imgPNumber = i+1;
    imgIrgb = frame2im(mov(imgINumber));
    imgPrgb = frame2im(mov(imgPNumber));
    imgI = double(rgb2gray( imgIrgb ));
    imgP = double(rgb2gray( imgPrgb ));
    
    % Motion Vectors Search
    motionVect = motionEstES(imgP,imgI,mbSize,p);
    imgComp = motionComp(imgIrgb, motionVect, mbSize);
    peaksnr(i) = psnr(imgP, double(rgb2gray(imgComp)), 255);
    
%     subplot(1,2,1);imshow(imgIrgb);
%     subplot(1,2,2);imshow(uint8(imgComp));
    pause(0.000001);
end
fprintf('\nThe maximum psrr value is %0.2f\n',max(peaksnr));
fprintf('\nThe minimum psrr value is %0.2f\n',min(peaksnr));


