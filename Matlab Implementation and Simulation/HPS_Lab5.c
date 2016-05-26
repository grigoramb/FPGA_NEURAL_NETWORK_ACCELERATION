#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <ctype.h>

#define SDRAM_BASE		0xc0000000
#define SDRAM_SPAN		0x40000000
#define SDRAM_OFST		0xC0000000
#define SDRAM_MASK		SDRAM_SPAN-1

int main(){

    double *b1, *b2;
    double *WF[200], *W1[784], *W2[200];
    double *testData[10000];
    int *testLabels;

    //double b1[200], b2[200];
    //double WF[200][10], W1[784][200],W2[200][200];
    // double testData[10000][784];
    // int testLabels[10000];
    
    int i;
    void *VA;
    int fd;
  
    double* sdram;



  if((fd = open( "/dev/mem", (O_RDWR | O_SYNC) ) ) == -1) {
    printf("ERROR\n");
    return(1);
  }
  VA = mmap(NULL, SDRAM_SPAN, ( PROT_READ | PROT_WRITE), MAP_SHARED, fd, SDRAM_BASE);


  if(VA == MAP_FAILED) {
    printf("VA ERROR\n");
    close(fd);
    return(1);
  }

  sdram = VA + ((unsigned long)(SDRAM_OFST +0x0) &(unsigned long)(SDRAM_MASK));

  b1 = sdram;
  b2 = b1 + 200;
  W1[0] = b2 + 200;
  for(i=1; i<784; i++){
	W1[i] =W1[i-1] + 200; 	
  }
  W2[0] = W1[783] + 200;
  for(i=1; i<200; i++){
	W2[i] =W2[i-1] + 200; 	
  }
  
  WF[0] = W2[199] + 200;
  for(i=1; i<200; i++){
	WF[i] =WF[i-1] + 10; 	
  }
  
  printf("Loading to SDRAM.\n");

  
 
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

   clock_t start, end;
   printf("Done Loading to SDRAM\n");
   start = clock();

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
    double elapsed; 
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
   	elapsed = ((double)(clock()-start))/CLOCKS_PER_SEC; 
		printf("\nelapsed: %lf  time per sample: %lf\n",elapsed,elapsed/i);
                //getchar();
        }
    }
    printf("%d ", correct);
    printf("\n%lf", correct/100.0);
}
