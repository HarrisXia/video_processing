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
% �ȶ��ı����ĵ�һ֡�ο�֡
iFrameRgbDct(:,:,1) = fread(fileEncID,[height width],'int8');
iFrameRgbDct(:,:,2) = fread(fileEncID,[height width],'int8');
iFrameRgbDct(:,:,3) = fread(fileEncID,[height width],'int8');
% DCT��任
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
    % ������Ķ��ǲ��֡
    diffImg(:,:,1) = fread(fileEncID,[height width],'int8');
    diffImg(:,:,2) = fread(fileEncID,[height width],'int8');
    diffImg(:,:,3) = fread(fileEncID,[height width],'int8');
    % DCT��任
    diffImg = mydct2Inverse(diffImg);
    imgPrgb = double(imgPre) + double(diffImg);
    itmp = imgPre;
    movde(i)=im2frame(uint8(imgPrgb));
    % ����PSNRָ��
    peaksnr(i-1)=psnr(double(frame2im(mov(i))), imgPrgb, 255);
end

disp('�������! !');
fclose(fileEncID);

for i=1:250
    
    subplot(1,2,1);
    title('�������Ƶ');
    a=frame2im(movde(i));
    imshow(a);
    subplot(1,2,2);
    title('����ǰ��Ƶ');
    b=frame2im(mov(i));
    imshow(b);
    print(1, '-djpeg',['./output/',num2str(i)]);
    pause(0.025);
    
end

% movie(movde);

fprintf('\nThe maximum PSNR is %0.2f\n',max(peaksnr));
fprintf('\nThe mean PSNR is %0.2f\n',mean(peaksnr));
fprintf('\nThe minimum PSNR is %0.2f\n',min(peaksnr));



framesPath = './output/';%�����Ƶ·��
videoName = './output/output.avi';%�����Ƶ����
fps = 25; %֡��
startFrame = 1; %��ʼ֡��
endFrame = 89; %����֡?
% if(exist(['./motion_video/',videoName],'file'))
%     delete (['./motion_video/',videoName])
% end
%������Ƶ�Ĳ����趨  
aviobj=VideoWriter(videoName);  %����һ��avi��Ƶ�ļ����󣬿�ʼʱ��Ϊ��  
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

