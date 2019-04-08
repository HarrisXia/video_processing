%%
%% XiaHan 2017229025
%%
clear
clc
fid = fopen('funfair.cif','rb');
fout = fopen('output.cif','w');
row = 288;  % ��Ƶ��С
col = 352;
length_start = 25;  % ���˽��ܵĳ���Ϊ25֡
length = 250;    % ת������Ƶ����
rgb = zeros(row, col, 3, length);

% �����ļ�����ת��ΪRGB��ʽ
for frame=1:length
    im_l_y = zeros(row,col); %Y
    % ����ʱ��YUV��ͬͨ������ʽ��ͬ
    for i1 = 1:row 
       im_l_y(i1,:) = fread(fid,col);  %��ȡ���ݵ������� 
    end

    im_l_cb = zeros(row/2,col/2); %cb
    for i2 = 1:row/2 
       im_l_cb(i2,:) = fread(fid,col/2);  
    end

    im_l_cr = zeros(row/2,col/2); %cr
    for i3 = 1:row/2 
       im_l_cr(i3,:) = fread(fid,col/2);  
    end
    % ���ú�������ת��
    rgb(:, :, :, frame) = yuv420torgb(im_l_y, im_l_cb, im_l_cr);
end

    
logo_file = imread('logo.jpg');  % ��ȡУ��ͼƬ
logo = imresize(logo_file,0.05);   % ͼƬ��С
[logo_row, logo_col] = size(logo(:,:,1));
portrait_file = imread('portrait.jpg');  % ��ȡ������ƬͼƬ
portrait = imresize(portrait_file,0.2);   % ͼƬ��С
[portrait_row, portrait_col] = size(portrait(:,:,1));

out_rgb = rgb;

first_frame = out_rgb(:, :, :, 1);
% ��ͷ25֡չʾ������Ϣ��ͼ������ʧ
for frame = 1:length_start
%     ����Ƭ��д�������Ϣ
    ti=vision.TextInserter('Xia Han', 'Location', [20 90], 'FontSize', 8, 'Color',[1 0 0]);
    portrait=step(ti,portrait);
    ti=vision.TextInserter('2017229025', 'Location', [25 100],'FontSize', 6, 'Color',[1 0 0]);
    portrait=step(ti,portrait);
%     ����Ƭ���룬������ʧ
    portrait_part = (1-frame/length_start) * portrait(:,:,:);
    pic_part = uint8((frame/length_start) * first_frame((row-portrait_row)/2:(row+portrait_row)/2-1, (col-portrait_col)/2:(col+portrait_col)/2-1, :)); % ��һ֡Ϊ����
    start_mov = first_frame;
    start_mov((row-portrait_row)/2:(row+portrait_row)/2-1, (col-portrait_col)/2:(col+portrait_col)/2-1, :) = portrait_part + pic_part;
    [y,u,v] = rgbtoyuv420(start_mov);
    %������ļ���
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
% % ������Ƶ
for frame = 1:length
    logo_part = 0.3*logo(:,:,:);
    pic_part = uint8(0.7 * out_rgb(row-logo_row+1:row, col-logo_col+1:col, :, frame));
    out_rgb(row-logo_row+1:row, col-logo_col+1:col, :, frame) = logo_part + pic_part;
    [y, u, v] = rgbtoyuv420(out_rgb(:,:,:,frame));
    %������ļ���
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



