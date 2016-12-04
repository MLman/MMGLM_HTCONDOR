//============================================================================
// Name        : legr_core.cpp
// Author      : Hyunwoo J. Kim
//	           : Anmol Mohanty
// Version     : 0.5
// Date        : 2016/07/06 13:05:35 (CDT)
// Copyright   :
// Description :
//============================================================================

#include <armadillo>
#include <iostream>
#include <boost/filesystem.hpp>
#include <boost/filesystem/operations.hpp>
#include <boost/filesystem/path.hpp>
#include <fstream>
#include <omp.h>
#include <unistd.h>
#include "spd_funcs.h"
#include "mmglm_spd.h"

#define DIM_DTI 6
// Index of elements in save files
#define iDxx 0
#define iDxy 1
#define iDxz 2
#define iDyy 3
#define iDyz 4
#define iDzz 5
using namespace std;
//using namespace arma; //for the armadillo library, this is separate from boost
namespace fs=boost::filesystem; //namespace is being declared

int main(int argc, char** argv)
{
  //creating 3 paths named below
  fs::path input_dir;
  fs::path shared_dir;
  fs::path result_fname;

  unsigned logicalcpucount ;
  logicalcpucount = sysconf( _SC_NPROCESSORS_ONLN);
  int nthreads;

  printf("################################################\n");
  printf("###               MMGLM_SPD_PAR              ###\n");
  printf("################################################\n");
  printf("\n The number of cups is %d. \n",logicalcpucount);
  if(argc == 1 || argc >=6){
      cout<<"\n MMGLM_SPD_PAR performs MMGLMs on SPDs. " <<endl;
      cout<<" P_values are the significance for the last covariate controlling\n";
      cout<<" for all covariates except the _last_ one in \"Xs_arma.mat\"." <<endl<<endl;
      cout<<" Usage: " <<endl;
      cout<<"  >>> mmglm_spd_par $input_dir $shared_dir"
          " ($result_fname==p_value.txt)" << endl;
      cout<<"  >>> mmglm_spd_par $input_dir $shared_dir $result_fname " << endl;
      cout<<"  >>> mmglm_spd_par $input_dir $shared_dir $result_fname $num_threads" << endl;
      cout<<"\n ### Requirements ### "<<endl;
      cout<<"\n $input_dir/Ys_arma.mat\n $input_dir/mask_job_arma.mat\n"
          " $shared_dir/Xs_arma.mat \n $shared_dir/idx_perm_arma.mat" << endl<<endl;
      return 1;
  }
  if(argc >= 2){
      input_dir = argv[1]; // Results will be written in input_dir, too.
      shared_dir = "./";
  }
  if(argc >= 3){
      shared_dir = argv[2];
  }
  if(argc >= 4){
      result_fname = argv[3];
  }else{
      result_fname="p_value.txt";
  }
  if(argc >=5){
      nthreads = atoi(argv[4]);
  }else{
      nthreads = logicalcpucount;
  }
  printf("\n The number of threads for OMP is set to %d. \n",nthreads);
  omp_set_num_threads(nthreads);

  arma::mat X; //declaring a matrix armadillo code || Armadillo API
  arma::mat Yv;
  fs::path Xname = "Xs_arma.mat";
  X.load((shared_dir/Xname).string(), raw_ascii);  //load into the variable X
  fs::path cur_dir(fs::current_path());

  fs::path Yname = "Ys_arma.mat";
  Yv.load((input_dir/Yname).string(),raw_ascii); // load into vY

  // Convert into cube
  unsigned int nsubjects = Yv.n_cols;

  cube Y(3,3,nsubjects);

  arma::imat idx_dti;
  fs::path idx_name = "idx_perm_arma.mat";
  idx_dti.load((shared_dir/idx_name).string(), raw_ascii);
  float nperms = idx_dti.n_rows;

  arma::imat mask_job;
  fs::path maskname = "mask_job_arma.mat";
  mask_job.load((input_dir/maskname).string(),raw_ascii);
  unsigned int nvoxels = mask_job.n_rows;
  unsigned int dimX = X.n_rows;
  arma::mat ErrMx1(nvoxels, nperms);
  arma::mat ErrMx2(nvoxels, nperms);

  ErrMx1 = ErrMx1.zeros(); //initialize
  ErrMx2 = ErrMx2.zeros();

//  #pragma omp parallel for shared(ErrMx1, ErrMx2)
//  #pragma omp parallel
//  {   
//      #pragma omp for nowait
//      #pragma omp for
      #pragma omp parallel for
      for(unsigned int ivoxel = 0; ivoxel < nvoxels; ivoxel++){
        getY(Y,Yv,ivoxel);
        //generalize this one
        mmglm_spd_perm(ErrMx1, X.rows(0,dimX-2), Y, idx_dti,ivoxel);
        mmglm_spd_perm(ErrMx2, X, Y, idx_dti,ivoxel);
      }
 // }

  //difference/improvement in the errors
  arma::mat ErrMxfinal = ErrMx1-ErrMx2; 
  //creates a p_value vector of type float for all voxels
  float *p_value=(float*)malloc(nvoxels*sizeof(float));

  unsigned int ivoxel;

  #pragma omp parallel for
  for(ivoxel = 0; ivoxel < nvoxels; ivoxel++){
    unsigned int count=0;
    size_t length=nperms;
    // What's the last element?
    while(--length){
      if(ErrMxfinal(ivoxel,length)>ErrMxfinal(ivoxel,0))
      count++; //find out values greater than ref value
    }
    p_value[ivoxel]= count/nperms; //typecasting
  }

  //Writing the p_value vector to a .txt file. 
  //Alternately armabinascii maybe used
  //Checking if file exists and deletes it

  if( remove( result_fname ) == 0 ) //file exists
    perror( "File existed and has been cleaned up" );
  //handle to the file
  ofstream fout;

  //opening an output stream for file p_value.txt
  fout.open(result_fname.string().c_str()); 
  //checking whether file could be opened or not. 
  //If file does not exist or don't have write permissions, file
  //stream could not be opened.

  if(fout.is_open()){
    for(unsigned int i=0;i<nvoxels-1;i++){
          fout << p_value[i]; //writing ith character of p_value in the file
          fout <<"\n";
    }
    fout << p_value[nvoxels-1]; //To write no unnecessary newline char.
    fout.close();
  }else{
    cout << "File could not be opened. Please try again" << endl;
    return 1;
  }
  cout << "Finished" << endl;
  return 0;
}
