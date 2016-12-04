#include<stdio.h>
#include <omp.h>
#include <armadillo>
int main(int argc,char** argv){
    int i;
    int nthreads=1;
    if(argc>=2){
        nthreads = atoi(argv[1]);
    }
    arma::vec A(10);
    
    omp_set_num_threads(nthreads);
    printf("Number of threads : %d\n",nthreads);
    #pragma omp parallel for 
    for(i=0;i<10;i++){
        A(i) = i+100;
        printf("%d\n",i+100); 
    }
    return 0 ;
}

