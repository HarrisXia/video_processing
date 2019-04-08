clear all;clc;
width=352;
height=288;
imgSize=width*height;
load mov.mat

% acFAST decoding
command = 'acfile.exe -d fileEnc fileDEc.bin';
system(command);

% read decoding file
fileEncID = fopen('fileDEc.bin');

fileDir = dir('fileEnc.bin');
% 先读的编码后的第一帧参考帧
iFrameRgbDct(:,:,1) = fread(fileEncID,[height width],'int8');
iFrameRgbDct(:,:,2) = fread(fileEncID,[height width],'int8');
iFrameRgbDct(:,:,3) = fread(fileEncID,[height width],'int8');
% DCT逆变换
iFrameRgb = mydct2Inverse(iFrameRgbDct);
movde(1)=im2frame(uint8(iFrameRgb));

nn=fileDir.bytes/(imgSize*3);%/8;  %% double 8 Bytes, int8, 1Byte
mbSize = 16;
p = 7;
itmp = uint8(iFrameRgb);
for i = 2:nn
    disp(i);
    % Motion Vectors Search
    motionVect(:,:,:) = motionV(:,:,:,i-1);
    % Computes motion compensated image using the given motion vectors
    imgPre = motionComp(itmp, motionVect, mbSize);
    % 后面读的都是差分帧
    diffImg(:,:,1) = fread(fileEncID,[height width],'int8');
    diffImg(:,:,2) = fread(fileEncID,[height width],'int8');
    diffImg(:,:,3) = fread(fileEncID,[height width],'int8');
    % DCT逆变换
    diffImg = mydct2Inverse(diffImg);
    imgPrgb = double(imgPre) + double(diffImg);
    itmp = imgPre;
    movde(i)=im2frame(uint8(imgPrgb));
    % 计算PSNR指标
    peaksnr(i-1)=psnr(double(frame2im(mov(i))), imgPrgb, 255);
end

disp('处理结束! !');
fclose(fileEncID);

for i=1:250
    
    subplot(1,2,1);
    title('解码后视频');
    a=frame2im(movde(i));
    imshow(a);
    subplot(1,2,2);
    title('编码前视频');
    b=frame2im(mov(i));
    imshow(b);
    print(1, '-djpeg',['./output/',num2str(i)]);
    pause(0.025);
    
end

% movie(movde);

fprintf('\nThe maximum PSNR is %0.2f\n',max(peaksnr));
fprintf('\nThe mean PSNR is %0.2f\n',mean(peaksnr));
fprintf('\nThe minimum PSNR is %0.2f\n',min(peaksnr));



framesPath = './output/';%输出视频路径
videoName = './output/output.avi';%输出视频名称
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

