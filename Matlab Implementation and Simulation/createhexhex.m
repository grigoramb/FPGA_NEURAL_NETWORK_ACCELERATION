fid = fopen('layer1.hex','wt');

for i = [1:200]
   fprintf(fid,'%x,\n',typecast(int8(finalB1L1(i)),'uint8'))
   fprintf(fid,'%x,\n',typecast(int8(newW1L1(i,:)),'uint8'))
%    fprintf(fid,'%x,\n',typecast(int8(1),'uint8'))
%    fprintf(fid,'%x,\n',typecast(int8(0*newW1L1(i,:)),'uint8'))
end

fclose(fid)

fid = fopen('layer1','wt');
for i = 1:200
    fwrite(fid, int8(finalB1L1(i)),'integer*1');
    for j = 1:360
        fwrite(fid, int8(newW1L1(i,j)), 'integer*1');
    end
end
fclose(fid);


fid = fopen('sample.hex','wt');
for i = 1:8:360
   x = newtestData(i:i+7,3052)'*(2.^[0:7])';
   fprintf(fid,'%x,\n',int8(x));
end

% sample 23
% 7,9,11,12,13, 17,18,19,20,21   23,24
fclose(fid)

% sample 6237 wrong nodes
% 00000000
% 00100100
% 00101100
% 00000000
% 00000000
% 00000000
% 00000000
% 00111000
% 00001000
% 00010000
% 01100000
% 01000001
% 10000100
% 00000000
% 10000000
% 00000000
% 00010000
% 00000100
% 00000000
% 00000000
% 00000100
% 00111100
% 01000000
% 00010000
% 00000000

%sample 3052 wrong nodes
% 00000000
% 00000100    3
% 01000000    
% 00000000
% 00000000
% 00000000
% 10000000
% 00000000
% 00000000
% 00100000
% 00000000
% 00001001
% 00100100
% 10000000
% 00000000
% 00000000
% 00010000
% 10000100
% 00000000
% 00000000
% 00000110
% 01000000
% 01111100
% 10000001
% 00000000