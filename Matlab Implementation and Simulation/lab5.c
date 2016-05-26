#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>


int main(){
    double b1[200], b2[200];
    
    double WF[200][10], W1[784][200],W2[200][200];
    // double testData[10000][784];
    // int testLabels[10000];
    
    int i;
    

    // Read b1 and b2
    FILE* fb1 = fopen("b1.txt","r");
    FILE* fb2 = fopen("b2.txt","r");
    fread(b1,sizeof(double),200,fb1);
    fread(b2,sizeof(double),200,fb2);
    fclose(fb1);
    fclose(fb2);

    // Read w1 and w2 and wf
    FILE* fw1 = fopen("w1.txt","r");
    FILE* fw2 = fopen("w2.txt","r");
    FILE* fwf = fopen("wf.txt","r");
    for(i = 0; i < 784; i++)
        fread(W1[i],sizeof(double),200,fw1);
    for(i = 0; i < 200; i++){
        fread(W2[i],sizeof(double),200,fw2);
        fread(WF[i],sizeof(double),10,fwf);
    }

    fclose(fw1);
    fclose(fw2);
    fclose(fwf);
    // Index starts at 0 instead of 1 
    /*
    printf("%lf ", W1[2][3]);
    printf("%lf ", W2[2][3]);
    printf("%lf ", WF[2][3]);
    */
  

    // for each sample
    // predict digit
    //      layer 1, 2, 3
    //          for each node
    //              val = bias
    //              for each weight
    //                     add weight*input[i]
    //              sigmoid
    
    FILE* data = fopen("data.txt", "r");
    FILE* labels = fopen("labels.txt", "r");

    char sample[784];
    char label;
    double temp, max;
    double layer1[200];
    double layer2[200];
    double output[10];
    int j, node, result, index, correct = 0;
    
    for(i = 0; i < 10000; i++){
        fread(sample,sizeof(char),784,data);
        fread(&label,sizeof(char),1,labels);
        
        for(node = 0; node < 200; node++){
            temp = b1[node];
            for(j = 0; j < 784; j++){
                // W1[pixel][nodeL1]
                temp += W1[j][node] * (double)sample[j];
            }
            temp = 1/(1+exp(-temp));
            layer1[node] = temp;
        }
        for(node = 0; node < 200; node++){
            temp = b2[node];
            for(j = 0; j < 200; j++){
                temp += W2[j][node] * layer1[j];
            }
            temp = 1/(1+exp(-temp));
            layer2[node] = temp;
            
        }
        for(node = 0; node < 10; node++){
            temp = 0;
            for(j = 0; j < 200; j++){
                temp += WF[j][node] * layer2[j];
            }
            temp = 1/(1+exp(-temp));
            output[node] = temp; 
        }
        max = 0;
        index = 0;
        for(j = 0; j < 10; j++){
            index = output[j] > max ? j : index;
            max = output[j] > max ? output[j] : max;
        }
        if(index + 1 == label){
            correct++;
        }
        else {
            printf("\n%d: %d: ", i, index+1);
            for(j = 0; j < 10; j++) {
                printf("%.3lf ", output[j]);
            }
                getchar();
        }
    }
    printf("%d ", correct);
    printf("\n%lf", correct/100.0);
}
