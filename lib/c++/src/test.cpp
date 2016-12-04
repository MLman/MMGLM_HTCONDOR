#include <iostream>
#include <armadillo>
using namespace std;

arma::vec foo(){
    arma::vec v(4);
    int i;
    for(i=0;i<4;i++){
        v(i) = i+10;
    }
    return v;
}
int main(){
    arma::vec d(4);
    arma::mat U(5,4);
    int i;
    for(i=0;i<4;i++){
        d(i) = i;
    }
    U.row(0) = d.t();
    arma::vec v;
    v= foo();
    U.print("U:");
    d.print("d:");
    v.print("v:"); 
    U.row(1) =foo().t();
    U.print("U:");
    return 0;

}

