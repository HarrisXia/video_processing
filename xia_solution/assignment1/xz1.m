%%
%% XiaHan 2017229025
%%
clear
clc
fid = fopen('funfair.cif','rb');
fout = fopen('output.cif','w');
row = 288;  % 视频大小
col = 352;
length_start = 25;  % 个人介绍的长度为25帧
length = 250;    % 转换的视频长度
rgb = zeros(row, col, 3, length);

% 读入文件，并转换为RGB格式
for frame=1:length
    im_l_y = zeros(row,col); %Y
    % 读入时，YUV不同通道处理方式不同
    for i1 = 1:row 
       im_l_y(i1,:) = fread(fid,col);  %读取数据到矩阵中 
    end

    im_l_cb = zeros(row/2,col/2); %cb
    for i2 = 1:row/2 
       im_l_cb(i2,:) = fread(fid,col/2);  
    end

    im_l_cr = zeros(row/2,col/2); %cr
    for i3 = 1:row/2 
       im_l_cr(i3,:) = fread(fid,col/2);  
    end
    % 调用函数进行转化
    rgb(:, :, :, frame) = yuv420torgb(im_l_y, im_l_cb, im_l_cr);
end

    
logo_file = imread('logo.jpg');  % 读取校徽图片
logo = imresize(logo_file,0.05);   % 图片缩小
[logo_row, logo_col] = size(logo(:,:,1));
portrait_file = imread('portrait.jpg');  % 读取个人照片图片
portrait = imresize(portrait_file,0.2);   % 图片缩小
[portrait_row, portrait_col] = size(portrait(:,:,1));

out_rgb = rgb;

first_frame = out_rgb(:, :, :, 1);
% 开头25帧展示个人信息，图像逐渐消失
for frame = 1:length_start
%     在照片上写入个人信息
    ti=vision.TextInserter('Xia Han', 'Location', [20 90], 'FontSize', 8, 'Color',[1 0 0]);
    portrait=step(ti,portrait);
    ti=vision.TextInserter('2017229025', 'Location', [25 100],'FontSize', 6, 'Color',[1 0 0]);
    portrait=step(ti,portrait);
%     将照片置入，并逐渐消失
    portrait_part = (1-frame/length_start) * portrait(:,:,:);
    pic_part = uint8((frame/length_start) * first_frame((row-portrait_row)/2:(row+portrait_row)/2-1, (col-portrait_col)/2:(col+portrait_col)/2-1, :)); % 第一帧为背景
    start_mov = first_frame;
    start_mov((row-portrait_row)/2:(row+portrait_row)/2-1, (col-portrait_col)/2:(col+portrait_col)/2-1, :) = portrait_part + pic_part;
    [y,u,v] = rgbtoyuv420(start_mov);
    %输出到文件中
    for i1 = 1:row 
       fwrite(fout, y(i1,:));  
    end
    for i1 = 1:row/2
       fwrite(fout, u(i1,:));  
    end
    for i1 = 1:row/2
       fwrite(fout, v(i1,:)); 
    end
%     out_rgb(1:logo_row, 1:logo_col, :, frame) = (frame/length)*logo(:,:,:) + (1-frame/length) * out_rgb(1:logo_row, 1:logo_col, :, frame);
end
% % 处理视频
for frame = 1:length
    logo_part = 0.3*logo(:,:,:);
    pic_part = uint8(0.7 * out_rgb(row-logo_row+1:row, col-logo_col+1:col, :, frame));
    out_rgb(row-logo_row+1:row, col-logo_col+1:col, :, frame) = logo_part + pic_part;
    [y, u, v] = rgbtoyuv420(out_rgb(:,:,:,frame));
    %输出到文件中
    for i1 = 1:row 
       fwrite(fout, y(i1,:));  
    end
    for i1 = 1:row/2
       fwrite(fout, u(i1,:));  
    end
    for i1 = 1:row/2
       fwrite(fout, v(i1,:)); 
    end
end
    
fclose(fout);



