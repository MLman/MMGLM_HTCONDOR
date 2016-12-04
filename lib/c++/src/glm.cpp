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
#include <unistd.h>

// Index of elements in save files
using namespace std;
namespace fs=boost::filesystem; //namespace is being declared

int main(int argc, char** argv)
{
  //creating 3 paths named below
  fs::path input_dir;
  fs::path shared_dir;
  fs::path result_fname;

  printf("################################################\n");
  printf("###                     GLM                  ###\n");
  printf("################################################\n");

  if(argc == 1 || argc >=5){
      cout<<"\n GLM performs general linear models. " <<endl;
      cout<<" P_values are the significance for the last covariate controlling\n";
      cout<<" for all covariates except the _last_ one in \"Xs_arma.mat\"." <<endl<<endl;
      cout<<" Usage: " <<endl;
      cout<<"  >>> glm $input_dir $shared_dir ($result_fname==p_value.txt)" << endl;
      cout<<"  >>> glm $input_dir $shared_dir $result_fname " << endl;
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

  arma::mat X; //declaring a matrix armadillo code || Armadillo API
  arma::mat Yv;
  fs::path Xname = "Xs_arma.mat"; // dim_x x nsubjects
  X.load((shared_dir/Xname).string(), raw_ascii);  //load into the variable X
  fs::path cur_dir(fs::current_path());

  fs::path Yname = "Ys_arma.mat";  //  dim_y x nvoxels
  Yv.load((input_dir/Yname).string(),raw_ascii); // load into vY

  // Convert into cube
  unsigned int nsubjects = Yv.n_cols;
  arma::imat idx_dti;
  fs::path idx_name = "idx_perm_arma.mat";
  idx_dti.load((shared_dir/idx_name).string(), raw_ascii);
  float nperms = idx_dti.n_rows;

  arma::imat mask_job;
  fs::path maskname = "mask_job_arma.mat"; // nvoxels x 3
  mask_job.load((input_dir/maskname).string(),raw_ascii);
  unsigned int nvoxels = mask_job.n_rows;
  unsigned int dimX = X.n_rows;
  unsigned int dimY = Yv.n_rows/nvoxles; // Yv.n_rows / nvoxels 
  
  arma::mat ErrMx1(nvoxels, nperms);
  arma::mat ErrMx2(nvoxels, nperms);

  ErrMx1 = ErrMx1.zeros(); //initialize
  ErrMx2 = ErrMx2.zeros();

  //creates a p_value vector of type float for all voxels
  float *p_value=(float*)malloc(nvoxels*sizeof(float));

  for(unsigned int ivoxel = 0; ivoxel < nvoxels; ivoxel++){
  	getY(Y,Yv,ivoxel);
    //generalize this one
    p_value[ivoxel]=mmglm_spd_perm_tan(X, Y, idx_dti, th);
  }

  //Writing the p_value vector to a .txt file. 
  //Alternately armabinascii maybe used
  //Checking if file exists and deletes it

  if( remove( result_fname ) == 1 ) //file exists
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
