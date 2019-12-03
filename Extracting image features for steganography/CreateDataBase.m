function []=CreateDataBase()

%this function calculate the frames and descriptor for database
%and save them in the folder for loading in the test phase

setup ;

DBTest   = fullfile(toolboxdir('vision'), 'test1');
DBSet = imageSet(DBTest, 'recursive');
%numImages = DBSet.Count;

for t = 1:1236
    % Get the feature for another image
    im = read(DBSet ,t);
    [frames,descrs] = getFeatures(im,'peakThreshold', 0.01) ;
    str=int2str(t);
    name=strcat('frames',str,'.mat');
    save(name,'frames');
    name2=strcat('descrs',str,'.mat');
    save(name2,'descrs');
end
