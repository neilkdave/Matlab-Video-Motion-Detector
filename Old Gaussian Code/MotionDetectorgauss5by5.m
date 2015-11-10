%Motion Detector 
%Added 5x5 Gaussian Mask

clear all
close all
imtool close all

images = zeros(288,384,3,485,'uint8');
imagestacktemp = zeros(288,384,485,'uint8');

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
imtool(imagestacktemp(:,:,120))

gaussian = fspecial('gaussian',5,2);

% 3x3
for x = 3:286
    for y = 3:382
        for n = 1:485
            imagestacktemp(x,y,n) = imagestacktemp(x-2,y-2,n)*gaussian(1,1) + imagestacktemp(x-2,y - 1,n)*gaussian(1,2) + imagestacktemp(x-2,y,n)*gaussian(1,3) + imagestacktemp(x - 2,y + 1,n)*gaussian(1,4) + imagestacktemp(x - 2,y + 2,n)*gaussian(1,5) + imagestacktemp(x-1,y-2,n)*gaussian(2,1) + imagestacktemp(x-1,y - 1,n)*gaussian(2,2) + imagestacktemp(x-1,y,n)*gaussian(2,3) + imagestacktemp(x -1,y + 1,n)*gaussian(2,4) + imagestacktemp(x - 1,y + 2,n)*gaussian(2,5) + imagestacktemp(x,y-2,n)*gaussian(3,1) + imagestacktemp(x,y - 1,n)*gaussian(3,2) + imagestacktemp(x,y,n)*gaussian(3,3) + imagestacktemp(x,y + 1,n)*gaussian(3,4) + imagestacktemp(x,y + 2,n)*gaussian(3,5) + imagestacktemp(x + 1,y-2,n)*gaussian(4,1) + imagestacktemp(x+1,y - 1,n)*gaussian(4,2) + imagestacktemp(x+1,y,n)*gaussian(4,3) + imagestacktemp(x +1,y + 1,n)*gaussian(4,4) + imagestacktemp(x +1,y + 2,n)*gaussian(4,5) + imagestacktemp(x+2,y-2,n)*gaussian(5,1) + imagestacktemp(x+2,y - 1,n)*gaussian(5,2) + imagestacktemp(x+2,y,n)*gaussian(5,3) + imagestacktemp(x + 2,y + 1,n)*gaussian(5,4) + imagestacktemp(x + 2,y + 2,n)*gaussian(5,5);
        end
    end
end
imtool(imagestacktemp(:,:,60))
imtool(imagestacktemp(:,:,120))

derkernel = [-0.5, 0, 0.5];
mask = zeros(288,384,485);

der = 0;

derarray = zeros(288,384,485);
threshold = 5;

for x = 1:288
    for y = 1:384
        for n = 2:484
            
            %calculate derivative at each point, and threshold to create
            %mask
   
%             der = abs(double(imagestacktemp(x,y,n-1))*derkernel(1) + double(imagestacktemp(x,y,n))*derkernel(2) + double(imagestacktemp(x,y,n+1))*derkernel(3));
            % derarray(x,y,n) = abs(double(imagestacktemp(x,y,n-1))*derkernel(1) + double(imagestacktemp(x,y,n))*derkernel(2) + double(imagestacktemp(x,y,n+1))*derkernel(3));

for d = -1:1
derarray(x,y,n) = derarray(x,y,n) + double(imagestacktemp(x,y,n + d))*derkernel(d+2);
end     
 derarray(x,y,n) = abs(double(derarray(x,y,n)));
%             if der < threshold
%                 mask(x,y,n) = 0;
%             else
%                 mask(x,y,n) = 1;
%             end

            if derarray(x,y,n) < threshold
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
 imtool(imagestacktemp(:,:,120))
 