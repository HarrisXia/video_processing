
im = imread('portrait.jpg');
fid = fopen('funfair.cif','r');
fod = fopen('output1.cif','w');
row=288;col=352; %图像的高、宽
im = imresize(im,[row, col]);
frames=250; % total=97 %序列的帧数
myphoto_frames=25;

for frame=1:myphoto_frames
 

    %im_l = ycbcr2rgb(uint8(im_l_ycbcr)); 
    ti=vision.TextInserter('XiaHan', 'Location', [130 200],'FontSize', 30);
    J=step(ti,im);
    ti=vision.TextInserter('2017229025', 'Location', [130 240],'FontSize', 20);
    J=step(ti,J);
    [im_y,im_cb,im_cr] = rgbtoyuv420(im);%将rgb转换为YCbCr

    for i1 = 1:row 
       fwrite(fod,im_y(i1,:));  %输出到文件中
    end
    for i1 = 1:row/2
       fwrite(fod,im_cb(i1,:));  
    end
    for i1 = 1:row/2
       fwrite(fod,im_cr(i1,:)); 
    end
    
end

for frame=1:frames
 %读入文件 将yuv转换为rgb，并用imshow显示
  %  im_l_y=fread(fid,[row,col],'uchar');  %错误的读入
    im_l_y = zeros(row,col); %Y
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

    im_rgb = yuv420torgb(im_l_y, im_l_cb, im_l_cr);%将YCbCr转换为rgb
    
    

    for i1 = 1:row 
       fwrite(fod,im_l_y(i1,:));  %输出到文件中
    end
    
    for i1 = 1:row/2
       fwrite(fod,im_l_cb(i1,:));  
    end
    
    for i1 = 1:row/2
       fwrite(fod,im_l_cr(i1,:)); 
    end
end
fclose(fid)
fclose(fod)