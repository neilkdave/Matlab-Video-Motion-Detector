%Motion Detector Project

% Part A

im = imread('C:\Users\thearchitect\Desktop\Enter Exit Crossing\EnterExitCrossingPaths2cor0000.jpg');

images = zeros(288,384,3,485,'uint8');
imagestack = zeros(288,384,485,'uint8');
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
    imagestack(:,:,n) = rgb2gray(images(:,:,:,n));
end

%create mask of zeros and ones to add to image
%threshold abs value of derivatives to find motion
%derivative kernel
derkernel = [-1 0 1];
mask = zeros(288,384,20);
der = 0;

for x = 1:288
    for y = 1:384
        for n = 2:19
   
            mask(x,y,n) = abs(imagestack(x,y,n-1)*derkernel(1) + imagestack(x,y,n)*derkernel(2) + imagestack(x,y,n+1)*derkernel(3));
            
        end
    end
end