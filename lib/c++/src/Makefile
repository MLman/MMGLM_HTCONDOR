CC= g++
CFLAGS= -Wall -Wextra -Wunreachable-code -static
#-static
#INC_PATH=  -I ../lib/armadillo-7.100.3/include/
INC_PATH=  -I ../lib/armadillo-3.930.2/include/
LIB_PATH=  -llapack -lblas -lpthread -lgfortran  -lboost_system -lboost_filesystem -lquadmath
#LIB_PATH= -DARMA_DONT_USE_WRAPPER 
#lrefblas
all: multithread mmglm show_arma_mx armabin2asciifull armabinequaltotxt
multithread_fast:
	$(CC) -g $(CFLAGS) mmglm_spd_multithread_fast.cpp -o ../bin/mmglm_spd_par_fast -fopenmp -O3 $(LIB_PATH) $(INC_PATH)
multithread:
	$(CC) -g $(CFLAGS) mmglm_spd_multithread.cpp -o ../bin/mmglm_spd_par -fopenmp -O3 $(LIB_PATH) $(INC_PATH)
mmglm:
	$(CC) $(CFLAGS) -O2 mmglm_spd.cpp -o ../bin/mmglm_spd $(INC_PATH) $(LIB_PATH) 
mmglm_tan:
	$(CC) $(CFLAGS) -O2 mmglm_spd_tan.cpp -o ../bin/mmglm_spd_tan $(INC_PATH) $(LIB_PATH) 
mmglmold:
	$(CC) $(CFLAGS) -O2 mmglm_spd.cpp -o ../bin/mmglm_spd -O2 ../lib/liblapack.a ../lib/librefblas.a $(INC_PATH) -lgfortran -lpthread -lboost_system -lboost_filesystem
show_arma_mx:
	$(CC) $(CFLAGS) show_arma_mx.cpp -o ../bin/show_arma_mx -O2  $(INC_PATH) $(LIB_PATH)
armabin2asciifull:
	$(CC) $(CFLAGS) armabin2asciifull.cpp -o ../bin/armabin2asciifull -O2 $(LIB_PATH) $(INC_PATH)
armabinequaltotxt:
	$(CC) $(CFLAGS) armabinequaltotxt.cpp -o ../bin/armabinequaltotxt -O2 $(LIB_PATH) $(INC_PATH)
test:
	$(CC) $(CFLAGS) test.cpp -o test -O2 $(LIB_PATH) $(INC_PATH)
omptest:
	$(CC) $(CFLAGS) omptest.cpp -o omptest -fopenmp -O2 $(LIB_PATH) $(INC_PATH)
clean:
	rm ../bin/*
