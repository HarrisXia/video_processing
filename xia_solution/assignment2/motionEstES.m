% Computes motion vectors using exhaustive search method.
% Input
%   imgP : The image for which we want to find motion vectors
%   imgI : The reference image
%   mbSize : Size of the macroblock
%   p : Search parameter
%
% Ouput
%   motionVect : the motion vectors for each integral macroblock in imgP

function motionVect = motionEstES(imgP, imgI, mbSize, p)

[row, col] = size(imgI);
costs = ones(2*p + 1, 2*p +1) * 65537;

ii=1;
for i = 1 : mbSize : row-mbSize+1
    jj=1;
    for j = 1 : mbSize : col-mbSize+1        
       
        for m = -p : p
            for n = -p : p
                refBlkVer = i + m;   % row/Vert co-ordinate for ref block
                refBlkHor = j + n;   % col/Horizontal co-ordinate
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;
                end
                costs(m+p+1,n+p+1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);       
            end
        end
        
        % Now we find the vector where the cost is minimum
        % and store it ... this is what will be passed back.      
        [dx, dy, ~] = minCost(costs); % finds which macroblock in imgI gave us min Cost
        v(ii,jj,1)=dy-p-1;    % row co-ordinate for the vector
        v(ii,jj,2)=dx-p-1;    % col co-ordinate for the vector
        costs = ones(2*p + 1, 2*p +1) * 65537;   
        jj = jj+1;
    end
    ii = ii+1;
end
%%{
% hfig = figure(1);
subplot(1,2,1);
quiver(v(:,:,1),v(:,:,2));
colormap('default');              
axis ij;
axis tight;
axis equal;
subplot(1,2,2);
imshow(uint8(imgI));         
% set(hfig, 'position', get(0,'ScreenSize'));
%}
motionVect = v;

