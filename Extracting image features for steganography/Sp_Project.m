%setup ;
mainIm=imread('Lyrica.jpg');
%SampleTxt='Hello World';

% H1=lbp(mainIm);
% pattern = elementaryCA(30, 256, 5, H1);
% cipher= xor(pattern(5,:),SampleTxt)



    %[frames,descrs] = getFeatures(mainIm,'peakThreshold', 0.01) ;
    %str=int2str(t);
    %name=strcat('frames',str,'.mat');
    %save(name,'frames');
    %name2=strcat('descrs',str,'.mat');
    %save(name2,'descrs');
    for i=1:16 
        T{i}=siftkey((i-1)*8+1:i*8,1); 
    end
    