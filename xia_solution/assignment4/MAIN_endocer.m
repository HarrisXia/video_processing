clear all;clc;
width=352;
height=288;
imgSize=width*height;
numFrame=250;
fileName = 'assignment1output.cif';
fileID=fopen(fileName,'r');

for i=1:numFrame
    frameSize=1.5*imgSize;
    fseek(fileID, (i - 1) * frameSize, 'bof');
    buf = fread(fileID, width * height, 'uchar');
    Y = reshape(buf, width, height).'; 
    buf = fread(fileID, width / 2 * height / 2, 'uchar');
    U = reshape(buf, width / 2, height / 2).';
    buf = fread(fileID, width / 2 * height / 2, 'uchar');
    V = reshape(buf, width / 2, height / 2).';
    RGB=yuv420torgb(Y,U,V);
    mov(i) = im2frame(RGB);
end
fclose(fileID);



fileEncID = fopen('fileEnc.bin','w');

iFrameRgb = frame2im(mov(1));
%DCT图像压缩
iFrameRgbDct = mydct2(iFrameRgb);
fwrite(fileEncID, int8(iFrameRgbDct),'int8');
% size of block
mbSize = 16;
p = 7;
itmp = iFrameRgb;
for i = 1:length(mov)-1 
    imgIrgb = frame2im(mov(i));
    imgPrgb = frame2im(mov(i+1));
    imgI = double(rgb2gray( imgIrgb ));
    imgP = double(rgb2gray( imgPrgb ));

    % Motion Vectors Search
    [motionVect, EScomput] = motionEstES(imgP,imgI,mbSize,p,i);  
    imgComp = motionComp(itmp, motionVect, mbSize);
    % 估计出的图像与原图像作差
    diffImg = double(imgPrgb) - double(imgComp);
    diffImgDct = mydct2(diffImg); 
    % 保存
    fwrite(fileEncID, int8(diffImgDct),'int8');

    itmp = imgComp;
    motionV(:,:,:,i) = motionVect;
    pause(0.00000000001);
end
disp('处理结束! !');
fclose(fileEncID);


framesPath = './output/';%输出视频路径
videoName = './output/output_encoder.avi';%输出视频名称
fps = 25; %帧率
startFrame = 1; %起始帧
endFrame = 89; %结束帧?
% if(exist(['./motion_video/',videoName],'file'))
%     delete (['./motion_video/',videoName])
% end
%生成视频的参数设定  
aviobj=VideoWriter(videoName);  %创建一个avi视频文件对象，开始时其为空  
aviobj.FrameRate=fps; 

open(aviobj);%Open file for writing video data

for i=startFrame:endFrame
    fileName=sprintf('%d',i);
    fileName=strcat(fileName);
    frames=imread([framesPath, fileName,'.jpg']);
    frames=im2frame(frames); 
    writeVideo(aviobj,frames);
end
close(aviobj);

% acFAST encoding
command = 'acfile.exe -c fileEnc.bin fileEnc';
system(command);

% command = 'acfile.exe -c assignment1output.cif funfairout';
% system(command);

save mov.mat mov motionV
