inputPattern = zeros([1 101]);
inputPattern(51) = 1;
for i=0:255 
    pattern = elementaryCA(i, 101, 50, inputPattern);
    address = 'C:\fig\';
    address=strcat(address, int2str(i),'.tif');
    imwrite(pattern, address, 'tif');
end