function [ prediction ] = detectdigit( data, finalB1L1, finalB1L2, finalSoftmaxTheta, finalW1L1, finalW1L2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %scale = 8;
    temp = (finalB1L1 + finalW1L1*data);
    layer1 = sigmoidL1(temp);
    temp = (finalB1L2 + finalW1L2*layer1);
    layer2 = sigmoidL2(temp);
    output = sigmoid(finalSoftmaxTheta*layer2)';
    %output = 1./(1 + exp(-finalSoftmaxTheta*layer2))
    [val, prediction] = max(output);
end

