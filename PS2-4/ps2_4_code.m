%Cristina Chu
%PS2
%Part 4

%--------1.a Normalized Correlation - Example 1---------------%
%Getting Images
leftTest = imread('leftTest.png');
rightTest = imread('rightTest.png');

%Variables
windowSize = 3;
disparityRange = 10;
pad = disparityRange + windowSize;

%Padding images
leftPad = padarray(leftTest, [pad, pad]);
rightPad = padarray(rightTest, [pad, pad]);

%--Left Disparity
disparityLeft = zeros(size(leftTest));
sizeRow = size(leftTest, 1);
sizeColumn = size(leftTest, 2);

%algorithm
for row = 1+pad:sizeRow-pad-1
    for column = 1+pad:sizeColumn-pad-1
        template = int32(leftPad(row-windowSize:row+windowSize, column-windowSize:column+windowSize));  %check neighborhood of windowSize
        target = int32(rightPad(row-windowSize:row+windowSize, pad:sizeColumn-pad));
        correlate = normxcorr2(template, target);
        
        correlateDisparity = max(correlate); %don't know what needs to be here
        disparityLeft(row, column) = correlateDisparity;
    end
end

%show left disparity
final1 = uint32(disparityLeft*255 / max(disparityLeft(:)));
figure(1);
image(final1);

% %--Right Disparity
% disparityRight = zeros(size(rightTest));
% sizeRow = size(rightTest, 1);
% sizeColumn = size(rightTest, 2);
% 
% %algorith
% 
% 
% %show right disparity
% final2 = uint32(disparityRight*255 / max(disparityRight(:)));
% figure(2);
% image(final2);


% %--------1.b Normalized Correlation - Example 2---------------%
% %Getting images
% leftTest = rgb2gray(imread('proj2-pair1-L.png'));
% rightTest = rgb2gray(imread('proj2-pair1-R.png'));
% 
% %Variables
% windowSize = 3;
% disparityRange = 110;
% pad = disparityRange + windowSize;
% 
% %Padding images
% leftPad = padarray(leftTest, [pad, pad]);
% rightPad = padarray(rightTest, [pad, pad]);



