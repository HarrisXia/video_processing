% Computes motion compensated image using the given motion vectors
%
% Input
%   imgI : The reference image 
%   motionVect : The motion vectors
%   mbSize : Size of the macroblock
%
% Ouput
%   imgComp : The motion compensated image
%
function imgComp = motionComp(imgI, motionVect, mbSize)

[row, col, ~] = size(imgI);

ii=1;
for i = 1:mbSize:row-mbSize+1
    jj=1;
    for j = 1:mbSize:col-mbSize+1
        
        % dy is row(vertical) index
        % dx is col(horizontal) index
        % this means we are scanning in order

        dy = motionVect(ii,jj,1);
        dx = motionVect(ii,jj,2);
        refBlkVer = i + dy;
        refBlkHor = j + dx;
        imageComp(i:i+mbSize-1,j:j+mbSize-1,:) = imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1,:);
        jj = jj+1;
    end
    ii = ii+1;
end
imgComp = imageComp;