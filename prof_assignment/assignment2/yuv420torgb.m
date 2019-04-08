function rgb = yuv420torgb(y,u,v)
y = double(y);
% double YuvToRgb[3][3] = {1,       0,  1.4022,
%                          1,    -0.3456, -0.7145,
%                          1,   1.771,       0};
uu=kron(double(u), ones(2,2)) - 128;
vv=kron(double(v), ones(2,2)) - 128;
rgb(:,:,1) = uint8(y + 1.4022*vv);
rgb(:,:,2) = uint8(y - 0.3456*uu -0.7145*vv);
rgb(:,:,3) = uint8(y + 1.771*uu);
