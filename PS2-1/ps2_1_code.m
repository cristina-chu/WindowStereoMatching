%Cristina Chu
%PS2
%Part 1

%Getting images
leftTest = imread('leftTest.png');
rightTest = imread('rightTest.png');

%Variables
windowSize = 3;             
disparityRange = 5;
pad = disparityRange + windowSize;

%Padding images
leftPad = padarray(leftTest, [pad, pad]);
rightPad = padarray(rightTest, [pad, pad]);

%1.a Left Disparity
%i.e Left = template, Right = target

%create zeros array for disparity image
disparityLeft = zeros(size(leftTest));
sizeRow = size(leftTest, 1);
sizeColumn = size(leftTest, 2);      

%SSD algorithm
for row = 1+pad:sizeRow-1-pad       %go through actual image, not padding
    for column = 1+pad:sizeColumn-1-pad
        
        ssdArray = zeros(disparityRange*2+1,1);
        minSSD = 1.0e+100;
        template = int32(leftPad(row-windowSize:row+windowSize, column-windowSize:column+windowSize));  %check neighborhood of windowSize
        
        for offset = column-disparityRange:column+disparityRange
            target = int32(rightPad(row-windowSize:row+windowSize, offset-windowSize:offset+windowSize));
            sqdiff = (target-template).^2;
            sumsq = sum(sqdiff(:));
            
            %Always keeping minimum match cost
            if (sumsq < minSSD)   
                minSSD = sumsq;
                currentDisparity = abs(column-offset);
            end
            
            ssdArray(offset-column+disparityRange+1) = sum(sqdiff(:));
            
        end
        
        minIndex = find(ssdArray == min(ssdArray));
        disparityLeft(row,column) = currentDisparity;
        
    end
end

%final image
final1 = uint32(disparityLeft*255 / max(disparityLeft(:)));
figure(1);
image(final1(pad:sizeRow-pad, pad:sizeColumn-pad));


%1.a Right Disparity
%i.e. Right = template, Left = target

%create zeros array for disparity image
disparityRight = zeros(size(rightTest));
sizeRow = size(rightTest, 1);
sizeColumn = size(rightTest, 2);


%SSD algorithm
for row = 1+pad:sizeRow-1-pad       %go through actual image, not padding
    for column = 1+pad:sizeColumn-1-pad
        
        ssdArray = zeros(disparityRange*2+1,1);
        minSSD = 1.0e+100;
        template = int32(rightPad(row-windowSize:row+windowSize, column-windowSize:column+windowSize));  %check neighborhood of windowSize
        
        for offset = column-disparityRange:column+disparityRange
            target = int32(leftPad(row-windowSize:row+windowSize, offset-windowSize:offset+windowSize));
            sqdiff = (target-template).^2;
            sumsq = sum(sqdiff(:));
            
            %Always keeping minimum match cost
            if (sumsq < minSSD)   
                minSSD = sumsq;
                currentDisparity = abs(column-offset);
            end
            
            ssdArray(offset-column+disparityRange+1) = sum(sqdiff(:));
            
        end
        
        minIndex = find(ssdArray == min(ssdArray));
        disparityRight(row,column) = currentDisparity;
        
    end
end

%final image
final2 = uint32(disparityRight*255 / max(disparityRight(:)));
figure(2);
image(final2(pad:sizeRow-pad, pad:sizeColumn-pad));

%Plot disparities
figure(3)
surf(double(final1), double(final2));
figure(4)
surf(double(final1)-double(final2));