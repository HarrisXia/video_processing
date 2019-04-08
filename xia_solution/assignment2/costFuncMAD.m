% Finds the indices of the cell that holds the minimum cost
% Input
%       currentBlk : The block for which we are finding the MAD
%       refBlk : the block with regard to which the MAD is being computed
%       n : the side of the two square blocks
%
% Output
%       cost : The MAD for the two blocks

function cost = costFuncMAD(currentBlk,refBlk, n)


err = 0;
for i = 1:n
    for j = 1:n
        err = err + abs((currentBlk(i,j) - refBlk(i,j)));
    end
end
cost = err / (n*n);

