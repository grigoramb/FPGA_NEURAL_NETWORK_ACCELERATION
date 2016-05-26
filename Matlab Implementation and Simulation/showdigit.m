function [  ] = showdigit( x, testData )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   imshow(imresize(reshape(testData(:,x),20,18),20));
   pause(.2);
end

