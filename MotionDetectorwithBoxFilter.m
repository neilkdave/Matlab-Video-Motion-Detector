%Computer Vision Project

% Part B (ii) Spatial Smoothing and Temporal Derivative

clear all
close all
imtool close all
folder_name = uigetdir();
folder_name = strrep(folder_name,'\','\\');
images = zeros(288,384,3,485,'uint8');
imagestackbox3 = zeros(288,384,485,'uint8');
imagestackbox5 = zeros(288,384,485,'uint8');
for i = 0:9
    images(:,:,:,i+1) = imread(sprintf(strcat(folder_name,'\\EnterExitCrossingPaths2cor000%d.jpg'),i));
end

for i = 10:99
    images(:,:,:,i+1) = imread(sprintf(strcat(folder_name,'\\EnterExitCrossingPaths2cor00%d.jpg'),i));
end

% for i = 100:484
%     images(:,:,:,i+1) = imread(sprintf(strcat(folder_name,'\\EnterExitCrossingPaths2cor0%d.jpg',i)));
% end
% for i = 0:9
%     images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Desktop\\Enter Exit Crossing\\EnterExitCrossingPaths2cor000%d.jpg',i));
% end
% 
% for i = 10:99
%     images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Desktop\\Enter Exit Crossing\\EnterExitCrossingPaths2cor00%d.jpg',i));
% end
% 
% for i = 100:484
%     images(:,:,:,i+1) = imread(sprintf('C:\\Users\\thearchitect\\Desktop\\Enter Exit Crossing\\EnterExitCrossingPaths2cor0%d.jpg',i));
% end

for n = 1:485
    imagestackbox3(:,:,n) = rgb2gray(images(:,:,:,n));
    imagestackbox5(:,:,n) = rgb2gray(images(:,:,:,n));
end


imtool(imagestackbox3(:,:,60))
imtool(imagestackbox3(:,:,120))

% 3x3 Box Filter
for x = 2:287
    for y = 2:383
        for n = 1:485
            imagestackbox3(x,y,n) = imagestackbox3(x-1,y-1,n)/9 + imagestackbox3(x-1,y,n)/9 + imagestackbox3(x-1,y+1,n)/9 + imagestackbox3(x,y-1,n)/9 + imagestackbox3(x,y,n)/9 + imagestackbox3(x,y+1,n)/9 + imagestackbox3(x+1,y-1,n)/9 + imagestackbox3(x+1,y,n)/9 + imagestackbox3(x+1,y+1,n)/9;
        end
    end
end
imtool(imagestackbox3(:,:,60))
imtool(imagestackbox3(:,:,120))

% 5x5 Box Filter
for x = 3:286
    for y = 3:382
        for n = 1:485
            imagestackbox5(x,y,n) = imagestackbox5(x-2,y-2,n)/25 + imagestackbox5(x-2,y - 1,n)/25 + imagestackbox5(x-2,y,n)/25 + imagestackbox5(x - 2,y + 1,n)/25 + imagestackbox5(x - 2,y + 2,n)/25 + imagestackbox5(x-1,y-2,n)/25 + imagestackbox5(x-1,y - 1,n)/25 + imagestackbox5(x-1,y,n)/25 + imagestackbox5(x -1,y + 1,n)/25 + imagestackbox5(x - 1,y + 2,n)/25 + imagestackbox5(x,y-2,n)/25 + imagestackbox5(x,y - 1,n)/25 + imagestackbox5(x,y,n)/25 + imagestackbox5(x,y + 1,n)/25 + imagestackbox5(x,y + 2,n)/25 + imagestackbox5(x + 1,y-2,n)/25 + imagestackbox5(x+1,y - 1,n)/25 + imagestackbox5(x+1,y,n)/25 + imagestackbox5(x +1,y + 1,n)/25 + imagestackbox5(x +1,y + 2,n)/25 + imagestackbox5(x+2,y-2,n)/25 + imagestackbox5(x+2,y - 1,n)/25 + imagestackbox5(x+2,y,n)/25 + imagestackbox5(x + 2,y + 1,n)/25 + imagestackbox5(x + 2,y + 2,n)/25;
        end
    end
end
imtool(imagestackbox5(:,:,60))
imtool(imagestackbox5(:,:,120))



derkernel = [-0.5, 0, 0.5];
mask3 = zeros(288,384,485);
mask5 = zeros(288,384,485);

der = 0;

derarray3 = zeros(288,384,485);
derarray5 = zeros(288,384,485);
threshold = 5;

for x = 1:288
    for y = 1:384
        for n = 2:484
            
            %calculate derivative at each point, and threshold to create
            %mask
   
%             der = abs(double(imagestackbox3(x,y,n-1))*derkernel(1) + double(imagestackbox3(x,y,n))*derkernel(2) + double(imagestackbox3(x,y,n+1))*derkernel(3));
            % derarray(x,y,n) = abs(double(imagestackbox3(x,y,n-1))*derkernel(1) + double(imagestackbox3(x,y,n))*derkernel(2) + double(imagestackbox3(x,y,n+1))*derkernel(3));

for d = -1:1
derarray3(x,y,n) = derarray3(x,y,n) + double(imagestackbox3(x,y,n + d))*derkernel(d+2);
derarray5(x,y,n) = derarray5(x,y,n) + double(imagestackbox5(x,y,n + d))*derkernel(d+2);
end     
 derarray3(x,y,n) = abs(double(derarray3(x,y,n)));
 derarray5(x,y,n) = abs(double(derarray3(x,y,n)));
%             if der < threshold
%                 mask(x,y,n) = 0;
%             else
%                 mask(x,y,n) = 1;
%             end

            if derarray3(x,y,n) < threshold
                mask3(x,y,n) = 0;
            else
                mask3(x,y,n) = 1;
            end
            
            if derarray5(x,y,n) < threshold
                mask5(x,y,n) = 0;
            else
                mask5(x,y,n) = 1;
            end
            
        end
    end
end

%apply mask3

for x = 1:288
    for y = 1:384
        for n = 2:484
            if mask3(x,y,n) == 1
                imagestackbox3(x,y,n) = 255;
            end
        end
    end
end

%apply mask5

for x = 1:288
    for y = 1:384
        for n = 2:484
            if mask5(x,y,n) == 1
                imagestackbox5(x,y,n) = 255;
            end
        end
    end
end

 imtool(imagestackbox3(:,:,60))
 imtool(imagestackbox3(:,:,120))
 
  imtool(imagestackbox5(:,:,60))
 imtool(imagestackbox5(:,:,120))
 