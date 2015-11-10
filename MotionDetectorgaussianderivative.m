%Motion Detector Project
%Neil Dave
% 1D Derivative of Gaussian
%Generates Gaussian Kernel based on value entered for tsigma

clear all
close all
imtool close all

%Very high standard deviation to emphasize area of target, not shape
tsigma = 5;

%Create empty image stack
images = zeros(288,384,3,485,'uint8');

%Read in images and assign them to the stack
for i = 0:9
    images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Documents\\MATLAB\\Computer Vision\\Project 1\\Enter Exit Crossing\\EnterExitCrossingPaths2cor000%d.jpg',i));
end

for i = 10:99
    images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Documents\\MATLAB\\Computer Vision\\Project 1\\Enter Exit Crossing\\EnterExitCrossingPaths2cor00%d.jpg',i));
end

for i = 100:484
    images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Documents\\MATLAB\\Computer Vision\\Project 1\\Enter Exit Crossing\\EnterExitCrossingPaths2cor0%d.jpg',i));
end

%Convert to grayscale
for n = 1:485
    imagestackdergauss(:,:,n) = rgb2gray(images(:,:,:,n));
end

%Display two sample image slices in figures 1 and 2
imtool(imagestackdergauss(:,:,30))
imtool(imagestackdergauss(:,:,120))

%Creates an odd or even gaussian kernel based on modulus of standard dev
if mod(round(tsigma),2) == 1; 
%odd case, empty kernel generated then populated by gaussian function between frames    
gdkernel = zeros(1, round(5*tsigma));
gdminkernel = ones(1, round(5*tsigma));
for x = -floor(2.5*tsigma):floor(2.5*tsigma)
    gdkernel(x + floor(2.5*tsigma) + 1) = (-x*exp(-(x*x)/(2*(tsigma*tsigma))))/(tsigma*tsigma);    
end

else    
 %even case, same deal
gdkernel = zeros(1, round(5*tsigma+1));
gdminkernel = ones(1, round(5*tsigma+1));

 for x = -(floor(2.5*tsigma)):floor(2.5*tsigma)
    gdkernel(x + floor(2.5*tsigma) + 1) = (-x*exp(-(x*x)/(2*(tsigma*tsigma))))/(tsigma*tsigma);    
end
end

s = size(gdkernel);
%Takes magnitude of all nonzero values, if statement used to improve speed
for x = 1:s(2)
    if gdkernel(x) ~= 0
        gdminkernel(x) = abs(gdkernel(x));
    end
end

gdmin = min(gdminkernel);
gdkernel = gdkernel/gdmin; 
gdminkernel = gdminkernel/min(gdminkernel);
gdminkernel(floor(2.5*tsigma)+1) = 0;
gdsum = sum(gdminkernel);
gdkernel = gdkernel/gdsum;

%Create motion mask
mask = zeros(288,384,485);

der = 0;
 dummy = zeros(288,384,485);
derarray = zeros(288,384,485);
threshold = 7;
gder = 0;

for x = 1:288
    for y = 1:384
 for n = floor(2.5*tsigma + 1):(484 - floor(2.5*tsigma))
        
     for d = -floor(2.5*tsigma):floor(2.5*tsigma)
      dummy(x,y,n) = dummy(x,y,n) + double(imagestackdergauss(x,y,n + d))*gdkernel(d + floor(2.5*tsigma) + 1);
     end
     dummy(x,y,n) = abs(dummy(x,y,n));

           %If the gaussian derivative values between frames is greater
           %than threshold at pixel location, then that location is active
            if dummy(x,y,n) < threshold
                mask(x,y,n) = 0;
            else
                mask(x,y,n) = 1;
            end
            
        end
    end
end

% apply mask

for x = 1:288
    for y = 1:384
        for n = 2:484
            if mask(x,y,n) == 1
                imagestackdergauss(x,y,n) = 255;
            end
        end
    end
end

%show output images in figures 3 and 4
 imtool(imagestackdergauss(:,:,30))
 imtool(imagestackdergauss(:,:,120))
 