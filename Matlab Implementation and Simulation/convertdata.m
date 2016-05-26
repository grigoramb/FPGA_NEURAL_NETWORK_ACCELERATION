clear; clc;
load NN.mat;
load testSet.mat;

fid_BL1 = fopen('b1.txt','wt');
fid_BL2 = fopen('b2.txt','wt');


%fprintf(fid_BL1,'%x\n',finalB1L1);
fwrite(fid_BL1, finalB1L1, 'double');
fwrite(fid_BL2, finalB1L2, 'double');

fclose(fid_BL1);
fclose(fid_BL2);




fid_WL1 = fopen('w1.txt','wt');
fid_WL2 = fopen('w2.txt','wt');
fid_WF = fopen('wf.txt','wt');


% COLUMN MAJOR
fwrite(fid_WL1, finalW1L1, 'double');
fwrite(fid_WL2, finalW1L2, 'double');
fwrite(fid_WF,  finalSoftmaxTheta, 'double');


fclose(fid_WL1);
fclose(fid_WL2);
fclose(fid_WF);

fid_data = fopen('data.txt','wt');
fid_labels = fopen('labels.txt','wt');

fwrite(fid_data, uint8(testData), 'uint8')
fwrite(fid_labels, uint8(testLabels), 'uint8')



