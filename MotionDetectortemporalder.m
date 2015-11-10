%Computer Vision Project
%Neil Dave
% Part B (i) TEMPORAL DERIVATIVE

clear all
close all
imtool close all

images = zeros(288,384,3,485,'uint8');
imagestacktemptemp = zeros(288,384,485,'uint8');
for i = 0:9
    images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Desktop\\Enter Exit Crossing\\EnterExitCrossingPaths2cor000%d.jpg',i));
end

for i = 10:99
    images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Desktop\\Enter Exit Crossing\\EnterExitCrossingPaths2cor00%d.jpg',i));
end

for i = 100:484
    images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Desktop\\Enter Exit Crossing\\EnterExitCrossingPaths2cor0%d.jpg',i));
end

for n = 1:485
    imagestacktemp(:,:,n) = rgb2gray(images(:,:,:,n));
end


imtool(imagestacktemp(:,:,2))
imtool(imagestacktemp(:,:,5))

derkernel = [-1, 0, 1];
mask = zeros(288,384,485);

der = 0;

derarray = zeros(288,384,485);
threshold = 5;

for x = 1:288
    for y = 1:384
        for n = 2:484
            
            %calculate derivative at each point, and threshold to create
            %mask
   
            der = abs(double(imagestacktemp(x,y,n-1))*derkernel(1) + double(imagestacktemp(x,y,n))*derkernel(2) + double(imagestacktemp(x,y,n+1))*derkernel(3));
           
           
            if der < threshold
                mask(x,y,n) = 0;
            else
                mask(x,y,n) = 1;
            end
            
        end
    end
end

%apply mask

for x = 1:288
    for y = 1:384
        for n = 2:484
            if mask(x,y,n) == 1
                imagestacktemp(x,y,n) = 255;
            end
        end
    end
end

 imtool(imagestacktemp(:,:,2))
 imtool(imagestacktemp(:,:,5))
 