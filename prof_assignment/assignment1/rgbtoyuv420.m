function [y u v] = rgbtoyuv420(x)
% note: components should be converted into double float for
% calculation. Otherwise, the conversion is not correct

R = double(x(:,:,1));
G = double(x(:,:,2));
B = double(x(:,:,3));

y =  uint8(R*0.2989  + G*0.5866  + B*0.1145);
uu = double(uint8(R*(-0.1688) + G*(-0.3312) + B*0.5000 + 128));
vv = double(uint8(R*0.5000  + G*(-0.4184) + B*(-0.0816) + 128));
u = uint8( ( uu(1:2:end, 1:2:end) + uu(1:2:end, 2:2:end) + uu(2:2:end, 1:2:end) + uu(2:2:end, 2:2:end) )/4);
v = uint8( ( vv(1:2:end, 1:2:end) + vv(1:2:end, 2:2:end) + vv(2:2:end, 1:2:end) + vv(2:2:end, 2:2:end) )/4);