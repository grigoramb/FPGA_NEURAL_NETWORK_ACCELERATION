clear; clc;
load NN.mat;
load testSet.mat;

% show the 1st sample
% imshow(reshape(testData(:,1),28,28));


% Part A
% Compute the number of all connections between different nodes in the network.
% Input Nodes: 784
% Layer 1: 200
% Layer 2: 200
% Output:  10

connections = 784*200 + 200*200 + 200*10;
%disp('Number of connections = ');
%disp(connections);


% Part B
% With IEEE 754 double precision:
%disp('Required memory for double precision in MB');
% 64 bit
doublemem = connections * 64; % in bits
doublemem = doublemem/8; % bytes
doublemem = doublemem/(2^20); % megabytes
%disp(doublemem);

%disp('Required memory for single precision in MB');
% 32 bit
%disp(doublemem/2);
testData = round(testData);

% testData = reshape(testData,28,28,10000);
% testData(1:4,:,:) = 0;
% testData(25:28,:,:) = 0;
% testData(:,24:28,:) = 0;
% testData(:,1:6,:) = 0;
% testData = reshape(testData,784,10000);

% scale = 8;
% top = 5;
% bot = 24;
% left = 7;
% right = 24;

scale = 8;
top = 5;
bot = 24;
left = 7;
right = 24;


newsize = (bot-top+1)*(right-left+1)

finalW1L1 = round(finalW1L1*scale);
finalW1L2 = round(finalW1L2*scale);
finalSoftmaxTheta = round(finalSoftmaxTheta*scale);
finalB1L1 = round(finalB1L1*scale);
finalB1L2 = round(finalB1L2*scale);

newW1L1 = reshape(finalW1L1,200,28,28);
newW1L1 = newW1L1(:,top:bot,left:right); % remove some rows
newW1L1 = reshape(newW1L1,200,newsize);

newtestData = reshape(testData,28,28,10000);
newtestData = newtestData(top:bot,left:right,:);
newtestData = reshape(newtestData,newsize,10000);


newconnections = newsize*200 + 200*200 + 200*10  + 200 + 200 + 10;
eightbitmem = (newconnections * 8)/8/(2^10);
%disp('Required memory for our implementation in KB');
%disp(eightbitmem);
tic
correct = 0;
prediction = zeros(1,10000);
for i = [1:10000]
   % showdigit(i,testData); 
   prediction(i) = detectdigit( newtestData(:,i), finalB1L1, finalB1L2, finalSoftmaxTheta, newW1L1, finalW1L2 );
   if(prediction(i) == testLabels(i))
       correct = correct + 1;
   else
       %showdigit(i,newtestData);
   end
end

accuracy = correct/i
toc
