function imageReconstructed = decoder(bitStream, data, loss, info, u, iqtMatrix, T, m, n)
decodedStream = huffdecode(bitStream, info, data);   %����Huffman���������н�ѹ��  
k=1;  
for i=1:n
    for j=1:m      
        decodedImage(i,j)=decodedStream(k);    
        k=k+1;     
    end
end
decodedImage= decodedImage';

decodedImage = (double(decodedImage) - 1 + loss).*u;     

image = blkproc(decodedImage,[8 8],'x.*P1',iqtMatrix); %������ 
imageReconstructed = uint8(blkproc(image,[8 8],'P1*x*P2',T',T)); 

