#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <ctype.h>
#include <string.h>

#define SDRAM_BASE		0xc0000000
#define SDRAM_SPAN		0x40000000
#define SDRAM_OFST		0xC0000000
#define SDRAM_MASK		SDRAM_SPAN-1

#define HW_REGS_BASE		0xfc000000
#define HW_REGS_SPAN		0x04000000
#define HW_REGS_MASK		HW_REGS_SPAN-1
#define ALT_LWFPGASLVS_OFST	0xff200000

#define LAYER1KERNEL		0x0
#define LAYER2KERNEL		0x20000
#define SAMPLES			0x14000

#define LAYER1RESULTS		0x1C000
#define LAYER2RESULTS		0x1E000

#define DONE			0xA0
#define READY			0xC0
#define DONE2			0xF0
#define READY2			0xB0

void computation(char* result, signed char *WF, signed char *testLabels, void*, void*, void*, void*, char* samples);

void layer3fun(signed char *WF, short* output, signed char * result){
	int node, j;
	short temp;
	for(node = 0; node < 10; node++){
            temp = 0;
            for(j = 0; j < 200; j++){
		if(result[j/8] & (1 << j % 8))
	        	temp += WF[j*10+node];	
		
            }
            output[node] = temp; 
        }
};


int main(){

    signed char * WF;
    char testLabels[400];
   
    unsigned char * layer1kernel;
    unsigned char * layer2kernel;
    unsigned char * result;
    unsigned char * samples;
    
    int i;
    void * VA;
    void * LW;
    int fd;
  
    char * sdram;

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

    LW = mmap(NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE), MAP_SHARED, fd, HW_REGS_BASE);

    if(LW == MAP_FAILED){
       printf("ERROR2\n");
       close(fd);
       return(1);
    }

    void * done, *ready, *done2, *ready2;

    done = LW + ((unsigned long)(ALT_LWFPGASLVS_OFST + DONE) & (unsigned long)(HW_REGS_MASK));
    ready = LW + ((unsigned long)(ALT_LWFPGASLVS_OFST + READY) & (unsigned long)(HW_REGS_MASK));
    done2 = LW + ((unsigned long)(ALT_LWFPGASLVS_OFST + DONE2) & (unsigned long)(HW_REGS_MASK));
    ready2 = LW + ((unsigned long)(ALT_LWFPGASLVS_OFST + READY2) & (unsigned long)(HW_REGS_MASK));

    result = (sdram) + LAYER2RESULTS;  
    samples = (sdram) + SAMPLES;
    layer1kernel = sdram + LAYER1KERNEL;
    layer2kernel = sdram + LAYER2KERNEL;
  
    WF = result + 0xA000000;
  
    printf("\nLoading to SDRAM.\n");
    clock_t start, end;
    start = clock();

    // Read layer 1 kernel
    FILE * l1k = fopen("layer1.bin","r");
    fread(layer1kernel,sizeof(char),(360)*201,l1k);

    // Read layer 2 kernel
    FILE * l2k = fopen("layer2.bin","r");
    fread(layer2kernel,sizeof(char),(200)*201,l2k);

    fclose(l1k);
    fclose(l2k);
 
    FILE * layer3 = fopen("layer3.bin","r");
  
    fread(WF,sizeof(char),2000,layer3);

    fclose(layer3);

    FILE * labels = fopen("labels.txt", "r");
    int templabel;
    for(i = 0 ; i < 400; i++){
        fscanf(labels,"%d",&templabel);
        testLabels[i] = (char)templabel;
    }
    fclose(labels);
    end = clock();

    double elapsed = (double)(end-start)/((double)(CLOCKS_PER_SEC));
    printf("Done Loading to SDRAM\n");
    printf("Time: %lf seconds\n",elapsed);
    
    computation(result, WF, testLabels, ready, done, ready2, done2, samples);

}

void prepsample(char* SDRAM, double* sample){
 
    int bytes = 0;
    int bits = 0;
    unsigned char byte = 0;
    int j,k;
    double temp3;
    int loaded = 0;
	for(j = 7; j <= 24; j++){ // read 18 cols   
	  for(k = 5; k <= 24; k++){  // read middle 20 rows
	      temp3 = sample[(j-1)*28 + k - 1];
	      byte = (byte>>1) | (unsigned char)(temp3+0.5) << 7;
	      bits++;
	      if(!(bits % 8))
			*(SDRAM + bytes++) = byte;
	  }
	}
	bytes++;
}


void computation(char* results, signed char *WF, signed char *testLabels, void* ready, void* done, void* ready2, void* done2, char* samples){

    char label;
    short temp, max;
    short output[10];
    int j, node, result, index, correct = 0;
    double elapsed; 
    int i;

    clock_t start, end;

    char filename[] = "XXX.txt";
    int pos = 2;
    double temp3;
    int k;
   
    double allsamples[400][28*28];

    int s; 

    start = clock();
    printf("Loading samples.\n");
    for(s = 1; s <= 400; s++){ // for each sample
       filename[2] = s%10 + '0';
       if(s >= 10){
         filename[1] = (s/10)%10 + '0';
         pos = 1;
       }
       if( s>= 100){
         filename[0] = (s/100)%10 + '0';
         pos = 0;
       }
       FILE * sample = fopen(filename+pos,"r");    
       for(i = 0; i < 28*28; i++)
          fscanf(sample,"%lf",&allsamples[s-1][i]);

       fclose(sample);
    }

    elapsed = ((double)(clock()-start))/CLOCKS_PER_SEC;  
    
    printf("\nLoaded 400 Samples\nElapsed: %lf  Time Per Sample: %lf\n",elapsed,elapsed/400);

    start = clock();

    int penguin;
    int loaded;

	printf("\nComputing!\n");
    for(penguin = 0; penguin < 4; penguin++){ 
        
		for(loaded = 0; loaded < 100; loaded++)
        	prepsample(samples + 46*loaded,allsamples[penguin*100 + loaded]);
	    
		*(char*)ready = 1;

    	for(i = 0; i < 100; i++){
    		label = testLabels[i+100*penguin];
        
    		while(*(unsigned char*)done2-1 < i); // Wait for Layer 2 to finish a sample

    		layer3fun(WF, output, results+i*26);
        
        	max = 0;
	        index = 0;
	        for(j = 0; j < 10; j++){
	           	index = output[j] > max ? j : index;
	           	max = output[j] > max ? output[j] : max;
	        }
	        if(index + 1 == label)
	           	correct++;
	    }

		*(char*)ready = 0;

    }

    elapsed = ((double)(clock()-start))/CLOCKS_PER_SEC; 
    printf("\nElapsed: %lf  Time Per Sample: %lf\n",elapsed,elapsed/(penguin*100));
    printf("%d/%d Correct\n", correct, (penguin*100));
    printf("\nAccuracy: %.2lf%%\n", correct/(penguin*1.0));
};


